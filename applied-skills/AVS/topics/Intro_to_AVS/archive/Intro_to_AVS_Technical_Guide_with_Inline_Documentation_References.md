# Azure VMware Solution: Architecture, Migration, Networking, Storage, and Operations Guide

## Purpose and Source Scope

Azure VMware Solution (AVS) provides a Microsoft-operated VMware private cloud on dedicated bare-metal infrastructure in Azure. Its central value proposition is not automatic application modernization; it is the ability to move or extend a VMware estate into Azure while retaining VMware compute, storage, networking, management, and migration tooling. [What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) [Azure VMware Solution private-cloud architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)

This guide preserves the supplied transcript’s organization, examples, analogies, calculations, and operational framing. Technical claims have been checked against the current official Microsoft documentation and, where Microsoft does not document VMware behavior in sufficient detail, official Broadcom documentation. Documentation corrections and unsupported transcript-derived claims are called out explicitly.

> **Source normalization note:** Obvious speech-to-text variants have been normalized for readability. Examples include ESX, ESXE, or ESSI as **ESXi**; vSYN or VSN as **vSAN**; HTX as **HCX**; and M-MAS as **MAC address**. These corrections do not change the apparent technical meaning of the transcript.

---

## 1. Why Azure VMware Solution Exists

AVS addresses a migration problem that cloud-native refactoring strategies often fail to solve economically or within acceptable timelines. Many mission-critical applications remain tightly coupled to the VMware environment, operating model, and virtualized infrastructure for which they were designed.

* **Historical cloud-modernization strategy:** Organizations were encouraged to break apart monolithic applications, containerize workloads, rewrite applications as microservices, and pursue effectively unlimited cloud scalability.

* **Observed migration friction:** According to the transcript, those initiatives frequently resulted in millions of dollars in consulting costs, multiyear delays, and applications that could not be cleanly separated from their underlying virtualized environment.

* **Infrastructure pressure:** Organizations may simultaneously face:

  * Aging on-premises hardware.
  * Expiring enterprise licensing agreements.
  * Requirements for stronger security and broader geographic reach.
  * Demand for integration with Microsoft Azure services.
  * A VMware estate that is too operationally significant to refactor quickly.

* **AVS response:** AVS preserves a VMware execution and management environment while relocating it to dedicated infrastructure operated in Azure. [What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)

* **Primary migration objective:** The platform minimizes replatforming rather than forcing immediate application redesign.

* **Operational continuity:** Existing administrators can continue using familiar VMware interfaces and supported integrations after the infrastructure has moved to Azure; individual scripts, backup products, and operational tools still require compatibility validation. [Azure VMware Solution private-cloud architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)

> **Transcript-derived analogy:** AVS is presented as bringing a carefully preserved piece of the past onto substantially better real estate. The organization retains the house it knows how to operate while Microsoft supplies and maintains the land, foundation, utilities, and physical infrastructure.

### Key implication

AVS should be evaluated as a migration-acceleration and operational-continuity platform. It does not inherently convert a VMware application into an Azure-native application. [Migration options for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)

---

## 2. Foundational Architecture

The most important architectural distinction is that AVS uses dedicated bare-metal hosts rather than VMware nested inside conventional Azure virtual machines. Microsoft documents ESXi as running on dedicated bare-metal infrastructure that forms the AVS private cloud. [Azure VMware Solution private-cloud architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)

> **Documentation clarification:** Microsoft documents AVS as dedicated bare-metal infrastructure and explicitly states that running ESXi as a nested-virtualization solution is not supported. The reviewed documentation does not describe the physical implementation using the transcript’s exact phrase “no Azure hypervisor sits between ESXi and the server.” [Does Azure VMware Solution support running ESXi as a nested virtualization solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/faq#does-azure-vmware-solution-support-running-esxi-as-a-nested-virtualization-solution)

### 2.1 Dedicated bare-metal deployment

* **Physical architecture:** AVS runs VMware on dedicated bare-metal servers located in Azure regions. [What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)

* **No nested hypervisor:** The transcript describes the service as having no intervening Azure hypervisor. This is consistent with Microsoft’s documented dedicated bare-metal architecture, but the precise implementation wording is transcript-derived.

* **Performance rationale:** The transcript characterizes nested VMware virtualization inside an Azure VM as an unacceptable design because the additional virtualization layer would introduce severe latency and performance overhead. This rationale is transcript-derived rather than an AVS product limit stated in the reviewed documentation.

* **Cloud consumption model:** Customers receive dedicated host capacity, while Microsoft manages the physical infrastructure and the lifecycle of the supported VMware software stack. [Azure VMware Solution responsibility matrix - Microsoft vs customer](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-responsibility-matrix---microsoft-vs-customer) [Azure VMware Solution private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 2.2 Microsoft-managed infrastructure

Microsoft is responsible for the physical and foundational platform components.

* Microsoft manages the physical server hardware and replaces failed hosts. [Azure VMware Solution responsibility matrix - Microsoft vs customer](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-responsibility-matrix---microsoft-vs-customer)

* Microsoft manages top-of-rack network switches.

* Microsoft manages power distribution and data-center infrastructure.

* Microsoft manages lifecycle operations for the core VMware software stack. [Azure VMware Solution private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

* During host maintenance or replacement, Microsoft places the host into maintenance mode and evacuates workloads where the service workflow permits. [Azure VMware Solution private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

* Microsoft replaces failed hardware without requiring the customer’s operations team to manage the physical repair.

> **Transcript-derived scenario:** If a physical memory module fails overnight, the transcript describes Microsoft detecting the failure, evacuating workloads, and replacing the affected hardware without a customer-side hardware pager event. Microsoft documents responsibility for correcting and replacing failed hosts, but not this exact failure sequence or alerting outcome. [Azure VMware Solution responsibility matrix - Microsoft vs customer](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-responsibility-matrix---microsoft-vs-customer)

---

## 3. VMware Components and Azure Equivalents

An AVS private cloud contains integrated VMware components. Azure Resource Manager exposes and governs the AVS resource at the Azure control plane, while VMware management components manage the software-defined data center on the hosts. [Azure VMware Solution private-cloud architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)

| Component          | Primary responsibility                                                                                   | Approximate Azure-native comparison                                                    | Important distinction                                                                                      |
| ------------------ | -------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| **ESXi**           | Abstracts physical CPU and memory and presents them to virtual machines.                                 | Azure hypervisor or compute fabric.                                                    | ESXi runs directly on the dedicated bare-metal server.                                                     |
| **vCenter Server** | Provisions VMs, configures clusters, monitors performance, and centrally manages the VMware environment. | Azure Resource Manager orchestration and Azure management APIs.                        | Azure Resource Manager provisions the AVS physical environment, while vCenter manages the VMs inside it.   |
| **vSAN**           | Pools local NVMe and SSD devices into a shared software-defined datastore.                               | Azure managed-disk and storage services.                                               | AVS storage is initially coupled to the physical hosts through hyper-converged infrastructure.             |
| **NSX**            | Provides software-defined switches, routers, gateways, and firewalls.                                    | Azure Virtual Network, route tables, network security controls, and firewall services. | Workload networks are managed inside the VMware networking layer rather than being ordinary Azure subnets. |
| **VMware HCX**     | Provides workload mobility, migration, network extension, and migration optimization.                    | Azure migration and network-extension services.                                        | HCX communicates with both source and destination vCenter environments using VMware-native semantics.      |

> **Architectural interpretation:** The Azure-native comparisons in the table are approximate functional analogies, not one-to-one service equivalences. The authoritative AVS component roles are documented in [Azure VMware Solution private-cloud architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds).

### 3.1 Division of management responsibility

* **Azure Resource Manager responsibility:** Azure Resource Manager deploys and manages the AVS private-cloud resource and host capacity. [Scale an Azure VMware Solution private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)

* **vCenter responsibility:** vCenter manages VMs, clusters, resource pools, and VMware operational workflows inside the private cloud. [Azure VMware Solution private-cloud architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)

* **NSX responsibility:** NSX provides the logical networking and distributed-security layer used by VMware workloads. [Azure VMware Solution private-cloud architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)

* **HCX responsibility:** HCX provides supported migration and network-extension workflows between paired VMware environments. [Migration options for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)

### 3.2 Why vCenter remains necessary

Replacing vCenter with Azure-native VM management would undermine the platform’s migration value.

* Existing VMware deployment scripts depend on vCenter APIs and objects.

* Third-party backup integrations such as Veeam and Commvault depend on VMware management interfaces.

* Existing monitoring systems, dashboards, and operating procedures assume a vCenter-managed environment.

* Removing vCenter would require teams to rewrite their operational model using Azure Resource Manager templates, Bicep, or other Azure-native tooling.

* Keeping vCenter allows administrators to encounter substantially the same management interface after migration that they used before migration.

* HCX pairs source and destination sites through HCX Connector and HCX Cloud Manager, with each side integrated with its VMware environment. [Configure VMware HCX in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)

* The preservation of vCenter supports live migration and operational familiarity without requiring an immediate tooling transformation.

### 3.3 Software lifecycle

Microsoft manages lifecycle operations for the core VMware stack, including vCenter, ESXi, vSAN, and NSX, through the AVS maintenance process. [Azure VMware Solution private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

At the time of this documentation review, Microsoft lists vCenter Server 8.0 U3e, ESXi 8.0 U3f with an additional hot patch, vSAN 8.0 U3, NSX 4.2.3.2, and HCX 4.11.3 as the software versions deployed for the current service. These values are time-sensitive and should be rechecked for the target region and deployment date. [VMware software versions](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#vmware-software-versions)

> **Documentation correction:** The transcript’s NSX 4.1.1 value is no longer current in the reviewed Microsoft documentation. Version strings should not be encoded as permanent architecture requirements.

---

## 4. Management Resource Reservation

The first AVS cluster contains a dedicated management resource pool that protects the VMware control plane. Unlike many native cloud services, AVS exposes the practical capacity impact of that control plane. [Plan an Azure VMware Solution deployment](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment)

* **Resource-pool name:** Microsoft documents the reserved pool as `MGMT-ResourcePool`. [Determine the number of clusters and hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#determine-the-number-of-clusters-and-hosts)

* **CPU reservation:** The pool reserves 46 GHz of CPU capacity. [Determine the number of clusters and hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#determine-the-number-of-clusters-and-hosts)

* **Memory reservation:** The pool reserves 171.88 GB of memory. [Determine the number of clusters and hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#determine-the-number-of-clusters-and-hosts)

* **Availability:** Customers cannot assign these resources to application workloads.

* **Purpose:** The reservation protects vCenter, NSX management components, HCX appliances, and other foundational services.

* **N+1 capacity model:** Microsoft’s three-node planning guidance treats two nodes as available for workloads after subtracting management overhead and reserves one node for resiliency. [Plan an Azure VMware Solution deployment](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment)

* **Failure behavior:** If one server is lost, management components must be able to restart or continue running on surviving hosts while the environment remains manageable.

> **Architectural interpretation:** The visible management reservation is the capacity cost of preserving a complete VMware control plane inside a dedicated private cloud. Native Azure services often hide comparable platform overhead from the customer’s resource view.

### Operational implication

Capacity planning must subtract management overhead before estimating usable application capacity. A minimum three-host cluster should not be modeled as though all physical CPU and memory are available to workloads.

---

## 5. Cluster Scale and Host Options

AVS scales in host-sized blocks rather than in small VM-sized increments. Because the initial architecture is hyper-converged, adding a host usually adds CPU, memory, and local storage together.

### 5.1 Platform scale limits stated in the transcript

* A cluster requires a minimum of three hosts. [Scale an Azure VMware Solution private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)

* A cluster can scale to a maximum of 16 hosts. [Scale an Azure VMware Solution private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)

* A private cloud can contain up to 96 hosts. [Scale an Azure VMware Solution private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)

* A private cloud can contain a maximum of 12 clusters. [Scale an Azure VMware Solution private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)

> **Documentation note:** These are current documented service limits, but host availability and supported SKUs remain region-dependent. [Scale an Azure VMware Solution private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)

### 5.2 Host SKU characteristics

Microsoft’s current host table documents the following specifications. All listed host types provide 100-Gbps NIC throughput; vSAN architecture and capacity differ by SKU and AVS generation. [Hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#hosts-clusters-and-private-clouds)

| Host SKU | Processor | Physical cores | Logical cores | Memory per host | vSAN architecture | Raw cache tier | Raw capacity tier |
| --- | --- | ---: | ---: | ---: | --- | ---: | ---: |
| **AV36** | Dual Intel Xeon Gold 6140, Skylake | 36 | 72 | 576 GB | Original Storage Architecture (OSA) | 3.2 TB NVMe | 15.20 TB SSD |
| **AV36P** | Dual Intel Xeon Gold 6240, Cascade Lake | 36 | 72 | 768 GB | OSA | 1.5 TB Intel cache | 19.20 TB NVMe |
| **AV48** | Dual Intel Xeon Gold 6442Y, Sapphire Rapids | 48 | 96 | 1,024 GB | Express Storage Architecture (ESA) | Not applicable | 25.60 TB NVMe |
| **AV52** | Dual Intel Xeon Platinum 8270, Cascade Lake | 52 | 104 | 1,536 GB | OSA | 1.5 TB Intel cache | 38.40 TB NVMe |
| **AV64** | Dual Intel Xeon Platinum 8370C, Ice Lake | 64 | 128 | 1,024 GB | OSA for Generation 1; ESA for Generation 2 | 3.84 TB NVMe for Generation 1; not applicable for Generation 2 | 15.36 TB NVMe for Generation 1; 19.25 TB NVMe for Generation 2 |

> **Documentation correction:** The transcript left several core counts unstated and inferred AV48’s core count from the SKU name. The table now uses Microsoft’s explicit per-host specifications rather than inference. Host availability and supported deployment combinations remain region- and generation-dependent.

> **Documentation note:** Microsoft’s current host-specification table lists 15.20 TB raw capacity for AV36, while the separate storage-concepts article still contains a 15.4-TB value. This guide uses the more detailed current host table and flags the discrepancy for deployment-time validation. [Hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#hosts-clusters-and-private-clouds)


### 5.3 Hyper-converged purchasing behavior

* For vSAN-backed clusters, compute, memory, and local storage are delivered together in each host. [Storage architecture for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage)

* Adding capacity means purchasing another full enterprise host rather than adding only a small amount of CPU or disk.

* Organizations may therefore acquire more compute than needed when their actual constraint is storage.

* External datastore integrations can change this economic model by allowing storage expansion independently of host count. [External storage solutions for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/ecosystem-external-storage-solutions)

---

## 6. Host Uniformity and the AV64 Exception

Host-mixing rules depend on AVS generation and cluster design; the transcript’s private-cloud-wide “all hosts must be identical” rule is too broad.

* **Cluster-level homogeneity:** A conventional AVS cluster is built from a supported host SKU. Capacity is added in host-sized increments and supported combinations must follow the service’s current host rules. [Hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#hosts-clusters-and-private-clouds)

* **Generation 1 AV64 expansion:** In Generation 1, AV64 is documented as an expansion host type that requires a supported seed cluster. Microsoft’s current documentation lists AV36, AV36P, AV48, or AV52 as supported seed host types. [Azure VMware Solution private cloud extension with AV64 node size](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-private-cloud-extension-with-av64-node-size)

* **Generation 2 AV64 deployment:** Generation 2 removes the seed-cluster requirement and supports direct deployment of a three-host AV64 private cloud. [Azure VMware Solution Generation 2 overview](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)

* **Stretched-cluster constraint:** AV64 is not supported for the Generation 1 stretched-cluster design, and Generation 2 currently does not support stretched clusters. [Azure VMware Solution private cloud extension with AV64 node size](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-private-cloud-extension-with-av64-node-size) [Azure VMware Solution Generation 2 design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration)

> **Documentation correction:** The transcript’s statement that AV64 can never be deployed as the initial cluster applies only to Generation 1. It is incorrect for Generation 2.


---

## 7. Enhanced vMotion Compatibility and Mixed CPU Generations

Introducing AV64 hosts alongside older CPU generations creates a live-migration compatibility problem. VMware Enhanced vMotion Compatibility (EVC) addresses that problem by presenting a controlled CPU feature baseline to virtual machines. [Enhanced vMotion Compatibility with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension)

### 7.1 The CPU compatibility problem

* A VM observes a set of CPU features when it boots.

* A newer processor may expose instructions that do not exist on an older processor.

* A running VM may begin using newer instructions after booting on newer hardware.

* Moving that VM live to an older CPU could cause execution failure if the destination lacks those instructions.

* VMware compatibility checks block a live migration when the destination cannot provide the CPU feature set exposed to the running VM. [Enhanced vMotion Compatibility with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension)

### 7.2 How EVC works

* EVC masks selected CPU features to present a compatible baseline. [Enhanced vMotion Compatibility with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension)

* It causes newer processors to present themselves as an older, least-common-denominator processor baseline.

* Guest operating systems and applications see only the feature set represented by the configured EVC mode.

* Newer processors remain capable of running workloads constrained to an older feature baseline.

> **Transcript-derived analogy:** A document created in an older version of Microsoft Word can usually open in a newer version because the newer software understands the older format. A document enhanced with features that exist only in the newer version may no longer open correctly in the older application.

### 7.3 Migration behavior described in the transcript

| VM history                                                                            | Observed CPU baseline                   | Attempted move                                 | Expected outcome                                                                                            |
| ------------------------------------------------------------------------------------- | --------------------------------------- | ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| VM boots on an older base cluster and then moves to AV64 without rebooting. | Older baseline remains active. | Live migration back to the older cluster. | The migration succeeds because the VM retains the original CPU baseline. [Enhanced vMotion Compatibility with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension) |
| VM is created or rebooted directly on AV64 without a compatible VM-level EVC baseline. | Newer Ice Lake features may be exposed. | Live migration to an older base cluster. | The move is blocked by EVC compatibility checks. [Enhanced vMotion Compatibility with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension) |
| VM boots on AV64 with VM-level EVC matching the older cluster. | Older baseline is enforced. | Live migration to the older cluster. | The migration can proceed because unsupported newer features were not exposed. [Enhanced vMotion Compatibility with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension) |
| VM uses newer features and no compatible EVC baseline was set. | Newer baseline is active. | Cold migration after full shutdown. | Power off the VM, move it, and restart it against the older CPU profile. [Enhanced vMotion Compatibility with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension) |

### 7.4 Required configuration sequence

1. Identify the oldest CPU generation to which the VM may need to migrate. [Enhanced vMotion Compatibility with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension)

2. Determine the corresponding EVC baseline for that older cluster.

3. Configure VM-level EVC before the VM first boots on AV64 hardware.

4. Confirm that the VM sees only the intended instruction-set baseline.

5. Test live migration in both directions before treating the VM as operationally portable.

6. Document the EVC setting in the VM build standard and scaling runbook.

7. If an incompatible VM has already booted on newer hardware, schedule a shutdown and cold migration rather than attempting an unsupported live move.

> **Operational recommendation:** Treat VM-level EVC as a mandatory provisioning control for any workload that may move from AV64 back to an older base cluster. A missed configuration can convert a nondisruptive migration into a maintenance-window event.

---

## 8. vSAN Storage Architecture

AVS initially uses hyper-converged storage. Local storage devices inside the ESXi hosts are combined by vSAN into a shared datastore available to the cluster. [Storage architecture for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage)

### 8.1 Difference from native Azure storage

* In native Azure, managed disks and other storage services are provisioned independently from AVS host-local vSAN capacity. [Storage architecture for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage)

* An Azure VM can attach managed disks that are provisioned independently of the VM host.

* Increasing storage does not inherently require purchasing additional CPU or memory.

* In the AVS vSAN model, storage originates from local devices inside the deployed ESXi hosts. [Storage architecture for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage)

* Adding a host increases compute, memory, and storage as a combined unit.

### 8.2 AV36 storage values stated in the transcript

An AV36 host is described as containing:

* 3.2 TB of raw NVMe capacity for the cache tier. [Hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#hosts-clusters-and-private-clouds)

* 15.20 TB of raw SSD capacity for the capacity tier. [Hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#hosts-clusters-and-private-clouds)

* vSAN pools the host-local devices into a shared software-defined datastore. [Storage architecture for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage)

### 8.3 Example raw-capacity calculation

> **Transcript-derived calculation: Three-host AV36 capacity**

1. **Inputs**

   * Three AV36 hosts.
   * 15.2 TB of persistent SSD capacity per host.
   * A 75% maximum utilization boundary documented for AVS vSAN usable capacity. [Azure VMware Solution networking limitations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#limitations)

2. **Formula**

   * Raw persistent capacity:
     `3 hosts × 15.2 TB per host = 45.6 TB`
   * Capacity at 75% utilization:
     `45.6 TB × 0.75 = 34.2 TB`

3. **Result**

   * The cluster contains 45.6 TB of raw persistent SSD capacity.
   * The 75% operating threshold is reached at 34.2 TB of consumed raw capacity.

4. **Practical interpretation**

   * At least 11.4 TB remains unconsumed to preserve the 25% operational buffer.

5. **Why real usable capacity differs**

   * RAID mirroring or erasure coding consumes additional capacity.
   * Management and metadata overhead reduce usable space.
   * Rebuild requirements and object-placement rules affect capacity.
   * Workload growth and thin-provisioned commitments may exceed current physical usage.
   * The calculation does not represent guaranteed application-usable capacity.

---

## 9. Fault Domains and Host Placement

A fault domain represents infrastructure that shares a common point of failure. AVS host placement and vSAN fault-domain design are intended to keep protected data components from depending on the same failure boundary. [AV64 cluster vSAN fault-domain design and recommendations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#av64-cluster-vsan-fault-domain-fd-design-and-recommendations)

### 9.1 Traditional AV36 and AV52 behavior

* Microsoft does not expose explicit vSAN fault domains in vCenter for the traditional AV36-, AV36P-, and AV52-based designs described in the documentation. [AV64 cluster vSAN fault-domain design and recommendations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#av64-cluster-vsan-fault-domain-fd-design-and-recommendations)

* Microsoft’s backend placement logic separates hosts physically.

* Microsoft documents backend host-placement logic that keeps hosts in a cluster from sharing the same physical fault domain; the documentation does not reduce this guarantee solely to “different racks.” [AV64 cluster vSAN fault-domain design and recommendations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#av64-cluster-vsan-fault-domain-fd-design-and-recommendations)

* The physical-separation policy is handled by the AVS platform rather than customer configuration.

### 9.2 AV64 fault-domain behavior

* Most AV64 deployments expose seven explicit vSAN fault domains in vCenter; Microsoft notes that some older regions use five. [AV64 cluster vSAN fault-domain design and recommendations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#av64-cluster-vsan-fault-domain-fd-design-and-recommendations)

* As an AV64 cluster grows from three to 16 hosts, AVS automation balances host placement across the available fault domains. [AV64 cluster vSAN fault-domain design and recommendations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#av64-cluster-vsan-fault-domain-fd-design-and-recommendations)

* Host placement is actively balanced to preserve structural redundancy.

### 9.3 Scale-down failure condition

* A customer cannot necessarily remove an arbitrary AV64 host.

* AVS evaluates whether host removal would leave the fault domains in an unsupported imbalance. [AV64 host-removal workflow and best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#av64-host-removal-workflow-and-best-practices)

* If the requested removal would violate placement requirements, the platform rejects the operation.

* An invalid AV64 removal request is rejected with HTTP `409 Conflict`. [AV64 host-removal workflow and best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#av64-host-removal-workflow-and-best-practices)

> **Failure condition:** An AV64 scale-down operation can fail even when the cluster has enough aggregate CPU, memory, and storage. Fault-domain placement, rather than simple capacity, may determine which host can be removed.

### Operational implication

Scale-down procedures must account for host-to-fault-domain placement. Cost-reduction plans should not assume that any selected host can be deleted.

---

## 10. The 75% vSAN Utilization Limit

Microsoft documents a 75% maximum consumption limit for total usable vSAN capacity and requires the remaining 25% to be available to preserve the AVS SLA. [Azure VMware Solution networking limitations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#limitations)

### 10.1 Why the buffer is required

* vSAN implements redundancy in software rather than depending on a traditional hardware RAID controller.

* The system uses host CPU and network traffic to write, mirror, encode, and rebalance data.

* Background garbage collection requires unallocated space.

* Rebalancing is necessary when one node or device carries disproportionate load.

* Drive or host failure requires replacement data components to be rebuilt elsewhere.

* A full-host failure can trigger a large reconstruction event across the surviving hosts.

### 10.2 Rebuild-storm scenario

* A host fails and its data components become unavailable.

* vSAN begins recreating those components on surviving storage devices.

* The surviving cluster must contain enough unused physical capacity to restore the required redundancy.

* If the cluster is already nearly full, vSAN may lack the placement space required for reconstruction.

* The platform is then exposed to additional risk if a second device or host fails.

### 10.3 Service-level consequence

* Microsoft states that consumption must remain at or below 75% of total usable vSAN capacity to maintain the AVS SLA. [Azure VMware Solution networking limitations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#limitations)

* Operating above the documented 75% boundary places the environment outside that capacity condition; 85% is a transcript example rather than a separately published Microsoft threshold. [Azure VMware Solution networking limitations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#limitations)

> **Documentation note:** Microsoft directly publishes the 75% usable-capacity condition, but contractual remedies, exclusions, and measurement details should be read in the current Azure VMware Solution SLA before reliance. [Azure VMware Solution networking limitations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#limitations)

### Operational recommendation

Trigger expansion planning well before utilization reaches 75%. Procurement lead time, host availability, data rebalancing, and fault-domain constraints can make last-minute expansion unsafe.

---

## 11. Failures to Tolerate and RAID Policies

VMware expresses vSAN resilience through failures to tolerate (FTT), while the RAID layout determines how the required copies or parity components are distributed. Microsoft documents the following minimum host counts for AVS storage-policy options. [AV64 supported RAID configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#av64-supported-raid-configuration)

| Storage policy | Minimum hosts | Documented protection |
| --- | ---: | --- |
| **RAID 1, FTT=1** | 3 | Mirroring that can tolerate one host failure. |
| **RAID 5, FTT=1** | 4 | Erasure coding that can tolerate one host failure. |
| **RAID 1, FTT=2** | 5 | Three-way mirroring that can tolerate two host failures. |
| **RAID 6, FTT=2** | 6 | Double-parity erasure coding that can tolerate two host failures. |
| **RAID 1, FTT=3** | 7 | Four-way mirroring that can tolerate three host failures. |

### 11.1 FTT=1 behavior

* FTT=1 requires a compliant object to remain available after one host failure. [Configure a storage policy in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-storage-policy)

* RAID 1 stores mirrored data components on separate fault domains.

* RAID 5 uses erasure coding to reduce capacity overhead compared with full mirroring and requires at least four hosts. [AV64 supported RAID configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#av64-supported-raid-configuration)

### 11.2 FTT=2 behavior

* FTT=2 requires a compliant object to tolerate two host failures.

* RAID 6 uses double-parity erasure coding and requires at least six hosts. [AV64 supported RAID configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#av64-supported-raid-configuration)

* Microsoft advises that clusters with more than six hosts should be configured with FTT=2, but storage policies do not automatically change when a cluster grows. [Storage policies and fault tolerance](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage#storage-policies-and-fault-tolerance)

> **Documentation correction:** The transcript states that every cluster with six through 16 hosts is automatically subject to an SLA-mandated FTT=2 policy. The reviewed Microsoft documentation instead lists minimum host counts, documents FTT=1 as the default workload policy, and advises FTT=2 for clusters with more than six hosts. A policy with FTT set to `None` does not qualify for the AVS SLA. [Configure a storage policy in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-storage-policy)


---

## 12. Thick and Thin Provisioning

AVS supports both thin and thick object-space reservation through vSAN storage policies. Microsoft documents the default workload policy as RAID-1 FTT=1 with **Object Space Reservation** set to thin provisioning. [Storage policies and fault tolerance](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage#storage-policies-and-fault-tolerance)

> **Documentation correction:** The transcript’s statement that the default workload storage policy is thick-provisioned is incorrect. The vSphere UI can show a policy named `vSAN Default Storage Policy` with thick settings, but Microsoft changes the cluster’s applied default workload policy to thin provisioning. [Storage policies and fault tolerance](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage#storage-policies-and-fault-tolerance)

### 12.1 Thick provisioning behavior

* A storage policy with Object Space Reservation set to 100% reserves the object’s full requested capacity. [Configure a storage policy in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-storage-policy)

* In the transcript’s simplified 100-GB example, a thick-provisioned disk reserves 100 GB even when only 10 GB currently contains guest data.

* Reserved logical space is unavailable to other objects and therefore accelerates physical-capacity commitments.

### 12.2 Thin provisioning behavior

* A storage policy with Object Space Reservation set to 0% is thin-provisioned. [Configure a storage policy in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-storage-policy)

* Physical consumption grows as data is written rather than reserving the full logical disk size immediately.

* Thin provisioning improves initial storage efficiency but can create overcommitment risk because total promised logical capacity can exceed installed physical capacity.

### 12.3 Numerical example

> **Transcript-derived calculation: Thick versus thin allocation**

1. **Inputs**

   * Requested virtual disk size: 100 GB.
   * Actual data written: 10 GB.

2. **Formula**

   * Thick allocation: `100 GB reserved`
   * Thin allocation at current usage: `10 GB written`
   * Initial physical-capacity difference:
     `100 GB − 10 GB = 90 GB`

3. **Result**

   * Thick provisioning reserves 100 GB.
   * Thin provisioning initially consumes approximately 10 GB in this simplified example.
   * Thin provisioning avoids approximately 90 GB of immediate allocation before protection-policy and metadata overhead.

4. **Practical interpretation**

   * Across hundreds of VMs, thin provisioning can substantially reduce immediate capacity commitment.

5. **Why the real result may differ**

   * Metadata and protection-policy overhead add consumption.
   * Snapshots increase actual usage.
   * Guest deletions may not immediately release physical blocks.
   * Application growth can consume the remaining logical capacity rapidly.

> **Operational recommendation:** Use storage policies deliberately and monitor both committed and physically consumed capacity. Do not change every workload blindly merely because thin provisioning is the AVS default. [Configure a storage policy in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-storage-policy)


---

## 13. Independent Storage Expansion

Hyper-converged infrastructure can force organizations to add compute hosts when they need only storage. AVS supports external datastore integrations that decouple storage expansion from ESXi host count. [External storage solutions for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/ecosystem-external-storage-solutions)

* A large SQL database may need dozens of terabytes without needing more CPU or memory.

* Buying another AVS host solely for its local drives may be economically inefficient.

* Azure NetApp Files can be attached to AVS as an NFS datastore. [Attach Azure NetApp Files to Azure VMware Solution hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts)

* Azure Elastic SAN can provide a persistent iSCSI VMFS datastore for AVS. [Configure Azure Elastic SAN with Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-azure-elastic-san)

* External datastores allow storage to scale independently from ESXi host count.

* For Generation 1, external datastore traffic traverses the AVS-to-VNet connectivity path; Generation 2 attaches the private cloud directly to delegated VNet subnets. [External storage solutions for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/ecosystem-external-storage-solutions) [Azure VMware Solution Generation 2 overview](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)

* Network latency and routing design therefore become part of the storage architecture.

> **Architectural interpretation:** External datastores shift AVS from a strictly hyper-converged model toward a design in which compute and storage can be scaled separately.

---

## 14. Network Planning Principles

Networking is presented as the highest-risk phase of AVS planning. Address-space and routing choices are deployment prerequisites, and the architecture differs materially between Generation 1 and Generation 2. [Network planning checklist for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations) [Azure VMware Solution Generation 2 design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration)

### 14.1 Dedicated `/22` management block

* AVS requires a minimum nonoverlapping `/22` CIDR block. In Generation 1 it is the private-cloud management block; in Generation 2 it is a VNet address range from which delegated AVS subnets are created. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations) [Azure VMware Solution Generation 2 design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration)

* The transcript uses `10.10.0.0/22` as an example.

* The selected address space must not overlap with connected Azure, on-premises, or other reachable networks. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)

* It must not overlap with Azure virtual networks.

* It must not overlap with on-premises networks.

* In Generation 1, the `/22` is reserved for AVS platform and management networks rather than workload segments. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)

* Generation 1 workload VMs use separate NSX segments rather than addresses from the management `/22`. [Azure VMware Solution network architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking)

### 14.2 Generation 1 internal subdivision

Microsoft documents a more detailed Generation 1 subdivision than the transcript’s four-network summary. The current checklist includes management, migration, ExpressRoute, NSX DNS, ESXi, vMotion, replication, vSAN, HCX uplink, and reserved ranges. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)

| Internal use | Prefix size documented |
| --- | ---: |
| vCenter and NSX management | `/26` |
| HCX management migrations | `/26` |
| ExpressRoute Global Reach | `/26` |
| NSX DNS | `/32` |
| ExpressRoute | `/27` |
| ESXi management | `/25` |
| vMotion | `/25` |
| Replication | `/25` |
| vSAN | `/25` |
| HCX uplink | `/26` |
| Additional platform and reserved ranges | Multiple Microsoft-reserved prefixes within the `/22` |

> **Documentation correction:** The transcript’s table omitted several current Generation 1 allocations and treated “HCX and backend ExpressRoute functions” as one undifferentiated remainder. Generation 2 uses a different native-VNet delegated-subnet model and should not be designed from this Generation 1 table. [Delegated Subnets and Network Security Groups for Gen 2](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration#delegated-subnets-and-network-security-groups-for-gen-2)


### 14.3 Address-allocation calculation

> **Transcript-derived calculation: Original simplified `/22` subdivisions**

1. **Inputs**

   * One `/26`.
   * Three `/25` networks.

2. **Formula**

   * `/26` address count: `64`
   * `/25` address count: `128`
   * Three `/25` networks: `3 × 128 = 384`
   * Simplified allocated addresses: `64 + 384 = 448`
   * Total addresses in a `/22`: `1,024`
   * Simplified remainder: `1,024 − 448 = 576`

3. **Result**

   * The arithmetic in the transcript is correct for its stated inputs.
   * It is not a complete calculation of the current Generation 1 AVS allocation because the documented design includes additional HCX, ExpressRoute, replication, DNS, and reserved prefixes.

4. **Practical interpretation**

   * The `/22` supports multiple isolated infrastructure networks rather than only the initial host count.

5. **Why the real result differs**

   * Microsoft reserves additional ranges inside the block.
   * The documented automated subdivision includes more networks than the transcript listed.
   * Generation 2 uses delegated VNet subnets and a different internal architecture. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations) [Azure VMware Solution Generation 2 design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration)


### 14.4 Workload networks

* Workload VMs reside on separate NSX segments.

* In Generation 1, customers create NSX segments and tier-1 gateways for workload networks. [Azure VMware Solution network architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking)

* Workloads may use newly designed IP addressing.

* HCX Network Extension can stretch supported on-premises Layer 2 networks into AVS during migration. [Configure HCX Network Extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension)

* The platform `/22` should never be treated as a general-purpose workload address pool.

### Key dependency

The AVS address space must be selected before deployment and remain nonoverlapping across the connected hybrid network. Apply the correct Generation 1 or Generation 2 subnet model. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations) [Azure VMware Solution Generation 2 design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration)

---

## 15. ExpressRoute Connectivity

Generation 1 AVS uses Microsoft ExpressRoute for private connectivity between the isolated private cloud and Azure virtual networks. Generation 2 instead uses native VNet connectivity through delegated subnets. [Azure VMware Solution network architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking) [Azure VMware Solution Generation 2 overview](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)

### 15.1 AVS-to-Azure connectivity

* For Generation 1, Microsoft provisions a managed ExpressRoute circuit as part of private-cloud deployment. [Azure VMware Solution network architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking)

* An ExpressRoute authorization and VNet gateway connection connect a Generation 1 private cloud to an Azure VNet. [Azure VMware Solution network architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking)

* AVS workloads use this path to reach native Azure services.

* Generation 1 external datastores such as Azure NetApp Files depend on correctly designed AVS-to-VNet connectivity. [Attach Azure NetApp Files to Azure VMware Solution hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts)

### 15.2 On-premises connectivity problem

For Generation 1, connecting an on-premises ExpressRoute circuit and the AVS managed circuit to the same VNet does not make the VNet gateway a transit router between those circuits. [Azure VMware Solution network architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking)

* An organization may already have an ExpressRoute circuit from its physical data center to an Azure virtual network.

* AVS has its own ExpressRoute circuit connected to Azure.

* The Azure VNet gateway does not automatically provide circuit-to-circuit transit between the on-premises circuit and the AVS circuit. [Azure VMware Solution network architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking)

* Connecting both circuits to the same virtual network does not create end-to-end transit.

### 15.3 ExpressRoute Global Reach

ExpressRoute Global Reach can connect the on-premises and AVS ExpressRoute circuits through Microsoft’s backbone. [Connect on-premises environments to Azure VMware Solution with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)

1. The on-premises packet enters Microsoft’s edge network.

2. The edge router forwards it directly toward the AVS circuit.

3. The packet bypasses the Azure virtual network gateway as an intermediate transit device.

4. AVS receives the traffic through its dedicated ExpressRoute path.

> **Architectural interpretation:** For the supported Generation 1 pattern, Global Reach provides circuit-to-circuit connectivity rather than expecting an Azure VNet gateway to bridge the circuits. [Connect on-premises environments to Azure VMware Solution with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)

---

## 16. BGP Route Limits and Summarization

Border Gateway Protocol (BGP) route scale is a critical design constraint, but the applicable limit depends on the architecture. For an Azure Route Server design with branch-to-branch enabled, Microsoft limits the combined VNet address-space routes and routes advertised by Route Server toward an ExpressRoute circuit to 1,000 prefixes. Generation 2 separately documents a 1,000-prefix VNet address-space limit. [Azure Route Server frequently asked questions](https://learn.microsoft.com/en-us/azure/route-server/route-server-faq) [Route architecture for Azure VMware Solution Gen 2](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

* **Route Server scope:** The 1,000-prefix limit applies to routes advertised from the VNet address space and Azure Route Server toward ExpressRoute when branch-to-branch is enabled. [Azure Route Server frequently asked questions](https://learn.microsoft.com/en-us/azure/route-server/route-server-faq)

* **Risk profile:** Legacy networks may contain thousands of fragmented subnets.

* **Transcript-derived failure scenario:** The transcript states that advertising approximately 1,500 routes can cause the BGP peering session to fail.

* **Service consequence:** A failed BGP adjacency or route-withdrawal event can interrupt reachability between AVS and on-premises networks. [Azure VMware Solution network architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking)

* **Not directly supported by the reviewed documentation:** The transcript’s specific explanation that the limit exists to protect regional edge-router stability was not confirmed in the reviewed official documentation.

> **Documentation correction:** Microsoft does not document a universal rule that advertising 1,500 on-premises routes to AVS causes BGP peering to fail. Azure Route Server documents a different 4,000-route limit for routes learned from a BGP peer, above which that peer session is dropped; that is not the same as the 1,000-prefix ExpressRoute-advertisement limit. [Azure Route Server frequently asked questions](https://learn.microsoft.com/en-us/azure/route-server/route-server-faq)

### Required route-preparation process

1. Inventory every prefix that could be advertised toward Azure and AVS.

2. Identify contiguous networks that can be represented by larger aggregate prefixes.

3. Summarize routes on the on-premises core routers or an approved network virtual appliance.

4. Confirm that each advertisement remains below the limit that applies to the selected Generation 1, Route Server, or Generation 2 architecture. [Azure Route Server frequently asked questions](https://learn.microsoft.com/en-us/azure/route-server/route-server-faq) [Route architecture for Azure VMware Solution Gen 2](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

5. Validate that no required management or workload routes are lost through overaggregation.

6. Test BGP failure and recovery before migration traffic depends on the connection.

7. Monitor received and advertised prefix counts continuously.

> **Operational recommendation:** Do not use the production ExpressRoute peering session as the first place to discover that the enterprise routing table exceeds the supported scale.

---

## 17. Bogon and Default-Route Risks

Microsoft’s Generation 1 network guidance identifies specific broad prefixes as unsupported or dangerous advertisements because they can disrupt AVS management reachability. [Azure VMware Solution networking limitations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#limitations)

### 17.1 Prohibited prefixes identified in the transcript

* `0.0.0.0/5` [Azure VMware Solution networking limitations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#limitations)

* `192.0.0.0/3` [Azure VMware Solution networking limitations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#limitations)

> **Documentation note:** The listed prefixes are directly documented for Generation 1 AVS. The generic networking term “bogon” has broader meanings; apply Microsoft’s AVS-specific route guidance rather than relying on the label alone. [Azure VMware Solution networking limitations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#limitations)

### 17.2 Default-route failure scenario

* An on-premises router advertises `0.0.0.0/0` toward Generation 1 AVS. [Connect on-premises environments to Azure VMware Solution with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)

* AVS interprets the route as the path for unknown destinations.

* Without a more-specific management route, a default route can create asymmetric or invalid return routing for AVS management traffic. [Connect on-premises environments to Azure VMware Solution with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)

* Return packets can be misrouted or dropped.

* Administrators may lose access to the vCenter management interface from the office network.

### 17.3 Mitigation described in the transcript

* Advertise a more-specific route for the Generation 1 AVS management `/22` through the intended path. [Connect on-premises environments to Azure VMware Solution with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)

* Ensure the specific route directs management return traffic through the intended path.

* Avoid broad advertisements that override required platform routing behavior.

> **Failure condition:** A valid-looking enterprise default route can act as a management black hole when introduced into AVS without more-specific routing controls.

---

## 18. ExpressRoute FastPath

For Generation 1, ExpressRoute FastPath allows eligible AVS-to-VNet traffic to bypass the gateway data path, reducing gateway processing and increasing supported throughput. Microsoft recommends an Ultra Performance ExpressRoute gateway with FastPath for production AVS connectivity at up to 10 Gbps. [Azure VMware Solution network architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking)

* Without FastPath, eligible traffic follows the ExpressRoute virtual-network-gateway data path.

* With FastPath, data traffic can be forwarded directly to supported VNet resources while the gateway continues to provide control-plane functions. [Azure VMware Solution network architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking)

* External-datastore performance depends on the datastore service, network path, gateway and FastPath eligibility, workload I/O profile, and implementation-specific limits. [External storage solutions for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/ecosystem-external-storage-solutions)

> **Documentation correction:** The transcript’s claim that FastPath is the only way to reach “hundreds of thousands of IOPS” is not directly supported by the reviewed AVS documentation. Microsoft documents FastPath as a recommended Generation 1 connectivity optimization, not as a universal IOPS guarantee. Generation 2 uses native VNet attachment rather than the same managed-ExpressRoute gateway architecture. [Azure VMware Solution Generation 2 overview](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)


---

## 19. Security Baseline and Internet Isolation

AVS workloads are not automatically exposed to the public internet. Internet ingress and egress require an explicit architecture using Azure or third-party network-security services. [Design public internet access for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-design-public-internet-access)

* No workload receives automatic public internet exposure.

* Internet ingress and egress must be intentionally designed.

* Public web ingress can be published through Azure Application Gateway. [Design public internet access for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-design-public-internet-access)

* Application Gateway Web Application Firewall can inspect supported application-layer traffic. [Design public internet access for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-design-public-internet-access)

* Azure Firewall can provide centralized ingress or egress control in supported hub-and-spoke patterns. [Hub-and-spoke network topology with Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)

* Security controls should be inserted before traffic reaches the public internet.

### Operational implication

Public connectivity is an architecture decision, not a default platform behavior. Internet paths, inspection points, address translation, and return routing must be designed explicitly. [Design public internet access for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-design-public-internet-access)

---

## 20. Identity, the CloudAdmin Account, and Least Privilege

Microsoft provisions the high-privilege `cloudadmin@vsphere.local` account for the private cloud. Microsoft recommends treating it as an emergency or initial-configuration identity rather than a routine administrator account. [Identity concepts for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity)

### 20.1 Break-glass account treatment

* Microsoft supplies credentials for `cloudadmin@vsphere.local`, and the password can be regenerated from the Azure control plane. [Rotate CloudAdmin credentials for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/rotate-cloudadmin-credentials)

* The account provides broad control over the vCenter environment.

* Microsoft recommends named identities and least-privilege roles for normal administration rather than routine use of CloudAdmin. [Identity concepts for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity)

* A shared static account cannot provide individual accountability.

* Destructive actions performed with the account are difficult to attribute to a named person.

* **Operational recommendation:** Store the break-glass credential in an approved secrets vault with controlled access and auditing.

* **Operational recommendation:** Rotate the password after emergency use and update any service that still depends on it; Microsoft warns that regeneration breaks services using the old credential. [Rotate CloudAdmin credentials for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/rotate-cloudadmin-credentials)

### 20.2 Active Directory integration

* vCenter can be integrated with an Active Directory identity source; NSX identity integration and role assignments must follow the supported AVS procedures. [Configure an identity source in vCenter for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter)

* Microsoft’s AVS identity-source procedure uses LDAPS for encrypted directory connectivity. [Configure an identity source in vCenter for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter)

* LDAPS encrypts directory queries and authentication exchanges in transit.

* Custom vCenter roles and group mappings should implement least privilege. [Identity concepts for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity)

* Roles should be assigned to defined Active Directory groups.

* Administrators should sign in with named individual accounts.

* Named accounts provide a usable audit trail.

### 20.3 Recommended identity sequence

1. Secure the initial CloudAdmin credential in an approved secrets vault.

2. Establish network reachability from AVS management components to the directory service.

3. Configure the supported LDAPS identity-source integration for vCenter and, where required, the supported NSX identity configuration. [Configure an identity source in vCenter for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter)

4. Validate certificate trust and encrypted authentication.

5. Create granular roles aligned with operational responsibilities.

6. Map corporate Active Directory groups to those roles.

7. Test named-user access.

8. Remove CloudAdmin from daily operational workflows.

9. Implement an emergency-use and immediate-rotation procedure.

---

## 21. Azure Control-Plane Governance

Securing VMware identity does not protect the Azure resource layer by itself. Azure RBAC separately governs who can perform AVS control-plane operations. [What is Azure role-based access control?](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)

* The AVS private cloud is represented as a resource in Azure.

* Azure permissions should be scoped so that only authorized operators can invoke AVS credential and lifecycle operations. [What is Azure role-based access control?](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)

> **Not directly supported by the reviewed documentation:** The transcript specifically states that generic Resource Group Contributor access can retrieve CloudAdmin credentials. The reviewed official sources support separate Azure-plane authorization and password regeneration, but this exact built-in-role assertion was not confirmed; validate the required AVS actions and role definitions before granting access.

* Azure role-based access control must be designed as part of the AVS security boundary.

### 21.1 Privileged elevation model

The transcript recommends a privileged identity workflow consistent with Microsoft Entra Privileged Identity Management (PIM), which supports time-bound and approval-based activation for eligible Azure roles. [Configure Microsoft Entra Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure)

* Replaces standing privileged role assignments with eligible, time-bound activation where operationally appropriate. [Configure Microsoft Entra Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure)

* Requires engineers to activate an eligible role for a limited period. [Configure Microsoft Entra Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure)

* Captures a business justification.

* Can require approval, multifactor authentication, justification, and other activation controls. [Configure Azure resource role settings in PIM](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-how-to-change-default-settings)

* Automatically expires elevated access after the configured activation duration. [Configure Azure resource role settings in PIM](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-how-to-change-default-settings)

> **Documentation correction:** The product name is **Microsoft Entra Privileged Identity Management (PIM)**. The transcript’s “Microsoft Anfra” and “PM” variants are transcription errors. [Configure Microsoft Entra Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure)

### Key implication

AVS has two control planes that require coordinated governance: the Azure resource plane and the VMware management plane.

---

## 22. Shared Responsibility Model

AVS transfers significant infrastructure responsibility to Microsoft without transferring responsibility for workload security and governance. [Azure VMware Solution responsibility matrix - Microsoft vs customer](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-responsibility-matrix---microsoft-vs-customer)

| Area                    | Microsoft responsibility described in transcript             | Customer responsibility described in transcript                                               |
| ----------------------- | ------------------------------------------------------------ | --------------------------------------------------------------------------------------------- |
| Physical data center    | Physical security, power, hardware, and facility operations. | No direct physical administration.                                                            |
| Bare-metal hosts        | Hardware replacement and host lifecycle.                     | Capacity planning and supported workload placement.                                           |
| VMware platform         | Hypervisor and core-stack maintenance and patching.          | Use of the platform within supported limits.                                                  |
| Network security        | Operation of the foundational AVS infrastructure.            | NSX distributed firewall rules, segmentation, ingress, egress, and lateral-movement controls. |
| Azure access            | Azure platform availability and identity services.           | Azure RBAC, privileged access, and protection of retrievable credentials.                     |
| Guest operating systems | Not described as a Microsoft AVS host responsibility.        | OS patching, application patching, agents, logs, malware protection, and configuration.       |
| Backups                 | Platform APIs are made available.                            | Selection, configuration, retention, validation, and recovery testing.                        |

> **Documentation note:** The table consolidates Microsoft’s AVS shared-responsibility guidance with operational interpretations for workload security and backup ownership. [Azure VMware Solution responsibility matrix - Microsoft vs customer](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-responsibility-matrix---microsoft-vs-customer)

### Key implication

A managed hypervisor does not make guest operating systems, applications, workload firewall policies, or administrator identities Microsoft-managed. [Azure VMware Solution responsibility matrix - Microsoft vs customer](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-responsibility-matrix---microsoft-vs-customer)

---

## 23. Restricted ESXi Host Access

Traditional VMware administrators may expect root SSH access to ESXi. AVS does not provide customers with ESXi root access or the `administrator@vsphere.local` account. [Identity concepts for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity)

* Customers do not receive ESXi root access. [Identity concepts for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity)

* Customers cannot use unrestricted root SSH administration of the managed hosts. [Identity concepts for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity)

* **Operational interpretation:** Because the hosts are Microsoft-managed and customers lack root access, host-level kernel modules and unsupported drivers are outside the customer administration model.

* Backup integrations must use supported VMware and AVS interfaces rather than unsupported host-level agents. [Microsoft Azure VMware Solution FAQ](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)

* Customers cannot inject unique hardware drivers into the managed host.

* The restriction protects the platform’s security, stability, patchability, and SLA.

### Operational consequence

Tools that depend on direct host access must be replaced, reconfigured, or proven compatible with supported VMware APIs.

---

## 24. Backup Through VMware APIs

AVS backup products must use supported VMware management and data-protection interfaces rather than requiring unrestricted ESXi host administration. Microsoft documents VADP HotAdd compatibility for supported partner products. [Backup/restore](https://learn.microsoft.com/en-us/azure/azure-vmware/faq#backuprestore)

* Microsoft documents VMware vStorage APIs for Data Protection (VADP) HotAdd as a supported backup integration model. [Backup/restore](https://learn.microsoft.com/en-us/azure/azure-vmware/faq#backuprestore)

* Backup software communicates with vCenter.

* The software requests VM snapshots through supported APIs.

* Backup data is streamed over the network.

* No backup agent is installed in the ESXi kernel.

* Microsoft’s current AVS FAQ names Commvault, Veritas, and Veeam among supported partner approaches. [Backup/restore](https://learn.microsoft.com/en-us/azure/azure-vmware/faq#backuprestore)

> **Source normalization note:** One speaker initially pronounces the acronym incorrectly before it is corrected to VADP in the transcript.

> **Not directly supported by the reviewed documentation:** The transcript includes Azure Backup Server as an AVS VADP example. The reviewed current Microsoft AVS documentation did not confirm that product in the supported partner list.

### Backup validation sequence

1. Confirm that the selected backup platform and deployment mode are currently supported for AVS and VADP. [Backup/restore](https://learn.microsoft.com/en-us/azure/azure-vmware/faq#backuprestore)

2. Register the platform with vCenter using a least-privilege service identity.

3. Validate snapshot creation and removal.

4. Test network throughput for backup and restore traffic.

5. Perform a complete VM recovery.

6. Test application-consistent recovery where required.

7. Verify that backup operations do not depend on ESXi root access.

---

## 25. Azure Arc and Guest-Level Management

Current Arc-enabled Azure VMware Solution integrates the private cloud with Azure by deploying an Azure Arc resource bridge and connecting vCenter inventory to Azure. Optional guest management then installs Azure-connected machine components inside Windows or Linux VMs for extension-based management. [Deploy Arc-enabled Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-arc-for-azure-vmware-solution) [Enable guest management and install extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/arc-enable-guest-management)

> **Documentation correction:** The transcript describes Azure Arc only as an agent installed inside each guest. That is incomplete for the current AVS-specific integration: Arc-enabled AVS first uses an Arc resource bridge and vCenter connection, while guest management is enabled separately for VM extensions and in-guest capabilities.

* Arc-enabled AVS represents VMware resources in Azure and supports selected create, read, update, and delete operations through Azure. [Integrate Azure native services with Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/integrate-azure-native-services)

* Guest management enables supported Azure VM extensions and in-guest management without requiring ESXi root access. [Enable guest management and install extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/arc-enable-guest-management)

* Azure Arc-enabled servers can integrate with services such as Azure Update Manager, Azure Policy guest configuration, monitoring, and security services, subject to each service’s prerequisites and regional support. [What is Azure Arc-enabled servers?](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview)

* The management experience becomes less dependent on the underlying hypervisor while the workload can remain on VMware.

> **Architectural interpretation:** AVS preserves the application’s VMware dependency below the guest, while Arc-enabled AVS and guest management introduce Azure governance and management above the hypervisor.

### Operational implication

The long-term operating model can become more Azure-integrated even when the application has not yet been replatformed.


---

## 26. VMware HCX and Migration Mechanics

VMware HCX provides migration, network-extension, and mobility services for AVS. Microsoft currently documents HCX Enterprise as included with AVS at no additional software charge. [Migration options for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)

> **Documentation note:** HCX Enterprise is documented as included, but supported capabilities, appliance sizing, and lifecycle versions should still be checked for the selected deployment. [Configure VMware HCX in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)

### 26.1 Traditional migration problems

A conventional application move may require:

* Scheduling a long outage window.

* Stopping database writes.

* Copying large data volumes over a VPN.

* Shutting down the original VM.

* Starting a replacement VM in the cloud.

* Assigning a new IP address.

* Changing firewall rules.

* Updating Domain Name System (DNS) records.

* Finding and correcting hard-coded IP addresses.

### 26.2 HCX network extension

* HCX Connector is deployed in the source VMware environment and paired with HCX Cloud Manager in AVS. [Configure VMware HCX in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)

* HCX Cloud Manager and service appliances provide the AVS-side HCX services. [Configure VMware HCX in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)

* HCX service meshes use IPsec-protected tunnels; the exact underlay can be ExpressRoute or supported internet connectivity, and required ports include UDP 4500 for IPsec. [Configure VMware HCX in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)

* HCX Network Extension stretches supported source Layer 2 networks to NSX segments in AVS. [Configure HCX Network Extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension)

* The migrated VM remains on the same logical subnet.

* A migrated VM can retain its IP address while attached to the extended network. [Enable VMware HCX access over the internet](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-hcx-access-over-internet)

* Supported HCX migrations can preserve the VM’s MAC identity together with its network attachment. [Enable VMware HCX access over the internet](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-hcx-access-over-internet)

* Existing firewall rules tied to that identity can remain valid.

* The VM can move while preserving active network sessions, subject to the supported migration design.

### 26.3 Migration flow

1. Deploy and configure the source-side HCX Connector and pair it with AVS. [Configure VMware HCX in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)

2. Establish the HCX service connection to AVS.

3. Confirm encrypted connectivity over the intended network path.

4. Extend the required Layer 2 network into NSX. [Configure HCX Network Extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension)

5. Validate routing, firewall rules, maximum transmission unit settings, and name resolution.

6. Select the migration wave.

7. Start the migration from the on-premises HCX interface.

8. Verify VM placement and application availability in AVS.

9. Monitor the stretched network for trombone-routing effects.

10. Enable Mobility Optimized Networking where supported and appropriate. [Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)

11. Move every remaining workload from the extended subnet.

12. Relocate the subnet’s permanent gateway to Azure.

13. Remove the temporary HCX network extension.

---

## 27. Trombone Routing

Layer 2 extension preserves IP addressing but may leave the workload’s default gateway in the source environment, producing suboptimal “trombone” traffic flows. [Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)

### 27.1 Example traffic path

1. A web server is migrated from Chicago to AVS.

2. Its subnet and IP address are stretched into Azure.

3. Its default gateway remains physically located in Chicago.

4. A customer sends a request to the server in Azure.

5. The server creates a response.

6. The response follows the default gateway across ExpressRoute back to Chicago.

7. The Chicago router forwards the response toward the internet.

8. Subsequent traffic may repeat the same long path.

### 27.2 Consequences

* The extra path can increase latency and consume additional WAN or ExpressRoute bandwidth. [Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)

* ExpressRoute bandwidth carries unnecessary round-trip traffic.

* Application response time degrades.

* Local Azure traffic may be routed through the on-premises data center.

> **Transcript-derived analogy:** Trombone routing is compared with flying from New York to London while being forced to stop in Los Angeles for every trip. The destination is reachable, but the path is operationally inefficient.

---

## 28. Mobility Optimized Networking

HCX Mobility Optimized Networking (MON) can optimize selected traffic flows for migrated VMs while a Layer 2 extension remains active. [Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)

### 28.1 MON behavior

* MON observes the location of the migrated VM.

* MON uses destination-side routing constructs to optimize eligible traffic according to VM locality and policy. [Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)

* Eligible traffic can use the destination-side gateway or policy route instead of returning to the source gateway. [Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)

* Traffic no longer needs to return to the on-premises gateway merely because the VM retains its original subnet identity.

* The VM does not need to be readdressed immediately.

### 28.2 Scale limits stated in the transcript

| MON design                                |          Limit stated |
| ----------------------------------------- | --------------------: |
| Default HCX Cloud Manager profile (4 vCPU, 12 GB RAM; HCX 4.5 or later) | 400 VMs with MON enabled [HCX MON Scalability Guide](https://knowledge.broadcom.com/external/article/321640/hcx-mobility-optimized-networking-mon-sc.html) |
| Expanded HCX Cloud Manager profile (8 vCPU, 24 GB RAM; HCX 4.5 or later) | 1,000 VMs with MON enabled [HCX MON Scalability Guide](https://knowledge.broadcom.com/external/article/321640/hcx-mobility-optimized-networking-mon-sc.html) |
| Network extensions with MON per HCX Cloud Manager | 100 [HCX MON Scalability Guide](https://knowledge.broadcom.com/external/article/321640/hcx-mobility-optimized-networking-mon-sc.html) |

> **Documentation note:** Broadcom documents these limits per HCX Cloud Manager, regardless of site pairings or service meshes. Limits vary by HCX version and Cloud Manager resources; confirm the current table before migration execution. [HCX MON Scalability Guide](https://knowledge.broadcom.com/external/article/321640/hcx-mobility-optimized-networking-mon-sc.html)

### 28.3 Why MON is temporary

* Packet interception consumes appliance compute and state-table capacity.

* Network extensions consume a finite resource.

* Stretched Layer 2 networks preserve migration flexibility but retain hybrid-network complexity.

* After all dependent VMs on an extended subnet have migrated, moving the gateway to the destination and removing the extension simplifies the steady-state network. [Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)

* The network extension should then be removed.

* Released HCX capacity can be reused for the next migration wave.

> **Operational recommendation:** Treat HCX network extension and MON as migration mechanisms, not as a permanent network architecture.

---

## 29. Migration Initiation Rule

For an on-premises-to-AVS migration, Microsoft’s HCX workflow deploys HCX Connector in the source environment, pairs it with AVS, and initiates migration operations from the source-side HCX context. [Configure VMware HCX in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)

* The on-premises environment is the source for the migration direction described in this guide.

* Engineers should create the migration from the source HCX environment rather than treating destination vCenter as a generic mechanism to “pull” an unmanaged source VM.

* HCX also supports other migration directions and site-pair topologies; the source and destination roles depend on the specific migration design. [Migration options for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)

> **Documentation correction:** The transcript’s “without exception” wording is too strong. Source-side initiation is appropriate for the on-premises-to-AVS flow described here, but it is not a universal prohibition on every HCX topology or migration direction. The reviewed Microsoft documentation also does not define every destination-initiated operation as a “reverse migration.”


---

## 30. Migration-Wave Operating Model

HCX appliance capacity, network-extension limits, and application dependencies favor structured migration waves. [Migration options for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate) [HCX MON Scalability Guide](https://knowledge.broadcom.com/external/article/321640/hcx-mobility-optimized-networking-mon-sc.html)

1. Group workloads by application dependency and subnet.

2. Identify the networks that must be extended for the current wave.

3. Confirm that VM, concurrent-operation, and network-extension counts remain below the limits for the deployed HCX version and appliance sizing. [HCX MON Scalability Guide](https://knowledge.broadcom.com/external/article/321640/hcx-mobility-optimized-networking-mon-sc.html)

4. Extend only the networks needed for the active wave.

5. Migrate the selected VMs.

6. Enable MON for eligible migrated workloads that would otherwise experience suboptimal routing. [Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)

7. Validate application communication and performance.

8. Move the remaining VMs from the same subnet.

9. Transfer the subnet’s permanent default gateway to Azure.

10. Remove the Layer 2 extension after the subnet no longer depends on it. [Configure HCX Network Extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension)

11. Release HCX appliance capacity.

12. Begin the next wave.

### Key dependency

A subnet cannot be cleanly de-extended until all workloads and dependencies that require that subnet have been addressed.

---

## 31. Stretched Clusters and Availability Zones

Generation 1 AVS stretched clusters provide infrastructure resilience across two Azure Availability Zones in the same region. [Stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

* Azure Availability Zones are separated groups of datacenters within a region, with independent power, cooling, and networking. [Reliability in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)

* Each zone has independent power, cooling, and network paths.

* Zones are separated sufficiently to reduce the likelihood that one localized event affects both.

* A stretched cluster presents one VMware cluster and a synchronously replicated vSAN datastore across two zones. [Stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

* VM storage writes are synchronously committed across the two data sites according to the stretched-cluster storage policy. [Stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

* A write is not considered complete until both locations acknowledge it.

### 31.1 Zone-failure behavior

* One Availability Zone becomes unavailable.

* VMs running in that zone stop.

* VMware High Availability can restart affected VMs on surviving hosts after a site failure, subject to capacity and object availability. [Stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

* The affected VMs restart on surviving hosts in the second zone.

* The design protects against the loss of an entire zone, subject to capacity and quorum availability.

### 31.2 Stretched-cluster scale

* A standard cluster begins at three hosts.

* A stretched cluster requires at least six hosts, deployed as three hosts per zone. [Stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

* The hosts are distributed as three per zone.

* The cluster scales in pairs to a maximum of 16 hosts in total. [Stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

### 31.3 AV64 limitation

* Generation 1 AV64 is not supported in a stretched-cluster configuration. [Azure VMware Solution private cloud extension with AV64 node size](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-private-cloud-extension-with-av64-node-size)

* Applications requiring the AV64 CPU profile cannot use this multi-zone stretched design.

* Architects must choose between the AV64 compute profile and the described multi-zone cluster resilience.

> **Documentation note:** Stretched-cluster availability, supported SKUs, quotas, and regions remain deployment-specific. Generation 2 currently does not support stretched clusters. [Stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) [Azure VMware Solution Generation 2 design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration)

---

## 32. Split-Brain Prevention and the vSAN Witness

A stretched cluster uses a third-zone vSAN witness to provide quorum and prevent split-brain operation during a partition. [Stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

### 32.1 Split-brain scenario

* The network between Zone 1 and Zone 2 fails.

* Both data centers remain powered and operational.

* Zone 1 concludes that Zone 2 is unavailable.

* Zone 2 concludes that Zone 1 is unavailable.

* Without quorum, both sides could attempt to continue writing independently.

* Divergent writes could cause unrecoverable data corruption.

### 32.2 Witness function

* Microsoft deploys and manages a vSAN witness in a third Availability Zone. [Stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

* The witness stores metadata and witness components rather than application data. [Stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

* It provides the quorum vote used to determine which data site can remain authoritative. [Stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

* The data site that can still communicate with the witness receives authority to continue.

* The other side is prevented from independently writing to the shared datastore.

> **Architectural interpretation:** Two data sites provide redundancy, but the third-zone witness provides authority. The witness prevents availability mechanisms from becoming a source of data corruption.

---

## 33. Witness-Zone Failure Scenario

A witness outage removes a quorum participant from the stretched cluster. The effect depends on the remaining site connectivity, object policy, and whether another failure occurs. Microsoft documents the witness as a managed third-zone quorum component; Broadcom documents the detailed vSAN voting behavior. [Stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) [Understanding vSAN stretched-cluster failure scenarios](https://knowledge.broadcom.com/external/article/394978/understanding-vsan-stretched-cluster-fai.html)

### 33.1 Immediate behavior

* If both data sites remain connected and objects retain quorum, existing workloads can remain accessible.

* A witness-only outage does not by itself mean that application data stored on both data sites is lost.

* The cluster is degraded because a subsequent site, host, network, or object-component failure can change quorum and availability outcomes. [Understanding vSAN stretched-cluster failure scenarios](https://knowledge.broadcom.com/external/article/394978/understanding-vsan-stretched-cluster-fai.html)

### 33.2 Degraded cluster behavior

* vSAN health reports the witness or partition problem, and affected objects can show reduced availability.

* Operations that require new vSAN objects or policy-compliant placement can fail when the required witness components or votes cannot be created. Broadcom documents that object creation is required for operations such as VM power-on swap objects, snapshots with memory, and some storage workflows. [vSAN daemon liveness and object-management operations](https://knowledge.broadcom.com/external/article/318410/vsan-health-service-cluster-health-vsa.html)

* Repair, resynchronization, and rebalancing behavior depends on the surviving quorum, storage policy, and the failure combination.

> **Documentation correction:** The transcript states categorically that every powered-off VM cannot be powered on, all rebalancing is blocked, and no component can be repaired during any witness outage. The reviewed official documentation supports a serious degraded state but does not support those effects as universal outcomes for every witness-only failure. Evaluate the actual vSAN object health, quorum, policy, and concurrent failures.

### 33.3 Recovery dependency

* The managed witness must be restored or replaced through the supported AVS service process. [Stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

* Quorum and object health must be verified before treating the cluster as fully recovered.

> **Failure condition:** A witness outage can leave applications running while reducing resilience and constraining operations that require new or repaired vSAN objects. Initial application availability should not be mistaken for full cluster health.


---

## 34. Consolidated Operational Recommendations

The transcript’s major recommendations can be converted into a set of implementation controls. Items labeled as operational recommendations are derived from documented requirements and failure modes rather than represented as verbatim Microsoft prescriptions.

### 34.1 Before deployment

* Reserve a nonoverlapping minimum `/22` using the Generation 1 management-block model or Generation 2 delegated-subnet model, as applicable. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations) [Azure VMware Solution Generation 2 design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration)

* Confirm cluster, host, quota, and SKU availability for the target region. [Scale an Azure VMware Solution private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud) [Hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#hosts-clusters-and-private-clouds)

* Determine whether the workload requires a standard host profile, Generation 1 AV64 expansion, direct Generation 2 AV64 deployment, or Generation 1 stretched-cluster resilience. [Azure VMware Solution private cloud extension with AV64 node size](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-private-cloud-extension-with-av64-node-size) [Azure VMware Solution Generation 2 overview](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction) [Stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

* Model the `MGMT-ResourcePool` reservation separately from workload capacity. [Plan an Azure VMware Solution deployment](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment)

* Inventory on-premises BGP routes and apply the route limit for the selected architecture rather than a universal AVS threshold. [Azure Route Server frequently asked questions](https://learn.microsoft.com/en-us/azure/route-server/route-server-faq) [Route architecture for Azure VMware Solution Gen 2](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

* Identify prohibited or dangerous Generation 1 route advertisements, including documented broad prefixes and default-route interactions. [Azure VMware Solution networking limitations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#limitations) [Connect on-premises environments to Azure VMware Solution with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)

* Plan Azure and VMware administrative roles as two separate security layers. [Identity concepts for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity) [What is Azure role-based access control?](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)

### 34.2 During platform configuration

* Configure supported Active Directory identity-source integration through LDAPS. [Configure an identity source in vCenter for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter)

* Create named, least-privilege administrative roles and group assignments. [Identity concepts for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity)

* Place the CloudAdmin credential in a secure vault and define a rotation procedure. [Rotate CloudAdmin credentials for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/rotate-cloudadmin-credentials)

* Minimize standing broad Azure privileges and use scoped roles. [What is Azure role-based access control?](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)

* Configure time-bound privileged elevation for high-impact Azure operations where appropriate. [Configure Microsoft Entra Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure)

* Confirm that workload storage policies use the intended thin or thick Object Space Reservation; do not assume the policy name reflects the applied default. [Storage policies and fault tolerance](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage#storage-policies-and-fault-tolerance) [Configure a storage policy in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-storage-policy)

* Configure storage monitoring and expansion planning around the documented 75% usable-capacity boundary. [Azure VMware Solution networking limitations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#limitations)

* Validate supported VADP-based backup and full-restore workflows. [Backup/restore](https://learn.microsoft.com/en-us/azure/azure-vmware/faq#backuprestore)

* Deploy Arc-enabled AVS and enable guest management where Azure-native governance or extensions are required. [Deploy Arc-enabled Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-arc-for-azure-vmware-solution) [Enable guest management and install extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/arc-enable-guest-management)

### 34.3 During compute expansion

* Verify CPU-generation and EVC compatibility. [Enhanced vMotion Compatibility with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension)

* Configure VM-level EVC before workloads boot on AV64 when return migration to an older base cluster is required. [Enhanced vMotion Compatibility with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension)

* Test live migration in both directions.

* Check explicit AV64 fault-domain placement before requesting host removal. [AV64 host-removal workflow and best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#av64-host-removal-workflow-and-best-practices)

* Plan a cold-migration procedure for VMs that have already adopted an incompatible CPU profile.

### 34.4 During migration

* For on-premises-to-AVS waves, initiate migrations from the source HCX context. [Configure VMware HCX in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)

* Extend only the networks needed for the current wave.

* Monitor HCX and MON scale limits for the deployed version and appliance resources. [HCX MON Scalability Guide](https://knowledge.broadcom.com/external/article/321640/hcx-mobility-optimized-networking-mon-sc.html)

* Detect and correct trombone routing with supported MON or gateway-cutover designs. [Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)

* Transfer the permanent default gateway to Azure after the final VM on the subnet has moved.

* Remove the temporary Layer 2 extension after the subnet is fully migrated. [Configure HCX Network Extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension)

### 34.5 During steady-state operations

* Maintain vSAN within the supported 75% usable-capacity limit. [Azure VMware Solution networking limitations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#limitations)

* Monitor actual, committed, and projected thin-provisioned capacity.

* Keep management and workload routes explicit.

* Monitor BGP route counts and peering health against the applicable architecture-specific limits. [Azure Route Server frequently asked questions](https://learn.microsoft.com/en-us/azure/route-server/route-server-faq) [Route architecture for Azure VMware Solution Gen 2](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

* Test backups and complete restores.

* Patch guest operating systems and applications independently of Microsoft’s host-platform maintenance. [Azure VMware Solution responsibility matrix - Microsoft vs customer](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-responsibility-matrix---microsoft-vs-customer)

* Maintain customer-owned NSX segments, distributed-firewall policy, and lateral-movement controls. [Azure VMware Solution private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

* Treat witness loss as a serious degraded-state incident even when applications remain online. [Understanding vSAN stretched-cluster failure scenarios](https://knowledge.broadcom.com/external/article/394978/understanding-vsan-stretched-cluster-fai.html)

---

## 35. Failure and Troubleshooting Matrix

| Symptom or event                                          | Likely cause described in transcript                                                | Operational effect                                                                   | Recommended response                                                                                                 |
| --------------------------------------------------------- | ----------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------- |
| Live migration from AV64 to an older cluster is blocked. | The VM booted with newer CPU features and lacks a compatible VM-level EVC baseline. | The VM cannot move live. | Power off the VM, perform a cold migration, restart it on the older baseline, and configure EVC before future moves. [Enhanced vMotion Compatibility with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension) |
| Host-removal request returns HTTP 409. | The removal would create an invalid AV64 fault-domain balance. | The selected host cannot be removed. | Review fault-domain placement and remove an eligible host instead. [AV64 host-removal workflow and best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#av64-host-removal-workflow-and-best-practices) |
| vSAN utilization exceeds 75%. | Capacity growth, snapshots, or insufficient expansion planning. | The deployment exceeds Microsoft’s documented usable-capacity condition for the AVS SLA. | Stop nonessential growth, identify reclaimable capacity, and add external storage or hosts. [Azure VMware Solution networking limitations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#limitations) |
| BGP peering drops after route advertisement. | An architecture-specific route or peer limit may have been exceeded, or another BGP fault occurred. | AVS can lose on-premises connectivity. | Compare learned and advertised routes with the selected Route Server, ExpressRoute, or Generation 2 limits; withdraw or summarize routes as required. [Azure Route Server frequently asked questions](https://learn.microsoft.com/en-us/azure/route-server/route-server-faq) [Route architecture for Azure VMware Solution Gen 2](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture) |
| vCenter is unreachable from on-premises. | A default or prohibited Generation 1 route may have redirected management return traffic. | Management access is lost. | Remove the problematic advertisement and restore a more-specific path for the AVS management `/22`. [Connect on-premises environments to Azure VMware Solution with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud) |
| Migrated application latency rises sharply. | Traffic may be tromboning through the source default gateway. | Increased latency and unnecessary hybrid-link use. | Enable MON where supported or move the gateway permanently to the destination. [Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance) |
| HCX cannot optimize additional VMs or networks. | MON VM, concurrent-operation, or network-extension limits may have been reached. | Later migration waves cannot use the same optimization. | Complete subnet cutovers, remove old extensions, or resize HCX Cloud Manager according to Broadcom guidance. [HCX MON Scalability Guide](https://knowledge.broadcom.com/external/article/321640/hcx-mobility-optimized-networking-mon-sc.html) |
| Backup tool requests ESXi root access. | The product relies on an administration model that AVS does not expose. | The tool cannot operate as designed. | Replace or reconfigure it to use supported VADP and vCenter APIs. [Backup/restore](https://learn.microsoft.com/en-us/azure/azure-vmware/faq#backuprestore) |
| Existing workloads run, but new VM power-on or object-creation operations fail. | The stretched-cluster witness or another vSAN quorum/object-management component may be unavailable. | The cluster can remain partially available while some operations fail. | Check vSAN health and quorum, then engage Microsoft for the managed witness or platform component. [Understanding vSAN stretched-cluster failure scenarios](https://knowledge.broadcom.com/external/article/394978/understanding-vsan-stretched-cluster-fai.html) |
| Storage-only demand forces consideration of another host. | Host-local vSAN capacity is coupled to compute. | The organization may purchase unnecessary CPU and memory. | Evaluate an external datastore such as Azure NetApp Files or Azure Elastic SAN. [External storage solutions for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/ecosystem-external-storage-solutions) |

---

# Architecture Summary

Azure VMware Solution combines Microsoft-operated physical infrastructure with a VMware software-defined data center. Azure provisions and maintains the service platform, while VMware components preserve the application runtime, management interfaces, network semantics, and migration tooling familiar to VMware operations teams. [What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) [Azure VMware Solution private-cloud architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)

## End-to-end architecture and traffic flow

1. **Azure provisions the private cloud.**

   * Azure Resource Manager creates the AVS resource and allocates dedicated bare-metal hosts.
   * Microsoft manages the physical servers and the lifecycle of the supported VMware platform. [Azure VMware Solution responsibility matrix - Microsoft vs customer](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-responsibility-matrix---microsoft-vs-customer) [Azure VMware Solution private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

2. **ESXi provides the compute layer.**

   * ESXi runs on the dedicated bare-metal hosts.
   * VMs consume physical CPU and memory through VMware virtualization. [Azure VMware Solution private-cloud architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)

3. **vCenter manages the VMware environment.**

   * Administrators provision VMs, manage clusters, monitor performance, and use supported VMware integrations.
   * `MGMT-ResourcePool` reserves 46 GHz of CPU and 171.88 GB of memory for the control plane in the first cluster. [Plan an Azure VMware Solution deployment](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment)

4. **vSAN supplies the initial datastore.**

   * Local NVMe and SSD devices are pooled across hosts.
   * Storage policies implement mirroring or erasure coding.
   * Workload policy, FTT, host count, and the 75% capacity boundary determine usable resilience and headroom. [Storage architecture for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage) [Azure VMware Solution networking limitations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#limitations)

5. **External Azure storage can extend capacity.**

   * Azure NetApp Files or Azure Elastic SAN can be attached as external datastores.
   * Storage performance depends on the generation-specific network path and the selected service. [External storage solutions for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/ecosystem-external-storage-solutions)

6. **NSX supplies Generation 1 workload networking and security.**

   * The Generation 1 dedicated `/22` supports AVS platform infrastructure.
   * Customer workloads use separate NSX segments and tier-1 gateways.
   * Customer-managed NSX distributed-firewall rules control lateral movement. [Azure VMware Solution network architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking)

7. **Generation 1 ExpressRoute or Generation 2 native VNet connectivity connects AVS to Azure.**

   * Generation 1 uses a Microsoft-managed AVS ExpressRoute circuit and a VNet gateway connection.
   * Generation 2 attaches the private cloud directly to delegated subnets in an Azure VNet. [Azure VMware Solution network architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking) [Azure VMware Solution Generation 2 overview](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)

8. **Global Reach can connect Generation 1 AVS to the physical data center.**

   * On-premises and AVS ExpressRoute circuits can be linked through ExpressRoute Global Reach.
   * This pattern avoids relying on an Azure VNet gateway as a circuit-to-circuit transit router. [Connect on-premises environments to Azure VMware Solution with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)

9. **HCX moves workloads into AVS.**

   * HCX can extend supported Layer 2 networks through IPsec-protected service-mesh tunnels.
   * Supported migrations can retain IP and MAC identities.
   * MON can reduce suboptimal routing while the extension remains active. [Configure VMware HCX in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx) [Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)

10. **Migration waves remove temporary hybrid dependencies.**

    * Workloads move in dependency- and subnet-aligned groups.
    * The default gateway ultimately relocates to the destination.
    * HCX network extensions are removed after each subnet is fully migrated. [Configure HCX Network Extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension)

11. **Azure and VMware identity controls protect two management planes.**

    * VMware administrators use named identities and least-privilege vCenter roles through a supported LDAPS identity source.
    * CloudAdmin remains a controlled break-glass credential.
    * Azure-side privileged access can use scoped RBAC and time-bound PIM activation. [Identity concepts for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity) [Configure Microsoft Entra Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure)

12. **Arc-enabled AVS introduces Azure management for VMware resources and guests.**

    * An Arc resource bridge and vCenter connection represent AVS resources in Azure.
    * Optional guest management enables extensions and in-guest services. [Deploy Arc-enabled Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-arc-for-azure-vmware-solution) [Enable guest management and install extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/arc-enable-guest-management)

13. **Generation 1 stretched clusters provide multi-zone resilience where supported.**

    * Data is synchronously mirrored between two Availability Zones.
    * A third-zone vSAN witness provides quorum and prevents split-brain operation.
    * Witness loss is a degraded-state event whose precise effect depends on quorum, policy, and concurrent failures. [Stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) [Understanding vSAN stretched-cluster failure scenarios](https://knowledge.broadcom.com/external/article/394978/understanding-vsan-stretched-cluster-fai.html)

## Final Result

AVS changes the practical definition of cloud migration. A workload can continue running on VMware ESXi while its physical infrastructure, platform lifecycle, connectivity, governance, monitoring, and security become integrated with Azure.

The platform’s effectiveness depends on disciplined engineering rather than simple host deployment. CPU compatibility, management reservations, vSAN free space, fault domains, generation-specific routing, least-privilege access, HCX limits, and witness quorum all have direct operational consequences. When those dependencies are designed correctly, AVS can move a large VMware estate into Azure without requiring immediate application refactoring or disruptive IP-address changes.

## Documentation and Interpretation Notes

* **Material corrections:** Current Microsoft documentation supplies complete host specifications; Generation 2 supports direct three-host AV64 deployment; the applied AVS workload storage policy is thin-provisioned by default; FTT=2 is documented as guidance for clusters with more than six hosts rather than an automatic six-host SLA transition; Route Server’s 1,000-prefix rule has a narrower scope than the transcript implied; and the current identity product name is Microsoft Entra Privileged Identity Management.

* **Claims that remain unsupported or only partially supported:** The reviewed sources did not confirm the transcript’s exact nested-hypervisor performance rationale, a universal 1,500-route BGP failure threshold, the specific claim that built-in Resource Group Contributor always retrieves CloudAdmin credentials, Azure Backup Server as a current AVS VADP example, or the categorical witness-outage behavior originally stated.

* **Architectures that must not be merged:** Generation 1 uses an AVS-managed ExpressRoute circuit, a dedicated management `/22`, and NSX workload networking. Generation 2 uses native VNet attachment and delegated subnets, has different routing and NSG behavior, supports direct AV64 deployment, and currently does not support stretched clusters. Azure Route Server limits, Global Reach patterns, secured Virtual WAN designs, and ordinary hub-VNet user-defined routes apply only when those components are actually present.

* **Interpretive and operational recommendations:** Treat the 75% vSAN boundary, EVC baselines, route scale, CloudAdmin custody, HCX extension cleanup, backup restore testing, and witness degradation as explicit operating controls. These recommendations synthesize documented constraints and failure behavior; they are not all verbatim Microsoft prescriptions.
