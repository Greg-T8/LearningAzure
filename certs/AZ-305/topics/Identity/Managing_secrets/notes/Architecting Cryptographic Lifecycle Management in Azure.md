# Architecting Cryptographic Lifecycle Management in Azure

Architecting the key lifecycle in Azure requires designing distinct strategies for creation, rotation, revocation, and recovery. The foundational principle is that you must **perfectly match your lifecycle automation strategy to the specific object type** you are managing [1, 2]. 

Here is how you should architect the key lifecycle across Azure key management solutions:

**1. Object-Specific Automation Mechanisms**
*   **Keys:** Cryptographic keys support **native rotation policies** configured directly on the key vault or Managed HSM. These policies automatically generate new key versions at predefined frequencies [1-3].
*   **Secrets:** Secrets do not support native autorotation because Azure does not inherently know how to update the target system (like a database). Instead, you must architect an event-driven workflow using **Azure Event Grid and Azure Functions** [1, 2, 4]. Event Grid detects a near-expiry status and triggers a Function that connects to the target service, updates the credential, and saves the new value back to Key Vault [4, 5]. To preserve availability, implement a **dual-credential rotation pattern** [2].
*   **Certificates:** Certificates support **automatic renewal** before expiration through native integrations with partnered Certificate Authorities (like DigiCert and GlobalSign) or via self-signed certificate regeneration [1, 2, 6, 7].

**2. Rotation Policies and Constraints**
When configuring native key rotation policies, you must account for platform limitations:
*   **Minimum intervals:** An automatic rotation policy cannot mandate that new key versions be created more frequently than **once every 28 days** [8]. 
*   **Version limits:** If you are using Azure Key Vault Managed HSM, you must account for the hard ceiling of **100 versions per key** [9]. Every time a key rotates, the new version counts toward this limit [9].
*   **External Key Management:** If your architecture uses Managed HSM external key management (preview) to keep key material in an on-premises HSM, **rotation is strictly manual and operator-driven** [10]. You must coordinate rotation by creating the new key in your external HSM, then creating a new key version in Managed HSM that points to the new external key identifier [10, 11].

**3. Data Rewrapping and Compromise Response**
Architecting the lifecycle also means understanding how rotation and revocation affect your encrypted data:
*   **How data rewrapping works:** Azure uses envelope encryption. When you rotate a key encryption key (KEK), the service simply re-wraps the dependent data encryption keys (DEKs) with the new key version; the underlying data itself is never re-encrypted [12, 13]. Because this process takes time, **both the old and new key versions must remain enabled** until the rewrapping is complete [12, 13].
*   **Responding to a compromise:** If you suspect a key has been compromised, **always rotate to a new key first** [12, 14]. Reconfigure your dependent services to use the new key before disabling or deleting the old one. If you disable the compromised key immediately, your dependent services go offline, but the data encryption keys remain vulnerable because they haven't been re-encrypted under a safe key [12, 14]. 

**4. Governance and Best Practices**
*   **Enforce expiration:** Cryptographic objects should never be permanent [15]. Use Azure Policy to mandate that all keys, secrets, and certificates have defined expiration dates and maximum validity periods [15, 16]. Cryptographic best practices (such as NIST guidelines) recommend rotating encryption keys at least every two years [17].
*   **Use versioning:** Ensure your client applications automatically reference the latest version of an object (using versionless URIs) so that dependent systems seamlessly pick up rotated assets without requiring code updates [7].
*   **Restrict lifecycle permissions:** Use **Azure RBAC** to strictly control who has the authority to configure rotation policies or perform manual rotation [7]. 
*   **Monitor lifecycle events:** Set up Event Grid notifications for near-expiry alerts and use Azure Monitor to track successful and failed rotation events [4, 18, 19].