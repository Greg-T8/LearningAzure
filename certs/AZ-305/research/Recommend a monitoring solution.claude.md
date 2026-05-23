# AZ-305 Study Guide: Recommend a Logging Solution

> **Exam task:** Design solutions for logging and monitoring — *Recommend a logging solution*
>
> **Estimated reading time:** 45 minutes
>
> **Scope boundary:** This guide covers the logging solution itself — what gets logged, where it's stored, and how collection is configured. The adjacent exam tasks "Recommend a solution for routing logs" (Event Hubs, storage accounts, partner integrations) and "Recommend a monitoring solution" (alerts, dashboards, Application Insights metrics) are deliberately excluded so you can study each task independently.

---

## How to use this guide

Read from top to bottom as if you were learning the topic from scratch. Each section builds on the previous one. By the end you should be able to answer questions like: "A customer has three Azure tenants, needs 7-year audit retention, and runs 200 VMs on-premises. What logging architecture would you recommend?"

After each major section there is a "Test yourself" block with the kinds of judgment calls the exam expects. The final section consolidates everything into a single decision framework.

---

## 1. The big picture: Azure Monitor's logging half

Azure Monitor has two data stores. Azure Monitor Metrics holds time-series numeric data. Azure Monitor Logs holds semi-structured log and trace data. This guide is entirely about the Logs side.

Azure Monitor Logs is a centralized SaaS platform for collecting, analyzing, and acting on telemetry from Azure and non-Azure resources. Its primary resource is the **Log Analytics workspace** — a single data store that can hold activity logs, resource logs, guest OS logs, application traces, security events, and custom data. Everything you "recommend" for logging ultimately flows into one or more of these workspaces.

The platform works in three stages:

1. **Collect** — data arrives from Azure platform logs, the Azure Monitor Agent on VMs, Application Insights SDKs, the Logs Ingestion API, or Event Hubs.
2. **Transform** — ingestion-time transformations (defined in data collection rules) can filter, enrich, or reshape data before it lands in a table.
3. **Store** — data lands in workspace tables, each assigned a table plan that controls cost, query performance, and retention.

> 📖 Read more: [Azure Monitor Logs overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)

---

## 2. Know your log types

Before you can recommend a solution, you need to know what kinds of logs Azure generates. There are three foundational types. Each has a different collection mechanism, and getting this taxonomy right is essential for the exam.

### 2.1 Activity log (control plane)

The activity log records every control-plane operation across your Azure subscriptions: who created or deleted a resource, who changed a network security group rule, which deployments failed. It is sometimes called the "management plane" log.

Key facts for exam purposes:

- The activity log is **generated automatically** for every Azure resource — you do not enable it.
- Entries are immutable; you cannot change or delete them.
- Azure retains activity log entries for **90 days** and then deletes them. There is no charge for entries during this period.
- To keep activity log data longer than 90 days, or to query it with KQL alongside other log data, you send it to a Log Analytics workspace by creating a **diagnostic setting**. Sending activity log data to a workspace is free (no ingestion charge).
- The activity log captures categories like Administrative, Service Health, Alert, Autoscale, Policy, Recommendation, Security, and Resource Health.

The critical design point: if a customer needs to retain control-plane audit records for compliance (for example, 1 year or 7 years), you must create a diagnostic setting that sends the activity log to a Log Analytics workspace, a storage account, or both.

> 📖 Read more: [Azure Monitor activity log](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log)

### 2.2 Resource logs (data plane)

Resource logs provide insight into data-plane operations performed *within* a resource. For example, reading a secret from Key Vault, executing a query against SQL Database, or processing a message in Service Bus. Every Azure service emits its own set of resource log categories with service-specific schemas.

Key facts:

- **Resource logs are not collected by default.** You must explicitly create a diagnostic setting on each resource (or use Azure Policy to do this at scale).
- When sent to a Log Analytics workspace, resource logs can be written in two collection modes:
  - **Azure diagnostics mode** — all categories for a resource are written to a single shared table called `AzureDiagnostics`. Older and simpler, but the table can become very wide and hard to query.
  - **Resource-specific mode** — each log category gets its own dedicated table (for example, `AzureKeyVaultAuditEvents`). This is the recommended mode for new deployments because it provides cleaner schemas, better query performance, and finer-grained retention and access control.
- Resource logs use a store-and-forward architecture that is not transactionally guaranteed. Small data losses can occur during transient platform issues, though this is rare.
- A single diagnostic setting supports no more than **one destination of each type**. If you need to send resource logs to two different Log Analytics workspaces, create two diagnostic settings.
- Each resource can have up to **five diagnostic settings**.

> 📖 Read more: [Resource logs in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs)

### 2.3 Guest OS logs (from VMs and servers)

Azure VMs automatically generate activity logs and host-level platform metrics, but these only describe the VM *host*. To collect Windows Event Logs, Linux Syslog, performance counters, IIS logs, or custom text/JSON log files from the guest operating system, you need the **Azure Monitor Agent** and a **data collection rule** (covered in Sections 4 and 5).

### 2.4 Application logs

Application-level logging in Azure Monitor is handled by Application Insights, which collects request traces, exceptions, dependency calls, and custom telemetry from your code. Application Insights stores its data in a Log Analytics workspace, so it participates in the same workspace design decisions covered in Section 3. For exam purposes, remember that Application Insights is the logging solution for application code, and it feeds into the same platform.

### 2.5 Microsoft Entra ID logs

Audit logs and sign-in logs from Microsoft Entra ID (formerly Azure AD) are similar to Azure activity logs but belong to the identity plane. They also require a diagnostic setting to be sent to a Log Analytics workspace. If a scenario mentions identity governance or sign-in auditing, include Entra ID diagnostic settings in your logging recommendation.

> 📖 Read more: [Azure Monitor data sources and data collection methods](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources)

### Test yourself — Log types

- A compliance officer asks you to guarantee zero data loss for resource logs. What do you tell them? *(Answer: Resource logs are not transactionally guaranteed; small losses can occur. For strict audit requirements, consider also using immutable blob storage as a second destination.)*
- A customer says their activity log entries disappear after three months. Is this a bug? *(Answer: No. Azure retains activity log entries for 90 days by default. Create a diagnostic setting to send them to a workspace or storage account for longer retention.)*

---

## 3. Designing the Log Analytics workspace architecture

This is the highest-value section for the exam. "Recommend a logging solution" overwhelmingly means "design the right workspace topology." The workspace is where cost, access control, retention, resilience, and query scope all intersect.

### 3.1 Start with one workspace

The official Microsoft guidance is to **start with a single workspace** and only add more when a specific requirement forces you to. A single workspace is simpler to manage, easier to query across, and lets you reach higher commitment tiers for cost savings. There are no performance limits from the amount of data in a workspace — you will not "outgrow" one.

### 3.2 Design criteria that force additional workspaces

Only create additional workspaces when you cannot meet a requirement with a single workspace. The following criteria are the ones tested on the exam:

**Azure tenants.** Most resources can only send logs to a workspace in the same tenant. If you have multiple Entra tenants, you will generally need at least one workspace per tenant. Exception: the Azure Monitor Agent can send VM data across tenants, which matters for managed-service-provider scenarios.

**Azure regions and data sovereignty.** A workspace lives in one Azure region. If regulations require that logs stay within a specific geography (for example, EU data must not leave the EU), you need a workspace in that geography. Note that sending resource logs via diagnostic settings across regions does not incur egress charges, but sending VM telemetry via the agent does.

**Data ownership and organizational boundaries.** If subsidiaries or affiliated companies must not see each other's data and table-level RBAC or resource-context access is insufficient, use separate workspaces.

**Split billing.** Workspaces in different subscriptions can be billed to different parties. However, you can often use Azure Cost Management queries to break down cost by resource group or subscription within a single workspace, so evaluate whether a truly separate workspace is needed.

**Data retention divergence.** You can set per-table retention within a single workspace (each table can have its own retention period). You only need a separate workspace if you require different retention for different *resources that write to the same table*. For example, if VM A and VM B both write to the Syslog table but VM A needs 30-day retention and VM B needs 2-year retention, you need two workspaces.

**Commitment tiers and cost optimization.** Commitment tiers (100 GB/day, 200 GB/day, and up) provide ingestion discounts. Consolidating data into fewer workspaces makes it easier to reach a higher tier. Splitting into too many workspaces may prevent you from qualifying for any tier discount.

**Operational vs. security data.** If you run Microsoft Sentinel alongside Azure Monitor, you must decide whether Sentinel shares a workspace with operational logs or gets its own:
  - *Combined workspace:* better cross-query visibility and potentially qualifies for a higher commitment tier. Sentinel gives 90 days of free retention (vs. the default 31) to the entire workspace.
  - *Separate workspaces:* cleaner ownership boundary between SOC and operations teams. May avoid applying Sentinel pricing to purely operational data. Choose this if your security team requires a dedicated environment.
  - Microsoft Defender for Cloud should generally share the Sentinel workspace so security data stays in one place.

**Access control.** Azure Monitor supports workspace-level RBAC, table-level RBAC, and resource-context access. Resource-context access lets a resource owner query logs about their own resources without seeing the rest of the workspace. If these controls are sufficient, you can avoid creating extra workspaces just for access separation. Set the workspace access control mode to "Use resource or workspace permissions" to enable this.

**Resilience.** For protection against regional outages, you can enable **workspace replication** (replicates to a secondary region) or use **continuous data export** to a geo-redundant storage account. Within a single region, **availability zones** provide automatic protection against datacenter-level failures. Workspace replication is the most comprehensive option but is a paid feature.

### 3.3 Decision flow (simplified)

```
Start with 1 workspace
│
├─ Multiple tenants? → 1 workspace per tenant (minimum)
│
├─ Data sovereignty requirements? → 1 workspace per required geography
│
├─ Need to separate Sentinel from operational data? → Split into 2 workspaces
│   (but evaluate commitment tier savings of combining)
│
├─ Irreconcilable retention for same-table data? → Additional workspace
│
├─ Hard billing separation needed beyond what Cost Management provides? → Additional workspace
│
└─ Otherwise → Keep everything in the single workspace
    Use table-level RBAC and resource-context access for granular control
```

> 📖 Read more: [Design a Log Analytics workspace architecture](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design)

### Test yourself — Workspace design

- A multinational company has Azure resources in West Europe and East US. EU law requires that EU data stay in Europe. They also run Microsoft Sentinel. How many workspaces minimum? *(Answer: At least 2 — one in a European region for EU resources with Sentinel enabled, one in a US region. If they want to separate Sentinel from operations, that could go higher.)*
- A startup has 40 GB/day of ingestion. Should they use one workspace or two? *(Answer: Almost certainly one. They are below the 100 GB/day commitment tier threshold, and splitting would add complexity without cost savings.)*
- A customer wants the security team to only see security tables and the ops team to only see performance tables, in the same workspace. Is this possible? *(Answer: Yes. Use table-level RBAC to grant each team read access to only the relevant tables.)*

---

## 4. Diagnostic settings: the collection mechanism for Azure resources

Diagnostic settings are the primary mechanism by which Azure PaaS and IaaS resources send their platform logs to destinations. Understanding them is essential for any logging recommendation.

### 4.1 What diagnostic settings collect

A diagnostic setting can collect three types of data from a resource:

| Source | Collected by default? | Notes |
|---|---|---|
| Platform metrics | Yes (stored in Metrics DB automatically) | A diagnostic setting can *also* send metrics to a workspace or storage account |
| Activity log | Yes (stored for 90 days automatically) | A diagnostic setting sends it to additional destinations for longer retention and cross-log querying |
| Resource logs | **No** | Must be explicitly enabled via a diagnostic setting |

### 4.2 Destinations

Each diagnostic setting sends data to one or more destinations:

- **Log Analytics workspace** — for KQL-based analysis, alerting, dashboards, Power BI integration, and correlation with other log data. This is the recommended primary destination for most scenarios.
- **Azure Storage account** — for long-term archival, audit compliance, or integration with external tools. Can be configured with immutable blob policies for tamper-proof retention. Must be in the same region as the resource (for regional resources).
- **Azure Event Hubs** — for streaming logs to external SIEM tools or third-party services in near-real-time.
- **Azure Monitor partner integrations** — for sending data to supported third-party monitoring solutions directly from the platform.

### 4.3 Constraints to remember

- A single diagnostic setting can have no more than **one of each destination type**. If you need two Log Analytics workspaces, create two settings.
- Each resource supports up to **five diagnostic settings**.
- The destination resource must **already exist** before you create the setting.
- You must allow trusted Microsoft services through any firewalls on Storage or Event Hubs.
- The setting's user needs appropriate RBAC on both the source resource and the destination.
- Diagnostic settings for the activity log are configured at the subscription level (Monitor → Activity log → Export Activity Logs), not on individual resources.

### 4.4 Category groups

Rather than selecting individual resource log categories, you can use **category groups** — predefined bundles like "allLogs" or "audit" — to simplify configuration and automatically pick up new categories as they are added by the service.

### 4.5 Scaling with Azure Policy

For enterprise environments with hundreds or thousands of resources, manually creating diagnostic settings is impractical. Use Azure Policy with the `DeployIfNotExists` effect to automatically create diagnostic settings on every new resource of a given type, sending logs to a designated workspace.

> 📖 Read more: [Diagnostic settings in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings)

### Test yourself — Diagnostic settings

- A customer wants to send Key Vault resource logs to both a Log Analytics workspace and a storage account. How many diagnostic settings do they need? *(Answer: One diagnostic setting can include both a workspace and a storage destination.)*
- A customer creates a diagnostic setting but forgets to select any resource log categories. What happens? *(Answer: Only metrics and/or activity log data flows, depending on what was selected. Resource logs require explicit category selection.)*

---

## 5. Collecting guest OS logs: Azure Monitor Agent and data collection rules

Diagnostic settings cover Azure platform-level logs. To collect logs from inside a virtual machine's operating system — Windows Event Logs, Linux Syslog, text files, IIS logs, performance counters — you need the **Azure Monitor Agent (AMA)** configured with **data collection rules (DCRs)**.

### 5.1 Azure Monitor Agent

The Azure Monitor Agent is the current, supported agent for collecting guest OS data. It replaces the legacy Log Analytics agent (MMA/OMS), which was retired on August 31, 2024.

Key characteristics:

- Installs as a VM extension on Azure VMs, Azure Arc-enabled servers (for on-premises or other-cloud machines), and Azure Virtual Machine Scale Sets.
- Supports both Windows and Linux.
- Can be installed on a single machine manually, or deployed at scale via Azure Policy, VM insights, or ARM templates.
- Has no cost itself — you pay only for the data ingested and stored.
- Authenticates using managed identity (more secure than the workspace keys used by the legacy agent).
- Configuration is entirely driven by data collection rules, not by workspace-level settings.

### 5.2 Data collection rules (DCRs)

DCRs are the modern, declarative configuration mechanism for data collection in Azure Monitor. They follow an extract-transform-load pattern:

1. **Extract** — the DCR tells the agent which data sources to collect (Windows events, Syslog facilities, performance counters, text log file paths, etc.) and can also describe the schema of incoming data.
2. **Transform** — an optional KQL-based transformation can filter rows, drop columns, enrich fields, parse delimited text, or mask sensitive data before ingestion.
3. **Load** — the DCR specifies which Log Analytics workspace and table the data should land in.

DCRs are stored as Azure resources, so they are managed via the portal, ARM/Bicep templates, CLI, or PowerShell — fully compatible with infrastructure-as-code.

### 5.3 Data collection rule associations (DCRAs)

A DCRA links a DCR to a specific resource (VM, scale set, etc.). The relationship is many-to-many: one DCR can be associated with many VMs, and one VM can be associated with up to 30 DCRs. This makes it easy to layer configurations — for example, one DCR for baseline Syslog on all servers, a second DCR for IIS logs on web servers only, and a third DCR for security events on Sentinel-monitored machines.

### 5.4 Beyond agents: other DCR scenarios

DCRs are not limited to the Azure Monitor Agent. They also govern:

- **Logs Ingestion API** — the REST-based API that replaces the legacy HTTP Data Collector API. Any custom application can send log data to a workspace by referencing a DCR, which validates the schema and applies transformations. Uses OAuth for authentication (more secure than workspace keys).
- **Workspace transformation DCR** — a special DCR that applies transformations to data arriving at a workspace from any source (including diagnostic settings), without requiring an agent. Useful for filtering out unwanted rows or masking PII across all incoming data.
- **Event Hubs ingestion** — DCRs can govern data collected from Event Hubs into a workspace.

### 5.5 Legacy agent migration

If an exam scenario mentions the Log Analytics agent, MMA, OMS agent, or workspace-based configuration, the recommended answer is always to migrate to the Azure Monitor Agent with data collection rules. The legacy agent is deprecated and no longer supported.

> 📖 Read more:
> - [Azure Monitor Agent overview](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview)
> - [Data collection rules in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview)

### Test yourself — Agent and DCRs

- A customer has 500 Linux VMs across Azure and an on-premises datacenter. They want to collect Syslog from all of them and IIS logs from the 50 that run web workloads. How would you configure this? *(Answer: Install Azure Monitor Agent on all VMs — Azure VMs via VM extension, on-premises VMs via Azure Arc + extension. Create one DCR for Syslog and associate it with all 500 VMs. Create a second DCR for IIS logs and associate it only with the 50 web servers.)*
- Can a DCR filter out specific Windows Event IDs before they are ingested? *(Answer: Yes. The DCR's transformation section can use a KQL `where` clause to drop events by ID, reducing ingestion cost.)*

---

## 6. Table plans: managing cost and retention

Once logs land in a workspace, the **table plan** determines the cost profile, query performance, and retention behavior of that data. This is a critical design lever for recommending a logging solution that balances cost and utility.

### 6.1 The three table plans

| Plan | Best for | Ingestion cost | Query cost | Query performance | Alerting | Analytics retention | Total max retention |
|---|---|---|---|---|---|---|---|
| **Analytics** | High-value operational and security data used for real-time detection, performance analysis, and dashboards | Standard | Included | Optimized (full KQL, cross-table joins) | Full alert support | 30 days default (90 with Sentinel/App Insights), extendable up to 2 years | Up to 12 years |
| **Basic** | Medium-touch data needed for troubleshooting and incident response — you query it occasionally but need it available | Reduced | Per-query charge | Good (full KQL on a single table, can `lookup` into Analytics tables) | Simple log alerts only | N/A | Up to 12 years |
| **Auxiliary** | Low-touch verbose data needed for audit, compliance, or rare forensic investigation | Minimal | Per-query charge | Slower — acceptable for auditing, not optimized for real-time analysis | No alerting | N/A | Up to 12 years |

### 6.2 Design guidance for table plans

When recommending a logging solution, assign each data type to the right plan:

- Security event tables used by Sentinel for active detection → **Analytics**
- Performance counters and application request logs used in dashboards → **Analytics**
- Verbose diagnostic logs from Azure Firewall or API Management that you query only during incidents → **Basic**
- Compliance audit trails that must be kept for 7 years and are rarely queried → **Auxiliary** (or archive to a storage account)
- Data that must drive automated alerting → must be **Analytics** or **Basic** (Auxiliary does not support alerts)

### 6.3 Retention tiers

Every table has two retention states:

- **Interactive retention** (formerly "analytics retention") — data is available for fast, ad-hoc KQL queries. Default is 30 days for Analytics plan tables.
- **Long-term retention** — data is kept in a low-cost cold tier. You can access it via search jobs or restore operations, but not via direct interactive queries. Total retention (interactive + long-term) can extend up to 12 years.

You configure retention at the table level, so different tables in the same workspace can have different retention periods. This is a key reason why you can often avoid creating extra workspaces just for retention differences.

> 📖 Read more: [Azure Monitor Logs overview — Table plans](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)

---

## 7. Best practices aligned to the Well-Architected Framework

Microsoft's best practices for Azure Monitor Logs map to the five pillars of the Well-Architected Framework. When the exam asks you to "recommend" something, grounding your answer in these pillars gives you a structured framework to evaluate trade-offs.

### Reliability

- Create workspaces in regions that support **availability zones** for automatic in-region protection against datacenter failures.
- For cross-region protection, enable **workspace replication** to a secondary region (this is a paid feature).
- Use **continuous data export** to a geo-redundant storage account as a backup mechanism for critical tables.
- Monitor workspace health using Log Analytics Workspace Insights.

### Security

- Set the workspace access control mode to **"Use resource or workspace permissions"** to enable resource-context access, so resource owners can query their own data without broad workspace access.
- Use **table-level RBAC** to restrict access to sensitive tables (for example, security event tables).
- Avoid using workspace keys for data submission; prefer managed identity (Azure Monitor Agent) or OAuth (Logs Ingestion API).

### Cost optimization

- Design the **fewest workspaces** that meet your requirements — consolidation enables commitment tier discounts.
- Assign verbose, low-value tables to the **Basic** or **Auxiliary** plan to reduce ingestion cost.
- Use **ingestion-time transformations** in DCRs to filter out unnecessary data before it is ingested (you are not charged for data that is dropped before landing).
- Review ingestion volume regularly using Log Analytics Workspace Insights and the `Usage` table.
- For long-lived audit data that rarely needs querying, use long-term retention (cheaper than interactive retention) or archive to storage.

### Operational excellence

- Use **infrastructure as code** (ARM/Bicep templates, Terraform) to manage workspaces, diagnostic settings, and DCRs consistently.
- Use **Azure Policy** with `DeployIfNotExists` to ensure that diagnostic settings are automatically created on all resources of a given type.
- Standardize on resource-specific collection mode for resource logs rather than Azure diagnostics mode.
- Standardize on the Azure Monitor Agent and DCRs; do not deploy the legacy Log Analytics agent for new projects.

### Performance efficiency

- There are no performance limits based on workspace data volume — a single workspace can handle enterprise-scale ingestion.
- Use the **Analytics** table plan for data that requires high-frequency, low-latency querying and alerting.
- Use **summary rules** to pre-aggregate high-volume data into summarized tables for dashboards and reports, reducing query cost and improving performance.

> 📖 Read more: [Best practices for Azure Monitor Logs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/best-practices-logs)

---

## 8. Pulling it all together: the recommendation framework

When the exam presents a scenario and asks you to recommend a logging solution, work through these layers in order:

### Layer 1: What needs to be logged?

Identify all the log types in the scenario:

| Source | Log type | Collection mechanism |
|---|---|---|
| Azure PaaS resources (Key Vault, SQL, App Service…) | Resource logs | Diagnostic setting on each resource |
| Azure subscriptions | Activity log | Diagnostic setting at subscription level |
| Microsoft Entra ID | Sign-in and audit logs | Diagnostic setting on Entra ID |
| Azure VMs / Arc-enabled servers | Guest OS logs (Event Log, Syslog, text files) | Azure Monitor Agent + DCR |
| Applications | Request traces, exceptions, dependencies | Application Insights (SDK or auto-instrumentation) |
| Custom/external sources | Custom logs via REST | Logs Ingestion API + DCR |

### Layer 2: Where does it go? (Workspace design)

Start with one workspace. Add workspaces only for:

1. Additional tenants
2. Data sovereignty / regional compliance
3. Separating Sentinel from operational data (if cost or governance requires it)
4. Same-table retention conflicts that cannot be resolved with per-table settings
5. Hard billing separation

### Layer 3: How is cost managed? (Table plans and retention)

For each table, assign the plan that matches its usage pattern:

- Frequent operational and security queries → **Analytics**
- Occasional troubleshooting → **Basic**
- Rare audit lookups / compliance → **Auxiliary** or long-term retention
- Archival beyond 12 years → Export to storage account

### Layer 4: How is collection governed at scale?

- Azure Policy for diagnostic settings on PaaS resources
- Azure Policy or VM insights for Azure Monitor Agent deployment
- Layered DCRs for different VM roles
- Infrastructure as code for repeatable deployment

### Layer 5: How is resilience ensured?

- Availability zones (in-region, automatic)
- Workspace replication (cross-region, paid)
- Continuous export to GRS storage (backup)

---

## 9. Quick-reference glossary

| Term | Definition |
|---|---|
| **Activity log** | Automatically generated control-plane log for every Azure resource. Retained 90 days by default. |
| **Resource logs** | Data-plane logs emitted by Azure resources. Not collected by default; require a diagnostic setting. |
| **Diagnostic setting** | Configuration that routes platform metrics, activity logs, and resource logs from an Azure resource to one or more destinations. |
| **Log Analytics workspace** | The primary data store for Azure Monitor Logs. All log data is collected into tables within a workspace. |
| **Azure Monitor Agent (AMA)** | The current agent for collecting guest OS logs from VMs. Replaces the legacy Log Analytics agent. |
| **Data collection rule (DCR)** | A declarative configuration that defines what data to collect, how to transform it, and where to send it. |
| **Data collection rule association (DCRA)** | A link between a DCR and a specific resource (VM, scale set, etc.). Many-to-many. |
| **Table plan** | The cost and capability profile assigned to a table: Analytics, Basic, or Auxiliary. |
| **Interactive retention** | The period during which table data is queryable with full KQL. |
| **Long-term retention** | Low-cost cold storage within the workspace. Data is accessible via search jobs or restore. |
| **Resource-specific mode** | The recommended collection mode where each resource log category gets its own dedicated table. |
| **Azure diagnostics mode** | The legacy collection mode where all resource log categories share the AzureDiagnostics table. |
| **Commitment tier** | A pricing tier offering an ingestion discount in exchange for a guaranteed daily minimum (100 GB/day and up). |
| **Workspace replication** | Replicates a workspace and its incoming data to a secondary region for cross-region resilience. |
| **Logs Ingestion API** | The REST API for sending custom log data to a workspace, governed by a DCR with OAuth authentication. |

---

## 10. Source documentation

All sources below are from Microsoft Learn product documentation.

1. [Azure Monitor Logs overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)
2. [Log Analytics workspace overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview)
3. [Design a Log Analytics workspace architecture](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design)
4. [Best practices for Azure Monitor Logs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/best-practices-logs)
5. [Diagnostic settings in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings)
6. [Resource logs in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs)
7. [Azure Monitor activity log](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log)
8. [Azure Monitor Agent overview](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview)
9. [Data collection rules in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview)
10. [Azure Monitor data sources and data collection methods](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources)
