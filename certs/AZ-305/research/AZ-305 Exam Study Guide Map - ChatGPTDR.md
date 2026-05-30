# AZ-305 Documentation Map

## Domain: Design identity, governance, and monitoring solutions

### Skill: Design solutions for logging and monitoring

#### Task: Recommend a logging solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview> | Establishes the Azure observability platform and explains how logs, metrics, traces, and events fit together. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview> | Grounds Log Analytics workspace design, retention, access, and multi-source log aggregation decisions. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design> | Helps size and segment workspaces by tenant, environment, compliance boundary, and operational model. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources) | <https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources> | Maps common Azure and hybrid log sources to the relevant collection methods for solution design. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview> | Supports guest and hybrid workload log collection strategy by explaining Azure Monitor Agent capabilities. |

#### Task: Recommend a solution for routing logs

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings) | <https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings> | Core reference for routing platform logs and metrics to Log Analytics, Event Hubs, and Storage. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log) | <https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log> | Explains subscription and management-group activity logs and how they can be retained, exported, and alerted on. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview> | Supports routing and transformation design for modern Azure Monitor data collection pipelines. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about> | Useful when log routing needs high-throughput streaming into SIEM, downstream processors, or external consumers. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-introduction) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-introduction> | Supports archive and low-cost retention destinations for exported logs and audit data. |

#### Task: Recommend a monitoring solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview> | Provides the end-to-end monitoring model for Azure, hybrid, apps, infrastructure, and alerts. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview> | Covers application performance monitoring, distributed tracing, OpenTelemetry, and user experience telemetry. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/monitor-vm) | <https://learn.microsoft.com/en-us/azure/azure-monitor/vm/monitor-vm> | Grounds VM monitoring design across host metrics, guest logs, and health/performance views. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/prometheus-metrics-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/prometheus-metrics-overview> | Useful for container and Kubernetes monitoring when Prometheus-compatible metrics are required. |
| [Azure Advisor](https://learn.microsoft.com/en-us/azure/advisor/advisor-overview) | <https://learn.microsoft.com/en-us/azure/advisor/advisor-overview> | Adds architecture and operational recommendations that complement telemetry-driven monitoring. |

### Skill: Design authentication and authorization solutions

#### Task: Recommend an authentication solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Authentication](https://learn.microsoft.com/en-us/entra/identity/authentication/overview-authentication) | <https://learn.microsoft.com/en-us/entra/identity/authentication/overview-authentication> | Covers MFA, passwordless, passkeys, and phishing-resistant sign-in choices for workforce identities. |
| [Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview) | <https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview> | Supports policy-based authentication decisions using device, risk, network, and application signals. |
| [Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/v2-overview) | <https://learn.microsoft.com/en-us/entra/identity-platform/v2-overview> | Essential for designing app authentication flows, token-based access, and delegated/app permissions. |
| [Hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn> | Helps choose between password hash sync, pass-through authentication, and federation for hybrid scenarios. |
| [Microsoft Entra External ID](https://learn.microsoft.com/en-us/entra/external-id/external-identities-overview) | <https://learn.microsoft.com/en-us/entra/external-id/external-identities-overview> | Supports customer, partner, and guest-facing authentication designs beyond internal workforce identities. |

#### Task: Recommend an identity management solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/) | <https://learn.microsoft.com/en-us/entra/identity/> | Establishes the core identity directory, tenant, user, group, and application management surface. |
| [Hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity> | Supports identity lifecycle design across on-premises AD and Microsoft Entra ID. |
| [Application management](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/what-is-application-management) | <https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/what-is-application-management> | Useful for enterprise app onboarding, SSO, provisioning, and access assignment patterns. |
| [Managed identities for Azure resources](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) | <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview> | Covers workload identities for Azure-hosted applications that should avoid credentials. |
| [Microsoft Entra device identity](https://learn.microsoft.com/en-us/entra/identity/devices/) | <https://learn.microsoft.com/en-us/entra/identity/devices/> | Supports designs that tie device state to identity and access controls. |

#### Task: Recommend a solution for authorizing access to Azure resources

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure RBAC](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview) | <https://learn.microsoft.com/en-us/azure/role-based-access-control/overview> | Primary reference for control-plane authorization to Azure resources by scope and role assignment. |
| [Azure RBAC](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles) | <https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles> | Helps choose least-privilege built-in roles for administrative and operational scenarios. |
| [Azure RBAC](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-definitions) | <https://learn.microsoft.com/en-us/azure/role-based-access-control/role-definitions> | Grounds custom role design and the distinction between actions, data actions, and scopes. |
| [Azure RBAC](https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-overview) | <https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-overview> | Adds ABAC-style conditional authorization where tags and attributes matter. |
| [Managed identities for Azure resources](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations) | <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations> | Useful when Azure resource authorization should be granted to workload identities instead of people. |

#### Task: Recommend a solution for authorizing access to on-premises resources

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Application proxy](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy) | <https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy> | Core Microsoft guidance for publishing private web apps with Entra-based preauthentication and SSO. |
| [Hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity> | Supports hybrid authorization models where the same identity must reach cloud and on-premises resources. |
| [Hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync> | Covers modern synchronization options that underpin authorization to hybrid resources. |
| [Hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn> | Helps decide how sign-ins are validated in hybrid identity environments. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/identity/azure-ad) | <https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/identity/azure-ad> | Provides an architectural blueprint for integrating on-premises AD with Microsoft Entra ID. |

#### Task: Recommend a solution to manage secrets, certificates, and keys

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview) | <https://learn.microsoft.com/en-us/azure/key-vault/general/overview> | Core service for centralized management of secrets, keys, and certificates. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/about-keys-secrets-certificates) | <https://learn.microsoft.com/en-us/azure/key-vault/general/about-keys-secrets-certificates> | Clarifies which Key Vault object type fits each requirement and workload pattern. |
| [Azure Key Vault Managed HSM](https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/overview) | <https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/overview> | Supports designs that require dedicated, FIPS-validated HSM-backed key protection. |
| [Azure Key Vault Managed HSM](https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control) | <https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control> | Useful when the design must also account for HSM authorization and separation of duties. |
| [Managed identities for Azure resources](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) | <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview> | Helps remove embedded secrets by using workload identities to reach Key Vault securely. |

### Skill: Design governance

#### Task: Recommend a structure for management groups, subscriptions, and resource groups, and a strategy for resource tagging

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/) | <https://learn.microsoft.com/en-us/azure/governance/management-groups/> | Primary source for tenant-level hierarchy and policy inheritance design. |
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/) | <https://learn.microsoft.com/en-us/azure/governance/policy/> | Supports guardrails, required tags, and consistent governance at scale. |
| [Azure Resource Manager](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview> | Grounds resource group scoping, ARM-based governance, and consistent deployment boundaries. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/> | Helps structure enterprise estates through platform and application landing zones. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-areas) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-areas> | Covers design areas that affect subscription placement, policy scope, identity, and management patterns. |

#### Task: Recommend a solution for managing compliance

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/) | <https://learn.microsoft.com/en-us/azure/governance/policy/> | Provides policy-based enforcement, audit, remediation, and compliance tracking. |
| [Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-regulatory-compliance) | <https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-regulatory-compliance> | Maps regulatory standards and security controls into a central compliance dashboard. |
| [Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/assign-regulatory-compliance-standards) | <https://learn.microsoft.com/en-us/azure/defender-for-cloud/assign-regulatory-compliance-standards> | Supports design decisions about which standards to assess and where to scope them. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-areas) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-areas> | Useful because compliance is often implemented as part of landing zone design, not a single product. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/management-governance/management-governance-start-here) | <https://learn.microsoft.com/en-us/azure/architecture/guide/management-governance/management-governance-start-here> | Offers architect-level governance and compliance guidance when product docs alone are too narrow. |

#### Task: Recommend a solution for identity governance

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview) | <https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview> | Establishes the overall identity governance feature set and when to use it. |
| [Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-getting-started) | <https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-getting-started> | Supports just-in-time privileged access and standing-access reduction designs. |
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/access-reviews-overview) | <https://learn.microsoft.com/en-us/entra/id-governance/access-reviews-overview> | Covers recurring access review patterns for groups, apps, and guests. |
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-overview) | <https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-overview> | Useful for access package, approval workflow, and expiration-based governance design. |
| [Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-deployment-plan) | <https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-deployment-plan> | Helps turn privileged-access requirements into an implementation and operating model. |

### Coverage notes

Governance and identity tasks are the most fragmented parts of this domain. Azure Monitor appears repeatedly because logging, routing, observability, and alerting are all implemented through the same platform. Microsoft Entra content is split across several nested documentation sets such as Authentication, Conditional Access, Hybrid identity, Application proxy, and ID Governance, so those PDF downloads are worth prioritizing early. For governance structure and compliance tasks, architecture guidance from the Cloud Adoption Framework and Azure Architecture Center is often more valuable than a single product root because subscription hierarchy, landing zones, policy, and compliance scopes are designed together.

## Domain: Design data storage solutions

### Skill: Design data storage solutions for relational data

#### Task: Recommend a solution for storing relational data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-stores-getting-started) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-stores-getting-started> | Provides the decision framework for choosing a relational store in Azure. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/understand-data-store-models) | <https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/understand-data-store-models> | Helps compare relational, document, key-value, analytics, and file/object store models. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview?view=azuresql> | Core PaaS relational service for managed SQL workloads. |
| [Azure SQL Managed Instance](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview?view=azuresql> | Useful when SQL Server compatibility requirements exceed single-database Azure SQL needs. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/overview) | <https://learn.microsoft.com/en-us/azure/postgresql/overview> | Supports managed PostgreSQL solution selection for open-source relational workloads. |
| [Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview) | <https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview> | Supports MySQL-based relational solution selection for app modernization and managed database scenarios. |

#### Task: Recommend a database service tier and compute tier

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/purchasing-models?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/purchasing-models?view=azuresql> | Compares SQL purchasing models and service tiers for capacity and cost planning. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-sql-database-vcore?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-sql-database-vcore?view=azuresql> | Explains provisioned versus serverless compute and the vCore model in detail. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/serverless-tier-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/serverless-tier-overview?view=azuresql> | Useful when the workload has variable or intermittent usage patterns. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tier-hyperscale?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tier-hyperscale?view=azuresql> | Supports design choices for very large databases with scale-out storage and compute. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/compute-storage/concepts-compute) | <https://learn.microsoft.com/en-us/azure/postgresql/compute-storage/concepts-compute> | Grounds tier and compute selection for PostgreSQL flexible server. |

#### Task: Recommend a solution for database scalability

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-pool-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-pool-overview?view=azuresql> | Essential for multi-database SaaS and bursty workload scaling designs. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/hyperscale-elastic-pool-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/hyperscale-elastic-pool-overview?view=azuresql> | Supports scale-out patterns for very large pooled database estates. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/resource-limits-vcore-elastic-pools?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/resource-limits-vcore-elastic-pools?view=azuresql> | Helps quantify pool sizing, limits, and headroom. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/compute-storage/concepts-storage) | <https://learn.microsoft.com/en-us/azure/postgresql/compute-storage/concepts-storage> | Useful for storage throughput, IOPS, and capacity planning in PostgreSQL. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/compute-storage/concepts-optimal-performance) | <https://learn.microsoft.com/en-us/azure/postgresql/compute-storage/concepts-optimal-performance> | Connects workload behavior to compute, storage, and scaling recommendations. |

#### Task: Recommend a solution for data protection

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview?view=azuresql> | Covers backups, availability, HA, and DR capabilities for Azure SQL. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/disaster-recovery-guidance?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/disaster-recovery-guidance?view=azuresql> | Helps match protection patterns to outage scenarios and recovery expectations. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/authentication-aad-configure?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/authentication-aad-configure?view=azuresql> | Supports identity-based database access for stronger protection and governance. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/security/security-access-control) | <https://learn.microsoft.com/en-us/azure/postgresql/security/security-access-control> | Grounds role- and permission-based protection models for PostgreSQL. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/overview) | <https://learn.microsoft.com/en-us/azure/postgresql/overview> | Provides the managed-service protection baseline for PostgreSQL workloads. |

### Skill: Design data storage solutions for semi-structured and unstructured data

#### Task: Recommend a solution for storing semi-structured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/overview) | <https://learn.microsoft.com/en-us/azure/cosmos-db/overview> | Primary Microsoft source for globally distributed, semi-structured NoSQL storage design. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/modeling-data) | <https://learn.microsoft.com/en-us/azure/cosmos-db/modeling-data> | Helps shape document modeling choices around query patterns and performance. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/partitioning) | <https://learn.microsoft.com/en-us/azure/cosmos-db/partitioning> | Essential for scaling, throughput distribution, and hot-partition avoidance. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels) | <https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels> | Supports tradeoffs between consistency, latency, and availability. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/understand-data-store-models) | <https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/understand-data-store-models> | Helps justify when document, key-value, graph, or other nonrelational models fit best. |

#### Task: Recommend a solution for storing unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-introduction) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-introduction> | Establishes the overall Azure Storage model for blobs, files, queues, and tables. |
| [Azure Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction) | <https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction> | Core guidance for large-scale object storage and binary/text content. |
| [Azure Files](https://learn.microsoft.com/en-us/azure/storage/files/) | <https://learn.microsoft.com/en-us/azure/storage/files/> | Useful when SMB or NFS file shares are the right unstructured storage interface. |
| [Azure Data Lake Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction) | <https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction> | Supports hierarchical namespace and analytics-oriented file/object storage decisions. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/storage-options) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/storage-options> | Compares Azure storage services by workload need, access pattern, and capability. |

#### Task: Recommend a data storage solution to balance features, performance, and costs

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/storage-options) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/storage-options> | Gives the clearest cross-service comparison for storage features and tradeoffs. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview> | Helps choose the right storage account type, tier, endpoints, and redundancy options. |
| [Azure Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview> | Supports cost optimization by access pattern using hot, cool, cold, archive, and smart tiers. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/partitioning) | <https://learn.microsoft.com/en-us/azure/cosmos-db/partitioning> | Important because partition-key design directly affects performance and cost. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels) | <https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels> | Useful for latency and consistency tradeoffs that often drive overall cost. |

#### Task: Recommend a data solution for protection and durability

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy> | Primary reference for LRS, ZRS, GRS, and GZRS durability design. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/data-protection-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/data-protection-overview> | Consolidates soft delete, versioning, snapshots, immutability, and restore patterns. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview> | Supports WORM-style protection, legal hold, and tamper resistance requirements. |
| [Azure Files](https://learn.microsoft.com/en-us/azure/storage/files/files-data-protection-overview) | <https://learn.microsoft.com/en-us/azure/storage/files/files-data-protection-overview> | Applies data protection concepts specifically to Azure file shares and hybrid file scenarios. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/continuous-backup-restore-introduction) | <https://learn.microsoft.com/en-us/azure/cosmos-db/continuous-backup-restore-introduction> | Supports point-in-time restore and accidental change recovery for semi-structured data. |

### Skill: Design data integration

#### Task: Recommend a solution for data integration

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Data Factory](https://learn.microsoft.com/en-us/azure/data-factory/introduction) | <https://learn.microsoft.com/en-us/azure/data-factory/introduction> | Core product for orchestrated data movement, ETL/ELT, and hybrid integration. |
| [Azure Data Factory](https://learn.microsoft.com/en-us/azure/data-factory/concepts-data-flow-overview) | <https://learn.microsoft.com/en-us/azure/data-factory/concepts-data-flow-overview> | Supports visual transformation design when pipelines need more than raw copy. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about> | Useful for high-ingest streaming integration patterns and event pipelines. |
| [Azure Event Grid](https://learn.microsoft.com/en-us/azure/event-grid/overview) | <https://learn.microsoft.com/en-us/azure/event-grid/overview> | Supports event-driven integration between services and reactive data workflows. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/data-guide/scenarios/data-transfer) | <https://learn.microsoft.com/en-us/azure/architecture/data-guide/scenarios/data-transfer> | Helps compare transfer and movement options for batch, streaming, offline, and periodic data flows. |

#### Task: Recommend a solution for data analysis

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Synapse Analytics](https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is) | <https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is> | Covers integrated SQL, Spark, and pipeline analytics patterns in a single workspace model. |
| [Azure Databricks](https://learn.microsoft.com/en-us/azure/databricks/introduction/) | <https://learn.microsoft.com/en-us/azure/databricks/introduction/> | Supports large-scale data engineering, analytics, and AI workloads. |
| [Azure Data Explorer](https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview) | <https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview> | Useful for near-real-time analytics over high-volume telemetry and time-series data. |
| [Azure Stream Analytics](https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction) | <https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction> | Covers real-time stream processing when the analysis requirement is continuous, not batch. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/analysis-visualizations-reporting) | <https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/analysis-visualizations-reporting> | Adds architect-level service comparison for analytical and reporting solution choice. |

### Coverage notes

This domain is fragmented because the study guide mixes storage-model selection, product sizing, durability, and analytics. Azure Architecture Center is especially valuable for the “recommend a solution” tasks because it frames service choice before you drop into product-specific documentation. For relational work, download Azure SQL, Azure SQL Managed Instance, Azure Database for PostgreSQL, and Azure Database for MySQL first. For semi-structured and unstructured work, Azure Cosmos DB and Azure Storage will appear repeatedly. For data integration and analysis, Azure Data Factory, Azure Synapse Analytics, Azure Databricks, Azure Data Explorer, and Azure Event Hubs collectively cover most of the design space.

## Domain: Design business continuity solutions

### Skill: Design solutions for backup and disaster recovery

#### Task: Recommend a recovery solution for Azure and hybrid workloads that meets recovery objectives

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/reliability/metrics) | <https://learn.microsoft.com/en-us/azure/well-architected/reliability/metrics> | Grounds RPO, RTO, and availability target selection before picking recovery tooling. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/reliability/disaster-recovery) | <https://learn.microsoft.com/en-us/azure/well-architected/reliability/disaster-recovery> | Helps translate business continuity requirements into DR strategy choices. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-overview) | <https://learn.microsoft.com/en-us/azure/backup/backup-overview> | Core service for backup-based recovery across Azure and selected hybrid workloads. |
| [Azure Site Recovery](https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-overview) | <https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-overview> | Core service for replication, failover, and failback for Azure and hybrid disaster recovery. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/overview) | <https://learn.microsoft.com/en-us/azure/reliability/overview> | Useful when recovery design depends on service-level resilience characteristics, zones, and regions. |

#### Task: Recommend a backup and recovery solution for compute

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-azure-vms-introduction) | <https://learn.microsoft.com/en-us/azure/backup/backup-azure-vms-introduction> | Primary guidance for VM backup architecture, vaulting, and restore choices. |
| [Azure Site Recovery](https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-architecture) | <https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-architecture> | Supports Azure VM replication and region-failover design. |
| [Virtual Machines](https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machines) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machines> | Adds service-specific resiliency and recovery expectations for individual VMs. |
| [Virtual Machine Scale Sets](https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machine-scale-sets) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machine-scale-sets> | Extends compute recovery design to scaled-out VM fleets. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/) | <https://learn.microsoft.com/en-us/azure/backup/> | Useful as the broader compute-backup documentation root for policies, vaults, and support matrices. |

#### Task: Recommend a backup and recovery solution for databases

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview?view=azuresql> | Core source for Azure SQL backup, restore, HA, and DR capabilities. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/disaster-recovery-guidance?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/disaster-recovery-guidance?view=azuresql> | Helps choose the correct recovery pattern by outage type and workload criticality. |
| [Azure SQL Managed Instance](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/business-continuity-high-availability-disaster-recover-hadr-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/business-continuity-high-availability-disaster-recover-hadr-overview?view=azuresql> | Applies database recovery design to managed-instance deployments that need SQL Server compatibility. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/continuous-backup-restore-introduction) | <https://learn.microsoft.com/en-us/azure/cosmos-db/continuous-backup-restore-introduction> | Supports database recovery for NoSQL-style data stores when point-in-time restore matters. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/periodic-backup-restore-introduction) | <https://learn.microsoft.com/en-us/azure/cosmos-db/periodic-backup-restore-introduction> | Adds backup-mode selection context for Cosmos DB database recovery strategy. |

#### Task: Recommend a backup and recovery solution for unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/data-protection-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/data-protection-overview> | Central reference for protection of blob data using versioning, soft delete, and restore. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/soft-delete-blob-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/soft-delete-blob-overview> | Supports accidental deletion and overwrite recovery for blobs. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/versioning-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/versioning-overview> | Useful for object-level recovery and historical restore scenarios. |
| [Azure Files](https://learn.microsoft.com/en-us/azure/storage/files/files-data-protection-overview) | <https://learn.microsoft.com/en-us/azure/storage/files/files-data-protection-overview> | Covers backup, snapshots, and protection of file-share workloads. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-azure-files) | <https://learn.microsoft.com/en-us/azure/backup/backup-azure-files> | Provides the backup implementation pattern for Azure Files. |

### Skill: Design for high availability

#### Task: Recommend a high availability solution for compute

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/availability) | <https://learn.microsoft.com/en-us/azure/virtual-machines/availability> | Summarizes HA options such as zones, sets, and VM placement strategies. |
| [Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/availability-set-overview) | <https://learn.microsoft.com/en-us/azure/virtual-machines/availability-set-overview> | Useful where availability zones are unavailable or the design uses fault/update domain separation. |
| [Virtual Machine Scale Sets](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-use-availability-zones) | <https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-use-availability-zones> | Supports zonal and zone-spanning HA designs for fleets of compute instances. |
| [Azure reliability documentation](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview) | <https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview> | Provides the platform concept that underpins many HA design decisions. |
| [Virtual Machines](https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machines) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machines> | Adds service-specific resilience guidance beyond simple placement patterns. |

#### Task: Recommend a high availability solution for relational data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview?view=azuresql> | Core Azure guidance for SQL HA across local replicas, zones, and regions. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/designing-cloud-solutions-for-disaster-recovery?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/designing-cloud-solutions-for-disaster-recovery?view=azuresql> | Useful for architecting globally available relational services. |
| [Azure SQL Managed Instance](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/business-continuity-high-availability-disaster-recover-hadr-overview?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/business-continuity-high-availability-disaster-recover-hadr-overview?view=azuresql> | Applies HA guidance to managed-instance deployments. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/overview) | <https://learn.microsoft.com/en-us/azure/postgresql/overview> | Captures the managed PostgreSQL feature baseline that informs HA options and tradeoffs. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/reliability/metrics) | <https://learn.microsoft.com/en-us/azure/well-architected/reliability/metrics> | Helps align database HA choices to business-defined availability targets. |

#### Task: Recommend a high availability solution for semi-structured and unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy> | Primary source for storage-account HA and regional durability options. |
| [Azure Files](https://learn.microsoft.com/en-us/azure/storage/files/files-redundancy) | <https://learn.microsoft.com/en-us/azure/storage/files/files-redundancy> | Applies redundancy choices specifically to file shares. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/global-distribution) | <https://learn.microsoft.com/en-us/azure/cosmos-db/global-distribution> | Essential for multi-region semi-structured data availability design. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels) | <https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels> | Important because HA in distributed databases depends on consistency/latency tradeoffs. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/storage-options) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/storage-options> | Helps connect technical HA features to the right storage service choice. |

### Coverage notes

This domain is where the Azure Well-Architected Framework becomes especially important because recovery objectives come before tool selection. Azure Backup and Azure Site Recovery recur throughout the backup/DR tasks and are the first PDF downloads to prioritize. For high availability, the best source is often not a single product root but a combination of service-level reliability guidance, workload targets, and product-specific HA or replication documentation. Azure SQL, Azure Storage, and Azure Cosmos DB appear repeatedly because they each expose distinct HA and recovery models.

## Domain: Design infrastructure solutions

### Skill: Design compute solutions

#### Task: Specify components of a compute solution based on workload requirements

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree> | Best high-level decision aid for matching workload characteristics to Azure compute platforms. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/microservices/design/compute-options) | <https://learn.microsoft.com/en-us/azure/architecture/microservices/design/compute-options> | Useful when the workload is decomposed into independently deployable services. |
| [App Service](https://learn.microsoft.com/en-us/azure/app-service/overview) | <https://learn.microsoft.com/en-us/azure/app-service/overview> | Covers fully managed web app and API hosting decisions. |
| [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/what-is-aks) | <https://learn.microsoft.com/en-us/azure/aks/what-is-aks> | Supports managed Kubernetes component selection when orchestration is required. |
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview> | Covers event-driven serverless components for elastic, code-focused workloads. |

#### Task: Recommend a virtual machine-based solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/availability) | <https://learn.microsoft.com/en-us/azure/virtual-machines/availability> | Provides the core deployment and availability choices for VM-centric architectures. |
| [Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/availability-set-overview) | <https://learn.microsoft.com/en-us/azure/virtual-machines/availability-set-overview> | Useful when the design uses grouped VMs with update/fault domain separation. |
| [Virtual Machine Scale Sets](https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machine-scale-sets) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machine-scale-sets> | Supports autoscale and fleet-level VM solution design. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-azure-vms-introduction) | <https://learn.microsoft.com/en-us/azure/backup/backup-azure-vms-introduction> | Important because VM design usually includes protection and restore requirements. |
| [Azure Site Recovery](https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-architecture) | <https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-architecture> | Adds regional DR and failover guidance for VM solutions. |

#### Task: Recommend a container-based solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/what-is-aks) | <https://learn.microsoft.com/en-us/azure/aks/what-is-aks> | Core managed Kubernetes platform for complex and orchestrated container workloads. |
| [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/core-aks-concepts) | <https://learn.microsoft.com/en-us/azure/aks/core-aks-concepts> | Grounds cluster, node, networking, and workload-placement design decisions. |
| [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/overview) | <https://learn.microsoft.com/en-us/azure/container-apps/overview> | Useful for serverless container scenarios without full Kubernetes management overhead. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/microservices/design/compute-options) | <https://learn.microsoft.com/en-us/azure/architecture/microservices/design/compute-options> | Helps distinguish orchestrated microservices from lighter serverless container patterns. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-kubernetes-service) | <https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-kubernetes-service> | Adds architect-level configuration guidance for AKS beyond feature overviews. |

#### Task: Recommend a serverless-based solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview> | Primary serverless compute platform for event-driven and short-lived execution models. |
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-triggers-bindings) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-triggers-bindings> | Useful for matching event sources and outputs to Functions-based designs. |
| [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/overview) | <https://learn.microsoft.com/en-us/azure/container-apps/overview> | Covers serverless containers as an alternative when packaging or runtime needs exceed Functions. |
| [Azure Event Grid](https://learn.microsoft.com/en-us/azure/event-grid/overview) | <https://learn.microsoft.com/en-us/azure/event-grid/overview> | Often pairs directly with serverless architectures as the event-ingress layer. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-functions) | <https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-functions> | Adds scaling, reliability, cost, and hosting-plan guidance for Functions. |

#### Task: Recommend a compute solution for batch processing

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Batch](https://learn.microsoft.com/en-us/azure/batch/batch-technical-overview) | <https://learn.microsoft.com/en-us/azure/batch/batch-technical-overview> | Core service for scheduled, parallel, and high-throughput batch workloads. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/batch-processing) | <https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/batch-processing> | Compares Azure batch-processing technology options by workload characteristics. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/compute/high-performance-computing) | <https://learn.microsoft.com/en-us/azure/architecture/guide/compute/high-performance-computing> | Useful for HPC-style batch requirements that drive compute architecture. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/best-practices/background-jobs) | <https://learn.microsoft.com/en-us/azure/architecture/best-practices/background-jobs> | Helps decide when batch jobs, queued tasks, and scheduled work are the correct pattern. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/big-compute) | <https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/big-compute> | Provides a reference architectural style for large parallel compute jobs. |

### Skill: Design an application architecture

#### Task: Recommend a messaging architecture

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Service Bus Messaging](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview) | <https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview> | Primary Microsoft guidance for reliable queues and publish/subscribe messaging. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about> | Useful when the architecture needs high-throughput event streaming rather than durable commands. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/messaging) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/messaging> | Clarifies when to use Service Bus, Event Grid, Event Hubs, or other messaging patterns. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/patterns/messaging-bridge) | <https://learn.microsoft.com/en-us/azure/architecture/patterns/messaging-bridge> | Supports integration scenarios that bridge heterogeneous messaging systems. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-service-bus) | <https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-service-bus> | Adds service-tier, reliability, private connectivity, and operational guidance for Service Bus. |

#### Task: Recommend an event-driven architecture

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Event Grid](https://learn.microsoft.com/en-us/azure/event-grid/overview) | <https://learn.microsoft.com/en-us/azure/event-grid/overview> | Primary service for reactive, event-first workload design on Azure. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) | <https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven> | Defines the architecture style, tradeoffs, and typical producer/consumer/event-channel roles. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about> | Useful when “event-driven” means high-volume stream ingestion rather than discrete events. |
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview> | Frequently acts as the event consumer/handler in Azure-native event-driven solutions. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-event-grid) | <https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-event-grid> | Adds production-grade design guidance for Event Grid implementations. |

#### Task: Recommend a solution for API integration

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts) | <https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts> | Core service overview for secure publishing, governance, and lifecycle management of APIs. |
| [API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-gateways-overview) | <https://learn.microsoft.com/en-us/azure/api-management/api-management-gateways-overview> | Supports design of managed, self-hosted, and workspace-aware gateway topologies. |
| [API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-policies) | <https://learn.microsoft.com/en-us/azure/api-management/api-management-policies> | Important for transformation, mediation, security, throttling, and backend integration patterns. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-api-management) | <https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-api-management> | Adds architecture guidance for scale, reliability, networking, and operations. |
| [Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/index-web-api) | <https://learn.microsoft.com/en-us/entra/identity-platform/index-web-api> | Useful when API integration also needs modern token-based authentication and downstream API protection. |

#### Task: Recommend a caching solution for applications

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Managed Redis](https://learn.microsoft.com/en-us/azure/redis/overview) | <https://learn.microsoft.com/en-us/azure/redis/overview> | Primary Azure-managed caching platform for low-latency in-memory access patterns. |
| [Azure Managed Redis](https://learn.microsoft.com/en-us/azure/redis/architecture) | <https://learn.microsoft.com/en-us/azure/redis/architecture> | Helps understand topology, persistence, clustering, and design boundaries. |
| [Azure Managed Redis](https://learn.microsoft.com/en-us/azure/reliability/reliability-managed-redis) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-managed-redis> | Grounds high availability and resilience considerations for cache design. |
| [Azure Managed Redis](https://learn.microsoft.com/en-us/azure/redis/redis-modules) | <https://learn.microsoft.com/en-us/azure/redis/redis-modules> | Useful when the cache also supports search, vector, probability, or specialized data-structure needs. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/understand-data-store-models) | <https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/understand-data-store-models> | Adds context for when cache-like key-value stores are preferable to other data-store models. |

#### Task: Recommend an application configuration management solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure App Configuration](https://learn.microsoft.com/en-us/azure/azure-app-configuration/overview) | <https://learn.microsoft.com/en-us/azure/azure-app-configuration/overview> | Core service for centralized app settings, feature flags, and environment-specific configuration. |
| [Azure App Configuration](https://learn.microsoft.com/en-us/azure/azure-app-configuration/howto-best-practices) | <https://learn.microsoft.com/en-us/azure/azure-app-configuration/howto-best-practices> | Helps structure keys, labels, segmentation, and operational configuration patterns. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview) | <https://learn.microsoft.com/en-us/azure/key-vault/general/overview> | Complements App Configuration when secrets and certificates must be separated from plain settings. |
| [Managed identities for Azure resources](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) | <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview> | Supports secretless access from apps to configuration and secret stores. |
| [App Service](https://learn.microsoft.com/en-us/azure/app-service/configure-common) | <https://learn.microsoft.com/en-us/azure/app-service/configure-common> | Useful when the configuration strategy must also account for runtime app settings and deployment slots. |

#### Task: Recommend an automated deployment solution for applications

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Resource Manager](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview> | Provides the Azure deployment and management control plane for IaC-based delivery. |
| [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview> | Core declarative IaC language for Azure application and infrastructure deployment. |
| [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules> | Supports modular, reusable deployment design for larger application estates. |
| [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks> | Useful for lifecycle management and controlled deletion of deployed resources. |
| [Azure Resource Manager](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-modes) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-modes> | Helps choose safe deployment behavior and understand incremental versus complete patterns. |

### Skill: Design migrations

#### Task: Evaluate a migration solution that leverages the Microsoft Cloud Adoption Framework for Azure

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/overview) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/overview> | Establishes the migration methodology and operating model Microsoft expects architects to understand. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/select-cloud-migration-strategy) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/select-cloud-migration-strategy> | Maps workloads to rehost, replatform, refactor, and related migration strategies. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/plan-migration) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/plan-migration> | Covers sequencing, transfer paths, rollback planning, and cutover preparation. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/> | Important because migration success depends on a prepared landing zone, not just migration tools. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview?view=migrate> | Connects CAF planning to the main Microsoft migration execution platform. |

#### Task: Evaluate on-premises servers, data, and applications for migration

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview?view=migrate> | Core hub for discovery, assessment, business case, and migration execution. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/concepts-overview?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/concepts-overview?view=migrate> | Explains how Azure Migrate assessments evaluate readiness, right-sizing, and cost. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/assessment-prerequisites?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/assessment-prerequisites?view=migrate> | Useful because assessment quality depends on data completeness and collection setup. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/review-assessment?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/review-assessment?view=migrate> | Helps interpret VM assessment outputs for server migration decisions. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/review-application-assessment?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/review-application-assessment?view=migrate> | Extends evaluation to application and cross-workload groupings rather than individual machines. |

#### Task: Recommend a solution for migrating workloads to infrastructure as a service and platform as a service

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview?view=migrate> | Core Microsoft platform for both IaaS migration and modernization pathways. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/concepts-assessment-overview?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/concepts-assessment-overview?view=migrate> | Helps evaluate which workloads fit Azure VMs, managed databases, and other PaaS targets. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/review-application-assessment?view=migrate) | <https://learn.microsoft.com/en-us/azure/migrate/review-application-assessment?view=migrate> | Useful for deciding whether application groups should move together and to which Azure target. |
| [App Service](https://learn.microsoft.com/en-us/azure/app-service/overview) | <https://learn.microsoft.com/en-us/azure/app-service/overview> | One of the primary PaaS targets for web applications and APIs during modernization. |
| [Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/availability) | <https://learn.microsoft.com/en-us/azure/virtual-machines/availability> | Useful as the main IaaS landing zone when rehosting is more appropriate than PaaS modernization. |

#### Task: Recommend a solution for migrating databases

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Database Migration Service](https://learn.microsoft.com/en-us/azure/dms/dms-overview) | <https://learn.microsoft.com/en-us/azure/dms/dms-overview> | Core service overview for Microsoft-managed database migration execution. |
| [Azure Database Migration Service](https://learn.microsoft.com/en-us/azure/dms/dms-tools-matrix) | <https://learn.microsoft.com/en-us/azure/dms/dms-tools-matrix> | Useful for matching source/target engines and specialty cases to the right migration tooling. |
| [Azure Database Migration Service](https://learn.microsoft.com/en-us/azure/dms/resource-scenario-status) | <https://learn.microsoft.com/en-us/azure/dms/resource-scenario-status> | Shows supported scenario coverage and current availability state for DMS paths. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/migration-guides/?view=azuresql) | <https://learn.microsoft.com/en-us/azure/azure-sql/migration-guides/?view=azuresql> | Consolidates migration guidance for the Azure SQL family. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/migrate/migration-service/overview-migration-service-postgresql) | <https://learn.microsoft.com/en-us/azure/postgresql/migrate/migration-service/overview-migration-service-postgresql> | Covers PostgreSQL-specific migration service capabilities and supported source patterns. |

#### Task: Recommend a solution for migrating unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-choose-data-transfer-solution) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-choose-data-transfer-solution> | Best Microsoft summary for online and offline unstructured-data movement options. |
| [Azure Data Box](https://learn.microsoft.com/en-us/azure/databox/data-box-overview) | <https://learn.microsoft.com/en-us/azure/databox/data-box-overview> | Useful when transfer volume, link speed, or cost favors offline bulk migration. |
| [Azure Storage Mover](https://learn.microsoft.com/en-us/azure/storage-mover/service-overview) | <https://learn.microsoft.com/en-us/azure/storage-mover/service-overview> | Core service for moving file shares from on-premises or S3 into Azure Storage. |
| [Azure File Sync](https://learn.microsoft.com/en-us/azure/storage/file-sync/file-sync-introduction) | <https://learn.microsoft.com/en-us/azure/storage/file-sync/file-sync-introduction> | Supports staged, hybrid, and cache-based migration approaches for file-server data. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/data-guide/scenarios/data-transfer) | <https://learn.microsoft.com/en-us/azure/architecture/data-guide/scenarios/data-transfer> | Helps compare transfer patterns by size, frequency, latency tolerance, and bandwidth constraints. |

### Skill: Design network solutions

#### Task: Recommend a connectivity solution that connects Azure resources to the internet

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview) | <https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview> | Provides the foundational network construct for public and private Azure connectivity. |
| [Azure DNS](https://learn.microsoft.com/en-us/azure/dns/dns-overview) | <https://learn.microsoft.com/en-us/azure/dns/dns-overview> | Supports internet name resolution and public/private DNS integration design. |
| [Azure NAT Gateway](https://learn.microsoft.com/en-us/azure/nat-gateway/nat-overview) | <https://learn.microsoft.com/en-us/azure/nat-gateway/nat-overview> | Primary outbound internet connectivity service for private subnets. |
| [Azure Front Door and CDN](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview) | <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview> | Useful for global internet ingress, acceleration, and edge-based routing. |
| [Azure Application Gateway](https://learn.microsoft.com/en-us/azure/application-gateway/overview) | <https://learn.microsoft.com/en-us/azure/application-gateway/overview> | Supports regional web ingress, layer-7 routing, and WAF-backed internet exposure. |

#### Task: Recommend a connectivity solution that connects Azure resources to on-premises networks

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [VPN Gateway](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways) | <https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways> | Primary design source for encrypted site-to-site and point-to-site hybrid connectivity. |
| [ExpressRoute](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction) | <https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction> | Primary design source for private, dedicated hybrid connectivity into Azure. |
| [Virtual WAN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about) | <https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about> | Useful for large-scale branch, transit, and centrally managed hybrid connectivity patterns. |
| [Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview) | <https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview> | Grounds VNet-side connectivity design and peering concepts that hybrid paths depend on. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-virtual-wan) | <https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-virtual-wan> | Adds scale, routing, and operational guidance for hub-based hybrid networking. |

#### Task: Recommend a solution to optimize network performance

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Network Watcher](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview) | <https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview> | Core diagnostics platform for observing connectivity, flow, and packet behavior. |
| [Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/concepts-and-best-practices) | <https://learn.microsoft.com/en-us/azure/virtual-network/concepts-and-best-practices> | Helps with address design, peering, routing, subnet planning, and efficient network layouts. |
| [ExpressRoute](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-about-virtual-network-gateways) | <https://learn.microsoft.com/en-us/azure/expressroute/expressroute-about-virtual-network-gateways> | Useful when hybrid performance depends on gateway architecture and throughput characteristics. |
| [Azure Front Door and CDN](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview) | <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview> | Supports latency optimization for globally distributed users and internet-delivered applications. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview> | Helps match the performance objective to the correct Azure routing or load-balancing service. |

#### Task: Recommend a solution to optimize network security

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/overview) | <https://learn.microsoft.com/en-us/azure/firewall/overview> | Core cloud-native firewall service for east-west and north-south traffic control. |
| [Azure DDoS Protection](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview) | <https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview> | Supports volumetric attack mitigation and perimeter resilience. |
| [Private Link](https://learn.microsoft.com/en-us/azure/private-link/private-link-overview) | <https://learn.microsoft.com/en-us/azure/private-link/private-link-overview> | Supports private access to PaaS services and removal of public exposure. |
| [Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) | <https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview> | Provides subnet and NIC-level traffic filtering for layered network security designs. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-firewall) | <https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-firewall> | Adds architecture guidance for Firewall and Firewall Manager in secured hub or hub-spoke patterns. |

#### Task: Recommend a load-balancing and routing solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Load Balancer](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview) | <https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview> | Covers layer-4 balancing for regional TCP/UDP workloads and outbound scenarios. |
| [Azure Application Gateway](https://learn.microsoft.com/en-us/azure/application-gateway/overview) | <https://learn.microsoft.com/en-us/azure/application-gateway/overview> | Supports layer-7 regional routing, path-based rules, and WAF-backed web balancing. |
| [Azure Front Door and CDN](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview) | <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview> | Supports global anycast ingress and edge-based routing for distributed applications. |
| [Traffic Manager](https://learn.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview) | <https://learn.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview> | Useful for DNS-based cross-region routing and failover strategies. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview> | Best cross-service comparison for selecting the correct balancing and routing pattern. |

### Coverage notes

This domain spans the widest set of documentation and is the most architecture-heavy part of AZ-305. Azure Architecture Center is especially important for compute choice, messaging, and load-balancing decisions because those tasks are comparative by nature. Azure Well-Architected service guides are most helpful after service selection, when you need design-quality guidance for AKS, Functions, API Management, Service Bus, Front Door, Virtual WAN, or Azure Firewall. For migrations, Cloud Adoption Framework plus Azure Migrate should be downloaded first, followed by Azure Database Migration Service and the target service docs for App Service, Azure SQL, and Azure Storage.