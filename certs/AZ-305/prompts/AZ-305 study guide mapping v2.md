You are helping me prepare for the AZ-305: Designing Microsoft Azure Infrastructure Solutions exam.

Source study guide:
<https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305>

Goal:
Analyze the official AZ-305 study guide and produce a documentation map organized by the study guide hierarchy:

<domain> → <skill> → <task>

For each exam task, identify 5–15 relevant links to official Microsoft documentation that would be useful for grounding study tools.

Important:
The official AZ-305 study guide does not explicitly name every Azure product, Microsoft Entra feature, or architecture pattern that may be relevant to each task. Do not limit the map only to product names that appear directly in the study guide.

Before producing the final documentation map, perform a broader product and topic discovery pass using:

- The official AZ-305 study guide
- Official Microsoft Learn documentation
- Microsoft Learn modules
- Azure Architecture Center
- Cloud Adoption Framework
- Well-Architected Framework
- Microsoft product comparison pages
- Public online discussion sources such as Reddit, Microsoft Q&A, Microsoft Tech Community, and other public forums

Forum and Reddit usage rules:

- Use online forums only as discovery signals for products, services, and topics that candidates report seeing or studying for AZ-305.
- Do not treat Reddit, forums, blogs, or community posts as authoritative sources.
- Do not include Reddit, forum, blog, exam dump, or unofficial links in the final documentation table.
- Do not quote or reproduce actual exam questions.
- Ignore exam dumps, braindumps, leaked-question sites, or posts that appear to violate exam confidentiality.
- Prefer recurring patterns across multiple discussions rather than one-off claims.
- Give more weight to recent discussions, but do not assume every recent claim is accurate.
- Every product or topic discovered from forums must be validated against official Microsoft documentation before being included in the final map.
- The final table must still contain only official Microsoft Learn URLs.

Product and topic discovery process:
For each domain, skill, and task:

1. Start with the official AZ-305 study guide task wording.

2. Infer the likely Microsoft product universe.
   - Identify Azure services, Microsoft Entra features, governance services, monitoring services, migration services, data services, networking services, security services, and architecture guidance that could reasonably support the task.
   - Include products that are part of realistic design decisions, service comparisons, tradeoffs, migration paths, reliability decisions, security decisions, or cost/performance decisions.

3. Search public candidate discussions for additional coverage signals.
   - Search Reddit and public forums for phrases such as:
     - `AZ-305 exam topics`
     - `AZ-305 products covered`
     - `AZ-305 services on exam`
     - `AZ-305 Reddit`
     - `AZ-305 exam experience`
     - `AZ-305 study guide missing topics`
     - `AZ-305 Azure services`
     - `AZ-305 <domain name>`
     - `AZ-305 <skill name>`
     - `AZ-305 <task keyword>`
   - Look for repeated mentions of Azure services, Microsoft Entra features, architecture patterns, and design topics.
   - Use this research to expand the candidate product list, not as final source material.

4. Validate forum-discovered topics using official Microsoft sources.
   - If forum research suggests a product or topic is commonly encountered, find the official Microsoft Learn product documentation or architecture guidance for that product.
   - Include the product only if it clearly maps to one or more AZ-305 tasks.
   - If a topic appears frequently in forums but does not clearly map to the official study guide, mention it briefly in coverage notes rather than forcing it into the table.

5. Build a candidate product list before selecting links.
   - For each task, first identify 8–25 candidate Microsoft products, features, or documentation sets that could reasonably be testable.
   - Then narrow the final output to the best 5–15 official Microsoft documentation links.
   - The final links should represent the most exam-relevant documentation sets, not merely the first obvious products.

6. Prioritize completeness of product coverage.
   - The final map should cover the major Microsoft products that are likely to appear in AZ-305 design scenarios, even when those products are not explicitly named in the official study guide.
   - Include adjacent products when they are part of realistic design decisions.
   - Example: For “Recommend a monitoring solution,” consider Azure Monitor, Log Analytics, Application Insights, Container insights, VM insights, Network Watcher, Azure Advisor, Microsoft Defender for Cloud, and Microsoft Entra Monitoring and health.
   - Example: For “Recommend a load-balancing and routing solution,” consider Azure Load Balancer, Application Gateway, Azure Front Door, Traffic Manager, NAT Gateway, Azure Firewall, Virtual WAN, Private Link, and Azure Architecture Center load-balancing guidance.
   - Example: For “Recommend a solution for data integration,” consider Azure Data Factory, Synapse pipelines, Event Hubs, Event Grid, Service Bus, Stream Analytics, Azure Databricks, Microsoft Fabric, Azure Data Lake Storage, and Azure Architecture Center data-transfer guidance.

Important requirements:

1. Use only official Microsoft sources in the final documentation map.
   - Prefer Microsoft Learn product documentation under `https://learn.microsoft.com/en-us/azure/`
   - Include Microsoft Entra, Azure Architecture Center, Cloud Adoption Framework, Well-Architected Framework, Microsoft Purview, and Microsoft Defender documentation only when directly relevant.
   - Do not include third-party sites, blogs, exam dumps, unofficial notes, forum answers, Reddit links, or generic search result pages in the final table.

2. Prioritize documentation sets, not individual article titles.
   - The **Supporting product documentation** value must represent the parent Microsoft Learn documentation set that would be downloaded as a PDF.
   - Do not use the leaf article title, feature title, or final URL segment as the documentation name unless that is also the top-level documentation set name.
   - Determine the documentation name from the left navigation top node, root documentation page, or Microsoft Learn documentation collection title.
   - Remove the generic word “Documentation” from the displayed name.

3. Naming examples:
   - `https://learn.microsoft.com/en-us/azure/azure-monitor/`  
     Supporting product documentation = `Azure Monitor`
   - `https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs`  
     Supporting product documentation = `Azure Monitor`, not `Azure Monitor Logs`
   - `https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview`  
     Supporting product documentation = `Azure Monitor`, not `Azure Monitor Alerts`
   - `https://learn.microsoft.com/en-us/entra/identity/monitoring-health/`  
     Supporting product documentation = `Monitoring and health`, because that is the top node of that Microsoft Entra documentation set
   - `https://learn.microsoft.com/en-us/azure/cosmos-db/overview`  
     Supporting product documentation = `Azure Cosmos DB`

4. Output columns:
   Use exactly these columns:
   - Supporting product documentation
   - URL
   - Why this supports the task

   Do not include a dedicated PDF filename column.

5. URL column rule:
   - Rename the column to `URL`, not `Friendly URL`.
   - The URL column must contain the main Microsoft Learn URL being recommended.
   - Use the canonical `https://learn.microsoft.com/en-us/...` URL.
   - Do not use tracking URLs, localized URLs, redirected URLs, shortened URLs, or URLs with unnecessary query parameters unless Microsoft Learn requires them for the page to resolve correctly.

6. Hyperlink rule:
   - In the **Supporting product documentation** column, hyperlink the documentation name to the same URL shown in the URL column.
   - In the **URL** column, show the URL in plain text using angle brackets.

Example:

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs> | Supports log data platform design, Log Analytics workspaces, and KQL-based querying. |
| [Monitoring and health](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/) | <https://learn.microsoft.com/en-us/entra/identity/monitoring-health/> | Supports identity audit logs, sign-in logs, workbooks, recommendations, and identity health monitoring. |

7. PDF naming rule:
   - Do not create a separate PDF filename column.
   - The implied PDF filename is the value in the **Supporting product documentation** column plus `.pdf`.
   - Example:
     - `Azure Monitor` → `Azure Monitor.pdf`
     - `Monitoring and health` → `Monitoring and health.pdf`
     - `Azure Cosmos DB` → `Azure Cosmos DB.pdf`

8. Avoid duplicate documentation sets within the same task where possible.
   - If several deep articles under the same documentation set support the same task, prefer the most relevant URL and keep the parent documentation set name.
   - If multiple URLs from the same documentation set are necessary because they support meaningfully different concepts, repeat the same Supporting product documentation name but use different URLs.
   - Example:
     - `Azure Monitor` can appear more than once if one URL supports logs and another supports diagnostic settings.
     - Do not rename those rows to `Azure Monitor Logs`, `Azure Monitor Alerts`, or `Azure Monitor Diagnostic Settings` unless those are actually separate top-level documentation sets.

9. Organize the output by the AZ-305 hierarchy.
   - Domain
   - Skill
   - Task
   - Supporting Microsoft documentation links

10. For each task, include only documentation that is directly relevant to that task, but interpret “directly relevant” in the context of a design exam.
    - Because AZ-305 is an architecture/design exam, include products that are part of real design choices, tradeoff decisions, service comparisons, or architecture patterns for that task.
    - Include architecture-level guidance when the task asks to “recommend,” “evaluate,” “design,” or “select” a solution.
    - It is acceptable for a documentation source to appear under multiple tasks if it supports each task.
    - Avoid broad catch-all links unless they help identify service selection criteria, architecture patterns, or tradeoffs.
    - Do not exclude a major Azure product simply because the task wording is broad.

11. Validate each link.
    - Confirm that each URL resolves to an official Microsoft Learn page.
    - Prefer stable, canonical Microsoft Learn URLs.
    - Prefer documentation roots or high-value overview pages when they are sufficient.
    - Use deeper article URLs only when they better support the specific exam task.
    - Do not include links that resolve to non-Microsoft domains.

12. Add a brief product coverage note after each task.
    - After each task table, include a short line named `Potentially relevant products considered`.
    - Keep this line brief.
    - Mention important products, features, or documentation sets that were considered for completeness.
    - This note may include products that were selected and products that were not selected.
    - Do not add extra table columns.
    - If a product was discovered through forum research and validated with Microsoft documentation, it may be mentioned here.

13. Add a brief forum-discovery note after each domain.
    - Do not include Reddit or forum URLs.
    - Summarize only the product/topic patterns discovered from public candidate discussions.
    - Keep it short.
    - Example:
      `Forum-discovery note: Public candidate discussions commonly mention service-selection scenarios around Azure Front Door vs Application Gateway, Azure SQL vs SQL Managed Instance, monitoring/logging, governance, and migration planning. These were validated against official Microsoft documentation before inclusion.`

14. Output format:

## Domain: <domain name>

### Skill: <skill name>

#### Task: <task name>

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/) | <https://learn.microsoft.com/en-us/azure/azure-monitor/> | Supports monitoring, metrics, logs, alerts, and observability design decisions. |

Potentially relevant products considered: Azure Monitor, Log Analytics, Application Insights, Network Watcher, Azure Advisor, Microsoft Defender for Cloud.

15. At the end of each domain, include a short “Coverage notes” section:
    - Mention any tasks where Microsoft documentation is fragmented across several products.
    - Mention any tasks where the best source is architecture guidance rather than a single product documentation root.
    - Mention any documentation sets that appear repeatedly and are worth downloading first.
    - Mention any major products that could be testable but are only lightly covered in that domain.
    - Mention any recurring product patterns found in public candidate discussions, but do not cite or link to those discussions.

16. Perform a final coverage audit before producing the answer.
    Check whether the following product families are represented somewhere appropriate in the map. Add missing products only where they map directly to an AZ-305 task.

Identity and governance:

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

Monitoring and operations:

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

Data and storage:

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

Business continuity:

- Azure Backup
- Azure Site Recovery
- Azure reliability documentation
- Azure Well-Architected Framework reliability guidance
- Availability zones
- Region pairs
- Azure Storage redundancy and data protection
- Azure SQL business continuity
- Azure Cosmos DB backup and multi-region distribution

Compute and application architecture:

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

Migration:

- Cloud Adoption Framework
- Azure Migrate
- Azure Database Migration Service
- Azure Storage Mover
- Azure Data Box
- Azure File Sync
- App Service migration guidance
- Azure SQL migration guidance
- Database migration guidance for PostgreSQL and MySQL, if relevant

Networking:

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

17. Do not include internal citation marker strings in the final output.
    - Do not output citation tokens.
    - Use normal Markdown hyperlinks only.
    - Do not include footnotes, bibliography sections, source IDs, or tool-generated citation markers.
    - Do not include Reddit/forum URLs in the final table.

Deliverable:
A complete AZ-305 documentation map that I can use to download PDFs from Microsoft Learn. The Supporting product documentation name should correspond to the Microsoft Learn documentation set/PDF name, while the URL should identify the specific Microsoft Learn page that best supports the exam task.

The final output should be clean Markdown only.
