# Distinguishing Role Assignments from Role Definitions in Azure RBAC

It is extremely common to mix up these two permissions because they look almost identical and both deal with the Azure Role-Based Access Control (RBAC) system. However, Azure enforces a strict architectural boundary between managing *access* and managing the *roles themselves*.

Here is a detailed breakdown of why your answer was incorrect and the terminology you must master for the AZ-305 exam:

**1. Why `roleAssignments/write` is incorrect**
In Azure RBAC, a **role assignment** is the process of attaching an existing role to a security principal (such as a user, group, or managed identity) at a specific scope to grant them access [1]. 

The permission `Microsoft.Authorization/roleAssignments/write` strictly allows a user to create these assignments [2]. In other words, it allows them to take a role that already exists and assign it to someone else. It does **not** grant the power to build, edit, or delete the underlying roles themselves.

**2. Why `roleDefinitions/write` is correct**
A **role definition** (often just called a "role") is the actual blueprint—the specific collection of `Actions`, `NotActions`, `DataActions`, and `NotDataActions` that dictate what operations are allowed [3, 4]. 

When you design a custom role, you are creating a new role definition object. Therefore, the specific control-plane permission required to create, update, or delete a custom role is `Microsoft.Authorization/roleDefinitions/write` [5, 6]. 

**3. The `AssignableScopes` Requirement**
The question also highlights an important security constraint regarding where this permission must be applied. When building a custom role, you must define its `AssignableScopes` (the management groups, subscriptions, or resource groups where this role is allowed to be used) [7]. To successfully create or update the custom role, the user performing the action must hold the `roleDefinitions/write` permission on **every single scope** listed in that `AssignableScopes` array [5, 6]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing delegation and RBAC administrative boundaries, always separate these two concepts:
*   **`roleAssignments/*`** = Managing **who** has access (delegating existing roles to users).
*   **`roleDefinitions/*`** = Managing **what** the roles are (creating, editing, or deleting the custom role blueprints).