# Governing Management Group Creation and RBAC Inheritance Boundaries

This is a classic AZ-305 exam scenario that tests your understanding of the **Azure scope hierarchy**, the direction of **RBAC inheritance**, and **tenant-level hierarchy settings**. 

Here is a detailed architectural breakdown of why a subscription Owner fails to create a management group when this setting is enabled:

### 1. The Default Behavior (No Hierarchy Protection)
By default, Microsoft Entra ID is designed with a highly open self-service model. If no protective settings are configured:
* **Any user in the tenant can create a new management group** [1].
* When they do, the new management group is automatically placed under the Tenant Root Management Group (or a configured default management group) [1].
* The creator is automatically granted the **Owner** role on that specific newly created management group [1]. Under this default state, no pre-existing permissions at the root or management group scope are required [1].

### 2. The "Require Write Permissions" Guardrail
In enterprise environments, allowing any user to create management groups leads to severe sprawl and governance bypasses. To prevent this, a Tenant Root Administrator can enable a hierarchy setting on the Root Management Group [2]:
* This setting is toggled via the **"Require write permissions for creating new management groups"** setting (also called "Permissions for creating new management groups" in the Azure Portal) [3].
* **The New Rule:** Once this setting is turned on, the default open behavior is disabled. To create any new child management group, a user must explicitly possess the **`Microsoft.Management/managementGroups/write`** operation on the **Root Management Group** scope [4].

### 3. Why "Subscription Owner" is Insufficient
Your developer has the **Owner** role, which is a highly privileged role, but it is scoped strictly at the **subscription level** [5, 6]. 

* **No Upward Inheritance:** Azure RBAC permissions only cascade **downward** through the hierarchy (from Management Group \\(\rightarrow\\) Subscription \\(\rightarrow\\) Resource Group \\(\rightarrow\\) Resource) [7, 8]. **Permissions never inherit upward** [9, 10]. 
* **The Boundary Wall:** Because the subscription is a child of the management group hierarchy, having "Owner" rights on a subscription does not grant any privileges at the management group or root level [8-10]. 
* **The Resulting Error:** When the developer attempts to create a new management group, Azure Resource Manager checks the Tenant Root scope for the `Microsoft.Management/managementGroups/write` permission [4]. Since the developer only has permissions inside their subscription container, they are blocked with a "Permission Denied" (403 Forbidden) error.

---

### 🎯 Key Exam Takeaways:
* **Creation vs. Management:** Standard Azure RBAC roles (Owner, Contributor) at the subscription level only allow management *inside* that subscription [5, 8]. They do not allow modifying or building the management group hierarchy above it [9].
* **Root Permissions Required:** If hierarchy protection is enabled, a user needs a role like **Owner**, **Contributor**, or **Management Group Contributor** assigned explicitly at the target parent management group scope (or Root scope) to create a new group [4, 11].
* **Hierarchy Settings Admin:** Managing these restriction toggles themselves requires the specialized built-in role **Hierarchy Settings Administrator** at the Root Management Group level [2, 12, 13].

***

🔍 Since management group governance is highly tested, would you like to review how the default subscription placement setting interacts with this hierarchy protection to ensure new subscriptions don't bypass security policies when they are first provisioned?