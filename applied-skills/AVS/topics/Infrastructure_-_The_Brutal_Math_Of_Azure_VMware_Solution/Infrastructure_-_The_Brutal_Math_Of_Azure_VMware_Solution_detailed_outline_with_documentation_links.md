# Detailed Outline: *Infrastructure – The Brutal Math of Azure VMware Solution*

> **Documentation annotation note:** This outline preserves the transcript’s sequence, examples, and claims. Inline links point to the closest current Microsoft Learn documentation. Where the current documentation materially differs from the transcript, a **Documentation note** identifies the difference rather than silently changing the transcript.
>
> **Coverage convention:** A link indicates direct or closely related Microsoft documentation. “Transcript example/speculation” indicates that no direct Microsoft Learn statement was identified for that wording.

## 1. Opening Scenario: When a Small Legacy Detail Blocks Cloud-Scale Automation

### 1.1 Multi-million-dollar environment brought to a halt
- Opens with a hypothetical enterprise spending approximately $50 million on an Azure-based data center. *(Transcript example; no direct Microsoft Learn reference identified.)*
- The environment appears healthy: — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - High-end compute is deployed. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Mission-critical workloads have been migrated. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Network monitoring dashboards show normal operation. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- Microsoft announces a critical hypervisor-level zero-day vulnerability. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- Automated global patching begins, but the AVS environment refuses the upgrade. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 1.2 The unexpectedly mundane root cause
- Troubleshooting ultimately identifies a virtual CD-ROM left mounted to a virtual machine. — [Microsoft Learn: Private-cloud maintenance and blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- The mounted media may have been attached years earlier for a legacy operating system or application. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- The virtual device prevents the virtual machine from being migrated. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- Because the VM cannot move: — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - The ESXi host cannot enter maintenance mode. — [Microsoft Learn: Private-cloud maintenance and blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - The automated remediation workflow cannot continue. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - A trivial legacy configuration blocks a major platform security update. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 1.3 Central theme
- The example illustrates the collision between: — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Traditional VMware administration habits. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Hyperscale cloud automation. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- The discussion is framed as an examination of the hidden, strict, and sometimes unforgiving rules of Azure VMware Solution (AVS). — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

---

## 2. The Shared Responsibility Model in AVS

### 2.1 Microsoft responsibilities
- Microsoft owns and operates: — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Physical servers. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Underlying data-center infrastructure. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Hypervisor platform lifecycle. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Core VMware platform updates. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Hardware remediation. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)

### 2.2 Customer responsibilities
- Customers remain responsible for: — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - IP addressing. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Azure virtual networks. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Routing boundaries. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Network segments. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Firewall policy. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Workload configuration. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Virtual hardware attached to VMs. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Application-level resilience. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)

### 2.3 Architectural consequence
- An environment can work correctly at initial deployment but fail later when: — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - It scales. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Workloads are migrated. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Hardware fails. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Platform updates are attempted. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Routing tables reach capacity. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
- The transcript emphasizes that understanding AVS requires more than following deployment steps; architects must understand the mathematical and operational limits behind the design. — [Microsoft Learn: AVS responsibility matrix](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)

---

## 3. AVS Generation 1 and Generation 2

### 3.1 Generation 1 architecture
- Built on specialized bare-metal hardware dedicated to AVS. — [Microsoft Learn: AVS private-cloud generations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) · [Microsoft Learn: Generation 2 introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)
- Uses more rigid connectivity mechanisms between VMware and Azure. — [Microsoft Learn: AVS private-cloud generations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) · [Microsoft Learn: Generation 2 introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)
- Treats the VMware private cloud more like an isolated environment connected to Azure through specialized edge services. — [Microsoft Learn: AVS private-cloud generations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) · [Microsoft Learn: Generation 2 introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)

### 3.2 Generation 2 architecture
- Uses standard Azure virtual machine types as part of the platform architecture. — **Documentation note:** Current Microsoft Learn describes Generation 2 as dedicated Azure bare-metal hosts on the AV64 SKU that attach directly to Azure virtual networks, not as standard Azure VM instances. [Microsoft Learn: AVS private-cloud generations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) · [Microsoft Learn: Generation 2 introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)
- Relies more heavily on native Azure virtual networking. — [Microsoft Learn: AVS private-cloud generations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) · [Microsoft Learn: Generation 2 introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)
- Intended benefits described in the transcript include: — [Microsoft Learn: AVS private-cloud generations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) · [Microsoft Learn: Generation 2 introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)
  - Simpler network topology. — [Microsoft Learn: AVS private-cloud generations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) · [Microsoft Learn: Generation 2 introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)
  - Faster data transfer. — [Microsoft Learn: AVS private-cloud generations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) · [Microsoft Learn: Generation 2 introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)
  - Lower latency for certain workloads. — [Microsoft Learn: AVS private-cloud generations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) · [Microsoft Learn: Generation 2 introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)
  - Better access from VMware workloads to native Azure services. — [Microsoft Learn: AVS private-cloud generations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) · [Microsoft Learn: Generation 2 introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)
- Conceptually shifts AVS from an isolated “island” to a more integrated part of the Azure network. — [Microsoft Learn: AVS private-cloud generations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) · [Microsoft Learn: Generation 2 introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)

### 3.3 Continuing requirement across both generations
- Regardless of generation, deployment begins with a tightly controlled network foundation. — [Microsoft Learn: AVS private-cloud generations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) · [Microsoft Learn: Generation 2 introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)
- The first major requirement is a contiguous management CIDR block that AVS can divide for internal use. — [Microsoft Learn: AVS private-cloud generations](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) · [Microsoft Learn: Generation 2 introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction)

---

## 4. The /22 Network Foundation

### 4.1 Minimum address space
- The deployment process requires a minimum contiguous `/22` network. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- A `/22` contains 1,024 total IPv4 addresses. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Once supplied, AVS takes control of the address block and divides it into deterministic internal subnets. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

### 4.2 Why AVS controls subnet allocation
- Core VMware components require stable and predictable addressing. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Internal consumers include: — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - vCenter. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - NSX Manager. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - ESXi host management interfaces. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - vMotion. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - vSAN. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Load balancers. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Identity and telemetry components. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Customer workloads are isolated from these internal infrastructure addresses. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

### 4.3 Example allocation described in the transcript

#### 4.3.1 Private cloud management subnet
- A `/26` is reserved for private-cloud management. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Provides 64 total addresses. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Hosts infrastructure such as: — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - vCenter Server Appliance. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Three-node NSX Manager cluster. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Internal load balancers. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Identity-related services. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Telemetry and management agents. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

#### 4.3.2 ESXi management subnet
- A `/25` is reserved for ESXi management VMkernel interfaces. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Each physical host requires an address so that vCenter can: — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Monitor the host. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Manage configuration. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Issue lifecycle and workload commands. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

#### 4.3.3 vMotion subnet
- A separate `/25` is dedicated to vMotion. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- vMotion moves the active memory and execution state of running VMs between hosts. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- The traffic is bursty and bandwidth-intensive. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Isolation prevents live-migration traffic from interfering with management or storage traffic. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

#### 4.3.4 vSAN subnet
- Another `/25` is dedicated to vSAN. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- vSAN aggregates local host storage into a shared distributed datastore. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- VM write operations may be synchronously replicated to another host. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Storage traffic is continuous and latency-sensitive. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Dedicated addressing and network isolation are required to prevent congestion. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

### 4.4 AVS as a structured micro–data center
- The transcript compares AVS network segmentation to structured memory allocation in software. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Management, migration, and storage traffic cannot simply share an undifferentiated network. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Each operational function requires its own protected capacity and failure boundary. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

---

## 5. The 96-Host Limit and Reserved Capacity

### 5.1 Apparent mathematical capacity
- A `/25` provides 128 total addresses. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- After reserved addresses, the subnet appears capable of supporting roughly 125 hosts. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

### 5.2 Supported host maximum
- The documented maximum described in the transcript is 96 hosts. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: AVS scale limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)
- The difference is deliberate rather than wasted capacity. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: AVS scale limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)

### 5.3 Reserved addresses
- Nineteen addresses are reserved for: — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Host replacement. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: AVS scale limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)
  - Platform upgrades. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: AVS scale limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)
  - Maintenance operations. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: AVS scale limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)
- Ten addresses are reserved for HCX-related functionality and migration activity. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

### 5.4 Why operational slack is necessary
- When a host fails, Microsoft must be able to introduce a replacement host before removing or repairing the failed one. — [Microsoft Learn: Private-cloud maintenance and blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- A replacement host requires management, vMotion, and storage addresses. — [Microsoft Learn: Private-cloud maintenance and blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- If every address were assigned to active hosts: — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: AVS scale limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)
  - Replacement provisioning would fail. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: AVS scale limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)
  - Automated self-healing would stop. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: AVS scale limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)
  - Maintenance could not proceed. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: AVS scale limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)
- The broader design lesson is that a resilient platform cannot operate safely at 100 percent capacity. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: AVS scale limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)

---

## 6. Prohibited and Reserved Address Ranges

### 6.1 General requirement
- Connected on-premises and Azure networks must not overlap with AVS internal ranges. — [Microsoft Learn: Connect AVS to on-premises with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)
- Overlap can cause control-plane routes to be mistaken for customer routes. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

### 6.2 `169.254.0.0/24`
- Used for internal AVS transit communication. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Must not be advertised from connected networks. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

### 6.3 `169.254.2.0/23`
- Described as being used for inter-VRF transit. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- VRFs provide separate virtual routing tables on shared routing infrastructure. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- AVS uses VRF separation to isolate tenant, management, and internal platform traffic. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Overlap can redirect internal control traffic toward a customer or on-premises network. — [Microsoft Learn: Connect AVS to on-premises with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)

### 6.4 `100.64.0.0/16`
- Identified as a particularly important prohibited range. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Used by the NSX architecture for internal communication between Tier-0 and Tier-1 gateways. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Although this range is associated with carrier-grade NAT, it is used internally by AVS/NSX. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Advertising the same range from a customer network can create routing ambiguity and potentially destabilize the overlay network. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

### 6.5 Planning lesson
- Address-space review must occur before deployment. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Architects must audit: — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - On-premises routes. — [Microsoft Learn: Connect AVS to on-premises with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)
  - Azure VNet address spaces. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - BGP advertisements. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Merger or acquisition networks. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Future expansion ranges. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- A deployment that works initially may become difficult or impossible to expand if address-space conflicts are discovered later. — [Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

---

## 7. Internet Connectivity: Generation 1 Managed SNAT

### 7.1 Managed SNAT purpose
- Provides outbound internet connectivity by translating private RFC 1918 addresses to a public address. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
- Designed as a managed, minimal-connectivity option. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)

### 7.2 Connection limitation
- The transcript describes a limit of 128,000 concurrent connections. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads) · [Microsoft Learn: Internet-connectivity design](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-design-public-internet-access)
- This can be restrictive for: — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
  - Large VM estates. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
  - Simultaneous operating-system updates. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
  - Microservices. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
  - Applications that rapidly create ephemeral TCP sessions. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
- Once the translation table is exhausted, new connections are dropped even though the underlying network remains available. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)

### 7.3 Functional restrictions
- ICMP is disabled, preventing internet ping tests. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads) · [Microsoft Learn: Internet-connectivity design](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-design-public-internet-access)
- Customers cannot: — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
  - Define custom outbound SNAT rules. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads) · [Microsoft Learn: Internet-connectivity design](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-design-public-internet-access)
  - Select or control the public IP address. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads) · [Microsoft Learn: Internet-connectivity design](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-design-public-internet-access)
  - Accept inbound internet-initiated connections. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads) · [Microsoft Learn: Internet-connectivity design](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-design-public-internet-access)
  - View detailed outbound connection logs. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads) · [Microsoft Learn: Internet-connectivity design](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-design-public-internet-access)

### 7.4 Design rationale
- Managed SNAT is presented as a deliberately restrictive shared-edge service. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads) · [Microsoft Learn: Internet-connectivity design](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-design-public-internet-access)
- Microsoft prioritized: — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
  - Platform stability. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
  - Security. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
  - Isolation of management infrastructure. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
  - Reduced risk from incorrect tenant NAT rules. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
- The tradeoff is reduced enterprise control and limited troubleshooting visibility. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)

### 7.5 Enterprise limitations
- The model is poorly suited to organizations that require: — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
  - Compliance logging. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
  - Static egress IP addresses. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
  - Third-party allowlisting. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
  - Custom inbound or outbound NAT. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)
  - Detailed security inspection. — [Microsoft Learn: Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads)

---

## 8. Internet Connectivity: Generation 2 Native Azure Networking

### 8.1 Removal of the managed-SNAT model
- Generation 2 shifts internet egress responsibility to the customer. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
- AVS networking is connected more directly to native Azure VNets. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)

### 8.2 User-defined routes
- The transcript describes associating UDRs with AVS-related Azure subnets. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
- A `0.0.0.0/0` route is directed to: — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
  - Azure Firewall, or — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
  - A third-party network virtual appliance such as Palo Alto or Fortinet. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)

### 8.3 Customer operational responsibilities
- The customer must deploy and manage: — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
  - Firewall infrastructure. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
  - NAT rules. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
  - Route tables. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
  - Security policy. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
  - Logging. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
  - Capacity. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
  - Availability. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
- Microsoft connects AVS to the Azure network, but the customer controls the path from the VNet to the public internet. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)

### 8.4 Enterprise benefit
- Organizations can apply the same security patterns used in their physical data centers. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
- Generation 2 provides greater: — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
  - Policy control. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
  - Logging. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
  - Egress consistency. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
  - Third-party firewall integration. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)
  - Network troubleshooting visibility. — [Microsoft Learn: Gen 2 internet connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations)

---

## 9. Corporate Connectivity and VPN Scale Units

### 9.1 Connectivity options
- AVS workloads may need access to: — [Microsoft Learn: AVS networking checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
  - On-premises data centers. — [Microsoft Learn: Connect AVS to on-premises with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)
  - Branch offices. — [Microsoft Learn: Connect AVS to on-premises with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)
  - Legacy databases. — [Microsoft Learn: AVS networking checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
  - Corporate identity and management services. — [Microsoft Learn: AVS networking checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
- Connectivity can be provided through: — [Microsoft Learn: AVS networking checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
  - Site-to-site IPsec VPN. — [Microsoft Learn: Connect AVS to on-premises with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
  - ExpressRoute. — [Microsoft Learn: Connect AVS to on-premises with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)
  - Azure Virtual WAN. — [Microsoft Learn: AVS networking checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)

### 9.2 VPN protocol support discussed
- IPsec tunnels may use IKEv1 or IKEv2. — [Microsoft Learn: Connect AVS to on-premises with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
- VPN gateways perform both packet forwarding and computationally expensive encryption/decryption. — [Microsoft Learn: Virtual WAN site-to-site gateway sizing](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal) · [Microsoft Learn: Virtual WAN scale units](https://learn.microsoft.com/en-us/azure/virtual-wan/pricing-concepts) · [Microsoft Learn: Virtual WAN VPN capacity](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq)

### 9.3 Scale-unit model
- One scale unit is described as 500 Mbps of aggregate VPN bandwidth. — [Microsoft Learn: Virtual WAN site-to-site gateway sizing](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal) · [Microsoft Learn: Virtual WAN scale units](https://learn.microsoft.com/en-us/azure/virtual-wan/pricing-concepts) · [Microsoft Learn: Virtual WAN VPN capacity](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq)
- Deploying a scale unit automatically provisions two gateway instances for high availability. — [Microsoft Learn: Virtual WAN site-to-site gateway sizing](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal) · [Microsoft Learn: Virtual WAN scale units](https://learn.microsoft.com/en-us/azure/virtual-wan/pricing-concepts) · [Microsoft Learn: Virtual WAN VPN capacity](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq)
- The pair may operate in active-active or active-standby form depending on the service design. — [Microsoft Learn: AVS networking checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)

### 9.4 Aggregate-bandwidth calculation
- Branch requirements must be calculated collectively at the hub. — [Microsoft Learn: AVS networking checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
- Example: — [Microsoft Learn: AVS networking checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
  - Five branches at 10 Mbps each require 50 Mbps aggregate. — [Microsoft Learn: AVS networking checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
- The gateway must support all concurrent encrypted traffic, not merely the requirement of an individual branch. — [Microsoft Learn: Virtual WAN site-to-site gateway sizing](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal) · [Microsoft Learn: Virtual WAN scale units](https://learn.microsoft.com/en-us/azure/virtual-wan/pricing-concepts) · [Microsoft Learn: Virtual WAN VPN capacity](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq)

### 9.5 Cryptographic bottleneck
- IPsec gateway performance is constrained by CPU and memory needed for AES encryption and decryption. — [Microsoft Learn: Virtual WAN site-to-site gateway sizing](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal) · [Microsoft Learn: Virtual WAN scale units](https://learn.microsoft.com/en-us/azure/virtual-wan/pricing-concepts) · [Microsoft Learn: Virtual WAN VPN capacity](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq)
- If undersized: — [Microsoft Learn: AVS networking checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
  - Physical links may appear healthy. — [Microsoft Learn: AVS networking checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
  - Gateway buffers fill. — [Microsoft Learn: Virtual WAN site-to-site gateway sizing](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal) · [Microsoft Learn: Virtual WAN scale units](https://learn.microsoft.com/en-us/azure/virtual-wan/pricing-concepts) · [Microsoft Learn: Virtual WAN VPN capacity](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq)
  - Packets are silently dropped. — [Microsoft Learn: AVS networking checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
  - File transfers and applications slow or time out. — [Microsoft Learn: AVS networking checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
- The transcript distinguishes a processor bottleneck from a raw link-bandwidth bottleneck. — [Microsoft Learn: AVS networking checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)

---

## 10. Hot-Potato and Cold-Potato Routing

### 10.1 Routing-preference decision
- Azure routing preference determines how long traffic remains on Microsoft’s global network before being handed to an ISP. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)

### 10.2 Hot-potato routing
- Traffic leaves Microsoft’s network as soon as possible. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
- It then traverses the public internet for most of the path. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
- Advantages: — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
  - Lower provider cost. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
  - Potentially lower network-service expense. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
- Disadvantages: — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
  - Less predictable latency. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
  - Greater exposure to public internet congestion. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
  - Dependence on ISP peering and BGP conditions. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)

### 10.3 Cold-potato routing
- Microsoft retains traffic on its private global backbone for as long as possible. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
- Traffic is handed to the destination ISP near the endpoint. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
- Advantages: — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
  - More predictable performance. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
  - Lower or more stable latency. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
  - Reduced exposure to public internet variability. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
- Tradeoff: — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
  - Different cost implications. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)

### 10.4 Architectural lesson
- Routing preference should be based on workload requirements rather than chosen as a generic default. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)
- Architects must consciously balance cost against performance predictability. — [Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview)

---

## 11. BGP and the 1,000-Prefix Limit

### 11.1 Role of BGP
- Border Gateway Protocol advertises the location of NSX segments to Azure networking. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- Each advertised network consumes an entry in an Azure routing table. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

### 11.2 Finite routing capacity
- The Generation 2 design described in the transcript has a maximum of 1,000 prefixes in the connected Azure virtual network. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- A summarized network may represent thousands of addresses while using one route. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- Poorly summarized or host-specific routes consume the same table much more quickly. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

### 11.3 Importance of route summarization
- A single summarized `/16` consumes one route entry. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- Hundreds of individual routes can consume hundreds of entries even if they represent fewer addresses. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- Route planning is therefore a capacity-management exercise, not merely a connectivity exercise. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

---

## 12. HCX Mobility Optimized Networking and /32 Route Exhaustion

### 12.1 Purpose of HCX MON
- Mobility Optimized Networking allows a migrated VM to retain its original on-premises IP address. — [Microsoft Learn: HCX MON guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance) · [Microsoft Learn: Gen 2 route limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- Avoids immediate changes to: — [Microsoft Learn: HCX MON guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance) · [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
  - DNS. — [Microsoft Learn: Configure an AVS DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution) · [Microsoft Learn: Network port requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Firewall rules. — [Microsoft Learn: HCX MON guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance) · [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
  - Application configuration. — [Microsoft Learn: HCX MON guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance) · [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
  - IP-based dependencies. — [Microsoft Learn: HCX MON guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance) · [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

### 12.2 Use of host routes
- To preserve the IP while moving the VM, HCX advertises a `/32` route. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture) · [Microsoft Learn: HCX MON guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)
- A `/32` represents one individual IP address rather than an address block. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture) · [Microsoft Learn: HCX MON guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)

### 12.3 Capacity risk
- Migrating 999 VMs using persistent `/32` advertisements can consume 999 of the 1,000 route entries. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture) · [Microsoft Learn: HCX MON guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)
- Only one route would remain for other Azure, AVS, or on-premises connectivity. — [Microsoft Learn: Connect AVS to on-premises with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)
- The environment may work during early migration waves and then fail abruptly as the route table fills. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

### 12.4 Required migration discipline
- MON should be treated as a migration mechanism rather than a permanent routing design. — [Microsoft Learn: HCX MON guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance) · [Microsoft Learn: Gen 2 route limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- After migration: — [Microsoft Learn: HCX MON guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance) · [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
  - Workloads should be transitioned to cloud-native addressing where appropriate. — [Microsoft Learn: HCX MON guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance) · [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
  - Routes should be summarized. — [Microsoft Learn: HCX MON guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance) · [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
  - Temporary host routes should be removed. — [Microsoft Learn: HCX MON guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance) · [Microsoft Learn: Gen 2 route limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- Failure to clean up migration routes can turn a successful migration tool into a long-term scalability problem. — [Microsoft Learn: HCX MON guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance) · [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

---

## 13. Tier-0 NIC Prefix Limits and /28 Expansion

### 13.1 Per-NIC route constraint
- The transcript describes a 1,024-prefix limitation per Tier-0 NIC for NSX segments. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

### 13.2 Automatic route decomposition
- NSX may divide a larger advertised segment into `/28` blocks. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- A `/28` represents 16 IPv4 addresses. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- These blocks are distributed across Tier-0 virtual NICs to load-balance inbound traffic. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

### 13.3 Effect of advertising a large block
- A `/16` contains 65,536 addresses. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- Dividing it into `/28` blocks produces 4,096 smaller routes. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- A single large advertisement can therefore expand into thousands of internal route entries. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- This expansion may exceed per-NIC limits even though the customer believes only one summary route was advertised. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

### 13.4 Operational risk
- The internal routing daemon may: — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
  - Stop accepting additional routes. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
  - Stop advertising segments. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
  - Lose connectivity to portions of the environment. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- Architects must understand both the customer-visible route count and the way NSX transforms routes internally. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

---

## 14. Cluster Size and Logical Routing Capacity

### 14.1 Three-node capacity
- The transcript states that a standard three-node private cloud supports 4,096 `/28` routes. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

### 14.2 Four-node capacity
- Adding a fourth host increases the described capacity to 6,144 `/28` routes. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

### 14.3 Why hardware changes a software-defined limit
- NSX Edge appliances run as virtual workloads on ESXi hosts. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- Adding a physical host gives NSX more compute and placement capacity. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- The platform can scale out internal Edge components and virtual NICs. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- More NICs provide additional distribution points for the `/28` advertisements. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

### 14.4 Key takeaway
- Scaling the physical cluster can increase logical network capacity. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- A host purchase may therefore increase: — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
  - VM compute. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
  - Storage. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
  - NSX Edge capacity. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
  - BGP route capacity. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)
- Hardware sizing and network scale cannot be planned independently. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture)

---

## 15. NSX Tier-0 and Tier-1 Gateway Architecture

### 15.1 Tier-0 gateway
- Serves as the edge routing boundary of the private cloud. — [Microsoft Learn: NSX gateway defaults](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Tier-1 gateway configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
- Exchanges BGP routes with the Azure network. — [Microsoft Learn: NSX gateway defaults](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Tier-1 gateway configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
- Runs in active-active mode. — [Microsoft Learn: NSX segment and default gateway modes](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Create a Tier-1 gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
- Active-active operation allows multiple uplinks to process traffic concurrently. — [Microsoft Learn: NSX segment and default gateway modes](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Create a Tier-1 gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)

### 15.2 Why active-active works for Tier-0
- Basic routing is treated as stateless. — [Microsoft Learn: NSX gateway defaults](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Tier-1 gateway configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
- The device forwards packets without needing to remember an entire application session. — [Microsoft Learn: NSX gateway defaults](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Tier-1 gateway configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
- Traffic can use multiple paths without breaking state tables. — [Microsoft Learn: NSX gateway defaults](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Tier-1 gateway configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)

### 15.3 Tier-1 gateway
- Sits beneath Tier-0 and connects logical workload segments. — [Microsoft Learn: NSX gateway defaults](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Tier-1 gateway configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
- Hosts stateful services such as: — [Microsoft Learn: NSX segment and default gateway modes](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Create a Tier-1 gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
  - NAT. — [Microsoft Learn: NSX gateway defaults](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Tier-1 gateway configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
  - Stateful firewall policy. — [Microsoft Learn: NSX gateway defaults](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Tier-1 gateway configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
  - Session-aware traffic processing. — [Microsoft Learn: NSX gateway defaults](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Tier-1 gateway configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
- Runs in active-standby mode. — [Microsoft Learn: NSX segment and default gateway modes](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Create a Tier-1 gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)

### 15.4 Why Tier-1 uses active-standby
- Stateful services must remember TCP session context. — [Microsoft Learn: NSX segment and default gateway modes](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Create a Tier-1 gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
- If an outbound SYN traverses one gateway but the returning SYN-ACK arrives at another gateway with no matching state: — [Microsoft Learn: NSX gateway defaults](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Tier-1 gateway configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
  - The return packet is treated as unsolicited. — [Microsoft Learn: NSX gateway defaults](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Tier-1 gateway configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
  - The packet is dropped. — [Microsoft Learn: NSX gateway defaults](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Tier-1 gateway configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
  - The connection fails. — [Microsoft Learn: NSX gateway defaults](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Tier-1 gateway configuration](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
- Active-standby preserves one authoritative session table while retaining failover capability. — [Microsoft Learn: NSX segment and default gateway modes](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Create a Tier-1 gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)

---

## 16. Creating NSX Segments: Azure Portal Versus NSX Manager

### 16.1 Azure portal experience
- Provides a simplified segment-creation interface. — [Microsoft Learn: Add an NSX segment](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)
- The operator supplies: — [Microsoft Learn: Add an NSX segment](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)
  - Segment name. — [Microsoft Learn: Add an NSX segment](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)
  - Address block. — [Microsoft Learn: Add an NSX segment](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)
  - Basic configuration. — [Microsoft Learn: Add an NSX segment](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)
- The portal automatically attaches the segment to the default pre-provisioned Tier-1 gateway. — [Microsoft Learn: NSX segment and default gateway modes](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Create a Tier-1 gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)

### 16.2 Limitation of the simplified interface
- The portal removes the ability to select a custom Tier-1 gateway. — [Microsoft Learn: NSX segment and default gateway modes](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Create a Tier-1 gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
- It is suitable for standard topologies but not for advanced isolation or multi-tenant designs. — [Microsoft Learn: Add an NSX segment](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)

### 16.3 NSX Manager requirement
- Custom routing and gateway attachment must be configured in native NSX Manager. — [Microsoft Learn: Add an NSX network segment](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)
- Examples include: — [Microsoft Learn: Add an NSX segment](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)
  - Separate Tier-1 gateways. — [Microsoft Learn: NSX segment and default gateway modes](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Create a Tier-1 gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
  - Tenant isolation. — [Microsoft Learn: Add an NSX segment](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)
  - Specialized route domains. — [Microsoft Learn: Add an NSX segment](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)
  - Non-default security boundaries. — [Microsoft Learn: Add an NSX segment](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)

### 16.4 Design lesson
- Simplified cloud interfaces reduce operational complexity by removing choices. — [Microsoft Learn: Add an NSX segment](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)
- Advanced architectures require deeper knowledge of the underlying platform. — [Microsoft Learn: Add an NSX segment](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)

---

## 17. DHCP Design and Broadcast Traffic

### 17.1 DHCP discovery behavior
- A newly started VM does not initially know: — [Microsoft Learn: Configure DHCP](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution) · [Microsoft Learn: DHCP on HCX L2 extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)
  - Its IP address. — [Microsoft Learn: Configure DHCP](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution) · [Microsoft Learn: DHCP on HCX L2 extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)
  - Its subnet. — [Microsoft Learn: Configure DHCP](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution) · [Microsoft Learn: DHCP on HCX L2 extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)
  - Its default gateway. — [Microsoft Learn: Configure DHCP](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution) · [Microsoft Learn: DHCP on HCX L2 extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)
  - Its DHCP server. — [Microsoft Learn: Configure DHCP server or relay](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution)
- It sends a Layer 2 broadcast to request configuration. — [Microsoft Learn: Configure DHCP server or relay](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution) · [Microsoft Learn: DHCP on HCX L2 stretched networks](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)

### 17.2 Problem with remote DHCP
- Sending DHCP traffic to an on-premises server over a WAN or ExpressRoute path creates a long dependency chain. — [Microsoft Learn: Configure DHCP server or relay](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution)
- The request may traverse: — [Microsoft Learn: Configure DHCP](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution) · [Microsoft Learn: DHCP on HCX L2 extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)
  - Virtual switch. — [Microsoft Learn: Configure DHCP](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution) · [Microsoft Learn: DHCP on HCX L2 extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)
  - Tier-1 gateway. — [Microsoft Learn: Configure DHCP](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution) · [Microsoft Learn: DHCP on HCX L2 extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)
  - Tier-0 gateway. — [Microsoft Learn: Configure DHCP](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution) · [Microsoft Learn: DHCP on HCX L2 extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)
  - VPN or ExpressRoute. — [Microsoft Learn: Connect AVS to on-premises with ExpressRoute Global Reach](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud) · [Microsoft Learn: Virtual WAN site-to-site VPN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal)
  - Physical network. — [Microsoft Learn: Configure DHCP](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution) · [Microsoft Learn: DHCP on HCX L2 extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)
  - Remote DHCP server. — [Microsoft Learn: Configure DHCP server or relay](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution)
- This design adds latency, consumes WAN resources, and introduces multiple failure points. — [Microsoft Learn: Configure DHCP](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution) · [Microsoft Learn: DHCP on HCX L2 extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)

### 17.3 HCX Layer 2 extension behavior
- In a stretched Layer 2 network, NSX may intercept and drop DHCP broadcasts. — [Microsoft Learn: Configure DHCP server or relay](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution) · [Microsoft Learn: DHCP on HCX L2 stretched networks](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)
- This prevents: — [Microsoft Learn: Configure DHCP](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution) · [Microsoft Learn: DHCP on HCX L2 extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)
  - Broadcast storms. — [Microsoft Learn: Configure DHCP server or relay](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution)
  - Rogue DHCP servers. — [Microsoft Learn: Configure DHCP server or relay](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution)
  - Cross-site DHCP contamination. — [Microsoft Learn: Configure DHCP server or relay](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution)
- A migrated VM may fail to receive an address and fall back to an APIPA address. — [Microsoft Learn: Configure DHCP server or relay](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution)

### 17.4 Recommended approaches in the transcript
- Deploy an NSX-local DHCP server. — [Microsoft Learn: Configure DHCP server or relay](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution)
- Configure a DHCP relay on the NSX segment. — [Microsoft Learn: Configure DHCP server or relay](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution)
- A relay converts the local broadcast into directed unicast traffic toward the remote DHCP server. — [Microsoft Learn: Configure DHCP server or relay](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution)

### 17.5 Design principle
- Keep broadcast-dependent infrastructure local whenever possible. — [Microsoft Learn: Configure DHCP server or relay](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution)
- Do not assume Layer 2 behavior will transparently extend across cloud and WAN boundaries. — [Microsoft Learn: Configure DHCP](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution) · [Microsoft Learn: DHCP on HCX L2 extensions](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)

---

## 18. DNS Dependency

### 18.1 Default-route implication
- If AVS receives or uses a `0.0.0.0/0` default route, DNS forwarders must still be able to resolve public names. — [Microsoft Learn: Configure an AVS DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution) · [Microsoft Learn: Network port requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

### 18.2 Required traffic
- The transcript specifically calls out UDP port 53. — [Microsoft Learn: Configure an AVS DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution) · [Microsoft Learn: Network port requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Blocking DNS prevents services from functioning even when general routing is otherwise correct. — [Microsoft Learn: Configure an AVS DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution) · [Microsoft Learn: Network port requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

### 18.3 Troubleshooting lesson
- Network reachability is insufficient if name resolution cannot follow the same egress path. — [Microsoft Learn: Configure an AVS DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution)
- Firewall and route reviews must include DNS dependencies. — [Microsoft Learn: Configure an AVS DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution) · [Microsoft Learn: Network port requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

---

## 19. Firewall Port Dependencies and Silent Failures

### 19.1 TCP 80 and vCenter redirection
- An administrator may verify that HTTPS/TCP 443 is open yet still fail to reach vCenter. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- TCP 80 is required for the initial HTTP connection and redirection to HTTPS. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Blocking port 80 as “insecure” can prevent the browser from reaching the secure page. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

### 19.2 Active Directory and LDAP
- TCP 389 supports LDAP. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- TCP 636 supports secure LDAP. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- These ports may be sufficient for same-domain authentication. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

### 19.3 Active Directory Global Catalog
- TCP 3268 supports Global Catalog queries. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- TCP 3269 supports secure Global Catalog queries. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- If blocked: — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Local-domain logins may work. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Cross-domain authentication may fail. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Partial success can mislead troubleshooting. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

### 19.4 HCX migration control channel
- The transcript identifies TCP 8123 as a required HCX bulk-migration control-channel port. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Disk data may copy successfully while final migration control operations fail. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- The migration can remain at 99 percent and eventually time out. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

### 19.5 IPsec NAT traversal
- UDP 4500 is required for IPsec NAT traversal and encapsulated encrypted traffic. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Initial negotiation may succeed on UDP 500 while actual data traffic fails if UDP 4500 is blocked. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

### 19.6 General pattern
- AVS failures may be silent or indirect: — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Browser pages spin. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Authentication works only for some users. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - Migrations stall near completion. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
  - VPNs establish but pass no data. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Understanding why each port is required is more useful than applying an unexplained port list. — [Microsoft Learn: AVS required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)

---

## 20. Transient Faults and Application Resilience

### 20.1 Transient faults are normal
- Short, intermittent failures are described as expected in hyperscale environments. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)
- The cloud consists of large amounts of physical: — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)
  - Compute. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)
  - Memory. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)
  - Storage. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)
  - Networking. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)
- At that scale, some component is always failing or being repaired. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)

### 20.2 Application responsibility
- Applications should implement: — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)
  - Retry logic. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)
  - Exponential backoff. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)
  - Circuit breakers. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults) · [Microsoft Learn: Circuit Breaker pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker)
  - Tolerance for brief connectivity loss. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)
- Infrastructure redundancy cannot eliminate every millisecond-scale interruption. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)

### 20.3 Broader lesson
- Cloud resilience requires both: — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)
  - Platform-level high availability. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)
  - Application-level fault handling. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)

---

## 21. Single-Host Failure: vSphere HA and vSAN

### 21.1 Host monitoring
- vSphere High Availability continuously monitors host heartbeats. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Private clouds and clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
- A catastrophic host failure is detected when the host stops responding. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Private clouds and clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)

### 21.2 VM recovery
- vSphere HA restarts affected VMs on surviving hosts. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Private clouds and clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
- The VMs are rebooted rather than continuing without interruption. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Private clouds and clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)

### 21.3 Data availability through vSAN
- vSAN aggregates local NVMe storage across the cluster. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Private clouds and clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
- Writes are synchronously copied to another host according to storage policy. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Private clouds and clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
- When one host fails: — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Private clouds and clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
  - Another host retains a current copy of the data. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Private clouds and clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
  - The VM can restart elsewhere. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Private clouds and clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
  - Storage pointers are redirected to surviving components. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Private clouds and clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)

### 21.4 Limits of the protection
- vSphere HA reduces infrastructure recovery time but does not preserve active TCP sessions. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Private clouds and clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
- Applications must still handle the reboot and reconnection. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Private clouds and clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)

---

## 22. Stretched Clusters and Availability Zones

### 22.1 Supported scenario
- Stretched clusters distribute a single vSphere/vSAN cluster across two Azure availability zones. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) · [Microsoft Learn: Deploy a vSAN stretched cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-vsan-stretched-clusters) · [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)
- The transcript states that this capability is limited to certain Generation 1 SKUs, including AV36, AV36P, and AV52. — **Documentation note:** Current regional and SKU support is listed in the stretched-cluster design guide; AV64 is not supported. [Microsoft Learn: Stretched-cluster design and availability](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) · [Microsoft Learn: AVS host types](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
- The newer denser AV64-class SKU described in the transcript is stated not to support the feature. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

### 22.2 Minimum host layout
- Requires at least six hosts: — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
  - Three in Availability Zone 1. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) · [Microsoft Learn: Deploy a vSAN stretched cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-vsan-stretched-clusters) · [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)
  - Three in Availability Zone 2. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) · [Microsoft Learn: Deploy a vSAN stretched cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-vsan-stretched-clusters) · [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)

### 22.3 Availability-zone separation
- Zones are physically separate data centers within one Azure region. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- They have independent: — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
  - Power. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
  - Cooling. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
  - Physical facilities. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
  - Network paths. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- A facility-level failure in one zone should not physically affect the other. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

### 22.4 Synchronous storage replication
- vSAN replicates writes across zones. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- A write is not acknowledged until the required remote copy is committed. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- This design targets zero data loss for a zone failure. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) · [Microsoft Learn: Deploy a vSAN stretched cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-vsan-stretched-clusters) · [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)

### 22.5 Active-active cluster behavior
- Both zones contribute resources while the inter-zone links are healthy. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- The design must still prevent both sides from independently assuming ownership when connectivity is lost. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

---

## 23. Split-Brain Risk

### 23.1 Failure scenario
- Both zones remain powered and operational. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- The network link between them is severed. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- Each zone can no longer see the other. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

### 23.2 Competing interpretations
- Zone 1 may assume Zone 2 failed. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- Zone 2 may assume Zone 1 failed. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- Without coordination, both could attempt to: — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
  - Run the same VMs. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
  - Use the same IP addresses. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
  - Modify separate copies of the same data. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

### 23.3 Consequences
- Divergent storage writes. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- File-system corruption. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- Database corruption. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- Duplicate application instances. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- Extended outage and restore requirements after connectivity is repaired. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

---

## 24. Witness Node and Quorum

### 24.1 Third-site witness
- A small witness appliance is deployed in a third availability zone. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) · [Microsoft Learn: Deploy a vSAN stretched cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-vsan-stretched-clusters) · [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)
- It runs a specialized ESXi image. — [Microsoft Learn: Stretched-cluster witness and split-brain protection](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- It does not host normal customer workloads or full customer-data copies. — [Microsoft Learn: Stretched-cluster witness and split-brain protection](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- It stores metadata and participates in cluster voting. — [Microsoft Learn: Stretched-cluster witness and split-brain protection](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

### 24.2 Quorum model
- The two data sites and the witness represent three voting members. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) · [Microsoft Learn: Deploy a vSAN stretched cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-vsan-stretched-clusters) · [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)
- A site requires a majority to remain active. — [Microsoft Learn: Stretched-cluster witness and split-brain protection](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

### 24.3 Fiber-cut example
- Zone 1 and Zone 2 lose direct connectivity. — [Microsoft Learn: Stretched-cluster witness and split-brain protection](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- Each contacts the witness over an independent path. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) · [Microsoft Learn: Deploy a vSAN stretched cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-vsan-stretched-clusters) · [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)
- The witness grants its vote to one side. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) · [Microsoft Learn: Deploy a vSAN stretched cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-vsan-stretched-clusters) · [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)
- The winning side obtains two of three votes and continues serving workloads. — [Microsoft Learn: Stretched-cluster witness and split-brain protection](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- The losing side cannot reach quorum and suspends storage I/O. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) · [Microsoft Learn: Deploy a vSAN stretched cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-vsan-stretched-clusters) · [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)

### 24.4 Protection mechanism
- The isolated side deliberately “stuns” or stops itself. — [Microsoft Learn: Stretched-cluster witness and split-brain protection](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- Suspending writes prevents both sites from creating divergent data. — [Microsoft Learn: Stretched-cluster witness and split-brain protection](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- Service continuity is favored on the quorum side while data integrity is preserved globally. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) · [Microsoft Learn: Deploy a vSAN stretched cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-vsan-stretched-clusters) · [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)

---

## 25. Availability-Zone Failure Sequence

### 25.1 Detection and notification
- Customers should monitor Azure Resource Health and Service Health. — [Microsoft Learn: Configure AVS alerts](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-alerts-for-azure-vmware-solution) · [Microsoft Learn: AVS customer communication](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
- The transcript states that customers should not rely on a proactive phone call from Microsoft. — **Documentation note:** Microsoft documents Service Health notifications for upgrades and email notifications for host replacement to eligible subscription roles. [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance) · [Microsoft Learn: AVS customer communication](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)

### 25.2 Immediate workload impact
- Active TCP connections to VMs in the failed zone terminate. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- Applications experience errors or reconnect events. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

### 25.3 Recovery
- The surviving zone communicates with the witness and obtains quorum. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) · [Microsoft Learn: Deploy a vSAN stretched cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-vsan-stretched-clusters) · [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)
- vSphere HA restarts failed VMs on hosts in the surviving zone. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- Recovery is described as occurring within minutes. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

### 25.4 Data protection
- Synchronous vSAN replication means committed writes already exist in the surviving zone. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- The design targets zero data loss. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) · [Microsoft Learn: Deploy a vSAN stretched cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-vsan-stretched-clusters) · [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)

### 25.5 Degraded operation
- The private cloud remains available with reduced compute and storage capacity. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)
- Full redundancy is restored only after Microsoft repairs the failed zone and rebalances the cluster. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters)

---

## 26. Platform Lifecycle and Shared Maintenance Responsibilities

### 26.1 Microsoft-managed components
- Microsoft manages lifecycle operations for: — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - ESXi. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - vCenter. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - vSAN. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - NSX appliances. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Physical server firmware. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Hardware replacement. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 26.2 Customer-managed conditions
- Customers must keep the environment eligible for automated maintenance. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- Customer configuration can prevent Microsoft from completing: — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Host evacuation. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Platform upgrades. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Security patching. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Hardware remediation. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 26.3 Operational tension
- Microsoft owns the automation, but the automation depends on customer workloads being portable and storage being sufficiently available. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- Shared responsibility therefore applies during maintenance, not just during initial deployment. — [Microsoft Learn: Private-cloud maintenance](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

---

## 27. The 75 Percent vSAN Storage Rule

### 27.1 Utilization requirement
- The transcript describes a hard requirement to keep vSAN storage below 75 percent utilization. — [Microsoft Learn: Private-cloud maintenance and blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 27.2 Host remediation process
- Microsoft introduces a healthy replacement host into the cluster. — [Microsoft Learn: Private-cloud maintenance and blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- The target host is placed into maintenance mode. — [Microsoft Learn: Private-cloud maintenance and blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- vMotion moves running VM compute and memory state. — [Microsoft Learn: vSAN maintenance readiness](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- vSAN evacuates or rebuilds storage components from the host. — [Microsoft Learn: vSAN maintenance readiness](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 27.3 Why free capacity is necessary
- Remaining hosts must temporarily absorb the data located on the host being removed. — [Microsoft Learn: vSAN maintenance readiness](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- At 90 percent utilization, there may be insufficient space to: — [Microsoft Learn: vSAN maintenance readiness](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Rebuild components. — [Microsoft Learn: vSAN maintenance readiness](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Preserve storage policy. — [Microsoft Learn: vSAN maintenance readiness](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Maintain fault tolerance. — [Microsoft Learn: vSAN maintenance readiness](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- Evacuation can fill the datastore and fail. — [Microsoft Learn: vSAN maintenance readiness](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 27.4 Purpose of the buffer
- The 25 percent free-space reserve gives vSAN room to: — [Microsoft Learn: vSAN maintenance readiness](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Move data. — [Microsoft Learn: vSAN maintenance readiness](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Reprotect objects. — [Microsoft Learn: vSAN maintenance readiness](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Replace hosts. — [Microsoft Learn: vSAN maintenance readiness](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Perform upgrades. — [Microsoft Learn: vSAN maintenance readiness](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- Paid storage capacity cannot safely be treated as fully consumable capacity. — [Microsoft Learn: vSAN maintenance readiness](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

---

## 28. Maintenance Blocker: Emulated Virtual CD-ROM

### 28.1 Alert condition
- The transcript references an alert similar to `EPC_CD-ROM_EMULATE_MODE`. — [Microsoft Learn: Private-cloud maintenance and blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- A VM has a mounted virtual CD-ROM configured in emulation mode. — [Microsoft Learn: Private-cloud maintenance and blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 28.2 Why it prevents vMotion
- The hypervisor translates legacy IDE or SATA device behavior. — [Microsoft Learn: CD-ROM maintenance blocker](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- The VM may retain state tied to the source host’s emulated hardware context. — [Microsoft Learn: CD-ROM maintenance blocker](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- vMotion cannot guarantee that the virtual device state can be serialized and recreated safely on another host. — [Microsoft Learn: CD-ROM maintenance blocker](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 28.3 Operational chain reaction
- vMotion aborts. — [Microsoft Learn: CD-ROM maintenance blocker](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- The VM remains pinned to the host. — [Microsoft Learn: CD-ROM maintenance blocker](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- The host cannot enter maintenance mode. — [Microsoft Learn: Private-cloud maintenance and blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- Patching and remediation stop. — [Microsoft Learn: CD-ROM maintenance blocker](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 28.4 Cultural lesson
- Legacy virtual devices that were harmless in a manually managed data center can become blockers in an automated cloud platform. — [Microsoft Learn: CD-ROM maintenance blocker](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- Unused ISOs and virtual media should be detached as part of routine hygiene. — [Microsoft Learn: CD-ROM maintenance blocker](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

---

## 29. Maintenance Blockers: Serial Ports and Other Hardware Devices

### 29.1 Examples
- Virtual serial ports. — [Microsoft Learn: Private-cloud maintenance and blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- Parallel ports. — [Microsoft Learn: Private-cloud maintenance and blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- USB controllers. — [Microsoft Learn: Private-cloud maintenance and blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- Other host-specific or nonportable device mappings. — [Microsoft Learn: Virtual-device maintenance blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 29.2 Failure mechanism
- The destination host may not expose the identical device mapping. — [Microsoft Learn: Virtual-device maintenance blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- The VM becomes anchored to the source host. — [Microsoft Learn: Virtual-device maintenance blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- vMotion refuses the move to prevent guest failure or loss of device state. — [Microsoft Learn: Virtual-device maintenance blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 29.3 Operational implication
- VM portability must be treated as a platform requirement. — [Microsoft Learn: Virtual-device maintenance blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- Administrators should remove unnecessary virtual hardware and avoid host-specific mappings. — [Microsoft Learn: Virtual-device maintenance blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

---

## 30. Maintenance Blocker: FTT Set to Zero

### 30.1 Failures to Tolerate
- FTT is a vSAN policy defining how many failures a VM’s storage can withstand. — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- It controls how many redundant copies or equivalent protected components exist. — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 30.2 Why FTT 0 may be selected
- Administrators may use it for: — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Temporary data. — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Scratch disks. — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Large logging workloads. — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Noncritical datasets. — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- The goal is often to conserve expensive vSAN capacity. — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 30.3 Maintenance conflict
- FTT 0 leaves only one copy of data. — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- If that copy resides on the host being remediated: — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Taking the host offline would make the data unavailable. — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - vSAN cannot maintain the required availability. — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
  - Automation refuses to continue. — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 30.4 Required policies stated in the transcript
- FTT 1 for clusters with up to five hosts. — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- FTT 2 for clusters with six or more hosts. — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

### 30.5 Design lesson
- Redundancy settings affect more than disaster recovery. — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- They determine whether the platform can perform routine maintenance without violating availability commitments. — [Microsoft Learn: FTT maintenance requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)

---

## 31. Self-Service Maintenance Scheduling

### 31.1 Customer scheduling control
- A healthy and compliant environment can use self-service scheduling. — [Microsoft Learn: Maintenance orchestration](https://learn.microsoft.com/en-us/azure/azure-vmware/maintenance-orchestration)
- Customers can choose a maintenance window in the Azure portal. — [Microsoft Learn: Maintenance orchestration](https://learn.microsoft.com/en-us/azure/azure-vmware/maintenance-orchestration)
- The transcript describes scheduling or deferring the operation up to 24 hours in advance. — **Documentation note:** Current guidance says maintenance can be rescheduled until 24 hours before its start, subject to deadlines and restrictions. [Microsoft Learn: Maintenance orchestration](https://learn.microsoft.com/en-us/azure/azure-vmware/maintenance-orchestration)

### 31.2 Business value
- Maintenance can avoid: — [Microsoft Learn: Maintenance orchestration](https://learn.microsoft.com/en-us/azure/azure-vmware/maintenance-orchestration)
  - Financial close. — [Microsoft Learn: Maintenance orchestration](https://learn.microsoft.com/en-us/azure/azure-vmware/maintenance-orchestration)
  - Critical batch jobs. — [Microsoft Learn: Maintenance orchestration](https://learn.microsoft.com/en-us/azure/azure-vmware/maintenance-orchestration)
  - High-traffic business hours. — [Microsoft Learn: Maintenance orchestration](https://learn.microsoft.com/en-us/azure/azure-vmware/maintenance-orchestration)
  - Planned migrations or releases. — [Microsoft Learn: Maintenance orchestration](https://learn.microsoft.com/en-us/azure/azure-vmware/maintenance-orchestration)

### 31.3 Security override
- Microsoft may override the selected window for a critical, actively exploited vulnerability. — [Microsoft Learn: Maintenance orchestration](https://learn.microsoft.com/en-us/azure/azure-vmware/maintenance-orchestration)
- Immediate patching may take precedence over customer scheduling. — [Microsoft Learn: Maintenance orchestration](https://learn.microsoft.com/en-us/azure/azure-vmware/maintenance-orchestration)
- The transcript presents this as a reasonable tradeoff for preserving platform security. — [Microsoft Learn: Maintenance orchestration](https://learn.microsoft.com/en-us/azure/azure-vmware/maintenance-orchestration)

---

## 32. Consolidated Architectural Lessons

### 32.1 Capacity must include failure and maintenance space
- Do not size: — [Microsoft Learn: AVS documentation hub](https://learn.microsoft.com/en-us/azure/azure-vmware/)
  - IP pools. — [Microsoft Learn: AVS documentation hub](https://learn.microsoft.com/en-us/azure/azure-vmware/)
  - Host counts. — [Microsoft Learn: AVS documentation hub](https://learn.microsoft.com/en-us/azure/azure-vmware/)
  - Storage. — [Microsoft Learn: AVS documentation hub](https://learn.microsoft.com/en-us/azure/azure-vmware/)
  - VPN gateways. — [Microsoft Learn: AVS documentation hub](https://learn.microsoft.com/en-us/azure/azure-vmware/)
  - Routing tables. — [Microsoft Learn: AVS documentation hub](https://learn.microsoft.com/en-us/azure/azure-vmware/)
  at their theoretical maximum.

### 32.2 Summarization is essential
- Persistent `/32` migration routes and automatically expanded `/28` routes can exhaust finite route tables. — [Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture) · [Microsoft Learn: HCX MON guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)
- Route cleanup must be part of the migration plan. — [Microsoft Learn: AVS documentation hub](https://learn.microsoft.com/en-us/azure/azure-vmware/)

### 32.3 Physical and logical scale are interconnected
- Adding a physical host can increase software-defined routing capacity. — [Microsoft Learn: AVS documentation hub](https://learn.microsoft.com/en-us/azure/azure-vmware/)
- Storage, routing, compute, and Edge capacity cannot be designed in isolation. — [Microsoft Learn: AVS documentation hub](https://learn.microsoft.com/en-us/azure/azure-vmware/)

### 32.4 Stateful and stateless traffic require different architectures
- Tier-0 can operate active-active for stateless routing. — [Microsoft Learn: NSX segment and default gateway modes](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Create a Tier-1 gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)
- Tier-1 uses active-standby to preserve NAT and firewall session state. — [Microsoft Learn: NSX segment and default gateway modes](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment) · [Microsoft Learn: Create a Tier-1 gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-tier-1-gateway)

### 32.5 Local infrastructure dependencies matter
- DHCP broadcasts should be served or relayed locally. — [Microsoft Learn: Configure DHCP server or relay](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution)
- DNS and exact firewall ports must follow the intended traffic path. — [Microsoft Learn: Configure an AVS DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution) · [Microsoft Learn: Network port requirements](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist)
- Partial connectivity often creates misleading symptoms. — [Microsoft Learn: AVS documentation hub](https://learn.microsoft.com/en-us/azure/azure-vmware/)

### 32.6 Resilience is layered
- vSphere HA restarts VMs after host failure. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Private clouds and clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
- vSAN preserves data. — [Microsoft Learn: AVS documentation hub](https://learn.microsoft.com/en-us/azure/azure-vmware/)
- Stretched clusters protect against zone failures. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) · [Microsoft Learn: Deploy a vSAN stretched cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-vsan-stretched-clusters) · [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)
- Witness quorum prevents split brain. — [Microsoft Learn: Stretched-cluster architecture](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters) · [Microsoft Learn: Deploy a vSAN stretched cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-vsan-stretched-clusters) · [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution)
- Applications still need retry and recovery logic. — [Microsoft Learn: AVS reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-vmware-solution) · [Microsoft Learn: Transient-fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults)

### 32.7 VM hygiene enables cloud automation
- Mounted media, unsupported virtual devices, insufficient redundancy, and excessive storage utilization can block platform maintenance. — [Microsoft Learn: Private-cloud maintenance and blockers](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-vmware-solution-private-cloud-maintenance)
- Operational readiness requires continuous configuration hygiene rather than one-time deployment validation. — [Microsoft Learn: AVS documentation hub](https://learn.microsoft.com/en-us/azure/azure-vmware/)

---

## 33. Final Perspective: Complexity Has Shifted, Not Disappeared

### 33.1 Cloud does not eliminate infrastructure
- Traditional tasks such as racking servers and tracing physical cables are abstracted away. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
- New responsibilities include: — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - CIDR planning. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - BGP prefix management. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - API and platform limits. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - SDN troubleshooting. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Virtual-device portability. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Automated-remediation readiness. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)

### 33.2 Abstraction paradox
- Greater automation makes systems easier to operate during normal conditions. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
- It can also hide the underlying mechanics from future engineers. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
- The transcript asks whether engineers will retain enough fundamental knowledge to troubleshoot when automation fails. *(Transcript speculation; no direct Microsoft Learn reference identified.)*

### 33.3 AI and future cloud operations
- AI may eventually manage: *(Transcript speculation; no direct Microsoft Learn reference identified.)*
  - Route capacity. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - BGP optimization. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Hardware balancing. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
  - Remediation blockers. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
- The closing question is whether perfect automation will cause the industry to lose the knowledge needed to understand the underlying “plumbing.” — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)

### 33.4 Closing takeaway
- AVS is not magic and does not remove infrastructure complexity. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
- It replaces physical-data-center rules with a highly structured set of software-defined rules. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
- Successful architecture depends on understanding the limits and mechanisms beneath the abstraction. — [Microsoft Learn: What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
