# Azure Managed HSM Key Version Constraints and Limits

It is very easy to assume that cloud services offer "unlimited" history that simply ages out over time, especially since many other Azure services (like Log Analytics or Azure Storage) use time-based retention policies. However, cryptographic keys in Azure are versioned objects that do not automatically expire or delete their history based on the number of days passed.

Here is a detailed breakdown of why your answer was incorrect, why 100 versions is the correct limit, and what you must remember for the AZ-305 exam:

**1. Why your answer was incorrect**
In Azure Key Vault and Managed HSM, key versions are never automatically purged after a set number of days (like 30 days). Once a key version is created, it remains stored permanently as part of that key's history so that any data previously encrypted by that older version can still be decrypted. The only way to remove old versions is if the entire key itself is deleted and purged. 

**2. Why "100 versions per key" is the correct answer**
Azure Key Vault Managed HSM enforces a strict, hard capacity limit on how many versions a single key can have. Specifically, **the maximum number of versions per key in a Managed HSM instance is exactly 100** [1, 2]. 

This limit becomes critically important when you configure automated key rotation. Every time a key is rotated—whether manually by an administrator or automatically by a Key Vault rotation policy—a new version of that key is generated, and **each of those new versions counts toward the 100-version limit** [3]. 

**Architectural Takeaways for the AZ-305 Exam:**
When designing key management and rotation strategies, memorize these distinct boundaries:
*   **Managed HSM vs. Standard Key Vault:** While **Managed HSM** enforces a hard limit of **100 versions per key** [1, 2], standard **Azure Key Vault** (the multi-tenant vaults) **does not strictly restrict** the number of versions a key, secret, or certificate can have [4, 5]. 
*   **The Backup Penalty:** Even though standard Key Vault doesn't cap the number of versions, Microsoft explicitly warns against storing an excessive number. If a single key, secret, or certificate accumulates more than **500 versions**, attempting to perform a backup operation on it will result in an error and fail [4, 6].
*   **Rotation Planning:** Because an automatic rotation policy cannot mandate new key versions be created more frequently than once every 28 days [7], a key rotating every 28 days in a Managed HSM will hit its absolute maximum 100-version limit in just under 8 years. You must architect your key lifecycle to account for this hard ceiling.