# Azure VMware Solution Implementation Guide

## 1. Purpose and Deployment Context

Azure VMware Solution, or AVS, is positioned in the transcript as a bridge between traditional VMware vSphere data centers and native Azure infrastructure. The main implementation challenge is not simply deploying cloud capacity, but safely connecting two operational worlds without disrupting production workloads.

* **Purpose:** AVS provides VMware-based private clouds on Azure dedicated infrastructure, enabling familiar vSphere operations while integrating with Azure services. [What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
* **Use case:** AVS supports migration and operation of VMware workloads without requiring an immediate application refactor. [Azure VMware Solution overview](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
* **Implementation risk:** Mission-critical workloads, such as tier-one SQL servers processing thousands of credit card transactions per minute, require migration planning that avoids downtime, packet loss, routing failures, and storage exhaustion.
* **Consultant role:** The consultant must explain the AVS service model, identify hard limits, design networking and identity, plan migrations, and prepare day-two operations. [Plan the Azure VMware Solution deployment](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment)

> **Transcript-derived analogy:** The transcript compares AVS migration to docking an on-premises cruise ship to a high-speed Azure space station. The analogy emphasizes that AVS is not a standalone cloud server deployment; it is a hybrid integration project.

## 2. AVS Service Model and Core Architecture

AVS is not a supported nested-virtualization service. It provides VMware private clouds on dedicated bare-metal Azure infrastructure. [Azure VMware Solution private cloud and cluster concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds) [Microsoft Azure VMware Solution FAQ — nested virtualization](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)

* **Core behavior:** Microsoft provides dedicated bare-metal server hosts in Azure data centers. [Private cloud architectural components](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
* **Tenant isolation:** Private-cloud hosts and clusters are dedicated rather than shared with other customers. [Microsoft Azure VMware Solution FAQ — underlying infrastructure](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
* **Architectural interpretation:** Because each private cloud uses dedicated hosts, its workloads do not share those hosts with unrelated customers; actual performance still depends on sizing, contention within the customer environment, storage policy, and workload behavior. [Private cloud architectural components](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
* **Managed stack:** Azure automates deployment and management of the private-cloud hardware and VMware software stack. [Azure VMware Solution private cloud and cluster concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)

*Source for the managed VMware components: [Private cloud architectural components](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)*

| Component             | Role                                                       |
| --------------------- | ---------------------------------------------------------- |
| VMware vCenter Server | Central management plane for the VMware environment.       |
| VMware vSAN           | Software-defined storage that pools local physical drives. |
| VMware vSphere / ESXi | Compute virtualization layer.                              |
| VMware NSX            | Software-defined networking and security layer.            |

* **Minimum deployment:** A private cloud starts with a minimum three-host cluster. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)
* **Reason for minimum:** The transcript attributes the three-host minimum to vSAN quorum. Microsoft documents the three-host hard limit but does not state that quorum is the sole reason in the reviewed AVS articles. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)
* **Cluster maximum:** A single cluster can scale to 16 hosts. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)
* **Private cloud maximum:** A private cloud can contain up to 12 clusters and 96 ESXi hosts in total. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)

> **Transcript-derived calculation:**  
> Inputs: 12 clusters and 16 hosts per cluster.  
> Arithmetic: `12 × 16 = 192`; however, this is only a theoretical multiplication of two independent limits. Microsoft separately enforces a maximum of **96 ESXi hosts per private cloud**, so not all 12 clusters can simultaneously contain 16 hosts. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)

## 3. Host SKUs and Hardware Planning

Host SKU selection determines compute density, processor generation, memory capacity, migration compatibility, and future expansion constraints.

*The following values are corrected to the current Microsoft host specification table. [Hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#hosts)*

| SKU | Documented processor | Documented cores | Documented memory |
| --- | --- | ---: | ---: |
| AV36 | Dual Intel Xeon Gold 6140, Skylake | 36 physical / 72 logical | 576 GB |
| AV36P | Dual Intel Xeon Gold 6240, Cascade Lake | 36 physical / 72 logical | 768 GB |
| AV48 | Dual Intel Xeon Gold 6442Y, Sapphire Rapids | 48 physical / 96 logical | 1,024 GB |
| AV52 | Dual Intel Xeon Platinum 8270, Cascade Lake | 52 physical / 104 logical | 1,536 GB |
| AV64 | Dual Intel Xeon Platinum 8370C, Ice Lake | 64 physical / 128 logical | 1,024 GB |

*Source: [Hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#hosts). AV64 uses OSA in Generation 1 and ESA in Generation 2; AV48 uses ESA.*

* **AV64 prerequisite:** For Generation 1, an existing AV36, AV36P, AV48, or AV52 private cloud is required before adding a separate AV64 cluster. [Prerequisite for AV64 expansion on AV36, AV36P, and AV52](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#prerequisite-for-av64-expansion-on-av36-av36p-and-av52)
* **Expansion-only behavior:** Generation 1 requires the seed private cloud before AV64 expansion; Generation 2 can be deployed directly as a minimum three-host AV64 private cloud. [Introduction to Azure VMware Solution Generation 2 private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)
* **Operational implication:** This seed-cluster cost applies to Generation 1 AV64 expansion, not Generation 2. [Differences between Generation 1 and Generation 2](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)
* **Migration implication:** Adding AV64 to a Generation 1 private cloud creates a heterogeneous CPU environment and Microsoft explicitly identifies EVC issues between AV64 and the base-SKU clusters. [Enhanced vMotion Compatibility (EVC) with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension)

> **Documentation correction:** Microsoft documents AV36 as **Skylake**, AV36P and AV52 as **Cascade Lake**, AV48 as **Sapphire Rapids**, and AV64 as **Ice Lake**. [Hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#hosts)

## 4. Operational Responsibility Boundaries

AVS is managed infrastructure, but not a fully managed workload platform. Microsoft manages the foundational VMware infrastructure, while the customer manages virtual workloads and higher-level configuration.

* **Microsoft responsibilities:** Microsoft manages the physical infrastructure and lifecycle of ESXi, vCenter Server, vSAN, and NSX. [Azure VMware Solution responsibility matrix — Microsoft vs customer](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-responsibility-matrix---microsoft-vs-customer)
* **Customer responsibilities:** The customer manages guest operating systems, applications, workload VMs, vSAN policies, NSX workload networking, and third-party solutions within the permissions exposed by the service. [Azure VMware Solution responsibility matrix — Microsoft vs customer](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-responsibility-matrix---microsoft-vs-customer)
* **Access and SLA:** Microsoft restricts ESXi administrator/root access as part of the managed-service security and responsibility boundary. The reviewed documentation confirms the restriction, but does not state that the 99.9% SLA is its sole cause. [Azure VMware Solution identity concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity)
* **Access limitation:** Customers do not receive ESXi administrator/root access. [Microsoft Azure VMware Solution FAQ — ESXi administrator access](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
* **Third-party tool impact:** Tools that require unrestricted ESXi root access or customer-installed VIBs cannot be assumed to work. Elevated operations, where supported, are exposed through curated Run Commands or product-specific installation workflows. [Use Run Commands in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/using-run-command)

> **Transcript-derived analogy:** AVS is compared to leasing a commercial kitchen. Microsoft owns and maintains the building and equipment, while the customer controls the menu and operations.

### Third-Party Tooling Requirements

* **Discovery requirement:** Consultants should audit all backup, monitoring, security, and performance tools against the AVS responsibility boundary and supported integration model. [Azure VMware Solution responsibility matrix — Microsoft vs customer](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-responsibility-matrix---microsoft-vs-customer)
* **Failure condition:** Legacy tools that require ESXi root access may be blocked entirely.
* **Preferred remediation:** For backup, use a solution that supports VMware VADP with HotAdd transport mode, which Microsoft says works out of the box on AVS. [Microsoft Azure VMware Solution FAQ — backup solutions](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
* **Why VADP helps:** VADP-based backup integrates through supported VMware data-protection APIs rather than relying on unrestricted host administration. [Microsoft Azure VMware Solution FAQ — backup solutions](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
* **Exception path:** For critical tools requiring elevated host operations, validate the specific Microsoft Run Command or supported partner installation workflow and engage support before committing to the design. [Use Run Commands in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/using-run-command)
* **Operational warning:** Do not assume Microsoft will approve or deploy custom host agents.

## 5. Quotas, Sizing, and Capacity Reservations

AVS sizing must account for procurement lead time, management overhead, high availability reservations, and storage slack. The transcript frames these as “invisible taxes” that materially reduce usable capacity.

### Host Quota Process

1. Request AVS host quota/capacity early in planning. [Request host quota for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/request-host-quota-azure-vmware-solution)
2. Allow up to five business days for Microsoft to confirm the request and allocate hosts, depending on the request. [Request host quota for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/request-host-quota-azure-vmware-solution)
3. Confirm the requested region, SKU, host count, and any placement requirements; Generation 1 placement and Generation 2 availability-zone selection differ. [Azure region availability zone to host type mapping table](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#azure-region-availability-zone-to-host-type-mapping-table) [Introduction to Generation 2 private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)
4. Avoid scheduling implementation work that assumes hosts are instantly available.

* **Reason for delay:** AVS hosts are dedicated bare-metal resources allocated from regional capacity. [Request host quota for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/request-host-quota-azure-vmware-solution)
* **Operational implication:** Microsoft must allocate physical infrastructure in the requested location.

### Management Resource Pool Overhead

* **Automatic deployment:** AVS creates the `MGMT-ResourcePool` for management and control-plane resources. [Azure VMware Solution private cloud and cluster concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
* **Purpose:** The pool reserves capacity for vCenter Server, NSX appliances, ESXi system usage, and optional add-ons such as HCX. [Management and control plane resource requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
* **Reserved capacity:** Microsoft documents a fixed reservation of **46 GHz CPU and 171.88 GB memory**. [Management and control plane resource requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
* **Constraint:** The `MGMT-ResourcePool` reservation cannot be changed. [Management and control plane resource requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)

> **Transcript-derived calculation:**
> Inputs: Three AV36 hosts with 576 GB RAM each.
> Formula: `3 × 576 GB = 1,728 GB total RAM`.
> Management reservation: `1,728 GB − 172 GB = 1,556 GB before HA reserve`.
> Practical interpretation: The client does not receive all purchased RAM for workloads because management appliances consume reserved capacity first.
> Factors that affect real usable capacity: HA reserve, workload overhead, storage policies, and cluster configuration.

### High Availability Reserve

* **HA model:** For a standard three-node cluster, Microsoft documents that one node of resources is held in reserve for node failure; stretched clusters use an N+2 percentage-based admission-control policy. [Management and control plane resource requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
* **Three-node implication:** Two nodes are available for customer workloads before subtracting management reservations, while one node of capacity is reserved for node failure. [Management and control plane resource requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
* **Failure scenario:** vSphere HA restarts affected workloads on surviving hosts when capacity and VM configuration permit. [Azure VMware Solution private cloud and cluster concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
* **Sizing implication:** The transcript’s “just over one host” estimate is an architectural interpretation; Microsoft publishes the fixed management reservation and one-node reserve, but actual usable workload capacity depends on CPU, memory, vSAN policy, and workload behavior. [Management and control plane resource requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
* **Client expectation:** Consultants must explain this before purchase approval.

## 6. vSAN Storage Design and Capacity Constraints

vSAN capacity planning is one of the most constrained parts of AVS design. Usable storage is reduced by slack space requirements, failure-tolerance policies, and provisioning choices.

### Slack Space Requirement

* **Required empty space:** Microsoft limits vSAN utilization to 75% of total usable capacity, which means keeping 25% available for the service-level requirement. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)
* **Operational threshold:** Microsoft identifies utilization above 75% as an error condition that can degrade performance and make the cluster unmaintainable. [Private cloud maintenance — vSAN utilization](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
* **Why it matters:** Free capacity supports maintenance, repair, rebalance, policy changes, and object growth. [Azure VMware Solution storage concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage)
* **Failure condition:** If the datastore is too full, maintenance, repair, rebalance, snapshots, and object growth can be impaired or blocked. The transcript’s word “catastrophically” is a risk characterization rather than Microsoft’s documented wording. [Private cloud maintenance — vSAN utilization](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### Failure Tolerance Policies

| Cluster size | Supported policy example | Data-protection behavior | Capacity impact |
| --- | --- | --- | --- |
| 3 hosts | Default RAID-1, FTT-1 | Tolerates one failure | Two mirrored data components mean approximately 2× data-component capacity before metadata and other overhead |
| 4 or more hosts | RAID-5, FTT-1 can be selected where supported | Tolerates one failure | Erasure coding is more capacity-efficient than RAID-1 |
| More than 6 hosts for AVS SLA use of FTT-2 | RAID-6, FTT-2 can be selected where supported | Tolerates two failures | Erasure coding is generally more capacity-efficient than RAID-1 FTT-2 |

*Sources: [Azure VMware Solution storage concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage) and [Using RAID 5 or RAID 6 erasure coding in a vSAN cluster](https://techdocs.broadcom.com/us/en/vmware-cis/vsan/vsan/8-0/vsan-administration/increasing-space-efficiency-in-a-vsan-cluster/using-raid-5-6-erasure-coding-in-vsan-cluster.html).*

* **FTT definition:** Failures to tolerate, or FTT, defines the number of failures a vSAN object is configured to tolerate. [Azure VMware Solution storage concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage)
* **RAID 1 behavior:** RAID-1 FTT-1 uses mirrored data components; the “approximately double” statement is a simplified capacity example and excludes metadata, witnesses, checksums, snapshots, and other overhead. [Azure VMware Solution storage concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage)
* **RAID 6 behavior:** RAID-6 uses erasure coding to tolerate two failures and requires sufficient cluster/fault-domain scale. [Azure VMware Solution storage concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage)
* **Scale benefit:** RAID-5 becomes possible at four hosts; RAID-6 requires at least six hosts in general vSAN guidance, while Microsoft states **more than six hosts** should be configured for an AVS FTT-2 policy to meet the referenced SLA condition. [Azure VMware Solution storage concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage)

> **Transcript-derived analogy:** RAID 1 is like printing two full copies of a 100-page book. Erasure coding is like splitting the book into chunks and storing parity equations so missing pieces can be reconstructed.

### Thin vs. Thick Provisioning

* **Default policy:** Microsoft documents the default datastore policy as RAID-1 FTT-1 and **thin provisioned**. [Microsoft Azure VMware Solution FAQ — thin provisioning](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
* **Thick provisioning behavior:** A thick-provisioned virtual disk reserves its configured capacity according to the selected VMware storage format and policy; the transcript’s 500 GB example is illustrative.
* **Failure scenario:** Migrating many VMs with oversized empty disks can immediately hit the 75% capacity wall.
* **Operational recommendation:** Verify the target storage policy and migration format rather than assuming thick provisioning. Microsoft says the default AVS vSAN policy is thin provisioned and HCX lets you specify the destination format. [Microsoft Azure VMware Solution FAQ — migrated VM provisioning format](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
* **Thin provisioning behavior:** Thin provisioning allocates datastore capacity as data is written, subject to vSAN object, policy, metadata, snapshot, and swap overhead. [Azure VMware Solution storage concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage)
* **Operational recommendation:** Use thin provisioning where appropriate, monitor actual consumption, and preserve the 25% free-capacity requirement; thin provisioning does not eliminate overcommitment risk. [Microsoft Azure VMware Solution FAQ — thin provisioning](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)

### External Storage Options

* **Supported options:** Azure NetApp Files provides NFS datastores; Azure Elastic SAN provides iSCSI block storage; Pure Cloud Block Store / Azure Native Pure Storage provides partner block-storage integration rather than NFS. [External storage solutions overview](https://learn.microsoft.com/en-us/azure/azure-vmware/ecosystem-external-storage-solutions)
* **Purpose:** External datastores can scale storage independently of AVS compute and reduce pressure on the vSAN datastore. [External storage solutions overview](https://learn.microsoft.com/en-us/azure/azure-vmware/ecosystem-external-storage-solutions)
* **Latency caveat:** External storage uses Azure networking paths; placement, generation, protocol, gateway design, and availability-zone alignment affect latency and throughput. [Attach Azure NetApp Files datastores to Azure VMware Solution hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts)
* **Performance implication:** Storage traffic must leave AVS, reach external storage, and return.
* **Network requirement:** For Generation 1 Azure NetApp Files connectivity, an ExpressRoute connection through a virtual network is required; Generation 2 can use the same or a peered virtual network. Microsoft’s AVS limit table recommends an Ultra Performance gateway with FastPath for the documented 10-Gbps soft limit, but a dedicated gateway is a design recommendation rather than a universal requirement for every external-storage option. [Attach Azure NetApp Files datastores to Azure VMware Solution hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts) [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)
* **FastPath behavior:** ExpressRoute FastPath sends traffic directly to virtual machines or supported private endpoints in the virtual network, bypassing the virtual network gateway data path where supported. [About ExpressRoute FastPath](https://learn.microsoft.com/en-us/azure/expressroute/about-fastpath)
* **Cost implication:** Ultra-performance ExpressRoute gateway capacity and advanced network design add cost and complexity.

## 7. Network Foundation and IP Addressing

Networking is the highest-risk AVS implementation domain in the transcript. Address overlap, routing table size, firewall rules, and ExpressRoute design can determine whether the environment functions or becomes isolated.

### Management CIDR Requirement

* **Generation 1 requirement:** Generation 1 private-cloud deployment requires a non-overlapping private `/22` network block. Generation 2 instead deploys inside an Azure virtual network with delegated subnets and has a different address-planning model. [Network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) [Azure VMware Solution Generation 2 private cloud design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration)
* **Transcript-derived calculation:** A `/22` IPv4 block contains `2^(32−22) = 1,024` total addresses; this arithmetic is not a Microsoft-published AVS capacity figure.
* **Use of addresses:** Generation 1 subdivides the management block for platform and host services; HCX also requires separately planned network profiles and appliance IP pools. [Network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) [Configure VMware HCX](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)
* **Non-overlap rule:** The management block must not overlap with connected on-premises or Azure networks. [Network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
* **Failure condition:** Any overlap can cause routing ambiguity, packet drops, black holes, or private cloud isolation.

> **Transcript-derived analogy:** The `/22` block is the foundation footprint of a building. If it overlaps a neighbor’s property line, the project fails.

### Reserved NSX Ranges

* **Reserved ranges:** Avoid `169.254.0.0/24` for internal transit, `169.254.2.0/23` for inter-VRF transit, and `100.64.0.0/16` for internal T1-to-T0 connectivity. [Network planning checklist — reserved NSX ranges](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
* **Purpose:** NSX uses the documented ranges for internal transit and T1/T0 connectivity. [Network planning checklist — reserved NSX ranges](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
* **Failure condition:** Advertising these ranges into AVS can collide with NSX internal plumbing and create routing loops.

> **Documentation correction:** The second reserved range is `169.254.2.0/23`, not `169.254.0.0/23`. Generation 2 design documentation also reserves `100.73.x.x` for Microsoft management networking. [Azure VMware Solution Generation 2 private cloud design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration)

## 8. ExpressRoute, Global Reach, and BGP Routing

AVS connectivity relies on ExpressRoute and, specifically for on-premises-to-AVS connectivity, ExpressRoute Global Reach. The routing design must be controlled carefully.

* **Generation 1 circuit behavior:** Azure VMware Solution Generation 1 includes a Microsoft-managed ExpressRoute circuit for private-cloud connectivity. Generation 2 attaches to an Azure virtual network and does not require ExpressRoute for native VNet connectivity. [Network interconnectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking) [Differences between Generation 1 and Generation 2](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)
* **Global Reach behavior:** ExpressRoute Global Reach connects the on-premises ExpressRoute circuit to the Generation 1 AVS private-cloud circuit at the Microsoft Edge. [Peer on-premises environments to Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)
* **Traffic path:** The preferred Generation 1 pattern is a direct Global Reach circuit-to-circuit connection rather than relying on an ExpressRoute gateway for circuit transit. [Network interconnectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking)
* **Performance implication:** Global Reach provides private circuit-to-circuit connectivity over Microsoft’s backbone and avoids using a virtual network gateway as a transit router; realized latency depends on circuit, peering, geography, and workload path. [Peer on-premises environments to Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)

### BGP Route Controls

* **BGP role:** ExpressRoute uses BGP to exchange network prefixes between customer and Microsoft edge routers. [ExpressRoute circuits and routing domains](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-circuit-peerings)
* **Route hygiene:** On-premises advertisements must comply with ExpressRoute route and prefix requirements. The transcript’s statement that any “bogon” advertisement automatically drops the BGP session is not directly confirmed in the reviewed AVS documentation. [ExpressRoute routing requirements](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-routing)
* **Not directly supported by the reviewed documentation:** The specific claim that advertising a bogon route automatically causes Microsoft Edge routers to drop the BGP session was not confirmed. Enforce ExpressRoute route-advertisement requirements and filter invalid or unintended prefixes. [ExpressRoute routing requirements](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-routing)
* **Route limits:** The 1,000-route statement applies to specific architectures, not all AVS connectivity. Generation 2 documents a combined prefix-and-host-route limit of 1,000 in its internal routing architecture; Azure Route Server and ExpressRoute gateways have their own separately documented limits. [Route architecture for Azure VMware Solution Gen 2](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture) [Azure Route Server limits](https://learn.microsoft.com/en-us/azure/route-server/route-server-faq#what-are-the-limits-of-azure-route-server)
* **Documentation correction:** Exceeding a route limit can cause route rejection, incomplete propagation, or control-plane failure behavior specific to the affected service; the reviewed documentation does not establish that advertising 2,000 routes universally severs the BGP session. Apply the limit for the actual Generation 1, Generation 2, Route Server, or gateway architecture. [Route limitations for Gen 2](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture#route-limitations-for-gen-2)
* **Operational recommendation:** Summarize routes where the network design safely permits it and keep route counts within the limit for the applicable architecture. [How to stay within the Generation 2 route limit](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

### Default Route Failure Scenario

> **Transcript-derived scenario:** Advertising only `0.0.0.0/0` to AVS can break administrative access.

* **Observed flow:** A user can send a request from on-premises to AVS vCenter.
* **Return-path failure:** vCenter may not have a more specific route back to the user’s subnet.
* **Documentation correction:** Microsoft states that a single `0.0.0.0/0` route is discarded by the AVS management network to preserve service operation; the reviewed AVS article does not describe the cause as Azure treating it as internet-bound. [Peer on-premises environments to Azure VMware Solution — default route note](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)
* **Required fix:** When advertising `0.0.0.0/0`, also advertise more-specific on-premises routes needed for AVS management access. [Peer on-premises environments to Azure VMware Solution — default route note](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)

## 9. Firewall Ports and HCX Network Tunnels

Firewall rules must be prepared before administrative access, authentication, and HCX migrations are attempted.

| Purpose | Protocol / documented port |
| --- | --- |
| vCenter Server web access | TCP 443 |
| NSX Manager web access | TCP 443 |
| Active Directory / LDAP authentication | TCP 389; TCP 636 recommended for LDAPS |
| Active Directory Global Catalog | TCP 3268; TCP 3269 for secure Global Catalog |
| HCX Cloud Manager appliance administration | TCP 9443 |
| HCX Manager to local HCX Interconnect / Network Extension REST API | TCP 9443 |
| HCX source-to-destination IPsec/IKEv2 tunnels | UDP 4500 |

*Source: [Network planning checklist — required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist).*

* **HCX tunnel behavior:** HCX Network Extension provides Layer-2 extension across the IPsec-based interconnect between paired sites. [Configure VMware HCX](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)
* **UDP 4500 role:** HCX uses UDP 4500 for IPsec/IKEv2 with NAT traversal between source and destination appliances. [Network planning checklist — HCX ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
* **Failure condition:** Blocking UDP 4500 prevents the required HCX interconnect and network-extension tunnels from forming. The “spin indefinitely and fail silently” wording is transcript-derived and not directly documented. [Configure VMware HCX — create a service mesh](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)

> **Documentation correction:** The documented LDAP ports are TCP **389** and **636**, not TCP 39. Microsoft recommends port 636 for secure LDAP. [Network planning checklist — required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

## 10. Identity, Access Control, and Break-Glass Design

Identity is treated as a critical architecture pillar. The transcript emphasizes local Azure-resident identity services, encrypted directory integration, named accounts, RBAC, and carefully controlled emergency access.

### Azure-Resident AD DS Controller

* **Operational recommendation:** Deploy resilient Windows Server AD DS and DNS services reachable from AVS, commonly including Azure-resident domain controllers, to avoid making administration depend on a single WAN path. Microsoft documents the need for connected AD and DNS resolution but does not mandate a dedicated “Identity subscription” or a specific controller placement. [Set an external identity source for vCenter Server — prerequisites](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter)
* **Reason:** Relying only on on-premises domain controllers creates an authentication dependency on ExpressRoute.
* **Failure scenario:** If the WAN or ExpressRoute circuit fails, AVS workloads may continue running, but administrators may be unable to authenticate to vCenter or NSX.
* **Design goal:** Local AVS administration should remain possible even when the on-premises connection is down.
* **Architectural interpretation:** Configure AD Sites and Services and DNS so AVS uses an appropriate reachable domain controller; the exact site topology is customer-specific. [Active Directory Domain Services site design](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/designing-the-site-topology)

### LDAPS and Named Accounts

* **Recommendation:** Microsoft recommends adding Windows Server Active Directory over LDAP using SSL (LDAPS) as the external vCenter identity source. [Set an external identity source for vCenter Server](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter)
* **Security purpose:** LDAPS uses TLS to protect LDAP traffic in transit. [Enable LDAP over SSL with a third-party certification authority](https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/enable-ldap-over-ssl-3rd-certification-authority)
* **Operational recommendation:** Use named AD identities and groups instead of shared daily-use accounts to improve accountability.
* **Auditability:** After adding external identity sources, assign vCenter Server and NSX roles to AD users or security groups according to least privilege. [Assign more vCenter Server roles to AD identities](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter) [Assign NSX roles to AD identities](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-external-identity-source-nsx-t)

### CloudAdmin Account

* **Built-in account:** AVS provides the local `cloudadmin@vsphere.local` account assigned to the CloudAdmin role. [Set an external identity source for vCenter Server](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter)
* **Operational recommendation:** Treat the local CloudAdmin account as break-glass rather than a shared daily-use identity; Microsoft documentation warns to identify dependencies before credential rotation. [Rotate the cloud admin credentials](https://learn.microsoft.com/en-us/azure/azure-vmware/rotate-cloudadmin-credentials)
* **Initial use:** Use CloudAdmin to configure LDAPS and grant named accounts appropriate rights.
* **Operational recommendation:** Store the CloudAdmin credential in an enterprise secrets vault with controlled access and auditing.
* **Operational recommendation:** Rotate the CloudAdmin credential after emergency use or suspected exposure, after checking services that depend on it. [Rotate the cloud admin credentials](https://learn.microsoft.com/en-us/azure/azure-vmware/rotate-cloudadmin-credentials)
* **Failure condition:** If a script or service account locks out CloudAdmin, top-tier access may be lost.

### Custom vCenter RBAC

* **Constraint:** AVS administrators operate within the privileges granted to CloudAdmin and cannot manage Microsoft-controlled platform objects. [Azure VMware Solution identity concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity)
* **Failure condition:** vCenter rejects role creation if the role includes privileges higher than CloudAdmin possesses.
* **Operational recommendation:** Build least-privilege roles from the permissions available to CloudAdmin and test them on noncritical objects. Microsoft documents role assignment, but does not prescribe cloning CloudAdmin as the only method. [Assign more vCenter Server roles to AD identities](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter)
* **Example:** A Tier One support role can allow VM reboot and console access while denying datastore deletion or network segment modification, as long as all selected privileges are within CloudAdmin’s permitted scope.

## 11. Azure Control Plane Security and PIM

AVS exists in both Azure Resource Manager and VMware vSphere control planes. A compromise in either control plane can affect the private cloud.

* **Azure plane:** Azure Resource Manager controls the AVS resource lifecycle, including deployment, scaling, and destructive cluster operations. [Azure VMware Solution private cloud and cluster concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
* **VMware plane:** vCenter Server and NSX Manager control customer-permitted workload compute, storage-policy, networking, and security operations. [Azure VMware Solution responsibility matrix — Microsoft vs customer](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-responsibility-matrix---microsoft-vs-customer)
* **Security recommendation:** Use Microsoft Entra PIM for just-in-time Azure resource-role access where licensing and operating requirements permit. [What is Privileged Identity Management?](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure)
* **PIM model:** Eligible users activate roles when needed; PIM supports just-in-time, time-bound, approval-based access, MFA, justification, notifications, and audit history. [What is Privileged Identity Management?](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure)
* **Activation controls:** Role settings can require approval, MFA, justification, a maximum activation duration, and notifications. [Configure Azure resource role settings in PIM](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-configure-role-settings)

### Alerting Exception for PIM

> **Transcript-derived scenario:** The transcript proposes a standing identity for alert delivery when human administrators use PIM.

* **Not directly supported by the reviewed documentation:** Azure Monitor, Service Health, and Resource Health alert delivery does not inherently require a human administrator to hold an active PIM role at the time of the event. Alert rules and action groups should be configured and tested independently. [Create and manage action groups in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups)
* **Documentation correction:** Do not create standing AVS permissions solely for SMTP alert delivery without a separately justified automation requirement. Use Azure Monitor action groups, Service Health alerts, or ticketing/webhook integrations for notification routing. [Create Service Health alerts in the Azure portal](https://learn.microsoft.com/en-us/azure/service-health/alerts-activity-log-service-notifications-portal)
* **Not directly supported by the reviewed documentation:** No AVS documentation requirement was found that a standing privileged identity must have an SMTP record for infrastructure alerts.
* **Operational recommendation:** Route AVS health and maintenance notifications to a monitored action group, distribution list, webhook, ITSM connector, or pager workflow. [Azure Monitor action groups](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups)
* **Documentation correction:** PIM governs privileged role activation; notification endpoints should be designed as nonhuman alerting integrations rather than privileged “alert receiver” accounts.

## 12. HCX Migration Design

VMware HCX is the primary migration mechanism described in the transcript. It supports large-scale migration while preserving IP addressing, but it has strict operational rules and scaling limits.

### Migration Direction

* **Architecture:** The on-premises HCX Connector pairs with the HCX Cloud Manager in AVS and deploys paired service-mesh appliances. [Configure VMware HCX in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)
* **Connector-to-cloud rule:** In the standard AVS Connector-to-Cloud topology, the HCX Connector is the source for mobility and network-extension operations. [Understanding HCX sites](https://techdocs.broadcom.com/us/en/vmware-cis/hcx/vmware-hcx/4-10/vmware-hcx-user-guide-4-10/creating-and-managing-site-pairs/understanding-hcx-sites.html)
* **Transcript-derived rule:** Do not initiate bulk migrations from the cloud-side HCX appliance in the standard Connector-to-Cloud design.
* **Architectural interpretation:** The source-side connector owns the source inventory and initiates the standard connector-to-cloud workflows; the “source of truth” wording is explanatory rather than a quoted product requirement. [Understanding HCX sites](https://techdocs.broadcom.com/us/en/vmware-cis/hcx/vmware-hcx/4-10/vmware-hcx-user-guide-4-10/creating-and-managing-site-pairs/understanding-hcx-sites.html)
* **Not directly supported by the reviewed documentation:** The specific claims about orphan files and synchronization failures from reverse initiation were not confirmed. The applicable product rule is that Connector sites serve as the source in Connector-to-Cloud pairings. [Understanding HCX sites](https://techdocs.broadcom.com/us/en/vmware-cis/hcx/vmware-hcx/4-10/vmware-hcx-user-guide-4-10/creating-and-managing-site-pairs/understanding-hcx-sites.html)

### Mobility Optimized Networking

* **Problem solved:** HCX Mobility Optimized Networking routes selected traffic locally at the destination for extended networks, reducing suboptimal backhaul through the source-site gateway. [Configure VMware HCX — MON prerequisites](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)
* **Tromboning behavior:** Without MON, cloud-based VMs may route traffic back to an on-premises gateway and then back to Azure.
* **Performance impact:** Tromboning adds latency and reduces application performance.
* **MON benefit:** Properly configured MON can keep eligible destination-site traffic local rather than sending it through the source-site gateway. [Configure VMware HCX — MON prerequisites](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)

| HCX MON scale item | Transcript-stated value |
| ------------------------------ | -------------------------------------------: |
| Standard HCX Manager appliance | About 400 VMs with MON enabled |
| Large HCX Manager appliance | About 1,000 VMs with MON enabled |
| Network extension limit | No more than 100 stretched networks with MON |

> **Not directly supported by the reviewed documentation:** These three transcript-stated MON scale values were not confirmed in the current Microsoft Learn or Broadcom TechDocs pages reviewed. Validate them against the Broadcom configuration-maximums tool and the exact HCX version before design approval. [VMware by Broadcom configuration maximums](https://configmax.broadcom.com/)

* **Migration implication:** Large clients may need phased network migration and gateway retirement.
* **Not directly supported by the reviewed documentation:** The exact “below 500 Mbps” trigger was not confirmed. HCX WAN Optimization provides deduplication and compression; select it based on measured bandwidth, latency, migration method, and current Broadcom guidance. [VMware Cloud: Introduction to HCX](https://www.vmware.com/docs/vmware-cloud-introduction-to-hcx)
* **WAN optimization behavior:** The HCX WAN Optimization appliance provides WAN optimization and deduplication for migration traffic. [VMware Cloud: Introduction to HCX](https://www.vmware.com/docs/vmware-cloud-introduction-to-hcx)

## 13. AV64 Heterogeneous CPU and EVC Trap

The AV64 expansion model can create a heterogeneous CPU environment. The transcript presents this as a major migration and operations risk.

### Failure Mechanics

* **Scenario:** In Generation 1, a client can add a separate AV64 Ice Lake cluster to a private cloud seeded by AV36, AV36P, AV48, or AV52. [Azure VMware Solution private cloud extension with AV64 node size](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#azure-vmware-solution-private-cloud-extension-with-av64-node-size)
* **Heterogeneity:** Microsoft describes this as a heterogeneous environment with EVC implications. [Enhanced vMotion Compatibility (EVC) with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension)
* **vMotion dependency:** Live vMotion moves a running VM between compatible hosts without planned workload downtime. [Enhanced vMotion Compatibility (EVC) with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension)
* **CPU instruction issue:** EVC masks CPU features to a compatible baseline so a powered-on VM does not begin using instructions unavailable on a migration target. [Enhanced vMotion Compatibility as a virtual machine attribute](https://techdocs.broadcom.com/us/en/vmware-cis/vsphere/vsphere/8-0/vsphere-virtual-machine-administration/managing-virtual-machinesvsphere-vm-admin/evc-as-a-virtual-machine-attributevsphere-vm-admin.html)
* **Forward motion:** Microsoft documents that live vMotion from a base-SKU cluster to an AV64 cluster succeeds in the described EVC scenario. [Enhanced vMotion Compatibility (EVC) with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension)
* **Backward motion risk:** A powered-on VM exposed to newer CPU features might not be live-migratable to an older CPU baseline. Microsoft flags EVC issues in AV64 heterogeneous private clouds. [Enhanced vMotion Compatibility (EVC) with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension)
* **Why VMware blocks it:** EVC prevents a powered-on VM from using CPU features that are unavailable on a migration target; Microsoft documents an EVC compatibility error for the affected AV64-to-base migration case. [Enhanced vMotion Compatibility (EVC) with AV64 extension](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#enhanced-vmotion-compatibility-evc-with-av64-extension)

### Reactive and Proactive Responses

*Source for per-VM EVC behavior: [Enhanced vMotion Compatibility as a virtual machine attribute](https://techdocs.broadcom.com/us/en/vmware-cis/vsphere/vsphere/8-0/vsphere-virtual-machine-administration/managing-virtual-machinesvsphere-vm-admin/evc-as-a-virtual-machine-attributevsphere-vm-admin.html)*

| Approach                | Description                                                         | Operational impact                                                 |
| ----------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------ |
| Reactive cold migration | Power off the VM, move it, and boot it on the older host.           | Requires downtime and is unacceptable for many tier-one workloads. |
| Proactive VM-level EVC  | Configure VM-level EVC before migration to mask newer CPU features. | Enables bidirectional live vMotion across heterogeneous clusters.  |

* **Proactive rule:** Configure per-VM EVC to a baseline supported by all intended source and destination hosts before the VM is exposed to newer CPU features. [Configure the EVC mode of a virtual machine](https://techdocs.broadcom.com/us/en/vmware-cis/vsphere/vsphere/7-0/vsphere-virtual-machine-administration/managing-virtual-machinesvm-admin/evc-as-a-virtual-machine-attributevm-admin/configure-the-evc-mode-of-a-virtual-machinevm-admin.html)
* **Effect:** Per-VM EVC presents the configured CPU feature baseline to the VM and overrides cluster EVC for that VM. [Enhanced vMotion Compatibility as a virtual machine attribute](https://techdocs.broadcom.com/us/en/vmware-cis/vsphere/vsphere/8-0/vsphere-virtual-machine-administration/managing-virtual-machinesvsphere-vm-admin/evc-as-a-virtual-machine-attributevsphere-vm-admin.html)
* **Operational result:** A compatible per-VM EVC baseline can preserve live-migration compatibility, subject to all other vMotion requirements. [Enhanced vMotion Compatibility as a virtual machine attribute](https://techdocs.broadcom.com/us/en/vmware-cis/vsphere/vsphere/8-0/vsphere-virtual-machine-administration/managing-virtual-machinesvsphere-vm-admin/evc-as-a-virtual-machine-attributevsphere-vm-admin.html)

> **Transcript-derived analogy:** Without proactive VM-level EVC, AV64 can become a “Roach Motel” for VMs: they can check in, but cannot check out without downtime.

## 14. Backup and Disaster Recovery

Backup and disaster recovery design must avoid consuming vSAN capacity and must maintain clean network addressing across regions.

### Backup Placement

* **Operational recommendation:** Do not use the primary vSAN workload datastore as the long-term backup repository; separate failure domains and preserve the 25% free-capacity requirement. Microsoft documents supported VADP backup solutions and external storage options, but does not phrase this as an absolute prohibition. [Microsoft Azure VMware Solution FAQ — backup solutions](https://learn.microsoft.com/en-us/azure/azure-vmware/faq) [External storage solutions overview](https://learn.microsoft.com/en-us/azure/azure-vmware/ecosystem-external-storage-solutions)
* **Reason:** vSAN is expensive high-performance NVMe storage intended for active workloads.
* **Capacity risk:** Large backup files can push vSAN above the 75% threshold.
* **Recommended targets:** Select a supported backup product and repository architecture, such as Azure Blob-backed protection or an external datastore, based on the vendor’s AVS design. [Deploy disaster recovery using JetStream DR](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-disaster-recovery-using-jetstream)

### Disaster Recovery Options

*Sources: [Support matrix for VMware/physical disaster recovery in Azure](https://learn.microsoft.com/en-us/azure/site-recovery/vmware-physical-azure-support-matrix), [Deploy disaster recovery with VMware Live Site Recovery](https://learn.microsoft.com/en-us/azure/azure-vmware/disaster-recovery-using-vmware-site-recovery-manager), and [Deploy disaster recovery using JetStream DR](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-disaster-recovery-using-jetstream)*

| DR approach                  | Use case                                                                              |
| ---------------------------- | ------------------------------------------------------------------------------------- |
| Azure Site Recovery          | Fail VMware workloads into native Azure infrastructure-as-a-service virtual machines. |
| VMware Site Recovery Manager | Fail VMware workloads to a secondary AVS private cloud.                               |
| Zerto / Jetstream            | Third-party VMware-to-VMware replication options.                                     |

* **Network rule:** Use non-overlapping routed address spaces between connected private clouds and recovery environments. [Connect multiple Azure VMware Solution private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking)
* **Failure scenario:** Overlapping routed address spaces prevent unambiguous connectivity and are rejected by supported private-cloud interconnect workflows. [Connect multiple Azure VMware Solution private clouds in the same region](https://learn.microsoft.com/en-us/azure/azure-vmware/connect-multiple-private-clouds-same-region)
* **Example design:** Use `10.0.0.0/16` for primary and a distinct block such as `192.168.0.0/16` for secondary.

## 15. Stretched Clusters and vSAN Witness Behavior

A stretched cluster provides high availability across availability zones within a single Azure region. It increases resilience but imposes strict host, routing, and quorum requirements.

* **Purpose:** A Generation 1 stretched cluster spans two availability zones in one Azure region with a single management and control plane; it is an availability architecture, not a replacement for regional disaster recovery. [Design considerations for vSAN stretched clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
* **Minimum size:** Six hosts, deployed as three hosts in each data availability zone. [Stretched-cluster SLA conditions](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
* **Maximum size:** Sixteen hosts; scale-out and scale-in occur in host pairs. [Design considerations for vSAN stretched clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
* **Balance requirement:** Hosts are distributed evenly across the two data availability zones. [Design considerations for vSAN stretched clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
* **Example:** Three hosts in Availability Zone 1 and three hosts in Availability Zone 2.
* **Network design:** The transcript’s requirement for two customer ExpressRoute circuits and two Global Reach connections is not stated as a universal stretched-cluster requirement in the reviewed design article. Design redundant connectivity so the surviving site retains required on-premises and Azure reachability. [Design considerations for vSAN stretched clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
* **Reason:** If one availability zone fails, the surviving zone must still route traffic to on-premises.

### vSAN Witness

* **Witness role:** The vSAN witness participates in quorum and is managed by Microsoft in the third availability zone. [Design considerations for vSAN stretched clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
* **Placement:** Microsoft deploys the witness in the third availability zone. [Design considerations for vSAN stretched clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
* **Normal failure behavior:** If one data availability zone fails, the surviving data zone plus witness maintain quorum.
* **Witness failure behavior:** Microsoft’s FAQ documents that the witness becomes unreachable if its zone is unavailable; continued workload behavior depends on the remaining quorum state and failure sequence. [Microsoft Azure VMware Solution FAQ — stretched-cluster witness](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
* **Not directly supported by the reviewed documentation:** The exact list of blocked repair, rebalance, and placement operations during a witness-only outage was not confirmed in current Microsoft Learn. Validate against the deployed vSAN version’s Broadcom documentation.

## 16. AV64 Fault Domains and Scale-Down Constraints

AV64 clusters expose fault-domain behavior more explicitly than traditional AVS clusters. This affects scale-down operations.

* **Fault domain concept:** A fault domain represents physical separation, such as server racks.
* **AV64 behavior:** Microsoft documents five or seven fault domains depending on the region and deployment context; the current region mapping table should be checked during design. [Azure region availability zone to host type mapping table](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#azure-region-availability-zone-to-host-type-mapping-table)
* **Scale-out behavior:** The AVS control plane adds AV64 hosts across the available fault domains to maintain balance. [AV64 host removal workflow and best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#av64-host-removal-workflow-and-best-practices)
* **Scale-down trap:** A removal request is checked for resulting fault-domain imbalance. [AV64 host removal workflow and best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#av64-host-removal-workflow-and-best-practices)
* **Failure condition:** If the difference between the most- and least-populated fault domains would exceed one, the request is rejected with HTTP 409 Conflict. [AV64 host removal workflow and best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#av64-host-removal-workflow-and-best-practices)
* **Operational procedure:**

  1. Open the vSphere client.
  2. Inspect the vSAN cluster fault-domain layout.
  3. Identify the most populated fault domain.
  4. Select a host from that domain for removal.
  5. Submit the scale-down request only for a host that preserves balance.

## 17. Day-Two Operations and Lifecycle Management

After migration, the client must operate AVS safely. Microsoft handles core infrastructure patching, but clients must plan around management-plane locks, monitoring, governance, and automation limits.

### Microsoft-Managed Patching

* **Microsoft responsibility:** Microsoft applies patches, updates, and upgrades to ESXi, vCenter Server, vSAN, and NSX. [Microsoft Azure VMware Solution FAQ — patches, updates, and upgrades](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
* **Workload impact:** ESXi maintenance uses host maintenance mode and vMotion to avoid workload impact when cluster capacity and VM constraints permit. [Microsoft Azure VMware Solution FAQ — patches, updates, and upgrades](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
* **Mechanism:** AVS uses host maintenance mode, moves VMs to other hosts, and upgrades hosts sequentially. [Microsoft Azure VMware Solution FAQ — patches, updates, and upgrades](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
* **Management-plane impact:** During vCenter Server maintenance, vCenter is unavailable; during NSX maintenance, NSX management access or configuration can be blocked. Workloads continue running. [Microsoft Azure VMware Solution FAQ — patches, updates, and upgrades](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
* **Blocked operations:** Avoid scaling, provisioning, network changes, HCX configuration changes, and active migration starts during the documented maintenance window. [Microsoft Azure VMware Solution FAQ — patches, updates, and upgrades](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
* **Operational recommendation:** Pause automated provisioning scripts during maintenance windows.

> **Transcript-derived analogy:** Workloads stay online like tenants remaining in an apartment, but management actions are blocked like plumbing being unavailable during building maintenance.

### Azure Arc, Defender, and VMware Security Tools

* **Azure Arc role:** Azure Arc-enabled VMware vSphere registers vCenter inventory with Azure; guest management installs the Azure Connected Machine agent so Azure services can govern, monitor, patch, and secure selected VMs. [What is Azure Arc-enabled VMware vSphere?](https://learn.microsoft.com/en-us/azure/azure-arc/vmware-vsphere/overview) [Install Arc agents on VMware VMs at scale](https://learn.microsoft.com/en-us/azure/azure-arc/vmware-vsphere/enable-guest-management-at-scale)
* **Defender integration:** Microsoft Defender for Cloud can assess and protect AVS VMs, commonly through Azure Arc and Azure monitoring/security agents. [Integrate Microsoft Defender for Cloud with Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-security-integration)
* **VMware vDefend support:** vDefend Firewall add-on capabilities require customer-provided Broadcom licensing where applicable. [Microsoft Azure VMware Solution FAQ — vDefend](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
* **Feature limitation:** Microsoft lists unsupported advanced capabilities including Security Intelligence, Malicious IP Filtering, Distributed Malware Detection and Prevention, Cloud Sandboxing and Artifact Analysis, Network Detection and Response, malware-file forwarding to NDR, and Gateway Malware Detection. [Microsoft Azure VMware Solution FAQ — vDefend limitations](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)
* **Available function:** Validate the licensed vDefend IDS/IPS and firewall feature set against the current AVS FAQ, known issues, and Broadcom entitlement before purchase. [Microsoft Azure VMware Solution FAQ — vDefend](https://learn.microsoft.com/en-us/azure/azure-vmware/faq) [Azure VMware Solution known issues](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-known-issues)

> **Operational recommendation:** Revalidate the vDefend support matrix immediately before licensing or architecture approval because capabilities depend on AVS platform support and Broadcom licensing. [Microsoft Azure VMware Solution FAQ](https://learn.microsoft.com/en-us/azure/azure-vmware/faq)

### Automated Scaling

* **Automation options:** AVS scaling can be automated through Azure APIs and orchestration services, but automation must respect quota, cluster limits, maintenance states, and long-running-operation behavior. [Scale clusters in a private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)
* **Not directly supported by the reviewed documentation:** The exact private-cloud-wide “one physical scale operation at a time” constraint was not located in current Microsoft Learn. Treat scale operations as long-running and serialize them unless Microsoft Support confirms safe concurrency for the target API/version.
* **Operational recommendation:** Queue and monitor scale operations, handle HTTP conflict/throttling responses, and verify completion before starting dependent changes.
* **Required automation design:** Use serialized queuing, idempotency, state checks, retry/backoff, and hard capacity limits.
* **Cost control:** Set hard maximum limits to prevent runaway scripts from ordering excessive bare-metal hosts.

### Monitoring and Alerts

* **Monitoring tools:** Use Azure Monitor, Log Analytics, Resource Health, Service Health, vCenter/vSAN monitoring, and guest-level monitoring according to the operating model. [Management and monitoring for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/eslz-management-and-monitoring)
* **Baseline framework:** AMBA provides a structured baseline-alert approach across Azure resources; customize it for the AVS resource, connected services, and guest VMs. [Management and monitoring for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/eslz-management-and-monitoring)
* **Operational recommendation:** A sustained cluster CPU threshold such as 80% can be a useful starting point, but Microsoft does not publish 80% as a universal AVS requirement; tune it to workload patterns, HA reserve, and scaling lead time.
* **Operational recommendation:** Alert before the 75% hard operating threshold; 70% is a reasonable planning threshold from the transcript, not a Microsoft-mandated value. [Private cloud maintenance — vSAN utilization](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
* **Reason:** Early warning provides time to delete/migrate data or add hosts before vSAN exceeds the documented 75% threshold. [Private cloud maintenance — vSAN utilization](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

## Architecture Summary

AVS combines dedicated Azure bare-metal hosts, VMware’s core software-defined data center stack, ExpressRoute-based hybrid connectivity, Azure-resident identity, HCX migration tooling, and Azure-native monitoring. The resulting architecture succeeds only when capacity reservations, storage policies, IP addressing, routing, identity, and lifecycle operations are designed together.

1. On-premises workloads begin in a traditional VMware vSphere environment.
2. The consultant provisions AVS bare-metal hosts in Azure after quota approval. [Request host quota for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/request-host-quota-azure-vmware-solution)
3. AVS deploys vCenter Server, ESXi, vSAN, and NSX automatically. [Azure VMware Solution private cloud and cluster concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
4. A non-overlapping `/22` management block is allocated for Generation 1; Generation 2 uses delegated subnets in an Azure virtual network. [Network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) [Generation 2 private cloud design considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration)
5. For the standard Generation 1 on-premises pattern, ExpressRoute Global Reach connects the on-premises circuit to the AVS private-cloud circuit. [Peer on-premises environments to Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)
6. Firewalls allow required management, authentication, and HCX tunnel traffic. [Network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
7. Reachable AD DS, DNS, and preferably LDAPS provide resilient external authentication. [Set an external identity source for vCenter Server](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter)
8. Named identities and least-privilege RBAC replace shared daily use of CloudAdmin. [Azure VMware Solution identity concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity)
9. PIM can protect Azure control-plane access; alert delivery should use Azure Monitor, Service Health, and nonhuman notification integrations rather than a standing privileged identity. [What is Privileged Identity Management?](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure)
10. In the standard Connector-to-Cloud topology, HCX initiates mobility from the connector/source site toward AVS. [Understanding HCX sites](https://techdocs.broadcom.com/us/en/vmware-cis/hcx/vmware-hcx/4-10/vmware-hcx-user-guide-4-10/creating-and-managing-site-pairs/understanding-hcx-sites.html)
11. MON, WAN optimization, and phased migration planning address routing and throughput limits.
12. Per-VM EVC can preserve CPU compatibility across Generation 1 base-SKU and AV64 clusters when configured before exposure to newer CPU features. [Enhanced vMotion Compatibility as a virtual machine attribute](https://techdocs.broadcom.com/us/en/vmware-cis/vsphere/vsphere/8-0/vsphere-virtual-machine-administration/managing-virtual-machinesvsphere-vm-admin/evc-as-a-virtual-machine-attributevsphere-vm-admin.html)
13. Backup data is sent outside vSAN to Azure-native or external storage.
14. DR uses ASR, SRM, or third-party replication with non-overlapping regional IP spaces.
15. Day-two operations rely on Microsoft-managed platform patching, Azure Monitor, Log Analytics, Arc, Defender, VMware monitoring, and controlled scaling automation. [Microsoft Azure VMware Solution FAQ — maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/faq) [Management and monitoring for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/eslz-management-and-monitoring)


## Documentation and Interpretation Notes

* **Material corrections:** The private-cloud limits are 12 clusters, 16 hosts per cluster, and 96 hosts per private cloud; those limits must not be multiplied to imply 192 deployable hosts. LDAP uses TCP 389 and LDAPS uses TCP 636. The reserved NSX range is `169.254.2.0/23`. The default AVS vSAN datastore policy is documented as RAID-1 FTT-1 and thin provisioned. Azure Elastic SAN is iSCSI block storage, not NFS. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters) [Network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) [Microsoft Azure VMware Solution FAQ](https://learn.microsoft.com/en-us/azure/azure-vmware/faq) [External storage solutions overview](https://learn.microsoft.com/en-us/azure/azure-vmware/ecosystem-external-storage-solutions)
* **Generation distinction:** Generation 1 uses the AVS-managed ExpressRoute attachment and requires the `/22` management block; Generation 2 deploys AV64 directly in an Azure virtual network, uses delegated subnets, and does not require a seed cluster. [Introduction to Azure VMware Solution Generation 2 private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)
* **Claims remaining unsupported after targeted research:** The exact HCX MON limits of 400/1,000 VMs and 100 stretched networks; the 500-Mbps WAN-optimization trigger; the claimed requirement for a standing privileged alert identity with SMTP; the detailed vSAN witness-only outage restrictions; and the private-cloud-wide single concurrent scale-operation limit were not confirmed in the reviewed current official documentation.
* **Important interpretations and recommendations:** Azure-resident AD DS placement, alert thresholds below the 75% vSAN ceiling, serialization of automation, vaulting and rotating CloudAdmin, and keeping backup repositories outside the primary workload datastore are sound design recommendations but must be adapted to the customer’s identity, resilience, security, and operating model.

## Final Result

This guide preserves the transcript’s AVS implementation playbook as a structured technical reference for planning, migration, security, resilience, and operations.
