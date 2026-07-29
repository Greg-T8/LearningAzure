# When Is a Data Collection Endpoint Required?

## Meaning

A Data Collection Endpoint (DCE) is not automatically required whenever Azure Monitor uses a Data Collection Rule (DCR). Most collection paths can use public Azure Monitor endpoints or an endpoint embedded in the DCR.

## Requirements and constraints

- **Private connectivity:** AMA or Logs Ingestion API traffic requires a DCE when the destination or agent path is configured for Azure Monitor Private Link/AMPLS.
- **Specific AMA data sources:** A DCE is currently required for **Windows Firewall logs** and **Prometheus metrics collected by Container Insights**. Other AMA data sources can use the public endpoint.
- **Logs Ingestion API:** A newer `Direct` DCR exposes its own `logsIngestion` endpoint, so a separate DCE is optional. DCRs created before **March 31, 2024** may not have that endpoint and require a DCE unless replaced with a new DCR.

## What it does not do

- Diagnostic settings resource logs and Application Insights data collection do not use DCEs.
- A DCE is not required merely because a DCR is present.

## Example

```text
AMA + Windows Firewall logs ──> DCE ──> DCR ──> Log Analytics
AMA + Windows events        ──> public endpoint ──> DCR ──> Log Analytics
Direct Logs Ingestion       ──> DCR logsIngestion endpoint ──> Log Analytics
```

## AZ-305 exam takeaway

> Choose a DCE for private-link isolation, Windows Firewall logs, Container Insights Prometheus metrics, or a legacy Direct DCR without an embedded ingestion endpoint.

## Common trap

Do not assume every AMA DCR needs a DCE. The DCE requirement depends on the network path and data source.

## Microsoft sources

- [Data collection endpoints in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-endpoint-overview)
- [Logs Ingestion API endpoint selection](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#endpoint)
