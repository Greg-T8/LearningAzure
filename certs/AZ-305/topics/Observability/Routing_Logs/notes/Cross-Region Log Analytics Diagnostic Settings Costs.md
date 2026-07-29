# Cross-Region Log Analytics Diagnostic Settings Costs

## Meaning

A regional Azure resource can send platform logs and metrics through an Azure Monitor diagnostic setting to a Log Analytics workspace in another region. Azure does **not** charge an inter-region data-transfer fee for data sent to a different region by **Diagnostic Settings**.

The destination workspace still incurs the normal Azure Monitor Logs charges that apply to the data, primarily ingestion and any chargeable retention or query features.

## How it works

```text
Regional Azure resource
        │
        │ Diagnostic setting
        │ No cross-region data-transfer charge
        ▼
Log Analytics workspace in another region
        │
        └─ Normal workspace ingestion, retention, and feature charges apply
```

Diagnostic Settings is the billing exception. Azure's general rule is that sending data between Azure services in different regions can incur outbound bandwidth charges, while inbound transfer is free. Microsoft explicitly exempts data sent to another region using Diagnostic Settings from those transfer charges.

## Requirements and constraints

- A Log Analytics workspace used by a diagnostic setting does not have to be in the monitored resource's region.
- For a **regional** monitored resource, diagnostic-setting destinations in Azure Storage and Event Hubs must be in the same region as that resource. This same-region rule does not apply to the Log Analytics destination.
- Sending platform logs to Log Analytics has no separate platform-log processing/export charge, but workspace data ingestion and collection can be billable.
- Azure Monitor Logs prices and available pricing options vary by the workspace's region, so workspace placement can still affect the total cost.
- Data residency, regulatory requirements, latency, RBAC boundaries, Microsoft Sentinel design, and operational ownership can justify a regional workspace even when transfer charges do not.

## What it does not do

- The exception does not make Log Analytics ingestion or retention free.
- It does not waive charges for later Log Analytics data export or other paid workspace features.
- It does not establish that every Azure Monitor collection route is exempt. For AMA, DCR, Logs Ingestion API, or other routes, verify the applicable bandwidth and service pricing instead of applying the Diagnostic Settings exception automatically.
- It does not permit a cross-region Storage or Event Hubs destination for a regional source's diagnostic setting.

## Example

A Key Vault in West US sends `AuditEvent` resource logs through a diagnostic setting to a Log Analytics workspace in East US. The organization pays the applicable Log Analytics ingestion and retention charges, but Azure does not add a West US-to-East US data-transfer charge for that diagnostic-setting route.

## AZ-305 exam takeaway

> A cross-region Log Analytics destination is valid for Diagnostic Settings and does not add a cross-region transfer charge; same-region destination constraints apply to Storage and Event Hubs, not Log Analytics.

## Common trap

Applying Azure's general inter-region bandwidth rule without noticing the Diagnostic Settings exception—or assuming that the exception makes Log Analytics ingestion free.

## Microsoft sources

- [Azure Monitor cost and usage — data transfer charges](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/cost-usage#data-transfer-charges)
- [Diagnostic settings in Azure Monitor — destinations](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#destinations)
- [Azure Monitor Logs cost calculations and options](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs)
