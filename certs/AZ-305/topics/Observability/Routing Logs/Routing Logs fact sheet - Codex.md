# Deep Technical Facts and Requirements for Recommend a Solution for Routing Logs

## Scope

- Exam: AZ-305: Designing Microsoft Azure Infrastructure Solutions
- Task: Recommend a solution for routing logs
- Source guide: `Routing Logs study guide - GPT5.md` and `Routing Logs task map.md`
- Research date: July 2026
- Product selection method: Products and major topics were extracted from the provided guide, then validated against current official Microsoft documentation.

## Product coverage summary

| Product / topic | Classification | Why it matters for this task |
|---|---|---|
| Diagnostic settings, resource logs, and Activity Log | Core | This is the principal route for Azure platform telemetry, with hard limits on setting count, destinations, regions, and destination networking. |
| DCRs, DCRAs, DCEs, transformations, AMA, and Logs Ingestion API | Core | This family routes guest OS and custom data, controls schema and filtering, and has source-specific association, endpoint, and throughput rules. |
| Log Analytics workspaces and workspace data export | Core | The queryable destination, retention model, workspace topology, and post-ingestion export behavior materially affect routing designs. |
| Azure Event Hubs | Core | Event Hubs is the streaming handoff for external SIEM and processing consumers; tier, throughput, retention, and disaster-recovery constraints matter. |
| Azure Blob Storage and immutable storage | Core | Storage is the archive destination, and WORM policy behavior determines whether a route can satisfy tamper-resistance requirements. |
| Microsoft Entra log routing | Supporting | Tenant-level identity logs use a separate configuration scope, license model, and retention model. |
| Virtual network flow logs and Traffic Analytics | Supporting | Network flow telemetry follows a storage-first Network Watcher path rather than a normal platform diagnostic-setting route. |
| Azure Monitor pipeline | Supporting | Edge and multicloud sources can use a locally operated pipeline for central ingestion, preprocessing, and disconnection buffering. |
| Microsoft Sentinel | Supporting | Sentinel changes the destination requirement when the scenario calls for SIEM, hunting, incidents, automation, or security data tiers. |
| Azure Policy | Supporting | Policy initiatives and remediation enforce diagnostic settings, AMA, and DCR associations at enterprise scale. |

---

## Diagnostic settings, resource logs, and Activity Log

**Classification:** Core  
**Why it matters:** Diagnostic settings are the normal generally available route for Azure resource logs, exportable platform metrics, and subscription or management-group Activity Log events. Their count, region, firewall, schema, and scope constraints frequently eliminate otherwise plausible answers.  
**Primary Microsoft source:** [Diagnostic settings in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings)  
**Limits and quotas source:** [Azure Monitor service limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#diagnostic-settings)

### Deep technical facts / requirements

1. **Defaults and collection behavior:** Azure Monitor automatically collects platform metrics and Activity Log events, but resource logs are **not collected by default**. A diagnostic setting is required to collect resource logs or send automatically collected platform data to another destination. [Diagnostic settings data sources](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#sources).
2. **Limits and quotas:** Each Azure resource supports a hard maximum of **5 diagnostic settings**, and a single setting can specify no more than **one destination of each type**. Two Log Analytics workspaces therefore require two settings, while one workspace, one storage account, and one Event Hubs destination can share one setting. [Azure Monitor diagnostic settings limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#diagnostic-settings).
3. **Destination gating:** Supported destination types are Log Analytics, Azure Storage, Event Hubs, and supported Azure Monitor partner solutions. A Storage destination must be a **Standard** account; Premium accounts and Azure DNS zone endpoints `[Preview]` aren't supported as diagnostic-setting destinations. [Diagnostic settings destinations](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#destinations).
4. **Regional constraint:** For a regional monitored resource, its Storage and Event Hubs destinations must be in the **same region** as that resource. A Log Analytics workspace isn't subject to this same-region rule, although residency requirements can still dictate its location. [Diagnostic settings destination requirements](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#destinations).
5. **RBAC and tenant boundary:** A destination can be in another subscription if the configuring identity has Azure RBAC access to both resources. Managing a destination in another Microsoft Entra tenant requires a cross-tenant management mechanism such as Azure Lighthouse. [Cross-subscription diagnostic settings](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#destinations).
6. **Prerequisite:** Every destination resource must exist before its diagnostic setting is created. A destination table in Log Analytics is created only after the first record arrives, so a saved setting doesn't prove that the source has emitted data. [Diagnostic settings destination prerequisites](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#destinations).
7. **Networking:** A firewalled Storage account or Event Hubs namespace must allow trusted Microsoft services to bypass its firewall so the Azure Monitor diagnostic-settings service can write. A private endpoint alone doesn't grant this service-to-destination access. [Diagnostic settings firewall requirements](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#destinations).
8. **Event Hubs authorization:** Diagnostic-settings streaming requires an Event Hubs authorization rule with `Manage`, `Send`, and `Listen`; updating a setting that streams also requires `ListKey`. A compacted event hub is invalid because Azure Monitor doesn't supply the partition key that compaction requires. [Stream Azure Monitor logs to Event Hubs](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#destinations).
9. **Transport security:** Diagnostic-setting destination endpoints support **TLS 1.2**. This protects data in transit but doesn't make the path private and doesn't make the destination immutable. [Diagnostic settings destination transport](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#destinations).
10. **Category behavior:** A setting can select individual log categories or a category group, but not both. `allLogs` automatically includes future categories added to that group; `audit` includes supported audit categories, and not every Azure service exposes category groups. [Diagnostic setting category groups](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#category-groups).
11. **Filtering limitation:** Diagnostic settings select entire categories and can't filter individual records within a category. Supported ingestion-time transformations can filter later, but collecting a category first can still affect processing and destination cost. [Control diagnostic settings costs](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#controlling-costs).
12. **Metrics constraint:** Not every platform metric is exportable, and diagnostic-settings export flattens multidimensional metrics and aggregates across dimension values. The metric reference's **Exportable** column is therefore a hard prerequisite when a design requires metric export. [Diagnostic settings metric limitations](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#metrics-limitations).
13. **Resource-log schema:** Resource-specific mode writes supported categories to dedicated tables and improves schema discoverability, ingestion/query performance, and table-level RBAC; Azure diagnostics mode writes many resource types to the legacy shared `AzureDiagnostics` table. Microsoft recommends resource-specific mode for new settings where supported. [Resource log collection modes](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collection-mode).
14. **Schema migration behavior:** Switching a diagnostic setting from Azure diagnostics mode to resource-specific mode doesn't migrate historical rows. Existing records remain in `AzureDiagnostics`, new records go to dedicated tables, and overlap queries must use `union` until old data ages out. [Change resource log collection mode](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#select-the-collection-mode).
15. **Delivery semantics:** Resource-log routing is a redundant store-and-forward system with retries, but it isn't transactionally lossless; small losses can occur during temporary, nonrepeating platform issues. It therefore shouldn't be represented as a transactional audit ledger. [Resource log collection guarantees](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collecting-resource-logs).
16. **Activity Log retention and latency:** Activity Log entries are collected without configuration, usually appear within **3–20 minutes**, and are retained for **90 days** at no charge. Longer retention requires export to another destination. [Azure Activity Log retention](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#retention-period).
17. **Activity Log hierarchy behavior:** A management-group diagnostic setting exports events for that management group and descendant management groups. Settings at multiple hierarchy levels can create duplicates, and not all subscription events propagate upward because the `hierarchy` property isn't mandatory for every resource provider. [Export management-group Activity Logs](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#export-management-group-activity-logs).
18. **Expected start time:** After a diagnostic setting is created, Microsoft states that data should begin flowing within **90 minutes**; an empty destination can still mean that no matching source events were generated. [Diagnostic settings expected latency](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#expected-latency-after-creating-a-diagnostic-setting).

### Incompatibilities and mutual exclusions

If a regional resource and a Storage or Event Hubs destination in another region are both required, that direct diagnostic-setting route can't be used because those destinations must be same-region. Use a compliant same-region first destination and a supported replication or second-stage forwarding design. [Diagnostic settings regional destination rules](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#destinations).

### Edge cases and gotchas

- Deleting, renaming, moving, or migrating a resource doesn't safely clean up its diagnostic settings; Microsoft warns to delete the settings because an orphaned setting can affect a resource recreated with the same identity. [Diagnostic setting lifecycle warning](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings).
- Diagnostic settings don't support resource IDs containing non-ASCII characters, so the affected resource or resource group must be recreated or moved to an ASCII-only identity. [Diagnostic settings non-ASCII limitation](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#setting-disappears-due-to-non-ascii-characters-in-a-resource-id).
- Enabling the Azure SQL `audit` category in a diagnostic setting doesn't enable database auditing; auditing must first be enabled on the database. [Diagnostic setting category-group caveat](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#category-groups).
- Metric export backs off for inactive resources: after **1 hour** of zero values it can wait **15 minutes**, after **7 days** it reaches a **2-hour** maximum backoff, and it returns to roughly **3-minute** latency when nonzero values resume. [Diagnostic settings inactive-resource behavior](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#resource-is-inactive).
- `[Preview]` Platform telemetry DCRs can now collect supported platform logs, but one DCR supports only one destination type, only **5** such DCRs can be associated with one resource, and using them beside diagnostic settings can duplicate data. Treat diagnostic settings as the generally available exam default unless the question explicitly allows this preview. [Platform log collection with DCRs preview](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/platform-logs-collect#limitations).

### AZ-305 exam discriminator

“Send one resource's logs to six workspaces” is impossible through six direct settings because the resource has a **5-setting** ceiling. “Send to two workspaces” requires two settings, while “send to one workspace, one Storage account, and one Event Hubs namespace” can use one setting because those are different destination types. [Azure Monitor diagnostic settings limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#diagnostic-settings).

### Common trap

Do not use subscription Activity Log export for guest OS events or data-plane resource operations: Activity Log is control-plane telemetry, guest data uses an agent-based route, and service-specific resource logs require resource-level collection. [Activity Log versus resource logs](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log).

---

## DCR-based collection: DCRs, DCRAs, DCEs, transformations, AMA, and Logs Ingestion API

**Classification:** Core  
**Why it matters:** DCR-based collection is the modern path for VM and Arc guest telemetry and custom direct ingestion. The architect must distinguish the processing rule, its resource association, optional endpoint, agent, and API client.  
**Primary Microsoft source:** [Data collection rules in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview)  
**Limits and quotas source:** [Azure Monitor DCR and Logs Ingestion API limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#data-collection-rules)

### Deep technical facts / requirements

1. **DCR role:** A DCR defines some or all of the incoming stream schema, what data to collect, transformations, data flows, and destinations. The way a DCR is invoked depends on the collection scenario; it isn't itself a queryable destination. [Data collection rule processing model](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#data-collection-process).
2. **Association model:** A DCRA creates the relationship used by association-based scenarios such as AMA. The relationship is many-to-many: one DCR can serve many resources, and one resource can be associated with up to **30 DCRs**. Direct Logs Ingestion API calls name the DCR instead of requiring a DCRA. [Data collection rule associations](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#data-collection-rule-associations-dcras).
3. **DCR limits:** One DCR supports at most **10 data sources**, **10 data flows**, **20 data streams**, **10 extensions**, **10 Log Analytics workspace destinations**, and a transformation of **15,360 characters**. Windows Event Log sources support at most **100 XPath queries**, and Syslog supports at most **20 facility names**. [Azure Monitor DCR limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#data-collection-rules).
4. **Transformation semantics:** An Azure Monitor transformation is KQL applied independently to each incoming record after Azure Monitor receives it and before the destination table stores it. The query begins with the virtual `source` table, and its output schema must match the destination table. [Create Azure Monitor transformations](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations-create#basic-query-structure).
5. **Transformation capability boundary:** Cloud DCR transformations don't support aggregation because each record is processed individually; Azure Monitor pipeline transformations occur earlier and can aggregate. [Pipeline versus Azure Monitor transformations](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations#azure-monitor-pipeline-transformations).
6. **Transformation performance:** Microsoft recommends an optimal transformation execution time of no more than **1 second** and warns that transformations taking more than **20 seconds** can cause data loss. [Optimize Azure Monitor transformations](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations-create#optimize-and-monitor-transformations).
7. **Transformation cost:** For Analytics and Basic tables, filtering more than **50%** of incoming data incurs a processing charge on the portion dropped above 50%; added columns increase billable ingested size. Sentinel-enabled workspaces don't charge transformation processing for Analytics tables regardless of the filtered percentage. [Azure Monitor transformation costs](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations#cost-for-transformations).
8. **DCE requirement:** A DCE is required for private-link Logs Ingestion API traffic or when a DCR doesn't contain a direct logs-ingestion endpoint. The `logsIngestion` endpoint property was added on **March 31, 2024**; it can't be retrofitted to an older DCR, so moving an existing client from a DCE to a DCR endpoint requires a replacement DCR. [Logs Ingestion API endpoint selection](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#endpoint).
9. **AMA purpose:** AMA runs inside Azure, other-cloud, and on-premises machines and collects guest OS and workload data such as Windows events, Syslog, performance, IIS, and file logs according to associated DCRs. Host platform telemetry alone can't expose guest processes or guest log files. [Azure Monitor Agent overview](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview).
10. **AMA environment and cost:** AMA has no agent charge, but ingestion and storage can be billed. Its generally available features are available in global Azure, Azure Government, and Azure operated by 21Vianet, but not in air-gapped clouds. [Azure Monitor Agent cost and regions](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#cost).
11. **Hybrid prerequisite and identity:** Non-Azure and on-premises machines use Azure Arc-enabled servers before AMA can be targeted. AMA authenticates by managed identity; Arc-enabled servers support only their automatically enabled system-assigned managed identity for this purpose. [AMA support outside Azure](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-supported-operating-systems#on-premises-and-in-other-clouds).
12. **OS and disk constraint:** AMA doesn't support x86 operating systems. Supported Linux environments require Python and baseline packages, and the agent requires at least **4 GB** of disk space to install and run successfully. [AMA supported operating systems and requirements](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-supported-operating-systems).
13. **Legacy-agent retirement:** The Log Analytics agent (MMA/OMS) retired on **August 31, 2024**; its cloud ingestion services can be shut down at any time after **March 2, 2026**, and it no longer receives support or new OS support. New designs use AMA and DCRs. [Migrate from the retired Log Analytics agent](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-migration).
14. **Logs Ingestion API prerequisites:** A client sends a UTF-8 JSON array to a DCR endpoint or DCE. The target table must exist, the DCR must describe the input and output, and the calling identity needs access to the DCR—Microsoft documents the **Monitoring Metrics Publisher** role for the application. [Logs Ingestion API configuration](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#configuration).
15. **Logs Ingestion API transport:** Starting **March 1, 2026**, the Logs Ingestion API enforces **TLS 1.2 or higher**. Its API URI uses the DCR immutable ID and stream name, so the display name isn't a substitute for the immutable ID. [Logs Ingestion API overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview).
16. **Logs Ingestion API limits:** The maximum call size is **1 MB** compressed or uncompressed; field values over **64 KB** are truncated. Per DCR, the documented thresholds are **2 GB/minute** and **12,000 requests/minute**; abrupt increases can throttle even though gradual scaling beyond those thresholds might be accommodated. [Logs Ingestion API service limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#logs-ingestion-api).
17. **Auxiliary-log timestamp limit:** A Logs Ingestion API call targeting an Auxiliary table can span at most **30 minutes** of untransformed `TimeGenerated` values. This restriction doesn't apply when a transformation rewrites those timestamps. [Logs Ingestion API service limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#logs-ingestion-api).
18. **Source filtering:** DCRs can combine multiple source types, but source-native filters such as Windows Event XPath should be used when possible because they avoid transporting and cloud-processing records that will only be discarded later. [DCR samples for VM client data](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-samples#collect-vm-client-data).

### Incompatibilities and mutual exclusions

If a source is an on-premises or other-cloud server and the organization refuses Azure Arc enrollment, AMA+DCRA can't be used because Azure Arc is the required resource and managed-identity bridge for non-Azure machines. Use another supported forwarding or pipeline design. [AMA support outside Azure](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-supported-operating-systems#on-premises-and-in-other-clouds).

### Edge cases and gotchas

- A workspace transformation DCR is intended for data that doesn't already use a DCR. A workspace transformation is ignored for AMA data because AMA's collection DCR owns that data path. [Workspace transformation DCR behavior](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations#workspace-transformation-dcr).
- DCE is not a synonym for DCR: a DCR is the processing contract, a DCRA binds resources in association-based scenarios, and a DCE is an endpoint needed only by particular network or legacy-direct-ingestion configurations. [Data collection rules and endpoints](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#using-a-dcr).
- A DCR used by Logs Ingestion API must be created in the same region as its destination workspace and DCE, if a DCE is used. [Logs Ingestion API DCR configuration](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#data-collection-rule-dcr).
- Azure Monitor warns that the Linux system-wide `FUTURE` crypto policy is incompatible with AMA because it disables algorithms needed by the service endpoints. [AMA Linux hardening compatibility](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-supported-operating-systems#linux-hardening).
- The portal can create a custom table and matching DCR from sample data, but targeting an existing table or creating the table another way requires the DCR to be created manually. [Logs Ingestion API table and DCR setup](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#configuration).

### AZ-305 exam discriminator

“Windows events or Linux Syslog from inside Azure and hybrid servers” points to AMA+DCR+DCRA; “custom JSON from an application” points to Logs Ingestion API+DCR; “Azure subscription control-plane operations” points to Activity Log export. The mechanism follows the source even when all three ultimately land in one workspace. [Azure Monitor data sources and collection methods](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources).

### Common trap

Do not add a DCE to every DCR design. New direct-ingestion DCRs expose their own endpoint, and a DCE is required only for private link or when the DCR lacks that endpoint. [Logs Ingestion API endpoint selection](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#endpoint).

---

## Log Analytics workspaces and workspace data export

**Classification:** Core  
**Why it matters:** Log Analytics is the queryable destination for KQL, alerts, workbooks, and Sentinel. Workspace region, access, retention, ingestion behavior, and second-stage export determine whether the route meets operational, sovereignty, security, and downstream-integration requirements.  
**Primary Microsoft source:** [Log Analytics workspace overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview)  
**Limits and quotas source:** [Azure Monitor Log Analytics workspace limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#log-analytics-workspaces)

### Deep technical facts / requirements

1. **Topology default:** Microsoft recommends sending log data to one workspace unless business requirements justify more. Valid drivers for multiple workspaces include separate tenants, regions, ownership/RBAC boundaries, availability, Sentinel architecture, billing, or data residency—not subscription symmetry by itself. [Create Log Analytics workspaces](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/quick-create-workspace).
2. **Default retention:** Most workspace tables retain data for **30 days** by default. `Usage`, `AzureActivity`, and workspace-based Application Insights tables retain data for at least **90 days** at no charge. [Log Analytics default retention](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure#log-tables-with-90-day-default-retention).
3. **Analytics and total maximums:** Analytics-plan tables support up to **2 years (730 days)** of interactive retention, and total retention can be extended to **12 years**. Data beyond analytics retention is accessed through a search job rather than ordinary real-time table behavior. [Configure Log Analytics retention](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure#analytics-long-term-and-total-retention).
4. **Minimum and included retention:** Analytics retention can be reduced to **4 days** through API or CLI, but **31 days** are included in the ingestion price, so reducing below 31 days doesn't lower retention cost. Basic tables have a fixed **30-day** query period. [Log Analytics retention behavior](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure#analytics-long-term-and-total-retention).
5. **Deletion safety:** When total retention is shortened, Azure Monitor waits **30 days** before removing data so the change can be reversed. Increasing total retention applies to existing data that hasn't already been removed. [Retention modification behavior](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure#how-retention-modifications-work).
6. **Access control:** Workspace access depends on access mode, workspace access-control mode, Azure RBAC, and optional table- or row-level granular RBAC. Resource-context access and table-level roles can sometimes meet segregation requirements without creating extra workspaces. [Manage Log Analytics workspace access](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access).
7. **Workspace limits:** Pay-as-you-go and commitment tiers have no daily ingestion cap and support up to **730 days** interactive and **12 years** total retention. The obsolete Free tier is capped at **500 MB/day** and **7 days**, and no new workspace has been able to enter it since **July 1, 2022**. [Log Analytics data volume and retention limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#data-collection-volume-and-retention).
8. **Soft ingestion-rate threshold:** Workspace ingestion from diagnostic settings, workspace-based Application Insights, and the legacy Data Collector API has a default soft threshold of **500 MB/minute compressed**, approximately **6 GB/minute uncompressed**. Azure retries four times over **12 hours** and can then drop data; this limit doesn't apply to agents or DCR ingestion. [Log Analytics ingestion volume rate](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#general-workspace-limits).
9. **Query-scale constraints:** One cross-resource query can reference at most **100** Log Analytics workspaces and Application Insights resources. A user can run **5** concurrent Analytics queries and **2** concurrent Basic/Auxiliary queries; queued queries time out after **3 minutes**. [Azure Monitor log query limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#log-queries-and-language).
10. **Data export stage:** A workspace data export rule continuously exports **new** records from selected supported tables as they arrive; it doesn't backfill historical records and doesn't replace the source's initial collection route. [Log Analytics data export overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#overview).
11. **Export filtering:** Data export operates at whole-table granularity and has no row filter. To change or filter exported records, apply a supported ingestion-time transformation before the data is stored and exported. [Log Analytics data export behavior](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#overview).
12. **Export destinations:** Workspace data export supports Azure Storage and Event Hubs. A Storage destination must be StorageV1 or later, non-Premium, and in the same region as the workspace; cross-region protection uses Storage redundancy such as GRS or GZRS. [Log Analytics data export destinations](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#storage-account).
13. **Export prerequisites and timing:** The `Microsoft.Insights` resource provider must be registered, destinations must already exist, and a new export rule can take about **30 minutes** to provision before export starts. [Enable Log Analytics data export](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#enable-data-export).
14. **Export cost:** Data export is billed on bytes exported in JSON, where **1 GB = 10^9 bytes**; workspace queries don't include JSON formatting overhead and therefore can't directly calculate the billed export size. Billing for data export began in **October 2023**. [Log Analytics data export pricing model](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#pricing-model).
15. **Event Hubs fan-out behavior:** If an export rule specifies only a Basic or Standard namespace, Azure creates one event hub per table, but those tiers allow only **10 event hubs per namespace**. Supplying one event hub name sends all selected tables to that hub and avoids the one-hub-per-table ceiling. [Log Analytics export to Event Hubs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#event-hubs).
16. **Storage export format:** Workspace export writes newline-delimited JSON into per-table containers and **5-minute** folders. Each append blob supports **50,000 writes** before Azure creates another blob for that folder. [Log Analytics export to Storage](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#storage-account).

### Incompatibilities and mutual exclusions

If the requirements include historical backfill or a per-row export predicate, continuous workspace data export can't meet them because it starts with new arrivals and exports whole supported tables without a filter. Use a query-orchestrated export for bounded historical/filtered data or transform data before ingestion. [Other Log Analytics export options](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#other-export-options).

### Edge cases and gotchas

- Direct diagnostic-setting fan-out normally has lower latency than workspace data export and avoids paying Log Analytics ingestion before export; use the second stage when downstream data must first land in the workspace or the source can't address the required fan-out. [Other Log Analytics export options](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#other-export-options).
- To export to immutable Storage, protected append-blob writes must be enabled; merely locking a container without the documented append compatibility can break the export writer. [Log Analytics export to immutable Storage](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#storage-account).
- A Storage account must be unique across export rules in one workspace, while multiple rules can share an Event Hubs namespace when they target separate event hubs. [Create Log Analytics data export rules](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#create-or-update-a-data-export-rule).
- A firewalled data-export destination still needs the trusted-services exception, and a compacted event hub isn't supported because exported records lack a partition key. [Log Analytics export destination networking](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#event-hubs).
- Workspace replication can support regional switchover, but Application Insights and VM insights are only partially compatible, and switching regions doesn't mitigate a Sentinel service-health issue that affects both regions. [Log Analytics workspace replication considerations](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-replication#support-for-microsoft-sentinel-and-other-services).

### AZ-305 exam discriminator

“All data must be queryable by operations first, then selected tables must stream downstream” points to Log Analytics plus workspace data export. “Archive-only data should never incur analytics ingestion” points to a direct diagnostic setting to Storage instead. [Log Analytics data export options](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#other-export-options).

### Common trap

Filtering or exporting after workspace ingestion doesn't undo the original Log Analytics ingestion charge; post-ingestion routing is a paid second stage. [Log Analytics data export pricing model](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#pricing-model).

---

## Azure Event Hubs

**Classification:** Core  
**Why it matters:** Event Hubs is the decoupled streaming destination for third-party SIEMs and processing systems. It isn't a KQL store or a compliance archive, so consumer persistence and tier limits are part of the routing design.  
**Primary Microsoft source:** [What is Azure Event Hubs?](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about)  
**Limits and quotas source:** [Compare Azure Event Hubs tiers](https://learn.microsoft.com/en-us/azure/event-hubs/compare-tiers#quotas)

### Deep technical facts / requirements

1. **Streaming model:** An event hub is an append-only, partitioned event stream. Consumer groups provide independent views of that stream, and consumers track progress through offsets and checkpoints; Event Hubs isn't an interactive KQL workspace. [Event Hubs features and terminology](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-features).
2. **Retention by tier:** Maximum event retention is **1 day** in Basic, **7 days** in Standard, and **90 days** in Premium or Dedicated. Retention is a replay window, not long-term compliance preservation. [Event Hubs tier quotas](https://learn.microsoft.com/en-us/azure/event-hubs/compare-tiers#quotas).
3. **Event size by tier:** Maximum publication size is **256 KB** in Basic, **1 MB** in Standard or Premium, and **20 MB** in Dedicated. A producer or Azure route whose event exceeds the tier limit must split or redesign the payload. [Event Hubs publication limits](https://learn.microsoft.com/en-us/azure/event-hubs/compare-tiers#quotas).
4. **Consumer groups:** One event hub supports **1** consumer group in Basic, **20** in Standard, **100** in Premium, and **1,000** in Dedicated. Independent applications that need their own checkpoints should use separate consumer groups. [Event Hubs consumer-group limits](https://learn.microsoft.com/en-us/azure/event-hubs/compare-tiers#quotas).
5. **Partitions:** An event hub supports up to **32** partitions in Basic or Standard, **100** in Premium, and **1,024** in Dedicated. Within a consumer group, practical parallelism is bounded by partition count. [Event Hubs partition limits](https://learn.microsoft.com/en-us/azure/event-hubs/compare-tiers#quotas).
6. **Standard throughput unit:** One Basic or Standard throughput unit permits up to **1 MB/s or 1,000 events/s ingress** and **2 MB/s or 4,096 events/s egress**. A namespace supports up to **40 TUs**; Premium supports **16 PUs**, and Dedicated supports **20 CUs**. [Event Hubs capacity limits](https://learn.microsoft.com/en-us/azure/event-hubs/compare-tiers#quotas).
7. **Namespace entity limits:** Basic and Standard namespaces support **10 event hubs** each; Premium supports **100 per PU**, and Dedicated supports **1,000**. This matters when workspace data export creates one event hub per exported table. [Event Hubs namespace quotas](https://learn.microsoft.com/en-us/azure/event-hubs/compare-tiers#quotas).
8. **Authentication and networking:** Event Hubs supports Microsoft Entra ID with Azure RBAC and managed identities, or SAS. It supports TLS 1.2, Private Link, virtual-network service endpoints, and IP firewall rules, but diagnostic-settings and workspace-export writers still require the trusted-services firewall exception. [Event Hubs security overview](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about#security-and-compliance).
9. **Capture gating:** Event Hubs Capture is unavailable in Basic, billed per hour in Standard, and included in Premium and Dedicated. Capture persists stream data to Blob Storage or Data Lake Storage and is the service-native way to retain a copy beyond the event replay window. [Event Hubs tier comparison](https://learn.microsoft.com/en-us/azure/event-hubs/compare-tiers#quotas).
10. **Disaster recovery gating:** Metadata geo-disaster recovery is unavailable in Basic but supported in Standard and higher. It replicates namespace configuration and metadata—not event data—and its failover is a one-way operation that removes the pairing. [Event Hubs geo-disaster recovery](https://learn.microsoft.com/en-us/azure/reliability/reliability-event-hubs#geo-disaster-recovery).
11. **Event-data replication:** Event-data geo-replication is a Premium and Dedicated capability; Standard metadata Geo-DR doesn't preserve the buffered events from a failed primary region. [Event Hubs tier comparison](https://learn.microsoft.com/en-us/azure/event-hubs/compare-tiers#quotas).
12. **Availability:** Event Hubs advertises up to a **99.99% SLA**, depending on tier and configuration. In availability-zone regions, Standard and Premium use zone redundancy automatically at no extra cost; Dedicated requires at least **3 CUs** for zone support. [Event Hubs high availability](https://learn.microsoft.com/en-us/azure/reliability/reliability-event-hubs#resilience-to-availability-zone-failures).

### Incompatibilities and mutual exclusions

If Azure Monitor diagnostic settings or Log Analytics data export is the producer and the destination event hub is compacted, the route can't be used because Azure Monitor doesn't attach the partition key required for compaction. [Diagnostic settings Event Hubs requirements](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#destinations).

### Edge cases and gotchas

- A successful producer route doesn't prove that the consumer has processed or persisted events; consumers must checkpoint and keep up before the tier's **1-, 7-, or 90-day** retention expires. [Event Hubs features and terminology](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-features).
- Basic tier's single consumer group prevents independent checkpoints for multiple downstream applications; Standard's **20** groups is usually the minimum practical tier for several consumers. [Event Hubs tier quotas](https://learn.microsoft.com/en-us/azure/event-hubs/compare-tiers#quotas).
- Dynamic partition additions are supported only in Premium and Dedicated, so Basic or Standard partition count must be planned more conservatively. [Dynamically add Event Hubs partitions](https://learn.microsoft.com/en-us/azure/event-hubs/dynamically-add-partitions).
- Metadata Geo-DR can restore the namespace alias nearly immediately, but any unreplicated event data remains lost unless the design separately uses geo-replication or durable capture. [Reliability in Azure Event Hubs](https://learn.microsoft.com/en-us/azure/reliability/reliability-event-hubs#geo-disaster-recovery).

### AZ-305 exam discriminator

“Near-real-time feed to Splunk, a Kafka-compatible application, or a custom stream processor” points to Event Hubs. “Analysts must run KQL against retained history” points to Log Analytics, while “seven-year immutable evidence” points to Blob Storage with WORM. [Azure Monitor Event Hubs streaming](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/stream-monitoring-data-event-hubs).

### Common trap

Do not treat the maximum **90-day** Premium/Dedicated event retention as an archive: Event Hubs is a transient stream, and long-term retention requires Capture or another consumer-owned store. [Event Hubs reliability and backup](https://learn.microsoft.com/en-us/azure/reliability/reliability-event-hubs#backup-and-restore).

---

## Azure Blob Storage and immutable storage

**Classification:** Core  
**Why it matters:** Storage is the direct low-cost archive destination for platform and identity logs. Immutable Blob Storage adds time-based WORM and legal holds, which are distinct from ordinary retention, RBAC, or private networking.  
**Primary Microsoft source:** [Immutable storage for blob data](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview)  
**Limits and quotas source:** [Configure container-scope immutability](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-policy-configure-container-scope)

### Deep technical facts / requirements

1. **Diagnostic destination constraint:** A regional resource can send diagnostic data only to same-region **Standard** Storage. Premium Storage and Azure DNS zone endpoints `[Preview]` aren't supported diagnostic-setting destinations. [Diagnostic settings Storage requirements](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#destinations).
2. **WORM policy types:** Time-based retention makes blobs create/read-only for a fixed interval; legal hold keeps them immutable until the hold is explicitly cleared. Both prevent modification and deletion while effective, and both can exist at the same level simultaneously. [Immutable Blob Storage overview](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview).
3. **Retention limits:** A time-based retention policy supports **1–146,000 days (400 years)**. The effective period is calculated from each blob's creation time and the latest policy interval. [Immutable storage retention interval](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#retention-interval-for-a-time-based-policy).
4. **Locked versus unlocked:** Both locked and unlocked policies block overwrites and deletes, but an unlocked policy can be shortened or deleted. A locked policy can't be deleted or shortened; a container-level locked policy allows at most **5** increases to its effective retention period. [Locked and unlocked immutability policies](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#locked-versus-unlocked-policies).
5. **Compliance state:** Microsoft states that a time-based policy must be locked for compliant SEC 17a-4(f)-style immutable protection and recommends locking within **24 hours**; unlocked mode is intended for short-term testing. [Immutable policy compliance state](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#locked-versus-unlocked-policies).
6. **Policy scopes and dependency:** Container-level WORM applies one policy to all blobs in a container. Version-level WORM supports account, container, or blob-version scope but requires blob versioning. [Immutable storage feature options](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#immutable-storage-feature-options).
7. **Hierarchical namespace limitation:** Accounts with hierarchical namespace support container-level WORM, but current documentation says version-level WORM isn't yet supported for those accounts. [Immutable storage feature options](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#immutable-storage-feature-options).
8. **Scale boundary:** Microsoft positions container-level WORM for designs needing no more than **10,000 protected containers per account**; version-level WORM is the granular alternative for broader or mixed-retention designs. [Container-level versus version-level WORM](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#container-level-vs-version-level-worm).
9. **Access tiers and redundancy:** All Blob access tiers and all Storage redundancy configurations support immutability. Immutability doesn't by itself select a durability or regional-read model. [Immutable storage access tiers and redundancy](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#access-tiers).
10. **Durability:** LRS is designed for at least **11 nines** annual object durability, ZRS for **12 nines**, and GRS/GZRS for **16 nines**. GRS and GZRS replicate asynchronously to another region, and read access to the secondary requires RA-GRS or RA-GZRS until failover. [Azure Storage redundancy](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy#summary-of-redundancy-options).
11. **Cost behavior:** Immutable storage has no additional capacity charge over mutable storage, but version-level WORM can cost more because blob versioning creates and retains additional versions; policy operations can also incur transaction charges. [Immutable storage pricing](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#pricing).
12. **Unsupported features:** Immutability is incompatible with point-in-time restore and last-access tracking, and immutability policies aren't supported on accounts with NFS 3.0 or SFTP enabled. [Immutable storage feature support](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#feature-support).
13. **Append compatibility:** Workloads that append to existing block or append blobs can fail under a policy unless protected append writes are explicitly allowed. This setting is required for supported Azure Monitor workspace export into immutable Storage. [Configure protected append writes](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-policy-configure-container-scope#configure-a-retention-policy-on-a-container).
14. **Deletion behavior:** A container with a locked policy, or an account/container with version-level WORM enabled, can be deleted only when empty. Administrative ownership doesn't override the protected data's WORM state. [Immutable storage deletion behavior](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#immutable-storage-feature-options).

### Incompatibilities and mutual exclusions

If a design requires WORM immutability and point-in-time restore, last-access tracking, NFS 3.0, or SFTP on the same storage account, immutable Blob Storage can't satisfy the combination because those features are explicitly incompatible. Separate the archive into a compatible Storage account. [Immutable storage feature support](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#feature-support).

### Edge cases and gotchas

- A legal hold and version-level WORM can't be created for the same container because the legal hold prevents the new versions that version-level WORM needs. [Immutable policy scopes](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#scope).
- A locked container-level policy can be extended only **5 times**, while version-level policies have no documented limit on extension count. [Locked and unlocked policies](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#locked-versus-unlocked-policies).
- Immutability policy changes made after the last geo-replication sync aren't copied during customer-managed unplanned failover; those policy changes must be reapplied in the new primary. [Immutable storage failover behavior](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#feature-support).
- Page blobs backing active VHDs are poor WORM candidates because writes are blocked or create new versions; Microsoft recommends immutable policies mainly for block and append blobs. [Recommended blob types for immutability](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#recommended-blob-types).
- GRS/GZRS protects durability across regions, but asynchronous replication means a regional disaster can lose the newest writes; RA variants expose read access but don't make the secondary writable without failover. [Azure Storage geo-redundancy](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy#redundancy-in-a-secondary-region).

### AZ-305 exam discriminator

“Rarely queried, long-term, lowest-cost audit records” points to direct Storage routing; adding “tamper-resistant,” “WORM,” or “legal hold” requires immutable Blob Storage, not merely a long Log Analytics retention setting. [Immutable Blob Storage overview](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview).

### Common trap

Do not equate retention with immutability. Log Analytics can retain data for **12 years**, but data can be purged for compliance workflows; a locked Blob WORM policy is the mechanism that prevents modification and deletion during the protected interval. [Microsoft Sentinel and Azure Monitor immutability behavior](https://learn.microsoft.com/en-us/azure/sentinel/overview).

---

## Microsoft Entra log routing

**Classification:** Supporting special source  
**Why it matters:** Entra audit, sign-in, provisioning, risk, and Graph activity logs are tenant-level identity telemetry. Their routing isn't configured through an Azure subscription Activity Log setting.  
**Primary Microsoft source:** [Configure Microsoft Entra diagnostic settings](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-configure-diagnostic-settings)

### Deep technical facts / requirements

1. **Scope and destinations:** Microsoft Entra diagnostic settings can send tenant activity logs to Log Analytics, Event Hubs, Azure Storage, or supported Azure Native ISV services, and the destination must exist before the setting is created. [Configure Microsoft Entra diagnostic settings](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-configure-diagnostic-settings).
2. **Least privilege:** **Security Administrator** is the least-privileged role documented for creating general Entra diagnostic settings; **Attribute Log Administrator** is required for custom security-attribute diagnostic settings. **Reports Reader** is the least-privileged role for reading activity logs. [Access Microsoft Entra activity logs](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-access-activity-logs#prerequisites).
3. **License gating:** Audit and sign-in logs are available with Entra ID Free, while provisioning, health, and Microsoft Graph activity logs require P1/P2 or the applicable premium suite. The selected categories only produce data for features the tenant is licensed to use. [Microsoft Entra log access prerequisites](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-access-activity-logs#prerequisites).
4. **Built-in retention:** Audit and sign-in logs retain **7 days** in Entra ID Free and **30 days** in P1/P2. Risky sign-ins retain **7 days** in Free, **30 days** in P1, and **90 days** in P2. [Microsoft Entra data retention](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/reference-reports-data-retention#how-long-does-microsoft-entra-id-store-the-data).
5. **Nonretroactive upgrades:** Upgrading from Free to P1/P2 doesn't recover expired logs; only data still inside the original **7-day** window becomes available under the new license. [Microsoft Entra retention after upgrade](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/reference-reports-data-retention#can-i-see-last-months-data-after-getting-a-premium-license).
6. **Graph activity logs:** Microsoft Graph activity logs are P1/P2-only and have no built-in retained history unless the category is enabled and routed to Storage or an analytics destination. Collection starts when the category is enabled in diagnostic settings. [Microsoft Entra data collection and retention](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/reference-reports-data-retention#when-does-microsoft-entra-id-start-collecting-data).
7. **Operational destination:** Sending Entra logs to Log Analytics enables correlation with Azure, application, and security logs; Event Hubs is the streaming path for external SIEMs, and Storage is the archive path when queries are infrequent. [Access options for Microsoft Entra activity logs](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-access-activity-logs).
8. **Cost:** Routing Entra logs to Log Analytics, Storage, or Event Hubs can incur destination and volume charges; Microsoft recommends measuring a representative day or two because tenant size and policy activity make volume difficult to predict. [Microsoft Entra integration cost considerations](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-log-monitoring-integration-options-considerations#cost-considerations).

### Incompatibilities and mutual exclusions

If the source is Entra sign-in or audit data and the proposed setting is an Azure subscription Activity Log export, the design is invalid because Entra logs are tenant-scoped and use Entra diagnostic settings. [Integrate Microsoft Entra logs with Azure Monitor](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-integrate-activity-logs-with-azure-monitor-logs).

### Edge cases and gotchas

- Microsoft Entra audit/sign-in retention is separate from the Microsoft 365 Unified Audit Log, whose retention is controlled through Microsoft Purview Audit. [Microsoft Entra data retention](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/reference-reports-data-retention).
- Entra diagnostic settings can be multiple, but changing an existing route can create new destination charges and duplicate data if overlapping categories are sent to the same downstream system. [Microsoft Entra integration options](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-log-monitoring-integration-options-considerations).
- Some selectable categories can belong to preview features and might emit no data until their feature is available and used. [Microsoft Entra diagnostic log options](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-diagnostic-settings-logs-options).
- Entra External ID Basic retains logs for **7 days**; longer retention requires Azure Monitor routing in the external tenant. [Microsoft Entra External ID log retention](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/reference-reports-data-retention#microsoft-entra-external-id-logs).

### AZ-305 exam discriminator

“Risky users, sign-ins, provisioning, or tenant audit trail” selects Entra diagnostic settings; KQL/correlation selects Log Analytics, third-party SIEM streaming selects Event Hubs, and long-term infrequent retrieval selects Storage. [Access Microsoft Entra activity logs](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-access-activity-logs).

### Common trap

Do not assume a P2 license creates a 90-day history for every Entra log: audit and ordinary sign-in logs remain **30 days** in P1/P2, while **90 days** applies to risky sign-ins in P2. [Microsoft Entra data retention](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/reference-reports-data-retention#how-long-does-microsoft-entra-id-store-the-data).

---

## Virtual network flow logs and Traffic Analytics

**Classification:** Supporting special source  
**Why it matters:** VNet flow logs record IP flows through a VNet and always use a Storage-first Network Watcher route. Traffic Analytics optionally aggregates that raw data into Log Analytics.  
**Primary Microsoft source:** [Virtual network flow logs](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview)

### Deep technical facts / requirements

1. **Collection model:** VNet flow logs operate at OSI Layer 4, collect at **1-minute** intervals, and write JSON containing 5-tuples, direction, flow state, encryption state, packet counts, and byte counts. Collection is performed by the Azure platform and doesn't affect resource traffic. [Virtual network flow log behavior](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview#how-logging-works).
2. **Storage-first route:** Raw flow data is written to Azure Storage before any optional Traffic Analytics processing. The Storage account must be **Standard**, same-region as the VNet, and in the same subscription or a subscription in the same Entra tenant. [VNet flow log Storage requirements](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview#storage-account).
3. **Scope precedence:** Flow logging can target a VNet, subnet, or NIC. When overlapping configurations exist, enablement precedence is **NIC > subnet > VNet**. [Manage VNet flow logs](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-manage).
4. **Traffic Analytics timing:** Traffic Analytics reads 1-minute flow blobs and processes them every **60 minutes** by default or every **10 minutes** when that interval is selected; aggregation and enrichment can then take up to **1 hour** before records appear in Log Analytics. [Traffic Analytics aggregation](https://learn.microsoft.com/en-us/azure/network-watcher/traffic-analytics-schema#data-aggregation).
5. **Cost:** VNet flow logs include **5 GB/month per subscription** at no charge, then bill per collected GB. Traffic Analytics has no free tier, and Storage charges are separate. [VNet flow log pricing](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview#pricing).
6. **Network Watcher limit:** Each subscription supports one Network Watcher instance per region. Network Watcher is automatically enabled when a VNet is created or updated unless the subscription previously opted out. [Network Watcher limits](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview#network-watcher-limits).
7. **Private endpoint limitation:** Flow traffic can't be captured at a private endpoint itself; capture it at the source VM, where the destination is recorded as the private endpoint IP and can be correlated through `PrivateEndpointResourceId`. [VNet flow log private endpoint traffic](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview#private-endpoint-traffic).
8. **Retirement change:** New NSG flow logs have been blocked since **June 30, 2025**, and NSG flow logs retire on **September 30, 2027**. Existing NSG flow-log resources will be deleted at retirement, while records already in Storage follow their configured retention. New designs use VNet flow logs. [NSG flow log retirement](https://learn.microsoft.com/en-us/azure/network-watcher/nsg-flow-logs-overview).
9. **Regional availability:** `[Limited regions — verify before specifying]` VNet flow logs and Traffic Analytics have separate regional availability columns, and not every VNet-flow-log region also hosts a Log Analytics workspace. [VNet flow log regional availability](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview#availability).

### Incompatibilities and mutual exclusions

If the workload is an unsupported integrated PaaS service such as App Service, Container Apps, Functions, Logic Apps, or Azure SQL Managed Instance, VNet flow logs can't capture that service's VNet integration traffic; use the service's supported logging and network-monitoring path. [VNet flow log incompatible services](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview#incompatible-services).

### Edge cases and gotchas

- Disable overlapping NSG flow logs before enabling VNet flow logs on the same workload, or traffic can be duplicated and charged twice. [VNet versus NSG flow logs](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview#virtual-network-flow-logs-compared-to-network-security-group-flow-logs).
- ExpressRoute FastPath bypasses the gateway and isn't captured at the gateway subnet; record the flow at the VM NIC or subnet instead. [VNet flow logs and ExpressRoute](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview#expressroute-gateway-traffic).
- Rotating a customer-managed encryption key for the destination Storage account stops flow logging until the flow log is disabled and re-enabled. [VNet flow log Storage considerations](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview#storage-account).
- While Azure appends 1-minute data to the current block blob, editing, overwriting, or deleting its block structure can make later writes for that hour fail. [Manage VNet flow logs](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-manage).

### AZ-305 exam discriminator

“Capture allowed and denied IP flows across a VNet and optionally visualize top talkers” selects VNet flow logs to same-region Standard Storage, optionally with Traffic Analytics. A resource diagnostic setting isn't the raw flow-log route. [Virtual network flow logs](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview).

### Common trap

Do not select NSG flow logs for a new design: creation ended in **June 2025**, retirement is **September 2027**, and Microsoft directs customers to VNet flow logs. [NSG flow log retirement](https://learn.microsoft.com/en-us/azure/network-watcher/nsg-flow-logs-overview).

---

## Azure Monitor pipeline

**Classification:** Supporting edge/hybrid  
**Why it matters:** Azure Monitor pipeline is a centrally managed but customer-operated edge collector for sources that can't run AMA or need preprocessing and buffering before cloud ingestion.  
**Primary Microsoft source:** [Azure Monitor pipeline overview](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview)

### Deep technical facts / requirements

1. **Deployment prerequisite:** The pipeline is a containerized solution deployed on a supported **Azure Arc-enabled Kubernetes** cluster in an edge site, datacenter, or another cloud. Microsoft manages its Azure integration, while the customer operates and maintains the Kubernetes environment. [Azure Monitor pipeline architecture](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview#how-azure-monitor-pipeline-works).
2. **Source status:** Syslog RFC 3164/5424 and CEF-over-Syslog are generally available; OpenTelemetry log ingestion over OTLP is `[Preview]`. [Azure Monitor pipeline supported data sources](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview#supported-data-sources).
3. **Default ports:** Syslog/CEF clients send over TCP or UDP **514** by default, while OTLP log clients use TCP **4317** by default `[Preview]`. [Azure Monitor pipeline architecture](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview#how-azure-monitor-pipeline-works).
4. **Local processing:** Pipeline transformations occur before telemetry is sent to Azure Monitor and can filter, reshape, and aggregate records, reducing both network traffic and cloud ingestion volume. Cloud DCR transformations occur later and don't support aggregation. [Pipeline transformation comparison](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations#azure-monitor-pipeline-transformations).
5. **Disconnection buffer:** Optional persistent storage survives process restarts and connectivity loss, then backfills when connectivity returns. The documented maximum pipeline persistence retention is **2,880 minutes (2 days)**. [Troubleshoot pipeline persistence](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-troubleshoot#check-persistence-configuration).
6. **Secure receiver:** TCP receivers support TLS and optional mutual TLS so the pipeline can encrypt client-to-pipeline traffic and authenticate trusted sources. [Azure Monitor pipeline capabilities](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview#key-capabilities).
7. **Destination chain:** The processing path is receiver → processor → exporter → DCE → DCR → Log Analytics workspace. A healthy local receiver doesn't prove that DCE/DCR authorization, schema, or destination ingestion is healthy. [Troubleshoot Azure Monitor pipeline](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-troubleshoot#no-data-arriving-in-azure-monitor).
8. **Regional and distribution support:** `[Limited regions — verify before specifying]` The pipeline supports a documented set of Kubernetes distributions/versions and Azure regions; unsupported cluster versions or regions invalidate the design. [Azure Monitor pipeline supported configurations](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview#supported-configurations).

### Incompatibilities and mutual exclusions

If the site can't supply a supported Arc-enabled Kubernetes cluster and operate its required extensions, Azure Monitor pipeline can't be deployed; use AMA on Arc-enabled servers, a supported direct API route, or another forwarding architecture. [Configure Azure Monitor pipeline prerequisites](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-configure).

### Edge cases and gotchas

- `CommonSecurityLog` is available as a pipeline target only when the destination workspace is onboarded to Microsoft Sentinel. [Configure Azure Monitor pipeline](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-configure).
- Two receivers can't bind the same endpoint/port, and firewall or NSG rules must allow clients to reach the Arc-cluster receiver. [Troubleshoot pipeline receiver connectivity](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-troubleshoot#validate-receiver-configuration).
- A persistent exporter requires a valid bound Kubernetes persistent volume; setting persistence without `persistentVolumeName` fails validation. [Troubleshoot pipeline persistence](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-troubleshoot#check-persistence-configuration).
- `[Preview]` OTLP log collection shouldn't be presented as an unqualified GA exam answer, even though Syslog and CEF ingestion are GA. [Azure Monitor pipeline supported data sources](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview#supported-data-sources).

### AZ-305 exam discriminator

“Thousands of appliances or applications can't run AMA and need local filtering, aggregation, or up to **2 days** of disconnection buffering” points to Azure Monitor pipeline on supported Arc-enabled Kubernetes. Ordinary AMA is one agent per supported machine and doesn't provide this shared edge receiver. [Azure Monitor pipeline use cases](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview#why-use-azure-monitor-pipeline).

### Common trap

Do not describe Azure Monitor pipeline as a Microsoft-operated appliance: Azure provides the extension and Azure integration, but the customer remains responsible for the underlying Kubernetes cluster. [Azure Monitor pipeline shared responsibility](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview#how-azure-monitor-pipeline-works).

---

## Microsoft Sentinel

**Classification:** Supporting security destination  
**Why it matters:** Sentinel is selected when routed data must support security correlation, detection, hunting, incidents, and automated response. It changes workspace retention and pricing decisions but doesn't replace a WORM archive.  
**Primary Microsoft source:** [Microsoft Sentinel overview](https://learn.microsoft.com/en-us/azure/sentinel/overview)

### Deep technical facts / requirements

1. **Capability:** Microsoft Sentinel is a cloud-native SIEM that collects multicloud and multiplatform security data and adds analytics rules, incidents, hunting, threat intelligence, and automation. A plain Log Analytics workspace stores and queries logs but doesn't itself provide this SIEM/SOAR layer. [Microsoft Sentinel SIEM capabilities](https://learn.microsoft.com/en-us/azure/sentinel/overview).
2. **Workspace relationship:** Sentinel is enabled on a Log Analytics workspace, and removing Sentinel doesn't delete that workspace or stop its separate workspace charges. [Microsoft Sentinel billing after removal](https://learn.microsoft.com/en-us/azure/sentinel/billing#costs-that-might-accrue-after-resource-deletion).
3. **Analytics retention:** Sentinel solution tables can retain **90 days** in the Analytics tier at no storage charge; Analytics retention can be extended to **2 years**. [Microsoft Sentinel data tiers and retention](https://learn.microsoft.com/en-us/azure/sentinel/manage-data-overview#how-data-tiers-and-retention-work).
4. **Data lake retention:** Total retention can extend to **12 years** in the lower-cost data lake tier, but lake-only data isn't available to real-time analytics rules, hunting, workbooks, watchlists, or playbooks. It is accessed through KQL/Spark jobs and other lake workflows. [Microsoft Sentinel tier comparison](https://learn.microsoft.com/en-us/azure/sentinel/manage-data-overview#compare-the-analytics-and-data-lake-tiers).
5. **Pricing:** Analytics-tier pricing defaults to pay-as-you-go; combined Sentinel/Log Analytics commitment tiers start at **100 GB/day**. Some connectors also run Azure Functions, and playbooks run Logic Apps, creating separate service charges. [Microsoft Sentinel pricing and billing](https://learn.microsoft.com/en-us/azure/sentinel/billing#how-youre-charged-for-microsoft-sentinel).
6. **RBAC:** Sentinel Reader can view data and incidents, Responder adds incident management, and Contributor adds solution/content and resource management. Running or editing playbooks requires additional Playbook Operator or Logic App permissions. [Microsoft Sentinel roles](https://learn.microsoft.com/en-us/azure/sentinel/roles#built-in-azure-roles-for-microsoft-sentinel).
7. **Multiple workspaces:** Sentinel can centrally display incidents and query across multiple workspaces or tenants, including through Azure Lighthouse, but each extra workspace adds configuration, analytics-rule, and governance complexity. [Extend Sentinel across workspaces and tenants](https://learn.microsoft.com/en-us/azure/sentinel/extend-sentinel-across-workspaces-tenants).
8. **Portal retirement:** Microsoft Sentinel stops being supported in the Azure portal after **March 31, 2027** and remains available in the Microsoft Defender portal. New customers with the required permissions have been automatically onboarded to the Defender portal since **July 2025**. [Microsoft Sentinel portal transition](https://learn.microsoft.com/en-us/azure/sentinel/overview).

### Incompatibilities and mutual exclusions

If a security table is placed only in the Sentinel data lake tier and the same data must drive real-time analytics rules, threat hunting, workbooks, or playbooks, the design is invalid because those features require Analytics-tier availability. [Compare Sentinel analytics and data lake tiers](https://learn.microsoft.com/en-us/azure/sentinel/manage-data-overview#compare-the-analytics-and-data-lake-tiers).

### Edge cases and gotchas

- Sentinel inherits Azure Monitor's append-oriented storage behavior but Azure Monitor supports compliance purges, so Sentinel/Log Analytics retention isn't equivalent to a locked WORM archive. [Microsoft Sentinel data immutability](https://learn.microsoft.com/en-us/azure/sentinel/overview).
- A Microsoft Sentinel Responder can manage incidents but can't create analytics rules or edit Sentinel resources; those tasks require Contributor. [Microsoft Sentinel built-in roles](https://learn.microsoft.com/en-us/azure/sentinel/roles#built-in-azure-roles-for-microsoft-sentinel).
- Role assignments are cumulative, and broad Azure or Log Analytics roles can grant more workspace access than the Sentinel-specific role name suggests. [Microsoft Sentinel roles and permissions](https://learn.microsoft.com/en-us/azure/sentinel/roles#other-azure-and-log-analytics-roles).
- Onboarding Sentinel to the Defender portal doesn't change the underlying Log Analytics ingestion pipeline or table schema, but some portal-specific features and behavior differ. [Transition Sentinel to the Defender portal](https://learn.microsoft.com/en-us/azure/sentinel/move-to-defender).

### AZ-305 exam discriminator

“Threat hunting, correlation, incidents, playbooks, and automated response” requires a Sentinel-enabled workspace. “KQL troubleshooting only” needs Log Analytics but not necessarily Sentinel, and “legal WORM evidence” still requires immutable Storage. [Microsoft Sentinel capabilities](https://learn.microsoft.com/en-us/azure/sentinel/overview).

### Common trap

Do not route every log to Sentinel merely because it is security-adjacent; high-volume data not needed for real-time detection can use the data lake tier or another archive, while Analytics-tier ingestion is reserved for data that powers Sentinel features. [Microsoft Sentinel data tiers](https://learn.microsoft.com/en-us/azure/sentinel/manage-data-overview#compare-the-analytics-and-data-lake-tiers).

---

## Azure Policy for routing governance

**Classification:** Supporting governance  
**Why it matters:** Azure Policy can deploy and remediate diagnostic settings, AMA, and DCR associations across management groups, subscriptions, and resource groups. It controls configuration coverage but doesn't prove data delivery.  
**Primary Microsoft source:** [Create diagnostic settings at scale with Azure Policy](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy)

### Deep technical facts / requirements

1. **Resource-type awareness:** Diagnostic categories vary by resource provider, so built-in or custom diagnostic-setting policies are resource-type-specific. For types without a built-in definition, Microsoft documents creating a custom policy. [Diagnostic settings at scale](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy#create-a-custom-policy-definition).
2. **Category groups:** Policies using `allLogs` or `audit` category groups automatically adapt when Microsoft adds new categories to that group, avoiding a policy edit for each new category but potentially increasing routed volume. [Diagnostic-setting policy category groups](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy#use-log-category-groups).
3. **Initiative design:** An initiative can combine one diagnostic policy per Azure service and expose a shared destination parameter. One initiative can then be assigned at management-group, subscription, or resource-group scope. [Create a diagnostic-setting policy initiative](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy#create-an-initiative).
4. **Existing resources:** `deployIfNotExists` marks existing resources noncompliant during evaluation but doesn't modify them until a remediation task runs. Assignment-time deployment handles new or updated resources; remediation is the required backfill for existing resources. [DeployIfNotExists evaluation](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deploy-if-not-exists#deployifnotexists-evaluation).
5. **Managed identity:** A `deployIfNotExists` or `modify` assignment uses one system- or user-assigned managed identity for remediation, and that identity needs the least-privileged roles declared by the policy. Portal assignments can grant them automatically; SDK-created assignments require manual role assignment. [Azure Policy remediation access control](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#how-remediation-access-control-works).
6. **Evaluation delay:** `deployIfNotExists` defaults to a **10-minute (`PT10M`)** delay after resource provisioning and supports a configurable **0–360 minute** ISO 8601 duration or provisioning-result modes. [DeployIfNotExists evaluation delay](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deploy-if-not-exists#deployifnotexists-properties).
7. **Remediation scale:** A remediation task defaults to **500 resources**, can target up to **50,000**, and permits **1–30** parallel deployments with a default of **10**. The default failure threshold is **100%**. [Azure Policy remediation task limits](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#create-a-remediation-task).
8. **AMA at scale:** Built-in initiatives can assign a user-assigned managed identity, install AMA, and create the DCRA for Azure VMs/VMSS. Arc-enabled servers use system-assigned identity because that is the supported Arc authentication model. [Use Azure Policy to install AMA](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-policy).

### Incompatibilities and mutual exclusions

If existing resources must be configured and the plan includes only assigning a `deployIfNotExists` policy, the plan is incomplete because existing noncompliant resources require a remediation task. [Remediate noncompliant resources](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources).

### Edge cases and gotchas

- A policy compliance result proves that the expected configuration resource exists and matches the policy condition; it doesn't prove that the source generated logs, the destination accepted them, or a consumer processed them. [DeployIfNotExists evaluation](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deploy-if-not-exists#deployifnotexists-evaluation).
- Changing a policy definition doesn't automatically update an existing assignment or its managed identity's role assignments; newly added role requirements must be granted separately. [Azure Policy remediation access control](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#how-remediation-access-control-works).
- `deployIfNotExists` supports nested templates but not linked templates, so a custom diagnostic-setting deployment must include its deployment content accordingly. [DeployIfNotExists effect](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deploy-if-not-exists).
- A management-group initiative centralizes assignment, but destination identity, region, category support, and RBAC still have to be valid for each matched resource type and subscription. [Assign a diagnostic-setting initiative](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy#assign-the-initiative).

### AZ-305 exam discriminator

“Apply the logging baseline to all current and future resources across many subscriptions” points to an initiative at management-group scope plus a managed identity and remediation tasks. Manual settings or an assignment without remediation don't cover the whole requirement. [Diagnostic settings at scale with Azure Policy](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy).

### Common trap

Do not assume that Azure Policy supplies one universal diagnostic-setting definition for every Azure resource type; log categories and destination support vary, so the initiative contains resource-type-aware built-in or custom policies. [Create diagnostic settings at scale](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy#create-a-custom-policy-definition).

---

## Current-documentation notes

- `[Preview]` Platform telemetry collection through DCRs is now documented for supported resource types, but it has a one-destination-type-per-DCR rule and a **5-DCR association** ceiling. This is newer than the supplied guide's generally available diagnostic-settings model, so diagnostic settings remain the unqualified exam default. [Platform log collection with DCRs preview](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/platform-logs-collect#limitations).
- Current Logs Ingestion API limits are **2 GB/minute** and **12,000 requests/minute per DCR**. Older Microsoft tutorial figures of 500 MB/minute and 300,000 requests/minute are superseded by the current service-limits page. [Current Logs Ingestion API limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#logs-ingestion-api).
- The Logs Ingestion API began enforcing **TLS 1.2 or higher on March 1, 2026**; direct DCR endpoints have existed since **March 31, 2024**, but old DCRs can't be retrofitted with them. [Logs Ingestion API endpoint and TLS changes](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview).
- Azure Monitor pipeline now documents Syslog and CEF collection as generally available, while OTLP log collection remains `[Preview]`; older descriptions that label every pipeline source as preview are outdated. [Azure Monitor pipeline supported data sources](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview#supported-data-sources).
- Current Log Analytics documentation supports up to **730 days** of interactive retention and **12 years** total retention. These limits don't replace immutable Storage when the requirement is locked WORM protection. [Azure Monitor workspace retention limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#data-collection-volume-and-retention).
- The Log Analytics agent retired on **August 31, 2024**, and its cloud ingestion can be shut down at any time after **March 2, 2026**; AMA+DCR is the current machine-log design. [Log Analytics agent retirement](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-migration).
- New NSG flow logs have been blocked since **June 30, 2025**, and the feature retires on **September 30, 2027**; use VNet flow logs for new network-flow routing designs. [NSG flow log retirement](https://learn.microsoft.com/en-us/azure/network-watcher/nsg-flow-logs-overview).
- Microsoft Sentinel stops being supported in the Azure portal after **March 31, 2027** and remains in the Microsoft Defender portal; the underlying Log Analytics ingestion pipeline and schema don't change merely because the portal changes. [Microsoft Sentinel portal transition](https://learn.microsoft.com/en-us/azure/sentinel/move-to-defender).

## Highest-yield exam discriminators

| Scenario clue | Best answer | Why |
|---|---|---|
| One resource must send logs to six separate workspaces | Centralize or add a supported second stage | A resource supports only **5 diagnostic settings**, and each workspace requires its own setting. [Azure Monitor diagnostic settings limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#diagnostic-settings). |
| One source must send to Log Analytics, Storage, and Event Hubs | One diagnostic setting | One setting can contain one destination of each type, so three different destination types fit in one setting. [Diagnostic settings destinations](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#destinations). |
| Regional resource must archive to firewalled Storage | Same-region Standard Storage plus trusted-services bypass | Regional resources require same-region Storage; Premium isn't supported, and the Azure Monitor writer needs trusted-services firewall access. [Diagnostic settings Storage requirements](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#destinations). |
| “Who deleted the VM?” | Azure Activity Log | Activity Log records subscription control-plane operations, is collected automatically, and retains **90 days** by default. [Azure Activity Log](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log). |
| Guest Windows events or Linux Syslog | AMA + DCR + DCRA | Diagnostic settings can't read inside the guest; AMA collects local data according to an associated DCR. [Azure Monitor Agent overview](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview). |
| On-premises machines must use AMA | Azure Arc-enabled servers + AMA + DCR | Azure Arc supplies the resource identity and system-assigned managed identity required for AMA outside Azure. [AMA outside Azure](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-supported-operating-systems#on-premises-and-in-other-clouds). |
| Custom JSON up to 1 MB/call with schema reshaping | Logs Ingestion API + DCR transformation | The API accepts JSON through the DCR and supports **1 MB** calls, **64 KB** fields, **2 GB/minute**, and **12,000 requests/minute per DCR**. [Logs Ingestion API limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#logs-ingestion-api). |
| Client uses public ingestion and a new direct-ingestion DCR | DCR endpoint; no mandatory DCE | A DCE is required for private link or a DCR without a direct endpoint, not for every direct-ingestion design. [Logs Ingestion API endpoint selection](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#endpoint). |
| KQL, workbooks, correlation, and log alerts | Log Analytics workspace | Log Analytics is the queryable destination; Storage is an archive and Event Hubs is a stream. [Log Analytics workspace overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview). |
| Operations query first; selected tables then go downstream | Log Analytics workspace data export | Data export continuously forwards new records from selected whole tables after workspace ingestion. [Log Analytics data export](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export). |
| Historical or row-filtered workspace export | Query-orchestrated export, or transform before ingestion | Continuous data export doesn't backfill history and has no row predicate. [Other Log Analytics export options](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#other-export-options). |
| Archive-only telemetry with minimum analytics cost | Direct diagnostic setting to Storage | Workspace-first export incurs Log Analytics ingestion and JSON export charges before the archive receives data. [Log Analytics data export pricing](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#pricing-model). |
| Seven-year, rarely read, tamper-resistant evidence | Standard Blob Storage with locked WORM | Immutable Blob Storage supports **1–146,000 days**; a locked policy can't be deleted or shortened. [Immutable storage retention and locking](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#locked-versus-unlocked-policies). |
| Third-party SIEM or Kafka-compatible consumer | Event Hubs | Event Hubs is the decoupled stream, but retention is only **1/7/90 days** by tier, so the consumer or Capture must persist required history. [Event Hubs tier quotas](https://learn.microsoft.com/en-us/azure/event-hubs/compare-tiers#quotas). |
| Multiple independent stream consumers on Basic Event Hubs | Upgrade to Standard or higher | Basic supports only **1 consumer group**; Standard supports **20**, allowing independent checkpoints. [Event Hubs consumer-group limits](https://learn.microsoft.com/en-us/azure/event-hubs/compare-tiers#quotas). |
| Risky sign-ins and tenant audit trail | Microsoft Entra diagnostic settings | These are tenant identity logs, with **7/30-day** audit/sign-in retention and P2-only **90-day** risky-sign-in retention—not subscription Activity Log data. [Microsoft Entra data retention](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/reference-reports-data-retention). |
| VNet IP-flow capture and top talkers | VNet flow logs to Storage, optionally Traffic Analytics | VNet flow logs collect Layer-4 flows every **1 minute** to same-region Standard Storage; Traffic Analytics adds **10- or 60-minute** processing. [Virtual network flow logs](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview). |
| Appliances can't run AMA and need local aggregation/buffering | Azure Monitor pipeline | The pipeline runs on Arc-enabled Kubernetes, supports local processing, and can persist up to **2 days** during disconnection; OTLP logs remain `[Preview]`. [Azure Monitor pipeline overview](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview). |
| Threat hunting, incidents, and playbooks | Sentinel-enabled Log Analytics workspace | Sentinel adds SIEM/SOAR; lake-only data can't power real-time analytics or hunting, so required detection data must remain in Analytics. [Microsoft Sentinel data tiers](https://learn.microsoft.com/en-us/azure/sentinel/manage-data-overview#compare-the-analytics-and-data-lake-tiers). |
| Current and future resources across many subscriptions | Azure Policy initiative plus remediation | Assignment covers new resources; existing noncompliant resources need remediation, which can target up to **50,000** resources per task. [Azure Policy remediation](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#create-a-remediation-task). |

---

_Model used to research and author this fact sheet: Codex (GPT-5; reasoning mode was not supplied in the request)._
