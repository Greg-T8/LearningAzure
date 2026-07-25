# Enterprise AVS over Site-to-Site VPN
## Detailed Outline with Microsoft Documentation Links

> **Documentation alignment note:** The transcript combines two related but distinct Azure network patterns: (1) an Azure VMware Solution connection through a **Standard Azure Virtual WAN hub** with site-to-site VPN and an ExpressRoute gateway, and (2) a **self-managed hub VNet** containing Azure Firewall, Application Gateway, Bastion, jump boxes, and identity/DNS VMs. A Virtual WAN hub is Microsoft-managed and doesn't provide customer subnets for arbitrary VMs or Application Gateway. In a Virtual WAN implementation, those resources should normally be placed in connected shared-services spoke VNets; Azure Firewall can be deployed as a secured virtual hub and traffic steering can use routing intent. See [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway), [Virtual WAN hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/hub-spoke-virtual-wan-architecture), [Firewall Manager architecture options](https://learn.microsoft.com/en-us/azure/firewall-manager/vhubs-and-vnets), and [What is a secured virtual hub?](https://learn.microsoft.com/en-us/azure/firewall-manager/secured-virtual-hub).

> **Source convention:** Links point primarily to Microsoft Learn. Points that describe the transcript's analogy, arithmetic, or operational interpretation—but aren't explicitly stated in Microsoft documentation—are labeled **Transcript-derived**.

---

## I. Scenario and Architectural Objective

### A. Migration mandate

1. An infrastructure architect receives an urgent requirement to migrate a mission-critical workload into Azure VMware Solution; AVS supplies dedicated bare-metal Azure infrastructure running VMware vSphere, vSAN, vCenter Server, and NSX. [What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
2. The example workload includes an approximately 5 TB SQL Server database and a weekend migration window. **Transcript-derived scenario;** Microsoft guidance requires migration planning based on database size, criticality, network speed, and approved downtime. [Migrate a SQL Server standalone instance to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-standalone-cluster) and [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)
3. AVS is selected to preserve the VMware operating model while moving workloads to Microsoft-managed dedicated infrastructure. [Azure VMware Solution overview](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
4. VMware HCX is the primary migration platform for moving vSphere workloads into the AVS private cloud. [Install VMware HCX in AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/install-vmware-hcx) and [HCX migration considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)

### B. Loss of the standard external connectivity option

1. A dedicated customer ExpressRoute circuit isn't available because of cost, timing, or provider availability. **Transcript-derived business constraint;** compare the supported AVS connectivity patterns in [AVS network and interconnectivity concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking) and [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke).
2. The on-premises edge must therefore connect through an IPsec/IKE site-to-site VPN terminating in an Azure Virtual WAN hub. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
3. The Virtual WAN hub contains both a site-to-site VPN gateway and an ExpressRoute gateway; the VPN reaches the hub externally, while the ExpressRoute gateway connects the hub to the AVS private cloud. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

### C. Design goals

1. Use a Microsoft-supported AVS-over-VPN topology that meets HCX minimum network requirements. [AVS hub-and-spoke architecture—S2S VPN considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke) and [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. Size the VPN gateway for aggregate branch and migration throughput rather than assuming the internet circuit's nominal speed will be achieved end to end. [Create a Virtual WAN site-to-site connection](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
3. Use BGP to dynamically exchange routes and avoid missing HCX network prefixes. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
4. Segment traffic among on-premises, Azure spokes, AVS management networks, and AVS workload segments. [Integrate AVS in a hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
5. Provide secure web publishing and administrative access without exposing AVS VMs or management endpoints directly to the internet. [Protect AVS web apps with Application Gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway) and [Access an AVS private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-access-private-cloud)
6. Localize identity and DNS services so an interruption of the on-premises VPN doesn't make the Azure or AVS environment wholly dependent on on-premises name resolution. [AVS hub-and-spoke DNS and identity considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)

---

## II. ExpressRoute versus Site-to-Site VPN

### A. Transportation analogy

1. ExpressRoute is presented as a private multilane highway, while an IPsec VPN is presented as a more constrained public road. **Transcript-derived analogy;** see [ExpressRoute overview](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction) and [VPN Gateway overview](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways).
2. The analogy illustrates that a VPN can provide connectivity but requires more conservative migration-window and performance planning. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)

### B. ExpressRoute characteristics

1. ExpressRoute extends on-premises networks into Microsoft cloud services through private connectivity supplied by a connectivity provider. [ExpressRoute overview](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction)
2. ExpressRoute traffic doesn't traverse the public internet and is typically used when private, predictable hybrid connectivity is required. [ExpressRoute overview](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction)
3. AVS uses an ExpressRoute circuit as part of its connection to Azure networking, including when a Virtual WAN VPN is the external on-premises path. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

### C. Site-to-site VPN characteristics

1. A site-to-site connection uses IPsec/IKE to connect an on-premises VPN device with Azure. [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
2. The on-premises VPN device requires a public-facing IP address for the documented AVS Virtual WAN design. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
3. Effective performance depends on the customer internet connection, VPN-device capacity, IPsec settings, gateway scale, path quality, and competing traffic. [VPN Gateway design](https://learn.microsoft.com/en-us/azure/vpn-gateway/design) and [Virtual WAN gateway settings](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
4. Latency, jitter, packet loss, and internet congestion are practical VPN risks. **General network behavior;** Microsoft specifically recommends ExpressRoute for large production databases and downtime-sensitive FCI migrations. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)

### D. Supportability for AVS

1. Connectivity to AVS through Azure site-to-site VPN is supported when the connection satisfies HCX minimum network requirements. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
2. Microsoft documents both VPN and ExpressRoute as possible network configurations for SQL Server FCI migration to AVS. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)
3. Because of limited bandwidth, HCX over VPN is typically suited to workloads that can sustain longer downtime, such as nonproduction workloads. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)
4. Microsoft recommends ExpressRoute for production environments, large databases, and migrations that must minimize downtime. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)

---

## III. VMware HCX Migration Considerations

### A. Role of VMware HCX

1. HCX is an application-mobility platform for simplifying migration and workload movement between vSphere environments and AVS. [Install VMware HCX in AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/install-vmware-hcx)
2. HCX uses HCX Cloud Manager in AVS and HCX Connector in the source environment. [Install VMware HCX in AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/install-vmware-hcx)
3. An HCX Service Mesh connects the sites and can provide Layer 2 network extension. [HCX migration considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)
4. Layer 2 extension can preserve workload IP addressing during migration when the design and operational requirements justify it. [Create an HCX network extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension)

### B. Migration profiles

1. HCX Enterprise supports Cold Migration, HCX vMotion, Bulk Migration, Replication Assisted vMotion, and OS Assisted Migration. [HCX migration considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)
2. Cold Migration has long downtime and is intended for smaller-scale powered-off VM copies. [HCX migration considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)
3. HCX vMotion provides no planned application downtime but performs serial, smaller-scale migrations. [HCX migration considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)
4. Bulk Migration supports parallel migration at the largest scale with a short source shutdown and destination startup period. [HCX migration considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)
5. Replication Assisted vMotion supports parallel, larger-scale migrations without planned downtime. [HCX migration considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)

### C. Network dependency

1. HCX doesn't eliminate bandwidth, latency, or reachability constraints; the service mesh depends on all required network segments and routes being available. [Install VMware HCX in AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/install-vmware-hcx) and [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. When BGP is disabled, administrators must manually maintain every advertised subnet, and a missed subnet can prevent the HCX service mesh from forming. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
3. Migration planning should be based on measured sustained throughput, not only nominal ISP or gateway limits. [Migrate a SQL Server standalone instance to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-standalone-cluster)

---

## IV. HCX vMotion over a VPN

### A. Live migration behavior

1. HCX vMotion is documented as a migration method with no planned migration downtime and is validated for standalone SQL Server migration to AVS. [HCX migration considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate) and [Migrate a SQL Server standalone instance to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-standalone-cluster)
2. For standalone SQL Server, the database remains available during vMotion, but Microsoft recommends avoiding critical data commits during the migration. [Migrate a SQL Server standalone instance to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-standalone-cluster)
3. Microsoft recommends performing the migration during off-peak hours within a preapproved change window. [Migrate a SQL Server standalone instance to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-standalone-cluster)

### B. Dirty-memory-page explanation

1. The transcript explains vMotion as an iterative memory-copy process in which pages changed during copying must be retransmitted. **Transcript-derived VMware technical explanation; no directly equivalent Microsoft Learn passage was identified.** Related migration guidance: [HCX migration considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate).
2. The transcript characterizes migration success as a race between the workload's memory-change rate and the available network throughput. **Transcript-derived interpretation;** validate actual workload suitability through testing and the HCX/Broadcom requirements referenced by [AVS S2S VPN considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke).

### C. Operational controls

1. Schedule vMotion during low-activity periods. [Migrate a SQL Server standalone instance to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-standalone-cluster)
2. Avoid major reports, batch jobs, index maintenance, bulk imports, and other high-change operations during migration. **Operational elaboration based on Microsoft's recommendation not to commit critical data during migration.** [Migrate a SQL Server standalone instance to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-standalone-cluster)
3. Test the migration method using representative workload activity and measured tunnel performance before the production change. [HCX migration considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)

---

## V. SQL Server Failover Cluster Instance Migration

### A. FCI architecture and limitation

1. A SQL Server Always On Failover Cluster Instance consists of clustered nodes and shared storage coordinated through Windows Server Failover Clustering. [SQL Server FCI overview](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/failover-cluster-instance-overview)
2. HCX doesn't support migration of VMs with SCSI controllers configured in physical sharing mode, which affects traditional shared-disk FCI configurations. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)
3. Microsoft provides a procedure that changes the shared-storage configuration as part of the migration and uses HCX Cold Migration. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)

### B. Required migration method

1. Plan a full shutdown of the cluster. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)
2. Back up the databases and cluster VMs and document storage, network, and WSFC configuration before migration. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)
3. Ensure all SQL Server and dependent workload network segments are extended to AVS. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)
4. Migrate all cluster nodes through HCX Cold Migration. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)
5. Validate shared storage, quorum, node communication, SQL services, and client connectivity after startup. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)

### C. Downtime implications

1. Microsoft categorizes FCI migration downtime as high because all cluster nodes are shut down and cold-migrated. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)
2. Downtime depends on database size and the private network's effective speed to Azure. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)
3. The migration should occur during off-peak hours under an approved change window. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)
4. Quorum and witness placement must be reviewed for datacenter-extension, datacenter-exit, disaster-recovery, and modernization scenarios. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)

---

## VI. Migration-Window Capacity Example

### A. Example calculation

1. The transcript uses a 5 TB workload and a 500 Mbps tunnel to demonstrate the minimum theoretical transfer time. **Transcript-derived arithmetic; no specific Microsoft Learn transfer-time estimate is provided.** Use a calculation based on measured sustained throughput rather than treating gateway capacity as guaranteed application throughput.
2. At an idealized continuous 500 Mbps, 5 TB requires approximately 22-24 hours depending on decimal versus binary units; protocol overhead and interruptions extend the duration. **Calculated example, not a Microsoft-published AVS estimate.**
3. Microsoft states that SQL migration downtime depends on database size and network speed. [Migrate a SQL Server standalone instance to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-standalone-cluster) and [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)

### B. Planning inputs

1. Calculate total VM storage transferred, not only the logical database size. [HCX migration considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)
2. Measure sustained encrypted throughput during the proposed migration window. [VPN Gateway design](https://learn.microsoft.com/en-us/azure/vpn-gateway/design)
3. Include retransmissions, packet loss, internet congestion, IPsec overhead, and competing business traffic in the safety margin. **Network-planning factors;** see [VPN Gateway design](https://learn.microsoft.com/en-us/azure/vpn-gateway/design).
4. Reserve time for application validation, cluster checks, DNS convergence, business testing, and rollback. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)

---

## VII. Azure Virtual WAN as the Connectivity Foundation

### A. Traditional hub-and-spoke limitations

1. VNet peering is nontransitive; a spoke can't reach another spoke through a self-managed hub without explicit routing or direct peering. [Hub-and-spoke network topology](https://learn.microsoft.com/en-us/azure/networking/design-guide/hub-spoke)
2. A growing self-managed hub-and-spoke topology requires the customer to manage peerings, route tables, appliances, and transit behavior. [Virtual WAN hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/hub-spoke-virtual-wan-architecture)
3. Virtual WAN provides a Microsoft-managed alternative with centralized routing and built-in transit among connected endpoints. [Virtual WAN hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/hub-spoke-virtual-wan-architecture)

### B. Role of Virtual WAN

1. Virtual WAN aggregates site-to-site VPN, point-to-site VPN, ExpressRoute, VNet, and SD-WAN connectivity. [Virtual WAN FAQ](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq)
2. A Standard Virtual WAN connects its hubs in a full mesh and supports any-to-any connectivity among supported spoke types. [Virtual WAN FAQ](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq)
3. The virtual hub is the regional routing and connectivity core. [About virtual hub settings](https://learn.microsoft.com/en-us/azure/virtual-wan/hub-settings)
4. Connected VNets host customer workloads and shared services; they aren't replaced by Virtual WAN. [Virtual WAN hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/hub-spoke-virtual-wan-architecture)

---

## VIII. Virtual WAN and Virtual Hub Structure

### A. Virtual WAN object

1. The Virtual WAN resource is global, although a resource location is selected for management and metadata. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. It acts as a container for one or more regional virtual hubs. [About virtual hub settings](https://learn.microsoft.com/en-us/azure/virtual-wan/hub-settings)

### B. Virtual hub

1. A virtual hub is a Microsoft-managed virtual network that can contain site-to-site VPN, point-to-site VPN, and ExpressRoute gateways. [About virtual hub settings](https://learn.microsoft.com/en-us/azure/virtual-wan/hub-settings)
2. The minimum hub address space is `/24`. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
3. Microsoft recommends `/23` or larger for future scalability, and `/22` or larger when Azure Firewall must scale to maximum throughput. [About virtual hub settings](https://learn.microsoft.com/en-us/azure/virtual-wan/hub-settings)
4. The hub address range must not overlap connected VNets, on-premises networks, or other hubs in the same Virtual WAN. [About virtual hub settings](https://learn.microsoft.com/en-us/azure/virtual-wan/hub-settings)
5. The address range can't be changed after hub creation, so future service and gateway capacity must be considered in advance. [About virtual hub settings](https://learn.microsoft.com/en-us/azure/virtual-wan/hub-settings)

### C. Workload and shared-service placement

1. Native Azure workloads remain in connected spoke VNets. [Virtual WAN hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/hub-spoke-virtual-wan-architecture)
2. In a Virtual WAN design, deploy jump boxes, Bastion, Application Gateway, DNS Private Resolver, domain controllers, and other customer VMs in connected shared-services VNets—not inside the managed virtual hub. [Firewall Manager architecture options](https://learn.microsoft.com/en-us/azure/firewall-manager/vhubs-and-vnets) and [Hub-and-spoke network topology](https://learn.microsoft.com/en-us/azure/networking/design-guide/hub-spoke)
3. Azure Firewall can be integrated into the managed hub by converting it to a secured virtual hub. [What is a secured virtual hub?](https://learn.microsoft.com/en-us/azure/firewall-manager/secured-virtual-hub)

---

## IX. Standard versus Basic Virtual WAN

### A. Basic limitations

1. Basic Virtual WAN supports site-to-site VPN and limited branch connectivity within a single hub. [Virtual WAN hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/hub-spoke-virtual-wan-architecture)
2. Basic hubs can only be used for site-to-site connections. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
3. Basic doesn't supply the ExpressRoute gateway capability required to patch the AVS private cloud into the Virtual WAN hub. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

### B. Standard requirements and benefits

1. Microsoft explicitly instructs customers to select **Standard** for the documented AVS-over-site-to-site-VPN configuration. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. Standard supports site-to-site VPN, point-to-site VPN, ExpressRoute, VNet connectivity, centralized routing, and full-mesh hub connectivity. [Virtual WAN FAQ](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq)
3. The AVS design requires an ExpressRoute gateway in the Virtual WAN hub even when no customer-provided external ExpressRoute circuit connects the datacenter. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

---

## X. Virtual WAN Site-to-Site VPN Gateway

### A. Gateway deployment

1. Enable the site-to-site VPN gateway while creating or updating the virtual hub. [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
2. Azure deploys redundant gateway instances and manages their public IP addresses. [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
3. Hub and gateway provisioning can take approximately 30 minutes. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

### B. Gateway scale units

1. Scale units select the aggregate throughput capacity of the Virtual WAN VPN gateway. [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
2. One scale unit represents 500 Mbps and deploys two redundant instances, each with a maximum throughput of 500 Mbps. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
3. The two instances provide redundancy; the documentation doesn't state that a single flow automatically combines them into a 1 Gbps tunnel. [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
4. Capacity planning must consider the combined traffic of all branches and migration operations connected to the hub. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

### C. Aggregate-capacity example

1. The transcript's 200 Mbps headquarters plus fifty 10 Mbps branches equals 700 Mbps of potential aggregate demand. **Transcript-derived arithmetic;** compare with Microsoft's branch aggregation example in [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal).
2. A one-scale-unit 500 Mbps gateway would be below that planned aggregate demand. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
3. Select enough scale units for expected peak load and allow headroom for encryption, bursts, failover, and migration traffic. [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)

---

## XI. Internet Routing Preference

### A. Available choices

1. The Virtual WAN VPN gateway supports routing preference through either the Microsoft network or the ISP network. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. Microsoft network routing is also called cold-potato routing; ISP routing is also called hot-potato routing. [Routing preference overview](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
3. The service assigns the Virtual WAN public IP based on the selected routing option. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

### B. Microsoft network routing

1. Microsoft network routing keeps traffic on Microsoft's global backbone for more of the route. [Routing preference overview](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
2. This option is the performance-oriented choice when path consistency is more important than minimizing egress cost. [Routing preference overview](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
3. The transcript recommends it for HCX migrations to reduce exposure to variable ISP paths. **Architectural recommendation inferred from routing behavior; Microsoft doesn't publish an HCX-specific mandate to select this option.** [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

### C. Distinguish two routing-preference settings

1. **VPN gateway routing preference** chooses Microsoft-network versus ISP-network handling of the gateway public IP. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. **Virtual hub routing preference** chooses how the hub selects among routes learned from ExpressRoute, VPN, and other sources; its options include ExpressRoute, VPN, and AS Path. [Virtual hub routing preference](https://learn.microsoft.com/en-us/azure/virtual-wan/about-virtual-hub-routing-preference)
3. The documented AVS S2S procedure says to leave hub routing preference at the default **ExpressRoute** unless a specific requirement dictates otherwise. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

---

## XII. VPN Site and Device Configuration

### A. VPN site object

1. A Virtual WAN VPN site represents an on-premises location and its physical links. [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
2. Each site includes the site name, region, private address space when BGP isn't used, and one or more link definitions. [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
3. A site can include multiple links for separate ISPs or edge paths. [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)

### B. Device-vendor field

1. The portal asks for the VPN device vendor, such as Cisco, Citrix, or Barracuda. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. Microsoft states that the information helps the Azure team understand the environment for future optimization and troubleshooting. [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
3. **Documentation correction:** Microsoft Learn doesn't state that selecting the vendor automatically changes Azure's IKE timers, algorithms, or negotiation behavior; that stronger claim in the transcript isn't directly supported by the cited page. [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)

---

## XIII. BGP as the Preferred Routing Component

### A. Purpose of BGP

1. BGP dynamically exchanges route prefixes between Azure and the on-premises VPN device. [BGP with Azure VPN Gateway](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-bgp-overview)
2. Each side uses an autonomous system number and BGP peer address. [BGP with Azure VPN Gateway](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-bgp-overview)
3. The Azure Virtual WAN gateway ASN is platform-managed and displayed in the hub configuration. [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
4. The on-premises ASN and peer configuration must be unique and compatible with the Azure configuration. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

### B. Importance for HCX

1. Microsoft states that BGP ensures AVS and on-premises servers advertise routes across the tunnel. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. If BGP is disabled, all required subnets must be maintained manually. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
3. If a required subnet is omitted, HCX can fail to form the service mesh. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
4. **Documentation nuance:** The page doesn't say BGP is technically mandatory in every case; it documents a static-routing alternative but warns of the operational risk. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

---

## XIV. APIPA BGP Peering Edge Case

### A. Default BGP peer addressing

1. Azure normally assigns the gateway's BGP address from its private gateway address space. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. The on-premises BGP peer address must be distinct from the VPN device's public address and the site's advertised address space. [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)

### B. APIPA behavior

1. APIPA addresses use the `169.254.0.0/16` range. [APIPA overview](https://learn.microsoft.com/en-us/windows-server/troubleshoot/how-to-use-automatic-tcpip-addressing-without-a-dh)
2. A custom Azure APIPA BGP address is needed when the on-premises VPN device uses an APIPA address as its BGP peer IP. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
3. Azure selects the custom APIPA address when the corresponding on-premises peer is configured with APIPA. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
4. If the peer uses a regular private address, Azure reverts to the gateway's normal private BGP address. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

---

## XV. Route-Based versus Policy-Based VPN

### A. Route-based VPN

1. Azure generally recommends route-based VPN gateways because they support broader and more flexible routing scenarios. [VPN Gateway design](https://learn.microsoft.com/en-us/azure/vpn-gateway/design)
2. Routing determines which prefixes traverse the tunnel rather than requiring a separate fixed encryption domain for each pair. [VPN Gateway design](https://learn.microsoft.com/en-us/azure/vpn-gateway/design)
3. Route-based VPN is the preferable model for dynamic BGP-driven AVS connectivity when the on-premises device supports it. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

### B. Policy-based VPN

1. The AVS Virtual WAN procedure includes an optional policy-based configuration. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. Policy-based traffic selectors require the on-premises and AVS networks, including hub ranges, to be specified as part of the encryption domain. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
3. The documented selectors include the Virtual WAN hub range, AVS private-cloud range, and any connected Azure VNet ranges. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
4. Missing a required prefix can prevent that traffic from matching the tunnel policy. [About policy-based traffic selectors](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-connect-multiple-policybased-rm-ps)

---

## XVI. IKE and IPsec Negotiation

### A. Supported protocols

1. The AVS Virtual WAN design supports IPsec site-to-site tunnels using IKEv1 or IKEv2. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. Microsoft allows custom IPsec policies for Virtual WAN VPN connections. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

### B. Negotiation phases

1. IKE Phase 1 establishes the IKE security association and authenticates the peers. [About cryptographic requirements and Azure VPN gateways](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-compliance-crypto)
2. IKE Phase 2 negotiates the IPsec security associations used to protect data traffic. [About cryptographic requirements and Azure VPN gateways](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-compliance-crypto)
3. Both endpoints must use compatible encryption, integrity, Diffie-Hellman/PFS, and security-association lifetime settings. [Configure custom IPsec/IKE policies](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-ipsecikepolicy-rm-powershell)
4. AES-256 and SHA-256 are examples of supported algorithms, but the chosen combination must be supported and identically configured on both peers. [Configure custom IPsec/IKE policies](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-ipsecikepolicy-rm-powershell)

---

## XVII. End-to-End Path Before AVS Integration

1. The on-premises VPN device establishes an IPsec/IKE tunnel with the Virtual WAN site-to-site VPN gateway. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. The VPN site connects to the selected virtual hub. [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
3. BGP or static prefixes provide reachability between the site and the hub. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
4. At this point, the on-premises site can reach the hub, but the AVS ExpressRoute circuit must still be patched into the hub. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

---

## XVIII. Why AVS Still Requires ExpressRoute Internally

### A. Nature of AVS

1. AVS consists of dedicated bare-metal hosts running VMware vSphere, vSAN, vCenter Server, and NSX. [What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
2. AVS VMs aren't native Azure IaaS VM objects. [Azure VMware Solution FAQ](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
3. Connectivity from Azure networking into the AVS private cloud uses the AVS ExpressRoute circuit. [Configure networking for an AVS private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-configure-networking)

### B. Dual-gateway design

1. The Virtual WAN hub's VPN gateway terminates the external on-premises VPN. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. The hub's ExpressRoute gateway connects to the AVS private-cloud ExpressRoute circuit. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
3. The requirement for both gateway types is why the documented architecture requires Standard Virtual WAN. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

---

## XIX. Connecting the Virtual Hub to AVS

### A. Request authorization from AVS

1. Open the AVS private cloud and select **Manage > Connectivity > ExpressRoute**. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. Request an authorization key and assign it a name. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
3. Copy both the authorization key and ExpressRoute ID/peer-circuit URI. [Configure networking for an AVS private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-configure-networking)
4. Copy the values promptly because the authorization key disappears after a period of time. [Configure networking for an AVS private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-configure-networking)

### B. Redeem authorization in Virtual WAN

1. Open the Virtual WAN ExpressRoute gateway and select **Redeem authorization key**. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. Paste the authorization key and peer-circuit URI. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
3. Select automatic association with the hub when appropriate and add the connection. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
4. The completed path is on-premises VPN device → Virtual WAN VPN gateway → virtual hub router → Virtual WAN ExpressRoute gateway → AVS ExpressRoute circuit → AVS management/workload networks. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

---

## XX. BGP Convergence after AVS Authorization

1. Microsoft recommends waiting approximately five minutes before testing connectivity after establishing the AVS ExpressRoute link. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. The transcript attributes the wait to route propagation and BGP convergence across AVS, ExpressRoute, the hub router, the VPN gateway, and the on-premises edge. **Reasonable routing interpretation; the five-minute wait is documented, while the detailed convergence narrative is transcript-derived.** [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
3. Test by creating an NSX segment and a VM and then validating reachability between on-premises and AVS endpoints. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
4. Don't immediately dismantle the connection if the first test occurs before the documented convergence interval. **Operational recommendation based on the documented wait.**

---

## XXI. Zero-Trust Security and Network Segmentation

### A. Lateral-movement risk

1. Hybrid reachability should not imply unrestricted communication among on-premises systems, Azure spokes, AVS workloads, and the AVS management plane. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
2. Azure Firewall or another supported NVA can enforce traffic rules between Azure spokes and AVS networks. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
3. NSGs provide a second layer of segmentation within native Azure VNets. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
4. AVS NSX distributed and gateway firewall rules provide segmentation within the private cloud. [AVS workload networking concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking)

### B. Virtual WAN security model

1. A Virtual WAN hub with Azure Firewall and associated policies is a secured virtual hub. [What is a secured virtual hub?](https://learn.microsoft.com/en-us/azure/firewall-manager/secured-virtual-hub)
2. Routing intent can direct private and internet traffic to the selected security solution. [Virtual WAN routing intent](https://learn.microsoft.com/en-us/azure/virtual-wan/how-to-routing-policies)
3. In a secured virtual hub, customers generally don't need to maintain traditional spoke UDRs solely to route traffic through Azure Firewall. [What is a secured virtual hub?](https://learn.microsoft.com/en-us/azure/firewall-manager/secured-virtual-hub)
4. Routing intent must be configured when branch-to-branch or inter-hub traffic must be inspected. [What is a secured virtual hub?](https://learn.microsoft.com/en-us/azure/firewall-manager/secured-virtual-hub)

### C. Traditional self-managed hub VNet model

1. In a self-managed hub VNet, route tables and UDRs can direct spoke traffic to Azure Firewall. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
2. A route for AVS management and workload prefixes can use the firewall private IP as the virtual-appliance next hop. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
3. Return routing must be designed symmetrically so a stateful firewall sees both directions of the flow. [Azure Firewall multi-hub and spoke routing](https://learn.microsoft.com/en-us/azure/firewall/firewall-multi-hub-spoke)

---

## XXII. User-Defined Routes

1. UDRs override or supplement Azure system routes for selected destination prefixes. [Azure virtual network traffic routing](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview)
2. In the traditional AVS hub-VNet architecture, spoke routes can direct AVS-bound traffic to Azure Firewall for allow/deny evaluation. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
3. Use specific AVS management and workload prefixes where appropriate rather than unintentionally overriding all hub-local traffic. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
4. In Virtual WAN secured-hub designs, use routing intent and hub route policies instead of automatically transplanting the self-managed UDR pattern. [What is a secured virtual hub?](https://learn.microsoft.com/en-us/azure/firewall-manager/secured-virtual-hub)

---

## XXIII. Critical Warning: Don't Apply `0.0.0.0/0` to the Gateway Subnet

1. `0.0.0.0/0` is the default route that matches destinations not covered by a more-specific route. [Azure virtual network traffic routing](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview)
2. Microsoft explicitly states that a route with prefix `0.0.0.0/0` on `GatewaySubnet` isn't supported. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
3. Microsoft also warns not to associate a route table containing `0.0.0.0/0` with the gateway subnet of a VNet connected to Azure VPN Gateway. [Manage Azure route tables](https://learn.microsoft.com/en-us/azure/virtual-network/manage-route-table)
4. Gateways require direct access to Azure management controllers, and unsupported routes can affect the control path, data path, diagnostics, and gateway health. [VPN Gateway configuration settings](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings)
5. Apply forced-routing policies to workload subnets or use supported Virtual WAN routing intent rather than hijacking the gateway subnet's platform traffic. [Securing internet access with Virtual WAN routing intent](https://learn.microsoft.com/en-us/azure/virtual-wan/about-internet-routing)

---

## XXIV. Publishing AVS Web Applications to the Internet

### A. AVS VM addressing limitation

1. AVS VMs aren't native Azure IaaS objects. [Azure VMware Solution FAQ](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
2. Native Azure services that require Azure VM resource objects can't necessarily target AVS VMs in the same way they target Azure IaaS VMs. [Azure VMware Solution FAQ](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
3. Microsoft documents Application Gateway as the supported/preferred method to expose web applications running on AVS VMs. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke) and [Protect AVS web apps with Application Gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway)

### B. Application Gateway placement

1. Application Gateway is a Layer 7 web traffic load balancer with URL routing, session affinity, and optional WAF capabilities. [Protect AVS web apps with Application Gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway)
2. In a self-managed hub VNet, it can be deployed in a dedicated hub subnet. [Protect AVS web apps with Application Gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway)
3. In a Virtual WAN architecture, deploy Application Gateway in a connected VNet—typically an ingress or shared-services spoke—because Application Gateway isn't deployed into the Microsoft-managed virtual hub. [Firewall Manager architecture options](https://learn.microsoft.com/en-us/azure/firewall-manager/vhubs-and-vnets)
4. Configure AVS web servers as backend targets reachable through private connectivity. [Protect AVS web apps with Application Gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway)

### C. Request processing and WAF

1. Clients connect to the Application Gateway frontend listener. [How Application Gateway works](https://learn.microsoft.com/en-us/azure/application-gateway/how-application-gateway-works)
2. When WAF is enabled, the gateway evaluates request headers and bodies against WAF rules. [How Application Gateway works](https://learn.microsoft.com/en-us/azure/application-gateway/how-application-gateway-works)
3. TLS can terminate at Application Gateway or be configured for end-to-end TLS, depending on listener and backend settings. [Application Gateway end-to-end TLS](https://learn.microsoft.com/en-us/azure/application-gateway/ssl-overview)
4. The AVS backend remains privately addressed and doesn't need direct public exposure. [Protect AVS web apps with Application Gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway)

---

## XXV. Secure Administrative Access

### A. Jump-box pattern

1. Microsoft documents using a Windows VM as a jump box to access AVS vCenter Server and NSX Manager. [Access an AVS private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-access-private-cloud)
2. Configure **Public inbound ports: None** for the jump-box VM. [Access an AVS private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-access-private-cloud)
3. Don't assign the jump box a public IP or expose TCP 3389 directly to the public internet. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
4. In a Virtual WAN implementation, place the jump box in a connected shared-services or management VNet rather than in the managed hub. [Virtual WAN hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/hub-spoke-virtual-wan-architecture)

### B. Azure Bastion

1. Azure Bastion provides RDP/SSH connectivity to Azure VMs over TLS, commonly through TCP 443. [What is Azure Bastion?](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview)
2. Target Azure VMs don't require a public IP, agent, or special client software for portal-based access. [What is Azure Bastion?](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview)
3. Connect to the Azure jump box through Bastion and then browse privately to AVS vCenter Server or NSX Manager. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
4. Bastion can be shared across peered VNets with the appropriate SKU and network design. [Hub-and-spoke network topology](https://learn.microsoft.com/en-us/azure/networking/design-guide/hub-spoke)

---

## XXVI. Why Bastion Can't Connect Directly to AVS VMs

1. Microsoft explicitly states that Azure Bastion can't connect directly to AVS VMs because they aren't Azure IaaS objects. [Azure VMware Solution FAQ](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
2. Bastion instead connects to a native Azure jump box. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
3. The jump box then connects to AVS management endpoints or workload VMs through private routing and the protocols those endpoints support. [Access an AVS private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-access-private-cloud)
4. This pattern keeps AVS management interfaces private while providing a controlled administration path. [Access an AVS private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-access-private-cloud)

---

## XXVII. Bastion as a Mitigation for VPN Instability

1. The management session between the Azure jump box and AVS remains on private Azure connectivity rather than traversing the on-premises site-to-site VPN. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
2. The administrator's Bastion connection reaches the Azure VM over TLS. [What is Azure Bastion?](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview)
3. This reduces the amount of latency-sensitive vCenter/NSX management traffic that must cross the on-premises VPN. **Architectural inference from the documented topology.**
4. The transcript states that a task initiated on the jump box can continue if the administrator's local connection briefly drops. **Operational inference; not explicitly guaranteed by the cited Bastion documentation.** [What is Azure Bastion?](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview)

---

## XXVIII. DNS as a Critical Dependency

1. AVS management components, AVS workloads, Azure workloads, and on-premises systems require consistent forward and reverse name resolution. [Configure an AVS DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution)
2. AVS management components can use NSX DNS forwarding rules to resolve privately hosted DNS namespaces. [Configure an AVS DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution)
3. Azure Private DNS provides private DNS zones linked to one or more VNets. [Azure Private DNS overview](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone)
4. Azure DNS Private Resolver supports hybrid DNS forwarding between Azure and on-premises without requiring customer-managed DNS forwarder VMs solely for that function. [Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver)

---

## XXIX. Domain Controllers in Azure

1. The AVS hub-and-spoke guidance recommends deploying domain-controller and DNS capability in Azure rather than relying exclusively on on-premises servers. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
2. For DNS, Microsoft recommends existing AD-integrated DNS on at least two Azure VMs in the hub/shared-services network. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
3. For identity, the same page recommends at least one domain controller in the hub and using zones or an availability set for resilience; in practice, two DCs avoid a single-server dependency. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke) and [Extend AD DS to Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/identity/adds-extend-domain)
4. In Virtual WAN, deploy these VMs in a connected identity/shared-services VNet rather than inside the managed virtual hub. [Virtual WAN hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/hub-spoke-virtual-wan-architecture)
5. Configure spoke VNets to use the Azure-hosted DNS servers or a centralized DNS resolver architecture. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)

---

## XXX. Domain Controllers in AVS

1. Microsoft recommends deploying another domain controller on the AVS side to act as an identity and DNS source inside the vSphere environment. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
2. An AVS-local domain controller reduces authentication and DNS dependence on the site-to-site VPN. **Resilience rationale inferred from the documented placement recommendation.**
3. Avoid treating a single AVS domain controller as sufficient for all production resiliency requirements; design AD site topology, replication, DNS, and availability based on the organization's recovery objectives. [Extend AD DS to Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/identity/adds-extend-domain)
4. Configure NSX DNS forwarding so AVS management components and workloads can reach the required private DNS servers. [Configure an AVS DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution)

---

## XXXI. Azure Private DNS

1. Azure Private DNS hosts private DNS namespaces without requiring customers to operate authoritative DNS VMs for those zones. [Azure Private DNS overview](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone)
2. Private zones are resolvable only from linked VNets or through an integrated hybrid resolver path. [Azure Private DNS overview](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone)
3. A private DNS zone can link to multiple VNets. [Azure Private DNS overview](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone)
4. Auto-registration creates and removes A records for supported Azure VMs as their lifecycle changes. [DNS security and private name resolution](https://learn.microsoft.com/en-us/azure/networking/design-guide/dns-security)
5. A VNet can have auto-registration enabled for only one private DNS zone. [Azure Private DNS overview](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone)
6. A VNet can link to as many as 1,000 private DNS zones when auto-registration isn't enabled on those links. [Azure Private DNS overview](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone)
7. Custom DNS servers override Azure's default name-resolution sequence, so use conditional forwarding or DNS Private Resolver to reach linked private zones. [Azure Private DNS overview](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone)

---

## XXXII. Conditional DNS Forwarding

1. Conditional forwarding sends queries for a specific DNS suffix to a designated resolver. [Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver)
2. On-premises DNS servers can forward Azure private-zone queries to the inbound endpoint of Azure DNS Private Resolver. [Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver)
3. Azure DNS Private Resolver outbound endpoints and forwarding rulesets can send Azure queries to on-premises or other private DNS servers. [DNS security and private name resolution](https://learn.microsoft.com/en-us/azure/networking/design-guide/dns-security)
4. AVS NSX DNS Service can conditionally forward defined FQDN zones to Azure or on-premises private DNS servers. [Configure an AVS DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution)
5. For AVS Gen 2 private DNS management names, Microsoft documents using DNS Private Resolver or a DNS server in the AVS VNet and creating the required conditional forwarder from on-premises. [Configure AVS private and public DNS forward lookup zones](https://learn.microsoft.com/en-us/azure/azure-vmware/native-dns-forward-lookup-zone)
6. Don't configure on-premises DNS servers to query Azure's `168.63.129.16` address directly; use a resolver or forwarder inside Azure. [Troubleshoot Azure DNS conditional forwarders](https://learn.microsoft.com/en-us/troubleshoot/azure/dns/troubleshoot-azure-dns-resolution-fails-conditional-forwarder-misconfiguration)

---

## XXXIII. DNS Fault Tolerance during a VPN Outage

1. Relying exclusively on on-premises DNS makes Azure and AVS workloads dependent on the site-to-site VPN for name resolution. **Architectural risk inferred from the topology.**
2. Azure-hosted AD-integrated DNS or DNS Private Resolver provides local resolution paths for Azure VNets. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke) and [Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver)
3. An AVS-local domain controller and NSX DNS forwarding capability provide local identity and DNS services for VMware workloads. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke) and [Configure an AVS DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution)
4. Local services allow environments to continue resolving local dependencies during a WAN interruption, although cross-environment dependencies still fail until connectivity returns. **Resilience inference; validate against application dependency maps and recovery requirements.**
5. Design DNS servers, resolver endpoints, forwarding targets, and firewall rules redundantly; avoid a single DNS VM or single unreachable forwarding target. [DNS security and private name resolution](https://learn.microsoft.com/en-us/azure/networking/design-guide/dns-security)

---

## XXXIV. Final Architecture Summary

### A. Connectivity layer

1. Deploy a Standard Azure Virtual WAN. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. Create a regional virtual hub with adequate, nonoverlapping address space. [About virtual hub settings](https://learn.microsoft.com/en-us/azure/virtual-wan/hub-settings)
3. Deploy and size the site-to-site VPN gateway for aggregate throughput. [Virtual WAN site-to-site tutorial](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
4. Select Microsoft network or ISP routing preference based on performance and cost requirements; the transcript favors Microsoft network routing for migration stability. [Routing preference overview](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
5. Deploy an ExpressRoute gateway in the same hub. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
6. Redeem the AVS authorization key and associate the AVS ExpressRoute circuit with the hub. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

### B. Routing layer

1. Enable BGP whenever possible to dynamically advertise on-premises, Azure, AVS, and HCX routes. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
2. Configure unique ASNs and compatible BGP peer addresses. [BGP with Azure VPN Gateway](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-bgp-overview)
3. Configure custom APIPA BGP addresses only when the on-premises peer uses APIPA. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
4. Leave virtual hub routing preference at ExpressRoute unless a deliberate path-selection requirement justifies VPN or AS Path preference. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway) and [Virtual hub routing preference](https://learn.microsoft.com/en-us/azure/virtual-wan/about-virtual-hub-routing-preference)
5. Allow approximately five minutes for route propagation after linking AVS. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)

### C. Security layer

1. Use a secured Virtual WAN hub with Azure Firewall and routing intent, or explicitly document that a self-managed hub-VNet/UDR design is being used instead. [What is a secured virtual hub?](https://learn.microsoft.com/en-us/azure/firewall-manager/secured-virtual-hub) and [Firewall Manager architecture options](https://learn.microsoft.com/en-us/azure/firewall-manager/vhubs-and-vnets)
2. Segment AVS management and workload prefixes with Azure Firewall, NSGs, and NSX firewall policy as appropriate. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
3. Don't apply an unsupported `0.0.0.0/0` UDR to a gateway subnet. [Manage Azure route tables](https://learn.microsoft.com/en-us/azure/virtual-network/manage-route-table)
4. Place Application Gateway in a connected ingress/shared-services VNet for a Virtual WAN design and use AVS VMs as private backend targets. [Protect AVS web apps with Application Gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway)
5. Don't expose AVS management endpoints or the jump-box RDP port directly to the internet. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)

### D. Management layer

1. Deploy a native Azure jump box in a connected management/shared-services VNet. [Access an AVS private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-access-private-cloud)
2. Use Azure Bastion to reach the jump box through its private IP. [What is Azure Bastion?](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview)
3. Access vCenter Server and NSX Manager privately from the jump box. [Access an AVS private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-access-private-cloud)
4. Don't attempt to use Bastion directly against AVS VMs as though they were Azure IaaS VM resources. [Azure VMware Solution FAQ](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)

### E. Identity and DNS layer

1. Deploy resilient AD-integrated DNS/domain controllers in an Azure identity/shared-services VNet. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
2. Deploy an AVS-local domain controller for vSphere workload identity and DNS requirements. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
3. Use Azure Private DNS for Azure-private namespaces and auto-registration where appropriate. [Azure Private DNS overview](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone)
4. Use Azure DNS Private Resolver or supported DNS forwarders for hybrid namespace resolution. [Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver)
5. Configure NSX DNS forward zones for AVS management and workload resolution. [Configure an AVS DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution)

---

## XXXV. Closing Perspective

1. The architecture treats the lack of an external ExpressRoute circuit as a design constraint rather than assuming VPN performance is equivalent to private connectivity. [Migrate a SQL Server failover cluster to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)
2. Performance risk is mitigated through gateway sizing, routing preference, BGP, migration-method selection, and realistic downtime planning. [Configure a site-to-site VPN in Virtual WAN for AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway) and [HCX migration considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)
3. Availability risk is mitigated by localizing management, identity, and DNS services in Azure and AVS. [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
4. Security risk is mitigated through centralized inspection, routing intent or UDRs appropriate to the selected hub model, private administrative access, and Application Gateway/WAF for published web workloads. [What is a secured virtual hub?](https://learn.microsoft.com/en-us/azure/firewall-manager/secured-virtual-hub), [AVS hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke), and [Protect AVS web apps with Application Gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway)
5. The transcript's final prediction that SD-WAN and public encrypted transport might eventually displace dedicated circuits is speculative and isn't an AVS product recommendation. **Transcript-derived future-looking discussion;** current designs should follow documented workload, security, support, and SLA requirements.

---

## Primary Microsoft Learn References

- [Azure VMware Solution documentation](https://learn.microsoft.com/en-us/azure/azure-vmware/)
- [Configure a site-to-site VPN in Virtual WAN for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-site-to-site-vpn-gateway)
- [Integrate Azure VMware Solution in a hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-hub-and-spoke)
- [VMware HCX migration considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-migrate)
- [Migrate a SQL Server standalone instance to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-standalone-cluster)
- [Migrate a SQL Server Always On Failover Cluster Instance to AVS](https://learn.microsoft.com/en-us/azure/azure-vmware/migrate-sql-server-failover-cluster)
- [Protect AVS web apps with Azure Application Gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway)
- [Access an AVS private cloud through a jump box](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-access-private-cloud)
- [Configure an AVS DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution)
- [Azure Virtual WAN hub-and-spoke architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/hub-spoke-virtual-wan-architecture)
