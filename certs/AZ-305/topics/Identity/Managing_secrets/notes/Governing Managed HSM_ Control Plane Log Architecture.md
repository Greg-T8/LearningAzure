# Governing Managed HSM: Control Plane Log Architecture

This is a great question that tests your understanding of the strict isolation between the control plane and the data plane in Azure Key Vault Managed HSM, as well as how Azure handles monitoring and telemetry.

Here is a detailed breakdown of why your answer was incorrect, why the Azure RBAC Reader role is the right choice, and what you must remember for the AZ-305 exam:

**1. Where Logs Live (Control Plane vs. Data Plane)**
In Managed HSM, actual cryptographic operations happen on the data plane, but the **logs** of those operations do not live inside the data plane. Instead, Managed HSM exports its `AuditEvent` logs to external services (like an Azure Log Analytics workspace, a Storage Account, or Event Hubs) via Azure Monitor diagnostic settings [1, 2]. 
Accessing these logs through Azure Monitor or the external storage resources requires **control-plane permissions (Azure RBAC)**, not data-plane permissions.

**2. Why "Managed HSM Crypto Auditor" is incorrect**
The `Managed HSM Crypto Auditor` role is a **Local RBAC data-plane role** [3, 4]. If you assign this role to auditors, you grant them permission to look directly inside the HSM's data plane to read key attributes, tags, and local role assignments [4, 5]. 
However, this role does absolutely nothing to grant them access to the Azure control plane, Azure Monitor, or the external Log Analytics workspaces where the actual historical audit logs are kept [2, 6]. They would have data-plane access they don't need, and lack the control-plane access they do need to view the logs.

**3. Why Azure RBAC "Reader" is the correct answer**
By assigning the standard Azure RBAC `Reader` role at the resource/vault scope (and potentially the log destination scope), you achieve exactly what the scenario requires:
*   **Log Access:** As a control-plane role, `Reader` allows the auditor to view the HSM resource in Azure and access its metrics, Activity Logs, and diagnostic logs through Azure Monitor [6, 7].
*   **Zero Key or Role Access:** Managed HSM enforces a hard boundary between planes. **Granting control-plane access to a user does not grant them data-plane access** [8]. Because the auditor only has an Azure RBAC role and *no* Managed HSM local RBAC roles, they are physically blocked from viewing key material, performing cryptographic operations, or modifying the HSM's role assignments [9]. 

**Architectural Takeaways for the AZ-305 Exam:**
*   **Dual Authorization Model:** Memorize that Managed HSM uses Azure RBAC for the control plane (management of the resource and monitoring) and its own isolated Local RBAC for the data plane (key operations and internal role assignments) [3, 10]. 
*   **No Inherited Data Access:** Having a high-level Azure RBAC role (even `Owner` or `Contributor`) on a Managed HSM does not implicitly grant you the ability to access data-plane keys or manage local roles [8]. 
*   **Log Routing:** Managed HSM logs must be proactively routed to a Log Analytics Workspace, Storage Account, or Event Hub to be retained and queried. Access to these destinations is governed entirely by standard Azure RBAC [1, 2].