# Deep Technical Facts and Requirements for Recommend a solution for migrating workloads to IaaS and PaaS

## Scope

- **Exam:** AZ-305: Designing Microsoft Azure Infrastructure Solutions
- **Task:** Recommend a solution for migrating workloads to infrastructure as a service (IaaS) and platform as a service (PaaS)
- **Domain / skill:** Design infrastructure solutions → Design migrations
- **Source guide:** `Migrating workloads to IaaS and PaaS study guide - chatGPT v1.md`
- **Generator prompt:** `AZ-305 task fact sheet.prompt.md`
- **Product selection method:** Products and major topics were extracted from the provided study guide’s product discovery table, core documentation list, architecture patterns, exam tips, traps, and adjacent task notes. The facts below were then validated against official Microsoft Learn, Azure product documentation, Cloud Adoption Framework, Azure Architecture Center, and Well-Architected Framework documentation.
- **Generated:** 2026-06-01
- **Current-study-guide note:** Microsoft’s current AZ-305 study guide lists this task under **Design infrastructure solutions → Design migrations** and notes skills measured as of **April 17, 2026**.

## Product coverage summary

| Product / topic | Classification | Why it matters for this task |
|---|---|---|
| Cloud Adoption Framework migration methodology and strategies | Framework / methodology | Provides the rehost, replatform, refactor, rearchitect, rebuild, replace, retain, and retire decision language used in migration scenarios. |
| Azure Architecture Center compute and container selection | Architecture guidance | Helps choose between VMs, App Service, AKS, Container Apps, Functions, and other compute options based on workload requirements. |
| Azure Migrate | Core | Central hub for discovery, assessment, business case, dependency analysis, and migration execution. |
| Azure Migrate appliance | Core | Collects discovery, configuration, performance, inventory, and dependency data used for assessments and migration planning. |
| Azure Migrate server migration | Core | Supports rehosting VMware, Hyper-V, physical, and cloud-hosted servers to Azure VMs. |
| Azure Migrate dependency analysis | Core | Identifies server-to-server dependencies so migration waves do not break multi-tier applications. |
| Azure Migrate business case | Core | Produces cost and savings analysis that can change the target recommendation or sequencing. |
| Azure Virtual Machines | Core | Primary IaaS target when the workload requires OS control, legacy compatibility, or minimal change. |
| Azure Managed Disks | Supporting | Determines VM storage performance, durability, redundancy, and cost for rehosted workloads. |
| Azure App Service | Core | Primary PaaS target for compatible web apps, APIs, and mobile back ends. |
| App Service plans and App Service networking | Core / supporting | Plan tier, scaling behavior, VNet integration, and private endpoints affect whether App Service is viable. |
| Azure Kubernetes Service (AKS) | Core | PaaS container target when Kubernetes API, cluster control, orchestration, or platform extensibility is required. |
| Azure Container Apps | Core | Serverless container target when the workload needs containers without direct Kubernetes management. |
| Azure Functions | Adjacent / supporting | Modernization target for event-driven components rather than a whole-server migration destination. |
| Azure VMware Solution | Core | Migration target when VMware operational continuity, vSphere tooling, or fast data-center exit is mandatory. |
| VMware HCX | Core when AVS applies | Provides AVS migration mechanisms such as vMotion, bulk migration, and replication-assisted vMotion. |
| Azure landing zones | Core / supporting | Provides the subscription, network, identity, security, governance, and management foundation for repeatable migration. |
| ExpressRoute | Supporting | Provides private connectivity for migration traffic, hybrid dependencies, and AVS/native Azure connectivity. |
| VPN Gateway | Supporting | Provides encrypted site-to-site, point-to-site, and VNet-to-VNet connectivity when ExpressRoute is not required. |
| Azure Policy | Supporting | Enforces allowed regions, SKUs, tags, diagnostic settings, public access restrictions, and compliance guardrails. |
| Azure Monitor | Supporting | Provides post-cutover observability needed to validate and operate migrated workloads. |
| Microsoft Cost Management | Supporting | Tracks cost after migration and supports optimization decisions after initial landing. |
| Azure Database Migration Service | Adjacent | Relevant when an application workload’s database migration affects the IaaS/PaaS target decision. |
| Azure Data Box | Adjacent | Relevant when large offline data movement blocks or reshapes the workload migration plan. |
| Azure Arc-enabled servers | Supporting / adjacent | Helps manage retained or staged hybrid servers before, during, or after migration. |
| Azure Well-Architected Framework | Architecture guidance | Provides reliability, security, cost, operational excellence, and performance review lenses for target selection. |

---

## Cloud Adoption Framework migration methodology and strategies

**Classification:** Framework / methodology  
**Why it matters:** CAF provides the migration decision vocabulary used by AZ-305 scenario questions. It prevents a tool-first answer by forcing a strategy choice before selecting Azure Migrate, VMs, App Service, AKS, Container Apps, AVS, or SaaS.  
**Primary Microsoft source:** [Select your cloud migration strategies](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/select-cloud-migration-strategy)  
**Supporting Microsoft source:** [Plan your migration](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/plan-migration)

### Deep technical facts / requirements

1. CAF strategy selection is workload-specific; different applications in the same portfolio can legitimately use different strategies such as retire, retain, rehost, replatform, refactor, rearchitect, rebuild, or replace.
2. **Rehost** is a like-for-like migration pattern and usually maps to Azure VMs or AVS when the scenario requires speed, minimal change, or OS-level control.
3. **Replatform** modernizes the hosting environment without a complete rewrite; common AZ-305 targets include App Service, managed databases, Container Apps, and sometimes AKS.
4. **Refactor** changes application code to improve cloud fit, which makes it more appropriate when scalability, deployment velocity, or platform integration matters more than the fastest move.
5. **Rearchitect** changes the application’s architecture and is usually justified only when the current design blocks availability, scale, performance, or maintainability goals.
6. **Rebuild** is a cloud-native development path and is unlikely to be the right answer for a short data-center exit deadline unless the old system is unsuitable for migration.
7. **Replace** moves the capability to SaaS; it can be the right business answer even when the task wording includes IaaS/PaaS, but it is outside a workload-hosting migration if the scenario explicitly requires Azure-hosted compute.
8. **Retire** is an explicit strategy; unused workloads should not be migrated simply because they appear in discovery.
9. A migration plan should group workloads into waves based on business priority, dependencies, complexity, risk, and readiness rather than by server list alone.
10. CAF strategy selection should happen before migration execution; choosing Azure Migrate or HCX does not by itself answer whether the workload should be rehosted, replatformed, modernized, retained, or retired.

### AZ-305 exam discriminator

Use CAF when the question asks **which migration approach** best satisfies a business driver. Use a specific Azure service only after the strategy is clear.

### Common trap

Treating all migrations as lift-and-shift. AZ-305 often rewards selecting the lowest-change option that satisfies the requirement, but not when the requirement clearly asks for managed operations, modernization, or reduced infrastructure responsibility.

---

## Azure Architecture Center compute and container selection

**Classification:** Architecture guidance  
**Why it matters:** Compute guidance helps distinguish VMs, App Service, AKS, Container Apps, Functions, and other hosting services based on control, operational burden, workload model, and scaling behavior.  
**Primary Microsoft source:** [Choose an Azure compute service](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree)  
**Supporting Microsoft sources:** [Use PaaS options](https://learn.microsoft.com/en-us/azure/architecture/guide/design-principles/managed-services), [Choose an Azure container service](https://learn.microsoft.com/en-us/azure/architecture/guide/choose-azure-container-service)

### Deep technical facts / requirements

1. Compute selection is not only a runtime choice; it also determines who manages OS patching, runtime updates, scaling, networking, deployment, and platform availability.
2. VMs are appropriate when the workload needs full OS control, privileged agents, custom drivers, vendor software, domain join, unsupported runtimes, or minimal change from the current architecture.
3. App Service is preferable for compatible web apps and APIs when the requirement is managed web hosting, reduced patching, deployment slots, integrated TLS, and platform scaling.
4. AKS is appropriate when Kubernetes itself is a requirement: Kubernetes APIs, custom controllers, custom ingress, service mesh, namespace models, platform team operations, or existing Kubernetes manifests.
5. Container Apps is appropriate when the application can run in containers but the requirement is serverless containers, event-driven scale, jobs, or avoiding direct Kubernetes cluster management.
6. Functions is a modernization target for event-driven components, not usually a direct replacement for a full multi-tier server workload.
7. PaaS choices reduce infrastructure operations but impose platform constraints around runtime support, networking, file system behavior, startup model, scaling boundaries, and deployment methods.
8. Container service selection should consider whether the workload needs orchestration primitives, direct Kubernetes API access, revision traffic splitting, event triggers, stateful storage, and cluster-level controls.
9. Exam scenarios often encode the compute choice through operational clues: “avoid OS patching” points away from VMs, while “install custom Windows service” points away from App Service.
10. The better architecture answer is normally the simplest Azure service that satisfies mandatory constraints, not the most flexible service.

### AZ-305 exam discriminator

Use this guidance when answer choices include multiple compute targets and the scenario contains clues about runtime, control, operations, scaling, or containers.

### Common trap

Choosing AKS just because an application uses containers. If the scenario does not require Kubernetes control, Container Apps or App Service for containers may be a better fit.

---

## Azure Migrate

**Classification:** Core  
**Why it matters:** Azure Migrate is the planning and execution hub for discovery, readiness, right-sizing, cost estimation, dependency analysis, and migration tracking across common workload types.  
**Primary Microsoft source:** [What is Azure Migrate?](https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview)

### Deep technical facts / requirements

1. Azure Migrate supports discovery, assessment, migration, and modernization for servers, databases, web apps, virtual desktops, and large-scale offline data migration through Data Box.
2. Azure Migrate is a free service, but partner migration tools or target Azure resources can still create charges.
3. Azure Migrate should be recommended when the scenario asks for Azure readiness, right-sizing, dependency analysis, migration planning, business case, or migration execution.
4. Azure Migrate can assess IaaS and PaaS targets, so it is not limited to VM rehost planning.
5. Server assessments can evaluate Azure readiness, VM sizing, cost estimation, and AVS node estimates depending on assessment type and collected data.
6. Azure Migrate Discovery and assessment discovers on-premises servers running on VMware, Hyper-V, and physical servers before migration to Azure.
7. Azure Migrate and Modernize migrates VMware VMs, Hyper-V VMs, physical servers, other virtualized servers, and public cloud VMs to Azure.
8. For VMware, Azure Migrate supports agentless or agent-based migration; the agentless option uses the same appliance used for discovery and assessment.
9. For Hyper-V migration, Azure Migrate uses provider agents installed on the Hyper-V host.
10. For physical servers and servers from other public clouds, Azure Migrate treats the source as a physical server and uses a replication appliance.
11. Azure Migrate can assess and migrate ASP.NET web apps hosted on Windows in a VMware environment to App Service using an agentless approach.
12. The Azure Migrate hub integrates related tools such as Data Migration Assistant and Azure Database Migration Service, but database migration is a separate AZ-305 task unless it changes the workload target.

### AZ-305 exam discriminator

Choose Azure Migrate for **assessment and migration planning**; choose VMs, App Service, AKS, Container Apps, or AVS for the **target platform**.

### Common trap

Answering “Azure Migrate” when the question asks for the final hosting destination. Azure Migrate plans and executes migration; it is not itself the steady-state hosting platform.

---

## Azure Migrate appliance

**Classification:** Core  
**Why it matters:** The appliance is the source-environment data collector that makes assessment quality possible. Without accurate discovery and performance data, target sizing and migration grouping are guesswork.  
**Primary Microsoft source:** [Azure Migrate appliance](https://learn.microsoft.com/en-us/azure/migrate/migrate-appliance)

### Deep technical facts / requirements

1. The Azure Migrate appliance is deployed in the source environment and continuously sends discovered configuration and performance metadata to Azure Migrate.
2. Microsoft recommends the appliance-based discovery approach for most migration assessments because it supports ongoing discovery rather than a one-time static inventory.
3. Appliance-collected performance data supports performance-based sizing, which can right-size target Azure VMs instead of using overprovisioned on-premises allocations.
4. For agentless VMware server migration, the Azure Migrate and Modernize tool uses the same appliance that is used for discovery and assessment.
5. The appliance is used to discover VMware, Hyper-V, physical, and other server environments, but the setup workflow and prerequisites differ by source type.
6. The appliance requires credentials with enough permission to discover inventory, collect metadata, and perform deeper discovery such as software inventory or dependency analysis where enabled.
7. Discovery quality affects the business case, readiness assessment, sizing recommendation, dependency map, and migration wave plan.
8. In restricted networks, Azure Migrate Collector can be considered for snapshot discovery when continuous appliance connectivity is not feasible, but this provides a different discovery model.
9. The appliance is not the same as the replication appliance used for agent-based physical/cloud server migrations.
10. Appliance deployment should be planned as part of landing zone and network readiness because it must communicate with Azure Migrate service endpoints.

### AZ-305 exam discriminator

When the scenario needs **continuous discovery, performance-based sizing, or dependency-aware assessment**, use the Azure Migrate appliance rather than spreadsheet inventory alone.

### Common trap

Assuming imported CMDB or manual server inventory is enough for migration sizing. For AZ-305, performance and dependency data can change the recommended target and migration wave.

---

## Azure Migrate server migration

**Classification:** Core  
**Why it matters:** Server migration is the primary rehost path when the answer is native Azure IaaS rather than PaaS or AVS.  
**Primary Microsoft source:** [Azure Migrate server migration overview](https://learn.microsoft.com/en-us/azure/migrate/server-migrate-overview)

### Deep technical facts / requirements

1. Azure Migrate supports server migration from VMware, Hyper-V, physical servers, other virtualized servers, and public cloud VMs.
2. Agentless VMware migration uses the Azure Migrate appliance; agent-based migration uses a replication appliance.
3. Hyper-V migration uses provider agents installed on Hyper-V hosts, which is a source-platform difference from VMware agentless migration.
4. Physical servers and cloud-hosted VMs are migrated by treating them as physical servers and using a replication appliance.
5. Test migration should be performed before production cutover to validate boot, connectivity, application behavior, security controls, and performance.
6. Server migration is aligned with rehost scenarios where the workload’s OS, application architecture, and operational model remain mostly intact.
7. Server migration does not automatically modernize the application; post-migration work is still required for patching, monitoring, backup, cost optimization, and security hardening.
8. Rehosted VMs require target designs for VM size, managed disk type, network placement, DNS, identity, availability, backup, monitoring, and update management.
9. Azure Migrate can reduce downtime and risk through replication and planned cutover, but the application’s consistency and cutover validation still matter.
10. Server migration is usually not the right answer when the scenario explicitly requires removing guest OS management, using managed runtime hosting, or scaling an app independently as PaaS.

### AZ-305 exam discriminator

Use server migration when the workload needs **minimal changes and OS-level control**. Use PaaS migration when the scenario emphasizes **managed operations** and platform compatibility.

### Common trap

Thinking server migration is a universal migration answer. It is strong for rehost, but weak when the business requirement is modernization or reduced infrastructure management.

---

## Azure Migrate dependency analysis

**Classification:** Core  
**Why it matters:** Dependency analysis identifies which servers communicate and should often move together, reducing outage risk during cutover.  
**Primary Microsoft source:** [Dependency analysis in Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/concepts-dependency-visualization)

### Deep technical facts / requirements

1. Dependency analysis identifies dependencies between discovered on-premises servers or Azure VMware Solution servers.
2. It helps form more accurate assessment groups by showing which servers are part of an application deployment.
3. It can reveal servers that must migrate together to avoid post-cutover connectivity failures.
4. It can also identify unused servers that might be retired instead of migrated.
5. Agentless dependency analysis captures TCP connection data without installing agents on servers.
6. Agentless dependency analysis is generally available for VMware VMs, Hyper-V VMs, bare-metal servers, and servers running in other public clouds such as AWS and GCP.
7. Agentless polling gathers TCP connection data every five minutes and sends processed data to Azure Migrate every six hours.
8. Agent-based dependency analysis uses the Service Map solution in Azure Monitor and requires the Microsoft Monitoring Agent / Log Analytics agent and Dependency Agent on each server.
9. Agent-based dependency analysis provides additional information such as connection count, latency, and data transfer information that can be queried in Log Analytics.
10. Agentless dependency map data can be viewed over one hour to 30 days and exported as CSV; agent-based maps have different visualization and query characteristics.
11. Agent-based analysis requires a Log Analytics workspace in a supported region, while agentless analysis does not require Log Analytics.

### AZ-305 exam discriminator

If the scenario says **application dependencies are unknown**, **migration waves are uncertain**, or **surprise outages must be avoided**, dependency analysis is a key requirement before migration.

### Common trap

Migrating servers in isolation because each VM assessment says “ready.” A technically ready VM can still fail after cutover if its application dependencies did not move or route correctly.

---

## Azure Migrate business case

**Classification:** Core  
**Why it matters:** A business case can change whether the recommended path is rehost, replatform, right-size, retire, or delay based on cost and modernization potential.  
**Primary Microsoft source:** [Business Case in Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/concepts-business-case-calculation)

### Deep technical facts / requirements

1. Azure Migrate business case estimates on-premises versus Azure cost and savings to support migration decision-making before execution.
2. Business case output includes total cost of ownership comparison, cash-flow comparison, utilization-based insights, and potential OpEx impact.
3. Business case analysis can identify overprovisioned workloads that should be right-sized instead of moved like-for-like.
4. Business case analysis can identify modernization opportunities where a PaaS or managed database target may produce better cost or operational outcomes than rehost.
5. Business case results depend on discovery and performance data quality; stale inventory can produce misleading cost recommendations.
6. Business case recommendations should be combined with technical requirements such as compliance, latency, OS support, runtime compatibility, and operational skills.
7. Cost savings alone should not override a hard requirement for OS control, custom agents, or vendor support.
8. Business case is most valuable before migration waves begin, not after cutover, because it informs target selection and sequencing.
9. The tool supports cloud migration planning, but actual cost after cutover must still be tracked through Microsoft Cost Management.
10. Business case analysis can help justify retiring unused servers discovered during dependency analysis rather than migrating them.

### AZ-305 exam discriminator

If the scenario asks for **cost comparison**, **right-sizing**, **TCO**, **business justification**, or **CapEx-to-OpEx analysis**, recommend Azure Migrate business case.

### Common trap

Assuming performance-based right-sizing is safe without understanding peak usage, compliance boundaries, or application-specific performance requirements.

---

## Azure Virtual Machines

**Classification:** Core  
**Why it matters:** Azure VMs are the default native Azure IaaS landing target when the workload must preserve OS-level control or migrate with minimal application change.  
**Primary Microsoft source:** [Overview of virtual machines in Azure](https://learn.microsoft.com/en-us/azure/virtual-machines/overview)

### Deep technical facts / requirements

1. Azure VMs provide virtualization without managing physical hardware, but the customer remains responsible for the guest OS, installed software, runtime stack, patching approach, and workload configuration.
2. VMs are appropriate for packaged vendor applications, legacy runtimes, custom Windows services, custom agents, domain-joined workloads, and applications that cannot fit PaaS constraints.
3. VM selection must include VM family, CPU/memory size, disk type, network placement, availability model, backup, monitoring, and security baseline.
4. Rehosting to VMs minimizes application change but can preserve technical debt, inefficient sizing, and manual operations.
5. Azure Migrate performance-based assessment should be used when on-premises servers are overprovisioned; like-for-like sizing can overstate cost.
6. VM workloads that need high availability require explicit architecture choices such as availability zones, availability sets, load balancing, disk redundancy, and application-level redundancy.
7. VM workloads that require Active Directory usually need hybrid identity, domain controller placement, DNS resolution, and network routing designed before cutover.
8. VM migration does not remove the need for patching; Azure Update Manager or an enterprise patching solution should be included in operations design.
9. VM workloads should be integrated with Azure Backup, Azure Monitor, Defender for Cloud, and Azure Policy after migration.
10. VMs are usually not the best target for a compatible web app when the main requirement is reduced server management and platform scaling.
11. Native Azure VMs are different from AVS: VMs use Azure IaaS operations, while AVS preserves the VMware operational model.

### AZ-305 exam discriminator

Choose VMs when the scenario says **same OS**, **custom software**, **legacy dependency**, **no code changes**, **server-level access**, or **fast lift-and-shift**.

### Common trap

Choosing App Service for a workload that requires Windows Server domain join, arbitrary installed services, custom drivers, or full server control.

---

## Azure Managed Disks

**Classification:** Supporting  
**Why it matters:** Disk type and redundancy affect performance, availability, migration sizing, and cost for rehosted VM workloads.  
**Primary Microsoft source:** [Overview of Azure Disk Storage](https://learn.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview)

### Deep technical facts / requirements

1. Managed disks are Azure-managed block-level storage volumes used with Azure VMs, so they are central to IaaS migration performance and reliability.
2. Disk SKU selection affects IOPS, throughput, latency, cost, and workload suitability.
3. Premium SSD, Premium SSD v2, Ultra Disk, Standard SSD, and Standard HDD serve different performance and cost requirements.
4. Ultra Disk and Premium SSD v2 are candidates for high-performance workloads but have feature, region, availability, and redundancy considerations that must be checked before recommendation.
5. Disk redundancy choices such as locally redundant storage and zone-redundant storage affect durability and zone failure tolerance.
6. OS disks and data disks should be sized and tiered based on workload behavior, not only source disk capacity.
7. Azure Migrate assessment can help size disks based on performance data, which is often more cost-effective than copying source allocation.
8. Shared disks and application-level clustering requirements can influence whether a VM rehost is feasible or needs redesign.
9. Disk performance can be limited by both disk SKU and VM size, so increasing disk tier alone may not fix throughput or IOPS limits.
10. Managed disks are an IaaS concern; choosing App Service, Container Apps, or Functions shifts most underlying disk management away from the workload team.

### AZ-305 exam discriminator

Use managed disk details when answer choices distinguish **VM storage performance**, **cost**, **zone resiliency**, or **legacy clustering** requirements.

### Common trap

Sizing Azure disks only by source disk size. Performance-based sizing and redundancy requirements are usually more important.

---

## Azure App Service

**Classification:** Core  
**Why it matters:** App Service is the primary PaaS target for compatible web apps and APIs when the scenario emphasizes managed hosting and reduced infrastructure operations.  
**Primary Microsoft source:** [Overview of Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/overview)

### Deep technical facts / requirements

1. App Service hosts web apps, REST APIs, and mobile back ends on a managed platform, reducing the need to manage servers and OS patching.
2. App Service is a strong target for compatible ASP.NET, Java, Node.js, Python, PHP, and container-based web applications, depending on supported runtimes and platform constraints.
3. App Service is not a general-purpose VM replacement; workloads requiring arbitrary OS customization, Windows Server domain join, custom drivers, or persistent local server assumptions may not fit.
4. Deployment slots can support staged deployment and swap patterns, which can be valuable during migration validation and cutover.
5. App Service integrates with managed identities, custom domains, TLS, diagnostics, autoscale, and Application Insights, which can reduce post-migration operational burden.
6. App Service supports VNet integration for outbound access to network resources, but inbound private access requires private endpoints or App Service Environment-style designs.
7. Apps using local file system state, long-running background processes, or machine-specific configuration may need refactoring before App Service is viable.
8. If the scenario requires independent scaling between apps, they should not be placed in the same overloaded App Service plan.
9. If the app is compatible and the requirement is to reduce patching and server management, App Service is usually a better answer than rehosting to VMs.
10. Azure Migrate can assess and migrate certain web apps to App Service, but compatibility must still be validated.

### AZ-305 exam discriminator

Choose App Service when the scenario says **web app**, **API**, **managed platform**, **reduced server management**, **deployment slots**, or **PaaS hosting** and no hard OS-control requirement exists.

### Common trap

Assuming every IIS-hosted application can move unchanged to App Service. Dependencies, runtime support, networking, local file behavior, and background services can block a direct replatform.

---

## App Service plans and App Service networking

**Classification:** Core / supporting  
**Why it matters:** App Service feasibility often depends on plan tier, scaling model, feature availability, subnet sizing, outbound routing, and private inbound access.  
**Primary Microsoft source:** [Azure App Service plans](https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans)  
**Supporting Microsoft sources:** [App Service VNet integration](https://learn.microsoft.com/en-us/azure/app-service/overview-vnet-integration), [Private endpoints for App Service](https://learn.microsoft.com/en-us/azure/app-service/overview-private-endpoint)

### Deep technical facts / requirements

1. Every App Service app runs in an App Service plan, and the plan defines OS, region, VM instance count, VM size, and pricing tier.
2. Apps in the same App Service plan share the same compute resources and scale together.
3. Deployment slots, WebJobs, diagnostic logging, and backups consume CPU and memory from the same App Service plan workers.
4. Free and Shared tiers are for development and testing and cannot scale out; production workloads usually require dedicated tiers or higher.
5. Dedicated compute tiers charge per VM instance in the plan regardless of how many apps are hosted on the plan.
6. Isolate an app in a separate plan when it is resource-intensive, needs independent scaling, or requires resources in a different region.
7. VNet integration allows outbound access from the app to a virtual network, peered VNets, ExpressRoute-connected resources, service endpoint-secured services, and private endpoint-enabled services.
8. VNet integration does not provide inbound private access to the app; use private endpoints for private inbound access.
9. VNet integration requires a delegated subnet and consumes one IP address per App Service plan instance; scaling and platform upgrades require spare subnet capacity.
10. Microsoft recommends allocating enough integration subnet space for planned maximum scale and platform upgrades; subnet sizing can become a migration blocker if undersized.
11. NAT Gateway can be used with VNet integration to provide dedicated outbound IPs and mitigate SNAT exhaustion.
12. App Service plan selection is both a feature decision and a cost decision because tier affects autoscale, deployment slots, backups, custom domains/TLS, isolation, and limits.

### AZ-305 exam discriminator

If the scenario contains **private access**, **hybrid dependencies**, **independent scaling**, **plan tier**, **cost sharing**, or **subnet sizing**, the App Service plan/networking details can change the answer.

### Common trap

Confusing App Service VNet integration with private inbound access. VNet integration is outbound; private endpoints are for inbound private access.

---

## Azure Kubernetes Service (AKS)

**Classification:** Core  
**Why it matters:** AKS is the Azure container platform when Kubernetes control, extensibility, and orchestration are explicit requirements.  
**Primary Microsoft source:** [What is Azure Kubernetes Service?](https://learn.microsoft.com/en-us/azure/aks/what-is-aks)  
**Supporting Microsoft sources:** [AKS core concepts](https://learn.microsoft.com/en-us/azure/aks/core-aks-concepts), [AKS networking concepts](https://learn.microsoft.com/en-us/azure/aks/concepts-network)

### Deep technical facts / requirements

1. AKS provides managed Kubernetes, but the customer still designs and operates node pools, workloads, networking, ingress, identity, secrets, policies, and upgrades.
2. AKS is the right choice when the scenario requires Kubernetes APIs, existing Kubernetes manifests, custom controllers, service mesh, custom ingress, namespaces, or cluster-level extensibility.
3. AKS can run multiple node pools, allowing workloads with different CPU, memory, OS, GPU, or isolation requirements to run in the same cluster design.
4. AKS networking decisions affect IP consumption, routing, load balancing, network policy, ingress, egress, and private cluster behavior.
5. AKS workload identity and managed identities can reduce secrets usage for applications accessing Azure resources.
6. AKS requires a platform operations model for cluster upgrades, node image updates, monitoring, policy, container security, ingress certificates, and workload reliability.
7. AKS is usually overkill for simple containerized APIs or background workers that do not require Kubernetes control.
8. AKS should be paired with Azure Monitor for containers and Defender for Containers when production observability and security posture are required.
9. Stateful workloads on AKS require storage planning; migration candidates with complex persistent state may need redesign or managed database/storage services.
10. Private AKS clusters, egress restrictions, network policy, and ingress design can be exam clues for regulated or isolated workloads.
11. AKS gives more control than Container Apps but also more operational responsibility.

### AZ-305 exam discriminator

Choose AKS when the scenario says **Kubernetes**, **custom controllers**, **cluster-level extensibility**, **existing Kubernetes platform**, **service mesh**, or **orchestrator control**.

### Common trap

Choosing AKS as a default container target. If the requirement says “containers without managing Kubernetes,” Container Apps is usually the better answer.

---

## Azure Container Apps

**Classification:** Core  
**Why it matters:** Container Apps is the PaaS/serverless container target when the workload can run in containers but the organization does not need to manage Kubernetes directly.  
**Primary Microsoft source:** [Azure Container Apps overview](https://learn.microsoft.com/en-us/azure/container-apps/overview)  
**Supporting Microsoft sources:** [Container Apps environments](https://learn.microsoft.com/en-us/azure/container-apps/environment), [Scaling in Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/scale-app), [Jobs in Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/jobs), [Dapr in Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/dapr-overview)

### Deep technical facts / requirements

1. Container Apps runs containerized applications on a serverless platform and abstracts direct Kubernetes cluster management.
2. It is suited for HTTP APIs, microservices, background workers, event-driven processing, and containerized jobs.
3. Container Apps uses revisions as immutable snapshots of the app configuration and template; changes to scaling rules can create new revisions.
4. Scaling is configured through declarative rules and uses KEDA for event-driven scaling.
5. Scale rules can be HTTP, TCP, or custom/event-driven rules, including Azure Service Bus, Event Hubs, Apache Kafka, Redis, CPU, and memory.
6. Container Apps can scale to zero when minimum replicas are set to zero, which is useful for bursty or event-driven workloads.
7. Container Apps jobs are appropriate for tasks that start, run to completion, and exit, rather than continuously running services.
8. Dapr integration can simplify microservice concerns such as service invocation, pub/sub, bindings, and state abstractions, but it also adds platform design considerations.
9. Container Apps environments are security and networking boundaries for groups of apps, and networking mode affects ingress and private access design.
10. Container Apps is not the right target when the workload requires direct Kubernetes API access, cluster-level customization, custom controllers, or a managed node-pool model.
11. Container Apps supports managed identity for scale-rule authentication to Azure resources, reducing the need to store connection-string secrets.

### AZ-305 exam discriminator

Choose Container Apps when the scenario says **serverless containers**, **event-driven scaling**, **jobs**, **microservices without cluster management**, or **avoid Kubernetes operations**.

### Common trap

Choosing Container Apps for a workload that requires direct Kubernetes ecosystem integration. In that case, AKS is usually required.

---

## Azure Functions

**Classification:** Adjacent / supporting  
**Why it matters:** Functions can modernize event-driven parts of a workload, but it is not usually the direct target for an entire migrated server or web application.  
**Primary Microsoft source:** [Azure Functions overview](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview)

### Deep technical facts / requirements

1. Azure Functions is suited to event-driven code triggered by HTTP requests, queues, timers, events, and other bindings.
2. Functions can be a refactor target for background tasks, scheduled jobs, queue processing, and event handlers discovered during workload migration.
3. Functions reduces server management but introduces constraints around execution model, runtime, triggers, bindings, hosting plan, cold start behavior, and state management.
4. Workloads that require long-running processes, persistent local state, or full OS control are usually not good direct candidates for Functions.
5. Durable Functions can model stateful orchestrations, but that is a redesign choice, not a lift-and-shift migration path.
6. Functions can run in an App Service plan or other hosting plans, which affects cost, scaling behavior, networking, and runtime availability.
7. Functions should be evaluated alongside App Service and Container Apps when only part of an application needs event-driven modernization.
8. Functions is adjacent to this task because the core decision is IaaS/PaaS workload hosting; Functions becomes relevant when the scenario includes event-driven components.

### AZ-305 exam discriminator

Choose Functions only when the scenario points to **event-driven code units**, **queue processing**, **scheduled jobs**, or **serverless component modernization**.

### Common trap

Trying to migrate an entire VM-hosted application to Functions because the word “serverless” appears. Functions usually requires decomposition.

---

## Azure VMware Solution

**Classification:** Core  
**Why it matters:** AVS is the Azure landing option for VMware estates when the organization must preserve VMware tooling and operational patterns during migration.  
**Primary Microsoft source:** [Azure VMware Solution introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)

### Deep technical facts / requirements

1. Azure VMware Solution provides VMware private clouds running on dedicated Azure infrastructure.
2. AVS lets organizations use familiar VMware technologies such as vSphere, vCenter, vSAN, NSX-T, and HCX in Azure.
3. AVS is a strong fit for data-center exit, VMware estate consolidation, operational continuity, and workloads that are difficult to replatform immediately.
4. AVS is not a native Azure PaaS modernization target; applications generally remain VMware workloads after migration.
5. AVS requires network planning for connectivity between on-premises VMware, AVS, and native Azure virtual networks.
6. ExpressRoute is a key AVS connectivity mechanism for private connectivity between AVS and Azure/on-premises designs.
7. AVS can be a transitional landing zone: migrate quickly to AVS first, then modernize selected workloads to native Azure VMs or PaaS later.
8. AVS requires capacity, node, storage, and cost planning because it uses dedicated infrastructure rather than per-VM native Azure billing.
9. Workloads that can be directly replatformed to App Service, Container Apps, or managed databases may not justify AVS unless VMware continuity is a hard requirement.
10. Shared management models often apply to AVS landing zones: platform teams manage the AVS platform while application teams operate applications on top.

### AZ-305 exam discriminator

Choose AVS when the scenario says **retain VMware tooling**, **use vSphere operations**, **migrate VMware estate quickly**, **minimize replatforming**, or **HCX**.

### Common trap

Treating AVS as modernization. AVS preserves VMware operations; it does not automatically reduce guest OS or application management.

---

## VMware HCX

**Classification:** Core when AVS applies  
**Why it matters:** HCX provides the migration mechanisms used to move VMware workloads into AVS while preserving VMware operations.  
**Primary Microsoft source:** [Migration considerations with VMware HCX](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)  
**Supporting Microsoft source:** [Configure VMware HCX in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)

### Deep technical facts / requirements

1. HCX is used with Azure VMware Solution to migrate VMware workloads from on-premises vSphere environments to AVS.
2. HCX migration options include cold migration, bulk migration, HCX vMotion, and replication-assisted vMotion.
3. Cold migration can be used when downtime is acceptable; live or replication-assisted options are used when downtime must be reduced.
4. Bulk migration is useful for moving multiple VMs in waves, but cutover planning and network dependencies still matter.
5. HCX requires site pairing between the source environment and the AVS private cloud.
6. HCX configuration includes network profiles, compute profiles, and service mesh setup.
7. Migration planning must include L2 extension or network cutover decisions where workload IP retention or minimal change is required.
8. HCX does not decide whether a workload should be modernized; it moves VMware workloads to AVS.
9. HCX design depends on bandwidth, latency, firewall rules, DNS, vCenter connectivity, and operational readiness.
10. After HCX migration, workloads still need backup, monitoring, security, patching, and cost management in the AVS operating model.

### AZ-305 exam discriminator

Use HCX when the scenario is specifically about **VMware-to-AVS migration method** and mentions downtime, vMotion, bulk migration, or preserving VMware mobility.

### Common trap

Choosing HCX for native Azure VM rehosting. HCX is for VMware migration to AVS, not standard Azure VM migration.

---

## Azure landing zones

**Classification:** Core / supporting  
**Why it matters:** Landing zones provide the repeatable Azure foundation that must exist before enterprise migration waves can safely land workloads.  
**Primary Microsoft source:** [What is an Azure landing zone?](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/)  
**Supporting Microsoft source:** [Prepare your landing zone for migration](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/ready-azure-landing-zone)

### Deep technical facts / requirements

1. An Azure landing zone provides a standardized, scalable foundation for Azure environments aligned to security, compliance, and operational efficiency.
2. Landing zone design areas include billing and tenant, identity and access management, management group and subscription organization, network topology and connectivity, security, management, governance, and platform automation/DevOps.
3. Platform landing zones host shared services such as identity, connectivity, and management.
4. Application landing zones host workload resources and can be separated by application, environment, scale, compliance boundary, or subscription limit needs.
5. Migration readiness tasks include establishing hybrid connectivity, preparing identity, enabling hybrid DNS, configuring firewall rules, routing, management, monitoring, and governance.
6. Many migration workloads remain domain-joined, so domain controllers, Active Directory sites, DNS, and hybrid identity should be ready before cutover.
7. Hybrid DNS is a common blocker; workloads in Azure must resolve on-premises names and on-premises resources may need to resolve Azure private names.
8. Hub firewall rules must be prepared before migration because Azure Firewall and many NVAs deny traffic until explicit allow rules exist.
9. Azure landing zones can use hub-spoke or Virtual WAN network topology depending on enterprise scale and connectivity model.
10. Landing zones should be deployed and managed with Infrastructure as Code where possible to support repeatability and governance.
11. Migration at scale should not start with ad hoc workload subscriptions; subscription vending and policy inheritance help ensure consistent controls.

### AZ-305 exam discriminator

Choose landing zone readiness when the scenario mentions **enterprise scale**, **repeatable migration waves**, **central connectivity**, **shared services**, **policy guardrails**, **DNS**, **identity**, or **governance**.

### Common trap

Treating landing zones as optional post-migration cleanup. For enterprise migrations, landing zone readiness often comes before workload migration.

---

## ExpressRoute

**Classification:** Supporting  
**Why it matters:** ExpressRoute provides private connectivity for high-volume migration traffic, hybrid application dependencies, and AVS/native Azure connectivity.  
**Primary Microsoft source:** [Azure ExpressRoute overview](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction)

### Deep technical facts / requirements

1. ExpressRoute provides private connectivity between on-premises infrastructure and Microsoft cloud services through a connectivity provider, not over the public internet.
2. ExpressRoute commonly supports migration scenarios that require predictable private connectivity, high bandwidth, low latency, or ongoing hybrid dependencies.
3. ExpressRoute uses BGP for dynamic routing between customer networks and Microsoft edge routers.
4. ExpressRoute is not encrypted by default in the same way as an IPsec VPN tunnel; encryption requirements must be addressed separately if needed.
5. ExpressRoute can coexist with VPN Gateway, often using VPN as a backup or supplemental path.
6. ExpressRoute circuit bandwidth, peering, routing, provider, and gateway SKU choices affect migration throughput and hybrid connectivity performance.
7. ExpressRoute is especially relevant for AVS because AVS relies heavily on private connectivity patterns between on-premises VMware, AVS, and Azure.
8. ExpressRoute does not remove the need for DNS, firewall rules, routing design, or identity planning.
9. ExpressRoute is usually excessive for small migrations or dev/test connectivity where encrypted site-to-site VPN satisfies requirements.
10. ExpressRoute costs include circuit/provider charges and Azure gateway/egress considerations, so it must be justified by the migration and hybrid requirements.

### AZ-305 exam discriminator

Choose ExpressRoute when the scenario says **private connectivity**, **predictable bandwidth**, **large migration traffic**, **hybrid enterprise connectivity**, or **AVS connectivity**.

### Common trap

Assuming ExpressRoute automatically encrypts traffic or automatically fixes application latency. It provides private connectivity, but architecture still controls encryption, routing, and performance.

---

## VPN Gateway

**Classification:** Supporting  
**Why it matters:** VPN Gateway is the common encrypted connectivity option for site-to-site, point-to-site, and VNet-to-VNet migration connectivity when ExpressRoute is not required.  
**Primary Microsoft source:** [What is Azure VPN Gateway?](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways)

### Deep technical facts / requirements

1. VPN Gateway sends encrypted traffic between Azure virtual networks and on-premises locations over the public internet.
2. VPN Gateway supports site-to-site IPsec/IKE tunnels for cross-premises connectivity.
3. VPN Gateway supports point-to-site VPN using OpenVPN, IKEv2, or SSTP for remote client access.
4. VPN Gateway can support VNet-to-VNet encrypted connectivity between Azure virtual networks.
5. Multiple connections can be created to the same VPN gateway, but all tunnels share the gateway’s available bandwidth.
6. Gateway SKU selection affects throughput, tunnel counts, point-to-site connection limits, BGP support, zone redundancy, and production suitability.
7. VPN Gateway can be deployed zone-redundantly using supported AZ SKUs to improve gateway resiliency.
8. Site-to-site VPN can serve as a failover path for ExpressRoute in coexistence designs.
9. VPN Gateway is often appropriate for dev/test, small-to-medium production workloads, or initial migration connectivity where ExpressRoute is unnecessary.
10. VPN Gateway costs include hourly gateway compute and egress data transfer.

### AZ-305 exam discriminator

Choose VPN Gateway when the scenario requires **encrypted hybrid connectivity** and does not require the private, provider-based connectivity of ExpressRoute.

### Common trap

Choosing VPN Gateway for very high-throughput migration or AVS enterprise connectivity requirements where ExpressRoute is a better fit.

---

## Azure Policy

**Classification:** Supporting  
**Why it matters:** Azure Policy enforces migration guardrails so workloads land in compliant regions, SKUs, network configurations, and logging/security baselines.  
**Primary Microsoft source:** [Overview of Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview)

### Deep technical facts / requirements

1. Azure Policy enforces organizational standards and assesses compliance at scale.
2. Common migration guardrails include allowed regions, required tags, diagnostic settings, public network restrictions, allowed SKUs, and encryption requirements.
3. Policy definitions can be grouped into initiatives for easier assignment and compliance tracking.
4. Policy assignments can target management groups, subscriptions, resource groups, or individual resources, with exclusions where necessary.
5. Azure Policy evaluates resources on create/update, assignment changes, policy changes, and regular compliance evaluation.
6. Policy effects can deny, audit, modify, deploy related resources, append settings, or block actions depending on definition type.
7. Azure Policy is not the same as Azure RBAC: RBAC controls who can perform actions, while Policy controls whether the resulting resource state complies with rules.
8. `deployIfNotExists` and `modify` policy effects require managed identity permissions for remediation.
9. Azure Policy can remediate existing noncompliant resources, which is useful when onboarding or migrating workloads into governed landing zones.
10. Policy should be validated before migration waves, because a policy-denied deployment can block cutover or force rework.

### AZ-305 exam discriminator

Choose Azure Policy when the scenario asks for **preventing noncompliant deployments**, **required tagging**, **allowed locations**, **diagnostic settings**, or **compliance at scale**.

### Common trap

Using RBAC to solve a resource-state compliance problem. RBAC does not enforce allowed regions, tags, or diagnostic settings.

---

## Azure Monitor

**Classification:** Supporting  
**Why it matters:** Migrated workloads require monitoring to validate cutover, detect regressions, and operate the new Azure target.  
**Primary Microsoft source:** [Azure Monitor overview](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview)

### Deep technical facts / requirements

1. Azure Monitor collects, analyzes, and acts on telemetry from Azure resources, applications, and hybrid environments.
2. Post-migration validation should include metrics, logs, alerts, dashboards, and application performance telemetry.
3. VM migrations should include Azure Monitor Agent or appropriate monitoring configuration after cutover.
4. App Service and Application Insights are common choices for application performance monitoring of replatformed web apps.
5. AKS and Container Apps require container-specific logging and metric designs, not only VM-style monitoring.
6. Diagnostic settings can route platform logs and metrics to Log Analytics, Event Hubs, or storage depending on retention and integration requirements.
7. Azure Monitor does not by itself select the migration target; it supports operational readiness of whatever target is chosen.
8. Migration landing zones should include workspace design, retention, access control, alerting, and cost considerations before production migration.
9. Monitoring baselines should compare pre-migration and post-migration performance to confirm sizing and application health.
10. Alerting should be defined for critical dependencies, not only individual compute resources.

### AZ-305 exam discriminator

Choose Azure Monitor when the scenario asks for **post-cutover validation**, **operational telemetry**, **alerts**, **application performance**, or **centralized logs**.

### Common trap

Migrating first and adding observability later. AZ-305 scenarios often expect monitoring readiness before or during production cutover.

---

## Microsoft Cost Management

**Classification:** Supporting  
**Why it matters:** Cost Management validates whether the migration produced the expected cost profile and supports post-migration optimization.  
**Primary Microsoft source:** [Overview of Cost Management](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/overview-cost-management)

### Deep technical facts / requirements

1. Microsoft Cost Management helps analyze, manage, and optimize Azure costs after workloads land in Azure.
2. Cost Management can track actual Azure spend against budgets and generate alerts when thresholds are crossed.
3. Cost Management is different from Azure Migrate business case: business case estimates before migration; Cost Management tracks actual cost after resources exist.
4. Tagging and subscription structure affect cost allocation and chargeback/showback for migrated workloads.
5. VM migration cost optimization may include right-sizing, reservations, savings plans, Azure Hybrid Benefit, disk tier optimization, and deallocating unused resources.
6. PaaS cost optimization may include App Service plan consolidation, autoscale tuning, Container Apps replica settings, and monitoring/log retention controls.
7. Cost analysis should include supporting services such as bandwidth, gateways, backup, monitoring ingestion, security services, and storage, not only compute.
8. Budgets do not enforce hard spend limits by default; they alert or trigger configured actions depending on implementation.
9. Cost Management should be part of landing zone governance so migration teams can observe cost drift early.
10. Cost recommendations must be balanced with performance, resiliency, compliance, and operational requirements.

### AZ-305 exam discriminator

Choose Cost Management for **actual post-migration cost tracking, budgets, alerts, and optimization**, not for initial source-environment discovery.

### Common trap

Using only migration estimates and never validating actual spend after cutover.

---

## Azure Database Migration Service

**Classification:** Adjacent  
**Why it matters:** Database migration is a separate AZ-305 task, but application workload migration often depends on whether the database remains on VM, moves to SQL on Azure VM, or replatforms to Azure SQL.  
**Primary Microsoft source:** [What is Azure Database Migration Service?](https://learn.microsoft.com/en-us/azure/dms/dms-overview)

### Deep technical facts / requirements

1. Azure Database Migration Service helps migrate databases to Azure data platforms such as Azure SQL Database, Azure SQL Managed Instance, and SQL Server on Azure VMs.
2. Database migration can change the application hosting recommendation because latency, connectivity, authentication, connection strings, compatibility, and downtime all affect the app tier.
3. A web app may be App Service-compatible, but database compatibility or network dependency can delay or change the target architecture.
4. SQL Server on Azure VM may be appropriate when OS-level SQL control or unsupported database features are required.
5. Azure SQL Managed Instance can be a modernization path when high SQL Server compatibility is needed without managing the underlying VM.
6. Azure SQL Database can be a stronger PaaS target when the application can tolerate database-level PaaS constraints and benefits from managed operations.
7. Database migration downtime and cutover method must align with application cutover; moving the app tier without its data dependency can break the workload.
8. DMS is adjacent here because the task is workload IaaS/PaaS migration; detailed database service-tier selection belongs to the database migration task.

### AZ-305 exam discriminator

Bring in DMS when the scenario says **application migration includes database dependency**, **database compatibility affects target**, or **database cutover controls downtime**.

### Common trap

Selecting App Service for the app tier without checking whether the database dependency can be reached, migrated, or modernized.

---

## Azure Data Box

**Classification:** Adjacent  
**Why it matters:** Large data movement can determine the migration method, timing, and feasibility of a workload cutover.  
**Primary Microsoft source:** [Azure Data Box overview](https://learn.microsoft.com/en-us/azure/databox/data-box-overview)

### Deep technical facts / requirements

1. Azure Data Box is used for offline transfer of large datasets to Azure when network transfer is impractical, expensive, or too slow.
2. Data Box can affect workload migration timing because application cutover may depend on bulk data seeding before final synchronization.
3. Offline transfer is useful for bandwidth-constrained environments, large file shares, archives, backup datasets, or migration seeding.
4. Data Box is not a compute migration tool; it moves data that may support a workload migration.
5. Data Box introduces logistics, shipping, chain-of-custody, encryption, copy validation, and import planning considerations.
6. For workloads with large file dependencies, Data Box may pair with online replication or delta synchronization to reduce downtime.
7. Data Box is adjacent to this task because unstructured-data migration is a separate AZ-305 task, but data volume can change the workload migration plan.
8. If the scenario asks for moving server workloads, Azure Migrate is usually more central than Data Box unless bulk data transfer is the blocker.

### AZ-305 exam discriminator

Choose Data Box when the scenario says **very large datasets**, **offline transfer**, **limited bandwidth**, or **network transfer cannot meet the migration window**.

### Common trap

Using Data Box as the answer for application/server migration. It moves data, not running workloads.

---

## Azure Arc-enabled servers

**Classification:** Supporting / adjacent  
**Why it matters:** Arc can help manage hybrid or retained servers while a migration program proceeds, but it is not the primary Azure landing target for IaaS/PaaS migration.  
**Primary Microsoft source:** [Azure Arc-enabled servers overview](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview)

### Deep technical facts / requirements

1. Azure Arc-enabled servers project Windows and Linux machines outside Azure into Azure Resource Manager for management.
2. Arc can manage servers across on-premises, edge, and other clouds while they remain outside Azure.
3. Arc can support policy, inventory, monitoring, security, and update management for retained or staged workloads.
4. Arc is useful when a migration program includes a retain phase or when workloads cannot move before the data-center deadline.
5. Arc does not migrate workloads; it manages hybrid machines where they currently run.
6. Arc can help standardize governance before migration by applying Azure management patterns to non-Azure servers.
7. Arc is not a substitute for Azure Migrate assessment when the goal is to size and migrate workloads to Azure.
8. Arc can be part of a hybrid target-state model when not all workloads are candidates for immediate migration.

### AZ-305 exam discriminator

Choose Arc when the scenario asks for **hybrid management of retained servers**, not when it asks to migrate workloads to Azure hosting.

### Common trap

Confusing Arc with migration. Arc extends Azure management; Azure Migrate assesses and migrates.

---

## Azure Well-Architected Framework

**Classification:** Architecture guidance  
**Why it matters:** WAF provides the post-target design lens used to evaluate reliability, security, cost, operational excellence, and performance after choosing IaaS or PaaS.  
**Primary Microsoft source:** [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/)

### Deep technical facts / requirements

1. The Well-Architected Framework evaluates workloads across reliability, security, cost optimization, operational excellence, and performance efficiency.
2. A migration target should be assessed against all pillars, not only migration speed.
3. Reliability requirements can change the target: a VM rehost may need zones and load balancing, while App Service may provide easier platform scaling.
4. Security requirements can change the target: private endpoints, managed identity, policy, Defender for Cloud, and network isolation may favor or disqualify certain services.
5. Cost optimization can favor PaaS, right-sized VMs, reservations, autoscale, or retiring unused systems depending on utilization and workload behavior.
6. Operational excellence can favor managed services when the team lacks capacity to manage OS, Kubernetes, or VMware operations.
7. Performance efficiency can favor AKS, Container Apps, App Service, or VMs depending on scale pattern, latency, runtime, and state.
8. WAF is not a migration tool; it is a design review model for the selected target architecture.
9. A migration strategy that satisfies the deadline but fails security, reliability, or operations requirements is incomplete for AZ-305.
10. WAF can justify a phased approach: rehost first to meet deadline, then modernize to improve long-term pillars.

### AZ-305 exam discriminator

Use WAF when the scenario asks for the **best architecture tradeoff**, not just the fastest migration.

### Common trap

Optimizing only for migration speed. AZ-305 expects architect-level tradeoff analysis across multiple pillars.

---

## Highest-yield exam discriminators

| Scenario clue | Best answer | Why |
|---|---|---|
| Minimal code change, same OS, custom agent, legacy runtime | Azure Virtual Machines | VM rehost preserves server-level control and minimizes application change. |
| VMware tooling and vSphere operations must remain | Azure VMware Solution | AVS preserves VMware operational model on Azure infrastructure. |
| VMware-to-AVS migration with vMotion or bulk migration | VMware HCX | HCX provides VMware migration methods for AVS. |
| Need discovery, readiness, sizing, cost, and dependencies before migration | Azure Migrate | Azure Migrate is the assessment and migration planning hub. |
| Unknown app dependencies across servers | Azure Migrate dependency analysis | Dependency maps help group servers and avoid missed dependencies. |
| Need TCO and right-sizing before committing | Azure Migrate business case | Business case compares on-premises and Azure cost and identifies utilization-based opportunities. |
| Compatible web app and goal is reduced server patching | Azure App Service | App Service provides managed web hosting and reduces infrastructure management. |
| App Service app needs outbound access to private resources | App Service VNet integration | VNet integration supports outbound private network access. |
| App Service app must be privately reachable inbound | App Service private endpoint | VNet integration alone does not provide inbound private access. |
| Multiple App Service apps need independent scaling | Separate App Service plans | Apps in the same plan share resources and scale together. |
| Containerized app requires Kubernetes APIs or custom controllers | AKS | AKS exposes Kubernetes control and extensibility. |
| Containerized app should avoid Kubernetes management | Azure Container Apps | Container Apps abstracts cluster operations. |
| Event-driven container workload with bursty demand | Azure Container Apps | KEDA-based scaling and scale-to-zero fit bursty workloads. |
| Event-driven code component, queue handler, timer task | Azure Functions | Functions is designed for event-driven serverless code units. |
| Large enterprise migration with shared connectivity, identity, DNS, and policy | Azure landing zone | Landing zones provide the repeatable governed target foundation. |
| Need private, predictable hybrid connectivity for migration traffic | ExpressRoute | ExpressRoute provides private provider-based connectivity. |
| Need encrypted site-to-site connectivity over public internet | VPN Gateway | VPN Gateway provides IPsec/IKE encrypted hybrid tunnels. |
| Need to block noncompliant regions/SKUs or enforce tags | Azure Policy | Policy enforces resource-state compliance at scale. |
| Need post-cutover telemetry and alerts | Azure Monitor | Monitor validates and operates migrated workloads. |
| Need actual spend tracking after migration | Microsoft Cost Management | Cost Management tracks budgets, alerts, and optimization after resources exist. |
| Database dependency controls app migration feasibility | Azure Database Migration Service / database assessment | Data-tier compatibility and cutover can change the app target. |
| Network transfer cannot move large datasets in time | Azure Data Box | Offline transfer can seed large data before application cutover. |
| Some servers remain on-premises but need Azure governance | Azure Arc-enabled servers | Arc manages retained hybrid servers without migrating them. |

---

## Quick review checklist

- Start with the business driver: deadline, modernization, cost, governance, risk, or operational reduction.
- Use CAF to classify the strategy: retire, retain, rehost, replatform, refactor, rearchitect, rebuild, or replace.
- Use Azure Migrate for discovery, assessment, business case, dependency analysis, and migration execution.
- Choose VMs for OS control and minimal change.
- Choose App Service for compatible managed web apps and APIs.
- Choose AKS only when Kubernetes control is required.
- Choose Container Apps for serverless containers without direct Kubernetes management.
- Choose AVS when VMware continuity is mandatory.
- Prepare landing zones, connectivity, identity, DNS, policy, monitoring, backup, and cost governance before production waves.
- Treat database and unstructured-data migration as adjacent decisions that can still affect the workload target.
