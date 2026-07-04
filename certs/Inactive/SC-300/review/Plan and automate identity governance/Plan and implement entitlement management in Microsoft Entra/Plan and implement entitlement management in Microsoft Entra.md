### **1. Connected Organizations & External Collaboration Boundaries**

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

### **2. Guest User Lifecycle & Governance (Governed vs. Ungoverned)**

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

### **3. Access Packages vs. Assignment Policies**

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

### **4. Custom Extensions (Logic Apps)**

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

### **5. Microsoft Entra Agent ID & AI Governance**

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

### **6. Administrative Roles, Portals, & Scripting**

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

### **7. Identity Synchronization & On-Premises Integration**

**Configuration Details & Concepts**

* **Cross-Tenant Synchronization:** A push process operating in a mesh topology where the source tenant acts as the ultimate authority over the identity lifecycle.
* **Deprovisioning Mechanics:** Pushing a deletion command issues a **soft delete** in the target tenant, which becomes a permanent hard delete after 30 days.
* **On-Premises AD DS Integration:** Cloud-born B2B guests require a physical user object provisioned into on-premises Active Directory Domain Services (AD DS) to receive Kerberos tickets and utilize Windows Integrated Authentication (WIA).

**Exam Traps to Memorize**

* **The Out of Scope Deletion Trap:** Unassigning a user from the cross-tenant sync scope triggers an automatic soft delete in the target tenant.
* **The Block Sign-in Distinction:** Disabling a user in the source tenant (setting `accountEnabled = false`) does not delete them in the target tenant; it simply blocks sign-in at the target.
* **The Writeback Trap (ECMA vs MIM):** You cannot use the Entra ECMA provisioning agent or Entra Connect to write cloud users into AD DS to avoid sync loops. You must use **Microsoft Identity Manager (MIM)**.

---

### **8. Auditing & Compliance**

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
