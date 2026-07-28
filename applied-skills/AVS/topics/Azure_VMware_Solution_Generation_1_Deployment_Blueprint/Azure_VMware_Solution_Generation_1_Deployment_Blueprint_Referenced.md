# Azure VMware Solution Generation 1 Deployment Blueprint

## Purpose and Scope

Azure VMware Solution Generation 1 is presented as an enterprise infrastructure platform rather than an instantly provisioned, abstract cloud service. Microsoft describes the service as a private cloud built from dedicated bare-metal VMware hosts, with Azure-managed infrastructure and VMware management components. [Introduction to Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction) Although the environment exposes familiar cloud controls, its successful deployment depends on physical hardware allocation, precise capacity calculations, nonoverlapping network ranges, routing compatibility, firewall approvals, and carefully staged migration services. [Plan the Azure VMware Solution deployment](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment)

This guide follows the transcript’s progression from subscription prerequisites and bare-metal hosts through clustering, networking, ExpressRoute connectivity, VMware HCX migration, foundational services, and end-to-end operational dependencies.

> **Architectural interpretation:** The blueprint repeatedly challenges the idea of a “weightless” cloud. Azure VMware Solution hides much of the physical infrastructure from application owners, but architects must still plan around physical servers, storage paths, network protocols, hardware replacement, geographic distance, and reserved capacity.

### Why the Planning Requirements Are High-Stakes

* A single overlapping Internet Protocol address range can prevent deployment or produce ambiguous routing behavior. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)
* A single blocked firewall port can prevent management, migration, network extension, authentication, or name resolution. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports)
* A naming error can prevent supported public-IP configuration when the private-cloud resource name exceeds the documented limit. [Define the resource name](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#define-the-resource-name)
* A hardware or storage placement decision can introduce latency that application-level abstractions cannot remove; Microsoft recommends same-zone placement and optimized ExpressRoute gateway settings for Azure NetApp Files datastores. [Performance best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts#performance-best-practices)
* A small configuration omission can affect critical workloads such as hospital records, banking ledgers, or global enterprise applications.
* The architecture therefore requires coordinated planning across cloud, VMware, networking, security, identity, storage, and operations teams.

---

## 1. Subscription, Resource, and Naming Prerequisites

Azure VMware Solution Generation 1 deployment planning requires an eligible Azure subscription associated with an Enterprise Agreement, a Cloud Solution Provider Azure plan, or a Microsoft Customer Agreement. [Identify the subscription](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-subscription) The subscription, billing, support, and resource-governance model must reflect the cost and operational complexity of dedicated enterprise infrastructure.

### 1.1 Supported Commercial Context

Microsoft documents the following eligible subscription associations for this deployment path:

* An Enterprise Agreement, or EA.
* A Cloud Solution Provider Azure plan, or CSP Azure plan.
* A Microsoft Customer Agreement, or MCA. [Identify the subscription](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-subscription)

> **Documentation correction:** The reviewed deployment-planning article lists the eligible EA, CSP Azure plan, and MCA associations. It does not document the broader claim that every personal-credit-card subscription or free trial is categorically unusable in all circumstances; eligibility should be verified against the current service and quota requirements.

**Operational implication:** Subscription eligibility should be verified before network design and migration planning progress too far. A complete technical design is not deployable until the organization has the correct commercial relationship and quota path.

### 1.2 Initial Resource Definitions

The deployment begins by defining several foundational Azure objects and parameters:

* **Resource group:** The resource group acts as the logical container for the private cloud and related Azure resources. [Identify the resource group](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-resource-group)
* **Geographic region:** The selected Azure region determines where the private cloud is deployed; host SKU and stretched-cluster availability vary by region. [Identify the region or location](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-region-or-location) [Hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#hosts)
* **Private-cloud resource name:** Microsoft documents the value as a friendly, descriptive private-cloud resource name and limits it to 40 characters. [Define the resource name](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#define-the-resource-name)

### 1.3 The 40-Character Private-Cloud Name Limit

Microsoft documents a hard maximum of 40 characters for the private-cloud resource name. [Define the resource name](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#define-the-resource-name)

* Exceeding the 40-character limit prevents creation of public IP addresses for use with the private cloud. [Define the resource name](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#define-the-resource-name)
* Microsoft describes the value as a friendly and descriptive resource name; the reviewed Azure VMware Solution documentation does not publish the transcript’s detailed suffix-generation sequence.
* The transcript cites general Domain Name System constraints and proposes that Azure-generated hostnames, FQDNs, hashes, and certificates explain the service limit.
* A descriptive name such as `Global Financial Production Cluster East Coast Primary` is approximately 58 characters before any service-generated content is considered.
* The transcript gives `.privatelink.azurevmwaresolution.com` as an example suffix and describes a failure sequence in which generated names exceed DNS limits.

> **Not directly supported by the reviewed documentation:** The causal explanation involving `.privatelink.azurevmwaresolution.com`, appended hashes, 63-character DNS labels, certificate generation, and broader deployment failure could not be confirmed in the reviewed Azure VMware Solution Generation 1 documentation. The directly documented behavior is narrower: a private-cloud resource name longer than 40 characters prevents creation of public IP addresses for use with that private cloud. [Define the resource name](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#define-the-resource-name)

**Operational recommendation:** Establish a short enterprise naming convention before deployment. The convention should stay comfortably below the documented 40-character limit and should not depend on long natural-language descriptions.

---

## 2. Dedicated Bare-Metal Host Architecture

Azure VMware Solution uses dedicated single-tenant physical hosts. Each host runs VMware ESXi and contributes compute, memory, local storage, and network capacity to the private cloud. [Hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#hosts)

### 2.1 VMware ESXi as the Hypervisor Layer

VMware ESXi is the bare-metal host hypervisor used by Azure VMware Solution. [Azure VMware Solution private cloud and cluster concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)

* It is installed directly on server hardware as the host hypervisor rather than as an application on a general-purpose operating system. [ESXi Installation and Setup](https://techdocs.broadcom.com/us/en/vmware-cis/vsphere/vsphere/7-0/esx-installation-and-setup.html)
* It virtualizes the host’s physical CPU, memory, storage, and networking for virtual machines. [Azure VMware Solution private cloud and cluster concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)
* In Azure VMware Solution, the hosts are dedicated to one customer rather than shared with unrelated tenants. [Identify the size hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-size-hosts)

### 2.2 Host Examples from the Transcript

The following table replaces transcript-only or missing values with the current documented Generation 1 host specifications. Availability remains region-dependent. [Identify the size hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-size-hosts)

| Host reference in transcript | Processor description | Physical cores | Logical cores | Memory | Local storage description | Network |
| --- | ---: | ---: | ---: | ---: | --- | ---: |
| “8036,” later referred to as AV36 | 2 × Intel Xeon Gold 6140 | 36 | 72 | 576 GB | vSAN OSA; 3.2 TB NVMe cache and 15.20 TB SSD capacity per host | 100 Gbps |
| AV48 | 2 × Intel Xeon Gold 6442Y | 48 | 96 | 1,024 GB | vSAN ESA; 25.6 TB NVMe capacity per host; no separate cache tier | 100 Gbps |
| AV64 | 2 × Intel Xeon Platinum 8370C | 64 | 128 | 1,024 GB | Generation 1 vSAN OSA; 3.84 TB NVMe cache and 15.36 TB NVMe capacity per host | 100 Gbps |

> **Documentation correction:** The official SKU is **AV36**, not “8036.” AV48 is a documented host option rather than merely an unspecified intermediate profile, and every listed Generation 1 SKU has 100-Gbps networking. [Identify the size hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-size-hosts)

### 2.3 Hyper-Converged Infrastructure

The architecture is hyper-converged because compute and storage are integrated into the same physical nodes.

* Traditional data centers often separate compute servers from a centralized storage area network, or SAN.
* In the Azure VMware Solution design:

  * NVMe and solid-state storage devices are installed in the compute hosts. [Identify the size hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-size-hosts)
  * VMware vSAN claims the local devices and presents a shared datastore to the cluster. [vSAN clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage#vsan-clusters)
* VMware vSAN aggregates the local drives from multiple hosts.

  * Each host contributes local capacity.
  * vSAN pools those devices across the cluster.
  * The resulting datastore provides distributed shared storage to the ESXi hosts. [vSAN concepts](https://techdocs.broadcom.com/us/en/vmware-cis/vsan/vsan/7-0/vsan-planning-and-deployment/what-is-vsan/vsan-concepts.html)
* High-capacity network interfaces are important because vSAN, management, vMotion, replication, and workload traffic all depend on the cluster network fabric. [Identify the size hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-size-hosts)

**Why it matters:** Hyper-convergence removes the dependency on an external SAN for the primary vSAN datastore, but it makes cluster networking, storage policy, and host symmetry central to performance and availability.

---

## 3. Host Quota, Allocation Lead Time, and Hardware Sanitization

Dedicated hosts are not treated as instantly available virtual machines. Microsoft states that a quota request can take up to five business days to confirm host allocation. [Request a host quota](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#request-a-host-quota)

### 3.1 Quota Request Behavior

* Administrators must submit a host quota request before deploying the required capacity. [Request a host quota](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#request-a-host-quota)
* The support team can take up to five business days to confirm allocation.
* The request is tied to physical hosts in the selected region and SKU.
* Deployment schedules should therefore include quota approval and allocation lead time.

### 3.2 Why Physical Allocation Takes Time

Microsoft documents the following allocation controls:

* Hosts are selected from an isolated hardware pool dedicated to one customer.
* Hardware tests are performed before allocation.
* Data on hosts is securely deleted before reassignment. [Request a host quota](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#request-a-host-quota)
* vSAN data-at-rest encryption is enabled by default; when a host is removed, its disk data is immediately invalidated. [Data-at-rest encryption](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage#data-at-rest-encryption)

> **Architectural interpretation:** These controls explain why host allocation is materially different from provisioning a shared virtual-machine instance. They do not establish the transcript’s stronger claim that every component is returned to a “factory-fresh, provably secure” state.

### 3.3 Media Sanitization Claims

The transcript describes a process that includes:

* Overwriting every sector of NVMe storage with randomized data.
* Performing multiple overwrite passes.
* Cryptographically verifying that no prior data remains.
* Following a standard referred to in the transcript as “NIST-888.”

> **Not directly supported by the reviewed documentation:** Microsoft documents secure deletion, hardware testing, default vSAN data-at-rest encryption, and disk-data invalidation when a host is removed. The reviewed official sources do not document a standard called “NIST-888,” a fixed number of randomized overwrite passes, or the stated sector-by-sector cryptographic verification procedure. [Request a host quota](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#request-a-host-quota) [Data-at-rest encryption](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-storage#data-at-rest-encryption)

### 3.4 Deployment Scheduling Implication

1. Estimate the required host type and count. [Identify the size hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-size-hosts)
2. Submit the quota request before the planned deployment date. [Request a host quota](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#request-a-host-quota)
3. Include the documented five-business-day allocation window in the project schedule.
4. Avoid fixing migration cutovers or application freezes until capacity availability is confirmed.
5. Confirm that the selected region supports the chosen host SKU. [Identify the region or location](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-region-or-location)

---

## 4. Initial Cluster Establishment and AV64 Dependency

For **Generation 1**, an AV64 cluster cannot be the first cluster in a new private cloud. The private cloud must first be created with an eligible AV36, AV36P, AV48, or AV52 cluster, after which AV64 capacity can be added as a separate cluster. [Add a new cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud#add-a-new-cluster)

### 4.1 Management-Layer Dependency

The initial cluster establishes the private cloud’s management and control plane.

* VMware vCenter Server provides centralized VMware management.
* VMware NSX appliances provide software-defined networking management and edge services.
* vSAN and vSphere Cluster Services are initialized with the first cluster.
* The first cluster contains the service-managed `MGMT-ResourcePool`, which reserves resources for these components. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)

### 4.2 Staged Host Introduction

The documented Generation 1 sequence is:

1. Deploy the initial private cloud with an eligible non-AV64 host SKU.
2. Allow vCenter, NSX, vSAN, and service-management components to initialize.
3. Validate the private cloud and its first cluster.
4. Add an AV64 cluster after the private cloud is operational. [Add a new cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud#add-a-new-cluster)
5. Place workloads according to validated capacity, compatibility, and performance requirements.

> **Architectural interpretation:** This staged sequence separates initial control-plane establishment from later AV64 scale-out.

> **Documentation correction:** The restriction applies to Generation 1. Generation 2 supports direct deployment of a minimum three-host AV64 cluster through its native virtual-network architecture, so the Generation 1 seed-cluster prerequisite must not be generalized to Generation 2. [Differences](https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction#differences)

---

## 5. Cluster Formation, High Availability, and the Management Capacity Tax

Azure VMware Solution groups dedicated hosts into clusters and reserves capacity for host failure and service-managed management components. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)

### 5.1 Minimum Cluster Requirements

* A standard cluster requires at least three physical hosts.
* All hosts in a cluster must use the same host SKU.
* VMware vCenter manages the hosts as one logical environment.
* VMware vSAN pools their local storage.
* A private cloud can contain multiple clusters, subject to service limits. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters) [Azure VMware Solution limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)

### 5.2 N+1 Availability

Standard clusters use an N+1 availability model implemented through percentage-based vSphere HA admission control. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)

* `N` represents the host capacity required to run the intended workloads.
* `+1` represents reserved failover capacity for one host.
* The additional capacity is not a powered-off spare host.
* Hosts participate in the cluster while admission control preserves enough capacity for restart after a host failure. [vSphere HA admission control](https://techdocs.broadcom.com/us/en/vmware-cis/vsphere/vsphere/8-0/vsphere-availability/creating-and-using-vsphere-ha-clusters/vsphere-ha-admission-control.html)
* Workload sizing must therefore use failure-tolerant capacity rather than the sum of raw host specifications.

> **Transcript-derived analogy:** A three-host cluster is compared to buying a three-bedroom house while being required to leave one bedroom available in case another becomes unusable. The analogy emphasizes that paid-for capacity is not the same as safely consumable application capacity.

### 5.3 vSphere High Availability Admission Control

The first cluster contains a service-managed management resource pool named `MGMT-ResourcePool`. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)

* Microsoft documents a fixed reservation of:

  * 46 GHz of CPU capacity.
  * 171.88 GB of memory.
* Customers cannot edit or delete this resource pool.
* The reservation protects the service-managed management and network-control appliances from workload contention.

### 5.4 Management Appliance Breakdown

The following values are the documented standard-cluster core-appliance allocations and typical raw storage footprints. The official table also includes ESXi/vSAN system usage and optional HCX, Site Recovery Manager, and vSphere Replication components. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)

| Management component | Quantity | Per-appliance allocation | Documented configured total | Primary role |
| --- | ---: | ---: | ---: | --- |
| vCenter Server | 1 | 8 vCPUs, 30 GB RAM, 915 GB configured disk | 8 vCPUs, 30 GB RAM, 915 GB configured disk; 1,830 GB typical raw vSAN | Centralized inventory, provisioning, monitoring, and lifecycle management |
| NSX Unified Appliance | 3 | 6 vCPUs, 24 GB RAM, 300 GB configured disk | 18 vCPUs, 72 GB RAM, 900 GB configured disk; 1,839 GB typical raw vSAN | Redundant software-defined networking management and policy processing |
| NSX Edge VM | 2 | 8 vCPUs, 32 GB RAM, 196 GB configured disk | 16 vCPUs, 64 GB RAM, 392 GB configured disk; 802 GB typical raw vSAN | North-south routing and network services |
| vSphere Cluster Service VMs | 3 | 1 vCPU, 0.1 GB RAM, 2 GB configured disk | 3 vCPUs, 0.3 GB RAM, 6 GB configured disk; 3 GB typical raw vSAN | Cluster-service continuity |

### 5.5 Management Memory Calculation

> **Transcript-derived calculation:**

**Inputs**

* vCenter memory: 30 GB.
* Three NSX Unified Appliances: `3 × 24 GB`.
* Two NSX Edge VMs: `2 × 32 GB`.
* Fixed management resource-pool reservation: 171.88 GB. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)

**Formula**

`30 GB + (3 × 24 GB) + (2 × 32 GB)`

**Result**

`30 GB + 72 GB + 64 GB = 166 GB`

The explicitly listed vCenter, NSX Unified, and NSX Edge appliances account for 166 GB of configured virtual memory. Adding the three documented 0.1-GB vSphere Cluster Service VMs yields 166.3 GB.

**Practical interpretation**

* The fixed 171.88-GB resource-pool reservation is a separately documented service reservation; it is not published as the arithmetic sum of appliance memory.
* The remaining difference must not be assigned to a specific component without service documentation.

**Factors that can make the real result different**

* Appliance sizing and platform components can change with the service release.
* Resource-pool reservations and configured VM memory are different controls.
* Optional services such as HCX add their own configured resources and storage. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)

> **Documentation correction:** The transcript’s 5.88-GB remainder should not be described as vSphere Cluster Service or ESXi overhead. The official table separately lists vSphere Cluster Service sizing, while the 171.88-GB management reservation is documented independently. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)

### 5.6 CPU Allocation Observation

The explicitly listed configured virtual CPU allocations total:

`8 vCPUs + 18 vCPUs + 16 vCPUs = 42 vCPUs`

Including the three vSphere Cluster Service VMs gives 45 configured vCPUs. Microsoft separately documents a 46-GHz CPU reservation. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)

> **Documentation correction:** vCPU count and reserved physical gigahertz are different units and cannot be converted or compared directly without processor frequency, scheduling, and reservation details.

### 5.7 Why the Management Pool Is Protected

* vCenter must continue monitoring hosts and virtual machines during workload pressure or hardware failure.
* NSX must continue applying routing, firewall, and network-virtualization logic.
* NSX Edge appliances must remain available for north-south forwarding.
* Workload demand must not consume the capacity reserved for the service-managed control plane. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)

> **Transcript-derived analogy:** The management resource pool is compared to a property manager occupying part of the house. The reserved space is expensive, but the property manager is performing the work of an always-on IT operations team.

**Takeaway:** Calculate application capacity after subtracting host-failure headroom, the fixed management reservation, and vSAN policy and system overhead.

---

## 6. Standard and Stretched Cluster Comparison

A stretched cluster distributes a single vSAN cluster across two Azure availability zones, with a witness in a third zone. It increases fault-domain resilience but requires additional hosts, synchronous storage mirroring, and higher management-plane storage consumption. [Background](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters#background)

| Characteristic | Standard cluster | Stretched cluster |
| --- | --- | --- |
| Minimum host count | 3 hosts [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters) | 6 hosts, split 3+3 across two availability zones [Background](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters#background) |
| Availability policy | N+1 through percentage-based HA admission control [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters) | Dual-site topology designed for one-zone failure; capacity is added in symmetric host pairs [Background](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters#background) |
| Physical distribution | One Azure availability-zone placement for the cluster | Two availability zones, with a witness in a third zone |
| Symmetry requirement | Homogeneous host SKU within the cluster | Equal host count in both data sites; minimum three hosts per site |
| Failure objective | Tolerate a host failure within the standard cluster | Continue service through a supported availability-zone failure scenario |
| Documented first-cluster total in the official sizing table | 17,287 GB before data-reduction assumptions, including optional add-ons shown in that table [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters) | 20,430 GB before data-reduction assumptions, including the optional HCX Manager shown in that table [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters) |
| Replication behavior | vSAN policy-based protection within one cluster location | Synchronous vSAN dual-site mirroring across the two data sites [Storage policies supported](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters#storage-policies-supported) |
| Cost and capacity impact | High | Higher because of six-host minimum, symmetric scale, and dual-site protection |

### 6.1 Stretched-Cluster Availability

* The cluster spans two Azure availability zones with equal numbers of hosts in each data site.
* The minimum is six hosts, three per site; the documented maximum is 16 hosts, and scale-out occurs in pairs.
* A witness component resides in a third availability zone.
* Microsoft documents a 99.99% availability commitment when the applicable service conditions are met. [Background](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters#background) [FAQ](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters#faq)
* Stretched clusters are a single-region availability design, not a substitute for multi-region disaster recovery.

### 6.2 Storage Overhead

* For the first standard cluster, Microsoft’s full sizing table totals 17,287 GB of typical raw vSAN storage before data-reduction assumptions; that total includes the optional HCX, Site Recovery Manager, and vSphere Replication entries shown in the table. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)
* For the first stretched cluster, the corresponding documented total is 20,430 GB and includes the optional HCX Manager entry shown in the table.
* The higher amount reflects the stretched topology and storage policy assumptions documented in the management/control-plane table.
* Workload storage consumption remains dependent on the chosen vSAN storage policies, failures-to-tolerate settings, data reduction, and workload data. [Storage policies supported](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters#storage-policies-supported)

> **Documentation correction:** The original 17.2-TB and 20.4-TB figures are rounded totals from the official **first-cluster sizing tables**, not universal vSAN-overhead constants. Optional add-ons must be discounted when they are not deployed, and subsequent clusters have a different sizing scope. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)

**Operational implication:** Justify a stretched cluster by the required failure domain and size it from documented host, latency, bandwidth, and storage-policy constraints rather than by simply doubling a standard-cluster workload estimate.

---

## 7. Private-Cloud Address Space and CIDR Planning

For Azure VMware Solution Generation 1, IP planning is a deployment prerequisite. The service requires a contiguous, nonoverlapping `/22` management address block and subdivides it for service-managed management, host, vMotion, vSAN, replication, ExpressRoute, and HCX functions. [Define the IP address segment for private cloud management](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#define-the-ip-address-segment-for-private-cloud-management) [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)

### 7.1 Required `/22` Address Block

* A `/22` contains 1,024 total IPv4 addresses.
* The range must be contiguous and must not overlap any connected on-premises network, Azure virtual network, or other routed environment.
* The block must be reserved before private-cloud deployment.
* Microsoft subdivides the block into service-specific networks; customers do not assign these internal subnets manually. [Define the IP address segment for private cloud management](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#define-the-ip-address-segment-for-private-cloud-management)

> **Transcript notation note:** Spoken examples such as `10.0.0.022` are interpreted in this guide as CIDR notation such as `10.0.0.0/22`.

### 7.2 `/22` Capacity Calculation

> **Transcript-derived calculation:**

**Inputs**

* IPv4 address length: 32 bits.
* Prefix length: 22 bits.

**Formula**

`2^(32 − 22)`

**Result**

`2^10 = 1,024 total addresses`

**Practical interpretation**

Azure receives one contiguous pool of 1,024 addresses and partitions it for private-cloud platform functions.

**Factors that make usable capacity different**

* Each internal subnet has its own service-reserved addresses.
* The platform reserves space for lifecycle operations, replacement hosts, ExpressRoute, and VMware HCX.
* Supported service limits can be lower than mathematical subnet capacity. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)

### 7.3 Documented Generation 1 Subnet Allocation

The documented Generation 1 allocation is more detailed than the transcript’s three-row summary. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)

| Prefix | Total addresses | Documented purpose |
| --- | ---: | --- |
| `/26` | 64 | Private-cloud management, including vCenter and NSX management |
| `/26` | 64 | HCX management migrations |
| `/26` | 64 | Reserved for ExpressRoute Global Reach |
| `/32` | 1 | NSX DNS service |
| Three `/32` ranges | 3 | Reserved |
| `/30` | 4 | Reserved |
| `/29` | 8 | Reserved |
| `/28` | 16 | Reserved |
| `/27` | 32 | ExpressRoute peering |
| `/25` | 128 | ESXi management |
| `/25` | 128 | vMotion |
| `/25` | 128 | Replication; not applicable to AV64 nodes and documented as planned for future deprecation |
| `/25` | 128 | vSAN |
| `/26` | 64 | HCX uplink |
| Three `/26` ranges | 192 | Reserved |

> **Documentation correction:** The transcript correctly identifies the management `/26`, ExpressRoute `/27`, and several `/25` networks, but the official allocation also includes dedicated HCX, vSAN, Global Reach, DNS, and reserved ranges. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)

> **Transcript-derived analogy:** The `/22` is compared to a parcel of land. Azure automation acts as the city planner, zoning separate streets for management, migration, replication, storage, and the connection back to the enterprise network.

---

## 8. Supported Host Count and Reserved Address Capacity

Microsoft explicitly distinguishes technical address capacity from the supported host maximum. The ESXi management, vMotion, and replication `/25` networks technically support 125 hosts, while the Azure VMware Solution private-cloud limit is 96 hosts. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations) [Azure VMware Solution limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)

### 8.1 Mathematical and Supported Values

* Each `/25` contains 128 total addresses.
* Microsoft documents technical support for 125 hosts on the relevant `/25` networks.
* The supported private-cloud maximum is 96 hosts.
* The remaining 29 host addresses are reserved:

  * 19 for host replacement and maintenance.
  * 10 for VMware HCX. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)

### 8.2 Transcript-Derived Capacity Calculation

> **Transcript-derived calculation:**

**Inputs**

* Documented technical host capacity: 125.
* Supported private-cloud maximum: 96.
* Replacement and maintenance reservation: 19.
* HCX reservation: 10.

**Formula**

`125 − 96 = 29 reserved addresses`

Reservation breakdown:

`19 + 10 = 29 addresses`

**Result**

The documented 29-address difference is fully allocated between lifecycle capacity and HCX.

**Practical interpretation**

* A replacement host can receive an address, join the cluster, synchronize, and be validated before the old host is removed.
* HCX appliances can be deployed without consuming steady-state supported host capacity.
* The 96-host limit is a service limit, not a result obtained only from ordinary IPv4 network-and-broadcast subtraction. [Azure VMware Solution limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)

> **Documentation correction:** The “125 hosts” value is not a conventional generic `/25` usable-address calculation. It is the Azure VMware Solution technical host capacity stated for these service-managed `/25` networks. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)

### 8.3 Why Replacement Addresses Are Necessary

* Host lifecycle operations can require the old and replacement host to coexist.
* The replacement host needs management, vMotion, and replication addressing while it joins and synchronizes.
* Reserved addresses prevent lifecycle work from being blocked at the supported 96-host scale. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)

> **Transcript-derived analogy:** Reserving replacement addresses is like leaving an empty building lot so a replacement house can be constructed before the damaged house is demolished.

---

## 9. Forbidden and High-Risk Address Ranges

Generation 1 reserves several ranges for internal platform use, and the management `/22` must come from an allowed private range without overlap. [Prerequisites](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#prerequisites) [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)

| Address range | Documented use or restriction | Risk |
| --- | --- | --- |
| `169.254.0.0/24` | Internal transit network | Customer overlap can conflict with platform transit routing |
| `169.254.2.0/23` | Inter-VRF transit network | Customer overlap can make virtual-routing paths ambiguous |
| `100.64.0.0/16` | Internal gateway connectivity | Customer routes can overlap service-managed gateway functions |
| `172.17.0.0/16` | Not allowed for the private-cloud management network | Common container networking use can create overlap |

### 9.1 Internal NSX Ranges

* Microsoft reserves `169.254.0.0/24`, `169.254.2.0/23`, and `100.64.0.0/16` for Azure VMware Solution internal connectivity. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)
* These ranges must not be reused for the management `/22` or advertised into the environment in a way that overlaps platform routing.
* Routing behavior during an overlap is implementation-dependent; the operationally relevant requirement is to prevent the conflict before deployment.

> **Documentation correction:** The transcript lists `169.254.0.0/23` for inter-VRF transit. The documented range is `169.254.2.0/23`. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)

### 9.2 Docker Bridge Conflict

* `172.17.0.0/16` is excluded from the allowed management-network ranges. [Prerequisites](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#prerequisites)
* The transcript associates the range with Docker’s common default bridge network.

> **Not directly supported by the reviewed documentation:** The Azure VMware Solution sources document that `172.17.0.0/16` is not allowed, but they do not support the stronger explanation that Azure VMware Solution’s underlying management platform rejects it specifically because Microsoft runs Docker containers there.

### 9.3 Preferred Source Ranges

Select the `/22` from the documented allowed private address spaces:

* `10.0.0.0/8`
* `172.16.0.0/12`, excluding `172.17.0.0/16`
* `192.168.0.0/16` [Prerequisites](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#prerequisites)

The selected block must still be checked for overlap with:

* On-premises data centers and branches.
* Other Azure virtual networks.
* Connected clouds and partner networks.
* Merger or acquisition address spaces.
* Existing application, container, and platform networks.

**Operational recommendation:** Validate the proposed `/22` against enterprise IP address management and all networks that can become transitively connected, not only networks connected on deployment day.

---

## 10. ExpressRoute Connectivity and BGP Routing

Generation 1 private clouds use an Azure VMware Solution-managed ExpressRoute circuit for connectivity to Azure virtual networks. On-premises connectivity is commonly established by linking that managed circuit to an organization’s on-premises ExpressRoute circuit through ExpressRoute Global Reach. [On-premises interconnectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#on-premises-interconnectivity) [Peer on-premises environments to Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)

### 10.1 ExpressRoute Characteristics

* ExpressRoute provides private connectivity to Microsoft cloud services through a connectivity provider or an ExpressRoute location, without sending the service traffic across the public internet. [What is Azure ExpressRoute?](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction)
* Azure VMware Solution Generation 1 includes a service-managed ExpressRoute circuit for the private cloud.
* The organization’s separate on-premises ExpressRoute circuit can be linked to the private-cloud circuit with Global Reach.
* ExpressRoute uses BGP to exchange routes between peered networks. [ExpressRoute circuits and peering](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-circuit-peerings)
* Bandwidth, latency, and resiliency depend on circuit design, provider, peering location, and routing; ExpressRoute should not be described as guaranteeing universally lower latency than every internet path.

> **Documentation correction:** The transcript merges the organization’s provider-provisioned on-premises circuit with the Azure VMware Solution-managed circuit. They are distinct circuits that are linked for the documented Global Reach pattern. [On-premises interconnectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#on-premises-interconnectivity)

### 10.2 Peering Establishment

For the Global Reach pattern:

1. Create or identify the on-premises ExpressRoute circuit.
2. Create an authorization key on that circuit. [Create an ExpressRoute authorization key](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud#create-an-expressroute-auth-key-in-the-on-premises-expressroute-circuit)
3. Retrieve the Azure VMware Solution private-cloud circuit resource identifier.
4. Peer the on-premises circuit with the private-cloud circuit by using the authorization and circuit details. [Peer private cloud to on-premises](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud#peer-private-cloud-to-on-premises)
5. Confirm that Global Reach is connected.
6. Validate route exchange and bidirectional reachability. [Verify on-premises network connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud#verify-on-premises-network-connectivity)

The connectivity provider configures the organization’s circuit and Microsoft peering edge relationship; Azure VMware Solution manages its own private-cloud circuit.

### 10.3 BGP Route Exchange

BGP dynamically exchanges reachable prefixes.

* The on-premises ExpressRoute private peering advertises enterprise prefixes.
* The Azure VMware Solution circuit advertises private-cloud prefixes.
* Global Reach permits those routes to propagate between the two circuits.
* Each side selects a next hop according to BGP attributes and the surrounding routing design. [ExpressRoute circuits and peering](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-circuit-peerings)

> **Transcript-derived analogy:** BGP is compared to a postal system in which each autonomous network announces the destinations it knows how to reach.

---

## 11. Four-Byte Autonomous System Number Requirement

Azure VMware Solution uses four-byte public Autonomous System Numbers for route advertisement, so connected on-premises equipment and the ExpressRoute provider must support four-byte ASNs. [Virtual network and ExpressRoute circuit considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#virtual-network-and-expressroute-circuit-considerations)

### 11.1 ASN Purpose

* An ASN identifies an autonomous network participating in BGP. [ExpressRoute circuits and peering](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-circuit-peerings)
* A two-byte field has `2^16`, or 65,536, possible numeric values before accounting for reserved ranges.
* A four-byte field has `2^32`, or 4,294,967,296, possible numeric values before accounting for reserved ranges.
* The practical Azure VMware Solution requirement is interoperability with its four-byte ASN advertisements. [Virtual network and ExpressRoute circuit considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#virtual-network-and-expressroute-circuit-considerations)

### 11.2 Legacy Router Failure Scenario

> **Transcript-derived scenario:**

An older enterprise router supports only two-byte ASNs.

1. The physical ExpressRoute circuit is connected.
2. Interface and switch indicators appear healthy.
3. The router receives a four-byte ASN advertisement.
4. It cannot process or establish the required BGP relationship correctly.
5. The BGP session fails or required routes are not learned.
6. Application connectivity fails even though the physical link is operational.

The exact failure behavior depends on the router and software release; the documented preventive control is to verify four-byte ASN support before deployment.

### 11.3 Validation Requirements

* Confirm that the on-premises router supports four-byte ASNs.
* Confirm that the installed operating-system or firmware version enables that support.
* Confirm support with the ExpressRoute provider.
* Validate BGP session state and the actual advertised and learned prefixes, not only physical-link state. [Virtual network and ExpressRoute circuit considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#virtual-network-and-expressroute-circuit-considerations)
* Verify reachability in both directions after Global Reach is connected. [Verify on-premises network connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud#verify-on-premises-network-connectivity)

> **Transcript-derived analogy:** ExpressRoute is compared to a high-speed rail line. Four-byte ASN support is the track gauge; if the gauges do not match, the train cannot travel even though the rails are physically connected.

---

## 12. Azure NetApp Files and Physical Proximity

Azure NetApp Files can be attached as an NFS datastore to Azure VMware Solution. For Generation 1, Microsoft recommends a supported high-performance ExpressRoute gateway configuration with FastPath and placement of the private cloud and Azure NetApp Files volumes in the same availability zone. [Performance best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts#performance-best-practices)

### 12.1 Storage Path

Azure NetApp Files is an external Azure storage service rather than local storage inside the ESXi hosts.

* The datastore is mounted over NFS from a delegated subnet in an Azure virtual network.
* Generation 1 traffic traverses the Azure VMware Solution ExpressRoute connection to the virtual network.
* Microsoft recommends an UltraPerformance or ErGw3Az gateway with FastPath for the documented Generation 1 pattern. [Performance best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts#performance-best-practices)
* A virtual-machine storage operation therefore depends on the end-to-end host, ExpressRoute, gateway/FastPath, virtual-network, and Azure NetApp Files path.

### 12.2 Geographic Placement Requirement

* Place the Azure VMware Solution private cloud and Azure NetApp Files volumes in the same availability zone when using zonal placement. [Performance best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts#performance-best-practices)
* Select a supported gateway and enable FastPath where the documented architecture requires it.
* Measure effective datastore latency and throughput before production use.
* Compute and storage placement should be planned together.

> **Documentation correction:** “Close to the hosts” is too imprecise. The current performance guidance specifically recommends same-availability-zone placement and identifies supported Generation 1 gateway/FastPath configurations. [Performance best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts#performance-best-practices)

### 12.3 Cross-Region Failure Scenario

> **Transcript-derived scenario:**

* The VMware cluster is deployed in Virginia.
* The virtual-network gateway and Azure NetApp Files storage are accidentally deployed in Texas.
* Each storage read and write travels a long geographic path.
* The added distance introduces propagation and network-processing latency.
* A database issuing many synchronous I/O operations repeatedly pays that latency cost.
* I/O wait time can dominate application response time.
* Severe latency can contribute to timeouts or application failure.

The scenario illustrates a valid physics constraint, but it is not a Microsoft-published benchmark and does not establish a specific latency value for those locations.

### 12.4 Latency Calculation Framework

> **Transcript-derived calculation:**

**Inputs**

* Approximate propagation speed in fiber used by the transcript: 200,000 kilometers per second.
* One-way routed fiber distance: `D` kilometers.

**Formula**

Approximate propagation-only round-trip time:

`RTT = (2 × D) ÷ 200,000 seconds`

Converted to milliseconds:

`RTT(ms) = [(2 × D) ÷ 200,000] × 1,000`

**Result**

The transcript does not provide an actual routed fiber distance, so the calculation yields a formula rather than a measured result.

**Practical interpretation**

A few milliseconds multiplied across many synchronous storage operations can become an application bottleneck.

**Factors that make the real result different**

* Fiber routes are longer than straight-line geographic distance.
* Routers, gateways, firewalls, switches, and queues add delay.
* Storage controllers and the application I/O pattern add latency.
* Caching and asynchronous I/O can reduce sensitivity.
* FastPath and zonal placement materially affect the Generation 1 path. [Performance best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts#performance-best-practices)

**Takeaway:** Cloud storage performance remains constrained by topology and propagation delay; software-defined infrastructure does not eliminate physical distance.

---

## 13. VMware HCX Migration Architecture

VMware HCX provides site pairing, service-mesh connectivity, workload mobility, replication, and network extension between a source VMware environment and Azure VMware Solution. [Configure VMware HCX](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)

### 13.1 HCX Purpose

* HCX pairs the on-premises and Azure VMware Solution HCX managers.
* A service mesh deploys the interconnect appliances used for migration and network extension.
* Migration services can move virtual machines through replication-assisted bulk migration, vMotion, cold migration, and other supported workflows. [VMware HCX migration types](https://techdocs.broadcom.com/us/en/vmware-cis/hcx/vmware-hcx/4-11/vmware-hcx-user-guide-4-11/migrating-virtual-machines-with-vmware-hcx/vmware-hcx-migration-types.html)
* Network Extension can stretch eligible Layer 2 networks so migrated virtual machines retain their IP and MAC addresses. [Configure HCX Network Extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension)

> **Documentation correction:** “Hybrid Cloud Extension” is retained as transcript terminology. Current Microsoft and Broadcom documentation generally uses the product name **VMware HCX** without relying on that expansion.

### 13.2 Required HCX Networks

Microsoft’s HCX deployment procedure defines four network-profile roles. [Create network profiles](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx#create-network-profiles)

| HCX network | Function | Operational dependency |
| --- | --- | --- |
| Management | HCX appliance communication with vCenter, NSX, DNS, NTP, and management endpoints | Routed reachability and required management ports |
| Uplink | HCX interconnect traffic toward the remote site | Sufficient routed connectivity, bandwidth, and firewall approval |
| vMotion | vMotion traffic for live migration | Supported port-group/network profile and TCP 8000 path |
| Replication | Replication traffic for migration disk data | Sustained throughput and migration-control connectivity |

### 13.3 Management Network

* The management profile provides reachability to vCenter and other required management services.
* HCX Manager and deployed interconnect appliances depend on DNS, routing, and the documented management ports.
* A management-path failure can prevent site pairing, appliance deployment, service-mesh health, or migration control. [Create network profiles](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx#create-network-profiles) [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports)

### 13.4 Uplink Network

* The uplink profile carries HCX interconnect traffic between sites.
* In a Generation 1 private-connectivity design, that path can traverse ExpressRoute and Global Reach.
* Uplink bandwidth, latency, MTU, routing, and firewall state affect migration throughput and service-mesh stability. [Create a compute profile](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx#create-a-compute-profile) [Create a service mesh](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx#create-a-service-mesh)

### 13.5 vMotion Network

VMware HCX vMotion transfers the running virtual machine by using VMware vMotion semantics.

* Memory and execution state are transferred while the source VM continues to run.
* Changed memory pages can be recopied during precopy.
* A brief switchover completes execution on the destination.
* The supported workflow is designed for minimal interruption rather than a normal guest operating-system reboot. [Understanding VMware HCX vMotion and Cold Migration](https://techdocs.broadcom.com/us/en/vmware-cis/hcx/vmware-hcx/4-11/vmware-hcx-user-guide-4-11/migrating-virtual-machines-with-vmware-hcx/understanding-vmware-hcx-vmotion-and-cold-migration.html)

### 13.6 vMotion and Source-Switch Requirements

The transcript combines two related but distinct documented requirements:

* The on-premises **vMotion network must be exposed on a vSphere Distributed Switch or `vSwitch0`** for the Azure VMware Solution HCX planning pattern. [Define VMware HCX network segments](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#define-vmware-hcx-network-segments)
* HCX **Network Extension** workload networks must connect to a vSphere Distributed Switch; networks on a vSphere Standard Switch cannot be extended. [Determine whether to extend your networks](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#determine-whether-to-extend-your-networks)
* At the underlying HCX product level, a network profile can abstract a distributed port group, standard port group, or NSX logical switch, but the Azure VMware Solution-specific vMotion and Network Extension restrictions still apply. [Create a Network Profile](https://techdocs.broadcom.com/us/en/vmware-cis/hcx/vmware-hcx/4-11/vmware-hcx-user-guide-4-11/configuring-and-managing-the-hcx-interconnect/configuring-the-hcx-service-mesh/create-a-network-profile.html)

> **Documentation correction:** Validate the vMotion profile and each workload network selected for Layer 2 extension separately. Standard-switch support for a generic HCX network profile does not make a standard-switch workload network eligible for HCX Network Extension.

### 13.7 Replication Network

* The replication profile carries virtual-disk replication traffic used by replication-assisted migration workflows.
* In bulk migration, HCX replicates VM disks while the source VM remains available, synchronizes changed data, and performs a scheduled cutover. [Understanding VMware HCX Bulk Migration](https://techdocs.broadcom.com/us/en/vmware-cis/hcx/vmware-hcx/4-11/vmware-hcx-user-guide-4-11/migrating-virtual-machines-with-vmware-hcx/understanding-vmware-hcx-bulk-migration.html)
* A dedicated replication profile helps separate this sustained data path from management and vMotion traffic.
* Replication and migration control also depend on the documented firewall paths, including TCP 8123 where applicable. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports)

---

## 14. Migration Method Comparison

HCX mobility, replication, network extension, and service-mesh functions work together; they are not interchangeable migration methods. [VMware HCX migration types](https://techdocs.broadcom.com/us/en/vmware-cis/hcx/vmware-hcx/4-11/vmware-hcx-user-guide-4-11/migrating-virtual-machines-with-vmware-hcx/vmware-hcx-migration-types.html)

| Mechanism | Primary data or function | Workload state | Downtime profile | Key dependency |
| --- | --- | --- | --- | --- |
| HCX vMotion | VM memory, execution state, and associated VM migration data | VM remains running during precopy and switches to the destination | Minimal interruption; not a normal guest reboot [Understanding VMware HCX vMotion and Cold Migration](https://techdocs.broadcom.com/us/en/vmware-cis/hcx/vmware-hcx/4-11/vmware-hcx-user-guide-4-11/migrating-virtual-machines-with-vmware-hcx/understanding-vmware-hcx-vmotion-and-cold-migration.html) | Supported vMotion network profile, compute profile, and TCP 8000 path |
| Bulk migration | Replicated virtual disks and changed data | Source VM remains running during initial replication | Scheduled final cutover after synchronization [Understanding VMware HCX Bulk Migration](https://techdocs.broadcom.com/us/en/vmware-cis/hcx/vmware-hcx/4-11/vmware-hcx-user-guide-4-11/migrating-virtual-machines-with-vmware-hcx/understanding-vmware-hcx-bulk-migration.html) | Replication network, migration control, destination capacity |
| Network Extension | Layer 2 reachability for an existing workload network | Does not move a VM | No workload cutover by itself; supports retained IP/MAC after migration [Configure HCX Network Extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension) | HCX Network Extension appliance and UDP 4500 tunnel |
| Service mesh | HCX appliance relationship and enabled interconnect services | Does not move a VM | Deployment prerequisite, not a workload migration | Site pairing, compute/network profiles, appliance deployment, and firewall approval [Create a service mesh](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx#create-a-service-mesh) |

**Operational implication:** A migration runbook should identify separately which mechanism transfers storage, which transfers execution state, which preserves network identity, and which service-mesh components make those functions available.

---

## 15. HCX Scale-Out and Port-Group Workaround

Large migrations can require more HCX management-address capacity than the default management network provides. Microsoft documents a dedicated `/26` port-group design for large HCX deployments. [Define VMware HCX network segments](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#define-vmware-hcx-network-segments)

### 15.1 Documented `/26` Port-Group Design

* Create a new `/26` network and present it as a port group to the on-premises VMware cluster.
* Use the dedicated network for HCX appliance addressing rather than exhausting the existing management network.
* Microsoft documents support for:

  * Up to 10 service meshes.
  * Up to 60 network-extender address slots, with one slot deducted for each service mesh (`-1 per service mesh`).
  * Up to 8 extended networks per network-extension appliance. [Define VMware HCX network segments](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#define-vmware-hcx-network-segments) [Azure VMware Solution limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)

> **Documentation correction:** The transcript’s “26-port group” and “20s network” wording refers to a **`/26` network**, not a `/20`.

### 15.2 Network-Extension Scale Calculation

> **Transcript-derived calculation:**

**Inputs**

* Documented maximum network extenders: 60.
* Documented maximum extended networks per appliance: 8.

**Formula**

`60 extenders × 8 networks per extender`

**Result**

`480 extended-network attachments` before applying the documented one-slot-per-service-mesh deduction.

**Practical interpretation**

The transcript’s multiplication is arithmetically correct for `60 × 8`, but the documented `/26` design states `60 network extenders (-1 per service mesh)`. With `M` service meshes, the address-based theoretical value is:

`(60 − M) × 8`

For one service mesh, that is `59 × 8 = 472`; for ten service meshes, it is `50 × 8 = 400`.

**Factors that can make the real result different**

* HCX version, licensing, destination topology, address availability, and service limits apply.
* Appliance placement and topology can further constrain the number usable by a particular mesh.
* ExpressRoute bandwidth, appliance throughput, firewall capacity, and operational manageability can establish a lower practical ceiling. [Azure VMware Solution limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)

> **Documentation correction:** Treat 480 as the transcript-derived pre-deduction multiplication, not as a supported simultaneous-network guarantee. Apply the documented `-1 per service mesh` rule before estimating usable extender capacity. [Define VMware HCX network segments](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#define-vmware-hcx-network-segments)

---

## 16. HCX Network Extension and Layer 2 Stretching

HCX Network Extension stretches an eligible Layer 2 network between sites so migrated virtual machines can retain their existing IP and MAC addresses. [Configure HCX Network Extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension) [Extend network](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-hcx-access-over-internet#extend-network)

### 16.1 Example Addressing Scenario

The transcript uses:

* Virtual-machine IP address: `192.168.1.50`.
* Default gateway: `192.168.1.1`.
* Original location: On-premises data center.
* Destination: Azure VMware Solution.

### 16.2 Network-Extension Flow

1. HCX extends the eligible `192.168.1.0/24` workload network into Azure VMware Solution.
2. A migration workflow moves the virtual machine.
3. The VM retains `192.168.1.50` and its MAC address. [Extend network](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-hcx-access-over-internet#extend-network)
4. In the default non-MON pattern, the original gateway can remain on-premises.
5. The Azure-side Network Extension appliance encapsulates frames for the stretched segment.
6. The HCX tunnel carries them to the peer appliance.
7. Traffic is decapsulated and delivered into the source-side Layer 2 domain.
8. Return traffic follows the extended path.

Mobility Optimized Networking, when supported and deliberately configured, can optimize selected traffic paths and alter gateway locality; it should not be silently assumed in the default flow. [VMware HCX Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)

> **Transcript-derived analogy:** The network extender functions as an encrypted wormhole. A virtual machine can run in another location while retaining the addressing identity associated with its source network.

### 16.3 Architectural Benefits

* Applications can retain hard-to-change addresses during migration.
* Migration can be separated from immediate network renumbering.
* Dependent systems can continue using the existing VM address.
* Migration waves can precede later network modernization. [Configure HCX Network Extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension)

### 16.4 Architectural Risks

* A Layer 2 failure domain is extended across a wide-area path.
* Without MON or another approved routing change, gateway-bound traffic can hairpin to the source site.
* Latency-sensitive east-west or north-south traffic can traverse the inter-site tunnel.
* Tunnel failure can isolate migrated VMs from source-side network services.
* DHCP behavior on an extended network requires explicit design because NSX blocks DHCP traffic across an HCX Layer 2 extension by default until the documented configuration is applied. [Configure L2-stretched VMware HCX networks](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)
* Many extenders and stretched networks increase monitoring and troubleshooting complexity.

**Operational recommendation:** Treat Layer 2 extension as a controlled migration state with ownership, monitoring, dependency mapping, and an exit plan rather than as an invisible permanent topology.

---

## 17. Firewall and Security Requirements

HCX, identity integration, DNS, and management depend on explicit routed and firewall-approved paths between the source environment and Azure VMware Solution. Microsoft publishes a Generation 1 port table with source, destination, protocol, and purpose. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports)

### 17.1 Scope Caveat

The detailed rule set applies where a firewall or other filtering control inspects traffic among:

* On-premises management networks.
* ExpressRoute-connected paths.
* HCX appliances.
* Azure VMware Solution management endpoints.
* DNS and Active Directory services.

If no firewall exists on a particular path, routing, name resolution, endpoint configuration, and host-based filtering still must permit the documented flow.

### 17.2 Security Review Questions

For each requested rule, document:

* The exact source and destination address or subnet.
* Port, protocol, and direction.
* Product function and whether traffic is encrypted.
* The operational failure when the rule is blocked.
* Whether the rule is temporary or persistent.
* How access is restricted, logged, monitored, and reviewed.

### 17.3 Documented Port Matrix

The table below consolidates the Azure VMware Solution Generation 1 network checklist. Directionality and endpoint scope must be taken from the current official table during implementation. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports)

| Port | Protocol | Purpose | Failure if blocked |
| ---: | --- | --- | --- |
| 53 | UDP | DNS queries to configured DNS servers | Name resolution required by management, HCX, identity, or applications fails |
| 80 | TCP | vCenter HTTP-to-HTTPS redirect; also included with 443/902 for specific HCX-to-ESXi management/OVF flows | Redirect or affected deployment workflow fails |
| 443 | TCP | HTTPS access to vCenter and documented HCX/ESXi management flows | Secure web, API, or appliance deployment operations fail |
| 902 | TCP | HCX-to-ESXi management and OVF deployment flow | Relevant HCX appliance deployment or host communication fails |
| 22 | TCP | SSH administration of HCX appliances | SSH administrative access fails |
| 9443 | TCP | HCX Cloud Manager interface and REST communication | HCX manager communication and service setup can fail |
| 8123 | TCP | HCX bulk-migration control | Bulk-migration orchestration and synchronization fail |
| 4500 | UDP | IPsec tunnel using IKEv2 and NAT traversal | HCX interconnect/network-extension tunnel cannot establish |
| 5201 | TCP and UDP | HCX `perftest` service-mesh bandwidth diagnostics | Diagnostic throughput testing fails |
| 8000 | TCP | vMotion traffic | Live-migration transfer fails |
| 389 | TCP | LDAP | Unencrypted LDAP identity queries fail |
| 636 | TCP | LDAP over TLS/SSL | Secure LDAP identity queries fail |
| 3268 | TCP | Active Directory Global Catalog | Global Catalog queries fail |
| 3269 | TCP | Secure Global Catalog | Encrypted Global Catalog queries fail |

> **Documentation correction:** The original matrix omitted TCP 902 from the documented HCX-to-ESXi flow and called the port-5201 utility `perfdest`; the official checklist calls it `perftest`. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports)

> **Operational recommendation:** Do not implement this summary table as an unrestricted any-to-any policy. Use the current official source/destination rows and restrict each rule to the actual appliance, service, or subnet addresses.

---

## 18. UDP 4500 and the Network-Extension Tunnel

HCX interconnect appliances use UDP 4500 for the documented IPsec tunnel, IKEv2 negotiation, and NAT traversal. That tunnel carries HCX services including Network Extension. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports) [Create a service mesh](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx#create-a-service-mesh)

### 18.1 Encapsulation Behavior

* A workload produces an Ethernet frame or IP packet on an extended network.
* The Network Extension appliance handles traffic for the stretched segment.
* HCX encapsulates and encrypts inter-site traffic through its interconnect tunnel.
* UDP 4500 carries the documented IPsec/IKEv2/NAT-T path between HCX interconnect endpoints.
* The peer appliance decapsulates the traffic and delivers it to the remote segment. [Configure HCX Network Extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension)

The exact packet encapsulation and cryptographic suite depend on the HCX release and negotiated configuration.

### 18.2 Security Mechanism

The transcript refers to “IPSC,” “Internet Key Exchange,” “ICAPE-2,” NAT-T, and “military-grade encryption.”

> **Documentation correction:** The documented terms are **IPsec**, **IKEv2**, and **NAT traversal (NAT-T)** over UDP 4500. “IPSC” and “ICAPE-2” appear to be transcription errors. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports)

> **Not directly supported by the reviewed documentation:** The phrase “military-grade encryption” is not a precise documented Azure VMware Solution or HCX security specification. Use the negotiated HCX/IPsec protocol and cipher information from the deployed product version for a security assessment.

### 18.3 Blocked-Port Failure Sequence

1. A firewall blocks UDP 4500 between the documented HCX endpoints.
2. The interconnect appliances cannot establish the required IPsec/IKEv2 path.
3. The affected service mesh reports a tunnel or appliance connectivity failure.
4. Network Extension cannot carry the stretched Layer 2 segment.
5. VMs that depend on that extension can lose source-side gateway or service reachability.
6. Migration workflows requiring the failed service must stop until connectivity is restored or the design is changed. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports)

**Operational implication:** UDP 4500 is a gating dependency for the HCX tunnel in this architecture, not merely a diagnostic port.

---

## 19. HCX Diagnostic and Migration Ports

HCX uses separate ports for manager communication, migration control, diagnostics, appliance deployment, and vMotion. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports)

### 19.1 TCP 9443

* Provides the documented HCX Cloud Manager interface and REST communication path.
* Supports HCX manager pairing and management interactions.
* Blocking the required endpoint flow can prevent service setup or manager communication.

### 19.2 TCP 8123

* Provides the documented HCX bulk-migration control channel.
* Coordinates replication-assisted migration operations.
* Blocking the port can prevent bulk migration from staging, synchronizing, or cutting over.

### 19.3 TCP and UDP 5201

* Supports the HCX service-mesh `perftest` bandwidth diagnostic.
* The test helps validate effective throughput before migration.
* Blocking it prevents this diagnostic but does not by itself prove that every production migration flow is blocked.

### 19.4 TCP 8000

* Carries the documented vMotion transfer path.
* Blocking it prevents HCX vMotion from transferring the running VM through that route.
* Replication-assisted migration uses different data and control paths and is not a substitute for vMotion when live migration is the selected method.

### 19.5 TCP 80, 443, and 902

* TCP 443 provides secure management and API access.
* TCP 80 supports the documented redirect behavior and appears with 443 and 902 in specific HCX-to-ESXi management/OVF deployment flows.
* TCP 902 is required for the documented HCX appliance deployment/ESXi communication path.
* Restrict these ports to the endpoints and directions in the official matrix.

### 19.6 TCP 22

* Supports SSH administration of HCX appliances.
* Restrict access to approved management sources.
* Blocking it removes SSH administration but does not necessarily stop every automated HCX data-plane function.

**Operational recommendation:** Validate ports from the actual HCX appliance interfaces and address pools. A successful test from an administrator workstation does not prove appliance-to-appliance reachability.

---

## 20. DHCP Placement and Broadcast-Storm Risk

Microsoft recommends using the NSX DHCP service or another DHCP server local to Azure VMware Solution instead of carrying DHCP broadcast dependency across a wide-area network. [DHCP and DNS resolution considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#dhcp-and-dns-resolution-considerations) [Configure DHCP for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution)

### 20.1 Recommended DHCP Placement

Supported design choices include:

* Hosting DHCP in NSX. [Use NSX to host your DHCP server](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution#use-nsx-to-host-your-dhcp-server)
* Using a supported third-party DHCP server reachable through an NSX DHCP relay. [Use a third-party external DHCP server](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution#use-a-third-party-external-dhcp-server)
* Configuring the service through the Azure portal where supported. [Create a DHCP server or relay](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution#use-the-azure-portal-to-create-a-dhcp-server-or-relay)

For HCX Layer 2 extended networks, DHCP behavior requires the specific documented L2-extension configuration; NSX blocks DHCP traffic across the extension by default. [Configure L2-stretched VMware HCX networks](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks)

### 20.2 Why Remote DHCP Is Risky

DHCP discovery begins before a client has a usable address.

* A client sends a DHCPDISCOVER with source address `0.0.0.0` and destination address `255.255.255.255`. [DHCP basics](https://learn.microsoft.com/en-us/windows-server/troubleshoot/dynamic-host-configuration-protocol-basics)
* A relay is required when the DHCP server is not on the local broadcast domain.
* A WAN-dependent relay design adds routing, firewall, latency, and remote-server dependencies to address acquisition.
* A burst of simultaneous restarts can create a corresponding burst of relay and DHCP-server load.

> **Documentation correction:** `255.255.255.255.255.255` is not valid IPv4 notation. The documented limited IPv4 broadcast destination for DHCPDISCOVER is `255.255.255.255`. [DHCP basics](https://learn.microsoft.com/en-us/windows-server/troubleshoot/dynamic-host-configuration-protocol-basics)

### 20.3 Simultaneous Restart Failure Scenario

> **Transcript-derived scenario:**

1. A physical host fails.
2. The cluster restarts 500 virtual machines.
3. Many VMs request or renew addresses at approximately the same time.
4. A remote-DHCP design relays those requests across the WAN.
5. The WAN path and DHCP service experience a sudden demand spike.
6. Latency, packet loss, or server saturation delays lease assignment.
7. Some VMs remain without usable network configuration.

The exact result depends on lease state, retry backoff, relay design, server capacity, and the number of VMs that actually restart simultaneously.

### 20.4 Local-Service Benefit

* Address assignment can remain within the workload’s Azure failure domain.
* Recovery is less dependent on the WAN and on-premises DHCP availability.
* Broadcast traffic is converted or contained by the supported local/relay architecture.
* Mass-restart behavior is easier to capacity-test and monitor. [DHCP and DNS resolution considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#dhcp-and-dns-resolution-considerations)

**Takeaway:** Keep DHCP local where practical, and explicitly test the relay and failure behavior when a remote DHCP service is required.

---

## 21. DNS Forwarding and Default-Route Behavior

DNS is a foundational dependency for Azure VMware Solution management, HCX, identity, and applications. NSX DNS forwarding can direct queries to designated upstream DNS servers. [Configure a DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution#configure-dns-forwarder)

### 21.1 Default Route Dependency

When a default route is advertised from on-premises to Azure VMware Solution:

* Unknown Internet-bound traffic follows that advertised path.
* The configured DNS forwarder must be able to reach its upstream DNS servers.
* Those servers must resolve the internal and public names required by the environment.
* The documented Generation 1 firewall table includes UDP 53 for DNS. [DHCP and DNS resolution considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#dhcp-and-dns-resolution-considerations) [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports)

### 21.2 Failure Scenario

* Internal IP routing can remain functional.
* A VM might reach known internal IP addresses.
* Public names fail to resolve when the forwarder cannot reach a recursive resolver or the resolver cannot answer public queries.
* Cloud APIs, certificate endpoints, package repositories, and application dependencies addressed by name appear unavailable.

### 21.3 Validation Sequence

1. Confirm whether a default route is advertised to the private cloud.
2. Confirm the DNS forwarder addresses configured in NSX. [Configure a DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution#configure-dns-forwarder)
3. Confirm routing and firewall reachability from the forwarder to each upstream server.
4. Validate the documented UDP 53 path.
5. Determine whether the organization’s DNS implementation also requires TCP 53 for large responses, fallback, or administrative operations.
6. Resolve representative internal names.
7. Resolve representative public names.
8. Test the application’s actual named dependencies.
9. Verify symmetric return routing where stateful inspection is present.

> **Documentation correction:** The Azure VMware Solution checklist explicitly lists UDP 53. The broader recommendation to assess TCP 53 is an operational DNS-design check, not an AVS-specific port requirement stated in that table.

---

## 22. Active Directory and Administrator Identity

Active Directory integration is optional, not an inherent requirement for private-cloud operation. When configured, it allows vCenter roles to be assigned to enterprise identities. Azure VMware Solution uses Run Command procedures because the service-managed permissions do not allow `cloudadmin` to perform every identity-source operation directly. [Identity concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity) [Configure an external identity source for vCenter Server](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter)

### 22.1 Required Directory Paths

The Generation 1 network checklist identifies:

* TCP 389 for LDAP.
* TCP 636 for LDAP over SSL/TLS.
* TCP 3268 for Active Directory Global Catalog.
* TCP 3269 for secure Global Catalog. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports)

Microsoft recommends LDAPS when adding Windows Server Active Directory as an identity source. [Add Active Directory by using LDAP over SSL](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter#add-windows-server-active-directory-by-using-ldap-via-ssl)

### 22.2 Authentication and Authorization Flow

1. Configure DNS and routed connectivity from vCenter to the domain services. [Prerequisites](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter#prerequisites)
2. Add the Active Directory identity source through the documented Azure VMware Solution Run Command workflow. [Add Active Directory by using LDAP over SSL](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter#add-windows-server-active-directory-by-using-ldap-via-ssl)
3. Assign vCenter roles to the required users or groups. [Assign vCenter Server roles to Active Directory identities](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter#assign-more-vcenter-server-roles-to-windows-server-active-directory-identities)
4. An administrator signs in to vCenter with the configured enterprise identity.
5. vCenter queries the identity source and applies its VMware role mappings.
6. Access is granted according to those assignments.

### 22.3 Failure Implications

* Blocking LDAP or LDAPS prevents the configured directory query path.
* Blocking Global Catalog ports prevents workflows that depend on forest-wide catalog queries.
* DNS or routing failure can make the identity source unreachable.
* Certificate trust or hostname validation issues can prevent LDAPS.
* Local service-managed or emergency access must follow Azure VMware Solution’s supported operational model; the transcript does not define a break-glass procedure.

> **Documentation correction:** The original statement that the private cloud “must integrate” with enterprise identity was too strong. Azure VMware Solution can operate with its built-in service-managed access model; Active Directory is an optional external identity-source integration. [Identity concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity)

---

## 23. End-to-End Deployment and Validation Workflow

The following procedure consolidates the documented dependencies and the guide’s operational recommendations.

### Phase 1: Establish Eligibility and Naming

1. Confirm that the subscription uses an eligible commercial agreement. [Identify the subscription](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-subscription)
2. Select the Azure subscription and resource group. [Identify the resource group](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-resource-group)
3. Select a region that supports the required Generation 1 host SKU. [Identify the region or location](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-region-or-location)
4. Define a private-cloud name of 40 characters or fewer. [Define the resource name](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#define-the-resource-name)
5. Apply a short enterprise naming convention; do not depend on the unsupported transcript explanation about generated suffix length.

### Phase 2: Reserve Network Address Space

6. Select a contiguous, unused `/22` from the allowed private ranges. [Prerequisites](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#prerequisites)
7. Compare it against on-premises, branch, Azure, partner, and connected-cloud networks.
8. Exclude `169.254.0.0/24`, `169.254.2.0/23`, and `100.64.0.0/16`.
9. Do not use `172.17.0.0/16`. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)
10. Record the block in enterprise IP address management.
11. Protect the block from allocation to another project.

### Phase 3: Request and Allocate Hosts

12. Select the initial Generation 1 host type. [Identify the size hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-size-hosts)
13. Calculate the minimum three-host standard-cluster requirement.
14. Add N+1 failure headroom.
15. Subtract the fixed `MGMT-ResourcePool` reservation.
16. Include vSAN policy and management/control-plane storage consumption. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)
17. Submit the host quota request. [Request a host quota](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#request-a-host-quota)
18. Include the documented period of up to five business days.
19. Confirm allocation before fixing the migration date.

### Phase 4: Deploy the Initial Private Cloud

20. Deploy the initial Generation 1 private cloud with an eligible non-AV64 SKU.
21. Allow vCenter, NSX, vSAN, and management components to initialize.
22. Verify the homogeneous cluster and minimum host count.
23. Confirm the management resource reservation.
24. Validate vCenter, NSX, vSAN, and cluster health.
25. Add AV64 only as a later cluster in the eligible Generation 1 private cloud. [Add a new cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud#add-a-new-cluster)

### Phase 5: Establish ExpressRoute

26. Create or identify the organization’s on-premises ExpressRoute circuit.
27. Create an authorization key and identify the Azure VMware Solution managed circuit. [Create an ExpressRoute authorization key](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud#create-an-expressroute-auth-key-in-the-on-premises-expressroute-circuit)
28. Confirm four-byte ASN support on the enterprise router.
29. Confirm four-byte ASN support with the provider. [Virtual network and ExpressRoute circuit considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#virtual-network-and-expressroute-circuit-considerations)
30. Link the circuits through ExpressRoute Global Reach. [Peer private cloud to on-premises](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud#peer-private-cloud-to-on-premises)
31. Confirm enterprise prefixes are learned in Azure VMware Solution.
32. Confirm private-cloud prefixes are learned on-premises.
33. Test bidirectional routing. [Verify on-premises network connectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud#verify-on-premises-network-connectivity)

### Phase 6: Place External Storage

34. Determine whether Azure NetApp Files will be used as an NFS datastore.
35. Use the documented Generation 1 gateway/FastPath design and same-availability-zone placement. [Performance best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts#performance-best-practices)
36. Validate the complete logical storage path.
37. Measure datastore latency and throughput before production assignment.
38. Reject placement that fails application-specific storage objectives.

### Phase 7: Prepare HCX

39. Deploy and pair the HCX managers. [Configure VMware HCX](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)
40. Define the management network profile.
41. Define the uplink network profile.
42. Define the vMotion network profile.
43. Define the replication network profile. [Create network profiles](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx#create-network-profiles)
44. Validate source switching separately for vMotion profiles and workload Network Extension eligibility.
45. Remediate unsupported workload networks before extending them. [Restrictions and limitations for Network Extension](https://techdocs.broadcom.com/us/en/vmware-cis/hcx/vmware-hcx/4-11/vmware-hcx-user-guide-4-11/extending-networks-with-vmware-hcx/about-vmware-hcx-network-extension/restrictions-and-limitations-for-network-extension.html)
46. Create the dedicated `/26` HCX port group when scale requires it.
47. Validate the current service-mesh, extender, and extended-network limits. [Define VMware HCX network segments](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#define-vmware-hcx-network-segments)

### Phase 8: Approve Firewall Rules

48. Document source, destination, port, protocol, purpose, encryption, and failure impact.
49. Approve the scoped HTTPS, SSH, HCX manager, and HCX-to-ESXi flows.
50. Approve bulk-migration control.
51. Approve UDP 4500 for the HCX IPsec/IKEv2/NAT-T path.
52. Approve `perftest` and vMotion flows.
53. Approve DNS and, when used, Active Directory paths. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports)
54. Test each flow from the actual appliance interface and address pool.

### Phase 9: Configure Foundational Services

55. Configure NSX DHCP or another supported local/relay design. [Configure DHCP for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution)
56. Test mass-restart and WAN-failure behavior.
57. Configure NSX DNS forwarders. [Configure a DNS forwarder](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution#configure-dns-forwarder)
58. Validate internal and public name resolution.
59. When required, add Active Directory as a vCenter identity source through Run Command.
60. Validate LDAP/LDAPS, Global Catalog, DNS, certificate, and routing dependencies.
61. Assign vCenter roles and test an enterprise identity. [Configure an external identity source for vCenter Server](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter)

### Phase 10: Build and Validate the HCX Service Mesh

62. Confirm source and cloud HCX site pairing.
63. Create the service mesh. [Create a service mesh](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx#create-a-service-mesh)
64. Verify deployment of the required interconnect and Network Extension appliances.
65. Run the `perftest` uplink diagnostic.
66. Confirm acceptable effective bandwidth, latency, and packet loss.
67. Verify UDP 4500 tunnel establishment. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports)
68. Extend a nonproduction test network.
69. Confirm intended gateway and traffic-path behavior, including whether MON is used. [VMware HCX Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance)

### Phase 11: Execute a Pilot Migration

70. Select a noncritical virtual machine.
71. Choose a supported HCX migration type. [VMware HCX migration types](https://techdocs.broadcom.com/us/en/vmware-cis/hcx/vmware-hcx/4-11/vmware-hcx-user-guide-4-11/migrating-virtual-machines-with-vmware-hcx/vmware-hcx-migration-types.html)
72. Stage disk data through replication when using bulk migration.
73. Perform the migration.
74. Confirm the expected IP and MAC behavior when Network Extension is used.
75. Confirm gateway, DNS, optional directory, and application connectivity.
76. Validate performance, recovery, and rollback procedures.
77. Resolve dependencies before expanding the migration wave.

### Phase 12: Scale Migration Waves

78. Group workloads by application dependency, network, and cutover method.
79. Monitor service-mesh, extender, firewall, ExpressRoute, storage, and management capacity.
80. Stay within validated HCX and Azure VMware Solution limits. [Azure VMware Solution limits](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud)
81. Track temporary Layer 2 extensions and source-gateway dependencies.
82. Continue migration only while management, routing, DNS, DHCP, optional identity, storage, and application health remain within approved thresholds.

---

## 24. Failure and Troubleshooting Matrix

| Symptom | Likely cause | Validation action | Operational consequence |
| --- | --- | --- | --- |
| Private cloud or public-IP creation fails during deployment | Private-cloud name exceeds 40 characters | Review the resource-name length and deployment error. [Define the resource name](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#define-the-resource-name) | Deployment cannot complete with the invalid name |
| Deployment rejects the management network | `/22` overlaps another routed range or uses a prohibited range | Compare it with enterprise IPAM and the documented prerequisites. [Prerequisites](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#prerequisites) | Private cloud cannot deploy with that block |
| Routes are absent although the physical circuit is up | Four-byte ASN incompatibility or BGP/Global Reach failure | Inspect BGP, Global Reach status, and learned prefixes. [Virtual network and ExpressRoute circuit considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#virtual-network-and-expressroute-circuit-considerations) | The sites cannot exchange required routes |
| Selected prefixes are unreachable | Customer addressing overlaps reserved internal ranges | Compare routes with the documented reserved ranges. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations) | Traffic is misrouted or unavailable |
| Host replacement or HCX scale is constrained | Reserved address capacity was consumed or the service limit was reached | Review `/25` reservations, host count, and HCX allocations. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations) | Maintenance or scale-out is blocked |
| Application capacity is lower than expected | N+1 headroom, `MGMT-ResourcePool`, or vSAN policy overhead was omitted | Recalculate usable cluster capacity. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters) | Workloads do not fit or resilience is reduced |
| Management appliances remain protected while workloads are constrained | Fixed management reservation and HA admission control are operating | Inspect resource-pool and HA settings without attempting to remove service controls. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters) | Control plane remains protected |
| HCX cannot extend a workload network | The network uses an unsupported vSphere Standard Switch or another extension limitation applies | Validate Network Extension eligibility separately from the vMotion network profile. [Restrictions and limitations for Network Extension](https://techdocs.broadcom.com/us/en/vmware-cis/hcx/vmware-hcx/4-11/vmware-hcx-user-guide-4-11/extending-networks-with-vmware-hcx/about-vmware-hcx-network-extension/restrictions-and-limitations-for-network-extension.html) | The network must be remediated or the migration redesigned |
| Service mesh cannot be created | Management/uplink profile, DNS, routing, appliance deployment, or port 9443/4500 failure | Validate profiles, endpoint flows, and appliance state. [Create a service mesh](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx#create-a-service-mesh) | HCX interconnect services remain unavailable |
| Bulk migration stalls | TCP 8123 or replication connectivity is impaired | Test the scoped bulk-control and replication paths. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports) | Disk staging or synchronization cannot complete |
| HCX vMotion fails | TCP 8000 or the vMotion profile/path is unavailable | Test the actual vMotion endpoints and compute profile. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports) | Running-state transfer fails |
| Network Extension fails | UDP 4500 tunnel is blocked or an appliance is unhealthy | Inspect firewall logs, IPsec/IKEv2 tunnel status, and appliance health. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports) | Extended-network connectivity is lost |
| HCX diagnostic test fails | TCP/UDP 5201 is blocked or path performance is inadequate | Run `perftest` and inspect throughput, loss, and MTU. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports) | Readiness cannot be validated with that diagnostic |
| Migrated VM retains its IP but cannot reach its gateway | Network Extension, source gateway, routing, or MON state is incorrect | Trace the intended gateway path and check extender state. [VMware HCX Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance) | VM is isolated from required network services |
| Many VMs fail to obtain addresses after restart | DHCP relay/WAN/server capacity is unavailable | Inspect leases, relay health, packet flow, and server load. [Configure DHCP for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dhcp-azure-vmware-solution) | Recovery is delayed |
| Internal IPs are reachable but public names fail | DNS forwarder or upstream resolver is unreachable through the advertised route | Test the configured forwarder and representative public lookup. [DHCP and DNS resolution considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#dhcp-and-dns-resolution-considerations) | Named external dependencies fail |
| Enterprise identity cannot sign in | Identity source, LDAP/LDAPS, Global Catalog, DNS, certificate, or routing failure | Test vCenter-to-directory connectivity and role assignment. [Prerequisites](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter#prerequisites) | Enterprise identity access is disrupted |
| External datastore performance collapses | Gateway/FastPath, zone placement, latency, throughput, or storage configuration is unsuitable | Measure datastore performance and inspect placement. [Performance best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts#performance-best-practices) | I/O wait, timeout, or application failure occurs |
| Stretched cluster consumes more capacity than planned | Six-host minimum, symmetric scale, or storage-policy/control-plane overhead was omitted | Recalculate hosts and vSAN consumption from the stretched-cluster design. [Background](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters#background) | Capacity and budget are insufficient |

---

## 25. Capacity and Performance Planning Principles

### 25.1 Size for Usable, Not Raw, Capacity

* Do not equate the sum of host specifications with application capacity.
* Subtract N+1 standard-cluster failover headroom. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)
* For a stretched cluster, model the documented six-host minimum, symmetric placement, and storage policies. [Background](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-stretched-clusters#background)
* Subtract the fixed 171.88-GB management memory reservation and account for the 46-GHz CPU reservation.
* Account for vSAN management/control-plane consumption and workload storage-policy overhead. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)
* Include growth, maintenance, migration coexistence, and service limits.

### 25.2 Protect Operational Swing Space

* Preserve the 19 addresses reserved for host replacement and maintenance.
* Preserve the 10 host-network addresses reserved for HCX.
* Leave capacity to introduce a replacement host before removing the old host.
* Avoid designs that depend on consuming every supported host, address, and datastore unit. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)

### 25.3 Treat Bandwidth and Latency Separately

* A 100-Gbps host interface does not make a distant storage operation local. [Identify the size hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#identify-the-size-hosts)
* ExpressRoute bandwidth does not eliminate propagation, gateway, queueing, or storage-controller latency.
* For Azure NetApp Files, use the documented same-zone and FastPath guidance and measure the application’s actual I/O behavior. [Performance best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts#performance-best-practices)
* Database sensitivity depends on concurrency, I/O size, caching, and synchronous acknowledgement patterns.

### 25.4 Plan for Simultaneous Failure Recovery

* Model mass VM restarts rather than only normal boot behavior.
* Keep DHCP local where practical and capacity-test relays when remote DHCP is required. [DHCP and DNS resolution considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#dhcp-and-dns-resolution-considerations)
* Preserve management-appliance reservations.
* Confirm that routing, DNS, optional identity, and storage remain available during the same failure scenario.

---

## 26. Operational Recommendations

> **Operational recommendation:**

* Begin network planning before requesting hosts because the `/22` must be contiguous, allowed, and nonoverlapping. [Define the IP address segment for private cloud management](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#define-the-ip-address-segment-for-private-cloud-management)
* Use a short private-cloud name rather than consuming the full 40-character limit.
* Submit host quota requests early and treat the documented five-business-day period as a project dependency. [Request a host quota](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#request-a-host-quota)
* Deploy an eligible Generation 1 initial cluster before adding AV64. [Add a new cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud#add-a-new-cluster)
* Size workloads against failure-tolerant usable capacity, not raw host totals.
* Validate vSAN policy and service-managed storage consumption for the chosen topology.
* Confirm four-byte ASN support through device capabilities and a live route-exchange test. [Virtual network and ExpressRoute circuit considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#virtual-network-and-expressroute-circuit-considerations)
* Place Azure NetApp Files in the same availability zone and use the supported Generation 1 gateway/FastPath design. [Performance best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts#performance-best-practices)
* Validate vMotion network profiles and workload Network Extension switch eligibility as separate HCX checks.
* Give the firewall team an endpoint-specific port matrix rather than a generic request to “allow HCX.” [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports)
* Treat UDP 4500 as a primary HCX tunnel dependency when Network Extension is required.
* Keep DHCP local where practical and explicitly configure DHCP behavior for stretched networks.
* Test internal and public DNS resolution after route changes.
* Treat Active Directory integration as optional, but validate it from vCenter when configured.
* Use a nonproduction HCX pilot to test routing, Network Extension, storage, and identity dependencies.
* Monitor stretched networks as explicit migration dependencies with a documented exit plan.

---

## 27. Architectural Reflection: The Server Room Inside the Cloud

The transcript closes by asking whether enterprise VMware migration represents full cloud transformation or a more resilient managed form of the traditional data center.

* HCX can stretch existing Layer 2 networks into Azure VMware Solution. [Configure HCX Network Extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension)
* Optional Active Directory integration carries LDAP or LDAPS identity queries across the hybrid path. [Configure an external identity source for vCenter Server](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter)
* Migrated VMs can retain existing IP and MAC addresses through Network Extension. [Extend network](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-hcx-access-over-internet#extend-network)
* Azure VMware Solution recreates familiar vCenter, NSX, ESXi, and vSAN operational models on dedicated Azure-hosted infrastructure. [Azure VMware Solution introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)
* The service provides managed infrastructure and Azure integration while preserving many application and network assumptions from the source VMware estate.
* The architecture therefore serves as both:

  * A bridge for moving existing enterprise workloads.
  * A reminder that migration and modernization are different activities.

> **Architectural interpretation:** Azure VMware Solution can reduce the immediate need to redesign applications, but the resulting environment still depends on planned hosts, subnets, ports, routes, identity paths, and storage locations. The abstraction boundary moves; it does not eliminate physical and protocol constraints.

---

## Architecture Summary

Azure VMware Solution Generation 1 combines dedicated VMware hosts, service-managed VMware infrastructure, ExpressRoute-based networking, and HCX migration services. The physical, management, network, storage, security, and optional identity layers form one dependency chain. [Azure VMware Solution introduction](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)

### End-to-End Architecture and Traffic Flow

1. **Enterprise subscription and resource definition**

   * Use an eligible subscription arrangement.
   * Select the subscription, resource group, supported region, and a private-cloud name of no more than 40 characters. [Plan an Azure VMware Solution deployment](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment)

2. **Dedicated host allocation**

   * A quota request initiates allocation of isolated, tested bare-metal ESXi hosts.
   * Microsoft can take up to five business days to confirm the allocation.
   * Microsoft documents secure deletion before reassignment; the transcript’s detailed overwrite process remains unsupported. [Request a host quota](https://learn.microsoft.com/en-us/azure/azure-vmware/plan-private-cloud-deployment#request-a-host-quota)

3. **Initial private-cloud cluster**

   * At least three homogeneous hosts form the first cluster.
   * vCenter, NSX, vSAN, NSX Edge, and vSphere Cluster Service components use service-managed resources.
   * N+1 admission control and `MGMT-ResourcePool` reservations protect availability and management capacity. [Clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds#clusters)
   * In Generation 1, AV64 is added only after an eligible initial cluster exists. [Add a new cluster](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-scale-private-cloud#add-a-new-cluster)

4. **Private-cloud network zoning**

   * A nonoverlapping `/22` provides 1,024 total addresses.
   * The service subdivides it into management, HCX, ExpressRoute, ESXi, vMotion, replication, vSAN, and reserved ranges.
   * Capacity remains reserved for HCX and host lifecycle operations.
   * Documented internal conflict ranges are excluded. [Routing and subnet considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations)

5. **Private enterprise routing**

   * The Generation 1 managed ExpressRoute circuit is linked to the organization’s on-premises ExpressRoute circuit through Global Reach.
   * BGP exchanges enterprise and private-cloud prefixes.
   * Connected equipment supports four-byte ASNs.
   * Physical circuit state and route-exchange state are validated separately. [On-premises interconnectivity](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-networking#on-premises-interconnectivity)

6. **External datastore path**

   * Azure NetApp Files can provide an NFS datastore.
   * The Generation 1 design uses supported ExpressRoute gateway/FastPath connectivity and same-availability-zone placement.
   * Storage remains subject to end-to-end latency and throughput. [Performance best practices](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts#performance-best-practices)

7. **HCX mobility services**

   * Management, uplink, vMotion, and replication profiles support the service mesh.
   * vMotion-profile support and workload Network Extension switch support are evaluated separately.
   * Bulk migration stages replicated disk data.
   * HCX vMotion transfers a running VM with minimal interruption.
   * Network Extension preserves eligible Layer 2 addressing across the migration path. [Configure VMware HCX](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-hcx)

8. **Firewall-controlled hybrid path**

   * Management and deployment use scoped ports including TCP 443, 9443, 22, and 902.
   * Bulk control uses TCP 8123.
   * vMotion uses TCP 8000.
   * `perftest` uses TCP and UDP 5201.
   * HCX IPsec/IKEv2/NAT-T uses UDP 4500. [Required network ports](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#required-network-ports)

9. **Foundational network services**

   * DHCP should be local where practical, with explicit relay or stretched-network configuration when required.
   * DNS forwarders must reach resolvers through the chosen routing design.
   * Optional Active Directory integration uses the documented LDAP/LDAPS and Global Catalog paths. [DHCP and DNS resolution considerations](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist#dhcp-and-dns-resolution-considerations)

10. **Workload migration**

    * A pilot validates storage, routing, DNS, optional identity, and application behavior.
    * Production workloads move in controlled waves.
    * Network Extension can preserve addresses while source-gateway dependencies are tracked.
    * Management reservation, bandwidth, latency, and extender health are monitored throughout the transition.

The resulting architecture can move existing VMware workloads into Azure with limited application change, but that simplicity depends on disciplined capacity planning, address governance, private routing, encrypted HCX tunneling, protected management resources, and coordinated operations.

---

## Documentation and Interpretation Notes

* **Material corrections:** The documented inter-VRF range is `169.254.2.0/23`; the large-HCX network is `/26`; the diagnostic is `perftest`; TCP 902 belongs in the HCX-to-ESXi matrix; the DHCP limited broadcast is `255.255.255.255`; and HCX uses the documented IPsec/IKEv2/NAT-T terminology.
* **Claims remaining unsupported:** The reviewed official sources do not substantiate the transcript’s DNS-suffix/certificate explanation for the 40-character name limit, the “NIST-888” multi-pass media-erasure description, the Docker-container rationale for excluding `172.17.0.0/16`, or “military-grade encryption.”
* **Architecture distinctions:** Generation 1 uses a service-managed ExpressRoute circuit and can connect on-premises through Global Reach; it must not be conflated with Generation 2 native virtual-network connectivity. HCX vMotion network profiles and HCX Network Extension workload-switch eligibility are separate checks.
* **Interpretive recommendations:** Treat usable capacity rather than raw capacity as the sizing basis; treat Layer 2 extension as a temporary controlled migration state; plan DHCP, DNS, routing, identity, and storage as one failure domain; and validate performance from the actual workload and appliance paths.
