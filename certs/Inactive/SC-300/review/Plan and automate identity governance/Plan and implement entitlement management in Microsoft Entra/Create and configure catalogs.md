### **I. Prerequisites and Licensing for Catalog Management**

* **Licensing Requirements:**
  * Requires **Microsoft Entra ID Governance**, **Microsoft Entra ID Governance Step Up**, or the **Microsoft Entra Suite**.
  * Basic Entra ID P2 does *not* cover advanced catalog extensibility (like custom Logic App extensions).
* **PowerShell Authorization (The Global Admin Gatekeeper):**
  * **First-Time Consent:** The very first time Microsoft Graph PowerShell is used for catalog management, a **Global Administrator** must authorize it.
  * **Permission Scope:** The Global Admin must check "Consent on behalf of your organization" for high-level scopes like `EntitlementManagement.ReadWrite.All`.
  * **Delegation:** After initial consent, the **Identity Governance Administrator** takes over day-to-day scripting; the Global Admin is no longer required.

> **🚨 EXAM TRAP:** If a scenario states an Identity Governance Administrator is receiving a "Cannot consent on behalf of your organization" error on their *first* PowerShell login, the solution is **not** to assign them a higher role permanently, but to have a Global Admin execute the initial consent.

---

### **II. Catalog Architecture and Structural Configuration**

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

### **III. Administrative Roles and Delegation Strategy**

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

### **IV. Resource Onboarding and The "Two-Pronged" Guardrail**

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

### **V. Configuring External Access at the Catalog Level**

The catalog acts as the ultimate security boundary for B2B guest access.

* **The Gateway Logic Toggle (`Enabled for external users`):**
  * If set to **No**, all external access is immediately blocked.
  * **Override Behavior:** This catalog-level toggle overrides any permissive policies inside its access packages. If the catalog says "No", external users from Connected Organizations cannot see or request *anything* inside it.
* **Auditing Strategy:**
  * Central IT uses the `Enabled for external users: Yes` filter in the admin center to rapidly isolate which departmental "buckets" are exposed to outside partners.
* **Proposed Connected Organizations:**
  * **Trigger:** If a catalog is enabled for external users, AND an access package policy allows "All users," an approval from an unknown domain triggers the **automatic creation of a proposed connected organization** for admin review.

---

### **VI. Automating Catalogs with Custom Extensions**

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

### **VII. Configuration via Graph API and PowerShell**

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
