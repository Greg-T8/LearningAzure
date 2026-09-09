# Azure RBAC Inheritance and Subscription Migration Dynamics

This question highlights how **Azure RBAC scope inheritance** behaves when you reorganize your resource hierarchy [1, 2]. 

Here is the technical breakdown of why your answer was incorrect, why the documented answer is correct, and the architectural rules of subscription movement to remember for the AZ-305 exam.

---

### 1. The Core Rule: Inherited Permissions are Dynamic and Scope-Bound
In Azure, role assignments made at a parent management group scope cascade down to child subscriptions via inheritance [1, 2]. However, **this inherited access is not permanently stamped onto the subscription** [3, 4]. It is entirely dependent on the subscription's active location in the hierarchy [4, 5].

* **The Severed Link:** When you move a subscription out from under the "Legacy" management group, **it immediately loses all inherited role assignments** that were applied at that "Legacy" level [6]. 
* **The New Parent:** Once moved, the subscription will only inherit permissions and policies from its new parent ("Cloud-Native") and any of its higher-level ancestors up to the Tenant Root Group [4-6]. 

Because the users only had the "Owner" role via inheritance from the "Legacy" group, they would instantly lose all administrative access the moment the subscriptions were moved [6].

---

### 2. Why the Correct Answer is Right
To ensure users do not lose access during the transition, you must establish their permissions at a scope that survives the move:

* **Direct Subscription Assignment (Preserved):** Unlike inherited assignments, **direct role assignments** (assigned explicitly at the subscription scope) are bound directly to the subscription's metadata [7]. Moving a subscription between management groups within the same tenant has no effect on direct subscription role assignments; they remain completely intact [8].
* **New Target Management Group Assignment (Inherited on Arrival):** If you assign the "Owner" role to the users at the "Cloud-Native" target management group level, they will dynamically inherit "Owner" access to the subscriptions the exact second those subscriptions are moved underneath it [3, 4].

---

### 3. Why Your Answer Was Incorrect
Your proposal was to *"Move the 'Legacy' management group to be a child of the 'Cloud-Native' group first."* This fails on a few technical and logical fronts:

* **It Doesn't Move the Subscriptions:** Moving the management group itself does not satisfy the core migration requirement of moving the *subscriptions* to the "Cloud-Native" group [6]. The subscriptions would still be nested under "Legacy" [9].
* **The Inheritance Break Still Occurs:** If you move the "Legacy" management group under "Cloud-Native" first, and *then* move the subscriptions out of "Legacy" into "Cloud-Native" directly, the inheritance link to "Legacy" is still severed [6]. The users would still lose their "Legacy"-inherited access unless direct or target assignments were made first.
* **Governance Pollution:** Nesting "Legacy" under "Cloud-Native" forces the old legacy resources to inherit all of the new cloud-native policies and RBAC rules [10, 11]. In a real-world migration, this often breaks legacy workloads before you are ready to modernize them [12].

---

### 🎯 AZ-305 Architectural Takeaways:
* **Inherited assignments** are lost when a child resource is moved out of the parent's hierarchy scope [6].
* **Direct assignments** at the subscription level survive management group moves within the same Microsoft Entra tenant [8].
* Always assess both the **pre-move** and **post-move** RBAC/Policy configurations before initiating a subscription migration [12, 13].

***

🔍 Would you like to review how moving a subscription to a completely different *Microsoft Entra tenant* (as opposed to just a different management group) impacts your RBAC roles, Azure Policy, and managed identities?