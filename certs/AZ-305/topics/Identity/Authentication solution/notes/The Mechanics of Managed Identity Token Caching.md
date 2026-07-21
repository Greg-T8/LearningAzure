# The Mechanics of Managed Identity Token Caching

Your choice of 1 hour was a very logical guess because 1 hour is the standard, default lifetime for a typical user access token in Microsoft Entra ID. However, managed identities operate under a completely different caching architecture for performance and resiliency.

Here is a breakdown of why your answer was incorrect and how managed identity token caching actually works:

**1. The 24-Hour Token Cache**
Unlike standard user tokens, the backend Azure infrastructure maintains a token cache per resource URI for managed identities [1, 2]. These cached managed identity tokens are valid for around **24 hours** [2, 3]. 

**2. The Impact on Permission Changes**
Because the underlying service relies on this 24-hour cache, any changes made to a managed identity's authorization—such as adding it to a new security group or modifying its Azure RBAC role assignment—can take several hours to be reflected [2, 4, 5]. If the application on your VM has already requested a token for Azure SQL Database, it will continue to receive the cached token with the old, outdated permissions until that 24-hour period expires [1, 6]. 

**3. No Manual Override**
Crucially, there is currently **no supported way to manually force a token refresh** for a managed identity before its natural expiration [1, 4, 7]. You simply must wait for the cache to clear.

**Architectural Takeaway for the AZ-305 Exam:**
When designing authorization structures for Azure resources, you must account for this caching limitation. If a scenario dictates that your workload requires rapid permission changes, relying on group membership for a managed identity is not recommended. Instead, the better architectural pattern is to grant direct permissions to a **user-assigned managed identity**, which avoids the group-caching delay and allows the permissions to be managed more predictably [5, 8].