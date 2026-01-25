# Learning Path 5: Monitor and Back Up Resources

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/paths/az-104-monitor-backup-resources/)
* [Introduction to Azure Backup](#introduction-to-azure-backup)

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
