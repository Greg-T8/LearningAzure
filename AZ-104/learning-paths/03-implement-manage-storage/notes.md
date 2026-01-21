# Learning Path 2: Implement and Manage Storage

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/paths/az-104-manage-storage/)

* [Implement Azure Storage](#implement-azure-storage)
* [Explore Azure Storage services](#explore-azure-storage-services)
* [Determine storage account types](#determine-storage-account-types)
* [Determine replication strategies](#determine-replication-strategies)
* [Access storage](#access-storage)
* [Secure storage endpoints](#secure-storage-endpoints)


---

<!-- omit in toc -->
## 📋 Modules

| # | Module | Status | Completed |
|---|--------|--------|-------|
| 1 | [Configure storage accounts](https://learn.microsoft.com/en-us/training/modules/configure-storage-accounts/) | 🕒 | |
| 2 | [Configure Azure Blob Storage](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/) | 🕒 | |
| 3 | [Configure Azure Storage security](https://learn.microsoft.com/en-us/training/modules/configure-storage-security/) | 🕒 | |
| 4 | [Configure Azure Files](https://learn.microsoft.com/en-us/training/modules/configure-azure-files-file-sync/) | 🕒 | |

---

## Implement Azure Storage

[Module Reference](https://learn.microsoft.com/training/modules/configure-storage-accounts/)

**Overview**

* **Azure Storage** is Microsoft’s cloud storage solution for modern data storage scenarios.
* Provides:

  * **Object storage** for massive scalability
  * **File system services** for cloud-based file shares
  * **Messaging storage** for reliable messaging
  * **NoSQL storage** for structured data
* Designed to be **AI-ready** and supports storing files, messages, tables, and other data types.
* Used by:

  * Application developers for **working data** (websites, mobile apps, desktop apps)
  * **IaaS virtual machines**
  * **PaaS cloud services**

<img src='.img/2026-01-21-04-01-05.png' width=700> 

**Categories of Data Supported**

* **Virtual machine data**

  * Includes **disks** and **files**
  * **Disks**: Persistent block storage for Azure IaaS virtual machines
  * **Files**: Fully managed file shares in the cloud
  * Provided through **Azure managed disks**
  * **Data disks** store:

    * Database files
    * Website static content
    * Custom application code
  * Number of data disks depends on **virtual machine size**

* **Unstructured data**

  * Least organized, **nonrelational** format
  * Stored using:

    * **Azure Blob Storage**

      * Highly scalable, REST-based cloud object store
    * **Azure Data Lake Storage**

      * Hadoop Distributed File System (HDFS) as a service

* **Structured data**

  * Stored in a **relational format** with a shared schema
  * Organized as tables with rows, columns, and keys
  * Stored using:

    * **Azure Table Storage** (autoscaling NoSQL store)
    * **Azure Cosmos DB** (globally distributed database service)
    * **Azure SQL Database** (fully managed database-as-a-service built on SQL)

**Key Considerations When Using Azure Storage**

* **Durability and availability**

  * Data is **highly durable and highly available**
  * **Redundancy** protects against:

    * Transient hardware failures
    * Local catastrophes
    * Natural disasters
  * Data can be replicated across:

    * Datacenters
    * Geographical regions
  * Replicated data remains available during unexpected outages

* **Secure access**

  * **All data is encrypted**
  * Provides **fine-grained access control** to data

* **Scalability**

  * Designed to be **massively scalable**
  * Supports modern application data storage and performance needs

* **Manageability**

  * Microsoft handles:

    * Hardware maintenance
    * Updates
    * Critical infrastructure issues

* **Data accessibility**

  * Accessible worldwide over **HTTP or HTTPS**
  * SDK support for:

    * .NET, Java, Node.js, Python, PHP, Ruby, Go
  * Supports:

    * REST API
    * Azure PowerShell
    * Azure CLI
  * Visual tools:

    * Azure portal
    * Azure Storage Explorer

**Key Facts to Remember**

* **Azure Storage** supports **virtual machine, structured, and unstructured data**
* **Azure managed disks** provide persistent storage for IaaS VMs
* **Blob Storage** and **Data Lake Storage** are used for unstructured data
* **Table Storage, Cosmos DB, and Azure SQL Database** support structured data
* Data is **encrypted by default** and **globally accessible**
* **Redundancy** ensures durability and availability during failures

---

## Explore Azure Storage services

[Module Reference](https://learn.microsoft.com/training/modules/configure-storage-accounts/)

<img src='.img/2026-01-21-04-03-23.png' width=700> 

**Azure Blob Storage**

* **Object storage** optimized for **massive amounts of unstructured or nonrelational data**
* Ideal for:

  * Serving **images or documents** directly to a browser
  * **Distributed file access**
  * **Streaming video and audio**
  * **Backup, restore, disaster recovery, and archiving**
  * **Data analysis** by on-premises or Azure-hosted services
* Blobs are accessible worldwide via **HTTP or HTTPS**
* Access methods:

  * URLs
  * Azure Storage REST API
  * Azure PowerShell
  * Azure CLI
  * Azure Storage client libraries
* Client libraries available for **.NET, Java, Node.js, Python, PHP, and Ruby**
* Supports access using the **NFS protocol**

**Azure Files**

* Provides **highly available network file shares**
* Supports access using:

  * **Server Message Block (SMB)**
  * **Network File System (NFS)**
* Multiple virtual machines can share files with **read and write access**
* Files can also be accessed via:

  * REST interface
  * Storage client libraries
* Common use cases:

  * **Lift-and-shift migration** of on-premises apps using file shares
  * Shared **configuration files** across multiple VMs
  * Centralized storage for **tools and utilities**
  * Storage of **diagnostic logs, metrics, and crash dumps**
* **Storage account credentials** are used for authentication
* All users mounting the share have **full read/write access**

**Azure Queue Storage**

* Used to **store and retrieve messages**
* **Queue message size limit: 64 KB**
* A queue can contain **millions of messages**
* Designed for **asynchronous message processing**
* Common scenario:

  * Decoupling application components
  * Creating a **backlog of work**
  * Independent scaling of processing components (for example, using Azure Functions)

**Azure Table Storage**

* Stores **structured, nonrelational (NoSQL) data**
* Provides a **key/attribute store** with a **schemaless design**
* Benefits:

  * Easy schema evolution as application needs change
  * **Fast and cost-effective** access
  * Typically **lower cost than traditional SQL** for similar data volumes
* Azure Cosmos DB Table API:

  * **Throughput-optimized tables**
  * **Global distribution**
  * **Automatic secondary indexes**

**Choosing the Right Azure Storage Service**

* **Massive unstructured data**: Use **Azure Blob Storage**
* **Highly available shared file storage**: Use **Azure Files**
* **Asynchronous message processing**: Use **Azure Queue Storage**
* **Structured, nonrelational data**: Use **Azure Table Storage / Cosmos DB Table API**

**Key Facts to Remember**

* **Blob Storage**: Unstructured data, HTTP/HTTPS access, NFS supported
* **Azure Files**: SMB and NFS file shares, shared VM access, lift-and-shift friendly
* **Queue Storage**: 64 KB message limit, millions of messages, async processing
* **Table Storage**: Schemaless NoSQL, cost-effective, Cosmos DB integration

---

## Determine storage account types

[Module Reference](https://learn.microsoft.com/training/modules/configure-storage-accounts/)

**Storage Account Types Overview**

* General-purpose Azure storage accounts have **two basic types**:

  * **Standard**
  * **Premium**

**Standard Storage Accounts**

* Backed by **magnetic hard disk drives (HDD)**
* Provide the **lowest cost per GB**
* Best suited for:

  * Bulk storage
  * Data that is **infrequently accessed**
* Common use cases include general application data and cost-sensitive workloads

**Premium Storage Accounts**

* Backed by **solid-state drives (SSD)**
* Provide **consistent low-latency and high-performance**
* Best suited for:

  * **I/O-intensive workloads**
  * Azure virtual machine disks
  * Databases and high-transaction applications

**Important Notes**

* **Standard and Premium storage accounts cannot be converted** between types

  * A new storage account must be created
  * Data must be copied manually if needed
* **All storage account types are encrypted at rest**

  * Encryption uses **Storage Service Encryption (SSE)**

**Storage Account Types and Supported Services**

* **Standard general-purpose v2**

  * Supports: Blob Storage (including Data Lake Storage), Queue Storage, Table Storage, Azure Files
  * Recommended for **most scenarios**, including blobs, file shares, queues, tables, and disks (page blobs)

* **Premium block blobs**

  * Supports: Blob Storage (including Data Lake Storage)
  * Recommended for:

    * Block blobs and append blobs
    * Applications with **high transaction rates**
    * Smaller objects or workloads requiring **consistently low latency**

* **Premium file shares**

  * Supports: Azure Files only
  * Recommended for:

    * Enterprise or high-performance scale applications
    * Scenarios requiring both **SMB and NFS** support

* **Premium page blobs**

  * Supports: Page blobs only
  * Recommended for:

    * Index-based and sparse data structures
    * Operating systems
    * Virtual machine data disks
    * Databases

**Key Facts to Remember**

* **Two base storage types**: Standard (HDD) and Premium (SSD)
* **No conversion** between Standard and Premium storage accounts
* **SSE encryption** is enabled for all storage accounts by default
* **Premium accounts are workload-specific** (block blobs, file shares, page blobs)
* **Standard GPv2** is the default choice for most Azure storage scenarios

---

## Determine replication strategies

[Module Reference](https://learn.microsoft.com/training/modules/configure-storage-accounts/)

**Azure Storage Replication Overview**

* Data in an Azure storage account is **always replicated** to ensure **durability** and **high availability**.
* Replication protects against:

  * Transient hardware failures
  * Network or power outages
  * Data center failures
  * Regional disasters
* Replication options span:

  * Within a **single datacenter**
  * Across **availability zones** in a region
  * Across **geographically paired regions**
* Replication helps meet Azure Storage **SLA** even during failures.


**Locally Redundant Storage (LRS)**

* **Lowest-cost** replication option
* Data is replicated **three times within a single datacenter**
* **Lowest durability** compared to other strategies
* **All replicas may be lost** during a datacenter-level disaster
* Appropriate when:

  * Data can be **easily reconstructed**
  * Data is **nonessential or constantly changing**
  * **Data residency** requires a single location

<img src='.img/2026-01-21-04-08-45.png' width=400>

**Zone-Redundant Storage (ZRS)**

* Data is **synchronously replicated across three availability zones** in one region
* Each zone:

  * Is **physically separated**
  * Has **independent power, networking, and cooling**
* Ensures data access if **one zone becomes unavailable**
* Provides **excellent performance and low latency**
* Limitations:

  * **Not available in all regions**
  * Converting to ZRS requires **physical data movement**

<img src='.img/2026-01-21-04-09-39.png' width=400> 

**Geo-Redundant Storage (GRS)**

* Replicates data to a **secondary region** hundreds of miles away
* Designed for **regional disaster recovery**
* Provides **99.99999999999999% (16 9’s) durability**
* Secondary data is **read-only after Microsoft-initiated failover**
* Replication process:

  * Data written to primary region using **LRS**
  * Replicated **asynchronously** to secondary region
  * Secondary region also uses **LRS**
* Replication unit: **storage scale unit**

<img src='.img/2026-01-21-04-10-19.png' width=700>

**Read-Access Geo-Redundant Storage (RA-GRS)**

* Based on **GRS**
* Adds **read access to the secondary region at all times**
* Read access is available **even without failover**

**Geo-Zone-Redundant Storage (GZRS)**

* Combines **ZRS + GRS**
* Data is:

  * Replicated across **three availability zones** in the primary region
  * Replicated to a **secondary paired region**
* Supports:

  * **Read/write access** during zone failures
  * **Durability during regional outages**
* Designed for **99.99999999999999% (16 9’s) durability**
* Same scalability targets as **LRS, ZRS, GRS, RA-GRS**
* Optional **read access to secondary region** with **RA-GZRS**
* Microsoft **recommends GZRS** for:

  * High availability
  * Strong consistency
  * Disaster recovery
  * Excellent performance

**Replication Strategy Capabilities**

* **Node failure protection**:

  * LRS, ZRS, GRS, RA-GRS, GZRS, RA-GZRS
* **Datacenter failure protection**:

  * ZRS, GRS, RA-GRS, GZRS, RA-GZRS
* **Region-wide outage protection**:

  * GRS, RA-GRS, GZRS, RA-GZRS
* **Read access during regional outage**:

  * RA-GRS, RA-GZRS

**Key Facts to Remember**

* **LRS**: Lowest cost, lowest durability, single datacenter
* **ZRS**: Synchronous replication across **3 availability zones**
* **GRS**: Asynchronous replication to **secondary region**
* **RA-GRS**: Read access to secondary region **without failover**
* **GZRS**: ZRS + GRS combined
* **RA-GZRS**: Read access to secondary region during disasters
* **16 nines durability** applies to **GRS, RA-GRS, GZRS, RA-GZRS**
* All geo-replication uses **LRS at both primary and secondary regions**

---

## Access storage

[Module Reference](https://learn.microsoft.com/training/modules/configure-storage-accounts/)

**Storage Account Endpoints**

* Every object in **Azure Storage** has a **unique URL**
* The **storage account name** forms the **subdomain** of the URL
* The **service type** determines the **domain name**
* The combination creates a **service endpoint**

**Default Service Endpoints**

| Service                      | Default Endpoint                             |
| ---------------------------- | -------------------------------------------- |
| **Blob (Container) service** | `//<storage-account>.blob.core.windows.net`  |
| **Table service**            | `//<storage-account>.table.core.windows.net` |
| **Queue service**            | `//<storage-account>.queue.core.windows.net` |
| **File service**             | `//<storage-account>.file.core.windows.net`  |

**Accessing Objects in Storage**

* Object URLs are created by **appending the object path** to the service endpoint

* Format:

  * `//<storage-account>.<service>.core.windows.net/<container>/<object>`

* Example:

  * Blob name: `myblob`
  * Container: `mycontainer`
  * URL:

    * `//mystorageaccount.blob.core.windows.net/mycontainer/myblob`

**Configure Custom Domains**

* You can configure a **custom domain** for **Azure Blob Storage**
* Default blob endpoint format:

  * `<storage-account>.blob.core.windows.net`
* Custom domains allow users to access blob data using a **friendly domain name**

**Direct Mapping with CNAME**

* **Direct mapping** enables a custom **subdomain** for a storage account
* Requires creating a **CNAME record** in DNS
* The CNAME maps the custom subdomain to the **blob or web endpoint**

**Direct Mapping Example**

* Custom subdomain: `blobs.contoso.com`
* Azure blob endpoint:

  * `<storage-account>.blob.core.windows.net`
* DNS CNAME record points the subdomain to the storage endpoint

<img src='.img/2026-01-21-04-16-52.png' width=700> 

**Key Facts to Remember**

* **Every Azure Storage object has a unique URL**
* **Storage account name = URL subdomain**
* **Service type determines the endpoint domain**
* **Custom domains apply to Blob Storage**
* **Direct mapping uses a DNS CNAME record**
* **Custom domains map to blob or web endpoints**

---

## Secure storage endpoints

[Module Reference](https://learn.microsoft.com/training/modules/configure-storage-accounts/secure-storage-endpoints)

**Firewall and Virtual Network Settings**

* Storage account network access is configured through **Firewalls and virtual networks** in the Azure portal.
* You explicitly define which **virtual networks and subnets** are allowed to access the storage account.
* This configuration **restricts access** to:

  * Specific **subnets** within virtual networks
  * Specific **public IP addresses or IP ranges**

<img src='.img/2026-01-21-04-14-32.png' width=700> 

**Service Endpoints**

* Azure Storage provides **service endpoint base URLs** for:

  * Blob
  * Queue
  * Table
  * File
* These base URLs are used to construct the full address for individual storage resources.

<img src='.img/2026-01-21-04-14-57.png' width=700> 

**Configuration Considerations**

* Access can be allowed from **one or more public IP ranges**.
* Virtual networks and subnets must be:

  * In the **same Azure region** as the storage account, **or**
  * In a supported **region pair**
* After configuration, you should **test the service endpoint** to confirm access is restricted as intended.

**Key Facts to Remember**

* **Firewalls and virtual networks** control network-level access to storage accounts.
* **Service endpoints** provide the base URL for all Azure Storage services.
* **Region alignment is required** between storage accounts and allowed virtual networks.
* **Testing access** after configuration is required to verify security behavior.

---
