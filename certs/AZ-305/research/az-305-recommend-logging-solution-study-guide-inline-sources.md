# AZ-305 Study Guide: Recommend a Logging Solution

> Source format: inline citations use literal linked labels such as [source1](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305#design-solutions-for-logging-and-monitoring), and each label opens the relevant section of the online Microsoft Learn documentation.


## How to use this guide

This guide is scoped to the AZ-305 task **Recommend a logging solution**, which appears under **Design solutions for logging and monitoring** alongside the separate tasks **Recommend a solution for routing logs** and **Recommend a monitoring solution**. [source1](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305#design-solutions-for-logging-and-monitoring)

Read this as a logging architecture guide, not as a general Azure Monitor guide, because the exam task is about deciding what log data should be collected, where it should live, how it should be structured, how long it should be retained, who should access it, and how cost should be controlled. [source2](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#how-azure-monitor-logs-works) [source3](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#azure-resources) [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

The adjacent routing task becomes relevant only when a question asks where to send logs, such as Log Analytics, Storage, Event Hubs, or partner tools, but this guide treats those choices mainly through the lens of the logging solution itself. [source1](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305#design-solutions-for-logging-and-monitoring) [source33](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collecting-resource-logs)

The adjacent monitoring task becomes relevant only when a question asks about health, alerting, dashboards, workbooks, metrics, or operational response, but this guide treats those items as consumers of log data rather than the primary design target. [source1](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305#design-solutions-for-logging-and-monitoring) [source2](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#how-azure-monitor-logs-works)

Plan on about 45 minutes: spend 5 minutes on the mental model, 10 minutes on log sources, 10 minutes on workspace architecture, 10 minutes on table plans and retention, 5 minutes on access and governance, and 5 minutes on exam scenarios. [source1](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305#design-solutions-for-logging-and-monitoring) [source2](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#how-azure-monitor-logs-works) [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

## 1. What “Recommend a logging solution” means on AZ-305

The task is asking you to recommend a durable log architecture for Azure, hybrid, and application environments, not merely to identify a portal blade or a single Azure Monitor feature. [source1](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305#design-solutions-for-logging-and-monitoring) [source2](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#how-azure-monitor-logs-works)

Azure Monitor Logs is the central SaaS platform for collecting, analyzing, and acting on telemetry data from Azure resources, non-Azure resources, and applications. [source2](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#how-azure-monitor-logs-works)

A Log Analytics workspace is the primary Azure Monitor Logs resource and functions as the data store that holds tables into which log data is collected. [source2](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#how-azure-monitor-logs-works) [source9](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview#data-retention)

A strong logging recommendation normally starts with the log source, then selects the collection method, then selects the destination workspace and table strategy, then selects retention, access, and cost controls. [source2](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#how-azure-monitor-logs-works) [source3](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#azure-resources) [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

The exam can test whether you know the difference between control-plane logs, resource data-plane logs, guest operating system logs, application telemetry, identity logs, Kubernetes logs, and custom logs. [source3](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#azure-resources) [source4](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#log-data-from-microsoft-entra-id) [source5](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#application-data) [source6](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#virtual-machine-data) [source7](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#kubernetes-cluster-data) [source8](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#custom-sources)

The exam can also test whether you can decide between a single workspace and multiple workspaces based on tenant boundaries, geography, ownership, billing, retention, commitment tiers, access control, and resilience requirements. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

The exam can further test whether you know when to use Analytics, Basic, or Auxiliary table plans based on query behavior, ingestion cost, analysis needs, and compliance retention requirements. [source19](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-type-and-schema) [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

A logging solution should make log data available for the expected analysis pattern while avoiding unnecessary ingestion, duplicate data, overly broad access, and retention that is longer or more expensive than the requirement justifies. [source2](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#how-azure-monitor-logs-works) [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy) [source24](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#pricing-model) [source25](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#data-size-calculation)

## 2. Core mental model

Think of Azure logging as a pipeline: sources emit records, collection methods ingest or forward records, Log Analytics workspaces store records in tables, table settings control query behavior and retention, and access controls define who can query the records. [source2](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#how-azure-monitor-logs-works) [source3](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#azure-resources) [source19](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-type-and-schema) [source58](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-mode)

Azure Monitor Logs can collect data, transform it, route it to destination tables, manage table plans and retention, and retrieve records with Kusto Query Language. [source2](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#how-azure-monitor-logs-works)

A workspace can store many types of data in one place, which allows correlation across sources without moving data into another storage system. [source2](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#how-azure-monitor-logs-works) [source9](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview#data-retention)

A workspace contains tables, and those tables have schemas, table plans, retention settings, and access characteristics that directly affect the usefulness and cost of the logging solution. [source19](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-type-and-schema) [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

Do not equate “send everything to Log Analytics” with a good recommendation, because Microsoft explicitly calls out ingestion and retention as significant cost drivers. [source24](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#pricing-model)

The more exam-relevant approach is to collect the logs that support a business, security, compliance, troubleshooting, or operational requirement, then tune plan and retention by table instead of applying one design to every log type. [source2](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#how-azure-monitor-logs-works) [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

A question that emphasizes near-real-time troubleshooting, cross-table correlation, alerts, dashboards, or continuous monitoring usually points toward Analytics-plan data in a Log Analytics workspace. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan)

A question that emphasizes lower-cost troubleshooting data with single-table queries can point toward Basic logs if the table supports Basic and the data access pattern fits the plan. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

A question that emphasizes verbose, low-touch, audit, or compliance data can point toward Auxiliary logs if the data is DCR-based custom data and does not require real-time analysis. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

A question that emphasizes retaining data for years should make you think about total retention and long-term retention in Log Analytics, not only about Storage account archiving. [source9](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview#data-retention) [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention) [source28](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#log-data-retention)

## 3. Log source categories you should recognize

### 3.1 Azure Activity Log

The Azure Activity Log records management operations for Azure resources, such as creating a virtual machine, changing a Key Vault access policy, or seeing Resource Manager deployment errors. [source30](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#activity-log-entries)

These management operations are control-plane operations, which means they describe actions against the Azure Resource Manager control plane rather than operations performed inside the resource’s data plane. [source30](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#activity-log-entries)

Activity Log entries are collected automatically and do not require a diagnostic setting for the initial 90-day availability period. [source30](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#activity-log-entries) [source31](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#retention-period)

Activity Log entries typically result from create, update, delete, or initiated action operations, and they generally do not capture read operations. [source30](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#activity-log-entries)

Azure retains Activity Log events for 90 days and then deletes them unless you collect them in another location for longer retention or additional functionality. [source31](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#retention-period)

For a logging solution, Activity Log is the baseline source for subscription-level audit and change tracking, especially when the scenario asks who changed an Azure resource or why a deployment failed. [source30](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#activity-log-entries) [source31](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#retention-period)

If the requirement is to correlate Activity Log data with other logs or retain it beyond 90 days, sending the Activity Log to a Log Analytics workspace is a common design choice. [source32](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#export-activity-log)

Activity Log data stored in Log Analytics is stored in the `AzureActivity` table. [source32](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#export-activity-log)

### 3.2 Azure resource logs

Azure resource logs describe operations performed within an Azure resource, and the content varies by resource type. [source33](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collecting-resource-logs)

Resource logs are different from the Activity Log because resource logs capture resource-level or data-plane behavior rather than Azure management-plane changes. [source30](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#activity-log-entries) [source33](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collecting-resource-logs)

Resource logs are not collected by default, so the logging solution must account for enabling collection on the relevant resources. [source33](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collecting-resource-logs)

The resource logs available from each service are described by categories and service-specific schemas, so the recommendation should identify which categories are useful for the scenario. [source35](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs-schema#top-level-common-schema) [source36](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs-schema#service-specific-schemas)

Resource logs share a common top-level schema when sent to Storage or Event Hubs, but column names can differ when records are sent to a Log Analytics workspace. [source35](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs-schema#top-level-common-schema)

When resource logs are sent to Log Analytics, resource-specific mode writes data to individual tables for each selected log category, while Azure diagnostics mode writes all data into the legacy `AzureDiagnostics` table. [source34](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collection-mode)

Microsoft recommends using resource-specific mode for new diagnostic settings where the choice is available because it improves schema discoverability, query usability, performance, and table-level RBAC support. [source34](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collection-mode)

For exam design questions, resource-specific mode is usually the better answer when the scenario values clean schemas, query performance, and granular access by table. [source34](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collection-mode) [source17](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-access-control)

Azure diagnostics mode remains relevant for services that still use it or older configurations, but it is a legacy pattern and can create a broad schema in `AzureDiagnostics`. [source34](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collection-mode)

### 3.3 Microsoft Entra ID logs

Microsoft Entra ID produces identity activity logs such as audit logs, sign-in logs, and provisioning logs. [source4](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#log-data-from-microsoft-entra-id) [source62](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-diagnostic-settings-logs-options#activity-log-options)

Audit logs capture changes to applications, groups, users, and licenses in the tenant. [source62](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-diagnostic-settings-logs-options#activity-log-options)

Sign-in logs capture interactive user sign-ins, including events generated when users enter credentials or satisfy MFA challenges. [source62](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-diagnostic-settings-logs-options#activity-log-options)

Provisioning log data can be queried in Log Analytics through the `AADProvisioningLogs` table after activity logs are sent to a workspace. [source64](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-analyze-activity-logs-log-analytics#query-activity-logs)

Microsoft Entra diagnostic settings can send activity logs to a Log Analytics workspace, stream them to an event hub, archive them to a storage account, or send them to partner solutions. [source63](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-configure-diagnostic-settings#select-the-logs-and-destination)

For this task, focus on the fact that Entra logs are a major identity log source that may need long-term retention, correlation with Azure and application data, and access controls aligned with identity and security teams. [source4](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#log-data-from-microsoft-entra-id) [source64](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-analyze-activity-logs-log-analytics#query-activity-logs) [source17](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-access-control)

A design question that asks for identity investigation across sign-ins, audit changes, and provisioning activity should make you think about sending the relevant Microsoft Entra log categories into Log Analytics. [source4](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#log-data-from-microsoft-entra-id) [source62](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-diagnostic-settings-logs-options#activity-log-options) [source64](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-analyze-activity-logs-log-analytics#query-activity-logs)

Microsoft Entra activity log schemas can differ between Microsoft Graph and Azure Monitor, so a logging design that depends on specific fields should account for the schema used by the destination. [source65](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-activity-log-schemas#what-is-a-log-schema)

Correlation IDs appear in Microsoft Entra log schemas and can help correlate activities for troubleshooting, but their presence does not automatically mean every service log can be joined across all services. [source65](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-activity-log-schemas#what-is-a-log-schema)

### 3.4 Guest operating system logs from VMs

Azure VMs emit Activity Log and platform metrics like other Azure resources, but guest operating system logs require an agent because the Azure platform cannot otherwise see inside the OS. [source6](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#virtual-machine-data) [source37](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#data-collection)

Azure Monitor Agent collects monitoring data from the guest operating system of Azure and hybrid VMs and delivers that data to Azure Monitor and services such as Microsoft Sentinel and Microsoft Defender for Cloud. [source37](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#data-collection)

Azure Monitor Agent is the supported agent for collecting guest OS data in Azure Monitor. [source37](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#data-collection)

For Windows VMs, common guest log data includes Windows Event Logs, performance data, file-based logs, and IIS logs. [source38](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#supported-services-and-features)

For Linux VMs, common guest log data includes Syslog, performance data, and file-based logs. [source38](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#supported-services-and-features)

Azure Monitor Agent collects data according to data collection rules, and those rules define what data is collected, how it is processed, and where it is sent. [source37](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#data-collection)

A design question that asks for Windows Event Logs, Syslog, or custom application text logs from VMs should make you think about Azure Monitor Agent plus DCRs. [source6](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#virtual-machine-data) [source37](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#data-collection) [source50](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#configure-custom-text-file-data-source)

Hybrid or on-premises VMs can use Azure Monitor Agent when they are enabled through Azure Arc, which lets the same guest log approach cover Azure and non-Azure servers. [source38](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#supported-services-and-features)

### 3.5 Application logs and telemetry

Application monitoring in Azure Monitor is done with Application Insights, which collects data from applications running in Azure, another cloud, or on-premises. [source5](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#application-data) [source54](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview#set-up-data-collection)

Application Insights collects metrics and logs related to application performance and operation and stores them in the Azure Monitor data platform. [source5](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#application-data)

Operational application log data can include page views, application requests, exceptions, traces, dependency information, and correlated transaction data. [source5](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#application-data) [source56](https://learn.microsoft.com/en-us/azure/azure-monitor/app/data-model-complete#types-of-telemetry)

Workspace-based Application Insights integrates with Log Analytics and sends telemetry to a common Log Analytics workspace, which consolidates logs and supports unified Azure RBAC. [source55](https://learn.microsoft.com/en-us/azure/azure-monitor/app/create-workspace-resource#create-an-application-insights-resource)

Application Insights stores application log records in the `traces` table for legacy reasons, while Log Analytics table names for Application Insights data include tables such as `AppTraces`, `AppRequests`, `AppExceptions`, and `AppDependencies`. [source56](https://learn.microsoft.com/en-us/azure/azure-monitor/app/data-model-complete#types-of-telemetry) [source57](https://learn.microsoft.com/en-us/azure/azure-monitor/app/data-model-complete#trace-telemetry)

A design question that asks about application diagnostics, exceptions, request failures, or dependencies should make you think about Application Insights and workspace-based storage rather than only resource logs. [source5](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#application-data) [source54](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview#set-up-data-collection) [source56](https://learn.microsoft.com/en-us/azure/azure-monitor/app/data-model-complete#types-of-telemetry)

A question that emphasizes application code instrumentation should point toward OpenTelemetry-based collection where supported. [source54](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview#set-up-data-collection)

A question that emphasizes consolidating application telemetry with infrastructure logs should point toward workspace-based Application Insights tied to an appropriate Log Analytics workspace. [source55](https://learn.microsoft.com/en-us/azure/azure-monitor/app/create-workspace-resource#create-an-application-insights-resource)

### 3.6 Kubernetes logs

AKS clusters generate Activity Log and platform metrics like other Azure resources, but they also generate cluster logs and metrics that can be collected from AKS and Arc-enabled Kubernetes clusters. [source7](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#kubernetes-cluster-data)

For AKS logging, standard Kubernetes logs include events for the cluster, nodes, deployments, and workloads. [source7](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#kubernetes-cluster-data)

Container insights can send Kubernetes logs to a Log Analytics workspace. [source7](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#kubernetes-cluster-data)

A design question that asks for container or Kubernetes logs should point toward Container insights and Log Analytics for logs, while keeping managed Prometheus and metrics in mind only if the question shifts toward metrics. [source7](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#kubernetes-cluster-data)

Because this exam task is about logging, the key AKS detail is that the design must distinguish logs from metrics and select the log collection path accordingly. [source7](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#kubernetes-cluster-data) [source1](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305#design-solutions-for-logging-and-monitoring)

### 3.7 Custom and third-party logs

Custom data sources outside Azure usually require custom collection methods. [source8](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#custom-sources)

The Logs Ingestion API lets you send data to a Log Analytics workspace by REST API or client libraries. [source46](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#basic-operation)

The Logs Ingestion API can send data to supported Azure tables or custom tables that you create. [source46](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#basic-operation)

The API uses a DCR to define the target table, workspace, incoming structure, transformation, and processing behavior. [source46](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#basic-operation) [source47](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#configuration)

The request body sent to the API must be a JSON array with item structure matching what the stream in the DCR expects. [source49](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#request-body)

For custom application or third-party logs that can call a REST endpoint, the Logs Ingestion API is the modern answer instead of the legacy HTTP Data Collector API. [source39](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#data-collection-process) [source46](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#basic-operation)

For applications on VMs that write local text files, Azure Monitor Agent can collect custom text logs through a Custom Text Logs data source in a DCR. [source50](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#configure-custom-text-file-data-source)

Custom text logs can only be sent to a Log Analytics workspace and stored in a custom table you create. [source51](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#add-destinations) [source53](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#log-analytics-workspace-table)

A design question that asks for local application log files on VMs should point toward AMA custom text log collection, while a design question that asks for arbitrary external JSON ingestion should point toward the Logs Ingestion API. [source50](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#configure-custom-text-file-data-source) [source46](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#basic-operation)

## 4. Collection methods and how to choose them

### 4.1 Diagnostic settings for Azure resource logs and identity logs

Diagnostic settings are still used to collect resource logs from Azure resources. [source39](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#data-collection-process) [source33](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collecting-resource-logs)

For Azure resources, diagnostic settings can send logs to a Log Analytics workspace, Storage account, Event Hubs, or partner integrations, but the logging-solution decision should start with what categories and schemas are needed. [source33](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collecting-resource-logs) [source36](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs-schema#service-specific-schemas)

For Microsoft Entra ID, diagnostic settings can select log categories and destinations, including Log Analytics, Event Hubs, Storage, and partner solutions. [source63](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-configure-diagnostic-settings#select-the-logs-and-destination)

A question that asks “collect Azure SQL auditing logs into a queryable platform” or “retain Key Vault access logs for investigations” should make you identify the service-specific resource log categories and send them to Log Analytics if interactive query and correlation are required. [source33](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collecting-resource-logs) [source36](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs-schema#service-specific-schemas)

A question that asks “keep logs for archive only” may introduce Storage account as a routing destination, but that is more directly part of the adjacent log-routing task unless the scenario is about retention architecture. [source1](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305#design-solutions-for-logging-and-monitoring) [source33](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collecting-resource-logs)

### 4.2 Azure Monitor Agent for guest OS logs

Azure Monitor Agent is installed on VMs in Azure, other clouds, or on-premises where it has access to local logs and performance data. [source37](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#data-collection)

Without the agent, Azure Monitor can collect only host-level data and cannot collect guest OS logs or process-level local data from the VM. [source37](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#data-collection)

DCRs associated with the agent determine which logs are collected and where they are sent. [source37](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#data-collection) [source39](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#data-collection-process)

DCR associations create a many-to-many relationship where a single DCR can be associated with multiple resources and a single resource can be associated with up to 30 DCRs. [source40](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#data-collection-rule-associations-dcras)

This matters for design because you can create reusable DCRs by workload class, environment, operating system, or compliance scope. [source40](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#data-collection-rule-associations-dcras)

For exam scenarios, choose AMA plus DCR when the required source is Windows Event Logs, Syslog, IIS logs, file-based logs, or other guest data on Azure or Arc-enabled machines. [source38](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#supported-services-and-features)

### 4.3 DCRs as the collection control plane

DCRs are part of an ETL-like data collection process that improves on legacy Azure Monitor collection methods. [source39](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#data-collection-process)

DCRs provide a consistent configuration method for multiple data sources. [source39](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#data-collection-process)

DCRs can apply transformations that filter or modify incoming data before the data is stored or sent to a destination. [source43](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#transformations)

DCRs support infrastructure-as-code and DevOps-oriented deployment patterns, which makes them important for repeatable logging designs at scale. [source39](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#data-collection-process)

In an AMA scenario, the DCR specifies events and performance data to collect, and transformations can filter or modify data before sending it to the specified workspace and table. [source41](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#azure-monitor-agent-ama)

In a direct ingestion scenario, each API call specifies a DCR that understands the incoming structure, applies the transformation, and sends the data to the target workspace and table. [source42](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#direct-ingestion)

DCR transformations can reduce ingestion cost by filtering unneeded data, remove sensitive data before it is persisted, or shape data so it matches the destination schema. [source43](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#transformations)

For AZ-305 design thinking, DCRs are not just implementation details; they are how you make collection consistent, controlled, scalable, and cost-aware. [source39](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#data-collection-process) [source43](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#transformations)

### 4.4 Data collection endpoints

A data collection endpoint defines endpoints related to data collection, configuration, and ingestion in Azure Monitor. [source44](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-endpoint-overview#when-is-a-dce-required)

A DCE is not always required because some sources use public endpoints or ingestion endpoints generated in the DCR. [source44](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-endpoint-overview#when-is-a-dce-required)

For AMA, a DCE is required when using private link and for certain data sources that require it. [source44](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-endpoint-overview#when-is-a-dce-required)

For the Logs Ingestion API, a DCR can include its own `logsIngestion` endpoint, and a DCE is required when sending data to a Log Analytics workspace configured for private link. [source44](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-endpoint-overview#when-is-a-dce-required) [source46](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#basic-operation)

DCE components include a logs ingestion endpoint, a metrics ingestion endpoint, and a configuration access endpoint. [source45](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-endpoint-overview#components-of-a-dce)

A design question that mentions private connectivity or Azure Monitor Private Link Scope may require DCE awareness, but a basic public ingestion scenario might not. [source44](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-endpoint-overview#when-is-a-dce-required)

## 5. Workspace architecture decisions

### 5.1 Start with one workspace unless requirements justify more

Microsoft’s workspace design guidance says to start with a single workspace to reduce management and query complexity. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

There are no performance limitations from the amount of data in a workspace. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

Multiple services and data sources can send data to the same workspace. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

As requirements justify additional workspaces, the design should still use the fewest workspaces needed to meet those requirements. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

This is an important exam pattern because “one workspace per resource” is rarely the best default answer. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

A better design answer evaluates criteria independently because region, egress, commitment tiers, security separation, billing, and ownership can conflict. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

### 5.2 Separate workspaces by operational and security requirements when justified

Organizations may combine operational data from Azure Monitor and security data from Microsoft Sentinel in one workspace or separate them into dedicated workspaces. [source12](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#operational-and-security-data)

Dedicated workspaces can segregate data ownership between operations and security teams. [source12](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#operational-and-security-data)

A workspace with Microsoft Sentinel enabled makes all data in that workspace subject to Sentinel pricing, even if the data is operational data collected by Azure Monitor. [source12](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#operational-and-security-data) [source29](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#workspaces-with-microsoft-sentinel)

A combined workspace can provide better visibility across operational and security data and can make it easier to combine data in queries and workbooks. [source12](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#operational-and-security-data)

A combined workspace can also help reach a commitment tier when the combined ingestion volume is high enough. [source12](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#operational-and-security-data) [source26](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#commitment-tiers)

If the scenario says the SOC must own and isolate security data, choose a dedicated security workspace. [source12](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#operational-and-security-data) [source17](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-access-control)

If the scenario says the organization needs broad cross-domain visibility and has no hard separation requirement, a combined workspace may be a stronger choice. [source12](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#operational-and-security-data)

If the scenario says Sentinel is enabled and operational logs would become expensive under Sentinel pricing, separating operational and security data can be justified. [source12](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#operational-and-security-data) [source29](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#workspaces-with-microsoft-sentinel)

### 5.3 Separate by tenant when needed

If an organization has multiple Azure tenants, the normal design is to create a workspace in each tenant. [source13](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#azure-tenants)

Many Azure resources can send monitoring data only to a workspace in the same Azure tenant. [source13](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#azure-tenants)

Virtual machines using Azure Monitor Agent can send data to workspaces in separate tenants, but the general design still needs to account for tenant boundaries. [source13](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#azure-tenants)

For AZ-305, a multi-tenant scenario should make you question whether a single central workspace is possible for every source type. [source13](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#azure-tenants)

### 5.4 Separate by region or geography when data residency requires it

Each Log Analytics workspace resides in a particular Azure region. [source14](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#azure-regions)

Regulatory or compliance requirements may require log data to be stored in specific geographies. [source14](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#azure-regions)

If a scenario requires keeping data in a specific geography, create a separate workspace for each region or geography that has such a requirement. [source14](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#azure-regions)

If there is no data residency requirement, a single workspace can be used across regions. [source14](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#azure-regions)

If virtual machine bandwidth charges become significant, regional workspaces can be considered, but this must be balanced against the added complexity of multiple workspaces. [source14](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#azure-regions)

### 5.5 Separate by data ownership or billing when required

A business may require workspaces to be separated by subsidiary, affiliated company, internal business unit, or other ownership boundary. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

A business may also require separate subscriptions or workspaces to support split billing or chargeback. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

Azure Cost Management and log queries can sometimes report charges granularly enough without splitting workspaces. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

If cost reporting by query or Cost Management is sufficient, a single workspace may still be preferable. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

If the scenario requires invoices or ownership boundaries that cannot be met by reporting, separate workspaces can be justified. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

### 5.6 Separate by retention only when table-level retention is not enough

Log Analytics can configure retention at the workspace level and at the table level. [source15](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-retention) [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

If different datasets in the same table require different retention periods, you may need separate workspaces because retention is applied at the table or workspace level rather than per arbitrary subset of records. [source15](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-retention)

If each table can have the appropriate retention period, a single workspace can often satisfy different retention requirements. [source15](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-retention) [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

This exam pattern is subtle because “different retention requirements” does not automatically mean “multiple workspaces” if table-level settings are sufficient. [source15](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-retention) [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

### 5.7 Consider commitment tiers when ingestion is predictable

Commitment tiers reduce ingestion cost when you commit to a daily ingestion amount in a workspace. [source16](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#commitment-tiers) [source26](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#commitment-tiers)

A single workspace can help an organization reach a commitment tier that smaller separated workspaces could not reach. [source16](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#commitment-tiers)

Commitment tiers start at 100 GB per day for workspace-level commitment pricing. [source26](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#commitment-tiers)

If ingestion across multiple workspaces is at least 100 GB per day, a dedicated cluster can allow workspaces in the cluster to share commitment-tier benefits. [source16](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#commitment-tiers)

A design scenario with predictable high-volume ingestion should make you consider whether consolidation reduces cost. [source16](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#commitment-tiers) [source26](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#commitment-tiers)

### 5.8 Design for access control before placing data

When a user is granted access to a workspace, the user can access all data in the workspace unless resource-context, table-level, or granular RBAC controls constrain access. [source17](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-access-control) [source58](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-mode)

Resource-context RBAC lets users with read access to an Azure resource view that resource’s monitoring data without explicit workspace access, depending on the workspace access control mode. [source17](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-access-control) [source58](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-mode) [source59](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-control-mode)

Table-level RBAC can grant or deny access to specific tables in a workspace. [source17](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-access-control)

Granular RBAC is Microsoft’s recommended method for table and row-level access control. [source61](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#set-granular-rbac)

If the scenario requires operations users to view only operational logs and security users to view security logs, the solution might use separate workspaces, table-level RBAC, or granular RBAC depending on the sensitivity and administrative model. [source17](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-access-control) [source60](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#azure-rbac) [source61](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#set-granular-rbac)

If the scenario requires resource owners to query only logs for resources they manage, resource-context access is a key design option. [source58](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-mode) [source59](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-control-mode)

### 5.9 Design for resilience only for critical data

To make critical workspace data available during a regional failure, you can ingest some or all data into multiple workspaces in different regions. [source18](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#resilience)

This resilience pattern increases configuration and management effort because integrations with services and products must be managed separately for each workspace. [source18](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#resilience)

Alerts and workbooks that rely on one workspace do not automatically switch to the alternate workspace during a failure. [source18](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#resilience)

For AZ-305, do not recommend multi-region log duplication by default because it can add complexity and cost. [source18](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#resilience) [source24](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#pricing-model)

Recommend multi-region ingestion only when the scenario explicitly requires log availability during regional failure for critical data. [source18](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#resilience)

## 6. Tables, table plans, and schema design

### 6.1 Tables are where the design becomes practical

A Log Analytics workspace consists of tables, and table configuration lets you manage the data model, access, and log-related costs. [source19](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-type-and-schema)

A table schema is the set of columns into which Azure Monitor Logs collects data from one or more data sources. [source19](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-type-and-schema)

Azure tables are created automatically based on Azure services you use and diagnostic settings you configure. [source19](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-type-and-schema)

Custom tables are used for non-Azure resources and other data sources, such as file-based logs. [source19](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-type-and-schema)

Search results tables are created by search jobs and use the schema produced by the search query. [source19](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-type-and-schema)

Restored logs tables have the same schema as the source table from which logs were restored. [source19](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-type-and-schema)

The table type matters because it affects schema control, access, query behavior, and whether the table can use certain plans. [source19](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-type-and-schema) [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan)

### 6.2 Choose Analytics for high-value interactive data

The Analytics plan is suited for continuous monitoring, real-time detection, and performance analytics. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan)

Analytics-plan data supports interactive multi-table queries and use by features and services for 30 days to two years. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

Analytics is the default table plan for tables created in the portal. [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

Use Analytics for data that you expect to query frequently, correlate across multiple tables, alert on, investigate in near real time, or use in dashboards and operational workflows. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source2](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#how-azure-monitor-logs-works)

Exam scenarios that mention “near real time,” “cross-correlation,” “alerting,” “operations team,” “developer troubleshooting,” or “security investigation” usually favor Analytics-plan data. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source2](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#how-azure-monitor-logs-works)

### 6.3 Choose Basic for lower-cost troubleshooting data with limited query needs

The Basic plan is suited for troubleshooting and incident response. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan)

Basic logs offer discounted ingestion and optimized single-table queries for 30 days. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan)

Only certain tables support the Basic plan, and the table plan dropdown is enabled only for tables that support Basic logs. [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

You can switch a table between Analytics and Basic only once a week. [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

Basic logs are a good fit when you need lower-cost ingestion and occasional single-table queries, but they are not the best fit for broad, continuous, multi-table analytics. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan)

In exam terms, Basic is usually a middle option between high-value Analytics data and low-touch Auxiliary data. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan)

### 6.4 Choose Auxiliary for low-touch audit and compliance data

The Auxiliary plan is suited for low-touch data such as verbose logs and data required for auditing and compliance. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan)

Auxiliary offers low-cost ingestion and unoptimized single-table queries for the full retention period. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan)

Auxiliary can be set only when creating a custom table by using the API. [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

Built-in Azure tables do not currently support the Auxiliary plan. [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

After a table is created with the Auxiliary plan, its plan cannot be switched. [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

Auxiliary is a strong exam answer when the scenario says the data is verbose, rarely queried, required for audit or compliance, and can live in a DCR-based custom table. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

Auxiliary is a weak answer when the scenario requires optimized near-real-time analytics, broad query features, or built-in Azure resource tables. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

### 6.5 Prefer resource-specific resource log tables for new resource log designs

Resource-specific mode creates individual tables for each selected log category. [source34](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collection-mode)

Resource-specific logs are easier to query, have better schema discoverability, improve performance for ingestion latency and query times, and support Azure RBAC rights on specific tables. [source34](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collection-mode)

Azure diagnostics mode writes all diagnostic setting data to the `AzureDiagnostics` table and is considered a legacy method used by a minority of services. [source34](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collection-mode)

If a new diagnostic setting offers a collection mode choice, Microsoft says to specify resource-specific mode. [source34](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collection-mode)

For AZ-305, resource-specific mode is the more architecturally correct recommendation for new designs unless the service does not offer the choice. [source34](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collection-mode)

## 7. Retention design

### 7.1 Understand analytics retention, long-term retention, and total retention

A Log Analytics workspace retains data in two states: analytics retention and long-term retention. [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

During analytics retention, data is available for monitoring, troubleshooting, and near-real-time analytics. [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

During long-term retention, data is stored at lower cost and is accessed through search jobs rather than normal interactive table-plan features. [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

By default, all tables retain data for 30 days except log tables with 90-day default retention. [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

Analytics-plan tables make data available for real-time queries during the analytics retention period. [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

Analytics retention can be extended up to two years for Analytics-plan tables. [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

To retain data in the same table beyond the analytics retention period, extend total retention up to 12 years. [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

At the end of the analytics retention period, data remains in the table for the rest of the configured total retention period. [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

A search job can retrieve specific long-term-retained data and make it available for interactive query in a search results table. [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

### 7.2 Use table-level retention to match data value

The default retention period of Analytics tables in a workspace is 30 days. [source23](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#configure-the-default-analytics-retention-period-of-analytics-tables)

You can change the default analytics period for Analytics tables up to two years at the workspace level. [source23](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#configure-the-default-analytics-retention-period-of-analytics-tables)

Changing the workspace-level default affects Analytics tables still using the default setting but does not affect tables whose analytics retention has already been changed. [source23](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#configure-the-default-analytics-retention-period-of-analytics-tables)

Basic and Auxiliary tables have a total retention period that is 30 days by default. [source23](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#configure-the-default-analytics-retention-period-of-analytics-tables)

Retention should be driven by investigation needs, compliance requirements, and expected query frequency. [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention) [source28](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#log-data-retention)

A common design is to keep high-value operational data in analytics retention for the period it is actively investigated and use long-term retention for data that must be preserved but is rarely queried. [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention) [source28](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#log-data-retention)

### 7.3 Know when retention points to a workspace split

If all resources sending data to a table can share the same table retention setting, keep the design simpler with one workspace. [source15](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-retention)

If different resources need different retention settings for the same table, separate workspaces may be required. [source15](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-retention)

This distinction matters because retention settings are not a per-resource property inside one shared table. [source15](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-retention)

For exam questions, read retention wording carefully and determine whether different table-level settings solve the problem before selecting multiple workspaces. [source15](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-retention) [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

### 7.4 Use long-term retention instead of defaulting to Storage archive

Azure Monitor Logs supports long-term retention in the same workspace for up to 12 years. [source9](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview#data-retention) [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

Long-term retention allows you to manage log data in one place without moving it to external storage. [source9](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview#data-retention)

During long-term retention, there is a reduced retention charge and a charge to retrieve data using a search job. [source28](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#log-data-retention)

Storage account archiving remains a possible destination for diagnostic settings, but long-term retention is often the more integrated answer when the requirement is “retain logs and query them when needed.” [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention) [source28](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#log-data-retention) [source33](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collecting-resource-logs)

If the scenario emphasizes immutable archive, external compliance storage, or downstream systems, the adjacent routing task may become more important. [source1](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305#design-solutions-for-logging-and-monitoring) [source33](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collecting-resource-logs)

## 8. Cost design

### 8.1 Know the main cost drivers

The most significant charges for many Azure Monitor implementations are ingestion and retention in Log Analytics workspaces. [source24](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#pricing-model)

Log Analytics pay-as-you-go pricing is based on ingested data volume and data retention. [source24](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#pricing-model)

Each Log Analytics workspace is charged as a separate service and contributes to the Azure subscription bill. [source24](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#pricing-model)

The amount of data ingested depends on the enabled solutions, the number and type of monitored resources, and the types of data collected from each resource. [source24](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#pricing-model)

A logging solution should avoid collecting more data than the requirement needs. [source3](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#azure-resources) [source24](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#pricing-model)

### 8.2 Understand billed data size

Azure Monitor Logs bills for the amount of data sent to a Log Analytics workspace in GB. [source25](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#data-size-calculation)

For Analytics and Basic logs, billed size is calculated from a string representation of the columns Azure Monitor must write to the workspace. [source25](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#data-size-calculation)

For Auxiliary logs, billed size is calculated as the uncompressed size of the column entries written to the workspace. [source25](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#data-size-calculation)

Billable size includes data from the source and data added during ingestion, such as custom columns added by Logs Ingestion API, transformations, and custom fields. [source25](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#data-size-calculation)

If incoming columns do not match the destination table schema, Azure Monitor Logs can bill for column entries even when the destination table cannot store them. [source25](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#data-size-calculation)

DCRs should match the destination table schema to avoid being charged for data that cannot be stored. [source25](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#data-size-calculation) [source43](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#transformations)

### 8.3 Use table plans as a cost lever

Analytics data has standard ingestion cost and query cost included. [source2](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs#how-azure-monitor-logs-works) [source27](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#basic-and-auxiliary-table-plans)

Basic and Auxiliary table plans have reduced ingestion charges, but queries against those tables are charged based on data scanned. [source27](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#basic-and-auxiliary-table-plans)

Long-term retention and search jobs have the same charges across Analytics, Basic, and Auxiliary table plans. [source27](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#basic-and-auxiliary-table-plans)

Use Analytics for high-value interactive data and consider Basic or Auxiliary when the data is lower-touch and the access pattern fits the restrictions. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source27](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#basic-and-auxiliary-table-plans)

Do not choose Basic or Auxiliary only because they are cheaper, because feature support, query pattern, table support, and ingestion method can make them unsuitable. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan) [source27](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#basic-and-auxiliary-table-plans)

### 8.4 Use transformations to reduce noise before storage

DCR transformations run against records received and can modify incoming data before it is stored or sent to a destination. [source43](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#transformations)

Transformations can filter unneeded data to reduce ingestion costs. [source43](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#transformations)

Transformations can remove sensitive data that should not be persisted in the workspace. [source43](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#transformations)

Transformations can format data so that it matches the schema of the destination table. [source43](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#transformations)

For custom logs, DCR transformations are often a design tool for both cost optimization and data quality. [source43](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#transformations) [source46](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#basic-operation)

### 8.5 Avoid duplicate ingestion

Duplicate data sent to multiple workspaces can create extra charges. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

Microsoft specifically warns that duplicate data to multiple workspaces should be avoided, even though some scenarios involve agents connected to separate operational and security workspaces. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

When a scenario asks for resilience or multi-team access, consider whether table-level RBAC, resource-context access, or a single shared workspace solves the requirement before duplicating logs. [source17](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-access-control) [source18](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#resilience) [source58](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-mode)

If multi-region availability is a hard requirement, duplicate ingestion may be justified for critical data. [source18](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#resilience)

## 9. Access, security, and governance

### 9.1 Understand workspace-context and resource-context access

Workspace-context access lets a user view all logs in the workspace for which the user has permission. [source58](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-mode)

Resource-context access lets a user view logs only for a specific resource, resource group, or subscription that the user can access. [source58](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-mode)

Resource-context access lets application teams focus on their resources without needing explicit access to the entire workspace. [source58](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-mode)

Workspace-context access is appropriate for central administrators who need access across many resources and data types. [source58](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-mode)

If the question describes centralized operations or security administrators, workspace-context permissions may be appropriate. [source58](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-mode)

If the question describes application owners who should see only their own resource logs, resource-context access is usually the better design concept. [source58](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-mode)

### 9.2 Understand workspace access control mode

Each workspace has an access control mode that determines how permissions are applied. [source59](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-control-mode)

The `Require workspace permissions` mode requires users to be granted workspace or table permissions to access workspace data. [source59](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-control-mode)

The `Use resource or workspace permissions` mode allows users with read access to a resource to access data associated with that resource when using resource-context access. [source59](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-control-mode)

Workspaces created after March 2019 default to `Use resource or workspace permissions`. [source59](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-control-mode)

A design question that says resource owners should query only their own resource logs without explicit workspace access should point toward resource-context access with the appropriate access control mode. [source58](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-mode) [source59](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-control-mode)

### 9.3 Understand roles and least privilege

Access to a workspace is managed with Azure RBAC. [source60](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#azure-rbac)

The Log Analytics Data Reader role provides minimum permissions to run queries and see metadata, and it is suited for granular RBAC scenarios with table and row-level control. [source60](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#azure-rbac)

The Log Analytics Reader role can view monitoring data and monitoring settings, including diagnostics configuration. [source60](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#azure-rbac)

The Log Analytics Contributor role can edit monitoring settings, configure diagnostic settings, and perform broader workspace-related actions. [source60](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#azure-rbac)

Log Analytics Contributor includes permissions that can add VM extensions, which Microsoft warns can allow full control over a virtual machine. [source60](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#azure-rbac)

For AZ-305, recommend the least privileged role that supports the needed log query or configuration task. [source60](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#azure-rbac) [source61](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#set-granular-rbac)

### 9.4 Use table and granular RBAC when data sensitivity differs

Table-level RBAC can grant or deny access to specific tables in a workspace. [source17](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-access-control)

Granular RBAC is the recommended method for table and row-level access control. [source61](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#set-granular-rbac)

If a single workspace stores both operational and sensitive security data, table-level or granular RBAC can reduce the need for separate workspaces when separation is primarily about access. [source17](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-access-control) [source61](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#set-granular-rbac)

If the requirement is legal, regulatory, tenant-level, or ownership isolation, separate workspaces may still be the better design. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy) [source12](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#operational-and-security-data) [source13](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#azure-tenants)

For exam questions, match the isolation mechanism to the requirement: resource-context for resource ownership, table/granular RBAC for data-type boundaries, and workspace separation for stronger administrative or billing boundaries. [source17](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-access-control) [source58](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-mode) [source61](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#set-granular-rbac)

## 10. Custom log design patterns

### 10.1 REST-based custom ingestion

Use the Logs Ingestion API when an application, service, or pipeline can send JSON records to Azure Monitor by REST API or client libraries. [source46](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#basic-operation)

Before using the API, configure an app registration and secret or credential, a destination table, and a DCR. [source47](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#configuration)

The app registration authenticates the API call and must be granted permissions to the DCR. [source47](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#configuration)

The destination table must exist before data can be sent to it. [source47](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#configuration)

The DCR defines the structure of the incoming data, the target table and workspace, and any transformation needed to align the incoming data with the destination table. [source47](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#configuration) [source48](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#data-collection-rule-dcr)

The REST API call uses a URI that includes the endpoint, DCR immutable ID, stream name, and API version. [source46](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#basic-operation)

The request body must be a JSON array and must be encoded properly. [source49](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#request-body)

For design, the Logs Ingestion API is best when you control the producer or can build an integration that sends structured records. [source46](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#basic-operation) [source47](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#configuration)

### 10.2 VM text-file log collection

Use custom text log collection when an application or service on a VM writes log information to local text files instead of Windows Event Log or Syslog. [source50](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#configure-custom-text-file-data-source)

The Custom Text Logs data source in a DCR identifies the file pattern, destination table, record delimiter, timestamp format, and optional transformation. [source50](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#configure-custom-text-file-data-source)

The file pattern identifies the local disk path and file names that the agent monitors. [source50](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#configure-custom-text-file-data-source)

The destination table must already exist in the Log Analytics workspace. [source53](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#log-analytics-workspace-table)

The table must include `TimeGenerated` and either `RawData` or parsed columns created by a transformation. [source53](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#log-analytics-workspace-table)

Text files must use ASCII or UTF-8 encoding. [source52](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#text-file-requirements-and-best-practices)

New records should be appended to the end of the file because overwriting records can cause data loss. [source52](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#text-file-requirements-and-best-practices)

You should avoid monitoring too many directories or accumulating too many files because this can create performance problems for the agent. [source52](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#text-file-requirements-and-best-practices)

This design is best when the log producer is a VM-local application that cannot easily call the Logs Ingestion API but can write stable local files. [source50](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#configure-custom-text-file-data-source) [source52](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#text-file-requirements-and-best-practices)

### 10.3 Schema shaping and parsing

Custom log design should define the destination schema before ingestion. [source47](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#configuration) [source53](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#log-analytics-workspace-table)

If raw data is sufficient, you can store each log entry in a `RawData` column. [source53](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#log-analytics-workspace-table)

If structured query is needed, use transformations to parse fields into typed columns before the data lands in the table. [source50](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#configure-custom-text-file-data-source) [source53](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#log-analytics-workspace-table)

For delimited text logs, transformations can use parsing functions to split data into separate columns and set `TimeGenerated` from the log entry. [source50](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#configure-custom-text-file-data-source)

A design that requires fast, reliable querying should favor well-structured columns over storing everything as unparsed raw text. [source53](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#log-analytics-workspace-table) [source43](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#transformations)

## 11. Exam decision patterns

### 11.1 “We need to know who changed Azure resources.”

The primary source is the Azure Activity Log because it records Azure resource management operations. [source30](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#activity-log-entries)

If 90 days is enough, the automatically retained Activity Log may satisfy the retention requirement. [source31](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#retention-period)

If longer retention or correlation with other logs is required, send Activity Log data to a Log Analytics workspace. [source31](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#retention-period) [source32](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#export-activity-log)

### 11.2 “We need to analyze operations inside a resource.”

The primary source is Azure resource logs because they provide insight into operations performed within an Azure resource. [source33](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collecting-resource-logs)

Resource logs are not collected by default, so the solution must enable collection for the relevant service and categories. [source33](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collecting-resource-logs)

If the service supports resource-specific mode, use it for new designs because it provides cleaner tables, better schema discoverability, better query performance, and table-level RBAC support. [source34](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collection-mode)

### 11.3 “We need Windows Event Logs or Syslog from VMs.”

Use Azure Monitor Agent because it collects guest OS data from Azure and hybrid VMs. [source37](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#data-collection)

Use DCRs to define which events are collected and where the data is sent. [source37](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#data-collection) [source39](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#data-collection-process)

For hybrid VMs, ensure the machines can be managed through Azure Arc if they are outside Azure. [source38](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#supported-services-and-features)

### 11.4 “We need application exceptions, traces, requests, and dependencies.”

Use Application Insights because it collects application telemetry and supports OpenTelemetry-based instrumentation for supported scenarios. [source54](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview#set-up-data-collection)

Use workspace-based Application Insights when the design requires consolidated logs in a Log Analytics workspace and unified Azure RBAC. [source55](https://learn.microsoft.com/en-us/azure/azure-monitor/app/create-workspace-resource#create-an-application-insights-resource)

Expect relevant data in Log Analytics tables such as `AppTraces`, `AppRequests`, `AppExceptions`, and `AppDependencies`. [source56](https://learn.microsoft.com/en-us/azure/azure-monitor/app/data-model-complete#types-of-telemetry) [source57](https://learn.microsoft.com/en-us/azure/azure-monitor/app/data-model-complete#trace-telemetry)

### 11.5 “We need low-cost long-term audit storage but occasional query.”

Consider long-term retention in Log Analytics because tables can retain data up to 12 years and retrieve data later using search jobs. [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention)

Consider Auxiliary tables for DCR-based custom data that is verbose, low-touch, and needed for audit or compliance. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

Do not choose Auxiliary for built-in Azure tables because built-in Azure tables do not currently support the Auxiliary plan. [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

### 11.6 “We need one operations team and one security team.”

A combined workspace improves correlation and may help reach a commitment tier. [source12](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#operational-and-security-data) [source16](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#commitment-tiers)

Separate workspaces can segregate ownership and avoid Sentinel pricing on operational data when Sentinel is enabled. [source12](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#operational-and-security-data) [source29](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#workspaces-with-microsoft-sentinel)

Table-level or granular RBAC can help when the main issue is access separation within a combined workspace. [source17](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-access-control) [source61](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#set-granular-rbac)

### 11.7 “We need resource owners to access only their resource logs.”

Use resource-context access so users can query logs associated with resources they can access. [source58](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-mode)

Ensure the workspace access control mode allows resource or workspace permissions. [source59](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-control-mode)

Use table or granular RBAC if the scenario also requires restricting access to particular data types. [source17](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#data-access-control) [source61](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#set-granular-rbac)

### 11.8 “We need to ingest logs from a custom app.”

Use the Logs Ingestion API if the app can send JSON records through REST or client libraries. [source46](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#basic-operation)

Create or select a destination table, define the DCR, and grant the application permissions to the DCR. [source47](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#configuration)

Use transformations to align incoming records to the table schema or filter fields before storage. [source43](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#transformations) [source47](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#configuration)

### 11.9 “We need to ingest local text logs from an application on a VM.”

Use Azure Monitor Agent custom text log collection. [source50](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#configure-custom-text-file-data-source)

Define the file pattern, destination custom table, delimiter or timestamp settings, and optional transformation in the DCR. [source50](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#configure-custom-text-file-data-source)

Ensure the file uses supported encoding and appends new records rather than overwriting old records. [source52](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/data-collection-log-text#text-file-requirements-and-best-practices)

## 12. Common traps

Do not confuse the Activity Log with resource logs because Activity Log records Azure management operations while resource logs capture operations performed within a resource. [source30](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#activity-log-entries) [source33](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collecting-resource-logs)

Do not assume resource logs are collected automatically because they require diagnostic settings. [source33](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collecting-resource-logs)

Do not default to `AzureDiagnostics` for new designs when resource-specific mode is available. [source34](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs#collection-mode)

Do not select Basic or Auxiliary just because they are cheaper, because each plan has query, feature, and table-support constraints. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan) [source27](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#basic-and-auxiliary-table-plans)

Do not create multiple workspaces only because the environment has many resources, because Microsoft recommends starting with a single workspace and using the fewest workspaces that satisfy requirements. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

Do not ignore Microsoft Sentinel pricing when operational data is sent to a Sentinel-enabled workspace. [source12](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#operational-and-security-data) [source29](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#workspaces-with-microsoft-sentinel)

Do not assume all identity log fields behave the same across Microsoft Graph and Azure Monitor schemas. [source65](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-activity-log-schemas#what-is-a-log-schema)

Do not retain all logs interactively for years unless the business requirement justifies the cost, because long-term retention and search jobs are designed for data that is kept but rarely queried. [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention) [source28](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#log-data-retention)

Do not assign Log Analytics Contributor when a reader role or data-reader role is sufficient, because Contributor has broader permissions and can configure diagnostic settings and extensions. [source60](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#azure-rbac)

Do not design custom ingestion without aligning the DCR stream, transformation, and table schema because mismatches can create unusable or billable data. [source25](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#data-size-calculation) [source43](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#transformations) [source47](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#configuration)

## 13. Summary checklist for answering AZ-305 questions

Identify the source type first: Activity Log, resource logs, Entra logs, guest OS logs, application telemetry, Kubernetes logs, or custom logs. [source3](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#azure-resources) [source4](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#log-data-from-microsoft-entra-id) [source5](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#application-data) [source6](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#virtual-machine-data) [source7](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#kubernetes-cluster-data) [source8](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#custom-sources)

Determine whether collection is automatic, diagnostic-setting based, agent-based, Application Insights-based, Container insights-based, or API-based. [source3](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources#azure-resources) [source37](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview#data-collection) [source46](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#basic-operation) [source54](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview#set-up-data-collection)

Choose the workspace design by evaluating tenant, region, data ownership, split billing, retention, commitment tiers, access control, and resilience. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

Prefer a single workspace unless a requirement clearly justifies multiple workspaces. [source11](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design#design-strategy)

Select the table plan based on the access pattern, not only on cost. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

Use Analytics for high-value, interactive, real-time, cross-table, or alerting-oriented data. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan)

Use Basic for supported tables that need lower-cost troubleshooting and optimized single-table queries for 30 days. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

Use Auxiliary for DCR-based custom data that is verbose, low-touch, and needed for audit or compliance. [source20](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables#table-plan) [source21](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans#set-the-table-plan)

Set analytics retention and total retention based on investigation and compliance requirements. [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention) [source23](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#configure-the-default-analytics-retention-period-of-analytics-tables)

Use long-term retention when data must remain in the workspace for years but is rarely queried. [source22](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure?tabs=portal%2Cportal-1#analytics-long-term-and-total-retention) [source28](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#log-data-retention)

Use DCR transformations to filter noise, remove sensitive fields, and shape schema before storage. [source43](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#transformations)

Use access controls that align with the operating model, including workspace-context, resource-context, table-level RBAC, and granular RBAC. [source58](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-mode) [source59](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-control-mode) [source61](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#set-granular-rbac)
