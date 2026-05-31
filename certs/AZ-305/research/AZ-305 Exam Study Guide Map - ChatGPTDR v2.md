# AZ-305 Documentation Map

## Research scope and method

This map follows the official AZ-305 study guide hierarchy that Microsoft lists for the exam skills measured as of April 17, 2026, and expands each task with official Microsoft Learn, Azure Architecture Center, Cloud Adoption Framework, and Azure Well-Architected Framework sources. Public candidate discussions were used only as nonauthoritative discovery signals for product/topic expansion; every link in the map below is an official Microsoft URL. citeturn39view0turn34search3turn34search6

## Domain: Design identity, governance, and monitoring solutions

### Skill: Design solutions for logging and monitoring

#### Task: Recommend a logging solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview> | Establishes the core observability platform for metrics, logs, traces, and alerts. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs> | Explains Azure Monitor Logs, ingestion, retention, querying, and workspace-based logging design. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview> | Helps scope workspace architecture, data access boundaries, and retention strategy. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview> | Grounds application telemetry design for request, dependency, trace, and exception logging. |
| [Monitoring and health](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/) | <https://learn.microsoft.com/en-us/entra/identity/monitoring-health/> | Covers identity-centric logs such as sign-ins, audits, and tenant health signals. |

Potentially relevant products considered: Azure Monitor, Log Analytics, Application Insights, Monitoring and health, Azure Storage, Event Hubs, Microsoft Defender for Cloud.

#### Task: Recommend a solution for routing logs

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings) | <https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings> | Core reference for routing platform logs and metrics to supported destinations. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log) | <https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log> | Important for subscription and management-group event routing and retention design. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview> | Supports DCR-based transformations, collection paths, and destination planning. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-features) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-features> | Useful when logs need streaming to external SIEM, analytics, or downstream pipelines. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/) | <https://learn.microsoft.com/en-us/azure/storage/> | Supports archival, low-cost retention, and downstream batch processing of diagnostic exports. |

Potentially relevant products considered: Diagnostic settings, Activity Log, DCRs, Event Hubs, Azure Storage, Log Analytics, Azure Policy built-ins for diagnostics.

#### Task: Recommend a monitoring solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview> | Provides the end-to-end monitoring platform for Azure workload design decisions. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/monitor-vm) | <https://learn.microsoft.com/en-us/azure/azure-monitor/vm/monitor-vm> | Grounds VM and VMSS monitoring design, including guest metrics and logs. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-overview> | Covers AKS and Kubernetes monitoring with Container insights and managed Prometheus. |
| [Network Watcher](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview) | <https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview> | Required for network visibility, diagnostics, topology, packet, and connection monitoring. |
| [Azure Service Health](https://learn.microsoft.com/en-us/azure/service-health/overview) | <https://learn.microsoft.com/en-us/azure/service-health/overview> | Supports service incident awareness, maintenance events, and resource health monitoring. |
| [Monitoring and health](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/) | <https://learn.microsoft.com/en-us/entra/identity/monitoring-health/> | Adds identity-plane observability to overall monitoring solution design. |

Potentially relevant products considered: Azure Monitor, Application Insights, VM insights, Container insights, Network Watcher, Azure Service Health, Azure Advisor, Monitoring and health, Managed Prometheus.

### Skill: Design authentication and authorization solutions

#### Task: Recommend an authentication solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Microsoft Entra authentication](https://learn.microsoft.com/en-us/entra/identity/authentication/) | <https://learn.microsoft.com/en-us/entra/identity/authentication/> | Covers MFA, passwordless, SSPR, and authentication methods policy choices. |
| [Microsoft Entra Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/) | <https://learn.microsoft.com/en-us/entra/identity/conditional-access/> | Supports risk-based and context-aware authentication controls in design scenarios. |
| [Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/) | <https://learn.microsoft.com/en-us/entra/identity-platform/> | Grounds app sign-in, token issuance, API protection, and delegated/app permissions. |
| [Hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity> | Relevant for federated or synchronized authentication across on-premises and cloud. |
| [Microsoft Entra External ID](https://learn.microsoft.com/en-us/entra/external-id/) | <https://learn.microsoft.com/en-us/entra/external-id/> | Useful for workforce B2B and external user authentication patterns. |

Potentially relevant products considered: Microsoft Entra authentication, Conditional Access, Microsoft identity platform, Hybrid identity, Microsoft Entra External ID, passkeys, device identity.

#### Task: Recommend an identity management solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/> | Covers synchronization and hybrid identity operating models. |
| [Managed identities for Azure resources](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/) | <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/> | Fundamental for workload identities and secretless service-to-service access. |
| [Microsoft Entra External ID](https://learn.microsoft.com/en-us/entra/external-id/) | <https://learn.microsoft.com/en-us/entra/external-id/> | Supports management of guests, partners, and external identities. |
| [Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/) | <https://learn.microsoft.com/en-us/entra/identity-platform/> | Useful for application registrations, service principals, and API identity design. |
| [Microsoft Entra Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/) | <https://learn.microsoft.com/en-us/entra/identity/conditional-access/> | Adds lifecycle and policy controls to identity posture decisions. |

Potentially relevant products considered: Hybrid identity, managed identities, application registrations, service principals, External ID, Conditional Access, device identity.

#### Task: Recommend a solution for authorizing access to Azure resources

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure RBAC](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview) | <https://learn.microsoft.com/en-us/azure/role-based-access-control/overview> | Primary control plane authorization model for Azure resources. |
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/) | <https://learn.microsoft.com/en-us/azure/governance/policy/> | Complements authorization with guardrails and deny/audit enforcement. |
| [Managed identities for Azure resources](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) | <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview> | Enables workload authorization without embedded credentials. |
| [Azure management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview) | <https://learn.microsoft.com/en-us/azure/governance/management-groups/overview> | Important for inheritance of RBAC and policy at enterprise scope. |
| [Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/) | <https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/> | Supports just-in-time access and least-privilege for Azure roles. |

Potentially relevant products considered: Azure RBAC, Azure Policy, management groups, managed identities, PIM for Azure resources, custom roles, ABAC.

#### Task: Recommend a solution for authorizing access to on-premises resources

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Microsoft Entra application proxy](https://learn.microsoft.com/en-us/entra/identity/app-proxy/) | <https://learn.microsoft.com/en-us/entra/identity/app-proxy/> | Key design option for secure remote access to on-prem web apps. |
| [Hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn> | Relevant for hybrid authentication methods that affect authorization outcomes. |
| [Microsoft Entra Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview) | <https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview> | Helps enforce conditional controls for access to hybrid applications. |
| [Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/v2-overview) | <https://learn.microsoft.com/en-us/entra/identity-platform/v2-overview> | Useful for protecting APIs and modernized on-prem-connected applications. |
| [Microsoft Entra External ID](https://learn.microsoft.com/en-us/entra/external-id/what-is-b2b) | <https://learn.microsoft.com/en-us/entra/external-id/what-is-b2b> | Supports partner or guest access scenarios that depend on on-prem-connected apps. |

Potentially relevant products considered: Application Proxy, hybrid auth, Kerberos-based hybrid patterns, Conditional Access, External ID, Microsoft identity platform.

#### Task: Recommend a solution to manage secrets, certificates, and keys

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview) | <https://learn.microsoft.com/en-us/azure/key-vault/general/overview> | Core vault service for secrets, keys, and certificates. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/basic-concepts) | <https://learn.microsoft.com/en-us/azure/key-vault/general/basic-concepts> | Clarifies vault versus Managed HSM and object-type tradeoffs. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/secure-key-vault) | <https://learn.microsoft.com/en-us/azure/key-vault/general/secure-key-vault> | Useful for network isolation, RBAC, rotation, soft delete, and purge protection design. |
| [Managed identities for Azure resources](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) | <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview> | Enables secret retrieval without embedding credentials in application code. |
| [Azure App Configuration](https://learn.microsoft.com/en-us/azure/azure-app-configuration/overview) | <https://learn.microsoft.com/en-us/azure/azure-app-configuration/overview> | Complements Key Vault when configuration state and secret references must be separated. |

Potentially relevant products considered: Azure Key Vault, Managed HSM, managed identities, Azure App Configuration, Azure RBAC, private endpoints.

### Skill: Design governance

#### Task: Recommend a structure for management groups, subscriptions, and resource groups, and a strategy for resource tagging

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview) | <https://learn.microsoft.com/en-us/azure/governance/management-groups/overview> | Defines the enterprise hierarchy for governance inheritance and scope partitioning. |
| [Azure Resource Manager](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview> | Grounds subscription, resource group, deployment scope, and management semantics. |
| [Azure Resource Manager](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources> | Core source for tagging capabilities, limits, and practical tagging strategy. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/> | Provides enterprise-scale landing zone guidance that drives hierarchy decisions. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org> | Focused guidance for resource organization design area and scope allocation. |

Potentially relevant products considered: Management groups, subscriptions, resource groups, tags, Azure landing zones, Azure Policy, cost management tagging.

#### Task: Recommend a solution for managing compliance

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/) | <https://learn.microsoft.com/en-us/azure/governance/policy/> | Primary enforcement and auditing mechanism for compliance at scale. |
| [Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction) | <https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction> | Adds security posture, recommendations, and regulatory compliance views. |
| [Microsoft Purview](https://learn.microsoft.com/en-us/purview/purview) | <https://learn.microsoft.com/en-us/purview/purview> | Relevant when compliance intersects with data governance, classification, and policy. |
| [Azure management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/) | <https://learn.microsoft.com/en-us/azure/governance/management-groups/> | Needed to apply compliance controls consistently across subscription estates. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-principles) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-principles> | Useful for governance and policy alignment in landing-zone-driven compliance design. |

Potentially relevant products considered: Azure Policy, management groups, Defender for Cloud, Microsoft Purview, landing zones, diagnostic settings, Azure Advisor.

#### Task: Recommend a solution for identity governance

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/) | <https://learn.microsoft.com/en-us/entra/id-governance/> | Central documentation hub for access lifecycle and governance capabilities. |
| [Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/) | <https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/> | Supports privileged role governance and just-in-time access design. |
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/access-reviews-overview) | <https://learn.microsoft.com/en-us/entra/id-governance/access-reviews-overview> | Important for periodic attestation and access recertification flows. |
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-overview) | <https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-overview> | Grounds access package, request, approval, and expiration design. |
| [Microsoft Entra External ID](https://learn.microsoft.com/en-us/entra/external-id/what-is-b2b) | <https://learn.microsoft.com/en-us/entra/external-id/what-is-b2b> | Frequently relevant when governance must cover guests and partner access. |

Potentially relevant products considered: ID Governance, PIM, access reviews, entitlement management, External ID, lifecycle workflows, guest governance.

Forum-discovery note: Public candidate discussions recurrently emphasize landing zones, Azure Policy and RBAC scope design, Conditional Access, managed identities, PIM, monitoring/log routing, and Defender for Cloud as recurring AZ-305 scenario material.

#### Coverage notes

Identity and governance coverage is fragmented across Azure, Microsoft Entra, and architecture guidance, so the best study set is usually a combination of Azure Monitor, Microsoft Entra authentication/Conditional Access, Azure RBAC, Azure Policy, management groups, and Microsoft Entra ID Governance. The most repeatedly useful downloads in this domain are Azure Monitor, Monitoring and health, Microsoft Entra authentication, Microsoft Entra Conditional Access, Azure Policy, Azure RBAC, Azure management groups, Microsoft Defender for Cloud, and Microsoft Entra ID Governance.

## Domain: Design data storage solutions

### Skill: Design data storage solutions for relational data

#### Task: Recommend a solution for storing relational data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-stores-getting-started) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-stores-getting-started> | Helps compare relational options against workload characteristics and constraints. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview?view=azuresql> | Canonical PaaS relational option for many Azure application scenarios. |
| [Azure SQL Managed Instance](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview?view=azuresql> | Important when SQL Server compatibility and lift-and-shift are priorities. |
| [SQL Server on Azure VM](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview?view=azuresql> | Relevant for full SQL Server control and OS-level customization. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/overview) | <https://learn.microsoft.com/en-us/azure/postgresql/overview> | Covers open-source relational workloads with managed PostgreSQL. |
| [Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview) | <https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview> | Supports MySQL-specific relational design decisions. |

Potentially relevant products considered: Azure SQL Database, Azure SQL Managed Instance, SQL Server on Azure VM, Azure Database for PostgreSQL, Azure Database for MySQL, Oracle migration patterns.

#### Task: Recommend a database service tier and compute tier

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview?view=azuresql> | Defines service model and major performance/cost tradeoffs. |
| [Azure SQL Managed Instance](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview?view=azuresql> | Useful for instance-level sizing and compatibility-driven tier choices. |
| [SQL Server on Azure VM](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/?view=azuresql> | Relevant when VM size, disk layout, and licensing shape compute selection. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/configure-maintain/concepts-servers) | <https://learn.microsoft.com/en-us/azure/postgresql/configure-maintain/concepts-servers> | Explains compute/storage behavior and server design considerations. |
| [Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview) | <https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview> | Supports MySQL sizing and deployment model decisions. |

Potentially relevant products considered: vCore versus DTU concepts, Business Critical patterns, hyperscale patterns, PostgreSQL compute/storage, MySQL flexible server sizing, SQL VM sizing.

#### Task: Recommend a solution for database scalability

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview?view=azuresql> | Covers elastic pools, service models, and scale-oriented PaaS choices. |
| [Azure SQL Managed Instance](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview?view=azuresql> | Supports managed instance scale and compatibility tradeoffs. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/configure-maintain/concepts-servers) | <https://learn.microsoft.com/en-us/azure/postgresql/configure-maintain/concepts-servers> | Useful for designing around compute, storage growth, and server behavior. |
| [Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concept-servers) | <https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concept-servers> | Supports server-level design and scale characteristics for MySQL workloads. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-stores-getting-started) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-stores-getting-started> | Helps compare which relational platform best fits the scale pattern. |

Potentially relevant products considered: Elastic pools, managed instance, PostgreSQL flexible server, MySQL flexible server, read scale, sharding, partitioning.

#### Task: Recommend a solution for data protection

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview?view=azuresql> | Covers automated backups and point-in-time restore planning. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/security-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/security-overview?view=azuresql> | Important for auditing, encryption, and identity-backed database security. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/reliability-sql-database) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-sql-database> | Adds zone and region resiliency design guidance for SQL Database. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/security/security-overview) | <https://learn.microsoft.com/en-us/azure/postgresql/security/security-overview> | Supports security, backup, and recovery posture for PostgreSQL. |
| [Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview) | <https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview> | Provides the service context needed for MySQL protection and recovery planning. |

Potentially relevant products considered: Automated backups, PITR, auditing, failover groups, PostgreSQL security, MySQL backups, SQL Server on Azure VM backup.

### Skill: Design data storage solutions for semi-structured and unstructured data

#### Task: Recommend a solution for storing semi-structured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/overview) | <https://learn.microsoft.com/en-us/azure/cosmos-db/overview> | Primary document, key-value, graph, and globally distributed NoSQL reference. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/understand-data-store-models) | <https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/understand-data-store-models> | Helps map workload patterns to document, key-value, and other models. |
| [Azure Data Explorer](https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview) | <https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview> | Useful for telemetry, log, and time-series semi-structured data scenarios. |
| [Azure Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction) | <https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction> | Supports JSON and object-centric storage when a database is unnecessary. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/) | <https://learn.microsoft.com/en-us/azure/storage/> | Broad storage reference for queue, table, blob, and general storage decisions. |

Potentially relevant products considered: Azure Cosmos DB, Blob Storage, Table patterns, Azure Data Explorer, key-value stores, search indexes, telemetry stores.

#### Task: Recommend a solution for storing unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction) | <https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction> | Core object store for files, media, backups, and large-scale unstructured data. |
| [Azure Files](https://learn.microsoft.com/en-us/azure/storage/files/) | <https://learn.microsoft.com/en-us/azure/storage/files/> | Relevant when SMB/NFS shares and file semantics are required. |
| [Azure Data Lake Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction) | <https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction> | Critical for analytics-oriented unstructured storage with hierarchical namespace. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/) | <https://learn.microsoft.com/en-us/azure/storage/> | Useful umbrella reference for object, file, queue, table, and big data services. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/storage-options) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/storage-options> | Helps compare file, object, and lake-oriented storage design tradeoffs. |

Potentially relevant products considered: Blob Storage, Azure Files, Data Lake Storage, archive tiering, NetApp Files, File Sync, Data Box for seeding.

#### Task: Recommend a data storage solution to balance features, performance, and costs

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/storage-options) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/storage-options> | Direct comparison guidance for balancing performance, features, and cost. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/overview) | <https://learn.microsoft.com/en-us/azure/cosmos-db/overview> | Useful when global distribution and low latency justify higher feature cost. |
| [Azure Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction) | <https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction> | Important for tiering and cost-sensitive object storage decisions. |
| [Azure Files](https://learn.microsoft.com/en-us/azure/storage/files/) | <https://learn.microsoft.com/en-us/azure/storage/files/> | Helps evaluate managed file shares against application requirements. |
| [Azure Data Lake Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction) | <https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction> | Needed when analytics features outweigh simpler object-store economics. |

Potentially relevant products considered: Blob tiers, Data Lake Storage, Azure Files, Cosmos DB, NetApp Files, durability SKUs, throughput and latency tradeoffs.

#### Task: Recommend a data solution for protection and durability

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/reliability-storage-blob) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-storage-blob> | Best source for blob redundancy, failover behavior, and region considerations. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/reliability-cosmos-db) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-cosmos-db> | Covers multi-region distribution and resilience for globally distributed NoSQL data. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/) | <https://learn.microsoft.com/en-us/azure/storage/> | Umbrella source for durability and redundancy options across storage services. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-overview) | <https://learn.microsoft.com/en-us/azure/backup/backup-overview> | Relevant when durability requirements extend into backup and restore operations. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/regions-paired) | <https://learn.microsoft.com/en-us/azure/reliability/regions-paired> | Important for geo-redundancy and region-failover planning. |

Potentially relevant products considered: GRS/ZRS choices, Blob soft delete, immutable storage, Azure Backup, Cosmos DB multi-region replication, paired-region strategy.

### Skill: Design data integration

#### Task: Recommend a solution for data integration

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Data Factory](https://learn.microsoft.com/en-us/azure/data-factory/introduction) | <https://learn.microsoft.com/en-us/azure/data-factory/introduction> | Core managed ETL/ELT and orchestration platform for integration scenarios. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/pipeline-orchestration-data-movement) | <https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/pipeline-orchestration-data-movement> | Compares orchestration and data movement options for design decisions. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-features) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-features> | Important for large-scale streaming ingestion pipelines. |
| [Azure Event Grid](https://learn.microsoft.com/en-us/azure/event-grid/overview) | <https://learn.microsoft.com/en-us/azure/event-grid/overview> | Supports event-based integration and reactive workflows. |
| [Azure Service Bus Messaging](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview) | <https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview> | Relevant for reliable brokered integration across systems and services. |
| [Azure Logic Apps](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview) | <https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview> | Useful for low-code workflow integration across cloud and on-premises systems. |

Potentially relevant products considered: Azure Data Factory, Synapse pipelines, Logic Apps, Event Hubs, Event Grid, Service Bus, Stream Analytics, Fabric Data Factory.

#### Task: Recommend a solution for data analysis

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Synapse Analytics](https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is) | <https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is> | Covers integrated SQL, Spark, pipelines, and analytics workspace design. |
| [Azure Databricks](https://learn.microsoft.com/en-us/azure/databricks/introduction/) | <https://learn.microsoft.com/en-us/azure/databricks/introduction/> | Strong option for lakehouse, data engineering, and ML-driven analysis scenarios. |
| [Azure Data Explorer](https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview) | <https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview> | Optimized for near-real-time analytics over log and telemetry data. |
| [Azure Stream Analytics](https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction) | <https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction> | Useful for real-time streaming analysis and event-to-insight pipelines. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/analytical-data-stores) | <https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/analytical-data-stores> | Helps choose the right analytical serving layer and storage technology. |
| [Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/) | <https://learn.microsoft.com/en-us/fabric/> | Relevant for modern Microsoft analytics scenarios adjacent to Azure design choices. |

Potentially relevant products considered: Synapse, Databricks, Data Explorer, Stream Analytics, Microsoft Fabric, Power BI, lakehouses, HTAP patterns.

Forum-discovery note: Public candidate discussions repeatedly call out Azure SQL Database versus SQL Managed Instance, Cosmos DB, Blob versus Files versus Data Lake, Data Factory versus Synapse/Databricks, and streaming integration choices such as Event Hubs, Event Grid, and Service Bus.

#### Coverage notes

This domain is the most fragmented across product docs. For relational storage, start with Azure SQL Database, Azure SQL Managed Instance, SQL Server on Azure VM, PostgreSQL, and MySQL. For nonrelational and analytics, Azure Cosmos DB, Azure Storage, Azure Data Factory, Azure Synapse Analytics, Azure Databricks, Azure Data Explorer, and Azure Stream Analytics are the highest-value downloads. Architecture Center decision guides are especially important here because AZ-305 frequently tests service-selection tradeoffs, not just product configuration.

## Domain: Design business continuity solutions

### Skill: Design solutions for backup and disaster recovery

#### Task: Recommend a recovery solution for Azure and hybrid workloads that meets recovery objectives

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-overview) | <https://learn.microsoft.com/en-us/azure/backup/backup-overview> | Core backup platform reference for recovery design and retention. |
| [Azure Site Recovery](https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-overview) | <https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-overview> | Required for disaster recovery, replication, failover, and failback design. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/overview) | <https://learn.microsoft.com/en-us/azure/reliability/overview> | Frames RPO/RTO-oriented reliability thinking across Azure services. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/reliability/metrics) | <https://learn.microsoft.com/en-us/azure/well-architected/reliability/metrics> | Useful for defining availability and recovery targets before selecting services. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/regions-paired) | <https://learn.microsoft.com/en-us/azure/reliability/regions-paired> | Important for region-failover and geo-recovery planning. |

Potentially relevant products considered: Azure Backup, Site Recovery, paired regions, availability zones, Recovery Services vaults, Azure reliability guides.

#### Task: Recommend a backup and recovery solution for compute

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-overview) | <https://learn.microsoft.com/en-us/azure/backup/backup-overview> | Covers backup choices for VMs, disks, and other compute-attached data. |
| [Azure Site Recovery](https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-overview) | <https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-overview> | Key DR service for Azure VMs and hybrid/server workloads. |
| [Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/availability) | <https://learn.microsoft.com/en-us/azure/virtual-machines/availability> | Supports compute resiliency choices that influence recovery design. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machines) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machines> | Service-specific recovery and resiliency guidance for VM workloads. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machine-scale-sets) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machine-scale-sets> | Relevant when compute recovery is designed around scaled fleets. |

Potentially relevant products considered: Azure Backup, Azure Site Recovery, VMs, VMSS, managed disks, boot diagnostics, Azure Monitor for recovery validation.

#### Task: Recommend a backup and recovery solution for databases

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview?view=azuresql> | Core source for SQL backup, PITR, and restore capabilities. |
| [SQL Server on Azure VM](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/?view=azuresql> | Relevant when database recovery depends on IaaS-hosted SQL workloads. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/reliability-sql-managed-instance) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-sql-managed-instance> | Important for managed instance regional recovery and failover-group planning. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/reliability-cosmos-db) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-cosmos-db> | Adds backup and multi-region durability guidance for NoSQL database recovery. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/reliability-database-postgresql) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-database-postgresql> | Useful for HA, backup, and regional recovery design in PostgreSQL. |

Potentially relevant products considered: Azure SQL backups, SQL VM backups, failover groups, Cosmos DB backups, PostgreSQL recovery, MySQL recovery, DMS for restore-based migrations.

#### Task: Recommend a backup and recovery solution for unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-overview) | <https://learn.microsoft.com/en-us/azure/backup/backup-overview> | Supports backup strategy selection for file and data protection scenarios. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/) | <https://learn.microsoft.com/en-us/azure/storage/> | Umbrella source for storage durability, redundancy, and service capabilities. |
| [Azure Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction) | <https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction> | Essential for blob-tier data restoration and retention planning. |
| [Azure Files](https://learn.microsoft.com/en-us/azure/storage/files/) | <https://learn.microsoft.com/en-us/azure/storage/files/> | Covers file-share semantics that influence backup and recovery design. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/reliability-storage-blob) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-storage-blob> | Best source for resilience and failover expectations for object data. |

Potentially relevant products considered: Azure Backup, Blob Storage, Azure Files, soft delete, snapshots, immutable storage, region redundancy, File Sync.

### Skill: Design for high availability

#### Task: Recommend a high availability solution for compute

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/availability) | <https://learn.microsoft.com/en-us/azure/virtual-machines/availability> | Covers availability sets and availability zones for VM workload design. |
| [Virtual Machine Scale Sets](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-use-availability-zones) | <https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-use-availability-zones> | Supports zone-spread scaling patterns for highly available compute tiers. |
| [App Service](https://learn.microsoft.com/en-us/azure/app-service/overview) | <https://learn.microsoft.com/en-us/azure/app-service/overview> | Useful for PaaS web/API workloads requiring built-in scale and HA. |
| [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/what-is-aks) | <https://learn.microsoft.com/en-us/azure/aks/what-is-aks> | Important for container orchestration HA and node-pool resilience decisions. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/reliability-functions) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-functions> | Relevant when highly available compute is serverless-based. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree> | Helps align HA requirements with the right compute platform. |

Potentially relevant products considered: VMs, VMSS, App Service, AKS, Functions, Container Apps, zones, multi-region, autoscale.

#### Task: Recommend a high availability solution for relational data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/reliability-sql-database) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-sql-database> | Best source for zone redundancy and multi-region options in SQL Database. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/reliability-sql-managed-instance) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-sql-managed-instance> | Important for managed instance failover and regional resilience design. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/high-availability/concepts-high-availability) | <https://learn.microsoft.com/en-us/azure/postgresql/high-availability/concepts-high-availability> | Covers zone-redundant HA and standby design for PostgreSQL. |
| [Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-high-availability) | <https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-high-availability> | Supports zone-redundant and same-zone HA tradeoff decisions for MySQL. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/regions-paired) | <https://learn.microsoft.com/en-us/azure/reliability/regions-paired> | Helps frame regional failover choices for geo-redundant data architectures. |

Potentially relevant products considered: SQL zone redundancy, failover groups, PostgreSQL HA, MySQL HA, paired regions, read replicas, active geo-replication.

#### Task: Recommend a high availability solution for semi-structured and unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/reliability-cosmos-db) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-cosmos-db> | Key source for multi-region, multi-write, and globally distributed NoSQL HA. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/reliability-storage-blob) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-storage-blob> | Explains ZRS/GRS-style design implications for unstructured storage. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/) | <https://learn.microsoft.com/en-us/azure/storage/> | Useful umbrella reference for redundancy options across storage services. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview) | <https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview> | Helps map zonal strategies to service support and failure domains. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/regions-paired) | <https://learn.microsoft.com/en-us/azure/reliability/regions-paired> | Needed for cross-region durability and failover decisions. |

Potentially relevant products considered: Cosmos DB multi-region distribution, Blob redundancy, Azure Files regional strategy, availability zones, paired regions, replication topology.

Forum-discovery note: Public candidate discussions commonly mention paired-region strategy, availability zones, SQL failover groups, Cosmos DB multi-region design, Azure Backup, and Azure Site Recovery as recurring scenario anchors.

#### Coverage notes

For this domain, the best study flow starts with Azure reliability documentation, Azure Backup, Azure Site Recovery, and the Azure Well-Architected reliability pillar, then branches into service-specific reliability guides for SQL, Cosmos DB, Blob Storage, VMs, and VMSS. The most testable pattern is not “memorize one backup product,” but “match RPO/RTO and failure domain requirements to zones, regions, replication, backup, and failover tooling.”

## Domain: Design infrastructure solutions

### Skill: Design compute solutions

#### Task: Specify components of a compute solution based on workload requirements

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree> | Primary decision guide for mapping workload needs to compute models. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/choose-azure-container-service) | <https://learn.microsoft.com/en-us/azure/architecture/guide/choose-azure-container-service> | Helps decide when containers are the right compute component. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview> | Grounds edge and traffic-management components that accompany compute choices. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-stores-getting-started) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-stores-getting-started> | Useful because compute selection depends on coupled storage decisions. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/messaging) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/messaging> | Important when workload requirements imply asynchronous compute patterns. |

Potentially relevant products considered: Compute decision trees, containers, messaging, storage, load balancing, API gateways, serverless triggers.

#### Task: Recommend a virtual machine-based solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/availability) | <https://learn.microsoft.com/en-us/azure/virtual-machines/availability> | Supports availability-set and zone-based VM architecture decisions. |
| [Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview) | <https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview> | Core networking design source for VM connectivity and segmentation. |
| [Load Balancer](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview) | <https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview> | Needed when VM solutions require Layer 4 traffic distribution or outbound patterns. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-overview) | <https://learn.microsoft.com/en-us/azure/backup/backup-overview> | Important for VM protection and recovery architecture. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/monitor-vm) | <https://learn.microsoft.com/en-us/azure/azure-monitor/vm/monitor-vm> | Grounds observability requirements for VM-based designs. |

Potentially relevant products considered: VMs, VMSS, managed disks, load balancers, virtual networks, backup, Bastion, monitoring.

#### Task: Recommend a container-based solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/what-is-aks) | <https://learn.microsoft.com/en-us/azure/aks/what-is-aks> | Primary orchestrated container platform for complex or large-scale workloads. |
| [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/overview) | <https://learn.microsoft.com/en-us/azure/container-apps/overview> | Useful for serverless containers, microservices, and event-driven apps. |
| [Azure Container Instances](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-overview) | <https://learn.microsoft.com/en-us/azure/container-instances/container-instances-overview> | Good fit for simple isolated containers and burst/task execution. |
| [Azure Container Registry](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-intro) | <https://learn.microsoft.com/en-us/azure/container-registry/container-registry-intro> | Essential image registry for container supply chain and deployment design. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/choose-azure-container-service) | <https://learn.microsoft.com/en-us/azure/architecture/guide/choose-azure-container-service> | Direct comparison guide for AKS, Container Apps, ACI, and adjacent options. |

Potentially relevant products considered: AKS, Container Apps, ACI, Container Registry, App Service for containers, Dapr-based app patterns, Application Gateway for Containers.

#### Task: Recommend a serverless-based solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview> | Canonical serverless compute platform for event and API-triggered code. |
| [Azure Logic Apps](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview) | <https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview> | Important for orchestration-centric serverless integration workflows. |
| [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/overview) | <https://learn.microsoft.com/en-us/azure/container-apps/overview> | Relevant for serverless container workloads where Kubernetes management is unnecessary. |
| [Azure Event Grid](https://learn.microsoft.com/en-us/azure/event-grid/overview) | <https://learn.microsoft.com/en-us/azure/event-grid/overview> | Supports trigger fan-out and event-driven invocation patterns for serverless systems. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree> | Helps compare Functions, containers, and PaaS app hosting against requirements. |

Potentially relevant products considered: Functions, Logic Apps, Container Apps, Event Grid, Service Bus triggers, App Service, Durable Functions.

#### Task: Recommend a compute solution for batch processing

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Batch](https://learn.microsoft.com/en-us/azure/batch/) | <https://learn.microsoft.com/en-us/azure/batch/> | Core service for scheduled, parallel, and HPC-like batch jobs. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/batch-processing) | <https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/batch-processing> | Compares batch engines and processing models for design decisions. |
| [Azure Container Instances](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-best-practices-and-considerations) | <https://learn.microsoft.com/en-us/azure/container-instances/container-instances-best-practices-and-considerations> | Useful for bursty, isolated, task-oriented container jobs. |
| [Azure Databricks](https://learn.microsoft.com/en-us/azure/databricks/introduction/) | <https://learn.microsoft.com/en-us/azure/databricks/introduction/> | Relevant when batch processing is data-engineering or analytics heavy. |
| [Azure Data Factory](https://learn.microsoft.com/en-us/azure/data-factory/introduction) | <https://learn.microsoft.com/en-us/azure/data-factory/introduction> | Supports orchestration and scheduling across batch processing stages. |

Potentially relevant products considered: Azure Batch, Databricks, Data Factory orchestration, Container Instances, HDInsight legacy comparisons, HPC patterns.

### Skill: Design an application architecture

#### Task: Recommend a messaging architecture

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/messaging) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/messaging> | Primary service-comparison guide for brokered and event messaging choices. |
| [Azure Service Bus Messaging](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview) | <https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview> | Best fit for reliable queues, topics, sessions, and enterprise messaging. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-features) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-features> | Important when ingesting large telemetry or event streams. |
| [Azure Queue storage](https://learn.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction) | <https://learn.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction> | Relevant for simple, low-cost queue-based decoupling. |
| [Azure Logic Apps](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview) | <https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview> | Useful when messaging is part of larger orchestration or integration workflows. |

Potentially relevant products considered: Service Bus, Event Hubs, Queue Storage, Logic Apps, Event Grid, competing consumers, publisher-subscriber.

#### Task: Recommend an event-driven architecture

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Event Grid](https://learn.microsoft.com/en-us/azure/event-grid/overview) | <https://learn.microsoft.com/en-us/azure/event-grid/overview> | Core event-routing service for reactive application architectures. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-features) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-features> | Relevant when event-driven systems ingest high-volume streams. |
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview> | Common compute target for event-triggered handlers and lightweight processing. |
| [Azure Logic Apps](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview) | <https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview> | Useful for no-code/low-code event reactions and workflow fan-out. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/patterns/publisher-subscriber) | <https://learn.microsoft.com/en-us/azure/architecture/patterns/publisher-subscriber> | Provides the architecture pattern behind event-driven decoupling decisions. |

Potentially relevant products considered: Event Grid, Event Hubs, Functions, Logic Apps, publisher-subscriber, event sourcing, webhook endpoints.

#### Task: Recommend a solution for API integration

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts) | <https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts> | Primary API gateway, policy, security, and lifecycle management platform. |
| [Azure Logic Apps](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview) | <https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview> | Useful for orchestrating API calls across SaaS, Azure, and on-prem endpoints. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/integration/integration-start-here) | <https://learn.microsoft.com/en-us/azure/architecture/integration/integration-start-here> | High-value integration overview across APIs, events, messaging, and orchestration. |
| [Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/) | <https://learn.microsoft.com/en-us/entra/identity-platform/> | Supports API authorization, delegated access, and application-to-application identity. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/microservices/design/api-design) | <https://learn.microsoft.com/en-us/azure/architecture/microservices/design/api-design> | Helps with API shape, versioning, and microservice boundary decisions. |

Potentially relevant products considered: API Management, Logic Apps, identity platform, REST design, OAuth/OpenID Connect, integration services, service mesh-adjacent patterns.

#### Task: Recommend a caching solution for applications

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Managed Redis](https://learn.microsoft.com/en-us/azure/redis/overview) | <https://learn.microsoft.com/en-us/azure/redis/overview> | Primary managed in-memory cache service for Azure application architectures. |
| [Azure Managed Redis](https://learn.microsoft.com/en-us/azure/redis/architecture) | <https://learn.microsoft.com/en-us/azure/redis/architecture> | Helps reason about persistence, performance, modules, and architecture tradeoffs. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/understand-data-store-models) | <https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/understand-data-store-models> | Useful for comparing key-value and document-style data access patterns. |
| [Azure Cache for Redis](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview) | <https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview> | Still useful for understanding legacy Redis guidance and migration context. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/patterns/) | <https://learn.microsoft.com/en-us/azure/architecture/patterns/> | Supports cache-aside and related cloud design patterns used in AZ-305 scenarios. |

Potentially relevant products considered: Azure Managed Redis, cache-aside, output caching, session state, Cosmos DB integrated caches, legacy Azure Cache for Redis.

#### Task: Recommend an application configuration management solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure App Configuration](https://learn.microsoft.com/en-us/azure/azure-app-configuration/overview) | <https://learn.microsoft.com/en-us/azure/azure-app-configuration/overview> | Centralized service for config values and feature flags. |
| [Azure App Configuration](https://learn.microsoft.com/en-us/azure/azure-app-configuration/howto-best-practices) | <https://learn.microsoft.com/en-us/azure/azure-app-configuration/howto-best-practices> | Helps design store layout, resiliency, refresh, and multi-environment strategy. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview) | <https://learn.microsoft.com/en-us/azure/key-vault/general/overview> | Complements configuration management when secrets must be separated. |
| [App Service](https://learn.microsoft.com/en-us/azure/app-service/app-service-configuration-references) | <https://learn.microsoft.com/en-us/azure/app-service/app-service-configuration-references> | Shows how applications consume centralized configuration without hardcoding settings. |
| [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/> | Useful when configuration must be managed as code across environments. |

Potentially relevant products considered: App Configuration, feature flags, Key Vault references, App Service settings, managed identities, Bicep parameterization.

#### Task: Recommend an automated deployment solution for applications

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Pipelines](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops) | <https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops> | Core CI/CD pipeline capability for automated build, test, and deployment. |
| [Azure Pipelines](https://learn.microsoft.com/en-us/azure/devops/pipelines/?view=azure-devops) | <https://learn.microsoft.com/en-us/azure/devops/pipelines/?view=azure-devops> | Good root reference for multi-stage YAML and deployment strategy patterns. |
| [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/> | Primary IaC language for repeatable application environment deployment. |
| [ARM template](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/> | Important when reviewing ARM-native deployment mechanics and template reuse. |
| [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks> | Adds lifecycle control and drift-managed cleanup for IaC-managed estates. |
| [App Service](https://learn.microsoft.com/en-us/azure/app-service/deploy-best-practices) | <https://learn.microsoft.com/en-us/azure/app-service/deploy-best-practices> | Useful when deployment design must include slots, pipelines, and app rollout practices. |

Potentially relevant products considered: Azure Pipelines, Bicep, ARM templates, deployment stacks, Git-based CI/CD, App Service deployment slots, Container Registry tasks.

### Skill: Design migrations

#### Task: Evaluate a migration solution that leverages the Microsoft Cloud Adoption Framework for Azure

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/select-cloud-migration-strategy) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/select-cloud-migration-strategy> | Grounds rehost/replatform/refactor and related migration strategy decisions. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/assess-workloads-for-cloud-migration) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/assess-workloads-for-cloud-migration> | Covers assessment scope, dependencies, readiness, and risk analysis. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/plan-migration) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/plan-migration> | Helps convert strategy into migration waves and execution planning. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/execute-migration) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/execute-migration> | Useful for choosing execution paths and migration tooling. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/> | Important because migration solutions depend on a landing-zone foundation. |

Potentially relevant products considered: CAF migration strategies, workload assessment, migration waves, landing zones, governance readiness, Azure Migrate execution tools.

#### Task: Evaluate on-premises servers, data, and applications for migration

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview?view=migrate> | Central hub for server, app, database, and VDI migration assessment. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/concepts-assessment-overview?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/concepts-assessment-overview?view=migrate> | Defines assessment types, readiness analysis, right-sizing, and cost estimates. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/appcat/overview?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/appcat/overview?view=migrate> | Useful for application and code assessment beyond raw infrastructure discovery. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/create-web-app-assessment?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/create-web-app-assessment?view=migrate> | Supports web app modernization assessments to App Service or AKS. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/review-application-assessment?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/review-application-assessment?view=migrate> | Helps interpret application assessment outputs and recommended targets. |

Potentially relevant products considered: Azure Migrate appliance, assessment types, app and code assessment, web app assessments, business case, dependency mapping.

#### Task: Recommend a solution for migrating workloads to infrastructure as a service and platform as a service

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview?view=migrate> | Entry point for deciding IaaS versus modernization targets. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/appcat/overview?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/appcat/overview?view=migrate> | Useful for discovering modernization opportunities into PaaS targets. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/create-web-app-assessment?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/create-web-app-assessment?view=migrate> | Helps evaluate whether apps fit App Service or AKS instead of rehosted VMs. |
| [App Service](https://learn.microsoft.com/en-us/azure/app-service/app-service-asp-net-migration) | <https://learn.microsoft.com/en-us/azure/app-service/app-service-asp-net-migration> | Practical modernization guidance for moving web apps to PaaS. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/prepare-workloads-cloud) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/prepare-workloads-cloud> | Helps prepare workloads for successful cutover and target-state alignment. |

Potentially relevant products considered: Azure Migrate, App Service, AKS, VM rehosting, modernization paths, landing zone readiness, PaaS fit analysis.

#### Task: Recommend a solution for migrating databases

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Database Migration Service](https://learn.microsoft.com/en-us/azure/dms/dms-overview) | <https://learn.microsoft.com/en-us/azure/dms/dms-overview> | Core managed service for online and offline database migration scenarios. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/migration-guides/?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/migration-guides/?view=azuresql> | Best source for target-specific Azure SQL migration paths and prerequisites. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/migrate/migration-service/overview-migration-service-postgresql) | <https://learn.microsoft.com/en-us/azure/postgresql/migrate/migration-service/overview-migration-service-postgresql> | Covers PostgreSQL migration service options and validation. |
| [Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/) | <https://learn.microsoft.com/en-us/azure/mysql/> | Useful when planning MySQL destination options and operational characteristics. |
| [Azure Database Migration Service](https://learn.microsoft.com/en-us/azure/dms/dms-tools-matrix) | <https://learn.microsoft.com/en-us/azure/dms/dms-tools-matrix> | Helps compare available database migration tools by source and destination. |

Potentially relevant products considered: Azure DMS, Azure SQL migration guides, PostgreSQL migration service, MySQL flexible server, online/offline migration, schema conversion.

#### Task: Recommend a solution for migrating unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Storage Mover](https://learn.microsoft.com/en-us/azure/storage-mover/service-overview) | <https://learn.microsoft.com/en-us/azure/storage-mover/service-overview> | Core choice for hybrid file migration into Azure Storage. |
| [Azure Data Box](https://learn.microsoft.com/en-us/azure/databox/data-box-overview) | <https://learn.microsoft.com/en-us/azure/databox/data-box-overview> | Important for large offline transfers constrained by bandwidth or time. |
| [Azure File Sync](https://learn.microsoft.com/en-us/azure/storage/file-sync/file-sync-introduction) | <https://learn.microsoft.com/en-us/azure/storage/file-sync/file-sync-introduction> | Useful when migration and hybrid file access need to coexist. |
| [Azure Files](https://learn.microsoft.com/en-us/azure/storage/files/) | <https://learn.microsoft.com/en-us/azure/storage/files/> | Helps evaluate Azure Files as the landing target for migrated file shares. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/execute-migration) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/execute-migration> | Useful for sequencing data transfer methods into migration execution planning. |

Potentially relevant products considered: Storage Mover, Data Box, File Sync, Azure Files, Blob Storage, AzCopy, offline versus online transfer.

### Skill: Design network solutions

#### Task: Recommend a connectivity solution that connects Azure resources to the internet

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview) | <https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview> | Foundational source for ingress/egress, subnets, and internet-routable architectures. |
| [Azure NAT Gateway](https://learn.microsoft.com/en-us/azure/nat-gateway/nat-overview) | <https://learn.microsoft.com/en-us/azure/nat-gateway/nat-overview> | Important for explicit scalable outbound internet connectivity. |
| [Azure DNS](https://learn.microsoft.com/en-us/azure/dns/dns-overview) | <https://learn.microsoft.com/en-us/azure/dns/dns-overview> | Required for public DNS hosting and internet-facing name resolution design. |
| [Azure Front Door and CDN](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview) | <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview> | Relevant for global internet-facing web entry points and edge acceleration. |
| [Azure Application Gateway](https://learn.microsoft.com/en-us/azure/application-gateway/overview) | <https://learn.microsoft.com/en-us/azure/application-gateway/overview> | Important for regional Layer 7 ingress patterns to internet-facing apps. |

Potentially relevant products considered: Virtual Network, NAT Gateway, Azure DNS, Front Door, Application Gateway, public endpoints, private endpoint alternatives.

#### Task: Recommend a connectivity solution that connects Azure resources to on-premises networks

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [ExpressRoute](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction) | <https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction> | Primary private-connectivity option for enterprise hybrid networking. |
| [VPN Gateway](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways) | <https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways> | Supports encrypted site-to-site and point-to-site connectivity over the internet. |
| [Virtual WAN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about) | <https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about> | Useful for large-scale branch, remote user, and global transit architectures. |
| [Private Link](https://learn.microsoft.com/en-us/azure/private-link/private-link-service-overview) | <https://learn.microsoft.com/en-us/azure/private-link/private-link-service-overview> | Relevant when hybrid access must remain private to selected services. |
| [Azure DNS](https://learn.microsoft.com/en-us/azure/dns/private-dns-overview) | <https://learn.microsoft.com/en-us/azure/dns/private-dns-overview> | Important for private name resolution across hybrid environments. |

Potentially relevant products considered: ExpressRoute, VPN Gateway, Virtual WAN, Private Link, Private DNS, BGP, zone-redundant gateways, hub-and-spoke.

#### Task: Recommend a solution to optimize network performance

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Network Watcher](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview) | <https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview> | Central diagnostics toolset for latency, topology, flow, and connection troubleshooting. |
| [Azure Front Door and CDN](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview) | <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview> | Improves global latency and edge delivery for internet-facing applications. |
| [Traffic Manager](https://learn.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview) | <https://learn.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview> | Useful for DNS-based endpoint selection and geographic traffic steering. |
| [Load Balancer](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview) | <https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview> | Helps optimize east-west and north-south flow distribution for VM workloads. |
| [Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview) | <https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview> | Important for route-table optimization and custom path selection. |

Potentially relevant products considered: Network Watcher, Front Door, Traffic Manager, Load Balancer, UDRs, connection monitor, CDN, Virtual WAN.

#### Task: Recommend a solution to optimize network security

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/overview) | <https://learn.microsoft.com/en-us/azure/firewall/overview> | Core cloud-native firewall service for centralized network security. |
| [Web Application Firewall](https://learn.microsoft.com/en-us/azure/web-application-firewall/) | <https://learn.microsoft.com/en-us/azure/web-application-firewall/> | Protects Layer 7 workloads at Application Gateway or Front Door edge. |
| [Azure DDoS Protection](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview) | <https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview> | Important for internet-exposed workload protection against volumetric attacks. |
| [Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) | <https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview> | Covers subnet/NIC traffic filtering with NSGs and rule evaluation. |
| [Private Link](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview) | <https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview> | Key option for reducing public exposure of PaaS and service endpoints. |
| [Azure Firewall Manager](https://learn.microsoft.com/en-us/azure/firewall-manager/) | <https://learn.microsoft.com/en-us/azure/firewall-manager/> | Useful for centrally managing secured virtual hubs and distributed firewall policy. |

Potentially relevant products considered: Azure Firewall, Firewall Manager, WAF, DDoS Protection, NSGs, ASGs, Private Link, route tables, hub-and-spoke security.

#### Task: Recommend a load-balancing and routing solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview> | Best comparison guide for selecting among Azure traffic distribution services. |
| [Load Balancer](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview) | <https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview> | Required for regional Layer 4 balancing and inbound/outbound flow scenarios. |
| [Azure Application Gateway](https://learn.microsoft.com/en-us/azure/application-gateway/overview) | <https://learn.microsoft.com/en-us/azure/application-gateway/overview> | Important for Layer 7 routing, TLS termination, and path-based rules. |
| [Azure Front Door and CDN](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview) | <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview> | Supports global anycast entry, acceleration, and edge-based failover. |
| [Traffic Manager](https://learn.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview) | <https://learn.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview> | Useful for DNS-based cross-region endpoint routing and failover. |

Potentially relevant products considered: Load Balancer, Application Gateway, Front Door, Traffic Manager, NAT Gateway, Virtual WAN, Azure DNS, WAF.

Forum-discovery note: Public candidate discussions most often mention service-selection comparisons such as Front Door versus Application Gateway, Load Balancer versus Traffic Manager, AKS versus Container Apps, SQL Database versus Managed Instance, and Azure Migrate plus landing zones for migration planning.

#### Coverage notes

This domain is where Architecture Center decision guides add the most value. AZ-305 scenarios often hinge on choosing among multiple “correct” services based on constraints, especially compute, containers, messaging, API integration, migrations, and network edge/routing. The documentation sets worth downloading first are Azure Architecture Center, Azure Migrate, Azure SQL, Azure Kubernetes Service, Azure Container Apps, API Management, Azure Firewall, Virtual Network, ExpressRoute, VPN Gateway, Front Door and CDN, Application Gateway, Load Balancer, and Traffic Manager.

## Coverage audit

The final map includes the core product families that most strongly align to the current AZ-305 study guide hierarchy: Microsoft Entra ID, Conditional Access, authentication methods, Microsoft identity platform, managed identities, Microsoft Entra ID Governance, PIM, access reviews, entitlement management, Application Proxy, hybrid identity, Azure RBAC, Azure Policy, management groups, resource groups, tags, Defender for Cloud, Purview, Azure Monitor, Log Analytics, Application Insights, VM and container monitoring, Network Watcher, Advisor, diagnostic settings, Activity Log, DCRs, Azure SQL Database, Azure SQL Managed Instance, SQL Server on Azure VM, PostgreSQL, MySQL, Cosmos DB, Azure Storage, Blob Storage, Azure Files, Data Lake Storage, Data Factory, Synapse, Databricks, Data Explorer, Stream Analytics, Event Hubs, Event Grid, Service Bus, Backup, Site Recovery, reliability guidance, availability zones, region pairs, VMs, VMSS, App Service, AKS, Container Apps, Functions, Batch, API Management, App Configuration, Key Vault, Azure Managed Redis, Logic Apps, Bicep, ARM templates, deployment stacks, Cloud Adoption Framework, Azure Migrate, Azure Database Migration Service, Storage Mover, Data Box, File Sync, Virtual Network, VPN Gateway, ExpressRoute, Virtual WAN, Azure DNS, Private DNS, Private Link, NAT Gateway, Azure Firewall, Firewall Manager, DDoS Protection, NSGs, UDR guidance, Load Balancer, Application Gateway, Front Door and CDN, Traffic Manager, and Network Watcher. The main areas only lightly represented are Azure NetApp Files, application security groups, and a few service-specific backup/deep-comparison pages, which are more situational than foundational for AZ-305 preparation.
