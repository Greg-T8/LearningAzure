### **I. Prerequisites and Licensing for Access Packages**

* **Mandatory Licensing Configurations:**
  * To configure access packages, the tenant must have **Microsoft Entra ID Governance**, **Microsoft Entra ID P2**, **EMS E5**, or the **Microsoft Entra Suite**.
  * **Internal Identities:** A per-user license is required for every internal employee who requests, approves, or reviews an access package.
  * **External Identities:** B2B Guests are governed via an Azure subscription linked for **Monthly Active User (MAU)** billing.
* **Capacity Guardrails:**
  * A single user can be governed across a maximum of **1500 applications** via entitlement management.

> **🚨 EXAM TRAP:** Basic Entra ID P1 does not cover the creation of access packages. If a scenario involves users requesting packages, ensure P2 or Governance licenses are explicitly mentioned.

**🛠️ TROUBLESHOOTING SCENARIO:**

* **Issue:** A Global Administrator navigates to "Identity Governance" -> "Access Packages" and receives an **"Access denied"** error.
* **Root Cause:** The tenant lacks the premium governance engine (P2 or ID Governance license). This error does not indicate a lack of administrative RBAC permissions; it indicates the service is inactive.
* **Fix:** Purchase and assign the appropriate Entra ID Governance or P2 licenses.

---

### **II. Access Package Architecture & Resource Bundling**

* **Core Function:** Access packages bundle resources so users request unified access (e.g., a SharePoint site, an enterprise app, and a Teams group) in a single transaction.
* **Supported Resource Types:**
  * Microsoft Entra security groups and M365 Groups/Teams.
  * Enterprise applications (SaaS/custom).
  * SharePoint Online sites.
  * **SAP IAG business roles**.
    * *Prerequisite:* Requires the Entra SAP IAG integration, mapping the `userUuid` attribute so both systems have identical user lists.
* **Automated Fulfillment Objects (`AppRoleAssignment`):**
  * When an access package containing applications is approved, Entitlement Management automatically generates an **`AppRoleAssignment`** instance for *each* application in the background.
  * This is the technical "glue" granting sign-in rights.
  * When the package expires or is revoked, Entitlement Management **automatically deletes** these instances.
* **Bridging Legacy On-Premises Authentication:**
  * Legacy apps require hardcoded SIDs (Security Identifiers) via Kerberos.
  * **Configuration:** Create a cloud group, bundle it in an access package, and use **Group Writeback** (Cloud Sync) to sync it to AD.
  * **Nesting:** Nest this synchronized group as a *child* of the legacy AD group.
  * **Result:** The user's Kerberos token will contain the parent's expected SID, bridging cloud governance with legacy technical requirements.

**Table 1: AI Agent Identity Constraints (Preview)**

| Resource Type | Permitted for AI Agents? | Configuration Notes |
| :--- | :--- | :--- |
| **Security Groups** | **Yes** | Standard group-based authorization. |
| **Directory Roles** | **Yes** | e.g., User Administrator. |
| **API Permissions (OAuth)** | **Yes** | Required for Graph API interactions. |
| **SharePoint Online Sites** | **No** | Strictly prohibited. |
| **Application Roles** | **No** | Standard Enterprise App roles prohibited. |
| **SAP Business Roles** | **No** | Strictly prohibited. |

> **🚨 EXAM TRAP:** Every AI agent access package **must** have a human **Sponsor**. If the sponsor leaves the organization, stewardship automatically transfers to their manager. It never remains "headless".

---

### **III. Access Package Policies: Request vs. Automatic**

* **Request Policies (Manual / Self-Service):**
  * An access package can have **multiple** request policies attached to it simultaneously (e.g., Policy A for Marketing, Policy B for external vendors).
  * **The "None" Policy:** Selecting "None (Administrator direct assignments only)" blocks self-service entirely. Users cannot browse or search for this package in the My Access portal. Used for system migrations or baseline access.
* **Automatic Assignment Policies:**
  * Driven by Entra ID user attributes (e.g., `user.department -eq "Marketing"`).
  * **STRICT LIMIT:** An access package can have **AT MOST ONE** automatic assignment policy.
  * **Configuration Workaround:** If you need to automate access for two distinct sets of users (e.g., Marketing and Seattle users), you must consolidate the logic using an **OR** statement within the single policy, or create two entirely separate access packages.
* **External User Policy Scopes:**
  * **Specific connected organizations:** Restricts to explicit partners.
  * **All configured connected organizations:** Allows any pre-approved partner domain in the tenant's registry.
  * **All users:** Allows any external domain. Approval triggers the creation of a "proposed connected organization".

---

### **IV. Discovery & My Access Portal Visibility Logic**

The My Access portal ("Available" tab) enforces a strict 4-step sequence to determine if a user can discover an access package:

1. **Catalog Enabled:** If the parent catalog is disabled, all underlying packages are hidden.
2. **External Enablement:** For guests, the catalog must specifically have "Enabled for external users" set to Yes.
3. **Hidden Toggle:** The package property `Hidden` must be set to "No". (Note: "Hidden: Yes" overrides permissive policies, but direct links still work).
4. **Crucial Policy Check:** The system checks for at least one enabled policy where the "Who can request" setting logically matches the user. (Policies set to "None" fail this check automatically).

**💡 SCENARIO EXAMPLE:**
An external consultant from `fabrikam.com` visits the My Access portal. `fabrikam.com` is configured as a Connected Organization. The Access Package is set to "Visible", and the policy allows "All configured connected organizations". However, the consultant sees nothing.
**Resolution:** The parent Catalog's setting for "Enabled for external users" is toggled to "No". This acts as an absolute gateway block, hiding everything inside it from external identities.

> **🚨 EXAM TRAP:** The first time a guest accesses the portal, the system **"stamps" their preferred language** based on browser settings, ensuring all future lifecycle emails match their language.

---

### **V. Separation of Duties (SoD) & Incompatible Packages**

* **Function:** Prevents users from acquiring conflicting access rights (e.g., holding both "Financial Auditor" and "Accounts Payable").
* **Configuration Constraints:**
  * **Incompatible Packages:** If User holds Package A, the portal actively blocks or hides requests for Package B.
  * **Incompatible Groups:** Prevents requesting a package if the user is already a member of a specific Entra security group.
  * **Bidirectional Best Practice:** For full enforcement, configure the relationship on **both** packages (A blocks B, and B blocks A).
* **Override Strategy:**
  * If a business exception is required, administrators create a separate "Override" access package containing the conflicting resources, but assign a higher-tier approval policy (e.g., Risk Officer).

---

### **VI. Multi-Stage Approval & Escalation Guardrails**

* **Fail-Fast Rule:** If any approver at any stage clicks "Deny", the entire request immediately terminates.
* **Escalation (Alternate) Approvers:**
  * Configured as a safety net if a primary approver ignores the request.
  * **Timers:**
    * **Half-Life Reminder:** Sent to the primary approver halfway through the designated timeframe.
    * **Escalation Trigger:** Forwarded to the alternate approvers if the primary deadline expires.
  * **Concurrent Rights:** Once escalated, **BOTH** primary and alternate approvers retain the right to act. The first to click approve/deny completes the stage.

**Table 2: Terminal Approval States**

| State | Trigger Cause | Resulting Action |
| :--- | :--- | :--- |
| **Denied** | Active rejection by a human approver. | Request terminates; user notified. |
| **Escalated** | Primary approver did not respond in time. | **Forwarded to alternate approvers**. |
| **Expired** | Hard deadline reached; no escalation configured. | Request automatically denied; user must submit a completely new request. |

---

### **VII. Time-Bound Lifecycle & External Guest Cleanup**

* **Expiration Settings:**
  * Must be defined by **number of days**, **number of hours**, or a **fixed date**.
* **Extensions vs. Re-Requesting:**
  * Users receive warnings before expiration and must submit an **Extension Request** via the portal *before* the deadline.
  * Extensions act as net-new requests, typically triggering a re-approval cycle.
* **Access Reviews:**
  * Overlaying recurring access reviews allows managers to attest to long-term access.
  * **Priority:** If a reviewer selects "Deny" during an access review, the assignment is **revoked immediately**, overriding any remaining time on the package's expiration clock.
* **B2B Guest Offboarding Automation:**
  * **Trigger:** Evaluated when a guest suffers the **"Loss of Last Assignment"** (they no longer hold any active access packages).
  * **Actions:** The system automatically executes a **"Block user from signing in"** command, or permanently **"Removes the user"** (deletes the B2B guest account) to maintain Zero Trust directory hygiene.

---

### **VIII. Custom Extensibility (Azure Logic Apps)**

* **Triggers:** Custom extensions fire at four specific stages: Request is created, Request is approved, Assignment is granted, **Assignment is removed**.
* **The "Assignment is removed" Best Practice:**
  * Used to maintain visibility by sending an automated notification to a Microsoft Teams channel, alerting staff that a contractor's access has ended.
* **Execution Behaviors:**
  * **Launch and Continue:** Triggers Logic App; Entra ID continues provisioning/deprovisioning immediately. (Ideal for Teams notifications).
  * **Launch and Wait:**
    * **Pauses** the Entra ID workflow completely. The process enters a **"Waiting for information"** state.
    * Waits for a Microsoft Graph **Resume API** signal from the external system (e.g., ServiceNow ticket closure).
    * **Timeout:** Hardcoded timeout of **14 days**. If no resume signal is received, the package assignment results in "Assignment failed".

---

### **IX. Graph API and PowerShell Technical Mechanics**

* **Module Requirement:**
  * Any cmdlet managing access packages with "Beta" in the name (e.g., `New-MgBetaEntitlementManagementAccessPackage`) strictly requires the **`Microsoft.Graph.Beta`** module. The standard `Microsoft.Graph.Identity.Governance` module only contains v1.0 cmdlets.
* **OriginSystem (Type Discrimination):**
  * When adding a resource to a catalog via the API, you must explicitly declare the `originSystem`.
  * **AadGroup:** For Security/M365 groups.
  * **AadApplication:** For Enterprise Apps.
  * If you supply a Group ID but set `originSystem` to 'AadApplication', the request fails with an "identity not found" schema mismatch error.
* **Catalog Resource ID vs. Origin ID:**
  * **Origin ID:** The standard Entra Object ID (e93e24d1...). Used to *add* the resource to a catalog.
  * **Catalog Resource ID:** A unique GUID generated *after* the resource is inside the catalog (4a1e21c5...).
  * You **MUST** use the Catalog Resource ID when linking a resource role to an access package via the `accessPackageResourceRoleScopes` API endpoint.

**🛠️ TROUBLESHOOTING SCENARIO:**

* **Issue:** Administrator tries to add the "Member" role of an M365 group to an access package via Graph API and receives an error.
* **Root Cause:** They are putting the standard Entra Object ID in the payload.
* **Fix:** Query the `resourceRequests` response to retrieve the catalog-specific **Catalog Resource ID**, and use that GUID in the `accessPackageResourceRoleScopes` request body instead.
