# Event Hubs for Log Analytics Data Export

## Meaning

Log Analytics workspace data export continuously forwards **new** records from selected whole tables to Azure Event Hubs after Azure Monitor ingests them. Event Hubs is the streaming handoff for an external SIEM, stream processor, or other downstream consumer; it is not the long-term, queryable log store.

## How it works

```text
Log Analytics workspace table
        │ new records only; no row filter
        ▼
Data export rule ──► Event Hubs namespace ──► Event Hub ──► consumers
```

- If the rule names a specific Event Hub, all selected tables are exported to that stream. Consumers can use the `Type` field to distinguish table types.
- If no Event Hub name is supplied, Azure Monitor creates one Event Hub per table, named `am-<table-name>` (for example, `am-SecurityEvent`).
- The destination Event Hubs namespace must be in the same region as the Log Analytics workspace.

## Requirements and constraints

- Export starts only after the rule is provisioned; it does **not** backfill historical data and exports all records in each selected table.
- Basic and Standard namespaces support up to **10 Event Hubs**. For more than 10 tables, route multiple tables to one named Event Hub or use additional namespaces.
- Basic Event Hubs has lower event-size capacity and no Auto-inflate. Prefer **Standard, Premium, or Dedicated** with Auto-inflate enabled as workspace log volume can grow.
- Use a namespace dedicated to monitoring export rather than combining it with unrelated producers, which reduces the chance of throttling or latency-driven ingress failures.
- A **compacted Event Hub** cannot be used: compaction requires a partition key, and Azure Monitor data export does not provide one.
- If Event Hubs networking restrictions are enabled, allow trusted Microsoft services so Azure Monitor can deliver exported data.

## What it does not do

- It does not make Log Analytics data immutable or provide a durable compliance archive. Event Hubs retention is limited to **1 day** in Basic, up to **7 days** in Standard, and up to **90 days** in Premium or Dedicated.
- It does not transform, aggregate, or row-filter exported records. Apply a workspace transformation before ingestion when filtering or reshaping is required.

## Example

A company needs `SecurityEvent`, `Heartbeat`, and application logs sent to a third-party SIEM. Create a workspace data export rule targeting a named Standard-tier Event Hub, enable Auto-inflate, and have the SIEM consumer separate records by `Type`. Keep the workspace for KQL investigation and use immutable Blob Storage separately if the requirement is long-term WORM evidence.

## AZ-305 exam takeaway

> Choose Event Hubs for continuous streaming to external consumers; choose Log Analytics for queries and immutable Storage for tamper-resistant long-term retention. For scalable workspace export, avoid Basic and use a normal, non-compacted Standard-or-higher Event Hub.

## Common trap

An Event Hubs **namespace** is the capacity and security container; an **Event Hub** is the individual event stream inside it. Also, a compacted Event Hub is a state-retention stream, not a valid destination for Azure Monitor log export.

## Microsoft sources

- [Log Analytics workspace data export in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#event-hubs)
- [Compare Azure Event Hubs tiers](https://learn.microsoft.com/en-us/azure/event-hubs/compare-tiers)
- [Log compaction in Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/log-compaction)
