# Azure Management Group Subscription Move Permission Standards

Your answer was incorrect because it misapplied the **Tenant Root Group exception** to a move between two non-root management groups [1, 2]. 

Here is a detailed breakdown of how Azure checks permissions during a subscription move, why all three scopes require write access in this scenario, and the specific exception rule you need to know for the AZ-305 exam.

---

### 1. The Three-Scope Rule for Moving Subscriptions
To move an existing Azure subscription from one management group to another, Azure Resource Manager (ARM) evaluates permissions across **three distinct layers** in the hierarchy [3, 4]:

1. **Child Subscription:** Requires write permission on the subscription object itself (`Microsoft.Management/managementGroups/subscriptions/write`) along with role assignment permissions [3-5].
2. **Target Parent Management Group:** Requires write access on the destination group (`Microsoft.Management/managementGroups/write`) to allow adding the subscription under it [2, 3, 5].
3. **Current Parent Management Group:** Requires write access on the source group (`Microsoft.Management/managementGroups/write`) to allow detaching/removing the subscription from its current parent [2, 3, 5].

---

### 2. Why Your Answer Was Incorrect (The Root Group Exception Misunderstanding)
Your answer assumed that the move was exempt from source parent permissions. 

Azure *does* have an exception for root move operations, but it is strictly limited:
* **The Root Exception:** Permission requirements on the parent scope are bypassed **only if the current parent or the target parent IS the Tenant Root Management Group itself** [1, 2]. Because the Tenant Root Group is the default landing spot for all new subscriptions, Azure allows items to be moved to or from the Tenant Root Group without requiring explicit write permissions at the root scope [1, 2].
* **The Scenario Setup:** In the quiz question, the subscription is being moved from **Management Group A** to **Management Group B**. Both are child management groups under the root [1, 2]. 
* **The Result:** Because **Management Group A** is a custom management group and not the Tenant Root Group, the Root Group exception does **not** apply [1, 2]. You must have write access on Management Group A to remove the subscription from it [2, 3, 5].

---

### 🎯 Key Exam Takeaways:
* **Standard Moves (Non-Root to Non-Root):** Must have write permissions on **Child**, **Target Parent**, and **Current Parent** [2, 3, 5].
* **Moves To/From Tenant Root:** You do **not** need write access on the Tenant Root Group itself when moving items to or from it; you only need permissions on the child item and the custom parent group involved [1, 2].
* **Built-in Roles:** Roles that grant management group write permissions include **Owner**, **Contributor**, and **Management Group Contributor** [2, 3].

---

⚙️ Would you like to review how inherited RBAC roles and Azure Policy assignments behave (or get re-evaluated) immediately after a subscription is moved to its new parent management group?