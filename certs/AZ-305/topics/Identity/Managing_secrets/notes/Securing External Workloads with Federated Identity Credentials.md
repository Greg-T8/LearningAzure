# Securing External Workloads with Federated Identity Credentials

Great job getting this right! Workload Identity Federation is a highly tested concept on the AZ-305 exam because it represents Microsoft's recommended security pattern for removing stored secrets from external applications. 

Here is a deeper dive into how Federated Identity Credentials (FICs) work, why the 20-FIC limit matters, and what you need to remember for the exam:

**1. What is Workload Identity Federation?**
Typically, if an external software workload (such as a GitHub Actions workflow, an on-premises Kubernetes cluster, or a Google Cloud service) needs to access Azure resources, developers would create a service principal and store a client secret or certificate [1]. These secrets pose a security risk, must be rotated regularly, and can cause service downtime if they expire [1, 2]. 

Workload Identity Federation replaces this secret with a **Federated Identity Credential (FIC)**. The FIC establishes a trust relationship between your user-assigned managed identity (or Microsoft Entra app) and the external Identity Provider (IdP) [2]. The external workload simply exchanges its own native token for a Microsoft Entra access token, eliminating the need to store an Azure credential entirely [1, 2].

**2. The 20-FIC Limit and Strict Matching**
As you correctly identified, there is a hard quota limit of **20 federated identity credentials per application object or user-assigned managed identity** [3, 4]. 

This limit is particularly restrictive using the Generally Available (GA) feature set because standard FICs require an **exact, case-sensitive match** between the token presented by the workload and the FIC configuration [3, 5]. Specifically, it checks three claims:
*   **Issuer:** The URL of the external IdP (e.g., `https://token.actions.githubusercontent.com`) [6].
*   **Subject:** The specific identifier of the external workload [6]. Standard GA FICs **do not support wildcard characters** [7, 8]. 
*   **Audience:** The intended audience of the token [6].

Because wildcards are not allowed in the GA feature set, if you have 30 different branches or environments in a single GitHub repository that all need access, you would need 30 distinct FICs. This immediately violates the 20-FIC maximum [5, 7].

**3. How to scale beyond the limit**
If a workload requires more than 20 trust relationships, you have two architectural choices:
*   **Partitioning (The GA Approach):** You must partition the workload by creating multiple user-assigned managed identities (or app registrations) and distributing the FICs across them [7].
*   **Flexible FICs (The Preview Approach):** To address this exact scaling bottleneck, Microsoft introduced **Flexible federated identity credentials** (currently in preview). This allows administrators to use a restricted expression language with wildcard matching on the subject claim (for example: `claims['sub'] matches 'repo:contoso/contoso-repo:ref:refs/heads/*'`) [5, 9, 10]. This allows a single Flexible FIC to cover many scenarios, significantly reducing management overhead [11].

**Architectural Takeaways for the AZ-305 Exam:**
When designing secretless architectures, memorize these rules:
*   **Azure-to-Azure vs. External-to-Azure:** If an Azure-hosted service needs to access another Azure service, use a standard **Managed Identity** [12]. If a workload runs *outside* of Azure (GitHub, AWS, GCP, Kubernetes) and needs Azure access, use **Workload Identity Federation** [12, 13].
*   **Required Audience:** When configuring the FIC for the Microsoft Entra ID global service, the audience claim must always be set exactly to **`api://AzureADTokenExchange`** [6, 14]. 
*   **User-Assigned Only:** You can only use **user-assigned managed identities** (or app registrations) for federated identity credentials. System-assigned managed identities are not supported [14].