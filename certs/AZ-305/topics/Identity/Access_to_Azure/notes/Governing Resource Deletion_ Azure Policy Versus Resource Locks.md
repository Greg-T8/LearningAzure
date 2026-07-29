# Governing Resource Deletion: Azure Policy Versus Resource Locks

Your choice of an **Azure Policy with a Deny effect** is a very common trap on the exam because Azure Policy is the primary tool for enterprise-wide governance and enforcement. However, Azure Policy and Resource Locks operate on completely different mechanics.

Here is a detailed breakdown of why your answer was incorrect and the architectural concepts you need to know:

**1. Why Azure Policy with a "Deny" effect is incorrect**
Azure Policy is designed to evaluate the *state* or configuration of a resource, not the actions performed against it [1]. The `Deny` effect in Azure Policy specifically blocks the **creation or update** of resources that do not match your required compliance rules (for example, stopping someone from deploying a VM to an unauthorized region) [2, 3]. **Azure Policy does not natively intercept or block `DELETE` operations.** 

*(Note: You might have been thinking of an Azure RBAC "deny assignment," which does explicitly block actions. However, you cannot manually create custom deny assignments for arbitrary actions; Azure only creates and manages them automatically for specific system-supported features [4, 5].)*

**2. Why a "Delete" Resource Lock is the correct answer**
To explicitly prevent the deletion of Azure resources, you must use an Azure Resource Manager lock (specifically, a `CanNotDelete` lock) [1, 6]. 
*   **It overrides all privileges:** A resource lock sits outside the standard role-based access control (RBAC) allowance. Even if a user has the highly privileged **Owner** role, the lock will override their permissions and block them from deleting the resource until the lock is explicitly removed [6].
*   **It utilizes inheritance:** Resource locks inherit from parent scopes [1]. Because you applied the lock at the **management group** scope, that single lock automatically cascades down to protect all current and future subscriptions, resource groups, and individual resources within that Sandbox hierarchy [1].

**Architectural Takeaway for the AZ-305 Exam:**
When designing governance solutions, you must differentiate the core tools based on what they evaluate:
*   Use **Azure RBAC** to determine *who* has permission to perform an action [7].
*   Use **Azure Policy** to determine if the resulting *resource state* (configuration) is compliant and allowed during creation or updates [1, 7].
*   Use **Resource Locks** specifically to block authorized users from *accidentally deleting or modifying* control-plane resources [6, 7].