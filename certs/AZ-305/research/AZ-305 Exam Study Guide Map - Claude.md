# AZ-305 Documentation Map: Designing Microsoft Azure Infrastructure Solutions

Built from the official study guide (skills measured as of April 17, 2026):
<https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305>

How to use this map:

- The **Supporting product documentation** name equals the Microsoft Learn documentation set you would download as a PDF (implied filename = name + `.pdf`).
- The **URL** column is the specific Microsoft Learn page recommended for that task.
- All sources are official Microsoft Learn documentation. Architecture Center, Cloud Adoption Framework, and Well-Architected Framework appear only where design guidance is the best available source.

---

## Domain: Design identity, governance, and monitoring solutions (25–30%)

### Skill: Design solutions for logging and monitoring

#### Task: Recommend a logging solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/) | <https://learn.microsoft.com/en-us/azure/azure-monitor/> | Top-level entry point for metrics, logs, and the full observability platform used to frame a logging design. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs> | Explains the Logs data platform, Log Analytics workspaces, and KQL, which are the core of any logging solution. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview> | Supports workspace design decisions: scope, access, retention, and consolidation across subscriptions. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs> | Covers log ingestion tiers, retention, and cost, which drive a cost-aware logging recommendation. |
| [Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/) | <https://learn.microsoft.com/en-us/azure/sentinel/> | Supports a SIEM-based logging design when security analytics and threat detection are required. |
| [Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/overview-monitoring-health) | <https://learn.microsoft.com/en-us/entra/identity/monitoring-health/overview-monitoring-health> | Covers identity audit and sign-in logs that often must be included in an enterprise logging design. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-logging-monitoring) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-logging-monitoring> | Provides landing-zone guidance for centralized logging across an environment. |

#### Task: Recommend a solution for routing logs

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings) | <https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings> | Diagnostic settings are the primary mechanism for routing platform logs and metrics to destinations. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/activity-log) | <https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/activity-log> | Explains routing subscription-level activity logs to workspaces, storage, or event hubs. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-collection-rule-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-collection-rule-overview> | Data collection rules control how data is collected, transformed, and routed at scale. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-export-logic-app) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-export-logic-app> | Supports exporting log data to external destinations for archive or downstream processing. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction) | <https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction> | Blob storage is a common archive target for long-term, low-cost log retention. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about> | Event Hubs is the standard route for streaming logs to third-party SIEM or analytics tools. |

#### Task: Recommend a monitoring solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/overview> | End-to-end overview for choosing the right monitoring capabilities for a workload. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview> | Covers alert rules, action groups, and signal types for proactive monitoring design. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview> | Application Insights supports application performance monitoring and distributed tracing. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-overview> | VM insights supports infrastructure monitoring for virtual machines and scale sets. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview> | Container insights supports monitoring AKS and container workloads. |
| [Azure Service Health](https://learn.microsoft.com/en-us/azure/service-health/overview) | <https://learn.microsoft.com/en-us/azure/service-health/overview> | Supports monitoring platform health, planned maintenance, and resource health events. |
| [Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction) | <https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction> | Supports security posture and workload protection monitoring as part of a broader solution. |

### Skill: Design authentication and authorization solutions

#### Task: Recommend an authentication solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/) | <https://learn.microsoft.com/en-us/entra/identity/> | Root for identity and access management, the foundation of any authentication design. |
| [Authentication methods](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-methods) | <https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-methods> | Compares MFA, passwordless, FIDO2, and other methods for selecting an authentication approach. |
| [Authentication methods](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-mfa-howitworks) | <https://learn.microsoft.com/en-us/entra/identity/authentication/concept-mfa-howitworks> | Supports recommending multifactor authentication and how it is enforced. |
| [Hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn> | Directly supports choosing PHS, PTA, or federation for hybrid authentication. |
| [Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-sspr-howitworks) | <https://learn.microsoft.com/en-us/entra/identity/authentication/concept-sspr-howitworks> | Self-service password reset is a common requirement in authentication recommendations. |
| [Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/v2-overview) | <https://learn.microsoft.com/en-us/entra/identity-platform/v2-overview> | Supports application authentication using OAuth 2.0 and OpenID Connect. |
| [Microsoft Entra External ID](https://learn.microsoft.com/en-us/entra/external-id/external-identities-overview) | <https://learn.microsoft.com/en-us/entra/external-id/external-identities-overview> | Supports authentication for customers and partners (B2B and B2C scenarios). |

#### Task: Recommend an identity management solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/fundamentals/whatis) | <https://learn.microsoft.com/en-us/entra/fundamentals/whatis> | Establishes core identity concepts and tenant design for an identity management recommendation. |
| [Hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity> | Supports designing synchronization between on-premises AD and Microsoft Entra ID. |
| [Hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync> | Helps choose between Entra Connect Sync and Cloud Sync for provisioning. |
| [Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/users/directory-overview-user-model) | <https://learn.microsoft.com/en-us/entra/identity/users/directory-overview-user-model> | Supports user and group management design within a tenant. |
| [Microsoft Entra Domain Services](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview) | <https://learn.microsoft.com/en-us/entra/identity/domain-services/overview> | Supports managed domain services for legacy apps needing LDAP, Kerberos, or NTLM. |
| [Microsoft Entra External ID](https://learn.microsoft.com/en-us/entra/external-id/) | <https://learn.microsoft.com/en-us/entra/external-id/> | Supports managing external user identities as part of an identity solution. |

#### Task: Recommend a solution for authorizing access to Azure resources

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure RBAC](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview) | <https://learn.microsoft.com/en-us/azure/role-based-access-control/overview> | Core model for authorizing access to Azure resources through role assignments and scope. |
| [Azure RBAC](https://learn.microsoft.com/en-us/azure/role-based-access-control/best-practices) | <https://learn.microsoft.com/en-us/azure/role-based-access-control/best-practices> | Provides least-privilege and scope design guidance for resource authorization. |
| [Azure RBAC](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles) | <https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles> | Supports recommending custom roles when built-in roles do not fit requirements. |
| [Managed identities for Azure resources](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) | <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview> | Supports authorizing application and service access without managing credentials. |
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure) | <https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure> | Privileged Identity Management supports just-in-time, time-bound resource access. |
| [Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview) | <https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview> | Conditional Access adds signal-based authorization controls on top of RBAC. |

#### Task: Recommend a solution for authorizing access to on-premises resources

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy) | <https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy> | Application Proxy publishes on-premises web apps with Entra ID authentication. |
| [Global Secure Access](https://learn.microsoft.com/en-us/entra/global-secure-access/overview-what-is-global-secure-access) | <https://learn.microsoft.com/en-us/entra/global-secure-access/overview-what-is-global-secure-access> | Supports identity-centric private access (ZTNA) to on-premises resources. |
| [Hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-pta) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-pta> | Pass-through authentication supports validating credentials against on-premises AD. |
| [Microsoft Entra Domain Services](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview) | <https://learn.microsoft.com/en-us/entra/identity/domain-services/overview> | Provides Kerberos and LDAP authorization for legacy on-premises-style workloads in Azure. |
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-applications-prepare) | <https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-applications-prepare> | Supports governing access to on-premises and legacy applications. |

#### Task: Recommend a solution to manage secrets, certificates, and keys

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview) | <https://learn.microsoft.com/en-us/azure/key-vault/general/overview> | Central service for managing secrets, keys, and certificates in Azure. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/security-features) | <https://learn.microsoft.com/en-us/azure/key-vault/general/security-features> | Covers access models, RBAC vs access policies, and network controls for vault design. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/overview) | <https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/overview> | Managed HSM supports FIPS 140 single-tenant key requirements. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/certificates/about-certificates) | <https://learn.microsoft.com/en-us/azure/key-vault/certificates/about-certificates> | Supports certificate lifecycle and issuance design. |
| [Managed identities for Azure resources](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) | <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview> | Managed identities are the recommended way for apps to access Key Vault without stored credentials. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/customer-managed-keys-overview) | <https://learn.microsoft.com/en-us/azure/storage/common/customer-managed-keys-overview> | Supports customer-managed key encryption scenarios using Key Vault. |

### Skill: Design governance

#### Task: Recommend a structure for management groups, subscriptions, and resource groups, and a strategy for resource tagging

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview) | <https://learn.microsoft.com/en-us/azure/governance/management-groups/overview> | Defines the management group hierarchy used to organize subscriptions at scale. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org> | Provides the recommended resource organization model for subscriptions and groups. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/scale-subscriptions) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/scale-subscriptions> | Supports subscription scaling and segmentation decisions. |
| [Azure Resource Manager](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview> | Explains resource groups, scopes, and the resource management model. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging> | Provides a tagging strategy for cost, ownership, and governance metadata. |
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/tutorials/govern-tags) | <https://learn.microsoft.com/en-us/azure/governance/policy/tutorials/govern-tags> | Supports enforcing tag governance through policy. |

#### Task: Recommend a solution for managing compliance

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview) | <https://learn.microsoft.com/en-us/azure/governance/policy/overview> | Core service for enforcing organizational and regulatory compliance rules. |
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/initiative-definition-structure) | <https://learn.microsoft.com/en-us/azure/governance/policy/concepts/initiative-definition-structure> | Initiatives group policies into compliance standards for assignment. |
| [Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard) | <https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard> | Provides regulatory compliance assessment against standards like ISO and PCI. |
| [Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/secure-score-security-controls) | <https://learn.microsoft.com/en-us/azure/defender-for-cloud/secure-score-security-controls> | Secure score supports measuring and improving compliance posture. |
| [Microsoft Purview](https://learn.microsoft.com/en-us/purview/purview) | <https://learn.microsoft.com/en-us/purview/purview> | Supports data compliance, classification, and regulatory requirements for data estates. |
| [Azure Resource Graph](https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview) | <https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview> | Supports querying resources at scale to verify compliance state. |

#### Task: Recommend a solution for identity governance

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview) | <https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview> | Top-level overview of access lifecycle, entitlements, and reviews. |
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-overview) | <https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-overview> | Entitlement management supports access packages and request workflows. |
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/access-reviews-overview) | <https://learn.microsoft.com/en-us/entra/id-governance/access-reviews-overview> | Access reviews support periodic recertification of access. |
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure) | <https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure> | PIM supports just-in-time elevation and approval for privileged roles. |
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/what-are-lifecycle-workflows) | <https://learn.microsoft.com/en-us/entra/id-governance/what-are-lifecycle-workflows> | Lifecycle workflows automate joiner, mover, and leaver processes. |
| [Microsoft Entra Permissions Management](https://learn.microsoft.com/en-us/entra/permissions-management/overview) | <https://learn.microsoft.com/en-us/entra/permissions-management/overview> | Supports discovering and right-sizing permissions across multicloud environments. |

### Coverage notes: identity, governance, and monitoring

- Logging and monitoring documentation is concentrated in **Azure Monitor**, which spans logs, metrics, alerts, diagnostic settings, and the workload-specific insights. Download this set first; it appears across nearly every monitoring task.
- Authentication and identity content is fragmented across several **Microsoft Entra** sub-collections: **Microsoft Entra ID**, **Authentication methods**, **Conditional Access**, **Hybrid identity**, and **Microsoft identity platform**. Treat these as separate PDFs.
- Governance structure relies more on **Cloud Adoption Framework** design guidance than on a single product root, especially for management group hierarchy, subscription scaling, and tagging strategy.
- **Microsoft Entra ID Governance** covers entitlement management, access reviews, PIM, and lifecycle workflows in one set and is worth downloading whole.

---

## Domain: Design data storage solutions (20–25%)

### Skill: Design data storage solutions for relational data

#### Task: Recommend a solution for storing relational data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview> | Compares SQL Database, Managed Instance, and SQL on VM to choose a relational platform. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview> | Overview of Azure SQL Database as the default PaaS relational option. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview> | Managed Instance supports near-full SQL Server compatibility for migrations. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/service-overview) | <https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/service-overview> | Supports open-source relational workloads on PostgreSQL. |
| [Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview) | <https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview> | Supports open-source relational workloads on MySQL. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-store-decision-tree) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-store-decision-tree> | Decision tree for matching data characteristics to the right store. |

#### Task: Recommend a database service tier and compute tier

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-sql-database-vcore) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-sql-database-vcore> | Explains the vCore model and service tiers for sizing SQL Database. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-dtu) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-dtu> | Covers the DTU purchasing model as an alternative tier choice. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/serverless-tier-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/serverless-tier-overview> | Serverless compute supports variable and intermittent workloads. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/hyperscale-architecture) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/hyperscale-architecture> | Hyperscale supports very large databases with fast scaling. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compute-storage) | <https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compute-storage> | Supports compute and storage tier selection for PostgreSQL. |

#### Task: Recommend a solution for database scalability

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/scale-resources) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/scale-resources> | Covers scaling up and down within service tiers. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-pool-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-pool-overview> | Elastic pools support scaling many databases with shared resources. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/read-scale-out) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/read-scale-out> | Read scale-out supports offloading read workloads to replicas. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-scale-introduction) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-scale-introduction> | Sharding patterns support horizontal scale for large datasets. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/partitioning-overview) | <https://learn.microsoft.com/en-us/azure/cosmos-db/partitioning-overview> | Useful when a globally scalable multi-model store is the better fit than relational scaling. |

#### Task: Recommend a solution for data protection

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/transparent-data-encryption-tde-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/transparent-data-encryption-tde-overview> | TDE provides encryption at rest for relational data. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/always-encrypted-landing) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/always-encrypted-landing> | Always Encrypted protects sensitive columns from high-privilege users. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/dynamic-data-masking-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/dynamic-data-masking-overview> | Dynamic data masking limits exposure of sensitive data. |
| [Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-databases-introduction) | <https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-databases-introduction> | Defender for Databases adds threat protection for data stores. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview) | <https://learn.microsoft.com/en-us/azure/key-vault/general/overview> | Supports customer-managed keys for database encryption. |
| [Microsoft Purview](https://learn.microsoft.com/en-us/purview/purview) | <https://learn.microsoft.com/en-us/purview/purview> | Supports classification and sensitivity labeling of stored data. |

### Skill: Design data storage solutions for semi-structured and unstructured data

#### Task: Recommend a solution for storing semi-structured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/introduction) | <https://learn.microsoft.com/en-us/azure/cosmos-db/introduction> | Primary store for JSON and other semi-structured data with multiple APIs. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/choose-api) | <https://learn.microsoft.com/en-us/azure/cosmos-db/choose-api> | Helps select the right Cosmos DB API (NoSQL, MongoDB, Cassandra, Gremlin, Table). |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/tables/table-storage-overview) | <https://learn.microsoft.com/en-us/azure/storage/tables/table-storage-overview> | Table storage supports low-cost key-value and semi-structured data. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/service-overview) | <https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/service-overview> | Supports JSONB and semi-structured data within a relational engine. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-store-decision-tree) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-store-decision-tree> | Supports matching semi-structured workloads to the right store. |

#### Task: Recommend a solution for storing unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction) | <https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction> | Blob storage is the primary store for unstructured objects and files. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-introduction) | <https://learn.microsoft.com/en-us/azure/storage/files/storage-files-introduction> | Azure Files supports SMB and NFS file share scenarios. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction) | <https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction> | Data Lake Storage Gen2 supports big-data analytics on unstructured data. |
| [Azure NetApp Files](https://learn.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-introduction-to-azure-netapp-files) | <https://learn.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-introduction-to-azure-netapp-files> | Supports high-performance enterprise file workloads. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview> | Access tiers support cost optimization for unstructured data. |

#### Task: Recommend a data storage solution to balance features, performance, and costs

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview> | Hot, cool, cold, and archive tiers balance access frequency against cost. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/lifecycle-management-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/lifecycle-management-overview> | Lifecycle policies automate tiering and deletion to control cost. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy> | Redundancy options trade durability and availability against cost. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-sql-database-vcore) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-sql-database-vcore> | Supports balancing relational performance tiers against cost. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/) | <https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/> | Provides cost optimization principles for storage design tradeoffs. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-store-decision-tree) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-store-decision-tree> | Supports balancing features against workload requirements. |

#### Task: Recommend a data solution for protection and durability

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy> | LRS, ZRS, GRS, and GZRS define durability and regional protection. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/soft-delete-blob-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/soft-delete-blob-overview> | Soft delete protects against accidental data loss. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview> | Immutable storage supports WORM and compliance retention. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-disaster-recovery-guidance) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-disaster-recovery-guidance> | Covers failover and recovery for geo-redundant storage. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/blob-backup-overview) | <https://learn.microsoft.com/en-us/azure/backup/blob-backup-overview> | Operational and vaulted backup for blobs adds point-in-time protection. |

### Skill: Design data integration

#### Task: Recommend a solution for data integration

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Data Factory](https://learn.microsoft.com/en-us/azure/data-factory/introduction) | <https://learn.microsoft.com/en-us/azure/data-factory/introduction> | Primary service for ETL and ELT data integration pipelines. |
| [Azure Synapse Analytics](https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is) | <https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is> | Combines integration, warehousing, and analytics in one workspace. |
| [Azure Data Factory](https://learn.microsoft.com/en-us/azure/data-factory/concepts-integration-runtime) | <https://learn.microsoft.com/en-us/azure/data-factory/concepts-integration-runtime> | Integration runtimes support cloud, hybrid, and self-hosted integration. |
| [Azure Stream Analytics](https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction) | <https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction> | Supports real-time streaming data integration. |
| [Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/data-factory/data-factory-overview) | <https://learn.microsoft.com/en-us/fabric/data-factory/data-factory-overview> | Fabric Data Factory supports unified SaaS-based data integration. |

#### Task: Recommend a solution for data analysis

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Synapse Analytics](https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is) | <https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is> | Supports enterprise data warehousing and large-scale analytics. |
| [Azure Databricks](https://learn.microsoft.com/en-us/azure/databricks/introduction/) | <https://learn.microsoft.com/en-us/azure/databricks/introduction/> | Supports Spark-based analytics, data engineering, and machine learning. |
| [Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/fundamentals/microsoft-fabric-overview) | <https://learn.microsoft.com/en-us/fabric/fundamentals/microsoft-fabric-overview> | Unified analytics platform spanning warehousing, lakehouse, and BI. |
| [Azure Data Explorer](https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview) | <https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview> | Supports high-volume log and telemetry analytics with KQL. |
| [Azure Stream Analytics](https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction) | <https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction> | Supports real-time analytical processing on streaming data. |
| [Azure Synapse Analytics](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/on-demand-workspace-overview) | <https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/on-demand-workspace-overview> | Serverless SQL supports ad hoc analysis over data lake files. |

### Coverage notes: data storage

- **Azure SQL** is one documentation set covering SQL Database, Managed Instance, and SQL on VM. It supports relational storage, tiers, scalability, and protection tasks, so download it once and reuse it.
- **Azure Storage** is a hub with separate sub-collections (Blob, Files, Queues, Tables, plus common topics like redundancy). Several tasks reference different sub-collections under the same set name.
- Data analysis is fragmented across **Azure Synapse Analytics**, **Azure Databricks**, **Microsoft Fabric**, and **Azure Data Explorer**. There is no single root; choose based on workload type.
- For store-selection tasks, the **Azure Architecture Center** data store decision tree is often the best grounding source rather than a single product root.

---

## Domain: Design business continuity solutions (15–20%)

### Skill: Design solutions for backup and disaster recovery

#### Task: Recommend a recovery solution for Azure and hybrid workloads that meets recovery objectives

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Site Recovery](https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-overview) | <https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-overview> | Primary DR service for replicating and failing over Azure and on-premises workloads. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-overview) | <https://learn.microsoft.com/en-us/azure/backup/backup-overview> | Supports backup-based recovery to meet RPO requirements. |
| [Azure reliability](https://learn.microsoft.com/en-us/azure/reliability/concept-recovery-reliability) | <https://learn.microsoft.com/en-us/azure/reliability/concept-recovery-reliability> | Frames RPO, RTO, and recovery strategy choices. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/framework/resiliency/business-metrics) | <https://learn.microsoft.com/en-us/azure/architecture/framework/resiliency/business-metrics> | Helps translate business continuity requirements into RPO and RTO targets. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/protect) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/protect> | Provides a structured protect-and-recover model across an estate. |

#### Task: Recommend a backup and recovery solution for compute

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-azure-vms-introduction) | <https://learn.microsoft.com/en-us/azure/backup/backup-azure-vms-introduction> | Covers VM backup, policies, and restore options. |
| [Azure Site Recovery](https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-architecture) | <https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-architecture> | Supports region-to-region VM disaster recovery. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-azure-arm-vms-prepare) | <https://learn.microsoft.com/en-us/azure/backup/backup-azure-arm-vms-prepare> | Supports configuring backup for Resource Manager VMs. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-azure-recovery-services-vault-overview) | <https://learn.microsoft.com/en-us/azure/backup/backup-azure-recovery-services-vault-overview> | Recovery Services vault is the container for compute backups. |
| [Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/backup-recovery) | <https://learn.microsoft.com/en-us/azure/virtual-machines/backup-recovery> | Summarizes backup and recovery options for VMs. |

#### Task: Recommend a backup and recovery solution for databases

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview> | Automated backups and point-in-time restore for SQL Database. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/long-term-retention-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/long-term-retention-overview> | Long-term retention supports compliance-driven backup requirements. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-azure-sql-database) | <https://learn.microsoft.com/en-us/azure/backup/backup-azure-sql-database> | Supports backing up SQL Server running in Azure VMs. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/online-backup-and-restore) | <https://learn.microsoft.com/en-us/azure/cosmos-db/online-backup-and-restore> | Covers continuous and periodic backup for Cosmos DB. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-backup-restore) | <https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-backup-restore> | Backup and restore design for PostgreSQL. |

#### Task: Recommend a backup and recovery solution for unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/blob-backup-overview) | <https://learn.microsoft.com/en-us/azure/backup/blob-backup-overview> | Operational and vaulted backup for blob data. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/azure-file-share-backup-overview) | <https://learn.microsoft.com/en-us/azure/backup/azure-file-share-backup-overview> | Supports backup and restore of Azure file shares. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/soft-delete-blob-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/soft-delete-blob-overview> | Soft delete supports recovery from accidental deletion. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-disaster-recovery-guidance) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-disaster-recovery-guidance> | Covers cross-region recovery for geo-redundant storage. |
| [Azure NetApp Files](https://learn.microsoft.com/en-us/azure/azure-netapp-files/snapshots-introduction) | <https://learn.microsoft.com/en-us/azure/azure-netapp-files/snapshots-introduction> | Snapshot-based recovery for enterprise file workloads. |

### Skill: Design for high availability

#### Task: Recommend a high availability solution for compute

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure reliability](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview) | <https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview> | Availability zones are the core building block for HA compute. |
| [Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/availability) | <https://learn.microsoft.com/en-us/azure/virtual-machines/availability> | Compares availability sets, zones, and SLAs for VM HA. |
| [Azure Virtual Machine Scale Sets](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview) | <https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview> | Scale sets support redundant, autoscaling compute across zones. |
| [Azure reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machines) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machines> | Service-specific reliability guidance for VMs. |
| [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/availability-zones) | <https://learn.microsoft.com/en-us/azure/aks/availability-zones> | Supports zone-redundant container HA on AKS. |
| [Azure Load Balancer](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview) | <https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview> | Distributes traffic across HA compute instances. |

#### Task: Recommend a high availability solution for relational data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/high-availability-sla-local-zone-redundancy) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/high-availability-sla-local-zone-redundancy> | Covers built-in and zone-redundant HA for SQL Database. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/active-geo-replication-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/active-geo-replication-overview> | Active geo-replication supports readable secondary replicas. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/failover-group-sql-db) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/failover-group-sql-db> | Failover groups support automatic regional failover. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-high-availability) | <https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-high-availability> | Zone-redundant HA design for PostgreSQL. |
| [Azure reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-sql-database) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-sql-database> | Reliability guide consolidating zone and region resiliency for SQL Database. |

#### Task: Recommend a high availability solution for semi-structured and unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy> | ZRS, GRS, and GZRS provide availability across zones and regions. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/high-availability) | <https://learn.microsoft.com/en-us/azure/cosmos-db/high-availability> | Multi-region writes and replicas support globally available data. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/distribute-data-globally) | <https://learn.microsoft.com/en-us/azure/cosmos-db/distribute-data-globally> | Global distribution supports regional resiliency for semi-structured data. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-disaster-recovery-guidance) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-disaster-recovery-guidance> | Account failover supports availability during a regional outage. |
| [Azure NetApp Files](https://learn.microsoft.com/en-us/azure/azure-netapp-files/cross-region-replication-introduction) | <https://learn.microsoft.com/en-us/azure/azure-netapp-files/cross-region-replication-introduction> | Cross-region replication supports HA for enterprise file data. |

### Coverage notes: business continuity

- **Azure Backup** and **Azure Site Recovery** are the two anchor sets for this domain. Download both first; one handles backup and RPO, the other handles replication and failover.
- High availability for data reuses the **Azure SQL**, **Azure Cosmos DB**, and **Azure Storage** sets already pulled for the data domain.
- The **Azure reliability** set now consolidates availability zone concepts and per-service reliability guides. It is the best single grounding source for HA design and is worth downloading whole.
- For mapping business requirements to RPO and RTO, the **Azure Architecture Center** resiliency guidance is a better source than any product root.

---

## Domain: Design infrastructure solutions (30–35%)

### Skill: Design compute solutions

#### Task: Specify components of a compute solution based on workload requirements

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree> | Decision tree for selecting the right compute service for a workload. |
| [Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/overview) | <https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/overview> | VM size families map workload characteristics to compute, memory, and IO. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/) | <https://learn.microsoft.com/en-us/azure/well-architected/> | Provides the pillars used to evaluate compute design tradeoffs. |
| [App Service](https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans) | <https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans> | Hosting plans support sizing PaaS web compute. |
| [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/what-is-aks) | <https://learn.microsoft.com/en-us/azure/aks/what-is-aks> | Supports specifying orchestrated container compute. |

#### Task: Recommend a virtual machine-based solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/overview) | <https://learn.microsoft.com/en-us/azure/virtual-machines/overview> | Core IaaS compute service for VM-based designs. |
| [Azure Virtual Machine Scale Sets](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview) | <https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview> | Supports autoscaling and redundant VM fleets. |
| [Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/overview) | <https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/overview> | Helps select VM series for the workload. |
| [Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview) | <https://learn.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview> | Managed disk types support storage performance design. |
| [Azure reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machines) | <https://learn.microsoft.com/en-us/azure/reliability/reliability-virtual-machines> | Supports resiliency planning for VM solutions. |

#### Task: Recommend a container-based solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/what-is-aks) | <https://learn.microsoft.com/en-us/azure/aks/what-is-aks> | Managed Kubernetes for complex orchestrated container workloads. |
| [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/overview) | <https://learn.microsoft.com/en-us/azure/container-apps/overview> | Serverless containers with built-in scaling for microservices. |
| [Container Instances](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-overview) | <https://learn.microsoft.com/en-us/azure/container-instances/container-instances-overview> | Supports simple, fast single-container scenarios. |
| [Container Registry](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-intro) | <https://learn.microsoft.com/en-us/azure/container-registry/container-registry-intro> | Supports storing and managing container images. |
| [App Service](https://learn.microsoft.com/en-us/azure/app-service/quickstart-custom-container) | <https://learn.microsoft.com/en-us/azure/app-service/quickstart-custom-container> | Supports running custom containers in a PaaS web model. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/choose-azure-container-service) | <https://learn.microsoft.com/en-us/azure/architecture/guide/choose-azure-container-service> | Helps choose between container services for the workload. |

#### Task: Recommend a serverless-based solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview> | Event-driven serverless compute for code execution. |
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-scale) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-scale> | Hosting plans determine scaling, cold start, and cost behavior. |
| [Azure Logic Apps](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview) | <https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview> | Serverless workflow orchestration with connectors. |
| [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/overview) | <https://learn.microsoft.com/en-us/azure/container-apps/overview> | Serverless container option for event-driven and scale-to-zero workloads. |
| [Azure Event Grid](https://learn.microsoft.com/en-us/azure/event-grid/overview) | <https://learn.microsoft.com/en-us/azure/event-grid/overview> | Provides event routing that triggers serverless compute. |

#### Task: Recommend a compute solution for batch processing

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Batch](https://learn.microsoft.com/en-us/azure/batch/batch-technical-overview) | <https://learn.microsoft.com/en-us/azure/batch/batch-technical-overview> | Managed service for large-scale parallel and HPC batch jobs. |
| [Azure Virtual Machine Scale Sets](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview) | <https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview> | Supports scalable VM-based batch compute. |
| [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/what-is-aks) | <https://learn.microsoft.com/en-us/azure/aks/what-is-aks> | Supports containerized batch and job workloads. |
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview> | Supports lightweight, event-triggered batch tasks. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/solution-ideas/articles/big-compute-with-azure-batch) | <https://learn.microsoft.com/en-us/azure/architecture/solution-ideas/articles/big-compute-with-azure-batch> | Reference architecture for big-compute batch processing. |

### Skill: Design an application architecture

#### Task: Recommend a messaging architecture

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Service Bus](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview) | <https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview> | Enterprise messaging with queues, topics, and ordered delivery. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction) | <https://learn.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction> | Queue storage supports simple, high-volume message queuing. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about> | Supports high-throughput data and event streaming. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/messaging) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/messaging> | Compares messaging services to match the right one to the scenario. |
| [Azure Service Bus](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-queues-topics-subscriptions) | <https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-queues-topics-subscriptions> | Supports publish-subscribe and competing-consumer patterns. |

#### Task: Recommend an event-driven architecture

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Event Grid](https://learn.microsoft.com/en-us/azure/event-grid/overview) | <https://learn.microsoft.com/en-us/azure/event-grid/overview> | Reactive event routing for discrete event-driven designs. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about> | Supports event streaming and ingestion pipelines. |
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview> | Common compute target for processing events. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) | <https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven> | Defines the event-driven architecture style and tradeoffs. |
| [Azure Stream Analytics](https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction) | <https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction> | Supports real-time event processing and analytics. |

#### Task: Recommend a solution for API integration

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts) | <https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts> | Central gateway for publishing, securing, and governing APIs. |
| [API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-policies) | <https://learn.microsoft.com/en-us/azure/api-management/api-management-policies> | Policies support transformation, throttling, and security at the gateway. |
| [API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-gateways-overview) | <https://learn.microsoft.com/en-us/azure/api-management/api-management-gateways-overview> | Compares gateway and deployment models including self-hosted. |
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview> | Supports building lightweight API backends. |
| [App Service](https://learn.microsoft.com/en-us/azure/app-service/overview) | <https://learn.microsoft.com/en-us/azure/app-service/overview> | Hosts web APIs behind the gateway. |

#### Task: Recommend a caching solution for applications

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Cache for Redis](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview) | <https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview> | Managed in-memory cache for application data and session state. |
| [Azure Cache for Redis](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-best-practices-development) | <https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-best-practices-development> | Guidance for caching patterns and tier selection. |
| [Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-caching) | <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-caching> | Edge caching reduces latency for global content. |
| [Content Delivery Network](https://learn.microsoft.com/en-us/azure/cdn/cdn-overview) | <https://learn.microsoft.com/en-us/azure/cdn/cdn-overview> | CDN caches static content close to users. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/best-practices/caching) | <https://learn.microsoft.com/en-us/azure/architecture/best-practices/caching> | Caching patterns and tradeoffs for application design. |

#### Task: Recommend an application configuration management solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure App Configuration](https://learn.microsoft.com/en-us/azure/azure-app-configuration/overview) | <https://learn.microsoft.com/en-us/azure/azure-app-configuration/overview> | Centralized store for application settings and feature flags. |
| [Azure App Configuration](https://learn.microsoft.com/en-us/azure/azure-app-configuration/concept-feature-management) | <https://learn.microsoft.com/en-us/azure/azure-app-configuration/concept-feature-management> | Feature management supports controlled rollout of capabilities. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview) | <https://learn.microsoft.com/en-us/azure/key-vault/general/overview> | Stores secrets referenced by application configuration. |
| [Managed identities for Azure resources](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) | <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview> | Allows apps to read configuration and secrets without stored credentials. |
| [Azure App Configuration](https://learn.microsoft.com/en-us/azure/azure-app-configuration/howto-best-practices) | <https://learn.microsoft.com/en-us/azure/azure-app-configuration/howto-best-practices> | Best practices for structuring configuration across environments. |

#### Task: Recommend an automated deployment solution for applications

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Pipelines](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines) | <https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines> | CI/CD pipelines for automated build and release. |
| [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview> | Infrastructure as code for repeatable Azure deployments. |
| [ARM templates](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview> | Declarative templates for deploying Azure resources. |
| [GitHub Actions for Azure](https://learn.microsoft.com/en-us/azure/developer/github/github-actions) | <https://learn.microsoft.com/en-us/azure/developer/github/github-actions> | Supports GitHub-based automated deployment to Azure. |
| [App Service](https://learn.microsoft.com/en-us/azure/app-service/deploy-best-practices) | <https://learn.microsoft.com/en-us/azure/app-service/deploy-best-practices> | Deployment slots and practices for safe app releases. |

### Skill: Design migrations

#### Task: Evaluate a migration solution that leverages the Microsoft Cloud Adoption Framework for Azure

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/overview) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/overview> | Framework overview that structures the full migration approach. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/> | The Migrate methodology covering assess, migrate, optimize, and secure. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/> | Planning guidance for digital estate and migration backlog. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/> | Landing zone readiness as a prerequisite for migration. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview) | <https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview> | The tooling that implements the CAF migration methodology. |

#### Task: Evaluate on-premises servers, data, and applications for migration

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview) | <https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview> | Central hub for discovery, assessment, and migration. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/concepts-assessment-calculation) | <https://learn.microsoft.com/en-us/azure/migrate/concepts-assessment-calculation> | Explains how readiness, sizing, and cost assessments are calculated. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/concepts-dependency-visualization) | <https://learn.microsoft.com/en-us/azure/migrate/concepts-dependency-visualization> | Dependency analysis supports grouping servers for migration. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/digital-estate/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/digital-estate/> | Methods for inventorying and rationalizing the digital estate. |
| [Azure Database Migration Service](https://learn.microsoft.com/en-us/azure/dms/dms-overview) | <https://learn.microsoft.com/en-us/azure/dms/dms-overview> | Supports assessing and migrating database workloads. |

#### Task: Recommend a solution for migrating workloads to IaaS and PaaS

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview) | <https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview> | Supports server migration to Azure IaaS. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/tutorial-migrate-vmware) | <https://learn.microsoft.com/en-us/azure/migrate/tutorial-migrate-vmware> | Example flow for lift-and-shift VM migration. |
| [App Service](https://learn.microsoft.com/en-us/azure/app-service/overview) | <https://learn.microsoft.com/en-us/azure/app-service/overview> | Target PaaS platform for migrating web applications. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/azure-migration-guide/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/azure-migration-guide/> | Structured guide for choosing rehost, refactor, or rearchitect. |
| [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/what-is-aks) | <https://learn.microsoft.com/en-us/azure/aks/what-is-aks> | Target for containerizing and modernizing workloads. |

#### Task: Recommend a solution for migrating databases

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Database Migration Service](https://learn.microsoft.com/en-us/azure/dms/dms-overview) | <https://learn.microsoft.com/en-us/azure/dms/dms-overview> | Managed service for online and offline database migration. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/migration-guides/managed-instance/sql-server-to-managed-instance-guide) | <https://learn.microsoft.com/en-us/azure/azure-sql/migration-guides/managed-instance/sql-server-to-managed-instance-guide> | Guidance for migrating SQL Server to Managed Instance. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview) | <https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview> | Coordinates database assessment alongside server migration. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/migrate/migration-service/overview-migration-service-postgresql) | <https://learn.microsoft.com/en-us/azure/postgresql/migrate/migration-service/overview-migration-service-postgresql> | Migration service for PostgreSQL targets. |
| [Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/migrate/migration-service/overview-migration-service-mysql) | <https://learn.microsoft.com/en-us/azure/mysql/migrate/migration-service/overview-migration-service-mysql> | Migration service for MySQL targets. |

#### Task: Recommend a solution for migrating unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Data Box](https://learn.microsoft.com/en-us/azure/databox/data-box-overview) | <https://learn.microsoft.com/en-us/azure/databox/data-box-overview> | Offline bulk transfer for large unstructured datasets. |
| [Azure Storage Mover](https://learn.microsoft.com/en-us/azure/storage-mover/service-overview) | <https://learn.microsoft.com/en-us/azure/storage-mover/service-overview> | Managed migration of files to Azure Storage. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10> | AzCopy supports online copy of blobs and files. |
| [Azure File Sync](https://learn.microsoft.com/en-us/azure/storage/file-sync/file-sync-introduction) | <https://learn.microsoft.com/en-us/azure/storage/file-sync/file-sync-introduction> | Supports tiering and migrating on-premises file servers to Azure Files. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview) | <https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview> | Coordinates data migration within an overall migration plan. |

### Skill: Design network solutions

#### Task: Recommend a connectivity solution that connects Azure resources to the internet

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview) | <https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview> | Foundation for inbound and outbound network connectivity. |
| [NAT Gateway](https://learn.microsoft.com/en-us/azure/nat-gateway/nat-overview) | <https://learn.microsoft.com/en-us/azure/nat-gateway/nat-overview> | Provides scalable, secure outbound internet connectivity. |
| [Azure Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses) | <https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses> | Public IP design for internet-facing resources. |
| [Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview) | <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview> | Global entry point for internet-facing web workloads. |
| [Azure Private Link](https://learn.microsoft.com/en-us/azure/private-link/private-link-overview) | <https://learn.microsoft.com/en-us/azure/private-link/private-link-overview> | Supports private access to PaaS services instead of public endpoints. |

#### Task: Recommend a connectivity solution that connects Azure resources to on-premises networks

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [VPN Gateway](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways) | <https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways> | Site-to-site and point-to-site VPN for hybrid connectivity. |
| [Azure ExpressRoute](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction) | <https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction> | Private, high-bandwidth dedicated connectivity to Azure. |
| [Virtual WAN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about) | <https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about> | Hub-and-spoke connectivity at scale across sites and regions. |
| [Azure Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview) | <https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview> | Peering connects VNets within the hybrid topology. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-other-providers) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-other-providers> | Landing-zone connectivity design guidance. |

#### Task: Recommend a solution to optimize network performance

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview) | <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview> | Global acceleration and edge optimization for web traffic. |
| [Content Delivery Network](https://learn.microsoft.com/en-us/azure/cdn/cdn-overview) | <https://learn.microsoft.com/en-us/azure/cdn/cdn-overview> | Caches content at the edge to reduce latency. |
| [Azure ExpressRoute](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction) | <https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction> | Predictable low-latency connectivity for performance-sensitive workloads. |
| [Azure Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/accelerated-networking-overview) | <https://learn.microsoft.com/en-us/azure/virtual-network/accelerated-networking-overview> | Accelerated networking reduces latency and improves throughput on VMs. |
| [Network Watcher](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-monitoring-overview) | <https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-monitoring-overview> | Supports diagnosing and optimizing network performance. |

#### Task: Recommend a solution to optimize network security

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/overview) | <https://learn.microsoft.com/en-us/azure/firewall/overview> | Managed, stateful firewall for centralized network protection. |
| [Azure Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) | <https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview> | Network security groups control segment-level traffic. |
| [Web Application Firewall](https://learn.microsoft.com/en-us/azure/web-application-firewall/overview) | <https://learn.microsoft.com/en-us/azure/web-application-firewall/overview> | Protects web apps from common exploits at the edge or gateway. |
| [Azure DDoS Protection](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview) | <https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview> | Protects public endpoints from volumetric attacks. |
| [Azure Private Link](https://learn.microsoft.com/en-us/azure/private-link/private-link-overview) | <https://learn.microsoft.com/en-us/azure/private-link/private-link-overview> | Removes public exposure by keeping traffic on the Microsoft backbone. |
| [Azure Bastion](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) | <https://learn.microsoft.com/en-us/azure/bastion/bastion-overview> | Secure RDP and SSH access without public IPs on VMs. |

#### Task: Recommend a load-balancing and routing solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview> | Decision guide for selecting the right load-balancing service. |
| [Azure Load Balancer](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview) | <https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview> | Layer 4 regional load balancing for TCP and UDP. |
| [Application Gateway](https://learn.microsoft.com/en-us/azure/application-gateway/overview) | <https://learn.microsoft.com/en-us/azure/application-gateway/overview> | Layer 7 load balancing with routing and WAF for web traffic. |
| [Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview) | <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview> | Global Layer 7 load balancing and routing. |
| [Traffic Manager](https://learn.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview) | <https://learn.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview> | DNS-based global routing across regions. |

### Coverage notes: infrastructure

- Compute and application architecture are spread across many small product sets (**Azure Virtual Machines**, **Azure Kubernetes Service (AKS)**, **App Service**, **Azure Functions**, **Azure Container Apps**, **Azure Service Bus**, **Azure Event Grid**, **Azure Event Hubs**). For service-selection tasks, the **Azure Architecture Center** decision guides (compute, container, messaging, load balancing) are the best grounding sources.
- Migrations are anchored by **Azure Migrate** and the **Cloud Adoption Framework**. Database migration also pulls in **Azure Database Migration Service** and the **Azure SQL** migration guides. Unstructured data migration is fragmented across **Azure Data Box**, **Azure Storage Mover**, **Azure File Sync**, and AzCopy under **Azure Storage**.
- Networking is highly fragmented: each capability (VNet, VPN Gateway, ExpressRoute, Virtual WAN, Firewall, Front Door, Application Gateway, Load Balancer, Traffic Manager, Private Link, DDoS Protection) is its own set. **Azure Virtual Network** appears most often and is worth downloading first, followed by the **Azure Architecture Center** load-balancing decision guide.
- **Cloud Adoption Framework** and **Azure Well-Architected Framework** recur across compute, migration, and networking tasks. Both are high-value cross-domain downloads.

---

## Cross-cutting documentation sets worth downloading first

These sets appear across multiple domains and tasks:

- **Azure Monitor** (logging, monitoring, routing)
- **Microsoft Entra ID** and its sub-collections (authentication, identity, governance)
- **Azure SQL** (relational storage, protection, HA, migration)
- **Azure Storage** (unstructured data, durability, backup, migration)
- **Azure reliability** (high availability and disaster recovery concepts)
- **Cloud Adoption Framework** (governance, migration, landing zones)
- **Azure Well-Architected Framework** (design tradeoffs across all pillars)
- **Azure Architecture Center** (service-selection decision guides)
