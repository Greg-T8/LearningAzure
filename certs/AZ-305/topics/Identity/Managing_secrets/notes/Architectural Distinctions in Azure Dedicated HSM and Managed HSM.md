# Architectural Distinctions in Azure Dedicated HSM and Managed HSM

It is completely understandable to mix these two up, as both Azure Cloud HSM and Azure Key Vault Managed HSM offer single-tenant, FIPS 140-3 Level 3 validated hardware security modules. However, this question tests a critical boundary regarding how these services integrate with other Azure products.

Here is a detailed breakdown of why your answer was incorrect, why Managed HSM is the right choice, and what you must remember for the AZ-305 exam:

**1. The Integration Boundary (Why your answer was incorrect)**
The scenario explicitly requires managing keys for encryption at rest in **Azure SQL and Azure Storage**. 
Azure Cloud HSM is an infrastructure-as-a-service (IaaS) offering [1, 2]. While it provides single-tenancy and high compliance, it **does not integrate with other Azure PaaS or SaaS services** for customer-managed keys [1-3]. If you chose Azure Cloud HSM, your Azure SQL and Azure Storage instances would simply be unable to connect to it to retrieve their encryption keys [1, 2].

**2. The PaaS Integration and Security Domain (Why the correct answer is right)**
**Azure Key Vault Managed HSM** is the correct answer because it natively integrates with Azure PaaS services like Azure SQL, Azure Storage, and Azure Information Protection to supply customer-managed keys for data encryption at rest [4, 5]. 

Additionally, Managed HSM satisfies the other strict requirements of the scenario:
*   **Single-tenancy and Compliance:** It provides a dedicated, single-tenant HSM pool validated to FIPS 140-3 Level 3 standards [6-8].
*   **Customer-Owned Root of Trust:** When you provision a Managed HSM, you must download and protect an encrypted blob called a **Security Domain** [9-11]. The Security Domain is cryptographically tied to root of trust keys under your sole control, ensuring that Microsoft has absolutely no access to your cryptographic key material [12].

**Architectural Takeaways for the AZ-305 Exam:**
When designing key management solutions, memorize these boundaries:
*   **Azure Cloud HSM** is for **IaaS and "lift-and-shift"** scenarios [3, 13, 14]. Use it when legacy applications require direct cryptographic APIs like PKCS#11, JCA/JCE, or CNG/KSP [3, 15].
*   **Azure Key Vault Managed HSM** is for **PaaS/SaaS integration** where you need a single-tenant, FIPS 140-3 Level 3 solution [3, 4]. It relies on modern Azure REST APIs rather than legacy cryptographic interfaces [16]. 
*   **Root of Trust:** In Managed HSM, the customer owns the root of trust via the Security Domain. If you lose the Security Domain and its associated private keys, your keys are permanently and irrecoverably lost [4, 5, 17].