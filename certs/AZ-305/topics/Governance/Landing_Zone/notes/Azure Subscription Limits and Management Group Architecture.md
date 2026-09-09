# Azure Subscription Limits and Management Group Architecture

Your answer was incorrect because **there is no limit of 800 subscriptions per management group**. In fact, according to Azure platform specifications, the number of subscriptions you can associate with a single management group is **unlimited** [1-3]. 

Here is why the correct answer is **the limit of 5,000 total subscriptions (active and deleted) per EA Account Owner**, and how this affects your architecture:

### 1. Subscriptions per Management Group is Unlimited
While Azure enforces several limits at the management group level—such as a tenant maximum of 10,000 management groups [2-4] and a depth limit of 6 levels below the root [2, 3, 5]—the platform does not restrict how many subscriptions can be placed within any single management group node [1-3]. The number "800" likely comes from a different Azure limit, such as the limit of **800 resources of a specific type per resource group** [6] or **800 deployments in a resource group's history** [7, 8], but it has no relationship to subscription grouping.

### 2. The 5,000 Cumulative Subscription Limit for EA Account Owners
For organizations utilizing an Enterprise Agreement (EA), Azure enforces a strict boundary of **5,000 total subscriptions per EA Account Owner** [9]. Crucially:
* **Deleted Subscriptions Count:** Unlike a Microsoft Customer Agreement (MCA) or Microsoft Partner Agreement (MPA) which only counts *active* subscriptions toward their 5,000 limit [9], the Enterprise Agreement billing subsystem **counts both active and deleted subscriptions** toward the Account Owner's 5,000 quota limit [9].
* **The Scale Block:** Since this enterprise currently has 4,500 active subscriptions and 600 deleted subscriptions, they have initiated **5,100 total subscription creations** under their single EA Account Owner. Having already surpassed the 5,000 threshold, they cannot programmatically create any more subscriptions under this Account Owner's credentials.

### 3. The Recommended Design Remediation: Subscription Reuse
To scale beyond this threshold without having to split billing across multiple EA Account Owners, the Cloud Adoption Framework (CAF) recommends a pattern called **Subscription Reuse** [10, 11]. 

Instead of letting deleted subscriptions pile up in the decommissioned container and consume quota:
1. **Clean up old subscriptions** by removing all resource groups, resource locks, role assignments, custom roles, policy assignments, and budgets [12].
2. **Reset the subscription** to a clean baseline state [10].
3. **Reassign the subscription** to a new workload team or project owner rather than provisioning a brand-new subscription from scratch [10, 11, 13].

***

🔄 Would you like to review some practice scenarios on how to design a subscription vending pipeline that automatically handles subscription clean-up and placement within your management group hierarchy?