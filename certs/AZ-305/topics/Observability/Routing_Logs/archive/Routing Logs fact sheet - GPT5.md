# Deep Technical Facts and Requirements for Recommend a Solution for Routing Logs

## Scope

- Exam: AZ-305: Designing Microsoft Azure Infrastructure Solutions
- Task: Recommend a solution for routing logs
- Source guide: "AZ-305 Study Guide: Recommend a solution for routing logs" and "Routing Logs task map"
- Research date: July 2026
- Product selection method: Products and major topics were extracted from the provided guide, then validated against current official Microsoft documentation.

## Product coverage summary

| Product / topic | Classification | Why it matters for this task |
|---|---|---|
| Diagnostic settings | Core | Primary platform route for resource logs, Activity Log, and exportable platform metrics. |
| Resource logs and collection mode | Core | Category availability and destination schema determine what arrives and how it can be secured and queried. |
| Azure Activity Log | Core | Subscription control-plane events use a different scope and have a fixed built-in retention period. |
| DCR, DCRA, DCE, and transformations | Core | Define modern collection, transformation, association, and endpoint behavior. |
| Azure Monitor Agent (AMA) | Core | Supported route for guest OS and workload logs from Azure and Arc-enabled machines. |
| Logs Ingestion API | Core | DCR-governed route for custom JSON and direct-ingestion sources. |
| Log Analytics workspace | Core destination | Queryable operational destination whose region, retention, RBAC, topology, and cost affect routing. |
| Log Analytics data export | Core second stage | Continuously forwards supported tables after workspace ingestion. |
| Azure Event Hubs | Core destination | Streaming handoff to third-party SIEMs and external processors. |
| Azure Blob Storage and immutable storage | Core destination | Archive and WORM destination for long-lived or regulated records. |
| Microsoft Entra log routing | Supporting special source | Tenant identity logs require tenant-level configuration and roles. |
| Virtual network flow logs | Supporting special source | Network flow telemetry follows a storage-first Network Watcher path. |
| Azure Monitor pipeline | Supporting edge/hybrid | Provides central preprocessing and buffering for sources that cannot run AMA. |
| Microsoft Sentinel | Supporting security destination | A Sentinel-enabled workspace adds SIEM/SOAR behavior and pricing. |
| Azure Policy | Supporting governance | Deploys and remediates diagnostic settings at scale. |

---

## Diagnostic settings

**Classification:** Core  
**Why it matters:** Diagnostic settings are the normal source-side route for Azure platform telemetry. Their destination, regional, network, and count constraints can invalidate an otherwise plausible design.  
**Primary Microsoft source:** [Diagnostic settings in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings)  
**Limits and quotas source:** [Azure Monitor service limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#diagnostic-settings)

### Deep technical facts / requirements

1. Resource logs are **not collected by default**; platform metrics and Activity Log events are collected automatically, but a diagnostic setting is still required to send them to another destination.
2. A resource supports at most **5 diagnostic settings**. One setting can contain no more than **one destination of each type**, so two workspaces or two Event Hubs destinations require separate settings.
3. Supported destinations are a Log Analytics workspace, Standard Azure Storage, Event Hubs, and supported Azure Monitor partner solutions. Premium Storage and Azure DNS zone endpoints are not supported diagnostic-setting destinations.
4. For a regional monitored resource, its Storage and Event Hubs destinations must be in the **same region**. A Log Analytics workspace does not have that same-region restriction, although residency and latency can still drive workspace placement.
5. A destination can be in another subscription when the configuring identity has RBAC access to both. A destination in another tenant requires a cross-tenant management pattern such as Azure Lighthouse.
6. The destination must exist before the setting. Log Analytics creates destination tables only after the first record arrives; configuration success does not prove records exist.
7. Firewalled Storage and Event Hubs destinations require **Allow trusted Microsoft services to bypass this firewall**. A private endpoint by itself does not authorize the Azure Monitor diagnostic-settings service.
8. Event Hubs streaming requires an authorization rule with `Manage`, `Send`, and `Listen`; updating the setting also requires `ListKey` on that rule. Diagnostic settings cannot target a compacted event hub because Azure Monitor does not provide the required partition key.
9. Destination endpoints support **TLS 1.2**. This protects transport but does not create a private route or an immutable destination.
10. A setting selects whole categories or the `allLogs`/`audit` category groups; it cannot filter individual records inside a selected category. Supported workspace transformations can filter later at ingestion.
11. `allLogs` automatically picks up categories later added to that group. `audit` selects audit categories only. A setting cannot mix a category group with individually selected categories.
12. Exported multidimensional metrics are flattened and aggregated across dimension values. Not every platform metric is exportable, so the metrics catalog's **Exportable** column is a hard prerequisite.
13. Microsoft states that data should begin flowing within **90 minutes** after creation. An absence of records can still mean no source events were generated, not a broken configuration.
14. Deleting, renaming, moving, or migrating a resource does not safely clean up its old diagnostic settings. If the same resource identity is recreated, an orphaned setting can resume collection, so lifecycle cleanup is required.

### Incompatibilities and mutual exclusions

If a regional resource and a Storage or Event Hubs destination in a different region are both required, that diagnostic-setting route cannot be used because regional resources must send to same-region Storage/Event Hubs. Use a compliant same-region first destination and, if necessary, a supported replication or second-stage export design.

### Edge cases and gotchas

- A setting for a Storage account or Event Hubs namespace cannot select that same resource as its own destination in the portal because that can create a logging loop.
- Enabling Azure SQL's `audit` log category does **not** enable SQL auditing; auditing must first be enabled on the database.
- Inactive zero-value metric export backs off: after **1 hour** it can wait **15 minutes**, and after **7 days** it reaches a **2-hour** maximum backoff. Normal export returns to about **3 minutes** after nonzero values resume.
- Diagnostic settings do not support resource IDs containing non-ASCII characters.

### AZ-305 exam discriminator

“Send a resource's logs to six workspaces” is impossible directly because the resource has a five-setting ceiling. “Send to two workspaces” requires two settings, while “send once to Log Analytics, Storage, and Event Hubs” can use one setting because those are three different destination types.

### Common trap

Assuming a private endpoint is sufficient for a firewalled destination. The service-to-destination write still requires the trusted-services firewall bypass documented for diagnostic settings.

---

## Resource logs and collection mode

**Classification:** Core  
**Why it matters:** Resource logs describe service and data-plane operations, but each resource provider exposes its own categories and supported schema mode.  
**Primary Microsoft source:** [Resource logs in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs)  
**Limits and quotas source:** [Diagnostic-setting limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#diagnostic-settings)

### Deep technical facts / requirements

1. Resource logs are not collected until a diagnostic setting selects their categories; merely creating a resource or workspace produces no resource-log route.
2. Resource-log categories and schemas vary by resource type. A generic policy that assumes identical category names across all providers is invalid unless it uses supported category groups.
3. Azure diagnostics mode writes records from many resource types into the legacy `AzureDiagnostics` table. Resource-specific mode writes each supported category to a dedicated table.
4. Resource-specific tables improve schema discoverability, ingestion/query performance, and table-level RBAC. Microsoft recommends resource-specific mode for new settings where the service supports the choice.
5. Many services force one mode and do not expose a selection. The resource log reference must therefore be checked before promising a particular table.
6. Changing a setting from Azure diagnostics to resource-specific mode does not migrate old records. Existing rows remain in `AzureDiagnostics`; new rows go to the dedicated table, requiring `union` during the retention overlap.
7. Event Hubs receives resource-log payloads as JSON with an outer `records` element. The inner record schema remains resource-type dependent.
8. Resource-log delivery uses store-and-forward with redundancy and retries but is **not transactionally lossless**; small losses can occur during temporary, nonrepeating platform issues.
9. Selecting `AllMetrics` does not guarantee every metric can be exported, and dimension data can be lost through flattening. Resource logs and metrics therefore cannot be treated as schema-equivalent substitutes.

### Incompatibilities and mutual exclusions

If per-table RBAC and a service that only supports Azure diagnostics mode are both present, that service's resource logs cannot gain dedicated-table isolation through the diagnostic setting because they land in the shared `AzureDiagnostics` table.

### Edge cases and gotchas

- A newly supported category is automatically included by `allLogs`, which is useful for coverage but can unexpectedly increase ingestion cost.
- A category name valid for one resource type can be rejected for another.
- Switching modes creates a two-table query period; it does not rewrite historical data.
- A successful setting can still yield an empty table when the source has emitted no matching events.

### AZ-305 exam discriminator

When a scenario calls for table-specific access control or simpler schemas, prefer resource-specific mode where supported. Do not claim that every resource can choose it.

### Common trap

Using `AzureDiagnostics` as the universal modern destination table. It is a legacy shared-table mode and only a minority of services still rely on it.

---

## Azure Activity Log

**Classification:** Core  
**Why it matters:** The Activity Log is the subscription control-plane source for who changed what; it is not guest telemetry or a resource's data-plane log.  
**Primary Microsoft source:** [Azure Activity Log](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log)  
**Limits and quotas source:** [Azure Monitor Activity Log limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#log-queries-and-language)

### Deep technical facts / requirements

1. Azure retains Activity Log events for **90 days** at no charge and then deletes them. Longer retention requires export to another destination.
2. Events are usually available within **3–20 minutes** of occurrence; the Activity Log is not a synchronous audit stream.
3. Export uses subscription- or management-group-scope diagnostic settings, not a DCR associated with each VM.
4. Export to Log Analytics writes into `AzureActivity`. Activity Log ingestion is free; retention charges apply only beyond the included **90 days**, and total workspace retention can reach **12 years**.
5. Export to Storage creates blobs under `insights-activity-logs` in hourly `PT1H.json` paths. Storage is unnecessary solely to preserve events for 90 days or less.
6. Event Hubs export emits JSON payloads with an outer `records` array and is appropriate when an external consumer needs the stream.
7. The Activity Log REST API requires a `$filter` with at least an `eventTimestamp` start value; both ends of the requested interval must fall inside the built-in 90-day window.
8. The Activity Log API allows **50 queries per 30 seconds** and a maximum timeout of **75 seconds**. Querying `AzureActivity` instead uses general Logs API limits.
9. Resource creator information is only available in the Activity Log. If that evidence must survive beyond 90 days, the route must be configured before the built-in copy expires.
10. Field values in `AzureActivity` can differ in case; robust KQL uses case-insensitive comparisons such as `=~` or normalizes with `tolower()`.

### Incompatibilities and mutual exclusions

If the source is subscription control-plane activity and the proposed mechanism is AMA+DCR, that mechanism cannot satisfy the requirement because AMA reads guest OS sources, not the Azure Activity Log.

### Edge cases and gotchas

- Activity Log alerts and log alerts are different; exporting to a workspace enables more complex KQL-based alert logic.
- Duplicate collection can result when overlapping subscription and management-group routes are designed without scope analysis.
- “Who created this resource?” becomes unanswerable after 90 days if no longer-lived route was established.

### AZ-305 exam discriminator

The clue “subscription-level control-plane change” selects the Activity Log route. The clue “inside the VM” eliminates it and selects AMA+DCR.

### Common trap

Treating the Activity Log as a record of application, guest OS, or service data-plane operations. It is primarily the Azure control plane.

---

## Data collection rules, associations, endpoints, and transformations

**Classification:** Core  
**Why it matters:** DCRs define input streams, transformations, data flows, and destinations for modern agent and ingestion workflows; DCRAs bind rules to monitored resources.  
**Primary Microsoft source:** [Data collection rules in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview)  
**Limits and quotas source:** [Azure Monitor DCR limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#data-collection-rules)

### Deep technical facts / requirements

1. A DCR is an Azure resource that defines data sources, input streams, transformations, data flows, and destinations. A DCRA is a separate association that applies a DCR to a resource such as a VM.
2. A DCR supports at most **10 data sources**, **10 data flows**, **20 data streams**, **10 extensions**, and **10 Log Analytics workspaces**.
3. A performance-counter source supports at most **100 counter specifiers**, a Syslog source **20 facility names**, and an Event Log source **100 XPath queries**.
4. Extension settings are limited to **32 KB**, and each transformation is limited to **15,360 characters**.
5. A DCR transformation uses a restricted KQL form to filter, parse, reshape, aggregate, or route records before they reach the destination table. Its output must match the target stream/table schema.
6. DCRs are centrally managed Azure resources and can be reused across many machines; one bespoke DCR per VM is not required.
7. A DCRA is required for association-based workflows such as AMA. Direct-ingestion workflows instead identify the DCR and stream in the API request and do not associate the client as an Azure resource.
8. A DCE supplies configuration-access and/or ingestion endpoints when the workflow or network design needs it. Logs Ingestion can use the DCR's own ingestion endpoint; private-link ingestion requires a DCE.
9. A workspace transformation DCR applies per supported table to incoming workflows that do not already use their own DCR. AMA data already processed by its DCR is not transformed again by a workspace transformation DCR.
10. Transformation charging can apply when Analytics or Basic table transformations discard more than **50%** of incoming data. Adding columns or expanding records can increase billable ingested volume.
11. A DCR can send to multiple workspaces within its ten-workspace ceiling, but duplicate delivery duplicates ingestion and retention cost.

### Incompatibilities and mutual exclusions

If a source workflow already uses an AMA DCR and the design relies on a workspace transformation DCR to transform it again, the combination cannot work because workspace transformations apply only to supported workflows that do not already use a DCR.

### Edge cases and gotchas

- A DCR, DCRA, and DCE are distinct resources; creating the DCR alone does not associate it with a VM.
- A transformation that drops data can still incur a transformation charge when it discards more than half the input.
- Destination table schema changes can break ingestion unless the DCR output is updated accordingly.
- DCR limits are per rule, so scale by reusable rule boundaries rather than filling one universal rule indefinitely.

### AZ-305 exam discriminator

“Guest events from a fleet with per-environment selection” points to AMA plus reusable DCRs and DCRAs. “Custom JSON POST” points to Logs Ingestion API plus a DCR, not a VM association.

### Common trap

Calling a DCR a universal replacement for diagnostic settings. Azure resource logs and Activity Log export still normally use platform diagnostic settings.

---

## Azure Monitor Agent

**Classification:** Core  
**Why it matters:** AMA is the supported collection component for guest OS telemetry from Azure VMs and Azure Arc-enabled servers.  
**Primary Microsoft source:** [Azure Monitor Agent overview](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview)  
**Limits and quotas source:** [Azure Monitor service limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#data-collection-rules)

### Deep technical facts / requirements

1. AMA runs inside the guest and can read Windows Event Logs, performance counters, IIS/file logs on supported Windows systems, and Syslog, performance, and file logs on supported Linux systems.
2. Without a guest agent, Azure Monitor can see host/platform telemetry but cannot read guest logs or running-process data.
3. AMA gets collection configuration from associated DCRs and periodically checks for rule updates. Installing the extension without a valid DCR/DCRA does not define what to collect.
4. Hybrid and other-cloud machines require Azure Arc so that AMA, its managed identity, DCRs, and associations can be managed as Azure resources.
5. AMA can be deployed as a VM extension, through Azure Policy, or by experiences such as VM insights. The agent itself has no separate charge; ingestion and retention do.
6. General-availability AMA features are available in all global Azure regions, Azure Government, and Azure operated by 21Vianet. The VM extension is not supported in air-gapped clouds; the Windows MSI client can support that case.
7. AMA can deliver to multiple Log Analytics workspaces through DCR design, subject to the DCR's **10-workspace** limit and duplicated ingestion cost.
8. AMA is the supported successor to the legacy Log Analytics/MMA agent, which [retired on August 31, 2024](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-migration). Microsoft states that its cloud ingestion services can be shut down at any time after **March 2, 2026**, so the legacy agent is invalid for new designs.
9. AMA and diagnostic settings observe different layers: AMA reads the guest; diagnostic settings route Azure platform/resource-provider telemetry.
10. The agent is pull-configured from Azure and needs network access to the appropriate Azure Monitor control and ingestion endpoints; private networking changes require the documented DCE/Private Link design.

### Incompatibilities and mutual exclusions

If the source is a network appliance on which no agent can be installed, AMA cannot be used because it must run on the monitored machine; use a central receiver such as Azure Monitor pipeline for a supported protocol.

### Edge cases and gotchas

- Policy can deploy the extension and associations, but policy compliance does not prove the source emitted records or that ingestion succeeded.
- Collecting the same stream through overlapping DCRs can duplicate data and cost.
- Arc onboarding is a prerequisite for consistent AMA management of non-Azure servers.
- Update Manager no longer uses AMA, so enabling Update Manager is not proof that log collection is configured.

### AZ-305 exam discriminator

“Windows events,” “Syslog,” “IIS logs,” or “guest performance counters” are AMA+DCR clues. “Azure resource audit category” is a diagnostic-settings clue.

### Common trap

Installing AMA and assuming collection starts automatically. The rule and association supply the actual collection configuration.

---

## Logs Ingestion API

**Classification:** Core  
**Why it matters:** This is the supported DCR-governed path for custom applications and direct JSON ingestion into Azure Monitor Logs.  
**Primary Microsoft source:** [Logs Ingestion API overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview)  
**Limits and quotas source:** [Azure Monitor Logs Ingestion API limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#logs-ingestion-api)

### Deep technical facts / requirements

1. The client sends JSON over HTTPS to a DCR ingestion endpoint or DCE, naming the DCR immutable ID and stream; the current documented URI uses `api-version=2023-01-01`.
2. The target Log Analytics table and DCR must exist before ingestion. The DCR input declaration describes received JSON, and its output stream must match the table schema.
3. Input JSON need not match the final table when a DCR transformation converts it. The destination table or workspace can be changed in the DCR without changing the client's payload contract.
4. Authentication is Microsoft Entra OAuth. An application/service principal or managed identity must be granted permission to the DCR; possession of a workspace key is not the modern authentication model.
5. A DCE is optional when the DCR has its own logs-ingestion endpoint, but a DCE is required for Private Link ingestion.
6. Custom table names end in `_CL`. Column names must start with a letter, contain at most **45** alphanumeric/underscore characters, and avoid reserved names; custom columns added to an Azure table use `_CF`.
7. Auxiliary tables restrict the `TimeGenerated` range in one API call to less than **30 minutes** when source timestamps pass through unchanged.
8. The API is an ingestion path to Log Analytics, not an Event Hubs-compatible fan-out mechanism. External consumers require data export, Event Hubs, or another architecture after/before ingestion.
9. The Logs Ingestion API supersedes the legacy HTTP Data Collector API with OAuth, DCR schema control, transformations, and longer-term platform support.

### Incompatibilities and mutual exclusions

If private-link ingestion is mandatory and the design calls only the public DCR endpoint without a DCE, the design cannot satisfy the requirement because private-link Logs Ingestion requires the DCE path.

### Edge cases and gotchas

- The DCR **immutable ID**, not merely its Azure resource name, appears in the request URI.
- A syntactically valid JSON body can be rejected or dropped when its transformed output does not match the target schema.
- Changing the DCR can reroute future requests without a client deployment; this is useful but makes DCR change control critical.
- The API does not make archive-only ingestion cheaper than routing eligible platform logs directly to Storage.

### AZ-305 exam discriminator

“Custom application sends JSON directly and needs schema transformation” selects Logs Ingestion API+DCR. “Azure resource emits a supported resource-log category” normally selects diagnostic settings.

### Common trap

Recommending the legacy shared-key HTTP Data Collector API for a new design instead of OAuth-based Logs Ingestion API.

---

## Log Analytics workspace and topology

**Classification:** Core destination / Architecture guidance  
**Why it matters:** The workspace is the queryable destination and the boundary for region, access, retention, Sentinel enablement, and much of the cost model.  
**Primary Microsoft source:** [Log Analytics workspace overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview) and [workspace architecture](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design)  
**Limits and quotas source:** [Log Analytics workspace limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#log-analytics-workspaces)

### Deep technical facts / requirements

1. A workspace can receive many resource and application types; data volume alone does not require workspace-per-subscription or workspace-per-resource separation.
2. Microsoft recommends starting with **one workspace** and adding only the fewest needed for hard requirements such as tenant, region/residency, ownership, billing, retention conflicts, or resilience.
3. Pay-as-you-go and commitment tiers have no daily ingestion cap, support up to **730 days** interactive retention, and up to **12 years** total retention with long-term retention.
4. Data beyond **31 days** normally incurs added retention charges in a standard Azure Monitor workspace. A Sentinel-enabled workspace changes included retention and pricing treatment.
5. Cross-resource KQL is limited to **100** Log Analytics/Application Insights resources in one query. A topology that requires querying more than 100 workspaces cannot rely on one direct cross-workspace query.
6. A user can run **5 concurrent Analytics queries** and **2 concurrent Basic/Auxiliary queries**; queued queries expire after **3 minutes**, and the queue holds **200** requests.
7. Default access mode is **Use resource or workspace permissions**, allowing resource-context access. Changing to **Require workspace permissions** blocks inherited resource-context access.
8. Resource-specific tables support table-level RBAC, which can avoid extra workspaces purely for data visibility. Workspace access otherwise exposes all permitted tables.
9. A workspace is regional. Most resources can send only to a workspace in the same Entra tenant; AMA has supported multitenant patterns, while many platform sources do not.
10. If different resources write to the same table but require different retention settings, separate workspaces may be necessary because retention is configured at table/workspace boundaries, not per originating resource row.
11. Commitment tiers begin to matter at **100 GB/day**. A dedicated cluster can aggregate volume from multiple linked workspaces toward the cluster commitment tier.
12. A second workspace does not automatically fail over alerts, workbooks, queries, and integrations. Those artifacts require explicit alternate configuration and operating procedures.

### Incompatibilities and mutual exclusions

If logs from different resources land in the same table but require different retention periods and cannot be separated into different tables, a single workspace cannot satisfy both per-resource retention requirements because retention applies to the table, not individual source rows.

### Edge cases and gotchas

- Cross-region workspace collection is supported in many cases, but data residency and some tenant-bound sources can force separation.
- More workspaces can prevent a combined workload from reaching a commitment tier and can increase cross-workspace query complexity.
- Sentinel enablement applies to the workspace; mixing operational data can subject that data to Sentinel pricing.
- Long-term retention is queryable through search jobs/restore workflows, but it is not the same as locked WORM storage.

### AZ-305 exam discriminator

Absent a hard separation requirement, choose the minimum workspace count. Residency, tenant isolation, irreconcilable table retention, or explicit SOC ownership can justify more.

### Common trap

Creating one workspace per subscription merely because subscriptions are separate management units. Workspace topology follows data and operating requirements, not subscription symmetry.

---

## Log Analytics data export

**Classification:** Core second-stage routing  
**Why it matters:** Data export forwards selected tables only after they have arrived in Log Analytics, so it has different cost, filtering, and support behavior from direct source routing.  
**Primary Microsoft source:** [Log Analytics data export rules](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export)  
**Limits and quotas source:** [Data export considerations and limits](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export#considerations)

### Deep technical facts / requirements

1. Data export continuously sends new records from selected supported tables to Blob Storage or Event Hubs as they arrive; it does not backfill historical data from before rule creation.
2. A workspace supports at most **10 active export rules**, and each rule can include multiple tables.
3. Analytics and Basic table plans are supported; Auxiliary tables are not. Some tables remain unsupported and must be checked before committing to “export everything.”
4. Export is table-wide and has no per-record filter. A supported ingestion-time transformation can filter data before it lands in the workspace and reaches export.
5. The destination must be in the **same region as the workspace**. Cross-region archival uses Storage replication such as GRS/GZRS rather than a cross-region export destination.
6. Export to Storage requires StorageV1 or later; Premium Storage is unsupported. It creates one `am-<TableName>` container per table and writes newline-delimited JSON in **5-minute** paths.
7. Append blobs allow **50,000 writes per blob**; extra blobs receive a numbered suffix after that ceiling.
8. Export to Basic/Standard Event Hubs can encounter the **10 event hubs per namespace** limit. Export more than ten tables by splitting namespaces or explicitly routing several tables to one named hub.
9. Destination failures are retried for up to **12 hours**. Retries can duplicate a fraction of records; after the retry period, unavailable-destination data is discarded.
10. Export is billed by bytes in destination JSON using **1 GB = 10^9 bytes**. The data has already incurred workspace ingestion and possibly retention charges.
11. Legacy custom logs created with the HTTP Data Collector API cannot be exported; DCR-created custom logs can be exported when their table is supported.
12. For immutable Storage, protected append-blob writes must be enabled in addition to the immutability policy.

### Incompatibilities and mutual exclusions

If the requirement is “avoid Log Analytics ingestion cost for archive-only data,” workspace data export cannot satisfy it because data must first be ingested into the workspace and export adds a paid second stage.

### Edge cases and gotchas

- The storage account must be unique across rules in a workspace.
- The exported JSON size can exceed the table's reported size because the formats differ.
- Successful source ingestion does not ensure destination capacity; monitor export failures and destination throttling.
- Export rule filtering is by table, not row or category after ingestion.

### AZ-305 exam discriminator

“All data must first be queryable by operations; selected tables then go downstream” points to workspace data export. “Archive only, never queried, lowest cost” points to direct Storage routing.

### Common trap

Treating data export as the initial collector. It cannot collect guest, platform, or custom data by itself.

---

## Azure Event Hubs

**Classification:** Core destination  
**Why it matters:** Event Hubs is the decoupled stream for external SIEM and processing consumers; it is not itself a queryable historical log store.  
**Primary Microsoft source:** [Azure Event Hubs overview](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about)  
**Limits and quotas source:** [Event Hubs quotas and limits](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-quotas)

### Deep technical facts / requirements

1. Maximum publication size is **256 KB Basic**, **1 MB Standard/Premium**, and **20 MB Dedicated**; the limit applies to both single events and batches.
2. Consumer groups per event hub are **1 Basic**, **20 Standard**, **100 Premium**, and **1,000 Dedicated**. Multiple independent consumers need separate consumer groups and checkpointing.
3. Maximum retention is **1 day Basic**, **7 days Standard**, and **90 days Premium/Dedicated**. Retention is a replay window, not a permanent compliance archive.
4. Basic and Standard allow **32 partitions per event hub**; Premium allows **100** with a namespace limit of **200 partitions per PU**; Dedicated allows **1,024 per event hub** and **2,000 per CU**.
5. Each Basic/Standard throughput unit provides up to **1 MB/s or 1,000 events/s ingress** and **2 MB/s or 4,096 events/s egress**.
6. Basic and Standard support at most **10 event hubs per namespace**. Premium supports **100 per PU**; Dedicated supports **1,000**.
7. Basic lacks Private Link, IP firewall, geo-disaster recovery, Capture, and auto-inflate. Standard adds Private Link/firewall/DR and paid Capture; customer-managed keys require Premium or Dedicated.
8. Diagnostic settings for a regional resource require a same-region Event Hubs destination and the trusted-services firewall bypass when network rules are enabled.
9. Diagnostic settings require a namespace authorization rule with `Manage`, `Send`, and `Listen`, plus `ListKey` to configure the route. A compacted event hub is incompatible because diagnostic settings omit a partition key.
10. Availability zones are supported across Basic, Standard, Premium, and Dedicated, but geo-replication requires Premium or Dedicated; Standard offers metadata geo-disaster recovery, not full data replication.
11. The producer's successful send says nothing about consumer lag, checkpoints, downstream persistence, or parsing. End-to-end monitoring must include both the hub and consumer.

### Incompatibilities and mutual exclusions

If a diagnostic-setting source and a compacted event hub are both required, that target cannot be used because compacted hubs require partition keys and Azure Monitor diagnostic settings do not emit one.

### Edge cases and gotchas

- Basic's single consumer group rules out multiple independent downstream consumers.
- Event Hubs retention expiration deletes unpersisted events even when the producer route was healthy.
- Partition count affects parallelism and is difficult to treat as a casual tuning knob in every tier.
- Use a dedicated monitoring hub/namespace when other workloads could consume capacity and throttle log export.

### AZ-305 exam discriminator

“Third-party SIEM,” “Kafka consumer,” or “near-real-time external processor” points to Event Hubs. “KQL investigation” points to Log Analytics; “seven-year WORM” points to immutable Storage.

### Common trap

Calling Event Hubs an archive. It is a finite-retention stream whose consumer must checkpoint and persist any durable copy.

---

## Azure Blob Storage and immutable storage

**Classification:** Core destination  
**Why it matters:** Storage is the low-cost archive route; immutability supplies WORM controls that Log Analytics retention alone does not.  
**Primary Microsoft source:** [Immutable storage for blob data](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview)  
**Limits and quotas source:** [Retention interval and WORM limits](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview#retention-interval-for-a-time-based-policy)

### Deep technical facts / requirements

1. A time-based immutability policy can retain data from **1 day to 146,000 days (400 years)**.
2. A legal hold has no predetermined expiry; it remains until explicitly cleared. Time-based retention and legal hold can coexist at the same scope.
3. Container-level WORM applies one policy to all blobs in the container. Version-level WORM can be configured at account, container, or individual version scope.
4. Both locked and unlocked policies block overwrite/delete, but an unlocked policy can be shortened or deleted. A locked policy cannot be deleted or shortened and is the state required for regulatory compliance such as SEC 17a-4(f).
5. A locked container-level policy can have its effective retention increased at most **5 times**. Version-level policies have no such increase-count limit.
6. Microsoft recommends locking a tested policy within **24 hours**; unlocked is intended for testing, not the final compliance state.
7. Container policy audit logs retain up to **7 time-based retention commands** for the policy lifetime. Version-level policy changes are not audited by that mechanism.
8. Accounts with hierarchical namespace support container-level WORM but not version-level WORM. A requirement for ADLS Gen2 hierarchical namespace plus per-version WORM is therefore invalid.
9. Container-level WORM is intended for no more than **10,000 containers per account**; version-level WORM is the design for broader account-scale policy application.
10. All blob access tiers and redundancy configurations support immutable storage. Tiering can reduce archive cost without removing WORM protection.
11. Diagnostic settings accept Standard Storage, not Premium, and regional sources require the account in the same region. Firewalled accounts require trusted-services bypass.
12. Workspace data export to immutable Storage requires protected append-blob writes so continuous export can append while WORM protection remains in force.

### Incompatibilities and mutual exclusions

If hierarchical namespace and version-level WORM are both mandatory, the storage design cannot satisfy both because version-level WORM is not supported on hierarchical-namespace accounts; use container-level WORM or change the account/design.

### Edge cases and gotchas

- Even a subscription owner cannot delete blobs protected by an effective locked policy or legal hold.
- Page blobs used as active VHDs are poor immutability candidates because writes are blocked or create excessive versions.
- Locking is effectively irreversible; test policy scope and append behavior before locking.
- Storage retention is not interactive KQL; retrieving and analyzing archived JSON requires another process.

### AZ-305 exam discriminator

“Tamper-resistant,” “legal hold,” or “WORM” makes immutable Blob Storage necessary. A 12-year Log Analytics retention option does not provide the same locked-write/delete semantics.

### Common trap

Equating long retention with immutability. Retained Log Analytics data can be purged; a locked WORM policy prevents modification and deletion.

---

## Microsoft Entra log routing

**Classification:** Supporting special source  
**Why it matters:** Audit, sign-in, provisioning, and risk logs are tenant-level identity data and are not routed by per-resource Azure diagnostic settings.  
**Primary Microsoft source:** [Integrate Microsoft Entra logs with Azure Monitor](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-integrate-activity-logs-with-azure-monitor-logs)

### Deep technical facts / requirements

1. Microsoft Entra diagnostic settings operate at tenant scope and can send selected identity log categories to Azure Monitor destinations.
2. Configuration requires at least the **Security Administrator** role in the Entra tenant plus appropriate access to the Log Analytics workspace.
3. A Log Analytics workspace must already exist before routing Entra logs to it.
4. Integrating Entra logs with Azure Monitor automatically enables the Microsoft Entra data connector in Microsoft Sentinel for that workspace.
5. Audit logs, sign-in logs, provisioning logs, and Identity Protection risk logs are distinct categories with licensing and availability differences; selecting one does not imply collecting all.
6. Entra logs correlate identity activity with Defender, Application Insights, and other workspace data only after they are routed into a common queryable destination.

### Incompatibilities and mutual exclusions

If tenant sign-in logs are the source and the proposed configuration is a subscription Activity Log diagnostic setting, the route cannot work because Entra activity is tenant-scoped, not Azure subscription control-plane activity.

### Edge cases and gotchas

- Workspace access and tenant configuration permission are separate requirements.
- Sentinel connector enablement can have security ownership and pricing implications.
- Category availability can depend on the tenant's Entra licensing; verify before specifying risk-log coverage.

### AZ-305 exam discriminator

“User sign-in,” “directory audit,” or “risky user” identifies Entra tenant diagnostic settings, not Azure Activity Log or AMA.

### Common trap

Treating Entra ID as an ordinary Azure resource whose logs are configured from a resource group's diagnostic-settings blade.

---

## Virtual network flow logs

**Classification:** Supporting special source  
**Why it matters:** Network flow records use a Network Watcher, storage-first path and have workload support gaps that generic diagnostic-settings answers miss.  
**Primary Microsoft source:** [Virtual network flow logs](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview)  
**Limits and quotas source:** [Virtual network flow-log considerations](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview#considerations-for-virtual-network-flow-logs)

### Deep technical facts / requirements

1. VNet flow logs are collected by the Azure platform at **1-minute intervals** and written as JSON to Azure Storage.
2. The storage account must be Standard, in the **same region** as the VNet, and in the same subscription or another subscription in the same Entra tenant. Premium Storage is unsupported.
3. Records capture Layer 4, five-tuple, direction, state, encryption state, and throughput data. They operate at VNet scope and include supported gateway traffic by default.
4. Enabling NSG and VNet flow logs for the same workloads can duplicate records and charges; Microsoft recommends disabling NSG flow logs before enabling VNet flow logs.
5. ExpressRoute FastPath traffic bypasses the gateway and is not recorded at the ExpressRoute gateway subnet. Capture at the VM subnet/NIC when supported.
6. Private-endpoint traffic cannot be recorded at the endpoint itself; capture at the source VM and use `PrivateEndpointResourceId` to identify the destination.
7. Flow-log lifecycle rules inherit Storage limits of **100 rules per account** and **10 blob prefixes per rule**.
8. A self-managed storage CMK rotation stops flow logging until the flow log is disabled and re-enabled.
9. VNet flow logs include a free tier of **5 GB/month per subscription**; Traffic Analytics processing and Storage are charged separately.
10. Unsupported workloads include Azure Container Instances, Container Apps, Logic Apps, Functions, App Service, several managed databases, and Azure NetApp Files. [Limited regions — verify before specifying] Availability also differs for flow logs, Traffic Analytics, and workspaces.
11. [NSG flow logs](https://learn.microsoft.com/en-us/azure/network-watcher/nsg-flow-logs-migrate) stopped accepting new configurations after **June 30, 2025** and retire on **September 30, 2027**. Existing NSG flow-log resources are deleted at retirement, while records already stored in Storage continue under their retention policies.

### Incompatibilities and mutual exclusions

If the workload is Azure App Service and the requirement is VNet flow-log capture of the app's VNet-integrated traffic, VNet flow logs cannot be used because App Service is an unsupported workload for this feature.

### Edge cases and gotchas

- Do not modify an actively written hourly block blob's block structure; later writes for that hour can fail.
- Gateway capture can increase volume because VNet scope includes gateway traffic.
- The first destination is Storage; Traffic Analytics or an SIEM is a downstream consumer.
- VNet flow logs and generic resource diagnostic settings are not interchangeable routes.

### AZ-305 exam discriminator

“All IP flows through a VNet” selects VNet flow logs and same-region Standard Storage. “Firewall diagnostic category” may instead use that firewall resource's diagnostic settings.

### Common trap

Recommending diagnostic settings straight to Log Analytics as the native path for VNet flow logs. Their documented primary path is Network Watcher to Storage.

---

## Azure Monitor pipeline

**Classification:** Supporting edge/hybrid  
**Why it matters:** The pipeline handles centralized ingestion, preprocessing, and disconnection buffering for appliances and other sources that cannot run an agent.  
**Primary Microsoft source:** [Azure Monitor pipeline overview](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview)  
**Limits and quotas source:** [Pipeline supported configurations](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview#supported-configurations)

### Deep technical facts / requirements

1. The pipeline is a containerized solution that runs on a customer-operated **Azure Arc-enabled Kubernetes** cluster in an edge, on-premises, or multicloud location.
2. Syslog supports RFC 3164 and RFC 5424 over TCP/UDP and is generally available; CEF is accepted through the Syslog receiver.
3. Syslog/CEF uses port **514** by default. OpenTelemetry log ingestion uses TCP **4317** by default and is **[Preview]** as of July 2026.
4. TLS and optional mutual TLS can secure client-to-pipeline ingestion. An optional gateway exposes receivers to clients outside the cluster.
5. Optional persistent storage survives process restarts and connectivity interruptions and automatically backfills when connectivity returns.
6. The pipeline can filter, aggregate, reshape, and auto-schematize supported Syslog/CEF into `Syslog` and `CommonSecurityLog` before sending to Log Analytics.
7. The customer operates and maintains the Kubernetes cluster; Azure manages the pipeline integration but not the underlying cluster lifecycle.
8. Horizontal replicas can serve thousands of sources, but exact sizing depends on telemetry rate, transformations, persistent storage, and supported Kubernetes versions.
9. [Limited regions — verify before specifying] Supported regions and Kubernetes distributions are explicitly bounded and can change; the July 2026 documentation lists specific TKGm, K3s, and AKS Arc versions.

### Incompatibilities and mutual exclusions

If the design requires GA OTLP log ingestion, Azure Monitor pipeline cannot currently be specified without qualification because OTLP logs are still preview; use a GA supported route or explicitly accept preview risk.

### Edge cases and gotchas

- AMA and pipeline are complementary: per-machine collection versus central network receiver.
- Persistent storage must be enabled to survive outages; buffering is not an unconditional default.
- Arc-enabled Kubernetes and supported `cert-manager`/distribution versions are prerequisites.
- Preview OTLP should not be presented as an unqualified exam-default answer.

### AZ-305 exam discriminator

“Appliance cannot run an agent,” “local aggregation,” or “disconnected buffering” points to Azure Monitor pipeline. Ordinary Azure/Arc VM guest logs point to AMA.

### Common trap

Assuming pipeline is a Microsoft-operated cloud service with no local infrastructure responsibility.

---

## Microsoft Sentinel

**Classification:** Supporting security destination  
**Why it matters:** Sentinel adds SIEM/SOAR, hunting, incidents, analytics, and automation to security data stored in a Log Analytics workspace.  
**Primary Microsoft source:** [Microsoft Sentinel overview](https://learn.microsoft.com/en-us/azure/sentinel/overview)  
**Limits and quotas source:** [Microsoft Sentinel service limits](https://learn.microsoft.com/en-us/azure/sentinel/sentinel-service-limits)

### Deep technical facts / requirements

1. A “Sentinel workspace” is a Log Analytics workspace enabled for Microsoft Sentinel; it is not a separate storage engine.
2. All data in a Sentinel-enabled workspace is subject to Sentinel pricing treatment, so combining generic operations data can change cost.
3. Sentinel adds security data connectors, analytics rules, hunting, incidents, threat intelligence, and Logic Apps-based playbooks; a plain workspace does not supply this SIEM/SOAR layer.
4. Routing data to Event Hubs for a third-party SIEM is not equivalent to Sentinel; Event Hubs transports events but does not provide Sentinel analytics and incident entities.
5. An immutable compliance copy remains a separate Storage requirement; Sentinel investigation retention is not locked WORM.
6. New customers onboarding their first Sentinel workspace since **July 2025** can be automatically onboarded to the Defender portal when the user has Owner or User Access Administrator and is not an Azure Lighthouse-delegated user.
7. Microsoft Sentinel in the Azure portal is supported only through **March 31, 2027**; after that it is available only in the Microsoft Defender portal.
8. Entra-to-Azure Monitor integration automatically enables the Entra data connector in Sentinel for the destination workspace.

### Incompatibilities and mutual exclusions

If the only requirement is immutable seven-year preservation and there is no SIEM use case, Sentinel alone cannot satisfy it because workspace data can be purged and Sentinel does not impose a locked WORM policy.

### Edge cases and gotchas

- Workspace topology and Sentinel topology are coupled; separation can protect SOC ownership but reduce easy correlation.
- Portal retirement changes the management surface, not the underlying requirement to route data to a workspace.
- Data connector availability and prerequisites differ by source.

### AZ-305 exam discriminator

“Threat correlation, hunting, incidents, and automated response” selects a Sentinel-enabled workspace. “External SIEM already exists” more often selects Event Hubs streaming.

### Common trap

Choosing Sentinel for any security-related retention request even when the actual requirement is only low-cost immutable archive.

---

## Azure Policy for routing governance

**Classification:** Supporting governance  
**Why it matters:** Azure Policy makes source routing repeatable across large resource estates and can remediate resources that predate the assignment.  
**Primary Microsoft source:** [Create diagnostic settings at scale with Azure Policy](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy)

### Deep technical facts / requirements

1. Built-in policies exist for many diagnostic-setting destinations and resource types; unsupported resource types require a custom definition.
2. Policy definitions are resource-type aware because diagnostic categories differ by provider; one hard-coded category list is not universally valid.
3. `allLogs` and `audit` category groups let a policy track new categories added to those groups without editing the assignment.
4. A policy assignment affects newly evaluated resources; a **remediation task** deploys the setting to existing noncompliant resources.
5. A managed identity used by a deploy policy needs the role assignments required to create the diagnostic setting and access its destination.
6. Initiatives group multiple destination/resource-type definitions into one governed baseline.
7. Policy compliance reports that the desired resource configuration exists; it does not prove the source emitted data, the destination accepted it, or a consumer processed it.

### Incompatibilities and mutual exclusions

If the policy hard-codes a log category that the targeted resource type does not expose, the deployment cannot create a valid setting; use the correct type-specific definition or supported category group.

### Edge cases and gotchas

- Existing resources remain unchanged until remediation runs successfully.
- Exemptions should be governed because they create intentional telemetry gaps.
- Policy does not bypass the five-settings-per-resource ceiling or destination firewall/region rules.
- Remediation identity permissions are separate from the human author's permissions.

### AZ-305 exam discriminator

“Ensure all current and future resources route audit logs” requires both a policy assignment and remediation for existing resources.

### Common trap

Treating a compliant policy result as evidence of end-to-end log delivery.

---

## Highest-yield exam discriminators

| Scenario clue | Best answer | Why |
|---|---|---|
| Resource logs to six separate workspaces | Centralize or add a supported second stage | A resource supports only **5 diagnostic settings**. |
| One source to Log Analytics, Storage, and Event Hubs | One diagnostic setting | It can contain one destination of each type. |
| Same resource to two workspaces | Two diagnostic settings | One setting permits only one destination of each type. |
| Regional resource to firewalled Storage | Same-region Standard Storage plus trusted-services bypass | Same-region and firewall rules are mandatory; private endpoint alone is insufficient. |
| Subscription control-plane events for 7 years | Activity Log export | Built-in retention is **90 days**; use Storage or Log Analytics for longer retention. |
| Guest Windows events or Linux Syslog | AMA + DCR + DCRA | Diagnostic settings cannot read inside the guest. |
| Custom JSON with schema reshaping | Logs Ingestion API + DCR | The DCR transforms input to the target table schema. |
| Appliance cannot run an agent and connectivity is intermittent | Azure Monitor pipeline with persistent storage | It centrally receives supported protocols and backfills after interruption. |
| GA OpenTelemetry logs through Azure Monitor pipeline | Do not select without qualification | OTLP log receiver is **[Preview]** in July 2026. |
| KQL, workbooks, correlation, log alerts | Log Analytics workspace | Event Hubs and Storage are not native KQL stores. |
| Seven-year, rarely read, tamper-resistant archive | Immutable Blob Storage | Time-based WORM supports **1–146,000 days** and locked deletion protection. |
| Third-party SIEM stream | Event Hubs | It provides decoupled streaming; Standard retention is at most **7 days**, so the consumer must persist data. |
| Threat hunting, incidents, playbooks | Sentinel-enabled workspace | Sentinel adds SIEM/SOAR over Log Analytics data. |
| Operations must query first, then selected tables go downstream | Log Analytics data export | It is a second stage with **10 active rules/workspace** and supported-table limits. |
| Archive-only data with minimum ingestion cost | Direct diagnostic setting to Storage | Workspace export first incurs Log Analytics ingestion and then export charges. |
| Row-level filtering in an export rule | Ingestion-time transformation first | Data export selects whole tables and has no row filter. |
| Resource-specific table RBAC | Resource-specific collection mode | Dedicated tables support per-table RBAC; `AzureDiagnostics` is shared. |
| Entra sign-ins and risky users | Entra tenant diagnostic settings | These are tenant identity logs, not subscription Activity Log events. |
| VNet IP-flow capture | VNet flow logs to same-region Standard Storage | It is a Network Watcher storage-first path collected every **1 minute**. |
| Existing and future resources must be configured | Azure Policy plus remediation | Assignment covers evaluation; remediation deploys settings to existing resources. |

## Current-documentation notes

- The supplied study guide's source-first decision model remains current: identify the source mechanism before choosing an outcome destination.
- Azure Monitor pipeline documentation now lists Syslog/CEF as generally available, while OTLP logs remain **[Preview]**; treat older blanket-preview descriptions as outdated.
- Current Log Analytics documentation states up to **730 days** of interactive retention and **12 years** total retention. This does not replace immutable Storage when WORM is required.
- Current Microsoft Sentinel documentation sets **March 31, 2027** as the end of Azure-portal support and directs the service experience to the Microsoft Defender portal.
- The legacy Log Analytics/MMA agent retired on **August 31, 2024**; its cloud ingestion can be shut down any time after **March 2, 2026**. New routing designs use AMA+DCR.
- New NSG flow logs have been blocked since **June 30, 2025**, and the feature retires on **September 30, 2027**. Use VNet flow logs for new network-flow designs.
