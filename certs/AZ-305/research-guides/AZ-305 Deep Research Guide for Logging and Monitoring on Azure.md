# AZ-305 Deep Research Guide for Logging and Monitoring on Azure

## Starting points and scope boundaries

This guide is scoped to the **AZ-305 “Design solutions for logging and monitoring”** skills measured (recommend a logging solution, recommend a solution for routing logs, recommend a monitoring solution), as listed in the official **AZ-305 study guide (skills measured as of April 17, 2026)**. [\[1\]](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305)

The required starting point for this skill area is the Microsoft Learn learning path **“AZ-305: Design identity, governance, and monitor solutions”** and its module **“Design a solution to log and monitor Azure resources”**. [\[2\]](https://learn.microsoft.com/en-us/training/paths/design-identity-governance-monitor-solutions/)

All sources and recommendations below use only documentation hosted on learn.microsoft.com (and Microsoft documentation reachable from those pages), per the constraint. [\[3\]](https://learn.microsoft.com/en-us/training/paths/design-identity-governance-monitor-solutions/)

## Recommend a logging solution

A strong “logging solution” answer on AZ-305 is usually a **data-platform selection + architecture** decision:

- **What signals** you need (metrics, logs, traces, lifecycle events/changes), and at what latency and retention.
- **Where** to store/analyze them (Azure Monitor Metrics vs Azure Monitor Logs/Log Analytics; sometimes Azure Data Explorer for high-volume/advanced analytics).
- **How** to control access, retention, and cost at scale (workspace architecture, table plans, retention tiers, export). [\[4\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-platform)

Azure Monitor’s documentation frames observability around **metrics, logs, and distributed traces**, consolidated into a common platform so you can correlate across data types and resources. [\[5\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-platform)

### Core docs you must read

The items below are the minimum “exam-coverage backbone” for logging design decisions:

- **Azure Monitor data platform** (pillars of observability; difference between metrics vs logs; how Azure Monitor correlates data). [\[6\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-platform)
- **Azure Monitor data sources and data collection methods** (what data exists by default: activity log and platform metrics; what requires configuration: resource logs; what uses agents/DCRs for VM and Kubernetes; where data lands). [\[7\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-sources)
- **Azure Monitor Logs overview** (Log Analytics workspace as the primary resource; ingestion/routing/transformation; table plans; retention; access). [\[8\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)
- **Azure Monitor Metrics overview** (types: platform/native/custom vs Prometheus; where Prometheus metrics are stored; analysis/alerting tooling differences). [\[9\]](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-platform-metrics)
- **Design a Log Analytics workspace architecture** (single vs multiple workspaces; tenant and region considerations; separating operational vs security data; cost implications when Microsoft Sentinel is enabled). [\[10\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design)
- **Manage data retention in a Log Analytics workspace** (default retention behavior; analytics retention vs total retention; how retention interacts with table plans). [\[11\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure)
- **Select a table plan based on data usage** (Analytics vs Basic vs Auxiliary tradeoffs, and operational constraints like how often you can switch plans). [\[12\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans)
- **Log queries in Azure Monitor** (the query model you’ll use for log-based investigation and log-alert logic). [\[13\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-query-overview)

### Adjacent docs you should read for fuller coverage

These topics commonly show up as “real-world architect constraints” and are easy to under-study if you only follow the Learn module:

- **Azure Monitor Logs cost calculations and options** (what drives cost; how table plans and retention drive cost; interaction with Microsoft Sentinel). [\[14\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs)
- **Azure Monitor cost and usage** and **Cost optimization in Azure Monitor** (what’s free by default—activity log and platform metrics; how to reduce ingestion/retention cost; commitment tiers). [\[15\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/cost-usage)
- **Manage tables in a Log Analytics workspace** (table types, schema, and configuration knobs you can use to align cost vs analytics needs). [\[16\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables)
- **Best practices for Azure Monitor Logs** (architecture recommendations like access control mode, table RBAC patterns, and other cross-pillar guidance). [\[17\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/best-practices-logs)
- **Optimize log queries in Azure Monitor** (query performance, recurring queries, dashboards/alerts impact; summary rules concept). [\[18\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/query-optimization)
- **Kusto Query Language (KQL) overview** (vendor-neutral KQL fundamentals used in Azure Monitor, Azure Data Explorer, Microsoft Sentinel). [\[19\]](https://learn.microsoft.com/en-us/kusto/query/?view=microsoft-fabric&utm_source=chatgpt.com)
- **What is Azure Data Explorer?** (when you need near-real-time analytics at high volume; how it relates to Azure Monitor Logs’ underlying query engine). [\[20\]](https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview)

### Gaps or underrepresented subtopics in the learning path

The Learn module touches the “big rocks” (Logs vs Metrics, Log Analytics workspace concepts, Workbooks/Insights, Azure Data Explorer) but tends to be light on several exam-relevant design details:

- **How to shape log cost and capability using table plans and retention tiers**, including Basic/Auxiliary behavior and long-term retention strategies. [\[21\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)
- **Workspace access-control design** (resource-context vs workspace-context, table-level access, granular RBAC): critical for “architect” scenarios where multiple teams share a centralized workspace. [\[22\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access)
- **Network isolation patterns** for log query/ingestion (Private Link / AMPLS impacts and design cautions). [\[23\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-security)

### Prioritized reading list

If you want a pragmatic order (high yield first), read:

1.  Azure Monitor data sources and collection methods. [\[7\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-sources)
2.  Azure Monitor data platform. [\[6\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-platform)
3.  Azure Monitor Logs overview (especially table plans, retention concepts, and “data collection, routing, and transformation”). [\[8\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)
4.  Azure Monitor Metrics overview (native vs Prometheus distinctions). [\[9\]](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-platform-metrics)
5.  Design a Log Analytics workspace architecture (tenant/region + security vs ops workspace decision). [\[10\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design)
6.  Manage data retention in a Log Analytics workspace. [\[11\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure)
7.  Select a table plan + revisit the table plan comparison section in Logs overview. [\[12\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans)
8.  Azure Monitor Logs cost calculations and options + Azure Monitor cost and usage. [\[24\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs)
9.  Manage access to Log Analytics workspaces (resource vs workspace permissions). [\[25\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access)
10. KQL overview + Log queries in Azure Monitor (just enough to understand how detection and correlation works). [\[26\]](https://learn.microsoft.com/en-us/kusto/query/?view=microsoft-fabric&utm_source=chatgpt.com)

## Recommend a solution for routing logs

On AZ-305, “routing logs” is rarely just “turn it on.” It typically means designing a pipeline that answers:

- **Which log types** you need (activity log, resource logs, guest OS logs, app logs, Prometheus metrics-as-metrics).
- **Which routing mechanism** applies for each source (diagnostic settings vs DCR/agent vs workspace data export vs streaming to Event Hubs).
- **Which destination(s)** match the scenario (Log Analytics workspace for query/correlation and alerts; Event Hubs for external SIEM/SOAR/stream processing; Storage for long-term/tamper-resistant retention; partner integrations). [\[27\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-sources)

### Core docs you must read

- **Diagnostic settings in Azure Monitor** (collect resource logs; send activity log / metrics to destinations; category groups; limitations like metric dimensionality; “infinite loop” destination constraint). [\[28\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings)
- **Resource logs in Azure Monitor** (destinations: Log Analytics, Event Hubs, Storage, partner integrations; collection modes: AzureDiagnostics vs resource-specific tables). [\[29\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs)
- **Activity log in Azure Monitor** (subscription-level events; default retention of 90 days; route via diagnostic setting for longer retention). [\[30\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log)
- **Azure Monitor data sources and data collection methods** (the “catalog view” that ties sources to their collection/routing mechanisms). [\[7\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-sources)
- **Data collection rules (DCRs) in Azure Monitor** (what DCRs are; how they replace legacy collection methods; where they’re used—AMA, Event Hubs, direct ingestion, workspace transformations). [\[31\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview)
- **Azure Monitor Agent overview** (agent uses DCRs; “what is collected, processed, and where it is sent”). [\[32\]](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview)
- **Log Analytics workspace data export** (continuous export of selected tables to Storage or Event Hubs; when to prefer updating diagnostic settings vs using workspace export; compliance use cases like immutability policies). [\[33\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export)
- **Stream Azure monitoring data to an event hub and external partner** (design guidance for Event Hubs streaming—retention, consumer groups, how Azure Monitor names hubs for activity log, and multiple streaming methods like DCRs vs diagnostic settings). [\[34\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/stream-monitoring-data-event-hubs)

### Adjacent docs you should read for fuller coverage

- **Create diagnostic settings at scale using built-in Azure policies** and **custom policies** (how to enforce diagnostic settings across resources using initiatives; category groups like `allLogs` and `audit`). [\[35\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy-built-in)
- **Built-in policy definitions for Azure Monitor** (what Microsoft provides out of the box for deploying diagnostic settings and other monitoring controls). [\[36\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/policy-reference)
- **Collect guest log data from virtual machines with Azure Monitor** (how VM guest logs are collected via DCRs; region constraints; DCE and Private Link considerations; duplicate data warnings). [\[37\]](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection)
- **Data collection endpoints (DCEs) overview** (regional design for endpoints supporting ingestion/configuration, especially in multi-region deployments). [\[38\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-endpoint-overview?utm_source=chatgpt.com)
- **Transformations in Azure Monitor** (workspace transformation DCR vs agent DCR; what transformations apply to which ingestion paths). [\[39\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations)
- **Logs Ingestion API overview** (DCR and endpoint requirements; when DCE is required; direct ingestion endpoint behavior and timeline). [\[40\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview)
- **Ingest events from Azure Event Hubs into Azure Monitor Logs** (an Azure-native path for bringing streaming data into Log Analytics when Event Hubs is the collection point). [\[41\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/ingest-logs-event-hub)
- **Metrics export feature comparison** and **Metrics export using DCRs (Preview)** (when exporting platform metrics in near real-time is required; region and co-location requirements for exporting to Event Hubs/Storage). [\[42\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-plane-versus-metrics-export)
- **Private Link security for Azure Monitor** (shared endpoint DNS impacts; AMPLS planning guidance). [\[43\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-security)

### Gaps or underrepresented subtopics in the learning path

Common routing-centric gaps, relative to what architects often need:

- **Diagnostic settings at scale** (policy initiatives/patterns) are usually only mentioned in passing but are central to real enterprise rollouts. [\[44\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy-built-in)
- **The “two pipeline worlds”**: diagnostic settings for resource logs vs DCR/AMA for guest logs and newer ingestion paths—and how transformations differ between them. [\[45\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview)
- **Designing for external log consumers** (Event Hubs operational guidance, network restrictions and firewall bypass requirements). [\[46\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/stream-monitoring-data-event-hubs)
- **Selecting between “export at source” vs “export at workspace”** (diagnostic settings vs workspace data export) and the latency/coverage/security implications. [\[33\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export)

### Prioritized reading list

1.  Azure Monitor data sources and data collection methods (to anchor which mechanism applies to which source). [\[7\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-sources)
2.  Diagnostic settings in Azure Monitor + Resource logs + Activity log. [\[47\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings)
3.  Data collection rules (DCRs) + Azure Monitor Agent overview. [\[48\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview)
4.  Collect guest log data from VMs (DCR realities + pitfalls). [\[37\]](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection)
5.  Log Analytics workspace data export (when central export is preferable). [\[33\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export)
6.  Stream Azure monitoring data to Event Hubs (external tool patterns). [\[34\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/stream-monitoring-data-event-hubs)
7.  Diagnostic settings at scale using built-in policies (and then custom policies if needed). [\[35\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy-built-in)
8.  Metrics export (if you expect “export metrics to Event Hubs/Storage” questions). [\[42\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-plane-versus-metrics-export)
9.  Private Link security + config guidance (if private ingestion/query is in scope for the scenario). [\[23\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-security)

## Recommend a monitoring solution

A complete monitoring solution for AZ-305 typically combines:

- **Signals**: metrics (fast), logs (deep), traces/APM (application-centric), and health/state signals for platform incidents.
- **Detection & response**: alerts (metric, log, activity/service/resource health), action groups, and notification management (alert processing rules).
- **Visualization**: Workbooks, Insights (curated experiences), and optionally Grafana/Prometheus patterns for cloud-native workloads. [\[49\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview)

### Core docs you must read

- **Azure Monitor overview** (unified observability framing: metrics, logs, traces, events). [\[50\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview)
- **Azure Monitor alerts overview** + **types of alerts** (metric vs log search vs activity log alerts; where Service Health/Resource Health fit). [\[51\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview)
- **Best practices for Azure Monitor alerts** (cost/architecture guidance; using free alert types when they meet the requirement). [\[52\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/best-practices-alerts)
- **Create and manage action groups** (notification and automation fan-out mechanism shared across alert sources). [\[53\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups?utm_source=chatgpt.com)
- **Alert processing rules** (adding/suppressing action groups, filters, schedules; and the key limitation that they don’t affect Service Health alerts). [\[54\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-processing-rules)
- **Azure Workbooks overview** (multi-source visualization canvas; ties directly to Logs + Metrics). [\[55\]](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview)
- **Azure Monitor Insights overview** (which curated “Insights” experiences exist—VM, etc.—and what they provide). [\[56\]](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/insights-overview)
- **Azure Service Health overview** + **Azure Resource Health overview** (platform vs resource health; how Service Health alerts fit into monitoring). [\[57\]](https://learn.microsoft.com/en-us/azure/service-health/overview)

### Adjacent docs you should read for fuller coverage

- **Types of alerts: activity log / service health / resource health alert creation** (practical creation model and design elements like action groups and processing rules). [\[58\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule?utm_source=chatgpt.com)
- **Metrics Explorer** (the mechanics of metrics investigations and charting). [\[59\]](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-charts)
- **Network Insights** (network-topology/health/traffic monitoring surface and how it connects to flow logs and connection monitoring capabilities). [\[60\]](https://learn.microsoft.com/en-us/azure/network-watcher/network-insights-overview)
- **Application Insights overview** and **availability tests** (APM + synthetic monitoring patterns that commonly appear in design scenarios). [\[61\]](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
- **Overview of Azure Monitor with Prometheus** + **Azure Monitor workspace overview** (cloud-native metrics design: where Prometheus metrics live, and how they’re queried/alerted). [\[62\]](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/prometheus-metrics-overview?utm_source=chatgpt.com)
- **Alerting and monitoring guidance from Cloud Adoption Framework and Well-Architected** (how Microsoft frames baseline monitoring and alerting requirements at the estate level). [\[63\]](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor)

### Gaps or underrepresented subtopics in the learning path

Compared with typical architect responsibilities, the learning path/module tends to underemphasize:

- **Alert architecture**: picking alert types, controlling alert cost, and building notification/automation topology with action groups and processing rules. [\[64\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types)
- **Service Health vs Resource Health** monitoring design and how those alerts behave differently from other alert sources (notably, processing rule limitations). [\[65\]](https://learn.microsoft.com/en-us/azure/service-health/overview)
- **Cloud-native metrics patterns** (Prometheus in Azure Monitor workspace + PromQL + Grafana integration), which are increasingly relevant for AKS-based designs. [\[66\]](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-platform-metrics)

### Prioritized reading list

1.  Azure Monitor overview (frame the service and data types). [\[50\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview)
2.  Alerts overview + Types of alerts + Best practices for alerts. [\[67\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview)
3.  Action groups + Alert processing rules (notification routing and suppression). [\[68\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups?utm_source=chatgpt.com)
4.  Service Health overview + Resource Health overview + activity/service/resource health alert creation article. [\[69\]](https://learn.microsoft.com/en-us/azure/service-health/overview)
5.  Workbooks overview + Insights overview (visualization + curated monitoring experiences). [\[70\]](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview)
6.  Metrics Explorer + (optional) Prometheus/Azure Monitor workspace overview if AKS is central. [\[71\]](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-charts)
7.  Application Insights overview + availability tests (if the scenarios include web apps/APIs). [\[61\]](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
8.  Network Insights overview (if the scenario emphasizes connectivity/perimeter). [\[60\]](https://learn.microsoft.com/en-us/azure/network-watcher/network-insights-overview)

## Cross-cutting gaps to close for exam-grade coverage

These topics cut across all three skill statements and often differentiate a “tool user” from an “architect answer”:

- **Access control & multi-team operations**: resource-context vs workspace-context, workspace access control modes, and table/row-level strategies (table-level RBAC and granular RBAC). [\[22\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access)
- **Multi-workspace strategy and cross-resource queries** (what you gain/lose with multiple workspaces; how to query across them; scale cautions when spanning many regions). [\[72\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design)
- **Cost governance as architecture**: table plans, retention/long-term retention, commitment tiers, and the “don’t use daily cap as primary filtering” principle. [\[73\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)
- **Network isolation and private access impacts** (AMPLS shared endpoints and DNS implications). [\[23\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-security)
- **At-scale enforcement**: using Azure Policy initiatives to apply diagnostic settings (and related monitoring controls) across an estate. [\[44\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy-built-in)

## Final source list grouped by domain

**Exam framing and Microsoft Learn starting points** - AZ-305 study guide (skills measured as of April 17, 2026). [\[1\]](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305)\
- Learning path: AZ-305 design identity, governance, and monitor solutions. [\[74\]](https://learn.microsoft.com/en-us/training/paths/design-identity-governance-monitor-solutions/)\
- Module: Design a solution to log and monitor Azure resources (and its units). [\[75\]](https://learn.microsoft.com/en-us/training/modules/design-solution-to-log-monitor-azure-resources/)

**Azure Monitor fundamentals and data model** - Azure Monitor overview. [\[50\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview)\
- Azure Monitor data platform. [\[6\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-platform)\
- Azure Monitor data sources and data collection methods. [\[7\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-sources)\
- Monitoring data reference (resource/metric/log reference entry point). [\[76\]](https://learn.microsoft.com/en-us/azure/azure-monitor/monitor-reference)

**Logs via Azure Monitor Logs (Log Analytics)** - Azure Monitor Logs overview (including table plan comparison). [\[8\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)\
- Design a Log Analytics workspace architecture. [\[10\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design)\
- Manage data retention in a Log Analytics workspace. [\[11\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure)\
- Select a table plan + manage Log Analytics tables. [\[77\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans)\
- Manage access + table access + granular RBAC. [\[78\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access)\
- Log query overview + log query scope + cross-workspace queries. [\[79\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-query-overview)\
- Query optimization + log alert query optimization. [\[80\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/query-optimization)\
- Cost docs: cost and usage, cost optimization, Logs cost calculations/options, daily cap, dedicated clusters. [\[81\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/cost-usage)

**Routing and ingestion pipelines** - Diagnostic settings (categories, category groups, limitations). [\[28\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings)\
- Activity log + resource logs. [\[82\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log)\
- DCRs, AMA, DCEs, VM guest log collection. [\[83\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview)\
- Workspace data export + streaming to Event Hubs. [\[84\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export)\
- Transformations (workspace transformation DCR concept). [\[39\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations)\
- Logs Ingestion API + ingest from Event Hubs. [\[85\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview)\
- Metrics exporting options (metrics export vs diagnostic settings vs REST API, and DCR-based metrics export). [\[86\]](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/metrics-index)

**Monitoring, alerting, and visualization** - Alerts: overview, types, best practices, action groups, alert processing rules. [\[87\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview)\
- Workbooks + Insights. [\[70\]](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview)\
- Service Health + Resource Health (and Service Health alert setup). [\[88\]](https://learn.microsoft.com/en-us/azure/service-health/overview)\
- Network Insights. [\[60\]](https://learn.microsoft.com/en-us/azure/network-watcher/network-insights-overview)\
- Application Insights overview + availability tests. [\[61\]](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)

**Cloud-native metrics (Prometheus/Grafana)** - Metrics overview (Prometheus vs native). [\[9\]](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-platform-metrics)\
- Azure Monitor with Prometheus + Azure Monitor workspace overview. [\[89\]](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/prometheus-metrics-overview?utm_source=chatgpt.com)

**Governance at scale for monitoring configuration** - Azure Policy overview (foundation). [\[90\]](https://learn.microsoft.com/en-us/azure/governance/policy/overview)\
- Diagnostic settings at scale: built-in and custom policy approaches + Azure Monitor policy reference. [\[91\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy-built-in)

**Well-Architected Framework and Cloud Adoption Framework guidance** - Performance efficiency checklist + collecting performance data (metrics/logs at different workload levels). [\[92\]](https://learn.microsoft.com/en-us/azure/architecture/framework/scalability/monitor)\
- CAF monitoring guidance for the estate-level mindset. [\[93\]](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor)

------------------------------------------------------------------------

[\[1\]](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305) Study guide for Exam AZ-305: Designing Microsoft Azure Infrastructure Solutions \| Microsoft Learn

<https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305>

[\[2\]](https://learn.microsoft.com/en-us/training/paths/design-identity-governance-monitor-solutions/) [\[3\]](https://learn.microsoft.com/en-us/training/paths/design-identity-governance-monitor-solutions/) [\[74\]](https://learn.microsoft.com/en-us/training/paths/design-identity-governance-monitor-solutions/) AZ-305: Design identity, governance, and monitor solutions - Training \| Microsoft Learn

<https://learn.microsoft.com/en-us/training/paths/design-identity-governance-monitor-solutions/>

[\[4\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-platform) [\[5\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-platform) [\[6\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-platform) Azure Monitor data platform - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/data-platform>

[\[7\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-sources) [\[27\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-sources) Azure Monitor data sources and data collection methods - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/data-sources>

[\[8\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs) [\[21\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs) [\[73\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs) Azure Monitor Logs - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs>

[\[9\]](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-platform-metrics) [\[66\]](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-platform-metrics) Metrics in Azure Monitor - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-platform-metrics>

[\[10\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design) [\[72\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design) Design a Log Analytics workspace architecture - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design>

[\[11\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure) Manage data retention in a Log Analytics workspace - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure>

[\[12\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans) [\[77\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans) Select a table plan based on data usage in a Log Analytics workspace - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans>

[\[13\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-query-overview) [\[79\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-query-overview) Log queries in Azure Monitor - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-query-overview>

[\[14\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs) [\[24\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs) Azure Monitor Logs cost calculations and options - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs>

[\[15\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/cost-usage) [\[81\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/cost-usage) Azure Monitor cost and usage - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/cost-usage>

[\[16\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables) Manage tables in a Log Analytics workspace - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables>

[\[17\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/best-practices-logs) Best practices for Azure Monitor Logs - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/logs/best-practices-logs>

[\[18\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/query-optimization) [\[80\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/query-optimization) Optimize log queries in Azure Monitor - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/logs/query-optimization>

[\[19\]](https://learn.microsoft.com/en-us/kusto/query/?view=microsoft-fabric&utm_source=chatgpt.com) [\[26\]](https://learn.microsoft.com/en-us/kusto/query/?view=microsoft-fabric&utm_source=chatgpt.com) Kusto Query Language (KQL) overview

<https://learn.microsoft.com/en-us/kusto/query/?view=microsoft-fabric&utm_source=chatgpt.com>

[\[20\]](https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview) What is Azure Data Explorer? - Azure Data Explorer \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview>

[\[22\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access) [\[25\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access) [\[78\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access) Manage access to Log Analytics workspaces - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access>

[\[23\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-security) [\[43\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-security) Use Azure Private Link to connect networks to Azure Monitor - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-security>

[\[28\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings) [\[47\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings) Diagnostic Settings in Azure Monitor - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings>

[\[29\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs) Resource logs in Azure Monitor - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs>

[\[30\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log) [\[82\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log) Azure Monitor activity log - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log>

[\[31\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview) [\[45\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview) [\[48\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview) [\[83\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview) Data collection rules in Azure Monitor - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview>

[\[32\]](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview) Azure Monitor Agent Overview - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview>

[\[33\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export) [\[84\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export) Log Analytics workspace data export in Azure Monitor - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export>

[\[34\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/stream-monitoring-data-event-hubs) [\[46\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/stream-monitoring-data-event-hubs) Stream Azure monitoring data to an event hub and external partners - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/platform/stream-monitoring-data-event-hubs>

[\[35\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy-built-in) [\[44\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy-built-in) [\[91\]](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy-built-in) Enable Diagnostic Settings by Category Group Using Built-in Policies - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy-built-in>

[\[36\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/policy-reference) Built-in policy definitions for Azure Monitor - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/policy-reference>

[\[37\]](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection) Collect log data from virtual machines with Azure Monitor - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection>

[\[38\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-endpoint-overview?utm_source=chatgpt.com) Data collection endpoints in Azure Monitor

<https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-endpoint-overview?utm_source=chatgpt.com>

[\[39\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations) Transformations Azure Monitor - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations>

[\[40\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview) [\[85\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview) Logs Ingestion API in Azure Monitor - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview>

[\[41\]](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/ingest-logs-event-hub) Ingest events from Azure Event Hubs into Azure Monitor Logs (Preview) - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/logs/ingest-logs-event-hub>

[\[42\]](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-plane-versus-metrics-export) Metrics export feature comparison - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-plane-versus-metrics-export>

[\[49\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview) [\[50\]](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview) Azure Monitor overview - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview>

[\[51\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview) [\[67\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview) [\[87\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview) Overview of Azure Monitor alerts - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview>

[\[52\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/best-practices-alerts) Best practices for Azure Monitor alerts - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/best-practices-alerts>

[\[53\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups?utm_source=chatgpt.com) [\[68\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups?utm_source=chatgpt.com) Create and manage action groups in Azure Monitor

<https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups?utm_source=chatgpt.com>

[\[54\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-processing-rules) Alert processing rules for Azure Monitor alerts - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-processing-rules>

[\[55\]](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview) [\[70\]](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview) Azure Workbooks overview - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview>

[\[56\]](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/insights-overview) Azure Monitor Insights Overview - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/insights-overview>

[\[57\]](https://learn.microsoft.com/en-us/azure/service-health/overview) [\[65\]](https://learn.microsoft.com/en-us/azure/service-health/overview) [\[69\]](https://learn.microsoft.com/en-us/azure/service-health/overview) [\[88\]](https://learn.microsoft.com/en-us/azure/service-health/overview) What is Azure Service Health? - Azure Service Health \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/service-health/overview>

[\[58\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule?utm_source=chatgpt.com) Create or edit an activity log, service health, or resource ...

<https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule?utm_source=chatgpt.com>

[\[59\]](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-charts) [\[71\]](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-charts) Analyze metrics with Azure Monitor metrics explorer - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-charts>

[\[60\]](https://learn.microsoft.com/en-us/azure/network-watcher/network-insights-overview) Network Insights \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/network-watcher/network-insights-overview>

[\[61\]](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) Application Insights OpenTelemetry observability overview - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview>

[\[62\]](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/prometheus-metrics-overview?utm_source=chatgpt.com) [\[89\]](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/prometheus-metrics-overview?utm_source=chatgpt.com) Overview of Azure Monitor with Prometheus

<https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/prometheus-metrics-overview?utm_source=chatgpt.com>

[\[63\]](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor) [\[93\]](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor) Monitor your Azure cloud estate - Cloud Adoption Framework \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor>

[\[64\]](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types) Types of Azure Monitor alerts - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types>

[\[75\]](https://learn.microsoft.com/en-us/training/modules/design-solution-to-log-monitor-azure-resources/) Design a Solution to Log and Monitor Azure Resources - Training \| Microsoft Learn

<https://learn.microsoft.com/en-us/training/modules/design-solution-to-log-monitor-azure-resources/>

[\[76\]](https://learn.microsoft.com/en-us/azure/azure-monitor/monitor-reference) Monitoring data reference for Azure Monitor - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/monitor-reference>

[\[86\]](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/metrics-index) Azure Monitor supported metrics by resource type - Azure Monitor \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/azure-monitor/reference/metrics-index>

[\[90\]](https://learn.microsoft.com/en-us/azure/governance/policy/overview) Overview of Azure Policy - Azure Policy \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/governance/policy/overview>

[\[92\]](https://learn.microsoft.com/en-us/azure/architecture/framework/scalability/monitor) Design review checklist for Performance Efficiency - Microsoft Azure Well-Architected Framework \| Microsoft Learn

<https://learn.microsoft.com/en-us/azure/architecture/framework/scalability/monitor>
