# Learning Path 2: Implement and Manage Storage

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/paths/az-104-manage-storage/)

---

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
