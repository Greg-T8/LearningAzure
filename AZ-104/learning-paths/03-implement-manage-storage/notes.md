# Learning Path 2: Implement and Manage Storage

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/paths/az-104-manage-storage/)

* [Implement Azure Storage](#implement-azure-storage)
* [Explore Azure Storage services](#explore-azure-storage-services)
* [Determine storage account types](#determine-storage-account-types)


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
