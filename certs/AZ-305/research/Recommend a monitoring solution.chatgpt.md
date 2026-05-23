# AZ-305 Study Guide: Recommend a Logging Solution

[AZ-305 study guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305)

## Purpose

This guide is scoped to the AZ-305 task **Recommend a logging solution** under **Design solutions for logging and monitoring**. It intentionally treats the adjacent tasks **Recommend a solution for routing logs** and **Recommend a monitoring solution** as out of scope.

The focus is not “how do I build every alert, dashboard, or downstream export?” The focus is: **given a business, operational, security, compliance, or cost requirement, what Azure logging architecture should you recommend?**

A good answer for this task usually explains:

- Which log sources must be collected.
- Where those logs should be stored.
- How many Log Analytics workspaces are appropriate.
- Which table plans and retention settings fit the requirement.
- How access to log data should be controlled.
- How custom or non-Azure logs should be ingested.
- How to reduce noise, control costs, and avoid duplicate collection.

## 45-minute reading path

Use this pacing if you want to read the guide in one sitting.

| Time | Focus |
|---:|---|
| 0-5 min | Understand the task boundary and the core exam mental model. |
| 5-12 min | Learn Azure Monitor Logs, Log Analytics workspaces, and the major log sources. |
| 12-22 min | Study collection methods: platform logs, activity logs, resource logs, Entra logs, VM guest logs, application logs, and custom logs. |
| 22-32 min | Study workspace architecture, workspace count, region, ownership, access, and retention. |
| 32-40 min | Study cost design: table plans, transformations, retention, usage analysis, duplicate data avoidance. |
| 40-45 min | Review decision patterns, exam traps, and the checklist. |

## Source set

All links in this guide point to Microsoft Learn documentation.

Primary sources:

- [AZ-305 study guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305)
- [Azure Monitor Logs overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)
- [Azure Monitor data sources and data collection methods](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources)
- [Log Analytics workspace overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview)
- [Design a Log Analytics workspace architecture](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design)
- [Best practices for Azure Monitor Logs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/best-practices-logs)
- [Manage tables in a Log Analytics workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables)
- [Select a table plan based on data usage in a Log Analytics workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans)
- [Manage data retention in a Log Analytics workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure)
- [Azure Monitor Logs cost calculations and options](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs)
- [Analyze usage in a Log Analytics workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/analyze-usage)
- [Manage access to Log Analytics workspaces](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access)
- [Data collection rules in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview)
- [Azure Monitor Agent overview](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview)
- [Activity Log in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log)
- [Diagnostic settings in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings)
- [Logs Ingestion API in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview)
- [Add or delete tables and columns in Azure Monitor Logs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/create-custom-table)
- [Run search jobs in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/search-jobs)
- [Application Insights OpenTelemetry observability overview](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
- [Create and configure Application Insights resources](https://learn.microsoft.com/en-us/azure/azure-monitor/app/create-workspace-resource)

## 1. Scope of “Recommend a logging solution”

AZ-305 lists these as separate tasks:

- Recommend a logging solution.
- Recommend a solution for routing logs.
- Recommend a monitoring solution.

That separation matters. In exam terms, **logging** is the design of the data foundation. **Routing** is where the log stream is sent or exported. **Monitoring** is how logs, metrics, alerts, dashboards, and operational responses are used after the data exists.

For this task, stay centered on the logging foundation:

- What log data is needed?
- What Azure service stores it?
- What collection mechanism gets it there?
- What table plan, retention period, and access model fit the requirement?
- What governance pattern keeps the solution scalable and cost-controlled?

Do not over-index on:

- Event Hubs forwarding to a SIEM.
- Long-term raw archive in a storage account.
- Workbooks and dashboards.
- Metric alerts or log search alerts.
- Action groups, automation runbooks, ITSM integration, or incident response.
- Full monitoring strategy for health, performance, availability, and SLOs.

Those are valid Azure Monitor topics, but they belong primarily to the adjacent routing and monitoring tasks.

## 2. The core mental model

For AZ-305, think of an Azure logging solution as a layered design.

```text
Log sources
  -> Collection method
    -> Ingestion pipeline and transformations
      -> Log Analytics workspace
        -> Tables and table plans
          -> Retention and search
            -> Access control and cost governance
```

The most important service is **Azure Monitor Logs**. It is the log platform that collects, stores, queries, and manages logs from Azure resources, non-Azure resources, and applications. The primary storage resource for Azure Monitor Logs is the **Log Analytics workspace**.

A workspace is not just a container. It is the design boundary for:

- Region and data residency.
- Billing and commitment tier aggregation.
- Table configuration.
- Retention.
- Access control.
- Microsoft Sentinel enablement, if security monitoring is included in the broader environment.
- Cross-resource and cross-workload querying.

The exam often expects you to recognize when the answer is simply “use Azure Monitor Logs with a Log Analytics workspace” and when the answer requires more nuance, such as separate workspaces, Basic Logs, Auxiliary Logs, table-level retention, Azure Monitor Agent, Data Collection Rules, or the Logs Ingestion API.

## 3. Azure Monitor Logs vs Log Analytics workspace

[Azure Monitor Logs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs) is the centralized log platform. It provides the ingestion, storage, query, and management capabilities.

A [Log Analytics workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview) is the primary resource that stores Azure Monitor Logs data. It contains tables. Tables contain log records.

A common misunderstanding is to treat “Log Analytics” as only a query tool. In current Azure terminology:

- **Azure Monitor Logs** is the log data platform.
- **Log Analytics workspace** is the log data store.
- **Log Analytics** is also the portal query experience used to query logs with KQL.

For architecture questions, the workspace is usually the design object. For operational questions, Log Analytics is often the query interface. For AZ-305 logging design, focus on the workspace and its related design choices.

### What a Log Analytics workspace gives you

A workspace can:

- Store platform, resource, guest OS, application, and custom logs.
- Organize log data into Azure tables, custom tables, and search result tables.
- Apply table plans to control cost and capabilities.
- Apply retention settings at workspace or table level.
- Support query and analysis with KQL.
- Integrate with other Microsoft services such as Application Insights and Microsoft Sentinel.
- Control access through workspace, resource, table, or row-level models.

### What a workspace does not automatically do

A workspace does not automatically collect every useful log. Many logs must be enabled through the appropriate mechanism:

- Azure Activity Log exists automatically, but exporting it to a workspace is a design choice.
- Azure resource logs are generated by resources, but usually require diagnostic settings to collect them.
- VM guest OS logs require an agent-based approach.
- Custom application or third-party logs require instrumentation, an agent, the Logs Ingestion API, or another supported method.
- Application telemetry requires Application Insights or OpenTelemetry-based instrumentation.

## 4. Know the main log source categories

A logging solution starts with the source. The exam may describe a requirement without saying the exact log name. Translate the scenario into the right source category.

### Azure Activity Log

Use [Activity Log in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log) for Azure control-plane events. This answers questions like:

- Who created, updated, or deleted an Azure resource?
- What happened at the subscription or resource group level?
- What service health or resource health events occurred?
- What administrative operations happened in Azure Resource Manager?

The Activity Log is collected automatically. However, its default retention and native access might not meet audit requirements. To correlate Activity Log data with other logs, run richer queries, or retain it longer, export it to a Log Analytics workspace.

Exam pattern:

> A company needs to retain administrative operations against Azure resources for one year and correlate those operations with VM and application logs.

Recommended logging solution:

> Send the Azure Activity Log to a Log Analytics workspace and configure retention appropriately.

Do not confuse Activity Log with resource logs. Activity Log is primarily control-plane. Resource logs are generated by the resource itself and often represent data-plane or service-internal operations.

### Azure resource logs

Use resource logs when the requirement is about detailed operations inside an Azure resource.

Examples:

- Key Vault access logs.
- Azure Firewall logs.
- Storage account access-related logs.
- App Service HTTP logs or audit logs.
- Azure SQL auditing or diagnostic categories.
- Network security group flow logs are network-specific and may appear in other monitoring/networking contexts, but the same “resource-specific log” mental model applies.

Resource logs are covered in [Azure Monitor data sources and data collection methods](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources) and configured through [Diagnostic settings in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings).

Important exam point: resource logs are not automatically sent to Log Analytics. You normally configure diagnostic settings for the resource and select the relevant log categories.

For this task, the important part is not the downstream routing destination design. The important part is knowing that resource-specific logs exist and that a diagnostic setting is the standard mechanism to collect those resource logs into the logging solution.

### Microsoft Entra ID logs

Microsoft Entra logs include audit and sign-in activity. These are identity logs, not Azure Resource Manager control-plane logs. They are similar in importance to Activity Log data, but they come from the tenant identity plane.

Relevant source: [Azure Monitor data sources and data collection methods](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources).

Exam pattern:

> A company needs to analyze user sign-in activity, risky access patterns, and tenant audit operations alongside Azure infrastructure logs.

Recommended logging solution:

> Configure Microsoft Entra diagnostic settings to send Entra audit and sign-in logs to a Log Analytics workspace that supports the required retention, access control, and security operations model.

Avoid saying “Azure Activity Log” for sign-in logs. The Activity Log is not the same as Microsoft Entra sign-in logs.

### VM guest OS logs

Use [Azure Monitor Agent](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview) when you need logs from inside the operating system.

Examples:

- Windows Event Logs.
- Linux Syslog.
- Text logs from files.
- Guest OS performance data, if relevant to the broader monitoring design.

The Azure Monitor Agent collects data according to [Data Collection Rules](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview). DCRs define what data to collect, how to process it, and where to send it.

Exam pattern:

> A company has Azure VMs and Azure Arc-enabled on-premises servers. They need to collect Windows security events and Linux Syslog into a centralized Azure log store.

Recommended logging solution:

> Deploy Azure Monitor Agent to Azure VMs and Azure Arc-enabled servers, define Data Collection Rules for the required Windows Event Log and Syslog sources, and send the collected data to a Log Analytics workspace.

Do not recommend the legacy Log Analytics agent for a new design unless a scenario explicitly requires legacy compatibility. For a design recommendation, prefer Azure Monitor Agent and DCRs.

### Application logs and telemetry

Use [Application Insights](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) for application telemetry. Current Application Insights designs are workspace-based and store telemetry in a Log Analytics workspace.

Application telemetry can include:

- Requests.
- Dependencies.
- Exceptions.
- Traces.
- Page views.
- Custom events.
- Distributed tracing data through OpenTelemetry.

For architecture decisions, understand that application logs are part of the same Azure Monitor data platform when Application Insights is workspace-based.

Exam pattern:

> Developers need application request, dependency, exception, and trace telemetry for a web application. Operations also needs the ability to query this data with platform logs.

Recommended logging solution:

> Use workspace-based Application Insights with the application associated to an appropriate Log Analytics workspace.

If the question emphasizes OpenTelemetry, code-based instrumentation, or distributed tracing, Application Insights with the Azure Monitor OpenTelemetry Distro is usually the relevant service.

### Custom and third-party logs

Use [Logs Ingestion API in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview) when an application, service, or third-party source needs to send custom data to a Log Analytics workspace through REST API calls or client libraries.

The Logs Ingestion API is important because it uses:

- A target Log Analytics workspace.
- A target table, often a custom table.
- A Data Collection Rule.
- A schema definition.
- Optional transformations.
- Microsoft Entra-based authentication through an app registration.

Exam pattern:

> A custom line-of-business application emits JSON audit events. The company wants to centralize those events in Azure Monitor Logs and query them with Azure platform logs.

Recommended logging solution:

> Create a custom table in the Log Analytics workspace and ingest the application’s JSON records through the Logs Ingestion API, using a Data Collection Rule to map and transform the data into the destination table.

Do not choose Event Hubs just because custom logs are involved. Event Hubs may be relevant to routing or streaming patterns, but for the specific logging solution into Azure Monitor Logs, the Logs Ingestion API is the more direct answer.

## 5. Collection methods and when to use each

The exam may describe the source indirectly. Map the requirement to the collection method.

| Requirement | Likely collection method | Destination |
|---|---|---|
| Azure subscription-level administrative changes | Activity Log export | Log Analytics workspace |
| Azure resource-specific operational logs | Diagnostic settings | Log Analytics workspace |
| Microsoft Entra audit or sign-in logs | Entra diagnostic settings | Log Analytics workspace |
| Windows Event Logs or Linux Syslog from Azure VMs | Azure Monitor Agent and DCR | Log Analytics workspace |
| Windows Event Logs or Linux Syslog from on-premises servers | Azure Arc plus Azure Monitor Agent and DCR | Log Analytics workspace |
| Application traces, requests, dependencies, exceptions | Application Insights/OpenTelemetry | Workspace-based Application Insights and Log Analytics workspace |
| Custom JSON or third-party application events | Logs Ingestion API and DCR | Custom or supported Azure table in Log Analytics workspace |
| Custom table schema for data not fitting existing tables | Custom table plus DCR | Log Analytics workspace |
| Need to filter, transform, or shape logs before storage | DCR transformation or workspace transformation, depending on source | Table in Log Analytics workspace |

### Data Collection Rules

[Data Collection Rules](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview) are central to modern Azure Monitor log collection.

A DCR can define:

- Data to collect.
- Incoming schema.
- Transformations.
- Destination workspace and table.
- Associations to resources, depending on scenario.

DCRs are especially relevant for:

- Azure Monitor Agent.
- Logs Ingestion API.
- Transformations.
- Scalable configuration with infrastructure as code.

When recommending a logging solution, mention DCRs when the source requires agent-based collection or custom ingestion. You do not need to mention DCRs for every Azure resource log scenario, because diagnostic settings are still the main collection method for many resource logs.

### Diagnostic settings

[Diagnostic settings](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings) define what platform log categories are collected from a resource and where they are sent. For this task, use diagnostic settings primarily to explain how Azure resource logs enter the logging solution.

Exam-safe phrasing:

> Configure diagnostic settings on the required Azure resources to collect the relevant resource log categories into a Log Analytics workspace.

Be careful not to drift into the adjacent routing task. If a scenario asks whether logs should go to Log Analytics, Event Hubs, or Storage, that is a routing question. If the scenario asks which logging data should be captured and centralized for query, diagnostic settings are relevant as the collection mechanism.

### Azure Monitor Agent

[Azure Monitor Agent](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview) is the recommended modern agent for collecting telemetry from guest operating systems on Azure VMs, VM scale sets, and Azure Arc-enabled servers.

Use it for:

- Windows Event Logs.
- Linux Syslog.
- Custom text logs, where supported by the DCR-based collection flow.
- Guest-level data not visible to the Azure resource provider.

Design points:

- Use DCRs to centrally define collection.
- Associate DCRs to the appropriate machines.
- Use Azure Policy for scale deployment when appropriate.
- Avoid duplicate collection during migration from legacy agents.
- Consider data volume and event filtering early.

### Logs Ingestion API

[Logs Ingestion API](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview) is the modern way to send custom data to Azure Monitor Logs.

Use it when:

- A custom application can make REST API calls.
- You need to ingest JSON records.
- A third-party source can call the API or use client libraries.
- You want DCR-governed schema control and transformations.
- You want to use custom tables or supported Azure tables.

Key design pieces:

- The destination table must exist.
- Custom tables use the `_CL` suffix.
- The DCR defines the stream, transformation, destination, and table mapping.
- The app registration must be granted access to the DCR.
- A Data Collection Endpoint is needed for some private link or older endpoint patterns.

For AZ-305, know the architecture more than the API syntax.

## 6. Workspace architecture decisions

The most exam-relevant design article is [Design a Log Analytics workspace architecture](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design).

A workspace architecture decision usually starts with this default:

> Use the fewest number of workspaces that meet the requirements. Start with a single workspace unless business, regulatory, operational, security, cost, or tenancy requirements justify more.

### When one workspace is often enough

A single workspace is often appropriate when:

- The organization wants centralized operational visibility.
- Data residency requirements are the same across workloads.
- The same operations team manages the environment.
- Access can be controlled using resource-context, table-level, or granular RBAC.
- Combining data improves correlation.
- Combining ingestion helps with commitment tier economics.
- The environment is not large enough to justify multiple separate operational boundaries.

Benefits:

- Simpler querying.
- Easier correlation across resources and applications.
- Lower administrative overhead.
- Potential cost optimization through aggregated usage.
- Less duplication and less fragmentation.

Exam pattern:

> A single IT operations team manages all Azure workloads in one tenant and one geographic region. They need centralized troubleshooting across VMs, App Service, Key Vault, and Azure SQL.

Recommendation:

> Use a centralized Log Analytics workspace and collect the required platform, resource, guest OS, and application logs into that workspace.

### When multiple workspaces are justified

Multiple workspaces may be appropriate when requirements differ across:

- Data residency or regulatory geography.
- Tenant boundary.
- Ownership or operations model.
- Security data separation.
- Microsoft Sentinel vs operational logging cost models.
- Customer isolation for service providers.
- Retention requirements that are difficult to manage cleanly by table.
- Chargeback or subscription-level billing requirements.

Examples:

- Separate workspaces for US and EU data residency requirements.
- Separate security workspace for Microsoft Sentinel if required by the security team.
- Separate workspaces for different tenants or managed customers.
- Separate workspaces where one business unit requires strict isolation from another.

Be careful: “many subscriptions” does not automatically mean “many workspaces.” A single workspace can collect logs from many subscriptions in the same tenant, depending on the source and collection mechanism.

### Region choice

Each Log Analytics workspace resides in a region. For AZ-305, region matters for:

- Data residency.
- Compliance.
- Latency to ingestion endpoints.
- Regional availability and resilience design.
- Cost considerations, including potential data transfer patterns.

Exam pattern:

> A company operates in the United States and Europe and must keep operational logs from European workloads within Europe.

Recommendation:

> Use separate regional Log Analytics workspaces aligned to the required data residency boundaries, such as one workspace for European workloads and one for US workloads.

### Operations vs security workspace

If Microsoft Sentinel is part of the environment, workspace design becomes more nuanced.

A combined workspace can improve correlation between security and operational data. A separate workspace can help isolate ownership, access, and cost. Microsoft’s workspace design guidance explicitly discusses combined and dedicated workspace approaches for Azure Monitor and Microsoft Sentinel.

For the logging task, do not make Sentinel the center unless the scenario mentions SIEM, SOC, security analytics, or Sentinel. But do recognize that security team ownership and pricing can justify separate workspace design.

Exam pattern:

> The operations team and security operations team have separate ownership, access, and cost management requirements. Security data is ingested into Sentinel and should be tightly controlled.

Recommendation:

> Consider dedicated workspaces for operational logging and security logging if separation is required by ownership, access, or cost requirements. Use access controls and table-level restrictions when a combined workspace better supports correlation and cost.

## 7. Tables, schemas, and table plans

A Log Analytics workspace stores data in tables. [Manage tables in a Log Analytics workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables) is important because table design affects cost, query capability, retention, and access.

### Table types

You should recognize three broad table categories:

- **Azure tables**: Created automatically for Azure services and solutions. They have predefined schemas.
- **Custom tables**: Created for custom or non-Azure data sources. You define the schema.
- **Search result tables**: Created by search jobs for data retrieved from long-term retention, Basic, or Auxiliary logs.

### Custom tables

Use custom tables when the log data does not fit an existing Azure table.

Design points:

- Custom tables should be designed around the query and retention needs.
- Table names should not contain sensitive information because table names can appear in billing and metadata contexts.
- Custom tables use the `_CL` suffix.
- The table schema and DCR schema must align.
- All records need a usable `TimeGenerated` concept.

Custom table scenario:

> A SaaS application emits application audit events as JSON. The organization wants to query those events in the same workspace as Azure platform logs.

Recommendation:

> Create a custom table in the Log Analytics workspace and use the Logs Ingestion API with a DCR to transform and map incoming JSON to the table schema.

### Table plans

[Table plans](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans) are a major cost and capability design choice.

Azure Monitor Logs has these main plan concepts:

- **Analytics**: Full query and analytics capabilities. Best for data used frequently for troubleshooting, dashboards, alerting, security, or operational analysis.
- **Basic**: Lower ingestion cost for high-volume logs that are queried less frequently and do not require the full Analytics feature set.
- **Auxiliary**: Designed for high-volume, verbose, low-touch data where low-cost storage is important and full interactive analytics is less critical. It is especially relevant to custom tables.

Exact capabilities and support vary by table type, so use the table plan documentation for details. For exam purposes, the decision pattern matters more than memorizing every limit.

### When to recommend Analytics

Recommend Analytics tables when the data is:

- Used for frequent troubleshooting.
- Used for near-real-time operational analysis.
- Needed for alerts or rich analysis.
- Needed for security operations.
- Needed by dashboards, workbooks, or interactive KQL analysis.
- Mission-critical enough that query flexibility matters more than ingestion cost.

Example:

> Production application exceptions, Key Vault access logs, and VM security events are actively used by operations and security teams.

Recommendation:

> Use Analytics tables for these logs because they require frequent interactive analysis and broad Azure Monitor feature support.

### When to recommend Basic

Recommend Basic logs when the data is:

- High-volume.
- Verbose.
- Useful for investigation, but not usually queried interactively every day.
- Not central to alerting or advanced analytics.
- Suitable for reduced-cost ingestion with more limited query capabilities.

Example:

> Container stdout logs are very high volume and are mostly used only during incident investigations.

Recommendation:

> Consider the Basic table plan for supported high-volume tables if the reduced feature set still meets investigation requirements.

### When to recommend Auxiliary

Recommend Auxiliary logs when the data is:

- Very high-volume or verbose.
- Needed for audit, compliance, or occasional forensic lookup.
- Queried infrequently.
- Custom in nature, where an Auxiliary custom table fits.
- Cost-sensitive enough that low-cost storage is a priority.

Example:

> A custom application produces verbose request-level audit logs that must be retained but are rarely queried.

Recommendation:

> Consider a custom table using the Auxiliary plan, assuming the query and feature limitations meet the requirement.

Important design caution: Auxiliary plan behavior and support differs from Analytics and Basic. Do not blindly recommend Auxiliary for operational logs that require rich queries, alerting, or frequent troubleshooting.

## 8. Retention and long-term access

Retention is a core logging design requirement. Use [Manage data retention in a Log Analytics workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure).

Log Analytics retention has these concepts:

- **Analytics retention**: Data is available for near-real-time analytics and interactive query capabilities, depending on table plan.
- **Long-term retention**: Data remains stored at lower cost after the analytics retention period and can be retrieved when needed.
- **Total retention**: The full retention period before the data is removed.

The right recommendation depends on how the logs are used:

- Operational troubleshooting data often needs shorter analytics retention, such as 30 to 90 days.
- Security investigation data may need longer analytics retention.
- Compliance audit data may need long total retention, sometimes years.
- Rarely queried data may be better served by long-term retention and search jobs rather than keeping everything in hot analytics retention.

### Table-level retention

Table-level retention is important because different logs have different value and cost profiles.

Example:

| Data type | Suggested retention concept |
|---|---|
| App exceptions | Longer analytics retention if actively used by developers and operations. |
| Debug traces | Short analytics retention or lower-cost table plan if high volume. |
| Azure Activity Log | Longer retention if audit requires it. |
| Security events | Retain according to investigation and compliance needs. |
| Verbose custom audit records | Long total retention with lower-cost access pattern. |

Exam pattern:

> A company must keep audit logs for seven years but only needs frequent interactive queries for 90 days.

Recommendation:

> Configure table-level analytics retention for the active investigation window and total retention for the full audit period. Use long-term retention and search jobs for older data when needed.

### Search jobs

[Search jobs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/search-jobs) retrieve data from long-term retention and from Basic or Auxiliary tables into a new Analytics table for deeper analysis.

This is relevant when a scenario says:

- Older logs must be retained but rarely queried.
- Historical audit data must be retrievable.
- The query may scan a large amount of data.
- The organization does not need all data kept in hot analytics mode.

Exam-safe phrasing:

> Use long-term retention for older log data and search jobs to retrieve specific historical records when investigation or compliance review requires interactive analysis.

## 9. Access control for logs

Logging data often contains sensitive information. For AZ-305, access control is a design requirement, not an afterthought.

Use [Manage access to Log Analytics workspaces](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access).

### Access modes

Log Analytics supports two important access modes:

- **Workspace-context**: Users query all data in the workspace that they have permission to access.
- **Resource-context**: Users access logs for a specific Azure resource, resource group, or subscription that they have permission to view.

Workspace-context fits central teams. Resource-context fits application or workload owners who should only see logs for their resources.

### Access control mode

Workspace access control mode affects whether permissions are evaluated at the workspace or resource level.

Design principle:

> Use resource-context access when application teams should query logs for only the resources they own without giving them broad access to the entire workspace.

This supports the “central workspace, delegated access” pattern.

### Table-level and granular RBAC

Use table-level or granular RBAC when access needs to be restricted by table or row.

Examples:

- Security logs should be visible only to security analysts.
- HR or identity-related tables should not be visible to general operations teams.
- Application teams should see only logs for their own resources.
- Central admins need full workspace access, while workload teams need narrow access.

Exam pattern:

> A company wants a centralized workspace but must prevent application teams from viewing security logs.

Recommendation:

> Use a centralized workspace with appropriate Azure RBAC, resource-context access, and table-level or granular RBAC to restrict access to sensitive tables.

Do not automatically recommend separate workspaces solely for access control. Separate workspaces may be appropriate, but resource-context and table-level controls may satisfy the requirement while preserving centralized correlation.

## 10. Cost design

Cost is a major part of a logging solution because log data can grow quickly.

Use these Microsoft Learn docs:

- [Azure Monitor Logs cost calculations and options](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs)
- [Analyze usage in a Log Analytics workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/analyze-usage)
- [Select a table plan based on data usage](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans)

Cost is driven by several factors:

- Volume of data ingested.
- Table plan.
- Retention period.
- Querying Basic or Auxiliary tables.
- Search jobs.
- Enabled solutions and insights.
- Duplicate collection.
- Data collected from verbose sources.
- Whether operational and security data are combined or separated.

### Cost reduction levers

A good AZ-305 logging recommendation should know these levers:

1. **Collect only required categories**
   - Do not enable every diagnostic category without purpose.
   - Map log categories to audit, troubleshooting, compliance, or security requirements.

2. **Use DCR filtering and transformations**
   - Filter low-value events.
   - Remove unnecessary columns.
   - Normalize data before storage.
   - Avoid collecting data that has no defined use.

3. **Use table plans intentionally**
   - Analytics for frequently queried and operationally important logs.
   - Basic for high-volume, lower-touch supported tables.
   - Auxiliary for high-volume, custom, low-touch data when limitations are acceptable.

4. **Set retention by table**
   - Do not retain verbose debug logs for years in Analytics retention unless required.
   - Use long-term retention for compliance where interactive query is rarely needed.

5. **Avoid duplicate collection**
   - Watch for multiple agents, old and new agents, or logs sent to multiple workspaces without business justification.
   - During migrations from legacy agents to Azure Monitor Agent, validate that duplicate ingestion is not occurring.

6. **Analyze usage regularly**
   - Use workspace insights and the `Usage` table to identify high-ingestion tables and resources.
   - Look for sudden increases after enabling a solution, diagnostic category, or agent rule.

### Common cost scenario

Scenario:

> A company enabled broad diagnostic logging for many Azure resources and now has unexpectedly high Log Analytics costs. They still need critical audit and troubleshooting logs.

Recommendation:

> Analyze ingestion by table and resource, identify high-volume categories, disable or filter low-value logs, use DCR transformations where applicable, move supported high-volume low-touch logs to Basic or Auxiliary plans where appropriate, and set table-specific retention policies.

Do not recommend deleting the workspace or turning off all logging. The design response should preserve required audit and troubleshooting capability while reducing unnecessary ingestion and retention.

## 11. Transformations and schema design

Transformations are part of the logging solution because they shape what lands in the workspace.

Relevant docs:

- [Data collection rules in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview)
- [Add or delete tables and columns in Azure Monitor Logs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/create-custom-table)
- [Logs Ingestion API in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview)

Use transformations when you need to:

- Map incoming custom JSON to a table schema.
- Drop low-value records before ingestion.
- Remove or reshape fields.
- Normalize inconsistent source data.
- Add derived columns.
- Reduce cost by filtering noisy data.

For custom ingestion, the DCR is especially important because it can transform incoming data before it reaches the target table.

Exam pattern:

> A custom app sends JSON records with many fields, but only a subset is needed for audit and troubleshooting. The schema does not match an existing Log Analytics table.

Recommendation:

> Create a custom table and use the Logs Ingestion API with a DCR transformation to map required fields, drop unneeded fields, and store the data in the custom table.

## 12. Decision tree for exam scenarios

Use this decision tree when reading an AZ-305 question.

### Step 1: Identify the log source

Ask: What is producing the log?

- Azure Resource Manager control plane? Use Activity Log.
- Azure service internal/resource logs? Use resource logs through diagnostic settings.
- Microsoft Entra sign-in or audit events? Use Entra logs through diagnostic settings.
- Guest OS logs? Use Azure Monitor Agent and DCR.
- Application telemetry? Use Application Insights/OpenTelemetry.
- Custom app or third-party data? Use Logs Ingestion API and custom tables, or an agent-based custom log path if the source is file-based.

### Step 2: Identify the storage target

For this task, the likely answer is a Log Analytics workspace.

Ask:

- Is centralized query required?
- Is correlation across sources required?
- Is retention required beyond default source retention?
- Is this operational or security log data?
- Does the data need to be queried with KQL?

If yes, use Azure Monitor Logs with a Log Analytics workspace.

### Step 3: Decide workspace topology

Start with one workspace.

Add workspaces only when required by:

- Region or data residency.
- Tenant boundary.
- Customer isolation.
- Separate operational or security ownership.
- Microsoft Sentinel cost or access boundaries.
- Strong chargeback or lifecycle separation requirements.

### Step 4: Choose table plan

Ask how the data is used:

- Frequently queried, alerting, dashboards, security, troubleshooting: Analytics.
- High-volume and less frequently queried: Basic, if supported and sufficient.
- Very high-volume custom or low-touch data: Auxiliary, if sufficient.

### Step 5: Set retention

Ask:

- How long must the data be actively queried?
- How long must it be retained for compliance?
- Is long-term retention sufficient for older records?
- Do different tables need different retention periods?

### Step 6: Design access

Ask:

- Who owns the logs?
- Who can query all logs?
- Should application teams see only their resource logs?
- Are some tables restricted to security or compliance teams?

Choose workspace RBAC, resource-context access, table-level RBAC, or granular RBAC as needed.

### Step 7: Control cost

Ask:

- Are there verbose sources?
- Are all categories necessary?
- Can transformations reduce ingestion?
- Can some tables use Basic or Auxiliary plans?
- Can retention be shorter for noisy tables?
- Is duplicate collection happening?

## 13. Recommendation patterns

### Pattern 1: Centralized enterprise operational logging

Scenario:

> A company has multiple Azure subscriptions in one tenant and wants centralized troubleshooting across infrastructure and applications.

Recommendation:

> Use Azure Monitor Logs with a centralized Log Analytics workspace. Configure diagnostic settings for required Azure resource logs, send Activity Log data to the workspace, deploy Azure Monitor Agent with DCRs for VM guest logs, and use workspace-based Application Insights for application telemetry. Use resource-context access and RBAC so application teams can access only their own logs.

Why this works:

- Centralizes data.
- Supports cross-resource queries.
- Reduces workspace sprawl.
- Preserves delegated access.
- Fits the default “start with one workspace” design.

### Pattern 2: Regulated multi-region logging

Scenario:

> A global company must keep European workload logs in Europe and US workload logs in the United States.

Recommendation:

> Use regional Log Analytics workspaces aligned to data residency boundaries. Configure collection so European resources send logs to the European workspace and US resources send logs to the US workspace. Apply table-level retention based on local compliance requirements.

Why this works:

- Meets data residency requirements.
- Avoids a single workspace that violates geography rules.
- Allows region-specific retention.

### Pattern 3: Security and operations separation

Scenario:

> Security operations and infrastructure operations have different access, cost, and ownership requirements. Security data is used in Microsoft Sentinel.

Recommendation:

> Evaluate separate workspaces for operational logging and security logging if ownership, cost, or access isolation requires it. If correlation is more important and access can be controlled, consider a combined workspace with table-level or granular RBAC.

Why this works:

- Does not blindly separate or combine.
- Ties the decision to ownership, cost, access, and correlation.
- Reflects Microsoft workspace design guidance.

### Pattern 4: Hybrid VM guest logging

Scenario:

> A company has Azure VMs and on-premises servers. It needs Windows Event Logs and Linux Syslog centralized in Azure.

Recommendation:

> Use Azure Arc for on-premises servers where needed, deploy Azure Monitor Agent, create DCRs for required Windows Event Log and Syslog sources, and send the data to an appropriate Log Analytics workspace.

Why this works:

- Azure Monitor Agent can collect guest OS logs.
- Azure Arc brings non-Azure servers into Azure management.
- DCRs provide centralized, scalable configuration.

### Pattern 5: Custom application audit logs

Scenario:

> A custom application emits JSON audit logs. Logs must be retained for seven years and queried during investigations.

Recommendation:

> Use the Logs Ingestion API to send JSON audit events to a custom table in a Log Analytics workspace. Use a DCR to map and transform the incoming schema. Set table-level analytics retention for the active investigation period and total retention for the required seven-year period.

Why this works:

- Handles custom data.
- Stores logs in Azure Monitor Logs.
- Supports custom schema and transformations.
- Separates active query needs from long-term compliance retention.

### Pattern 6: High-volume verbose logs with cost pressure

Scenario:

> A workload produces high-volume verbose logs that are rarely queried but must be retained.

Recommendation:

> Use table plans and retention settings to optimize cost. Keep operationally important logs in Analytics tables. Move supported high-volume low-touch logs to Basic or Auxiliary plans when limitations are acceptable. Use DCR transformations to filter unneeded records before ingestion.

Why this works:

- Preserves useful logs.
- Reduces ingestion and retention cost.
- Aligns table plan to usage pattern.

### Pattern 7: Application telemetry with platform correlation

Scenario:

> Developers need traces, exceptions, dependencies, and request telemetry for an application, and operations wants to correlate this with Azure platform logs.

Recommendation:

> Use workspace-based Application Insights. Associate the Application Insights resource with the appropriate Log Analytics workspace so application telemetry can be queried and correlated with other Azure Monitor Logs data.

Why this works:

- Application Insights is the application telemetry service.
- Workspace-based resources store telemetry in Log Analytics.
- Supports correlation with infrastructure and platform logs.

## 14. Common exam traps

### Trap 1: Choosing Azure Storage as the logging solution by default

Storage accounts can be used for archive or routing scenarios, but for the task “Recommend a logging solution,” Log Analytics workspace is usually the primary design target when the requirement involves query, analysis, correlation, retention management, or Azure Monitor integration.

Use Storage only when the requirement emphasizes raw archive, immutable storage, or long-term export, and recognize that this is closer to log routing or archival design.

### Trap 2: Choosing Event Hubs for custom logs

Event Hubs is a streaming and integration service. It may be right for routing logs to third-party SIEMs or external consumers. For sending custom data into Azure Monitor Logs, the Logs Ingestion API and custom tables are the more directly relevant logging solution.

### Trap 3: Using one workspace per subscription automatically

A workspace per subscription is not always wrong, but it should not be automatic. Start with the fewest workspaces that meet requirements. Multiple subscriptions can send logs to a shared workspace when requirements allow.

### Trap 4: Using separate workspaces only because teams need different access

Separate workspaces can solve access separation, but they also add query and management complexity. Resource-context access, table-level RBAC, and granular RBAC may solve the access requirement while preserving centralization.

### Trap 5: Treating all logs as equal

All logs do not need the same table plan or retention period. High-value security and operational logs may need Analytics. Verbose, low-touch logs may fit Basic or Auxiliary. Compliance logs may need long total retention but not long hot analytics retention.

### Trap 6: Forgetting that resource logs must be enabled

Azure resource logs are not always automatically collected into a workspace. Diagnostic settings are typically needed to collect resource logs into Log Analytics.

### Trap 7: Recommending legacy agents for new designs

For new VM guest logging designs, prefer Azure Monitor Agent with Data Collection Rules. Legacy agents may appear in migration scenarios, but they should not be the default recommendation for new architecture.

### Trap 8: Confusing Activity Log with Entra sign-in logs

Azure Activity Log covers Azure resource control-plane events. Entra sign-in logs and audit logs are identity-plane logs. Both can be important, but they are not the same source.

### Trap 9: Extending hot retention for everything

If old data is rarely queried, long-term retention plus search jobs can meet requirements at lower cost than keeping all tables in long analytics retention.

### Trap 10: Ignoring cost until after collection is enabled

A good logging design includes cost controls from the start: category selection, DCR filtering, transformations, table plans, retention, and usage analysis.

## 15. Quick comparison tables

### Source-to-solution map

| Source requirement | Recommended logging component |
|---|---|
| Azure resource create/update/delete audit | Activity Log to Log Analytics workspace |
| Azure service internal operations | Resource logs through diagnostic settings |
| Entra sign-ins and tenant audit events | Entra diagnostic settings to Log Analytics workspace |
| Windows Event Logs | Azure Monitor Agent plus DCR |
| Linux Syslog | Azure Monitor Agent plus DCR |
| Application requests, exceptions, dependencies, traces | Application Insights/OpenTelemetry with workspace-based storage |
| Custom JSON logs | Logs Ingestion API plus DCR plus custom table |
| Custom schema in workspace | Custom table |
| Need to filter before storage | DCR transformation or workspace transformation |
| Need historical retrieval from long-term retention | Search jobs |

### Workspace decision table

| Requirement | Likely workspace decision |
|---|---|
| Central operations team, same region, same tenant | Single centralized workspace |
| Data residency differs by geography | Regional workspaces |
| Separate customers managed by provider | Separate workspaces or strong isolation model |
| Security and operations have separate ownership and cost requirements | Dedicated security and operations workspaces may be justified |
| Application teams need only their own logs | Central workspace with resource-context access may be enough |
| Need centralized correlation across workloads | Prefer fewer workspaces |
| Cost optimization through aggregation | Prefer fewer workspaces when requirements allow |

### Table plan decision table

| Requirement | Likely table plan |
|---|---|
| Frequently queried operational logs | Analytics |
| Logs used for alerts and dashboards | Analytics |
| Security investigation data | Usually Analytics, depending on SOC requirements |
| High-volume logs queried occasionally | Basic, if supported and sufficient |
| Very high-volume custom logs queried rarely | Auxiliary, if limitations are acceptable |
| Long-term compliance retention | Total retention plus search jobs, table plan based on access needs |

## 16. What to memorize vs understand

### Memorize

- Log Analytics workspace is the primary Azure Monitor Logs data store.
- Activity Log is Azure control-plane logging.
- Resource logs usually require diagnostic settings.
- Azure Monitor Agent plus DCR is the modern VM guest log collection model.
- Logs Ingestion API plus custom tables is the modern custom log ingestion model.
- Application Insights is the application telemetry service and is workspace-based in modern designs.
- Start workspace design with the fewest workspaces that meet requirements.
- Use table plans and retention to control cost.
- Use RBAC, resource-context, table-level access, and granular RBAC to control log access.

### Understand

- Why one workspace is simpler, but multiple workspaces may be required.
- Why data residency can override centralization.
- Why security and operations sometimes separate workspaces.
- Why verbose logs may not belong in Analytics tables.
- Why retention should be table-specific.
- Why custom logs require schema planning.
- Why transformations are part of cost and data quality design.
- Why log routing and monitoring are adjacent but distinct tasks.

## 17. Mini-scenarios for practice

### Scenario 1

A company needs to investigate who changed network security group rules in Azure. They need to keep this data for one year and query it with other operational logs.

Best recommendation:

> Send Azure Activity Log data to a Log Analytics workspace and configure retention for the required one-year period.

Why:

> NSG rule changes are Azure Resource Manager control-plane events. The Activity Log is the correct source. The workspace provides retention and correlation.

### Scenario 2

A company needs Key Vault access logs for audit investigations.

Best recommendation:

> Configure Key Vault diagnostic settings to collect the required resource log categories into a Log Analytics workspace.

Why:

> Key Vault access activity is resource-specific logging. Diagnostic settings collect Azure resource logs.

### Scenario 3

A company has Azure VMs and on-premises servers. It wants to collect Windows Security events centrally.

Best recommendation:

> Use Azure Monitor Agent with DCRs. For on-premises servers, onboard them to Azure Arc and associate the appropriate DCRs.

Why:

> Guest OS logs require an agent. DCRs define what to collect and where to send it.

### Scenario 4

A SaaS application emits JSON audit records and must send them to Azure Monitor Logs.

Best recommendation:

> Create a custom table and use the Logs Ingestion API with a DCR to ingest and transform the records.

Why:

> This is custom log ingestion into Azure Monitor Logs, not a native Azure resource log.

### Scenario 5

A workload emits high-volume debug logs. They are only used occasionally and do not drive alerts.

Best recommendation:

> Use a lower-cost table plan such as Basic or Auxiliary if supported and if feature limitations meet requirements. Consider filtering the data before ingestion.

Why:

> The usage pattern does not justify full Analytics capabilities for all records.

### Scenario 6

A company wants a single workspace but does not want application teams to view logs for resources they do not own.

Best recommendation:

> Use resource-context access and Azure RBAC so teams can query logs only for resources they can access. Use table-level or granular RBAC if table or row-level restrictions are needed.

Why:

> Access control can often be solved without creating separate workspaces.

### Scenario 7

A company must retain audit data for seven years, but only needs fast interactive queries for the last 90 days.

Best recommendation:

> Configure table-level retention with an appropriate analytics retention window and total retention for seven years. Use search jobs for older data when needed.

Why:

> Long-term retention is more appropriate than keeping all historical data in hot analytics mode.

## 18. A practical design checklist

Use this checklist to build a complete answer.

### Source requirements

- Which Azure control-plane logs are needed?
- Which Azure resource logs are needed?
- Which identity logs are needed?
- Which guest OS logs are needed?
- Which application telemetry is needed?
- Which custom logs are needed?

### Collection requirements

- Are diagnostic settings needed for resource logs?
- Is Azure Monitor Agent required for guest OS logs?
- Are Data Collection Rules required?
- Is Azure Arc required for non-Azure servers?
- Is Application Insights required for application telemetry?
- Is the Logs Ingestion API required for custom logs?

### Workspace requirements

- Is one workspace enough?
- Are multiple regions required?
- Are multiple tenants involved?
- Are security and operations separated?
- Is Sentinel part of the design?
- Does the design support cross-resource correlation?

### Table and schema requirements

- Are Azure tables sufficient?
- Are custom tables needed?
- Is the schema known and stable?
- Is `TimeGenerated` available or derivable?
- Are transformations needed?

### Retention requirements

- What is the active investigation window?
- What is the compliance retention window?
- Do retention periods vary by table?
- Is long-term retention more appropriate for older data?
- Are search jobs needed for historical retrieval?

### Access requirements

- Who can query the whole workspace?
- Who can query only resource-specific logs?
- Which tables are sensitive?
- Is table-level RBAC needed?
- Is row-level/granular RBAC needed?
- Are separate workspaces truly required, or can access controls solve the issue?

### Cost requirements

- Which logs are high volume?
- Which logs are low value?
- Which logs need Analytics capabilities?
- Which logs can use Basic or Auxiliary plans?
- Can transformations reduce ingestion?
- Are there duplicate data sources?
- Is workspace usage being reviewed?

## 19. Exam answer framing

When answering a design question, use this structure mentally:

1. **Name the logging platform**
   - Azure Monitor Logs and Log Analytics workspace.

2. **Name the source-specific collection mechanism**
   - Activity Log export, diagnostic settings, Azure Monitor Agent with DCR, Application Insights, Logs Ingestion API.

3. **Name the workspace design**
   - Single centralized workspace, regional workspaces, separate security workspace, or tenant/customer-specific workspaces.

4. **Name the cost and retention controls**
   - Table plans, table-level retention, long-term retention, transformations, usage analysis.

5. **Name the access model**
   - RBAC, resource-context access, table-level access, granular RBAC.

Example complete answer:

> Use Azure Monitor Logs with a centralized Log Analytics workspace. Export the Azure Activity Log to the workspace for control-plane audit events. Configure diagnostic settings on required Azure resources for resource logs. Deploy Azure Monitor Agent with DCRs for Windows Event Logs and Linux Syslog from Azure and Arc-enabled servers. Use workspace-based Application Insights for application telemetry. Use table-level retention and appropriate table plans to manage cost, and use resource-context access with table-level or granular RBAC to restrict sensitive log data.

That answer remains focused on the logging solution. It does not over-explain routing to Event Hubs or monitoring with alerts and dashboards unless the question asks for those adjacent capabilities.

## 20. Final high-yield summary

For **Recommend a logging solution**, the default architectural center is:

> **Azure Monitor Logs stored in one or more Log Analytics workspaces.**

Then refine the answer based on source, ownership, residency, cost, access, and retention.

High-yield mappings:

- **Azure admin/control-plane events**: Activity Log.
- **Azure service/resource operations**: Resource logs through diagnostic settings.
- **Identity audit and sign-in data**: Microsoft Entra logs through diagnostic settings.
- **VM guest logs**: Azure Monitor Agent plus DCR.
- **Hybrid server logs**: Azure Arc plus Azure Monitor Agent plus DCR.
- **Application telemetry**: Workspace-based Application Insights/OpenTelemetry.
- **Custom JSON logs**: Logs Ingestion API plus DCR plus custom table.
- **Central query and correlation**: Log Analytics workspace.
- **Cost-sensitive high-volume logs**: Basic or Auxiliary table plans where appropriate.
- **Long audit retention**: Table-level total retention and search jobs.
- **Delegated access**: Resource-context access, table-level RBAC, granular RBAC.
- **Workspace count**: Use the fewest workspaces that meet business, regulatory, ownership, cost, and access requirements.

