# Why Log Analytics Retention Is Not WORM

## Meaning

Log Analytics retention specifies how long Azure Monitor Logs keeps data available. It is a lifecycle and cost setting, not an immutable-storage guarantee.

**WORM** (write once, read many) requires an enforced rule that prevents data from being modified or deleted for a defined period. Log Analytics is append-only after ingestion, but authorized users can still purge data or change retention settings.

```text
Log Analytics retention
    = Keep data for the configured period

Blob immutability policy
    = Prevent overwrite and deletion during the protected period
```

## Why retention alone fails a WORM requirement

- Log Analytics data can be purged for compliance or data-management reasons.
- Table or workspace retention can be changed; shortening retention eventually removes data.
- Tables and workspaces have deletion operations that are not equivalent to a locked retention policy.
- A resource lock can block purge, table deletion, or retention changes, but an authorized administrator can remove the lock.
- Long-term retention improves economical storage duration, but does not make the data tamper-proof.

Current Log Analytics documentation describes analytics retention and long-term retention separately. Analytics retention can be extended up to **two years**, and total table retention can be extended up to **12 years**; those are retention limits, not WORM guarantees.

## WORM architecture

Use Log Analytics for searchable operational data and maintain a separate immutable copy when regulatory or tamper-proof retention is required:

```text
Logs ──> Log Analytics workspace
          └─> queries, alerts, investigations

Logs ──> Azure Storage account with immutable Blob policies
          └─> authoritative WORM archive
```

Azure Monitor workspace data export can continuously copy selected tables to Azure Storage as data arrives. Configure the destination Storage account with Blob immutable storage using a locked time-based retention policy or a legal hold.

## Requirements and constraints

- Select the specific log tables that must be protected; data export is configured per table.
- The exported destination must be an Azure Storage account configured with immutability policies.
- A locked time-based retention policy prevents modification or deletion until the interval expires.
- A legal hold keeps data immutable until the hold is explicitly cleared.
- If using Azure Monitor Logs data export, the Storage account must be in the same region as the workspace and must not be Premium; Microsoft also requires the protected-append-blob configuration described in the export guidance.
- Confirm that the chosen log source and table support the export path. Exporting only a searchable Log Analytics copy does not itself create a WORM archive.

## What it does not do

- A 12-year Log Analytics retention setting does not mean the data is undeletable for 12 years.
- A Log Analytics workspace lock is not the same as a locked Blob immutability policy.
- Long-term retention and archive tiers do not provide legal-hold semantics.
- Exporting to an ordinary Storage account does not provide WORM protection; the Storage account must have immutable policies configured.

## Example

An organization must retain security logs for seven years in a tamper-proof form. Set suitable Log Analytics retention for investigations, configure continuous export for the required tables, and write the export to a Storage account with a locked seven-year Blob immutability policy. The workspace supports operational analysis; the immutable Storage copy satisfies the WORM requirement.

## AZ-305 exam takeaway

> “Retain for N years” points to Log Analytics retention. “WORM,” “tamper-proof,” or “cannot be deleted” points to Azure Blob immutable storage with a locked time-based retention policy or legal hold.

## Common trap

Choosing Log Analytics long-term retention alone because its maximum duration is longer than the requirement. Duration and immutability are different requirements; the latter requires an enforced immutable destination.

## Microsoft sources

- [Manage data retention in a Log Analytics workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure)
- [Log Analytics workspace data export](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export)
- [Best practices for Azure Monitor Logs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/best-practices-logs)
- [Immutable storage for Blob data](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview)
