# Microsoft Entra Cloud Sync Architectural Scale Limits

Your choice of **50,000** was a very reasonable guess because that number represents a different, prominent boundary within Microsoft Entra Cloud Sync: it is the maximum number of **members supported in a single group** [1, 2]. 

However, this question specifically asks about the scale limit for synchronizing an entire *domain*, not the membership cap of a single group.

Here is a breakdown of why your answer was incorrect and the architectural limits you should remember:

**1. The 150,000 Object per Domain Limit**
In Microsoft Entra Cloud Sync, the current scale limit is a maximum of **150,000 objects per domain** [3]. If your on-premises Active Directory domain contains more than 150,000 objects, Microsoft Entra Cloud Sync cannot fully support synchronizing that domain. 

**2. Comparing Cloud Sync to Connect Sync**
This limitation is an important architectural discriminator when deciding whether to migrate from Microsoft Entra Connect Sync to Cloud Sync. While Cloud Sync is strictly capped at 150,000 objects per domain, the legacy Microsoft Entra Connect Sync has an **unlimited** domain scale limit (provided you use a full SQL Server deployment rather than the default SQL Express LocalDB) [1, 3]. 

**Architectural Takeaway for the AZ-305 Exam:**
When evaluating a migration to Cloud Sync, you must carefully assess your directory size against these two distinct boundaries:
*   **50,000:** The maximum number of *members in a single group* supported by Cloud Sync [2].
*   **150,000:** The maximum total number of *objects per domain* supported by Cloud Sync [3]. 

If an exam scenario states that an organization exceeds either of these limits, you cannot recommend a migration to Cloud Sync; you must architect the solution to retain **Microsoft Entra Connect Sync** instead [4, 5].