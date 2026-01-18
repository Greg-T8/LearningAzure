# Learning Path 2: Configure and Manage Virtual Networks

**Learning Path** [Microsoft Learn](https://learn.microsoft.com/en-us/training/paths/az-104-manage-virtual-networks/)

* [Plan virtual networks](#plan-virtual-networks)
* [Create subnets](#create-subnets)
* [Create virtual networks](#create-virtual-networks)
* [Plan IP addressing](#plan-ip-addressing)
* [Create public IP addressing](#create-public-ip-addressing)
* [Associate public IP addresses](#associate-public-ip-addresses)
* [Allocate or assign private IP addresses](#allocate-or-assign-private-ip-addresses)
* [Exercise: Create and configure virtual networks](#exercise-create-and-configure-virtual-networks)


---

<!-- omit in toc -->
## 📋 Modules

| # | Module | Status |
|---|--------|--------|
| 1 | [Configure virtual networks](https://learn.microsoft.com/en-us/training/modules/configure-virtual-networks/) | ✅ |
| 2 | [Configure network security groups](https://learn.microsoft.com/en-us/training/modules/configure-network-security-groups/) | 🕒 |
| 3 | [Host your domain on Azure DNS](https://learn.microsoft.com/en-us/training/modules/host-domain-azure-dns/) | 🕒 |
| 4 | [Configure Azure Virtual Network peering](https://learn.microsoft.com/en-us/training/modules/configure-vnet-peering/) | 🕒 |
| 5 | [Manage and control traffic flow in your Azure deployment with routes](https://learn.microsoft.com/en-us/training/modules/control-network-traffic-flow-with-routes/) | 🕒 |
| 6 | [Introduction to Azure Load Balancer](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-load-balancer/) | 🕒 |
| 7 | [Introduction to Azure Application Gateway](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-application-gateway/) | 🕒 |
| 8 | [Introduction to Azure Network Watcher](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-network-watcher/) | 🕒 |

**Legend:** 🕒 Not Started | 🚧 In Progress | ✅ Complete

---

## Plan virtual networks

[Module Reference](https://learn.microsoft.com/training/modules/configure-virtual-networks/)

**Purpose of Moving to Azure**

* Enables IT departments to transition server resources to the cloud
* Reduces costs and simplifies administration
* Eliminates the need to maintain:

  * Datacenters
  * Uninterruptible power supplies
  * Generators
  * Multiple fail-safes
  * Clustered database servers
* Particularly attractive for **small and medium-sized companies** that lack expertise to maintain robust infrastructure

<img src='.img/2026-01-18-06-04-25.png' width=600>

**Things to Know About Azure Virtual Networks**

* **Azure Virtual Network (VNet)** provides a virtual representation of a network in the cloud
* VNets enable more effective deployment and connection of cloud resources
* An Azure virtual network is a **logical isolation** of Azure cloud resources
* VNets can be used to provision and manage **virtual private networks (VPNs)** in Azure
* Each VNet has its own **CIDR block**
* VNets can be linked to:

  * Other virtual networks
  * On-premises networks
* Hybrid or cross-premises solutions are supported when **CIDR blocks do not overlap**
* You control:

  * **DNS server settings**
  * **Segmentation into subnets**

**Common Virtual Network Scenarios**

* **Create a dedicated private cloud-only virtual network**

  * No cross-premises connectivity required
  * Resources communicate securely within the cloud
  * Internet access can still be configured via endpoints as needed

* **Securely extend your data center**

  * Uses **site-to-site VPNs**
  * Securely scales datacenter capacity
  * Site-to-site VPNs use **IPSEC**
  * Connects corporate VPN gateway to Azure

* **Enable hybrid cloud scenarios**

  * Supports a wide range of hybrid configurations
  * Securely connects cloud-based applications to on-premises systems
  * Works with systems such as **mainframes** and **Unix systems**

**Key Facts to Remember**

* Azure VNets provide **logical isolation** of cloud resources
* Every VNet requires a **CIDR address block**
* **Non-overlapping CIDR blocks** are required for connected networks
* VNets support **VPNs, hybrid, and cloud-only** scenarios
* DNS configuration and subnet design are fully controlled by the user

---

## Create subnets

[Module Reference](https://learn.microsoft.com/training/modules/configure-virtual-networks/create-subnets)

**Overview**

* **Azure subnets** provide logical segmentation within a virtual network.
* Subnets help **improve security**, **increase performance**, and **simplify management**.

**Subnet IP Address Requirements**

* Each subnet contains an IP address range that falls **within the virtual network address space**.
* Each subnet’s address range must be **unique** within the virtual network.
* Subnet IP ranges **cannot overlap** with other subnets in the same virtual network.
* Subnet address space must be specified using **CIDR notation**.
* A virtual network can be segmented into **one or more subnets**.

<img src='.img/2026-01-18-06-05-55.png' width=700>

**Reserved Addresses**

* Azure reserves **five IP addresses per subnet**.
* The **first four IP addresses** and the **last IP address** are reserved.

**Reserved Address Example (192.168.1.0/24)**

| Reserved Address              | Purpose                                |
| ----------------------------- | -------------------------------------- |
| **192.168.1.0**               | Identifies the virtual network address |
| **192.168.1.1**               | Default gateway                        |
| **192.168.1.2 – 192.168.1.3** | Azure DNS IP addresses                 |
| **192.168.1.255**             | Broadcast address                      |

**Things to Consider When Using Subnets**

* **Service requirements**

  * Some services require **their own subnet**.
  * Ensure enough **unallocated IP space** for service needs.
  * Azure VPN Gateway requires a **dedicated gateway subnet**.
* **Network virtual appliances**

  * Azure routes traffic between subnets **by default**.
  * Default routing can be overridden to:

    * Block inter-subnet traffic
    * Route traffic through a **network virtual appliance**
  * Deploy resources to **different subnets** if traffic must flow through an appliance.
* **Network security groups (NSGs)**

  * Each subnet can have **zero or one NSG**.
  * The same NSG can be reused across subnets or assigned individually.
  * NSGs contain rules to **allow or deny inbound and outbound traffic**.
* **Private Link**

  * Provides **private connectivity** from a virtual network to:

    * Azure PaaS services
    * Customer-owned services
    * Microsoft partner services
  * Eliminates data exposure to the **public internet**.

**Key Facts to Remember**

* **5 IP addresses** are always reserved per subnet.
* Subnet IP ranges **must not overlap**.
* CIDR notation is **required** for subnet address space.
* Azure VPN Gateway requires a **dedicated subnet**.
* Only **one NSG per subnet** is allowed.

---

## Create virtual networks

[Module Reference](URL)

**Overview**

* You can create a virtual network at any time.
* You can also create a virtual network during virtual machine creation.

**IP Address Space Requirements**

* You must define an **IP address space** when creating a virtual network.
* The address space must **not already be in use** within your organization.
* The address space can be **on-premises or cloud-based**, but **not both**.
* Once created, the **IP address space cannot be changed**.
* Planning cloud-only address spaces is important if future **on-premises connectivity** is expected.

**Subnet Requirements**

* At least **one subnet** is required to create a virtual network.
* Each subnet:

  * Contains a **range of IP addresses** within the virtual network address space.
  * Must have a **unique address range**.
  * **Cannot overlap** with any other subnet in the same virtual network.

**Creation in Azure Portal**

* Required inputs:

  * **Azure subscription**
  * **Resource group**
  * **Virtual network name**
  * **Service region**

**Limits and Considerations**

* Default limits on Azure networking resources **can change over time**.
* Always review the latest Azure networking documentation before deployment.

**Key Facts to Remember**

* **IP address space is immutable** after creation.
* **At least one subnet is mandatory**.
* **Subnet IP ranges must be unique and non-overlapping**.
* Address space must be **unused and either cloud or on-premises only**, not both.

---

## Plan IP addressing

[Module Reference](https://learn.microsoft.com/training/modules/configure-virtual-networks/plan-ip-addressing)

**Overview**

* IP addresses enable Azure resources to communicate with:

  * Other Azure resources
  * On-premises networks
  * The internet
* Azure supports **two types of IP addresses**:

  * **Private IP addresses**
  * **Public IP addresses**

**Private IP Addresses**

* Enable communication **within an Azure virtual network**
* Enable communication with **on-premises networks**
* Created when you extend your network to Azure using:

  * **VPN gateway**
  * **Azure ExpressRoute circuit**

**Public IP Addresses**

* Allow Azure resources to communicate with the **internet**
* Used to connect with **Azure public-facing services**

<img src='.img/2026-01-18-06-14-49.png' width=800>

**IP Address Assignment Types**

* IP addresses can be:

  * **Statically assigned**
  * **Dynamically assigned**
* You can separate static and dynamic IP resources into **different subnets**

**Static IP Address Characteristics**

* **Do not change**
* Best suited for scenarios requiring consistent addressing, including:

  * **DNS name resolution** where IP changes would require host record updates
  * **IP-based security models** that require fixed IPs
  * **TLS/SSL certificates** linked to an IP address
  * **Firewall rules** that allow or deny traffic based on IP ranges
  * **Role-based virtual machines**, such as:

    * Domain Controllers
    * DNS servers

**Key Facts to Remember**

* Azure uses **private and public IP addresses**
* **Private IPs** are for internal and hybrid connectivity
* **Public IPs** enable internet access
* IPs can be **static or dynamic**
* **Static IPs** are required for DNS, security rules, certificates, firewalls, and critical infrastructure roles

---

## Create public IP addressing

[Module Reference](https://learn.microsoft.com/training/modules/configure-virtual-networks/create-public-ip-addressing)

**Overview**

* You can create a **public IP address** for an Azure resource using the **Azure portal**
* A common use case is assigning a public IP address to a **virtual machine**
* Public IP addresses are **often used with load balancers**

<img src='.img/2026-01-18-06-16-00.png' width=700>

**Configuration Settings for Public IP Addresses**

* **IP Version**

  * **IPv4**

    * Can be attached to:

      * Load balancers
      * Network interfaces
  * **IPv6**

    * Can only be attached to **load balancers**
  * **IPv4 and IPv6 are charged at the same rate**

* **SKU**

  * Select the SKU for the public IP address
  * The **Public IP SKU must match** the SKU of the **Load Balancer** it is used with

* **Tier**

  * Must match the **load balancer tier**
  * **Cross-region**

    * Distributes traffic across **regional backends**
  * **Regional**

    * Distributes traffic **within a virtual network**

* **IP Address Assignment**

  * Public IP addresses are **static**
  * Assigned **when the public IP address is created**
  * Not released until the **public IP address resource is deleted**

**Key Facts to Remember**

* Public IPs are created in the **Azure portal**
* Frequently used with **load balancers**
* **IPv6 public IPs** can only be used with load balancers
* **SKU and tier must match** the associated load balancer
* Public IP addresses are **static by default** and persist until deletion

---

## Associate public IP addresses

[Module Reference](https://learn.microsoft.com/training/modules/configure-virtual-networks/associate-public-ip-addresses)

**Overview**

* A **public IP address resource** can be associated with:

  * Virtual machine **network interfaces**
  * Internet-facing **load balancers**
  * **VPN gateways**
  * **Application gateways**
* Resources can use **dynamic or static** public IP addresses.

**Important**

* **Basic SKU public IPs were retired on September 30, 2025**.

**Association by Resource Type**

* **Virtual machine**

  * Associated at the **network interface configuration**
* **Virtual Network Gateway (VPN)**

  * Associated at the **gateway IP configuration**
* **Virtual Network Gateway (ER)**

  * Associated at the **gateway IP configuration**
* **NAT Gateway**

  * Associated at the **gateway IP configuration**
* **Public Load Balancer**

  * Associated at the **front-end configuration**
* **Application Gateway**

  * Associated at the **front-end configuration**
* **Azure Firewall**

  * Associated at the **front-end configuration**
* **Route Server**

  * Associated at the **front-end configuration**
* **API Management**

  * Associated at the **front-end configuration**
* **Bastion host**

  * Associated at the **public IP configuration**

**Public IP Address SKU Features**

* **Standard SKU**

  * **Allocation method**: Static
  * **Security**: Secure by default model
  * **Availability zones**: Supported

    * Can be **nonzonal**, **zonal**, or **zone-redundant**

**Key Facts to Remember**

* Public IPs attach at **different configuration levels** depending on resource type.
* **Standard SKU** is the supported option after **Basic SKU retirement**.
* Standard public IPs are **static**, **secure by default**, and **zone-aware**.

---

## Allocate or assign private IP addresses

[Module Reference](https://learn.microsoft.com/training/modules/configure-virtual-networks/allocate-or-assign-private-ip-addresses)

**Overview**

* A **private IP address resource** can be associated with:

  * Virtual machine **network interfaces (NICs)**
  * **Internal load balancers**
  * **Application gateways**
* Private IP addresses can be **dynamically assigned by Azure** or **statically assigned by you**.

**Association by Resource Type**

* **Virtual machine**

  * Association: **NIC**
  * Dynamic IP: **Yes**
  * Static IP: **Yes**
* **Internal load balancer**

  * Association: **Front-end configuration**
  * Dynamic IP: **Yes**
  * Static IP: **Yes**
* **Application gateway**

  * Association: **Front-end configuration**
  * Dynamic IP: **Yes**
  * Static IP: **Yes**

**Private IP Address Assignment**

* Private IPs are allocated from the **address range of the subnet** where the resource is deployed.
* Two allocation options are available:

  * **Dynamic**
  * **Static**

**Dynamic Assignment**

* Azure assigns the **next available unassigned or unreserved IP address** in the subnet.
* **Default allocation method**
* Example:

  * Assigned: `10.0.0.4` – `10.0.0.9`
  * Next assigned by Azure: **`10.0.0.10`**

**Static Assignment**

* You manually select **any unassigned or unreserved IP address** in the subnet.
* Example:

  * Subnet range: `10.0.0.0/16`
  * Assigned: `10.0.0.4` – `10.0.0.9`
  * Valid static range: **`10.0.0.10` – `10.0.255.254`**

**Key Facts to Remember**

* Private IPs are always allocated **from the subnet address range**.
* **Dynamic assignment** is the default and automatic.
* **Static assignment** requires manual selection of a valid, unused IP.
* NICs and front-end configurations determine **where private IPs are associated**.

---

## Exercise: Create and configure virtual networks

[Module Reference](URL)

**Exercise scenario**

* Your organization is migrating a **web-based application** to **Azure**.
* First task: set up **virtual networks** and **subnets**.
* You also need to **securely peer** the virtual networks.

<img src='.img/2026-01-18-06-19-49.png' width=800>

**Requirements**

* Create **two virtual networks**:

  * **app-vnet**
  * **hub-vnet**
* These virtual networks simulate a **hub-and-spoke network architecture**.
* **app-vnet** hosts the application and requires **two subnets**:

  * **frontend subnet** – hosts the **web servers**
  * **backend subnet** – hosts the **database servers**
* **hub-vnet** requires **one subnet**:

  * subnet for the **firewall**
* Configure the two virtual networks to communicate **securely and privately** using **virtual network peering**.
* Both virtual networks should be in the **same region**.

**Job skills**

* Create a **virtual network**
* Create a **subnet**
* Configure **virtual network peering** (**optional**)

**Notes**

* Estimated time: **30 minutes**
* Requires an **Azure subscription**
* Launch the exercise and follow the instructions; when finished, return to continue learning.

**Key Facts to Remember**

* Virtual networks required: **2** (**app-vnet**, **hub-vnet**) in the **same region**
* Subnets: **app-vnet = 2** (frontend/web, backend/database); **hub-vnet = 1** (firewall)
* Connectivity between vnets uses **virtual network peering** for **secure, private** communication

---


*Last updated: 2026-01-14*
