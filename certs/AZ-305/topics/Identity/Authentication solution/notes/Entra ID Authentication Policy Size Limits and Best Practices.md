# Entra ID Authentication Policy Size Limits and Best Practices

Your choice of 1 MB is a very reasonable guess because 1 MB is actually the maximum file size limit for a credential photo in Microsoft Entra Verified ID [1]. However, policy objects in Microsoft Entra ID are much smaller.

The correct answer is **20 KB** because the authentication methods policy has a strict maximum size limit of 20 KB [2]. 

Here is a detailed breakdown of how this limit affects passkey deployments and what you should remember for the AZ-305 exam:

**1. The Dedicated Passkey (FIDO2) Allocation**
Historically, all authentication methods in a tenant shared a single 20 KB policy size limit [3]. However, as organizations adopted more complex passkey configurations, they easily approached this limit, which blocked them from saving their configurations [3]. 

To solve this, Microsoft introduced a **dedicated 20 KB allocation specifically for the passkey (FIDO2) policy**, while all other authentication methods continue to share their own existing 20 KB limit [3]. This expanded storage allows administrators to create up to **10 passkey profiles** per tenant, enabling granular targeting (for example, having different attestation requirements for admins versus standard users) [4, 5].

**2. The Impact on Group Targeting**
This 20 KB limit directly influences how you should architect your policy assignments. Every time you add a new targeted group to an authentication method policy or a registration campaign, it consumes part of that 20 KB limit [2, 6]. 

**Architectural Takeaway for the Exam:**
Because assigning too many individual groups can quickly exhaust the 20 KB limit and prevent you from saving your policy, **Microsoft explicitly recommends consolidating your targets into fewer, larger groups** [2, 6]. If a scenario requires you to manage passkey rollouts for dozens of different departments, your design should focus on merging those users into a centralized rollout group rather than targeting dozens of individual department groups [7].