# Azure VMware Solution: Architecture, Migration, Networking, Storage, and Operations Guide

## Purpose and Source Scope

Azure VMware Solution (AVS) provides a managed VMware software-defined data center on dedicated bare-metal infrastructure inside Microsoft Azure. Its central value proposition is not application modernization; it is the ability to move an existing VMware estate into Azure while preserving the hypervisor, management tools, network identities, operational procedures, and third-party integrations on which that estate depends.

This guide is derived exclusively from the supplied transcript and does not incorporate external documentation or independent product validation.

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

* **AVS response:** AVS preserves the VMware execution and management environment while relocating it to cloud-managed physical infrastructure.

* **Primary migration objective:** The platform minimizes replatforming rather than forcing immediate application redesign.

* **Operational continuity:** Existing administrators can continue using familiar VMware interfaces, scripts, backup tools, dashboards, and runbooks after the infrastructure has moved to Azure.

> **Transcript-derived analogy:** AVS is presented as bringing a carefully preserved piece of the past onto substantially better real estate. The organization retains the house it knows how to operate while Microsoft supplies and maintains the land, foundation, utilities, and physical infrastructure.

### Key implication

AVS should be evaluated as a migration-acceleration and operational-continuity platform. It does not inherently convert a VMware application into an Azure-native application.

---

## 2. Foundational Architecture

The most important architectural distinction is that AVS is not nested virtualization. VMware does not run inside a conventional Azure virtual machine, and an Azure hypervisor does not sit between ESXi and the physical server.

### 2.1 Dedicated bare-metal deployment

* **Physical architecture:** AVS runs VMware directly on dedicated bare-metal servers located inside Azure data centers.

* **No nested hypervisor:** There is no Azure hypervisor between the physical CPU and the VMware ESXi hypervisor.

* **Performance rationale:** The transcript characterizes nested VMware virtualization inside an Azure VM as an unacceptable design because the additional virtualization layer would introduce severe latency and performance overhead.

* **Cloud consumption model:** Customers receive a VMware environment with direct access to dedicated physical server capacity, but Microsoft manages the underlying hardware and platform lifecycle.

### 2.2 Microsoft-managed infrastructure

Microsoft is responsible for the physical and foundational platform components.

* Microsoft manages the physical server hardware.

* Microsoft manages top-of-rack network switches.

* Microsoft manages power distribution and data-center infrastructure.

* Microsoft manages the lifecycle of the core VMware software stack.

* Microsoft detects physical hardware failures and moves workloads away from affected hosts.

* Microsoft replaces failed hardware without requiring the customer’s operations team to manage the physical repair.

> **Transcript-derived scenario:** If a physical memory module fails overnight, Microsoft’s systems detect the failure, evacuate workloads to healthy nodes, and replace the affected hardware without generating a customer-side hardware pager event.

---

## 3. VMware Components and Azure Equivalents

An AVS private cloud contains several tightly integrated VMware components. Azure Resource Manager provisions and governs the AVS resource at the Azure infrastructure layer, while VMware tools manage the virtualized environment running on the hosts.

| Component          | Primary responsibility                                                                                   | Approximate Azure-native comparison                                                    | Important distinction                                                                                      |
| ------------------ | -------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| **ESXi**           | Abstracts physical CPU and memory and presents them to virtual machines.                                 | Azure hypervisor or compute fabric.                                                    | ESXi runs directly on the dedicated bare-metal server.                                                     |
| **vCenter Server** | Provisions VMs, configures clusters, monitors performance, and centrally manages the VMware environment. | Azure Resource Manager orchestration and Azure management APIs.                        | Azure Resource Manager provisions the AVS physical environment, while vCenter manages the VMs inside it.   |
| **vSAN**           | Pools local NVMe and SSD devices into a shared software-defined datastore.                               | Azure managed-disk and storage services.                                               | AVS storage is initially coupled to the physical hosts through hyper-converged infrastructure.             |
| **NSX**            | Provides software-defined switches, routers, gateways, and firewalls.                                    | Azure Virtual Network, route tables, network security controls, and firewall services. | Workload networks are managed inside the VMware networking layer rather than being ordinary Azure subnets. |
| **VMware HCX**     | Provides workload mobility, migration, network extension, and migration optimization.                    | Azure migration and network-extension services.                                        | HCX communicates with both source and destination vCenter environments using VMware-native semantics.      |

### 3.1 Division of management responsibility

* **Azure Resource Manager responsibility:** Azure Resource Manager provisions the physical AVS nodes and exposes the private cloud as an Azure resource.

* **vCenter responsibility:** vCenter manages the VMs, clusters, VMware resource pools, and VMware operational workflows.

* **NSX responsibility:** NSX manages the virtual networks and security controls used by VMware workloads.

* **HCX responsibility:** HCX handles migration and network-extension workflows between the source VMware environment and AVS.

### 3.2 Why vCenter remains necessary

Replacing vCenter with Azure-native VM management would undermine the platform’s migration value.

* Existing VMware deployment scripts depend on vCenter APIs and objects.

* Third-party backup integrations such as Veeam and Commvault depend on VMware management interfaces.

* Existing monitoring systems, dashboards, and operating procedures assume a vCenter-managed environment.

* Removing vCenter would require teams to rewrite their operational model using Azure Resource Manager templates, Bicep, or other Azure-native tooling.

* Keeping vCenter allows administrators to encounter substantially the same management interface after migration that they used before migration.

* HCX requires vCenter-to-vCenter communication to coordinate workload mobility.

* The preservation of vCenter supports live migration and operational familiarity without requiring an immediate tooling transformation.

### 3.3 Software lifecycle

The transcript states that Microsoft deploys and maintains a recent VMware stack and manages major updates, minor updates, and critical security patches on a regimented schedule.

> **Requires documentation validation:** The transcript identifies the software versions as vCenter 8.0 U3E, ESXi 8.0 U3F, and NSX 4.1.1. These values are time-sensitive and must be validated against the deployment region and current AVS release before implementation.

---

## 4. Management Resource Reservation

The first AVS cluster contains a dedicated management resource pool that protects the VMware control plane. Unlike many native cloud services, AVS exposes the practical capacity impact of that control plane.

* **Resource-pool name:** The transcript identifies the reserved pool as the `MGMT` resource pool.

* **CPU reservation:** The pool reserves 46 GHz of CPU capacity.

* **Memory reservation:** The pool reserves exactly 171.88 GB of RAM.

* **Availability:** Customers cannot assign these resources to application workloads.

* **Purpose:** The reservation protects vCenter, NSX management components, HCX appliances, and other foundational services.

* **N+1 requirement:** The control plane must retain sufficient capacity to continue operating if a physical host fails.

* **Failure behavior:** If one server is lost, management components must be able to restart or continue running on surviving hosts while the environment remains manageable.

> **Architectural interpretation:** The visible management reservation is the capacity cost of preserving a complete VMware control plane inside a dedicated private cloud. Native Azure services often hide comparable platform overhead from the customer’s resource view.

### Operational implication

Capacity planning must subtract management overhead before estimating usable application capacity. A minimum three-host cluster should not be modeled as though all physical CPU and memory are available to workloads.

---

## 5. Cluster Scale and Host Options

AVS scales in host-sized blocks rather than in small VM-sized increments. Because the initial architecture is hyper-converged, adding a host usually adds CPU, memory, and local storage together.

### 5.1 Platform scale limits stated in the transcript

* A cluster requires a minimum of three hosts.

* A cluster can scale to a maximum of 16 hosts.

* A private cloud can contain up to 96 hosts.

* A private cloud can contain a maximum of 12 clusters.

> **Requires documentation validation:** Host, cluster, and private-cloud limits are service constraints that may change by region, hardware generation, or platform release.

### 5.2 Host SKU characteristics

| Host SKU  | Processor generation stated in transcript |                                Physical cores |            Logical cores | Memory per host | Notable role                                               |
| --------- | ----------------------------------------: | --------------------------------------------: | -----------------------: | --------------: | ---------------------------------------------------------- |
| **AV36**  |                             Intel Skylake |                                            36 |               Not stated |          576 GB | Base host option.                                          |
| **AV36P** |                        Intel Cascade Lake |                                    Not stated |               Not stated |          768 GB | Higher-memory base host option.                            |
| **AV48**  |                     Intel Sapphire Rapids | 48 implied by name, but not explicitly stated |               Not stated |            1 TB | Newer-generation high-memory option.                       |
| **AV52**  |           Processor generation not stated |                                            52 |               Not stated |          1.5 TB | High-core and high-memory base option.                     |
| **AV64**  |                            Intel Ice Lake |                                            64 | 128 with Hyper-Threading |        1,024 GB | Expansion option with specific compatibility requirements. |

> **Requires documentation validation:** The transcript’s SKU names, processor generations, memory values, availability, and supported deployment combinations should be confirmed before procurement. It also describes AV48 as using Sapphire Rapids while providing limited additional details.

### 5.3 Hyper-converged purchasing behavior

* Compute and storage are initially tied to the same physical chassis.

* Adding capacity means purchasing another full enterprise host rather than adding only a small amount of CPU or disk.

* Organizations may therefore acquire more compute than needed when their actual constraint is storage.

* External Azure datastore integration can change this economic model by allowing independent storage expansion.

---

## 6. Host Uniformity and the AV64 Exception

The transcript describes host uniformity as a strict AVS requirement, with a specific exception for AV64 expansion.

* **General rule:** Hosts in a private cloud are described as needing to be identical.

* **AV64 exception:** AV64 hosts can be introduced as expansion capacity alongside an existing base environment.

* **Base-cluster dependency:** The transcript states that AV64 requires an existing cluster based on AV36, AV36P, or AV52 hosts.

* **Day-one restriction:** An AV64 cluster cannot be deployed from scratch as the initial primary cluster.

* **Design intent:** AV64 is characterized as an expansion option for an already established environment.

> **Requires documentation validation:** The exact scope of host uniformity—whether it applies to individual clusters, the entire private cloud, or specific supported cluster combinations—must be confirmed in current AVS documentation.

---

## 7. Enhanced vMotion Compatibility and Mixed CPU Generations

Introducing AV64 hosts alongside older CPU generations creates a live-migration compatibility problem. VMware Enhanced vMotion Compatibility (EVC) addresses that problem by presenting a controlled CPU feature baseline to virtual machines.

### 7.1 The CPU compatibility problem

* A VM observes a set of CPU features when it boots.

* A newer processor may expose instructions that do not exist on an older processor.

* A running VM may begin using newer instructions after booting on newer hardware.

* Moving that VM live to an older CPU could cause execution failure if the destination lacks those instructions.

* VMware therefore blocks incompatible migrations rather than allowing the guest operating system to crash.

### 7.2 How EVC works

* EVC masks selected CPU features.

* It causes newer processors to present themselves as an older, least-common-denominator processor baseline.

* Guest operating systems and applications see only the feature set represented by the configured EVC mode.

* Newer processors remain capable of running workloads constrained to an older feature baseline.

> **Transcript-derived analogy:** A document created in an older version of Microsoft Word can usually open in a newer version because the newer software understands the older format. A document enhanced with features that exist only in the newer version may no longer open correctly in the older application.

### 7.3 Migration behavior described in the transcript

| VM history                                                                            | Observed CPU baseline                   | Attempted move                                 | Expected outcome                                                                                            |
| ------------------------------------------------------------------------------------- | --------------------------------------- | ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| VM boots on an older AV36-class cluster and then moves to AV64 without rebooting.     | Older masked baseline remains active.   | Live migration back to the older cluster.      | The migration succeeds because the VM never re-queried the CPU and retained the older feature mask.         |
| VM is created or rebooted directly on AV64 without a VM-level compatibility baseline. | Newer Ice Lake features may be exposed. | Live migration to an older AV36-class cluster. | The hypervisor blocks the move with an EVC compatibility error.                                             |
| VM boots on AV64 with VM-level EVC explicitly matching the older cluster.             | Older baseline is enforced.             | Live migration to the older cluster.           | The migration can proceed because unsupported newer instructions were never exposed.                        |
| VM uses newer features and no compatible EVC baseline was set.                        | Newer baseline is active.               | Cold migration after full shutdown.            | The VM must be powered off, moved, and restarted so the guest can initialize against the older CPU profile. |

### 7.4 Required configuration sequence

1. Identify the oldest CPU generation to which the VM may need to migrate.

2. Determine the corresponding EVC baseline for that older cluster.

3. Configure VM-level EVC before the VM first boots on AV64 hardware.

4. Confirm that the VM sees only the intended instruction-set baseline.

5. Test live migration in both directions before treating the VM as operationally portable.

6. Document the EVC setting in the VM build standard and scaling runbook.

7. If an incompatible VM has already booted on newer hardware, schedule a shutdown and cold migration rather than attempting an unsupported live move.

> **Operational recommendation:** Treat VM-level EVC as a mandatory provisioning control for any workload that may move from AV64 back to an older base cluster. A missed configuration can convert a nondisruptive migration into a maintenance-window event.

---

## 8. vSAN Storage Architecture

AVS initially uses hyper-converged storage. Local storage devices inside the ESXi hosts are combined by vSAN into a shared datastore available to the cluster.

### 8.1 Difference from native Azure storage

* In native Azure, compute and storage are normally decoupled.

* An Azure VM can attach managed disks that are provisioned independently of the VM host.

* Increasing storage does not inherently require purchasing additional CPU or memory.

* In the AVS vSAN model, storage originates from local physical devices inside the deployed ESXi hosts.

* Adding a host increases compute, memory, and storage as a combined unit.

### 8.2 AV36 storage values stated in the transcript

An AV36 host is described as containing:

* 3.2 TB of raw NVMe capacity for the cache tier.

* 15.2 TB of SSD capacity for persistent data.

* vSAN pools those devices across the hosts into one shared software-defined datastore.

### 8.3 Example raw-capacity calculation

> **Transcript-derived calculation: Three-host AV36 capacity**

1. **Inputs**

   * Three AV36 hosts.
   * 15.2 TB of persistent SSD capacity per host.
   * A 75% maximum utilization target.

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

A fault domain represents infrastructure that shares a common point of failure, such as a rack, top-of-rack switch, or power distribution system. vSAN placement must ensure that redundant copies do not depend on the same physical failure domain.

### 9.1 Traditional AV36 and AV52 behavior

* Explicit vSAN fault domains are not shown in vCenter for the traditional configurations described in the transcript.

* Microsoft’s backend placement logic separates hosts physically.

* The transcript states that hosts in a cluster are not placed in the same physical rack.

* The physical-separation policy is handled by the AVS platform rather than customer configuration.

### 9.2 AV64 fault-domain behavior

* AV64 deployments expose seven explicit vSAN fault domains in vCenter.

* As the cluster grows from three to 16 nodes, AVS automation distributes the hosts across those seven fault domains.

* Host placement is actively balanced to preserve structural redundancy.

### 9.3 Scale-down failure condition

* A customer cannot necessarily remove an arbitrary AV64 host.

* AVS evaluates whether the removal would leave the fault domains unbalanced.

* If the requested removal would violate placement requirements, the platform rejects the operation.

* The transcript identifies the rejection as an HTTP `409 Conflict`.

> **Failure condition:** An AV64 scale-down operation can fail even when the cluster has enough aggregate CPU, memory, and storage. Fault-domain placement, rather than simple capacity, may determine which host can be removed.

### Operational implication

Scale-down procedures must account for host-to-fault-domain placement. Cost-reduction plans should not assume that any selected host can be deleted.

---

## 10. The 75% vSAN Utilization Limit

The transcript presents 75% utilization as a strict operating and service-level boundary. The remaining 25% is working capacity required for vSAN maintenance, recovery, and placement operations.

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

* The transcript states that remaining below 75% utilization is required to maintain the financially backed Microsoft service-level agreement.

* It further states that operating at a higher utilization, such as 85%, places the environment outside supported service-level bounds.

> **Requires documentation validation:** The exact SLA language, measurement method, grace periods, and enforcement conditions associated with the 75% threshold must be confirmed before contractual reliance.

### Operational recommendation

Trigger expansion planning well before utilization reaches 75%. Procurement lead time, host availability, data rebalancing, and fault-domain constraints can make last-minute expansion unsafe.

---

## 11. Failures to Tolerate and RAID Policies

VMware defines redundancy through failures to tolerate (FTT). The required FTT level and RAID layout change as the cluster grows.

| Cluster size   | Required FTT stated in transcript | Supported protection examples                        | Protection objective                    |
| -------------- | --------------------------------: | ---------------------------------------------------- | --------------------------------------- |
| **3–5 hosts**  |                             FTT=1 | RAID 1 mirroring, or RAID 5 with at least four hosts | Survive one host failure.               |
| **6–16 hosts** |                             FTT=2 | RAID 6 erasure coding                                | Survive two simultaneous host failures. |

### 11.1 FTT=1 behavior

* FTT=1 requires data to remain available after one physical host fails.

* RAID 1 stores an exact copy of data on separate hosts.

* RAID 5 uses parity to reduce capacity overhead compared with full mirroring.

* The transcript states that RAID 5 requires at least four hosts.

### 11.2 FTT=2 behavior

* At six or more hosts, the transcript states that the SLA mandates FTT=2.

* FTT=2 must preserve data through two simultaneous host failures.

* RAID 6 uses double parity.

* Double-parity protection consumes more physical capacity and compute than a single-failure policy.

> **Requires documentation validation:** The relationship between cluster size, default policy, mandatory FTT level, SLA eligibility, and supported RAID layouts should be confirmed for the selected host generation and AVS release.

---

## 12. Thick and Thin Provisioning

The transcript warns that the default storage policy is thick provisioning and recommends moving promptly to thin provisioning.

### 12.1 Thick provisioning behavior

* A virtual disk’s full requested capacity is reserved immediately.

* A 100 GB disk consumes 100 GB of physical allocation even if only 10 GB contains data.

* Unused logical space remains unavailable to other workloads.

* Thick provisioning accelerates physical-capacity consumption in an environment already constrained by a 75% threshold.

### 12.2 Thin provisioning behavior

* Physical capacity is consumed only as data is written.

* A 100 GB virtual disk containing 10 GB of data initially consumes approximately 10 GB rather than the full 100 GB.

* The virtual disk can grow dynamically as the application writes more data.

* Thin provisioning improves storage efficiency.

* Thin provisioning also creates an overcommitment risk because total promised logical capacity can exceed installed physical capacity.

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
   * Thin provisioning initially consumes 10 GB.
   * Thin provisioning avoids 90 GB of immediate allocation in this example.

4. **Practical interpretation**

   * Across hundreds of VMs, thin provisioning can substantially delay host purchases and reduce stranded storage.

5. **Why the real result may differ**

   * Metadata and protection-policy overhead add consumption.
   * Snapshots increase actual usage.
   * Guest deletions may not immediately release physical blocks.
   * Application growth can consume the remaining logical capacity rapidly.

> **Operational recommendation:** Change the default vSAN policy to thin provisioning where appropriate, but pair the change with capacity-alerting, growth forecasting, and monitoring of committed versus physically consumed capacity.

---

## 13. Independent Storage Expansion

Hyper-converged infrastructure can force organizations to buy compute hosts when they need only storage. The transcript describes external Azure storage integration as a way to decouple those requirements.

* A large SQL database may need dozens of terabytes without needing more CPU or memory.

* Buying another AVS host solely for its local drives may be economically inefficient.

* Azure NetApp Files can be mounted into the VMware environment as a datastore.

* Azure Elastic SAN is also described as an external datastore option.

* External datastores allow storage to scale independently from ESXi host count.

* Storage traffic must traverse the connection between AVS and the Azure virtual network.

* Network latency and routing design therefore become part of the storage architecture.

> **Architectural interpretation:** External datastores shift AVS from a strictly hyper-converged model toward a design in which compute and storage can be scaled separately.

---

## 14. Network Planning Principles

Networking is presented as the highest-risk phase of AVS planning. Address-space or routing mistakes made during initial deployment can be difficult to reverse without service interruption.

### 14.1 Dedicated `/22` management block

* AVS requires a dedicated minimum `/22` Classless Inter-Domain Routing (CIDR) block.

* The transcript uses `10.10.0.0/22` as an example.

* The block must be globally unique within the organization.

* It must not overlap with Azure virtual networks.

* It must not overlap with on-premises networks.

* The `/22` is reserved for AVS platform infrastructure and management functions.

* Workload VMs do not receive addresses from this management block.

### 14.2 Internal subdivision described in the transcript

| Internal use                           |                                   Prefix size stated |
| -------------------------------------- | ---------------------------------------------------: |
| vCenter and NSX management network     |                                                `/26` |
| ESXi host management interfaces        |                                                `/25` |
| vMotion network                        |                                                `/25` |
| vSAN node-to-node replication          |                                                `/25` |
| HCX and backend ExpressRoute functions | Additional internal subnets from the remaining space |

### 14.3 Address-allocation calculation

> **Transcript-derived calculation: Known `/22` subdivisions**

1. **Inputs**

   * One `/26`.
   * Three `/25` networks.

2. **Formula**

   * `/26` address count: `64`
   * `/25` address count: `128`
   * Three `/25` networks: `3 × 128 = 384`
   * Known allocated addresses: `64 + 384 = 448`
   * Total addresses in a `/22`: `1,024`
   * Remaining before other reservations: `1,024 − 448 = 576`

3. **Result**

   * The explicitly described subnets consume 448 addresses.
   * Up to 576 addresses remain for HCX, ExpressRoute, additional platform services, and reserved space.

4. **Practical interpretation**

   * The apparently oversized `/22` supports multiple isolated infrastructure networks rather than only three physical hosts.

5. **Why the real result may differ**

   * Network and broadcast conventions affect usable addresses.
   * Microsoft may reserve additional ranges.
   * The exact automated subdivision may vary by platform design or release.

### 14.4 Workload networks

* Workload VMs reside on separate NSX segments.

* Customers create and manage those segments through NSX tier-1 gateways.

* Workloads may use newly designed IP addressing.

* HCX can extend existing on-premises subnets into AVS.

* The platform `/22` should never be treated as a general-purpose workload address pool.

### Key dependency

The `/22` must be selected before deployment and must remain nonoverlapping across the entire hybrid network.

---

## 15. ExpressRoute Connectivity

AVS depends on Microsoft ExpressRoute for private connectivity between the VMware environment and Azure networking.

### 15.1 AVS-to-Azure connectivity

* Microsoft automatically provisions a backend ExpressRoute circuit when AVS is deployed.

* The circuit connects the isolated AVS environment to Azure virtual networks.

* AVS workloads use this path to reach native Azure services.

* External datastores such as Azure NetApp Files depend on this connectivity.

### 15.2 On-premises connectivity problem

A standard Azure virtual network gateway does not act as a transit router between two external circuits.

* An organization may already have an ExpressRoute circuit from its physical data center to an Azure virtual network.

* AVS has its own ExpressRoute circuit connected to Azure.

* The Azure VNet gateway does not automatically forward traffic between the on-premises circuit and the AVS circuit.

* Connecting both circuits to the same virtual network does not create end-to-end transit.

### 15.3 ExpressRoute Global Reach

ExpressRoute Global Reach connects the circuits at the Microsoft Enterprise Edge layer.

1. The on-premises packet enters Microsoft’s edge network.

2. The edge router forwards it directly toward the AVS circuit.

3. The packet bypasses the Azure virtual network gateway as an intermediate transit device.

4. AVS receives the traffic through its dedicated ExpressRoute path.

> **Architectural interpretation:** Global Reach links the on-premises and AVS circuits directly rather than expecting an Azure VNet gateway to bridge them.

---

## 16. BGP Route Limits and Summarization

Border Gateway Protocol (BGP) route scale is a critical design constraint. The transcript describes a hard maximum of 1,000 routes propagated to the ExpressRoute gateway when Azure Route Server integration is used.

* **Stated limit:** No more than 1,000 routes may be propagated.

* **Risk profile:** Legacy networks may contain thousands of fragmented subnets.

* **Failure scenario:** The transcript states that advertising approximately 1,500 routes can cause the BGP peering session to fail.

* **Service consequence:** A failed BGP session can isolate AVS from the on-premises environment.

* **Platform rationale:** Microsoft edge routers enforce finite BGP state-table limits to protect regional stability.

### Required route-preparation process

1. Inventory every prefix that could be advertised toward Azure and AVS.

2. Identify contiguous networks that can be represented by larger aggregate prefixes.

3. Summarize routes on the on-premises core routers or an approved network virtual appliance.

4. Confirm that the summarized advertisement remains below the route limit.

5. Validate that no required management or workload routes are lost through overaggregation.

6. Test BGP failure and recovery before migration traffic depends on the connection.

7. Monitor received and advertised prefix counts continuously.

> **Operational recommendation:** Do not use the production ExpressRoute peering session as the first place to discover that the enterprise routing table exceeds the supported scale.

---

## 17. Bogon and Default-Route Risks

The transcript uses the term “Bogon routes” for route advertisements that can disrupt AVS management traffic.

### 17.1 Prohibited prefixes identified in the transcript

* `0.0.0.0/5`

* `192.0.0.0/3`

> **Requires documentation validation:** The complete prohibited-prefix list and the transcript’s use of the term “Bogon” should be checked against current AVS routing guidance.

### 17.2 Default-route failure scenario

* An on-premises router advertises `0.0.0.0/0` toward AVS.

* AVS interprets the route as the path for unknown destinations.

* Management components such as vCenter and NSX Manager may send return traffic toward the on-premises default route.

* Return packets can be misrouted or dropped.

* Administrators may lose access to the vCenter management interface from the office network.

### 17.3 Mitigation described in the transcript

* Advertise a more specific route for the AVS management `/22`.

* Ensure the specific route directs management return traffic through the intended path.

* Avoid broad advertisements that override required platform routing behavior.

> **Failure condition:** A valid-looking enterprise default route can act as a management black hole when introduced into AVS without more-specific routing controls.

---

## 18. ExpressRoute FastPath

FastPath reduces network-processing latency between AVS and native Azure services.

* In a standard path, traffic from ESXi reaches an ExpressRoute virtual network gateway before being forwarded to the destination.

* Gateway processing adds latency.

* FastPath allows eligible traffic to bypass the virtual network gateway.

* AVS packets can travel more directly to services such as Azure NetApp Files.

* This is particularly important for databases that require high input/output operations per second (IOPS).

* The transcript associates FastPath with achieving hundreds of thousands of IOPS for enterprise databases.

> **Requires documentation validation:** FastPath eligibility, gateway requirements, supported routes, datastore designs, and achievable IOPS depend on the selected Azure services and configuration. The transcript’s characterization of FastPath as the only way to achieve the cited performance should be validated.

---

## 19. Security Baseline and Internet Isolation

AVS is isolated by default. Deploying the private cloud does not directly expose workloads to the public internet.

* No workload receives automatic public internet exposure.

* Internet ingress and egress must be intentionally designed.

* A public web workload can route through Azure Application Gateway.

* A Web Application Firewall (WAF) can inspect application-layer traffic.

* Azure Firewall can provide controlled network egress and packet inspection.

* Security controls should be inserted before traffic reaches the public internet.

### Operational implication

Public connectivity is an architecture decision, not a default platform behavior. Internet paths, inspection points, source translation, and return routing must be designed explicitly.

---

## 20. Identity, the CloudAdmin Account, and Least Privilege

Microsoft initially provides a high-privilege VMware account for the private cloud. The transcript identifies this account as `cloudadmin@vsphere.local`.

### 20.1 Break-glass account treatment

* Microsoft supplies an automatically generated password.

* The account provides broad control over the vCenter environment.

* It should not be used for normal administration.

* A shared static account cannot provide individual accountability.

* Destructive actions performed with the account are difficult to attribute to a named person.

* The credentials should be stored in a controlled digital vault.

* The password should be rotated immediately after emergency use.

### 20.2 Active Directory integration

* vCenter and NSX Manager should be integrated with the corporate Active Directory environment.

* The transcript specifies secure LDAP, or LDAPS.

* LDAPS encrypts directory queries and authentication exchanges in transit.

* Custom VMware roles should be created with fewer privileges than CloudAdmin.

* Roles should be assigned to defined Active Directory groups.

* Administrators should sign in with named individual accounts.

* Named accounts provide a usable audit trail.

### 20.3 Recommended identity sequence

1. Secure the initial CloudAdmin credential in an approved secrets vault.

2. Establish network reachability from AVS management components to the directory service.

3. Configure LDAPS for vCenter and NSX Manager.

4. Validate certificate trust and encrypted authentication.

5. Create granular roles aligned with operational responsibilities.

6. Map corporate Active Directory groups to those roles.

7. Test named-user access.

8. Remove CloudAdmin from daily operational workflows.

9. Implement an emergency-use and immediate-rotation procedure.

---

## 21. Azure Control-Plane Governance

Securing VMware identity does not protect the Azure resource layer by itself. Azure role assignments may expose management capabilities and private-cloud credentials.

* The AVS private cloud is represented as a resource in Azure.

* A user with sufficient rights on the containing resource group may be able to retrieve high-privilege VMware credentials.

* Overly broad Azure Contributor access can therefore bypass VMware-side least-privilege controls.

* Azure role-based access control must be designed as part of the AVS security boundary.

### 21.1 Privileged elevation model

The transcript recommends a privileged identity workflow that:

* Prevents standing permanent Contributor access.

* Requires engineers to request temporary elevation.

* Captures a business justification.

* Can require manager or security approval.

* Automatically expires elevated access after a limited period.

> **Requires documentation validation:** The transcript names this capability as “Microsoft Anfra Privileged Identity Management,” alternates between “PM” and an implied privileged-management acronym, and appears to contain a transcription inconsistency. The intended product name and configuration requirements must be confirmed before publication.

### Key implication

AVS has two control planes that require coordinated governance: the Azure resource plane and the VMware management plane.

---

## 22. Shared Responsibility Model

AVS transfers significant infrastructure responsibility to Microsoft without transferring responsibility for workload security and governance.

| Area                    | Microsoft responsibility described in transcript             | Customer responsibility described in transcript                                               |
| ----------------------- | ------------------------------------------------------------ | --------------------------------------------------------------------------------------------- |
| Physical data center    | Physical security, power, hardware, and facility operations. | No direct physical administration.                                                            |
| Bare-metal hosts        | Hardware replacement and host lifecycle.                     | Capacity planning and supported workload placement.                                           |
| VMware platform         | Hypervisor and core-stack maintenance and patching.          | Use of the platform within supported limits.                                                  |
| Network security        | Operation of the foundational AVS infrastructure.            | NSX distributed firewall rules, segmentation, ingress, egress, and lateral-movement controls. |
| Azure access            | Azure platform availability and identity services.           | Azure RBAC, privileged access, and protection of retrievable credentials.                     |
| Guest operating systems | Not described as a Microsoft AVS host responsibility.        | OS patching, application patching, agents, logs, malware protection, and configuration.       |
| Backups                 | Platform APIs are made available.                            | Selection, configuration, retention, validation, and recovery testing.                        |

### Key implication

A managed hypervisor does not make the guest operating systems, applications, firewall policies, or administrator identities fully managed.

---

## 23. Restricted ESXi Host Access

Traditional VMware administrators may expect root Secure Shell (SSH) access to ESXi. AVS intentionally removes that administrative pattern.

* Root access to the ESXi host shell is restricted.

* Customers cannot SSH into the hypervisor.

* Customers cannot install custom kernel modules.

* Customers cannot install unsupported host-level backup agents.

* Customers cannot inject unique hardware drivers into the managed host.

* The restriction protects the platform’s security, stability, patchability, and SLA.

### Operational consequence

Tools that depend on direct host access must be replaced, reconfigured, or proven compatible with supported VMware APIs.

---

## 24. Backup Through VMware APIs

Backups must use supported management APIs instead of host-installed agents.

* The transcript identifies the VMware vStorage APIs for Data Protection, or VADP, as the intended integration mechanism.

* Backup software communicates with vCenter.

* The software requests VM snapshots through supported APIs.

* Backup data is streamed over the network.

* No backup agent is installed in the ESXi kernel.

* The transcript names Azure Backup Server, Commvault, and Veeam as examples of tools using this model.

> **Source normalization note:** One speaker initially pronounces the acronym incorrectly before it is corrected to VADP in the transcript.

### Backup validation sequence

1. Confirm that the selected backup platform supports AVS and VADP.

2. Register the platform with vCenter using a least-privilege service identity.

3. Validate snapshot creation and removal.

4. Test network throughput for backup and restore traffic.

5. Perform a complete VM recovery.

6. Test application-consistent recovery where required.

7. Verify that backup operations do not depend on ESXi root access.

---

## 25. Azure Arc and Guest-Level Management

Azure Arc provides an Azure-native management bridge for VMs that continue to run on VMware.

* The Azure Arc agent is installed inside the Windows or Linux guest operating system.

* The agent does not require access to the ESXi host.

* Azure Policy can be applied to Arc-enabled servers.

* Azure Update Management can coordinate operating-system patching.

* Security logs can be sent to Microsoft Defender for Cloud.

* The management experience becomes less dependent on the underlying hypervisor.

* A VM can retain its VMware-compatible execution environment while adopting Azure-native governance.

> **Architectural interpretation:** AVS preserves the application’s VMware dependency below the guest while Azure Arc modernizes management above the guest.

### Operational implication

The long-term operating model can become cloud-native even when the application has not yet been replatformed.

---

## 26. VMware HCX and Migration Mechanics

VMware HCX is presented as the defining migration feature of AVS. The transcript states that Microsoft includes HCX without an additional licensing charge.

> **Requires documentation validation:** HCX edition, included capabilities, licensing terms, and service entitlements should be confirmed for the selected AVS offer.

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

* An HCX appliance runs in the on-premises VMware environment.

* Another HCX appliance runs in AVS.

* The appliances establish an encrypted IPsec tunnel over ExpressRoute.

* HCX extends the source Layer 2 network into the NSX environment.

* The migrated VM remains on the same logical subnet.

* The VM can retain its IP address.

* The VM can retain its MAC address.

* Existing firewall rules tied to that identity can remain valid.

* The VM can move while preserving active network sessions, subject to the supported migration design.

### 26.3 Migration flow

1. Deploy and configure the on-premises HCX components.

2. Establish the HCX service connection to AVS.

3. Confirm encrypted connectivity over the intended network path.

4. Extend the required Layer 2 network into NSX.

5. Validate routing, firewall rules, maximum transmission unit settings, and name resolution.

6. Select the migration wave.

7. Start the migration from the on-premises HCX interface.

8. Verify VM placement and application availability in AVS.

9. Monitor the stretched network for trombone-routing effects.

10. Enable Mobility Optimized Networking where appropriate.

11. Move every remaining workload from the extended subnet.

12. Relocate the subnet’s permanent gateway to Azure.

13. Remove the temporary HCX network extension.

---

## 27. Trombone Routing

Layer 2 extension preserves IP addressing but may leave the workload’s default gateway in the on-premises data center.

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

* Network latency increases.

* ExpressRoute bandwidth carries unnecessary round-trip traffic.

* Application response time degrades.

* Local Azure traffic may be routed through the on-premises data center.

> **Transcript-derived analogy:** Trombone routing is compared with flying from New York to London while being forced to stop in Los Angeles for every trip. The destination is reachable, but the path is operationally inefficient.

---

## 28. Mobility Optimized Networking

HCX Mobility Optimized Networking (MON) reduces trombone routing while the Layer 2 extension remains active.

### 28.1 MON behavior

* MON observes the location of the migrated VM.

* The local NSX gateway intercepts relevant traffic.

* Internet-bound or locally reachable traffic is routed through the Azure-side path.

* Traffic no longer needs to return to the on-premises gateway merely because the VM retains its original subnet identity.

* The VM does not need to be readdressed immediately.

### 28.2 Scale limits stated in the transcript

| MON design                                |          Limit stated |
| ----------------------------------------- | --------------------: |
| Standard HCX appliance profile            | Approximately 400 VMs |
| Larger HCX appliance profile              |       Up to 1,000 VMs |
| Simultaneous network extensions using MON |                   100 |

> **Requires documentation validation:** MON limits are dependent on HCX edition, appliance sizing, software version, topology, and workload behavior.

### 28.3 Why MON is temporary

* Packet interception consumes appliance compute and state-table capacity.

* Network extensions consume a finite resource.

* Stretched Layer 2 networks preserve migration flexibility but retain hybrid-network complexity.

* Once all VMs on a subnet have moved, the default gateway should move permanently to Azure.

* The network extension should then be removed.

* Released HCX capacity can be reused for the next migration wave.

> **Operational recommendation:** Treat HCX network extension and MON as migration mechanisms, not as a permanent network architecture.

---

## 29. Migration Initiation Rule

The transcript states that HCX migration workflows must be initiated from the on-premises HCX interface.

* The on-premises environment is the source of the migration.

* Engineers should not log in to cloud-side vCenter and attempt to pull the VM into AVS.

* The transcript refers to the cloud-initiated pull as a reverse migration.

* Source-side initiation ensures the intended gateway-interception and MON behavior is configured across the tunnel.

> **Requires documentation validation:** Supported migration directions and initiation rules may vary by HCX migration type. The transcript’s “without exception” wording should be validated before being encoded as an absolute operational policy.

---

## 30. Migration-Wave Operating Model

HCX limits require structured migration waves.

1. Group workloads by application dependency and subnet.

2. Identify the networks that must be extended for the current wave.

3. Confirm that VM and network-extension counts remain below HCX and MON limits.

4. Extend only the networks needed for the active wave.

5. Migrate the selected VMs.

6. Enable MON for migrated workloads that would otherwise experience trombone routing.

7. Validate application communication and performance.

8. Move the remaining VMs from the same subnet.

9. Transfer the subnet’s permanent default gateway to Azure.

10. Remove the Layer 2 extension.

11. Release HCX appliance capacity.

12. Begin the next wave.

### Key dependency

A subnet cannot be cleanly de-extended until all workloads and dependencies that require that subnet have been addressed.

---

## 31. Stretched Clusters and Availability Zones

AVS stretched clusters provide infrastructure resilience across two Azure Availability Zones in the same region.

* An Availability Zone is described as a physically separate data-center complex.

* Each zone has independent power, cooling, and network paths.

* Zones are separated sufficiently to reduce the likelihood that one localized event affects both.

* A stretched cluster presents one VMware cluster and vSAN datastore across two zones.

* VM writes are synchronously mirrored between the zones.

* A write is not considered complete until both locations acknowledge it.

### 31.1 Zone-failure behavior

* One Availability Zone becomes unavailable.

* VMs running in that zone stop.

* VMware High Availability detects the host loss.

* The affected VMs restart on surviving hosts in the second zone.

* The design protects against the loss of an entire zone, subject to capacity and quorum availability.

### 31.2 Stretched-cluster scale

* A standard cluster begins at three hosts.

* A stretched cluster requires at least six hosts.

* The hosts are distributed as three per zone.

* The cluster can scale to a maximum of 16 hosts in total.

### 31.3 AV64 limitation

* The transcript states that AV64 is not supported in a stretched-cluster configuration.

* Applications requiring the AV64 CPU profile cannot use this multi-zone stretched design.

* Architects must choose between the AV64 compute profile and the described multi-zone cluster resilience.

> **Requires documentation validation:** Stretched-cluster SKU support, minimum host count, supported regions, and maximum scale should be confirmed before design approval.

---

## 32. Split-Brain Prevention and the vSAN Witness

A stretched cluster requires a third decision point to prevent both zones from taking control during a network partition.

### 32.1 Split-brain scenario

* The network between Zone 1 and Zone 2 fails.

* Both data centers remain powered and operational.

* Zone 1 concludes that Zone 2 is unavailable.

* Zone 2 concludes that Zone 1 is unavailable.

* Without quorum, both sides could attempt to continue writing independently.

* Divergent writes could cause unrecoverable data corruption.

### 32.2 Witness function

* Microsoft deploys a managed vSAN witness appliance in a third Availability Zone.

* The witness stores no application data.

* It acts as a quorum tiebreaker.

* The data site that can still communicate with the witness receives authority to continue.

* The other side is prevented from independently writing to the shared datastore.

> **Architectural interpretation:** Two data sites provide redundancy, but the third-zone witness provides authority. The witness prevents availability mechanisms from becoming a source of data corruption.

---

## 33. Witness-Zone Failure Scenario

The transcript describes a specific degraded state when the witness becomes unavailable while both data sites remain healthy.

### 33.1 Immediate behavior

* Existing workloads continue running.

* No immediate application outage occurs.

* No immediate data loss occurs.

* The physical data hosts remain online.

### 33.2 Degraded cluster behavior

* The cluster loses quorum awareness.

* vSAN cannot safely make certain placement or recovery decisions.

* The storage environment enters a constrained or frozen state.

* A VM that is powered off cannot be powered on.

* Background data rebalancing is blocked.

* Failed data components are not repaired during the witness outage.

* A subsequent physical disk or host failure increases risk because normal repair activity cannot proceed.

### 33.3 Recovery dependency

* Microsoft engineers must intervene.

* A replacement witness appliance must be provisioned.

* Quorum must be re-established.

* Normal storage-management and repair operations resume only after quorum is restored.

> **Failure condition:** A witness outage may leave applications online while removing the platform’s ability to restart, rebalance, or repair them. Application availability during the initial event should not be mistaken for full cluster health.

---

## 34. Consolidated Operational Recommendations

The transcript’s major recommendations can be converted into a set of implementation controls.

### 34.1 Before deployment

* Reserve a globally unique, nonoverlapping `/22` for AVS management infrastructure.

* Confirm cluster and host limits for the target region.

* Determine whether the workload requires standard hosts, AV64 expansion, or stretched-cluster resilience.

* Model management-resource reservations separately from application capacity.

* Inventory on-premises BGP routes and reduce the advertisement below the stated limit.

* Identify prohibited or dangerous route advertisements.

* Plan Azure and VMware administrative roles as two separate security layers.

### 34.2 During platform configuration

* Configure Active Directory integration through LDAPS.

* Create named, least-privilege administrative roles.

* Place the CloudAdmin credential in a secure vault.

* Remove permanent broad Azure Contributor access.

* Configure temporary privileged elevation for high-impact Azure operations.

* Change suitable vSAN policies from thick to thin provisioning.

* Configure storage monitoring around the 75% threshold.

* Validate VADP-based backups.

* Deploy Azure Arc inside guest operating systems where Azure-native governance is required.

### 34.3 During compute expansion

* Verify CPU-generation compatibility.

* Configure VM-level EVC before workloads boot on AV64.

* Test live migration in both directions.

* Check explicit fault-domain placement before requesting host removal.

* Plan a cold-migration procedure for VMs that have already adopted an incompatible CPU profile.

### 34.4 During migration

* Start migrations from the source-side HCX interface.

* Extend only the networks needed for the current wave.

* Monitor HCX and MON scale limits.

* Detect and correct trombone routing.

* Transfer the permanent default gateway to Azure after the final VM on the subnet has moved.

* Remove the temporary Layer 2 extension.

### 34.5 During steady-state operations

* Maintain vSAN below the supported utilization threshold.

* Monitor actual, committed, and projected thin-provisioned capacity.

* Keep management and workload routes explicit.

* Monitor BGP route counts and peering health.

* Test backups and complete restores.

* Patch guest operating systems independently of Microsoft’s hypervisor maintenance.

* Maintain NSX segmentation and lateral-movement controls.

* Treat witness loss as a serious degraded-state incident even when applications remain online.

---

## 35. Failure and Troubleshooting Matrix

| Symptom or event                                          | Likely cause described in transcript                                                | Operational effect                                                                   | Recommended response                                                                                                 |
| --------------------------------------------------------- | ----------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------- |
| Live migration from AV64 to an older cluster is blocked.  | The VM booted with newer CPU features and lacks a compatible VM-level EVC baseline. | The VM cannot move live.                                                             | Power off the VM, perform a cold migration, restart it on the older baseline, and configure EVC before future moves. |
| Host-removal request returns HTTP 409.                    | The removal would create an invalid AV64 fault-domain balance.                      | The selected host cannot be removed.                                                 | Review fault-domain placement and remove an eligible host instead.                                                   |
| vSAN utilization exceeds 75%.                             | Capacity growth, thick provisioning, snapshots, or insufficient expansion planning. | Reduced operational headroom, possible performance degradation, and stated SLA risk. | Stop nonessential growth, identify reclaimable capacity, and add storage or hosts.                                   |
| BGP peering drops after route advertisement.              | The advertised route count exceeds the stated 1,000-route limit.                    | AVS loses on-premises connectivity.                                                  | Withdraw excess routes, summarize prefixes, and re-establish peering.                                                |
| vCenter is unreachable from on-premises.                  | A default or prohibited route has redirected management return traffic.             | Management access is lost.                                                           | Remove the problematic advertisement and restore a more-specific path for the AVS `/22`.                             |
| Migrated application latency rises sharply.               | Traffic is tromboning through the on-premises default gateway.                      | Slow response and unnecessary ExpressRoute usage.                                    | Enable MON where supported or move the gateway permanently to Azure.                                                 |
| HCX cannot optimize additional VMs or networks.           | MON VM count or network-extension state-table limits have been reached.             | Later migration waves cannot use the same optimization.                              | Complete subnet cutovers, remove old extensions, or resize the HCX appliances.                                       |
| Backup tool requests ESXi root access.                    | The product relies on unsupported host-installed agents.                            | The tool cannot operate as designed in AVS.                                          | Replace or reconfigure it to use VADP and vCenter APIs.                                                              |
| Existing workloads run, but powered-off VMs cannot start. | The stretched-cluster witness is unavailable.                                       | The cluster remains online but cannot safely perform key operations.                 | Escalate to Microsoft for witness restoration and avoid additional infrastructure changes.                           |
| Storage-only demand forces consideration of another host. | vSAN capacity is coupled to compute.                                                | The organization may purchase unnecessary CPU and memory.                            | Evaluate an external datastore such as Azure NetApp Files or Azure Elastic SAN.                                      |

---

# Architecture Summary

Azure VMware Solution combines Azure-managed physical infrastructure with a complete VMware software-defined data center. Azure provisions and maintains the bare-metal platform, while VMware components preserve the application runtime, management interfaces, network semantics, and migration tooling familiar to existing VMware operations teams.

## End-to-end architecture and traffic flow

1. **Azure provisions the private cloud.**

   * Azure Resource Manager creates the AVS resource and allocates dedicated bare-metal hosts.
   * Microsoft manages the physical servers, power, top-of-rack switching, and VMware platform lifecycle.

2. **ESXi provides the compute layer.**

   * ESXi runs directly on the physical servers without an intervening Azure hypervisor.
   * VMs consume the physical CPU and memory through VMware virtualization.

3. **vCenter manages the VMware environment.**

   * Administrators provision VMs, manage clusters, monitor performance, and use existing VMware integrations.
   * A protected management resource pool reserves CPU and memory for the control plane.

4. **vSAN supplies the initial datastore.**

   * Local NVMe and SSD devices are pooled across hosts.
   * Storage policies implement mirroring or erasure coding.
   * Capacity must retain sufficient free space for rebalancing and recovery.

5. **External Azure storage can extend capacity.**

   * Azure NetApp Files or Azure Elastic SAN can be attached as external datastores.
   * Fast, correctly routed connectivity is required between AVS and the Azure virtual network.

6. **NSX supplies workload networking and security.**

   * The dedicated `/22` supports AVS management infrastructure.
   * Customer workloads use separate NSX segments and tier-1 gateways.
   * NSX distributed firewall rules control lateral movement.

7. **ExpressRoute connects AVS to Azure.**

   * Microsoft provisions the AVS backend ExpressRoute circuit.
   * FastPath can reduce gateway-processing latency for eligible Azure-service traffic.

8. **Global Reach connects AVS to the physical data center.**

   * On-premises and AVS ExpressRoute circuits are linked at the Microsoft edge.
   * The design avoids relying on an Azure VNet gateway as a transit router.

9. **HCX moves workloads into AVS.**

   * HCX extends Layer 2 networks through an encrypted tunnel.
   * VMs can retain IP and MAC addresses during migration.
   * MON reduces trombone routing while the extension remains active.

10. **Migration waves remove temporary hybrid dependencies.**

    * Workloads move in subnet-aligned groups.
    * The default gateway ultimately relocates to Azure.
    * HCX network extensions are removed after each subnet is fully migrated.

11. **Azure and VMware identity controls protect the two management planes.**

    * VMware administrators use named Active Directory accounts over LDAPS.
    * CloudAdmin remains a vaulted break-glass credential.
    * Azure-side privileged access is temporary, justified, and automatically revoked.

12. **Azure Arc manages the guest operating systems.**

    * Arc agents apply Azure policy, patching, and security monitoring inside the VMs.
    * Guest governance becomes Azure-native even though execution remains on VMware.

13. **Stretched clusters provide multi-zone resilience where supported.**

    * Data is synchronously mirrored between two Availability Zones.
    * A third-zone vSAN witness provides quorum and prevents split-brain operation.
    * Loss of the witness creates a serious degraded state even if workloads remain online.

## Final Result

AVS changes the practical definition of cloud migration. The workload may continue running on VMware ESXi, but its hardware, lifecycle, connectivity, governance, monitoring, and security can be delivered through Azure.

The platform’s effectiveness depends on disciplined engineering rather than simple host deployment. CPU compatibility, management reservations, vSAN free space, fault domains, route scale, default-route behavior, least-privilege access, HCX limits, and witness quorum all have direct operational consequences. When those dependencies are designed correctly, AVS can move a large VMware estate into Azure without requiring immediate application refactoring or disruptive IP-address changes.
