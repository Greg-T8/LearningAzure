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

## Exercise - Create a VM using the Azure portal

[Module Reference](https://learn.microsoft.com/training/modules/intro-to-azure-virtual-machines/)

**Purpose of the Exercise**

* Demonstrates how to create an Azure virtual machine using the **Azure portal**
* Shows a **browser-based** approach compared to command-line tools
* Exercise is **optional** and requires an **Azure subscription**
* Intended as a walkthrough, not a full explanation of all VM options

**Prerequisites and Notes**

* An **Azure subscription** is required to complete the exercise
* A **resource group** is required

  * You can use an existing resource group
  * Creating a new resource group makes cleanup easier
* Replace `myResourceGroupName` with your actual resource group name in all examples

**Options to Create and Manage Virtual Machines**

* Azure supports:

  * **Azure portal** (web-based UI)
  * **Command-line tools** (Linux, macOS, Windows)

**Azure Portal Overview**

* Browser-based interface for creating and managing Azure resources
* Supports:

  * Resource creation
  * Scaling compute resources
  * Cost monitoring
* Uses guided wizards, making it suitable for learning and exploration

**Steps to Create an Azure VM Using the Azure Portal**

* Sign in to the **Azure portal**
* On the home page:

  * Select **Create a resource**
  * Choose **Virtual machine**
* The **Create virtual machine** pane opens

**VM Configuration – Basics Tab**

* **Project details**

  * **Subscription**: Select your subscription
  * **Resource group**: Select `myResourceGroupName`
* **Instance details**

  * **Virtual machine name**: `test-ubuntu-cus-vm`
  * **Region**: Select a region close to you
  * **Availability options**: No infrastructure redundancy required
  * **Security type**: Standard
  * **Image**: Ubuntu Server 24.04 LTS – Gen2
  * **VM architecture**: x64
  * **Run with Azure Spot discount**: Unchecked
  * **Size**: Standard D2s V3
* **Administrator account**

  * **Authentication type**: SSH public key
  * **Username**: User-defined
  * **SSH public key source**: Generate a new key pair
  * **Key pair name**: `test-ubuntu-cus-vm_key`
* **Inbound port rules**

  * **Public inbound ports**: Allow selected ports
  * **Select inbound ports**: SSH (22)

**Validation and Deployment**

* Select **Review + create** to validate settings
* Azure performs configuration validation before deployment
* Errors are shown by tab and must be resolved before continuing
* Select **Create** to deploy the VM
* When prompted:

  * Select **Download private key and create resource**

**Monitoring Deployment**

* Deployment progress can be viewed in:

  * **Deployment details** on the Overview pane
  * **Notifications** pane (top-right toolbar icon)
* Deployment takes a few minutes
* A notification confirms successful deployment

**Post-Deployment**

* Select **Go to resource** to open the VM Overview page
* VM Overview displays:

  * Configuration details
  * **Public IP address**
* SSH access is available because SSH public key authentication was enabled

**Key Facts to Remember**

* **Azure portal** provides a guided, browser-based VM creation experience
* A **resource group is mandatory** for VM creation
* SSH (port 22) must be explicitly allowed for Linux VM access
* Azure validates VM settings before deployment
* A **private SSH key** must be downloaded when generated during VM creation
* VM deployment status is available via the **Notifications** pane

---
