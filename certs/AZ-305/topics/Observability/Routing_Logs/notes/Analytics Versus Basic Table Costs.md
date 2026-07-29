# Analytics Versus Basic Table Costs

## Meaning

In Azure Monitor Logs, **Basic tables reduce ingestion cost but add a charge for interactive queries**. **Analytics tables have standard ingestion pricing, but interactive query cost is included**. The cheaper plan depends on the table's access pattern, not ingestion volume alone.

## How it works

| Cost area | Analytics | Basic |
|---|---|---|
| Ingestion | Standard rate | Reduced rate |
| Interactive queries | Included | Charged by GB scanned |
| Interactive retention | Usually 31 days (90 days for applicable Sentinel/Application Insights data) | 30 days |
| Query model | Full KQL across tables | Full KQL on one table, with `lookup` to Analytics tables |

For a Basic-table query, Azure measures the data ingested into that table during the query's time range. A query over a table ingesting 100 GB/day for three days is charged as scanning 300 GB, even if filters return only a small result set.

Long-term retention charges are separate and use the same per-GB rate across Analytics, Basic, and Auxiliary plans. Exact ingestion and query prices vary by region, pricing tier, and agreement.

## Requirements and constraints

- Basic is intended for medium-touch troubleshooting and incident response, not continuous monitoring.
- Basic tables have optimized single-table queries, but they don't provide all Analytics features, such as Insights and full multi-table query behavior.
- Basic supports only tables that Microsoft allows to use the Basic plan (and DCR-based custom tables).
- Query charges can apply to workbook, dashboard, or other refresh activity that reads Basic data.

## Example

```text
Verbose diagnostic logs queried occasionally  -> Basic
Alerts, dashboards, correlation, Insights    -> Analytics
```

If a verbose table ingests 1 TB/day but is investigated only after incidents, Basic's ingestion discount may outweigh occasional scan charges. If the same table is queried every few minutes by dashboards or alerts, repeated scan charges can exceed the ingestion savings; Analytics is usually the better fit.

## AZ-305 exam takeaway

> Choose **Basic** when ingestion volume is high and access is infrequent; choose **Analytics** when the data drives continuous monitoring, alerting, Insights, or frequent cross-table queries.

## Common trap

“Basic is always cheaper” is incorrect. Basic shifts part of the cost from ingestion to querying, and the query bill is based on data scanned—not rows returned.

## Microsoft sources

- [Azure Monitor pricing](https://azure.microsoft.com/en-us/pricing/details/monitor/)
- [Azure Monitor Logs cost calculations and options](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs)
- [Azure Monitor Logs table plans](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)
- [Query data in a Basic table](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/basic-logs-query)
