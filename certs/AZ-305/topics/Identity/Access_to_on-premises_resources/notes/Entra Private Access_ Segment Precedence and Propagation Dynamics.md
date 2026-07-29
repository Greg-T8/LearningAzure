# Entra Private Access: Segment Precedence and Propagation Dynamics

It is completely understandable why you might think Quick Access would take priority, especially if it was working before the new per-app segment was introduced. However, Microsoft Entra Private Access enforces a very specific set of rules for overlapping segments and configuration propagation.

Here is a detailed breakdown of why your answer was incorrect and the architectural rules you must remember for the AZ-305 exam:

**1. The Overlap Rule (Why your answer was incorrect)**
In Microsoft Entra Private Access, if you have a specific per-app enterprise application segment (like `app1.contoso.com`) that overlaps with a broad Quick Access segment (like the subnet `10.1.1.0/24`), **the specific per-app segment always takes priority** [1-3]. 

Azure does not base this priority on whether the destination is an IP address or an FQDN; the rule is simply that the per-app enterprise application takes precedence over Quick Access [1, 3]. Furthermore, Quick Access does not act as a fallback [1, 2]. If a user is not assigned to the new per-app application, they will be denied access to that specific destination, even if they are still assigned to the broader Quick Access app [1, 2]. 

**2. The Client Propagation Delay (Why the correct answer is right)**
Since the scenario states that the users *are* correctly assigned to the new per-app application, the issue is not authorization, but rather synchronization. When you create a new application segment or change user assignments, the changes are not instantly applied to the end-users' devices. You must allow approximately **15 minutes** for the assignment and configuration changes to synchronize and propagate to the Global Secure Access clients [1, 2, 4]. 

**Architectural Takeaways for the AZ-305 Exam:**
When designing a migration from a VPN (using Quick Access) to a Zero Trust model (using per-app segmentation), remember these constraints:
*   **Precedence:** A per-app segment will always override a Quick Access segment [1]. 
*   **No Fallback:** If you pull a resource out of Quick Access into its own per-app enterprise application, you must explicitly assign the required users to that new application. Quick Access will not catch them if they are missing from the new assignment [1, 2].
*   **Timing:** Always factor in up to 15 minutes of propagation time for policy and assignment changes to reach the Global Secure Access clients [1, 2, 4].