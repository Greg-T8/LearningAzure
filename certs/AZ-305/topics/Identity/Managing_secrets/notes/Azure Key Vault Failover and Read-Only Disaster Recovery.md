# Azure Key Vault Failover and Read-Only Disaster Recovery

It is easy to assume that a massive regional failure would completely knock out access to a service, or that a failover would restore 100% of the service's functionality. However, Azure Key Vault's Microsoft-managed failover operates under a very specific degraded state to protect data integrity.

Here is a detailed breakdown of why your answer was incorrect, how Key Vault failover functions, and what you must remember for the AZ-305 exam:

**1. The Purpose of Microsoft-Managed Failover (Why your answer was incorrect)**
Stating that the vault becomes "completely inaccessible" is incorrect because it defeats the fundamental purpose of the disaster recovery mechanism. For key vaults deployed in supported paired regions, Azure automatically and asynchronously replicates your vault's contents to the secondary region [1, 2]. In the rare event of a prolonged primary region outage, Microsoft may initiate a failover [1]. The goal of this failover is specifically to ensure your mission-critical applications *can* still access the cryptographic keys and secrets they need to survive the disaster, rather than leaving them completely locked out. 

**2. The Read-Only Limitation (Why the correct answer is right)**
While the failover keeps your applications running, the secondary region does not provide full read-write functionality. After the failover completes, **the key vault operates strictly in read-only mode** [3]. 
*   **What you CAN do:** Your applications can continue to read data and perform cryptographic operations. Supported actions include listing and getting certificates, secrets, and keys, as well as operations like Encrypt, Decrypt, Wrap, Unwrap, Verify, Sign, and Backup [4]. 
*   **What you CANNOT do:** You are absolutely blocked from performing any control-plane management or data-plane write operations. This means **you cannot change key vault properties, modify firewall configurations, or alter access policies** while operating in the secondary region [3]. You also cannot create new keys, generate new certificates, or update secret values.

**Architectural Takeaways for the AZ-305 Exam:**
When designing a highly available secret management solution, you must account for these disaster recovery constraints:
*   **The Write-Access Boundary:** If your application dynamically generates new secrets, or if an administrator needs to grant new access policies during a disaster, relying on Microsoft-managed failover will fail because the secondary vault is read-only [3].
*   **Custom Multi-Region Solutions:** If your business requires full read-write availability during a regional outage, or if your vault is in a region that does not support Microsoft-managed failover (such as regions without pairs), you must design a **custom multi-region solution** [5]. This involves deploying separate, independent key vaults in multiple regions, manually syncing them, and handling the application-side failover routing yourself [6]. 
*   **Failover Timing:** Microsoft-managed failover is handled entirely by Microsoft on a best-effort basis, and it can take several hours to trigger after the primary region is lost [7]. It is intended only as a last-resort disaster recovery mechanism, not a rapid high-availability switch.