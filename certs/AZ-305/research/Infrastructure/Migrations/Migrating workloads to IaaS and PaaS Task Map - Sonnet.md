## Domain: Design infrastructure solutions

### Skill: Design a migration solution

#### Task: Recommend a solution for migrating workloads to infrastructure as a service (IaaS) and platform as a service (PaaS)

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/> | The CAF Migrate methodology is the primary framework for this task. Covers the assess–deploy–release lifecycle, migration wave planning, and tooling selection. Exam questions consistently reference CAF as the design anchor for migration strategy. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/select-cloud-migration-strategy) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/select-cloud-migration-strategy> | Covers the migration strategy "Rs" (Rehost, Replatform, Refactor, Rearchitect, Replace, Retire, Retain). Directly supports the IaaS vs. PaaS decision — rehost maps to IaaS lift-and-shift; replatform and refactor map to PaaS modernization. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/) | <https://learn.microsoft.com/en-us/azure/migrate/> | Core service documentation for the task. Azure Migrate is the primary discovery, assessment, and migration hub for servers, databases, web apps, and containers targeting both IaaS and PaaS. Covers business case generation, readiness scoring, and sizing recommendations. |
| [Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/overview) | <https://learn.microsoft.com/en-us/azure/virtual-machines/overview> | Primary IaaS target for lift-and-shift migrations. Covers VM creation, sizing, availability sets, availability zones, and management considerations essential for workload migration design. |
| [Virtual Machine Scale Sets](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/) | <https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/> | Extends IaaS VM design with autoscaling and load-balanced VM groups. Relevant when migrated workloads require elastic scaling beyond a single VM. |
| [Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/) | <https://learn.microsoft.com/en-us/azure/app-service/> | Primary PaaS target for web application migration. Covers hosting tiers, deployment slots, migration assistant tooling, and compatibility assessment for ASP.NET and Java workloads moving from IIS to App Service. |
| [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/what-is-aks) | <https://learn.microsoft.com/en-us/azure/aks/what-is-aks> | PaaS container target relevant when the migration strategy involves containerizing existing apps (lift-and-shift to containers). Azure Migrate integrates with AKS for app containerization scenarios. |
| [Azure Database Migration Guides](https://learn.microsoft.com/en-us/data-migration/) | <https://learn.microsoft.com/en-us/data-migration/> | Covers migration paths for SQL Server, PostgreSQL, MySQL, and other databases to Azure PaaS targets (Azure SQL Database, Azure SQL Managed Instance, Azure Database for PostgreSQL/MySQL). Essential for PaaS database design decisions. |
| [Azure Database Migration Service](https://learn.microsoft.com/en-us/azure/dms/) | <https://learn.microsoft.com/en-us/azure/dms/> | Managed service for executing database migrations with minimal downtime. Supports migration from multiple on-premises database sources to Azure PaaS data platforms. Commonly paired with Azure Migrate in exam scenarios. |
| [Azure Storage migration guide](https://learn.microsoft.com/en-us/azure/storage/common/storage-migration-overview) | <https://learn.microsoft.com/en-us/azure/storage/common/storage-migration-overview> | Covers unstructured data migration to Azure Storage services (Blob, Files, Data Lake). Relevant when workload migration includes file or object storage components, which is common in both IaaS and PaaS scenarios. |
| [Cloud Adoption Framework — Ready methodology](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/> | Covers Azure landing zone design as the pre-migration environment preparation step. Establishing a landing zone is expected before migrating workloads in CAF-aligned designs. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/) | <https://learn.microsoft.com/en-us/azure/well-architected/> | Provides the five-pillar design lens (Reliability, Security, Cost Optimization, Operational Excellence, Performance Efficiency) applied when recommending IaaS vs. PaaS targets and tradeoffs during migration design. |

---

**Potentially relevant products considered:** Azure Migrate, Azure Virtual Machines, Virtual Machine Scale Sets, Azure App Service, Azure Kubernetes Service, Azure Container Instances, Azure SQL Database, Azure SQL Managed Instance, Azure Database Migration Service, Azure Database for PostgreSQL, Azure Database for MySQL, Azure Storage, Azure Data Box, Azure Storage Mover, Azure Site Recovery, Azure Backup, Cloud Adoption Framework, Azure Well-Architected Framework, Azure Landing Zones, Azure Arc, Azure VMware Solution.

**Products excluded after review:** Azure Site Recovery (primarily a business continuity tool; migration scenarios use Azure Migrate instead), Azure Container Instances (relevant for dev/test, not a primary migration target in exam scenarios), Azure Arc (relevant to hybrid management post-migration, not to the migration recommendation itself), Azure Data Box (relevant to offline/large-scale data migration, which is a separate task in the study guide).

---

**Forum-discovery note:** Public candidate discussions consistently highlight Azure Migrate, the CAF Migrate methodology, and the IaaS vs. PaaS decision framework as the highest-frequency topics in this domain. App Service migration tooling and database migration to Azure SQL targets appear frequently alongside server migration scenarios. These signals were validated against official Microsoft documentation before inclusion; no Reddit, forum, or unofficial links appear in the table.

---

**Coverage notes:**

- This task is **fragmented across multiple product documentation sets** rather than covered by a single root. The CAF Migrate methodology and Azure Migrate documentation are the two anchors; everything else supports the service-selection and tradeoff layer.
- **Download priority:** Start with the Cloud Adoption Framework (migrate methodology + strategy selection) and Azure Migrate documentation. These are the most exam-relevant for this specific task.
- **IaaS design coverage** is concentrated in Azure Virtual Machines and Virtual Machine Scale Sets. Both are well-documented with distinct parent sets.
- **PaaS design coverage** is split across App Service (web workloads), AKS (container workloads), and the database migration guides (data-tier workloads). Each represents a meaningfully different migration target.
- The **Azure Well-Architected Framework** and **CAF Ready methodology** provide the design governance layer expected in AZ-305 architecture recommendations and should be reviewed even though they are not migration-specific tools.
- **Azure SQL Managed Instance** is testable as a PaaS migration target for SQL Server workloads with near-full SQL Server compatibility. It is covered under the Azure Database Migration Guides link above, but candidates may also benefit from reviewing the [Azure SQL Managed Instance documentation](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview) separately.
