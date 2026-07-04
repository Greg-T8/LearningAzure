### **I. Prerequisites, Licensing, & Role Configurations**

* **Licensing Requirements:**
  * Requires **Microsoft Entra ID Governance**, **Microsoft Entra ID P2**, or the **Microsoft Entra Suite**.
  * Every internal user making a request requires a license.
  * External guests submitting requests are governed via the **Monthly Active User (MAU)** Azure subscription billing.
* **Administrative Delegation:**
  * **Catalog Owner:** Can view all access package requests within their container, reprocess stalled requests, and directly push/remove assignments.
  * **Identity Governance Administrator:** Tenant-wide authority to manage requests and bypass standard portal workflows.

---

### **II. The Requestor Experience & Data Collection**

* **The My Access Portal:** The central, unified storefront where users request access to cloud groups, apps, SharePoint sites, and even legacy on-premises applications (via Microsoft Entra Private Access).
* **Terms of Use (ToU) Agreement:**
  * Operates on a "proactive governance" model.
  * If a policy mandates a ToU agreement, the user is required to accept the terms **during the initial request submission** in the portal, long before the request reaches a human approver.
* **Information Collection (Attributes vs. Questions):**
  * **Custom Questions:** Data is stored solely on the specific request object. Visited by approvers to justify the request. Works for all user identity types.
  * **Specify Attributes:** Data is written **directly and permanently into the requestor's Microsoft Entra User object** (e.g., country code, phone number).
* **The Synchronized User Constraint:**
  * The "Specify attributes" feature is **strictly limited to cloud-only users**.
  * For users synchronized from on-premises AD, Entra ID is not the "Source of Authority". Attempting to write an attribute to a synced user will fail because their cloud profile is read-only.
  * Even if forced, the data would be overwritten/deleted during the next Entra Connect sync cycle.

> **🚨 EXAM TRAP:** If a scenario states that synchronized Active Directory users are receiving errors when trying to submit an access request, look for "Specify attributes" in the policy. To fix the issue, you must switch the collection method to "Custom questions".

**Table 1: Request Data Collection Methods**

| Feature | Data Storage Location | Works for AD-Synchronized Users? |
| :--- | :--- | :--- |
| **Custom Questions** | Stored on the **request object**. | **Yes**. |
| **Specify Attributes** | Written to the **User object profile**. | **No** (Cloud is read-only for these users). |

---

### **III. Request Visibility & Privacy Limitations**

Entitlement management enforces strict role-based access to request data to ensure privacy.

* **The Requestor:** Can view their own pending/past requests via the **"Request history"** tab in the My Access portal.
* **The Approver:** Can view requests awaiting their decision in the **"Approvals"** tab.
* **Catalog Owner:** Can view all requests within their delegated catalog via the Entra admin center.

> **🚨 EXAM TRAP:** Owning a resource (e.g., being a SharePoint Site Administrator or an M365 Group Owner) does **NOT** grant visibility into the access requests for that resource. If a Resource Owner is not explicitly named as a designated approver in the policy, they have zero visibility into the My Access portal's request queue.

---

### **IV. Microsoft Graph API & Request Scopes**

When managing request policies and executing requests programmatically, specific properties must be mapped accurately.

* **Defining the Requestor Scope (`scopeType`):**
  * To allow a specific list of individuals or groups to request an access package, configure the policy's `scopeType` as **`SpecificDirectorySubjects`**.
  * You must then define those specific user Object IDs in the **`allowedRequestors`** array (e.g., `@odata.type: #microsoft.graph.singleUser`).
* **Direct Assignment (Bypassing Requests):**
  * To disable self-service, set the UI to "None (administrator direct assignments only)". In the API, this corresponds to setting `allowedTargetScope` to `notSpecified`.
  * **Visibility Impact:** Direct Assignment policies actively **hide the package** from the "Available" tab in the My Access portal.
* **Executing Requests (`requestType`):**
  * **`UserAdd`:** The mandatory value used when an **end-user initiates a self-service request** (both for first-time assignments and extensions).
  * **`AdminAdd`:** Used when an administrator bypasses the portal to push a direct assignment to a user, or when adding a catalog resource.

**🛠️ TROUBLESHOOTING SCENARIO:**

* **Issue:** An employee uses a provided PowerShell script (`New-MgBetaEntitlementManagementAccessPackageAssignmentRequest`) to renew their access but receives an "Unauthorized" error.
* **Root Cause:** The script payload contains `-RequestType 'AdminAdd'`, which requires administrative directory roles the end-user lacks.
* **Fix:** Change the parameter to `-RequestType 'UserAdd'` to signal the API that this is a self-service request subject to the standard policy approval workflow.

---

### **V. Multi-Stage Approvals & Escalation Guardrails**

* **Linear Architecture:** Multi-stage approvals (maximum of **three stages**) operate sequentially. Stage 2 approvers are **never notified** until Stage 1 is fully approved.
* **The "At Least One" Rule:** If a stage features multiple approvers (e.g., five "Project Leads"), the **first person to click Approve** satisfies the requirement for the entire stage, advancing the request.
* **Fail-Fast Mechanism:** If an approver at **any stage** clicks "Deny", the entire process terminates immediately. No further stages are triggered.
* **Escalation (Alternate) Approvers:**
  * **Half-Life Reminder:** System sends an automated reminder to the primary approver halfway through the designated approval timeframe.
  * **Escalation Event:** If the primary deadline expires, the request is actively **forwarded** to the alternate approvers.
  * **Shared Authority:** Once escalated, **BOTH** the primary and alternate approvers have concurrent authority to act; the first to decide satisfies the stage.

---

### **VI. Request Timeouts and Terminal States**

Entitlement management differentiates between human process failures and technical provisioning failures.

* **Expired (Human Failure):**
  * Occurs when neither primary nor escalation approvers respond before the final deadline.
  * The request is permanently locked; it cannot be "un-expired" or overridden by an administrator.
  * No resources are provisioned. The user **must resubmit** a brand new request.
* **Assignment Failed (Technical Failure):**
  * Occurs during the technical fulfillment phase, specifically when a custom extension (like a Logic App triggering a ServiceNow ticket) uses "Launch and wait".
  * **14-Day Timeout:** If the external system fails to send a "resume" API signal back to Entra ID within 14 days, the assignment fails.
* **Denied:** An active rejection by a human approver.

**Table 2: Request Lifecycle Terminal States**

| State | Trigger Cause | Lifecycle Phase |
| :--- | :--- | :--- |
| **Denied** | A human approver **actively clicked "Deny"**. | Request / Approval Phase |
| **Expired** | The **approval timeout** was reached with zero human action. | Request / Approval Phase |
| **Assignment failed** | A **technical extension** (ServiceNow) did not send a resume signal. | Delivering / Fulfillment Phase |

---

### **VII. Technical Fulfillment: The "Delivering" State**

The "Delivering" state is a technical transition zone indicating approval is finished, but provisioning is not yet complete.

* **Internal Users:** The system is generating **`AppRoleAssignment`** objects and linking the user to specific resource roles.
* **External Users (The Consent Hurdle):**
  * For B2B guests, "Delivering" means the guest account has been created, but the user has **not yet accepted the initial consent prompt** for your directory.
  * **Action Required:** An administrator cannot "force" a request past this state. The guest must navigate to their email, open the portal, and accept the terms.
  * Only after consent is recorded does the state transition to "Delivered".

**Table 3: Delivery Status Breakdown**

| State | Definition | Key Requirement |
| :--- | :--- | :--- |
| **Approved** | Human decision made; no technical action yet. | Approver clicked "Approve". |
| **Delivering** | Account created; waiting for user action or backend sync. | **Waiting for external user consent**. |
| **Delivered** | User has full access to all package resources. | Consent prompt accepted / groups synced. |
| **Partially Delivered** | Access granted to some, but not all resources. | A specific resource role encountered an error. |

---

### **VIII. Managing Access Extensions (Zero Trust)**

All request-based assignments are inherently time-bound and must be continually governed.

* **Proactive Workflow:** Users receive automated warnings prior to expiration. They must submit an **Extension Request** via the portal before the deadline hits.
* **Governance Logic (New Request):** An extension is **not a guaranteed renewal**. The system treats it as a **new request** that typically triggers a completely new cycle of human justification and approval.
* **Transition Paths:**
  * *Approved:* Logs record **"Access extended"**; `AppRoleAssignments` remain intact without interruption.
  * *Denied/Ignored:* Status changes to **"Access expired"**; the system automatically and instantly deletes all `AppRoleAssignments`, immediately revoking sign-in rights.

**Table 4: Extension vs. Re-Requesting**

| Feature | Extension Request | Re-Requesting (New Request) |
| :--- | :--- | :--- |
| **Timing** | Submitted **before** access expires. | Submitted **after** access has expired. |
| **User Experience** | Seamless; access continues uninterrupted. | Disruptive; access is lost until fulfilled. |
| **Trigger Mechanism** | Triggered by an automated system reminder. | Triggered by user discovering a loss of access. |
