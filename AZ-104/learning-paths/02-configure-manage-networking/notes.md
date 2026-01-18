# Learning Path 2: Configure and Manage Virtual Networks

**Learning Path** [Microsoft Learn](https://learn.microsoft.com/en-us/training/paths/az-104-manage-virtual-networks/)

* [Plan virtual networks](#plan-virtual-networks)
* [Create subnets](#create-subnets)


---

<!-- omit in toc -->
## 📋 Modules

| # | Module | Status |
|---|--------|--------|
| 1 | [Configure virtual networks](https://learn.microsoft.com/en-us/training/modules/configure-virtual-networks/) | 🕒 |
| 2 | [Configure network security groups](https://learn.microsoft.com/en-us/training/modules/configure-network-security-groups/) | 🕒 |
| 3 | [Host your domain on Azure DNS](https://learn.microsoft.com/en-us/training/modules/host-domain-azure-dns/) | 🕒 |
| 4 | [Configure Azure Virtual Network peering](https://learn.microsoft.com/en-us/training/modules/configure-vnet-peering/) | 🕒 |
| 5 | [Manage and control traffic flow in your Azure deployment with routes](https://learn.microsoft.com/en-us/training/modules/control-network-traffic-flow-with-routes/) | 🕒 |
| 6 | [Introduction to Azure Load Balancer](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-load-balancer/) | 🕒 |
| 7 | [Introduction to Azure Application Gateway](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-application-gateway/) | 🕒 |
| 8 | [Introduction to Azure Network Watcher](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-network-watcher/) | 🕒 |

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


*Last updated: 2026-01-14*
