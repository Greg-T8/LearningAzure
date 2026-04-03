# Display Text Formatting Rules

Detailed rules for constructing the display text of documentation links in the reference tree.

## Link Display Format

```
[<Doc Area Title> - <Page Title>](<URL>)
```

- **Doc Area Title**: The name of the Microsoft documentation area (e.g., "Azure Monitor", "Azure Policy")
- **Page Title**: The H1 heading of the target documentation page
- Joined with ` - ` (space-hyphen-space)

### Special Rules

1. **Drop "Documentation" suffix**: If the doc area name ends with "Documentation", remove it. Example: "Azure Monitor Documentation" → "Azure Monitor".
2. **Preserve redundancy**: If the page title contains the doc area name, do **not** remove it. Example: `[Azure Monitor - Azure Monitor Logs overview]` is correct.
3. **Subtitle inclusion**: If the H1 includes a subtitle separated by ` - `, include the full H1. Example: `[Azure Monitor - Introduction to Application Insights - OpenTelemetry observability]`.

---

## Known Documentation Area Mappings

Use this table to determine the Doc Area Title from the URL path. Match against the **longest matching prefix** (most specific wins). Entries are ordered by specificity.

| URL Path Prefix | Doc Area Title |
|---|---|
| `/en-us/azure/azure-monitor/` | Azure Monitor |
| `/en-us/azure/governance/policy/` | Azure Policy |
| `/en-us/azure/governance/resource-graph/` | Azure Resource Graph |
| `/en-us/azure/governance/` | Azure Governance |
| `/en-us/azure/network-watcher/` | Networking Fundamentals |
| `/en-us/azure/azure-resource-manager/management/` | Manage Azure resources |
| `/en-us/azure/azure-resource-manager/` | Azure Resource Manager |
| `/en-us/azure/data-explorer/` | Azure Data Explorer |
| `/en-us/azure/well-architected/` | Azure Well-Architected Framework |
| `/en-us/azure/azure-cache-for-redis/` | Azure Cache for Redis |
| `/en-us/azure/cosmos-db/` | Azure Cosmos DB |
| `/en-us/azure/key-vault/` | Azure Key Vault |
| `/en-us/azure/storage/` | Azure Storage |
| `/en-us/azure/virtual-machines/` | Azure Virtual Machines |
| `/en-us/azure/active-directory/` | Microsoft Entra ID |
| `/en-us/azure/role-based-access-control/` | Azure RBAC |
| `/en-us/azure/app-service/` | Azure App Service |
| `/en-us/azure/container-apps/` | Azure Container Apps |
| `/en-us/azure/aks/` | Azure Kubernetes Service |
| `/en-us/azure/virtual-network/` | Azure Virtual Network |
| `/en-us/azure/load-balancer/` | Azure Load Balancer |
| `/en-us/azure/application-gateway/` | Azure Application Gateway |
| `/en-us/azure/frontdoor/` | Azure Front Door |
| `/en-us/azure/firewall/` | Azure Firewall |
| `/en-us/azure/dns/` | Azure DNS |
| `/en-us/azure/private-link/` | Azure Private Link |
| `/en-us/azure/expressroute/` | Azure ExpressRoute |
| `/en-us/azure/vpn-gateway/` | Azure VPN Gateway |
| `/en-us/azure/bastion/` | Azure Bastion |
| `/en-us/azure/ddos-protection/` | Azure DDoS Protection |
| `/en-us/azure/traffic-manager/` | Azure Traffic Manager |
| `/en-us/azure/nat-gateway/` | Azure NAT Gateway |
| `/en-us/azure/sql-database/` | Azure SQL Database |
| `/en-us/azure/azure-sql/` | Azure SQL |
| `/en-us/azure/cosmos-db/` | Azure Cosmos DB |
| `/en-us/azure/mysql/` | Azure Database for MySQL |
| `/en-us/azure/postgresql/` | Azure Database for PostgreSQL |
| `/en-us/azure/azure-functions/` | Azure Functions |
| `/en-us/azure/logic-apps/` | Azure Logic Apps |
| `/en-us/azure/event-grid/` | Azure Event Grid |
| `/en-us/azure/event-hubs/` | Azure Event Hubs |
| `/en-us/azure/service-bus-messaging/` | Azure Service Bus |
| `/en-us/azure/api-management/` | Azure API Management |
| `/en-us/azure/backup/` | Azure Backup |
| `/en-us/azure/site-recovery/` | Azure Site Recovery |
| `/en-us/azure/automation/` | Azure Automation |
| `/en-us/azure/advisor/` | Azure Advisor |
| `/en-us/azure/cost-management-billing/` | Azure Cost Management |
| `/en-us/azure/defender-for-cloud/` | Microsoft Defender for Cloud |
| `/en-us/azure/sentinel/` | Microsoft Sentinel |
| `/en-us/azure/migrate/` | Azure Migrate |
| `/en-us/azure/reliability/` | Azure Reliability |
| `/en-us/azure/architecture/` | Azure Architecture Center |
| `/en-us/entra/` | Microsoft Entra |
| `/en-us/kusto/` | Kusto |
| `/en-us/powershell/` | PowerShell |

### `?toc=` Context Override

When a documentation URL includes a `?toc=` parameter, the doc area title should reflect the **toc context** rather than the URL path. Extract the service name from the toc path.

Example:

- URL: `/azure/storage/common/storage-insights-overview?toc=/azure/azure-monitor/toc.json`
- URL path suggests: Azure Storage
- `?toc=` path indicates: `/azure/azure-monitor/`
- **Correct doc area**: Azure Monitor

### `/kusto/` Path with `?view=azure-data-explorer`

Pages under `/kusto/` that have `?view=azure-data-explorer` may appear under either "Azure Data Explorer" or "Kusto" depending on the page breadcrumb context. Fetch the page and check the breadcrumb to determine the appropriate doc area title. If unsure, prefer "Azure Data Explorer" for feature/overview pages and "Kusto" for KQL query reference pages.

---

## URL-Based Fallback

When the URL path is not in the known-mappings table and the page cannot be fetched:

1. Extract the first path segment after `/azure/` (e.g., `/azure/container-instances/` → `container-instances`)
2. Replace hyphens with spaces
3. Title-case each word
4. Prepend "Azure" if not already present

Example: `/azure/container-instances/overview` → "Azure Container Instances"

For non-`/azure/` paths (e.g., `/entra/`, `/kusto/`):

1. Extract the first path segment
2. Title-case it

---

## Page Title Extraction

The **Page Title** is the H1 heading of the target documentation page.

### Extraction Priority

1. **H1 heading**: The main `# Title` at the top of the page content
2. **Fallback**: The inline link text from the unit page where the link was found (often abbreviated — use only if the page cannot be fetched)

### Common H1 Patterns

- Simple: `Azure Monitor data platform`
- With subtitle: `Introduction to Application Insights - OpenTelemetry observability`
- Question format: `What is Azure Data Explorer?`

Use the full H1 as-is, including subtitles and question marks.

---

## URL Cleaning Rules

### Unit URLs

Strip all query parameters. Final format:

```
https://learn.microsoft.com/en-us/training/modules/<module-slug>/<unit-slug>
```

### Module URLs

Keep the trailing slash:

```
https://learn.microsoft.com/en-us/training/modules/<module-slug>/
```

### Documentation URLs

Preserve these query parameters when present:

- `?toc=...`
- `?view=...`
- `?preserve-view=...`
- `?tabs=...`

Strip all other query parameters (e.g., `?source=recommendations`).
