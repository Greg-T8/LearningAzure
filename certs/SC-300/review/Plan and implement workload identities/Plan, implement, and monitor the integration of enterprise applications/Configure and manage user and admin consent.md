### **SC-300 Study Review Sheet: Configure and Manage User and Admin Consent**

#### **1. Permission Types and Technical Identifiers**

* **Delegated Permissions**
  * **Definition:** Allows an application to act restricted to the data the user is already authorized to access.
  * **Prompt Identifier:** The permission description ends with **"on behalf of the signed-in user"**.
  * **Approval Authority:** Can often be granted by end-users (if classified as low impact) or by a Cloud Application Administrator for tenant-wide consent.
* **Application Permissions (App Roles)**
  * **Definition:** Allows an application to access data directly as a background service or daemon, independent of a specific user's presence.
  * **Prompt Identifier:** The permission description ends with **"without a signed-in user"**.
  * **Risk Profile:** Considered a highly sensitive operation allowing access to data across the entire organization.
  * **Common Microsoft Graph App Role Examples:** `Directory.Read.All`, `User.Read.All`, `Group.Read.All`, `Application.ReadWrite.All`, `Policy.ReadWrite.ConditionalAccess`, and `AppRoleAssignment.ReadWrite.All`.

**Comparison Table: Permission Types**

| Feature | Delegated Permissions | Application Permissions (App Roles) |
| :--- | :--- | :--- |
| **Description Phrase** | "on behalf of the signed-in user" | "without a signed-in user" |
| **Access Scope** | Limited to the signed-in user's rights | Organization-wide background access |
| **Admin Required?** | Only if high-impact or policy dictates | **Always** requires administrator approval |
| **Graph API Approver** | Cloud Application Administrator | **Global Administrator** or Privileged Role Admin |

#### **2. Administrative Roles and Authority Boundaries**

* **Global Administrator Requirements**
  * **Workflow Configuration:** Must be a Global Administrator to initially turn on the admin consent workflow or modify its core parameters (reviewers, expiration timers, notifications).
  * **Microsoft Graph Consent:** Only Global Administrators (or Privileged Role Administrators) have the technical authority to approve requests for **Microsoft Graph app roles**.
* **Cloud Application Administrator / Application Administrator**
  * **Scope of Authority:** Can manage applications and grant tenant-wide admin consent for **any delegated permission** (including Microsoft Graph) and **application permissions for non-Graph APIs**.
  * **Policy Engine:** Their authority is defined by the built-in `microsoft-application-admin` policy.
* **Application Owners vs. Custom Roles**
  * **Principle of Least Privilege:** Do not use the "Owner" role solely for application credential rotation. Owners can manage single sign-on (SSO), provisioning, user assignments, and impersonate the app.
  * **Custom Roles:** Create a custom role to grant only the specific permissions needed to rotate secrets or certificates.

* **⚠️ EXAM TRAP:** Do not confuse workflow roles with technical RBAC roles. Designating a user as a "Reviewer" in the workflow **does not elevate their technical privileges**. A reviewer can block or deny requests, but they must natively hold an RBAC role like Global Admin to select "Approve" for Graph App roles.

#### **3. Configuring User Consent**

* **Low Impact Permission Classifications**
  * **Configuration Order:** You must first categorize specific delegated permissions (e.g., `openid`, `User.Read`) into the **"Low" impact** category via the "Permission classifications" tab.
  * **Policy Dependency:** Once classified, you can enable the tenant policy to *"Allow user consent for apps from verified publishers, for selected permissions"*.
  * **Verified Publishers:** Microsoft vets these publishers to protect against "consent phishing".
* **Persistence of Existing User Consent Grants**
  * **Forward-Looking Policy:** Updating the tenant setting to **"Do not allow user consent"** only affects future consent operations.
  * **Continued Access:** Users will continue to sign in to applications they already consented to.
  * **Revocation Process:** To remove existing access, an administrator must manually review and revoke permissions via PowerShell or the Microsoft Graph API; bulk revocation is not supported in the portal.

#### **4. Admin Consent Workflow Mechanics**

* **Static Assignment Logic & Reviewer Propagation**
  * **Point-in-Time Stamping:** When a user requests consent, the request is stamped with the *current* list of reviewers.
  * **New Reviewers:** If you add a new reviewer, they cannot see the backlog of existing requests. They only see requests created **after** they are added (which takes up to one hour to propagate).
  * **Removed Reviewers:** A reviewer removed from the list **retains access and receives email notifications** for the older requests generated during their tenure.
* **Communication, Notifications, & Silent Consequences**
  * **Mandatory Justifications:** Administrators must enter a justification text when selecting **Deny** or **Block**. This text is emailed directly to the requester.
  * **The "Silent" Consequence:** If the global setting *"Selected users will receive email notifications for requests"* is disabled, it disables emails for reviewers **and** requesters. Requesters will not know if their request was submitted, approved, denied, or expired.
* **De-duplication & Queue Entries**
  * **Identical Clicks:** If a user clicks "Request approval" 5 times for the same app, the system's de-duplication logic ensures **only the first request** is submitted to the admin.
  * **Static vs. Dynamic Consent:** If an application requests baseline permissions (static) and later requests optional feature permissions (dynamic/incremental), it will generate **two separate entries** in the reviewer's queue for that single application.
* **Lifecycle Timers**
  * **Expiration:** Requests typically expire after a maximum of **30 days** (as shown in standard configurations).
  * **Reminders:** The first "about-to-expire" reminder is sent at the midway point (e.g., day 15).

**Comparison Table: Workflow Actions**

| Action | Technical Result | User Experience |
| :--- | :--- | :--- |
| **Approve** | Tenant-wide consent granted for requested scopes | User signs in seamlessly |
| **Deny** | Request rejected | Emailed justification; user **can request again** later |
| **Block** | Creates a **disabled service principal** object | Emailed justification; user is **permanently prevented** from requesting again |

#### **5. Application Assignments and Portal Visibility**

* **"Assignment Required" Property**
  * **Configuration Detail:** If an enterprise application has **"Assignment required?"** set to **Yes**, individual user consent is automatically disabled.
  * **Result:** An administrator must grant tenant-wide admin consent, forcing centralized review.
* **PowerShell Assignments**
  * **Consent vs. Assignment:** Granting permissions authorizes data access, but **assignment** triggers portal visibility.
  * **Correct Cmdlet:** Use `New-MgServicePrincipalAppRoleAssignedTo` to assign a user to an app, ensuring the application tile appears in the user's **My Apps portal**. (Granting permission alone does not make the tile visible).
* **Troubleshooting Persistent Prompts**
  * **Scenario:** An administrator grants tenant-wide consent, but users are prompted again a week later.
  * **Causes:** The developer updated the app to require new permissions, the app uses dynamic/incremental consent for new features, or a previous permission was revoked. Admin consent is static to the exact scopes requested at the time of approval.

#### **6. Auditing, Error Codes, and Governance Tools**

* **Audit Log Technical Classifications**
  * **ApplicationManagement:** Used for events involving the application entity itself. For example, if risk-based step-up consent detects a malicious request, it is logged under `ApplicationManagement` with the activity **"Consent to application"** and reason **"Risky application detected"**.
  * **UserManagement:** Used for workflow configuration changes. Turning the workflow on or changing its settings is logged under the "Access Reviews" service with the precise technical activity name **"Update governance policy template"**.
* **Consent Error Codes**
  * **AADSTS90094:** Triggered by **risk-based step-up consent** detecting a risky app (e.g., unverified multitenant app) while the admin consent workflow is disabled.
  * **AADSTS90093:** Triggered when a **tenant-wide administrative policy** strictly forbids the user from granting the requested permissions.
* **Consent Insights Workbook**
  * **Prerequisites:** Requires **Microsoft Entra ID P1 or P2** and a Log Analytics workspace.
  * **Functionality:** Aggregates logs to identify high-demand applications causing failed or blocked consent attempts, allowing admins to proactively grant tenant-wide consent and reduce support tickets.

* **⚠️ EXAM TRAP:** Do not look for "Configure consent settings" in the audit logs when troubleshooting who changed the workflow reviewers. The system engine views the workflow as a policy template, logging it strictly as `"Update governance policy template"`.
