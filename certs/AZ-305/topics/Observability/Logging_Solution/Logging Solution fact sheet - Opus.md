# Deep Technical Facts and Requirements for Recommend a Logging Solution

## Scope

- Exam: AZ-305: Designing Microsoft Azure Infrastructure Solutions
- Task: Design solutions for logging and monitoring — Recommend a logging solution
- Source guide: "AZ-305 Study Guide: Recommend a logging solution" plus the matching Study Guide Map ("Logging Solution task map")
- Product selection method: Products and major topics were extracted from the provided guide and map, then validated against current official Microsoft documentation. Fast-changing facts (agent retirements, NSG flow log retirement, table plans and retention, classic Application Insights retirement, Sentinel platform changes) were re-verified against Microsoft Learn as of June 2026 and discrepancies with the guide are flagged where relevant.

## Product coverage summary

| Product / topic | Classification | Why it matters for this task |
|---|---|---|
| Azure Monitor | Core | The umbrella platform that frames the whole logging recommendation. |
| Azure Monitor Logs / Log Analytics workspace | Core | The query, retention, and table-plan engine for log data. |
| Log Analytics workspace architecture | Core / Architecture guidance | Drives single-vs-multiple workspace, residency, RBAC, and cost decisions. |
| Diagnostic settings | Core | The routing mechanism for platform, activity, and resource logs. |
| Activity Log and resource logs | Core | The two main Azure-emitted log categories and their default behavior. |
| Data Collection Rules (DCRs) | Core | Modern, scalable configuration for what is collected, transformed, and routed. |
| Azure Monitor Agent (AMA) | Core | The only supported agent for VM and hybrid guest-OS log collection. |
| Application Insights | Core | Application-level telemetry, traces, and distributed tracing. |
| Microsoft Entra monitoring and logs | Supporting | Identity sign-in, audit, and provisioning logs and their routing. |
| Virtual network flow logs (Network Watcher) | Supporting | Network traffic logging; replaces retiring NSG flow logs. |
| Microsoft Sentinel | Supporting (security) | SIEM/SOAR layer when correlation, detection, and hunting are required. |
| Azure Data Explorer (ADX) | Adjacent | High-volume, low-latency, custom-schema log analytics edge cases. |
| Azure Blob Storage | Supporting | Low-cost long-term archival and immutable compliance retention. |
| Azure Event Hubs | Supporting | Streaming export to third-party SIEM and external analytics. |
| Azure Well-Architected Framework (observability) | Framework / methodology | Principles for deciding what to collect and why. |
| Azure Policy, Azure Arc, Defender for Cloud, Container insights | Adjacent / limited relevance | Enforcement, hybrid reach, security posture, and AKS specifics. |

---

## Azure Monitor

**Classification:** Core
**Why it matters:** Azure Monitor is the platform the whole task sits inside. Scenario answers are usually "a specific Azure Monitor feature," so you must know which feature owns which job.
**Primary Microsoft source:** <https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview>

### Deep technical facts / requirements

1. Azure Monitor splits data into two fundamental types: metrics (numeric, time-series, near-real-time, stored in a time-series database) and logs (structured or text records stored in a Log Analytics workspace and queried with KQL). A logging recommendation almost always lands on the logs side, not the metrics store.
2. Metrics and logs have different retention models. Platform metrics are retained for a fixed window (93 days) in the metrics store, while log retention is configurable per table in a Log Analytics workspace. If a scenario needs "long retention of numeric data," you route metrics to logs or Storage rather than relying on the metrics store.
3. Azure Monitor collects from platform sources (Activity Log, resource logs, platform metrics) and from instrumented sources (agents, SDKs, Application Insights). Knowing the source determines the collection mechanism, which is the most common exam discriminator in this task.
4. Azure Monitor is the routing and analysis layer, not a single store. The same log can be sent to multiple destinations simultaneously (Log Analytics for query, Storage for archive, Event Hubs for export), and good answers often combine destinations rather than picking one.
5. Alerts, workbooks, dashboards, and health models are monitoring features built on top of collected data. For the "Recommend a logging solution" task, treat those as out of scope except as the consumers that justify collecting and retaining the data.
6. Azure Monitor reaches beyond Azure. With agents and Azure Arc it collects from on-premises and other-cloud machines, so "hybrid logging" is in scope and usually points to AMA plus Arc rather than a separate product.

### AZ-305 exam discriminator

When a scenario lists a requirement, map it to the owning Azure Monitor feature: control-plane "who changed what" goes to Activity Log; service-internal diagnostics go to resource logs via diagnostic settings; guest-OS logs go to AMA with DCRs; application telemetry goes to Application Insights.

### Common trap

Treating "Azure Monitor" as a single destination. Azure Monitor is the platform; the destination is a Log Analytics workspace, a Storage account, or an Event Hub. Answers that say "send to Azure Monitor" without naming the destination are usually the distractor.

---

## Azure Monitor Logs and Log Analytics workspaces

**Classification:** Core
**Why it matters:** The Log Analytics workspace is where queryable logs live, and its table plans and retention settings are the levers that control both capability and cost.
**Primary Microsoft source:** <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs>

### Deep technical facts / requirements

1. A Log Analytics workspace is the unit of query, retention, RBAC boundary, and billing for Azure Monitor Logs. KQL queries run within a workspace (or across workspaces explicitly), so workspace placement directly affects what can be correlated in a single query.
2. There are three table plans, selected per table, not per workspace: Analytics, Basic, and Auxiliary. Choosing the wrong plan is a cost and capability error, not just a tuning detail.
3. Analytics plan tables support full KQL, alerts, and dashboards. Default interactive retention is 30 days and can be raised up to 730 days (2 years). The first 31 days are included in the ingestion price, so reducing below 31 days does not save money.
4. Basic plan tables target high-volume, low-value verbose logs. They have a fixed 30-day interactive query period, cheaper ingestion, and per-query charges based on data scanned. Only supported tables (DCR-based custom tables and some Azure tables) can use Basic, and you can switch a table between Analytics and Basic with the change applying to existing data immediately.
5. Auxiliary plan tables are the cheapest ingestion tier and are intended for very verbose data. They can be set only on DCR-based custom tables created through the API, the plan cannot be changed after creation, and they support search jobs but not data restore.
6. Long-term retention (formerly called "Archive") extends a table's total retention up to 12 years. Data past the interactive period is still stored but is reachable only through search jobs or restore, not interactive query. This is the native alternative to dumping logs into Storage.
7. Search jobs run across Analytics, Basic, and long-term retention data and pull matching records into a new Analytics table for analysis. Restore (Analytics and Basic only, not Auxiliary) rehydrates a time range into a high-performance hot cache for interactive query.
8. Basic and Auxiliary plans are not available on legacy (per-node / per-GB legacy) pricing tiers, and Auxiliary data is not replicated by Log Analytics workspace replication, so Auxiliary tables are not protected against a regional failure.
9. Summary rules let you run scheduled KQL aggregations against Basic or Auxiliary data and write compact results into an Analytics table, which keeps frequently queried summaries cheap while raw verbose data stays in a low-cost tier.

### AZ-305 exam discriminator

Table plan choice is the lever for "reduce cost without losing the data." Verbose, rarely queried logs go to Basic or Auxiliary; logs that drive alerts and dashboards stay Analytics. Long-term retention (up to 12 years) is the in-workspace answer to "retain for years but rarely query," competing with Storage archive.

### Common trap

Assuming you can flip any table to Basic or Auxiliary to save money. Auxiliary is custom-table-only and permanent; Basic is limited to supported tables and changes query behavior to a fixed 30-day window with per-scan charges. Blanket plan changes break alerting and dashboards that depend on Analytics tables.

---

## Log Analytics workspace architecture

**Classification:** Core / Architecture guidance
**Why it matters:** Workspace topology is the single most testable design decision in this task: one versus many, where they live, who can read them, and how data residency and cost are handled.
**Primary Microsoft source:** <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design>

### Deep technical facts / requirements

1. Microsoft's default guidance is to start with a single workspace and add more only when a specific requirement forces separation. Fewer workspaces means simpler correlation, fewer cross-workspace queries, and easier management.
2. Legitimate reasons to split workspaces include data residency or sovereignty (data must stay in a region), separation of operational and security data, different retention or access requirements per data set, and isolation for chargeback across business units.
3. Workspace data is stored in the workspace's region. Cross-region collection is supported but can incur data egress, and strict residency requirements drive region-specific workspaces. A single global workspace is usually wrong when the scenario states data must remain in-country.
4. Access control offers several models: workspace-context (permissions granted at the workspace, user sees all tables) versus resource-context (users see only logs for resources they have access to). Resource-context RBAC often removes the need to split workspaces purely for access isolation.
5. Table-level RBAC lets you restrict access to specific tables within a single workspace, which is another way to avoid creating extra workspaces just to hide sensitive data from some teams.
6. Retention can be set at the workspace default and overridden per table. A table whose retention you have already changed is not affected when you later change the workspace default, which is a subtle behavior worth knowing for compliance scenarios.
7. Charges (ingestion and retention) accrue per workspace, so workspace boundaries are also cost-allocation boundaries. Multiple workspaces can make chargeback cleaner but add operational overhead and complicate cross-workspace KQL.
8. Microsoft Sentinel is enabled on a workspace, and that decision interacts with topology: a security workspace dedicated to Sentinel is a common reason to separate security logs from operational logs.

### AZ-305 exam discriminator

Watch for the trigger words. "Data must stay in region / country" forces regional workspaces. "Separate SOC from operations" suggests an operations workspace plus a security workspace (often Sentinel-enabled). Absent such triggers, a single workspace is the expected answer.

### Common trap

Defaulting to one workspace per subscription, per team, or per application "for separation." That creates workspace sprawl, breaks single-query correlation, and is the wrong answer unless a residency, security-separation, retention, or chargeback requirement is explicitly stated.

---

## Diagnostic settings

**Classification:** Core
**Why it matters:** Diagnostic settings are the routing control for Azure platform logs and metrics. Without them, most resource logs are simply never collected.
**Primary Microsoft source:** <https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings>

### Deep technical facts / requirements

1. Resource logs are not collected by default. Until a diagnostic setting is created on a resource, its resource logs are emitted nowhere. This is one of the most frequently tested facts in the entire task.
2. A diagnostic setting routes platform logs and platform metrics to one or more destinations: a Log Analytics workspace, an Azure Storage account, an Azure Event Hub, or a partner/marketplace solution.
3. A single resource supports up to 5 diagnostic settings. Each setting can send a chosen set of log categories and metrics to its destinations, so you can fan out the same logs to query, archive, and export targets.
4. The Activity Log uses the same diagnostic-settings export mechanism to send subscription-level control-plane logs to a workspace, Storage, or Event Hubs for retention beyond the built-in window.
5. When sending resource logs to Log Analytics, many services support resource-specific tables (dedicated, well-typed tables) in addition to the legacy AzureDiagnostics shared table. Resource-specific mode is the recommended choice for new designs because it is cheaper to query and better structured.
6. Diagnostic settings are per-resource by default, which makes them tedious at scale. The standard answer for scale is Azure Policy with DeployIfNotExists to enforce diagnostic settings automatically across new and existing resources.
7. Diagnostic settings cover platform logs and metrics. They do not collect guest-OS logs from inside a VM; that requires the Azure Monitor Agent with DCRs. Mixing these two collection paths up is a classic exam trap.

### AZ-305 exam discriminator

"Collect firewall / Key Vault / database / service diagnostics" points to diagnostic settings. "Enforce diagnostic settings across the whole subscription or management group" points to Azure Policy. "Send the same logs to an external SIEM and keep a copy for query" points to one diagnostic setting with both Event Hubs and Log Analytics destinations.

### Common trap

Assuming resource logs flow automatically once a workspace exists. They do not. The missing diagnostic setting is the reason logs are absent, and "create a diagnostic setting" (or enforce it with Policy) is usually the intended fix.

---

## Activity Log and resource logs

**Classification:** Core
**Why it matters:** These are the two main Azure-emitted log categories, and the exam tests when to use which and what their default retention is.
**Primary Microsoft source:** <https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/activity-log>

### Deep technical facts / requirements

1. The Activity Log is a subscription-level control-plane log: it records management operations through Azure Resource Manager, such as who created, updated, or deleted a resource and the result. It answers "who did what to the resource," not "what happened inside the resource."
2. The Activity Log is retained for 90 days in the platform at no cost. To keep it longer or to query it alongside other logs, you export it via a diagnostic setting to Log Analytics, Storage, or Event Hubs.
3. Resource logs (formerly "diagnostic logs") are data-plane and service-internal logs emitted by a resource, such as Key Vault access, firewall traffic decisions, or database query activity. Their content and categories vary per service.
4. Resource logs require an explicit diagnostic setting to be collected anywhere; there is no default retention for them inside the resource.
5. The Activity Log distinguishes categories such as Administrative, Security, Service Health, Resource Health, Alert, Autoscale, and Policy. Scenarios about service or resource health point at the Activity Log's health categories rather than at resource logs.
6. Control-plane versus data-plane is the key mental model: configuration and lifecycle changes are control-plane (Activity Log); operations the service performs on data are data-plane (resource logs).

### AZ-305 exam discriminator

"Who changed / deleted / modified this Azure resource?" is the Activity Log. "What operations did the service perform, or who accessed the data?" is resource logs. "Keep audit records longer than 90 days" means export the Activity Log via a diagnostic setting.

### Common trap

Believing the Activity Log captures in-resource activity, or that resource logs are on by default. The Activity Log is control-plane only, and resource logs collect nothing until a diagnostic setting routes them.

---

## Data Collection Rules (DCRs)

**Classification:** Core
**Why it matters:** DCRs are the modern, central way to define what gets collected, how it is transformed, and where it goes. They are the configuration backbone behind the Azure Monitor Agent and several ingestion paths.
**Primary Microsoft source:** <https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview>

### Deep technical facts / requirements

1. A DCR defines data sources (what to collect), optional transformations (a KQL-based filter or reshape at ingestion), and destinations (where to send it). It decouples collection configuration from the agent or resource it applies to.
2. DCRs associate to targets such as VMs and Arc-enabled servers through Data Collection Rule Associations (DCRAs). One DCR can be associated to many machines, and one machine can have multiple DCRs, enabling centralized, reusable collection definitions.
3. Ingestion-time transformations run inside the pipeline before data lands in the workspace. They can drop columns, filter rows, mask sensitive fields, or route to specific tables, which reduces ingestion cost and helps meet privacy requirements at the source.
4. DCRs are the modern replacement for legacy agent configuration. The retired Log Analytics agent stored its collection config in the workspace; AMA reads it from DCRs, which is why new designs are DCR-based.
5. DCRs power more than VM agents. The Logs Ingestion API and custom-table ingestion paths also use DCRs, and Auxiliary-plan custom tables are created and fed through DCR-based API ingestion.
6. A single DCR can fan data to multiple destinations and can target multiple tables, supporting patterns like "send security events to a security table and performance counters to another" from one rule.
7. DCRs are themselves Azure resources, so they can be deployed, versioned, and enforced with ARM/Bicep templates and Azure Policy, which is how guest-log collection gets standardized at scale.

### AZ-305 exam discriminator

When a scenario needs source-side filtering, transformation, masking, or "collect different things from different machine groups," the answer involves DCRs. When it needs that collection enforced fleet-wide, pair DCRs with Azure Policy and AMA.

### Common trap

Thinking DCRs are only an agent setting. They are a general ingestion-pipeline construct used by AMA, the Logs Ingestion API, and custom tables, and they are the right place to put cost-saving filters and privacy transformations.

---

## Azure Monitor Agent (AMA)

**Classification:** Core
**Why it matters:** AMA is the only supported agent for collecting guest-OS logs from Azure VMs and hybrid machines. Legacy agents are retired, so new designs must use AMA.
**Primary Microsoft source:** <https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview>

### Deep technical facts / requirements

1. AMA collects guest-OS data such as Windows Event Logs, Syslog, performance counters, IIS logs, and text/JSON file-based logs. This is data from inside the operating system that diagnostic settings cannot reach.
2. The legacy Log Analytics agent (also known as MMA, the Microsoft Monitoring Agent) was retired on 31 August 2024. New designs must use AMA, and "use the Log Analytics agent" is a wrong answer on current exams. The provided study guide's "avoid the retired Log Analytics agent" note matches the current Microsoft position.
3. AMA is configured entirely through DCRs. There is no in-agent configuration to edit; what the agent collects and where it sends it is defined in associated DCRs.
4. AMA supports multiple destinations from a single agent and source-side filtering, which the legacy agent could not do. This reduces ingestion cost and avoids deploying multiple agents.
5. For on-premises and other-cloud servers, AMA runs on Azure Arc-enabled servers. The pattern "collect logs from on-premises VMs" is Azure Arc plus AMA plus DCRs, not a VPN or a manual export.
6. AMA is deployed as a VM extension and can be rolled out and kept associated to DCRs at scale using Azure Policy, which is the standard fleet-wide enablement approach.
7. AMA also underpins several higher-level features (for example VM insights and the current Change Tracking and Inventory), so migrating off legacy agents is a prerequisite for those features going forward.

### AZ-305 exam discriminator

"Collect Windows Event Logs, Syslog, or IIS logs from VMs" means AMA with DCRs. "Collect those logs from on-premises or multicloud servers" means Azure Arc plus AMA. Diagnostic settings never collect guest-OS logs.

### Common trap

Selecting the Log Analytics agent / MMA, or assuming a VM's guest logs appear in the workspace automatically. The legacy agent is retired, and guest-OS collection requires AMA plus an associated DCR.

---

## Application Insights

**Classification:** Core
**Why it matters:** Application Insights is the answer whenever the requirement is application-level telemetry: requests, dependencies, exceptions, traces, and distributed transaction tracking.
**Primary Microsoft source:** <https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview>

### Deep technical facts / requirements

1. Application Insights captures application telemetry that infrastructure logging cannot: request rates and durations, dependency calls, exceptions, page views, custom events, and end-to-end distributed traces across services.
2. Application Insights is now workspace-based, meaning its data is stored in a Log Analytics workspace. Classic (non-workspace) Application Insights was deprecated on 29 February 2024, automatic migration of remaining classic resources began in April 2025, and classic resources not migrated by 31 July 2025 were disabled. New designs must be workspace-based.
3. Because telemetry lands in a Log Analytics workspace, you can query application data with KQL alongside infrastructure and platform logs and apply unified workspace RBAC, which is a key advantage over the retired classic model.
4. Application Insights supports OpenTelemetry-based instrumentation, which is Microsoft's recommended path for new applications and provides vendor-neutral traces, metrics, and logs.
5. Distributed tracing correlates a single transaction across multiple components using operation IDs, enabling the application map and end-to-end transaction views. This is the discriminator when a scenario mentions "trace a request across microservices."
6. Availability tests (synthetic monitoring) probe an endpoint from multiple regions and record results as telemetry, which is how Application Insights answers "verify the app is reachable from outside."
7. Sampling reduces telemetry volume (and cost) while preserving statistically representative data and keeping related items of a transaction together, which matters for high-traffic apps with ingestion-cost constraints.

### AZ-305 exam discriminator

"Requests, dependencies, exceptions, traces, or distributed transactions" points to Application Insights, not to VM agents or diagnostic settings. If the scenario also needs the data queried with other logs, the workspace-based model already provides that.

### Common trap

Proposing classic Application Insights or a standalone instance disconnected from a workspace. Classic is retired; the correct design is workspace-based Application Insights linked to a Log Analytics workspace.

---

## Microsoft Entra monitoring and logs

**Classification:** Supporting
**Why it matters:** Identity logs (sign-in, audit, provisioning) are a distinct source with their own routing and retention rules, and they are central to security and compliance scenarios.
**Primary Microsoft source:** <https://learn.microsoft.com/en-us/entra/identity/monitoring-health/overview-monitoring-health>

### Deep technical facts / requirements

1. Microsoft Entra produces several log types: sign-in logs, audit logs, and provisioning logs, plus risk-related data. These are tenant-level identity logs, not Azure subscription resource logs.
2. Entra log default retention in the directory depends on license: typically 7 days without Entra ID P1/P2 and up to 30 days with P1/P2. To retain longer, you must route the logs out.
3. Entra logs are routed using Entra diagnostic settings (a separate configuration from resource diagnostic settings) to a Log Analytics workspace, a Storage account, or an Event Hub.
4. Sending Entra logs to Log Analytics enables KQL query and correlation with other logs; sending to Storage supports cheap long-term retention; sending to Event Hubs supports third-party SIEM ingestion. The destination choice mirrors the general logging-destination tradeoff.
5. Entra logs are a primary feed for Microsoft Sentinel via a data connector, which is the path when the requirement is identity-focused threat detection and investigation.
6. Sign-in logs answer "who signed in, from where, with what result, and was it risky," while audit logs answer "what directory changes were made," so the two are not interchangeable in a scenario.

### AZ-305 exam discriminator

"Retain or analyze sign-in and audit logs beyond the default window" means configure Entra diagnostic settings to a workspace (query), Storage (archive), or Event Hubs (SIEM). Identity-driven security correlation adds Sentinel.

### Common trap

Assuming Azure resource diagnostic settings cover identity logs, or that Entra retains logs indefinitely. Entra has its own diagnostic-settings export, and default in-directory retention is short (7 to 30 days by license).

---

## Virtual network flow logs (Network Watcher)

**Classification:** Supporting
**Why it matters:** Network traffic logging is a recurring source, and the correct product changed because NSG flow logs are being retired in favor of virtual network flow logs.
**Primary Microsoft source:** <https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview>

### Deep technical facts / requirements

1. Virtual network (VNet) flow logs record IP traffic flowing through a virtual network: source and destination IP, port, protocol, and whether traffic was allowed or denied. They are the current recommended network flow logging feature.
2. NSG flow logs are being retired. New NSG flow logs cannot be created after 30 June 2025, and NSG flow logs reach full retirement on 30 September 2027, after which the resources are deleted (existing blobs in Storage remain per their retention policy). New designs must use VNet flow logs.
3. VNet flow logs are configured at the virtual network, subnet, or NIC scope and do not depend on a network security group being present, which gives broader coverage than NSG flow logs.
4. Flow logs are written to an Azure Storage account in JSON. Storage is the native landing zone; Log Analytics is not the direct target for the raw flow logs.
5. Traffic Analytics is the optional enrichment layer: it processes flow logs and sends aggregated, enriched results to a Log Analytics workspace for KQL query and visualization. If a scenario wants to query flows in KQL, the answer is "enable Traffic Analytics," not "send flow logs straight to a workspace."
6. Flow logs support security and compliance use cases such as detecting unexpected traffic, validating segmentation, and forensic investigation, and they can be exported to a SIEM via the Storage account or downstream pipelines.

### AZ-305 exam discriminator

"Log IP traffic through a virtual network" for a new design means VNet flow logs. "Query and visualize network flows" means VNet flow logs with Traffic Analytics into a workspace. Choosing NSG flow logs for a new design is now incorrect.

### Common trap

Recommending NSG flow logs, or expecting raw flow logs to appear directly in Log Analytics. NSG flow logs are retiring; raw flow logs go to Storage, and Traffic Analytics is what lands enriched data in a workspace.

---

## Microsoft Sentinel

**Classification:** Supporting (security)
**Why it matters:** Sentinel is the answer when logging must support SIEM/SOAR: security correlation, detection, investigation, hunting, and automated response. It is built on a Log Analytics workspace.
**Primary Microsoft source:** <https://learn.microsoft.com/en-us/azure/sentinel/overview>

### Deep technical facts / requirements

1. Microsoft Sentinel is a cloud-native SIEM and SOAR that is enabled on top of a Log Analytics workspace. It is not a separate log store; it adds security analytics, incidents, hunting, workbooks, and playbooks to the data already in the workspace.
2. Enabling Sentinel on a workspace adds Sentinel charges on top of Log Analytics ingestion and retention. This is the cost discriminator: turning on Sentinel for logs that only need operational query is over-engineering.
3. Sentinel ingests data through data connectors (for Azure services, Microsoft 365 / Entra, and many third parties) and uses analytics rules to generate incidents, with SOAR automation via playbooks (Logic Apps).
4. Microsoft Sentinel is converging into the Microsoft Defender portal as part of unified security operations. The Azure portal experience for Sentinel is being retired (no longer supported after 31 March 2027), and new customers onboarded from 1 July 2025 are placed in the Defender portal. The underlying requirement for a Sentinel-enabled Log Analytics workspace remains.
5. The Microsoft Sentinel data lake (GA in late 2025) introduces a two-tier model: an analytics tier for real-time detection and a low-cost data lake tier for long-term security retention (up to 12 years), addressing the "keep security logs cheaply for years" requirement within the security stack.
6. Sentinel commonly drives a workspace-separation decision: a dedicated security workspace (Sentinel-enabled) separate from an operations workspace is a frequent topology when SOC and operations teams have different access and retention needs.
7. Because Sentinel sits on a workspace, KQL skills, table plans, and retention settings carry over, but security-specific features (UEBA, threat intelligence, hunting) are what justify Sentinel over plain Log Analytics.

### AZ-305 exam discriminator

"Threat detection, investigation, hunting, correlation across sources, or automated response (SOAR)" points to Sentinel. "Just query and alert on operational logs" points to Log Analytics alone, because Sentinel adds cost without adding value for non-security use cases.

### Common trap

Enabling Sentinel for ordinary operational logging, or treating it as a separate destination. Sentinel runs on a Log Analytics workspace and adds security capability and cost; it is the wrong answer when the requirement is not security operations.

---

## Azure Data Explorer (ADX)

**Classification:** Adjacent
**Why it matters:** ADX is the edge-case answer for very high-volume, low-latency, custom-schema log and telemetry analytics that exceed what a standard Log Analytics workspace is designed for.
**Primary Microsoft source:** <https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview>

### Deep technical facts / requirements

1. ADX is a fast, fully managed analytics service for large volumes of structured, semi-structured, and free-text data, and it is the same KQL engine that underlies Log Analytics and Application Insights.
2. ADX is appropriate when you need full control over schema, ingestion, partitioning, caching (hot/cold), and retention at very large scale, or when you require near-real-time analytics over high-velocity telemetry beyond typical operational logging.
3. ADX supports time-series analysis, pattern detection, and exploratory analytics over billions of records, which is why it is preferred for IoT, clickstream, and large custom-telemetry scenarios rather than standard Azure resource logging.
4. Cross-service KQL queries can join ADX with Log Analytics and Application Insights data, so ADX can complement rather than replace a workspace when some data sets are too large or too custom for the workspace model.
5. ADX is more of a data-platform responsibility than Log Analytics: you size and manage clusters (or use the serverless-style options) and own more of the operational and cost model.
6. ADX is a strong choice when retention of large raw telemetry for ad-hoc analytics is needed at lower cost-per-query at scale, where Log Analytics ingestion costs or query limits would be prohibitive.

### AZ-305 exam discriminator

"Very high-volume, near-real-time, custom-schema, or exploratory large-scale analytics" points to ADX. Ordinary Azure operational logging, alerting, and correlation stays in a Log Analytics workspace.

### Common trap

Reaching for ADX for standard Azure resource or VM logging. For typical operational logging, Log Analytics is simpler and integrated; ADX is justified only by scale, custom schema, or analytics requirements the workspace cannot meet economically.

---

## Azure Blob Storage

**Classification:** Supporting
**Why it matters:** Storage is the low-cost destination for long-term archival and immutable compliance retention of logs that are rarely queried interactively.
**Primary Microsoft source:** <https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-overview>

### Deep technical facts / requirements

1. Diagnostic settings and Activity Log export can send logs directly to an Azure Storage account, making Storage the cheapest archival destination when interactive KQL query is not required.
2. Blob access tiers (Hot, Cool, Cold, Archive) let you match cost to access frequency, and lifecycle management policies can automatically move aging log blobs to cooler tiers and eventually delete them, which is core to a cost-aware retention design.
3. Immutable blob storage (WORM, write-once-read-many) with time-based retention or legal-hold policies provides tamper-proof retention for regulatory and audit requirements, which neither a default workspace nor a Storage account without immutability gives you.
4. Logs in Storage are not directly queryable with KQL. To analyze them you must move them (for example via a search job into a workspace, or another analytics tool), which is the tradeoff against keeping data in Log Analytics long-term retention.
5. Storage is the native landing zone for VNet flow logs, so even a "network forensics retention" requirement often resolves to a Storage account plus a retention policy.
6. Storage cost is driven by capacity and access tier rather than by query, which is the inverse of the analytics-store model and is exactly why it wins "retain cheaply, query rarely" scenarios.

### AZ-305 exam discriminator

"Retain logs for years at the lowest cost, query rarely, or meet immutable/WORM compliance" points to Azure Storage (with archive tier and immutability). It competes with Log Analytics long-term retention; Storage usually wins on raw cost, while long-term retention wins when occasional in-place search is needed.

### Common trap

Choosing active Log Analytics retention for seven-year "store but rarely query" requirements. That is expensive; Storage archive (or Log Analytics long-term retention) is the cost-correct answer, and immutable storage is the piece that satisfies tamper-proof compliance.

---

## Azure Event Hubs

**Classification:** Supporting
**Why it matters:** Event Hubs is the streaming export path when logs must reach a third-party SIEM, external analytics platform, or custom downstream processor.
**Primary Microsoft source:** <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about>

### Deep technical facts / requirements

1. Diagnostic settings, Activity Log export, and Entra log export can all stream to an Event Hub, which makes Event Hubs the standard bridge from Azure logging to non-Azure consumers.
2. Event Hubs is the recommended destination for integrating existing third-party SIEM tools (such as Splunk or IBM QRadar) and external analytics systems that pull from a streaming endpoint.
3. Event Hubs decouples producers from consumers: Azure writes logs to the hub, and any number of consumers read independently, which is why it suits fan-out to multiple external systems.
4. A complete Event Hubs design requires consumer-side work and capacity planning: throughput units (or processing units), partitions, and a consumer application or connector. It is not a store you query; it is a pipe you must drain.
5. Event Hubs retains streamed data only for a short configured window (it is a buffer, not an archive), so durable retention still requires the consumer to persist the data elsewhere.
6. Event Hubs is the right answer when the requirement explicitly involves an external or on-premises SIEM. When the SIEM is Microsoft Sentinel, you typically use a Sentinel data connector instead of routing through Event Hubs.

### AZ-305 exam discriminator

"Send Azure logs to a third-party / external SIEM or analytics tool" points to Event Hubs. "Send logs to Microsoft Sentinel" points to a Sentinel data connector, not Event Hubs.

### Common trap

Treating Event Hubs as a log store or as the destination for native Azure querying. It is a streaming buffer for export; durable storage and analysis happen in the downstream consumer.

---

## Azure Well-Architected Framework (observability)

**Classification:** Framework / methodology
**Why it matters:** The WAF observability guidance supplies the design principles behind a logging recommendation: collect what supports operations, align with reliability and cost pillars, and avoid collecting noise.
**Primary Microsoft source:** <https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/observability>

### Deep technical facts / requirements

1. WAF frames observability as collecting the data that lets you understand system health and act on it, which translates the task from "log everything" into "log what supports operations, reliability, and security decisions."
2. The Operational Excellence pillar drives the "what to collect and why" decisions, while the Cost Optimization pillar drives table plans, retention tiers, sampling, and source-side filtering to avoid runaway ingestion charges.
3. WAF distinguishes logs, metrics, and traces as complementary signals, which maps directly to choosing Log Analytics tables, the metrics store, and Application Insights distributed tracing for the right data types.
4. WAF emphasizes centralization and correlation, which supports the single-workspace-first guidance and the use of consistent collection (diagnostic settings, DCRs) across the estate.
5. WAF treats security/audit logging and operational logging as both necessary but potentially separable, which underpins operations-versus-security workspace separation and Sentinel adoption decisions.

### AZ-305 exam discriminator

When a question asks for the principle behind a choice ("why collect this, why retain this long, why separate these logs"), the WAF observability and cost guidance is the justification, even though the concrete answer is a specific Azure Monitor feature.

### Common trap

Treating WAF as something you "deploy." It is guidance, not a service. On the exam it explains the reasoning behind a design, not the implementation.

---

## Adjacent / limited relevance

These products materially affect the logging task in narrow ways but do not carry 7+ central facts for "Recommend a logging solution." They are most likely to appear as a single discriminator or a supporting detail.

- **Azure Policy** (<https://learn.microsoft.com/en-us/azure/governance/policy/overview>): The scale answer for logging. DeployIfNotExists policies enforce diagnostic settings, deploy AMA, and create DCR associations across subscriptions and management groups, so "ensure all resources send logs" is a Policy answer, not a per-resource one. Not central because Policy is the enforcement mechanism, not the logging feature itself.
- **Azure Arc** (<https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview>): Extends AMA and DCR-based collection to on-premises and other-cloud servers. The pattern "collect guest logs from non-Azure machines" is Arc plus AMA. Limited relevance because it is the reach mechanism for AMA rather than a logging product.
- **Microsoft Defender for Cloud** (<https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction>): Generates security recommendations and alerts and can store security data in Log Analytics; its server protections now rely on Defender for Endpoint rather than the retired MMA. Adjacent because it consumes and produces security signals but is not the core log-collection design.
- **Container insights** (<https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview>): The AKS-specific path for collecting container stdout/stderr and node/pod telemetry into a Log Analytics workspace; ContainerLogV2 supports the Basic table plan to control volume. Limited relevance because it is a specialized collection scenario layered on the same workspace model.

---

## Highest-yield exam discriminators

| Scenario clue | Best answer | Why |
|---|---|---|
| "Centralized KQL query and correlation across Azure resources" | Single Log Analytics workspace | Workspace is the query and correlation boundary; start with one unless a requirement forces splitting. |
| "Who created, changed, or deleted an Azure resource?" | Activity Log | Subscription-level control-plane log for ARM operations. |
| "Service-internal diagnostics (firewall, Key Vault, database)" | Diagnostic settings to a workspace | Resource logs are not collected until a diagnostic setting routes them. |
| "Logs aren't showing up even though the workspace exists" | Missing diagnostic setting / DCR association | Resource logs and guest logs require explicit routing. |
| "Collect Windows Event Logs, Syslog, or IIS logs from VMs" | Azure Monitor Agent with DCRs | Guest-OS collection; diagnostic settings cannot reach inside the OS. |
| "Collect guest logs from on-premises or multicloud servers" | Azure Arc + AMA + DCRs | Arc extends AMA-based collection beyond Azure. |
| "Filter, transform, or mask data before ingestion to cut cost" | Data Collection Rule transformation | Ingestion-time KQL transform reduces volume and protects sensitive fields. |
| "Application requests, dependencies, exceptions, distributed traces" | Workspace-based Application Insights | Application telemetry and end-to-end tracing; classic is retired. |
| "Sign-in and audit logs retained or analyzed beyond default" | Entra diagnostic settings to workspace / Storage / Event Hubs | Entra logs have their own export and short default retention. |
| "Log IP traffic through a virtual network (new design)" | Virtual network flow logs | NSG flow logs are retiring; new flow logs cannot be created after 30 June 2025. |
| "Query and visualize network flows in KQL" | VNet flow logs + Traffic Analytics | Raw flow logs go to Storage; Traffic Analytics enriches into a workspace. |
| "Threat detection, hunting, correlation, automated response (SOAR)" | Microsoft Sentinel | SIEM/SOAR on a Log Analytics workspace; adds security capability and cost. |
| "Send Azure logs to a third-party / external SIEM" | Event Hubs | Streaming export bridge to non-Azure consumers. |
| "Retain logs for years, query rarely, lowest cost" | Azure Storage archive (or LA long-term retention) | Cost-optimized retention; Storage wins on raw cost, long-term retention enables in-place search. |
| "Tamper-proof / WORM retention for compliance" | Immutable Blob Storage with time-based retention | Immutability provides regulator-grade, unalterable retention. |
| "Reduce ingestion cost for verbose, rarely queried logs" | Basic or Auxiliary table plan | Per-table low-cost tiers; Auxiliary is custom-table-only and permanent. |
| "Data must stay in a specific region / country" | Region-specific workspaces | Workspace data is stored in its region; residency forces separation. |
| "Separate SOC data from operations data" | Operations workspace + security (Sentinel) workspace | Different access, retention, and tooling justify topology separation. |
| "Very high-volume, near-real-time, custom-schema analytics" | Azure Data Explorer | Scale and custom analytics beyond the standard workspace model. |
| "AKS container stdout/stderr and pod/node telemetry" | Container insights to a workspace (ContainerLogV2, Basic plan) | AKS-specific collection on the same workspace model, with cost control. |

### Notes on discrepancies with the source guide

- The provided guide correctly flags that NSG flow logs are retiring; the precise current dates are: no new NSG flow logs after 30 June 2025, and full retirement on 30 September 2027.
- The guide's "avoid the retired Log Analytics agent" note is accurate; the Log Analytics agent (MMA) retired on 31 August 2024, and AMA is the only supported agent for new designs.
- The guide treats Application Insights as workspace-based; this is now mandatory because classic Application Insights is fully retired (deprecated 29 February 2024, with unmigrated classic resources disabled after 31 July 2025).
- The guide predates Microsoft Sentinel's move into the Defender portal and the Sentinel data lake. The core fact (Sentinel runs on a Log Analytics workspace and adds SIEM/SOAR) is unchanged, but be aware the Azure portal Sentinel experience is being retired (no longer supported after 31 March 2027) and a two-tier data lake now exists for long-term security retention.
