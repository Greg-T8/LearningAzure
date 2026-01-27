# Disks

## Disks Intro

**Timestamp**: 05:31:25 – 05:32:56

**Key Concepts**  
- Azure Managed Disks are virtual block-level storage volumes used by Azure VMs.  
- Managed disks abstract away the underlying hardware, simplifying disk management.  
- High availability and durability are ensured by Azure through data replication.  
- Managed disks integrate with Azure features like availability sets, availability zones, backup, and RBAC.  
- Encryption options for disks include server-side encryption and Azure Disk Encryption.

**Definitions**  
- **Azure Managed Disks (Azure Disks)**: Block-level storage volumes managed by Azure, used as virtual hard drives for Azure VMs.  
- **Server-Side Encryption (SSE)**: Encryption at rest enabled by default for managed disk snapshots and images to meet security compliance.  
- **Azure Disk Encryption (ADE)**: Encryption solution that encrypts OS and data disks of IaaS virtual machines.  

**Key Facts**  
- Managed disks offer 99.999% availability.  
- Azure creates 3 replicas of managed disk data for durability.  
- You can create up to 50 VM disks per subscription per region.  
- Scale sets can have up to 1,000 virtual machines using marketplace images.  
- Managed disks support integration with availability sets and availability zones.  
- Azure Backup supports time-based backups and retention policies for managed disks.  
- RBAC can assign specific permissions on managed disks to users.  
- VHDs can be directly imported into Azure disks.  
- Azure Private Link can be used to keep traffic between disks and VMs within Microsoft’s network.  
- Temporary disks are not encrypted by SSE unless encryption at the host is enabled.  
- Encryption keys can be platform-managed (by Azure) or customer-managed.

**Examples**  
- None mentioned explicitly.

**Key Takeaways 🎯**  
- Remember that Azure Managed Disks provide highly available, durable, and managed block storage for VMs without hardware management.  
- Know the difference between server-side encryption (default, at rest) and Azure Disk Encryption (encrypts OS/data disks).  
- Be aware of the limits: 50 disks per subscription per region, and 1,000 VMs in a scale set.  
- Understand integration points: availability sets/zones, backup, RBAC, and private links for secure traffic.  
- Encryption keys management options (platform vs customer) are important for compliance and security.

---

## Encryption

**Timestamp**: 05:32:56 – 05:34:01  

**Key Concepts**  
- Two types of disk encryption in Azure: Server-Side Encryption (SSE) and Azure Disk Encryption (ADE)  
- SSE provides encryption at rest and is enabled by default for managed disk snapshots and images  
- ADE encrypts OS and data disks for IaaS virtual machines  
- Encryption keys can be platform-managed or customer-managed  

**Definitions**  
- **Server-Side Encryption (SSE)**: Encryption at rest for managed disk snapshots and images, enabled by default, safeguarding data to meet security compliance. Temporary disks are not encrypted by SSE unless encryption at the host is enabled.  
- **Azure Disk Encryption (ADE)**: Encryption solution for OS and data disks on Azure IaaS VMs; uses BitLocker for Windows and DMcrypt for Linux.  
- **Platform-Managed Keys**: Encryption keys managed by Azure.  
- **Customer-Managed Keys**: Encryption keys managed by the customer.  

**Key Facts**  
- SSE is enabled by default for all managed disk snapshots and images.  
- Temporary disks are not encrypted by SSE unless encryption at the host is enabled.  
- ADE supports encryption of OS and data disks on Azure IaaS virtual machines.  
- Windows VMs use BitLocker for disk encryption; Linux VMs use DMcrypt.  

**Examples**  
- None specifically mentioned within this time range.  

**Key Takeaways 🎯**  
- Remember the distinction between SSE (default encryption at rest) and ADE (encryption of OS/data disks on VMs).  
- Know that temporary disks are not encrypted by SSE by default.  
- Understand the difference between platform-managed and customer-managed keys for encryption.  
- ADE uses BitLocker for Windows and DMcrypt for Linux virtual machines.

---

## Disk Roles

**Timestamp**: 05:34:01 – 05:35:42

**Key Concepts**  
- Azure virtual machines use three types of disk roles: Data disk, OS disk, and Temporary disk.  
- Each disk role serves a specific purpose related to storage and VM operation.  
- These disks can be viewed in Windows Disk Management when connected to a VM.  

**Definitions**  
- **Data Disk**: A managed disk attached to a VM for storing application and user data. Registered as an SCSI drive and labeled with a drive letter.  
- **OS Disk**: The operating system disk attached to every VM containing the boot volume and pre-installed OS selected during VM creation.  
- **Temporary Disk**: A non-managed disk providing short-term storage for temporary data like page or swap files. Data may be lost during maintenance or redeployment but persists through standard reboots.  

**Key Facts**  
- Data disks:  
  - Maximum capacity of 32 GB (note: this may be a transcript error or outdated; typically data disks can be larger, but only what was stated is included here).  
  - Number and type of data disks depend on the VM size.  
- OS disk:  
  - Maximum capacity of 4 GB (as per transcript).  
  - Contains the boot volume and OS.  
- Temporary disk:  
  - Not a managed disk.  
  - Used for short-term storage such as page or swap files.  
  - Data can be lost during maintenance or redeployment but persists after normal reboots.  
  - Typically mounted as `/dev/sdb` on Linux.  
  - Assigned to the D: drive on Windows.  
- Encryption: These disks are not encrypted with Storage Encryption (SE) unless host-level encryption is enabled.  

**Examples**  
- Viewing disk roles by spinning up a Windows 10 Pro server VM and checking Disk Management to see OS disk, temporary disk, and data disk.  
- Temporary disk mount points: `/dev/sdb` on Linux and D: drive on Windows.  

**Key Takeaways 🎯**  
- Remember the three disk roles and their purposes: OS disk (boot and OS), data disk (persistent application data), and temporary disk (ephemeral storage).  
- Temporary disk data is not guaranteed to persist through maintenance or redeployment—do not store critical data here.  
- Data disks are managed and attached as SCSI drives with configurable drive letters.  
- OS disk contains the boot volume and is essential for VM operation.  
- Encryption is not enabled by default on these disks unless host-level encryption is configured—important for security considerations.  
- Practical exam tip: Knowing the typical mount points and drive letters for temporary disks on Linux and Windows can help in troubleshooting or configuration questions.

---

## Managed Disk Snapshots Managed Custom Image

**Timestamp**: 05:35:42 – 05:37:07

**Key Concepts**  
- Managed disk snapshots and managed custom images are related but serve different purposes.  
- Snapshots are read-only, crash-consistent, point-in-time copies of a single managed disk.  
- Managed custom images capture all managed disks attached to a VM (OS and data disks) as a single image.  
- Snapshots exist independently of the source disk and can be used to create new managed disks.  
- Snapshots are billed based on the used size of the disk, not the allocated size.  
- Managed custom images are necessary when coordination of multiple disks is required (e.g., disk striping).  
- Snapshots do not support coordination between multiple disks.  

**Definitions**  
- **Managed Disk Snapshot**: A read-only, crash-consistent full copy of a single managed disk stored as a standard disk, used for point-in-time recovery.  
- **Managed Custom Image**: An image that contains all managed disks (OS and data disks) associated with a VM, used to capture the entire VM disk configuration.  

**Key Facts**  
- Snapshots are billed only for the used space (e.g., if a 24 GB disk uses 10 GB, billing is for 10 GB).  
- Snapshots are suitable for copying individual disks (e.g., a single data disk).  
- Managed custom images are required when multiple disks need to be captured together for scenarios like striping.  
- Snapshots do not support multi-disk coordination.  

**Examples**  
- Use snapshots to copy a single data disk.  
- Use managed custom images when you need to capture all disks of a VM together.  

**Key Takeaways 🎯**  
- Remember that snapshots are disk-level, point-in-time copies and are independent of the source disk.  
- Snapshots are cost-efficient as billing is based on used space, not total disk size.  
- Use managed custom images when you need to capture the entire VM disk setup, including OS and multiple data disks.  
- Snapshots cannot coordinate multiple disks, so they are not suitable for multi-disk scenarios like striping.  
- Understand when to choose snapshots vs. managed custom images based on your backup or deployment needs.  

---

## Disk Types

**Timestamp**: 05:37:07 – 05:40:35

**Key Concepts**  
- Azure managed disks come in four tiers, each with different performance and cost characteristics.  
- Disk tiers affect throughput, IOPS, latency, and VM compatibility.  
- Disk bursting allows temporary performance boosts for IOPS and throughput without permanently upgrading disks.  

**Definitions**  
- **Ultra Disk**: High throughput, high IOPS, and consistently low latency disk storage for Azure VMs. Suitable for data-intensive workloads (e.g., SAP HANA, top-tier databases, transaction-heavy workloads). Only usable as data disks and supported on specific VM series. Performance can be dynamically changed without VM restart.  
- **Premium SSD**: High-performance, low-latency disks designed for mission-critical workloads requiring guaranteed IOPS and throughput. Compatible only with premium storage-supported VM series. Provides low single-digit millisecond latency.  
- **Standard SSD**: Cost-effective storage optimized for workloads needing consistent performance but lower IOPS than Premium SSD. Suitable for web servers, low IOPS app servers, lightly used enterprise apps, and dev/test workloads. Provides single-digit millisecond latency with better availability and reliability than HDD.  
- **Standard HDD**: Lowest cost tier, reliable but with variable latency, IOPS, and throughput. Suitable for latency-insensitive workloads. Available for all VMs and regions.  

**Key Facts**  
- Ultra Disk supports dynamic performance scaling without VM restart but only as data disks.  
- Premium SSD guarantees IOPS and throughput; standard tiers do not guarantee IOPS.  
- Typical max IOPS values to remember:  
  - Premium SSD starts at ~20,000 IOPS  
  - Ultra Disk can go up to 160,000 IOPS  
- Maximum disk size across tiers is roughly 32,767 GB.  
- Maximum throughput examples:  
  - Standard HDD: lower throughput, variable performance  
  - Premium SSD: up to 900 MB/s  
  - Ultra Disk: up to 2,000 MB/s  
- Standard HDD designed for write latency under 10 ms and read latency under 20 ms for most I/O operations.  
- Bursting allows temporary increase in disk IOPS and throughput to handle unexpected traffic without upgrading disk tier. Bursting on disks and VMs are independent features.  

**Examples**  
- Ultra Disk recommended for SAP HANA, top-tier databases, and transaction-heavy workloads.  
- Premium SSD recommended for mission-critical applications requiring guaranteed performance.  
- Standard SSD suitable for web servers, low IOPS app servers, dev/test environments.  
- Standard HDD used by small startups or for non-critical, latency-insensitive workloads.  

**Key Takeaways 🎯**  
- Remember the four disk tiers: Ultra Disk, Premium SSD, Standard SSD, Standard HDD, each with distinct performance and cost profiles.  
- Premium SSD starts at ~20,000 IOPS — a key number to recall for exams.  
- Ultra Disk offers the highest performance but limited VM compatibility and only as data disks.  
- Standard HDD is the lowest cost but with variable and higher latency, suitable for less critical workloads.  
- Use bursting to handle temporary spikes in disk performance without upgrading permanently.  
- Always check VM compatibility before selecting Ultra Disk or Premium SSD tiers.  
- Choose disk tier based on workload criticality, performance needs, and cost constraints.

---

## Bursting

**Timestamp**: 05:40:35 – 05:41:48

**Key Concepts**  
- Bursting is a performance feature for both virtual machines (VMs) and disk storage.  
- It temporarily boosts performance metrics such as IOPS (Input/Output Operations Per Second) and throughput (MB/s) for disks, and CPU utilization for VMs.  
- Bursting helps handle unexpected spikes in disk or VM workload without needing to permanently upgrade resources.  
- Bursting for disks and VMs operate independently but can be combined depending on use case.  

**Definitions**  
- **Bursting (Disks)**: Temporary increase in disk IOPS and throughput to handle sudden increases in disk traffic.  
- **Bursting (VMs)**: Temporary boost in CPU performance and related resources for virtual machines.  

**Key Facts**  
- Burstable VMs require specific VM series that support bursting: VSV2, DS3, and ESV3 series.  
- Bursting is enabled by default on VMs that support it.  
- For premium SSD disks, bursting is available and enabled by default on disk sizes P20 and smaller, across all regions.  

**Examples**  
- None explicitly mentioned beyond the VM series and disk size specifications.  

**Key Takeaways 🎯**  
- Understand that bursting is a cost-effective way to handle workload spikes without permanent upgrades.  
- Know which VM series support bursting (VSV2, DS3, ESV3).  
- Remember bursting is enabled by default on supported VMs and disks (premium SSDs P20 and smaller).  
- Bursting on disks and VMs are independent features; you can have one without the other.  
- Useful for exam scenarios involving performance optimization and cost management in Azure environments.

---

## Attaching Partitioning and Mounting a Disk

**Timestamp**: 05:41:48 – 06:01:36

**Key Concepts**  
- Attaching additional disks to Azure VMs after creation  
- Partitioning disks using Linux `parted` command  
- Creating a Linux file system on the partition with `mkfs` (XFS)  
- Informing the OS of partition table changes with `partprobe`  
- Mounting the partition to a directory using `mount`  
- Creating mount points with `mkdir`  
- Persisting disk mounts across reboots by editing `/etc/fstab` with UUIDs  
- Using `blkid` to find disk UUIDs for `/etc/fstab` entries  
- Checking mounted disks and usage with `df -h` and `grep`  
- Creating snapshots of managed disks in Azure for backup  
- Attaching and partitioning disks on Windows VMs using PowerShell commands  
- Formatting disks in Windows via Disk Management GUI or PowerShell  
- Differences in disk attachment and formatting between Linux and Windows VMs  

**Definitions**  
- **Managed Disk**: Azure-managed block-level storage volumes used by VMs, providing high durability and availability.  
- **Partitioning**: Dividing a disk into sections that can be formatted and used separately.  
- **Mounting**: Attaching a file system to a directory so it can be accessed by the OS.  
- **UUID (Universally Unique Identifier)**: A unique identifier for a disk partition used in `/etc/fstab` to ensure consistent mounting.  
- **`parted`**: A Linux command-line tool used for disk partitioning.  
- **`mkfs`**: Command to create a file system on a partition (e.g., `mkfs.xfs`).  
- **`partprobe`**: Command to inform the OS kernel of partition table changes.  
- **`/etc/fstab`**: File that defines how disk partitions and other file systems are mounted at boot.  
- **Snapshot**: A point-in-time backup of an Azure managed disk, can be full or incremental.  

**Key Facts**  
- Disk names in Linux follow the pattern `/dev/sdX` where `X` is a letter (a, b, c, d...) representing the disk order. Partitions add a number suffix (e.g., `/dev/sdc1`).  
- Use `sudo parted /dev/sdc --script mklabel gpt` to create a GPT partition table on the disk.  
- Use `sudo mkfs.xfs /dev/sdc1` to format the partition with the XFS file system.  
- Use `sudo partprobe` to notify the OS of partition changes.  
- Mount point directories can be created anywhere, e.g., `/DAX`.  
- Use `sudo mount /dev/sdc1 /DAX` to mount the partition.  
- To make mounts persistent, add an entry in `/etc/fstab` using the disk’s UUID, mount point, file system type, and options like `defaults,nofail 1 2`.  
- Use `sudo blkid` to find UUIDs of partitions.  
- Snapshots can be created from the Azure portal, choosing full or incremental backup types.  
- Windows disk initialization and partitioning can be done via PowerShell using `Get-Disk`, `Initialize-Disk`, `New-Partition`, and `Format-Volume`.  
- Windows disks can also be formatted via Disk Management GUI with quick format option.  

**Examples**  
- Creating and attaching a second disk (standard SSD) to an Ubuntu VM named DAX.  
- Partitioning the disk `/dev/sdc` using `parted` and formatting it with XFS.  
- Mounting the partition to `/DAX` and verifying with `df -h | grep sd`.  
- Editing `/etc/fstab` to add the UUID entry for automatic mounting on reboot.  
- Creating a snapshot named "my disk backup" of the attached disk in Azure portal.  
- Attaching a disk to a Windows Server VM, initializing and formatting it using PowerShell commands and Disk Management GUI.  

**Key Takeaways 🎯**  
- Know the Linux commands for partitioning (`parted`), formatting (`mkfs`), and mounting (`mount`, `mkdir`).  
- Understand the importance of updating `/etc/fstab` with UUIDs to persist mounts after reboot.  
- Be familiar with how to find disk UUIDs using `blkid`.  
- Remember that disk names in Linux follow `/dev/sdX` convention.  
- Snapshots provide a way to back up managed disks and can be full or incremental.  
- Windows disk management differs; PowerShell commands and GUI tools are used for partitioning and formatting.  
- Practice the process of attaching, partitioning, mounting, and backing up disks in both Linux and Windows Azure VMs for exam readiness.  
- Don’t memorize exact commands but understand the workflow and purpose of each step.  
- Using `&&` in Linux command lines ensures sequential execution only if the previous command succeeds, which is preferable to `;`.  

---

These notes cover the practical steps and concepts needed for exam questions related to attaching, partitioning, mounting, and backing up Azure VM disks.

---

## Disks CheatSheet

**Timestamp**: 06:01:36 – 06:06:20

**Key Concepts**  
- Azure Managed Disks are block-level storage volumes managed by Azure, used within Azure VMs.  
- Managed Disks provide high availability with 99.999% uptime by maintaining 3 replicas of data.  
- Integration with Availability Sets and Availability Zones for resilience.  
- Role-Based Access Control (RBAC) can assign specific permissions to managed disks.  
- Azure Backup supports time-based backups and retention policies for managed disks.  
- Two types of encryption for managed disks: Server-Side Encryption (SSE) by default and optional encryption at the host.  
- Azure Disk Encryption uses BitLocker for Windows and DMcrypt for Linux to encrypt OS and data disks.  
- Three main disk roles: OS disk, Data disk, and Temporary disk.  
- Temporary disks provide short-term storage, are not managed disks, and data may be lost during maintenance or VM redeployment.  
- Managed disk snapshots are read-only, crash-consistent full copies used for point-in-time recovery and billed based on used size.  
- Managed custom images can capture all managed disks (OS + data) of a VM for reuse.  
- Azure offers four disk performance tiers: Ultra, Premium SSD, Standard SSD, and Standard HDD, each optimized for different workload needs.

**Definitions**  
- **Azure Managed Disks**: Block-level storage volumes managed by Azure, used as VM disks with built-in replication for durability.  
- **Data Disk**: Managed disk attached to a VM to store application or user data; size and number depend on VM size.  
- **OS Disk**: The managed disk containing the operating system and boot volume of a VM; max capacity mentioned as 4 GB (likely a transcript error, typically larger).  
- **Temporary Disk**: Non-managed disk providing ephemeral storage for page or swap files; data may be lost on maintenance or redeployment.  
- **Managed Disk Snapshot**: Read-only, crash-consistent full copy of a managed disk used for backup or creating new disks.  
- **Managed Custom Image**: Image capturing all managed disks (OS + data) of a VM for creating new VMs with the same configuration.  
- **Server-Side Encryption (SSE)**: Default encryption for managed disks using platform-managed or customer-managed keys.  
- **Azure Disk Encryption**: Encryption of OS and data disks using BitLocker (Windows) or DMcrypt (Linux).  

**Key Facts**  
- Azure Managed Disks provide 99.999% availability with 3 replicas of data.  
- Up to 50,000 managed disks per subscription per region.  
- Temporary disks are typically mounted as `/dev/sdb` on Linux and `D:` drive on Windows.  
- Temporary disks are not encrypted by default with SSE unless encryption at the host is enabled.  
- Snapshots are billed based on the actual used size, not the provisioned size (e.g., 64 GB disk with 10 GB used billed for 10 GB).  
- Four disk tiers:  
  - **Ultra Disk**: High throughput, high IOPS, low latency for demanding workloads.  
  - **Premium SSD**: High performance and low latency for IO-intensive workloads.  
  - **Standard SSD**: Cost-effective with consistent performance at lower IOPS.  
  - **Standard HDD**: Low-cost, reliable for latency-insensitive workloads.  

**Examples**  
- Temporary disk usage: storing page or swap files; data loss possible during maintenance.  
- Snapshot billing example: 64 GB disk with only 10 GB used is billed for 10 GB snapshot size.  
- Encryption example: Windows VMs use BitLocker; Linux VMs use DMcrypt for disk encryption.  

**Key Takeaways 🎯**  
- Know the three disk types and their roles: OS disk (boot volume), data disk (application data), temporary disk (ephemeral storage).  
- Understand the difference between snapshots (single disk) and managed custom images (multiple disks).  
- Remember that temporary disks are not backed up or encrypted by default and data can be lost on maintenance.  
- Be familiar with the four disk tiers and their use cases to select the right disk type for workload needs.  
- Snapshots are cost-efficient as they are billed on used space, not provisioned size.  
- Azure Disk Encryption differs by OS: BitLocker for Windows, DMcrypt for Linux.  
- RBAC can be applied specifically to managed disks for fine-grained access control.  
- Managed disks integrate with availability sets and zones to ensure high availability and durability.

---
