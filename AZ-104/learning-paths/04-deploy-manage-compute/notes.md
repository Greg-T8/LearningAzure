# Learning Path 3: Deploy and Manage Compute Resources

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/paths/az-104-manage-compute-resources/)

* [Compile a checklist for creating an Azure Virtual Machine](#compile-a-checklist-for-creating-an-azure-virtual-machine)
* [Exercise - Create a VM using the Azure portal](#exercise---create-a-vm-using-the-azure-portal)
* [Describe the options available to create and manage an Azure Virtual Machine](#describe-the-options-available-to-create-and-manage-an-azure-virtual-machine)
* [Manage the availability of your Azure VMs](#manage-the-availability-of-your-azure-vms)
* [Back up your virtual machines](#back-up-your-virtual-machines)
* [Plan for maintenance and downtime](#plan-for-maintenance-and-downtime)
* [Create availability sets](#create-availability-sets)

---

<!-- omit in toc -->
## 📋 Modules

| # | Module | Status | Completed |
|---|--------|--------|-------|
| 1 | [Introduction to Azure virtual machines](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-virtual-machines/) | ✅ | 1/23/26 |
| 2 | [Configure virtual machine availability](https://learn.microsoft.com/en-us/training/modules/configure-virtual-machine-availability/) | 🕒 | |
| 3 | [Configure Azure App Service plans](https://learn.microsoft.com/en-us/training/modules/configure-app-service-plans/) | 🕒 | |
| 4 | [Configure Azure App Service](https://learn.microsoft.com/en-us/training/modules/configure-azure-app-services/) | 🕒 | |
| 5 | [Configure Azure Container Instances](https://learn.microsoft.com/en-us/training/modules/configure-azure-container-instances/) | 🕒 | |

**Legend:** 🕒 Not Started | 🚧 In Progress | ✅ Complete

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

## Describe the options available to create and manage an Azure Virtual Machine

[Module Reference](https://learn.microsoft.com/training/modules/intro-to-azure-virtual-machines/)

**Overview**

* The **Azure portal** is the easiest way to create VMs when starting out.
* The portal is not efficient for creating or managing **many VMs at scale**.
* Azure provides multiple **automation, scripting, and programmatic options** to create and manage VMs.

**Ways to Create and Manage Azure Virtual Machines**

* **Azure Resource Manager (ARM) templates**
* **Azure CLI**
* **Azure PowerShell**
* **Terraform**
* **Azure REST API**
* **Azure Client SDKs**
* **Azure VM extensions**
* **Azure Automation services**
* **Auto-shutdown**

---

**Azure Resource Manager (ARM) Templates**

* JSON files that **define resources declaratively**
* Used to create **exact copies of VMs** and infrastructure
* Templates can be exported from an existing VM:

  * VM menu → **Automation** → **Export template**
* Templates are:

  * Easy to edit
  * Reusable
  * Parameterized (VM name, network name, storage account, etc.)
* Redeploying a modified template:

  * Updates existing resources to match the template
* Enables consistent environments (test, staging, production)

<img src='.img/2026-01-23-03-27-40.png' width=500>

---

**Azure CLI**

* Cross-platform command-line tool (Windows, Linux, macOS, Cloud Shell)
* Used for **scripting and automation**
* Can be integrated with other languages (Python, Ruby)

**Command example – create a VM**

```bash
az vm create \
    --resource-group TestResourceGroup \
    --name test-wp1-eus-vm \
    --image Ubuntu2204 \
    --admin-username azureuser \
    --generate-ssh-keys
```

---

**Azure PowerShell**

* Best for:

  * One-off interactive tasks
  * Repeated automation
* Cross-platform
* Uses Azure-specific **cmdlets**

**Command example – create a VM**

```powershell
New-AzVm `
    -ResourceGroupName "TestResourceGroup" `
    -Name "test-wp1-eus-vm" `
    -Location "East US" `
    -Image Debian11 `
    -VirtualNetworkName "test-wp1-eus-network" `
    -SubnetName "default" `
    -SecurityGroupName "test-wp1-eus-nsg" `
    -PublicIpAddressName "test-wp1-eus-pubip" `
    -GenerateSshKey `
    -SshKeyName myPSKey `
    -OpenPorts 22
```

---

**Terraform**

* Infrastructure as Code (IaC) tool with an Azure provider
* Uses **HCL (HashiCorp Configuration Language)**
* Workflow:

  * Define infrastructure
  * Generate execution plan
  * Preview changes
  * Apply plan to deploy
* Supports repeatable, predictable deployments

---

**Programmatic Options (APIs)**

* Used for **complex scenarios** or integration into applications

**Azure REST API**

* Direct interaction using:

  * HTTP methods: **GET, PUT, POST, DELETE, PATCH**
* Azure Compute APIs provide VM management capabilities

**Azure Client SDKs**

* Higher-level abstraction over REST API
* Available for:

  * .NET (C#)
  * Java
  * Node.js
  * Python
  * PHP
  * Ruby
  * Go
* Simplifies VM creation and management in code

---

**Azure VM Extensions**

* Small applications that run **after VM deployment**
* Used to:

  * Install software
  * Apply configurations
  * Automate tasks
* Executed and monitored automatically

---

**Azure Automation Services**

* Used to reduce manual effort and operational errors

* Includes:

* **Process Automation**

  * Responds automatically to events or errors

* **Configuration Management**

  * Tracks OS and software updates
  * Supports integration with Microsoft Endpoint Configuration Manager

* **Update Management**

  * Assesses update status
  * Schedules patching
  * Reviews deployment results
  * Enabled per VM or via Automation account

---

**Auto-shutdown**

* Automatically shuts down VMs on a schedule
* Helps **reduce costs**
* Supports:

  * Daily or weekly schedules
  * Time zone configuration
* Configured from the VM blade in the portal under **Operations**

---

**Key Facts to Remember**

* **ARM templates** enable repeatable, parameterized VM deployments
* **Azure CLI and PowerShell** are primary scripting tools for VM management
* **Terraform** provides declarative, previewable infrastructure deployment
* **REST API and SDKs** are used for advanced, application-driven scenarios
* **VM extensions** configure VMs after deployment
* **Azure Automation** handles process, configuration, and update management
* **Auto-shutdown** reduces VM costs by enforcing scheduled shutdowns

---

## Manage the availability of your Azure VMs

[Module Reference](https://learn.microsoft.com/training/modules/manage-availability-azure-vms/)

**Availability**

* **Availability** is the **percentage of time a service is available for use**
* Customers often expect **100% availability**, especially for customer-facing services
* Azure provides built-in capabilities to help manage **availability, security, and monitoring**
* VM administration includes planning for **business continuity and disaster recovery (BCDR)**

**Why Availability Matters in Azure**

* Azure VMs run on **physical servers** in Azure datacenters
* If a **physical host fails**, all VMs on that host fail
* Azure automatically moves affected VMs to a **healthy host**, but:

  * Self-healing migrations can take **several minutes**
  * Applications may be **unavailable during migration**
* **Planned maintenance events** (software updates, hardware upgrades) may:

  * Occur without VM impact
  * Require **VM reboots** in some cases

**Availability Zones**

* An **Availability Zone** is a **physically separate zone** within an Azure region
* Supported regions have **three Availability Zones**
* Each zone has:

  * **Independent power**
  * **Independent networking**
  * **Independent cooling**
* Using **replicated VMs across zones**:

  * Protects against **datacenter-level failures**
  * Ensures apps and data remain available if one zone fails

**Virtual Machine Scale Sets**

* **VM Scale Sets** let you create and manage **load-balanced groups of VMs**
* VM instance count can:

  * **Automatically scale up or down**
  * Respond to **demand or schedules**
* Benefits:

  * **High availability**
  * Centralized **management, configuration, and updates**
* **No additional cost** for scale sets

  * You pay only for **VM instances**
* Deployment options:

  * **Multiple availability zones**
  * **Single availability zone**
  * **Regional**
* Availability zone options depend on the **orchestration mode**

**Load Balancer**

* **Azure Load Balancer** distributes traffic across multiple VMs
* Combining Load Balancer with:

  * **Availability Zones**
  * **Availability Sets**
  * Provides **maximum application resiliency**
* **Standard tier VMs** include Azure Load Balancer
* Not all VM tiers include Load Balancer support

**Azure Storage Redundancy**

* Azure Storage stores **multiple copies of data by default**
* Protects against:

  * Hardware failures
  * Network or power outages
  * Natural disasters
* Redundancy helps meet **availability and durability targets**
* Factors when choosing redundancy:

  * Replication method in the **primary region**
  * Whether data is replicated to a **secondary geographic region**
  * Whether **read access** is required in the secondary region during outages

**Failover Across Locations (Azure Site Recovery)**

* **Azure Site Recovery** replicates workloads from:

  * A **primary site**
  * To a **secondary location**
* If the primary site fails:

  * You can **fail over** to the secondary site
  * Users maintain **uninterrupted access**
* After recovery:

  * You can **fail back** to the primary site

**Business Advantages of Site Recovery**

* Eliminates the need to maintain a **secondary physical datacenter**
* Enables **non-disruptive failover testing** for recovery drills
* Supports **recovery plans** that can include:

  * Custom PowerShell scripts
  * Azure Automation runbooks
  * Manual intervention steps
* Works with:

  * Azure resources
  * Hyper-V
  * VMware
  * Physical on-premises servers
* Plays a central role in **BCDR strategy**
* Enables additional scenarios:

  * Azure migration
  * Temporary capacity bursts
  * Development and testing environments

**Key Facts to Remember**

* Availability is measured as a **percentage of uptime**
* Azure automatically heals VM failures, but **downtime can still occur**
* **Three Availability Zones** exist per supported Azure region
* Scale sets provide **automatic scaling and high availability**
* Azure Storage always maintains **multiple data copies**
* Azure Site Recovery handles **replication, failover, and recovery** across locations

---

## Back up your virtual machines

[Module Reference](https://learn.microsoft.com/training/modules/intro-to-azure-virtual-machines/backup-your-virtual-machines)

**Overview**

* Data backup and recovery is a required part of infrastructure planning.
* Backup supports recovery from accidental data loss, software bugs, or audit requirements.
* **Azure Backup** is a backup-as-a-service solution for physical and virtual machines.
* Protects workloads **on-premises and in the cloud**.

<img src='.img/2026-01-23-03-34-44.png' width=500>

**Supported Backup Scenarios**

* **Files and folders** on Windows OS machines

  * Physical or virtual
  * On-premises or cloud
* **Application-aware snapshots** using **Volume Shadow Copy Service (VSS)**
* Microsoft server workloads:

  * **Microsoft SQL Server**
  * **Microsoft SharePoint**
  * **Microsoft Exchange**
* **Azure Virtual Machines**

  * Windows
  * Linux
* **Client machines**

  * Windows
  * Linux
  * Windows 10

**Advantages of Azure Backup**

* **Automatic storage management**

  * Storage is automatically allocated and managed.
  * Pay-as-you-use pricing model.
* **Unlimited scaling**

  * Uses Azure scalability for high availability.
* **Multiple storage options**

  * **Locally redundant storage (LRS)**: copies stored in the same region.
  * **Geo-redundant storage (GRS)**: data replicated to a secondary region.
* **Unlimited data transfer**

  * No inbound or outbound data transfer limits.
  * No charge for transferred data.
* **Data encryption**

  * Secure transmission and storage of backup data.
* **Application-consistent backups**

  * Recovery points contain all required data for restore.
* **Long-term retention**

  * No limit on how long backup data can be retained.

**Azure Backup Components**

* **Azure Backup agent**
* **System Center Data Protection Manager (DPM)**
* **Azure Backup Server**
* **Azure Backup VM extension**

**Recovery Services Vault**

* Backup data is stored in a **Recovery Services vault**.
* Vaults use **Azure Storage blobs** for efficient, low-cost long-term storage.
* After creating a vault:

  * Select machines to back up.
  * Define a **backup policy**:

    * Snapshot schedule
    * Retention duration

**Key Facts to Remember**

* Azure Backup supports **both on-premises and cloud** workloads.
* Backup storage uses **Azure Storage blobs**.
* **Unlimited scaling and data transfer** are built-in.
* **Application-consistent backups** are supported.
* **No retention time limit** for stored backups.

---

## Plan for maintenance and downtime

[Module Reference](https://learn.microsoft.com/training/modules/configure-virtual-machine-availability/plan-for-maintenance-and-downtime)

**Maintenance Planning Overview**

* Azure administrators must plan for **planned** and **unplanned** failures.
* An availability plan for Azure virtual machines should account for:

  * **Unplanned hardware maintenance**
  * **Unexpected downtime**
  * **Planned maintenance**

**Unplanned Hardware Maintenance**

* Occurs when Azure predicts an impending failure of hardware or platform components.
* Azure issues an **unplanned hardware maintenance event**.
* Azure uses **Live Migration** to move virtual machines to healthy hardware.
* Live Migration characteristics:

  * Preserves the virtual machine state.
  * Causes only a **short pause**.
  * Performance **may be reduced before or after** the event.

**Unexpected Downtime**

* Occurs when hardware or physical infrastructure fails unexpectedly.
* Examples include:

  * Local network failures
  * Local disk failures
  * Rack-level failures
* Azure automatically **heals** the virtual machine by migrating it to healthy hardware in the **same datacenter**.
* During healing:

  * Virtual machines experience **downtime (reboot)**.
  * There may be **loss of the temporary drive** in some cases.

**Planned Maintenance**

* Periodic updates performed by Microsoft.
* Purpose of planned maintenance:

  * Improve **reliability**
  * Improve **performance**
  * Improve **security** of the Azure platform infrastructure.
* Planned maintenance affects the **underlying host and hardware**, not the guest OS.

**Virtual Machine Update Responsibility**

* Microsoft **does not automatically update**:

  * Virtual machine operating systems
  * Software running inside virtual machines
* Customers have **full control and responsibility** for OS and application updates.
* Azure **does** periodically patch:

  * Underlying host software
  * Physical hardware

**Key Facts to Remember**

* **Live Migration** minimizes downtime during predicted hardware failures.
* **Unexpected downtime** can cause VM reboots and temporary disk loss.
* **Planned maintenance** targets Azure infrastructure, not guest operating systems.
* VM OS and application patching is **customer-managed**, not Microsoft-managed.

---

## Create availability sets

[Module Reference](https://learn.microsoft.com/training/modules/configure-virtual-machine-availability/create-availability-sets)

**Overview**

* An **availability set** is a logical grouping used to ensure related virtual machines are deployed together.
* Helps prevent a **single point of failure** from impacting all virtual machines.
* Ensures virtual machines are **not upgraded at the same time** during host OS upgrades in the datacenter.

**Characteristics of Availability Sets**

* All virtual machines should perform **identical functionalities**.
* All virtual machines should have the **same software installed**.
* Azure distributes virtual machines across:

  * Multiple **physical servers**
  * **Compute racks**
  * **Storage units**
  * **Network switches**
* If hardware or Azure software failures occur, **only a subset** of virtual machines is affected.
* Applications remain available during partial failures.
* A virtual machine and an availability set can be **created at the same time**.
* A virtual machine can be added to an availability set **only at creation time**.

  * To change the availability set, the virtual machine must be **deleted and recreated**.
* Availability sets can be created using:

  * Azure portal
  * Azure Resource Manager (ARM) templates
  * Scripting
  * API tools
* Azure provides **Service Level Agreements (SLAs)** for virtual machines in availability sets.

**Limitations**

* Availability sets **do not protect** against:

  * Operating system failures
  * Application-specific failures
* Additional **disaster recovery and backup solutions** are required for application-level protection.

**Design Considerations**

* **Redundancy**

  * Place multiple virtual machines in an availability set to achieve redundancy.
* **Separation of application tiers**

  * Each application tier should be placed in a **separate availability set**.
* **Load balancing**

  * Use Azure Load Balancer to distribute traffic across virtual machines in the availability set.
* **Managed disks**

  * Availability sets support **Azure managed disks** for block-level storage.

**Key Facts to Remember**

* Virtual machines can only join an availability set **at creation time**.
* Availability sets improve **infrastructure-level availability**, not application-level resilience.
* Separate availability sets should be used for **different application tiers**.
* Load balancing is required to achieve **high availability** across virtual machines.

---
