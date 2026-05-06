### **1. Core Architecture & Hierarchy Constraints**

* **The "Flat" Architectural Design:**
  * Unlike traditional Active Directory Organizational Units (OUs), Microsoft Entra Administrative Units (AUs) do not support a parent-child hierarchy.
  * **Configuration Detail:** AUs are strictly flat containers and **cannot be nested within one another** (e.g., you cannot place a "Seattle" AU inside a "Washington" AU).
  * **Prerequisite Note:** Administrative units are entirely unsupported in Microsoft Entra B2C organizations.
* **Solving Hierarchy Through Overlapping Memberships:**
  * To build matrixed management structures, Entra ID allows overlapping memberships.
  * **Configuration Detail:** A single resource (user, group, or device) can be a member of up to **30 different AUs** simultaneously.
  * **Scenario Example:** A user is placed in a geographical "Seattle" AU (so local regional support can reset their password) and a departmental "Marketing" AU (so a User Administrator can manage their specific business needs). This completely eliminates the need for complex, nested container systems.

### **2. Administrative Scoping Rules & Privilege Boundaries**

* **Container Scope vs. Resource Scope:**
  * **Container Scope:** Grants permissions to manage the **objects contained inside** the boundary, but *not* the container itself. An AU-scoped admin cannot rename or delete the AU.
  * **Resource Scope:** Grants permissions over **the resource itself** (e.g., a specific group), but those permissions strictly stop there and do not extend to the objects within the resource.
* **The "Container vs. Member" Boundary:**
  * **Exam Trap:** Placing a security group (e.g., 'Research-Dept') into an AU only brings the **group object itself** into the management scope.
  * **Troubleshooting Detail:** An AU-scoped User Administrator can modify the group's name and membership list, but they **cannot manage the personal properties of the individual users** within that group (e.g., they cannot reset passwords or modify authentication methods).
  * **Configuration Detail:** To gain the ability to reset those users' passwords, the specific users must be **directly and separately added as members** of that same AU.
* **The Tenant-Wide Protection Rule:**
  * **Exam Trap:** An AU-scoped administrator **cannot reset the password** of a user assigned an organization-wide role (e.g., Exchange Administrator).
  * The system prioritizes protecting the privileged account over the localized management boundary to prevent an elevation of privilege.
  * **Troubleshooting Detail:** Only a Global Administrator or Privileged Authentication Administrator can reset these credentials.
* **Custom Role Requirements:**
  * AUs are strictly limited to holding only **users, groups, or devices**; they cannot contain applications.
  * **Configuration Detail:** To assign a custom role at the scope of an AU, the custom role's definition **must include at least one permission relevant to users, groups, or devices**.

### **3. Specialized AUs: Restricted Management**

* **Primary Goal:** Specialized security boundaries designed to protect your organization's most sensitive objects (e.g., CEO, compliance data).
* **Architecture & Default Access:** They intentionally break standard directory-wide inheritance rules, blocking default tenant-level administrators (including Global Administrators) from modifying the objects inside.
* **The Immutability Rule:**
  * **Configuration Detail:** Enforced by the `isMemberManagementRestricted` property in the Microsoft Graph API.
  * **Exam Trap:** The restricted setting **must be applied at the exact time of creation and cannot be changed afterward**. You cannot convert a standard AU into a restricted one, nor can you disable the restriction later.
* **Global Admin Overrides:**
  * **Troubleshooting Detail:** If a Global Administrator attempts to reset the CEO's password using their standard tenant-wide powers, it will fail.
  * To access the objects inside, the Global Administrator must explicitly assign themselves a scoped role directly to that specific Restricted Management AU, ensuring an auditable trail is created.
* **Governance Blockades & Supported Objects:**
  * **Exam Trap:** Resources placed inside are explicitly **blocked** from PIM, Entitlement Management, Lifecycle Workflows, and Access Reviews.
  * Unlike standard AUs, they explicitly **cannot** contain Microsoft 365 groups, Mail-enabled security groups, or Distribution groups.

| Feature Comparison | Standard Administrative Unit | Restricted Management AU |
| :--- | :--- | :--- |
| **Max per Tenant** | No Limit | **Strict limit of 100** |
| **Supported Objects** | Users, Groups (All types), Devices | Users, Devices, **Standard Security Groups only** |
| **Tenant Admin Access** | Inherited by default | **Blocked** |
| **Governance Features** | Not Supported | **Explicitly Blocked** |
| **Immutability** | Can be modified | **Immutable** (`isMemberManagementRestricted`) |

### **4. Specialized AUs: Dynamic Membership**

* **Strict Object Segregation:**
  * **Exam Trap:** A dynamic AU can only contain **one type of object at a time** (users OR devices). It is not possible to mix them.
  * **Scenario Example:** To dynamically populate based on the "Sales" department attribute, you must create two completely separate dynamic AUs: one for Sales users, and another for Sales devices.
* **Group Restrictions:**
  * **Exam Trap:** You **cannot dynamically add groups** to an administrative unit.
* **Dynamic Rule Limits:**
  * **Configuration Detail:** The rule syntax for a dynamic AU is capped at a strict maximum limit of **3,072 characters**.

### **5. Managing Non-Human Identities (Service Principals)**

* **The Blind Spot:**
  * **Troubleshooting Detail:** By default, service principals and guest users **do not receive default directory read permissions**. If assigned a User Administrator role scoped to a specific AU, they remain fundamentally unable to perform administrative actions because they are completely blind to the users inside that unit.
* **The Tenant-Scope Resolution:**
  * **Configuration Detail:** A strict two-part setup is required to fix this:
        1. Assign the management role (e.g., User Administrator) at the **AU scope**.
        2. Assign the **Directory Readers** role to grant baseline read access.
  * **Exam Trap:** Microsoft Entra ID **currently does not support assigning directory read permissions scoped to an administrative unit**; the Directory Readers role must be assigned at the **tenant scope**.

### **6. Interface, Tooling & Portal Limitations**

| Admin Interface | Support / Limitations for AU-Scoped Admins |
| :--- | :--- |
| **Microsoft 365 Admin Center** | Fully permitted to manage properties and membership of **Microsoft 365 groups**. Managing Security Groups is **explicitly not supported**. License Admins are fully supported in managing user licenses here. |
| **Microsoft Entra Admin Center** | Required to manage **Security Groups**. Cloud Device Admins can manage devices here. |
| **Microsoft Graph / PowerShell** | Required to manage **Security Groups**. |
| **Microsoft Intune** | **Managing devices in Intune is not supported at this time** using an AU scope. Requires Intune RBAC. |

### **7. Audit Logging & Diagnostics**

* **Exam Trap:** You must distinguish between managing the *container* versus managing *administrative power*.
  * **`AdministrativeUnit` Category:** Tracks lifecycle and structural/membership changes made directly to the container itself (e.g., logging `IsMemberManagementRestricted = true`, adding a user, removing a member).
  * **`RoleManagement` Category:** Assigning an administrator a role scoped to an AU **does not** fall under the AdministrativeUnit category. Assigning or removing a User Administrator strictly for an AU is recorded under RoleManagement.

### **8. Licensing Requirements**

| Feature | Licensing Requirement | Implementation Notes |
| :--- | :--- | :--- |
| **Basic AU Creation & Manual Members** | **Microsoft Entra ID Free** | Creating AUs and manually adding members is fully supported under the Free tier. |
| **Administrator scoped to an AU** | **Microsoft Entra ID P1 / P2** | The *administrator* who is assigned the scoped role requires P1. The everyday standard users inside the container only need Free licenses. |
| **Members of a Dynamic AU** | **Microsoft Entra ID P1 / P2** | Required for ***every single user*** who becomes a member of a dynamic AU. |

### **9. Critical Service Limits Glossary**

* **30:** Maximum number of different Administrative Units that a single Microsoft Entra resource (user, group, or device) can be a member of simultaneously.
* **100:** Strict maximum number of Restricted Management Administrative Units allowed within a single Microsoft Entra tenant.
* **500:** Maximum number of role-assignable groups a single tenant can have.
* **999:** Maximum number of users that the interface is designed to display per administrative unit when a manager logs into the 'My Staff' portal.
* **2,048:** Maximum number of group memberships (combining direct and nested) a single user or group can hold before access issues might block them.
* **3,072:** Maximum number of characters allowed in the rule syntax for a dynamic membership group or dynamic administrative unit.
