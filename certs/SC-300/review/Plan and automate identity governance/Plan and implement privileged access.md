### **1. Emergency Access ("Break-Glass") Architecture & Configuration**

* **Core Architectural Prerequisites:**
  * Must create exactly **two** emergency accounts.
  * Must be permanently assigned the **Global Administrator** role.
  * Must absolutely be **cloud-only accounts** (no on-premises Active Directory or AD FS ties).
  * Must never be assigned to a specific individual human.
  * Must never be linked to a personal email address (e.g., Gmail, Outlook.com) for external recovery due to phishing risks; must use a dedicated corporate mailbox.
* **Conditional Access Configuration Details:**
  * You **must explicitly exclude** these accounts from all Conditional Access policies (including MFA and location restrictions).
  * *Scenario Example:* An administrator misconfigures a CA policy requiring MFA for all admins, but the third-party MFA provider goes offline. If the break-glass accounts were not explicitly excluded, the entire tenant would be permanently locked out.
* **PIM Configuration & Exceptions:**
  * Break-glass accounts are the strict exception to the Just-In-Time (JIT) access rule.
  * They require **active, permanent role assignments**.
  * *Exam Trap:* Do not make these accounts "eligible" via PIM. If they required an approval or MFA prompt to activate, they would be useless during the exact outage they are meant to bypass.
  * *Failsafe Mechanism:* Microsoft Entra ID intentionally prevents the removal of the last active role assignment for the Global Administrator role to prevent accidental tenant lockouts.
* **Monitoring, Auditing, and KQL Details:**
  * Baseline expectation: **Absolute zero sign-in activity**.
  * Any activity must trigger an immediate **high-priority alert**.
  * *KQL Configuration:* `SigninLogs | where UserPrincipalName in ('admin1@...', 'admin2@...')`.
  * *Broader Auditing:* Monitor the `AuditLogs` for password changes, permission/role changes, and any modifications to their authentication credentials.

### **2. Privileged Identity Management (PIM) Automation & API Mechanics**

* **The MS-PIM Automation Engine:**
  * PIM operates via a dedicated internal service principal named **MS-PIM**.
  * *Prerequisite Permissions:* To onboard an Azure resource into PIM (clicking "Manage resource"), the administrator must hold either the **Owner** or **User Access Administrator** role directly on that specific resource.
  * *Configuration Detail:* Upon onboarding, MS-PIM is automatically assigned the **User Access Administrator** role at the scope of the Management Group or Subscription to enforce access.
* **Troubleshooting MS-PIM Errors:**
  * *Scenario Example:* An administrator suddenly receives "access denied" or authorization errors when attempting to make eligible assignments in PIM.
  * *Resolution:* The MS-PIM service principal likely had its User Access Administrator assignment accidentally deleted from the resource's IAM blade. Manually re-assign the role to the MS-PIM identity to fix the pipeline.
  * *Exam Trap:* Once a Management Group or Subscription is onboarded into PIM, **it cannot be unmanaged** (to prevent rogue admins from bypassing governance).
* **Discovery and Insights (Eliminating Standing Access):**
  * Replaces the legacy "Security Wizard".
  * Discovers users and **service principals** (applications) with permanent privileged access.
  * *Configuration Limitations:* You can make human users "eligible," but you **cannot** make service principals eligible (they can only be removed).
  * *Exam Trap:* Do not make personal Microsoft accounts (e.g., Skype, Xbox) eligible. MFA activation prompts will lock them out. Do not make your break-glass accounts eligible.

**Comparison Table: PIM API Boundary Architecture**

| API Feature | Microsoft Entra Roles & PIM for Groups | Azure Resource Roles (ARM) |
| :--- | :--- | :--- |
| **API Endpoint** | Microsoft Graph API (`graph.microsoft.com`) | Azure Resource Manager API (`management.azure.com`) |
| **Required Permissions** | Microsoft Graph Permissions | Azure RBAC: Owner or User Access Administrator |
| **Current API Version** | Iteration 3: `/roleManagement/directory/roleAssignmentApprovals` | ARM REST API Framework |
| **Deprecated Version** | Iteration 2: `/beta/privilegedAccess` (Stops Oct 2026) | Iteration 2: `/beta/privilegedAccess` (Stops Oct 2026) |
| **Approval HTTP Method** | `PATCH` to the specific `<step-id>` [Chat History, 62] | `PATCH` to ARM endpoint [33, Chat History] |
| **Extend/Renew via API** | Currently **Not Supported** | Currently **Not Supported** |

### **3. PIM for Groups & Role-Assignable Constraints**

* **Role-Assignable Group Architecture:**
  * *Prerequisite:* To assign Entra directory roles to a group, the group must be explicitly created as **"role-assignable"**.
  * *Administrative Boundaries:* Only a Global Admin, Privileged Role Admin, or the Group Owner can manage these groups. Lower-level admins (like Helpdesk) are blocked from resetting passwords of members inside these groups.
  * *Tenant Limits:* Hardcoded maximum of **500 role-assignable groups** per tenant. Standard non-role-assignable groups do not count toward this PIM limit.
* **Configuration Limitations & Exam Traps:**
  * *Group Nesting Trap:* Role-assignable groups **cannot have other groups actively nested inside them**. However, one group *can* be an *eligible* member of another group via PIM.
  * *Incompatible Groups Trap:* **Dynamic membership groups** and **on-premises synchronized groups** are strictly blocked from PIM for Groups. They must be cloud-only, assigned-membership groups.
  * *Application Delay Trap:* Do not use PIM for Groups for Microsoft Purview, Exchange, or SharePoint administrator portals; use standard PIM for Entra roles to avoid significant activation delays.
* **SCIM Provisioning via PIM:**
  * *Configuration Detail:* Activating a group via PIM expedites SCIM provisioning to **2 to 10 minutes** (bypassing the standard 40-minute cycle).
  * *Throttling Trap:* Hard throttle of **5 users per 10-second window**. User #6 is delayed to the standard 40-minute cycle.
  * *Scenario Example (Dual Groups):* Create a baseline "All Users" group for permanent account provisioning, and a separate "PIM Privileged" group for eligible role elevation. This reduces SCIM engine load during emergencies.
* **Troubleshooting: The Last Owner Failsafe Loop:**
  * *Scenario Example:* Group has 1 active owner (User A) and 1 eligible owner (User B). User B activates. User A is deleted. User B's activation expires.
  * *System Behavior:* Entra prevents removing the last active owner. PIM attempts to deactivate User B, fails, and enters a **30-day retry loop**.
  * *Troubleshooting Fix:* An administrator must manually add a new active owner to the group. Once added, PIM safely demotes User B. If left unfixed for 30 days, User B remains a permanent active owner.
* **Microsoft Graph PowerShell Configuration:**
  * `New-MgIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest` = Creates an **eligible** (JIT) assignment.
  * `New-MgIdentityGovernancePrivilegedAccessGroupAssignmentScheduleRequest` = Creates an **active** (immediate) assignment.

### **4. PIM Scoping, Approvals, and Inheritance Mechanics**

* **Role Setting (Policy) Boundaries:**
  * *Configuration Detail:* PIM role settings are strictly defined **per role and per resource**.
  * *Inheritance Trap:* Azure RBAC *assignments* inherit downwards, but PIM *role settings* **do not inherit**.
  * *Scenario Example:* You require MFA to activate the "Owner" role at the Management Group level. A user attempts to activate the "Owner" role explicitly at a child Subscription level. The user will bypass the MFA requirement unless you also configured the PIM settings independently on that child Subscription.
* **Approval Workflow Details:**
  * *Notification Routing:* Pending requests strictly route to designated delegated approvers. Global Admins/Privileged Role Admins receive an *after-the-fact* notification once the role is successfully activated.
  * *Fallback Exception:* For Entra roles, if no approver is selected, GAs/PRAs become default approvers. For Azure Resources/Groups, there is no default; an approver must be manually selected.
  * *The "First to Click" Rule:* Does not require consensus. The first approver to respond resolves the request.
* **Approval Limitations & Exam Traps:**
  * *The 24-Hour Trap:* Delegated approvers have a hardcoded, unconfigurable **24-hour limit** to respond. If missed, the request drops.
  * *Self-Approval Trap:* An approver **cannot approve their own request**. Service principals cannot approve requests.
  * *ITSM Validation Trap:* Requiring a ticket number is an **information-only field**. PIM does not natively validate the ticket against ServiceNow/Jira.

**Comparison Table: Assignment Lifecycles (Extend vs. Renew)**

| Feature | Request to Extend | Request to Renew |
| :--- | :--- | :--- |
| **Current Status of Role** | Currently Active or Eligible | Already Expired (No Access) |
| **Time Window** | Within the final **14 days** of expiration | Up to **30 days** after expiration |
| **Requires Admin Approval?** | Yes | Yes |
| **Admin Configuration Steps** | Set new end date + justification | Set new start date, end date, type (Eligible/Active), + justification |
| **Proactive Admin Bypass** | Admins can extend on user's behalf (No approval workflow needed) | Admins can renew on user's behalf (No approval workflow needed) |
| **Inherited Group Limitations** | Cannot extend inherited group assignments | Cannot renew inherited group assignments |

### **5. PIM Auditing, Governance Alerts, and Log Analysis**

* **Navigating Audit Logs:**
  * *Resource Audit vs. My Audit:* `My Audit` only shows personal activity. `Resource audit` shows tenant-wide activity for that specific resource.
  * *Location Trap:* Azure Resource role audits are completely separated from Microsoft Entra role audits in the portal UI.
  * *Retention Limit:* PIM natively stores history for exactly **30 days** (must route to Log Analytics for longer retention).
* **Identifying the Approver vs. Requester:**
  * *Approver Location:* Look at the **Initiated by (actor)** column on the "Add member to role request approved" event.
  * *Requester Location:* Look at the **Targets** tab on that same event, or the actor column on the preceding "Add member to role completed" event.
  * *Business Justifications:* Permanently captured in the logs for both the requester (why they need it) and the approver (why they allowed it).
* **PIM Bypass Threat Hunting:**
  * *Scenario Example:* A Global Administrator bypasses PIM and assigns a role directly in the standard IAM blade.
  * *Audit Log Indicator:* The `Initiated by (actor)` will display the human administrator's UPN instead of the automated `MS-PIM` service principal.
  * *Built-In Alert:* Triggers the "Roles are being assigned outside of Privileged Identity Management" high-severity alert.
  * *Scope Trap:* For Azure resources, this alert only triggers for out-of-band assignments made at the **Subscription level** (ignores Resource Groups/Resources).
  * *Mitigation Trap:* The built-in "Fix" action automatically **removes the user's access entirely**. To restore it, they must be reassigned properly through the PIM UI.
  * *Reporting:* Out-of-band assignments are actively tracked on the weekly PIM digest email.
