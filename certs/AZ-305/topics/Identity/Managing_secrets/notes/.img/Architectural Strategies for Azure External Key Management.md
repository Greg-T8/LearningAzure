# Architectural Strategies for Azure External Key Management

It is very easy to select Azure Dedicated HSM in this scenario, as it provides a single-tenant, bare-metal hardware security module. However, this question tests a very strict boundary regarding physical data sovereignty and the specific feature sets of Azure Key Vault Managed HSM.

Here is a detailed breakdown of why your answer was incorrect, how the new External Key Management feature works, and what you must remember for the AZ-305 exam:

**1. The Physical Location Constraint (Why your answer was incorrect)**
While Azure Dedicated HSM gave customers complete administrative control over a dedicated physical appliance, that appliance was still physically racked and hosted **inside Microsoft Azure datacenters**. Therefore, it fundamentally violates the regulatory requirement that cryptographic material must never physically reside on Microsoft infrastructure. 

Additionally, as an architect taking the AZ-305 exam, you must know that **Azure Dedicated HSM is retiring**; Microsoft is no longer accepting new customer onboardings for it, making it an invalid architectural recommendation for new deployments [1-3].

**2. Managed HSM External Key Management (Why the correct answer is right)**
The scenario states the enterprise is already using the Azure Key Vault Managed HSM service. To satisfy the strict regulatory or digital-sovereignty requirement that key material never touches Microsoft infrastructure, you must use **Managed HSM External Key Management** [4-6].

External Key Management allows Managed HSM to act as the front door for your cloud applications, but it delegates the actual cryptographic operations to a customer-run External Key Management (EKM) Proxy connected to an external HSM that you (or your vendor) operate completely outside of Azure [7-9]. In this architecture, Microsoft manages the access control (via Microsoft Entra ID and Managed HSM local RBAC), but Microsoft never sees or hosts the actual Key Encryption Key (KEK) [4, 10, 11].

**Architectural Takeaways for the AZ-305 Exam:**
When evaluating Managed HSM External Key Management, you must memorize the severe operational tradeoffs it requires. You should only recommend it as a last resort for strict compliance mandates [4]:
*   **No Microsoft SLA:** Because the key material and proxy live in your external data center, there is no Service Level Agreement (SLA) covering the availability of your external keys [12-14].
*   **Limited Cryptographic Operations:** External key management only supports `wrapKey` and `unwrapKey` operations [12, 13]. It does not support signing, verifying, or encrypting/decrypting directly [12].
*   **Immutable Key Types:** A key's status as a Managed HSM key or an external key is fixed at creation [15, 16]. You cannot convert or migrate an existing Managed HSM key into an external key [16].