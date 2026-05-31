# AZ-305 Documentation Map

Designing Microsoft Azure Infrastructure Solutions. Organized by the official study guide hierarchy (skills measured as of April 17, 2026): Domain → Skill → Task.

**How to use this map.** Each row names a Microsoft Learn documentation set (the value you would get if you downloaded that doc set as a PDF, so the implied filename is the name plus `.pdf`). The URL points to the single page within that set that best supports the task. All links are official Microsoft Learn pages. A documentation set may repeat across tasks where it genuinely supports each one.

**Validation note.** URLs use canonical `learn.microsoft.com/en-us/` paths and stable documentation-set roots or high-value overview pages. Newer or ambiguously named sets (Azure Managed Redis vs Azure Cache for Redis, Azure Storage Mover, deployment stacks) were verified directly. Forum and community discussions were used only as discovery signals to widen the candidate product list, then validated against official documentation. No forum, blog, or exam-dump links appear in this map.

---

## Domain: Design identity, governance, and monitoring solutions (25–30%)

### Skill: Design solutions for logging and monitoring

#### Task: Recommend a logging solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview> | Core logging platform: Log Analytics workspaces, log data model, and KQL querying that most log designs center on. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-collection-rule-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-collection-rule-overview> | Data collection rules define what telemetry is gathered from VMs and agents; central to logging design. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview> | Application Insights provides application-level logging and tracing for app diagnostics. |
| [Azure Activity log](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/activity-log) | <https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/activity-log> | Subscription-level control-plane logging for resource changes and operations. |
| [Microsoft Entra monitoring and health](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/) | <https://learn.microsoft.com/en-us/entra/identity/monitoring-health/> | Identity sign-in and audit logs, a distinct log source that must be designed into any logging solution. |
| [Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/overview) | <https://learn.microsoft.com/en-us/azure/sentinel/overview> | SIEM layer that ingests logs for security analytics; relevant when logging design must support threat detection. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-overview> | Blob storage as a low-cost archive destination for long-term log retention. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/observability) | <https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/observability> | Observability design principles for choosing what to log and how to structure it. |

Potentially relevant products considered: Azure Monitor, Log Analytics, Application Insights, Activity log, Data collection rules, Microsoft Entra monitoring and health, Microsoft Sentinel, Azure Storage (archive), Event Hubs (streaming export), Microsoft Defender for Cloud, Well-Architected observability guidance.

#### Task: Recommend a solution for routing logs

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings) | <https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings> | Diagnostic settings are the primary mechanism for routing platform logs and metrics to destinations. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export> | Log Analytics data export routes workspace data to storage or Event Hubs for retention or downstream use. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about> | Standard target for streaming logs to external SIEMs or third-party tools. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-overview> | Archive destination for long-term, low-cost log retention. |
| [Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/connect-data-sources) | <https://learn.microsoft.com/en-us/azure/sentinel/connect-data-sources> | Data connectors define how logs are routed into a SIEM for analysis. |
| [Microsoft Entra monitoring and health](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-stream-logs-to-event-hub) | <https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-stream-logs-to-event-hub> | Routing of Entra sign-in and audit logs to Event Hubs, storage, or Log Analytics. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-collection-rule-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-collection-rule-overview> | DCRs route and transform collected data to chosen destinations. |

Potentially relevant products considered: Diagnostic settings, Log Analytics data export, Event Hubs, Azure Storage, Microsoft Sentinel, Microsoft Entra log streaming, Data collection rules, Logic Apps (alert-driven routing).

#### Task: Recommend a monitoring solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/overview> | The umbrella monitoring platform covering metrics, logs, alerts, and visualization. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview> | Alerting design across metric, log, and activity-log signals. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview> | Application performance monitoring for web apps and services. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-overview> | VM insights for compute health and performance monitoring. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview> | Container insights for AKS and container workload monitoring. |
| [Azure Network Watcher](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview) | <https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview> | Network monitoring and diagnostics for connectivity and performance. |
| [Azure Advisor](https://learn.microsoft.com/en-us/azure/advisor/advisor-overview) | <https://learn.microsoft.com/en-us/azure/advisor/advisor-overview> | Proactive recommendations across reliability, security, performance, and cost. |
| [Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction) | <https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction> | Security posture monitoring and workload threat protection. |
| [Microsoft Entra monitoring and health](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/) | <https://learn.microsoft.com/en-us/entra/identity/monitoring-health/> | Identity health, sign-in monitoring, and workbooks. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/observability) | <https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/observability> | Design guidance for selecting a monitoring strategy aligned to workload needs. |

Potentially relevant products considered: Azure Monitor, Log Analytics, Application Insights, VM insights, Container insights, Network Watcher, Azure Advisor, Microsoft Defender for Cloud, Microsoft Entra monitoring and health, Azure Service Health, Managed Grafana, Workbooks.

### Skill: Design authentication and authorization solutions

#### Task: Recommend an authentication solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Microsoft Entra authentication](https://learn.microsoft.com/en-us/entra/identity/authentication/overview-authentication) | <https://learn.microsoft.com/en-us/entra/identity/authentication/overview-authentication> | Authentication methods, MFA, and passwordless options to choose from. |
| [Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/fundamentals/whatis) | <https://learn.microsoft.com/en-us/entra/fundamentals/whatis> | Core identity provider for cloud and hybrid authentication. |
| [Microsoft Entra Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview) | <https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview> | Policy-driven authentication controls based on signals and risk. |
| [Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/v2-overview) | <https://learn.microsoft.com/en-us/entra/identity-platform/v2-overview> | App authentication using OAuth 2.0/OpenID Connect for custom and third-party apps. |
| [Microsoft Entra hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity> | Hybrid authentication choices: password hash sync, pass-through auth, federation. |
| [Microsoft Entra External ID](https://learn.microsoft.com/en-us/entra/external-id/external-identities-overview) | <https://learn.microsoft.com/en-us/entra/external-id/external-identities-overview> | Authentication for external users, partners, and customers (B2B/B2C scenarios). |
| [Microsoft Entra Workload ID](https://learn.microsoft.com/en-us/entra/workload-id/workload-identities-overview) | <https://learn.microsoft.com/en-us/entra/workload-id/workload-identities-overview> | Authentication for applications and services rather than users. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access) | <https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access> | Design principles for identity and access in secure architectures. |

Potentially relevant products considered: Microsoft Entra ID, authentication methods, MFA, passwordless/FIDO2, Conditional Access, Microsoft identity platform, hybrid identity (Entra Connect), federation/AD FS, External ID (B2B/B2C), Workload identities, Windows Hello for Business.

#### Task: Recommend an identity management solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/fundamentals/whatis) | <https://learn.microsoft.com/en-us/entra/fundamentals/whatis> | Foundational directory and identity management service. |
| [Microsoft Entra hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity> | Synchronization and management of on-premises and cloud identities. |
| [Microsoft Entra Connect](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/whatis-azure-ad-connect) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/whatis-azure-ad-connect> | Directory synchronization tooling for hybrid identity management. |
| [Microsoft Entra managed identities](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) | <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview> | Eliminates credential management for Azure resource-to-resource identity. |
| [Microsoft Entra External ID](https://learn.microsoft.com/en-us/entra/external-id/external-identities-overview) | <https://learn.microsoft.com/en-us/entra/external-id/external-identities-overview> | Managing external/guest identity lifecycle. |
| [Microsoft Entra Application Proxy](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy) | <https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy> | Publishing on-premises apps through Entra-managed identity. |
| [Microsoft Entra Domain Services](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview) | <https://learn.microsoft.com/en-us/entra/identity/domain-services/overview> | Managed domain services (LDAP, Kerberos) for legacy apps without domain controllers. |
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview) | <https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview> | Lifecycle, access reviews, and entitlement management for identities at scale. |

Potentially relevant products considered: Microsoft Entra ID, hybrid identity, Entra Connect/Cloud Sync, managed identities, External ID, Application Proxy, Entra Domain Services, ID Governance, self-service password reset, group management.

#### Task: Recommend a solution for authorizing access to Azure resources

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure RBAC](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview) | <https://learn.microsoft.com/en-us/azure/role-based-access-control/overview> | Primary model for authorizing access to Azure control-plane resources. |
| [Azure RBAC](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles) | <https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles> | Custom roles for least-privilege authorization design. |
| [Microsoft Entra managed identities](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) | <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview> | Workload identities that receive RBAC assignments without stored credentials. |
| [Microsoft Entra Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure) | <https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure> | Just-in-time, time-bound privileged access to Azure resources and roles. |
| [Microsoft Entra Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview) | <https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview> | Conditions and controls applied to resource and portal access. |
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview) | <https://learn.microsoft.com/en-us/azure/governance/policy/overview> | Guardrails that constrain what authorized principals can deploy. |
| [Azure attribute-based access control](https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-overview) | <https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-overview> | ABAC conditions for fine-grained authorization on storage and resources. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access) | <https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access> | Least-privilege and access-control design principles. |

Potentially relevant products considered: Azure RBAC, custom roles, ABAC conditions, managed identities, PIM, Conditional Access, Azure Policy, management group scoping, Microsoft Entra roles vs Azure roles.

#### Task: Recommend a solution for authorizing access to on-premises resources

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Microsoft Entra Application Proxy](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy) | <https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy> | Secure remote access to on-premises web apps using Entra identity. |
| [Microsoft Entra hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity> | Extending cloud identity to authorize on-premises access. |
| [Microsoft Entra Domain Services](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview) | <https://learn.microsoft.com/en-us/entra/identity/domain-services/overview> | Kerberos/LDAP authorization for legacy on-premises-style apps. |
| [Microsoft Entra Private Access](https://learn.microsoft.com/en-us/entra/global-secure-access/concept-private-access) | <https://learn.microsoft.com/en-us/entra/global-secure-access/concept-private-access> | Zero Trust network access to private on-premises resources. |
| [Microsoft Entra Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview) | <https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview> | Conditions governing access to published on-premises apps. |
| [Active Directory Domain Services](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/active-directory-domain-services) | <https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/active-directory-domain-services> | On-premises AD DS as the authorization source in hybrid designs. |
| [Microsoft Entra Kerberos](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-azure-ad-kerberos-auth) | <https://learn.microsoft.com/en-us/entra/identity/authentication/concept-azure-ad-kerberos-auth> | Cloud Kerberos for accessing on-premises resources and Azure Files. |

Potentially relevant products considered: Application Proxy, hybrid identity, Entra Domain Services, Global Secure Access / Private Access, Conditional Access, on-premises AD DS, Entra Kerberos, single sign-on, SSO for SaaS.

#### Task: Recommend a solution to manage secrets, certificates, and keys

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview) | <https://learn.microsoft.com/en-us/azure/key-vault/general/overview> | Central service for storing and managing secrets, keys, and certificates. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/keys/about-keys) | <https://learn.microsoft.com/en-us/azure/key-vault/keys/about-keys> | Key management, including customer-managed keys for encryption. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/certificates/about-certificates) | <https://learn.microsoft.com/en-us/azure/key-vault/certificates/about-certificates> | Certificate lifecycle management and integration with issuers. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/overview) | <https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/overview> | Managed HSM for FIPS 140-2 Level 3 key protection in regulated scenarios. |
| [Microsoft Entra managed identities](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) | <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview> | Credential-free way for apps to retrieve secrets from Key Vault. |
| [Azure App Configuration](https://learn.microsoft.com/en-us/azure/azure-app-configuration/overview) | <https://learn.microsoft.com/en-us/azure/azure-app-configuration/overview> | Configuration store that references Key Vault secrets, complementing secret design. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/security/application-secrets) | <https://learn.microsoft.com/en-us/azure/well-architected/security/application-secrets> | Design guidance for handling application secrets securely. |

Potentially relevant products considered: Azure Key Vault, Managed HSM, customer-managed keys, managed identities, App Configuration, Dedicated HSM, certificate auto-rotation, Key Vault references in App Service/Functions.

### Skill: Design governance

#### Task: Recommend a structure for management groups, subscriptions, and resource groups, and a strategy for resource tagging

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview) | <https://learn.microsoft.com/en-us/azure/governance/management-groups/overview> | Hierarchy for organizing subscriptions and applying governance at scale. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org> | Resource organization design area for management group and subscription structure. |
| [Azure Resource Manager](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview> | Subscriptions, resource groups, and the resource hierarchy fundamentals. |
| [Azure resource tagging](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources> | Mechanics of applying tags for organization, cost, and automation. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging> | Tagging strategy and naming conventions for governance and chargeback. |
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview) | <https://learn.microsoft.com/en-us/azure/governance/policy/overview> | Enforcing tag and structure requirements across the hierarchy. |
| [Azure landing zones](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/> | Reference for enterprise-scale subscription and management group design. |

Potentially relevant products considered: Management groups, subscriptions, resource groups, Azure Resource Manager, tags, Azure Policy, CAF resource organization, landing zones, Azure Blueprints (deprecated path noted), subscription vending.

#### Task: Recommend a solution for managing compliance

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview) | <https://learn.microsoft.com/en-us/azure/governance/policy/overview> | Definitions and initiatives that enforce and audit compliance state. |
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance) | <https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance> | Regulatory compliance initiatives mapped to standards. |
| [Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard) | <https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard> | Compliance posture dashboard against regulatory standards. |
| [Microsoft Purview](https://learn.microsoft.com/en-us/purview/purview) | <https://learn.microsoft.com/en-us/purview/purview> | Data governance and compliance across data estates. |
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-initiatives) | <https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-initiatives> | Built-in initiatives accelerating compliance baselines. |
| [Microsoft Service Trust Portal / compliance offerings](https://learn.microsoft.com/en-us/compliance/regulatory/offering-home) | <https://learn.microsoft.com/en-us/compliance/regulatory/offering-home> | Reference for Microsoft compliance offerings and certifications. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/security/governance) | <https://learn.microsoft.com/en-us/azure/well-architected/security/governance> | Governance and compliance design principles. |

Potentially relevant products considered: Azure Policy, regulatory compliance initiatives, Microsoft Defender for Cloud, Microsoft Purview, compliance offerings, Azure Blueprints, resource locks, Cloud Adoption Framework Govern methodology.

#### Task: Recommend a solution for identity governance

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview) | <https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview> | Umbrella for access lifecycle, reviews, and entitlement governance. |
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-overview) | <https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-overview> | Entitlement management with access packages for scalable provisioning. |
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/access-reviews-overview) | <https://learn.microsoft.com/en-us/entra/id-governance/access-reviews-overview> | Access reviews for periodic recertification of access. |
| [Microsoft Entra Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure) | <https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure> | Just-in-time elevation and oversight of privileged roles. |
| [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/what-is-provisioning) | <https://learn.microsoft.com/en-us/entra/id-governance/what-is-provisioning> | Lifecycle workflows and automated provisioning/deprovisioning. |
| [Microsoft Entra Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview) | <https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview> | Risk- and condition-based controls that complement governance. |

Potentially relevant products considered: Entra ID Governance, entitlement management, access reviews, PIM, lifecycle workflows, provisioning, terms of use, Conditional Access, separation of duties.

### Coverage notes (Domain 1)

- Logging and monitoring spread across one large set (Azure Monitor, which contains Log Analytics, Application Insights, VM insights, Container insights) plus separate sets for Network Watcher, Advisor, Defender for Cloud, and Entra monitoring and health. Download **Azure Monitor** first; it covers the majority of logging/monitoring tasks.
- Identity tasks draw heavily on the Microsoft Entra documentation family, which is split into many sub-sets (authentication, Conditional Access, identity platform, hybrid, managed identities, ID Governance, External ID). These names map to separate PDFs even though they share the Entra brand.
- Governance is fragmented across Azure Policy, management groups, Azure Resource Manager, and Cloud Adoption Framework; the best structural guidance is architecture/CAF rather than a single product root.
- Compliance has no single product home: it combines Azure Policy, Defender for Cloud, and Microsoft Purview.
- Forum-discovery note: Public candidate discussions repeatedly surface scenarios around Conditional Access vs PIM, managed identities vs service principals, RBAC scope vs Azure Policy, management group hierarchy design, and where Defender for Cloud vs Purview applies. All were validated against official documentation before inclusion.

---

## Domain: Design data storage solutions (20–25%)

### Skill: Design data storage solutions for relational data

#### Task: Recommend a solution for storing relational data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview> | PaaS relational option; the default starting point for most relational designs. |
| [Azure SQL Managed Instance](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview> | Near-full SQL Server compatibility for lift-and-shift relational workloads. |
| [SQL Server on Azure VMs](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview> | IaaS option when OS-level control or unsupported features are required. |
| [Azure SQL](https://learn.microsoft.com/en-us/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview> | IaaS vs PaaS comparison central to relational service selection. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/service-overview) | <https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/service-overview> | Managed PostgreSQL option for open-source relational workloads. |
| [Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview) | <https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview> | Managed MySQL option for open-source relational workloads. |
| [Azure Cosmos DB for PostgreSQL](https://learn.microsoft.com/en-us/azure/cosmos-db/postgresql/introduction) | <https://learn.microsoft.com/en-us/azure/cosmos-db/postgresql/introduction> | Distributed PostgreSQL for relational workloads needing horizontal scale. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-store-overview) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-store-overview> | Data store selection guidance comparing relational and other models. |

Potentially relevant products considered: Azure SQL Database, SQL Managed Instance, SQL Server on VMs, Azure Database for PostgreSQL, Azure Database for MySQL, Cosmos DB for PostgreSQL, IaaS vs PaaS comparison, data store decision guide, Azure SQL Hyperscale.

#### Task: Recommend a database service tier and compute tier

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-sql-database-vcore) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-sql-database-vcore> | vCore tiers and compute models that drive tier selection. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/serverless-tier-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/serverless-tier-overview> | Serverless compute for intermittent or unpredictable workloads. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tier-hyperscale) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tier-hyperscale> | Hyperscale tier for very large databases and rapid scaling. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/purchasing-models) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/purchasing-models> | DTU vs vCore purchasing models for cost/performance decisions. |
| [Azure SQL Managed Instance](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/service-tiers-managed-instance-vcore) | <https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/service-tiers-managed-instance-vcore> | Service tiers for Managed Instance sizing. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compute) | <https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compute> | Compute tiers and sizing for PostgreSQL flexible server. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/optimize-scaling-costs) | <https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/optimize-scaling-costs> | Cost optimization guidance informing tier and compute choices. |

Potentially relevant products considered: vCore vs DTU, serverless, Hyperscale, Business Critical/General Purpose, Managed Instance tiers, PostgreSQL/MySQL compute tiers, reserved capacity, autoscaling.

#### Task: Recommend a solution for database scalability

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/scale-resources) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/scale-resources> | Vertical scaling of compute and storage. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-pool-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-pool-overview> | Elastic pools for sharing resources across many databases. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/read-scale-out) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/read-scale-out> | Read scale-out using replicas to offload read traffic. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-scale-introduction) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-scale-introduction> | Sharding patterns for horizontal scale. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/partitioning-overview) | <https://learn.microsoft.com/en-us/azure/cosmos-db/partitioning-overview> | Partitioning for horizontal scale where relational limits are reached. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-read-replicas) | <https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-read-replicas> | Read replicas for scaling PostgreSQL reads. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/patterns/sharding) | <https://learn.microsoft.com/en-us/azure/architecture/patterns/sharding> | Sharding design pattern for scaling data stores. |

Potentially relevant products considered: Vertical scaling, elastic pools, read scale-out, Hyperscale, sharding/elastic database tools, Cosmos DB partitioning, read replicas, Cosmos DB for PostgreSQL (Citus), caching offload.

#### Task: Recommend a solution for data protection

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/transparent-data-encryption-tde-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/transparent-data-encryption-tde-overview> | Encryption at rest via TDE, including customer-managed keys. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/always-encrypted-landing) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/always-encrypted-landing> | Always Encrypted for protecting sensitive columns. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/dynamic-data-masking-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/dynamic-data-masking-overview> | Dynamic data masking to limit sensitive data exposure. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/auditing-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/auditing-overview> | Auditing for data access tracking and compliance. |
| [Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-databases-introduction) | <https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-databases-introduction> | Threat protection for database workloads. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/keys/about-keys) | <https://learn.microsoft.com/en-us/azure/key-vault/keys/about-keys> | Customer-managed keys backing database encryption. |
| [Microsoft Purview](https://learn.microsoft.com/en-us/purview/purview) | <https://learn.microsoft.com/en-us/purview/purview> | Classification and sensitivity labeling for data protection. |

Potentially relevant products considered: TDE, Always Encrypted, dynamic data masking, row-level security, auditing, Defender for Databases (Defender for SQL), customer-managed keys, Microsoft Purview, private endpoints, ledger.

### Skill: Design data storage solutions for semi-structured and unstructured data

#### Task: Recommend a solution for storing semi-structured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/introduction) | <https://learn.microsoft.com/en-us/azure/cosmos-db/introduction> | Multi-model NoSQL store for JSON and semi-structured data at global scale. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/choose-api) | <https://learn.microsoft.com/en-us/azure/cosmos-db/choose-api> | API selection (NoSQL, MongoDB, Cassandra, Gremlin, Table) for different data shapes. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/tables/table-storage-overview) | <https://learn.microsoft.com/en-us/azure/storage/tables/table-storage-overview> | Table storage for key-value/semi-structured data at low cost. |
| [Azure Cache for Redis](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview) | <https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview> | In-memory key-value store for semi-structured caching scenarios. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/service-overview) | <https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/service-overview> | JSONB support makes PostgreSQL a relational option for semi-structured data. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-store-overview) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-store-overview> | Data store selection guidance across NoSQL and document models. |

Potentially relevant products considered: Cosmos DB (multi-API), Table storage, Azure Cache for Redis, PostgreSQL JSONB, Azure Managed Redis, Data Lake (for semi-structured files), data store decision guide.

#### Task: Recommend a solution for storing unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction) | <https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction> | Blob storage is the primary service for objects, media, and unstructured files. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-introduction) | <https://learn.microsoft.com/en-us/azure/storage/files/storage-files-introduction> | Azure Files for SMB/NFS file shares. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction) | <https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction> | Data Lake Storage Gen2 for big-data analytics on unstructured data. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview> | Hot/cool/cold/archive tiers for cost-aligned unstructured storage. |
| [Azure NetApp Files](https://learn.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-introduction) | <https://learn.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-introduction> | High-performance file storage for demanding enterprise NAS workloads. |
| [Azure Managed Lustre](https://learn.microsoft.com/en-us/azure/azure-managed-lustre/amlfs-overview) | <https://learn.microsoft.com/en-us/azure/azure-managed-lustre/amlfs-overview> | High-performance parallel file system for HPC unstructured data. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-store-overview) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-store-overview> | Selection guidance across object, file, and disk storage. |

Potentially relevant products considered: Blob Storage, Azure Files, Data Lake Storage Gen2, access tiers, Azure NetApp Files, Managed Lustre, Azure Disk Storage, Azure Elastic SAN, Storage account selection.

#### Task: Recommend a data storage solution to balance features, performance, and costs

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview> | Access tiers and lifecycle management balance cost against access needs. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy> | Redundancy options that trade durability against cost. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/throughput-serverless) | <https://learn.microsoft.com/en-us/azure/cosmos-db/throughput-serverless> | Provisioned vs serverless throughput for cost/performance balance. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/purchasing-models) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/purchasing-models> | Purchasing model comparison for relational cost decisions. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-store-overview) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-store-overview> | Feature-by-feature comparison of data store options. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/) | <https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/> | Cost optimization pillar guidance for storage decisions. |
| [Microsoft Cost Management](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/overview-cost-management) | <https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/overview-cost-management> | Cost analysis and budgeting to validate storage choices. |

Potentially relevant products considered: Blob access tiers, lifecycle management, storage redundancy, reserved capacity, Cosmos DB serverless vs provisioned, SQL purchasing models, Well-Architected cost pillar, Cost Management, data store decision guide.

#### Task: Recommend a data solution for protection and durability

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy> | LRS/ZRS/GRS/GZRS redundancy underpins durability design. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/data-protection-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/data-protection-overview> | Soft delete, versioning, and point-in-time restore for blob protection. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview> | Immutable (WORM) storage for compliance and ransomware resilience. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/blob-backup-overview) | <https://learn.microsoft.com/en-us/azure/backup/blob-backup-overview> | Operational and vaulted backup for blob data. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/online-backup-and-restore) | <https://learn.microsoft.com/en-us/azure/cosmos-db/online-backup-and-restore> | Continuous/periodic backup and restore for NoSQL data. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/keys/about-keys) | <https://learn.microsoft.com/en-us/azure/key-vault/keys/about-keys> | Customer-managed keys for storage encryption at rest. |

Potentially relevant products considered: Storage redundancy, blob soft delete/versioning, immutable storage, object replication, Azure Backup for blobs/files, Cosmos DB backup, Azure Files share snapshots, customer-managed keys, private endpoints.

### Skill: Design data integration

#### Task: Recommend a solution for data integration

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Data Factory](https://learn.microsoft.com/en-us/azure/data-factory/introduction) | <https://learn.microsoft.com/en-us/azure/data-factory/introduction> | Primary ETL/ELT and orchestration service for data integration. |
| [Azure Synapse Analytics](https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is) | <https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is> | Integrated pipelines, Spark, and SQL for unified data integration. |
| [Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/data-factory/data-factory-overview) | <https://learn.microsoft.com/en-us/fabric/data-factory/data-factory-overview> | Modern SaaS data integration via Fabric Data Factory and pipelines. |
| [Azure Databricks](https://learn.microsoft.com/en-us/azure/databricks/introduction/) | <https://learn.microsoft.com/en-us/azure/databricks/introduction/> | Spark-based large-scale transformation and integration. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about> | Streaming ingestion for real-time integration pipelines. |
| [Azure Stream Analytics](https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction) | <https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction> | Real-time stream processing in integration scenarios. |
| [Azure Data Lake Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction) | <https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction> | Landing zone and staging layer for integrated data. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/data-guide/) | <https://learn.microsoft.com/en-us/azure/architecture/data-guide/> | End-to-end data pipeline and integration architecture guidance. |

Potentially relevant products considered: Azure Data Factory, Synapse pipelines, Microsoft Fabric, Azure Databricks, Event Hubs, Event Grid, Service Bus, Stream Analytics, Data Lake Storage, integration runtime, data transfer guidance.

#### Task: Recommend a solution for data analysis

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/fundamentals/microsoft-fabric-overview) | <https://learn.microsoft.com/en-us/fabric/fundamentals/microsoft-fabric-overview> | Unified SaaS analytics platform (OneLake, warehousing, BI) for modern analysis design. |
| [Azure Synapse Analytics](https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is) | <https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is> | Enterprise data warehousing and big-data analytics. |
| [Azure Databricks](https://learn.microsoft.com/en-us/azure/databricks/introduction/) | <https://learn.microsoft.com/en-us/azure/databricks/introduction/> | Lakehouse analytics and machine learning at scale. |
| [Azure Data Explorer](https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview) | <https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview> | Fast analytics over telemetry, logs, and time-series data. |
| [Azure Stream Analytics](https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction) | <https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction> | Real-time analytics on streaming data. |
| [Azure Analysis Services](https://learn.microsoft.com/en-us/azure/analysis-services/analysis-services-overview) | <https://learn.microsoft.com/en-us/azure/analysis-services/analysis-services-overview> | Semantic modeling layer for BI analysis (legacy/established scenarios). |
| [Power BI](https://learn.microsoft.com/en-us/power-bi/fundamentals/power-bi-overview) | <https://learn.microsoft.com/en-us/power-bi/fundamentals/power-bi-overview> | Visualization and reporting layer for analysis output. |

Potentially relevant products considered: Microsoft Fabric, Synapse Analytics, Azure Databricks, Azure Data Explorer, Stream Analytics, Analysis Services, Power BI, OneLake, dedicated vs serverless SQL pools, HDInsight.

### Coverage notes (Domain 2)

- Relational design centers on the **Azure SQL** documentation family, which splits into separate sets for Azure SQL Database, SQL Managed Instance, and SQL Server on Azure VMs. The IaaS-vs-PaaS comparison page is the single most useful selection reference; download all three SQL sets if relational scenarios are a focus.
- Storage tasks consolidate under one large **Azure Storage** set covering Blob, Files, Data Lake, redundancy, tiers, and data protection. Download it first for this domain.
- Analytics and integration are fragmented across Data Factory, Synapse, Databricks, Fabric, Stream Analytics, and Data Explorer; the **Azure Architecture Center data guide** is the best single source for choosing among them.
- Microsoft Fabric is increasingly emphasized for modern analytics and integration design; it is lightly named in the study guide but maps directly to the data analysis and integration tasks.
- Forum-discovery note: Public candidate discussions frequently cite Azure SQL Database vs SQL Managed Instance vs SQL on VM, Cosmos DB consistency levels and partitioning, storage redundancy (GRS/ZRS/GZRS) tradeoffs, blob access tiers, and Synapse vs Fabric vs Databricks selection. All were validated against official documentation before inclusion.

---

## Domain: Design business continuity solutions (15–20%)

### Skill: Design solutions for backup and disaster recovery

#### Task: Recommend a recovery solution for Azure and hybrid workloads that meets recovery objectives

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Site Recovery](https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-overview) | <https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-overview> | Primary DR service for replication and failover of Azure and on-premises workloads. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-overview) | <https://learn.microsoft.com/en-us/azure/backup/backup-overview> | Backup and restore foundation that complements replication for recovery. |
| [Azure reliability](https://learn.microsoft.com/en-us/azure/reliability/disaster-recovery-overview) | <https://learn.microsoft.com/en-us/azure/reliability/disaster-recovery-overview> | Cross-service DR concepts and region/zone recovery options. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/reliability/disaster-recovery) | <https://learn.microsoft.com/en-us/azure/well-architected/reliability/disaster-recovery> | Designing for RTO/RPO targets and DR strategy selection. |
| [Azure reliability](https://learn.microsoft.com/en-us/azure/reliability/regions-paired) | <https://learn.microsoft.com/en-us/azure/reliability/regions-paired> | Region pairs that underpin cross-region recovery design. |
| [Azure reliability](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview) | <https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview> | Availability zones for in-region resilience as part of recovery objectives. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/protect) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/protect> | Protection and recovery planning at the operations level. |

Potentially relevant products considered: Azure Site Recovery, Azure Backup, Azure reliability (DR, region pairs, availability zones), Well-Architected reliability pillar, CAF manage/protect, RTO/RPO, multi-region active-active vs active-passive.

#### Task: Recommend a backup and recovery solution for compute

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-azure-vms-introduction) | <https://learn.microsoft.com/en-us/azure/backup/backup-azure-vms-introduction> | VM backup design, including policies and recovery options. |
| [Azure Site Recovery](https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-architecture) | <https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-architecture> | VM replication and failover for compute disaster recovery. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-azure-arm-vms-prepare) | <https://learn.microsoft.com/en-us/azure/backup/backup-azure-arm-vms-prepare> | Preparing and configuring VM backups in a Recovery Services vault. |
| [Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/backup-recovery) | <https://learn.microsoft.com/en-us/azure/virtual-machines/backup-recovery> | VM-level backup and recovery options overview. |
| [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/backup/azure-kubernetes-service-backup-overview) | <https://learn.microsoft.com/en-us/azure/backup/azure-kubernetes-service-backup-overview> | Backup for containerized compute (AKS). |
| [Azure reliability](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview) | <https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview> | Zone resilience that complements compute backup/recovery. |

Potentially relevant products considered: Azure Backup (VMs, AKS), Azure Site Recovery, Recovery Services vault, disk snapshots, restore points, App Service backup, availability zones.

#### Task: Recommend a backup and recovery solution for databases

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview> | Automated backups, retention, and point-in-time restore for Azure SQL. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/long-term-retention-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/long-term-retention-overview> | Long-term backup retention for compliance recovery objectives. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-azure-sql-database) | <https://learn.microsoft.com/en-us/azure/backup/backup-azure-sql-database> | Backing up SQL Server running in Azure VMs. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/online-backup-and-restore) | <https://learn.microsoft.com/en-us/azure/cosmos-db/online-backup-and-restore> | Continuous and periodic backup/restore for Cosmos DB. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-backup-restore) | <https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-backup-restore> | Backup and restore for PostgreSQL flexible server. |
| [Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-backup-restore) | <https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-backup-restore> | Backup and restore for MySQL flexible server. |
| [Azure SQL Managed Instance](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/automated-backups-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/automated-backups-overview> | Automated backups and restore for Managed Instance. |

Potentially relevant products considered: Azure SQL automated/long-term backups, point-in-time restore, geo-restore, Azure Backup for SQL on VMs, Cosmos DB backup, PostgreSQL/MySQL backup, Managed Instance backups.

#### Task: Recommend a backup and recovery solution for unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/blob-backup-overview) | <https://learn.microsoft.com/en-us/azure/backup/blob-backup-overview> | Operational and vaulted backup for blob storage. |
| [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/azure-file-share-backup-overview) | <https://learn.microsoft.com/en-us/azure/backup/azure-file-share-backup-overview> | Backup for Azure file shares. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/data-protection-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/data-protection-overview> | Soft delete, versioning, and point-in-time restore for blobs. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy> | Geo-redundancy contributing to unstructured data recovery. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/object-replication-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/object-replication-overview> | Asynchronous object replication across regions for recovery. |
| [Azure NetApp Files](https://learn.microsoft.com/en-us/azure/azure-netapp-files/snapshots-introduction) | <https://learn.microsoft.com/en-us/azure/azure-netapp-files/snapshots-introduction> | Snapshot-based protection for NetApp file workloads. |

Potentially relevant products considered: Azure Backup (blobs, files), blob soft delete/versioning, object replication, storage redundancy, Azure Files share snapshots, NetApp Files snapshots, immutable storage.

### Skill: Design for high availability

#### Task: Recommend a high availability solution for compute

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure reliability](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview) | <https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview> | Availability zones as the core building block for compute HA. |
| [Azure Virtual Machine Scale Sets](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview) | <https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview> | Scale sets for redundant, auto-scaling VM compute. |
| [Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/availability) | <https://learn.microsoft.com/en-us/azure/virtual-machines/availability> | Availability sets, zones, and SLA options for VM HA. |
| [Azure Load Balancer](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview) | <https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview> | Distributes traffic across redundant compute instances. |
| [Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/overview-zone-redundancy) | <https://learn.microsoft.com/en-us/azure/app-service/overview-zone-redundancy> | Zone redundancy for PaaS web compute HA. |
| [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/availability-zones-overview) | <https://learn.microsoft.com/en-us/azure/aks/availability-zones-overview> | Zone-aware node pools for container compute HA. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/reliability/redundancy) | <https://learn.microsoft.com/en-us/azure/well-architected/reliability/redundancy> | Redundancy design principles for highly available compute. |

Potentially relevant products considered: Availability zones, availability sets, VM Scale Sets, Load Balancer, App Service zone redundancy, AKS zones, Traffic Manager/Front Door for multi-region, Well-Architected reliability pillar.

#### Task: Recommend a high availability solution for relational data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/high-availability-sla) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/high-availability-sla> | Built-in HA architecture and SLA tiers for Azure SQL. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/active-geo-replication-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/active-geo-replication-overview> | Active geo-replication for cross-region read replicas and failover. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/failover-group-sql-db) | <https://learn.microsoft.com/en-us/azure/azure-sql/database/failover-group-sql-db> | Auto-failover groups for transparent regional failover. |
| [Azure SQL Managed Instance](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/failover-group-sql-mi) | <https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/failover-group-sql-mi> | Failover groups for Managed Instance HA/DR. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-high-availability) | <https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-high-availability> | Zone-redundant HA for PostgreSQL. |
| [SQL Server on Azure VMs](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/business-continuity-high-availability-disaster-recovery-hadr-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/business-continuity-high-availability-disaster-recovery-hadr-overview> | Always On availability groups and FCIs for IaaS SQL HA. |

Potentially relevant products considered: Azure SQL built-in HA, zone-redundant config, active geo-replication, failover groups, Managed Instance failover groups, PostgreSQL/MySQL zone-redundant HA, Always On AGs on SQL VMs, read replicas.

#### Task: Recommend a high availability solution for semi-structured and unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy> | ZRS/GZRS redundancy delivers HA for blob and file data. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/high-availability) | <https://learn.microsoft.com/en-us/azure/cosmos-db/high-availability> | Multi-region writes and automatic failover for NoSQL HA. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/distribute-data-globally) | <https://learn.microsoft.com/en-us/azure/cosmos-db/distribute-data-globally> | Global distribution for low-latency, highly available data. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/object-replication-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/object-replication-overview> | Object replication for cross-region availability of blob data. |
| [Azure Cache for Redis](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-high-availability) | <https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-high-availability> | Replication and zone redundancy for cached semi-structured data. |
| [Azure NetApp Files](https://learn.microsoft.com/en-us/azure/azure-netapp-files/cross-region-replication-introduction) | <https://learn.microsoft.com/en-us/azure/azure-netapp-files/cross-region-replication-introduction> | Cross-region replication for file workload HA. |

Potentially relevant products considered: Storage redundancy (ZRS/GZRS), object replication, Cosmos DB multi-region writes and automatic failover, Azure Cache for Redis/Managed Redis geo-replication, NetApp Files cross-region replication, Azure Files redundancy.

### Coverage notes (Domain 3)

- Business continuity guidance is split between two product sets (**Azure Backup** and **Azure Site Recovery**) and the cross-cutting **Azure reliability** set (availability zones, region pairs, DR overview). Download all three first for this domain.
- Database HA/DR is documented inside each data product's own set (Azure SQL Database, SQL Managed Instance, SQL on VMs, PostgreSQL, MySQL, Cosmos DB) rather than in a central place, so coverage is fragmented by data platform.
- The best strategy-level guidance for RTO/RPO and active-active vs active-passive is the **Well-Architected Framework reliability pillar**, not a single product root.
- Forum-discovery note: Public candidate discussions commonly raise Azure Backup vs Azure Site Recovery scope, availability zones vs availability sets, SQL failover groups vs active geo-replication, storage redundancy choices for durability, and Cosmos DB multi-region failover behavior. All were validated against official documentation before inclusion.

---

## Domain: Design infrastructure solutions (30–35%)

### Skill: Design compute solutions

#### Task: Specify components of a compute solution based on workload requirements

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree> | Compute decision tree mapping workload requirements to services. |
| [Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/overview) | <https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/overview> | VM size families for matching CPU, memory, and I/O requirements. |
| [Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/overview) | <https://learn.microsoft.com/en-us/azure/app-service/overview> | Managed web compute option for app-centric workloads. |
| [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/what-is-aks) | <https://learn.microsoft.com/en-us/azure/aks/what-is-aks> | Orchestrated container compute for microservices workloads. |
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview> | Event-driven serverless compute for bursty/episodic workloads. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/) | <https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/> | Performance efficiency principles for sizing compute. |
| [Azure reliability](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview) | <https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview> | Resilience requirements influencing compute component choices. |

Potentially relevant products considered: Compute decision tree, VM sizes, App Service, AKS, Container Apps, Functions, Batch, scale sets, Well-Architected performance pillar, availability zones.

#### Task: Recommend a virtual machine-based solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/overview) | <https://learn.microsoft.com/en-us/azure/virtual-machines/overview> | Core IaaS compute service for VM-based designs. |
| [Azure Virtual Machine Scale Sets](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview) | <https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview> | Autoscaling and redundancy for VM fleets. |
| [Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/overview) | <https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/overview> | Size selection for performance and cost. |
| [Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/availability) | <https://learn.microsoft.com/en-us/azure/virtual-machines/availability> | Availability sets/zones and SLA considerations. |
| [Azure Disk Storage](https://learn.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview) | <https://learn.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview> | Managed disk types and performance for VM storage. |
| [Azure Spot Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/spot-vms) | <https://learn.microsoft.com/en-us/azure/virtual-machines/spot-vms> | Cost-optimized compute for interruptible workloads. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/> | Azure VMware Solution path for VM-based migrations needing VMware compatibility. |

Potentially relevant products considered: Virtual Machines, Scale Sets, VM sizes, managed disks, Spot VMs, reserved instances, availability sets/zones, Azure VMware Solution, dedicated hosts, proximity placement groups.

#### Task: Recommend a container-based solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/what-is-aks) | <https://learn.microsoft.com/en-us/azure/aks/what-is-aks> | Full Kubernetes orchestration for complex container workloads. |
| [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/overview) | <https://learn.microsoft.com/en-us/azure/container-apps/overview> | Serverless containers and microservices without managing Kubernetes. |
| [Azure Container Instances](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-overview) | <https://learn.microsoft.com/en-us/azure/container-instances/container-instances-overview> | Lightweight, single-container or burst scenarios. |
| [Azure Container Registry](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-intro) | <https://learn.microsoft.com/en-us/azure/container-registry/container-registry-intro> | Image storage and management for container solutions. |
| [Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/quickstart-custom-container) | <https://learn.microsoft.com/en-us/azure/app-service/quickstart-custom-container> | Running custom containers on managed App Service. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/choose-azure-container-service) | <https://learn.microsoft.com/en-us/azure/architecture/guide/choose-azure-container-service> | Decision guidance for choosing among container hosting options. |

Potentially relevant products considered: AKS, Container Apps, Container Instances, Container Registry, App Service for containers, AKS Automatic, container service comparison, Dapr, KEDA.

#### Task: Recommend a serverless-based solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview> | Event-driven serverless functions for code execution. |
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-scale) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-scale> | Hosting plans (Consumption, Premium, Flex) for serverless design. |
| [Azure Logic Apps](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview) | <https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview> | Serverless workflow orchestration and integration. |
| [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/overview) | <https://learn.microsoft.com/en-us/azure/container-apps/overview> | Serverless containers with scale-to-zero. |
| [Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts) | <https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts> | Fronting serverless APIs with governance and throttling. |
| [Azure Event Grid](https://learn.microsoft.com/en-us/azure/event-grid/overview) | <https://learn.microsoft.com/en-us/azure/event-grid/overview> | Event routing that triggers serverless compute. |

Potentially relevant products considered: Azure Functions, Functions hosting plans, Logic Apps, Container Apps, Event Grid, API Management, serverless SQL/Cosmos DB, Durable Functions.

#### Task: Recommend a compute solution for batch processing

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Batch](https://learn.microsoft.com/en-us/azure/batch/batch-technical-overview) | <https://learn.microsoft.com/en-us/azure/batch/batch-technical-overview> | Managed large-scale parallel and HPC batch processing. |
| [Azure Virtual Machine Scale Sets](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview) | <https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview> | Scalable VM pools for self-managed batch workloads. |
| [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/jobs) | <https://learn.microsoft.com/en-us/azure/container-apps/jobs> | Container Apps jobs for scheduled and event-driven batch tasks. |
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview> | Serverless processing for smaller or triggered batch jobs. |
| [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/what-is-aks) | <https://learn.microsoft.com/en-us/azure/aks/what-is-aks> | Kubernetes jobs for containerized batch processing. |
| [Azure Spot Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/spot-vms) | <https://learn.microsoft.com/en-us/azure/virtual-machines/spot-vms> | Cost-efficient compute for interruptible batch work. |

Potentially relevant products considered: Azure Batch, VM Scale Sets, Container Apps jobs, AKS jobs, Functions, Spot VMs, HPC (CycleCloud), Data Factory for data batch, Logic Apps scheduling.

### Skill: Design an application architecture

#### Task: Recommend a messaging architecture

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Service Bus](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview) | <https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview> | Enterprise messaging with queues and topics for reliable decoupling. |
| [Azure Queue Storage](https://learn.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction) | <https://learn.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction> | Simple, low-cost queue messaging for basic scenarios. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about> | High-throughput event streaming and ingestion. |
| [Azure Event Grid](https://learn.microsoft.com/en-us/azure/event-grid/overview) | <https://learn.microsoft.com/en-us/azure/event-grid/overview> | Event distribution for reactive messaging patterns. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/messaging) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/messaging> | Choosing between messages and events and the right service. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/patterns/competing-consumers) | <https://learn.microsoft.com/en-us/azure/architecture/patterns/competing-consumers> | Messaging patterns such as competing consumers and queue-based load leveling. |

Potentially relevant products considered: Service Bus (queues/topics), Queue Storage, Event Hubs, Event Grid, messaging vs events guidance, messaging design patterns, Logic Apps, Azure Relay.

#### Task: Recommend an event-driven architecture

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Event Grid](https://learn.microsoft.com/en-us/azure/event-grid/overview) | <https://learn.microsoft.com/en-us/azure/event-grid/overview> | Native event routing service for reactive, event-driven designs. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about> | Event streaming backbone for high-volume event pipelines. |
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview> | Serverless handlers triggered by events. |
| [Azure Stream Analytics](https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction) | <https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction> | Real-time processing of event streams. |
| [Azure Service Bus](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview) | <https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview> | Reliable command/message delivery complementing events. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) | <https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven> | Event-driven architecture style guidance and tradeoffs. |

Potentially relevant products considered: Event Grid, Event Hubs, Functions, Stream Analytics, Service Bus, event-driven architecture style, IoT Hub (if relevant), Logic Apps, pub/sub patterns.

#### Task: Recommend a solution for API integration

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts) | <https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts> | Central gateway for publishing, securing, and governing APIs. |
| [Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-policies) | <https://learn.microsoft.com/en-us/azure/api-management/api-management-policies> | Policies for transformation, throttling, and security on APIs. |
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview) | <https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview> | Lightweight API backends behind the gateway. |
| [Azure Application Gateway](https://learn.microsoft.com/en-us/azure/application-gateway/overview) | <https://learn.microsoft.com/en-us/azure/application-gateway/overview> | Layer-7 routing and WAF in front of API backends. |
| [Microsoft Entra identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/v2-overview) | <https://learn.microsoft.com/en-us/entra/identity-platform/v2-overview> | OAuth-based API authorization and token validation. |
| [Azure Logic Apps](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview) | <https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview> | Connector-based API integration and orchestration. |

Potentially relevant products considered: API Management, APIM policies, Functions, Application Gateway/WAF, Microsoft identity platform, Logic Apps, Front Door (API edge), self-hosted gateway, GraphQL/REST design.

#### Task: Recommend a caching solution for applications

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Managed Redis](https://learn.microsoft.com/en-us/azure/redis/overview) | <https://learn.microsoft.com/en-us/azure/redis/overview> | Current Redis Enterprise-based managed cache for new caching designs. |
| [Azure Cache for Redis](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview) | <https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview> | Established managed Redis cache (Basic/Standard/Premium tiers). |
| [Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-caching) | <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-caching> | Edge caching of static content at the CDN layer. |
| [Azure Content Delivery Network](https://learn.microsoft.com/en-us/azure/cdn/cdn-overview) | <https://learn.microsoft.com/en-us/azure/cdn/cdn-overview> | CDN caching for globally distributed static assets. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/best-practices/caching) | <https://learn.microsoft.com/en-us/azure/architecture/best-practices/caching> | Caching patterns and guidance (cache-aside, content caching). |
| [Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-cache) | <https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-cache> | Response caching at the API gateway. |

Potentially relevant products considered: Azure Managed Redis, Azure Cache for Redis, Front Door caching, CDN, caching design patterns, APIM response caching, cache-aside pattern, content caching.

#### Task: Recommend an application configuration management solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure App Configuration](https://learn.microsoft.com/en-us/azure/azure-app-configuration/overview) | <https://learn.microsoft.com/en-us/azure/azure-app-configuration/overview> | Centralized configuration and feature flag management for apps. |
| [Azure App Configuration](https://learn.microsoft.com/en-us/azure/azure-app-configuration/concept-feature-management) | <https://learn.microsoft.com/en-us/azure/azure-app-configuration/concept-feature-management> | Feature flags for progressive rollout and runtime toggles. |
| [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview) | <https://learn.microsoft.com/en-us/azure/key-vault/general/overview> | Secret storage referenced by configuration, keeping secrets out of config. |
| [Microsoft Entra managed identities](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) | <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview> | Secure, credential-free access to configuration and secrets. |
| [Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/configure-common) | <https://learn.microsoft.com/en-us/azure/app-service/configure-common> | App settings and configuration for PaaS-hosted applications. |

Potentially relevant products considered: Azure App Configuration, feature management, Key Vault references, managed identities, App Service settings, environment-based config, configuration-as-code.

#### Task: Recommend an automated deployment solution for applications

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview> | Declarative IaC language for repeatable Azure deployments. |
| [ARM templates](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview> | JSON-based infrastructure as code for deployment automation. |
| [Azure deployment stacks](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks> | Managing a set of resources as a single deployable, governed unit. |
| [Azure Pipelines](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines) | <https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines> | CI/CD pipelines for automated build and release. |
| [GitHub Actions for Azure](https://learn.microsoft.com/en-us/azure/developer/github/github-actions) | <https://learn.microsoft.com/en-us/azure/developer/github/github-actions> | Git-based CI/CD workflows deploying to Azure. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/infrastructure-as-code) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/infrastructure-as-code> | IaC strategy guidance for automated deployment design. |

Potentially relevant products considered: Bicep, ARM templates, deployment stacks, Azure Pipelines, GitHub Actions, Terraform on Azure, template specs, blue-green/canary deployment, App Service deployment slots.

### Skill: Design migrations

#### Task: Evaluate a migration solution that leverages the Microsoft Cloud Adoption Framework for Azure

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/overview) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/overview> | The framework itself: strategy, plan, ready, migrate methodology. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/> | Migrate methodology, assess/migrate/optimize phases. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/> | Planning, digital estate, and migration backlog. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/> | Landing zones as the target environment for migration. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview) | <https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview> | Tooling that operationalizes CAF assessment and migration. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/) | <https://learn.microsoft.com/en-us/azure/well-architected/> | Aligning migrated workloads to the five pillars. |

Potentially relevant products considered: Cloud Adoption Framework (strategy/plan/ready/migrate), landing zones, Azure Migrate, Well-Architected Framework, the 5 Rs of rationalization, total cost of ownership, governance baseline.

#### Task: Evaluate on-premises servers, data, and applications for migration

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview) | <https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview> | Discovery and assessment hub for servers, databases, and apps. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/concepts-assessment-calculation) | <https://learn.microsoft.com/en-us/azure/migrate/concepts-assessment-calculation> | Assessment readiness, sizing, and cost estimation logic. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/concepts-dependency-visualization) | <https://learn.microsoft.com/en-us/azure/migrate/concepts-dependency-visualization> | Dependency analysis to group and sequence workloads. |
| [Azure Database Migration Service](https://learn.microsoft.com/en-us/azure/dms/dms-overview) | <https://learn.microsoft.com/en-us/azure/dms/dms-overview> | Database assessment and migration readiness. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/digital-estate/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/digital-estate/> | Digital estate evaluation and rationalization decisions. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/how-to-create-azure-vmware-solution-assessment) | <https://learn.microsoft.com/en-us/azure/migrate/how-to-create-azure-vmware-solution-assessment> | Assessing VMware estates for migration paths. |

Potentially relevant products considered: Azure Migrate (discovery, assessment, dependency mapping), Database Migration Service, CAF digital estate, web app assessment, SQL assessment, VMware assessment, the 5 Rs.

#### Task: Recommend a solution for migrating workloads to IaaS and PaaS

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview) | <https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview> | Server migration to Azure VMs (IaaS) at scale. |
| [Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/app-service-asp-net-migration) | <https://learn.microsoft.com/en-us/azure/app-service/app-service-asp-net-migration> | Migrating web apps to App Service (PaaS). |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/> | Rehost vs refactor vs rearchitect decisions for IaaS/PaaS. |
| [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/what-is-aks) | <https://learn.microsoft.com/en-us/azure/aks/what-is-aks> | Target for containerizing apps as part of modernization. |
| [Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) | <https://learn.microsoft.com/en-us/azure/azure-vmware/introduction> | Lift-and-shift for VMware estates needing platform parity. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree> | Selecting the target compute model during migration. |

Potentially relevant products considered: Azure Migrate, App Service migration, AKS, Azure VMware Solution, CAF migrate (5 Rs), Container Apps, Functions, SQL target platforms, compute decision tree.

#### Task: Recommend a solution for migrating databases

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Database Migration Service](https://learn.microsoft.com/en-us/azure/dms/dms-overview) | <https://learn.microsoft.com/en-us/azure/dms/dms-overview> | Managed service for online/offline database migrations. |
| [Azure SQL Migration](https://learn.microsoft.com/en-us/azure/dms/migration-using-azure-data-studio) | <https://learn.microsoft.com/en-us/azure/dms/migration-using-azure-data-studio> | Azure SQL migration via the migration extension and DMS. |
| [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/migration-guides/database/sql-server-to-sql-database-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/migration-guides/database/sql-server-to-sql-database-overview> | SQL Server to Azure SQL Database migration guidance. |
| [Azure SQL Managed Instance](https://learn.microsoft.com/en-us/azure/azure-sql/migration-guides/managed-instance/sql-server-to-managed-instance-overview) | <https://learn.microsoft.com/en-us/azure/azure-sql/migration-guides/managed-instance/sql-server-to-managed-instance-overview> | SQL Server to Managed Instance migration path. |
| [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/migrate/concepts-migration-service-postgresql) | <https://learn.microsoft.com/en-us/azure/postgresql/migrate/concepts-migration-service-postgresql> | Migration service for PostgreSQL targets. |
| [Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/migrate/migrate-single-flexible-mysql-import-cli) | <https://learn.microsoft.com/en-us/azure/mysql/migrate/migrate-single-flexible-mysql-import-cli> | Migration paths to MySQL flexible server. |
| [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/migration-choices) | <https://learn.microsoft.com/en-us/azure/cosmos-db/migration-choices> | Migration options for NoSQL data into Cosmos DB. |

Potentially relevant products considered: Database Migration Service, Azure SQL/Managed Instance migration guides, Azure Data Studio migration extension, PostgreSQL/MySQL migration, Cosmos DB migration choices, Data Migration Assistant, schema/data movement, offline vs online.

#### Task: Recommend a solution for migrating unstructured data

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Storage Mover](https://learn.microsoft.com/en-us/azure/storage-mover/service-overview) | <https://learn.microsoft.com/en-us/azure/storage-mover/service-overview> | Managed hybrid service for migrating file shares to Azure. |
| [Azure Data Box](https://learn.microsoft.com/en-us/azure/databox/data-box-overview) | <https://learn.microsoft.com/en-us/azure/databox/data-box-overview> | Offline bulk transfer for very large datasets or limited bandwidth. |
| [Azure File Sync](https://learn.microsoft.com/en-us/azure/storage/file-sync/file-sync-introduction) | <https://learn.microsoft.com/en-us/azure/storage/file-sync/file-sync-introduction> | Syncing and tiering on-premises file servers to Azure Files. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10> | AzCopy for online bulk copy of blobs and files. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-migration-overview) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-migration-overview> | Storage migration overview comparing tools and approaches. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview) | <https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview> | Coordinating data migration alongside server migration. |

Potentially relevant products considered: Azure Storage Mover, Data Box (Disk/Heavy), Azure File Sync, AzCopy, storage migration overview, Azure Migrate, Data Box Gateway, online vs offline transfer tradeoffs.

### Skill: Design network solutions

#### Task: Recommend a connectivity solution that connects Azure resources to the internet

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview) | <https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview> | Foundational network for outbound/inbound connectivity design. |
| [Azure NAT Gateway](https://learn.microsoft.com/en-us/azure/nat-gateway/nat-overview) | <https://learn.microsoft.com/en-us/azure/nat-gateway/nat-overview> | Scalable, secure outbound internet connectivity. |
| [Azure Public IP / Load Balancer](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview) | <https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview> | Inbound internet-facing connectivity via public load balancing. |
| [Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview) | <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview> | Global edge entry point for internet-facing apps. |
| [Azure Bastion](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) | <https://learn.microsoft.com/en-us/azure/bastion/bastion-overview> | Secure management connectivity without public IPs on VMs. |
| [Azure Private Link](https://learn.microsoft.com/en-us/azure/private-link/private-link-overview) | <https://learn.microsoft.com/en-us/azure/private-link/private-link-overview> | Keeping PaaS traffic off the public internet where required. |

Potentially relevant products considered: Virtual Network, NAT Gateway, public IPs, Load Balancer, Front Door, Application Gateway, Bastion, Private Link, default outbound access changes, DNS.

#### Task: Recommend a connectivity solution that connects Azure resources to on-premises networks

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure VPN Gateway](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways) | <https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways> | Site-to-site and point-to-site VPN connectivity to on-premises. |
| [Azure ExpressRoute](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction) | <https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction> | Private, high-bandwidth dedicated connectivity to Azure. |
| [Azure Virtual WAN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about) | <https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about> | Unified hub-and-spoke connectivity across sites and regions. |
| [Azure Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview) | <https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview> | VNet peering as part of hybrid topology design. |
| [Azure Private Link](https://learn.microsoft.com/en-us/azure/private-link/private-link-overview) | <https://learn.microsoft.com/en-us/azure/private-link/private-link-overview> | Private access to services across hybrid connections. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity> | Network topology and connectivity design area for hybrid networks. |

Potentially relevant products considered: VPN Gateway, ExpressRoute, Virtual WAN, VNet peering, Private Link, ExpressRoute + VPN failover, hub-and-spoke, CAF network topology, Azure DNS Private Resolver.

#### Task: Recommend a solution to optimize network performance

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview) | <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview> | Global acceleration and edge routing for performance. |
| [Azure ExpressRoute](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction) | <https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction> | Predictable, low-latency dedicated bandwidth. |
| [Azure Content Delivery Network](https://learn.microsoft.com/en-us/azure/cdn/cdn-overview) | <https://learn.microsoft.com/en-us/azure/cdn/cdn-overview> | Edge caching to reduce latency for static content. |
| [Azure Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/accelerated-networking-overview) | <https://learn.microsoft.com/en-us/azure/virtual-network/accelerated-networking-overview> | Accelerated networking for higher throughput and lower latency. |
| [Azure Network Watcher](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview) | <https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview> | Diagnosing latency and performance bottlenecks. |
| [Azure ExpressRoute](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-global-reach) | <https://learn.microsoft.com/en-us/azure/expressroute/expressroute-global-reach> | Global Reach for optimized site-to-site traffic. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/networking/guide/network-level-segmentation) | <https://learn.microsoft.com/en-us/azure/architecture/networking/guide/network-level-segmentation> | Network design guidance balancing performance and segmentation. |

Potentially relevant products considered: Front Door, ExpressRoute (and Global Reach), CDN, accelerated networking, proximity placement groups, Network Watcher, Traffic Manager, routing preference, Virtual WAN.

#### Task: Recommend a solution to optimize network security

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/overview) | <https://learn.microsoft.com/en-us/azure/firewall/overview> | Managed, stateful network firewall for centralized filtering. |
| [Azure Firewall Manager](https://learn.microsoft.com/en-us/azure/firewall-manager/overview) | <https://learn.microsoft.com/en-us/azure/firewall-manager/overview> | Central policy management for firewalls across hubs. |
| [Azure Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) | <https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview> | NSGs and ASGs for subnet/NIC-level traffic control. |
| [Azure DDoS Protection](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview) | <https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview> | Protection against volumetric and protocol attacks. |
| [Azure Web Application Firewall](https://learn.microsoft.com/en-us/azure/web-application-firewall/overview) | <https://learn.microsoft.com/en-us/azure/web-application-firewall/overview> | Layer-7 protection on Application Gateway and Front Door. |
| [Azure Private Link](https://learn.microsoft.com/en-us/azure/private-link/private-link-overview) | <https://learn.microsoft.com/en-us/azure/private-link/private-link-overview> | Private connectivity that removes public exposure of PaaS. |
| [Azure Bastion](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) | <https://learn.microsoft.com/en-us/azure/bastion/bastion-overview> | Secure RDP/SSH without exposing management ports. |

Potentially relevant products considered: Azure Firewall, Firewall Manager, NSGs/ASGs, DDoS Protection, Web Application Firewall, Private Link, Bastion, service endpoints, user-defined routes, Microsoft Defender for Cloud, Zero Trust network design.

#### Task: Recommend a load-balancing and routing solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview) | <https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview> | Decision guidance for selecting among Azure load balancing options. |
| [Azure Load Balancer](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview) | <https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview> | Layer-4 regional load balancing for VMs and services. |
| [Azure Application Gateway](https://learn.microsoft.com/en-us/azure/application-gateway/overview) | <https://learn.microsoft.com/en-us/azure/application-gateway/overview> | Layer-7 regional load balancing with WAF and path routing. |
| [Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview) | <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview> | Global HTTP(S) load balancing and routing at the edge. |
| [Azure Traffic Manager](https://learn.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview) | <https://learn.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview> | DNS-based global routing across regions. |
| [Azure NAT Gateway](https://learn.microsoft.com/en-us/azure/nat-gateway/nat-overview) | <https://learn.microsoft.com/en-us/azure/nat-gateway/nat-overview> | Outbound connectivity that pairs with load-balanced designs. |
| [Azure Virtual WAN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about) | <https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about> | Routing across hubs in large-scale network topologies. |

Potentially relevant products considered: Load balancing decision guide, Load Balancer, Application Gateway (+WAF), Front Door, Traffic Manager, NAT Gateway, Virtual WAN, gateway load balancer, global vs regional and L4 vs L7 tradeoffs.

### Coverage notes (Domain 4)

- Compute selection is best anchored by the **Azure Architecture Center** compute decision tree and container service comparison, then the individual product sets (Virtual Machines, AKS, Container Apps, Functions, Batch). Architecture guidance, not a single product root, drives the "specify components" task.
- Caching now spans two Redis sets: **Azure Managed Redis** (newer, Redis Enterprise based) and **Azure Cache for Redis** (established tiers). Both are valid; expect selection-style questions between them.
- Deployment automation is fragmented across Bicep, ARM templates, deployment stacks, Azure Pipelines, and GitHub Actions. **Bicep** is the primary IaC set to download first.
- Migration relies on **Cloud Adoption Framework** for strategy and **Azure Migrate** for tooling, with database and storage migration documented in their own product sets. The load balancing and connectivity tasks are best served by **Azure Architecture Center** decision guides rather than single product pages.
- Networking is broad: download Virtual Network, Azure Firewall, Front Door, Application Gateway, Load Balancer, VPN Gateway, ExpressRoute, Virtual WAN, and Private Link to cover the skill fully.
- Forum-discovery note: Public candidate discussions repeatedly highlight Front Door vs Application Gateway vs Traffic Manager vs Load Balancer selection, VPN Gateway vs ExpressRoute vs Virtual WAN, AKS vs Container Apps vs App Service, Functions hosting plans, Bicep vs ARM, and Azure Migrate assessment scenarios. All were validated against official documentation before inclusion.

---

## Final coverage audit

This map covers the full study guide hierarchy (4 domains, 11 skills, 41 tasks). The product families below were checked for representation; each appears under at least one directly relevant task.

- **Identity and governance:** Microsoft Entra ID, Conditional Access, authentication methods, Microsoft identity platform, managed identities, Entra ID Governance, PIM, access reviews, entitlement management, Application Proxy, hybrid identity, Azure RBAC, Azure Policy, management groups, resource groups, tags, Microsoft Defender for Cloud, Microsoft Purview.
- **Monitoring and operations:** Azure Monitor, Log Analytics, Application Insights, VM insights, Container insights, Network Watcher, Azure Advisor, diagnostic settings, activity log, data collection rules, Microsoft Entra monitoring and health.
- **Data and storage:** Azure SQL Database, SQL Managed Instance, SQL Server on Azure VMs, Azure Database for PostgreSQL, Azure Database for MySQL, Cosmos DB, Azure Storage, Blob, Files, Data Lake Storage, Azure NetApp Files, Data Factory, Synapse Analytics, Databricks, Data Explorer, Stream Analytics, Event Hubs, Event Grid, Service Bus, Microsoft Fabric.
- **Business continuity:** Azure Backup, Azure Site Recovery, Azure reliability, Well-Architected reliability guidance, availability zones, region pairs, storage redundancy, Azure SQL business continuity, Cosmos DB backup and multi-region distribution.
- **Compute and application architecture:** Virtual Machines, VM Scale Sets, availability sets, App Service, AKS, Container Apps, Container Instances, Functions, Batch, API Management, App Configuration, Key Vault, Azure Managed Redis, Service Bus, Event Grid, Event Hubs, Logic Apps, Bicep, ARM templates, deployment stacks.
- **Migration:** Cloud Adoption Framework, Azure Migrate, Database Migration Service, Azure Storage Mover, Data Box, Azure File Sync, App Service migration, Azure SQL migration, PostgreSQL/MySQL migration.
- **Networking:** Virtual Network, VPN Gateway, ExpressRoute, Virtual WAN, Azure DNS, Private DNS, Private Link, NAT Gateway, Azure Firewall, Firewall Manager, DDoS Protection, NSGs, ASGs, route tables/UDRs, Load Balancer, Application Gateway, Front Door, Traffic Manager, CDN, Network Watcher.

**Download-first recommendations.** For breadth per domain: Azure Monitor and the Microsoft Entra family (Domain 1); Azure SQL family and Azure Storage (Domain 2); Azure Backup, Azure Site Recovery, and Azure reliability (Domain 3); Azure Architecture Center decision guides, plus Virtual Network and the load-balancing product sets (Domain 4).
