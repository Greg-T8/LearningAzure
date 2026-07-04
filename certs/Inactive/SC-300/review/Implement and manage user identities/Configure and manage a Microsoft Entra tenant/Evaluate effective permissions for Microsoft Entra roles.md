### **1. The Mechanics of Access Evaluation & Token Authorization**

* **The Microsoft Entra Access Evaluation Flow:** Microsoft Entra ID uses a strict sequence behind the scenes to verify administrative permissions when an API call is made:
    1. **Token Acquisition:** The user (or service principal) acquires an access token to the Microsoft Graph endpoint.
    2. **The API Call:** The user makes an API call to Entra ID via Microsoft Graph using the issued token.
    3. **Evaluating the `wids` Claim:** Entra ID evaluates role memberships based specifically on the **`wids` claim** contained within the token, which holds the role membership identifiers.
    4. **Action Verification:** Entra ID checks if the specific action requested is included within the permissions of the roles the user holds for that resource.
    5. **Final Authorization:** Access is either granted or denied based on the evaluation.
* **Troubleshooting Detail (Stale Tokens):** Because Microsoft Entra ID relies directly on the `wids` claim inside the active token, if an administrator is unexpectedly denied access right after receiving a new role, their token is stale.
  * *Resolution:* They must acquire a new token (typically by signing out and signing back in) to update the `wids` claim with their new permissions.

### **2. Privileged Identity Management (PIM) and the `wids` Claim**

* **Prerequisite/Licensing Note:** Utilizing PIM for Just-In-Time (JIT) access requires a **Microsoft Entra ID P2** license.

| Assignment State | Token Status | `wids` Claim Status | Key Action Required |
| :--- | :--- | :--- | :--- |
| **Eligible** | Permissions are inactive; user only has the authorized *right* to request access. | **Missing.** The identifier for the privileged role is absent. | User must explicitly activate the role. |
| **Active** | Privileges are temporarily turned on. | **Present.** Session updates, a new token is acquired, and the `wids` claim contains the active role ID. | Can enforce MFA, business justification, or manager approval during activation. |

* **Scenario Example (The Security Reader Exception):**
  * *Configuration Detail:* The **Security Reader** role grants read-only access to PIM, Entra ID Protection, and Defender. They explicitly **cannot make changes** to PIM configurations.
  * *The Override:* However, if they are marked as *eligible* for another role (e.g., Privileged Role Administrator), PIM allows them to use the portal to **activate that additional role**. This updates their token with a new `wids` claim and temporarily elevates their access.

### **3. Decoding Permission Syntax & The Property Set Boundary**

* **REST-Based Schema:** Permissions loosely follow the REST format of Microsoft Graph and are broken into four specific components: `<Namespace>/<ResourceType>/<PropertySet>/<Action>`.
* **Exam Trap (The `standard` Property Set):** The `standard` keyword acts as a strict security boundary. It explicitly prevents administrators from accessing highly sensitive user information during a read action.
* **The `.myOrganization` Tenancy Modifier:**
  * **Exam Trap (Ownership vs. Tenancy):** Do not confuse this keyword with application *ownership*. An Application Owner has inherent rights to manage their specific app without custom roles. The `.myOrganization` keyword strictly restricts a permission to **single-tenant applications** (apps available only to users within your specific Entra organization).
  * *Broad Scope:* `microsoft.directory/applications/allProperties/update` grants update abilities on **both single-tenant and multi-tenant** apps.
  * *Restricted Scope:* `microsoft.directory/applications.myOrganization/allProperties/update` limits power to **only single-tenant** apps.

### **4. Container vs. Resource Scopes: The Membership Trap**

* **Resource Scope Evaluation:** When assigned over a specific resource (e.g., a Microsoft Entra group), the permissions apply strictly to **the resource object itself, and do not extend beyond it**.
  * **Exam Trap (Group Roster vs Members):** The administrator can change the group's name or roster, but these permissions **explicitly do not extend to the individual users** who are members of the group. They cannot reset those members' passwords or change their authentication methods.
  * *Resolution:* To manage the personal properties of the users, the individual users must be directly and separately added as members of an Administrative Unit that the administrator manages.
* **Container Scope Evaluation (Administrative Units):**
  * **Exam Trap:** Assigning a role over an AU grants permissions over the **objects contained inside** the boundary, but *not* on the container itself.
  * **Configuration Detail:** AUs can only contain users, groups, or devices. Therefore, to assign any custom role at the scope of an AU, **the custom role's definition must include at least one permission relevant to users, groups, or devices**.
* **AU Membership Transition Mechanics:**
  * *Configuration Detail:* If you change an AU's membership type from "Dynamic" to "Assigned," the **current members remain intact** (they are not wiped out).
  * *Exam Trap:* Because dynamic AUs cannot contain groups, flipping the AU back to "Assigned" automatically lifts this restriction, meaning the **ability to add groups is enabled immediately**.

### **5. Evaluating Restricted Management AUs (RMAUs) & Global Admins**

| Access Boundary | Entra ID Objects inside RMAU | Microsoft 365 Services (e.g., Exchange) inside RMAU |
| :--- | :--- | :--- |
| **Global Admin (Tenant Scope)** | **Blocked.** Cannot reset passwords, delete users, or modify Entra attributes. | **Allowed.** Can modify email and mailbox settings. |
| **Global Admin (AU Scope)** | **Allowed.** Must explicitly assign themselves a scoped role over the RMAU container. | **Allowed.** |

* **Scenario Example (Allowed Tenant Actions):** Despite the RMAU lock on Entra properties, tenant-level admins can still assign licenses, update usage locations, apply Intune device policies, add the users to standard Entra groups, and read standard properties (like UPN or photo).
* **Exam Trap (Custom Security Attributes):** Do not confuse RMAU restrictions with Custom Security Attributes. **By default, Global Administrators do not have permissions to read, define, or assign custom security attributes**. This is an inherent limitation of the Global Admin role itself, regardless of whether an RMAU is used. They must explicitly assign themselves an Attribute Administrator role.

### **6. Delegating Application Administration & Provisioning**

* **Gallery Apps vs. Custom Apps:**
  * `microsoft.directory/servicePrincipals/create` only grants the baseline ability to register generic service principals.
  * **Configuration Detail:** To deploy pre-built templates from the Microsoft Entra Gallery (e.g., Salesforce), the exact permission required is **`microsoft.directory/applicationTemplates/instantiate`**.
* **Delegating Enterprise App Provisioning:**
  * `microsoft.directory/servicePrincipals/synchronizationCredentials/manage` authorizes managing the **OAuth bearer token** and provisioning secrets.
  * **Troubleshooting Detail (The UI Read Requirement):** Having write permission is not enough. **Performing any write operation through the UI also requires baseline read permissions** (e.g., `.../synchronization/standard/read`) to actually view the provisioning page in the portal.
  * **Configuration Detail (Setting Scopes):** To set the provisioning scope to "all users and groups," an admin must possess **both** the `synchronizationJobs/manage` **and** `synchronizationCredentials/manage` permissions simultaneously.

### **7. Overcoming Non-Human Identity Visibility Gaps**

* **The Blind Spot:** Regular member users can read basic directory information by default. However, **service principals and guest users do not receive these default directory read permissions**.
* **Troubleshooting Detail:** Even if you assign a service principal the 'User Administrator' role scoped to an AU, it cannot perform actions because it is completely blind to the users inside.
* **The Resolution:** You must assign the **Directory Readers** role to the service principal.
* **Exam Trap (Scope Limitation):** Microsoft Entra ID **currently does not support assigning directory read permissions scoped to an administrative unit**. The Directory Readers role must be assigned at the **tenant scope**.

### **8. Specialized Quotas & Licensing Requirements**

| Feature | Quota / Limit | Licensing Requirement |
| :--- | :--- | :--- |
| **Built-in Roles** | N/A | **Microsoft Entra ID Free** |
| **Custom Roles (Definitions)** | **100** max per tenant | **Microsoft Entra ID P1** (for *every* assigned user) |
| **Custom Role (Assignments)** | **150** max per security principal | **Microsoft Entra ID P1** |
| **Administrative Unit Scoped Roles** | N/A | **Microsoft Entra ID P1** (for the assigned admin) |
| **Dynamic AU Members** | Combined 15,000 max per tenant | **Microsoft Entra ID P1** (for *every* dynamic user) |
| **Role-Assignable Groups** | **500** max per tenant | **Microsoft Entra ID P1 / P2** |

* **Exam Trap (Role-Assignable Groups & Governance):** To prevent unauthorized elevation of privilege, the membership type for a role-assignable group **cannot be a Microsoft Entra dynamic group**; it must strictly be "Assigned". The `isAssignableToRole` property is immutable and **must be enabled at the exact time the group is created**. Group nesting is completely unsupported.
