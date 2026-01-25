# Learning Path 5: Monitor and Back Up Resources

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/paths/az-104-monitor-backup-resources/)
* [Introduction to Azure Backup](#introduction-to-azure-backup)
* [What is Azure Backup?](#what-is-azure-backup)
* [How Azure Backup works](#how-azure-backup-works)

---
<!-- omit in toc -->
## 📋 Modules

| # | Module | Status | Completed |
|---|--------|--------|-----------|
| 1 | [Introduction to Azure Backup](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-backup/) | 🕒 | |
| 2 | [Protect your virtual machines by using Azure Backup](https://learn.microsoft.com/en-us/training/modules/protect-virtual-machines-with-azure-backup/) | 🕒 | |

**Legend:** 🕒 Not Started | 🚧 In Progress | ✅ Complete

---

## Introduction to Azure Backup

[Module Reference](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-backup/)

**Purpose of Backups**

* Data protection drives decisions around **storage**, **backup frequency**, **retention duration**, and **restore policies**.
* Traditional on-premises backups often relied on:

  * **Local redundant storage**
  * **Off-site storage** (for example, tape backups)
* Off-site and tape-based backups can cause:

  * **Long restore times**
  * **Significant downtime** due to transport and manual restore processes

**Limitations of Traditional Backup Solutions**

* May not adequately address:

  * **Backup security**
  * **Ransomware protection**
  * **Human error** during backup or restore
* Often lack simplicity or cost efficiency

**Azure Backup Overview**

* Azure Backup is designed to be:

  * **Cost-effective**
  * **Simple to use**
  * **Secure**
* Provides a cloud-based, Azure-native backup solution
* Uses Azure storage as the backup target

**Supported Workloads**

Azure Backup supports backing up the following resources:

* **Azure Virtual Machines**
* **Azure Managed Disks**
* **Azure Files**
* **SQL Server in Azure VMs**
* **SAP HANA databases in Azure VMs**
* **Azure Database for PostgreSQL servers**
* **Azure Database for PostgreSQL – Flexible servers**
* **Azure Database for MySQL – Flexible servers**
* **Azure Blobs**
* **Azure Kubernetes clusters**

**Example Scenario**

* SQL Server databases running in an **Always On availability group** across **three Azure VMs**
* Requirements:

  * Use an **Azure-native backup service**
  * Retain backups for **10 years** in **lower-cost storage**
  * Meet **audit and compliance** needs
  * **Daily monitoring** of backup jobs

**Module Objectives**

* Evaluate whether:

  * Azure Backup can meet organizational backup requirements
  * Required data can be **backed up and restored**
  * Backup data can be stored **securely**
* Enable informed decisions on using Azure Backup for **data protection**

**Key Facts to Remember**

* Azure Backup addresses both **on-premises** and **Azure-based** backup scenarios
* Long-term retention (for example, **10 years**) is supported
* Designed to reduce downtime compared to traditional tape or off-site backups
* Focuses on **security**, **simplicity**, and **cost efficiency**

---

## What is Azure Backup?

[Module Reference](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-backup/)

**Azure Backup Overview**

* **Azure Backup** is an Azure service that provides **cost-effective, secure, zero-infrastructure backup solutions** for Azure-managed data assets.
* Eliminates the need to deploy or manage backup servers or backup storage.
* Backup storage is **automatically managed and scaled** by Azure.

<img src='.img/2026-01-25-05-16-45.png' width=700> 

**Azure Backup Definition**

* Provides **centralized management** for defining backup policies.
* Protects a wide range of enterprise workloads, including:

  * **On-premises files, folders, and system state**
  * **Azure Virtual Machines (VMs)**
  * **Azure Managed Disks**
  * **Azure File Shares**
  * **SQL Server in Azure VMs**
  * **SAP HANA databases in Azure VMs**
  * **Azure Database for PostgreSQL servers**
  * **Azure Database for PostgreSQL – Flexible servers**
  * **Azure Database for MySQL – Flexible servers**
  * **Azure Blobs**
  * **Azure Kubernetes clusters**

<img src='.img/2026-01-25-05-17-28.png' width=700> 

**When to Use Azure Backup**

* Designed for organizations with **compliance and data-protection requirements**.
* Supports **self-service backup and restore** for application administrators.
* Protects **all workloads** from a **centralized management interface**.
* Addresses scenarios such as:

  * Data corruption
  * Accidental deletions
  * Rogue administrator actions
  * Disaster recovery requirements

**Key Features**

* **Zero-infrastructure backup solution**

  * No backup servers or storage to deploy.
  * Reduces **capital expenses** and **operational expenses**.
  * Automates storage management.
* **At-scale management**

  * Centralized management through **Backup Center**.
  * Supports **APIs, PowerShell, and Azure CLI** for automation.
  * Enables discovery, governance, monitoring, operation, and optimization of backups.
* **Security**

  * Built-in protection for data **in transit and at rest**.
  * Uses encryption, private endpoints, alerts, and other security capabilities.
  * Protects against ransomware, malicious admins, and accidental deletions.

**Recovery Objectives**

* **Recovery Time Objective (RTO)**

  * Target time to restore a business process after a disaster.
  * Example: If maximum tolerated downtime is four hours, RTO is **four hours**.
* **Recovery Point Objective (RPO)**

  * Maximum acceptable data loss measured in time.
  * Example: An RPO of **one hour** means backups occur hourly, with no more than one hour of data loss.
* Example scenario:

  * RPO: **1 hour**
  * RTO: **3 hours**
  * Data loss is limited to one hour, and system access is restored within three hours.

**Key Facts to Remember**

* **Azure Backup requires no backup infrastructure**
* **Backup Center** is the central management console
* Supports **Azure, on-premises, and database workloads**
* **RTO = restore time target**
* **RPO = acceptable data loss window**
* Built-in security protects backups from **ransomware and accidental deletion**

---

## How Azure Backup works

[Module Reference](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-backup/)

**Azure Backup Service Overview**

* Azure Backup provides data protection for **on-premises machines**, **Azure virtual machines**, and **workloads**
* Backed-up data is stored in **Recovery Services vaults** or **Backup vaults**
* Protects **data**, **machine state**, and **workloads**

**Azure Backup Architecture Layers**

* **Workload integration layer – Backup Extension**

  * Integrates directly with workloads such as **Azure VMs**, **Azure Blobs**, and databases
  * Backup extensions are installed on source VMs or worker VMs
  * Backup types generated:

    * **Snapshots** for Azure VMs and Azure Files
    * **Stream backups** for databases such as SQL Server and HANA

* **Data Plane – Access Tiers**

  * **Snapshot tier**

    * First phase of VM backup
    * Snapshots stored in the customer’s subscription and resource group
    * Faster restores because data is locally available
  * **Vault-standard tier**

    * Online storage in Microsoft-managed tenant
    * Stores isolated copy of backup data
    * Ensures availability even if source data is deleted or compromised
  * **Archive tier**

    * Used for **long-term retention (LTR)**
    * Optimized for rarely accessed data
    * Supports compliance-based retention requirements
  * Each tier has different **RTOs** and pricing

<img src='.img/2026-01-25-05-20-31.png' width=700> 

* **Data Plane – Availability and Security**

  * Data replication options:

    * **Locally redundant storage (LRS)**
    * **Zone-redundant storage (ZRS)**
    * **Geo-redundant storage (GRS)**
  * Security features:

    * **Encryption**
    * **Azure RBAC**
    * **Soft delete**

      * Deleted backups retained for **14 days** at no cost
  * Supports **backup data lifecycle management** for retention policies

* **Management Plane – Vaults and Backup Center**

  * **Recovery Services vaults** and **Backup vaults**

    * Manage backups and store backup data
    * Contain **backup policies** that define schedules and retention
  * Vault usage models:

    * Single vault for single subscription/resource
    * Multiple vaults across subscriptions and regions
  * **Backup center**

    * Centralized management (“single pane of glass”)
    * Supports multiple workloads, vaults, subscriptions, regions, and Azure Lighthouse tenants

<img src='.img/2026-01-25-05-20-51.png' width=700> 

**What Data Is Backed Up**

* On-premises Windows machines:

  * Direct backup using **MARS agent**
  * Indirect backup using **DPM** or **MABS** (Microsoft Azure Backup Server), then backed up to Azure
* Azure VMs:

  * Full VM backup using VM backup extension
  * File and folder backup using MARS agent

**Supported Backup Types**

* **Full backup**

  * Initial backup type
* **Incremental backup**

  * Backs up only changed data blocks
  * Used for all Azure backups and DPM/MABS disk backups

**SQL Server Backup Support**

| Backup Type              | Description                           | Limits                                         |
| ------------------------ | ------------------------------------- | ---------------------------------------------- |
| Full                     | Entire database backup including logs | Max **1 per day**                              |
| Differential             | Changes since last full backup        | Max **1 per day**; cannot run same day as full |
| Multiple backups per day | Azure VM backups                      | RPO **4–24 hours** using Enhanced policy       |
| Selective disk backup    | Backup selected VM disks only         | Supported via Enhanced policy                  |
| Transaction log          | Point-in-time recovery                | Every **15 minutes** maximum                   |

<img src='.img/2026-01-25-05-21-08.png' width=700> 


**Key Facts to Remember**

* Azure Backup uses **vaults** to store and manage backup data
* Backup extensions generate **snapshots** or **stream backups**
* Three access tiers: **Snapshot**, **Vault-standard**, **Archive**
* Soft delete retains backups for **14 days**
* SQL log backups can run every **15 minutes**
* Enhanced backup policy enables **hourly VM backups** and **selective disk backup**

---
