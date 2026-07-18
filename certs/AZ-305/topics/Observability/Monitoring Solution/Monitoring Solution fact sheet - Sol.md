# Deep Technical Facts and Requirements for Recommend a Monitoring Solution

## Scope

- Exam: AZ-305: Designing Microsoft Azure Infrastructure Solutions
- Task: Recommend a monitoring solution
- Source guide: `Monitoring Solution study guide - GPT5.md`, `Monitoring Solution task map.md`, and the task hierarchy in `Skills.psd1`
- Research date: July 2026
- Product selection method: Products and major topics were extracted from the provided guide, then validated against current official Microsoft documentation.

## Product coverage summary

| Product / topic | Classification | Why it matters for this task |
|---|---|---|
| Azure Monitor data platform, Metrics, Logs, and workspaces | Core | Signal type, store type, retention, query, cost, and network-boundary requirements determine the foundation of a monitoring design. |
| Azure Monitor alerts, action groups, and alert processing rules | Core | A correct design must match the signal to the alert engine and separately design notification, automation, suppression, and scale. |
| Application Insights and availability tests | Core | Application performance monitoring requires application telemetry, distributed traces, dependency correlation, and externally generated availability signals. |
| VM insights, Azure Monitor Agent, and DCRs | Core | Azure and hybrid VM monitoring spans host, guest, process, and dependency layers with different onboarding and retirement constraints. |
| Container insights and managed Prometheus | Core | Kubernetes designs commonly require both Log Analytics-backed container logs and Azure Monitor workspace-backed Prometheus metrics. |
| Workbooks, Azure dashboards, and Azure Managed Grafana | Core | Visualization choice changes data-source support, private networking, identity, alerting, interactivity, limits, and audience fit. |
| Service Health and Resource Health | Supporting | Provider incidents, planned maintenance, and resource availability require platform-health signals that workload telemetry cannot replace. |
| Network Watcher and Connection Monitor | Supporting | IaaS reachability, latency, path, next-hop, and packet diagnostics need network-specific tooling rather than application APM. |
| Entra monitoring, Defender for Cloud, and Microsoft Sentinel | Adjacent | Identity health, security posture, and SIEM/SOAR are specialist outcomes that complement operational monitoring but are not interchangeable with it. |
| Private access and enterprise monitoring governance | Framework / architecture guidance | AMPLS, Azure Policy, landing-zone baselines, ownership, and least privilege determine whether the recommendation works at enterprise scale. |

---

## Azure Monitor data platform, Metrics, Logs, and workspaces

**Classification:** Core  
**Why it matters:** Azure Monitor is the umbrella platform, but its metric and log stores have different schemas, query languages, retention, latency, and cost behavior. An architect must choose the signal and store rather than naming Azure Monitor generically.  
**Primary Microsoft source:** [Azure Monitor overview](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview)  
**Limits and quotas source:** [Azure Monitor service limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits)

### Deep technical facts / requirements

1. **Signal behavior:** Platform metrics are numerical time-series data that Azure resources usually emit at **1-minute** frequency; metric dimensions preserve context such as instance or response code, and custom metrics support no more than **10 dimensions**. [Metrics in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/data-platform-metrics).
2. **Retention and query window:** Platform and custom metrics are retained for **93 days**, but one Metrics Explorer chart can query at most a **30-day** interval; users can pan a 30-day window across the retention period. Prometheus metrics instead retain **18 months**, with a maximum **32-day** PromQL query span. [Azure Monitor metric retention](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/data-platform-metrics#retention-of-metrics).
3. **Workspace distinction:** A Log Analytics workspace stores logs and traces queried with KQL, while an Azure Monitor workspace stores Prometheus and OpenTelemetry metrics queried with PromQL. The similarly named resources are separate stores and one cannot substitute for the other. [Azure Monitor data platform](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview#azure-monitor-data-platform).
4. **Log retention and tiers:** Pay-as-you-go and commitment-tier Log Analytics workspaces support up to **730 days** of interactive retention and up to **12 years** of archive; retention beyond **31 days** incurs additional retention charges. [Log Analytics workspace limits and retention](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#data-collection-volume-and-retention).
5. **Query limits:** One cross-resource log query can reference at most **100** Log Analytics workspaces and Application Insights resources; the portal returns at most **500,000 records** or about **100 MiB** of raw data, and the query API has a **10-minute** maximum execution time. [Azure Monitor log query limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#log-queries-and-language).
6. **Concurrency:** A user can run **5** concurrent Analytics-table queries but only **2** concurrent Basic/Auxiliary search queries. A queued query is terminated with HTTP 429 after **3 minutes**, and no more than **200** queries can wait in the queue. [Azure Monitor Logs user query throttling](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#user-query-throttling).
7. **Cost gating:** Log Analytics table plans change capability as well as price: Analytics supports full query and alert behavior, Basic is optimized for high-volume troubleshooting data, and Auxiliary is intended for verbose audit/security data; table-plan restrictions therefore must be checked before promising scheduled analytics or alerting. [Azure Monitor log table plans](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#table-plans).
8. **Metric export limitation:** Diagnostic-settings export does not preserve dimensions for multidimensional platform metrics; it aggregates dimension values, and only metrics marked **Exportable** in the metric reference can be routed that way. [Diagnostic settings metric limitations](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#metrics-limitations).
9. **Access model:** Workspace-context access evaluates permissions at the workspace, while resource-context access allows a user with access to an Azure resource to query logs associated with that resource without broad workspace access. Table-level RBAC can further restrict specific tables. [Manage access to Log Analytics workspaces](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access).
10. **Networking:** Azure Monitor Private Link uses an Azure Monitor Private Link Scope (AMPLS) between a VNet private endpoint and a defined set of monitoring resources; it can keep ingestion and query traffic on the Microsoft backbone and can disable public network access. [Azure Monitor Private Link architecture](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-security).
11. **Private-link limits:** One VNet can connect to only **1 AMPLS**; one AMPLS can connect to **3,000 Log Analytics workspaces**, **10,000 Application Insights components**, and **10 private endpoints**; one Azure Monitor resource can join up to **100 AMPLS** objects. [Azure Monitor Private Link limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#azure-monitor-private-link-scope-ampls).
12. **Ingestion resiliency:** A Log Analytics workspace has a default soft ingestion threshold of about **500 MB compressed**, approximately **6 GB/minute uncompressed**, for affected ingestion paths. Azure Monitor retries four times over **12 hours** after the threshold is reached and then can drop data; AMA and DCR ingestion are excluded from this particular workspace threshold. [Log Analytics ingestion volume rate](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#general-workspace-limits).

### Incompatibilities and mutual exclusions

If a solution requires both PromQL-native Prometheus storage and only a Log Analytics workspace, the design is invalid because managed Prometheus requires an Azure Monitor workspace; add that workspace rather than attempting to store Prometheus metrics as ordinary KQL logs. [Azure Monitor managed Prometheus storage](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/prometheus-metrics-overview#data-storage).

### Edge cases and gotchas

- Moving or renaming an Azure resource can cause loss of that resource's historical metric continuity, so a resource move should not be assumed to preserve a seamless metric series. [Azure Monitor metric retention note](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/data-platform-metrics#retention-of-metrics).
- A private-link-only Logs design cannot use KQL `externaldata` or the Azure Data Explorer proxy because those paths do not guarantee that the external target is accessed privately. [Azure Monitor Private Link query limitations](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-configure#querying-limitation-externaldata-operator).
- Azure Monitor automatically collects platform metrics and the subscription Activity Log, but resource logs are not collected until a diagnostic setting or another supported collection path is configured. [Azure Monitor diagnostic settings sources](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#sources).
- Basic/Auxiliary search queries and Analytics queries have different concurrency limits; changing a table plan for cost can therefore alter troubleshooting concurrency and supported query behavior. [Azure Monitor Logs query limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#user-query-throttling).

### AZ-305 exam discriminator

When the requirement says “PromQL,” “Prometheus rule,” or “18-month metric retention,” select an Azure Monitor workspace and managed Prometheus; when it says “KQL correlation across logs and traces” or “up to 12-year archive,” select a Log Analytics workspace and the appropriate table/retention plan. [Azure Monitor data platform](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview#azure-monitor-data-platform) [Azure Monitor service limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits).

### Common trap

Do not treat Log Analytics as the Azure Monitor product itself: it is the KQL log-analysis experience and workspace, while metrics, managed Prometheus, alerts, insights, and visualization use other Azure Monitor platform components. [Azure Monitor overview](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview).

---

## Azure Monitor alerts, action groups, and alert processing rules

**Classification:** Core  
**Why it matters:** Detection, notification, automation, and maintenance suppression are separate design concerns. Alert type follows the signal and condition shape; action groups execute responses; processing rules modify actions on fired alerts.  
**Primary Microsoft source:** [Azure Monitor alerts overview](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview)  
**Limits and quotas source:** [Azure Monitor alert limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#alerts)

### Deep technical facts / requirements

1. **Engine selection:** Metric alerts evaluate precomputed time series and are billed by monitored time series; log search alerts run KQL and are billed by evaluation frequency, while Prometheus alerts run PromQL against managed Prometheus data. [Choose the right alert type](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types#types-of-azure-monitor-alerts).
2. **State behavior:** Metric alerts are stateful by default. Activity Log, Service Health, and Resource Health alerts are event-driven and stateless, remain in `Fired` monitor condition, and do not automatically resolve because they represent a point-in-time event. [Azure Monitor alert state behavior](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types#activity-log-alerts).
3. **Multi-condition semantics:** Multiple conditions in one metric alert rule use logical **AND**; the alert resolves after at least one condition is false for **3 consecutive checks**. [Metric alert multiple-condition behavior](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types#applying-multiple-conditions-to-a-metric-alert-rule).
4. **Multi-resource constraint:** A single multi-resource metric rule can monitor resources of the same type in the same Azure region, but multi-resource metric alerts do not support VM guest metrics or the listed VM network metrics. [Multi-resource metric alert support](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types#monitor-multiple-resources-with-one-alert-rule).
5. **Scale limits:** A subscription supports **5,000** active metric alert rules with up to **10,000 metric time series per rule**, **5,000** log alert rules, and only **100** Activity Log alert rules; the Activity Log ceiling includes Service Health and Resource Health alerts and cannot be increased. [Azure Monitor alert service limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#alerts).
6. **High-frequency gating:** Of the **5,000** log alert rules per subscription, only **100** can run at **1-minute** frequency. Each stateless rule can produce **6,000 alerts per evaluation**, while a stateful rule can produce **300 per evaluation** and retain up to **5,000 fired alerts**. [Azure Monitor log alert limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#alerts).
7. **Query restrictions:** Log search alert rule properties have a combined **64-KB** ceiling; query results cannot exceed **20 MB**, and alert queries do not support `bag_unpack()`, `pivot()`, or `narrow()`. [Log search alert query restrictions](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-log-alert-rule#configure-alert-rule-conditions).
8. **Dimension behavior:** A log search alert can split on up to **6** string or numeric dimensions; every dimension combination becomes a separately evaluated and billed time series and can fire its own alert. [Log alert dimension splitting](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-log-alert-rule#configure-alert-rule-conditions).
9. **RBAC prerequisites:** Creating or editing an alert rule requires read access to the target, write access to the resource group holding the rule, and read access to attached action groups. [Alert rule permissions](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-log-alert-rule#prerequisites).
10. **Action-group capacity:** A rule can attach up to **5 action groups**. A subscription can contain unlimited action groups subject to ARM limits, but individual action types have limits—for example **10** webhooks, **10** Logic Apps, and **1,000** email actions per action group. [Azure Monitor action groups](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups) [Action group service limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#action-groups).
11. **Notification throttling:** Email is limited to **100 messages per hour per address per region**, SMS and voice production notifications to **1 every 5 minutes**, and webhook calls to **1,500 per minute per subscription**. Automation actions are not subject to the SMS/email/voice/push notification rate limiting model. [Action group notification limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#action-groups).
12. **Processing-rule semantics:** Alert processing rules can add or suppress action groups on fired alerts without preventing the alert instance from being created. Suppression wins if both add and suppress rules match, and one subscription supports **1,000** active processing rules by default. [Alert processing rule behavior](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-processing-rules) [Alert processing rule limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#alerts).
13. **Scope boundary:** An alert processing rule can target resources, resource groups, or a subscription only within the rule's own subscription; filters in one rule are combined with logical AND, while up to **5 values** inside one filter are combined with logical OR. [Alert processing rule scope and filters](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-processing-rules#scope-and-filters-for-alert-processing-rules).
14. **Preview status:** `[Preview]` Query-based metric alerts can evaluate Prometheus and OpenTelemetry metrics with PromQL as individual resources; the GA exam default for Prometheus alerting remains Prometheus rule groups unless preview is explicitly allowed. [Query-based metric alert preview](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types#types-of-azure-monitor-alerts).

### Incompatibilities and mutual exclusions

If maintenance suppression and Service Health alerts are both required, alert processing rules cannot provide that suppression because they do not affect Service Health alerts; design the Service Health rule and its action group deliberately instead. [Alert processing rule limitation](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-processing-rules) [Azure landing-zone monitoring guidance](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-monitor).

### Edge cases and gotchas

- A log search alert is usually less reliable for detecting absence of heartbeat data because logs are more latent; Microsoft recommends a metric alert when an appropriate metric signal exists. [Log search alert latency guidance](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types#log-search-alerts).
- Alert processing rules were formerly called action rules, and their resource type remains `Microsoft.AlertsManagement/actionRules` for backward compatibility. [Alert processing rule naming](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-processing-rules).
- A Service Health alert needs a **Global** action group for correct processing; a regional action group is not the safe default for that alert type. [Global and regional action-group processing](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups#global-and-regional-action-group-processing).
- Dynamic thresholds need historical behavior and are unsuitable for a brand-new series where an explicit hard safety threshold must work immediately. [Metric alert dynamic thresholds](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-dynamic-thresholds).

### AZ-305 exam discriminator

Use a metric alert for a precomputed numerical time series and fast state evaluation, a log search alert for KQL correlation or calculations, an Activity Log alert for control-plane events, and a Prometheus rule for PromQL. Attach an action group for response and use a processing rule only to change actions on already-fired alerts. [Choose the right alert type](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types) [Alert processing rules](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-processing-rules).

### Common trap

Suppressing actions with an alert processing rule does not stop alert evaluation or hide the fired alert; it removes action groups while the alert remains visible in the portal, API, PowerShell, and Azure Resource Graph. [Alert processing rule suppression](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-processing-rules#what-should-this-rule-do).

---

## Application Insights and availability tests

**Classification:** Core  
**Why it matters:** Application Insights supplies APM signals that infrastructure metrics cannot infer: requests, dependencies, exceptions, trace correlation, user behavior, and synthetic availability. Workspace, instrumentation, sampling, network, and test constraints materially change the design.  
**Primary Microsoft source:** [Application Insights overview](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)  
**Limits and quotas source:** [Application Insights service limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#application-insights)

### Deep technical facts / requirements

1. **Current resource model:** Classic Application Insights resources are retired; current resources are workspace-based and send telemetry to a Log Analytics workspace, where ingestion and retention are billed. [Create a workspace-based Application Insights resource](https://learn.microsoft.com/en-us/azure/azure-monitor/app/create-workspace-resource).
2. **Instrumentation:** Application Insights can monitor applications hosted inside or outside Azure, but request, dependency, exception, and distributed-trace telemetry requires SDK/OpenTelemetry instrumentation or supported agent-based autoinstrumentation; merely creating the Azure resource does not instrument arbitrary code. [Application Insights overview](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview).
3. **OpenTelemetry direction:** Microsoft recommends the Azure Monitor OpenTelemetry Distro for new applications where supported; classic Application Insights SDK guidance remains relevant for scenarios not yet covered by OpenTelemetry. [Application Insights OpenTelemetry overview](https://learn.microsoft.com/en-us/azure/azure-monitor/app/opentelemetry-overview).
4. **Ingestion limits:** The default Application Insights daily cap ceiling is **100 GB/day** and can be raised in the portal to **1,000 GB/day**; the documented throttling threshold is **32,000 events/second**, measured over one minute. [Application Insights service limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#application-insights).
5. **Telemetry limits:** One telemetry item is limited to **64 KB**, a batch to **64,000 items**, property and metric names to **150 characters**, property values to **8,192 characters**, and trace/exception messages to **32,768 characters**. [Application Insights telemetry limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#application-insights).
6. **Retention:** Raw log retention is configurable to **30, 60, 90, 120, 180, 270, 365, 550, or 730 days**; retention beyond **90 days** can incur extra cost. Aggregated metrics retain **90 days**, and debug snapshots retain **15 days** by default. [Application Insights data retention FAQ](https://learn.microsoft.com/en-us/azure/azure-monitor/app/application-insights-faq#data-collection-retention-storage-and-privacy).
7. **Sampling behavior:** Metrics are not sampled. The Azure Monitor OpenTelemetry sampler supports fixed-rate sampling from **0 to 1** and rate-limited traces per second; using the Azure Monitor sampler preserves complete-trace decisions and Live Metrics compatibility. [Application Insights OpenTelemetry sampling](https://learn.microsoft.com/en-us/azure/azure-monitor/app/opentelemetry-sampling).
8. **Daily-cap consequence:** A daily cap stops ingestion after the threshold and creates a telemetry gap until reset, so Microsoft treats it as a last-resort cost control rather than a substitute for sampling and filtering. [Application Insights sampling and daily cap](https://learn.microsoft.com/en-us/azure/azure-monitor/app/opentelemetry-sampling#set-a-daily-cap).
9. **Availability-test scale:** One Application Insights resource supports **100 availability tests**, one resource group supports **800**, a standard test follows up to **10 redirects**, supports up to **16 locations**, and has a minimum **5-minute** frequency. [Application Insights availability-test limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#application-insights) [Application Insights availability tests](https://learn.microsoft.com/en-us/azure/azure-monitor/app/availability).
10. **Public reachability:** Standard availability tests require an HTTP or HTTPS endpoint visible from the public internet. They can test any public endpoint and do not require application instrumentation, but they are not the native answer for an endpoint reachable only through a private network. [Application Insights availability-test prerequisites](https://learn.microsoft.com/en-us/azure/azure-monitor/app/availability#create-an-availability-test).
11. **Test semantics:** Enabling retry means a location reports failure only after **3 successive attempts** fail. Parsing dependent requests checks up to **15 dependent requests**, and all must complete within the configured timeout. [Application Insights standard-test settings](https://learn.microsoft.com/en-us/azure/azure-monitor/app/availability#create-an-availability-test).
12. **Identity and network:** Workspace-based Application Insights supports unified Azure RBAC through its Log Analytics workspace and can use AMPLS for private ingestion/query boundaries; private link does not itself make a public standard availability-test endpoint private. [Workspace-based Application Insights capabilities](https://learn.microsoft.com/en-us/azure/azure-monitor/app/create-workspace-resource) [Azure Monitor Private Link](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-security).

### Incompatibilities and mutual exclusions

If the monitored endpoint must have no public reachability and only native standard availability tests are allowed, the requirements conflict because standard tests require a public HTTP/HTTPS endpoint; use a supported private synthetic-monitoring pattern or an agent-generated custom signal instead. [Application Insights availability-test prerequisites](https://learn.microsoft.com/en-us/azure/azure-monitor/app/availability#create-an-availability-test).

### Edge cases and gotchas

- URL ping tests retire on **September 30, 2026** and existing tests will be removed; use standard tests for current single-step availability monitoring. [Application Insights availability-test retirement](https://learn.microsoft.com/en-us/azure/azure-monitor/app/availability#types-of-availability-tests).
- Automatically enabled availability alerts initially provide portal behavior; to invoke configured action groups, edit the generated alert rule and set its notification/action settings. [Configure availability alerts](https://learn.microsoft.com/en-us/azure/azure-monitor/app/availability#enable-alerts).
- Telemetry exporters provide best-effort delivery; a crash, process exit before flush, unavailable local storage, or an outage longer than retry capacity can lose telemetry. [Application Insights delivery behavior](https://learn.microsoft.com/en-us/azure/azure-monitor/app/application-insights-faq#does-application-insights-guarantee-telemetry-delivery).
- Client IP is used for geolocation and then stored as zero by default, so raw retained telemetry should not be assumed to contain the original client IP address. [Application Insights privacy behavior](https://learn.microsoft.com/en-us/azure/azure-monitor/app/application-insights-faq#data-collection-retention-storage-and-privacy).

### AZ-305 exam discriminator

Requests, dependency calls, exceptions, application maps, distributed traces, Live Metrics, and synthetic web tests point to Application Insights; host CPU or VM guest counters alone do not. [Application Insights overview](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview).

### Common trap

An Application Insights resource does not automatically create deep APM for every workload: the application must emit supported telemetry through instrumentation or autoinstrumentation, while a standard availability test only observes the public endpoint from outside. [Application Insights data collection](https://learn.microsoft.com/en-us/azure/azure-monitor/app/application-insights-faq#what-is-collected-and-from-where) [Application Insights availability tests](https://learn.microsoft.com/en-us/azure/azure-monitor/app/availability).

---

## VM insights, Azure Monitor Agent, and DCRs

**Classification:** Core

**Why it matters:** VM monitoring is layered. Azure supplies host signals automatically, but guest logs and counters require AMA and DCRs, hybrid machines require Azure Arc, and process dependency mapping now has a dated retirement path.

**Primary Microsoft source:** [Monitor Azure virtual machines](https://learn.microsoft.com/en-us/azure/virtual-machines/monitor-vm)

**Limits and quotas source:** [Azure Monitor DCR limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#data-collection-rules)

### Deep technical facts / requirements

1. **Default versus agent collection:** Azure VM host platform metrics, Activity Log data, and boot diagnostics are available without AMA, but guest OS performance counters, Windows events, and Syslog require Azure Monitor Agent plus an associated DCR. [Azure VM host and guest monitoring](https://learn.microsoft.com/en-us/azure/virtual-machines/monitor-vm).
2. **Onboarding dependencies:** Full guest monitoring requires three distinct actions: install AMA, create or reuse a DCR, and associate the VM with the DCR. Installing the extension without a DCR association does not define data collection. [Enable VM monitoring](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vm-enable-monitoring).
3. **Association model:** One machine can associate with multiple DCRs and one DCR can associate with multiple machines. The agent downloads all associated rules, enabling reusable collection baselines and workload overlays. [VM data collection rules](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/monitor-virtual-machine-data-collection#data-collection-rules).
4. **DCR scale:** One DCR supports up to **10 data sources**, **100 performance-counter specifiers**, **20 Syslog facilities**, **100 Windows Event Log XPath queries**, **10 data flows**, **20 streams**, and **10 Log Analytics workspace destinations**. [Azure Monitor DCR service limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#data-collection-rules).
5. **Transform limits:** A DCR can contain at most **15,360 characters** in one transformation. Transformations can filter or reshape incoming records before workspace ingestion, affecting both stored volume and schema. [Azure Monitor DCR limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#data-collection-rules) [DCR transformations](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations).
6. **VM insights default:** Enabling VM insights creates a reusable `MSVMI-` prefixed DCR and collects normalized performance counters into `InsightsMetrics`; process and dependency collection is **off by default** to avoid additional ingestion cost. [VM insights data collection](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/monitor-virtual-machine-data-collection#vm-insights).
7. **Dependency requirement:** Enabling VM insights processes and dependencies deploys Dependency Agent and populates `VMBoundPort`, `VMComputer`, `VMConnection`, and `VMProcess`. This data is required for the legacy Map experience but not for base performance monitoring. [VM insights process and dependency collection](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/monitor-virtual-machine-data-collection#vm-insights).
8. **Hybrid prerequisite:** AMA on non-Azure machines requires Azure Arc-enabled servers so the machine has an Azure resource identity and managed identity for Azure Monitor onboarding and authentication. [AMA on on-premises and other-cloud servers](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-supported-operating-systems#on-premises-and-in-other-clouds).
9. **Agent retirement:** The legacy Log Analytics agent reached retirement on **August 31, 2024** and is unsupported; new and migrated designs must use AMA. [Migrate to Azure Monitor Agent](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-migration).
10. **Map retirement:** VM insights Map and Dependency Agent are deprecated and retire on **June 30, 2028**. A new architecture should not make that feature the long-term dependency-mapping foundation. [VM insights Map retirement](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-maps).
11. **Map limits:** The deprecated Map experience supports IPv4 but not native IPv6, shows **30 minutes** by default, allows at most a **1-hour** historical selection, and supports only **5 machines** in the Free pricing tier. [VM insights Map limitations](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-maps#limitations).
12. **Policy at scale:** Azure Policy initiatives can deploy AMA and DCR associations across scopes; existing resources require remediation, while new matching resources are evaluated through normal policy processing. [Enable VM insights with Azure Policy](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-enable-policy).

### Incompatibilities and mutual exclusions

If the requirement is native IPv6 dependency mapping and long-term support beyond June 2028, VM insights Map cannot satisfy it because the feature supports IPv4 only and both Map and Dependency Agent retire on June 30, 2028. [VM insights Map limitations and retirement](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-maps).

### Edge cases and gotchas

- Running AMA and the legacy Log Analytics agent against the same machine can duplicate records and make VM insights Map inaccurate because Map does not deduplicate the data. [VM insights duplicate-agent warning](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-maps#prerequisites).
- Duplicate IP address ranges across VNets or subnets can make dependency maps display incorrect relationships. [VM insights Map limitations](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-maps#limitations).
- Selecting a DCR without Map collection does not automatically uninstall an already deployed Dependency Agent; retirement cleanup must remove the obsolete agent and policy assignments deliberately. [Migrate VM insights to AMA](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-migrate-agent).
- The portal can automate AMA, DCR, and DCR-association steps, but architects should still model all three dependencies for IaC and policy deployment. [Enable VM monitoring](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vm-enable-monitoring).

### AZ-305 exam discriminator

Platform CPU and host availability can use default VM platform signals; guest event logs, Syslog, memory, and custom counters require AMA plus DCR; on-premises VMs add Azure Arc; application request traces still require Application Insights. [Monitor Azure VMs](https://learn.microsoft.com/en-us/azure/virtual-machines/monitor-vm).

### Common trap

VM insights does not automatically enable process/dependency mapping in its default cost-conscious configuration; that option is separate, deploys Dependency Agent, and is on a June 2028 retirement path. [VM insights data collection defaults](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/monitor-virtual-machine-data-collection#vm-insights) [VM insights Map retirement](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-maps).

---

## Container insights and Azure Monitor managed service for Prometheus

**Classification:** Core

**Why it matters:** Kubernetes telemetry is split by purpose. Container logs and inventory use Container insights and Log Analytics, while Prometheus metrics and PromQL use managed Prometheus and an Azure Monitor workspace.

**Primary Microsoft source:** [Kubernetes monitoring overview](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-overview)

**Limits and quotas source:** [Managed Prometheus service limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#prometheus-metrics)

### Deep technical facts / requirements

1. **Two-workspace architecture:** Managed Prometheus requires an Azure Monitor workspace, while Container insights log collection requires a Log Analytics workspace; enabling one store does not provide the other signal family. [Kubernetes monitoring quickstart](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-tutorial).
2. **Supported cluster scope:** Azure Monitor can onboard AKS and Azure Arc-enabled Kubernetes for managed Prometheus and Container insights, allowing a common monitoring plane across Azure, on-premises, and other clouds. [Kubernetes monitoring best practices](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/best-practices-containers).
3. **Retention and pricing:** Managed Prometheus retains data for **18 months** without a separate storage charge; pricing is based on ingestion and query, and PromQL queries can span no more than **32 days**. [Managed Prometheus overview](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/prometheus-metrics-overview) [Managed Prometheus service limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#prometheus-metrics).
4. **Ingestion scale:** One Azure Monitor workspace supports **1,000,000 active time series** and **1,000,000 events per minute** by default, with increases requestable. A Prometheus DCR allows **15,000 requests/minute** and **50 GB/minute**, and those DCR ceilings cannot be increased. [Managed Prometheus ingestion limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#ingestion).
5. **Query scale:** One PromQL query can return up to **500,000 time series** and **50,000,000 samples**; for a range of **48 hours or more**, the minimum query step is **60 seconds**. [Managed Prometheus query limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#queries).
6. **Rule limits:** An Azure Monitor workspace supports **500 Prometheus rule groups** by default, each group supports **20 rules**, and evaluation intervals range from **1 minute to 24 hours**, with **1 minute** as the default. [Prometheus alert and recording-rule limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#alert-and-recording-rules).
7. **Case behavior:** Azure managed Prometheus is case-insensitive for metric names, label names, and label values when determining whether series are distinct; names that differ only by case collide as the same time series. [Managed Prometheus ingestion behavior](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#ingestion).
8. **Cost overlap:** Container insights can also collect some Prometheus metrics into Log Analytics, but Microsoft recommends managed Prometheus and warns that collecting the same metrics through both paths is redundant and adds cost. [Kubernetes monitoring cost optimization](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/best-practices-containers#cost-optimization-for-kubernetes-monitoring).
9. **Log-plan gating:** If container logs are not queried frequently or used by alerts, `ContainerLogV2` can use the Basic table plan; if scheduled alerting and full analytics are required, validate the Analytics plan instead. [Container insights cost optimization](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/best-practices-containers#cost-optimization-for-kubernetes-monitoring).
10. **High-scale mode:** Container insights high-scale mode is intended above **2,000 logs/second** or **2 MB/second per node** and is tested up to **50,000 logs/second per node**; Microsoft recommends node SKUs with at least **16 CPU cores** for maximum throughput. [Container insights high-scale mode](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-high-scale).
11. **High-scale prerequisites:** High-scale mode requires `ContainerLogV2`, Azure CLI **2.74.0+**, an ingestion DCE, and outbound HTTPS on port **443** to the DCE ingestion endpoint. [Container insights high-scale prerequisites](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-high-scale#prerequisites).
12. **Private query path:** An Azure Monitor workspace can disable public query access and use a private endpoint; Azure Managed Grafana additionally needs a managed private endpoint to keep its workspace queries off the public internet. [Managed Prometheus private endpoints](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/azure-monitor-workspace-private-endpoint).

### Incompatibilities and mutual exclusions

If a design requires PromQL rules and only a Log Analytics workspace, Container insights alone is insufficient because PromQL data and rules depend on managed Prometheus in an Azure Monitor workspace. [Kubernetes monitoring quickstart](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-tutorial).

### Edge cases and gotchas

- High-scale mode cannot be enabled through the Azure portal, and existing Container insights must be disabled and re-enabled for migration because the mode uses a different pipeline. [Container insights high-scale limitations and migration](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-high-scale#limitations).
- A custom DCR using `Microsoft-ContainerLogV2` alongside high-scale collection must be replaced with `Microsoft-ContainerLogV2-HighScale` or logs can be duplicated. [Container insights high-scale migration](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-high-scale#migration).
- Managed Prometheus remote write is limited to about **150,000 unique time series** with the default **500-series** batch; increasing the batch to **1,000** can reduce connection pressure above that point. [Managed Prometheus remote-write limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#remote-write).
- Live-data charts in Container insights are a direct cluster experience and are not supported with the managed Prometheus visualizations in Azure Monitor for AKS. [Container insights live metrics limitations](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-livedata-metrics).

### AZ-305 exam discriminator

PromQL, Kubernetes recording rules, and 18-month metric retention point to managed Prometheus plus an Azure Monitor workspace; stdout/stderr logs, inventory, and KQL-based container investigation point to Container insights plus Log Analytics; operational dashboards commonly add Grafana. [Managed Prometheus overview](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/prometheus-metrics-overview) [Kubernetes monitoring overview](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-overview).

### Common trap

“Enable Container insights” is not a complete cloud-native monitoring design: it does not replace managed Prometheus for PromQL-native metrics, nor Application Insights for application-level distributed traces. [Kubernetes monitoring overview](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-overview).

---

## Workbooks, Azure dashboards, and Azure Managed Grafana

**Classification:** Core

**Why it matters:** These tools overlap visually but differ in interactivity, source support, operational workflow, private networking, identity, alerting, licensing, and hard rendering limits.

**Primary Microsoft source:** [Azure Monitor visualization guidance](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/best-practices-visualize)

**Limits and quotas source:** [Azure Workbooks limits](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-limits)

### Deep technical facts / requirements

1. **Workbooks role:** Workbooks combine queries, parameters, text, and interactive visualizations across Azure data sources and underpin many built-in Insights experiences; they are Azure portal resources rather than a continuously running ingestion or alert engine. [Azure Workbooks overview](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview).
2. **Workbook result ceiling:** Workbook queries generally return no more than **10,000 results**; log grids show **250 rows** by default and can be raised to **10,000**, while metric grids query at most **200 resources** at a time. [Azure Workbooks result limits](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-limits).
3. **Workbook visualization limits:** A workbook chart supports **100 series** and **10,000 data points**; tiles display **100 items**, maps display **100 points**, and text uses only the first returned cell. [Azure Workbooks visualization limits](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-limits#visualization-limits).
4. **Workbook parameter limits:** Dropdown and options-group parameters support **1,000 items**, multi-value parameters support **100**, and query-backed dropdowns use only the first **4 columns**. [Azure Workbooks parameter limits](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-limits#parameter-limits).
5. **Dashboard distinction:** Azure dashboards provide a portal-centric pane that can combine Azure Monitor tiles with other Azure portal resources; Workbooks offer richer analysis and drill-down, while dashboards are the simpler shared portal surface. [Azure Monitor visualization choices](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/best-practices-visualize).
6. **Grafana fit:** Grafana is optimized for operational and cloud-native dashboards and supports Azure Monitor plus open-source and third-party data sources. All Grafana editions include the Azure Monitor data-source plug-in. [Grafana visualization guidance](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/best-practices-visualize#grafana).
7. **Current Grafana tiers:** Azure Managed Grafana Standard is the default/recommended tier. Essential is unavailable for new workspaces, has no SLA, and is scheduled for complete deprecation on **March 31, 2027**. [Azure Managed Grafana tiers](https://learn.microsoft.com/en-us/azure/managed-grafana/overview#service-tiers).
8. **Standard sizing:** Standard X1 is the default instance size and supports **500 alert rules per organization**; X2 provides more memory and supports **1,000 alert rules**, at additional cost. [Azure Managed Grafana service tiers](https://learn.microsoft.com/en-us/azure/managed-grafana/overview#service-tiers).
9. **Tier gating:** Standard supports zone redundancy, deterministic outbound IPs, private endpoints, Grafana alerting, SMTP email, reporting/image rendering, and the broader core plug-in set; deprecated Essential lacks those capabilities. [Azure Managed Grafana tier comparison](https://learn.microsoft.com/en-us/azure/managed-grafana/overview#service-tiers).
10. **Identity:** Azure Managed Grafana authenticates users with Microsoft Entra ID, maps access through Grafana Admin/Editor/Viewer/Limited Viewer Azure roles, and can use managed identity to access Azure data sources. [Managed Grafana access and roles](https://learn.microsoft.com/en-us/azure/managed-grafana/how-to-manage-access-permissions-users-identities).
11. **Private networking:** Private endpoints are a Standard-tier capability. Querying a private Azure Monitor workspace from Azure Managed Grafana requires a managed private endpoint in addition to the workspace's own private access configuration. [Managed Grafana networking](https://learn.microsoft.com/en-us/azure/managed-grafana/how-to-connect-to-data-source-privately) [Azure Monitor workspace private endpoints](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/azure-monitor-workspace-private-endpoint).
12. **Preview alternative:** `[Preview]` Azure Monitor dashboards with Grafana run in the Azure portal at no additional service cost and support Azure Monitor and managed Prometheus, but Managed Grafana is required when the design needs external sources, usage audit logs, managed identity/service-principal access, or private networking. [Azure Monitor visualization guidance](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/best-practices-visualize#grafana).

### Incompatibilities and mutual exclusions

If the dashboard must use private networking or non-Azure/open-source data sources and only Azure Monitor dashboards with Grafana `[Preview]` are allowed, the design is insufficient; use Azure Managed Grafana Standard because the portal preview does not provide those enterprise capabilities. [Azure Monitor Grafana choice](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/best-practices-visualize#grafana).

### Edge cases and gotchas

- A workbook can silently truncate beyond its rendering limits, so a visually complete grid or chart is not proof that the query returned the entire dataset. [Azure Workbooks result limits](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-limits).
- Workbook parameters normally affect only components downstream from where the parameter is set; global parameters are the exception. [Azure Workbook parameter behavior](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-parameters).
- Grafana Limited Viewer can be combined with component-level dashboard, folder, and data-source permissions when ordinary Viewer access would expose too much. [Managed Grafana component permissions](https://learn.microsoft.com/en-us/azure/managed-grafana/how-to-manage-access-permissions-users-identities#edit-permissions-for-specific-component-elements).
- Power BI remains the better fit for business-centric reports and long-term KPI analysis; it is not the default real-time operations console. [Azure Monitor visualization guidance](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/best-practices-visualize#power-bi).

### AZ-305 exam discriminator

Choose Workbooks for interactive Azure analysis and drill-down, Azure dashboards for a simple shared portal pane, Managed Grafana for Prometheus/cloud-native or multi-source operational dashboards with enterprise networking, and Power BI for business reporting. [Azure Monitor visualization guidance](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/best-practices-visualize).

### Common trap

Workbooks and Grafana visualize and analyze data but do not replace the collection store or Azure Monitor alert rule; design ingestion, retention, and alerting separately from the presentation layer. [Azure Monitor visualization guidance](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/best-practices-visualize) [Azure Monitor alerts overview](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview).

---

## Service Health and Resource Health

**Classification:** Supporting

**Why it matters:** Provider incidents, maintenance, advisories, and individual-resource health require Azure-generated platform context. These signals complement but cannot replace end-to-end workload tests and telemetry.

**Primary Microsoft source:** [Azure Service Health overview](https://learn.microsoft.com/en-us/azure/service-health/overview)

### Deep technical facts / requirements

1. **Scope distinction:** Azure Status is a public global service-status view; authenticated Service Health is personalized to services and regions used by the subscription; Resource Health reports current and historical health for individual resources. [Azure Service Health overview](https://learn.microsoft.com/en-us/azure/service-health/overview).
2. **Event model:** Service Health notifications are system-generated events recorded in the subscription Activity Log; Service Health and Resource Health alert rules are therefore Activity Log alert rules. [Service Health notification properties](https://learn.microsoft.com/en-us/azure/service-health/service-health-notifications-properties) [Azure Monitor alert types](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types#service-health-alerts).
3. **Alert categories:** Service Health alerts can filter service issues, planned maintenance, health advisories, and security advisories by subscription, service, region, and event type. [Service Health alerts](https://learn.microsoft.com/en-us/azure/service-health/service-health-alert-overview).
4. **Scale limit:** A subscription has a hard maximum of **100** Activity Log alert rules, including all Service Health and Resource Health alert rules; this limit cannot be increased. [Azure Monitor Activity Log alert limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#alerts).
5. **State behavior:** Service Health and Resource Health alerts are event-driven and stateless; they fire once for a matching event and do not auto-resolve, so the user response field must be used for acknowledgement or closure. [Activity Log alert state behavior](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types#activity-log-alerts).
6. **Response requirement:** Service Health alerts should use a **Global** action group so notification processing is not tied to a region that might be affected by the incident. [Action group regional behavior](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups#global-and-regional-action-group-processing).
7. **Processing-rule limitation:** Alert processing rules do not affect Service Health alerts, so scheduled processing-rule suppression cannot mute their action groups during a maintenance window. [Alert processing rule limitations](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-processing-rules).
8. **Health-model boundary:** Resource Health explains Azure's assessment of a resource and may identify platform- versus user-initiated causes, but it does not validate the business transaction through all dependencies; external availability testing remains a separate requirement. [Azure Resource Health overview](https://learn.microsoft.com/en-us/azure/service-health/resource-health-overview) [Application Insights availability tests](https://learn.microsoft.com/en-us/azure/azure-monitor/app/availability).

### Incompatibilities and mutual exclusions

If the requirement is to suppress Service Health notification actions with a scheduled alert processing rule, that design cannot work because Service Health alerts are explicitly excluded from processing rules. [Alert processing rules](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-processing-rules).

### Edge cases and gotchas

- The Service Health alert view shows rules the customer created, not every health event that exists in Azure; a missing rule can mean no notification even though an event is visible in Service Health. [Service Health alerts overview](https://learn.microsoft.com/en-us/azure/service-health/service-health-alert-overview).
- A fired Service Health alert remaining in `Fired` does not prove an outage is ongoing; Activity Log alerts do not auto-resolve. [Activity Log alert state behavior](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types#activity-log-alerts).
- Azure Status is too broad for subscription-specific impact because it does not use the authenticated resource context that personalizes Service Health. [Azure Service Health overview](https://learn.microsoft.com/en-us/azure/service-health/overview).

### AZ-305 exam discriminator

“Azure outage or planned maintenance affecting my subscriptions” points to Service Health; “why this individual Azure resource is unavailable” points to Resource Health; “can users complete the transaction” still requires workload availability testing. [Azure Service Health overview](https://learn.microsoft.com/en-us/azure/service-health/overview) [Application Insights availability tests](https://learn.microsoft.com/en-us/azure/azure-monitor/app/availability).

### Common trap

Service Health is not an end-to-end application availability monitor: it reports Azure-provider context and cannot see a failed business transaction caused by application code, configuration, or an external dependency. [Azure Service Health overview](https://learn.microsoft.com/en-us/azure/service-health/overview) [Application Insights overview](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview).

---

## Network Watcher and Connection Monitor

**Classification:** Supporting

**Why it matters:** Network Monitor experiences diagnose IaaS connectivity and path behavior that resource metrics and APM alone cannot isolate. Connection Monitor adds continuous reachability and latency tests.

**Primary Microsoft source:** [Network Watcher overview](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview)

### Deep technical facts / requirements

1. **Regional scope:** Network Watcher is a regional service and is automatically enabled when a VNet is created or updated unless the subscription opted out; opt-out environments must enable it in every required region. [Enable Network Watcher](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-create).
2. **Service boundary:** Network Watcher provides topology, next hop, IP flow verify, packet capture, NSG diagnostics, flow visibility, and Connection Monitor for Azure IaaS networks; it is not the APM tool for application requests or web usage. [Network Watcher overview](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview).
3. **Source-agent requirement:** Azure VM and VM scale-set source endpoints in Connection Monitor require the Network Watcher extension; on-premises source endpoints use a Log Analytics agent-based executable path supported by Connection Monitor. [Connection Monitor agents](https://learn.microsoft.com/en-us/azure/network-watcher/connection-monitor-overview#monitoring-agents).
4. **Endpoint support:** Destinations can be Azure VM resource IDs, IPv4, IPv6, FQDNs, custom URLs, and Microsoft 365 or Dynamics 365 URLs, allowing tests from Azure or on-premises sources to Azure or external destinations. [Connection Monitor overview](https://learn.microsoft.com/en-us/azure/network-watcher/connection-monitor-overview#create-a-connection-monitor).
5. **Scale:** A subscription supports **100 Connection Monitor resources per region**; one monitor supports **20 test groups**, **100 sources and destinations**, and **20 test configurations**. [Connection Monitor scale limits](https://learn.microsoft.com/en-us/azure/network-watcher/connection-monitor-overview#scale-limits).
6. **Combinatorial tests:** Every source, destination, and test-configuration combination becomes a separate test; **3 sources × 2 destinations × 2 configurations = 12 tests**, which affects monitor scale and alert volume. [Connection Monitor test model](https://learn.microsoft.com/en-us/azure/network-watcher/connection-monitor-overview#create-a-connection-monitor).
7. **Signals:** Connection Monitor exposes `ChecksFailedPercent` and `RoundTripTimeMs` metrics for alerting and keeps topology and test-result context for reachability and latency analysis. [Connection Monitor metrics](https://learn.microsoft.com/en-us/azure/network-watcher/connection-monitor-overview#analyze-monitoring-data-and-set-alerts).
8. **Reevaluation edge:** Connection Monitor reevaluates endpoint status every **24 hours**; a VM deallocated mid-cycle can show `Indeterminate` until the next reevaluation, especially when particular scale-set instances were selected. [Connection Monitor endpoint reevaluation](https://learn.microsoft.com/en-us/azure/network-watcher/connection-monitor-overview#analyze-monitoring-data-and-set-alerts).

### Incompatibilities and mutual exclusions

If the requirement is browser request traces, code exceptions, and dependency-call correlation for a PaaS web app, Network Watcher cannot satisfy it because its scope is network reachability and diagnostics; use Application Insights for the application layer. [Network Watcher overview](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview) [Application Insights overview](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview).

### Edge cases and gotchas

- Automatic Network Watcher enablement creates the regional service but does not automatically create Connection Monitor tests or install every required source extension. [Enable Network Watcher](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-create) [Connection Monitor agents](https://learn.microsoft.com/en-us/azure/network-watcher/connection-monitor-overview#monitoring-agents).
- Fixed selection of scale-set instances can leave tests indeterminate after scale-in; percentage-based coverage and random instance selection reduce that risk. [Connection Monitor coverage behavior](https://learn.microsoft.com/en-us/azure/network-watcher/connection-monitor-overview#scale-limits).
- Point-in-time tools such as next hop and IP flow verify answer a different question from continuous Connection Monitor tests; one does not replace the other. [Azure network monitoring design guide](https://learn.microsoft.com/en-us/azure/networking/design-guide/monitor).

### AZ-305 exam discriminator

Continuous reachability and RTT between endpoints point to Connection Monitor; routing-table outcome points to next hop; NSG allow/deny diagnosis points to IP flow verify or NSG diagnostics; packet-level capture points to packet capture. [Network Watcher overview](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview).

### Common trap

Network Watcher being enabled in a region does not mean the network is continuously tested; Connection Monitor resources, test groups, endpoint agents, protocols, ports, and thresholds still must be configured. [Connection Monitor overview](https://learn.microsoft.com/en-us/azure/network-watcher/connection-monitor-overview).

---

## Microsoft Entra monitoring, Defender for Cloud, and Microsoft Sentinel

**Classification:** Adjacent

**Why it matters:** These products become the correct answer only when the dominant requirement is identity activity, cloud security posture/workload protection, or SIEM/SOAR. They can consume or export Azure Monitor data but do not replace workload observability.

**Primary Microsoft sources:** [Microsoft Entra monitoring and health](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/overview-monitoring-health), [Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction), and [Microsoft Sentinel SIEM](https://learn.microsoft.com/en-us/azure/sentinel/overview)

### Deep technical facts / requirements

1. **Entra retention by license:** Microsoft Entra audit and sign-in logs retain **7 days** on Free and **30 days** on P1/P2; risky sign-ins retain **7 days** on Free, **30 days** on P1, and **90 days** on P2. [Microsoft Entra data retention](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/reference-reports-data-retention).
2. **No retroactive extension:** Upgrading from Free to Premium does not restore older activity; only the previously retained **7 days** is available after upgrade, so long-term requirements must export before data expires. [Microsoft Entra data retention after license upgrade](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/reference-reports-data-retention#can-i-see-last-months-data-after-getting-a-premium-license).
3. **Graph activity prerequisite:** Microsoft Graph activity logs require Entra P1 or P2 and are not retained by Entra itself; a diagnostic setting must send them to storage or an analytics destination. [Microsoft Entra data retention](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/reference-reports-data-retention#activity-reports).
4. **Entra integration:** Entra diagnostic settings can route identity activity to Azure Monitor Logs for KQL/workbooks, Event Hubs for a third-party SIEM, or Storage for retention; these tenant identity logs are not subscription Activity Log events. [Microsoft Entra monitoring integration options](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-log-monitoring-integration-options-considerations).
5. **Defender baseline:** Enabling Defender for Cloud automatically enables free Foundational CSPM; paid Defender CSPM adds capabilities such as attack-path analysis, cloud security explorer, governance, regulatory compliance, and agentless scanning. [Enable Defender CSPM](https://learn.microsoft.com/en-us/azure/defender-for-cloud/tutorial-enable-cspm-plan).
6. **Secure Score behavior:** Microsoft cloud security benchmark is applied by default when Defender for Cloud is enabled, only built-in MCSB recommendations contribute to the classic secure score, and preview recommendations are excluded from score calculation. [Defender for Cloud Secure Score](https://learn.microsoft.com/en-us/azure/defender-for-cloud/secure-score-security-controls).
7. **Current score change:** Effective **June 30, 2026**, more than **200** new AWS and GCP recommendations can affect Secure Score, so a score change can reflect expanded assessed scope rather than degraded Azure configuration. [Defender Secure Score multicloud update](https://learn.microsoft.com/en-us/azure/defender-for-cloud/secure-score-security-controls).
8. **Security export:** Defender for Cloud continuous export can send selected alerts, recommendations, and score changes to Log Analytics or Event Hubs; a secure-score change of **0.01 or more** triggers its export record. [Defender for Cloud continuous export](https://learn.microsoft.com/en-us/azure/defender-for-cloud/benefits-of-continuous-export).
9. **Sentinel outcome:** Microsoft Sentinel provides SIEM/SOAR capabilities including security connectors, analytics, incidents, hunting, investigation, automation, and playbooks; it is the specialist answer when the requirement is a security operations workflow rather than ordinary availability/performance monitoring. [Microsoft Sentinel SIEM overview](https://learn.microsoft.com/en-us/azure/sentinel/overview).
10. **Sentinel data tiers:** The Analytics tier supports high-performance detection, hunting, alerting, and incident management; the data lake tier provides long-term security retention and deep analysis for up to **12 years**, so lake-only placement is not a substitute for real-time analytics-tier detections. [Microsoft Sentinel data lake tiers](https://learn.microsoft.com/en-us/azure/sentinel/datalake/sentinel-lake-overview#storage-tiers).

### Incompatibilities and mutual exclusions

If the requirement is real-time SIEM analytics, incidents, and hunting, placing the data only in Sentinel's data lake tier is insufficient because those operational detection workflows depend on the Analytics tier. [Microsoft Sentinel data tiers](https://learn.microsoft.com/en-us/azure/sentinel/datalake/sentinel-lake-overview#storage-tiers).

### Edge cases and gotchas

- Microsoft Entra audit/sign-in retention is separate from Microsoft 365 Unified Audit Log retention; changing Entra licensing does not change Purview Audit retention. [Microsoft Entra data retention](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/reference-reports-data-retention).
- Defender Secure Score measures posture recommendations; it is not a substitute for live application health, latency, or synthetic availability signals. [Defender for Cloud Secure Score](https://learn.microsoft.com/en-us/azure/defender-for-cloud/secure-score-security-controls) [Application Insights overview](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview).
- Sentinel data ingested into the Analytics tier is mirrored into the data lake tier, preserving a central lake copy while retaining analytics capability. [Microsoft Sentinel platform overview](https://learn.microsoft.com/en-us/azure/sentinel/sentinel-overview).

### AZ-305 exam discriminator

Identity sign-in/audit health points to Entra monitoring; posture, regulatory recommendations, and workload protection point to Defender for Cloud; cross-source security detection, hunting, incidents, and playbooks point to Sentinel; application latency and infrastructure health remain Azure Monitor outcomes. [Microsoft Entra monitoring](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/overview-monitoring-health) [Defender for Cloud overview](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction) [Microsoft Sentinel SIEM](https://learn.microsoft.com/en-us/azure/sentinel/overview).

### Common trap

Log Analytics is a data store and query experience, not a SIEM by itself; Sentinel adds security analytics, incidents, hunting, and automation on top of security data. [Log Analytics workspace overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview) [Microsoft Sentinel SIEM](https://learn.microsoft.com/en-us/azure/sentinel/overview).

---

## Private access and enterprise monitoring governance

**Classification:** Framework / architecture guidance

**Why it matters:** A technically correct product choice can still fail at scale without network-boundary design, policy-based onboarding, standard alerts, ownership, least privilege, cost governance, and regional failure visibility.

**Primary Microsoft sources:** [Cloud Adoption Framework monitoring](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor) and [Well-Architected monitoring design guide](https://learn.microsoft.com/en-us/azure/well-architected/design-guides/monitoring)

### Deep technical facts / requirements

1. **Workload capability:** The Well-Architected Framework treats monitoring as a system spanning instrumentation, collection/storage, analysis/correlation, alerting, and visualization; omitting any stage creates a blind spot even when Azure Monitor resources exist. [Well-Architected monitoring design guide](https://learn.microsoft.com/en-us/azure/well-architected/design-guides/monitoring).
2. **Responsibility model:** Cloud Adoption Framework monitoring separates platform-team baseline monitoring from workload-team overlays and requires ownership for alert response; a central workspace alone does not assign operational accountability. [Cloud Adoption Framework monitoring](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor).
3. **Subscription response baseline:** Azure landing-zone guidance recommends at least **1 action group per subscription** so relevant owners receive baseline alerts. [Azure landing-zone monitoring](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-monitor).
4. **Policy mechanics:** Azure Policy can deploy monitoring settings and agents to new resources, but existing noncompliant resources need remediation tasks; policy assignment without remediation does not retroactively configure everything immediately. [Azure Policy remediation](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources).
5. **Private-link architecture:** AMPLS defines which Log Analytics, Application Insights, and supported Azure Monitor resources are reachable through a private endpoint and can block exfiltration to workspaces outside the approved scope. [Azure Monitor Private Link](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-security).
6. **DNS dependency:** Private Azure Monitor access depends on correct private DNS resolution; browsers that override or cache DNS can attempt public endpoints, and Chromium local-network restrictions can block portal access to private endpoint addresses until allowed. [Configure Azure Monitor Private Link](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-configure#browser-dns-settings).
7. **Regional observability:** A global aggregate can hide a failed region, so resiliency monitoring should retain region dimensions and combine regional workload telemetry, external availability tests, and Service Health provider context. [Well-Architected monitoring design guide](https://learn.microsoft.com/en-us/azure/well-architected/design-guides/monitoring) [Azure Monitor metric dimensions](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/data-platform-metrics#multi-dimensional-metrics).
8. **Cost architecture:** Azure Monitor cost is driven by collected volume, table plan, retention, alert evaluation, query, and visualization usage; collection should preserve actionable diagnostic context while filtering redundant high-volume data before ingestion where supported. [Azure Monitor cost and usage](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/cost-usage) [DCR transformations](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations).

### Incompatibilities and mutual exclusions

If a VNet needs private access to resources spread across multiple AMPLS objects, the topology is invalid because one VNet can connect to only one AMPLS; consolidate all approved monitoring resources into that reachable scope. [Azure Monitor Private Link limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#azure-monitor-private-link-scope-ampls).

### Edge cases and gotchas

- Private Link controls network paths but does not replace Azure RBAC; clients still use the same authorization mechanisms over the private endpoint. [Azure Monitor Private Link architecture](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-security#basic-concepts).
- A central action group reused by hundreds of noisy rules can hit notification rate limits; Microsoft recommends stateful alerts, multi-resource rules, tuned evaluation, and deliberate regional action-group distribution. [Action group limit guidance](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#action-groups).
- `[Preview]` Azure Monitor health models can create business-aware health rollups, but a scenario that prohibits preview features must use GA metrics, logs, workbooks, and alerts instead. [Azure Monitor health models](https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/overview).

### AZ-305 exam discriminator

Enterprise-scale requirements for consistent VM onboarding, baseline alerts, and ownership point to Azure Policy/landing-zone monitoring plus workload overlays; private-only ingestion and query add AMPLS, private endpoints, and DNS rather than changing the selected monitoring signal. [Azure landing-zone monitoring](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-monitor) [Azure Monitor Private Link](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-security).

### Common trap

Centralizing all telemetry into one workspace is not automatically the best governance design: regional residency, access isolation, query limits, cost ownership, and blast radius can require multiple workspaces with standardized policy and cross-workspace query boundaries. [Cloud Adoption Framework monitoring](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor) [Azure Monitor log query limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#log-queries-and-language).

---

## Highest-yield exam discriminators

| Scenario clue | Best answer | Why |
|---|---|---|
| PromQL, Prometheus rule groups, or 18-month Kubernetes metric retention | Azure Monitor managed service for Prometheus + Azure Monitor workspace | Managed Prometheus stores metrics for **18 months**, uses PromQL, and requires an Azure Monitor workspace; a PromQL query spans at most **32 days**. [Managed Prometheus limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#prometheus-metrics). |
| KQL correlation across logs and traces | Log Analytics workspace | Log Analytics is the KQL store; an Azure Monitor workspace is the separate Prometheus/OTel metric store. [Azure Monitor data platform](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview#azure-monitor-data-platform). |
| Numeric threshold already exposed as a metric | Metric alert | Metric alerts evaluate precomputed time series and are stateful by default, avoiding the additional latency and query cost of a log alert. [Choose alert type](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types#metric-alerts). |
| Complex correlation or calculation written in KQL | Log search alert | Log search alerts execute KQL, but only **100** per subscription can use a **1-minute** frequency and query results cannot exceed **20 MB**. [Azure Monitor alert limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#alerts). |
| Azure control-plane operation, Service Health event, or Resource Health transition | Activity Log alert | Activity Log alerts are event-driven and stateless; the hard subscription ceiling is **100**, including Service/Resource Health rules. [Azure Monitor alert limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#alerts). |
| Suppress notification actions during planned maintenance but keep alert evidence | Alert processing rule | Suppression removes action groups while fired alerts remain visible; it does not stop rule evaluation or delete alerts. [Alert processing rule suppression](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-processing-rules#what-should-this-rule-do). |
| Suppress Service Health through an alert processing rule | Redesign the Service Health action path | Processing rules do not affect Service Health alerts, and Service Health should use a Global action group. [Alert processing rules](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-processing-rules) [Action groups](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups#global-and-regional-action-group-processing). |
| Distributed requests, dependencies, exceptions, application map | Application Insights | These are application-instrumentation signals; workspace-based Application Insights stores them in Log Analytics and correlates distributed operations. [Application Insights overview](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview). |
| Public HTTP endpoint synthetic test from multiple Azure locations | Application Insights standard availability test | Standard tests require a public endpoint, support up to **16 locations**, have a **5-minute** minimum frequency, and allow **100 tests per Application Insights resource**. [Availability tests](https://learn.microsoft.com/en-us/azure/azure-monitor/app/availability) [Application Insights limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#application-insights). |
| Guest Windows events, Linux Syslog, or guest performance counters | AMA + DCR + DCR association | Host signals are automatic, but guest collection needs all three onboarding components; AMA alone has no collection definition. [Enable VM monitoring](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vm-enable-monitoring). |
| Same VM monitoring baseline for on-premises servers | Azure Arc-enabled servers + AMA + DCR | Azure Arc supplies the Azure resource/identity needed to manage AMA and DCR associations outside Azure. [AMA outside Azure](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-supported-operating-systems#on-premises-and-in-other-clouds). |
| Long-term dependency map design after June 2028 | Do not depend on VM insights Map | VM insights Map and Dependency Agent retire on **June 30, 2028**, and Map supports IPv4 only. [VM insights Map retirement and limits](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-maps). |
| Kubernetes stdout/stderr logs and inventory | Container insights + Log Analytics | Container logs use the Log Analytics path; managed Prometheus uses a separate Azure Monitor workspace for metrics. [Kubernetes monitoring quickstart](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-tutorial). |
| More than 2,000 container logs/sec/node | Container insights high-scale mode | High-scale mode targets over **2,000 logs/sec** and is tested to **50,000 logs/sec/node**, but requires `ContainerLogV2`, a DCE, and nonportal onboarding. [Container insights high-scale](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-high-scale). |
| Interactive Azure drill-down report with parameters | Azure Workbooks | Workbooks provide interactive Azure analysis but truncate general query results beyond **10,000** and charts beyond **100 series/10,000 points**. [Azure Workbooks limits](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-limits). |
| Prometheus, multicloud, external sources, managed identity, or private dashboard access | Azure Managed Grafana Standard | Standard supports broad plug-ins, private endpoints, managed identity, zone redundancy, and alerting; deprecated Essential does not and retires **March 31, 2027**. [Azure Managed Grafana tiers](https://learn.microsoft.com/en-us/azure/managed-grafana/overview#service-tiers). |
| Personalized Azure outage and planned-maintenance notifications | Service Health alert + Global action group | Service Health is subscription-aware and its action group should be Global; Azure Status is only the broad public status view. [Azure Service Health overview](https://learn.microsoft.com/en-us/azure/service-health/overview) [Action groups](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups#global-and-regional-action-group-processing). |
| Continuous reachability and round-trip latency between Azure/on-premises/external endpoints | Network Watcher Connection Monitor | Connection Monitor emits failed-check percentage and RTT; one monitor supports **20 test groups**, **100 endpoints**, and **20 configurations**. [Connection Monitor scale limits](https://learn.microsoft.com/en-us/azure/network-watcher/connection-monitor-overview#scale-limits). |
| Secure score, posture recommendations, and attack paths | Microsoft Defender for Cloud | Foundational CSPM is free; paid Defender CSPM adds attack-path analysis and advanced posture capabilities. [Defender CSPM](https://learn.microsoft.com/en-us/azure/defender-for-cloud/tutorial-enable-cspm-plan). |
| Security hunting, incidents, cross-source analytics, and playbooks | Microsoft Sentinel | Sentinel adds SIEM/SOAR workflows; lake-only data is for long-term analysis and does not replace Analytics-tier real-time detection and incidents. [Microsoft Sentinel SIEM](https://learn.microsoft.com/en-us/azure/sentinel/overview) [Sentinel data tiers](https://learn.microsoft.com/en-us/azure/sentinel/datalake/sentinel-lake-overview#storage-tiers). |

---

_Model used to research and author this fact sheet: GPT-5 (reasoning mode was not supplied)._
