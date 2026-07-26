# Strategic Policy Scoping in Azure Landing Zones

Your choice of the root management group is a very logical guess because you want the policies to apply broadly to all workloads. However, in the Azure landing zone architecture, assigning policies at the very top of the hierarchy creates governance challenges and violates least-privilege scoping.

Here is a detailed breakdown of why your answer was incorrect and how management group scopes work for your AZ-305 exam preparation:

**1. Why the "root management group" is incorrect**
When you assign an Azure Policy at the root management group, it inherits down to every single management group, subscription, and resource within that Microsoft Entra tenant [1, 2]. If you assign workload policies here, they will inappropriately apply to your Platform (shared services), Sandbox, and Decommissioned management groups. 

Because of this massive blast radius, Microsoft explicitly recommends that you **limit the number of policy assignments at the root management group scope** to avoid having to manage complex policy exclusions at lower levels [3, 4]. Policy assignments at the root should be restricted to absolute "must-have" global requirements with near-zero potential negative effects on operations [1, 5]. 

**2. Why the "Landing zones" management group is correct**
In the Azure landing zone reference architecture, the "Landing zones" management group is specifically designed as the parent node that contains all of your application landing zone child management groups (such as "Corp" and "Online") [6, 7]. 

Because all your application workloads reside under this specific node, it is the designated location to assign **workload-agnostic Azure policies** to ensure that all workloads are secure and compliant [6]. By assigning your universal security and compliance guardrails here, you ensure they automatically apply to all current and future workloads, regardless of their type, while safely excluding your sandbox, decommissioned, and platform resources [6-8].

**Architectural Takeaway for the AZ-305 Exam:**
When designing a management group hierarchy, remember that you should keep the hierarchy reasonably flat (no more than three to four levels) and use management groups primarily for policy and access management, rather than duplicating your organizational HR or billing chart [9, 10]. Always manage policy assignments at the **highest appropriate level** that encompasses the target resources, but no higher, to avoid unintended inheritance across unrelated environments [11].