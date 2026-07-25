# Enterprise Azure VMware Solution over Site-to-Site VPN

## Purpose and Scenario

This guide describes a transcript-derived architecture for connecting an on-premises VMware environment to Azure VMware Solution (AVS) when a dedicated on-premises ExpressRoute circuit is unavailable. Microsoft documents this specific topology as a [site-to-site IPsec/IKE VPN terminating in an Azure Virtual WAN hub that also contains the AVS ExpressRoute gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway). The design treats the site-to-site VPN as a fixed architectural constraint and builds the surrounding Azure environment to minimize the resulting performance, routing, security, management, and resiliency risks.

> **Transcript-derived scenario:** An infrastructure architect must migrate a 5 TB, mission-critical database to AVS over a weekend. A dedicated ExpressRoute circuit is unavailable because of cost, location, or provisioning-time constraints, leaving the public internet and an IPsec site-to-site VPN as the only practical transport into Azure.

The intended outcome is not a temporary tunnel with minimal controls. The transcript presents an enterprise architecture designed to remain:

- **Operationally usable:** Workloads can migrate and operate across the hybrid path.
- **Scalable:** Additional Azure networks, branches, and services can be incorporated without creating an unmanageable peering mesh.
- **Secure:** Hybrid and inter-network traffic is segmented and inspected.
- **Manageable:** Administrators can reach AVS management services without exposing management hosts directly to the internet.
- **Resilient:** Identity and DNS services remain available when the VPN is degraded or unavailable.

The architecture is developed in the following order:

1. Evaluate the physical and workload constraints of VPN-based migration.
2. Select migration methods based on workload behavior and acceptable downtime.
3. Build a [Standard Azure Virtual WAN and regional virtual hub](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway) for the topology documented in this guide.
4. Size and configure the site-to-site VPN path using the [Virtual WAN VPN gateway scale-unit model](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq#what-are-virtual-wan-gateway-scale-units).
5. Establish dynamic routing with [Border Gateway Protocol (BGP)](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-bgp-overview).
6. Connect the virtual hub to AVS through the [AVS-managed ExpressRoute circuit and authorization-key workflow](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#connect-your-vpn-site-to-the-hub).
7. Add centralized traffic inspection and segmentation using the routing model appropriate to either a [secured Virtual WAN hub](https://learn.microsoft.com/en-us/azure/firewall-manager/secured-virtual-hub) or a traditional customer-managed hub VNet.
8. Publish selected AVS applications through a controlled ingress path such as [Azure Application Gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway) or [public IP addresses on the NSX Edge](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-public-ip-nsx-edge).
9. Provide secure administrative access through [Azure Bastion](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) and, when needed, a private jump box.
10. Distribute identity and DNS services across on-premises, native Azure, and AVS, using [Azure Private DNS](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone) and [Azure DNS Private Resolver](https://learn.microsoft.com/en-us/azure/dns/private-resolver-architecture) where appropriate.

---

## 1. Understanding the Transport Constraint

A site-to-site VPN can provide supported connectivity into an AVS architecture, but it does not provide the deterministic behavior of a dedicated private circuit. The design must therefore begin with realistic assumptions about throughput, latency, jitter, packet loss, and outage risk.

> **Transcript-derived analogy:** ExpressRoute is compared to a multi-lane private interstate used by a fleet of moving trucks. The VPN is a winding two-lane state highway. The same house can still be moved, but each trip, load, dependency, and delay must be planned much more carefully.

### 1.1 ExpressRoute and Site-to-Site VPN Compared

| Characteristic | ExpressRoute | Site-to-Site VPN |
|---|---|---|
| Transport | [Private connectivity through a connectivity provider](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction) into the Microsoft network | [Encrypted IPsec/IKE tunnel across the public internet](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways) |
| Internet exposure | Traffic does not traverse the public internet | Encrypted packets traverse one or more public internet paths |
| Bandwidth behavior | Purchased private-circuit capacity is intended to be predictable | Effective throughput is constrained by both the local internet circuit and the Azure VPN gateway |
| Latency | Generally stable and predictable | Can fluctuate because of ISP routing, congestion, and internet-path changes |
| Jitter and packet loss | Lower and more controlled | More likely to vary and affect migration or application performance |
| Provisioning considerations | Requires circuit availability, provider coordination, budget, and lead time | Can often be deployed more quickly when internet connectivity already exists |
| Migration impact | Better suited to high-volume or latency-sensitive migration | Requires careful migration-window and workload planning |

- **ExpressRoute behavior:** The transcript describes ExpressRoute as a provider-mediated private connection between the on-premises edge and the Microsoft enterprise edge. The design benefit is traffic isolation, purchased capacity, and more predictable latency.
- **VPN behavior:** A site-to-site VPN encrypts private traffic in IPsec and sends it across public ISP paths. The packet may cross multiple providers before reaching Azure, introducing variability outside the customer’s direct control.
- **Practical consequence:** The VPN is not merely a different connection type. It changes the assumptions used for migration duration, live-migration success, cluster handling, management access, and failure planning.

### 1.2 VMware HCX as the Migration Transport

VMware HCX is the application mobility platform used in the scenario to move workloads from the on-premises vSphere environment into AVS. Microsoft documents five HCX migration profiles—Cold Migration, HCX vMotion, Bulk Migration, Replication Assisted vMotion, and OS Assisted Migration—with different downtime and scale characteristics. [Microsoft Learn — VMware HCX migration considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)

- **Service mesh:** HCX forms a service mesh between the on-premises VMware environment and the AVS private cloud. [Microsoft Learn — VMware HCX architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate#vmware-hcx-architecture)
- **Mobility functions:** HCX coordinates workload migration and supports Layer 2 network extension between sites. [Microsoft Learn — VMware HCX architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate#vmware-hcx-architecture)
- **IP preservation:** A stretched Layer 2 network can allow a migrated VM to retain its IP address, avoiding immediate readdressing. This is an architectural consequence of Layer 2 extension rather than a guarantee that every workload can be moved without application or network changes.
- **Transport dependency:** HCX cannot compensate for an inadequate WAN path. Its success remains limited by available bandwidth, latency, jitter, packet loss, and gateway capacity.
- **Baseline requirement:** The VPN path must meet the network requirements of the HCX migration method being used.

> **Documentation correction:** Microsoft documents VPN or ExpressRoute as valid connectivity for the SQL migration scenario. It specifically states that HCX over VPN, because of limited bandwidth, is typically suited to workloads that can sustain longer downtime, such as nonproduction environments; ExpressRoute is recommended for production environments, large databases, and migrations that must minimize downtime. [Microsoft Learn — Migrate a SQL Server FCI to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster#prerequisites) This is workload-specific migration guidance, not a statement that every AVS workload is unsuitable for VPN connectivity.

### 1.3 Design Implication

The constrained WAN path is the architecture’s limiting resource. Every Azure-side component must therefore avoid adding unnecessary bottlenecks, routing complexity, or failure points. Capacity planning must use realistic sustained throughput rather than nominal link speed.

---

## 2. Selecting the Migration Method

The appropriate HCX migration method depends on workload activity, clustering, data size, WAN quality, and the amount of downtime the business can accept. A method that works for a lightly used standalone VM may be unsafe or infeasible for a clustered SQL Server workload.

### 2.1 HCX vMotion

HCX vMotion is presented as the preferred option when continuous workload availability is required and the network can support live migration. Microsoft categorizes HCX vMotion as a serial, small-scale method with no planned migration downtime. [Microsoft Learn — HCX migration options](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate#vmware-hcx-migration-options)

- **Powered-on migration:** The source VM remains online and continues serving users while memory, state, and storage are synchronized to AVS.
- **Iterative memory copy:** HCX first copies the VM’s memory state, then repeatedly copies pages changed while the VM remains active.
- **Dirty pages:** Memory pages modified after an earlier copy are called dirty pages.
- **Convergence race:** The migration process must transmit changed pages faster than the workload generates new dirty pages.
- **Final stun:** When the remaining delta becomes sufficiently small, HCX briefly pauses the VM, transfers the final state, and resumes the VM in AVS.
- **Ideal user impact:** The final interruption may be only a short blip if the migration converges successfully.

#### Failure Condition

A live migration may fail when the source VM’s rate of change exceeds the tunnel’s effective transfer rate.

- Heavy application activity can generate dirty pages faster than they can be sent.
- High latency increases the time needed for iterative synchronization.
- Congestion and packet loss reduce effective throughput and can prevent convergence.
- HCX may eventually abandon the migration rather than loop indefinitely. Broadcom documents a vMotion/RAV failure condition in which changing memory exceeds available network bandwidth and recommends retrying when the VM is less busy or more bandwidth is available. [Broadcom Knowledge Base — HCX vMotion failure for busy VMs](https://knowledge.broadcom.com/external/article/368043/hcx-ravvmotion-migration-failure-for-b.html)

#### Operational Recommendations

- Use live migration for workloads whose memory and storage change rate is compatible with the available WAN capacity.
- Reduce workload activity during the migration window.
- Avoid high-volume transactions, reporting, batch processing, or other write-intensive activity while vMotion is running.
- Monitor the tunnel for congestion and packet loss before initiating the migration.

> **Example:** A lightly utilized standalone SQL Server VM may remain available during HCX vMotion if the VPN is stable. Microsoft’s standalone SQL migration guidance says the database remains available during vMotion but recommends avoiding critical data commits and performing the migration during off-peak hours in an approved change window. [Microsoft Learn — Migrate a standalone SQL Server instance](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-standalone-cluster)

### 2.2 Cold Migration

HCX cold migration is presented as the required approach for workloads that cannot be safely live-migrated, including the SQL Server failover cluster instance described in the transcript. Microsoft categorizes Cold Migration as a small-scale method with long downtime. [Microsoft Learn — HCX migration options](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate#vmware-hcx-migration-options)

- **Power state:** All participating VMs are gracefully shut down before transfer.
- **Data transfer:** HCX copies the virtual disks across the VPN while the VMs are offline.
- **Destination startup:** The VMs are powered on in AVS after the copy completes.
- **Downtime model:** The outage includes shutdown, the complete data-transfer period, destination startup, and application validation.
- **Primary sizing variables:** Database size and sustained tunnel throughput dominate the migration duration.

### 2.3 Clustered SQL Server Consideration

The transcript distinguishes a standalone SQL Server VM from a SQL Server failover cluster instance (FCI).

- **FCI behavior:** An FCI uses multiple nodes and shared storage to provide high availability.
- **Transcript position:** The clustered instance should not be vMotioned across the stretched VPN design because of the risk of split-brain behavior or data corruption.
- **Required sequence:** All cluster nodes should be gracefully stopped, migrated while powered off, and then brought online and validated in AVS.
- **Business impact:** Downtime is no longer a brief vMotion stun. It is bounded by the full data-copy duration.

> **Documentation correction:** Microsoft’s documented FCI limitation is specific: HCX does not support migrating VMs whose SCSI controllers are in physical sharing mode. The documented workaround performs a full cluster shutdown, temporarily removes or reconfigures shared-disk attachments, and uses HCX Cold Migration for each node. [Microsoft Learn — Migrate a SQL Server Always On FCI](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster) The transcript’s broader split-brain and corruption rationale is not the stated Microsoft support reason and should not replace workload-specific validation.

### 2.4 Migration Method Comparison

| Consideration | HCX vMotion | HCX Cold Migration |
|---|---|---|
| Source VM state | Powered on | Powered off |
| Application availability | Intended to remain available | Unavailable during transfer |
| Network sensitivity | Very sensitive to latency, packet loss, and dirty-page rate | Primarily sensitive to total throughput and tunnel stability |
| Final interruption | Short stun after convergence | Full outage for shutdown, transfer, startup, and validation |
| Suitable transcript example | Lightly utilized standalone SQL Server | SQL Server failover cluster instance |
| Primary failure risk | Migration cannot converge | Migration exceeds the maintenance window or is interrupted |
| Operational control | Reduce source workload activity | Accurately size the outage and protect the transfer path |

---

## 3. Calculating the Migration Window

A nominal tunnel speed does not directly equal usable migration throughput. The transcript’s 5 TB example illustrates why a weekend window can easily be consumed by a cold migration.

> **Transcript-derived calculation:** Transfer a 5 TB database across a 500 Mbps VPN tunnel. The arithmetic below is independently verified; it is not a Microsoft-published migration estimate. The 500 Mbps input corresponds to one Virtual WAN VPN gateway scale unit, but actual throughput is affected by gateway, tunnel, cryptographic, packet-size, and workload constraints. [Microsoft Learn — Virtual WAN gateway scale units](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq#what-are-virtual-wan-gateway-scale-units)

### 3.1 Inputs

- Data size: **5 TB**
- Tunnel rate: **500 Mbps**
- Assumed overhead for the initial calculation: **0%**
- Competing traffic: **None**
- Tunnel interruption: **None**

### 3.2 Formula

Using decimal units for a simple planning estimate:

1. Convert terabytes to bits:

   `5 TB × 8 = 40 terabits`

2. Convert to megabits:

   `40 terabits = 40,000,000 megabits`

3. Divide by the transfer rate:

   `40,000,000 Mb ÷ 500 Mb/s = 80,000 seconds`

4. Convert seconds to hours:

   `80,000 ÷ 3,600 = 22.22 hours`

Using binary-size assumptions changes the data volume, and protocol overhead, encryption overhead, retransmissions, storage performance, and real-world throughput can push the result beyond 24 hours. The zero-overhead decimal result itself is **22.22 hours**, so the transcript’s “more than 24 hours” statement is not true at the stated idealized inputs.

### 3.3 Result

- **Theoretical decimal estimate:** Approximately **22.2 hours**
- **Practical planning result:** More than **24 hours** is plausible only after applying binary sizing and/or real-world efficiency losses; it is not the theoretical result at the stated decimal inputs.

### 3.4 Practical Interpretation

A 5 TB cold migration can consume most or all of a weekend change window even before accounting for:

- Graceful cluster shutdown
- HCX initialization
- Encryption and protocol overhead
- Packet retransmission
- Storage read and write performance
- Validation and application startup
- User acceptance testing
- Rollback contingency

### 3.5 Factors That Can Extend the Duration

- The tunnel drops and remains unavailable for an hour.
- Internet congestion reduces throughput from 500 Mbps to 100 Mbps.
- Other branch, user, backup, or application traffic shares the gateway.
- Source storage cannot read at the tunnel’s potential rate.
- Destination storage or HCX appliances cannot sustain the write rate.
- Packet loss and latency cause retransmission or reduced protocol efficiency.

At 100 Mbps, the same simple decimal calculation becomes:

`40,000,000 Mb ÷ 100 Mb/s = 400,000 seconds = 111.1 hours`

That is more than four and a half days before adding operational overhead.

### 3.6 Operational Implication

Migration planning must use measured sustained throughput and include a safety margin. The design should also reserve capacity for control traffic and essential production communication instead of assuming the entire nominal VPN rate is available to HCX.

---

## 4. Building the Azure Network Foundation

The transcript uses Azure Virtual WAN (vWAN) and a regional virtual hub as the central transit architecture. The goal is to avoid a growing mesh of manually maintained VNet peerings and provide a managed routing core for on-premises, Azure spokes, and AVS connectivity. Standard Virtual WAN supports transitive VNet-to-VNet connectivity through the hub. [Microsoft Learn — Virtual WAN FAQ](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq#can-spoke-vnets-connected-to-a-virtual-hub-communicate-with-each-other-v2v-transit)

### 4.1 Why a Traditional VNet Design Becomes Difficult

A small Azure deployment can begin with one VNet and one VPN gateway, but enterprise environments normally expand.

- Separate VNets may be created for web, database, development, shared services, and other workload tiers.
- AVS adds another distinct network domain.
- Direct peering between every required pair creates a peering mesh.
- Route-table and peering maintenance becomes more complex as networks are added.
- [VNet peering is not inherently transitive](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview):
  - If VNet A is peered with VNet B, and VNet B is peered with VNet C, VNet A does not automatically gain connectivity to VNet C.
- A traditional design may require a network virtual appliance, such as a Cisco or Palo Alto device, to provide centralized transit routing.

### 4.2 Virtual WAN and Virtual Hub Roles

- **Virtual WAN:** The vWAN object is a global resource and serves as the container for the hybrid and multi-region connectivity strategy. [Microsoft Learn — Configure vWAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#create-an-azure-virtual-wan)
- **Virtual hub:** A hub is a Microsoft-managed virtual network deployed in a specific Azure region and serves as the managed routing core for that region. It can contain site-to-site and ExpressRoute gateways. [Microsoft Learn — Create a virtual hub](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#create-a-virtual-hub)
- **Spokes:** Native Azure VNets connect to the hub rather than being fully meshed with one another.
- **Branches and sites:** On-premises sites and acquired branch offices terminate their VPN connectivity at the hub.
- **Central transit:** The hub’s managed router exchanges traffic among connected sites, spokes, gateways, and the AVS path according to the configured routing and security controls.
- **Scalability benefit:** New networks and sites can be attached to the hub without redesigning a full peering matrix.

> **Architectural interpretation:** The vWAN hub is the Azure-side receiving and transit center. It decouples external connectivity from workload VNets and gives the architecture a single place to scale gateways, propagate routes, and apply central controls.

> **Documentation image note:** Microsoft Learn includes a directly relevant site-to-site VPN and AVS topology diagram on the [vWAN configuration article](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway). The original asset could not be downloaded reliably in this execution environment and therefore was not packaged.

### 4.3 Virtual Hub Address Space

The transcript directs the architect to allocate a private address prefix to the virtual hub.

- The cited example uses a **/24** prefix.
- A /24 contains 256 total IPv4 addresses.
- The hub prefix must not overlap with on-premises, Azure spoke, AVS management, HCX, or workload networks.
- Address planning should reserve space for future growth and prevent route ambiguity.

> **Documentation correction:** `/24` is the documented minimum Virtual WAN hub address space, but Microsoft recommends `/23` or larger for future scale. A secured hub with Azure Firewall requires at least `/22` so the firewall can allocate enough addresses to scale to maximum throughput. The hub address space cannot be changed after creation. [Microsoft Learn — Virtual hub address space](https://learn.microsoft.com/en-us/azure/virtual-wan/hub-settings#virtual-hub-address-space)

### 4.4 Standard Versus Basic Virtual WAN

The initial tier selection is a critical dependency.

| Capability in Transcript | Basic vWAN | Standard vWAN |
|---|---:|---:|
| Site-to-site VPN | Yes | Yes |
| Point-to-site VPN | Not presented as available | Presented as available |
| Advanced routing and routing intent | Restricted | Available |
| Firewall integration and policies | Restricted | Available |
| ExpressRoute gateway | Not available | Available |
| Suitable for the presented AVS architecture | No | Yes |

- **Basic limitation:** A Basic vWAN can contain only Basic hubs, and Basic hubs support only site-to-site connections. [Microsoft Learn — Create an Azure Virtual WAN](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#create-an-azure-virtual-wan)
- **Critical dependency:** The documented vWAN-to-AVS pattern requires an ExpressRoute gateway in the virtual hub before the AVS platform circuit can be patched to it. [Microsoft Learn — Patch the AVS ExpressRoute circuit](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#connect-your-vpn-site-to-the-hub)
- **Required choice for this topology:** Use **Standard** vWAN even though the external on-premises connection is a VPN.
- **Future flexibility:** Standard supports transitive connectivity and additional gateway and security scenarios beyond Basic. [Microsoft Learn — Virtual WAN FAQ](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq)

> **Documentation correction:** Azure Virtual WAN is one documented method for connecting a site-to-site VPN to AVS; it is not a universal prerequisite for every AVS networking design. Standard is mandatory only for the specific Virtual WAN pattern in this guide because the hub must contain both the VPN gateway and the ExpressRoute gateway. [Microsoft Learn — Configure a site-to-site VPN in vWAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

---

## 5. Sizing the Virtual WAN VPN Gateway

The VPN gateway must be sized for aggregate demand rather than for a single site. The transcript uses scale units to represent gateway compute and throughput capacity.

### 5.1 Scale-Unit Behavior

- A VPN gateway scale unit represents a predefined amount of gateway compute and throughput.
- The transcript assigns **500 Mbps** of aggregate throughput to one VPN gateway scale unit.
- Azure provisions two gateway instances in an active-active configuration.
- Each instance has its own public IP address.
- Both instances actively process traffic rather than leaving one idle as a passive standby.

> **Documentation correction:** Microsoft defines one Virtual WAN VPN gateway scale unit as 500 Mbps of aggregate gateway throughput. For the AVS vWAN procedure, selecting one scale unit creates two redundant instances, each with a maximum throughput of 500 Mbps. The two instances provide active-active redundancy; they should not be treated as a single 1 Gbps tunnel. [Microsoft Learn — AVS vWAN VPN gateway sizing](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#create-a-vpn-gateway) [Microsoft Learn — Virtual WAN VPN performance](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq#what-is-the-recommended-algorithm-and-packets-per-second-per-site-to-site-instance-in-virtual-wan-hub-how-many-tunnels-is-support-per-instance-what-is-the-max-throughput-supported-in-a-single-tunnel)

### 5.2 Capacity Example

> **Transcript-derived calculation:** Headquarters requires 200 Mbps, and 50 branch offices each require 10 Mbps.

#### Inputs

- Headquarters: `200 Mbps`
- Branches: `50 × 10 Mbps = 500 Mbps`
- Total expected aggregate demand: `700 Mbps`

#### Formula

`200 Mbps + (50 × 10 Mbps) = 700 Mbps`

#### Result

- One 500 Mbps scale unit is insufficient.
- At least two scale units provide a documented aggregate gateway capacity of 1 Gbps for planning purposes. Individual tunnel and instance limits still apply. [Microsoft Learn — Virtual WAN gateway scale units](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq#what-are-virtual-wan-gateway-scale-units)

#### Practical Interpretation

If the gateway is undersized:

- Gateway compute can become saturated by IPsec encryption and decryption.
- Packets can be dropped.
- Latency can increase.
- Branch and application sessions can fail.
- HCX migration throughput can collapse even when the internet circuits themselves have unused capacity.

#### Factors That Can Change the Real Requirement

- Not every site may transmit at peak simultaneously.
- Bidirectional traffic may be asymmetric.
- IPsec and encapsulation overhead reduces usable application throughput.
- HA distribution across instances may not be perfectly even.
- Individual tunnel limits may constrain a single migration flow.
- HCX, management, DNS, authentication, and production workload traffic may compete for capacity.
- Future sites and acquisitions increase the aggregate requirement.

### 5.3 Sizing Procedure

1. Inventory every site and connection expected to terminate on the hub.
2. Record nominal circuit capacity and realistic peak utilization.
3. Include migration, backup, replication, management, DNS, and authentication traffic.
4. Calculate expected aggregate inbound and outbound demand.
5. Add headroom for bursts, failover, encryption overhead, and future growth.
6. Select the gateway scale that supports the peak design case.
7. Load-test the path before the migration window.
8. Monitor actual throughput, packet loss, and gateway health during migration.

### 5.4 Design Takeaway

The gateway must not become an artificial choke point at the Azure edge. The WAN is already constrained; the Azure-side receiving path should be sized so that it does not reduce the throughput available from the internet circuit.

---

## 6. Choosing the Internet Routing Preference

The transcript compares ISP-network routing with Microsoft-network routing using the hot-potato and cold-potato metaphors. The Virtual WAN VPN gateway procedure exposes these choices as **Microsoft network** and **ISP network (public internet)** routing preferences. [Microsoft Learn — AVS vWAN VPN routing preference](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#create-a-vpn-gateway)

### 6.1 Hot-Potato Routing

- A provider hands the packet to another network as early as possible.
- The packet may traverse multiple public ISPs before reaching the Azure region.
- The route is exposed to more internet-path changes, congestion, outages, routing flaps, and attacks.
- Latency and jitter may vary as the path changes.
- The transcript associates this behavior with the ISP network option.

### 6.2 Cold-Potato Routing

- The packet enters Microsoft’s network at an edge location closer to the source.
- Microsoft carries the packet across its managed backbone toward the destination region.
- The public-internet portion of the trip is shortened.
- The transcript associates this behavior with **Microsoft Network Routing**.
- The expected design benefit is more stable latency and jitter.

> **Transcript-derived analogy:** A hot potato is handed away immediately, so many providers may carry it. A cold potato is retained longer by Microsoft after an early on-ramp onto its backbone.

### 6.3 Why the Transcript Prefers Microsoft Network Routing

A VPN-based HCX migration is sensitive to variable latency and packet loss. The transcript therefore treats Microsoft Network Routing as a major performance-control decision.

- A shorter public-internet path reduces exposure to unpredictable ISP behavior.
- More of the packet journey occurs on Microsoft-managed infrastructure.
- Stable latency improves the likelihood that HCX vMotion can converge.
- Reduced jitter and packet loss protect application and management sessions.
- The option may carry a price premium, but the transcript frames that cost as a way to recover some predictability lost by not using a dedicated circuit.

> **Documentation correction:** The routing-preference setting is documented for the public IP address assigned to the Virtual WAN VPN gateway. Microsoft documents the path-selection options but does not promise that Microsoft-network routing restores an ExpressRoute-like SLA or guarantees vMotion success. Treat improved predictability as an architectural expectation to validate with measurements, not as a service guarantee. [Microsoft Learn — Routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)

---

## 7. Creating the Site-to-Site VPN Connection

With the hub and gateway deployed, the next task is to configure the VPN site, IPsec tunnel, device compatibility settings, and dynamic routing.

### 7.1 Identify the On-Premises VPN Device

The VPN site record includes device-vendor metadata, but the transcript overstates its immediate effect on tunnel negotiation.

- Vendors may implement IPsec defaults differently even when using the same standards.
- Differences can include:
  - IKE timers
  - Encryption-suite preferences
  - Negotiation order
  - Rekey behavior
  - Traffic-selector behavior
- Microsoft states that the device-vendor field helps the Azure team understand the environment for future optimization possibilities and troubleshooting; the documentation does not state that Azure automatically changes timers or cryptographic negotiation behavior based on this selection. [Microsoft Learn — Create a site-to-site VPN](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#create-a-site-to-site-vpn)
- The examples named in the transcript include Cisco, Juniper, Palo Alto, and Citrix.

> **Operational recommendation:** Record the exact firewall model, software version, supported IKE version, BGP capabilities, and high-availability design before generating or applying the Azure configuration.

### 7.2 Use Border Gateway Protocol

[Border Gateway Protocol (BGP)](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-bgp-overview) is the dynamic routing protocol used to exchange reachable prefixes between the on-premises edge and the Azure hub.

- **Dynamic advertisement:** Each side announces the networks it can reach.
- **Reduced manual maintenance:** New or changed prefixes can be propagated without adding static routes on every device.
- **Autonomous system numbers:** Each BGP domain uses an autonomous system number (ASN).
- **Azure ASN:** The transcript cites Azure ASN **65515** as the typical default.
- **On-premises ASN:** The edge router should use a different private ASN.
- **Example advertisement:** Azure may advertise that ASN 65515 can reach `10.1.0.0/24`.

### 7.3 Why Static Routing Is Risky

The transcript rejects static routing for the presented AVS and HCX design because the environment creates and advertises multiple dynamic networks.

- HCX deploys management and migration appliances.
- HCX can create vMotion networks and Layer 2 extended segments.
- Each required prefix would need to be entered and maintained manually on the on-premises router.
- A mistyped subnet mask or omitted migration network can prevent service-mesh formation.
- The resulting failure may appear as an HCX or vSphere timeout rather than as an obvious routing error.
- Engineers may spend time troubleshooting software while the actual cause is one missing route.

#### Failure Scenario

1. HCX creates or uses a migration network.
2. The network is not present in the on-premises static route table.
3. Return traffic does not have a valid path.
4. The HCX service mesh fails or a migration times out.
5. The firewall may not present an explicit message identifying the missing route.
6. Troubleshooting moves incorrectly toward VMware logs and appliance health.

> **Operational recommendation:** Treat BGP adjacency, learned routes, advertised routes, and prefix symmetry as first-line validation items before troubleshooting HCX at the application layer.

> **Documentation correction:** BGP is supported and strongly recommended for this dynamic topology, but the AVS vWAN article allows BGP to be disabled if every required subnet is maintained manually. Microsoft warns that omitted subnets can prevent HCX from forming the service mesh. [Microsoft Learn — AVS vWAN BGP guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#create-a-site-to-site-vpn)

### 7.4 APIPA BGP Peering Addresses

Automatic Private IP Addressing (APIPA) uses link-local addresses in the `169.254.0.0/16` range; Azure documents custom APIPA addresses for BGP peering when the on-premises VPN device also uses APIPA. [Microsoft Learn — APIPA BGP peering](https://learn.microsoft.com/en-us/azure/vpn-gateway/bgp-howto) The transcript describes an edge case in which the on-premises device uses APIPA addresses for BGP peering across the VPN.

- Azure normally uses an internal private address as the gateway’s BGP peering endpoint.
- Some legacy or tightly standardized devices may require an APIPA peering address.
- The Azure configuration must indicate that the on-premises BGP peer uses APIPA.
- Azure can then provision a compatible custom APIPA address for its side of the peering.
- If one side expects APIPA and the other uses a standard private address, the BGP adjacency does not form.

#### Troubleshooting Implication

A tunnel can appear partially configured while BGP remains down because the peer addresses do not match. The transcript presents this as a subtle issue capable of causing many hours of investigation.

> **Documentation correction:** The transcript’s intended term is **APIPA**. The AVS vWAN article documents custom Azure APIPA BGP addressing when the on-premises peer uses an address from `169.254.0.1` through `169.254.255.254`; the exact supported/reserved ranges for the selected Azure gateway type must still be checked before assignment. [Microsoft Learn — Custom APIPA BGP address](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#create-a-site-to-site-vpn)

### 7.5 Route-Based and Policy-Based VPNs

| Characteristic | Route-Based VPN | Policy-Based VPN |
|---|---|---|
| Traffic selection | Routing table sends traffic to a virtual tunnel interface | Explicit source and destination selectors define the encryption domain |
| Flexibility | High; routes determine protected traffic | Lower; selectors must be maintained |
| Transcript preference | Preferred by Azure | Used mainly for legacy or compliance requirements |
| Change impact | New routes can use the tunnel without redefining every selector | New subnets may require policy updates on both sides |
| Common failure | Incorrect route or BGP issue | Mismatched or missing traffic selector |
| Operational complexity | Lower for dynamic environments | Higher in environments with many changing prefixes |

- **Route-based design:** Traffic sent to the tunnel interface is encrypted according to routing decisions. Azure VPN gateways use route-based VPNs for most modern scenarios. [Microsoft Learn — Policy-based devices with route-based VPN Gateway](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-connect-multiple-policybased-rm-ps)
- **Policy-based design:** Only traffic matching configured source and destination ranges triggers the IPsec tunnel. The AVS vWAN procedure documents policy-based traffic selectors as an optional configuration and requires the hub, AVS, and connected VNet ranges in the encryption domain. [Microsoft Learn — Optional policy-based tunnels](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#optional-create-policy-based-vpn-site-to-site-tunnels)
- **Compliance driver:** Some organizations use policy-based VPNs because security policy requires explicit encryption domains.
- **Failure condition:** If a subnet is missing from a policy selector, matching traffic is dropped.

### 7.6 IKE and IPsec Negotiation

The transcript summarizes Internet Key Exchange (IKE) in two phases.

1. **IKE Phase 1**
   - Establishes the initial secure channel between the two VPN devices.
   - Uses a Diffie-Hellman key exchange to derive a shared secret without transmitting that secret directly.
   - Requires matching authentication and cryptographic parameters.

2. **IKE Phase 2**
   - Uses the Phase 1 channel to negotiate the IPsec security associations that protect data traffic.
   - Selects the payload encryption algorithm, such as AES-256.
   - Selects the integrity mechanism, such as SHA-256.
   - Establishes the traffic selectors or protected routes.

- **Configuration dependency:** When a custom IPsec/IKE policy is used, the configured encryption, integrity, Diffie-Hellman, lifetime, and perfect-forward-secrecy parameters must be compatible on both sides. [Microsoft Learn — Configure custom IPsec/IKE policy](https://learn.microsoft.com/en-us/azure/vpn-gateway/ipsec-ike-policy-howto)
- **Failure behavior:** A mismatch can prevent the tunnel from forming or can allow only some traffic to pass.

---

## 8. Connecting the Virtual Hub to AVS

The external path reaches the Azure virtual hub through the VPN gateway, but AVS is a distinct VMware environment rather than a set of native Azure VMs. The hub therefore needs an additional internal connection to the AVS private cloud.

### 8.1 Why AVS Uses an Internal ExpressRoute Path

- AVS consists of dedicated bare-metal ESXi hosts in Microsoft datacenters.
- VMware NSX provides network virtualization inside the AVS environment.
- AVS workloads are not native Azure VMs attached directly to Azure virtual network interfaces.
- Microsoft provisions an ExpressRoute circuit with the AVS private cloud and uses it to integrate the private cloud with Azure networking. [Microsoft Learn — AVS vWAN site-to-site topology](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
- The virtual hub therefore contains:
  - A **VPN gateway** for the external on-premises IPsec path.
  - An **ExpressRoute gateway** for the internal connection toward AVS.

> **Transcript-derived analogy:** The on-premises moving truck travels over the VPN “state highway” to the Microsoft “warehouse,” represented by the virtual hub. Microsoft then uses an internal high-speed “forklift,” represented by the internal ExpressRoute path, to move the traffic into the AVS area.

### 8.2 Dependency on Standard Virtual WAN

The ExpressRoute gateway requirement explains the earlier Standard-tier decision.

- Basic vWAN does not provide the ExpressRoute gateway capability described in the design.
- Standard vWAN allows the ExpressRoute gateway to coexist with the VPN gateway in the hub.
- The external connection can remain a VPN even though the hub-to-AVS leg uses ExpressRoute internally.

### 8.3 Authorization-Key Workflow

The transcript provides the following Azure portal sequence.

1. Open the **AVS private cloud** resource.
2. Navigate to its **connectivity** settings.
3. Open the **ExpressRoute** area.
4. Request an **authorization key**.
5. Copy the generated authorization key immediately.
6. Copy the **ExpressRoute ID**, also described as the peer-circuit URI.
7. Return to the **virtual hub**.
8. Open the hub’s **ExpressRoute gateway** configuration.
9. Select the option to **redeem an authorization key**.
10. Paste the authorization key.
11. Paste the ExpressRoute ID or peer-circuit URI.
12. Submit the request.
13. Wait for the authorization and connection state to complete.
14. Allow time for BGP routes to propagate before testing.

- **Authorization key:** The key grants the hub permission to connect to the AVS-managed ExpressRoute circuit.
- **Circuit identifier:** The peer-circuit URI uniquely identifies the ExpressRoute resource associated with the AVS private cloud.
- **Control-plane result:** Redeeming the key authorizes the isolated AVS environment to attach its internal circuit to the hub.

> **Directly supported:** Microsoft states that the authorization key disappears after some time and instructs operators to copy the key and ExpressRoute ID as soon as the key appears. The documentation does not publish an exact lifetime on this page. [Microsoft Learn — Request an AVS authorization key](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#connect-your-vpn-site-to-the-hub)

### 8.4 BGP Convergence Delay

Microsoft instructs the operator to wait approximately five minutes after establishing the link before testing connectivity from a client behind the circuit. [Microsoft Learn — Test the AVS vWAN connection](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#connect-your-vpn-site-to-the-hub)

The route propagation path includes:

1. AVS NSX-T advertises AVS prefixes.
2. The prefixes traverse the AVS-managed ExpressRoute circuit.
3. The hub ExpressRoute gateway learns the routes.
4. The virtual hub router processes and propagates the routes.
5. The hub VPN gateway advertises them across the site-to-site tunnel.
6. The on-premises edge router updates its BGP table.
7. Return routes must converge in the opposite direction.

Testing immediately can produce failed pings or unreachable services even when the configuration is correct.

#### Troubleshooting Risk

- An engineer redeems the key.
- Connectivity is tested immediately.
- Routes have not fully propagated.
- The test fails.
- The engineer assumes the tunnel, subnet mask, or authorization is incorrect.
- Working components are unnecessarily changed or removed.

> **Operational recommendation:** Record the connection-completion time, wait for the documented convergence interval, then validate route tables and BGP peers before testing applications.

---

## 9. Securing Hybrid and Inter-Network Traffic

Once routing is established among on-premises, Azure spokes, and AVS, unrestricted reachability can create lateral-movement risk. The hub must operate as a security control point rather than only as a transit router.

### 9.1 Threat Scenario

- A web server in a native Azure spoke is compromised.
- The spoke has unrestricted routing to AVS.
- The attacker can probe AVS workloads or management services.
- Direct reachability to vCenter or NSX management interfaces could expand the compromise.

### 9.2 Central Firewall

The transcript proposes a central firewall in or associated with the hub.

- A native implementation uses [Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/overview).
- A third-party network virtual appliance can also provide the inspection role.
- The firewall enforces policy between network zones.
- Traffic can be checked against access-control rules.
- The transcript also attributes intrusion-detection capability to the inspection path.
- Allowed traffic is forwarded; denied or suspicious traffic is dropped.

> **Documentation correction:** Azure Firewall feature availability depends on SKU. IDPS and TLS inspection require Azure Firewall Premium; Standard provides network and application filtering but not those Premium inspection features. [Microsoft Learn — Azure Firewall features by SKU](https://learn.microsoft.com/en-us/azure/firewall/features-by-sku)

### 9.3 Secured Virtual WAN Hub Routing

For the architecture used elsewhere in this guide, Azure Firewall can be associated with the Microsoft-managed Virtual WAN hub to create a **secured virtual hub**. Firewall Manager and Virtual WAN routing policies automate the supported traffic-steering model; Microsoft states that customers do not need to create their own UDRs to route traffic through the firewall. [Microsoft Learn — Secured virtual hub](https://learn.microsoft.com/en-us/azure/firewall-manager/secured-virtual-hub)

- Configure **routing intent and routing policies** to direct private and/or internet traffic to the selected security provider. [Microsoft Learn — Virtual WAN routing intent](https://learn.microsoft.com/en-us/azure/virtual-wan/how-to-routing-policies)
- Routing intent is required to secure inter-hub and branch-to-branch traffic, including branch-to-branch communication within one hub. [Microsoft Learn — Secured virtual hub](https://learn.microsoft.com/en-us/azure/firewall-manager/secured-virtual-hub)
- Validate route propagation for VNet, VPN, ExpressRoute, and AVS connections and maintain symmetric paths through the stateful firewall.
- Select the Azure Firewall SKU according to required features. IDPS and TLS inspection are Premium capabilities rather than generic behavior of every Azure Firewall deployment. [Microsoft Learn — Azure Firewall features by SKU](https://learn.microsoft.com/en-us/azure/firewall/features-by-sku)

> **Documentation correction:** The transcript combines a secured Virtual WAN hub with a traditional hub-VNet UDR design. In a secured Virtual WAN hub, use Firewall Manager and Virtual WAN routing intent rather than assigning a customer route table to a `GatewaySubnet` that does not exist as a customer-managed subnet.

### 9.4 Traditional Hub VNet and GatewaySubnet Distinction

A separate Azure architecture pattern uses a customer-managed hub VNet containing `GatewaySubnet`, `AzureFirewallSubnet`, and workload or shared-service subnets. In that pattern, UDRs can steer workload-subnet traffic to a virtual appliance or Azure Firewall. [Microsoft Learn — Azure virtual network traffic routing](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview)

- `0.0.0.0/0` is the default route, or route of last resort.
- Workload subnets can use a default route to send outbound traffic to a firewall when the design is supported.
- Do not disable virtual-network-gateway route propagation on `GatewaySubnet`; Microsoft states that the gateway will not function. [Microsoft Learn — Virtual network gateway route propagation](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview#border-gateway-protocol)
- If a VNet is connected to an Azure VPN gateway, Microsoft specifically warns not to associate a route table with `GatewaySubnet` when it contains a `0.0.0.0/0` destination because the gateway might stop functioning correctly. [Microsoft Learn — Associate a route table with a subnet](https://learn.microsoft.com/en-us/azure/virtual-network/manage-route-table#associate-a-route-table-to-a-subnet)

> **Architectural interpretation:** Preserve the transcript’s operational warning—do not override managed gateway control-plane routing—but apply it only to the architecture pattern that actually contains a customer-managed `GatewaySubnet`. For the Virtual WAN design, use Virtual WAN route tables, connection associations/propagations, and routing intent.

### 9.5 Segmentation Principles

- Separate management, migration, application, shared-service, and ingress traffic.
- Allow only the protocols required for HCX, vCenter, NSX-T, domain services, application flows, and monitoring.
- Do not rely on reachability alone as authorization.
- Maintain bidirectional route symmetry through stateful inspection devices.
- Log denied connections and monitor changes to route tables and firewall policy.
- Test failover and routing behavior after every major network-policy change.

---

## 10. Publishing AVS Web Applications

AVS workloads use VMware NSX networking rather than native Azure VM network interfaces. A native Azure public IP therefore cannot be attached directly to an AVS VM NIC. Microsoft documents two distinct ingress patterns: Azure Application Gateway is the preferred method for web applications, while public IP addresses on NSX Edge provide direct inbound and outbound internet connectivity when that pattern is approved. [Microsoft Learn — Protect AVS web apps with Application Gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway) [Microsoft Learn — Public IP on NSX Edge](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-public-ip-nsx-edge)

### 10.1 Application Gateway for Web Applications

Azure Application Gateway is a Layer 7 web traffic load balancer that can place AVS-hosted web servers in a backend pool. Microsoft describes Application Gateway as the **preferred** method to expose web applications running on AVS VMs. [Microsoft Learn — Application Gateway with AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway)

1. The internet client resolves and connects to the Application Gateway frontend IP.
2. A listener accepts the HTTP or HTTPS request.
3. When WAF is enabled, the request can be evaluated by Web Application Firewall policy.
4. A routing rule selects the AVS backend pool and HTTP settings.
5. Application Gateway opens a separate backend connection to the AVS-hosted web server over private connectivity. [Microsoft Learn — How Application Gateway works](https://learn.microsoft.com/en-us/azure/application-gateway/how-application-gateway-works)

- **Layer 7 controls:** Application Gateway supports capabilities such as URL-based routing, cookie-based affinity, and WAF. [Microsoft Learn — Protect AVS web apps](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway)
- **Backend treatment:** The service treats AVS VMs like externally reachable or on-premises backend servers; it does not require the servers to be native Azure VMs.
- **Placement:** Deploy Application Gateway in a dedicated subnet in a customer VNet connected to the AVS path. Do not describe it as being deployed inside the Microsoft-managed Virtual WAN hub.

> **Transcript-derived analogy:** Application Gateway acts like a secure corporate mailroom. It receives the external package, inspects it according to policy, then sends a separate internal request to the AVS application.

> **Documentation image note:** Microsoft Learn includes an Application Gateway and AVS topology diagram on the [AVS Application Gateway article](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway). The original asset could not be downloaded reliably in this execution environment and therefore was not packaged.

### 10.2 Public IP Addresses on NSX Edge

Microsoft also supports reserving public IP prefixes for the AVS private cloud and configuring them on NSX Edge. This capability provides inbound and outbound internet access for AVS workload VMs. [Microsoft Learn — Public IP on NSX Edge](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-public-ip-nsx-edge)

- Use NSX DNAT to expose a private workload IP on a specific public IP address or port.
- Use NSX SNAT/PAT for outbound connectivity and configure the required NSX gateway firewall policy.
- Review asymmetric-routing and reverse-DNS limitations documented for this pattern.
- Subject direct NSX ingress to the organization’s security, DDoS, governance, and compliance requirements.

> **Documentation correction:** Application Gateway is not the only supported native ingress option. It is the preferred Microsoft method for web applications, while public IP on NSX Edge is a supported direct-internet pattern. The correct choice depends on Layer 7 protection, protocol requirements, routing, and security policy.

---

## 11. Providing Secure Administrative Access

The AVS management plane must be reachable without exposing a Windows jump server or RDP directly to the internet. Azure Bastion provides RDP and SSH over TLS on port 443 without requiring a public IP, agent, or special client on the target VM. [Microsoft Learn — Azure Bastion overview](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) The transcript combines Bastion with an internal jump box for browser-based vCenter and NSX administration.

### 11.1 Prohibited Pattern

The insecure pattern is:

- Deploy a Windows jump box.
- Assign it a public IP address.
- Open TCP port 3389 to the internet.
- Use direct RDP for AVS administration.

The transcript rejects this design because internet scanning and brute-force attacks can quickly find exposed RDP services.

### 11.2 Jump-Box Placement

- Deploy a Windows client or Windows Server VM as a native Azure VM.
- Place it in a shared-services or management subnet.
- Do not assign it a public IP address.
- Allow it to reach the AVS management endpoints over private routes.
- Restrict its inbound and outbound access to administrative requirements.
- Use it to open the internal vCenter or NSX management interfaces.

### 11.3 Azure Bastion Access Flow

1. Deploy Azure Bastion in a dedicated `AzureBastionSubnet` in a connected spoke or management VNet. Bastion cannot be deployed inside the Microsoft-managed Virtual WAN hub. [Microsoft Learn — Bastion with Virtual WAN](https://learn.microsoft.com/en-us/azure/bastion/bastion-faq#does-azure-bastion-support-virtual-wan)
2. Keep the jump box private.
3. An administrator signs in to the Azure portal.
4. The administrator selects the jump-box VM.
5. The administrator chooses **Connect through Bastion**.
6. Bastion presents the RDP or SSH session through the browser.
7. The browser-side connection uses TLS over TCP 443.
8. From the jump-box desktop, the administrator accesses AVS management services over their private IP addresses.

- No inbound RDP port is exposed on the jump box.
- The administrator does not need to assign the VM a public IP.
- The transcript describes an HTML5 browser experience and no agent requirement on the administrator’s device.
- Azure identity, portal access, and role assignments become part of the administrative control plane.

### 11.4 Direct IP-Based Connections and the Jump-Box Role

Azure Bastion Standard or higher supports IP-based RDP and SSH connections to reachable on-premises and non-Azure VMs over ExpressRoute or site-to-site VPN. The target does not need to be an Azure resource or have a public IP address. [Microsoft Learn — Bastion IP-based connection](https://learn.microsoft.com/en-us/azure/bastion/connect-ip-address)

- **Direct guest access:** An AVS guest VM can be a candidate for direct Bastion access when it exposes supported RDP or SSH, its private IP is reachable, and all Bastion routing limitations are satisfied.
- **SKU requirement:** IP-based connection requires Bastion Standard or Premium and must be enabled in Bastion configuration.
- **Force-tunneling limitation:** IP-based connection does not work when force tunneling or a learned default route removes Bastion’s required internet path. [Microsoft Learn — Bastion IP connection limitations](https://learn.microsoft.com/en-us/azure/bastion/connect-ip-address#limitations)
- **Jump-box value:** vCenter and NSX Manager are web management interfaces rather than RDP/SSH targets. A private jump box remains useful for those interfaces, administrative tooling, controlled source addresses, and long-running operations.

> **Documentation correction:** Bastion does not depend on the Azure VM agent, and non-Azure VMs are not categorically unsupported. The transcript’s private jump-box pattern remains valid, but its stated technical reason is outdated.

### 11.5 Resiliency Benefit Under a Flaky WAN

The transcript presents the jump-box pattern as a direct mitigation for VPN instability.

- Heavy vCenter and NSX management traffic occurs between the Azure jump box and AVS over the Azure-side private path.
- Only the interactive screen, keyboard, and mouse session crosses the administrator’s internet connection.
- A brief local internet interruption does not necessarily stop a task already running on the jump box.
- The administrator can reconnect and continue after local connectivity returns.
- Management operations are less dependent on the latency and stability of the on-premises-to-Azure site-to-site VPN.

> **Operational recommendation:** Perform long-running migration and configuration tasks from the Azure-resident management host rather than from a workstation that communicates directly with AVS across the constrained WAN.

---

## 12. Designing Distributed Identity and DNS

The architecture spans three environments: on-premises, native Azure, and AVS. DNS and identity services must therefore be distributed so that a VPN interruption isolates environments gracefully rather than causing the entire cloud deployment to fail.

### 12.1 DNS Failure Impact

Without reliable DNS:

- On-premises servers cannot resolve AVS vCenter or migrated workload names.
- AVS workloads cannot locate Azure services by hostname.
- Applications cannot resolve database connection targets.
- Authentication can fail when domain controllers cannot be located.
- IP connectivity may exist while applications remain unusable.

### 12.2 Domain Controllers in Native Azure

The transcript recommends at least two Active Directory domain controllers near Azure workloads. In a Virtual WAN architecture, place them in a connected identity or shared-services VNet—not inside the Microsoft-managed virtual hub. Microsoft’s AVS landing-zone guidance recommends deploying an AD DS domain controller in the identity subscription. [Microsoft Learn — AVS enterprise-scale identity](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/eslz-identity-and-access-management)

- Deploy at least two VMs for redundancy.
- Place them in an availability set or distribute them across availability zones.
- Configure them as DNS servers for native Azure workloads.
- Use them as local identity authorities for Azure-hosted systems.
- Ensure their replication, time synchronization, monitoring, backup, and recovery are designed independently of the VPN path.

> **Documentation correction:** Customer VMs cannot be deployed inside the Microsoft-managed Virtual WAN hub. Deploy Azure-local domain controllers in a connected identity/shared-services VNet. The exact number and placement are availability-design decisions; Microsoft architecture guidance commonly uses at least two DNS/domain-controller VMs distributed across availability zones for resilience, but this is not an AVS vWAN requirement. [Microsoft Learn — Hybrid DNS with AD DS](https://learn.microsoft.com/en-us/azure/architecture/hybrid/hybrid-dns-infra)

### 12.3 Domain Controller in AVS

The transcript also places a domain controller inside AVS as a localized identity and DNS service. This is an architectural option, not a Microsoft requirement for every private cloud.

- Deploy a VM in the AVS environment.
- Promote it to a domain controller.
- Configure it to provide local DNS and authentication for VMware workloads.
- Ensure it replicates with the broader Active Directory environment while the hybrid link is available.
- Design it so AVS workloads can continue authenticating during a temporary VPN outage.

For production resiliency, the transcript’s single-VM statement should be expanded during validation to determine whether multiple AVS-local domain controllers are appropriate.

### 12.4 Azure Private DNS Zones

Azure Private DNS provides private name resolution in linked VNets without requiring a customer-managed authoritative DNS server for the private zone. [Microsoft Learn — Azure Private DNS zone overview](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone)

- A custom internal namespace such as `internal.mycompany.com` can be used.
- Private DNS zones are linked to VNets, and records are resolvable only from linked networks. [Microsoft Learn — Private DNS zone resolution](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone#private-dns-zone-resolution)
- Native Azure VMs can resolve linked zones; auto-registration can manage A-record lifecycle for VMs in a registration VNet.
- The feature reduces reliance on provider-generated names.

### 12.5 Auto-Registration

When auto-registration is enabled on a linked VNet:

- Azure creates an A record when a VM is deployed.
- The record maps the VM hostname to its private IP address.
- Azure removes the record when the VM is deleted.
- Administrators avoid manual record cleanup for those native Azure VMs.

The transcript states:

- A VNet can be linked to only one Private DNS zone with auto-registration enabled.
- Without auto-registration, a VNet can be linked to as many as 1,000 private zones.

> **Directly supported:** A VNet can be linked to only one private DNS zone with auto-registration enabled. Auto-registration creates A records for the primary NIC and removes them when the VM is stopped or deleted; it does not support non-VM resources or PTR records. [Microsoft Learn — Private DNS auto-registration restrictions](https://learn.microsoft.com/en-us/azure/dns/private-dns-autoregistration#restrictions) Microsoft currently documents that a VNet can link to as many as 1,000 private DNS zones when auto-registration is not enabled. [Microsoft Learn — Azure Private DNS limits](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone#limits)

### 12.6 Conditional Forwarders

Conditional forwarding links the DNS authorities in each environment. When a VNet uses custom DNS servers, those settings override Azure-provided DNS; use Azure DNS Private Resolver or a conditional forwarder to `168.63.129.16` from a DNS VM in a VNet linked to the private zone. [Microsoft Learn — Private DNS with custom DNS](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone#private-dns-zone-resolution)

Example flow for `internal.mycompany.com`:

1. An on-premises server queries its local DNS server.
2. The local server recognizes that the requested suffix belongs to Azure.
3. It forwards the query to the Azure-resident DNS servers.
4. The Azure DNS server resolves the name or queries the appropriate Azure Private DNS mechanism.
5. The response returns across the VPN.
6. The application begins communicating with the resolved private address.

Conditional forwarders should be designed in both directions for the namespaces that each environment owns.

- On-premises DNS forwards Azure-specific zones toward Azure.
- Azure DNS forwards on-premises zones toward on-premises servers.
- AVS-local DNS forwards zones it does not host toward the appropriate Azure or on-premises resolvers.
- Firewall policy must allow DNS traffic on the required protocols and ports.
- Forwarders should list multiple target servers to avoid a single resolver dependency.

> **Documentation correction:** AD-integrated DNS and Azure Private DNS are separate authoritative systems. Domain controllers do not automatically host Azure Private DNS zone data. Use Azure DNS Private Resolver inbound/outbound endpoints and forwarding rulesets, or DNS forwarder VMs with conditional forwarders, to bridge the namespaces. [Microsoft Learn — Azure DNS Private Resolver architectures](https://learn.microsoft.com/en-us/azure/dns/private-resolver-architecture)

### 12.7 Failure Behavior During a VPN Outage

A centralized on-premises-only DNS design creates a critical dependency:

- The VPN fails.
- Azure and AVS systems lose access to on-premises domain controllers and DNS.
- Authentication and hostname resolution fail.
- Applications stop even if their local compute and storage remain healthy.

The distributed design changes the failure mode:

- AVS workloads can continue using AVS-local DNS and domain services for functions that do not require contact with unavailable remote services.
- Native Azure workloads can continue using Azure-local DNS and domain services.
- Azure Private DNS zones remain available through linked VNets and local resolver paths.
- Cross-environment dependencies, AD replication, remote application tiers, and resources whose authentication requires unavailable remote roles can still be affected.
- Local services reduce the blast radius of a VPN outage; they do not guarantee that every workload continues normally during a network partition.

> **Transcript-derived analogy:** The locally deployed domain controllers and DNS services act as lifeboats. Each environment retains local capabilities while the primary route back to the on-premises datacenter is unavailable.

> **Documentation image note:** Microsoft Learn includes centralized and distributed DNS Private Resolver diagrams on the [Private resolver architecture](https://learn.microsoft.com/en-us/azure/dns/private-resolver-architecture) article. The original asset could not be downloaded reliably in this execution environment and therefore was not packaged.

---

## 13. End-to-End Deployment Sequence

The following sequence consolidates the transcript’s architecture into an implementation workflow.

### Phase 1: Assess the Workloads and WAN

1. Inventory all VMs, data sizes, change rates, clusters, and dependencies.
2. Identify workloads that can tolerate cold-migration downtime.
3. Identify workloads that may be candidates for HCX vMotion.
4. Measure current internet latency, jitter, packet loss, and sustained throughput to the target Azure region.
5. Record local firewall capabilities, VPN throughput, BGP support, and HA behavior.
6. Calculate migration durations using measured throughput and safety margins.
7. Define rollback and outage thresholds.

### Phase 2: Plan the Address Space

1. Document on-premises networks.
2. Document current and planned Azure spoke networks.
3. Reserve nonoverlapping prefixes for:
   - Virtual hub
   - Shared services
   - Management
   - Azure Bastion
   - Application Gateway
   - Domain controllers
   - AVS management
   - HCX management and migration
   - AVS workload segments
4. Validate that no prefixes overlap across BGP domains.

### Phase 3: Deploy the Virtual WAN Foundation

1. Create a [Standard Azure Virtual WAN](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#create-an-azure-virtual-wan) for this documented topology.
2. Create a [virtual hub](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#create-a-virtual-hub) in the target Azure region.
3. Assign at least `/24`; prefer `/23` or larger, or at least `/22` when Azure Firewall will be deployed in the hub. [Microsoft Learn — Virtual hub address space](https://learn.microsoft.com/en-us/azure/virtual-wan/hub-settings#virtual-hub-address-space)
4. Connect required native Azure spoke VNets.
5. Deploy the hub VPN gateway.
6. Size the gateway for aggregate peak demand and growth.
7. Select the intended routing preference.

### Phase 4: Configure the On-Premises Site and VPN

1. Create the VPN site and record accurate device-vendor metadata for inventory and troubleshooting. [Microsoft Learn — Create a site-to-site VPN](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway#create-a-site-to-site-vpn)
2. Configure both gateway public IP destinations for active-active connectivity when required.
3. Configure compatible IKE and IPsec parameters.
4. Prefer a route-based VPN unless a validated policy requirement mandates policy-based selectors.
5. Configure the on-premises ASN.
6. Configure BGP peer addresses.
7. Configure APIPA peers explicitly if required.
8. Bring up the IPsec tunnels.
9. Verify both tunnel instances and BGP adjacencies.
10. Confirm expected routes are advertised and learned.

### Phase 5: Connect the Hub to AVS

1. Deploy an ExpressRoute gateway in the Standard virtual hub.
2. Request the AVS ExpressRoute authorization key.
3. Copy the authorization key and circuit URI.
4. Redeem the authorization in the hub ExpressRoute gateway.
5. Wait for the connection state to complete.
6. Allow time for BGP convergence.
7. Verify AVS prefixes are visible on-premises.
8. Verify on-premises and Azure prefixes are visible from the AVS side.
9. Test bidirectional connectivity with route and firewall validation.

### Phase 6: Implement Security

1. Deploy Azure Firewall or the selected network virtual appliance.
2. Define network zones and approved flows.
3. For a secured Virtual WAN hub, configure [routing intent and policies](https://learn.microsoft.com/en-us/azure/virtual-wan/how-to-routing-policies); do not attempt to use a customer `GatewaySubnet` UDR model.
4. For a traditional hub VNet, use supported UDRs on workload subnets and preserve symmetric return routing.
5. Preserve required gateway and Bastion platform connectivity.
6. Do not apply an unsupported `0.0.0.0/0` or disable route propagation on `GatewaySubnet`; avoid force tunneling for the Bastion VNet.
7. Enable logging and alerting for denied traffic and routing changes.
8. Test route symmetry and firewall failover.

### Phase 7: Deploy Ingress and Management Services

1. Use [Application Gateway and WAF](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway) for approved web applications when Layer 7 protection is required, or use the separately governed [NSX public IP](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-public-ip-nsx-edge) pattern for supported direct ingress.
2. Keep AVS workload addresses private when using Application Gateway; direct NSX ingress uses DNAT from a reserved public IP.
3. Deploy a native Azure jump box without a public IP.
4. Deploy Azure Bastion in a connected spoke/management VNet; use Standard or higher when IP-based connection is required. [Microsoft Learn — Bastion IP-based connection](https://learn.microsoft.com/en-us/azure/bastion/connect-ip-address)
5. Limit the jump box to required management endpoints.
6. Validate access to vCenter and NSX from the jump box.
7. Perform migration and configuration operations from the Azure-resident management host.

### Phase 8: Deploy Identity and DNS

1. Deploy at least two Azure-local domain controllers in a shared-services VNet.
2. Distribute them across fault domains or availability zones.
3. Deploy appropriate local domain-controller capacity in AVS.
4. Create and link [Azure Private DNS zones](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone) for Azure-private naming, and deploy [Azure DNS Private Resolver](https://learn.microsoft.com/en-us/azure/dns/private-resolver-architecture) or DNS forwarders when hybrid resolution is required.
5. Enable auto-registration only where the namespace design requires it.
6. Configure conditional forwarders among on-premises, Azure, and AVS DNS services.
7. Test authentication and resolution with the VPN available.
8. Simulate or schedule a controlled VPN outage.
9. Confirm local authentication and DNS continue operating in Azure and AVS.

### Phase 9: Execute the Migration

1. Establish a change freeze for the selected workload.
2. Reduce high-write activity for vMotion candidates.
3. Gracefully stop all nodes for cold-migrated clustered workloads.
4. Start the HCX migration.
5. Monitor tunnel throughput, packet loss, BGP state, and gateway health.
6. Validate destination startup and application dependencies.
7. Confirm DNS records and application connectivity.
8. Retain rollback capability until business validation is complete.

---

## 14. Validation and Troubleshooting Guide

The transcript repeatedly emphasizes that routing and convergence failures can appear as application or HCX failures. Troubleshooting should therefore proceed from the underlying transport upward.

### 14.1 Validation Order

1. **Internet path**
   - Confirm the on-premises circuit is stable.
   - Measure latency, jitter, packet loss, and throughput.

2. **IPsec**
   - Confirm both active-active tunnels are established.
   - Check IKE and IPsec security associations.
   - Verify cryptographic parameter compatibility.

3. **BGP**
   - Confirm neighbor state is established.
   - Verify ASNs and peer addresses.
   - Check APIPA configuration if used.
   - Review advertised and learned prefixes.

4. **Virtual hub**
   - Confirm VPN and ExpressRoute gateway health.
   - Confirm route propagation among connections.
   - Check effective vWAN route tables or supported routing views.

5. **AVS authorization**
   - Confirm the authorization was redeemed successfully.
   - Confirm the correct circuit URI was used.
   - Allow the required convergence interval.

6. **Firewall and UDRs**
   - Confirm the intended next hop.
   - Confirm return-path symmetry.
   - Review deny logs.
   - Verify gateway control-plane traffic has not been overridden.

7. **HCX**
   - Confirm management and migration appliances can communicate.
   - Confirm service-mesh networks are reachable.
   - Review HCX only after network reachability is established.

8. **DNS**
   - Test direct DNS queries to each local resolver.
   - Test conditional forwarders.
   - Confirm the correct zone owns the queried name.
   - Confirm records remain available during a WAN outage.

9. **Application**
   - Validate ports, certificates, authentication, dependencies, and transaction flow.

### 14.2 Common Failure Scenarios

| Symptom | Likely Transcript-Derived Cause | Initial Check |
|---|---|---|
| HCX service mesh times out | Missing static route or failed BGP propagation | Compare expected prefixes with learned routes |
| BGP adjacency never forms | ASN, peer IP, or APIPA mismatch | Verify both peer configurations |
| Only some policy-based VPN traffic works | Missing source/destination traffic selector | Compare encryption domains on both devices |
| Ping fails immediately after AVS authorization | BGP convergence is incomplete | Wait the documented interval and recheck routes |
| Gateway becomes unhealthy after route changes | Unsupported default route redirected control-plane traffic | Remove the route and restore supported routing |
| vMotion never converges | Dirty-page rate exceeds effective tunnel transfer rate | Reduce workload activity and measure packet loss |
| Cold migration misses the change window | Throughput estimate used nominal rather than sustained rate | Recalculate using measured throughput and overhead |
| AVS application cannot be reached from the internet | Application Gateway backend/routing issue, missing NSX DNAT, or firewall policy | Identify whether the design uses Application Gateway or NSX public IP, then validate that specific path |
| Bastion cannot reach an AVS guest by IP | Standard+ IP connection not enabled, route unavailable, force tunneling, NSG/firewall, or target service unavailable | Validate Bastion SKU/configuration, private route, and RDP/SSH reachability; use a jump box for vCenter/NSX web administration |
| Cloud workloads fail when the VPN drops | DNS and identity depend exclusively on on-premises services | Deploy and test local Azure and AVS services |

---

## 15. Operational Recommendations

- Treat the VPN as a shared production service, not only as a migration tunnel.
- Reserve headroom for authentication, DNS, management, and application traffic.
- Use measured sustained throughput in all migration calculations.
- Avoid high-write workload activity during HCX vMotion.
- Use cold migration when workload architecture or supportability requires a full shutdown.
- Prefer and validate BGP rather than depending on manually maintained route lists; static routing is supported only when every required subnet is maintained correctly.
- Document ASNs, peer addresses, route advertisements, and APIPA assignments.
- Prefer route-based VPNs unless a validated legacy or compliance constraint requires policy-based selectors.
- Size the hub gateway for aggregate peak traffic and failover conditions.
- Use Microsoft-network routing when validated as applicable and justified by latency requirements.
- Wait for BGP convergence after connecting the AVS circuit.
- Route workload traffic through [Virtual WAN routing intent](https://learn.microsoft.com/en-us/azure/virtual-wan/how-to-routing-policies) in a secured hub, or through supported UDRs in a traditional hub VNet; do not merge the two routing models.
- Never expose a jump box to the internet with public RDP.
- Perform complex AVS management from an Azure-resident jump host.
- Prefer a controlled Layer 7 ingress service for AVS web applications, while recognizing that [NSX public IP and DNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-public-ip-nsx-edge#inbound-internet-access-for-vms) are also supported when direct ingress is required.
- Distribute DNS and identity services so a WAN outage does not become a cloud-wide outage.
- Test failure modes before the migration weekend, including tunnel loss, gateway failover, DNS isolation, and route reconvergence.

---

## 16. Architecture Summary

The completed design uses the site-to-site VPN only for the external on-premises-to-Azure leg. Azure Virtual WAN provides the regional transit core, while the AVS private cloud attaches to the hub through its internal ExpressRoute-based integration. Security, management, and DNS services are placed so that the constrained internet path does not become a single point of operational failure.

### End-to-End Traffic Flow

1. An on-premises router encrypts traffic into an IPsec site-to-site VPN.
2. The traffic enters Azure through the active-active vWAN VPN gateway.
3. BGP dynamically exchanges on-premises, Azure, HCX, and AVS prefixes.
4. The virtual hub routes the traffic according to its connection and security policies.
5. The hub ExpressRoute gateway carries AVS-bound traffic over the AVS-managed internal ExpressRoute connection.
6. A secured Virtual WAN hub uses Firewall Manager and routing intent to direct selected traffic through Azure Firewall; a traditional hub VNet uses a different UDR model.
7. AVS web applications can remain private behind Application Gateway, while separately approved workloads can use public IP on NSX Edge and DNAT.
8. Administrators connect through Azure Bastion to a private native Azure jump box, or use Standard+ IP-based RDP/SSH for a reachable AVS guest when appropriate.
9. The jump box manages vCenter and NSX over the Azure-side private path.
10. Domain controllers and DNS services operate locally in Azure and AVS while conditional forwarding links the namespaces.
11. If the VPN fails, cross-environment communication is interrupted, but Azure-local and AVS-local authentication and name resolution continue.

### Core Dependencies

- A Standard vWAN tier for the presented vWAN-based topology
- A correctly sized active-active VPN gateway
- Compatible IPsec and IKE policies
- Stable BGP adjacency and nonoverlapping prefixes, or complete manual route maintenance when BGP is intentionally disabled
- An ExpressRoute gateway in the virtual hub
- A valid AVS authorization key and circuit identifier
- Supported central routing and firewall controls
- Private administrative access through Bastion, with a jump box for vCenter/NSX web tooling where needed
- Distributed identity and DNS services
- A migration plan based on sustained throughput and workload behavior

### Primary Risks

- Underestimating migration duration
- Attempting live migration of an unsuitable workload
- Undersizing gateway capacity
- BGP or APIPA misconfiguration
- Policy-based selector omissions
- Testing before route convergence
- Creating asymmetric firewall routing
- Overriding managed-gateway control-plane routes
- Exposing management services publicly
- Depending exclusively on on-premises DNS and domain controllers

---


## Documentation and Interpretation Notes

- **Combined architecture patterns:** The transcript blended a Microsoft-managed Virtual WAN secured hub with a traditional customer-managed hub VNet. In the Virtual WAN pattern, use Firewall Manager, Virtual WAN route tables, and routing intent; the `GatewaySubnet` UDR warning applies to the separate traditional VNet gateway pattern.
- **BGP:** Microsoft recommends BGP for this topology and warns that missing manually maintained routes can prevent the HCX service mesh from forming, but the reviewed AVS vWAN article does not make BGP universally mandatory.
- **SQL FCI migration:** The documented Cold Migration requirement is driven by HCX’s lack of support for physical SCSI bus sharing and requires a full cluster shutdown and shared-storage reconfiguration.
- **Migration arithmetic:** Five decimal terabytes at an ideal 500 Mbps is 22.22 hours. A duration over 24 hours requires binary sizing and/or real-world efficiency losses.
- **AVS ingress:** Application Gateway is the preferred Microsoft method for web applications, not the only supported ingress method. Public IP on NSX Edge supports direct inbound and outbound connectivity.
- **Azure Bastion:** Bastion does not require the Azure VM agent. Standard or higher supports IP-based RDP/SSH to reachable non-Azure targets, but a private jump box remains useful for vCenter, NSX Manager, and administrative tooling.
- **DNS:** AD-integrated DNS zones and Azure Private DNS zones are separate. Use Azure DNS Private Resolver or explicit forwarding components to bridge them.
- **Resilience interpretation:** Local DNS and domain controllers reduce dependence on the VPN but do not guarantee full application functionality during a partition; cross-environment dependencies and AD replication remain affected.

## Image Sources

The following official documentation images were identified as materially relevant. The original assets could not be downloaded reliably in this execution environment, so no local image paths were inserted or fabricated.

| Local file | Description | Microsoft documentation page | Original image URL |
|---|---|---|---|
| Not packaged | AVS site-to-site VPN through a Virtual WAN hub | [Configure a site-to-site VPN in vWAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway) | [Original PNG](https://learn.microsoft.com/en-us/azure/azure-vmware/media/create-ipsec-tunnel/vpn-s2s-tunnel-architecture.png) |
| Not packaged | Application Gateway protecting AVS web applications | [Protect web apps on AVS with Application Gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway) | [Original PNG](https://learn.microsoft.com/en-us/azure/azure-vmware/media/application-gateway/app-gateway-protects.png) |
| Not packaged | Public IP connectivity through NSX Edge | [Turn on public IP addresses on NSX Edge](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-public-ip-nsx-edge) | [Original PNG](https://learn.microsoft.com/en-us/azure/azure-vmware/media/public-ip-nsx-edge/architecture-internet-access-avs-public-ip.png) |
| Not packaged | Distributed DNS Private Resolver hub-and-spoke architecture | [Private resolver architecture](https://learn.microsoft.com/en-us/azure/dns/private-resolver-architecture) | [Original PNG](https://learn.microsoft.com/en-us/azure/dns/media/private-resolver-architecture/hub-and-spoke-ruleset.png) |

---

## 17. Forward-Looking Design Consideration

The transcript closes by asking whether future hybrid-cloud architectures may rely increasingly on intelligent encrypted overlays rather than rigid dedicated circuits. Faster internet backbones and software-defined WAN technologies can dynamically steer traffic, respond to jitter, and optimize paths.

The immediate architecture still treats the VPN as a constraint. The longer-term design question is whether applications and platforms are sufficiently network-agnostic to continue operating when the transport changes, degrades, or becomes temporarily unavailable.

A resilient architecture should therefore avoid assuming that any single network path will always provide perfect latency or uninterrupted reachability. Local services, asynchronous application behavior, distributed identity, fault-tolerant DNS, controlled reconvergence, and recoverable management operations are valuable whether the transport is VPN, ExpressRoute, SD-WAN, or a future hybrid fabric.
