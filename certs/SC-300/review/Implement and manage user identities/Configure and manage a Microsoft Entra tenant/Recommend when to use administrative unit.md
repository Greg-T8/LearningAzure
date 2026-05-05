**SC-300 Study Review Sheet: Recommend When to Use Administrative Units (Expanded Edition)**

### **1. Core Architectural Concepts & Scoping Mechanics**

* **Architectural Definition:** An Administrative Unit (AU) is a Microsoft Entra resource acting as a management container designed specifically to hold a collection of users, groups, or devices.
* **The Principle of Least Privilege & Scope Overlap:** Microsoft Entra RBAC operates on the rule that permissions are additive, and the broadest scope always applies.
  * **Exam Trap (Redundant Assignments):** Overlapping, narrower scopes do not restrict broader ones. If a user holds the Helpdesk Administrator role at the Tenant scope, assigning them the same role at the AU scope is entirely redundant. They retain overarching directory-wide powers, completely defeating the AU's localized security boundary.
* **Scenario Example (Delegating Password Resets):** An organization needs a department lead to reset passwords strictly for the "Sales" department.
  * *Solution:* Place all Sales users into an AU, and assign the lead the built-in **Helpdesk Administrator** role at the AU scope.
  * *Why built-in roles?* This avoids the administrative overhead of building, testing, and maintaining custom permission schemas from scratch.

| Delegation Scenario | Recommended Scope | Rationale & Mechanics |
| :--- | :--- | :--- |
| **Manage a single application** (e.g., Procurement Pro) | **Resource (Object) Scope** | Limits authority to a single, specific resource. Prevents access to other apps. |
| **Manage a collection of users/groups** (e.g., Sales Dept) | **Administrative Unit Scope** | Restricts a tenant-wide role to a specific subset of the directory container. |
| **Manage all resources organization-wide** | **Tenant Scope** | Grants permissions over all relevant resources in the entire organization. |

### **2. The Management Boundary: Container vs. Members**

* **The Group Scoping Rule:** There is a strict boundary between managing a group object and managing the individual users within that group.
  * Placing a group into an AU brings *only the group itself* into the management scope.
  * **What is allowed:** The AU-scoped administrator can change the group's name, description, and membership list (adding/removing people).
  * **Exam Trap (User Properties):** The scoped administrator **cannot manage the properties of the individual users** inside the group (e.g., resetting passwords or updating job titles).
  * **Required Configuration:** To manage the users themselves, those individual users must be separately and directly added as members of the AU.
* **Groups Administrator Constraints at AU Scope:**
  * **Creation Limits:** They lack directory-level authority and must instantiate any new group directly within their assigned AU container.
  * **Exam Trap (Tenant Authority):** They cannot manage, modify, or create groups outside the AU, nor can they manage overarching tenant-level group settings (e.g., expiration rules or naming policies).
* **Troubleshooting Detail (Protected Users):** If an AU contains users who are members/owners of a **role-assignable group**, those users are designated as "protected". A standard AU-scoped Helpdesk or User Administrator **cannot** reset their passwords. Only a Privileged Authentication Administrator or Global Administrator has this authority.

### **3. Dynamic Membership in Administrative Units**

* **Configuration Detail:** AUs can automatically populate based on user or device attributes (e.g., `department -eq "Sales"`) via the dynamic membership engine.
* **Exam Trap (The Single Object Type Rule):** A dynamic AU can only contain **one type of object at a time**. You cannot mix users and devices together in the same dynamic AU.
* **Exam Trap (Group Restrictions):** You **cannot dynamically assign groups** to an AU. Dynamic AU rules only apply to users and devices.
* **Troubleshooting Detail (Manual Additions Blocked):** Once dynamic membership is active, all commands to manually add or remove members are **completely disabled** to prevent conflicts. Membership changes require editing the rule syntax.

### **4. Restricted Management Administrative Units**

* **Primary Use Case:** Specialized security containers designed to protect highly sensitive accounts (e.g., the CEO) from unauthorized or unnoticed modifications by breaking default inheritance.
* **Architecture & Blocked Access:** Tenant-level administrators (including Global Administrators) are explicitly blocked from directly modifying the properties of users inside a Restricted Management AU.
  * **Troubleshooting Detail (Error Message):** Attempting an unauthorized change returns: *"This user is a member of a restricted management administrative unit. Management rights are limited to administrators scoped on that administrative unit"*.
* **Exam Trap (Immutability):** The restricted management setting is a permanent security measure. It must be applied at the exact time of creation and is **immutable** (cannot be toggled later).
  * *Why?* Toggling it OFF would instantly strip critical protections; toggling it ON would break existing workflows by locking out current admins.
* **Exam Trap (Governance Blockades):** Users and groups inside a Restricted Management AU **cannot be managed with Microsoft Entra ID Governance features** (PIM, Entitlement management, or Access reviews).
* **Required Configuration & Audit Trail Workflow:**
    1. Global Administrators maintain authority to manage the AU *container* itself (creating/deleting it, adding/removing members).
    2. To reset the CEO's password, the Global Admin must explicitly assign themselves an appropriate role (e.g., User Administrator) scoped strictly to that specific Restricted Management AU.
    3. This forced assignment guarantees the action is recorded as a highly visible, auditable event in the role management logs (under the *RoleManagement* category).

| Feature | Regular Administrative Unit | Restricted Management AU |
| :--- | :--- | :--- |
| **Default Tenant Admin Access** | Automatically inherited (can manage members). | **Blocked** (breaks default inheritance). |
| **Immutability** | Configuration can be changed at any time. | Must be set at creation; permanently locked. |
| **Governance Features (PIM/Access Reviews)** | Fully Supported. | **Explicitly Blocked**. |
| **Container Management** | Managed by Tenant-level Privileged Admins. | Managed by Tenant-level Privileged Admins. |

### **5. Custom Resource Roles vs. Built-in Roles**

* **Scenario Example:** Delegating assignment management for a single enterprise app like "Procurement Pro".
  * **Configuration Detail:** Use a custom role at the **Resource scope** with the highly specific `microsoft.directory/servicePrincipals/appRoleAssignedTo/update` permission.
  * **Exam Trap (Built-in Privileged Roles):** Do not assign built-in roles like **Application Administrator** for this task. They grant dangerous abilities to modify app credentials, delete the app, and present a massive **impersonation risk** (acting as the application's identity).

### **6. Exhaustive Licensing Framework**

| Feature | Licensing Requirement | Implementation Notes |
| :--- | :--- | :--- |
| **Basic AU Creation & Manual Members** | **Microsoft Entra ID Free** | Creating AUs and manually adding users/groups/devices is free. |
| **Delegating Roles at AU Scope** | **Microsoft Entra ID P1 / P2** | The scoped *administrator* requires P1. The standard members inside the AU do not require a premium license for this scenario. |
| **Dynamic Membership (Users)** | **Microsoft Entra ID P1 / P2** | Required for **every unique user** participating. The tenant must own a sufficient total count of P1 licenses to cover all dynamic AU users. |
| **Dynamic Membership (Devices)** | **No premium license required** | Devices populated via dynamic rules are completely exempt from premium licensing. |
| **Assigning Custom Roles** | **Microsoft Entra ID P1 / P2** | Every user assigned a custom role (even at resource scope) requires P1. |

### **7. Critical Service Limits & Constraints**

| Constraint / Feature | Service Limit | Key Details & Exam Traps |
| :--- | :--- | :--- |
| **Memberships Per Object** | **30 AUs** | A single user, group, or device can be a member of no more than 30 different AUs. |
| **Restricted Management AUs** | **100 per tenant** | Strict tenant-wide limit specifically for restricted AUs. |
| **Role-Assignable Groups** | **500 per tenant** | Strict tenant-wide max for groups that can assign roles. (Also the max for manual group expiration policies). |
| **Dynamic AUs & Groups** | **15,000 per tenant** | Combined directory-wide maximum for all dynamic groups and dynamic AUs. |
| **Container Nesting** | **Not Supported** | AUs are strictly flat containers and cannot be nested. |
