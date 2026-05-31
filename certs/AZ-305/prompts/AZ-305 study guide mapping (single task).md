# AZ-305 Single-Task Microsoft Documentation Map Prompt

## Role

You are helping me prepare for the **AZ-305: Designing Microsoft Azure Infrastructure Solutions** exam.

Official study guide:
<https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305>

Your job is to create a Microsoft documentation map for **one specific AZ-305 exam task** that I provide.

---

## Input I will provide

I will provide one exam task from the AZ-305 study guide.

I may also provide the domain and skill. If I do not provide them, infer the most likely domain and skill from the official AZ-305 study guide.

Example input:

```text
Task: Recommend a monitoring solution
```

Optional expanded input:

```text
Domain: Design business continuity solutions
Skill: Design a monitoring solution
Task: Recommend a monitoring solution
```

---

## Primary goal

Analyze **only the provided AZ-305 task** and produce a focused Microsoft documentation map for that task.

The output should help me identify the most relevant official Microsoft documentation sets to download as PDFs from Microsoft Learn.

Do not generate a full AZ-305 documentation map.  
Do not include documentation for unrelated tasks unless it directly supports the provided task.

---

## Important context

The official AZ-305 study guide does not explicitly name every Azure product, Microsoft Entra feature, architecture pattern, or design tradeoff that may be relevant to a task.

Do not limit the documentation map only to product names that appear directly in the task wording.

AZ-305 is a design exam, so include products, services, and architecture guidance that are part of realistic design decisions, including:

- Service selection
- Tradeoffs
- Cost and performance decisions
- Reliability and resiliency decisions
- Security and governance decisions
- Migration paths
- Operational design
- Architecture patterns

---

## Research and discovery process

For the provided task, perform the following process before producing the final answer.

### 1. Start with the official task wording

Use the provided task as the anchor.

If the domain and skill are not provided, identify the most likely official AZ-305 domain and skill.

If there is ambiguity, state the assumption briefly.

---

### 2. Infer the likely Microsoft product universe

Identify Microsoft products, Azure services, Microsoft Entra features, architecture patterns, and documentation sets that could reasonably support the task.

Include products that may be relevant because they are part of:

- Design choices
- Service comparisons
- Architecture tradeoffs
- Security decisions
- Governance decisions
- Monitoring decisions
- Migration decisions
- Reliability decisions
- Cost optimization decisions
- Data platform decisions
- Networking decisions

Before narrowing the final list, build a candidate product list of approximately **8–25 products, services, features, or documentation sets** that could reasonably support the task.

---

### 3. Use public candidate discussions only as discovery signals

Search public candidate discussions for additional coverage signals, such as:

- Reddit
- Microsoft Q&A
- Microsoft Tech Community
- Public AZ-305 study discussions
- Public forum discussions

Useful search phrases may include:

- `AZ-305 exam topics`
- `AZ-305 products covered`
- `AZ-305 services on exam`
- `AZ-305 Reddit`
- `AZ-305 exam experience`
- `AZ-305 study guide missing topics`
- `AZ-305 Azure services`
- `AZ-305 <task keyword>`
- `AZ-305 <skill name>`
- `AZ-305 <domain name>`

Forum and Reddit rules:

- Use forums only as discovery signals.
- Do not treat Reddit, forums, blogs, or community posts as authoritative sources.
- Do not include Reddit, forum, blog, exam dump, or unofficial links in the final table.
- Do not quote or reproduce actual exam questions.
- Ignore exam dumps, braindumps, leaked-question sites, or posts that appear to violate exam confidentiality.
- Prefer recurring patterns across multiple discussions instead of one-off claims.
- Give more weight to recent discussions, but do not assume every recent claim is accurate.
- Validate every forum-discovered product or topic against official Microsoft documentation before including it.

---

### 4. Validate topics against official Microsoft sources

Every final documentation link must be an official Microsoft source.

Acceptable source families include:

- Microsoft Learn Azure documentation
- Microsoft Entra documentation
- Azure Architecture Center
- Cloud Adoption Framework
- Azure Well-Architected Framework
- Microsoft Defender documentation
- Microsoft Purview documentation
- Microsoft Learn modules, when directly relevant
- Microsoft product comparison pages, when directly relevant

Do not include:

- Third-party blogs
- Reddit links
- Forum links
- Exam dumps
- Braindumps
- Unofficial study notes
- Generic search result pages
- Vendor marketing pages outside Microsoft

---

## Link selection rules

For the provided task, select the best **5–15 official Microsoft documentation links**.

Prioritize:

1. Documentation sets that directly support the task
2. Product documentation roots or overview pages
3. Architecture guidance when the task asks to recommend, evaluate, design, or select a solution
4. Comparison or decision guidance when the task involves choosing between services
5. Deeper article URLs only when they better support the specific task

Use canonical Microsoft Learn URLs in this format:

```text
https://learn.microsoft.com/en-us/...
```

Do not use:

- Tracking URLs
- Shortened URLs
- Localized URLs
- Redirected URLs
- URLs with unnecessary query parameters

---

## Documentation naming rules

The **Supporting product documentation** value must represent the Microsoft Learn documentation set name that would likely correspond to the PDF download name.

Use the parent documentation set name, not the leaf article title.

Examples:

| URL | Correct Supporting product documentation |
|---|---|
| `https://learn.microsoft.com/en-us/azure/azure-monitor/` | `Azure Monitor` |
| `https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs` | `Azure Monitor` |
| `https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview` | `Azure Monitor` |
| `https://learn.microsoft.com/en-us/entra/identity/monitoring-health/` | `Monitoring and health` |
| `https://learn.microsoft.com/en-us/azure/cosmos-db/overview` | `Azure Cosmos DB` |

Remove the generic word **Documentation** from the displayed name.

Do not create a dedicated PDF filename column.

The implied PDF filename is:

```text
<Supporting product documentation>.pdf
```

Examples:

```text
Azure Monitor.pdf
Monitoring and health.pdf
Azure Cosmos DB.pdf
```

---

## Duplicate documentation set rules

Avoid unnecessary duplicate documentation sets within the same task.

If several articles under the same documentation set support the same concept, choose the most relevant URL.

It is acceptable to repeat the same documentation set only when different URLs support meaningfully different concepts.

Example:

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs> | Supports log platform design, Log Analytics workspaces, and KQL-based querying. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview> | Supports alerting design, alert rules, action groups, and notification strategy. |

Do not rename those rows to `Azure Monitor Logs` or `Azure Monitor Alerts` unless those are actual top-level documentation set names.

---

## Required output structure

Use this structure exactly.

```markdown
## Domain: <domain name>

### Skill: <skill name>

#### Task: <task name>

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/) | <https://learn.microsoft.com/en-us/azure/azure-monitor/> | Supports monitoring, metrics, logs, alerts, and observability design decisions. |

Potentially relevant products considered: Azure Monitor, Log Analytics, Application Insights, Network Watcher, Azure Advisor, Microsoft Defender for Cloud.

Forum-discovery note: Public candidate discussions commonly mention monitoring, logging, alerting, and service-selection scenarios. These were used only as discovery signals and validated against official Microsoft documentation before inclusion.

Coverage notes:
- Mention whether the task is supported by one primary documentation set or fragmented across several product areas.
- Mention whether architecture guidance is more useful than a single product documentation root.
- Mention documentation sets worth downloading first.
- Mention major products that could be testable but were only lightly covered.
```

---

## Required table columns

Use exactly these columns:

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|

Column rules:

1. **Supporting product documentation**
   - Hyperlink the documentation set name to the same URL shown in the URL column.

2. **URL**
   - Show the full canonical URL in plain text using angle brackets.

3. **Why this supports the task**
   - Explain why the source supports the specific AZ-305 task.
   - Keep the explanation concise but specific.
   - Focus on design relevance, tradeoffs, service selection, architecture decisions, or operational considerations.

---

## Product coverage audit

Before producing the final answer, audit whether any of the following product families are relevant to the provided task.

Only include products that directly map to the task.

### Identity and governance

- Microsoft Entra ID
- Conditional Access
- Authentication methods
- Microsoft identity platform
- Managed identities
- Microsoft Entra ID Governance
- Privileged Identity Management
- Access reviews
- Entitlement management
- Application Proxy
- Hybrid identity
- Azure RBAC
- Azure Policy
- Management groups
- Resource groups
- Tags
- Microsoft Defender for Cloud
- Microsoft Purview, if relevant to compliance or data governance

### Monitoring and operations

- Azure Monitor
- Log Analytics
- Application Insights
- VM insights
- Container insights
- Network Watcher
- Azure Advisor
- Diagnostic settings
- Activity log
- Data collection rules
- Microsoft Entra Monitoring and health

### Data and storage

- Azure SQL Database
- Azure SQL Managed Instance
- SQL Server on Azure VMs
- Azure Database for PostgreSQL
- Azure Database for MySQL
- Azure Cosmos DB
- Azure Storage
- Blob Storage
- Azure Files
- Azure Data Lake Storage
- Azure NetApp Files, if relevant
- Azure Data Factory
- Azure Synapse Analytics
- Azure Databricks
- Azure Data Explorer
- Azure Stream Analytics
- Event Hubs
- Event Grid
- Service Bus
- Microsoft Fabric, if directly relevant to modern analytics design

### Business continuity

- Azure Backup
- Azure Site Recovery
- Azure reliability documentation
- Azure Well-Architected Framework reliability guidance
- Availability zones
- Region pairs
- Azure Storage redundancy and data protection
- Azure SQL business continuity
- Azure Cosmos DB backup and multi-region distribution

### Compute and application architecture

- Virtual Machines
- Virtual Machine Scale Sets
- Availability sets
- App Service
- Azure Kubernetes Service
- Azure Container Apps
- Azure Container Instances, if relevant
- Azure Functions
- Azure Batch
- API Management
- Azure App Configuration
- Azure Key Vault
- Azure Managed Redis
- Service Bus
- Event Grid
- Event Hubs
- Logic Apps, if relevant to integration or serverless workflows
- Bicep
- ARM templates
- Deployment stacks

### Migration

- Cloud Adoption Framework
- Azure Migrate
- Azure Database Migration Service
- Azure Storage Mover
- Azure Data Box
- Azure File Sync
- App Service migration guidance
- Azure SQL migration guidance
- Database migration guidance for PostgreSQL and MySQL, if relevant

### Networking

- Virtual Network
- VPN Gateway
- ExpressRoute
- Virtual WAN
- Azure DNS
- Private DNS
- Private Link
- NAT Gateway
- Azure Firewall
- Azure Firewall Manager
- DDoS Protection
- Network security groups
- Application security groups
- Route tables and user-defined routes
- Load Balancer
- Application Gateway
- Azure Front Door
- Traffic Manager
- Content Delivery Network, if relevant
- Network Watcher

---

## Final quality rules

Before producing the final answer:

1. Confirm that every final URL is an official Microsoft URL.
2. Confirm that every selected documentation source directly supports the provided task.
3. Confirm that the documentation set names represent parent Microsoft Learn documentation sets, not leaf article names.
4. Confirm that the final answer covers the most important product families relevant to the task.
5. Confirm that no unofficial links appear in the final table.
6. Confirm that no Reddit, forum, blog, or exam-dump links appear in the final table.
7. Confirm that no internal citation marker strings appear in the final output.
8. Confirm that the output is clean Markdown only.

---

## Deliverable

Produce a focused AZ-305 documentation map for the single task I provide.

The final output must include:

1. Domain
2. Skill
3. Task
4. Documentation table with 5–15 official Microsoft links
5. Potentially relevant products considered
6. Forum-discovery note
7. Coverage notes

The final output should be clean Markdown only.
