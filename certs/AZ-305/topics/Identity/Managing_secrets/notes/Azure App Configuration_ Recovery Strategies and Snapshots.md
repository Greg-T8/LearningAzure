# Azure App Configuration: Recovery Strategies and Snapshots

It is very easy to select soft delete because the term implies data recovery. However, this question tests your understanding of the different layers of recovery, versioning, and deployment safety mechanisms within Azure App Configuration.

Here is a detailed breakdown of why your answer was incorrect, why Snapshots are the recommended strategy, and what you must remember for the AZ-305 exam:

**1. The Limitation of Soft Delete (Why your answer was incorrect)**
In Azure App Configuration, the soft delete feature acts as a safeguard against the accidental or intentional deletion of the **entire App Configuration store resource** [1, 2]. If an administrator deletes the store, soft delete allows you to recover the whole store during a configurable retention period [2]. 
However, soft delete does not track or revert everyday modifications made to individual settings within an active, running store. If you update a setting from `True` to `False` and it breaks your production environment, the soft delete feature cannot help you revert that specific change.

**2. The Power of Snapshots (Why the correct answer is right)**
A snapshot is a named, completely immutable subset of your configuration key-values [3]. Because a snapshot cannot be modified once it is created, Microsoft explicitly recommends using snapshots to support safe deployment practices and to maintain a **Last Known Good (LKG)** configuration [4]. 
During a deployment, if you push new configuration changes that cause a production issue, you can immediately roll back the application by referencing the previous LKG snapshot [4, 5]. Because the snapshot is immutable, you are guaranteed that the configuration will revert to the exact, consistent state it was in before the faulty deployment occurred [6].

**Architectural Takeaways for the AZ-305 Exam:**
When designing recovery and safe deployment strategies for Azure App Configuration, you must memorize the distinct boundaries between these three features:
*   **Soft Delete:** Use this only when the **entire configuration store** is deleted and needs to be recovered [2].
*   **Point-in-Time Key-Values:** Use this to "time-travel" backward to view or recover the past value of an **individual key-value pair** that was accidentally modified or deleted [7].
*   **Snapshots:** Use this for configuration versioning, auditing, and maintaining an **immutable Last Known Good (LKG) state** to safely roll back application deployments [4, 8].