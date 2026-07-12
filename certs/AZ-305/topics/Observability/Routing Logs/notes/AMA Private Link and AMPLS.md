# AMA Private Link and AMPLS

## Meaning

For Azure Monitor Agent (AMA), **Private Link** means that the agent reaches Azure Monitor through a private endpoint in its virtual network instead of through Azure Monitor's public endpoints.

Azure Monitor does not normally create a separate private endpoint directly on every Log Analytics workspace. The private endpoint targets an **Azure Monitor Private Link Scope (AMPLS)**. The AMPLS contains the Azure Monitor resources that the connected network is allowed to reach privately, such as Log Analytics workspaces and data collection endpoints (DCEs).

A Log Analytics workspace therefore does not “listen on a private link scope.” More precisely, the workspace is **added as a scoped resource to the AMPLS**, and Azure Monitor routes its resource-specific ingestion endpoint through the AMPLS private endpoint.

## How it works

AMA has two distinct communication needs:

```text
VM or Kubernetes cluster
        │
        ├── Retrieve DCR configuration
        │       └── DCE configuration endpoint
        │
        └── Send logs
                └── Log Analytics workspace ingestion endpoint

Both private paths resolve through Azure Monitor private DNS
to the private endpoint connected to the AMPLS.
```

The roles are different:

- **Private endpoint:** Supplies private IP addresses in the VNet and carries traffic over Azure Private Link.
- **AMPLS:** Defines which Azure Monitor resources are reachable through that private endpoint.
- **DCE:** Gives AMA a private configuration-access endpoint from which it retrieves its associated data collection rules (DCRs).
- **DCR:** Defines what AMA collects and the destination for the collected data.
- **Log Analytics workspace:** Receives AMA log data through its resource-specific ingestion endpoint when the workspace is included in the AMPLS.

## Requirements and constraints

- Add the Log Analytics workspace to the AMPLS to support private ingestion and queries for that workspace.
- Add the DCE used for AMA configuration access to the AMPLS.
- Associate the VM or cluster with the configuration-access DCE. Each VM or cluster can have only **one** such DCE association; a new association replaces the existing one.
- The configuration-access DCE must be in the **same region as the monitored VM or cluster**.
- Connect the AMPLS to a private endpoint in the VNet and configure the required Azure Monitor private DNS zones.
- Use one AMPLS for networks that share the same DNS. Multiple AMPLS instances sharing DNS can overwrite Azure Monitor private DNS mappings and break connectivity.
- AMPLS has separate ingestion and query access modes. **Open** permits access to resources both inside and outside the AMPLS; **Private only** restricts access to resources included in the AMPLS and helps prevent data exfiltration.

## DCE ingestion distinction

The general DCE model includes configuration, logs-ingestion, and metrics-ingestion endpoints. This does not mean that AMA must use a DCE to ingest logs into a Log Analytics workspace when configured with AMPLS.

For the current AMA Private Link architecture:

- AMA requires a DCE in the AMPLS to retrieve DCR configuration.
- AMA does **not** require a DCE for private log ingestion into Log Analytics; the Log Analytics workspace is added directly to the AMPLS.
- A DCE is required for private metrics ingestion into an Azure Monitor workspace. Azure Monitor workspaces are not themselves added to AMPLS; their DCE is added for ingestion.

## What it does not do

- AMPLS is not the data store and does not receive or retain logs.
- A DCE is not a Log Analytics workspace and does not replace one.
- A DCR association alone does not create private network connectivity.
- Disabling public access does not automatically create a private endpoint, AMPLS membership, or DNS configuration.
- Private Link does not replace authentication or authorization.

## Common failure conditions

1. The workspace is missing from the AMPLS, so private Log Analytics ingestion is unavailable.
2. The configuration-access DCE is missing from the AMPLS or is not associated with the VM or cluster, so AMA cannot retrieve its DCRs.
3. The DCE is not in the monitored resource's region.
4. Private DNS does not resolve Azure Monitor endpoints to the AMPLS private endpoint.
5. AMPLS is set to **Private only**, but a required workspace or DCE has not been added to the scope.

## AZ-305 exam takeaway

> For AMA over Private Link, connect the VNet's private endpoint to an AMPLS, add the Log Analytics workspace for private log ingestion, and add and associate a same-region DCE for AMA configuration retrieval.

## Common trap

Do not assume that the Log Analytics workspace owns the private endpoint or that all AMA traffic must pass through a DCE. The private endpoint targets the AMPLS; the DCE supplies AMA configuration access, while the workspace's AMPLS membership enables private Log Analytics ingestion.

## Microsoft sources

- [Enable Private Link for monitoring VMs and Kubernetes clusters](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-vm-kubernetes)
- [Use Azure Private Link to connect networks to Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-security)
- [Data collection endpoints in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-endpoint-overview)
- [Configure Private Link for Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-configure)
