# Azure Cloud HSM vs Key Vault for Legacy Migrations

It is very easy to select Azure Key Vault Premium because it provides HSM-protected keys and is often the default choice for high-security key management in Azure. However, this scenario tests your knowledge of **API compatibility** when migrating legacy applications.

Here is a detailed breakdown of why your answer was incorrect and the specific integration boundaries you must remember for the AZ-305 exam:

**1. The API Limitation of Azure Key Vault (Why your answer was incorrect)**
Azure Key Vault (both Standard and Premium tiers) and Azure Key Vault Managed HSM are cloud-native services. They **do not support industry-standard cryptographic APIs like PKCS#11**, JCA/JCE, or CNG/KSP [1, 2]. Instead, they strictly require applications to communicate using the Azure Key Vault REST API or Azure SDKs [1, 2]. Because the scenario explicitly states that the legacy application requires direct PKCS#11 integration and *cannot be refactored* to use REST APIs, Azure Key Vault Premium is not a compatible solution.

**2. The Lift-and-Shift Capabilities of Azure Cloud HSM (Why the correct answer is right)**
**Azure Cloud HSM** is an infrastructure-as-a-service (IaaS) style offering that gives you a dedicated, single-tenant HSM cluster [3, 4]. Crucially, it provides **full native support for the PKCS#11** API, as well as OpenSSL, JCA/JCE, and CNG/KSP [5, 6]. This makes it the exact right solution for "lift-and-shift" migrations where you are moving a legacy on-premises application to Azure Virtual Machines and need it to continue performing cryptographic operations exactly as it did on-premises, without rewriting the application's code [7, 8].

**Architectural Takeaways for the AZ-305 Exam:**
When designing a key management solution, memorize these distinct application boundaries:
*   **Cloud-Native vs. Legacy APIs:** If an application can use modern REST APIs or Azure SDKs, use **Azure Key Vault** (Standard or Premium) or **Managed HSM** [1, 6, 8]. If the application strictly requires legacy cryptographic interfaces like **PKCS#11** and cannot be rewritten, you must choose **Azure Cloud HSM** [6, 8].
*   **PaaS/SaaS Integration:** Be aware that Azure Cloud HSM does *not* integrate with Azure PaaS or SaaS services (like Azure Storage or Azure SQL) for customer-managed encryption keys [4, 8]. It is specifically designed for IaaS scenarios (like Azure Virtual Machines) and custom applications [4, 8].