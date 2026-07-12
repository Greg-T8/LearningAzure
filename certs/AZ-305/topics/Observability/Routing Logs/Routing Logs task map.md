## Domain: Design identity, governance, and monitoring solutions

### Skill: Design solutions for logging and monitoring

#### Task: Recommend a solution for routing logs

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor data sources](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources) | <https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources> | Provides the source-first map for a routing design: Azure resources, the subscription activity log, Microsoft Entra ID, applications, virtual machines, Kubernetes, and custom sources use different collection and routing mechanisms. |
| [Diagnostic settings in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings) | <https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings> | Documents the primary routing mechanism for Azure platform telemetry. Diagnostic settings send resource logs, the activity log, and platform metrics to Log Analytics, Storage, Event Hubs, or supported partner solutions. It also covers scenario-driving constraints such as the five-setting limit, one destination of each type per setting, regional requirements, and firewall considerations. |
| [Azure Monitor resource logs](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs) | <https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs> | Explains how data-plane resource logs behave at each destination and compares Azure Diagnostics mode with resource-specific tables. The choice affects schema, query performance, per-table RBAC, and cost. |
| [Azure Activity Log](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log) | <https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log> | Covers control-plane events at subscription and management-group scope, their default 90-day retention, and export through diagnostic settings to Log Analytics, Storage, or Event Hubs for longer retention and downstream use. |
| [Data collection rules in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview> | Defines the DCR routing model: what to collect, how to transform it, and where to send it. DCRs support Azure Monitor Agent, direct ingestion, Event Hubs ingestion, and platform-metric export, with data collection rule associations connecting rules to monitored resources. |
| [Data collection transformations](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations) | <https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations> | Supports filtering, parsing, reshaping, aggregating, or splitting records before delivery. Transformation placement and dropped-data volume affect ingestion cost, while output-stream design determines which destination tables receive the data. |
| [Azure Monitor Agent overview](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview> | Covers collection of guest OS and workload telemetry—including Windows events, Syslog, performance counters, IIS logs, and text logs—from Azure and Azure Arc-enabled machines through DCRs to Azure Monitor Logs and Microsoft Sentinel. |
| [Azure Monitor pipeline](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview> | Supports edge, on-premises, and multicloud designs that need local filtering, aggregation, buffering during disconnection, or centrally governed routing before telemetry reaches Azure. |
| [Design a Log Analytics workspace architecture](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design> | Addresses which workspace should receive the logs. Single- versus multiple-workspace decisions depend on region and data residency, operational versus security ownership, RBAC, Microsoft Sentinel placement, retention, billing, and commitment tiers. |
| [Log Analytics workspace data export](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export> | Covers post-ingestion routing. Data export rules continuously send selected workspace tables to Azure Blob Storage or Event Hubs for archive, external tooling, and downstream processing after data has landed in Log Analytics. |
| [Deploy diagnostic settings at scale by using Azure Policy](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy) | <https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy> | Supports governance at scale with policy definitions, initiatives, and remediation tasks that automatically deploy diagnostic settings across management groups, subscriptions, resource groups, and resource types. |
| [Integrate Microsoft Entra logs with Azure Monitor](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-integrate-activity-logs-with-azure-monitor-logs) | <https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-integrate-activity-logs-with-azure-monitor-logs> | Covers tenant-level routing of audit, sign-in, provisioning, and Identity Protection logs to Log Analytics, Storage, or Event Hubs, including integration with Microsoft Sentinel. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about> | Provides the high-throughput streaming destination for near-real-time forwarding to non-Microsoft SIEMs, Kafka-compatible consumers, external analytics, and event-processing pipelines. |
| [Immutable storage for Azure Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview> | Provides the low-cost compliance archive option. WORM immutability, time-based retention, and legal holds support tamper-resistant preservation of routed audit data. |
| [Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/overview) | <https://learn.microsoft.com/en-us/azure/sentinel/overview> | Supports the SIEM/SOAR destination when security events require correlation, threat detection, investigation, hunting, and automated response across Azure, hybrid, and multicloud sources. |
| [Virtual network flow logs](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview) | <https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview> | Covers a network-specific path in which virtual network flow logs are written to Storage and can feed Traffic Analytics or external SIEM and IDS tooling for analysis, compliance, and forensics. |

### Routing decision framework

Choose the routing mechanism from the source first, then choose a destination from the required outcome. Workspace topology, governance, and cost refine the design after those two decisions.

| Log source or stage | Preferred routing mechanism | Key design consideration |
|---|---|---|
| Azure resource logs and platform metrics | Diagnostic settings | Select categories or category groups and account for destination, region, firewall, and per-resource setting limits. |
| Azure Activity Log | Subscription- or management-group-level diagnostic settings | Export when retention beyond the built-in period, centralized querying, or external streaming is required; avoid unintended duplication across hierarchy scopes. |
| Microsoft Entra audit, sign-in, provisioning, and risk logs | Microsoft Entra diagnostic settings | Route at tenant scope and align the workspace with identity operations or Microsoft Sentinel. |
| Guest OS and workload logs from Azure or Azure Arc machines | Azure Monitor Agent with DCRs and DCR associations | Use DCRs to select streams, transform records, and control destinations consistently across machines. |
| Custom applications and direct-ingestion sources | Logs Ingestion API with DCRs | Define the input stream, transformation, target table, and data collection endpoint where required. |
| Edge, on-premises, or multicloud telemetry requiring local processing | Azure Monitor pipeline | Use when filtering, aggregation, buffering, or routing must occur before cloud ingestion. |
| Logs already stored in Log Analytics | Workspace data export | Continuously export selected tables to Blob Storage or Event Hubs; this is a second routing stage and does not replace initial collection. |
| Virtual network flow logs | Network Watcher flow-log path | Treat this as a storage-first network logging flow rather than a normal resource diagnostic-setting route. |

| Requirement | Recommended destination | Why |
|---|---|---|
| Interactive queries, KQL analytics, alerts, workbooks, and operational troubleshooting | Log Analytics workspace | Provides centralized analysis and Azure Monitor integration. |
| Long-term, low-cost, immutable, or compliance retention | Azure Storage, with immutability when required | Optimized for archive and tamper-resistant retention rather than interactive analysis. |
| Near-real-time forwarding to an external SIEM or processing pipeline | Event Hubs | Decouples producers from high-throughput streaming consumers, including Kafka-compatible tools. |
| Threat detection, security correlation, hunting, and automated response | Microsoft Sentinel-enabled Log Analytics workspace | Adds cloud-native SIEM and SOAR capabilities to collected security data. |
| Direct integration with a supported third-party observability platform | Azure Monitor partner solution | Use when the scenario names or requires a supported partner destination. |

Potentially relevant products considered: Azure Monitor, Azure Monitor Logs, Log Analytics workspaces, diagnostic settings, Azure Activity Log, Azure resource logs, platform metrics, Data Collection Rules, Data Collection Endpoints, data collection rule associations, DCR transformations, Azure Monitor Agent, Azure Monitor pipeline, Logs Ingestion API, Log Analytics data export, Azure Event Hubs, Azure Blob Storage, immutable storage, Azure Data Lake Storage Gen2, Microsoft Entra monitoring and health, Microsoft Sentinel, Microsoft Defender for Cloud, Network Watcher, virtual network flow logs, Traffic Analytics, Application Insights, Container insights, Azure Monitor partner solutions, Azure Policy, and Azure Arc.

Forum-discovery note: Public AZ-305 candidate discussions repeatedly surface diagnostic-setting destinations, Log Analytics workspace design, Data Collection Rules and Azure Monitor Agent, Microsoft Sentinel integration, and Azure Policy enforcement. These are discovery signals only; the supporting references above are official Microsoft documentation.

Coverage notes:

- The task is centered on Azure Monitor, but relevant guidance spans platform telemetry, data collection, agents, workspaces, identity logs, network logs, export, and destination services.
- The primary exam pattern has two decisions: select the mechanism that matches the source, then select the destination that matches the required use—analysis, archive, streaming, security operations, or partner integration.
- For diagnostic-setting scenarios, remember the maximum of five settings per resource, one destination of each type per setting, regional destination rules for regional resources, and networking requirements such as trusted Microsoft services access when a destination firewall is enabled.
- Log Analytics workspace architecture is part of the routing recommendation. Region and sovereignty, RBAC and ownership, Microsoft Sentinel, retention, and cost can justify one or multiple workspaces.
- Transform data as early as practical when it reduces noise or normalizes schemas, but evaluate ingestion and transformation charges before using filtering primarily as a cost-control mechanism.
- Use Azure Policy with remediation to enforce diagnostic settings at scale instead of relying on manual configuration for every resource.
- Distinguish initial routing from post-ingestion export: diagnostic settings and DCRs collect data into destinations, while Log Analytics data export forwards selected tables after ingestion.
- Lightly covered but testable adjacent topics include Azure Arc for hybrid collection, Application Insights and Container insights routing, Defender for Cloud security data, Azure Data Explorer for high-volume analytics, and partner observability integrations.

---

_Combined and reconciled from the Fable 5, GPT 5.5, and Opus 4.8 task maps. Source URLs and validation notes originated in those drafts._
