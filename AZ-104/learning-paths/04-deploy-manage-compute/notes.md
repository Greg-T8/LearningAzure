# Learning Path 3: Deploy and Manage Compute Resources

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/paths/az-104-manage-compute-resources/)

* [Compile a checklist for creating an Azure Virtual Machine](#compile-a-checklist-for-creating-an-azure-virtual-machine)
* [Exercise - Create a VM using the Azure portal](#exercise---create-a-vm-using-the-azure-portal)
* [Describe the options available to create and manage an Azure Virtual Machine](#describe-the-options-available-to-create-and-manage-an-azure-virtual-machine)
* [Manage the availability of your Azure VMs](#manage-the-availability-of-your-azure-vms)
* [Back up your virtual machines](#back-up-your-virtual-machines)
* [Plan for maintenance and downtime](#plan-for-maintenance-and-downtime)
* [Create availability sets](#create-availability-sets)
* [Review update domains and fault domains](#review-update-domains-and-fault-domains)
* [Review availability zones](#review-availability-zones)
* [Compare vertical and horizontal scaling](#compare-vertical-and-horizontal-scaling)
* [Implement Azure Virtual Machine Scale Sets](#implement-azure-virtual-machine-scale-sets)
* [Create Virtual Machine Scale Sets](#create-virtual-machine-scale-sets)
* [Implement autoscale](#implement-autoscale)
* [Configure autoscale](#configure-autoscale)
* [Implement Azure App Service plans](#implement-azure-app-service-plans)
* [Determine Azure App Service plan pricing](#determine-azure-app-service-plan-pricing)
* [Scale up and scale out Azure App Service](#scale-up-and-scale-out-azure-app-service)
* [Configure Azure App Service autoscale](#configure-azure-app-service-autoscale)
* [Implement Azure App Service](#implement-azure-app-service)

---

<!-- omit in toc -->
## 📋 Modules

| # | Module | Status | Completed |
|---|--------|--------|-------|
| 1 | [Introduction to Azure virtual machines](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-virtual-machines/) | ✅ | 1/23/26 |
| 2 | [Configure virtual machine availability](https://learn.microsoft.com/en-us/training/modules/configure-virtual-machine-availability/) | ✅ | 1/23/26 |
| 3 | [Configure Azure App Service plans](https://learn.microsoft.com/en-us/training/modules/configure-app-service-plans/) | ✅ | 1/24/26 |
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

## Review update domains and fault domains

[Module Reference](https://learn.microsoft.com/training/modules/availability-virtual-machines/)

**Azure Virtual Machine Availability Sets**

* Use **update domains** and **fault domains** to provide high availability and fault tolerance
* Each virtual machine in an availability set is assigned to:

  * **One update domain**
  * **One fault domain**

**Update Domains**

* An **update domain** is a group of nodes upgraded together during service updates
* Enables **incremental (rolling) upgrades** across a deployment
* Characteristics:

  * Contains virtual machines and associated physical hardware
  * VMs in the same update domain can be **updated and rebooted at the same time**
  * During **planned maintenance**, only **one update domain** is rebooted at a time
  * **Default**: **5 update domains** (not user-configurable)
  * **Maximum configurable**: **Up to 20 update domains**

**Fault Domains**

* A **fault domain** represents a **physical unit of failure**
* Typically maps to a **single server rack**
* Characteristics:

  * VMs in the same fault domain share common hardware components

    * Power
    * Networking switches
  * Protects against:

    * Hardware failures
    * Network outages
    * Power interruptions
    * Software updates
  * Uses **two fault domains** to distribute VMs and reduce single points of failure

**Fault Domain Distribution Scenario**

* Two fault domains with two virtual machines each
* Virtual machines are spread across **different availability sets**

  * **Web availability set**:

    * One VM in fault domain 1
    * One VM in fault domain 2
  * **SQL availability set**:

    * One VM in fault domain 1
    * One VM in fault domain 2
* Ensures availability even if a single fault domain fails

<img src='.img/2026-01-23-03-42-59.png' width=500>

**Key Facts to Remember**

* **Each VM** in an availability set is placed in **one update domain and one fault domain**
* **Update domains** control **planned maintenance and upgrades**
* **Fault domains** protect against **physical infrastructure failures**
* **Default update domains**: **5**
* **Maximum update domains**: **20**
* **Minimum fault domains used**: **2**

---

## Review availability zones

[Module Reference](https://learn.microsoft.com/training/modules/configure-virtual-machine-availability/review-availability-zones)

**Availability Zones Overview**

* Availability zones are a **high-availability offering** that protect applications and data from **datacenter failures**.
* Applications achieve high availability by:

  * Colocating **compute, storage, networking, and data** resources within a zone
  * **Replicating resources across other zones**
* Distributing virtual machines across zones results in:

  * **Three fault domains**
  * **Three update domains**
* Azure ensures that virtual machines in different zones are **not updated at the same time**.

**Characteristics of Availability Zones**

* Availability zones are **unique physical locations** within an Azure region.
* Each zone consists of **one or more datacenters** with:

  * Independent **power**
  * Independent **cooling**
  * Independent **networking**
* Enabled regions have a **minimum of three separate zones**.
* Physical separation protects applications and data from **datacenter-level failures**.
* **Zone-redundant services** replicate data and applications across zones to avoid **single points of failure**.

**Availability Zone Service Categories**

* **Zonal services**

  * Resources are **pinned to a specific zone**
  * Examples:

    * Azure Virtual Machines
    * Azure managed disks
    * Standard IP addresses

* **Zone-redundant services**

  * Azure **automatically replicates** resources across all zones
  * Examples:

    * Zone-redundant Azure Storage
    * Azure SQL Database

**Architecture Consideration**

* For comprehensive business continuity, combine:

  * **Availability zones**
  * **Azure regional pairs**

**Key Facts to Remember**

* **Minimum zones per enabled region**: 3
* **Zonal services** are tied to a specific zone
* **Zone-redundant services** replicate automatically across zones
* Availability zones provide protection against **datacenter failures**

---

## Compare vertical and horizontal scaling

[Module Reference](https://learn.microsoft.com/training/modules/configure-virtual-machine-availability/compare-vertical-horizontal-scaling)

**Scalability Overview**

* **Scalability** allows a virtual machine to handle increased requests without degrading response time or throughput.
* Scaling adjusts capacity in proportion to available hardware resources.
* Two primary scaling approaches are **vertical scaling** and **horizontal scaling**.

**Vertical Scaling (Scale Up / Scale Down)**

* Involves **increasing or decreasing the size of a single virtual machine**.
* Makes a virtual machine more powerful (**scale up**) or less powerful (**scale down**).
* Useful when workloads fluctuate but do not require additional VM instances.

*Common scenarios:*

* Reduce VM size during periods of low utilization (for example, weekends) to **lower costs**.
* Increase VM size to support higher demand **without adding new virtual machines**.

**Horizontal Scaling (Scale Out / Scale In)**

* Involves **increasing or decreasing the number of virtual machine instances**.
* Adds instances to **scale out** or removes instances to **scale in**.
* Designed to support changing workloads by distributing demand across multiple VMs.

**Considerations for Vertical vs. Horizontal Scaling**

* **Limitations**

  * Vertical scaling is limited by available hardware sizes and regional availability.
  * Vertical scaling usually requires the VM to **stop and restart**, causing temporary service disruption.
  * Horizontal scaling generally has **fewer limitations**.

* **Flexibility**

  * Horizontal scaling is more flexible in cloud environments.
  * Can support **potentially thousands of virtual machines** to meet workload demands.

* **Reprovisioning**

  * Reprovisioning replaces an existing VM with a new one.
  * Availability planning should account for reprovisioning-related interruptions.
  * Any required data must be identified and **migrated** if reprovisioning occurs.

**Key Facts to Remember**

* **Vertical scaling** changes VM size; **horizontal scaling** changes VM count.
* Vertical scaling often requires downtime due to restart.
* Horizontal scaling offers greater flexibility and scale.
* Robust availability planning must consider **reprovisioning and data persistence**.

---

## Implement Azure Virtual Machine Scale Sets

[Module Reference](https://learn.microsoft.com/en-us/training/modules/configure-virtual-machine-availability/7-implement-scale-sets)

**Overview**

* **Azure Virtual Machine Scale Sets** are an Azure Compute resource used to deploy and manage a set of **identical virtual machines**.
* Configuring all virtual machines the same way enables **true autoscaling**.
* Scale sets **automatically increase** VM instances as demand rises and **decrease** instances as demand falls.
* Virtual machines **do not need to be pre-provisioned**, simplifying large-scale deployments.
* Suitable for **large-scale services**, **big compute**, **big data**, and **containerized workloads**.
* Scaling actions can be **manual**, **automated**, or a **combination** of both.

**Availability and Traffic Management**

* All virtual machine instances are created from the **same base operating system image and configuration**.
* Supports **Azure Load Balancer** for **layer-4 traffic distribution**.
* Supports **Azure Application Gateway** for **layer-7 traffic distribution** and **TLS/SSL termination**.
* Applications continue to be accessible if one VM instance fails, improving **availability**.

**Autoscaling Behavior**

* Automatically adjusts the number of virtual machine instances based on **customer demand**.
* Scaling responds to usage patterns that change throughout the **day or week**.

**Limits and Capacity**

* Supports **up to 1,000 virtual machine instances**.
* If using **custom virtual machine images**, the limit is **600 virtual machine instances**.

**Key Facts to Remember**

* **Identical configuration** across all VM instances enables simplified management.
* **Autoscaling** increases and decreases VM count automatically based on demand.
* **Azure Load Balancer** = layer 4; **Azure Application Gateway** = layer 7 with TLS/SSL.
* **Maximum instances**: 1,000 (600 with custom images).

---

## Create Virtual Machine Scale Sets

[Module Reference](https://learn.microsoft.com/training/modules/configure-virtual-machine-availability/create-virtual-machine-scale-sets)

**Overview**

* Azure Virtual Machine Scale Sets let you deploy and manage a group of virtual machines as a single resource.
* You specify the **number of VMs**, **VM size**, and preferences such as **Azure Spot instances**, **managed disks**, and **allocation policies**.
* Configuration is performed through the **Azure portal**.

<img src='.img/2026-01-23-03-50-09.png' width=500>

**Orchestration Mode**

* **Flexible**

  * You manually create and add virtual machines.
  * VMs can have **any configuration** within the scale set.
* **Uniform**

  * You define a **single VM model**.
  * Azure automatically creates **identical VM instances** based on that model.

**Image**

* Select the **base operating system** or **application image** for the virtual machines.

**VM Architecture**

* **x64**

  * Provides the **highest software compatibility**.
* **Arm64**

  * Provides **up to 50% better price-performance** compared to similar x64 VMs.

**Size**

* Choose a VM size that matches workload requirements.
* VM size determines:

  * **CPU**
  * **Memory**
  * **Storage capacity**
* Azure charges **per hour** based on:

  * VM size
  * Operating system

**Advanced Settings – Spreading Algorithm**

* Determines how VMs are distributed across **fault domains**.
* **Max spreading**

  * VMs are spread across **as many fault domains as possible** in each zone.
  * Scale set **successfully deploys** even if fewer than five fault domains exist.
  * **Recommended by Microsoft**.
* **Fixed spreading**

  * VMs are spread across **exactly five fault domains**.
  * Deployment **fails** if fewer than five fault domains are available.

**Key Facts to Remember**

* **Uniform orchestration** creates identical VMs from a single model.
* **Flexible orchestration** allows mixed VM configurations.
* **Arm64 VMs** can deliver up to **50% better price-performance**.
* **Max spreading** is recommended to avoid deployment failures.
* VM pricing is **hourly** and depends on **size and OS**.

---

## Implement autoscale

[Module Reference](https://learn.microsoft.com/training/modules/configure-virtual-machine-availability/implement-autoscale)

**Overview**

* **Autoscaling** automatically increases or decreases the number of virtual machine instances in an **Azure Virtual Machine Scale Sets** implementation.
* Autoscaling dynamically adjusts capacity to meet changing workload demands.
* Helps maintain acceptable application performance while optimizing cost.

<img src='.img/2026-01-23-03-51-30.png' width=500>

**Benefits of Autoscaling**

* Minimizes unnecessary virtual machine instances when demand is low.
* Automatically adds instances as demand grows to maintain performance.
* Reduces manual monitoring and operational overhead.

**Things to Consider When Using Autoscaling**

* **Automatic adjusted capacity**

  * Autoscale rules define acceptable performance thresholds.
  * When thresholds are met, autoscale rules adjust the number of VM instances automatically.

* **Scale out**

  * Used when application demand increases consistently.
  * Autoscale rules add virtual machine instances to handle sustained load increases.

* **Scale in**

  * Used when application demand decreases consistently (for example, evenings or weekends).
  * Autoscale rules remove virtual machine instances.
  * Reduces operational costs by running only the required number of instances.

* **Scheduled events**

  * Autoscaling can be configured to increase or decrease capacity at fixed, scheduled times.

* **Management overhead**

  * Autoscaling with Virtual Machine Scale Sets reduces the need for manual performance monitoring and optimization.

**Key Facts to Remember**

* Autoscaling applies to **Azure Virtual Machine Scale Sets**.
* Scaling actions are based on **defined rules and thresholds**.
* Supports both **scale out** (increase instances) and **scale in** (decrease instances).
* Can be triggered by **metrics** or **scheduled events**.
* Improves cost efficiency and application performance.

---

## Configure autoscale

[Module Reference](https://learn.microsoft.com/training/modules/configure-virtual-machine-availability/)

**Overview**

* When creating an **Azure Virtual Machine Scale Sets** implementation, you can enable **manual scaling** or **autoscaling**
* For optimal performance, define **minimum**, **maximum**, and **default** instance counts
* Scaling mode is selected during configuration in the Azure portal

<img src='.img/2026-01-23-03-53-07.png' width=500>

**Scaling Modes**

* **Manually update the capacity**

  * Maintains a **fixed instance count**
  * Instance count range: **0–1000**
  * Configure a **scale-in policy** to determine deletion order

    * Example: balance across zones, then delete the VM with the **highest instance ID**

* **Autoscaling**

  * Automatically adjusts capacity
  * Can scale:

    * On a **schedule**
    * Based on **metrics**
  * You must specify the **maximum number of instances** allowed

**Autoscaling Configuration**

* Autoscaling operates based on a **scaling condition**

<img src='.img/2026-01-23-03-54-24.png' width=500>

* **Default instance count**

  * Initial number of VMs deployed
  * Range: **0–1000**

* **Instance limit**

  * **Minimum** instance count for scale-in
  * **Maximum** instance count for scale-out

* **Scale out rule**

  * Triggered by **CPU usage percentage threshold**
  * Defines the **number of instances to add**

* **Scale in rule**

  * Triggered by **CPU usage percentage threshold**
  * Defines the **number of instances to remove**

* **Query duration**

  * Look-back period used by the autoscale engine
  * Allows metric values to **stabilize** before scaling decisions

* **Schedule**

  * Define **start and end dates**
  * Can repeat on **specific days**

**Key Facts to Remember**

* **Instance range**: 0–1000
* **Manual scaling** = fixed capacity
* **Autoscaling** supports metric-based and scheduled scaling
* **CPU percentage thresholds** control scale-in and scale-out
* **Query duration** stabilizes metrics before action

---

## Implement Azure App Service plans

[Module Reference](https://learn.microsoft.com/training/modules/configure-azure-app-service-plans/)

**What an App Service plan is**

* An **Azure App Service plan** defines the **compute resources** used by applications running in Azure App Service.
* Compute resources are analogous to a **server farm** in traditional web hosting.
* **One or more applications** can run on the **same App Service plan**.
* All apps in the plan share the **same compute resources**.

**Behavior of App Service plans**

* When an App Service plan is created in a **region**, Azure provisions compute resources **in that region**.
* Any application added to the plan runs on the plan’s defined compute resources.
* New applications can be added **as long as sufficient capacity remains**.

**App Service plan settings**

Each App Service plan defines:

* **Operating system**: Linux or Windows
* **Region**: The geographic location (for example, West US, Central India, North Europe)
* **Pricing tier**

  * Determines available App Service features
  * Determines cost
  * Available tiers depend on the selected operating system
* **Number of VM instances**

  * Determined by the plan
* **Size of VM instances**

  * Defined by **CPU**, **memory**, and **remote storage**

**Cost and resource considerations**

* **Cost savings**

  * You pay for the compute resources allocated to the plan
  * Multiple applications in one plan can reduce costs
* **Multiple applications in one plan**

  * Simplifies configuration and maintenance
  * Applications share the same VM instances
  * Requires careful resource and capacity management
* **Plan capacity**

  * Evaluate resource requirements before adding new applications
  * Ensure sufficient remaining capacity

**Important limitation**

* **Overloading an App Service plan can cause downtime** for both new and existing applications.

**Application isolation scenarios**

Create a **new App Service plan** when:

* The application is **resource-intensive**
* The application must **scale independently**
* The application requires resources in a **different geographic region**

**Key Facts to Remember**

* App Service plans define **shared compute resources** for one or more applications
* All apps in a plan share the **same VM instances**
* Pricing tier affects **features, scale, and cost**
* Overloading a plan risks **application downtime**
* Use separate plans for **isolation, scaling, or regional needs**

---

## Determine Azure App Service plan pricing

[Module Reference](https://learn.microsoft.com/training/modules/configure-azure-app-service-plans/)

**Overview**

* The **pricing tier** of an Azure App Service plan determines:

  * Available App Service **features**
  * **Cost** of the plan
* Example pricing tiers:

  * **Free**
  * **Shared**
  * **Basic**
  * **Standard**
  * **Premium**
  * **PremiumV2**
  * **PremiumV3**
  * **Isolated**
  * **IsolatedV2**

**How Apps Run and Scale in App Service Plans**

* An **App Service plan** is the **scale unit** for App Service applications
* All apps in the same plan:

  * Run on the **same VM instances**
  * **Scale together**
* If a plan has **five VM instances**, all apps run on all five instances
* Autoscale settings apply to **all apps** in the plan

**Pricing Tier Categories**

* **Shared compute**

  * Includes **Free** and **Shared**
  * Apps run on **shared Azure VMs** with other apps (including other customers)
  * **CPU quotas per app**
  * **No scale-out**
  * Intended for **development and testing only**

* **Dedicated compute**

  * Includes **Basic**, **Standard**, **Premium**, **PremiumV2**, **PremiumV3**
  * Apps run on **dedicated Azure VMs**
  * Compute resources are shared **only within the same App Service plan**
  * Higher tiers allow **more VM instances for scale-out**

* **Isolated**

  * Includes **Isolated** and **IsolatedV2**
  * Apps run on **dedicated VMs** in **dedicated virtual networks**
  * Provides **network isolation** and **compute isolation**
  * Offers the **maximum scale-out capability**

**Sample Plan Feature Comparison**

* **Free (F1)**

  * Usage: Development, Testing
  * Staging slots: N/A
  * Autoscale: N/A
  * Scale instances: N/A
  * Daily backups: N/A

* **Basic (B1)**

  * Usage: Development, Testing
  * Staging slots: N/A
  * Autoscale: Manual
  * Scale instances: **3**
  * Daily backups: N/A

* **Standard (S1)**

  * Usage: Production workloads
  * Staging slots: **5**
  * Autoscale: Rules
  * Scale instances: **10**
  * Daily backups: **10**

* **Premium (P1V3)**

  * Usage: Enhanced scale and performance
  * Staging slots: **20**
  * Autoscale: Rules, Elastic
  * Scale instances: **30**
  * Daily backups: **50**

**Free and Shared Plans**

* Run on **shared Azure virtual machines**
* Intended for **development and testing only**
* **No SLA**
* **Metered per application**

**Basic Plan**

* Designed for **low traffic** applications
* Does **not** include advanced autoscale or traffic management
* Pricing based on **VM size and instance count**
* Includes **built-in network load balancing**
* Linux runtime supports **Web App for Containers**

**Standard Plan**

* Designed for **production workloads**
* Pricing based on **VM size and instance count**
* Includes:

  * **Built-in load balancing**
  * **Autoscale** based on rules
* Linux runtime supports **Web App for Containers**

**Premium Plan**

* Designed for **enhanced performance** production applications
* Premium v2 features:

  * **Dv2-series VMs**
  * Faster processors
  * **SSD storage**
  * **Double memory-to-core ratio** vs Standard
* Supports **higher scale-out** than Standard
* Original Premium tier remains available for existing customers

**Isolated Plan**

* Designed for **mission-critical workloads**
* Runs in a **private, dedicated environment**
* Uses **App Service Environment**
* Features:

  * **Network isolation**
  * **Dv2-series VMs**
  * SSD storage
  * Double memory-to-core ratio vs Standard
* Can scale to **100 instances** (more available upon request)

**Selecting an App Service Plan**

* Selection criteria:

  * **Hardware requirements**

    * CPU
    * Memory
    * Number of instances
  * **Feature requirements**

    * Backups
    * Staging slots
    * Zone redundancy
* Azure portal steps:

  * Search for **App Service plans**
  * Create a new App Service plan
  * Select **Explore pricing plans**

**Key Facts to Remember**

* **App Service plan = scaling boundary** for all apps in the plan
* **Shared compute tiers** cannot scale out
* **Dedicated compute tiers** allow increasing VM instances
* **Isolated tiers** provide both **network and compute isolation**
* **Autoscale applies to all apps** in the same plan

---

## Scale up and scale out Azure App Service

[Module Reference]([URL](https://learn.microsoft.com/en-us/training/modules/configure-app-service-plans/4-scale-up-scale-out))

**Azure App Service Scaling Methods**

* Azure App Service plans and applications support **two scaling methods**: **scale up** and **scale out**
* Scaling can be performed **manually** or **automatically (autoscale)**

**Scale Up (Vertical Scaling)**

* Increases **CPU, memory, and disk space**
* Performed by **changing the pricing tier** of the App Service plan
* Unlocks additional features, including:

  * **Dedicated virtual machines**
  * **Custom domains and certificates**
  * **Deployment (staging) slots**
  * **Autoscaling**
* App Service plans can be **scaled up or down at any time**

**Scale Out (Horizontal Scaling)**

* Increases the **number of virtual machine instances** running the application
* Maximum instance count depends on the **App Service plan pricing tier**
* **Isolated tier (App Service Environment)** supports up to **100 instances**
* Instance count can be configured:

  * **Manually**
  * **Automatically using autoscale**

**Autoscale**

* Applies to the **scale-out method**
* Automatically adjusts the **instance count**
* Based on:

  * **Predefined rules**
  * **Schedules**
* Helps maintain performance during high load and reduce costs during low load

**Scaling Considerations**

* **Manual tier adjustment**

  * Start with a **lower pricing tier**
  * Scale up only when additional features are required
  * Scale down when features are no longer needed to **reduce costs**
* **Progressive scaling scenario**

  * Free tier → Shared tier (custom DNS)
  * Shared tier → Basic tier (SSL binding)
  * Basic tier → Standard tier (staging slots)
  * Scale within the same tier for **more cores, memory, or storage**
* **No redeployment required**

  * Scaling does **not require code changes**
  * Scale changes apply in **seconds**
  * All apps in the App Service plan are affected
* **Independent scaling of dependent services**

  * Azure App Service plans **do not manage scaling** for dependent services
  * Services like **Azure SQL Database** or **Azure Storage** must be scaled separately

**Key Facts to Remember**

* **Scale up** = change pricing tier to gain more resources and features
* **Scale out** = increase number of VM instances
* **Autoscale** applies only to scale out
* **Isolated tier** supports up to **100 instances**
* Scaling does **not require redeployment**
* App Service plan scaling affects **all apps in the plan**

---

## Configure Azure App Service autoscale

[Module Reference](https://learn.microsoft.com/training/modules/configure-azure-app-service-plans/)

**Autoscale Overview**

* **Autoscale** adjusts resources automatically to handle application load.
* Supports **scaling out** to handle increased load and **scaling in** to reduce cost during idle periods.
* Uses **rules and conditions** to control scaling behavior.

**Autoscale Configuration Basics**

* Define a **minimum** and **maximum** number of instances.
* The autoscale engine automatically adjusts the number of **virtual machine instances** based on defined rules.
* When rule conditions are met, one or more **autoscale actions** are triggered.

<img src='.img/2026-01-24-04-29-50.png' width=700>

**Autoscale Settings and Profiles**

* An **autoscale setting** determines whether to scale in or scale out.
* Autoscale settings are grouped into **profiles**.
* Each profile contains one or more autoscale rules.

**Autoscale Rules**

* Autoscale rules consist of:

  * A **trigger**
  * A **scale action** (scale in or scale out)
* Triggers can be:

  * **Metric-based**

    * Scale based on measured load.
    * Example metrics:

      * **CPU time**
      * **Average response time**
      * **Requests**
    * Example condition: scale when **CPU usage > 50%**
  * **Time-based (schedule-based)**

    * Scale based on predictable time patterns.
    * Example: trigger an action at **8:00 AM on Saturday** in a specific time zone.

**Notifications**

* The autoscale engine uses **notification settings**.
* Notifications are triggered when autoscale events occur.
* Notifications can:

  * Send emails to **one or more email addresses**
  * Call **one or more webhooks**

**Configuration Considerations**

* **Minimum instance count**

  * Ensures the application remains running even with no load.
* **Maximum instance count**

  * Limits total possible **hourly cost**.
* **Adequate scale margin**

  * Minimum and maximum values must be different.
  * Autoscale operates between these values using rules.
* **Scale rule combinations**

  * Always configure both **scale-out** and **scale-in** rules.
  * Missing scale-out rules can cause performance degradation.
  * Missing scale-in rules can lead to unnecessary costs.
* **Metric statistics**

  * Choose the correct statistic:

    * **Average**
    * **Minimum**
    * **Maximum**
    * **Total**
* **Default instance count**

  * Used when metrics are unavailable.
  * Should be a **safe and stable** value.
* **Notifications**

  * Should always be enabled to monitor application behavior during load changes.

**Key Facts to Remember**

* Autoscale uses **profiles**, **rules**, and **conditions**.
* Rules always include a **trigger** and a **scale action**.
* Triggers can be **metric-based** or **time-based**.
* Always configure **minimum, maximum, and default** instance counts.
* Both **scale-out and scale-in rules** are required for effective autoscale.
* Notifications support **email and webhook** targets.

---

## Implement Azure App Service

[Module Reference](https://learn.microsoft.com/en-us/training/modules/configure-azure-app-services/2-implement)

**Overview**

* **Azure App Service** enables building **websites, mobile backends, and web APIs** for any platform or device.
* Applications **run and scale** in both **Windows** and **Linux-based** environments.
* Provides **Quickstarts** for common programming languages.

**Supported Languages**

* **ASP.NET**
* **Java**
* **Node.js**
* **Python**
* **PHP**

**App Service Benefits**

* **Multiple languages and frameworks**

  * First-class support for **ASP.NET, Java, Node.js, PHP, and Python**
  * Supports **PowerShell** and other scripts or executables as background services

* **DevOps optimization**

  * Continuous integration and deployment with:

    * **Azure DevOps**
    * **GitHub**
    * **BitBucket**
    * **Docker Hub**
    * **Azure Container Registry**
  * Support for **test and staging environments**
  * App management via **Azure PowerShell** or **cross-platform CLI**

* **Global scale with high availability**

  * Scale **up or out**, **manually or automatically**
  * Host apps in **Microsoft global datacenter infrastructure**
  * App Service **SLA provides high availability**

* **Security and compliance**

  * Compliant with **ISO**, **SOC**, and **PCI**
  * Authentication using:

    * **Microsoft Entra ID**
    * Social logins (**Google, Facebook, Twitter, Microsoft**)
  * Supports **IP address restrictions**
  * Supports **managed service identities**

* **Application templates**

  * Templates available from **Azure Marketplace**
  * Examples: **WordPress, Joomla, Drupal**

* **Visual Studio integration**

  * Dedicated tools for **creating, deploying, and debugging** applications

* **API and mobile features**

  * Built-in **CORS** support for RESTful APIs
  * Mobile features include:

    * Authentication
    * Offline data sync
    * Push notifications

**Key Facts to Remember**

* **App Service supports Windows and Linux**
* **Automatic and manual scaling are both supported**
* **Integrated CI/CD with multiple DevOps platforms**
* **Built-in security, compliance, and authentication options**
* **Marketplace templates simplify app deployment**

---
