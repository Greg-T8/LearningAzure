# Modern Identity Provisioning: The Shift to Cloud Sync

Your choice of **"Enable Group Writeback v2"** was a very logical guess because that feature was originally designed to do exactly what the question asks. However, the identity synchronization architecture has recently changed.

Here is a detailed breakdown of why your answer was incorrect and what you should know for your architectural designs:

**1. The Deprecation of Group Writeback v2**
Historically, administrators could use the "Group Writeback v2" preview feature within Microsoft Entra Connect Sync to provision cloud-created security groups back to their on-premises Active Directory [1, 2]. However, Microsoft has officially **deprecated Group Writeback v2**, and it is no longer supported after June 30, 2024 [1, 3, 4]. Because the feature is retired, you cannot recommend enabling it for a new deployment.

**2. The Shift to Microsoft Entra Cloud Sync**
To replace that deprecated feature, Microsoft introduced **Group Provision to AD** natively within **Microsoft Entra Cloud Sync** [4, 5]. Therefore, if you need to provision cloud security groups to your on-premises Active Directory Domain Services (AD DS) today, the recommended and supported path is to migrate that specific synchronization task to Cloud Sync [3, 4]. 

**3. Architectural Flexibility (Side-by-Side Coexistence)**
Microsoft recognizes that not every organization is ready to completely replace their existing Microsoft Entra Connect Sync server. If you still need Connect Sync for other advanced synchronization tasks, you are allowed to **run Microsoft Entra Cloud Sync side-by-side with Microsoft Entra Connect Sync** [4, 5]. In this hybrid setup, you can leave Connect Sync handling your traditional AD-to-cloud user sync, while Cloud Sync is configured strictly to handle the provisioning of your cloud security groups back to on-premises AD DS [4, 5].

**Architectural Takeaway for the Exam:**
When designing group synchronization, remember this hard boundary: 
*   If you need to write back **Microsoft 365 groups**, you can still use the legacy **Group Writeback v1** in Microsoft Entra Connect Sync [6, 7].
*   If you need to write back **cloud-created security groups**, you must use **Microsoft Entra Cloud Sync** [4, 8].