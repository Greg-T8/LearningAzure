# AZ-305 Study Guide: Recommend a Logging Solution

**Estimated reading time:** 45 minutes.

**Scope:** This guide focuses on the AZ-305 task **Recommend a logging solution** and intentionally treats **Recommend a solution for routing logs** and **Recommend a monitoring solution** as adjacent but separate tasks. <sup>[[1]](#source-1)</sup>

**Citation style:** Each explanatory sentence includes one or more Microsoft Learn source references in a NotebookLM-style superscript format. <sup>[[1]](#source-1)</sup>

---

## 45-minute reading path

Spend the first 5 minutes establishing the exam boundary so you do not answer a logging question as if it were a routing, alerting, dashboarding, or end-to-end monitoring design question. <sup>[[1]](#source-1)</sup>

Spend the next 10 minutes on the Azure Monitor Logs mental model: Azure Monitor collects data, transforms it when needed, stores log records in Log Analytics workspace tables, and makes those records available for query and analysis. <sup>[[2]](#source-2), [[3]](#source-3), [[4]](#source-4)</sup>

Spend the next 10 minutes on workspace architecture decisions because a logging recommendation usually depends on workspace count, region, data ownership, retention, access model, billing model, and resilience expectations. <sup>[[5]](#source-5), [[18]](#source-18), [[25]](#source-25), [[26]](#source-26)</sup>

Spend the next 10 minutes on log sources and ingestion methods because the correct answer often depends on whether the data comes from Azure platform logs, Azure resource logs, guest operating system logs, application telemetry, Microsoft Entra activity logs, or custom logs. <sup>[[3]](#source-3), [[6]](#source-6), [[7]](#source-7), [[10]](#source-10), [[13]](#source-13), [[20]](#source-20), [[21]](#source-21)</sup>

Spend the last 10 minutes on table plans, retention, cost, and security because these details separate a technically correct logging solution from an architecturally appropriate one. <sup>[[14]](#source-14), [[15]](#source-15), [[16]](#source-16), [[17]](#source-17), [[18]](#source-18), [[19]](#source-19)</sup>

---

## 1. Exam boundary: what “Recommend a logging solution” means

The AZ-305 study guide places **Recommend a logging solution**, **Recommend a solution for routing logs**, and **Recommend a monitoring solution** under the same logging and monitoring design area, but it lists them as separate tasks. <sup>[[1]](#source-1)</sup>

For this task, treat the core decision as **what log data should be collected, where it should be stored, how it should be structured, who should access it, how long it should be retained, and how cost should be controlled**. <sup>[[2]](#source-2), [[4]](#source-4), [[5]](#source-5), [[14]](#source-14), [[16]](#source-16), [[17]](#source-17), [[18]](#source-18)</sup>

Do not make Event Hubs streaming, Storage Account archival, SIEM forwarding, dashboards, workbooks, alerts, or alert actions the center of your answer unless the scenario explicitly asks for those capabilities. <sup>[[1]](#source-1), [[7]](#source-7), [[9]](#source-9), [[22]](#source-22)</sup>

A logging solution can still mention diagnostic settings when the point is that Azure resource logs are not collected by default and require configuration before they appear in a destination such as Log Analytics. <sup>[[7]](#source-7), [[9]](#source-9)</sup>

A logging solution can still mention Log Analytics queries because query access is a primary reason for storing logs in Azure Monitor Logs, but the question becomes a monitoring-design question when the focus shifts to alerts, dashboards, visualizations, or operational response. <sup>[[2]](#source-2), [[27]](#source-27), [[1]](#source-1)</sup>

A good AZ-305 answer should identify the correct logging service, the correct log store, the correct data sources, the correct ingestion method, the correct retention and table plan, and the correct access boundary. <sup>[[2]](#source-2), [[3]](#source-3), [[4]](#source-4), [[5]](#source-5), [[10]](#source-10), [[11]](#source-11), [[14]](#source-14), [[18]](#source-18)</sup>

---

## 2. Core mental model

Azure Monitor Logs is the Azure Monitor capability that collects, stores, and queries log and performance data from Azure, other clouds, on-premises systems, applications, and custom sources. <sup>[[2]](#source-2), [[3]](#source-3)</sup>

A Log Analytics workspace is the primary data store for Azure Monitor Logs and can contain log data from Azure resources, non-Azure resources, and applications. <sup>[[4]](#source-4), [[14]](#source-14)</sup>

A workspace is not just a folder for logs because its configuration affects table structure, retention, access control, billing, cost optimization, and service integrations. <sup>[[4]](#source-4), [[5]](#source-5), [[14]](#source-14), [[16]](#source-16), [[17]](#source-17), [[18]](#source-18)</sup>

Logs are stored in tables, and each table has a schema that determines the columns used to store records from one or more data sources. <sup>[[14]](#source-14)</sup>

Azure tables have predefined schemas for Azure services, custom tables can be defined for non-Azure or custom data sources, and search results tables are created from search jobs. <sup>[[14]](#source-14)</sup>

The most exam-relevant idea is that a logging solution is a data architecture decision before it is a visualization or alerting decision. <sup>[[2]](#source-2), [[4]](#source-4), [[5]](#source-5), [[14]](#source-14)</sup>

When a question says the organization needs to troubleshoot, investigate, query, correlate, audit, or retain operational data, the default Azure-native answer is usually Azure Monitor Logs with one or more Log Analytics workspaces. <sup>[[2]](#source-2), [[4]](#source-4), [[5]](#source-5), [[22]](#source-22)</sup>

When a question says the organization only needs long-term compliance storage and rarely queries the records, the logging solution may still include Log Analytics long-term retention or may shift toward archival as part of a routing task. <sup>[[16]](#source-16), [[7]](#source-7), [[9]](#source-9), [[22]](#source-22)</sup>

When a question says the organization needs near-real-time querying, correlation, troubleshooting, and analytics, Log Analytics workspace storage is the more relevant design center than raw archival storage. <sup>[[2]](#source-2), [[4]](#source-4), [[16]](#source-16), [[22]](#source-22)</sup>

---

## 3. Know the major log source categories

A logging recommendation starts by identifying the source of the records because Azure Monitor uses different collection methods for different types of data. <sup>[[3]](#source-3)</sup>

Azure resources generate a standard set of monitoring data, and Microsoft recommends starting by understanding and configuring the collection of this core data. <sup>[[3]](#source-3)</sup>

The Azure Activity Log records subscription-level control-plane events and can be viewed at the subscription, resource group, or resource level. <sup>[[6]](#source-6)</sup>

The Activity Log is automatically collected, but diagnostic settings are used when you need to send Activity Log entries to another destination. <sup>[[9]](#source-9)</sup>

Azure resource logs describe operations performed inside or by an Azure resource, and they are different from the Activity Log because they are resource-specific rather than subscription-level control-plane events. <sup>[[7]](#source-7), [[8]](#source-8)</sup>

Azure resource logs are not collected by default, so collecting them requires a diagnostic setting. <sup>[[9]](#source-9)</sup>

Resource log categories are the granularity at which logs can be enabled or disabled for a particular resource, and common category names include Audit, Operational, Execution, and Request. <sup>[[8]](#source-8)</sup>

Guest operating system logs from Azure VMs, non-Azure VMs, and Arc-enabled servers require an agent because Azure cannot see inside the guest operating system without one. <sup>[[10]](#source-10)</sup>

Azure Monitor Agent collects guest operating system monitoring data from Azure and hybrid VMs and sends that data to Azure Monitor. <sup>[[10]](#source-10)</sup>

Azure Monitor Agent uses data collection rules to define what data is collected, how it is processed, and where it is sent. <sup>[[10]](#source-10), [[11]](#source-11)</sup>

Application logs and application telemetry can be consolidated into Log Analytics by using workspace-based Application Insights. <sup>[[20]](#source-20)</sup>

Workspace-based Application Insights gives application telemetry access to Log Analytics capabilities and can reduce cross-workspace or cross-application query complexity when the telemetry is sent to a common workspace. <sup>[[20]](#source-20)</sup>

Microsoft Entra activity logs include audit logs, sign-in logs, and provisioning logs, so identity logging requirements should not be treated as the same thing as Azure resource logging. <sup>[[21]](#source-21)</sup>

Microsoft Entra activity logs can be integrated with Azure Monitor Logs when the organization needs richer querying, longer analysis patterns, and integration with Log Analytics. <sup>[[22]](#source-22), [[23]](#source-23)</sup>

Custom logs can be sent to a Log Analytics workspace by using the Logs Ingestion API, which supports REST API calls and client libraries. <sup>[[13]](#source-13)</sup>

The Logs Ingestion API can send data to supported Azure tables, custom tables, and Azure tables extended with custom columns. <sup>[[13]](#source-13)</sup>

---

## 4. Decide on the log store first

The first major design decision is whether the logs should land in Log Analytics for query and analysis, remain available only through native service blades, be archived primarily for retention, or be streamed to another platform. <sup>[[2]](#source-2), [[4]](#source-4), [[7]](#source-7), [[22]](#source-22)</sup>

For the AZ-305 logging task, Log Analytics is usually the main service to evaluate because it is the Azure Monitor Logs data store and supports query, retention, table configuration, access control, and cost management. <sup>[[2]](#source-2), [[4]](#source-4), [[14]](#source-14), [[16]](#source-16), [[17]](#source-17), [[18]](#source-18)</sup>

A single workspace is usually simpler and can centralize analysis, retention management, access patterns, and cost control when there are no conflicting requirements. <sup>[[5]](#source-5)</sup>

Multiple workspaces are justified when requirements differ for region, data ownership, data segregation, billing, retention, or resilience. <sup>[[5]](#source-5)</sup>

A separate workspace by region can be appropriate when data residency requirements require data to remain in a particular geography. <sup>[[5]](#source-5)</sup>

A separate workspace by data owner can be appropriate when subsidiaries, affiliated companies, or internal business units require monitoring data segregation. <sup>[[5]](#source-5)</sup>

A separate workspace by cost owner can be appropriate when chargeback or billing separation cannot be handled with Cost Management or log queries. <sup>[[5]](#source-5), [[17]](#source-17)</sup>

A separate workspace by retention need can be appropriate when different resources send data to the same table but require different retention settings. <sup>[[5]](#source-5), [[16]](#source-16)</sup>

A design that creates many workspaces without clear requirements can increase complexity for queries, access management, cost optimization, and operational consistency. <sup>[[5]](#source-5), [[19]](#source-19)</sup>

A design that forces all data into one workspace despite residency, ownership, security, or retention conflicts can fail compliance and operating-model requirements. <sup>[[5]](#source-5), [[18]](#source-18), [[19]](#source-19)</sup>

---

## 5. Workspace architecture decision framework

Start with one shared workspace unless the scenario gives a specific reason to separate workspaces. <sup>[[5]](#source-5)</sup>

Separate workspaces for geography when the scenario says data must remain in a particular geography or region. <sup>[[5]](#source-5)</sup>

Separate workspaces for data ownership when different organizations or business units require hard boundaries between their monitoring data. <sup>[[5]](#source-5)</sup>

Separate workspaces for billing when chargeback requires workspace-level cost separation and query-based reporting is not granular enough. <sup>[[5]](#source-5), [[17]](#source-17)</sup>

Separate workspaces for retention when different resources send to the same table but require different retention policies that cannot be represented at table level. <sup>[[5]](#source-5), [[16]](#source-16)</sup>

Consider a dedicated cluster when aggregate ingestion is high enough to justify commitment-tier economics or when advanced capabilities such as customer-managed keys are required. <sup>[[5]](#source-5), [[24]](#source-24), [[25]](#source-25)</sup>

Consider workspace replication when the scenario emphasizes data availability during regional failure and the requirement is to keep queryable copies of a workspace in another region. <sup>[[26]](#source-26)</sup>

Do not split workspaces only because resources are in different subscriptions unless the scenario ties subscription boundaries to ownership, billing, access, retention, or compliance requirements. <sup>[[5]](#source-5), [[18]](#source-18)</sup>

Do not assume every application needs a separate workspace because workspace-based Application Insights can send multiple application telemetry streams into a common Log Analytics workspace when common analysis and RBAC are desired. <sup>[[20]](#source-20)</sup>

Do not assume every environment needs the same retention period because table-level retention and workspace-level retention can be configured differently. <sup>[[4]](#source-4), [[16]](#source-16)</sup>

---

## 6. Table design, schema, and table plans

A Log Analytics workspace is made up of tables, and table design controls the data model, access possibilities, and cost-management options. <sup>[[14]](#source-14)</sup>

Each table has a schema, and the schema is the set of columns into which Azure Monitor Logs stores records from one or more data sources. <sup>[[14]](#source-14)</sup>

Azure tables are created automatically based on Azure services and configured diagnostic settings, and they use predefined schemas. <sup>[[14]](#source-14)</sup>

Custom tables are appropriate for non-Azure data, file-based logs, or other sources where you need to define how the data should be stored. <sup>[[14]](#source-14), [[13]](#source-13)</sup>

Search results tables are generated by search jobs and are useful when you retrieve data from long-term retention or scan large data volumes. <sup>[[14]](#source-14), [[28]](#source-28)</sup>

Table plan selection matters because Analytics, Basic, and Auxiliary plans have different query, retention, and cost characteristics. <sup>[[2]](#source-2), [[15]](#source-15), [[16]](#source-16)</sup>

Use the Analytics plan when the data needs rich analytics, broad query support, near-real-time operational use, or frequent troubleshooting. <sup>[[2]](#source-2), [[15]](#source-15), [[16]](#source-16)</sup>

Use a lower-cost plan only when the data is lower-touch and the scenario can tolerate the query and feature tradeoffs described for the table plan. <sup>[[15]](#source-15), [[16]](#source-16), [[17]](#source-17)</sup>

Changing a table from Analytics to Basic treats data older than 30 days as long-term retention data based on the table’s total retention period. <sup>[[15]](#source-15)</sup>

A table plan can be switched only once per week, so table-plan decisions should be treated as part of the design rather than as a casual operational toggle. <sup>[[15]](#source-15)</sup>

For exam purposes, table plans are strongest when paired with the data-use pattern: frequently queried operational data belongs in Analytics, while lower-touch data may fit a cheaper plan or long-term retention strategy. <sup>[[15]](#source-15), [[16]](#source-16), [[17]](#source-17)</sup>

---

## 7. Retention design

A Log Analytics workspace retains data in interactive retention and long-term retention states. <sup>[[4]](#source-4), [[16]](#source-16)</sup>

Interactive retention is the period during which data is available for queries, visualizations, alerts, and related features based on the table plan. <sup>[[4]](#source-4), [[16]](#source-16)</sup>

Long-term retention is a lower-cost state where data is not available for table-plan features but can be accessed through search jobs. <sup>[[16]](#source-16), [[28]](#source-28)</sup>

By default, Log Analytics tables retain data for 30 days unless they are tables with a 90-day default retention period. <sup>[[16]](#source-16)</sup>

Each table in a Log Analytics workspace can retain data up to 12 years in long-term retention. <sup>[[4]](#source-4)</sup>

Use table-level retention when different categories of log data have different business, compliance, or troubleshooting value. <sup>[[4]](#source-4), [[16]](#source-16)</sup>

Use separate workspaces when different resources send to the same table but require different retention settings that cannot be represented within one workspace-table combination. <sup>[[5]](#source-5), [[16]](#source-16)</sup>

Treat retention as part of the logging solution because most Azure Monitor cost is driven by ingestion and retention in Log Analytics workspaces. <sup>[[17]](#source-17)</sup>

Avoid collecting logs for “just in case” scenarios unless the scenario justifies the cost, because Microsoft explicitly recommends not collecting more data than required. <sup>[[3]](#source-3), [[17]](#source-17), [[19]](#source-19)</sup>

Use search jobs when the organization needs to retrieve records from long-term retention or from lower-cost table plans into a new Analytics table for deeper analysis. <sup>[[28]](#source-28)</sup>

---

## 8. Cost design

The largest charges for most Azure Monitor implementations are usually ingestion and retention of data in Log Analytics workspaces. <sup>[[17]](#source-17)</sup>

A cost-aware logging recommendation should limit collection to required data, choose appropriate table plans, choose appropriate retention settings, and consider commitment tiers when ingestion volume is predictable. <sup>[[3]](#source-3), [[5]](#source-5), [[15]](#source-15), [[16]](#source-16), [[17]](#source-17)</sup>

Commitment tiers can reduce ingestion cost when the organization commits to a minimum daily ingestion amount in a workspace. <sup>[[5]](#source-5), [[17]](#source-17)</sup>

Consolidating logs into one workspace can help an organization reach a commitment tier, while spreading the same volume across many workspaces can prevent the organization from receiving the same tier benefit unless a dedicated cluster is used. <sup>[[5]](#source-5), [[25]](#source-25)</sup>

A daily cap can control ingestion growth, but it must be used carefully because dropped or throttled log ingestion can create visibility gaps. <sup>[[17]](#source-17), [[20]](#source-20)</sup>

Application Insights daily cap behavior must be considered alongside the underlying Log Analytics workspace because workspace-based Application Insights stores data in a Log Analytics workspace. <sup>[[20]](#source-20), [[17]](#source-17)</sup>

Data collection rules can reduce cost when they filter or transform incoming data before it lands in the destination. <sup>[[11]](#source-11), [[22]](#source-22)</sup>

A strong cost answer explains why specific logs are collected, why specific logs are excluded, and why the chosen retention period matches the business need. <sup>[[3]](#source-3), [[16]](#source-16), [[17]](#source-17), [[19]](#source-19)</sup>

---

## 9. Access and security design

Log access design matters because a workspace can contain data from many resources, applications, tenants, teams, or environments. <sup>[[4]](#source-4), [[18]](#source-18)</sup>

Workspace access can be governed through explicit workspace permissions or through resource-context access depending on the workspace access control mode. <sup>[[18]](#source-18)</sup>

In workspace-context mode, users with workspace access can query data in tables for which they have permissions. <sup>[[18]](#source-18)</sup>

In resource-context mode, users can query logs for the specific resources, resource groups, or subscriptions they can access, without being granted access to all workspace data. <sup>[[18]](#source-18)</sup>

Resource-context RBAC can allow resource owners to access logs for resources they manage without granting broad workspace permissions. <sup>[[5]](#source-5), [[18]](#source-18)</sup>

A design that centralizes logs should still preserve least-privilege access by using workspace access mode, table-level access, resource-context access, and appropriate Azure RBAC assignments. <sup>[[18]](#source-18), [[19]](#source-19)</sup>

A separate workspace can be the cleaner answer when the security boundary is organizational, contractual, regulatory, or otherwise stronger than table-level or resource-context access controls. <sup>[[5]](#source-5), [[18]](#source-18)</sup>

Customer-managed keys can provide additional control over the encryption key lifecycle for Log Analytics data when logs are linked to a dedicated cluster. <sup>[[24]](#source-24), [[25]](#source-25)</sup>

Customer-managed keys for Azure Monitor Logs are regional, and the Key Vault, dedicated cluster, and linked workspaces must be in the same region. <sup>[[24]](#source-24)</sup>

A logging design that uses customer-managed keys should include operational ownership of the key lifecycle because the key is part of access to encrypted log data. <sup>[[24]](#source-24)</sup>

---

## 10. Ingestion and collection mechanisms

Choose the collection mechanism based on the source rather than trying to force every log type through the same path. <sup>[[3]](#source-3), [[11]](#source-11)</sup>

Use diagnostic settings for Azure resource logs because resource logs are not collected by default. <sup>[[7]](#source-7), [[9]](#source-9)</sup>

Use diagnostic settings when Activity Log entries need to be sent outside their default collection experience. <sup>[[6]](#source-6), [[9]](#source-9)</sup>

Use Azure Monitor Agent for guest operating system logs from Azure VMs, other-cloud VMs, and on-premises machines because the agent can access local logs and performance data. <sup>[[10]](#source-10)</sup>

Use data collection rules with Azure Monitor Agent to define which events or performance data should be collected and where the data should be sent. <sup>[[10]](#source-10), [[11]](#source-11)</sup>

Use data collection rule associations to connect data collection rules to resources, and remember that a resource can be associated with multiple data collection rules. <sup>[[11]](#source-11)</sup>

Use the Logs Ingestion API for applications, agents, or custom sources that can send JSON payloads through REST or client libraries. <sup>[[13]](#source-13)</sup>

Use a custom table when the source data does not fit an existing Azure table or when you need to define a schema for a non-Azure source. <sup>[[13]](#source-13), [[14]](#source-14)</sup>

Use a data collection rule stream declaration for custom data sent through the Logs Ingestion API because custom data can have any schema. <sup>[[12]](#source-12), [[13]](#source-13)</sup>

Use workspace-based Application Insights when the requirement is to consolidate application telemetry into Log Analytics and use a common workspace model. <sup>[[20]](#source-20)</sup>

Use Microsoft Entra diagnostic integration when the requirement is to analyze audit, sign-in, or provisioning logs in Azure Monitor Logs. <sup>[[21]](#source-21), [[22]](#source-22), [[23]](#source-23)</sup>

---

## 11. Microsoft Entra logging decisions

Microsoft Entra audit logs record the history of tasks performed in the tenant, so they are relevant to identity governance, configuration change tracking, and administrative audit scenarios. <sup>[[21]](#source-21), [[22]](#source-22)</sup>

Microsoft Entra sign-in logs capture sign-in attempts from users and client applications, so they are relevant to authentication troubleshooting and identity investigation scenarios. <sup>[[21]](#source-21), [[22]](#source-22)</sup>

Microsoft Entra provisioning logs provide information about users provisioned through third-party services, so they are relevant when the organization needs to troubleshoot or audit automated provisioning activity. <sup>[[21]](#source-21), [[22]](#source-22)</sup>

Microsoft recommends considering the overall task when choosing how to integrate Microsoft Entra activity logs for storage or analysis. <sup>[[22]](#source-22)</sup>

For basic troubleshooting that does not require retention beyond 30 days, the Microsoft Entra admin center or Microsoft Graph API can be sufficient. <sup>[[22]](#source-22)</sup>

For longer retention with frequent query needs, Microsoft recommends sending Microsoft Entra activity logs to Azure Monitor Logs when a third-party SIEM is not the design center. <sup>[[22]](#source-22)</sup>

The Microsoft Entra schema matters because the Azure Monitor schema can differ from the Microsoft Graph schema. <sup>[[23]](#source-23)</sup>

Common Microsoft Entra log fields such as correlation ID, result status, UTC timestamp, initiatedBy, targetResources, and sign-in risk fields help determine whether the logs support the investigation scenario. <sup>[[23]](#source-23)</sup>

An AZ-305 identity logging answer should identify the needed Entra log type before deciding whether the destination is Log Analytics, storage, Event Hubs, Microsoft Sentinel, or a native portal view. <sup>[[21]](#source-21), [[22]](#source-22), [[23]](#source-23)</sup>

---

## 12. Application logging decisions

Application Insights is relevant to a logging solution when the scenario involves application telemetry, failures, dependencies, traces, requests, or custom application data that should be stored and analyzed with Azure Monitor. <sup>[[20]](#source-20)</sup>

A workspace-based Application Insights resource sends telemetry to a common Log Analytics workspace and gives that telemetry access to Log Analytics capabilities. <sup>[[20]](#source-20)</sup>

A common workspace can reduce cross-app and cross-workspace query complexity when the application estate should be analyzed together. <sup>[[20]](#source-20)</sup>

A managed Application Insights workspace may be acceptable for a simple application, but an explicitly chosen Log Analytics workspace is usually stronger for enterprise designs that require shared access control, retention planning, and cost governance. <sup>[[20]](#source-20), [[5]](#source-5), [[18]](#source-18)</sup>

Application logging cost must account for both the Application Insights resource and the underlying Log Analytics workspace because workspace-based Application Insights data is stored in the workspace. <sup>[[20]](#source-20), [[17]](#source-17)</sup>

For exam purposes, do not answer an application logging question with only VM guest logs because application telemetry is a different source category from operating system event logs. <sup>[[3]](#source-3), [[10]](#source-10), [[20]](#source-20)</sup>

---

## 13. Custom logging decisions

Use the Logs Ingestion API when the requirement is to send custom data from an application, custom agent, or other REST-capable source into Azure Monitor Logs. <sup>[[13]](#source-13)</sup>

The Logs Ingestion API supports sending data to custom tables, supported Azure tables, and Azure tables extended with custom columns. <sup>[[13]](#source-13)</sup>

The source payload must be JSON and must match the structure expected by the data collection rule. <sup>[[13]](#source-13)</sup>

The payload does not have to match the target table exactly because a data collection rule can transform the incoming data to match the table structure. <sup>[[13]](#source-13)</sup>

The data collection rule contains the target table and workspace information used by the Logs Ingestion API flow. <sup>[[13]](#source-13)</sup>

Custom data sent through the Logs Ingestion API uses a stream declaration because custom data can have any schema. <sup>[[12]](#source-12), [[13]](#source-13)</sup>

A custom logging answer should include the custom table design, the DCR, the authentication model, the destination workspace, and the retention and table-plan choices. <sup>[[12]](#source-12), [[13]](#source-13), [[14]](#source-14), [[15]](#source-15), [[16]](#source-16)</sup>

---

## 14. Common AZ-305 scenario patterns

### Pattern 1: Centralized enterprise log analytics

Choose a centralized Log Analytics workspace when the organization needs a common place to query and analyze logs across resources and there are no strong separation requirements. <sup>[[2]](#source-2), [[4]](#source-4), [[5]](#source-5)</sup>

Use table-level retention, table plans, and access controls to tailor the centralized workspace rather than creating unnecessary workspaces. <sup>[[14]](#source-14), [[15]](#source-15), [[16]](#source-16), [[18]](#source-18)</sup>

Mention commitment tiers if ingestion volume is predictable and high enough to benefit from consolidated billing. <sup>[[5]](#source-5), [[17]](#source-17)</sup>

### Pattern 2: Regulated multi-region logging

Choose regional workspaces when the scenario requires log data to remain in a specific geography. <sup>[[5]](#source-5)</sup>

Consider workspace replication only when the scenario requires resilience of Log Analytics data across regions. <sup>[[26]](#source-26)</sup>

Avoid implying that regional workspace separation is required for every multi-region deployment because Microsoft’s workspace design guidance recommends a single workspace across regions when geography requirements do not require separation. <sup>[[5]](#source-5)</sup>

### Pattern 3: Departmental or subsidiary separation

Choose separate workspaces when each business unit or subsidiary owns its logs and requires clear data segregation. <sup>[[5]](#source-5)</sup>

Use workspace access control and resource-context access when the organization can safely centralize data but still needs scoped access. <sup>[[18]](#source-18)</sup>

Do not assume table-level access solves every segregation problem because some boundaries are organizational or contractual rather than technical convenience boundaries. <sup>[[5]](#source-5), [[18]](#source-18)</sup>

### Pattern 4: Hybrid server guest logs

Choose Azure Monitor Agent with data collection rules for Windows and Linux guest operating system logs from Azure, other clouds, or on-premises servers. <sup>[[10]](#source-10), [[11]](#source-11)</sup>

Use Azure Arc-enabled servers as the management bridge when the scenario involves non-Azure machines that need Azure Monitor Agent-based collection. <sup>[[10]](#source-10)</sup>

Define different DCRs for different server groups when collection requirements vary by workload, operating system, environment, or compliance requirement. <sup>[[11]](#source-11)</sup>

### Pattern 5: Azure resource diagnostics

Choose Azure resource logs when the requirement is to capture operational, audit, request, or execution events generated by specific Azure resources. <sup>[[7]](#source-7), [[8]](#source-8)</sup>

Use diagnostic settings because Azure resource logs are not collected by default. <sup>[[9]](#source-9)</sup>

Use the supported services and schemas documentation to verify which categories exist for the resource type. <sup>[[8]](#source-8)</sup>

### Pattern 6: Identity audit and sign-in analysis

Choose Microsoft Entra audit logs when the requirement is to know who changed tenant objects, applications, users, groups, roles, or policies. <sup>[[21]](#source-21), [[23]](#source-23)</sup>

Choose Microsoft Entra sign-in logs when the requirement is to investigate user or application sign-in behavior. <sup>[[21]](#source-21), [[23]](#source-23)</sup>

Choose Microsoft Entra provisioning logs when the requirement is to troubleshoot or audit user provisioning activity to non-Microsoft applications. <sup>[[21]](#source-21), [[22]](#source-22)</sup>

### Pattern 7: Custom application or appliance logs

Choose the Logs Ingestion API when the source can send JSON records through REST or client libraries and the data should land in Log Analytics. <sup>[[13]](#source-13)</sup>

Create a custom table when the custom data needs its own schema. <sup>[[13]](#source-13), [[14]](#source-14)</sup>

Use DCR transformations to shape incoming custom data before it lands in the target table. <sup>[[11]](#source-11), [[13]](#source-13)</sup>

---

## 15. What to exclude from this specific task

Do not over-focus on Event Hubs unless the question asks to stream logs to a third-party SIEM or external processing system. <sup>[[1]](#source-1), [[7]](#source-7), [[22]](#source-22)</sup>

Do not over-focus on Storage Accounts unless the question asks for archival, long-term raw storage, or a routing destination outside Log Analytics. <sup>[[1]](#source-1), [[7]](#source-7), [[9]](#source-9), [[22]](#source-22)</sup>

Do not over-focus on Azure Monitor alerts because alerting belongs more directly to monitoring solution design than logging solution design. <sup>[[1]](#source-1), [[2]](#source-2)</sup>

Do not over-focus on dashboards and workbooks because those are consumption and visualization patterns rather than the core logging architecture. <sup>[[1]](#source-1), [[2]](#source-2), [[22]](#source-22)</sup>

Do not over-focus on Microsoft Sentinel unless the scenario is specifically about SIEM, security detection, threat hunting, or security operations integration. <sup>[[22]](#source-22), [[1]](#source-1)</sup>

Do not answer every question with “create a diagnostic setting” because diagnostic settings are one collection mechanism and do not by themselves define the workspace architecture, table plan, retention, cost, or access model. <sup>[[9]](#source-9), [[5]](#source-5), [[14]](#source-14), [[16]](#source-16), [[17]](#source-17), [[18]](#source-18)</sup>

---

## 16. Decision checklist

Identify the source category first: Activity Log, resource logs, guest operating system logs, application telemetry, Microsoft Entra logs, or custom logs. <sup>[[3]](#source-3), [[6]](#source-6), [[7]](#source-7), [[10]](#source-10), [[20]](#source-20), [[21]](#source-21), [[13]](#source-13)</sup>

Choose Log Analytics when the logs need centralized querying, correlation, analysis, retention management, or integration with Azure Monitor Logs. <sup>[[2]](#source-2), [[4]](#source-4), [[27]](#source-27)</sup>

Choose a single workspace when requirements can be satisfied with shared storage, table-level configuration, resource-context access, and shared cost management. <sup>[[5]](#source-5), [[18]](#source-18)</sup>

Choose multiple workspaces when the scenario requires separation by geography, owner, billing, retention, or resilience. <sup>[[5]](#source-5), [[16]](#source-16)</sup>

Choose Azure Monitor Agent and DCRs for guest operating system logs and hybrid server log collection. <sup>[[10]](#source-10), [[11]](#source-11)</sup>

Choose diagnostic settings for Azure resource logs because they are not collected by default. <sup>[[7]](#source-7), [[9]](#source-9)</sup>

Choose workspace-based Application Insights for application telemetry that should be stored in and queried from Log Analytics. <sup>[[20]](#source-20)</sup>

Choose the Logs Ingestion API and a custom table when the logs come from a custom source that can send JSON data. <sup>[[13]](#source-13), [[14]](#source-14)</sup>

Choose the Analytics table plan for data that requires frequent or rich query and troubleshooting workflows. <sup>[[15]](#source-15), [[16]](#source-16)</sup>

Choose lower-cost table plans or long-term retention for lower-touch data when the scenario can tolerate the feature and query tradeoffs. <sup>[[15]](#source-15), [[16]](#source-16), [[17]](#source-17)</sup>

Set retention based on business, compliance, and troubleshooting requirements rather than a default assumption that all data needs the same duration. <sup>[[5]](#source-5), [[16]](#source-16)</sup>

Design access with workspace access mode, resource-context permissions, table-level access, or separate workspaces depending on the sensitivity and ownership of the log data. <sup>[[18]](#source-18), [[5]](#source-5)</sup>

Evaluate cost by considering ingestion volume, retention duration, table plans, transformation opportunities, commitment tiers, and workspace consolidation. <sup>[[3]](#source-3), [[5]](#source-5), [[11]](#source-11), [[15]](#source-15), [[16]](#source-16), [[17]](#source-17)</sup>

---

## 17. Fast exam traps

If the question says **resource logs are missing**, remember that resource logs are not collected by default and require diagnostic settings. <sup>[[9]](#source-9)</sup>

If the question says **VM guest event logs are required**, choose Azure Monitor Agent and DCRs rather than only diagnostic settings. <sup>[[10]](#source-10), [[11]](#source-11)</sup>

If the question says **application telemetry should be queried with infrastructure logs**, prefer workspace-based Application Insights using a Log Analytics workspace. <sup>[[20]](#source-20), [[4]](#source-4)</sup>

If the question says **custom JSON records must be ingested**, prefer the Logs Ingestion API, DCR, and custom table design. <sup>[[13]](#source-13), [[12]](#source-12), [[14]](#source-14)</sup>

If the question says **data residency differs by geography**, prefer regional workspace separation. <sup>[[5]](#source-5)</sup>

If the question says **different groups require hard data separation**, prefer separate workspaces or strong access boundaries rather than assuming a single shared workspace is always acceptable. <sup>[[5]](#source-5), [[18]](#source-18)</sup>

If the question says **retention differs by log category**, consider table-level retention before creating additional workspaces. <sup>[[16]](#source-16), [[5]](#source-5)</sup>

If the question says **retention differs for data that lands in the same table from different resources**, consider separate workspaces because table-level retention might not distinguish the data by resource within the same table. <sup>[[5]](#source-5), [[16]](#source-16)</sup>

If the question says **query older data occasionally**, consider long-term retention and search jobs rather than keeping all data in expensive interactive retention. <sup>[[16]](#source-16), [[28]](#source-28), [[17]](#source-17)</sup>

If the question says **high predictable ingestion volume**, consider commitment tiers and possibly a dedicated cluster. <sup>[[5]](#source-5), [[17]](#source-17), [[25]](#source-25)</sup>

If the question says **customer-managed keys for Log Analytics**, remember that CMK requires a dedicated cluster and has regional constraints. <sup>[[24]](#source-24), [[25]](#source-25)</sup>

---

## 18. Recommended documentation reading order

Read the AZ-305 study guide first to anchor the task boundary and avoid drifting into adjacent routing and monitoring tasks. <sup>[[1]](#source-1)</sup>

Read the Azure Monitor Logs overview next to understand the common logging platform, collection pipeline, workspace tables, cost controls, retention controls, and query use cases. <sup>[[2]](#source-2)</sup>

Read the Azure Monitor data sources page next to classify the source type before choosing a collection method. <sup>[[3]](#source-3)</sup>

Read the Log Analytics workspace overview next to understand the workspace as the primary log data store. <sup>[[4]](#source-4)</sup>

Read the workspace architecture article next because it contains the most exam-relevant guidance for single-workspace versus multi-workspace decisions. <sup>[[5]](#source-5)</sup>

Read the Activity Log, resource logs, resource schema, and diagnostic settings articles together because they explain the difference between control-plane logs, resource-specific logs, log categories, and collection requirements. <sup>[[6]](#source-6), [[7]](#source-7), [[8]](#source-8), [[9]](#source-9)</sup>

Read the Azure Monitor Agent and data collection rule articles together because they explain guest OS and hybrid collection. <sup>[[10]](#source-10), [[11]](#source-11)</sup>

Read the DCR structure and Logs Ingestion API articles together because they explain custom ingestion and schema mapping. <sup>[[12]](#source-12), [[13]](#source-13)</sup>

Read the table, table plan, retention, cost, and access articles together because they determine whether the logging solution is operationally sustainable. <sup>[[14]](#source-14), [[15]](#source-15), [[16]](#source-16), [[17]](#source-17), [[18]](#source-18)</sup>

Read the Entra and Application Insights articles last to connect identity and application logging scenarios to the Log Analytics workspace model. <sup>[[20]](#source-20), [[21]](#source-21), [[22]](#source-22), [[23]](#source-23)</sup>

---

## 19. One-page mental model

A logging solution starts with the question **what records must exist for audit, troubleshooting, investigation, analytics, or compliance**. <sup>[[2]](#source-2), [[3]](#source-3), [[22]](#source-22)</sup>

The next question is **which service produces those records**. <sup>[[3]](#source-3), [[6]](#source-6), [[7]](#source-7), [[10]](#source-10), [[20]](#source-20), [[21]](#source-21), [[13]](#source-13)</sup>

The next question is **which collection method is required for that source**. <sup>[[3]](#source-3), [[9]](#source-9), [[10]](#source-10), [[11]](#source-11), [[13]](#source-13)</sup>

The next question is **which Log Analytics workspace or workspaces should store the data**. <sup>[[4]](#source-4), [[5]](#source-5)</sup>

The next question is **which tables, schemas, and table plans should hold the records**. <sup>[[14]](#source-14), [[15]](#source-15)</sup>

The next question is **how long the records must remain interactive and how long they must remain searchable or recoverable**. <sup>[[4]](#source-4), [[16]](#source-16), [[28]](#source-28)</sup>

The next question is **who can query the data and whether access should be workspace-scoped, resource-scoped, table-scoped, or separated by workspace**. <sup>[[18]](#source-18), [[5]](#source-5)</sup>

The last question is **whether the design controls ingestion and retention cost without removing records needed for required analysis**. <sup>[[3]](#source-3), [[17]](#source-17), [[19]](#source-19)</sup>

If you can answer those questions, you can usually recommend a logging solution without accidentally turning the answer into a routing or monitoring solution. <sup>[[1]](#source-1), [[2]](#source-2), [[5]](#source-5)</sup>

---

## Microsoft Learn source index

<a id="source-1"></a>**[1]** [Study guide for Exam AZ-305: Designing Microsoft Azure Infrastructure Solutions](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305)

<a id="source-2"></a>**[2]** [Azure Monitor Logs overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)

<a id="source-3"></a>**[3]** [Azure Monitor data sources and data collection methods](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources)

<a id="source-4"></a>**[4]** [Log Analytics workspace overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview)

<a id="source-5"></a>**[5]** [Design a Log Analytics workspace architecture](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design)

<a id="source-6"></a>**[6]** [Activity Log in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log)

<a id="source-7"></a>**[7]** [Resource logs in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs)

<a id="source-8"></a>**[8]** [Azure resource logs supported services and schemas](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs-schema)

<a id="source-9"></a>**[9]** [Diagnostic settings in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings)

<a id="source-10"></a>**[10]** [Azure Monitor Agent overview](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview)

<a id="source-11"></a>**[11]** [Data collection rules in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview)

<a id="source-12"></a>**[12]** [Structure of a data collection rule in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-structure)

<a id="source-13"></a>**[13]** [Logs Ingestion API in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview)

<a id="source-14"></a>**[14]** [Manage tables in a Log Analytics workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-logs-tables)

<a id="source-15"></a>**[15]** [Select a table plan based on data usage in a Log Analytics workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-table-plans)

<a id="source-16"></a>**[16]** [Manage data retention in a Log Analytics workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-configure)

<a id="source-17"></a>**[17]** [Azure Monitor Logs cost calculations and options](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs)

<a id="source-18"></a>**[18]** [Manage access to Log Analytics workspaces](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access)

<a id="source-19"></a>**[19]** [Best practices for Azure Monitor Logs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/best-practices-logs)

<a id="source-20"></a>**[20]** [Create and configure Application Insights resources](https://learn.microsoft.com/en-us/azure/azure-monitor/app/create-workspace-resource)

<a id="source-21"></a>**[21]** [What is Microsoft Entra monitoring and health?](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/overview-monitoring-health)

<a id="source-22"></a>**[22]** [Microsoft Entra activity log integration options](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-log-monitoring-integration-options-considerations)

<a id="source-23"></a>**[23]** [Microsoft Entra activity logs schema](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-activity-log-schemas)

<a id="source-24"></a>**[24]** [Azure Monitor customer-managed keys](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/customer-managed-keys)

<a id="source-25"></a>**[25]** [Azure Monitor Logs Dedicated Clusters](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-dedicated-clusters)

<a id="source-26"></a>**[26]** [Enhance resilience by replicating your Log Analytics workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-replication)

<a id="source-27"></a>**[27]** [Overview of Log Analytics in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-overview)

<a id="source-28"></a>**[28]** [Run search jobs in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/search-jobs)
