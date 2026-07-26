# Mastering Azure RBAC Control and Data Planes

It is very easy to mix up how Azure separates resource management from data access. Your choice highlights a common misunderstanding of how wildcards and role definition planes interact.

Here is a detailed breakdown of why your answer was incorrect and the architectural rules governing Azure RBAC you must remember:

**1. Control Plane vs. Data Plane**
To understand this question, you must separate operations into two distinct planes:
*   **The Control Plane (`Actions` / `NotActions`):** This manages the Azure resources themselves via Azure Resource Manager, such as viewing that a storage account exists, checking network configurations, or deploying a virtual machine [1].
*   **The Data Plane (`DataActions` / `NotDataActions`):** This manages the actual data living *inside* the resource, such as reading a blob in a container, querying rows in a database, or retrieving a secret from a Key Vault [1].

**2. Why Your Choice was Incorrect**
By using `DataActions: ["*/read"]`, you explicitly granted the security team the ability to read the *data* inside every single Azure service that supports data plane RBAC [2]. 
*   **Incomplete exclusions:** While you tried to block Key Vault access by putting `"Microsoft.KeyVault/*"` in `NotDataActions`, you missed excluding Azure Storage blobs. Because of this oversight, the security team would still be fully authorized to read blob data.
*   **Future-proofing failure:** Microsoft warns that using wildcards (`*`) in custom roles can silently grant unwanted access [3, 4]. If Azure releases a brand new data service tomorrow, your `DataActions: ["*/read"]` wildcard would automatically grant the security team access to read that new service's data, violating the strict security requirement.

**3. Why the Correct Answer Works**
By defining `Actions: ["*/read"]`, you grant the security team the ability to read the configuration, metadata, and inventory of all current and future Azure resources across the entire control plane [5]. 

By **completely omitting `DataActions`**, you grant absolutely **zero** data-plane permissions [6, 7]. You do not need to play a game of "whack-a-mole" by creating a complex `NotDataActions` list to manually block Key Vaults and Storage accounts. Because the role contains no data actions, the platform natively blocks the user from looking inside containers to read blobs or looking inside vaults to read secrets [8]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing custom roles, always evaluate whether the scenario is asking for resource visibility or data access.
*   If a requirement asks to "view resources," "inventory," or "audit configurations," use control-plane **`Actions`**. 
*   If a requirement specifically asks to "read blobs," "retrieve secrets," or "query data," use data-plane **`DataActions`** [9].
*   Never use a wildcard (`*`) in `DataActions` for an administrative or security inventory role, as it opens a massive data-exposure blast radius. Let the natural boundary between the control plane and data plane protect your sensitive information [8].