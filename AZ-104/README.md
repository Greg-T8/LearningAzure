# AZ-104: Microsoft Azure Administrator — Study Guide

**Objective:** Achieve the **AZ-104: Microsoft Azure Administrator** certification using a hands-on labs and practice exams approach.

---

## 📚 Learning Modality Progress Tracker

| Priority | Modality         | My Notes                                                        | Status | Started | Completed | Days |
| :------- | :--------------- | :-------------------------------------------------------------- | :----- | :------ | :-------- | :--- |
| 1        | Hands-on Labs    | [Hands-on Labs](./hands-on-labs/README.md)                      | 🚧    | 2/2/26  |           |      |
| 1        | Practice Questions   | [Practice Questions](./practice-questions/README.md)                    | 🚧    | 2/2/26  |           |      |
| 2        | Video            | [John Savill's Training](./video-courses/savill/README.md) | ✅    | 1/29/26 | 2/1/26          | 4      |
| 3        | Microsoft Learn | [Microsoft Learning Paths](./learning-paths/README.md)          | ✅     | 1/14/26 | 1/25/26   | 11   |

**Legend:** 🕒 Not Started | 🚧 In Progress | ✅ Complete

**[Study Log](./StudyLog.md)** — Session-by-session study time tracker

---

## 📌 Reference Links

- **Certification Page:** [AZ-104: Microsoft Azure Administrator](https://learn.microsoft.com/en-us/credentials/certifications/azure-administrator/?practice-assessment-type=certification#certification-prepare-for-the-exam)
- **Official Study Guide:** [AZ-104 Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-104)

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

## 📈 Practice Exam Coverage

Task-level question counts from [Practice Questions](./practice-questions/README.md). Tasks with **0** have no practice questions yet.

<!-- BEGIN COVERAGE TABLE -->

### Domain 1: Manage Azure Identities and Governance (20–25%)

#### Manage Microsoft Entra users and groups

| Task | Qs |
| :--- | -: |
| Create users and groups | 0 |
| Manage user and group properties | 0 |
| Manage licenses in Microsoft Entra ID | 0 |
| Manage external users | 0 |
| Configure self-service password reset (SSPR) | 1 |

#### Manage access to Azure resources

| Task | Qs |
| :--- | -: |
| Manage built-in Azure roles | 0 |
| Assign roles at different scopes | 0 |
| Interpret access assignments | 1 |

#### Manage Azure subscriptions and governance

| Task | Qs |
| :--- | -: |
| Implement and manage Azure Policy | 3 |
| Configure resource locks | 2 |
| Apply and manage tags on resources | 3 |
| Manage resource groups | 1 |
| Manage subscriptions | 0 |
| Manage costs by using alerts, budgets, and Azure Advisor recommendations | 1 |
| Configure management groups | 0 |

### Domain 2: Implement and Manage Storage (15–20%)

#### Configure access to storage

| Task | Qs |
| :--- | -: |
| Configure Azure Storage firewalls and virtual networks | 0 |
| Create and use shared access signature (SAS) tokens | 1 |
| Configure stored access policies | 1 |
| Manage access keys | 2 |
| Configure identity-based access for Azure Files | 1 |

#### Configure and manage storage accounts

| Task | Qs |
| :--- | -: |
| Create and configure storage accounts | 0 |
| Configure Azure Storage redundancy | 1 |
| Configure object replication | 1 |
| Configure storage account encryption | 0 |
| Manage data by using Azure Storage Explorer and AzCopy | 0 |

#### Configure Azure Files and Azure Blob Storage

| Task | Qs |
| :--- | -: |
| Create and configure a file share in Azure Storage | 0 |
| Create and configure a container in Blob Storage | 0 |
| Configure storage tiers | 0 |
| Configure soft delete for blobs and containers | 0 |
| Configure snapshots and soft delete for Azure Files | 1 |
| Configure blob lifecycle management | 2 |
| Configure blob versioning | 1 |

### Domain 3: Deploy and Manage Azure Compute Resources (20–25%)

#### Automate deployment of resources by using ARM templates or Bicep files

| Task | Qs |
| :--- | -: |
| Interpret an Azure Resource Manager template or a Bicep file | 1 |
| Modify an existing Azure Resource Manager template | 0 |
| Modify an existing Bicep file | 1 |
| Deploy resources by using an ARM template or a Bicep file | 0 |
| Export a deployment as an ARM template or convert an ARM template to a Bicep file | 0 |

#### Create and configure virtual machines

| Task | Qs |
| :--- | -: |
| Create a virtual machine | 0 |
| Configure Azure Disk Encryption | 1 |
| Move a VM to another resource group, subscription, or region | 0 |
| Manage virtual machine sizes | 1 |
| Manage virtual machine disks | 0 |
| Deploy VMs to availability zones and availability sets | 0 |
| Deploy and configure an Azure Virtual Machine Scale Sets | 1 |

#### Provision and manage containers in the Azure portal

| Task | Qs |
| :--- | -: |
| Create and manage an Azure container registry | 0 |
| Provision a container by using Azure Container Instances | 0 |
| Provision a container by using Azure Container Apps | 0 |
| Manage sizing and scaling for containers, including Azure Container Instances and Azure Container Apps | 1 |

#### Create and configure Azure App Service

| Task | Qs |
| :--- | -: |
| Provision an App Service plan | 4 |
| Configure scaling for an App Service plan | 3 |
| Create an App Service | 1 |
| Configure certificates and TLS for an App Service | 0 |
| Map an existing custom DNS name to an App Service | 0 |
| Configure backup for an App Service | 0 |
| Configure networking settings for an App Service | 0 |
| Configure deployment slots for an App Service | 1 |

### Domain 4: Implement and Manage Virtual Networking (15–20%)

#### Configure and manage virtual networks in Azure

| Task | Qs |
| :--- | -: |
| Create and configure virtual networks and subnets | 0 |
| Create and configure virtual network peering | 0 |
| Configure public IP addresses | 0 |
| Configure user-defined network routes | 0 |
| Troubleshoot network connectivity | 0 |

#### Configure secure access to virtual networks

| Task | Qs |
| :--- | -: |
| Create and configure NSGs and application security groups | 0 |
| Evaluate effective security rules in NSGs | 0 |
| Implement Azure Bastion | 0 |
| Configure service endpoints for Azure PaaS | 0 |
| Configure private endpoints for Azure PaaS | 1 |

#### Configure name resolution and load balancing

| Task | Qs |
| :--- | -: |
| Configure Azure DNS | 1 |
| Configure an internal or public load balancer | 1 |
| Troubleshoot load balancing | 2 |

### Domain 5: Monitor and Maintain Azure Resources (10–15%)

#### Monitor resources in Azure

| Task | Qs |
| :--- | -: |
| Interpret metrics in Azure Monitor | 1 |
| Configure log settings in Azure Monitor | 0 |
| Query and analyze logs in Azure Monitor | 0 |
| Set up alert rules, action groups, and alert processing rules in Azure Monitor | 2 |
| Configure and interpret monitoring of VMs, storage accounts, and networks by using Azure Monitor Insights | 0 |
| Use Azure Network Watcher and Connection Monitor | 2 |

#### Implement backup and recovery

| Task | Qs |
| :--- | -: |
| Create a Recovery Services vault | 0 |
| Create an Azure Backup vault | 0 |
| Create and configure a backup policy | 0 |
| Perform backup and restore operations by using Azure Backup | 2 |
| Configure Azure Site Recovery for Azure resources | 0 |
| Perform a failover to a secondary region by using Site Recovery | 0 |
| Configure and interpret reports and alerts for backups | 0 |

<!-- END COVERAGE TABLE -->