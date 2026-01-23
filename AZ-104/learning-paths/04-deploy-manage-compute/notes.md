# Learning Path 3: Deploy and Manage Compute Resources

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/paths/az-104-manage-compute-resources/)

---

## 📋 Modules

| # | Module | Status | Completed |
|---|--------|--------|-------|
| 1 | [Introduction to Azure virtual machines](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-virtual-machines/) | 🕒 | |
| 2 | [Configure virtual machine availability](https://learn.microsoft.com/en-us/training/modules/configure-virtual-machine-availability/) | 🕒 | |
| 3 | [Configure Azure App Service plans](https://learn.microsoft.com/en-us/training/modules/configure-app-service-plans/) | 🕒 | |
| 4 | [Configure Azure App Service](https://learn.microsoft.com/en-us/training/modules/configure-azure-app-services/) | 🕒 | |
| 5 | [Configure Azure Container Instances](https://learn.microsoft.com/en-us/training/modules/configure-azure-container-instances/) | 🕒 | |

---

## Compile a checklist for creating an Azure Virtual Machine

[Module Reference](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-virtual-machines/2-compile-a-checklist-for-creating-a-vm)

**What is an Azure resource?**

* An **Azure resource** is a manageable item in Azure
* An IaaS VM consists of multiple resources:

  * **Virtual machine**
  * **Disks** for storage
  * **Virtual network**
  * **Network interface**
  * **Network Security Group (NSG)**
  * **IP address** (public, private, or both)
* Azure can create these resources automatically or use existing ones
* Resource names are generated from the **VM name** if Azure creates them
* Consistent VM naming is important because names are difficult to change later

**Required resources checklist**

* **Virtual network**
* **VM name**
* **Location**
* **VM size**
* **Disks**
* **Operating system**

**Network planning**

* Network design should be planned **before** creating VMs
* Consider:

  * What the server communicates with
  * Which ports must be open
* **Virtual Networks (VNets)** provide private connectivity between:

  * Azure VMs
  * Azure services in the same VNet
* External access is blocked by default but can be enabled
* Network address spaces and subnets are difficult to change later
* Address spaces must **not overlap** with:

  * Other VNets
  * On-premises networks
* Common private IP ranges:

  * **10.0.0.0/8**
  * **172.16.0.0/12**
  * **192.168.0.0/16**

**Subnet design**

* Subnets segment the VNet into manageable sections
* Example segmentation:

  * **10.1.0.0** – VMs
  * **10.2.0.0** – Backend services
  * **10.3.0.0** – SQL Server VMs
* Azure reserves:

  * **First four IP addresses**
  * **Last IP address** in each subnet

**Network security**

* No default security boundary exists between subnets
* **Network Security Groups (NSGs)** control traffic:

  * Inbound and outbound
  * At subnet and NIC levels
* NSGs act as software firewalls with custom rules

**VM deployment planning**

* Inventory each on-premises server:

  * OS type
  * Disk space usage
  * Data sensitivity or legal restrictions
  * CPU, memory, and disk I/O usage
  * Burst or peak traffic patterns

**VM naming**

* VM name is used as:

  * Computer name in the OS
  * Azure resource name
* Name length limits:

  * **Linux**: up to **64 characters**
  * **Windows**: up to **15 characters**
* Recommended naming elements:

  * **Environment** (dev, prod, QA)
  * **Location** (eus, jw)
  * **Instance number** (01, 02)
  * **Product or service**
  * **Role** (web, sql, messaging)
* Example: **deveus-webvm01**

**Location selection**

* Azure regions group datacenters geographically
* Consider:

  * Proximity to users
  * Legal, compliance, or tax requirements
  * Hardware availability (varies by region)
  * Regional price differences

**VM size selection**

* VM size defines CPU, memory, and storage combinations
* Size choice directly affects cost
* Workload-based size categories:

  * **General purpose**
  * **Compute optimized**
  * **Memory optimized**
  * **Storage optimized**
  * **GPU**
  * **High performance compute**

**Resizing VMs**

* VM sizes can be changed if supported by hardware
* Resizing a running VM:

  * Causes an **automatic reboot**
  * Only allowed if size is available in the current cluster
* Stopping and deallocating a VM allows:

  * Any size available in the region
* Resizing production VMs can cause outages and IP changes

**VM components and billing**

* Default supporting resources:

  * Virtual network
  * NIC (no separate cost, limited by VM size)
  * Private and/or public IP address
  * NSG (no additional charge)
  * OS disk and local disk
* Local disk storage:

  * **No charge**
* OS disk:

  * Typically **127 GiB**
  * Charged at standard disk rates
* OS licenses:

  * Cost varies by VM size and core count
  * Can be reduced using **Azure Hybrid Benefit**

**Pricing model**

* Two cost categories:

  * **Compute**
  * **Storage**
* Compute costs:

  * Billed per minute
  * Charged only while VM is running
  * Linux is cheaper (no OS license)
* Compute payment options:

  * **Pay-as-you-go**
  * **Reserved Virtual Machine Instances** (1 or 3 years, up to **72% savings**)
* Storage costs:

  * Charged regardless of VM state
  * Continue even when VM is stopped/deallocated

**Storage for VMs**

* Every VM includes:

  * **OS disk**
  * **Temporary disk**
* Additional **data disks** recommended for application data
* Max data disks typically **2 per vCPU**
* Disk types:

  * **Ultra disks**
  * **Premium SSD v2 (preview)**
  * **Premium SSD**
  * **Standard SSD**
  * **Standard HDD**
* OS disk support:

  * Ultra disks and Premium SSD v2: **Not supported**
  * All others: **Supported**

**Operating system selection**

* Azure provides:

  * Windows and multiple Linux distributions
* OS choice affects compute pricing
* Marketplace images can include:

  * OS plus preconfigured software stacks
* Custom images:

  * Can be created and reused
  * Can be managed and replicated using **Azure Compute Gallery**

**Key Facts to Remember**

* VM names are hard to change — plan naming early
* VNets and address spaces are difficult to modify after deployment
* Azure reserves **5 IP addresses per subnet**
* Resizing a running VM causes a reboot
* Compute and storage are billed separately
* Storage charges apply even when VMs are stopped
* Disk type selection directly impacts performance and cost

---
