# Azure App Configuration: Snapshots versus Restore Features

Yes, in the context of Azure App Configuration, **Snapshots** and the **Restore** feature are two completely separate capabilities designed for different scenarios. They even have distinct locations within the Azure portal's Operations menu. 

Here is a breakdown of how they differ:

**1. The "Restore" Feature (Point-in-Time Key-Values)**
*   **What it is:** The **Restore** menu in the Azure portal is the interface used to access the **Point-in-time key-values** feature [1, 2]. It automatically maintains a continuous, rolling history of all changes made to your store [1].
*   **How you use it:** You use it reactively to "time-travel" backward. If someone accidentally deletes or misconfigures a key, you open the Restore menu, select a specific date and time from the past (e.g., 24 hours ago), and the portal will show you exactly what the keys looked like at that exact moment so you can revert them [1, 2].
*   **Mutability:** The active configuration store is mutable. When you use the Restore feature, you are actively writing old values back into your live, changeable configuration state [3].

**2. Snapshots**
*   **What it is:** A snapshot is a proactively created, named, and **completely immutable** (unchangeable) subset of your configuration settings [4]. You access this feature through the **Snapshots** menu in the portal [5].
*   **How you use it:** Snapshots are used for safe deployment practices, configuration versioning, and auditing [6, 7]. Before a major application release, a developer creates a snapshot to capture a "Last Known Good" (LKG) configuration [8]. 
*   **How recovery works:** Unlike the Restore feature where you push old data back into the live store, rolling back with a snapshot typically involves updating your application to load the specific snapshot name (e.g., calling `SelectSnapshot("Snapshot_v1.0")` in your application code) [9, 10]. Because the snapshot is immutable, you are guaranteed that the application will load the exact configuration state that was captured, protecting you from unexpected changes making their way into production [11, 12].

**Summary for the AZ-305 Exam:**
*   Use the **Restore** menu (Point-in-time) to recover from accidental day-to-day modifications of individual keys [1].
*   Use **Snapshots** to intentionally version your configurations and establish a safe, immutable Last Known Good (LKG) state for application deployments [4, 8].