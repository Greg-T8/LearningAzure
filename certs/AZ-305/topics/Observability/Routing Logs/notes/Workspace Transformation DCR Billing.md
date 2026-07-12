# Workspace Transformation DCR Billing

## Meaning

A workspace transformation data collection rule (DCR) filters or reshapes supported data that reaches a Log Analytics workspace through a collection path that does **not** already use its own DCR. Because the transformation runs in the Azure Monitor cloud ingestion pipeline, it can reduce the amount stored and billed as ingestion, but it does not always make all discarded data free.

## How it works

```text
Data source without its own DCR
        |
        v
Azure Monitor receives the data
        |
        v
Workspace transformation DCR
        |
        v
Post-transformation data is ingested into the destination table
```

The destination table plan determines the billing treatment:

| Table plan | Data-processing charge | Data-ingestion charge |
|---|---|---|
| Analytics or Basic | Only filtered volume beyond 50% of the incoming data is billable for transformation processing | Based on the data remaining after transformation; added data also increases ingestion volume |
| Auxiliary | Based on all incoming data processed by the ingestion-time transformation | Based on the data remaining after transformation |

For Analytics and Basic tables, the billable processing volume is:

```text
data dropped - (incoming data / 2)
```

This value is zero when the transformation drops 50% or less.

## Requirements and constraints

- A workspace can have only **one** workspace transformation DCR, although that DCR can contain transformations for multiple supported tables.
- It applies to supported data sent to those tables only when the data did not come through another DCR.
- Data collected by Azure Monitor Agent (AMA) must be transformed in the AMA-associated DCR, not by the workspace transformation DCR.
- If a transformation increases record size, the extra ingested data is charged at the standard ingestion rate.
- If Microsoft Sentinel is enabled on the workspace, transformations into Analytics tables have no transformation-processing charge, regardless of the percentage filtered. Other Sentinel ingestion and retention charges can still apply.

## Example

Suppose **20 GB** reaches an ingestion-time transformation and **12 GB** is discarded, leaving **8 GB**:

| Destination table plan | Processing billed | Ingestion billed |
|---|---:|---:|
| Analytics or Basic | `12 GB - (20 GB / 2)` = **2 GB** | **8 GB** |
| Auxiliary | **20 GB** | **8 GB** |

For an Analytics or Basic table, dropping only **8 GB** from the same **20 GB** input would produce no processing charge because less than 50% was discarded; ingestion would be billed on the remaining **12 GB**.

## What it does not do

- It does not transform data that already arrived through another DCR.
- It does not avoid every charge associated with data that Azure Monitor has already received.
- It does not provide the same cost and bandwidth benefit as filtering at the source or through a client-side transformation before data is sent to Azure Monitor.

## AZ-305 exam takeaway

> A workspace transformation can reduce billable ingestion, but it is an ingestion-time control: for Analytics or Basic tables, filtering beyond 50% can add processing charges; for Auxiliary tables, all incoming processed data is billed for processing. Prefer source-side or client-side filtering when the architecture permits it.

## Common trap

Assuming that a workspace transformation causes Azure Monitor to charge either for the full volume at the normal ingestion rate or only for the final stored volume in every case. Billing separates **processing** from **ingestion**, and the table plan determines how each is calculated.

## Microsoft sources

- [Transformations in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations)
- [Create a workspace transformation DCR](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/tutorial-workspace-transformations-portal)
- [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/)
