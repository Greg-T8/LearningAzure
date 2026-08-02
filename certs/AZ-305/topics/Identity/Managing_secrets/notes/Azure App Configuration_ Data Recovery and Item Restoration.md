# Azure App Configuration: Data Recovery and Item Restoration

It is very easy to select "Soft-delete recovery" because, in many other Azure services (like Azure Key Vault or Azure Storage), soft-delete is the exact mechanism used to recover individual items. However, Azure App Configuration handles item-level recovery differently, which is what this question is testing.

Here is a detailed breakdown of why your answer was incorrect, how App Configuration manages data recovery, and what you must remember for the AZ-305 exam:

**1. Why "Soft-delete recovery" is incorrect**
In Azure App Configuration, the **soft-delete feature applies to the entire configuration store resource**, not to individual key-value pairs [1]. If an administrator accidentally deletes the entire App Configuration store, soft-delete allows you to recover the whole store (along with all its data) during a configurable retention period [2]. However, if the store is active and you only delete a single key-value, the soft-delete feature does not apply.

**2. Why "Point-in-time key-values" is the correct answer**
To recover a specific key-value that was deleted or modified within an active store, you must use the **Point-in-time key-values** feature [3]. 
Azure App Configuration automatically maintains a continuous record of all changes made to your key-values, creating a historical timeline [3]. Using the Point-in-time feature, you can effectively "time-travel" backward by selecting a specific date and time (such as 24 hours ago) to view the store exactly as it existed then [3, 4]. 

If you select a time before the key was deleted, the portal will show a green plus sign (+) next to the key, indicating that it existed at your selected time but does not exist currently [5]. You can then restore that specific key-value back into your active configuration [5].

**Architectural Takeaways for the AZ-305 Exam:**
When designing recovery strategies for Azure App Configuration, memorize these distinct boundaries:
*   **Store-Level vs. Item-Level:** Use **Soft-delete** when the *entire store* is deleted [2]. Use **Point-in-time key-values** when an *individual key-value* or feature flag is accidentally deleted or misconfigured [3].
*   **Retention Limits:** The amount of time you can "time-travel" backward using Point-in-time key-values depends on your store's pricing tier. The revision history is stored for **7 days** in the Free and Developer tiers, and for **30 days** in the Standard and Premium tiers [3, 6]. 
*   **Snapshots vs. Point-in-Time:** Do not confuse Point-in-time key-values with App Configuration *Snapshots*. Point-in-time is an automatic, continuous history of changes [3]. A Snapshot is a manually created, immutable, named subset of key-values (e.g., `Snapshot_v1.0`) used primarily to guarantee that a specific set of configurations remains safely unchanged during an application deployment [7, 8].