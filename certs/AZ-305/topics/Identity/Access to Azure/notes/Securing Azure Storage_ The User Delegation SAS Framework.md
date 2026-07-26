# Securing Azure Storage: The User Delegation SAS Framework

It is very common to guess a longer timeframe like 30 days for temporary access tokens, but Azure enforces a strict security boundary for this specific type of Shared Access Signature (SAS). 

Here is a detailed breakdown of why your answer was incorrect, how a User Delegation SAS works, and what you should remember for your AZ-305 exam preparation:

**1. The 7-Day Hard Limit**
A user delegation SAS is unique because it has a hard maximum validity interval of exactly **7 days** [1, 2]. Even if you configure a broader SAS expiration policy on the storage account itself, the user delegation SAS cannot exceed this 7-day ceiling [1]. 

**2. Identity-Based Security vs. Account Keys**
To understand why this restriction exists, you have to look at how different SAS tokens are authorized. A standard service SAS or account SAS relies on the storage account's Shared Key, which completely bypasses Microsoft Entra identity evaluation [1]. Because access keys grant broad powers and are difficult to track to a specific user, Microsoft recommends moving away from them [1, 3]. 

A **user delegation SAS**, on the other hand, is secured natively by Microsoft Entra credentials [1, 2]. Because it is tied to a specific user's identity rather than the powerful account key, the strict 7-day limit acts as a built-in security measure to minimize the blast radius if a token is accidentally leaked or misused.

**Architectural Takeaways for the AZ-305 Exam:**
When designing temporary data access solutions for Azure Storage, remember these specific boundaries:
*   **The Recommended Standard:** If you need to provide temporary delegated access to Blob data without distributing storage account keys, always recommend a **user delegation SAS** over a key-signed SAS [3].
*   **The Expiration Rule:** Always remember the hard **7-day** maximum validity limit for user delegation SAS tokens [1, 4]. 
*   **The Shared Key Exception:** If a security requirement forces you to completely disable Shared Key authorization on a storage account (for example, to enforce Conditional Access policies), standard service and account SAS tokens will immediately stop working [1, 5]. However, a user delegation SAS will remain valid because it is authorized through Microsoft Entra ID [1, 5].