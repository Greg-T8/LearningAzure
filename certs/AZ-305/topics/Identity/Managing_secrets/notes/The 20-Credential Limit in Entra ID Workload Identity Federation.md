# The 20-Credential Limit in Entra ID Workload Identity Federation

It is very easy to assume that cloud limits are high (like 100) or that the platform evaluates a large list of rules from top to bottom. However, this question tests a very specific, hard capacity limit in Microsoft Entra ID regarding how trust relationships are mapped without using secrets.

Here is a detailed breakdown of why your answer was incorrect, the mechanics of workload identity federation, and what you must remember for the AZ-305 exam:

**1. The Strict Matching Rule (Why your answer was incorrect)**
With standard Federated Identity Credentials (FICs), the trust relationship relies on an exact, case-sensitive match of three components: the **issuer**, the **subject**, and the **audience** [1, 2]. 

Standard FICs do not support wildcard matching [1]. This means that if a developer wants to trust 30 different GitHub repositories—or even 30 different branches or environments within a single repository—they must explicitly create a separate, distinct FIC for every single one of them [3]. Because there is no "top-down evaluation limit" of 10 items, your selected answer was incorrect. 

**2. The Hard Capacity Limit (Why the correct answer is right)**
Because standard FICs require exact 1:1 mapping, they can accumulate quickly. To protect the service, Microsoft Entra ID enforces a hard quota: **you can configure a maximum of 20 federated identity credentials per application or user-assigned managed identity** [1, 4]. 

If a workload requires 21 distinct trust relationships, a single managed identity simply cannot accommodate the request using standard Generally Available (GA) features [5]. 

**Architectural Takeaways for the AZ-305 Exam:**
When designing workload identity federation for at-scale CI/CD environments (like GitHub Actions or Azure Pipelines), memorize these boundaries and solutions:
*   **The 20-FIC Limit:** Always remember the hard limit of 20 FICs per app registration or user-assigned managed identity [1]. 
*   **Scaling via Partitioning (GA Approach):** If a workload genuinely needs to trust more than 20 distinct issuer/subject combinations, the standard architectural solution is to **partition the workload** by creating multiple user-assigned managed identities (or app registrations) and distributing the FICs across them [5].
*   **Scaling via Flexible FICs (Preview Approach):** To solve this scaling bottleneck, Microsoft introduced **Flexible federated identity credentials** (currently in preview) [6]. This feature extends the standard model by allowing a restricted expression language—including wildcards—to match `subject` claims [7, 8]. For example, instead of creating 20 FICs for 20 different branches in a GitHub repository, you can create a single Flexible FIC with a wildcard (e.g., `claims['sub'] matches 'repo:contoso/contoso-repo:ref:refs/heads/*'`) [3, 9]. This allows multiple workflows to be managed under a single credential, drastically reducing management overhead and quota consumption [10].