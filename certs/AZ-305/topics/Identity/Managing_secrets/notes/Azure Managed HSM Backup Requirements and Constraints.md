# Azure Managed HSM Backup Requirements and Constraints

It is very easy to assume that Locally Redundant Storage (LRS) would be an invalid choice for such a critical disaster recovery operation, especially since Azure often pushes you toward higher redundancy levels for high availability. However, this question tests a hard technical limitation of the Managed HSM backup process. 

Here is a detailed breakdown of why your answer was incorrect, why immutability breaks the backup process, and what you must remember for the AZ-305 exam:

**1. Why "A storage account with an immutability policy applied" is the correct answer**
While immutable storage (WORM - Write Once, Read Many) is fantastic for regulatory compliance and preventing data tampering, **Azure Key Vault Managed HSM explicitly does not support backing up to storage accounts that have an immutability policy applied** [1]. If you attempt to target an immutable storage account, the backup operation will fail. 

**2. Why "A storage account using standard LRS" is incorrect**
Using a storage account with standard Locally Redundant Storage (LRS) is a fully supported configuration for Managed HSM backups [2, 3]. The backup operation will complete successfully. 

However, there is a difference between what is *supported* and what is *recommended* for disaster recovery. Microsoft recommends that if your region supports it, you should back up your Managed HSM to an Azure Storage account with geo-redundant storage (GRS) enabled [3]. GRS ensures that your backup survives a regional disaster, but LRS is not blocked or unsupported by the platform.

**Architectural Takeaways for the AZ-305 Exam:**
When designing backup and disaster recovery architectures for Azure Key Vault Managed HSM, memorize these requirements:
*   **Unsupported Storage Features:** You cannot use storage accounts with immutability policies applied for Managed HSM backups [1]. 
*   **Authentication Mechanism:** To perform the backup and restore operations securely, you must assign a user-assigned managed identity (UAMI) to the Managed HSM service [4]. This identity must be granted the Storage Blob Data Contributor role on the target storage account [2].
*   **Security Domain Dependency:** The backup you create is encrypted using cryptographic keys associated with your HSM's Security Domain [3]. Therefore, you can only restore this backup into an HSM that shares the exact same Security Domain [3]. If you lose the Security Domain, your backups are entirely useless.
*   **Redundancy Best Practice:** Always design your backup storage account with Geo-Redundant Storage (GRS) to ensure your backup payload survives a primary region failure [3].