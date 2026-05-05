**SC-300 Study Review Sheet: Configure and Manage Built-in and Custom Microsoft Entra Roles (Expanded Edition)**

### **1. Architectural Foundations & Access Evaluation**

* **Identity vs. Infrastructure Planes**
  * **Microsoft Entra Roles (Identity Plane):** Manage access to directory resources (users, groups, apps).
    * Managed via the **Microsoft Graph API**, Microsoft 365 admin center, or Entra admin center.
  * **Azure Roles (Resource Plane):** Manage access to infrastructure (VMs, storage, networking).
    * Managed via **Azure Resource Management (ARM)**, Azure portal, and ARM templates.
  * **Exam Trap (Overlapping Access):** By default, Azure roles and Entra roles do not overlap; an Azure Owner cannot manage Entra users.
  * **Scenario Example (Global Admin Elevation):** If a Global Administrator is locked out of an Azure subscription, they can toggle an "elevation" setting. This temporarily grants them the **User Access Administrator** (an Azure role) at the root level across all subscriptions, restoring their infrastructure access.
* **Authentication & Access Token Evaluation**
  * **The `wids` Claim:** During an API call to Microsoft Graph, Entra ID evaluates directory role memberships specifically by looking at the **`wids` claim** (well-known identifiers) within the access token.
  * **Exam Trap (`roles` vs. `wids`):** While the `roles` claim is commonly used for Application Roles, Entra ID specifically relies on the `wids` claim to authorize directory-level API calls. Note that information regarding the `roles` claim is outside the provided sources and should be verified independently.
* **Troubleshooting Detail (CLI Limitations)**
  * Azure roles are fully supported via **Azure CLI**.
  * **Azure CLI is explicitly not supported** for managing Microsoft Entra role assignments.

| Feature Comparison | Microsoft Entra Roles | Azure Roles (Azure RBAC) |
| :--- | :--- | :--- |
| **Primary Scope** | Identity resources (users, groups, apps) | Infrastructure (VMs, Storage, Network) |
| **Management Plane** | Microsoft Graph API | Azure Resource Management (ARM) |
| **Access Decision Point** | Evaluates `wids` claim | Evaluates ARM policies |
| **Azure CLI Support** | **Not Supported** | Fully Supported |

### **2. Custom Role Configuration & Interface Limitations**

* **Prerequisite/Licensing Notes:**
  * Built-in roles are free.
  * Custom roles require a **Microsoft Entra ID P1 or P2 license** for every user assigned.
  * Using Privileged Identity Management (PIM) for just-in-time role activation requires a **P2 license**.
* **Configuration Detail (Baselines):**
  * **Start from scratch:** Provides a blank slate; must manually add permissions.
  * **Clone from a custom role:** Inherits permissions from an existing custom role.
  * **Exam Trap (Cloning):** You **cannot clone a built-in role** (e.g., Global Reader) to use as a baseline template. You must start from scratch and add the permissions manually.
* **Custom Role Interface & Portal Restrictions:**
  * **Current Blades Only:** Custom roles only grant access in the most current app registration blades; legacy blades are unsupported.
  * **App Visibility:** Apps managed via custom roles only appear in the **"All applications"** tab, not the "Owned applications" tab (unless the user is an explicit owner).
* **Troubleshooting Detail (Portal Access Restriction Paradox):**
  * If the *"Restrict access to Microsoft Entra administration portal"* setting is set to **Yes**, it blocks non-admins from the web-based GUI.
  * **Exam Trap:** Custom roles **do not override** this restriction; assigned users will be blocked from the GUI.
  * Built-in roles (e.g., Global Reader) **do override** the restriction.
  * Programmatic access via PowerShell or Graph API is **always permitted**, regardless of this GUI restriction.

### **3. Granular Scopes & Application Delegation**

* **Understanding Resource Scopes:**
  * **Tenant Scope:** Organization-wide authority over all resources of that type.
  * **Resource Scope:** Limits permissions to a **single specific resource** (e.g., one application registration).
  * **Exam Trap (Create Permissions):** You **cannot assign "create" permissions** (e.g., `microsoft.directory/applications/create`) at the resource scope. Creation permissions must be assigned at the tenant scope to be effective.
* **Delegating Enterprise App Assignments:**
  * **Configuration Detail:** Create a custom role with the `microsoft.directory/servicePrincipals/appRoleAssignedTo/update` permission and assign it at the **resource scope** for a specific app.
  * **Scenario Example:** A project lead needs to manage who can access "Contoso Expense Reports" but should not be allowed to change its credentials or proxy settings. Assigning the custom role above at the resource scope ensures least privilege.
* **Application Creation Permissions & Precedence:**
  * Standard users have a default quota of **250 objects** (apps, groups, service principals).

| Permission Attribute | `createAsOwner` | `create` (Custom Role) |
| :--- | :--- | :--- |
| **Ownership Behavior** | Creator is automatically added as first owner. | Creator is **NOT** automatically added as owner. |
| **Quota Impact** | Counts against personal 250-object limit. | **Does NOT count** against personal limit. |
| **Limit Enforcement** | Hard stop at 250 objects. | Stops only at directory-level capacity quota. |
| **Precedence Rules** | Overridden by `create`. | **Takes precedence** if both are assigned. |

* **Exam Trap (Accountability vs Automation):** If an automated service account needs to register thousands of apps, `createAsOwner` will fail at 250. You must assign a custom role with `create` to bypass the limit. Owners can still be manually added later via Graph/PowerShell.

### **4. Application Administration Roles Compared**

* Both roles are highly **privileged** due to **impersonation risk** (adding credentials to an app and acting as the application to elevate privileges).
* Neither role is automatically added as an owner when creating apps.

| Capability | Application Administrator | Cloud Application Administrator |
| :--- | :--- | :--- |
| **Manage App/Enterprise Registrations** | Yes | Yes |
| **Manage Application Credentials** | Yes | Yes |
| **Manage Application Proxy (On-Prem)** | **Yes** | **No** |
| **Recommendation (Least Privilege)** | Use for hybrid apps requiring proxy. | Use for all standard cloud-app admins. |

### **5. Administrative Units (AUs) Architecture**

* **Prerequisite/Licensing Notes:**
  * Creating AUs is available with **Entra ID Free**.
  * Delegating roles scoped to an AU or configuring dynamic membership rules requires **Entra ID P1 or P2**.
* **Configuration Detail (Limits):**
  * AUs **cannot be nested**.
  * An object can belong to a max of **30 AUs**.
* **Role Requirements:**
  * **Privileged Role Administrator** is the least privileged role required to create, delete, or manage AU lifecycle/membership.
  * **User Administrator** is the least privileged role required to enable "My Staff" for AU-scoped managers.
* **The Container vs. Object Distinction:**
  * Role assignments apply to the objects *inside* the container, not the container itself.
  * **Exam Trap (Container Management):** An AU-scoped administrator cannot rename or delete the AU itself; this requires a tenant-scoped Privileged Role Admin.
  * **Exam Trap (Groups in AUs):** Adding a group to an AU brings the *group object* into scope (allowing name/membership edits). It **does not bring the users inside that group into scope** unless those users are also explicitly in the AU.

| Feature Comparison | Regular Administrative Unit | Restricted Management AU |
| :--- | :--- | :--- |
| **Primary Architectural Goal** | Delegate management of a subset of the directory. | Protect highly sensitive objects (e.g., CEO) from unauthorized change. |
| **Tenant-Level Admins (Global Admin)** | Can modify objects inside by default. | **Blocked** from modifying objects inside unless explicitly assigned an AU-scoped role. |
| **Data Security Fallacy** | No data encryption. | **No data encryption** (solely an RBAC scoping tool). |
| **Configuration Immutability** | Can be changed at any time. | Must be set at creation; **immutable**. |

### **6. Governance of Role-Assignable Groups**

* **Prerequisite/Licensing Notes:**
  * Requires **Entra ID P1 or P2**.
  * Requires **Privileged Role Administrator** to create the group.
  * To manage membership via MS Graph, `RoleManagement.ReadWrite.Directory` is required.
* **Structural Limits & Immutability:**
  * Strict limit of **500 role-assignable groups** per tenant.
  * **Exam Trap (Immutability):** The `isAssignableToRole` property can **only be set at creation**. You cannot convert an existing group into a role-assignable group.
  * Group nesting is **not supported**.
  * Membership must be **Assigned**; dynamic membership rules are completely blocked to prevent unauthorized accounts gaining privileged access.
* **Protected User Security Constraints:**
  * Members/owners of these groups become "protected users".
  * **Troubleshooting Detail (Password Resets):** A standard Helpdesk or User Administrator **cannot reset their passwords** or change MFA settings.
  * Only a **Privileged Authentication Administrator** or Global Administrator can reset credentials for these users.

### **7. Specialized System & Infrastructure Roles**

* **Microsoft Entra Domain Name Administrator:**
  * **Core Responsibilities:** Read, add, verify, update, and delete domain names.
  * **Scenario Example (Hybrid Identity):** Officially recognized as the least privileged role to configure federation and manage **Microsoft Entra Connect** synchronization settings.
  * **Troubleshooting Detail (Visibility):** Has directory-wide visibility of users and apps specifically to troubleshoot domain dependencies (like UPN suffixes).
  * **Exam Trap (Comparison):** Differs from *Hybrid Identity Administrator* (who focuses on PHS/PTA sync mechanics).
* **Directory Synchronization Accounts:**
  * **Primary Function:** A highly specialized internal system role used exclusively by the Microsoft Entra Connect service to read on-premises directory sync data.
  * **Exam Trap (Assignment):** This role **should never be manually assigned to human users**.
  * **Interface Limitation:** It is hidden from the standard Entra admin center GUI and only visible via Graph API or PowerShell.
