# Why Azure VMware Solution Gen 2 Can Break Enterprise Networks

## Technical Guide to Generation 1and Resilience

Azure VMware Solution (AVS) lets organizations relocate VMware workloads to dedicated Azure infrastructure without first rewriting every application. The Generation 1 and Generation 2 architectures provide the same basic VMware operating model, but they differ substantially in hardware, Azure connectivity, routing scale, migration behavior, and availability design.

The central architectural warning is straightforward: **Generation 2 simplifies connectivity by integrating AVS directly into an Azure virtual network, but this integration subjects the VMware environment to strict route-scale and placement constraints.** A design that ignores those constraints can exhaust route capacity during migration or prevent new workload networks from being programmed.

---

## 1. Azure VMware Solution as a Rehosting Platform

AVS addresses the problem of moving large VMware estates whose applications cannot be refactored within the available schedule or budget. Microsoft deploys VMware software on dedicated bare-metal Azure infrastructure and manages the underlying platform, while the customer continues managing workloads through familiar VMware tools.

* **Purpose:** AVS supports the relocation of VMware virtual machines without requiring every application to be rewritten as an Azure-native service.

* **Platform components:** An AVS private cloud includes VMware vCenter Server, VMware vSphere, VMware vSAN, and VMware NSX on dedicated Azure hosts. Microsoft manages and maintains the private-cloud infrastructure and VMware platform software. [Microsoft Learn — Introduction to Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)

* **Operational continuity:** Existing VMware administration practices, virtual-machine formats, and migration tools can remain applicable after the workloads move to Azure.

* **Migration value:** Organizations can use VMware HCX, vMotion, cold migration, or other supported mechanisms to relocate workloads instead of immediately refactoring them.

* **Application dependency:** AVS reduces infrastructure migration effort, but it does not remove application, identity, DNS, firewall, licensing, or dependency-analysis requirements.

> **Transcript-derived analogy:** AVS is described as a “cheat code” for a datacenter exit. Rather than rebuilding every application, the organization relocates its VMware operating environment onto Azure-hosted infrastructure.

### Operational implication

AVS is most valuable when the business benefit of quickly exiting a datacenter outweighs the cost of maintaining a VMware-based operating model in Azure.

---

## 2. The Generation 1 and Generation 2 Architecture Fork

Generation 2 is not merely a software update to Generation 1. It changes how the physical hosts attach to Azure networking and therefore affects connectivity, routing, security controls, hardware selection, migration planning, and failure-domain design.

| Architectural area            | Generation 1                                                       | Generation 2                                                     |
| ----------------------------- | ------------------------------------------------------------------ | ---------------------------------------------------------------- |
| Azure attachment model        | Microsoft-managed ExpressRoute                                     | Direct attachment to an Azure virtual network                    |
| Primary host choices          | AV36, AV36P, AV48, AV52; AV64 can be added as an expansion cluster | AV64                                                             |
| vSAN architecture             | Primarily OSA; AV48 uses ESA                                       | ESA                                                              |
| Azure VNet connectivity       | Requires an ExpressRoute-based connection                          | Native VNet integration and peering                              |
| Route-scale concern           | ExpressRoute and BGP design                                        | VNet prefix limit plus T0 `/28` programming limit                |
| Availability-zone placement   | Standard private clouds do not expose direct zone selection        | The deployment zone can be selected, subject to capacity         |
| Stretched cluster             | Supported for documented Gen 1 configurations                      | Not supported                                                    |
| Hardware cost flexibility     | Several host profiles                                              | AV64 only                                                        |
| Upfront placement constraints | Significant                                                        | More restrictive because the private cloud is embedded in a VNet |

Microsoft documents the current differences between the generations in the [Generation 2 introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction).

> **Transcript-derived analogy:** Generation 1 is like a private estate outside a city. It offers isolation and flexibility, but the owner must build a private highway to reach the city. Generation 2 places the estate directly into the city grid, providing immediate access to city services while imposing strict zoning and traffic rules.

### Documentation correction: direct AV64 deployment

The transcript reflects an earlier AV64 model in which an existing Generation 1 private cloud acted as a seed environment. Microsoft now supports directly creating a Generation 2 private cloud with a minimum three-host AV64 cluster. A Generation 1 seed cluster is not required for a new Generation 2 deployment. [Microsoft Learn — Introduction to Azure VMware Solution Generation 2](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)

AV64 can also still be added as a separate expansion cluster to a compatible existing Generation 1 private cloud. [Microsoft Learn — Introduction to Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)

---

## 3. Host Hardware and vSAN Storage Architecture

Hardware selection is inseparable from the generation decision. Generation 1 offers several compute and memory profiles, while Generation 2 is tied to AV64.

### 3.1 Host profiles

| Host type  | Processor and core count                                       |      RAM | vSAN architecture and storage                                                         |
| ---------- | -------------------------------------------------------------- | -------: | ------------------------------------------------------------------------------------- |
| AV36       | Dual Intel Xeon Gold 6140, Skylake; 36 physical cores          |   576 GB | OSA; NVMe cache and SSD capacity                                                      |
| AV36P      | Dual Intel Xeon Gold 6240, Cascade Lake; 36 physical cores     |   768 GB | OSA; Intel cache and NVMe capacity                                                    |
| AV48       | Dual Intel Xeon Gold 6442Y, Sapphire Rapids; 48 physical cores | 1,024 GB | ESA; NVMe capacity                                                                    |
| AV52       | Dual Intel Xeon Platinum 8270, Cascade Lake; 52 physical cores | 1,536 GB | OSA; Intel cache and NVMe capacity                                                    |
| AV64 Gen 1 | Dual Intel Xeon Platinum 8370C, Ice Lake; 64 physical cores    | 1,024 GB | OSA in the Generation 1 expansion model                                               |
| AV64 Gen 2 | Dual Intel Xeon Platinum 8370C, Ice Lake; 64 physical cores    | 1,024 GB | ESA; approximately 19.25 TB raw NVMe capacity in the current documented configuration |

The current specifications and qualifications are maintained in [Microsoft Learn — Introduction to Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction).

### Documentation correction: host networking

The transcript presents 100-Gbps interfaces as a Generation 2 differentiator. Current Microsoft documentation lists 100-Gbps network-interface throughput for all current AVS host profiles. The practical performance available to an individual workload still depends on workload traffic allocation, storage behavior, contention, software processing, and end-to-end network design.

### 3.2 vSAN Original Storage Architecture

vSAN Original Storage Architecture (OSA) organizes local devices into disk groups containing a cache tier and a capacity tier.

* **Write path:** New writes first enter a fast cache device.

* **Acknowledgment:** vSAN can acknowledge the write after it has been protected in the cache tier according to the applicable policy.

* **Destaging:** Data is later moved from cache into the capacity tier.

* **Historical benefit:** This architecture helped compensate for slower capacity devices by placing high-speed storage in front of them.

* **Processing overhead:** The cluster must manage disk groups, caching, destaging, capacity pressure, and data movement.

* **Congestion condition:** Sustained writes can reduce performance when data reaches the cache tier faster than it can be destaged.

* **Potentially affected workloads:** Large database writes, bulk data ingestion, migration replication, and virtual-desktop boot storms can create sustained storage pressure.

> **Transcript-derived analogy:** The cache tier acts as a high-speed hotel lobby. Arriving data can enter quickly, but congestion develops when arrivals exceed the rate at which the data can be moved into permanent rooms.

### 3.3 vSAN Express Storage Architecture

vSAN Express Storage Architecture (ESA) is designed for modern NVMe devices and removes the traditional OSA disk-group and dedicated cache-tier design. AV48 and AV64 Generation 2 deployments use ESA. [Microsoft Learn — Configure vSAN Express Storage Architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vsan-esa)

* **Single-tier storage:** Data is written directly to the high-performance NVMe capacity tier.

* **Reduced cache management:** ESA does not rely on a separate write-cache device followed by a destaging process.

* **Hardware alignment:** The architecture is optimized for low-latency NVMe storage and modern processors.

* **Operational benefit:** The design reduces bottlenecks associated with cache saturation and disk-group management.

### 3.4 Workloads that can justify AV64

AV64 is most compelling when workloads can use its compute, memory, storage, and network density.

* Highly transactional SQL Server or other database workloads.
* Storage-latency-sensitive systems.
* Large virtual desktop infrastructure deployments.
* Workloads with substantial input/output operations per second.
* Dense consolidation environments.
* Applications that benefit from newer processor instructions.

> **Transcript-derived scenario:** A virtual desktop environment in which thousands of users start their desktops at 8:00 a.m. creates a “boot storm.” ESA and NVMe can absorb that burst more effectively than a cache-constrained OSA design.

### 3.5 Cost and overprovisioning

* **Premium dependency:** A Generation 2 private cloud uses AV64 hosts even when the migrated workloads do not need AV64-level performance.

* **Overprovisioning risk:** Domain controllers, ordinary file servers, small intranet applications, and lightly used line-of-business systems might not consume the available compute or storage ceiling.

* **Generation 1 flexibility:** Several Generation 1 profiles allow an organization to align host density more closely with workload requirements.

* **Sizing requirement:** The design should use measured CPU, memory, storage latency, IOPS, throughput, and network utilization rather than assuming that the newest platform is automatically the most economical.

### 3.6 Region and quota dependencies

* Confirm AV64 availability in the target Azure region and availability zone. Microsoft maintains current placement information in [Azure VMware Solution private cloud and cluster concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds).

* Obtain AV64 quota before committing migration dates.

* Treat regional capacity as a deployment prerequisite rather than a post-design administrative task.

* Retain contingency plans for constrained regions or zones.

---

## 4. Generation 1 Connectivity

Generation 1 places the VMware private cloud adjacent to Azure networking but outside the customer VNet routing domain. Connectivity to Azure VNets is provided through Microsoft-managed ExpressRoute circuits. [Microsoft Learn — Azure VMware Solution networking architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking)

### 4.1 Core connectivity components

* **AVS ExpressRoute circuit:** The private cloud exposes a Microsoft-managed ExpressRoute connection.

* **Azure VNet connection:** An ExpressRoute virtual network gateway connects the AVS circuit to an Azure VNet.

* **On-premises connectivity:** ExpressRoute Global Reach can connect the AVS ExpressRoute circuit to the enterprise ExpressRoute circuit. [Microsoft Learn — Peer on-premises environments to Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/expressroute-global-reach-private-cloud)

* **Routing protocol:** Border Gateway Protocol (BGP) exchanges routes between relevant network domains.

* **Microsoft edge routing:** ExpressRoute connectivity traverses Microsoft Enterprise Edge routing infrastructure.

* **Gateway dependency:** The customer must plan gateway capacity, gateway subnets, route propagation, circuit authorization, and failure behavior.

### 4.2 Packet-flow example

A Generation 1 AVS virtual machine accessing a service in an Azure VNet follows an ExpressRoute-based path:

1. The workload sends traffic from an NSX segment.
2. Traffic exits the VMware routing domain through the AVS provider edge.
3. The packet crosses the AVS ExpressRoute circuit.
4. The ExpressRoute virtual network gateway introduces the traffic into the destination VNet.
5. Azure routes the packet to the destination service.
6. Return traffic follows the corresponding reverse path.

> **Architectural interpretation:** The transcript describes this as hairpinning through ExpressRoute. The exact physical and logical path depends on the selected topology, but Generation 1 does require an ExpressRoute attachment rather than direct VNet placement.

### 4.3 Operational consequences

* More network components must be configured and monitored.
* BGP advertisements and route propagation must be understood.
* ExpressRoute gateways introduce cost and capacity planning.
* Misconfiguration can occur at the circuit, authorization, peering, gateway, firewall, or route-propagation layer.
* ExpressRoute Global Reach is required for direct circuit-to-circuit connectivity between on-premises ExpressRoute and AVS because an ExpressRoute gateway does not provide transitive routing between its attached circuits. [Microsoft Learn — Azure VMware Solution FAQ](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)

---

## 5. Generation 2 VNet Integration

Generation 2 deploys the AVS private cloud directly into an Azure virtual network. This removes the need for an ExpressRoute gateway solely to reach Azure resources in that VNet or its supported peers. [Microsoft Learn — Introduction to Azure VMware Solution Generation 2](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)

### 5.1 Native connectivity benefits

* **Direct VNet attachment:** AVS infrastructure and gateway components are programmed into the selected VNet.

* **VNet peering:** Supported Azure VNet peering works without constructing the Generation 1 ExpressRoute bridge.

* **Simpler internal connectivity:** AVS workloads can access Azure-native resources through standard Azure networking paths.

* **Reduced gateway cost:** An ExpressRoute virtual network gateway is not required merely for internal AVS-to-Azure connectivity.

* **Reduced routing complexity:** The design removes the customer-managed BGP and gateway plumbing associated with the Generation 1 internal-Azure path.

* **Zonal alignment:** The organization can select a Generation 2 deployment zone, subject to available capacity, to align AVS with zonal Azure resources.

### 5.2 Packet-flow example

1. An AVS workload sends a packet from an NSX segment.
2. The provider T0 gateway translates between the NSX overlay and the Azure underlay.
3. Azure VNet routing or VNet peering carries the packet toward the Azure-native destination.
4. The destination service processes the request.
5. Return traffic follows the programmed VNet and AVS gateway path.

### 5.3 Azure security and DNS integration

* Generation 2 supports Azure-centric security controls, including network security groups, within the supported VNet design. [Microsoft Learn — Generation 2 introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)

* NSGs associated with the AVS host VNet must reside in the same resource group as the private cloud and VNet. [Microsoft Learn — Generation 2 design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration)

* Azure private DNS resolution can be selected for the private cloud.

* Custom DNS configured directly on the Generation 2 host VNet is not supported because it can disrupt lifecycle operations. Use the documented private-DNS integration model instead. [Microsoft Learn — Generation 2 design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration)

### Documentation correction: scope of NSG control

The transcript implies that ordinary customer NSGs can be freely applied to all VMware traffic. Generation 2 does expose Azure-centric security integration, but AVS also creates and manages required networking resources. Azure policies that enforce incompatible NSG or route-table naming and creation rules can prevent deployment. Security design must distinguish:

* Customer-controlled workload paths.
* Service-created AVS subnets and resources.
* System-managed protection for management components.
* Customer firewalls or network virtual appliances.
* NSX distributed and gateway firewall controls.

---

## 6. Generation 2 Infrastructure Addressing and Service Subnets

The host VNet is a permanent foundation of a Generation 2 deployment. Address planning must account for AVS infrastructure, VMware HCX, workload segments, peered networks, and temporary migration routes.

### 6.1 Address-space requirements

* A private `/22` network block is required for the core AVS private-cloud management deployment. A `/22` contains 1,024 total IPv4 addresses. [Microsoft Learn — Azure VMware Solution FAQ](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)

* The address space must not overlap:

  * On-premises networks.
  * Other Azure VNets.
  * Partner networks.
  * Other AVS private clouds that must communicate.
  * HCX network-extension ranges.
  * Future routed environments.

* Current Generation 2 guidance also requires two additional `/24` subnets for HCX management and uplink functions when HCX is deployed. [Microsoft Learn — Generation 2 design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration)

### 6.2 Service-managed subnets

Microsoft creates subnets and resources for functions such as:

* VMware management.
* vCenter Server and NSX Manager connectivity.
* vMotion or VMkernel traffic.
* NSX provider gateways.
* Azure-to-NSX routing.
* HCX management and uplink connectivity where applicable.

Current documentation refers to service subnets such as `avs-mgmt`, `avs-nsx-gw`, and `avs-nsx-gw-1` in supported routing scenarios. [Microsoft Learn — Generation 2 internet connectivity design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)

### 6.3 Service-managed security behavior

* AVS creates security and routing resources required by the service.

* Inbound internet access to private-cloud management components is not enabled by default.

* A customer might not see these controls represented in the same way as a conventional customer-created NSG.

* Management access still requires an approved routed source, correct name resolution, supported security configuration, and any required firewall permissions.

> **Transcript-derived analogy:** The service-managed security layer is compared to an invisible security agent standing in a doorway. A conventional lock might not appear in the expected portal view, but unauthorized traffic is still blocked by the platform.

### 6.4 Management-access validation procedure

1. Confirm that the source management subnet is approved.
2. Confirm that its address range does not overlap the AVS VNet.
3. Validate VNet peering, on-premises connectivity, or transit routing.
4. Check Azure route tables and effective routes where customer visibility is available.
5. Validate customer-managed NSGs, Azure Firewall policies, and network virtual appliances.
6. Validate NSX gateway and distributed firewall rules.
7. Confirm private DNS resolution for vCenter Server and NSX Manager.
8. Test the required ports from the management jump host.
9. Escalate to Microsoft when customer-controlled routing and security are correct but service-managed filtering or programming remains suspected.

---

## 7. Deployment Permanence and Governance

The Generation 2 private cloud and its host VNet are tightly coupled. Several placement decisions cannot be changed after deployment.

### 7.1 Documented restrictions

Microsoft currently documents the following restrictions for Generation 2: [Microsoft Learn — Generation 2 design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration)

* Only one private cloud can be deployed in an Azure VNet.
* Only one private cloud can be created in a resource group.
* The private cloud and host VNet must be in the same resource group.
* The private cloud cannot be moved to another resource group after creation.
* The private cloud cannot be moved to another tenant after creation.
* The resource group cannot be deleted until the private cloud is deleted.
* Cross-resource-group and cross-subscription references require the documented role assignment or must otherwise be removed.
* Certain Azure policies can block deployment by preventing AVS from creating required NSGs or route tables.

### 7.2 Governance consequences

A casually named proof-of-concept resource group can become a long-lived production boundary. Merger, divestiture, tenant consolidation, subscription reorganization, and network restructuring scenarios therefore need to be considered before deployment.

### 7.3 Predeployment governance checklist

1. Confirm the authoritative Microsoft Entra tenant.
2. Confirm the long-term Azure subscription and billing owner.
3. Select the permanent resource group.
4. Establish production naming and tagging standards.
5. Confirm the Azure region and availability zone.
6. Confirm AV64 capacity and quota.
7. Reserve nonoverlapping infrastructure and HCX address spaces.
8. Confirm the host VNet and peering model.
9. Review all cross-resource-group and cross-subscription references.
10. Review Azure Policy assignments that affect NSGs, routes, VNets, or resource names.
11. Confirm DNS architecture.
12. Define privileged-access and management-jump-host paths.
13. Define backup and disaster-recovery ownership.
14. Obtain architecture approval before creating the private cloud.

> **Operational recommendation:** Treat the first Generation 2 deployment as permanent production infrastructure, not as a disposable object that can easily be moved later.

---

## 8. Route-Scale Limits

Route scale is the most important Generation 2 networking constraint. Two independent limits must be modeled: the overall VNet prefix count and the number of `/28` entries programmed on NSX T0 uplinks.

Microsoft documents these limits in [Route architecture for Azure VMware Solution Generation 2](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture).

### 8.1 Overall VNet prefix limit

Generation 2 supports a maximum of **1,000 prefixes** in the private-cloud VNet address-space representation.

The count includes:

* NSX segment prefixes from `/29` through `/16`.
* NSX service routes such as DNS, VPN gateway, and destination NAT `/32` routes.
* VMware HCX Mobility Optimized Networking `/32` host routes.
* The private-cloud address space itself.

Because the private-cloud address space consumes an entry, as many as 999 other entries can remain in a minimal configuration.

### 8.2 Per-T0-NIC limit

Each NSX T0 uplink interface supports a maximum of **1,024 NSX segment prefixes** after route expansion.

* This limit applies to NSX segment entries.
* HCX MON `/32` routes consume the overall VNet limit but not the T0 NSX-segment slice count.
* Adding hosts can increase aggregate T0 capacity.
* Adding hosts does not increase the 1,000-prefix VNet limit.

### 8.3 `/28` route expansion

Azure divides each NSX segment advertisement into `/28` CIDR blocks and assigns the resulting entries to NSX T0 uplinks.

| Advertised NSX segment | `/28` entries created |
| ---------------------- | --------------------: |
| One `/28`              |                     1 |
| One `/27`              |                     2 |
| One `/26`              |                     4 |
| One `/24`              |                    16 |
| One `/23`              |                    32 |
| One `/22`              |                    64 |
| One `/16`              |                 4,096 |

#### Calculation: one `/24`

1. **Input:** One `/24` contains 256 addresses.
2. **Slice size:** One `/28` contains 16 addresses.
3. **Formula:** `256 ÷ 16 = 16`.
4. **Result:** One `/24` consumes 16 T0 slice entries.
5. **Practical interpretation:** Counting only visible NSX segments understates the interface-programming requirement.

#### Calculation: one `/22`

1. **Input:** One `/22` contains 1,024 addresses.
2. **Formula:** `1,024 ÷ 16 = 64`.
3. **Result:** One `/22` consumes 64 T0 slice entries.

#### Calculation: one `/16`

1. **Input:** One `/16` contains 65,536 addresses.
2. **Formula:** `65,536 ÷ 16 = 4,096`.
3. **Result:** One `/16` becomes 4,096 `/28` entries.
4. **Practical interpretation:** A single large segment can require multiple T0 interfaces and a sufficiently large private cloud.

### 8.4 Capacity by cluster size

* A three-node Generation 2 private cloud supports 4,096 `/28` entries, equivalent to 256 fully consumed `/24` segments.
* A four-node private cloud supports 6,144 `/28` entries, equivalent to 384 fully consumed `/24` segments.
* A four-node or larger private cloud can accommodate one `/16` segment under the documented slice model.
* Cluster scale-out expands the internal slice capacity but does not raise the 1,000-prefix VNet ceiling.

### 8.5 Allowed and disallowed examples

* **Allowed:** 1,000 `/28` segments, subject to the total VNet count and other required entries.
* **Not allowed:** 1,000 `/24` segments because they would require 16,000 T0 slice entries.
* **Potentially allowed:** One `/16` on a four-node or larger private cloud.
* **Not allowed:** 256 `/23` segments because they require 8,192 slice entries.

### 8.6 Route-budget control

Maintain two independent figures:

1. **VNet entry budget**

   * NSX segment entries.
   * NSX service `/32` entries.
   * HCX MON `/32` entries.
   * Infrastructure address-space entries.

2. **T0 slice budget**

   * Sum of each NSX segment after conversion into `/28` units.

A change can be acceptable under one limit and invalid under the other.

---

## 9. HCX Migration and Route Consumption

VMware HCX is commonly used to migrate workloads while preserving their existing network identity. Mobility Optimized Networking (MON) improves the routing path for migrated virtual machines, but each active host route consumes Generation 2 route capacity.

### 9.1 How MON consumes routes

* A migrated virtual machine can retain its original IP address.
* MON provides a local cloud gateway for optimized routing.
* HCX advertises a `/32` route identifying the migrated virtual machine’s current location.
* Each active `/32` consumes one entry from the 1,000-prefix VNet limit.
* Up to 999 MON host routes are theoretically available only when the private-cloud address space is the sole other entry.

### 9.2 Transcript-derived 800-VM calculation

> **Transcript-derived calculation:** An 800-VM migration wave uses one MON `/32` for each migrated VM.

1. **Migrated VMs:** 800.
2. **Routes per VM:** 1.
3. **Formula:** `800 × 1 = 800 routes`.
4. **Overall limit:** 1,000.
5. **Percentage consumed:** `800 ÷ 1,000 × 100 = 80%`.
6. **Nominal remaining entries:** `1,000 - 800 = 200`.
7. **Practical interpretation:** The environment has consumed 80 percent of its route capacity before counting most workload segments, services, or future migration activity.

The arithmetic is valid, although the actual remaining capacity is lower when required infrastructure and workload entries are included.

### 9.3 Route summarization workflow

1. Inventory every VM in the source subnet.
2. Confirm that the complete subnet can be migrated within the planned wave.
3. Start migration and allow MON `/32` routes to appear.
4. Monitor the total VNet prefix count.
5. Complete the migration of all workloads that belong to the subnet.
6. Move the subnet gateway to the cloud side.
7. Advertise the summarized NSX segment route.
8. Disable MON for the finalized extended segment.
9. Confirm that specific `/32` host routes are removed.
10. Allow for route convergence, which Microsoft documents as potentially taking up to 30 seconds during failover.
11. Recalculate route headroom before beginning the next wave.

### 9.4 Permanent MON state

Leaving extended networks in MON indefinitely reduces the number of workloads and services that the private cloud can support. Microsoft explicitly recommends summarizing routes and disabling MON for finalized network segments. [Microsoft Learn — Route architecture for Generation 2](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

### 9.5 HCX compatibility constraint

* MON is supported between Generation 1 and Generation 2 private clouds.
* MON is not supported between two Generation 2 private clouds when the design requires overlapping address spaces, because peered VNets cannot overlap.

### 9.6 Base Sync and Online Sync performance

Microsoft warns that HCX Replication Assisted vMotion and bulk migrations to Generation 2 can experience slower performance during Base Sync and Online Sync. [Microsoft Learn — Generation 2 design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration)

* Pilot migrations should measure sustained replication throughput.
* Migration windows should not be calculated from the host’s 100-Gbps physical interface rating.
* Source storage, destination storage, HCX appliances, latency, packet loss, MTU, encryption, and other competing traffic affect throughput.
* Large databases should be tested before a weekend migration commitment is made.

> **Architectural interpretation:** The transcript attributes the slowdown to underlay/overlay translation, encapsulation, gateway processing, and packet fragmentation. Microsoft documents the performance warning but does not prescribe that complete causal chain as the universal explanation for every deployment.

### 9.7 Migration validation checklist

* Measure Base Sync and Online Sync independently.
* Validate MTU along the entire HCX path.
* Monitor packet loss and retransmission.
* Confirm HCX appliance CPU and memory.
* Confirm source and destination datastore throughput.
* Track current `/32` route usage.
* Reserve route headroom for rollback.
* Complete gateway cutover and route cleanup before declaring a wave finished.

---

## 10. Availability and Disaster Recovery

Generation 1 stretched clusters and Generation 2 zonal deployments solve different availability problems. Rack-level fault domains, availability-zone resilience, and cross-region disaster recovery must not be treated as equivalent.

### 10.1 Availability zones

An Azure availability zone is a physically separate datacenter location within an Azure region, with independent power, cooling, and network infrastructure. [Microsoft Learn — Availability zones overview](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview)

### 10.2 Generation 1 stretched clusters

A supported Generation 1 vSAN stretched cluster distributes hosts across two availability zones and places a witness in a third zone. [Microsoft Learn — Stretched-cluster design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

* **Minimum topology:** Six hosts, with three data hosts in each availability zone.
* **Single logical private cloud:** Both sites operate under one vCenter Server and NSX management plane.
* **Storage policy:** Workload data uses dual-site mirroring.
* **Synchronous writes:** A write must be protected according to the cross-site storage policy before it is acknowledged.
* **Witness:** The witness provides quorum information and prevents split-brain behavior.
* **Host failure:** VMware HA restarts affected virtual machines on surviving hosts.
* **Zone failure:** Workloads can restart in the surviving zone when quorum, storage policy, capacity, and connectivity conditions are satisfied.
* **Recovery behavior:** Virtual machines restart; this is not uninterrupted application execution.
* **SLA:** A correctly configured stretched cluster is designed for a 99.99-percent infrastructure availability commitment, subject to the required storage policy and additional SLA conditions.

Current reliability guidance identifies AV36, AV36P, and AV52 as supported stretched-cluster host profiles. [Microsoft Learn — Reliability in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)

### Documentation correction: active-active wording

The transcript calls the stretched cluster “active-active.” Both sites can host running workloads, but an individual virtual machine is not simultaneously executing in both zones. Following a host or zone failure, VMware HA restarts affected VMs on surviving hosts.

### 10.3 Witness-zone failure

If the zone containing the Generation 1 witness becomes unavailable:

* Existing running workloads can continue when sufficient data replicas remain.
* The cluster loses witness-based quorum awareness.
* Some operations, including certain power-on, repair, and rebalancing actions, can be blocked.
* The witness is not automatically recreated in another availability zone. [Microsoft Learn — Azure VMware Solution FAQ](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)

### 10.4 Generation 2 zonal deployment

* Generation 2 allows the customer to select the private cloud’s availability zone, subject to capacity.
* A Generation 2 private cloud remains confined to one zone.
* Generation 2 does not support a single vSAN stretched cluster spanning two zones.
* A complete loss of the selected zone can make the private cloud unavailable until the zone recovers or a separate recovery environment is activated.
* Separate Generation 2 private clouds can be deployed in different zones, but workload replication and failover orchestration are customer responsibilities. [Microsoft Learn — Azure VMware Solution FAQ](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)

### 10.5 Disaster-recovery alternatives

Generation 2 resilience beyond one zone requires a separate disaster-recovery design.

Potential options documented in the AVS ecosystem include:

* Azure Site Recovery.

* VMware Live Site Recovery.

* JetStream.

* Zerto.

* Other partner products that support the required replication model.

* **Replication mode:** Cross-private-cloud or cross-region replication is generally asynchronous.

* **RPO:** Potential data loss depends on the configured replication frequency, current replication lag, application consistency, and the selected product.

* **RTO:** Recovery includes failover orchestration, VM startup, network activation, DNS or traffic changes, and application validation.

* **Testing:** Replication health alone does not prove recoverability; scheduled failover tests are required.

> **Not directly supported by the reviewed Microsoft documentation:** The transcript’s specific claim that Zerto support required a signed-VIB remediation for AV64 Secure Boot in early 2025 was not validated in the reviewed Microsoft Learn material. Treat that detail as a product-version-specific vendor validation item.

### 10.6 Resilience decision

* Choose a supported Generation 1 stretched cluster when synchronous multi-zone protection is mandatory.
* Choose Generation 2 when zonal placement plus an external DR design meets the workload’s RPO and RTO.
* Do not substitute rack-level fault domains for availability-zone resilience.
* Do not describe asynchronous replication as zero-data-loss availability.

---

## 11. AV64 vSAN Fault Domains

AV64 clusters use explicit vSAN fault domains. The Azure control plane balances hosts across those domains as the cluster grows.

### 11.1 Fault-domain design

* Microsoft configures seven vSAN fault domains in most AV64-supported regions.
* Some regions retain five fault domains from the earlier rollout.
* Hosts are distributed as evenly as possible across the available fault domains.
* A fault domain represents an independent physical-failure boundary such as a rack and its associated top-of-rack infrastructure.
* The design supports storage-policy placement across distinct physical boundaries.

Current fault-domain counts are listed in [Azure VMware Solution private cloud and cluster concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds).

### 11.2 Three-host and four-host behavior

* Three hosts satisfy the platform minimum and are placed in different fault domains.
* Following a fault-domain failure, existing protected data can remain accessible, but object creation and maintenance can be constrained.
* Microsoft recommends four hosts to preserve greater operational flexibility during maintenance or failure. [Microsoft Learn — Introduction to Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)

### 11.3 Storage-policy dependencies

| Storage policy        | Failures to tolerate | Minimum AV64 hosts |
| --------------------- | -------------------: | -----------------: |
| RAID-1 mirroring      |                    1 |                  3 |
| RAID-5 erasure coding |                    1 |                  4 |
| RAID-1 mirroring      |                    2 |                  5 |
| RAID-6 erasure coding |                    2 |                  6 |
| RAID-1 mirroring      |                    3 |                  7 |

The available policy also depends on the number of fault domains supported in the region.

### 11.4 Scale-in balance rule

Before removing an AV64 host, the control plane calculates the resulting fault-domain distribution.

* A removal is rejected when it would make the difference between the most populated and least populated fault domains greater than one.
* A removal that would leave fewer than three active fault domains is also invalid.
* The API returns HTTP `409 Conflict` when the requested removal conflicts with the current topology.
* The administrator must inspect the vSAN fault-domain mapping and choose a valid host.

### 11.5 Transcript-derived imbalance calculation

1. **Initial state:** Fault domain 1 contains two hosts; fault domain 2 contains one host.
2. **Proposed action:** Remove the only host in fault domain 2.
3. **Resulting counts:** Fault domain 1 contains two hosts; fault domain 2 contains zero.
4. **Formula:** `2 - 0 = 2`.
5. **Permitted difference:** 1.
6. **Result:** The removal would exceed the permitted imbalance and is rejected.

> **Transcript-derived analogy:** Scaling in an AV64 cluster resembles removing a block from a Jenga tower. The host that appears least busy might not be the host that can safely be removed.

### 11.6 Host-removal procedure

1. Open the vSphere Client.
2. Navigate to the vSAN fault-domain configuration.
3. Map each host to its fault domain.
4. Count the hosts in every fault domain.
5. Model the distribution after each candidate removal.
6. Select a host from a more populated domain.
7. Confirm the maximum-to-minimum count difference remains no greater than one.
8. Confirm that at least three active fault domains remain.
9. Verify datastore capacity and storage-policy compliance.
10. Initiate the supported Azure portal or API removal workflow.
11. When HTTP `409` is returned, treat it as topology protection and recalculate the candidate host.

---

## 12. Mixed-Generation Private Clouds and EVC

An existing Generation 1 private cloud can be expanded with a separate AV64 cluster. The resulting environment remains under the same vCenter Server but contains different processor generations and EVC behavior.

### 12.1 Expansion model

* The original cluster remains on AV36, AV36P, AV48, or AV52.
* A separate AV64 cluster is added.
* The AV64 cluster requires at least three hosts.
* AV64 quota is required.
* Additional management address space is required for the AV64 expansion cluster.
* AV64 cannot be added to a Generation 1 stretched-cluster private cloud.
* The private cloud becomes a heterogeneous processor environment.

### 12.2 Enhanced vMotion Compatibility

Enhanced vMotion Compatibility (EVC) masks processor features so virtual machines see a common CPU baseline.

* AV64 uses an Ice Lake EVC baseline.
* Older AV36, AV36P, and AV52 clusters do not use that same explicit baseline.
* A virtual machine can use newer CPU features after being created or power-cycled on AV64.
* A destination host must support all CPU features exposed to a running VM.
* vCenter blocks an unsafe live migration rather than allowing the virtual machine to execute unsupported instructions.

### 12.3 Directional vMotion behavior

#### Base cluster to AV64

* A running VM with an older CPU baseline can live-migrate to AV64.
* The newer processor supports the older exposed instruction set.
* The move is from a lower baseline to a higher-capability processor.

#### AV64 back to a base cluster

Two conditions apply:

1. **The VM originally came from the base cluster and has not been power-cycled on AV64.**

   * Live vMotion can succeed because the VM retains its older CPU feature set.

2. **The VM was created on AV64 or was power-cycled there.**

   * Live vMotion to the older cluster fails with an EVC compatibility error.

Microsoft documents this behavior in [Introduction to Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction).

### 12.4 Mitigation options

* Configure VM-level EVC to match the lower required baseline.
* Use templates that apply the approved EVC setting.
* Track VMs that have been power-cycled on AV64.
* Use a cold migration when the VM cannot live-migrate backward.
* Separate workload placement according to long-term CPU requirements.
* Do not assume all clusters under one vCenter Server are interchangeable.

> **Transcript-derived analogy:** A VM moved from an older cluster to AV64 is compared to a passenger upgraded from economy to first class. After receiving first-class features, the passenger cannot carry those features back into the lower-tier cabin. The technical mechanism is EVC compatibility, not the analogy itself.

### Documentation correction: crash scenario

The transcript describes a hypothetical VM crash if a workload were placed on a processor that lacked instructions already exposed to the guest. In supported operation, vCenter performs compatibility validation and blocks the unsafe live migration. The expected administrative symptom is an EVC compatibility error, not an intentionally permitted crash.

---

## 13. Architecture Selection Framework

The generation decision should be made from workload requirements rather than feature novelty.

### 13.1 Conditions favoring Generation 1

* Several lower-cost host profiles can satisfy the workload.
* AV64 performance is unnecessary.
* The organization already operates ExpressRoute and BGP effectively.
* The route topology is too large or dynamic for Generation 2 limits.
* The migration plan requires extensive or long-lived host-route advertisements.
* Synchronous multi-zone stretched-cluster protection is mandatory.
* The organization cannot accept single-zone private-cloud operation.
* Existing Generation 1 investments should remain in service.

### 13.2 Conditions favoring Generation 2

* Direct VNet integration materially simplifies the architecture.
* ExpressRoute gateways used only for AVS-to-Azure connectivity can be removed.
* Workloads can use AV64 compute and ESA storage.
* The route inventory remains below both Generation 2 limits.
* HCX waves can be finalized and summarized promptly.
* The organization can tolerate zonal operation with a separate DR strategy.
* The target region and zone have AV64 capacity.
* The organization has mature IP-address, Azure Policy, route-budget, migration, and fault-domain governance.

### 13.3 Conditions favoring a mixed-generation environment

* Existing Generation 1 workloads should remain in place.
* Selected workloads benefit from AV64.
* Stretched-cluster workloads must remain on Generation 1.
* The organization can operate separate placement tiers under one vCenter Server.
* VM-level EVC can be governed.
* Cold-migration downtime is acceptable for workloads using the newer CPU baseline.

### 13.4 Decision matrix

| Requirement                         |                    Generation 1 |                       Generation 2 |                   Mixed environment |
| ----------------------------------- | ------------------------------: | ---------------------------------: | ----------------------------------: |
| Native VNet attachment              |                              No |                                Yes | Depends on private-cloud generation |
| Multiple host profiles              |                             Yes |                           No; AV64 |                                 Yes |
| AV64 and ESA performance            |      AV64 expansion or AV48 ESA |                                Yes |           Yes for selected clusters |
| Stretched cluster                   |        Supported configurations |                                 No | Retain protected workloads on Gen 1 |
| Direct zone selection               | No for a standard private cloud |                                Yes |                              Varies |
| Large route topology                |    Less exposed to Gen 2 limits |           Requires strict modeling |                 Partition carefully |
| Minimal Azure gateway plumbing      |                              No |                                Yes |                               Mixed |
| Simple bidirectional live migration |      Within compatible clusters |         Within compatible clusters |             Requires EVC governance |
| Lowest governance burden            | ExpressRoute expertise required | Route and VNet governance required |             Highest combined burden |

### 13.5 Decision sequence

1. Define workload RPO and RTO.
2. Identify workloads requiring synchronous multi-zone protection.
3. Inventory current and future network prefixes.
4. Count expected NSX segment entries.
5. Convert every segment into `/28` T0 units.
6. Model peak HCX MON `/32` usage.
7. Benchmark CPU, memory, storage, and network demand.
8. Compare workload demand against available host profiles.
9. Confirm region, availability-zone capacity, and quota.
10. Validate tenant, subscription, resource group, VNet, policy, and DNS placement.
11. Evaluate existing ExpressRoute investments.
12. Evaluate EVC and mixed-cluster mobility requirements.
13. Select Generation 1, Generation 2, or a mixed design only after availability, routing, and migration feasibility have been proven.

---

## 14. Operational Controls

Generation 2 replaces some customer-managed network plumbing with platform-managed integration. The apparent simplicity makes proactive controls more important, not less important.

### 14.1 Route controls

* Maintain an authoritative inventory of VNet, NSX, service, on-premises, and migration prefixes.
* Track VNet entries and T0 `/28` entries separately.
* Require route-impact analysis for every new NSX segment.
* Reject unnecessarily large flat segments.
* Establish warning thresholds below the absolute limits.
* Reserve capacity for rollback, incidents, and future growth.
* Alert when MON `/32` routes remain after a migration wave.

### 14.2 Migration controls

* Pilot every migration method.
* Measure real sustained throughput.
* Validate HCX MTU and service-mesh health.
* Group migration waves by complete subnet where practical.
* Include route cleanup in the migration definition of done.
* Retain rollback-route capacity.
* Allow for documented route convergence.
* Avoid leaving extended networks in a permanent transitional state.

### 14.3 Availability controls

* Assign every workload a zone-failure RPO and RTO.
* Keep synchronous multi-zone workloads on a supported stretched-cluster design.
* Test Generation 2 DR failover.
* Validate application startup order and dependencies.
* Distinguish host, rack, zone, and region failure scenarios.
* Verify storage-policy compliance following scale operations.

### 14.4 AV64 scale controls

* Inspect fault-domain placement before every removal.
* Automate the post-removal balance calculation.
* Maintain sufficient free storage for evacuation.
* Treat HTTP `409` as a topology-protection event.
* Review storage policy requirements whenever cluster size changes.

### 14.5 EVC controls

* Define approved VM-level EVC baselines.
* Apply them through templates and automation.
* Inventory VMs created or power-cycled on AV64.
* Identify workloads that can move backward live.
* Document workloads that require cold migration.
* Test emergency cluster-evacuation procedures.

### 14.6 Governance controls

* Approve tenant, subscription, resource group, VNet, region, zone, and DNS before deployment.
* Validate Azure Policy assignments.
* Document resource-move limitations.
* Confirm quota before setting migration dates.
* Train Azure, VMware, network, security, and DR teams on the combined architecture.
* Revalidate Microsoft documentation before production deployment because regional availability and product constraints can change.

---

## 15. Implementation Checklist

1. Inventory all VMware workloads and dependencies.
2. Classify applications by availability, RPO, RTO, and compliance requirements.
3. Measure workload CPU, memory, storage, and network utilization.
4. Select the candidate generation and host profile.
5. Confirm regional and zonal host availability.
6. Obtain host quota.
7. Reserve a nonoverlapping `/22` management block.
8. Reserve the additional HCX subnets required by the current Generation 2 design.
9. Inventory all existing routed address spaces.
10. Model every planned NSX segment against the 1,000-entry limit.
11. Convert each NSX segment into `/28` T0 entries.
12. Model maximum concurrent MON `/32` routes.
13. Reserve route capacity for rollback and future services.
14. Confirm the permanent tenant, subscription, resource group, and VNet.
15. Review cross-resource-group and cross-subscription references.
16. Review Azure Policy assignments affecting networking resources.
17. Configure the approved DNS model.
18. Establish management access through a jump host or supported private path.
19. Configure VNet peering, on-premises routing, and required firewalls.
20. Deploy or activate HCX.
21. Validate the HCX service mesh and MTU.
22. Run a pilot migration.
23. Measure Base Sync and Online Sync throughput.
24. Verify route programming during the pilot.
25. Execute migration waves by subnet.
26. Cut over gateways and remove obsolete MON routes.
27. Validate application, DNS, identity, security, and monitoring.
28. Test host-failure behavior.
29. Test the applicable zone or DR recovery procedure.
30. Document fault-domain scale-in and EVC procedures.
31. Establish route, quota, capacity, and platform-health monitoring.
32. Conduct an architecture review before production cutover.

---

## 16. Architecture Summary

### 16.1 Generation 1 flow

1. VMware workloads run on supported Generation 1 hosts.
2. NSX provides workload networking inside the private cloud.
3. AVS remains outside the customer VNet routing domain.
4. Microsoft-managed ExpressRoute connects AVS to Azure networking.
5. An ExpressRoute gateway introduces traffic into Azure VNets.
6. ExpressRoute Global Reach connects AVS to an on-premises ExpressRoute circuit when required.
7. Supported stretched clusters can synchronously protect data across two availability zones.
8. A witness in a third zone provides quorum.

### 16.2 Generation 2 flow

1. The customer selects the permanent tenant, subscription, resource group, region, zone, and VNet.
2. The customer reserves the core AVS and HCX address spaces.
3. Azure creates AVS infrastructure resources in the host VNet.
4. AV64 hosts provide compute and ESA storage.
5. NSX segments are advertised into the VNet.
6. Each segment consumes one overall VNet entry.
7. Azure divides each segment into `/28` units for T0 uplink programming.
8. VNet peering provides direct connectivity to supported Azure networks.
9. HCX MON creates temporary `/32` host routes during migration.
10. Completed subnets are summarized and MON routes are removed.
11. Explicit vSAN fault domains provide rack-level resilience.
12. The private cloud remains in one availability zone.
13. Zone or region recovery requires a separate customer-managed replication and orchestration design.

---

## 17. Documentation and Interpretation Notes

* **Direct Generation 2 creation:** Current documentation supports directly creating a three-host AV64 Generation 2 private cloud. A legacy seed cluster is no longer required.

* **Generation 1 AV64 expansion:** AV64 remains available as an expansion cluster for compatible Generation 1 private clouds, subject to documented prerequisites.

* **Host networking:** Current Microsoft documentation lists 100-Gbps interface throughput across the current host portfolio, not only AV64 Generation 2.

* **Generation 2 NSGs:** Azure-centric NSG integration is supported, but service-created networking resources, resource-group requirements, Azure Policy interactions, NSX controls, and customer-managed firewalls must be treated as distinct layers.

* **Address requirements:** The core `/22` remains required. Current Generation 2 HCX guidance additionally calls for two `/24` subnets.

* **Route limits:** The 1,000-entry VNet limit, 1,024-per-T0-NIC segment limit, `/28` expansion behavior, and three-node/four-node capacity figures are directly documented.

* **HCX performance:** Microsoft documents potentially slower RAV and bulk-migration Base Sync and Online Sync performance on Generation 2. The transcript’s detailed packet-processing explanation should be treated as an architectural interpretation rather than a universal documented cause.

* **Stretched clusters:** Generation 2 supports availability-zone selection but not a single private cloud stretched across zones. Separate zonal private clouds require customer-managed replication and failover.

* **Mixed-generation EVC:** Microsoft documents the directional vMotion behavior and recommends VM-level EVC or cold migration when moving a VM back to older processor generations.

* **Zerto implementation detail:** The transcript’s specific Secure Boot and signed-VIB history was not directly validated in the reviewed Microsoft Learn documentation and requires confirmation from current vendor documentation.

---

## Image Sources

No local documentation images are referenced in this inline edition.

| Local file | Description                   | Microsoft documentation page | Original image URL |
| ---------- | ----------------------------- | ---------------------------- | ------------------ |
| None       | No image assets were packaged | Not applicable               | Not applicable     |
