# Storage Accounts

---

## Intro to Storage Accounts

**Timestamp**: 02:32:04 – 02:33:48

**Key Concepts**  
- Azure Storage Accounts contain all Azure Storage data objects: blobs, files, queues, tables, and disks.  
- Storage Accounts are multi-purpose services with different storage types inside them.  
- Different storage types have distinct features and pricing models.  
- The term "storage type" is used interchangeably with "account kind" in the Azure UI.  
- Common features across storage accounts include supported services, performance tiers, access tiers, replication, and deployment models.  

**Definitions**  
- **Storage Account**: A container in Azure that holds various storage data objects such as blobs, files, queues, tables, and disks.  
- **Account Kind**: The classification of a storage account that determines the type of storage and features available (e.g., General Purpose v1, General Purpose v2, Blob Storage).  
- **Performance Tiers**: Levels indicating the speed of read/write operations, typically Standard or Premium.  
- **Access Tiers**: Frequency-based tiers indicating how often data is accessed (e.g., hot, cool).  
- **Replication**: The number and location of redundant copies of data to ensure durability and availability.  
- **Deployment Models**: The method used to deploy storage accounts, mainly Resource Manager or Classic (only for General Purpose v1).  

**Key Facts**  
- Storage account types include: General Purpose v1, General Purpose v2, Blob Storage, Block Blob Storage, and File Storage.  
- The Azure portal UI uses "account kind" instead of "storage type."  
- Supported services vary by storage account type (e.g., containers, queues, tables).  
- Performance tiers available are Standard and Premium.  
- Deployment model is mostly Resource Manager except for General Purpose v1 which supports Classic.  

**Examples**  
- None explicitly mentioned beyond listing storage account types and their features.  

**Key Takeaways 🎯**  
- Remember that "account kind" in the UI corresponds to "storage type."  
- Know the main storage account types and that each supports different services and pricing.  
- Understand the difference between performance tiers (Standard vs Premium) and access tiers (frequency of access).  
- Replication options affect data durability and availability.  
- Deployment model is almost always Resource Manager except for General Purpose v1 which can use Classic.  
- Focus on these distinctions as they often appear in exam questions about Azure Storage Accounts.

---

## Storage Comparison

**Timestamp**: 02:33:48 – 02:35:49

**Key Concepts**  
- Different storage types have varying features based on version and type.  
- Deployment models mainly use Resource Manager, except for Storage version 1 which supports Classic deployment.  
- Replication options are most extensive in Storage version 2.  
- Access tiers (hot, cool, archive) are only available in General Purpose v2 and Blob storage.  
- Performance tiers include Standard and Premium; Premium is used for file storage and block blob storage, Standard for legacy blob storage.  
- Blob storage has three types with some differences in support and use cases.  
- File storage supports only file types, while General Purpose v2 supports all storage types.  

**Definitions**  
- **Deployment Model**: The method by which storage services are deployed; either Classic or Resource Manager (modern standard).  
- **Replication**: The process of creating redundant copies of data to ensure durability and availability.  
- **Access Tiers**: Levels of data accessibility and cost optimization (e.g., hot, cool, archive) available for certain storage types.  
- **Performance Tiers**: Storage speed and cost options, mainly Standard and Premium.  

**Key Facts**  
- Only Storage version 1 supports the Classic deployment model; all others use Resource Manager.  
- Storage version 2 offers the most replication options.  
- Access tiers are exclusive to General Purpose v2 and Blob storage.  
- File storage and block blob storage typically use Premium performance tier.  
- Legacy Blob storage uses Standard performance tier.  
- General Purpose v2 is the most versatile storage type supporting all features.  

**Examples**  
- File storage is always premium and supports only file types.  
- Blob storage comes in three types, with some supporting page blobs (though details are not emphasized).  

**Key Takeaways 🎯**  
- Focus on General Purpose v2 storage for the broadest feature set and flexibility.  
- Remember that replication options and access tiers are primarily a feature of Storage version 2.  
- Deployment model differences are mostly behind the scenes; practically, Resource Manager is the default.  
- Know that performance tiers affect cost and speed, with Premium used for file and block storage.  
- Understanding which storage types support access tiers can help optimize cost and performance.  

---

## Core Storage Services

**Timestamp**: 02:35:49 – 02:37:43

**Key Concepts**  
- Azure provides five core storage services under storage accounts.  
- Different storage services serve different purposes: object storage, file sharing, messaging, and block storage.  
- Storage accounts are used to launch most storage services except Azure Disks, which are launched separately.  

**Definitions**  
- **Azure Blob Storage**: A massively scalable object store for text and binary data; supports big data analytics via Data Lake Storage Gen2. Files are treated as objects without needing to manage a file system.  
- **Azure Files**: A managed file share service that allows multiple virtual machines to share the same file system and files.  
- **Azure Queues**: A NoSQL store for schema-less structured data, used for messaging between application components (categorized under storage but functions as messaging).  
- **Azure Disk Storage**: Block-level storage volumes specifically for Azure Virtual Machines (VMs). Disks are launched separately from storage accounts.  

**Key Facts**  
- Azure Blob Storage supports big data analytics through Data Lake Storage Gen2.  
- Azure Files enables shared file systems across multiple VMs.  
- Azure Queues provide reliable messaging but are categorized under storage accounts.  
- Azure Disks are block-level storage volumes for VMs and are managed separately from the other four core storage services.  
- Some storage accounts (like general-purpose v2) may be involved in disk backup or storage, but disks themselves are launched independently.  

**Examples**  
- Using Azure Files to share the same file system among multiple virtual machines.  
- Azure Blob Storage for uploading files as objects without managing file systems.  

**Key Takeaways 🎯**  
- Remember the five core storage services: Blob, Files, Queues, (Messaging), and Disks.  
- Blob storage is ideal for scalable object storage and big data analytics.  
- Azure Files is best when multiple VMs need shared access to the same files.  
- Azure Queues, though under storage accounts, function as a messaging service for application components.  
- Azure Disks are block storage volumes for VMs and are managed separately from storage accounts.  
- For exam purposes, know the purpose and basic use case of each core storage service.

---

## Performance Tiers

**Timestamp**: 02:37:43 – 02:39:51

**Key Concepts**  
- Performance tiers apply primarily to Azure Blob storage accounts.  
- Two main performance tiers: **Standard** and **Premium**.  
- Performance is measured in IOPS (Input/Output Operations Per Second).  
- Premium tier uses SSDs (Solid-State Drives) optimized for low latency and higher throughput.  
- Standard tier uses HDDs (Hard Disk Drives) with varied performance depending on access tier.

**Definitions**  
- **IOPS (Input/Output Operations Per Second)**: A measure of how many read/write operations a storage device can perform per second; higher IOPS means faster performance.  
- **Premium Performance Tier**: Storage backed by SSDs, offering higher IOPS, low latency, and higher throughput.  
- **Standard Performance Tier**: Storage backed by HDDs, with performance varying by access tier (hot, cool, archive).

**Key Facts**  
- Premium tier SSDs have no moving parts, enabling faster random read/write operations.  
- Standard tier HDDs have moving parts (an ARM) and perform best with sequential read/write operations.  
- SSDs are suited for interactive workloads, analytics, AI/ML, and data transformation.  
- HDDs are suited for backup, disaster recovery, media content, and bulk data processing.  
- Neither SSD nor HDD is inherently better; choice depends on workload needs and cost considerations.

**Examples**  
- Premium SSDs used for AI/ML workloads and interactive analytics.  
- Standard HDDs used for backup and disaster recovery scenarios.

**Key Takeaways 🎯**  
- Remember the two performance tiers: Standard (HDD) vs. Premium (SSD).  
- Higher IOPS = better performance; premium tier provides this via SSDs.  
- Choose performance tier based on workload type and cost: SSDs for speed-critical tasks, HDDs for cost-effective bulk storage.  
- Understand that HDDs excel at sequential data access, SSDs excel at random access with low latency.  
- Performance tier selection impacts latency, throughput, and cost—know these trade-offs for exam scenarios.

---

## Access Tiers

**Timestamp**: 02:39:51 – 02:43:37

**Key Concepts**  
- Azure Storage offers three access tiers for standard storage: Hot, Cool, and Archive.  
- Access tiers help optimize storage costs based on how frequently data is accessed.  
- Tiering can be applied at the storage account level or at the individual BLOB level.  
- Moving data between tiers can incur different costs and sometimes delays (rehydration).  
- Lifecycle management policies can automate moving data between tiers based on rules.

**Definitions**  
- **Hot Tier**: For data accessed frequently; highest storage cost but lowest access cost. Suitable for active data or data staged for processing.  
- **Cool Tier**: For infrequently accessed data stored for at least 30 days; lower storage cost than Hot but higher access cost. Used for short-term backup, disaster recovery, or older media content.  
- **Archive Tier**: For rarely accessed data stored for at least 180 days; lowest storage cost but highest access cost. Intended for long-term backup, archival, compliance data, or original raw data preservation.  
- **Rehydration**: The process of moving a BLOB out of the Archive tier to a hotter tier, which can take several hours.  
- **BLOB Lifecycle Management**: Rule-based policies to automatically transition BLOBs between tiers or delete them based on age or other criteria.

**Key Facts**  
- Cool tier requires data to be stored for a minimum of 30 days.  
- Archive tier requires data to be stored for a minimum of 180 days.  
- Not all replication types support the Archive tier; configuration may affect tier availability.  
- Changing tiers is instant except when moving out of Archive (rehydration delay).  
- When moving a BLOB to a cooler tier, the operation is billed as a write operation at the destination tier rates.  
- When moving a BLOB to a hotter tier, the operation is billed as a read operation at the source tier rates.  
- Early deletion charges apply if data is moved out of Cool or Archive tiers before the minimum storage duration (30 days for Cool, 180 days for Archive). Charges are prorated.  
- If a BLOB does not have an explicitly assigned tier, it inherits the tier from the storage account’s default access tier.

**Examples**  
- Cool tier use cases: short-term backup, disaster recovery data sets, older media content not frequently viewed but expected to be available immediately, large data sets stored cost-effectively while gathering more data.  
- Archive tier use cases: long-term backup, secondary backup, archival data sets, original raw data preservation, compliance data rarely accessed.

**Key Takeaways 🎯**  
- Remember the minimum storage durations: 30 days for Cool, 180 days for Archive to avoid early deletion charges.  
- Understand cost implications: Hot tier has highest storage cost but lowest access cost; Archive has lowest storage cost but highest access cost.  
- Know that rehydration from Archive can take hours—plan accordingly for data retrieval.  
- Use lifecycle management policies to automate cost optimization by moving data between tiers based on usage patterns.  
- Be aware that some replication settings may disable the Archive tier option.  
- Tier changes are immediate except for Archive to other tiers, which require rehydration.  
- Charges for tier changes depend on the direction of the move (write vs read operations).

---

## Replication Data Redundancy

**Timestamp**: 02:43:37 – 02:45:30

**Key Concepts**  
- Replication is used to create multiple copies of data to protect against outages, hardware failures, network/power issues, and natural disasters.  
- Different replication types offer varying levels of redundancy and cost.  
- Replication types are categorized into three main groups based on redundancy scope and access:  
  1. Primary region redundancy  
  2. Secondary region redundancy  
  3. Secondary region redundancy with read access  

**Definitions**  
- **Replication**: The process of copying data multiple times across different locations or zones to ensure durability and availability.  
- **Local Redundant Storage (LRS)**: Replicates data synchronously three times within a single primary region; most cost-effective.  
- **Zone Redundant Storage (ZRS)**: Replicates data across multiple availability zones within the primary region.  
- **Geo-Redundant Storage (GRS)**: Replicates data to a secondary geographic region for higher redundancy.  
- **Geo-Zone Redundant Storage (GZRS)**: Combines geo-redundancy with zone redundancy.  
- **Read Access Geo-Redundant Storage (RAGRS)**: Provides read access to the secondary region’s replicated data.  
- **Read Access Geo-Zone Redundant Storage (RAGZRS)**: Read access with geo-zone redundancy.

**Key Facts**  
- LRS and ZRS fall under primary region redundancy.  
- GRS and GZRS fall under secondary region redundancy.  
- RAGRS and RAGZRS provide read access to replicated data in the secondary region.  
- LRS is typically used for development accounts due to its cost-effectiveness.  
- Data in primary region redundancy is replicated at least three times within the primary region.  
- LRS uses synchronous replication within the region.

**Examples**  
- Using LRS for development accounts as a cost-effective replication choice.  
- No other specific practical examples mentioned.

**Key Takeaways 🎯**  
- Understand the three categories of replication redundancy and their use cases.  
- Remember the acronyms and what they stand for, focusing on LRS, ZRS, GRS, GZRS, RAGRS, and RAGZRS.  
- Know that higher redundancy levels come with higher costs.  
- LRS replicates data three times synchronously within the primary region and is the most cost-effective option.  
- Secondary region redundancy options provide disaster recovery across geographic regions.  
- Read access redundancy options allow reading from the secondary region replica, useful for read-heavy workloads or failover scenarios.

---

## LRS ZRS

**Timestamp**: 02:45:30 – 02:47:01

**Key Concepts**  
- Primary region redundancy options for Azure Storage replication  
- Differences between LRS (Locally Redundant Storage) and ZRS (Zone-Redundant Storage)  
- Synchronous replication within the primary region  
- Durability levels associated with LRS and ZRS  
- Impact of availability zone failures on data availability  

**Definitions**  
- **LRS (Locally Redundant Storage)**: Replicates data synchronously three times within a single availability zone in the primary region.  
- **ZRS (Zone-Redundant Storage)**: Replicates data synchronously across three different availability zones within the primary region.  

**Key Facts**  
- LRS uses synchronous replication to maintain three copies of data within one availability zone.  
- ZRS uses synchronous replication to maintain three copies of data across three separate availability zones.  
- Durability for LRS is 11 nines (99.999999999%).  
- Durability for ZRS is 12 nines (99.9999999999%), making it more durable than LRS.  
- LRS is the cheapest storage option and suitable for developer accounts or scenarios where replication is not critical.  
- ZRS provides higher availability by protecting against an entire availability zone failure within the primary region.  
- If an availability zone fails, data in LRS is lost; in ZRS, data remains available in other zones.  

**Examples**  
- Choosing LRS for developer accounts where replication durability is less critical.  
- Choosing ZRS when you need higher durability and protection against availability zone outages.  

**Key Takeaways 🎯**  
- Remember that both LRS and ZRS replicate data synchronously within the primary region but differ in the scope of replication (single zone vs multiple zones).  
- ZRS offers better durability and availability than LRS by spanning multiple availability zones.  
- LRS is the most cost-effective option but has lower fault tolerance.  
- Understand the difference in durability levels (11 nines vs 12 nines) as a measure of reliability.  
- For exam scenarios involving availability zone failures, ZRS is the preferred choice over LRS.

---

## GRS GZRS

**Timestamp**: 02:47:01 – 02:49:02

**Key Concepts**  
- Secondary region redundancy protects against regional disasters by replicating data to a paired secondary region.  
- Secondary regions are paired automatically; users cannot choose the pair.  
- Secondary regions are normally on standby and not available for read/write access except during failover.  
- GRS (Geo-Redundant Storage) and GZRS (Geo-Zone-Redundant Storage) combine synchronous replication within the primary region and asynchronous replication to the secondary region.  
- Synchronous replication guarantees data consistency within the primary region.  
- Asynchronous replication to the secondary region means data may not be fully up-to-date or consistent at any given moment.  
- GZRS adds zone-redundancy within the primary region by replicating data asynchronously across three availability zones before geo-replication.  
- Durability for GRS is extremely high (16 nines).  
- Read-access geo-redundant options (RAGRS, RAGZRS) provide synchronous replication to the secondary region to enable consistent read replicas.

**Definitions**  
- **Secondary Region Redundancy**: Replication of data to a geographically paired region to protect against regional outages or disasters.  
- **Paired Region**: A fixed secondary region automatically assigned to a primary region for geo-replication purposes.  
- **Synchronous Replication**: Data is copied in real-time ensuring consistency and durability guarantees.  
- **Asynchronous Replication**: Data is copied with a delay, so the secondary copy may lag behind the primary.  
- **GRS (Geo-Redundant Storage)**: Storage replication strategy that synchronously replicates data within the primary region and asynchronously replicates to a paired secondary region.  
- **GZRS (Geo-Zone-Redundant Storage)**: Similar to GRS but adds asynchronous replication across three availability zones within the primary region before geo-replication.  
- **RAGRS / RAGZRS**: Read-access geo-redundant storage options that provide synchronous replication to the secondary region, enabling read access to the secondary copy.

**Key Facts**  
- Secondary regions are not available for read/write access unless failover occurs (except for RAGRS/RAGZRS).  
- GRS durability is 16 nines (99.99999999999999%).  
- Data in the secondary region is asynchronously copied, so it may not be fully up-to-date.  
- GZRS replicates data asynchronously across 3 availability zones in the primary region before geo-replication.  
- The secondary region in GZRS may not replicate data across multiple AZs (based on the graphic referenced).  
- RAGRS and RAGZRS provide synchronous replication to the secondary region to ensure data consistency for read replicas.

**Examples**  
- None explicitly mentioned beyond conceptual descriptions of replication behavior.

**Key Takeaways 🎯**  
- Understand the difference between synchronous (within primary region) and asynchronous (to secondary region) replication in GRS and GZRS.  
- Remember that secondary regions are paired and cannot be chosen by the user.  
- Know that GRS/GZRS provide geo-redundancy but secondary copies are not readable unless failover occurs.  
- RAGRS/RAGZRS enable read access to the secondary region by using synchronous replication across regions.  
- GZRS adds zone redundancy within the primary region, improving durability before geo-replication.  
- Durability of GRS is extremely high (16 nines), making it suitable for critical data requiring geo-redundancy.

---

## RAGRS_RA GZRS

**Timestamp**: 02:49:02 – 02:49:44

**Key Concepts**  
- Redundancy in the secondary region with read access  
- Read-access geo-redundant storage (RAGRS) and read-access geo-zone-redundant storage (RAGZRS)  
- Synchronous data replication between primary and secondary regions for read replicas  
- Ensuring data consistency (one-to-one sync) between primary and secondary regions for read operations  

**Definitions**  
- **RAGRS / RAGZRS**: Storage options that provide read access to a secondary region with synchronous data replication to maintain data consistency between primary and secondary regions.  

**Key Facts**  
- Data is synchronous in both primary and secondary regions when using RAGRS or RAGZRS  
- The purpose of these options is to enable a read replica in another region with data in sync  
- This differs from asynchronous replication where data may lag or be out of sync  

**Examples**  
- None mentioned explicitly, but the concept described is having a read replica in a secondary region with synchronous data replication  

**Key Takeaways 🎯**  
- Remember that RAGRS and RAGZRS provide synchronous replication to the secondary region to support read replicas  
- Synchronous replication ensures data consistency for read operations across regions  
- This is critical when you want to read from a geographically distant region without risking stale data  
- Understand the difference between asynchronous replication (used in other redundancy options) and synchronous replication in RAGRS/RAGZRS  

---

## Intro to Blob

**Timestamp**: 02:49:44 – 02:50:51

**Key Concepts**  
- Azure Blob Storage is an object store optimized for massive amounts of unstructured data.  
- Unstructured data refers to data without a specific data model or schema, such as text or binary data.  
- Azure Blob Storage hierarchy includes Storage Account → Containers → Blobs.  
- Storage accounts provide a fully qualified domain name (FQDN) for global access.  
- Containers in Blob Storage act like folders to organize blobs.  
- There are three types of blobs: block blobs, append blobs, and (implicitly) page blobs (not mentioned here).  

**Definitions**  
- **Blob Storage**: A service optimized for storing large amounts of unstructured data like text or binary.  
- **Storage Account**: The top-level namespace for Azure storage, providing a unique FQDN for access.  
- **Container**: A logical grouping within a storage account that organizes blobs, similar to folders.  
- **Block Blob**: The primary blob type used to store text and binary data, composed of individually manageable blocks.  
- **Append Blob**: Blob type optimized for append operations, ideal for scenarios like logging where data is added sequentially.  

**Key Facts**  
- Storage accounts have a unique name treated like a domain name to ensure global uniqueness.  
- Block blobs can store up to 4.7 terabytes of data.  
- Append blobs are efficient for appending data, such as virtual machine logs.  

**Examples**  
- Append blobs are used for writing logs from a virtual machine, as they efficiently append data to the end of the file.  

**Key Takeaways 🎯**  
- Remember that Azure Blob Storage is designed for unstructured data and is organized hierarchically: Storage Account → Containers → Blobs.  
- Storage account names must be globally unique because they form part of the URL (FQDN).  
- Block blobs are the most common blob type for storing large text or binary files.  
- Use append blobs specifically when you need to add data sequentially, such as logging scenarios.  
- Understand the difference between containers (folders) and blobs (actual data objects) in Azure Blob Storage.

---

## Blob Types

**Timestamp**: 02:50:51 – 02:51:45

**Key Concepts**  
- Azure Blob Storage organizes data into containers (similar to folders).  
- There are three main types of blobs used to store different kinds of data and optimized for different scenarios.

**Definitions**  
- **Block Blobs**: Store text and binary data as blocks that can be managed individually.  
- **Append Blobs**: Optimized for append operations, ideal for scenarios like logging where data is continuously added to the end.  
- **Page Blobs**: Store random access files, primarily used for virtual hard drives (VHDs) and serve as disks for Azure Virtual Machines.

**Key Facts**  
- Block blobs can store up to 4.7 terabytes of data.  
- Append blobs are efficient for appending data, such as VM logs.  
- Page blobs can store up to 8 terabytes and are used for VHD files.

**Examples**  
- Append blobs are used for writing logs from virtual machines efficiently by appending data to the end of the file.  
- Page blobs are used to store virtual hard drives (VHD files) that serve as disks for Azure VMs.

**Key Takeaways 🎯**  
- Remember the three blob types and their primary use cases:  
  - Block blobs for general text/binary storage.  
  - Append blobs for append-only scenarios like logging.  
  - Page blobs for random access files and VM disks.  
- Know the size limits: 4.7 TB for block blobs, 8 TB for page blobs.  
- Understanding blob types is essential for choosing the right storage solution in Azure.

---

## Blob Moving Data

**Timestamp**: 02:51:45 – 02:52:50

**Key Concepts**  
- Multiple methods exist to move data into Azure Blob Storage beyond just the portal or File Explorer.  
- Command-line tools, libraries, ETL services, virtual file system drivers, and physical data transport options are available.  

**Definitions**  
- **AzCopy**: A command-line tool for Windows and Linux used to efficiently move data to Azure Storage.  
- **Azure Storage Data Movement Library**: A .NET library that uses AzCopy under the hood to facilitate data transfer programmatically.  
- **Azure Data Factory**: An ETL (Extract, Transform, Load) service by Azure designed to move and transform data into Azure.  
- **Blob Fuse**: A virtual file system driver that allows Linux systems to mount Azure Blob Storage as a file system using the FUSE library.  
- **Azure Data Box**: A rugged physical device used to securely transport large amounts of data physically to Azure.  
- **Azure Import Export Service**: A service where customers ship their physical disks to Azure for data import/export operations.  

**Key Facts**  
- AzCopy supports both Windows and Linux platforms.  
- Blob Fuse leverages the Linux FUSE library to enable file system access to Blob Storage.  
- Azure Data Box and Azure Import Export Service are physical data transfer solutions, useful when network transfer is impractical or too slow.  

**Examples**  
- None specifically mentioned in this segment, but AzCopy is highlighted as a practical command-line tool for data movement.  

**Key Takeaways 🎯**  
- Know the variety of tools and services available for moving data into Azure Blob Storage, including command-line, programmatic, ETL, virtual file system, and physical transport options.  
- AzCopy is a fundamental tool to be familiar with for exam purposes.  
- Understand the difference between virtual (AzCopy, Data Factory, Blob Fuse) and physical (Data Box, Import Export Service) data transfer methods.  
- Remember Blob Fuse is Linux-specific and uses the FUSE library to mount Blob Storage as a file system.

---

## Intro to Files

**Timestamp**: 02:52:50 – 02:54:05

**Key Concepts**  
- Azure Files is a fully managed file share service in the cloud.  
- It acts like a centralized file server allowing multiple virtual machines to connect and share data simultaneously.  
- Uses network protocols to facilitate communication: Server Message Block (SMB) and Network File System (NFS).  
- Mounting is the process of connecting the Azure file share to a specific directory or drive letter on a client machine.  

**Definitions**  
- **Azure Files**: A cloud-based fully managed file share service that provides a shared drive accessible by multiple clients at the same time.  
- **Mounting**: The process of making a remote file share accessible locally by assigning it to a folder or drive letter (e.g., Z: drive on Windows).  
- **Server Message Block (SMB)**: A network protocol created by Microsoft used for file sharing, commonly used on Windows systems.  
- **Network File System (NFS)**: A network protocol commonly used on Linux or Unix-based systems for file sharing.  

**Key Facts**  
- Azure Files supports multiple simultaneous connections from virtual machines.  
- On Windows, Azure Files can be mounted to drive letters such as Z:, X:, or Y:.  
- SMB is primarily used on Windows clients; NFS is commonly used on Linux/Unix clients.  

**Examples**  
- Mounting Azure Files as a Z: drive on a Windows server so that accessing Z: uses the Azure file share.  

**Key Takeaways 🎯**  
- Remember Azure Files acts like a shared network drive in the cloud accessible by multiple VMs.  
- Know the two main protocols: SMB (Windows) and NFS (Linux/Unix).  
- Understand the concept of mounting and how it maps a remote file share to a local drive or folder.  
- Azure Files can replace or supplement on-premises file servers and NAS devices, making it important for cloud migrations and hybrid scenarios.

---

## Files Use Cases

**Timestamp**: 02:54:05 – 02:57:31

**Key Concepts**  
- Azure Files can replace or supplement on-premises file servers and NAS devices.  
- Lift and Shift migration strategies: classic lift and hybrid lift.  
- Shared storage simplifies cloud deployments by centralizing configuration files and logs.  
- Azure Files supports containerized applications by providing persistent storage volumes.  
- Azure Files is fully managed, scalable, resilient, and supports standard file protocols out-of-the-box.  
- Automation and scripting support via Azure API and PowerShell.  
- Backup capabilities with incremental shared snapshots and soft delete to prevent accidental data loss.

**Definitions**  
- **Lift and Shift**: Moving workloads to the cloud without re-architecting them.  
- **Classic Lift**: Moving both the application and its data fully to Azure.  
- **Hybrid Lift**: Moving only the application data to Azure Files while the application runs on-premises.  
- **Mounting**: Assigning a drive letter (e.g., Z:) on Windows to access Azure Files as a network share.  
- **Shared Snapshots**: Read-only, incremental backups of file shares that store only changed data.  
- **Soft Delete**: A feature to prevent accidental deletion of file shares and backups by retaining deleted data temporarily.

**Key Facts**  
- Azure Files supports file shares up to 100 terabytes (large file shares feature, disabled by default).  
- Default file share capacity example used: 3 GB (small for demo purposes).  
- VM size chosen for demo: B1LS (cost-effective, approx. $6/month).  
- SMB communicates over TCP port 445, which must be explicitly opened in the VM’s network security group.  
- Soft delete for Azure File Shares is enabled by default for 7 days.  
- Mounting requires creating a mount directory and a credentials file with restricted permissions.  

**Examples**  
- Using Azure Files as a replacement for on-premises NAS devices.  
- Classic lift: moving both app and data to Azure.  
- Hybrid lift: app stays on-premises, data moves to Azure Files.  
- Sharing application settings/configuration files across multiple VMs by mounting the same Azure Files share.  
- Centralizing diagnostic logs from multiple VMs for developer debugging.  
- Sharing development tools quickly by placing them on Azure Files for easy mounting.  
- Persisting container volumes using Azure Files.

**Key Takeaways 🎯**  
- Understand the difference between classic lift and hybrid lift migration strategies.  
- Remember Azure Files can replace on-premises file servers and simplify shared storage needs.  
- Azure Files supports standard SMB/NFS protocols and is fully managed, reducing operational overhead.  
- Backup with incremental snapshots is efficient and supports long retention (up to 10 years).  
- Soft delete is critical to prevent accidental data loss of file shares and backups.  
- Azure Files is ideal for scenarios requiring shared access across multiple VMs or containers.  
- Automation via Azure API and PowerShell enhances management and scalability.

---

## Files Feature

**Timestamp**: 02:57:31 – 03:01:21

**Key Concepts**  
- Azure Files supports backups via shared snapshots that are read-only and incremental.  
- Snapshots store only changed data, optimizing storage space.  
- Soft delete protects against accidental deletion by retaining deleted shares for a retention period before permanent deletion.  
- Advanced Threat Protection (ATP) adds security intelligence to detect anomalous activity on storage accounts.  
- Azure Files offers multiple storage tiers optimized for different workloads and cost/performance needs.  
- Identity options for Azure Files include Azure AD Domain Services (managed or on-premises) and storage account keys.  
- Azure Files can be accessed inside and outside the Azure environment via storage account public endpoints.  
- SMB protocol uses port 445 for mounting Azure file shares.  
- Encryption at rest uses Azure Storage Service Encryption (SSE). Encryption in transit uses SMB 3.0 encryption or HTTPS.  
- Azure File Sync enables caching of Azure file shares on on-premises Windows Servers or Azure VMs, allowing local access with protocols like SMB, NFS, FTP.  

**Definitions**  
- **Shared Snapshots**: Read-only, incremental backups of Azure file shares that capture only changed data since the last snapshot.  
- **Soft Delete**: A feature that retains deleted file shares for a configurable retention period to prevent accidental permanent deletion.  
- **Advanced Threat Protection (ATP)**: Security feature providing alerts on anomalous activities detected in storage accounts.  
- **Storage Tiers**: Different performance and cost options for Azure Files, including Premium (SSD), Transaction Optimized (HDD), Hot, and Cool tiers.  
- **Azure File Sync**: A service that caches Azure file shares on local Windows Servers or VMs, enabling local protocol access and multi-site sync.  

**Key Facts**  
- Up to 200 snapshots per file share are supported.  
- Backups (snapshots) can be retained for up to 10 years.  
- Snapshots are incremental, storing only changed data (e.g., adding 1 MB only stores 1 MB extra).  
- Premium tier uses SSD with single-digit millisecond latency and high IOPS.  
- Transaction Optimized tier uses HDD, suitable for transaction-heavy workloads without premium latency needs.  
- Hot tier is optimized for general-purpose file sharing and Azure File Sync scenarios.  
- Cool tier is HDD-based, cost-effective for online archiving.  
- SMB protocol requires port 445 to be open for mounting file shares.  
- Encryption at rest uses Azure Storage Service Encryption (SSE).  
- Encryption in transit uses SMB 3.0 encryption or HTTPS.  

**Examples**  
- Incremental snapshot example: A 100 GB file share with 1 MB added results in a snapshot storing only that 1 MB change.  
- Azure File Sync acts like a OneDrive for file shares, caching files locally and syncing with the cloud, allowing access via SMB, NFS, or FTP protocols.  

**Key Takeaways 🎯**  
- Understand the incremental nature of Azure Files snapshots and their storage efficiency.  
- Remember soft delete is crucial to prevent accidental data loss in Azure Files.  
- Know the different storage tiers and their appropriate use cases (Premium = SSD/low latency, Transaction Optimized = HDD, Hot = general purpose, Cool = archival).  
- Be aware of identity options for accessing Azure Files, especially Azure AD Domain Services integration.  
- SMB port 445 must be open for mounting Azure file shares—important for networking considerations.  
- Encryption is enabled both at rest and in transit, ensuring data security.  
- Azure File Sync enables hybrid scenarios with local caching and multi-protocol access, useful for on-premises integration.  
- ATP is an additional security layer but less critical for foundational certification levels.

---

## File Sync

**Timestamp**: 03:01:21 – 03:02:21

**Key Concepts**  
- Azure File Sync allows caching of Azure file shares on on-premises Windows Servers or cloud VMs.  
- Enables local access to cloud files using native Windows Server protocols (SMB, NFS, FTP).  
- Supports multiple cache locations globally to keep files synchronized.  
- Files can be referenced locally without needing to store all files physically on the local server.  

**Definitions**  
- **Azure File Sync**: A service that synchronizes Azure file shares with on-premises Windows Servers or cloud VMs, enabling local caching and access to cloud files using standard file protocols.  

**Key Facts**  
- Supports protocols: SMB, NFS, FTP on Windows Server for local access.  
- Multiple caches can be deployed worldwide to keep data in sync.  
- Files are accessed on-demand, reducing local storage requirements.  

**Examples**  
- Described as similar to OneDrive for file shares, where files are kept in sync between cloud and local caches.  

**Key Takeaways 🎯**  
- Remember Azure File Sync is ideal for hybrid environments needing local access to cloud files with familiar protocols.  
- It reduces local storage needs by caching files and accessing others on-demand.  
- Supports multiple cache servers globally for distributed access and synchronization.  
- Think of it as cloud file storage with local caching and syncing capabilities, similar in concept to OneDrive but for file shares.  

---

## Storage Explorer

**Timestamp**: 03:02:21 – 03:02:55

**Key Concepts**  
- Azure Storage Explorer is a standalone application for managing Azure Storage data.  
- It supports multiple operating systems: Windows, Mac OS, and Linux.  
- Provides a graphical interface to access subscriptions, storage accounts, disks, and storage data.  
- Allows operations such as uploading, downloading, opening, cloning, and creating storage items.  
- Simplifies working with Azure Storage by providing easy and convenient access.

**Definitions**  
- **Azure Storage Explorer**: A cross-platform standalone app that enables users to easily manage and interact with Azure Storage resources and data.

**Key Facts**  
- Available on Windows, Mac OS, and Linux.  
- Interface includes navigation for subscriptions, storage accounts, and disks on the left-hand side.  
- Supports file operations like upload and download directly within the app.

**Examples**  
- Running Azure Storage Explorer on a Mac with visible subscriptions and storage accounts on the left panel.  
- Using options to upload files, download files, open, clone, and create storage items.

**Key Takeaways 🎯**  
- Know that Azure Storage Explorer is a GUI tool for managing Azure Storage across platforms.  
- Remember it supports multiple file operations and provides easy access to storage accounts and data.  
- Useful for exam scenarios involving managing Azure Storage resources without using the portal or CLI.  
- Familiarity with its cross-platform availability and basic functionality can help in practical and exam contexts.

---

## AZCopy

**Timestamp**: 03:02:55 – 03:04:42

**Key Concepts**  
- AZCopy is a command-line utility used to copy blobs or files to and from Azure Storage accounts.  
- It supports Windows, Linux, and Mac OS platforms.  
- Proper authorization is required to use AZCopy, based on user roles.  
- Authentication can be done via Azure Active Directory or Shared Access Signature (SAS).  
- The basic usage involves logging in, then using the `azcopy copy` command with source and destination paths.

**Definitions**  
- **AZCopy**: A command-line tool for transferring data to and from Azure Blob Storage or file storage.  
- **Storage Blob Data Reader**: Role needed for downloading blobs.  
- **Storage Blob Data Contributor**: Role needed for uploading blobs.  
- **Storage Blob Data Owner**: Role with full permissions over blobs.  
- **Azure Active Directory (AAD)**: Microsoft's cloud-based identity and access management service used for authentication.  
- **Shared Access Signature (SAS)**: A URI that grants restricted access rights to Azure Storage resources.

**Key Facts**  
- AZCopy executable is available for Windows, Linux, and Mac OS.  
- Required roles for AZCopy operations:  
  - Download: Storage Blob Data Reader  
  - Upload: Storage Blob Data Contributor or Storage Blob Data Owner  
- Authentication via `azcopy login` opens a web browser for AAD sign-in and requires entering a displayed code.  
- Copy command syntax: `azcopy copy [source] [destination]`  
- To download files, reverse the source and destination in the command.

**Examples**  
- Logging in: `azcopy login` → opens browser for Azure AD authentication.  
- Upload example: `azcopy copy <local-file-path> <storage-account-endpoint>/<container>/<path>`  
- Download example: `azcopy copy <storage-account-endpoint>/<container>/<file> <local-path>`

**Key Takeaways 🎯**  
- Ensure you have the correct Azure role assigned before using AZCopy (Reader for downloads, Contributor/Owner for uploads).  
- Use `azcopy login` to authenticate via Azure Active Directory before performing operations.  
- Remember the command structure: `azcopy copy [source] [destination]` and reverse it for downloads.  
- AZCopy is a powerful tool for efficient data transfer to/from Azure Storage and supports all major OS platforms.  
- Be aware of authentication options: Azure AD or SAS tokens depending on your scenario.

---

## Import Export Service

**Timestamp**: 03:04:42 – 03:07:10

**Key Concepts**  
- Azure Import Export Service is used to move large amounts of data to Azure Blob Storage and Azure Files by physically shipping disk drives to Azure data centers.  
- Two options for drives: use your own disk drives or Microsoft-provided Azure Data Box Disks (SSD drives).  
- Data is copied locally to the drives, encrypted, and then shipped to Azure.  
- Preparation of drives is done using the WA Import Export Tool (command line).  
- There are two versions of WA Import Export Tool:  
  - Version 1 for Azure Blob Storage  
  - Version 2 for Azure Files  
- Export jobs are only supported for Azure Blob Storage, not Azure Files.  

**Definitions**  
- **Azure Import Export Service**: A service that enables transferring large data sets to Azure by shipping physical disk drives to Azure data centers.  
- **Azure Data Box Disks**: Microsoft-provided solid state drives used for data import/export, shipped in sets of five.  
- **WA Import Export Tool**: A Windows 64-bit command line tool used to prepare drives for import/export, including copying data, encrypting it with AES-256 BitLocker, and generating journal files.  
- **Journal File**: A file generated by the WA Import Export Tool containing metadata such as drive serial numbers, encryption keys, and storage account details, used to create import jobs.  

**Key Facts**  
- Up to 40 terabytes of data can be shipped per import order. For more than 40 TB, multiple orders are required.  
- Drives connect via USB 3.0 for data copying.  
- Encryption uses AES-256 BitLocker (software encryption).  
- WA Import Export Tool is only compatible with Windows 64-bit OS (no Linux or Mac support).  
- Export jobs allow shipping up to 10 empty drives to Azure per job for data export.  
- Export is supported only for Azure Blob Storage, not Azure Files.  

**Examples**  
- Microsoft sends five Azure Data Box Disks (SSD drives) per order for import/export.  
- Data is copied locally to the drives using USB 3.0, encrypted, and then shipped back to Azure.  

**Key Takeaways 🎯**  
- Remember the two versions of WA Import Export Tool and their target storage types (v1 for Blob, v2 for Files).  
- Know the 40 TB per import order limit and the need for multiple orders if exceeding this.  
- Encryption is mandatory and done with AES-256 BitLocker via the tool.  
- Export jobs are limited to Azure Blob Storage only, with a maximum of 10 drives per export job.  
- WA Import Export Tool only runs on Windows 64-bit — no Linux or Mac support.  
- The journal file is critical for creating import jobs and contains essential metadata.  
- Understand the physical shipping process as a method for large data transfer to Azure when network transfer is impractical.

---

## SAS

**Timestamp**: 03:07:10 – 03:10:09

**Key Concepts**  
- Shared Access Signature (SAS) is a URI that grants restricted, temporary access to Azure storage resources.  
- SAS provides a way to authorize access besides using Active Directory.  
- There are different types of SAS depending on the scope and authentication method.  
- SAS tokens can be created as ad hoc or with stored access policies.  
- SAS URIs include query parameters that define permissions, start and expiry times, resource types, and authentication signatures.

**Definitions**  
- **Shared Access Signature (SAS)**: A URI that grants restricted access rights to Azure storage resources for a limited time and with specific permissions.  
- **Account-level SAS**: Grants access to resources across one or more storage services within a storage account.  
- **Service-level SAS**: Grants access to a single storage service using storage account keys.  
- **User Delegated SAS**: Uses Azure AD credentials to access storage accounts, limited to Blob and container resources; considered best practice by Microsoft.  
- **Ad hoc SAS**: SAS token with start time, expiry time, and permissions embedded directly in the URI.  
- **Service SAS with Stored Access Policy**: SAS token linked to a stored access policy defined on a resource container, allowing management of constraints across multiple SAS tokens.

**Key Facts**  
- SAS types: Account-level, Service-level, User Delegated.  
- User Delegated SAS is limited to Blob and container resources only.  
- Stored access policies apply to Blob, container, table, queue, and file share resources (disks are excluded).  
- SAS URI components include:  
  - `sv`: Storage service version  
  - `st`: Start time  
  - `se`: Expiry time  
  - `sr`: Storage resource type (e.g., B for Blob, Q for Queue)  
  - `sp`: Permissions (e.g., read, write)  
  - `sig`: Signature used for authentication (SHA-256)  
- SAS tokens can be easily generated via the Azure Portal under the storage account’s Shared Access Signature section.

**Examples**  
- Example URI structure discussed:  
  - Storage account URL + container + file name + query string parameters (sv, st, se, sr, sp, sig)  
- Generating SAS token: Open Azure Portal → Storage Account → Shared Access Signature → select options → generate URI → use URI for access.

**Key Takeaways 🎯**  
- Understand the different SAS types and when to use each (account, service, user delegated).  
- User Delegated SAS with Azure AD is the recommended best practice for Blob storage access.  
- Know the difference between ad hoc SAS and SAS with stored access policies.  
- Be familiar with the key query parameters in a SAS URI and what they represent.  
- Remember that SAS tokens provide temporary and scoped access, enhancing security over sharing account keys.  
- Practice generating SAS tokens in the Azure Portal as it is straightforward and exam-relevant.

---

## Use AZCopy to copy files to Storage Accounts

**Timestamp**: 03:10:09 – 03:26:14

**Key Concepts**  
- AZCopy is a command-line tool used to efficiently copy files to and from Azure Storage Accounts.  
- You can use AZCopy via Cloud Shell for a consistent cross-platform experience (Linux, Mac, Windows).  
- Authentication with AZCopy can be done using either:  
  - Azure AD login (`azcopy login`)  
  - Shared Access Signature (SAS) tokens appended to URLs  
- Storage accounts contain containers, which hold blobs (files). Containers can be private or public.  
- Proper role assignments are required to upload/download blobs using AZCopy (e.g., Storage Blob Data Owner or Contributor).  
- SAS tokens provide granular, time-limited access to storage resources without sharing account keys.  

**Definitions**  
- **AZCopy**: A command-line utility designed to copy data to/from Azure Storage accounts quickly and securely.  
- **Shared Access Signature (SAS)**: A URI that grants restricted access rights to Azure Storage resources without exposing account keys.  
- **Container**: A logical grouping within a storage account that holds blobs (files).  
- **Blob**: A file stored in Azure Blob Storage.  
- **Storage Blob Data Owner/Contributor**: Azure roles that grant permissions to manage blobs within storage accounts.  

**Key Facts**  
- AZCopy can be downloaded for multiple platforms: Windows, Linux, Mac.  
- When using Cloud Shell, files can be uploaded to the mounted storage share for use with AZCopy.  
- To extract the AZCopy binary from a tarball in Cloud Shell, use: `tar -xvzf <filename>.tar.gz`  
- The AZCopy executable may require execution permissions (`chmod u+x azcopy`).  
- To authenticate with Azure AD via AZCopy, run `azcopy login` and complete the browser sign-in with a provided code.  
- Blob URLs follow the format:  
  `https://<storage-account-name>.blob.core.windows.net/<container-name>/<blob-name>`  
- Role assignments for blob access must be done via Access Control (IAM) in the Azure portal; changes can take ~5 minutes to propagate.  
- SAS tokens start with a question mark (`?`) and are appended to blob/container URLs to grant access.  
- Common SAS permissions include read, write, add, create, and list.  
- SAS tokens can be generated in the Azure portal under the storage account’s Shared Access Signature settings.  
- Sometimes AZCopy in Cloud Shell may have issues with SAS authentication; using a local AZCopy client (e.g., Windows version) can resolve this.  

**Examples**  
- Created a storage account named **Fajo** with a container named **Kivas Fagio** (private access).  
- Uploaded an image file (`Kivas Fagio.jpg`) to the container using AZCopy with Azure AD login authentication.  
- Generated a SAS token with permissions for Blob storage (read, write, add, create) and attempted to upload using SAS appended to the URL.  
- Encountered a 403 error initially due to missing role assignment; resolved by assigning Storage Blob Data Contributor role to the user.  
- Demonstrated troubleshooting steps when SAS upload failed in Cloud Shell but succeeded using Windows AZCopy client.  

**Key Takeaways 🎯**  
- Always ensure you have the correct role assignments (Storage Blob Data Owner or Contributor) to perform blob operations with AZCopy.  
- Use `azcopy login` for Azure AD authentication or SAS tokens appended to URLs for delegated access.  
- Blob URLs must be correctly formatted: `https://<account>.blob.core.windows.net/<container>/<blob>`  
- SAS tokens must start with a question mark (`?`) when appended to URLs.  
- When using Cloud Shell, upload your files and AZCopy binaries to the mounted storage share before running commands.  
- If AZCopy commands fail in Cloud Shell, try using a local AZCopy client as a fallback.  
- Role assignment changes may take several minutes to take effect—be patient before retrying operations.  
- Practice generating SAS tokens with appropriate permissions and understand their scope and expiry.  
- Remember to clean up resources (delete resource groups) after practice to avoid unnecessary charges.

---

## Create a File Share with Files

**Timestamp**: 03:26:14 – 03:37:22

**Key Concepts**  
- Azure File Share is a sub-service within a Storage Account, not a standalone service.  
- File shares can be created under General Purpose v2 or Premium storage accounts.  
- Premium storage accounts can be dedicated to file storage only (FileStorage account kind).  
- Azure Files supports SMB protocol for mounting shares to virtual machines.  
- Mounting Azure File Shares on Linux requires installing `cifs-utils`.  
- Port 445 (TCP) must be opened on the VM’s network security group for SMB communication.  
- Credentials for mounting are stored securely in a file with restricted permissions.  
- Azure File Shares support soft delete (default 7 days) and can be configured for large file shares (up to 100 TB).  
- File operations on the mounted share reflect immediately on the Azure File Share.  

**Definitions**  
- **Azure File Share**: A managed file share service within Azure Storage Accounts that can be mounted via SMB protocol to VMs.  
- **General Purpose v2 Storage Account**: A multi-purpose storage account that supports blobs, files, queues, and tables.  
- **Premium FileStorage Account**: A storage account dedicated solely to file shares, optimized for premium performance.  
- **SMB (Server Message Block)**: A network protocol used to mount Azure File Shares.  
- **cifs-utils**: A Linux utility package required to mount SMB file shares.  

**Key Facts**  
- Azure Files supports file shares up to 100 terabytes (large file shares feature, disabled by default).  
- Default file share capacity example used: 3 GB (small for demo purposes).  
- VM size chosen for demo: B1LS (cost-effective, approx. $6/month).  
- Linux VM image used: Ubuntu 18.04 LTS, Generation 2.  
- SMB communicates over TCP port 445, which must be explicitly opened in the VM’s network security group.  
- Soft delete for Azure File Shares is enabled by default for 7 days.  
- Mounting requires creating a mount directory and a credentials file with restricted permissions.  

**Examples**  
- Created a resource group and storage account named "KeyVoss".  
- Created a file share named "Kivas" with 3 GB quota.  
- Launched an Ubuntu Linux VM named "Kivas" to mount the file share.  
- Opened port 445 on the VM’s network security group for SMB.  
- Installed `cifs-utils` on the Linux VM (`sudo apt update && sudo apt install cifs-utils`).  
- Created directories `/mnt/kivas` and `/etc/smbcredentials` on the VM.  
- Created a credentials file with Azure Storage account username and key, set permissions to 600.  
- Mounted the Azure File Share using the CIFS protocol with the credentials file.  
- Uploaded an image file ("Kivas Faggio") via the Azure Portal upload button to the file share.  
- Verified file presence and demonstrated file operations (move, delete) reflecting immediately on the mounted share.  

**Key Takeaways 🎯**  
- Always create Azure File Shares inside a Storage Account (General Purpose v2 or Premium FileStorage).  
- Remember to open TCP port 445 on the VM’s NSG to allow SMB traffic.  
- On Linux VMs, install `cifs-utils` to enable mounting SMB shares.  
- Use a credentials file with restricted permissions to securely store storage account keys for mounting.  
- Azure File Shares support soft delete and large file shares (up to 100 TB) but large file shares must be enabled explicitly.  
- File operations on the mounted share are immediately reflected in Azure Files and vice versa.  
- For file sync scenarios, Windows VMs are required (Linux mounting is for direct file share access only).  
- Use cost-effective VM sizes (e.g., B1LS) for demo or lab environments.  
- When copying multi-line commands in Cloud Shell or SSH, paste line-by-line to avoid errors.  

---

## Setup Files Sync

**Timestamp**: 03:37:22 – 03:54:31

**Key Concepts**  
- Azure File Sync extends Azure File Shares by enabling synchronization between on-premises Windows Servers (or Azure VMs) and Azure Files in the cloud.  
- Requires a Windows Server VM to install the Azure File Sync Agent (cannot be done from Linux).  
- Setup involves creating a Storage Account, a File Share, a Storage Sync Service, and launching a Windows Server VM.  
- Registration of the Windows Server VM with the Storage Sync Service is necessary via the Azure File Sync Agent.  
- Sync Groups are created to manage synchronization between cloud endpoints (Azure File Shares) and server endpoints (folders on Windows Server).  
- Cloud tiering can be enabled to optimize local disk space by keeping frequently accessed files locally and tiering others to the cloud.  
- Proper cleanup requires deleting server endpoints, cloud endpoints, sync groups, and then the storage sync service before deleting the resource group.

**Definitions**  
- **Azure File Sync**: A service that centralizes file shares in Azure Files while keeping the flexibility, performance, and compatibility of an on-premises file server. It synchronizes files between Windows Servers and Azure File Shares.  
- **Storage Sync Service**: The Azure resource that orchestrates file synchronization between cloud and server endpoints.  
- **Sync Group**: A grouping of cloud endpoints and server endpoints that are kept in sync.  
- **Cloud Endpoint**: The Azure File Share in the cloud that is part of a sync group.  
- **Server Endpoint**: A folder on a registered Windows Server that syncs with the cloud endpoint.  
- **Cloud Tiering**: A feature that preserves a specified percentage of free space on the server volume by tiering infrequently accessed files to Azure Files.

**Key Facts**  
- Windows Server 2019 (Generation 2) was used for the VM in the example.  
- Minimum VM size requires at least 2 vCPUs (e.g., DSV3 or D2 v2).  
- File Share size example: 5 GB (small size sufficient for demo).  
- Ports to open on VM: at least port 3389 (RDP) plus any others needed.  
- Azure File Sync Agent installation requires PowerShell module AzureRM and disabling IE Enhanced Security Configuration temporarily for easier download.  
- Cloud tiering example: preserve 20% free space on the volume.  
- Deletion order for cleanup: delete server endpoints → delete cloud endpoints → delete sync group → delete storage sync service → delete resource group.

**Examples**  
- Creating a Windows Server VM named "Kivas" with Windows Server 2019 for Azure File Sync.  
- Creating a Storage Account and a 5 GB file share named "Kivas".  
- Installing AzureRM PowerShell module and Azure File Sync Agent on the Windows VM.  
- Registering the VM with the Storage Sync Service using Azure File Sync Agent.  
- Creating a folder `C:\kivas` on the VM, adding a test file `hello.txt`, and sharing it.  
- Creating a Sync Group named "Kivas" and adding cloud and server endpoints to sync the folder.  
- Enabling cloud tiering with 20% free space preservation to avoid sync pending issues.

**Key Takeaways 🎯**  
- Azure File Sync requires a Windows Server environment; Linux-only setups cannot use Azure File Sync.  
- Always ensure VM size meets minimum requirements (2 vCPUs minimum).  
- Remember to open RDP port 3389 to connect to the Windows VM.  
- Install AzureRM PowerShell module before installing Azure File Sync Agent.  
- Disable IE Enhanced Security Configuration temporarily to download the Azure File Sync Agent smoothly.  
- Register the Windows Server VM with the Storage Sync Service via the Azure File Sync Agent to enable syncing.  
- Create Sync Groups to manage synchronization between cloud and server endpoints.  
- Enable cloud tiering to prevent sync endpoints from staying in a pending state and optimize local storage.  
- Proper resource cleanup in Azure requires deleting endpoints before deleting sync groups and services to avoid deletion errors.  
- Be familiar with the Azure portal navigation to find Storage Sync Services (search for "Azure File Sync").  
- Sync errors may occur but verify file presence in Azure File Shares to confirm syncing is working.  
- Exam questions may test knowledge on setup order, components involved, and cleanup procedures for Azure File Sync.

---

## Storage Accounts CheatSheet

**Timestamp**: 03:54:31 – 04:02:22

**Key Concepts**  
- Azure has **five core storage services**:  
  1. Azure Blob  
  2. Azure Files  
  3. Azure Queues  
  4. Azure Tables  
  5. Azure Disks  
- Blob Storage performance tiers: **Standard (HDD)** and **Premium (SSD)**  
- Blob Storage supports **three types of blobs**: Block Blobs, Append Blobs, Page Blobs  
- Blob Storage access tiers (Standard): **Hot**, **Cool**, and **Archive**  
- Blob tiering can be done at **account level** or **blob level**  
- **Rehydration** is required when moving blobs out of Archive tier (can take hours)  
- Blob lifecycle management allows **rule-based automatic tier transitions**  
- Charges apply differently when moving blobs between tiers (read/write operations and data retrieval costs)  
- Early deletion charges apply for blobs moved to Cool (30 days minimum) or Archive (180 days minimum) tiers  
- Multiple tools to move data into Azure Blob Storage: AZCopy, Azure Storage Data Movement Library, Azure Data Factory, Blob Fuse, Azure Databox, Azure Import/Export Service  
- Storage account replication types:  
  - Locally Redundant Storage (LRS)  
  - Zone Redundant Storage (ZRS)  
  - Geo-Redundant Storage (GRS)  
  - Geo-Zone Redundant Storage (GZRS)  
  - Read Access Geo-Redundant Storage (RA-GRS)  
  - Read Access Geo-Zone Redundant Storage (RA-GZRS)  
- Azure Files: fully managed cloud file shares accessible via SMB or NFS protocols  
- Azure Files supports **shared snapshots** (read-only, incremental, up to 200 per share, retention up to 10 years)  
- Soft delete for Azure Files prevents accidental deletion by retaining deleted files for a configurable period  
- Azure Files storage tiers: Premium, Transaction Optimized, Hot, Cool (on GPv2 accounts)  
- Azure Files can be accessed inside or outside Azure via public endpoints; SMB uses **port 445** (may require unblocking)  
- Encryption: at rest (Azure Storage Service Encryption) and in transit (SMB 3.0 or HTTPS)  
- Azure File Sync allows caching Azure file shares on on-prem Windows Servers or Cloud VMs  
- Azure Import/Export Service allows secure import/export of large data sets using physical drives (own drives or Microsoft-provided Azure Data Box Disks)  
- WA Import Export tool is Windows 64-bit only; two versions exist (v1 for blobs, v2 for Azure Files)  
- Shared Access Signatures (SAS) provide restricted, temporary access to storage resources with different types:  
  - Account-level SAS  
  - Service-level SAS  
  - User-delegated SAS (best practice, uses Azure AD credentials, limited to blobs or containers)  
- SAS formats include ad hoc SAS and service SAS with stored access policies  

**Definitions**  
- **Blob Storage**: Object storage for unstructured data, supporting block, append, and page blobs.  
- **Access Tiers (Blob Storage)**: Hot (frequent access), Cool (infrequent access), Archive (rare access, minimum 180 days retention).  
- **Rehydration**: Process of moving blobs from Archive tier back to Hot or Cool, which can take several hours.  
- **Replication Types**: Methods to replicate data for durability and availability across regions or zones.  
- **Azure Files**: Managed file shares in the cloud accessible via SMB or NFS protocols.  
- **Soft Delete**: Feature that retains deleted files for a period to prevent accidental data loss.  
- **Shared Access Signature (SAS)**: URI granting restricted, temporary access to storage resources without sharing account keys.  

**Key Facts**  
- Blob Storage has 3 blob types and 3 access tiers for Standard performance.  
- Archive tier requires data to be stored for at least 180 days; Cool tier has a 30-day minimum retention.  
- Moving blobs out of Archive requires rehydration, which can take hours.  
- Early deletion charges apply if blobs are moved out of Cool or Archive before minimum retention.  
- Azure Files supports up to 200 incremental snapshots per file share, retained up to 10 years.  
- SMB protocol for Azure Files uses port 445 (may need to be unblocked).  
- Azure Data Box Disks: 5 encrypted SSDs per order, 40 TB total capacity.  
- WA Import Export tool is Windows 64-bit only; version 1 for blobs, version 2 for Azure Files.  
- SAS types: account-level, service-level, user-delegated (best practice).  

**Examples**  
- Tools to move data into Blob Storage: AZCopy, Azure Data Factory, Blob Fuse, Azure Databox, Azure Import/Export Service.  
- Azure File Sync caches Azure file shares on-premises or cloud VMs for faster access.  
- Using BitLocker to encrypt drives for Azure Import/Export.  

**Key Takeaways 🎯**  
- Know the five core Azure storage services and their purposes.  
- Understand the differences between blob types and access tiers, including costs and retention policies.  
- Be familiar with replication options and when to use each.  
- Remember port 445 is required for SMB access to Azure Files and may need to be unblocked.  
- Soft delete and snapshot features protect against accidental data loss in Azure Files.  
- Know the basics of Azure Import/Export Service and WA Import Export tool requirements.  
- Shared Access Signatures are critical for secure, temporary access; user-delegated SAS using Azure AD is best practice.  
- Be aware of charges related to tier changes, early deletions, and data retrievals.  
- Understand rehydration timing and implications when moving blobs from Archive tier.

---
