# Azure Data Recovery and HSM Billing Architecture

It is completely understandable why you selected that answer, as you were likely recalling that Azure App Configuration has a mechanism for recovering individual key-values. However, this question tests your precise knowledge of Azure terminology and the specific architectural and billing constraints of Managed HSM.

Here is a detailed breakdown of why your answer was incorrect, why the correct answer is right, and what you must remember for the AZ-305 exam:

**1. Why your answer was incorrect**
Your chosen answer stated that "Soft-delete in App Configuration applies to individual key-values." As we covered in a previous scenario, this is structurally false. 
In Azure App Configuration, the **soft-delete feature applies exclusively to the entire configuration store resource** [1, 2]. If you delete the whole store, soft-delete allows you to recover it. If you accidentally delete an *individual* key-value pair within an active store, the soft-delete feature does not help you; instead, you must use the **Point-in-time key-values** feature to "time-travel" backward and recover that specific item. Therefore, stating that App Configuration's soft-delete applies to individual keys makes the answer incorrect.

**2. Why the correct answer is right**
The correct answer accurately describes two strict, unique behaviors of Azure Key Vault Managed HSM that differ significantly from other Azure services:
*   **It cannot be disabled:** While standard Azure Key Vaults created before 2020 allowed soft-delete to be optional, Managed HSM enforces strict data protection. Soft-delete is permanently enabled by default and **cannot be turned off** [3-5]. 
*   **You continue to be billed:** This is the most critical differentiator. Azure App Configuration and standard Azure Key Vaults do not charge you for resources while they are in a soft-deleted state [6, 7]. However, Managed HSM is a single-tenant service that reserves dedicated underlying hardware for you [8]. Because these underlying resources remain allocated to your HSM even when it is in a deleted state, **the Managed HSM resource continues to accrue charges at its full hourly rate until it is permanently purged** [5, 9, 10].

**Architectural Takeaways for the AZ-305 Exam:**
When designing recovery and cost-management strategies, memorize these distinct boundaries:
*   **App Configuration Recovery:** Soft-delete recovers the *entire store* [11]. Point-in-time recovers *individual key-values*. Soft-deleted stores do not incur charges [6].
*   **Managed HSM Soft-Delete Constraints:** It cannot be disabled [3]. You will continue to be billed for the HSM while it sits in the "recycle bin" because the single-tenant hardware is still reserved for you [8, 10].
*   **Purge Protection Implications:** If you enable Purge Protection on a Managed HSM, you cannot force-delete the HSM early [12]. You are forced to wait out the entire retention period (up to 90 days), meaning you are financially locked into paying the hourly rate for that deleted HSM until the retention period naturally expires [10, 13].