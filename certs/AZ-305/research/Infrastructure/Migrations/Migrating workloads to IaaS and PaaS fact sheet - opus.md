# Deep Technical Facts and Requirements for Migrating Workloads to IaaS and PaaS

## Scope

- Exam: AZ-305: Designing Microsoft Azure Infrastructure Solutions
- Task: Design migrations. Recommend a solution for migrating workloads to infrastructure as a service (IaaS) and platform as a service (PaaS).
- Source guide: "AZ-305 Study Guide: Recommend a solution for migrating workloads to IaaS and PaaS" (chatGPT v1).
- Product selection method: Products and major topics were extracted from the guide's discovery pass, core product list, architecture patterns, and quick-reference tables, then validated against current Microsoft documentation (Microsoft Learn, Azure product docs, Cloud Adoption Framework, Azure Architecture Center). Where the guide or older docs differed from current Microsoft documentation, the current documentation is used and the discrepancy is noted.

## Product coverage summary

| Product / topic | Classification | Why it matters for this task |
|---|---|---|
| Cloud Adoption Framework migration methodology | Framework | Frames migration as a lifecycle (assess, migrate, release, govern), which controls the order of correct exam answers. |
| Cloud migration strategies (the "R" strategies) | Framework | The rehost vs replatform vs refactor distinction is the central decision this task tests. |
| Azure Migrate (hub, discovery and assessment, server migration, web app modernization) | Core | The default assess-and-migrate tooling; assessment type points to IaaS vs PaaS targets. |
| Azure Migrate appliance | Supporting | Discovery boundaries and scale limits affect feasibility and design of large migrations. |
| Dependency analysis | Core | Determines migration grouping and prevents post-cutover outages. |
| Azure Migrate business case | Core | Drives the cost and modernization justification that selects a strategy. |
| Azure Virtual Machines | Core | Default IaaS rehost target when OS control or legacy compatibility is required. |
| Managed disks | Supporting | Disk type and redundancy drive VM performance, resiliency, and cost. |
| Azure App Service (and App Service plans) | Core | Primary PaaS replatform target for web apps; plan tier gates features and isolation. |
| Azure Kubernetes Service | Core | Target when Kubernetes APIs and cluster control are a requirement. |
| Azure Container Apps | Core | Serverless container target when Kubernetes management is not required. |
| Azure Functions | Adjacent | Event-driven modernization target for components, not whole servers. |
| Azure VMware Solution (with HCX) | Core | VMware operational continuity and fast data-center exit. |
| Azure landing zones | Framework | The destination foundation that must exist before migration. |
| ExpressRoute | Supporting | Private hybrid connectivity; mandatory for Azure VMware Solution. |
| VPN Gateway | Supporting | Encrypted site-to-site connectivity when ExpressRoute is not required. |
| Azure Policy | Supporting | Guardrails that can block target regions and SKUs before migration. |
| Azure Monitor | Supporting | Post-migration operations; agent-based dependency analysis dependency. |
| Microsoft Cost Management | Supporting | Post-migration cost optimization. |
| Azure Arc-enabled servers | Adjacent | Hybrid management for retained or staged workloads. |
| Azure Database Migration Service | Adjacent | Affects combined application-plus-database migrations. |
| Azure Data Box | Adjacent | Offline bulk transfer that can gate a workload migration. |
| Compute / container decision guidance | Architecture guidance | The reasoning Microsoft expects when choosing the target platform. |

---

## Cloud Adoption Framework migration methodology

**Classification:** Framework / methodology
**Why it matters:** AZ-305 questions reward the correct order of operations. The methodology dictates that you assess and plan before you cut over, and that you prepare governance before you land workloads.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/

### Deep technical facts / requirements

1. The CAF migration effort is a repeatable lifecycle, not a single copy operation. The core phases are assess workloads, deploy (migrate) workloads, and release workloads, supported by the Ready (landing zone) and Govern methodologies that run in parallel.
2. Migration assessment in CAF is workload-centric, not server-centric. A workload is the full set of resources that support a business capability, so a correct migration plan groups dependent servers and services rather than migrating individual machines.
3. CAF separates "migrate" from "modernize." Migration moves workloads with little or no change; modernization (replatform, refactor, rearchitect) changes the hosting model or code. The exam often tests whether a scenario is asking for speed (migrate) or transformation (modernize).
4. The Ready methodology (landing zones) is a prerequisite, not a later step. CAF places identity, network, governance, and security foundations before workload migration, so "prepare the landing zone first" is the correct answer pattern when governance is mentioned.
5. CAF uses iterative migration waves. Workloads are grouped into waves based on dependency, business priority, and risk, which is why dependency analysis precedes wave planning.
6. Each migrated workload follows a standard pattern: replicate, test migrate, cut over, validate, then decommission the source. Test migration before cutover is an explicit CAF step and a common "what comes next" exam answer.
7. CAF ties each migration decision to a business driver (cost reduction, data-center exit, scale, compliance), so the "best" strategy in a scenario is the one that matches the stated business driver, not the most technically advanced option.
8. Govern and Manage are continuous. Post-migration, CAF expects ongoing policy enforcement, monitoring, and cost optimization, which is why Azure Policy, Azure Monitor, and Cost Management appear as supporting services in this task.

### AZ-305 exam discriminator

When a scenario gives a sequence question ("what should you do first"), the methodology forces this order: assess and build the business case, prepare the landing zone, then migrate in waves. Choosing cutover or tooling first is almost always wrong.

### Common trap

Treating migration as a tool choice ("which tool migrates servers") instead of a lifecycle decision. The exam usually wants the requirement-driven strategy and target, with Azure Migrate as the assessment and execution mechanism, not the answer by itself.

---

## Cloud migration strategies (the "R" strategies)

**Classification:** Framework / methodology
**Why it matters:** The rehost, replatform, and refactor distinction is the single most tested decision in this task. The chosen strategy determines the target platform.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/select-cloud-migration-strategy

### Deep technical facts / requirements

1. Microsoft's current CAF strategy set is: Retire, Retain, Rehost, Replatform, Refactor, Rearchitect, Rebuild, Replace. Note this differs from the popular "7 Rs" lists that include Relocate or Repurchase. On AZ-305, use Microsoft's set; "Relocate" is not part of the current CAF strategy list.
2. Rehost (lift and shift) moves a workload with no code changes, typically to Azure Virtual Machines or Azure VMware Solution. Microsoft guidance says rehost is appropriate only when you are confident the workload will not need modernization for at least two years.
3. Replatform moves a workload to a managed (PaaS) hosting environment with minimal code changes. This is the strategy behind App Service, AKS, Container Apps, and managed database targets. Choose it when the goal is reduced operations and better scalability without a rewrite.
4. Refactor changes application code to improve maintainability, performance, or cloud alignment without redesigning the architecture. Rearchitect redesigns the architecture (for example into microservices) for scale and resilience. Rebuild recreates the workload as cloud-native from scratch.
5. Replace moves to a SaaS product and retires the custom workload. Retire decommissions a workload with no business value. Retain (sometimes called "retain/hybrid") keeps a workload on-premises, often because of latency, compliance, or dependency constraints.
6. Strategy maps to target: rehost maps to IaaS (VMs or AVS); replatform maps to PaaS (App Service, AKS, Container Apps); refactor/rearchitect/rebuild map to deeper cloud-native services. Reading the strategy clue tells you the service family.
7. The fastest strategy is rehost; the lowest long-term operational cost usually comes from replatform or higher. The exam frequently pits "move quickly / data-center deadline" (rehost or AVS) against "reduce management / modernize" (PaaS).
8. Strategy is a per-workload decision. A single migration program normally applies different strategies to different workloads, so a scenario describing a mixed estate can have more than one correct target.

### AZ-305 exam discriminator

The phrase decides the answer. "Minimal or no code changes" and "retain OS control" point to rehost (VM). "Reduce infrastructure management for a web app" points to replatform (App Service). "Modernize into microservices" points to refactor/rearchitect (AKS or Container Apps).

### Common trap

Assuming "migrate to Azure" means "move to VMs." Replatform to PaaS is frequently the better answer when the requirement is reduced operations, independent scaling, or modernization.

---

## Azure Migrate (hub, discovery and assessment, server migration, web app modernization)

**Classification:** Core
**Why it matters:** Azure Migrate is the default assessment and migration tooling. The assessment type you run (server vs web app) steers the recommendation toward IaaS or PaaS.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/migrate/migrate-services-overview

### Deep technical facts / requirements

1. Azure Migrate is a hub that covers discovery, assessment, business case, dependency analysis, and migration for servers, databases, and web apps. It is the assessment and planning layer; the strategy and target decision still come from CAF and the compute decision guidance.
2. Server migration supports VMware, Hyper-V, physical servers, and other cloud-hosted servers. VMware can use agentless replication (no agent on the guest) or agent-based replication via a separate replication appliance.
3. For VMware, the Azure Migrate appliance (assessment and agentless migration) and the replication appliance (agent-based migration) are different appliances. They can connect to the same vCenter but must not be installed on the same server.
4. Web app assessment is distinct from server assessment and is what points a workload to PaaS. Azure Migrate can assess ASP.NET (IIS) and Java (Tomcat) web apps for migration to App Service or AKS, while server assessment produces VM sizing and readiness.
5. Assessments support sizing based on as-on-premises configuration or on performance history. Performance-based sizing right-sizes overprovisioned source servers, which is the correct answer when a scenario says source servers are oversized and cost must be controlled.
6. Assessments produce Azure readiness, recommended VM SKU or target service, and monthly cost estimates, including support for Azure Hybrid Benefit and reserved-instance pricing assumptions in the cost view.
7. Azure Migrate supports test migration before cutover so you can validate a workload in Azure without affecting the running source. This is the recommended validation step before final cutover.
8. The service is free to use for discovery and assessment; you pay for the Azure resources you consume (for example replication storage and the target VMs), not for the assessment tooling itself.
9. Azure Migrate has been broadened and is presented as "Azure Migrate and Modernize." Functionality (discovery, assessment, dependency analysis, business case, server and web app migration) is consistent with what the study guide describes.

### AZ-305 exam discriminator

Run a server assessment when the recommendation will be an IaaS VM. Run a web app assessment when the recommendation could be App Service or AKS. The assessment type, not the tool, signals whether the correct target is IaaS or PaaS.

### Common trap

Jumping straight to migration or cutover. The correct first action is almost always discovery and assessment (and dependency analysis), because cutover before assessment risks wrong sizing and missed dependencies.

---

## Azure Migrate appliance

**Classification:** Supporting
**Why it matters:** Discovery scale limits and connectivity requirements can constrain the design of a large migration, which can surface as a feasibility question.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/migrate/migrate-appliance

### Deep technical facts / requirements

1. The appliance is deployed on-premises (as a VM or physical server) and continuously sends server configuration and performance metadata to Azure Migrate. It performs discovery and assessment, and for VMware it can also perform agentless migration.
2. A single appliance has discovery scale limits: up to 10,000 servers in a VMware environment, up to 5,000 in Hyper-V, and up to 1,000 physical servers. Larger estates require multiple appliances or scaled assessments.
3. The appliance discovers installed software inventory, SQL Server instances and databases, and (for physical and VMware) ASP.NET web apps, in addition to server configuration and performance data.
4. Deployment differs by source: VMware and Hyper-V use a downloadable appliance image (OVA or VHD); physical servers use a script-based installation. Azure Government has separate deployment scripts and URLs.
5. The appliance needs outbound access to a defined set of Azure URLs. In locked-down networks, these URLs must be allowed or proxied, which is a common readiness blocker.
6. Web app configuration data (IIS and Tomcat) is refreshed about every 24 hours, while server performance data is collected continuously, so very recent changes may not appear immediately in an assessment.
7. Deleting an appliance from a project is not supported, so appliance placement and project scoping are design decisions, not throwaway choices.

### AZ-305 exam discriminator

When a scenario states a very large estate (for example tens of thousands of servers), recognize that a single appliance cannot discover everything and the design needs multiple appliances or scaled assessment, rather than assuming one appliance covers all sources.

### Common trap

Assuming the appliance installs agents on every guest. For VMware and Hyper-V, discovery and assessment are agentless; agents are only required for specific paths such as agent-based dependency analysis or agent-based replication.

---

## Dependency analysis

**Classification:** Core
**Why it matters:** Dependency analysis determines which servers must move together. Missing a dependency causes outages even when each VM migrates successfully.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/migrate/concepts-dependency-visualization

### Deep technical facts / requirements

1. Dependency analysis identifies network connections between discovered servers so you can group servers into application migration waves and avoid leaving a dependency behind.
2. There are two modes: agentless and agent-based. Agentless captures TCP connection data without installing anything on the guest; agent-based uses the Service Map solution in Azure Monitor and requires the Log Analytics agent (MMA) and the Dependency agent on each server.
3. Agentless dependency analysis for VMware connects through vCenter using VMware APIs. For physical servers and Hyper-V it connects directly to Windows using PowerShell remoting (port 5985) and to Linux using SSH (port 22).
4. Agent-based analysis depends on a Log Analytics workspace and the dependency agent. This is the option to choose when the scenario already standardizes on Log Analytics or needs richer, queryable connection data (latency, data transfer, process detail).
5. Agentless data is processed on the appliance and sent to Azure roughly every six hours, and agentless visualization is available for a bounded window (about 30 days for export), so it is best for time-boxed discovery.
6. Dependency analysis also reveals servers that are idle or unused, which supports a retire decision instead of migrating a workload that no longer carries value.
7. Dependency mapping is the prerequisite for wave planning. The correct sequence is discover, analyze dependencies, group into waves, then migrate, not migrate server by server.

### AZ-305 exam discriminator

Choose agentless when the requirement is low-touch discovery with no agent installation. Choose agent-based when the requirement is detailed, queryable dependency data or when Log Analytics is already in use. Hyper-V scenarios that demand rich dependency data may point to agent-based.

### Common trap

Migrating servers individually based on a server list. If dependencies are unknown, the correct answer is to run dependency analysis first and migrate dependent servers in the same wave.

---

## Azure Migrate business case

**Classification:** Core
**Why it matters:** The business case is what justifies a strategy financially before migration, and "cost justification required" scenarios point directly to it.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/migrate/concepts-business-case-calculation

### Deep technical facts / requirements

1. The business case quantifies the cost comparison between staying on-premises and migrating to Azure, including a total cost of ownership view rather than only per-VM compute cost.
2. It models cost savings levers such as Azure Hybrid Benefit (reusing Windows Server and SQL Server licenses), reserved instances, and right-sizing based on discovered utilization.
3. The business case surfaces modernization opportunities, for example moving SQL Server to a managed database or web apps to App Service, so it helps justify replatform over rehost on cost grounds.
4. It uses discovered configuration and performance data, so the accuracy of the business case depends on the discovery window being long enough to capture representative load.
5. The business case is a planning artifact produced before migration. In a scenario asking what to do before committing to a strategy, building the business case (and assessment) is the correct early step.
6. It includes on-premises cost assumptions (hardware, facilities, management) that can be tuned, so the output is a decision aid, not a fixed quote.
7. The business case complements, but does not replace, Microsoft Cost Management, which handles ongoing cost tracking and optimization after workloads are in Azure.

### AZ-305 exam discriminator

When a scenario requires financial justification or comparison before migration, the business case is the answer, not Cost Management (which is post-migration) and not a manual pricing estimate.

### Common trap

Confusing the pre-migration business case with post-migration Cost Management. The business case justifies the move; Cost Management optimizes spend after the move.

---

## Azure Virtual Machines

**Classification:** Core
**Why it matters:** VMs are the default IaaS rehost target. They are the correct answer when the workload needs OS control or legacy compatibility.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/virtual-machines/overview

### Deep technical facts / requirements

1. VMs give you OS-level control, so they are the right target when the workload needs custom agents, kernel modules, domain join, specific OS versions, or software that cannot run on a managed platform.
2. VM resiliency is tiered. A single VM with premium or ultra disks can carry an SLA; availability zones spread VMs across physically separate datacenters in a region; availability sets spread VMs across fault and update domains within a datacenter. Zones give higher resiliency than sets.
3. Availability zones protect against datacenter-level failure inside a region; availability sets only protect against rack-level and maintenance events. When a scenario requires region-internal datacenter fault tolerance, the answer is zones, not sets.
4. VM Scale Sets provide automatic horizontal scaling and are the basis for elastic VM workloads; a single VM does not autoscale. Choose scale sets when the IaaS workload needs to scale out on demand.
5. Azure Hybrid Benefit lets you apply existing Windows Server and SQL Server licenses to reduce VM cost, which is a frequent cost discriminator between rehosting on VMs and other options.
6. Premium and Ultra disk performance requires a VM size that supports premium storage (the "s" in sizes such as Standard_D4s_v5). Choosing a non-premium-capable size blocks high-performance disks.
7. Generation 2 VMs are required for some features such as larger memory, certain security features, and trusted launch. Workload OS and feature requirements can dictate Gen 1 vs Gen 2.
8. VMs carry the highest operational burden of the compute targets. You patch the OS, manage scaling, configure backup, and harden the guest. This is the tradeoff against PaaS and the reason rehost is not always recommended.

### AZ-305 exam discriminator

VM is the answer when the requirement explicitly needs OS control, legacy or unsupported runtimes, custom system-level software, or a fast lift and shift with no code changes. If the requirement is "reduce infrastructure management," a VM is usually the wrong answer.

### Common trap

Defaulting to a VM for any "migrate" scenario. Check first whether the workload can replatform to App Service, AKS, or Container Apps to reduce operations.

---

## Managed disks

**Classification:** Supporting
**Why it matters:** Disk type and redundancy set VM performance, resiliency, and cost, and several disk constraints can eliminate an otherwise correct VM design.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/virtual-machines/disks-types

### Deep technical facts / requirements

1. There are five managed disk types: Ultra Disk, Premium SSD v2, Premium SSD, Standard SSD, and Standard HDD. Performance and cost rise from Standard HDD up to Ultra Disk.
2. Ultra Disk delivers the highest IOPS and throughput and sub-millisecond latency, but it has constraints: locally redundant storage only (no ZRS), no availability sets, no disk caching, and it cannot be an OS disk. Sizes range from 4 GiB to 64 TiB, up to about 400,000 IOPS per disk.
3. Premium SSD v2 lets you set capacity, IOPS, and throughput independently and adjust them without downtime, often at lower cost than Premium SSD. Limits: LRS only currently, no host caching, cannot be an OS disk, and in availability-zone regions it attaches only to zonal VMs.
4. Premium SSD provides guaranteed IOPS and throughput based on disk size and supports both LRS and ZRS. It can be a shared disk attached to multiple VMs (for clustering), and it can be an OS disk.
5. Standard SSD suits light or dev/test workloads and supports LRS and ZRS. Standard HDD is the cheapest, magnetic, suited to infrequently accessed or backup data.
6. You can switch between Premium SSD, Standard SSD, and Standard HDD in place. Moving to or from Ultra Disk or Premium SSD v2 generally requires creating a new disk from a snapshot (Premium SSD v2 conversion is in preview).
7. Redundancy is a per-disk resiliency decision. ZRS disks survive a zone failure; LRS disks do not. A workload that must keep running through a zone outage needs ZRS-capable disks (Premium SSD or Standard SSD), not Ultra or Premium SSD v2.

### AZ-305 exam discriminator

When a scenario demands the absolute highest IOPS and lowest latency, Ultra Disk is correct, but only if the design does not also require ZRS, availability sets, or an OS disk on that disk. If those are required, Premium SSD is the safer answer.

### Common trap

Selecting Ultra Disk or Premium SSD v2 for a design that also requires zone-redundant disks or availability sets. Those disk types do not support ZRS or availability sets, so the requirement combination is invalid.

---

## Azure App Service (and App Service plans)

**Classification:** Core
**Why it matters:** App Service is the primary PaaS replatform target for web apps. The plan tier gates features, scaling, and isolation, so tier selection is itself an exam decision.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans

### Deep technical facts / requirements

1. App Service is a managed platform for web apps and APIs. Choosing it removes OS and patching responsibility, which makes it the correct replatform target when the requirement is "reduce infrastructure management for a web app."
2. Compute is dedicated at the plan level, not per app. All apps in the same App Service plan share that plan's compute and scale together. To isolate or independently scale an app, put it in a separate plan.
3. Plan tiers include Free and Shared (multi-tenant, very limited), Basic, Standard, Premium v3, and Isolated v2. Higher tiers unlock autoscale, deployment slots, backups, custom domains, TLS, and more. Premium v3 is the recommended production tier; older Premium v2 should not be the default for new work.
4. Deployment slots (staging, with swap) are available from Standard upward. Standard supports up to 5 slots and Premium up to 20, which matters for blue-green or staged-cutover requirements.
5. Network isolation has two distinct features that are often confused. VNet integration controls outbound traffic from the app into a virtual network. Private endpoint provides private inbound access to the app. They solve opposite directions of traffic.
6. App Service is not private by default. For a "web app needs private inbound access" requirement, add a private endpoint. For "app must reach on-premises or VNet resources," add VNet integration.
7. Isolated v2 runs apps in an App Service Environment v3 (ASE v3), a single-tenant deployment in your VNet with no public internet dependency. A single Isolated v2 plan scales to 100 instances; one ASE v3 supports up to 200 total instances across plans.
8. ASE v1 and v2 are retired; new isolated deployments must use ASE v3. For most network isolation needs, Premium v3 with VNet integration and private endpoints is far cheaper than an ASE and is the right answer unless strict single-tenant hardware isolation or compliance is required.
9. App Service supports Windows and Linux, multiple runtimes (for example .NET, Java, Node, Python, PHP), and container images. A containerized web app can land on App Service without needing Kubernetes.
10. Built-in features such as autoscale, custom domains, managed TLS certificates, and backups are provided by the platform and do not incur separate per-feature compute charges beyond the plan; you pay for plan instances.

### AZ-305 exam discriminator

App Service beats a VM when a web app can run on a managed platform and the goal is reduced operations. The correct plan tier is the lowest tier that satisfies the stated requirements (slots, autoscale, isolation), so isolation or compliance requirements push the answer toward Premium v3 plus private networking, or to Isolated v2 / ASE v3 only when single-tenant isolation is mandatory.

### Common trap

Assuming App Service is private by default, or confusing VNet integration (outbound) with private endpoint (inbound). Also, assuming apps in the same plan scale independently; they do not.

---

## Azure Kubernetes Service (AKS)

**Classification:** Core
**Why it matters:** AKS is the right target when the requirement is Kubernetes itself: orchestration APIs, cluster extensibility, or platform-team control.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/aks/what-is-aks

### Deep technical facts / requirements

1. Microsoft manages the AKS control plane (API server, etcd, scheduler, controller manager). You manage and pay for the worker node VMs, disks, load balancers, and egress. The control plane is free on the Free tier.
2. AKS has three management tiers. Free has no SLA and is for dev/test (recommended under about 10 nodes). Standard adds a financially backed SLA (99.95% API server availability with availability zones, 99.9% without) and a control plane that scales to large clusters. Premium adds Long-Term Support (LTS) for extended Kubernetes version support.
3. The Standard tier supports large clusters (up to 5,000 nodes) with a control plane that scales with load. The Free tier control plane has limited capacity and request limits and is not suitable for production scale.
4. AKS supports both Linux and Windows node pools in the same cluster, and multiple node pools let you separate workloads by VM size, OS, or purpose (for example system vs user node pools).
5. Spot node pools run on surplus capacity at large discounts and can be evicted; they suit fault-tolerant or batch workloads, not stateful or latency-critical services.
6. AKS integrates with Microsoft Entra ID for cluster authentication and supports managed identities and workload identity for pod-level access to Azure resources without storing secrets.
7. AKS gives you direct Kubernetes API access (kubectl), custom controllers, service mesh, and the full ecosystem. This control is the reason to choose AKS, and it is also the operational cost: you own upgrades, networking design, and node management.
8. AKS Automatic provides a more managed experience with automated upgrades, node provisioning, scaling, and networking, for teams that want Kubernetes without operating every layer.
9. Networking has design implications. Azure CNI assigns VNet IPs to pods (better for VNet integration, uses more IP space) versus simpler models; ingress and egress must be designed explicitly. This is a common AKS planning gap.

### AZ-305 exam discriminator

AKS is the answer when Kubernetes is a stated requirement: Kubernetes APIs, custom controllers, service mesh, or platform-level control. It is not the answer merely because the workload uses containers. For production, Standard tier (SLA) plus availability zones is the expected reliability choice.

### Common trap

Choosing AKS for any containerized workload. If the team only needs to run containers with event-driven scale and no Kubernetes control, Container Apps is the better answer and avoids cluster operations.

---

## Azure Container Apps

**Classification:** Core
**Why it matters:** Container Apps is the serverless container target. It is the correct answer when the workload is containerized but does not need Kubernetes management.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/container-apps/overview

### Deep technical facts / requirements

1. Container Apps is built on Kubernetes plus KEDA, Dapr, and Envoy, but it abstracts the cluster away. You do not get kubectl or direct Kubernetes API access; you configure apps through the Container Apps resource model (portal, CLI, Bicep, Terraform).
2. It has two plan types within a workload-profiles environment. Consumption is serverless, scales to zero, and bills per second of active use. Dedicated runs on reserved compute with predictable pricing and supports larger instances and GPU.
3. Scale-to-zero on the Consumption plan means you pay nothing when idle, which makes Container Apps strong for bursty, event-driven, or intermittent workloads where AKS nodes would sit idle.
4. Autoscaling uses KEDA, driven by HTTP traffic, queue depth, CPU, or custom event sources. Built-in KEDA scalers cover most needs, but you cannot author a custom scaler that manipulates Kubernetes resources directly; that limit is where AKS becomes necessary.
5. Dapr is a first-class, toggle-on integration for state management, pub/sub, and service invocation in microservice apps. On AKS you would install and manage Dapr yourself.
6. A Container Apps environment is the isolation and networking boundary. Apps in the same environment share a virtual network, logging configuration, and Dapr settings, similar in concept to how an App Service plan groups apps.
7. Container Apps supports revisions and traffic splitting for blue-green and canary releases without external tooling.
8. Resource limits differ by plan. The Consumption profile has a smaller per-app image and disk allowance (about 8 GB shared across image, app, and logs), while Dedicated profiles support much larger image sizes per instance and GPU-backed profiles for AI inference.
9. Each subscription receives a monthly free grant on the Consumption profile (on the order of 180,000 vCPU-seconds and 360,000 GiB-seconds), shared across all Consumption apps in that subscription, not per app.

### AZ-305 exam discriminator

Container Apps wins when the requirement is "run containers" or "serverless containers," event-driven scale, background jobs, or microservices without managing Kubernetes. The decisive clue against it is a need for direct Kubernetes APIs, custom controllers, or cluster-level customization, which points to AKS.

### Common trap

Choosing Container Apps when the workload genuinely needs cluster-level Kubernetes control, or choosing AKS when the workload only needs serverless container hosting. The deciding factor is whether Kubernetes control is a requirement, not whether containers are present.

---

## Azure Functions

**Classification:** Adjacent / supporting
**Why it matters:** Functions is a modernization target for event-driven components, not a whole-server migration target, so it appears in refactor and rearchitect scenarios rather than rehost.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview

### Deep technical facts / requirements

1. Functions is event-driven serverless compute for discrete functions and short-running logic, not a destination for migrating an entire server or monolithic web app.
2. It fits the refactor and rearchitect strategies, where a component (for example a scheduled job or queue processor) is broken out of a monolith, rather than the rehost or replatform of a full workload.
3. Functions can run on a Consumption plan (scale to zero, pay per execution), a Premium plan (pre-warmed instances, VNet, no cold start), or an App Service plan (run alongside web apps on dedicated compute).
4. Functions can also run inside a Container Apps environment, which is the path when you want functions to share networking, scaling, and Dapr with other containerized microservices.
5. Choosing Functions usually implies code-level change, so it is rarely the correct answer to a "minimal changes" or "lift and shift" scenario.

### AZ-305 exam discriminator

Functions is correct when a scenario isolates an event-driven or scheduled component for modernization. It is wrong for migrating a whole application server with minimal change.

### Common trap

Treating Functions as a general workload migration target. It is a component-level modernization service, not a server replacement.

---

## Azure VMware Solution (with VMware HCX)

**Classification:** Core
**Why it matters:** AVS is the answer when the requirement is VMware operational continuity or a fast data-center exit without re-platforming the estate.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/azure-vmware/

### Deep technical facts / requirements

1. AVS runs VMware vSphere, vSAN, and NSX on dedicated bare-metal hosts inside Azure datacenters. It is a rehost path that keeps the VMware operational model, tooling, and skills intact, so it suits "must keep VMware tooling" and "fast exit" scenarios.
2. The minimum is three hosts per cluster, and the initial deployment is a single cluster of at least three hosts. A cluster scales to 16 hosts, and a private cloud supports up to 12 clusters and up to 96 hosts total.
3. Host SKUs include AV36, AV36P, AV48, AV52, and AV64. All hosts in a cluster must be the same type. AV64 is used only to expand an existing private cloud that was first built on AV36, AV36P, AV48, or AV52, with a minimum three-node base; you cannot start a private cloud on AV64 alone.
4. AVS requires an Azure Virtual Network and an ExpressRoute circuit. A Microsoft-managed ExpressRoute connects the VMware hosts to native Azure services, so ExpressRoute is a hard prerequisite, not optional.
5. You manage AVS through vCenter Server and NSX Manager using a built-in cloudadmin account with the CloudAdmin role. Microsoft operates the underlying platform (host lifecycle, patching, hardware), so it is a managed bare-metal VMware service, not full IaaS you own end to end.
6. Migration into AVS uses VMware HCX, which provides cold migration, bulk migration, HCX vMotion (live, near-zero downtime), and replication-assisted vMotion. The migration type chosen depends on downtime tolerance and scale.
7. AVS is positioned as VMware continuity and migration acceleration, not as application modernization. Treat it as the destination for keeping VMware operations, while modernization to PaaS is a later, separate decision.
8. Disaster recovery and business continuity for AVS use VMware-native tools (for example Site Recovery Manager and HCX), and AVS can extend on-premises networks, which supports hybrid and DR designs.

### AZ-305 exam discriminator

AVS is correct when the scenario stresses VMware operational continuity, vSphere/NSX tooling, a large VMware estate, or a hard data-center exit deadline with minimal change. Native Azure VMs are the alternative only when keeping the VMware control plane is not required.

### Common trap

Calling AVS "modernization." It is VMware continuity and rapid migration. Also forgetting that ExpressRoute is mandatory and that AV64 cannot be the founding host type of a private cloud.

---

## Azure landing zones

**Classification:** Framework / architecture guidance
**Why it matters:** The landing zone is the destination foundation. Governance, identity, and networking must exist before workloads migrate, which makes it a frequent "what first" answer.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/

### Deep technical facts / requirements

1. A landing zone is a pre-provisioned, governed environment (management groups, subscriptions, networking, identity, policy, security) that workloads land into. It exists to make migration repeatable and compliant from day one.
2. Landing zone design spans defined design areas including identity and access, network topology and connectivity, resource organization, governance, security, management, and platform automation. A migration plan should confirm these before cutover.
3. The recommended structure uses management groups to apply Azure Policy and RBAC at scale, with separate platform and application (landing zone) subscriptions, so governance is inherited rather than configured per resource.
4. Network topology is chosen up front, typically hub-and-spoke or Virtual WAN, because migrated workloads depend on connectivity (ExpressRoute or VPN), DNS, and firewalling that must be ready before they move.
5. Landing zones embed guardrails through Azure Policy (allowed regions, allowed SKUs, required tags, security baselines), which can block a migration if the target region or SKU is not permitted.
6. The Ready methodology distinguishes a platform landing zone (shared services) from application landing zones (where workloads run). Migrated workloads go into application landing zones that inherit platform controls.
7. Preparing the landing zone is explicitly a pre-migration step in CAF. In multi-business-unit or multi-subscription scenarios, the correct first action is usually to establish landing zones, not to start migrating.

### AZ-305 exam discriminator

When a scenario describes multiple business units, multiple subscriptions, or enterprise governance needs, the answer is to design and deploy landing zones first so identity, networking, and policy are inherited consistently before workloads arrive.

### Common trap

Treating governance and landing zones as something to add after migration. CAF puts the landing zone first, and policy guardrails can reject non-compliant target regions or SKUs at migration time.

---

## ExpressRoute

**Classification:** Supporting
**Why it matters:** ExpressRoute provides private hybrid connectivity for migration traffic and dependencies, and it is mandatory for Azure VMware Solution.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction

### Deep technical facts / requirements

1. ExpressRoute is a private, dedicated connection between on-premises and Azure that does not traverse the public internet. It uses BGP for dynamic routing and offers predictable bandwidth and latency.
2. ExpressRoute does not encrypt traffic by default. Unlike a VPN tunnel, the private circuit provides isolation but not encryption, so designs needing encryption add MACsec or IPsec over ExpressRoute.
3. ExpressRoute is the correct choice when migration or hybrid traffic needs high, consistent bandwidth, low latency, or large data movement, for example a steady migration of many workloads or AVS connectivity.
4. ExpressRoute is a prerequisite for Azure VMware Solution; AVS hosts connect to Azure through a Microsoft-managed ExpressRoute circuit.
5. ExpressRoute generally costs more and takes longer to provision than a VPN gateway, so a scenario emphasizing speed of setup or lower cost may favor VPN instead.

### AZ-305 exam discriminator

Choose ExpressRoute when the requirement is private, high-bandwidth, low-latency, or AVS connectivity. Choose VPN Gateway when encryption over the internet or quick, lower-cost setup is the priority. Remember ExpressRoute is not encrypted by default.

### Common trap

Assuming ExpressRoute encrypts traffic. It provides private connectivity, not encryption; add IPsec or MACsec if encryption is required.

---

## VPN Gateway

**Classification:** Supporting
**Why it matters:** VPN Gateway provides encrypted site-to-site connectivity for migration when ExpressRoute is not required.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways

### Deep technical facts / requirements

1. VPN Gateway creates encrypted IPsec/IKE tunnels between on-premises and Azure over the public internet, so it provides encryption that ExpressRoute does not provide by default.
2. It is faster to provision and lower cost than ExpressRoute, which makes it the answer when a scenario needs quick, encrypted hybrid connectivity without dedicated bandwidth.
3. Throughput and SLA depend on the gateway SKU, and bandwidth is shared and internet-dependent, so VPN Gateway is less predictable than ExpressRoute for large, sustained migration traffic.
4. VPN can serve as a backup or failover path alongside ExpressRoute in resilient hybrid designs.
5. For very large offline data sets, neither VPN nor ExpressRoute may be fastest; offline transfer with Data Box can be the correct answer.

### AZ-305 exam discriminator

VPN Gateway is correct when encrypted connectivity over the internet is acceptable and cost or setup speed matters. ExpressRoute is correct when bandwidth, latency, or AVS is the driver.

### Common trap

Using VPN Gateway for very large or latency-sensitive migration traffic where ExpressRoute (or offline Data Box for bulk data) is the better fit.

---

## Azure Policy

**Classification:** Supporting
**Why it matters:** Policy enforces guardrails that can block target regions and SKUs, so it can change whether a migration target is even allowed.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/governance/policy/overview

### Deep technical facts / requirements

1. Azure Policy enforces rules on resources (allowed locations, allowed SKUs, required tags, security configurations) and can deny non-compliant deployments, which can block a migration if the target is out of policy.
2. Policies are assigned at management group, subscription, or resource group scope and are inherited downward, so landing zone policies apply automatically to migrated workloads.
3. Policy supports deny, audit, append, modify, and deployIfNotExists effects, so it can both prevent and remediate. DeployIfNotExists can auto-configure required settings on migrated resources.
4. Initiatives (policy sets) group related policies, including regulatory compliance baselines, which is how compliance requirements are enforced at scale during and after migration.
5. Policy is distinct from RBAC: RBAC controls who can act, Policy controls what configurations are allowed. Both are part of landing zone governance.

### AZ-305 exam discriminator

When a scenario says enterprise policy restricts regions or SKUs, the correct step is to validate Azure Policy and landing zone readiness before migrating, because a deny policy can fail the deployment.

### Common trap

Assuming a migration will succeed without checking guardrails. Policy can block the target region or SKU, so readiness validation comes before cutover.

---

## Azure Monitor

**Classification:** Supporting
**Why it matters:** Azure Monitor operates migrated workloads after cutover and is the backend for agent-based dependency analysis during assessment.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview

### Deep technical facts / requirements

1. Azure Monitor collects metrics and logs across Azure resources, with Log Analytics workspaces as the query and storage layer for log data.
2. Agent-based dependency analysis in Azure Migrate relies on the Service Map solution in Azure Monitor and the dependency agent plus Log Analytics agent, so a Log Analytics workspace is a prerequisite for that path.
3. Azure Monitor is a post-migration operations concern, not the migration-selection decision, so it is a supporting service rather than a target choice in this task.
4. Container and Kubernetes monitoring (Container insights, managed Prometheus and Grafana) integrate with AKS and Container Apps, which matters when the migration target is a container platform.
5. Alerts, workbooks, and autoscale rules in Azure Monitor support operating migrated workloads, but they do not change which target platform is correct.

### AZ-305 exam discriminator

Azure Monitor appears as the operate-and-observe answer after migration, and as the dependency for agent-based dependency analysis. It is rarely the answer to "where should the workload land."

### Common trap

Selecting a monitoring action as the migration step. Monitoring follows migration; it does not decide the target.

---

## Microsoft Cost Management

**Classification:** Supporting
**Why it matters:** Cost Management optimizes spend after workloads move, and it is distinct from the pre-migration Azure Migrate business case.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/overview-cost-management

### Deep technical facts / requirements

1. Cost Management provides cost analysis, budgets, alerts, and recommendations for resources already running in Azure, so it is a post-migration optimization tool.
2. It surfaces savings opportunities such as right-sizing, reserved instances, and savings plans for workloads after they are migrated and generating real usage data.
3. It is separate from the Azure Migrate business case, which estimates cost before migration. The business case justifies the move; Cost Management optimizes the running estate.
4. Budgets and alerts can enforce financial guardrails as part of ongoing governance in the landing zone.

### AZ-305 exam discriminator

Cost Management is the post-migration cost answer. If a scenario asks for cost justification before migration, the answer is the Azure Migrate business case instead.

### Common trap

Using Cost Management for pre-migration justification. That is the business case's job.

---

## Azure Arc-enabled servers

**Classification:** Adjacent / limited relevance
**Why it matters:** Arc manages servers that stay on-premises (retained workloads) or that are in transition, but it is not a landing target for this task.
**Primary Microsoft source:** https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview

### Deep technical facts / requirements

1. Arc projects on-premises and other-cloud servers into Azure for consistent management (policy, monitoring, security, RBAC) without migrating them.
2. It supports the retain strategy and hybrid operating models, where a workload stays outside Azure but is governed with Azure tooling.
3. Arc is not a migration destination. It is management reach, so it is the answer for "govern retained or hybrid servers," not for "migrate the workload."

### Why it is not central

This task asks where workloads should land and how they move. Arc manages workloads that are not landing in Azure, so it is supporting and adjacent rather than a core target.

---

## Azure Database Migration Service and Azure Data Box

**Classification:** Adjacent / limited relevance
**Why it matters:** These belong to neighboring AZ-305 tasks but can affect a combined application migration plan.
**Primary Microsoft sources:** https://learn.microsoft.com/en-us/azure/dms/dms-overview and https://learn.microsoft.com/en-us/azure/databox/data-box-overview

### Deep technical facts / requirements

1. Database Migration Service supports online (minimal downtime) and offline migrations to Azure SQL Database, SQL Managed Instance, and other targets. It is the answer when an application migration includes moving the database with controlled downtime.
2. When a scenario combines a web app and its database, the application can replatform (for example to App Service) while the database migrates separately with DMS, which can be a multi-part correct answer.
3. Azure Data Box is an offline transfer appliance for large data sets (on the order of tens to hundreds of TB per order) that cannot move over the network in the available time. It can gate a workload migration whose data is too large to transfer online.
4. Data Box is the answer when bandwidth or a deadline makes online transfer impractical; it complements rather than replaces VPN or ExpressRoute for the rest of the migration.

### Why they are not central

Database and unstructured-data migration are separate AZ-305 tasks. They appear here only when they block or accompany a workload-level IaaS/PaaS recommendation.

---

## Compute and container decision guidance

**Classification:** Architecture guidance
**Why it matters:** This is the reasoning Microsoft expects when selecting the target platform, and it is what turns a requirement into a service choice.
**Primary Microsoft sources:** https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree and https://learn.microsoft.com/en-us/azure/architecture/guide/choose-azure-container-service

### Deep technical facts / requirements

1. The compute decision guidance favors managed services first. Prefer PaaS over IaaS unless a specific requirement (OS control, legacy software, unsupported runtime) forces a VM. This is the "use managed services" design principle.
2. For containers, the decision narrows to: App Service for simple containerized web apps, Container Apps for serverless containers and microservices without Kubernetes, and AKS when Kubernetes control is required.
3. The guidance treats "the app is containerized" as insufficient to choose AKS. The deciding question is whether the team needs Kubernetes APIs and cluster control, which separates AKS from Container Apps.
4. IaaS is the fallback when managed options cannot meet a hard requirement, not the default. This mirrors the rehost-versus-replatform tension in the CAF strategies.
5. The decision is requirement-driven and per workload, so different workloads in the same estate can correctly resolve to different services.

### AZ-305 exam discriminator

Use the decision guidance to eliminate wrong answers: managed service first, VM only when control is required, AKS only when Kubernetes is required, Container Apps for serverless containers, App Service for managed web apps.

### Common trap

Reaching for the most powerful or most "modern" service. The guidance picks the simplest managed service that meets the requirement, which keeps operations low.

---

## Highest-yield exam discriminators

| Scenario clue | Best answer | Why |
|---|---|---|
| "Minimal or no code changes," "lift and shift" | Rehost to Azure VMs | Rehost keeps the workload unchanged; VM is the default IaaS target. |
| "Must retain OS control," custom agents, legacy runtime | Azure Virtual Machines | Only IaaS gives OS-level control and legacy compatibility. |
| "Reduce infrastructure management for a web app" | Azure App Service | PaaS removes OS and patching; replatform target for web apps. |
| "Need Kubernetes APIs," custom controllers, service mesh | Azure Kubernetes Service | AKS is chosen when Kubernetes control itself is the requirement. |
| "Serverless containers," "avoid cluster management," bursty event-driven scale | Azure Container Apps | Serverless containers with KEDA scale-to-zero, no Kubernetes ops. |
| "Keep VMware tooling," vSphere/NSX continuity, fast data-center exit | Azure VMware Solution | Preserves the VMware operational model on managed bare metal. |
| "Web app needs private inbound access" | App Service private endpoint | Private endpoint gives private inbound; App Service is not private by default. |
| "App must reach on-premises or VNet resources" | App Service VNet integration | VNet integration controls outbound connectivity. |
| "Unknown dependencies between servers" | Azure Migrate dependency analysis | Identifies connections so dependent servers move in the same wave. |
| "Right-size overprovisioned servers / control cost" | Azure Migrate performance-based assessment and business case | Performance-based sizing and TCO drive the cost decision. |
| "Cost justification required before migrating" | Azure Migrate business case | Pre-migration TCO and savings (Hybrid Benefit, reservations). |
| "Optimize cost after migration" | Microsoft Cost Management | Post-migration analysis, budgets, and recommendations. |
| "Multiple business units / subscriptions / governance" | Azure landing zones first | Inherit identity, network, and policy before workloads land. |
| "Enterprise policy restricts regions or SKUs" | Validate Azure Policy and landing zone readiness | A deny policy can block the target before cutover. |
| "Highest IOPS, lowest latency" with no ZRS or availability set need | Ultra Disk | Top performance, but no ZRS, no availability sets, not an OS disk. |
| "High-performance disk that must survive a zone failure" | Premium SSD with ZRS | Ultra and Premium SSD v2 do not support ZRS. |
| "Private, high-bandwidth, low-latency hybrid link" or AVS | ExpressRoute | Dedicated private circuit; mandatory for AVS; not encrypted by default. |
| "Encrypted hybrid link, quick and lower cost" | VPN Gateway | IPsec over the internet; faster and cheaper to provision. |
| "Move a very large data set under a deadline" | Azure Data Box | Offline transfer when online bandwidth cannot meet the timeline. |
| "Event-driven component broken out of a monolith" | Azure Functions | Component-level modernization, not whole-server migration. |
| "What should you do first" in a migration program | Discover, assess, build business case (then landing zone, then migrate) | CAF order: assess and prepare before cutover. |
