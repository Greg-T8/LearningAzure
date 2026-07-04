<!--
File: Plan and automate identity governance.md
Description: Combined markdown content merged from 'Plan and automate identity governance'
Generated: 2026-05-26
Author: Greg Tate
-->

# Plan and automate identity governance

## Monitor identity activity by using logs, workbooks, and reports

##### **Log Analytics & KQL Fundamentals**

* **Validating Log Streams**
  * **Configuration Detail:** Use `SigninLogs | take 10` or `SigninLogs | limit 10` to extract a random sample of 10 records and verify the pipeline is working.
  * **Prerequisite:** A Log Analytics Workspace must be integrated via Diagnostic Settings.
  * **Troubleshooting:** It can take up to **15 minutes** for data to populate after the initial setup.
  * **Exam Trap (Random vs. Recent):** `take 10` does not guarantee chronological order. To get the most recent logs, you must use `top 10 by TimeGenerated desc` or `sort by TimeGenerated desc | take 10`.
* **Timestamp Accuracy**
  * `TimeGenerated`: The exact time the log was ingested and published by Log Analytics.
  * `CreatedDateTime`: The exact time the user actually authenticated.
  * **Exam Trap (Exported Logs):** Downloaded CSV/JSON files from the portal always display timestamps in **UTC**, regardless of the "Local" time UI toggle.
* **Aggregating Data (Summarize Operator)**
  * **List and Count:** `summarize count() by UserDisplayName` returns a list of unique users alongside their individual failure counts.
  * **Grand Total:** `summarize dcount(UserPrincipalName)` returns a single number (distinct count) of total unique users.
  * **Time Binning:** To summarize failures per day, add the `bin()` function: `summarize count() by UserDisplayName, bin(TimeGenerated, 1d)`.
  * **Exam Trap (UPN vs. Display Name):** `UserPrincipalName` is strictly unique; `UserDisplayName` is not. Microsoft recommends grouping by UPN for accuracy.
  * **Exam Trap (Inflated Counts):** A complex sign-in generates a separate log row for every step (password, MFA fail, MFA retry). To count actual *sessions*, group by `CorrelationId` first.
* **Understanding Sign-In Log Tables & Statuses**
  * `SigninLogs`: Contains interactive sign-ins where a human provided a factor.
  * `AADNonInteractiveUserSignInLogs`: Contains background token refreshes.
  * **Conditional Access Statuses:**
    * **Success:** Policy applied and grant controls were satisfied.
    * **Failure:** Policy applied but user failed controls or was blocked.
    * **Not Applied:** User/app did not match policy assignments, OR the user signed into a local Windows device using Windows Hello for Business (policies apply to cloud resources, not local device logins).

##### **Diagnostic Settings & Exporting Boundaries**

* **Export Limits and Behavior**
  * **Portal Downloads:** The browser interface limits downloads to **250,000 audit logs** or **100,000 sign-in/provisioning logs** per file.
  * **Custom Visual Columns:** Clicking "Download" exports the complete schema with all properties; it ignores any columns you visually hid in the UI.
  * **Filters:** Downloaded files *will* strictly honor active filters (e.g., Date Range, UPN).
  * **Circumventing Limits:** Use the **Microsoft Graph reporting APIs** or **Diagnostic Settings** to retrieve larger datasets.
* **SIEM Integration (Third-Party)**
  * **Architecture:** To send logs to Splunk or ArcSight, you must route them through an **Azure Event Hub**.
  * **Exam Trap (Security Boundary):** Both the Azure subscription and the Event Hubs namespace must reside in the **exact same Microsoft Entra tenant** from which the logs are streamed.
* **Custom Security Attributes (Strict Isolation)**
  * **Configuration Detail:** Audit logs for these attributes (`CustomSecurityAttributeAuditLogs`) are isolated from standard directory logs. They are configured in a completely separate "Custom security attributes" section within the Diagnostic Settings blade.
  * **Prerequisite/Licensing:** Standard Global or Security Administrators *cannot* configure this export. The user must explicitly be assigned the **Attribute Log Administrator** role.
  * **Exam Trap:** In Conditional Access, custom security attributes only support the **String** data type.

##### **Auditing, Provisioning, & Threat Hunting**

* **Microsoft Graph Activity Logs (`MicrosoftGraphActivityLogs`)**
  * **Use Case:** Provides a raw audit trail of all HTTP API requests. Used to investigate deep programmatic threats, like suspicious privileged assignments or anomalous API volume.
  * **Prerequisite:** Requires a **P1 or P2 license** and the **Security Administrator** role.
  * **Exam Trap (Data Volume Filtering):** You **cannot** filter these logs through Diagnostic Settings prior to sending them. To reduce Log Analytics costs, you must apply a workspace transformation.
  * **KQL Join Scenario:** To track compromised users, use `MicrosoftGraphActivityLogs | join AADRiskyUsers on $left.UserId == $right.Id`. To map a token to a sign-in event, join `SignInActivityId` (Graph logs) to `UniqueTokenIdentifier` (Sign-in logs).
  * **Exam Trap (Missing Correlations):** First-party app-only sign-ins (Microsoft background jobs) are intentionally excluded from service principal sign-in logs, so some Graph activity will not have a matching sign-in record.
* **Retrieving Sign-in Logs via PowerShell**
  * **Command:** `Get-MgAuditLogSignIn`.
  * **Prerequisite:** P1/P2 license and either `AuditLog.Read.All` or `Directory.Read.All` permissions.
  * **Exam Trap (`signInActivity`):** The `signInActivity` user property does *not* retrieve logs. It only stores a high-level timestamp of the last authentication, and it can take **up to 24 hours to update**.
* **Auditing Directory vs. Policy Changes**
  * **Group Modifications:** To investigate a user added to an administrative group, query `AuditLogs` under the **GroupManagement** category (activity: "Add member to group"). Check the `Initiated by (actor)` field to see who executed the change. If it says "Microsoft Substrate Management", it was an automated Exchange sync.
  * **Role Modifications:** To investigate direct privileged role assignments, query `RoleManagement` (activity: "Add member to role").
  * **Conditional Access Auditing:** To track policy changes, filter `AuditLogs` for `OperationName == "Update conditional access policy"`. Look under `TargetResources > modifiedProperties` to compare the `oldValue` and `newValue` JSON. Requires **Security Reader** role.
* **Provisioning Logs (SaaS Lifecycle)**
  * **Use Case:** Investigating if a user deleted in Entra ID was successfully removed from Adobe or ServiceNow.
  * **Troubleshooting Statuses:** "Skipped" indicates the user fell outside defined scoping filters or lacked a mandatory attribute.
  * **Exam Trap (Accidental Deletions):** If a sync job exceeds the deletion threshold (e.g., >500 users), the job enters **quarantine**. Removals are blocked until an admin manually clicks "Allow deletes".

##### **Azure Workbooks & Governance Tools**

* **Universal Workbook Prerequisites**
  * All workbooks natively require a **Premium P1 license** and a configured **Log Analytics Workspace**.
* **Conditional Access Gap Analyzer**
  * **Use Case:** Highlights user sign-ins bypassing modern controls (e.g., legacy authentication, unmonitored locations, skipped apps).
  * **Exam Trap:** Do not confuse this with the *Conditional Access insights and reporting* workbook, which measures the success/failure rate of *active* policies. Gap Analyzer finds the blind spots.
* **Cross-Tenant Access Activity Workbook**
  * **Use Case:** Combines B2B inbound (guests accessing your apps) and outbound (your users accessing partner apps) traffic.
  * **Exam Trap (Unconfigured State):** By default, new partner access is "unconfigured" and passes through your default settings.
  * **Exam Trap (Dynamic UI):** The user/app tables change based on whether you select the Inbound or Outbound tab. Editing these policies requires the **Security Administrator** role.
* **Usage and Insights Dashboard**
  * **Microsoft Entra application activity:** Pivots data to an app-centric view to find success/failure rates per application.
  * **Authentication methods activity:** Tracks tenant-wide MFA registration vs. actual usage to drive passwordless adoption.
  * **Exam Traps:**
    * If an app was deleted yesterday, it still appears if sign-ins occurred during the date range.
    * "Not found" apps are Microsoft service-to-service instantiations.
    * **AD FS application activity** intentionally hides any on-premises app that hasn't had a sign-in in 30 days.
    * If users complain about "too many MFA prompts", use the **Authentication Prompts Analysis** workbook, *not* Usage and Insights.
* **Identity Protection Risk Analysis Workbook**
  * **Use Case:** Visual heatmap and real-time vs. offline risk detection trends.
  * **Prerequisite/Licensing Trap:** The absolute minimum to *use the workbook* is **P1**, but to fully utilize the underlying Identity Protection data, **P2** is required.
  * **Roles:** Viewing requires Reports Reader, Security Reader, or Global Reader. Editing requires Security Administrator.

##### **Identity Secure Score Dashboard**

* **Scoring Mechanics & Math**
  * **Refresh Cycle:** Evaluates every 24 hours. Sync delays can take up to 72 hours.
  * **Partial Completion:** Actions like MFA rollout calculate a percentage score based on coverage (e.g., 5 of 100 users = 0.53% of the max available 10.71% score).
  * **[Not Scored] Label:** Actions that improve security but currently award 0 points.
* **Least Privilege Roles**
  * **View Only:** `Service Support Administrator`.
  * **Update Statuses:** `SharePoint Administrator`.
  * **Exam Trap:** Never select Global Administrator if the question specifies the "principle of least privilege".
* **Administrator Status Actions**
  * **Risk accepted:** No points awarded; item hidden.
  * **Resolved through third party / alternate mitigation:** Use this for non-Microsoft MFA (Duo/Okta). Awards the maximum score points manually.

##### **Service Health & SLA Attainment**

* **SLA Attainment Dashboard**
  * **Use Case:** Provides a monthly look-back at core authentication availability.
  * **Calculation:** Total successful user minutes divided by (successful + failed user minutes).
  * **Exam Traps:**
    * Requires a minimum of **5,000 Monthly Active Users (MAU)** to view.
    * Measures token issuance and authentication success, *not* network ping or system uptime.
    * Successful authentications routed through the backup resilient authentication system are counted as successes.

---

##### **Comparison Tables**

###### **1. Differentiating Unique Identifiers**

| Identifier | Definition & Troubleshooting Use Case |
| :--- | :--- |
| **Correlation ID** | Groups multiple logs from the **same sign-in session** (e.g., tracking a user failing and retrying MFA). |
| **Request ID** | Corresponds specifically to a single **issued token**. Use this when a developer provides an exact token. |
| **Unique Token Identifier** | Correlates a sign-in event specifically with the initial **token request**. |

###### **2. Identity Secure Score Status Options**

| Manual Status | Impact on Dashboard | Point Award |
| :--- | :--- | :--- |
| **To Address** | Active on the improvement list. | Partial or Zero. |
| **Planned** | Concrete plans are made; active on list. | Zero. |
| **Risk Accepted** | Hidden from the active list. | Zero Points. |
| **Resolved through third party** | Used when Entra lacks native visibility (e.g., Okta). | Maximum Points. |

###### **3. Microsoft Entra vs. Graph API Log Types**

| Log Source | Primary Data Captured | Prerequisite Limitations |
| :--- | :--- | :--- |
| **SigninLogs** | Interactive user authentication events. | Basic available; P1/P2 for export. |
| **AuditLogs** | Directory/configuration changes (groups, policies). | 30-day retention natively. |
| **ProvisioningLogs** | Sync actions to third-party SaaS apps. | 30-day retention natively. |
| **MicrosoftGraphActivityLogs** | Raw HTTP API requests (deep threat hunting). | P1/P2. Cannot filter before ingestion. |

## Plan and implement entitlement management in Microsoft Entra

##### **1. Connected Organizations & External Collaboration Boundaries**

**Configuration Details & Concepts**

* **Definition:** A connected organization is a structural definition representing a business relationship with an external domain.
* **Boundary Enforcement:** Adding a connected organization registers the domain but does not automatically grant access, move existing guests, or apply lifecycle expirations.
* **Policy Scoping:** To enforce least privilege, access package policies must be scoped to **"Specific connected organizations"**.

**Prerequisite / Licensing Notes**

* Connected organizations support both Microsoft Entra tenants and non-Entra external domains.

**Exam Traps to Memorize**

* **The Global Allowlist/Blocklist Trap:** Do not use the tenant's global External collaboration settings to block a domain if you simply want to restrict access package requests, as this breaks general B2B sharing.
* **The "All Users" Policy Trap:** Selecting "All users" exposes the access package to anyone on the internet and is flagged as a major security vulnerability.
* **The Directory Moving Trap:** Defining a connected organization does not move user objects into specific OUs or security groups.
* **The Proposed Connected Organization Feature:** If an access package is mistakenly set to "All users," a successful request from an undefined domain prompts Entitlement Management to automatically generate a "proposed connected organization" for administrator review.

**Scenario Example**

* **Scenario:** Fabrikam, Inc. does not use Microsoft Entra ID. You need to allow only their users to request an access package.
* **Solution:** Create a Connected Organization for Fabrikam's domain, then scope the access package policy to that Specific Connected Organization.

**Comparison Table: External Collaboration Tools**

| Partner Infrastructure | Required Configuration Tool | Primary Function |
| :--- | :--- | :--- |
| **Microsoft Entra ID** | Cross-tenant access settings | Establishes mutual trust (e.g., MFA/device claims) between two Entra tenants. |
| **Non-Entra ID (e.g., Custom OIDC)** | External Identities + Connected Organizations | Configures custom IdP federation, then defines the boundary for Entitlement Management. |

---

##### **2. Guest User Lifecycle & Governance (Governed vs. Ungoverned)**

**Configuration Details & Concepts**

* **Ungoverned Guests:** Invited manually outside Entitlement Management (e.g., direct Teams invite); they have no automated lifecycle and remain indefinitely.
* **Governed Guests:** Provisioned via access packages; their lifecycle is tied directly to their approved access.
* **Lifecycle Settings:** Configured globally in the Identity Governance admin center under **Control configurations > Lifecycle of external users**.
* **Action Options:** Administrators can configure the system to block sign-in, remove the user entirely, or set a deletion buffer (e.g., 30 days).

**Prerequisite / Licensing Notes**

* **MAU Billing Model:** Guest governance features use a Monthly Active User (MAU) billing model.
* **Azure Subscription Link:** The tenant must have a valid Azure subscription linked to activate the "Microsoft Entra ID Governance for guests" add-on.

**Troubleshooting Details**

* If guest-specific governance actions are failing to trigger, verify that the required Azure subscription is linked to the MAU billing meter.

**Exam Traps to Memorize**

* **The "Delete and Reinvite" Trap:** To bring an ungoverned guest under governance, do not delete their account. The correct action is to directly assign the existing B2B guest user to an access package.
* **The "Last Assignment" Rule:** Automated deletion only triggers when the external user loses their **last remaining access package assignment**.
* **The Ungoverned Guest Trap:** If a manually invited guest is later assigned an access package, losing that package will not delete them unless they were proactively converted to a governed state.

---

##### **3. Access Packages vs. Assignment Policies**

**Configuration Details & Concepts**

* **Access Packages:** The container/bundle of resources (groups, apps, SharePoint sites).
* **Assignment Policies:** The rulebook governing who can request, who approves, and lifecycle expiration.
* **Requestor Questions:** Configured on the policy under the **Requestor information** tab. Answers are held on the **request object**.
* **Attributes:** Configured on the catalog resource using "Specify attributes" and are written permanently to the Microsoft Entra User profile.
* **Approval Stages:** Policies support up to three stages of approval.

**Scenario Example**

* **Scenario:** A project requires internal employees to gain access instantly, while external vendor requests require their manager's approval and a contract number.
* **Solution:** Attach two assignment policies to the single access package. Policy A is for internal users (auto-approval). Policy B is for specific connected organizations, requiring manager approval and a mandatory custom question for the contract number.

**Exam Traps to Memorize**

* **Questions vs. Attributes Trap:** If data must be passed to a Logic App via the request object, use "Questions". If data must be permanently saved to the user identity, use "Specify attributes".
* **The Catalog Boundary Trap:** Never configure approvals or user justifications on the Catalog; they must strictly be configured on the Assignment Policy.
* **The Multi-Stage Approval Trap:** In a multi-stage approval workflow, at least one approver from *every* configured stage must approve before access is granted.
* **The Localization Trap:** Custom questions can be localized. The preferred language is stamped based on the external guest's browser language at the time of their request.

---

##### **4. Custom Extensions (Logic Apps)**

**Configuration Details & Concepts**

* **Trigger Stages:** Request is created, Request is approved, Assignment is granted, Assignment is removed.
* **Execution Behaviors:**
  * **Launch and continue:** Fire-and-forget (e.g., Teams notification).
  * **Launch and wait:** Pauses the access package workflow until the Microsoft Graph resume API is called.

**Exam Traps to Memorize**

* **The Catalog Prerequisite Trap:** A Custom Extension must be created inside the Catalog and linked to the Azure subscription before it can be added to an access package policy.
* **The Consumption Logic App Rule:** The Logic App must strictly be a **Consumption** logic app; Standard logic apps are unsupported.
* **The Resume API Permissions Trap:** The external identity calling the resume API must hold the **Access package assignment manager** role directly on the catalog.
* **The 14-Day Timeout Trap:** "Launch and wait" requests will time out and fail if the callback is not received within 14 days.

---

##### **5. Microsoft Entra Agent ID & AI Governance**

**Configuration Details & Concepts**

* **Target Identities:** AI agents are governed as first-class identities but mandate a human **Sponsor** or **Owner**.
* **Access Request Pathways:** Agents can request access programmatically, via direct administrator assignment, or via a Sponsor performing an **On Behalf Of (OBO)** request in the My Access portal.
* **Automated Sponsorship Transfer:** Configured via Lifecycle Workflows. The template "Transition agent sponsorships when a sponsor leaves" utilizes the built-in task `Transfer agent identity sponsorships to manager`.

**Prerequisite / Licensing Notes**

* Agents do not require separate licenses; they are covered under the human user's Microsoft Agent 365 or Microsoft 365 E7 license.
* Lifecycle workflow automation for agents requires **Microsoft Entra ID Governance** or **Microsoft Entra Suite** licenses.
* OBO requests for agents require the **Microsoft Agent 365** platform (preview).

**Troubleshooting Details**

* If the automated sponsorship transfer workflow fails during the "Leaver" phase, verify that the departing sponsor's **`manager` attribute** is populated on their user profile.

**Exam Traps to Memorize**

* **The Unsupported Resource Trap:** Agent access packages are strictly limited to Security Group memberships, Entra directory roles, and OAuth API permissions. You cannot assign SharePoint or SAP roles.
* **The Privileged Catalog Trap:** Adding Entra directory roles or OAuth permissions marks the catalog as **privileged**, which requires a **Global Administrator** to configure.
* **The Target Identity Matching Trap:** Sponsors and Owners request access on behalf of agents/service principals. Managers request access on behalf of human employees.
* **The Service Principal Fallback Trap:** For legacy workloads not using Agent ID, configure the access package policy to allow "All Service principals".

---

##### **6. Administrative Roles, Portals, & Scripting**

**Configuration Details & Concepts**

* **My Access Portal (`myaccess.microsoft.com`):** The delegated interface for non-administrators, sponsors, and business owners to track requests, perform approvals, request OBO, and conduct access reviews.
* **PowerShell Least Privilege:** Microsoft Graph PowerShell requires explicit scoping upon connection (e.g., `Connect-MgGraph -Scopes "EntitlementManagement.ReadWrite.All"`).

**Comparison Table: Delegated Administration Roles**

| Role Name | Scope & Capabilities |
| :--- | :--- |
| **Identity Governance Administrator** | Tenant-wide directory role. Can manage all catalogs, access packages, and connected organizations without full Global Admin rights. |
| **Catalog Owner** | Feature-scoped role. Restricted to managing access packages and resources exclusively within their assigned catalog. |
| **Connected Organization Administrator** | Feature-scoped role. Can create and manage connected organizations, but cannot create catalogs. |
| **Global Administrator** | Tenant-wide directory role. Required specifically to add Microsoft Entra directory roles or OAuth API permissions to privileged agent catalogs. |

**Exam Traps to Memorize**

* **The User Administrator Trap:** The User Administrator role can no longer create catalogs or manage access packages in an unowned catalog. Assign the Identity Governance Administrator role instead.
* **The Portal Distinction Trap:** If the scenario involves a business owner, sponsor, or end-user performing approvals, the answer is always the **My Access portal**, never the Entra admin center.
* **The "Directory.ReadWrite.All" Distractor Trap:** When scripting Entitlement Management tasks, avoid broad directory scopes. Always choose the targeted `EntitlementManagement.ReadWrite.All` scope.

---

##### **7. Identity Synchronization & On-Premises Integration**

**Configuration Details & Concepts**

* **Cross-Tenant Synchronization:** A push process operating in a mesh topology where the source tenant acts as the ultimate authority over the identity lifecycle.
* **Deprovisioning Mechanics:** Pushing a deletion command issues a **soft delete** in the target tenant, which becomes a permanent hard delete after 30 days.
* **On-Premises AD DS Integration:** Cloud-born B2B guests require a physical user object provisioned into on-premises Active Directory Domain Services (AD DS) to receive Kerberos tickets and utilize Windows Integrated Authentication (WIA).

**Exam Traps to Memorize**

* **The Out of Scope Deletion Trap:** Unassigning a user from the cross-tenant sync scope triggers an automatic soft delete in the target tenant.
* **The Block Sign-in Distinction:** Disabling a user in the source tenant (setting `accountEnabled = false`) does not delete them in the target tenant; it simply blocks sign-in at the target.
* **The Writeback Trap (ECMA vs MIM):** You cannot use the Entra ECMA provisioning agent or Entra Connect to write cloud users into AD DS to avoid sync loops. You must use **Microsoft Identity Manager (MIM)**.

---

##### **8. Auditing & Compliance**

**Configuration Details & Concepts**

* Entitlement Management activities (e.g., `User requests access package assignment`, `Fulfill access package assignment request`) are recorded in the Microsoft Entra audit logs.
* **Diagnostic Settings:** Configured via **Monitoring & health > Diagnostic settings** to continuously export logs to external Azure destinations.

**Exam Traps to Memorize**

* **The 30-Day Retention Trap:** Microsoft Entra ID hard-caps audit log retention at 30 days (even with Premium P1/P2). You must export logs to satisfy long-term regulatory requirements.
* **Discovery vs. Governance:** PowerShell scripts identify group-less external users (discovery). You must then place them in a security group and target an **Access Review** to take governed action (block/delete).

**Comparison Table: Export Destinations for Compliance**

| Destination | Primary Use Case for Regulatory Compliance |
| :--- | :--- |
| **Azure Storage Account** | Cheap, long-term archival where data is rarely searched. |
| **Azure Monitor Log Analytics** | Active analysis, custom reporting, and Kusto Query Language (KQL) correlation. |
| **Azure Event Hub** | Streaming logs into a third-party, non-Microsoft SIEM (e.g., Splunk, ArcSight). |

## Plan and implement privileged access

##### **1. Emergency Access ("Break-Glass") Architecture & Configuration**

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

##### **2. Privileged Identity Management (PIM) Automation & API Mechanics**

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

##### **3. PIM for Groups & Role-Assignable Constraints**

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

##### **4. PIM Scoping, Approvals, and Inheritance Mechanics**

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

##### **5. PIM Auditing, Governance Alerts, and Log Analysis**

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

## Plan, implement, and manage access reviews in Microsoft Entra

**SC-300 Exam: Microsoft Entra Access Reviews Advanced Study Review Sheet**

##### **1. Architecture & Microsoft Graph API Hierarchy**

* **The Three-Tier Hierarchy:** Access reviews operate on a strict structure of **Definitions > Instances > Decisions**.
  * **Definitions (`/identityGovernance/accessReviews/definitions`):**
    * The overarching "blueprint" or schedule.
    * Created via `POST`.
    * JSON payload must configure: `scope` (target resource/users), `reviewers`, `settings` (compliance rules like `autoApplyDecisionsEnabled`), and `recurrence` (e.g., weekly, quarterly).
  * **Instances (`/instances/{instanceId}`):**
    * Active occurrences spawned automatically by the definition's schedule.
  * **Decisions (`/instances/{instanceId}/decisions`):**
    * Individual review items for identities.
    * Returns `accessReviewInstanceDecisionItem` objects containing the `decision`, AI `recommendation`, reviewer `justification`, and current `applyResult` state.
* **API / PowerShell Execution Exam Traps:**
  * **The Instance Creation Trap:** You never manually create an instance via a `POST /instances` call; they are spawned automatically.
  * **The Multiple Resources Trap:** A definition can only target **one single resource** at a time. Scripting 50 applications requires 50 separate `POST` requests.
  * **The API Default Trap:** When using the Graph API, `autoApplyDecisionsEnabled` defaults to `false` if omitted from the payload, requiring manual enforcement.
* **Prerequisites & Licensing Notes:**
  * **API Permissions:** Scripts require the **`AccessReview.ReadWrite.All`** delegated or application permission.
  * **Role Requirements:** Generally requires the **Identity Governance Administrator** role.
  * **Privileged Role Exception:** If creating a review for a group where `isAssignableToRole = true`, the script strictly requires the **Privileged Role Administrator** role.
  * **PowerShell Module:** Requires the `Microsoft.Graph.Identity.Governance` module.

##### **2. Multi-Stage Access Reviews & Escalation Workflows**

* **Architecture Details:** Supports up to three sequential stages.
* **The Final Say Rule:** The **last decision recorded for a reviewee is the one permanently applied** at the end of the overall review. Later-stage reviewers silently overwrite earlier decisions.
* **Stage Progression Configuration (The Funnel Method):**
  * **Filter Scenario (Reduce Auditor Workload):** Set Stage 1 to "Self-review" and "Reviewees going to the next stage" to **"Approved reviewees"**. Stage 2 managers only evaluate users who explicitly requested to keep access.
  * **Escalation Scenario (Handle Ambiguity):** Set "Reviewees going to the next stage" to **"Not reviewed reviewees"** and **"Reviewees marked as 'Don't know'"**. This guarantees undecided/ignored users are escalated to a final authority.
  * **Dead End Trap:** If a "Don't know" user is not configured to progress, their review ends and falls back to the "If reviewers don't respond" setting.
* **Conflict of Interest Scenario:**
  * If a group owner is a member being reviewed, assigning "Group owner(s)" allows them to rubber-stamp their own access.
  * **Solution:** Create a multi-stage review. Stage 1: "Self-review". Stage 2: "Selected users" (Auditor).
* **Visibility Exam Traps:**
  * **The Blind Review Trap:** For strict, unbiased, independent compliance audits, disable the **"Show previous stage(s) decisions to later stage reviewers"** setting.

##### **3. Automated Decision Helpers & Machine Learning**

* **Inactive Users Recommendation:**
  * **Tenant-Level vs. App-Level:** Reviewing a Microsoft 365 Group checks tenant-wide sign-ins; reviewing an Enterprise Application specifically evaluates activity within that app.
  * **The Snapshot Trap:** The system captures a snapshot of sign-in data exactly when the review begins. It **is not updated while the review is in progress**, even if the user subsequently logs in.
  * **Grace Period Trap:** Guests created within the inactivity window (e.g., created 10 days ago for a 30-day review) are **not in scope**, ensuring new users have time to authenticate. Maximum lookback is 730 days.
* **User-to-Group Affiliation Helper:**
  * Analyzes organizational reporting structure/org chart to flag users with "low affiliation" to group peers.
  * **Prerequisites Trap:** **Requires a populated `manager` attribute**. Works only for **internal users** (not B2B guests).
  * **Computation Limit Trap:** Instantly fails for **groups with more than 600 users**.
* **Access Review Agent (Microsoft Teams):**
  * Takes reviews out of the My Access portal and into Microsoft Teams using natural language summaries. It only proposes decisions; humans must finalize them.
* **Licensing Prerequisites:**
  * All advanced helpers (Affiliation, Inactive Users, Teams Agent) strictly require the premium **Microsoft Entra ID Governance** or **Microsoft Entra Suite** license, not just P2.

##### **4. Reviewer Assignments & PIM Intersections**

* **PIM for Groups Reviewer Rules:**
  * **Active vs. Eligible Trap:** Access reviews assigned to "Group owner(s)" for PIM-governed groups will **only route to active owners, completely ignoring eligible owners**.
* **Fallback Reviewer Configuration:**
  * **Triggers:** Required for PIM groups (which often have zero permanent active owners). Also triggered if reviewer is set to "Manager" but the reviewee has a blank manager attribute.
  * **Immutability Trap:** Once a fallback reviewer is added to a definition, **they cannot be removed**.

##### **5. Enforcement, Lifecycle States, & Troubleshooting**

* **Decision Enforcement Timing:**
  * **Active Status:** No access rights are changed while the review is "InProgress". The API `applyResult` shows as `New`.
  * **Completed Status:** If "Auto apply results to resource" is enabled, status progresses automatically: `Completed` -> `Applying` -> `Applied`. If disabled, an administrator must manually click "Apply".
* **Review Termination Traps:**
  * **Stop Current Stage:** Advances the workflow to the next multi-stage phase.
  * **Stop:** Terminates the *entire* access review instance early and executes decisions immediately.
  * **Reset:** Wipes out all current decisions and reverts everyone back to `NotReviewed`.
* **Fallback Enforcement ("If reviewers don't respond"):**
  * To establish a strict default-deny compliance posture for non-responders, set this to **"Remove access"**.
  * **System Actor Trap:** Decisions applied by this fallback are attributed to the system actor **"AAD Access Reviews"** in audit logs.
* **Guest Offboarding Mechanics ("Block and Delete"):**
  * Setting "Action to apply on denied guest users" to block for 30 days then remove from tenant executes a global offboarding.
  * **Phase 1 Trap:** The user is blocked from sign-in, but resource access/group memberships are intentionally *not* revoked as a safety net.
  * **The "Applying" UI Trap:** The review remains stuck in the `Applying` state for 30 days; settings, reviewers, and audit logs cannot be viewed during this window.
  * **Universal Deletion Trap:** Deletes the user from the tenant irrespective of other legitimate group access. Cannot be used for Entra ID role reviews.
* **Troubleshooting Unsupported Removals:**
  * Microsoft Entra cannot automatically apply access removals if the user gained access via a **nested group** or a **Windows Active Directory synced group**.

##### **6. Auditing, Notifications, & Log Retention**

* **Notification Reminders Configuration:**
  * **Midpoint Schedule:** Enabling reminders automatically triggers an email at the **exact mathematical midpoint** of the review. Custom schedules (e.g., every 3 days) are not supported.
  * **Targeted Audience Trap:** By default, it sends only to uncompleted reviewers. However, if toggled on *mid-flight* during an active review, **all reviewers receive the email**, regardless of completion status.
* **Access Review History (Static Reporting):**
  * Used to bypass the 30-day standard audit log limit by generating historical CSV/Excel reports.
  * **The URI Link Trap:** If scripting via Graph API, the generated `downloadUri` **is only active for 24 hours**.
  * **Enforcement Limitation:** Cannot be used for real-time automated access removal.
* **Diagnostic Settings (Dynamic Reporting):**
  * **The Retroactive Trap:** Exporting to Azure Monitor only captures logs *from the moment enabled forward*; it cannot retrieve purged historical data.
  * **KQL Auditing Trap:** To audit actual human reviewer engagement, KQL queries must filter out system actions: `where ReviewedBy_DisplayName != "AAD Access Reviews"`.

##### **7. Comparison Tables**

**Table 1: Graph API Hierarchy vs. PowerShell Cmdlets**

| Tier | API Endpoint Concept | HTTP Action | PowerShell Cmdlet | Description |
| :--- | :--- | :--- | :--- | :--- |
| **Definition** | `/definitions` | `POST` | `New-MgIdentityGovernanceAccessReviewDefinition` | Creates the central blueprint, scope, settings, and recurrence pattern. |
| **Instance** | `/instances` | System Auto | N/A (System Generated) | An active, scheduled occurrence spawned automatically. |
| **Decision** | `/instances/{id}/decisions` | `GET` | `Get-MgIdentityGovernanceAccessReviewDefinitionInstanceDecision` | Retrieves the real-time decisions, justifications, and application states for users. |
| **Manual Apply** | `/instances/{id}/applyDecisions` | `POST` | `Add-MgIdentityGovernanceAccessReviewDefinitionInstanceDecision` | Manually forces decisions to apply if auto-apply was disabled. |

**Table 2: Log Retention & Diagnostic Destinations**

| Destination Type | Best Use Case | Retention / Limits |
| :--- | :--- | :--- |
| **Default Entra Audit Logs** | Immediate portal viewing. | **30 days** (P1/P2 Premium) / 7 days (Free tier). |
| **Access Review History** | Point-in-time auditor compliance files. | Data retained >30 days. Report download URI expires in **24 hours**. |
| **Azure Log Analytics Workspace** | Active KQL querying, Workbooks, real-time custom reports. | Up to 2 years (customizable). |
| **Azure Storage Account** | Cheap, long-term compliance archival without frequent querying. | Indefinite/Custom lifecycle. |
| **Azure Event Hub** | Streaming to 3rd-party SIEMs (Splunk, SumoLogic). | N/A (acts as a bridge). |

## Plan and implement entitlement management in Microsoft Entra

### Create and configure access packages

###### **I. Prerequisites and Licensing for Access Packages**

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

###### **II. Access Package Architecture & Resource Bundling**

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

###### **III. Access Package Policies: Request vs. Automatic**

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

###### **IV. Discovery & My Access Portal Visibility Logic**

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

###### **V. Separation of Duties (SoD) & Incompatible Packages**

* **Function:** Prevents users from acquiring conflicting access rights (e.g., holding both "Financial Auditor" and "Accounts Payable").
* **Configuration Constraints:**
  * **Incompatible Packages:** If User holds Package A, the portal actively blocks or hides requests for Package B.
  * **Incompatible Groups:** Prevents requesting a package if the user is already a member of a specific Entra security group.
  * **Bidirectional Best Practice:** For full enforcement, configure the relationship on **both** packages (A blocks B, and B blocks A).
* **Override Strategy:**
  * If a business exception is required, administrators create a separate "Override" access package containing the conflicting resources, but assign a higher-tier approval policy (e.g., Risk Officer).

---

###### **VI. Multi-Stage Approval & Escalation Guardrails**

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

###### **VII. Time-Bound Lifecycle & External Guest Cleanup**

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

###### **VIII. Custom Extensibility (Azure Logic Apps)**

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

###### **IX. Graph API and PowerShell Technical Mechanics**

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

### Create and configure catalogs

###### **I. Prerequisites and Licensing for Catalog Management**

* **Licensing Requirements:**
  * Requires **Microsoft Entra ID Governance**, **Microsoft Entra ID Governance Step Up**, or the **Microsoft Entra Suite**.
  * Basic Entra ID P2 does *not* cover advanced catalog extensibility (like custom Logic App extensions).
* **PowerShell Authorization (The Global Admin Gatekeeper):**
  * **First-Time Consent:** The very first time Microsoft Graph PowerShell is used for catalog management, a **Global Administrator** must authorize it.
  * **Permission Scope:** The Global Admin must check "Consent on behalf of your organization" for high-level scopes like `EntitlementManagement.ReadWrite.All`.
  * **Delegation:** After initial consent, the **Identity Governance Administrator** takes over day-to-day scripting; the Global Admin is no longer required.

> **🚨 EXAM TRAP:** If a scenario states an Identity Governance Administrator is receiving a "Cannot consent on behalf of your organization" error on their *first* PowerShell login, the solution is **not** to assign them a higher role permanently, but to have a Global Admin execute the initial consent.

---

###### **II. Catalog Architecture and Structural Configuration**

* **The General Catalog (`serviceDefault`):**
  * **Creation Mechanism:** Automatically generated the *very first time* an admin interacts with the entitlement management system.
  * **Fallback Behavior:** If an administrator creates a package using a resource not currently in a designated catalog, it is added here by default.
  * **Graph API Identifier:** Identified technically by the `catalogType` property value of `serviceDefault`.
* **Designated Catalogs:**
  * Custom containers (e.g., "HR", "Sales") used to isolate department resources and delegate administration away from central IT.
* **Privileged Catalogs:**
  * **Automatic Flagging:** A catalog is automatically treated as "Privileged" if it contains resources granting elevated rights, specifically:
        1. Microsoft Entra directory roles.
        2. OAuth API permissions.

---

###### **III. Administrative Roles and Delegation Strategy**

* **Tenant-Wide Authorities:**
  * **Global Administrator & Identity Governance Administrator (IGA):**
    * Are "super-users" exempt from resource ownership checks.
    * Can add *any* resource to *any* catalog, regardless of whether they "own" the catalog or the resource.
  * **Catalog Creator (The Delegator):**
    * Authorized tenant-wide to *create* catalogs.
    * **Automatic Promotion:** Upon creation, the creator is *automatically* assigned the **Catalog owner** role for that specific container.
    * **Blind Spot:** Cannot see, edit, or manage catalogs they did not explicitly create or own.
* **Catalog-Specific Authorities:**
  * **Catalog Owner:** Full control over a specific container; can add/remove resources and add other owners.
  * **Access Package Manager:** The "Chef". Can build new packages from the catalog's existing resources but **cannot add new resources to the catalog**.
  * **Access Package Assignment Manager:** The "Operator". Can assign users and troubleshoot delivery errors. **Cannot create packages, edit policies, or bypass underlying approval settings**.

> **🚨 EXAM TRAP:** The **User Administrator** role is no longer recommended for managing catalogs. Microsoft specifically transitioned these duties to the **Identity Governance Administrator** as the least-privileged tenant-wide role.

**Table 1: Catalog Delegation Limitations**

| Role | Scope | Can Create Catalogs? | Can Add Resources to Catalog? | View Unowned Catalogs? |
| :--- | :--- | :--- | :--- | :--- |
| **IGA** | Tenant | **Yes** | **Yes** (Any resource) | **Yes** |
| **Catalog Creator** | Tenant -> Catalog | **Yes** | **Yes** (Only if owned) | **No** |
| **Catalog Owner** | Catalog | **No** | **Yes** (Only if owned) | **No** |
| **Access Pkg Manager**| Catalog | **No** | **No** | **No** |

---

###### **IV. Resource Onboarding and The "Two-Pronged" Guardrail**

For any user *other* than a Global Admin or IGA, adding a resource to a catalog requires satisfying two checks simultaneously: **1. Catalog Owner** AND **2. Technical Resource Ownership**.

* **1. Security Groups and Microsoft 365 Groups:**
  * **Required Graph Permissions:**
    * `microsoft.directory/groups/members/update`.
    * `microsoft.directory/groups/owners/update`.
  * **Configuration:** User must be listed as an explicit **Owner** on the group object.
* **2. Enterprise Applications:**
  * **Required Graph Permission:** `microsoft.directory/servicePrincipals/appRoleAssignedTo/update`.
  * **Configuration:** User must be an Application Administrator, Cloud App Admin, or explicitly assigned as the Enterprise Application **Owner**.
* **3. SharePoint Online Sites:**
  * **Required Roles:** Being a standard "Site Owner" is insufficient. User must be a **SharePoint Administrator** or the specific **Site Collection Administrator** (SharePoint site administrator).

**🛠️ TROUBLESHOOTING:**

* **Scenario:** A Catalog owner attempts to add a sensitive M365 Group to their catalog. The group is grayed out or throws a "403 Forbidden" error.
* **Root Cause:** The user is merely a *Member* of the M365 Group, lacking the `members/update` and `owners/update` permissions.
* **Resolution:** An IT Admin must make the user an explicit *Owner* of the group within Entra ID.

---

###### **V. Configuring External Access at the Catalog Level**

The catalog acts as the ultimate security boundary for B2B guest access.

* **The Gateway Logic Toggle (`Enabled for external users`):**
  * If set to **No**, all external access is immediately blocked.
  * **Override Behavior:** This catalog-level toggle overrides any permissive policies inside its access packages. If the catalog says "No", external users from Connected Organizations cannot see or request *anything* inside it.
* **Auditing Strategy:**
  * Central IT uses the `Enabled for external users: Yes` filter in the admin center to rapidly isolate which departmental "buckets" are exposed to outside partners.
* **Proposed Connected Organizations:**
  * **Trigger:** If a catalog is enabled for external users, AND an access package policy allows "All users," an approval from an unknown domain triggers the **automatic creation of a proposed connected organization** for admin review.

---

###### **VI. Automating Catalogs with Custom Extensions**

Catalogs are the attachment point for **Azure Logic Apps** to automate external tasks (ITSM integration, custom Teams messages).

* **Configuration Requirements:**
  * **Role:** Requires Identity Governance Administrator or Catalog Owner.
  * **Infrastructure:** Requires an active Azure subscription for consumption-based Logic Apps.
* **Execution Behaviors:**
  * **Launch and Continue:** Triggers the external logic and immediately moves to the next Entra provisioning step.
  * **Launch and Wait:** **Pauses** the entitlement process completely. Waits for a Microsoft Graph API "resume" signal. If no signal arrives, it times out (typically after **14 days**).
* **The ServiceNow "Resume" Architecture (Critical Configuration):**
  * **Identity:** ServiceNow requires a **Microsoft Entra application registration** to act as its Service Principal.
  * **Authentication:** ServiceNow authenticates via a **client secret** to send the resume API call.
  * **Least Privilege Role Assignment:** The ServiceNow App Registration must be assigned the **Access package assignment manager** role *strictly at the catalog level*. This ensures ServiceNow can only resume workflows in the catalog it is authorized for.

**💡 SCENARIO:**
An organization needs to provision access to a legacy on-premises database that lacks Entra integration.
**Configuration:** The IGA configures a custom extension linked to the catalog. Trigger: *Request is approved*. Behavior: *Launch and Wait*. The Logic App generates a ServiceNow ticket. The user does not receive the "Delivered" state in Entra ID until the IT technician closes the ticket, prompting ServiceNow to send the REST API resume signal.

---

###### **VII. Configuration via Graph API and PowerShell**

* **PowerShell Command Structure:**
  * **Create a new catalog:** `New-MgEntitlementManagementCatalog`.
  * **Retrieve an existing catalog:** `Get-MgEntitlementManagementCatalog`.
  * **Find Default Catalog ID:** Use the filter string `-Filter "displayName eq 'General'"` with the `Get-` cmdlet.
* **Graph API (`POST /resourceRequests`):**
  * **Explicit IDs Required:** Unlike the Entra admin UI, the Graph API does **not** fall back to the General catalog automatically. The administrator *must* supply a specific `catalogId` in the request body.
  * **The `adminAdd` Request Type:**
    * Used when an administrator links a group, app, or site to a catalog via API.
    * **Execution Logic:** The resource is added to the catalog **immediately**, without requiring a separate user request, approval workflow, or background waiting period.

**Table 2: Comparison of Assignment/Addition Request Types**

| Request Type | Actor | Target | Outcome Behavior |
| :--- | :--- | :--- | :--- |
| **adminAdd** | Administrator | Catalog Resource | **Immediate.** Adds resource to catalog menu directly. |
| **adminAdd** | Administrator | User Assignment | **Immediate.** Direct assignment pushes access, bypassing My Access portal. |
| **UserAdd** | End User | Package Request | **Conditional.** Subject to policy approval and delivery states. |

### Implement and manage terms of use (ToU)

###### **SC-300 Exam Study Review: Implement and Manage Terms of Use (ToU) - Expanded Edition**

###### **1. Prerequisites and Licensing**

* **Licensing Requirements:**
  * **Minimum:** **Microsoft Entra ID P1** is required to configure and enforce ToU policies.
  * **Supported Bundles:** Fully supported in **Microsoft Entra ID P2** and **Microsoft 365 Business Premium**.
* **Licensing Expiration Behaviors:**
  * ⚠️ **EXAM TRAP:** If a tenant’s P1 or P2 license expires, **all user acceptance records are permanently and immediately deleted**.
  * Conditional Access (CA) policies are **not** deleted; they enter a "graceful state" where they cannot be updated but can be viewed or deleted.
  * Historical proof of compliance is permanently lost unless previously backed up via CSV.
* **Administrative Roles:**
  * **Conditional Access Administrator:** Create, modify, and delete ToU policies.
  * **Security Reader:** View ToU configurations, policies, and aggregate acceptance reports.
  * **Reports Reader:** View detailed consent events in the **Microsoft Entra audit logs**.

###### **2. Document Configuration and Specifications**

* **Tenant Limits:** A hard limit of **40 ToU policies** per Microsoft Entra tenant.
* **Document Formatting:**
  * Must be strictly uploaded in **PDF format**.
  * You cannot alter the file format of an existing policy.
  * **Best Practice:** Microsoft mandates at least a **24-point font** to ensure mobile readability.
* **Hyperlink Behavior & Limitations:**
  * *External Links:* Supported. Links to external sites work during the initial sign-in flow.
  * *Internal Links:* **Unsupported**. "Jump links" or bookmarks navigating within the same PDF will fail.
  * *MyAccount Portal:* **No links function** when a user reviews a previously accepted ToU via the MyAccount portal.

###### **3. Multi-Language Support and Localization**

* **Configuration:** You can upload multiple PDFs to a single policy, tag them with specific languages, and specify a unique **Display name** per language.
* **Language Detection Logic:**
  * **Step 1:** System checks the user's **browser language preferences**.
  * **Step 2 (Fallback):** If no match is found, the system serves the **"default document"** (the very first PDF uploaded to the policy).
* ⚠️ **EXAM TRAP:** **Desktop WAM Apps Exception:**
  * For Windows desktop applications using Web Account Manager (WAM), such as **Microsoft Teams**, the system **ignores browser settings** and uses the **operating system language**.

###### **4. Conditional Access Integration and Enforcement**

* **Enforcement Mechanism:** ToU is applied as a **grant control** within CA policies.
* **Automated Workflow:** Selecting the **"Custom policy"** template when creating a ToU automatically triggers the CA policy creation dialog with the ToU pre-populated under Grant controls.
* **Validation Order:**
  * 1st: **Multifactor Authentication (MFA)**.
  * 2nd: **Device state/compliance**.
  * 3rd: **Terms of Use** (evaluated last).
* **User Experience Controls:**
  * **Mandatory Expansion:** Administrators can require users to scroll through (expand) the document before the "Accept" button enables.
  * **Denial Consequence:** Declining the terms completely blocks access to protected applications until the user signs in and accepts them.

###### **5. Device and Application Scenarios**

* **"Require users to consent on every device" (Per-Device):**
  * Requires the hardware to be **registered in Microsoft Entra ID** to obtain a unique **Device ID**.
  * Mobile devices may require broker apps (**Microsoft Authenticator** or **Company Portal**) to facilitate registration.
* ⚠️ **EXAM TRAP:** **Per-Device Limitations:**
  * **B2B Guests:** Strictly unsupported. External guests do not register devices in the resource tenant, so no Device ID exists. Use standard per-user ToU policies for guests.
  * **Intune Conflict:** The **Microsoft Intune Enrollment app** must be explicitly excluded. Applying per-device ToU here checks for a Device ID *before* enrollment completes, causing a circular authentication loop blocking enrollment.
* 💡 **SCENARIO: SharePoint External Sharing:**
  * ToU is **only** displayed if the recipient has a guest account in the directory (Account-based sharing). Ad-hoc/guestless links (e.g., "Anyone" links) bypass the Entra ID flow and **will not** trigger ToU.

###### **6. Troubleshooting and Identity Exclusions**

* **Interactive Requirement:** ToU requires a human to view and click "Accept".
* **Legacy Protocols:** Basic Auth, IMAP, POP, and legacy PowerShell are strictly incompatible with modern grant controls and are **blocked automatically**.
* **Mandatory Exclusions (To prevent tenant lockouts and automation failures):**
    1. **Service Accounts** (Recommend migrating to Managed Identities/Workload CA policies).
    2. **Emergency Access (Break-Glass) accounts**.
    3. **Microsoft Entra Connect Sync accounts**.
* 💡 **SCENARIO: Edge Browser Loop:**
  * Users constantly prompted on Microsoft Edge need to **sync their work profile**. This establishes a **Primary Refresh Token (PRT)** for SSO, allowing Entra to remember the session's prior acceptance.
* **Network Allow-List for Restricted Networks:**
  * If using strict firewalls, you must allow: `https://tokenprovider.termsofuse.identitygovernance.azure.com`, `https://myaccount.microsoft.com`, and `https://account.activedirectory.windowsazure.com`.

###### **7. Reporting, Auditing, and Data Retention Comparison**

| Feature | Terms of Use Details Overview | Exported CSV Report | Entra Audit Logs |
| :--- | :--- | :--- | :--- |
| **Scope of Data** | Snapshot of the **current version only**. | **Entire history** across all versions. | Granular consent events with correlation IDs. |
| **Update Frequency** | Refreshes typically **once daily**. | Real-time at point of export. | Real-time ingestion. |
| **Data Retention** | **Resets** if updated or expired. | Stored for the **entire life of the policy**. | Retained for **30 days** by default. |
| **Primary Use Case** | Quick daily compliance snapshot. | Audit-ready historical proof. | Deep troubleshooting (e.g., checking "Interrupted" status). |

* **Extending Audit Logs:** Use **Diagnostic Settings** to push 30-day audit logs to an Azure Storage Account, Log Analytics Workspace (for KQL queries), or Event Hubs.

###### **8. Policy Lifecycle, Versioning, and Deletion**

* **Updating Versions ("Require reaccept" toggle):**
  * **Off:** Existing user consents remain valid. Only new users or expired users see the new version.
  * **On:** Existing users are forced to accept the new version, but **only after their current session expires**. To force immediate global evaluation, the ToU must be deleted and recreated.
* **Deletion Governance:**
  * Deleting a ToU object triggers the **immediate, permanent purge** of all associated acceptance records.
  * **Best Practice:** Download the CSV report before deletion. If you want to temporarily stop enforcing but keep records, **disable the Conditional Access policy** rather than deleting the ToU object.
* **End-User Self-Review:**
  * Users navigate to **`https://myaccount.microsoft.com/`** > **Settings & Privacy** > **Privacy** > **Organization's notice**.
  * Users **cannot "unaccept"** or revoke consent once given.

### Manage access requests

###### **I. Prerequisites, Licensing, & Role Configurations**

* **Licensing Requirements:**
  * Requires **Microsoft Entra ID Governance**, **Microsoft Entra ID P2**, or the **Microsoft Entra Suite**.
  * Every internal user making a request requires a license.
  * External guests submitting requests are governed via the **Monthly Active User (MAU)** Azure subscription billing.
* **Administrative Delegation:**
  * **Catalog Owner:** Can view all access package requests within their container, reprocess stalled requests, and directly push/remove assignments.
  * **Identity Governance Administrator:** Tenant-wide authority to manage requests and bypass standard portal workflows.

---

###### **II. The Requestor Experience & Data Collection**

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

###### **III. Request Visibility & Privacy Limitations**

Entitlement management enforces strict role-based access to request data to ensure privacy.

* **The Requestor:** Can view their own pending/past requests via the **"Request history"** tab in the My Access portal.
* **The Approver:** Can view requests awaiting their decision in the **"Approvals"** tab.
* **Catalog Owner:** Can view all requests within their delegated catalog via the Entra admin center.

> **🚨 EXAM TRAP:** Owning a resource (e.g., being a SharePoint Site Administrator or an M365 Group Owner) does **NOT** grant visibility into the access requests for that resource. If a Resource Owner is not explicitly named as a designated approver in the policy, they have zero visibility into the My Access portal's request queue.

---

###### **IV. Microsoft Graph API & Request Scopes**

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

###### **V. Multi-Stage Approvals & Escalation Guardrails**

* **Linear Architecture:** Multi-stage approvals (maximum of **three stages**) operate sequentially. Stage 2 approvers are **never notified** until Stage 1 is fully approved.
* **The "At Least One" Rule:** If a stage features multiple approvers (e.g., five "Project Leads"), the **first person to click Approve** satisfies the requirement for the entire stage, advancing the request.
* **Fail-Fast Mechanism:** If an approver at **any stage** clicks "Deny", the entire process terminates immediately. No further stages are triggered.
* **Escalation (Alternate) Approvers:**
  * **Half-Life Reminder:** System sends an automated reminder to the primary approver halfway through the designated approval timeframe.
  * **Escalation Event:** If the primary deadline expires, the request is actively **forwarded** to the alternate approvers.
  * **Shared Authority:** Once escalated, **BOTH** the primary and alternate approvers have concurrent authority to act; the first to decide satisfies the stage.

---

###### **VI. Request Timeouts and Terminal States**

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

###### **VII. Technical Fulfillment: The "Delivering" State**

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

###### **VIII. Managing Access Extensions (Zero Trust)**

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

### Plan entitlements

###### **1. Licensing, Prerequisites, and Capacity Planning**

* **Prerequisite Licensing Combinations:** Microsoft Entra ID Governance is an add-on requiring a specific base license.
  * Microsoft Entra ID Governance + **Microsoft Entra ID P1**.
  * Microsoft Entra ID Governance Step Up + **Microsoft Entra ID P2** (or EMS E5).
  * **Microsoft Entra Suite** (includes governance natively).
* **Capacity Limits:**
  * Organizations with the appropriate license combination can govern access to a maximum of **1500 applications per user**.
* **Per-User vs. Guest Billing:**
  * **Internal Users:** The tenant must have sufficient Governance licenses for all internal members governed (requestors, approvers, reviewers).
  * **External Users (Guests):** Governed via **Monthly Active User (MAU)** billing linked to an Azure subscription.
* **Feature-Specific Licensing Requirements:**
  * Basic access review features exist in Entra ID P2, but **intelligent features** (Access Review Agent, inactive user reviews, machine learning recommendations) **explicitly require the Microsoft Entra ID Governance license**.

> **🚨 EXAM TRAP:** Do not assume Entra ID P2 covers all entitlement management features. If a question asks about AI-driven recommendations or reviewing inactive users, the answer requires the **Governance add-on**.

---

###### **2. Architecting Catalogs and Delegated Administration**

* **Catalog Architecture:** The mandatory parent container for resources (groups, apps, SharePoint sites) and access packages.
  * **Default State:** A "General" catalog exists by default for non-delegated, centralized IT management.
  * **Privileged Catalogs:** Automatically flagged if the catalog contains high-privilege resources, specifically **directory roles** or **OAuth API permissions**.
* **Delegating Administration (Least Privilege):**
  * **Catalog Creator:** Delegated to business leads. They can create/manage their own catalogs but **cannot see or manage catalogs they do not own**.
  * **Auto-Assignment:** Creating a catalog automatically makes the creator the **Catalog owner**.
* **Resource Onboarding Guardrails (Two-Pronged Check):**
  * Non-administrators must possess **both** the Catalog Owner role **AND** the technical resource ownership permission.
  * *Security Groups:* Requires `microsoft.directory/groups/members/update` and `microsoft.directory/groups/owners/update`.
  * *Enterprise Apps:* Requires `microsoft.directory/servicePrincipals/appRoleAssignedTo/update` [Conversation History].
  * *Bypass:* Global Administrators and Identity Governance Administrators bypass this and can add any resource to any catalog.

> **🚨 EXAM TRAP:** If a scenario asks for the "least privileged role" to allow a department manager to create packages for their own team, choose **Catalog creator**, not Identity Governance Administrator.

**Table 1: Entitlement Management Administrative Roles**

| Role | Can Create Catalogs? | Can Create Access Packages? | Can Edit Package Policies? | Can Edit Resource Roles? |
| :--- | :--- | :--- | :--- | :--- |
| **Identity Governance Admin** | Yes (Tenant-wide) | Yes (Tenant-wide) | Yes | Yes |
| **Catalog Owner** | No (Manages owned catalog) | Yes (In owned catalog) | Yes | Yes |
| **Access Package Manager** | No | No | Yes | Yes |
| **Access Pkg Assignment Manager**| No | No | No | No |

**🛠️ Troubleshooting Scenario:**

* **Issue:** A Catalog owner attempts to add a sensitive HR security group to their catalog but receives an error.
* **Root Cause:** The Catalog owner is not listed as an *owner* on the Azure AD security group object.
* **Fix:** An IT administrator or current group owner must add the Catalog owner as a technical owner of the HR group.

---

###### **3. Designing Access Packages and Resource Roles**

* **Resource Roles:** Access packages bundle specific collections of permissions (Resource Roles).
  * *Groups:* Member or Owner.
  * *SharePoint:* Site Visitor, Site Member, Site Owner.
  * *Applications:* Custom roles defined in the application manifest (e.g., "Salesperson").
* **Separation of Duties (SoD):** Enforced via **Incompatible access packages**.
  * **Configuration:** Administrator marks two packages as incompatible.
  * **Behavior:** If User A holds Package 1, the system actively **blocks the assignment** of Package 2 and prevents User A from requesting it.

> **🚨 EXAM TRAP:** Do not confuse "Incompatible access packages" with "Catalog resource scoping". Scoping organizes resources into folders; Incompatible packages logically block conflicting user assignments.

**Table 2: Supported Resources by Identity Type**

| Resource Type | Standard Human User | AI Agent / Service Principal (Preview) |
| :--- | :--- | :--- |
| **Security Groups** | Supported | Supported |
| **Directory Roles** | Supported | Supported |
| **API Permissions (OAuth)** | Not standard for end-users | **Supported** |
| **SharePoint Online Sites** | Supported | **NOT Supported** |
| **Application Manifest Roles** | Supported | **NOT Supported** |
| **SAP Business Roles** | Supported | **NOT Supported** |

* **AI Agent Governance (Preview):**
  * Governed via the **"All agents (preview)"** assignment policy.
  * Must have a **human sponsor** accountable for approving requests and extending time-bound access.

---

###### **4. Planning Access Lifecycles and Automation Strategies**

* **Automatic Assignment Policies:**
  * **Trigger:** Attribute-based rules (e.g., `user.department -eq "Marketing"`).
  * **Source of Truth:** Often driven by inbound provisioning from an HCM system (Workday, SuccessFactors).
  * **Constraint:** An access package can have a maximum of **ONE** automatic assignment policy. (You can add request-based policies alongside it).
* **Direct Assignment Policies:**
  * Used when administrators manually push access (bypassing requests).
  * **Governance Requirement:** Manual access **must** be tied to a policy to inherit expiration rules (e.g., expires in 90 days), preventing permanent backdoor access.

**Table 3: Lifecycle Automation Comparison**

| Feature | Primary Trigger | Primary Outcome | Use Case |
| :--- | :--- | :--- | :--- |
| **Automatic Assignment Policy** | Entra ID User Attribute Match | Adds/Removes access to groups/apps/sites | User moves from Sales to Marketing |
| **Lifecycle Workflows** | Joiner/Mover/Leaver event | Executes process tasks (Emails, TAPs) | Sending a welcome email to a new hire's manager |
| **Direct Assignment** | Manual Admin Action | Grants access governed by policy expiration | Bulk onboarding or helpdesk override |

---

###### **5. Planning External Identity Governance (B2B)**

* **Connected Organizations:**
  * Defines authorized partner domains.
  * Enables **scoping**: Access package policies can be restricted so only users from a specific partner domain can see/request the package.
  * **Sponsorship:** Allows defining **Internal Sponsors** (your project managers) and **External Sponsors** (partner contacts) for approval flows.
  * **Auto-Discovery:** If a user from an unknown domain requests access via an "All users" policy, the system creates a **"proposed" connected organization** for admin review.
* **Just-in-Time Provisioning:**
  * When an external user requests access and is approved, the system **automatically creates a B2B guest account**.
* **External User Lifecycle Settings:**
  * **Trigger:** Evaluated when the guest's **last access package assignment expires** (or is revoked).
  * **Actions:** "Block sign-in only", "Delete user", or implement a "Waiting period" (e.g., 30 days before deletion).

**🛠️ Troubleshooting Scenario:**

* **Issue:** An external user from a trusted Connected Organization is given the My Access portal link but cannot see the access package.
* **Root Cause:** The parent Catalog housing the package is not configured for external visibility.
* **Fix:** Navigate to Catalog settings and change **"Enabled for external users"** to **Yes**.

---

###### **6. Custom Extensibility (Azure Logic Apps)**

* **Prerequisites:**
  * Requires **Microsoft Entra ID Governance** or Microsoft Entra Suite.
  * Requires an Azure subscription for Consumption-based Logic Apps.
* **Role Requirement:**
  * Must hold the **Identity Governance Administrator** role (the least privileged role capable of managing custom extensibility/catalogs globally).
* **Triggers:**
  * Logic apps can fire during three stages: **Request processing**, **Assignment granting**, or **Assignment removal**.

**Table 4: Logic App Execution Behaviors**

| Behavior | Mechanism | Best For... |
| :--- | :--- | :--- |
| **Launch and Continue** | Triggers Logic App and moves to next Entra ID provisioning step immediately. | Sending a Teams notification; logging an event. |
| **Launch and Wait** | Triggers Logic App and **pauses** Entra ID provisioning. Waits for a "resume" signal from the external system. | Creating a ServiceNow ticket; waiting for legacy DB provisioning. |

> **🚨 EXAM TRAP:** If a scenario asks how to provision access to a legacy system that lacks native Entra provisioning, and the system must be ready *before* the access package is marked "Delivered", choose **Launch and Wait**.

---

###### **7. Access Review Agent (AI Insights)**

* **Platform:** Interacts with reviewers entirely within **Microsoft Teams** using natural language.
* **Capabilities:**
  * Identifies **"inactive users"** (e.g., no sign-in for 30 days).
  * Identifies **"low affiliation"** based on org reporting structure.
  * Provides actionable **recommendations** ("Approve" or "Deny") to reduce attestation fatigue.

