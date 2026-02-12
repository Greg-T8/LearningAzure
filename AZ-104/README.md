# AZ-104: Microsoft Azure Administrator — Study Guide

**Objective:** Achieve the **AZ-104: Microsoft Azure Administrator** certification using a hands-on labs and practice exams approach.

- **Certification Page:** [AZ-104: Microsoft Azure Administrator](https://learn.microsoft.com/en-us/credentials/certifications/azure-administrator/?practice-assessment-type=certification#certification-prepare-for-the-exam)
- **Official Study Guide:** [AZ-104 Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-104)

---

## 📚 Learning Modality Progress Tracker

| Priority | Modality         | My Notes                                                        | Status | Started | Completed | Days |
| :------- | :--------------- | :-------------------------------------------------------------- | :----- | :------ | :-------- | :--- |
| 1        | Hands-on Labs    | [Hands-on Labs](./hands-on-labs/README.md)                      | 🚧    | 2/2/26  |           |      |
| 1        | Practice Exams   | [Practice Exams](./practice-exams/README.md)                    | 🚧    | 2/2/26  |           |      |
| 2        | Video            | [John Savill's Training](./video-courses/savill/README.md) | ✅    | 1/29/26 | 2/1/26          | 4      |
| 3        | Microsoft Learn | [Microsoft Learning Paths](./learning-paths/README.md)          | ✅     | 1/14/26 | 1/25/26   | 11   |

**Legend:** 🕒 Not Started | 🚧 In Progress | ✅ Complete

---

## 📊 Exam Domains

| Domain                     | Weight |
| :------------------------- | :----- |
| 1. Identities & Governance | 20-25% |
| 2. Storage                 | 15-20% |
| 3. Compute                 | 20-25% |
| 4. Networking              | 15-20% |
| 5. Monitoring & Backup     | 10-15% |

---

## 📘 Domain Quick Reference

### Domain 1: Manage Azure Identities and Governance (20–25%)

**Skills Measured**

**Manage Microsoft Entra users and groups**

- Create users and groups
- Manage user and group properties
- Manage licenses in Microsoft Entra ID
- Manage external users
- Configure self-service password reset (SSPR)

**Manage access to Azure resources**

- Manage built-in Azure roles
- Assign roles at different scopes
- Interpret access assignments

**Manage Azure subscriptions and governance**

- Implement and manage Azure Policy
- Configure resource locks
- Apply and manage tags on resources
- Manage resource groups
- Manage subscriptions
- Manage costs by using alerts, budgets, and Azure Advisor recommendations
- Configure management groups

---

### Domain 2: Implement and Manage Storage (15–20%)

**Skills Measured**

**Configure access to storage**

- Configure Azure Storage firewalls and virtual networks
- Create and use shared access signature (SAS) tokens
- Configure stored access policies
- Manage access keys
- Configure identity-based access for Azure Files

**Configure and manage storage accounts**

- Create and configure storage accounts
- Configure Azure Storage redundancy
- Configure object replication
- Configure storage account encryption
- Manage data by using Azure Storage Explorer and AzCopy

**Configure Azure Files and Azure Blob Storage**

- Create and configure a file share in Azure Storage
- Create and configure a container in Blob Storage
- Configure storage tiers
- Configure soft delete for blobs and containers
- Configure snapshots and soft delete for Azure Files
- Configure blob lifecycle management
- Configure blob versioning

---

### Domain 3: Deploy and Manage Azure Compute Resources (20–25%)

**Skills Measured**

**Automate deployment of resources by using Azure Resource Manager (ARM) templates or Bicep files**

- Interpret an Azure Resource Manager template or a Bicep file
- Modify an existing Azure Resource Manager template
- Modify an existing Bicep file
- Deploy resources by using an Azure Resource Manager template or a Bicep file
- Export a deployment as an Azure Resource Manager template or convert an Azure Resource Manager template to a Bicep file

**Create and configure virtual machines**

- Create a virtual machine
- Configure Azure Disk Encryption
- Move a virtual machine to another resource group, subscription, or region
- Manage virtual machine sizes
- Manage virtual machine disks
- Deploy virtual machines to availability zones and availability sets
- Deploy and configure an Azure Virtual Machine Scale Sets

**Provision and manage containers in the Azure portal**

- Create and manage an Azure container registry
- Provision a container by using Azure Container Instances
- Provision a container by using Azure Container Apps
- Manage sizing and scaling for containers, including Azure Container Instances and Azure Container Apps

**Create and configure Azure App Service**

- Provision an App Service plan
- Configure scaling for an App Service plan
- Create an App Service
- Configure certificates and Transport Layer Security (TLS) for an App Service
- Map an existing custom DNS name to an App Service
- Configure backup for an App Service
- Configure networking settings for an App Service
- Configure deployment slots for an App Service

---

### Domain 4: Implement and Manage Virtual Networking (15–20%)

**Skills Measured**

**Configure and manage virtual networks in Azure**

- Create and configure virtual networks and subnets
- Create and configure virtual network peering
- Configure public IP addresses
- Configure user-defined network routes
- Troubleshoot network connectivity

**Configure secure access to virtual networks**

- Create and configure network security groups (NSGs) and application security groups
- Evaluate effective security rules in NSGs
- Implement Azure Bastion
- Configure service endpoints for Azure platform as a service (PaaS)
- Configure private endpoints for Azure PaaS

**Configure name resolution and load balancing**

- Configure Azure DNS
- Configure an internal or public load balancer
- Troubleshoot load balancing

---

### Domain 5: Monitor and Maintain Azure Resources (10–15%)

**Skills Measured**

**Monitor resources in Azure**

- Interpret metrics in Azure Monitor
- Configure log settings in Azure Monitor
- Query and analyze logs in Azure Monitor
- Set up alert rules, action groups, and alert processing rules in Azure Monitor
- Configure and interpret monitoring of virtual machines, storage accounts, and networks by using Azure Monitor Insights
- Use Azure Network Watcher and Connection Monitor

**Implement backup and recovery**

- Create a Recovery Services vault
- Create an Azure Backup vault
- Create and configure a backup policy
- Perform backup and restore operations by using Azure Backup
- Configure Azure Site Recovery for Azure resources
- Perform a failover to a secondary region by using Site Recovery
- Configure and interpret reports and alerts for backups

---
