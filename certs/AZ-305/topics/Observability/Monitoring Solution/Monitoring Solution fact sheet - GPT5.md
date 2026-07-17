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

