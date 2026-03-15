# AZ-104: Microsoft Azure Administrator — Study Guide

**Objective:** Achieve the **AZ-104: Microsoft Azure Administrator** certification using a hands-on labs and practice exams approach.

- **Certification Page:** [AZ-104: Microsoft Azure Administrator](https://learn.microsoft.com/en-us/credentials/certifications/azure-administrator/?practice-assessment-type=certification#certification-prepare-for-the-exam)
- **Official Study Guide:** [AZ-104 Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-104)
- **Study Log:** [Session-by-session study time tracker](./StudyLog.md)

---

## 📚 Progress Tracker

| Priority | Modality         | My Notes                                                        | Status | Started | Completed | Days |
| :------- | :--------------- | :-------------------------------------------------------------- | :----- | :------ | :-------- | :--- |
| 1        | Hands-on Labs    | [Hands-on Labs](./hands-on-labs/README.md)                      | In Progress | 2/2/26  |           | 40 |
| 1        | Practice Questions   | [Practice Questions](./practice-questions/README.md)                    | In Progress | 2/2/26  |           | 40 |
| 2        | Video            | [John Savill's Training](./video-courses/savill/README.md) | Completed | 1/29/26 | 2/1/26          | 4      |
| 3        | Microsoft Learn | [Microsoft Learning Paths](./learning-paths/README.md)          | Completed | 1/14/26 | 1/25/26   | 11   |

---

## 📊 Exam Coverage

Task-level coverage from [Practice Questions](./practice-questions/README.md) and [Hands-on Labs](./hands-on-labs/README.md).

<!-- BEGIN COVERAGE DASHBOARD -->

| Domain | Weight | Qs | Labs | Tasks Covered | Status |
| :----- | :----- | -: | ---: | :------------ | :----: |
| [1. Identities & Governance](#domain-1) | 20–25% | 14 | 0 | 8 / 15 (53%) | 🟡 |
| [2. Storage](#domain-2) | 15–20% | 17 | 5 | 11 / 17 (64%) | 🟡 |
| [3. Compute](#domain-3) | 20–25% | 21 | 6 | 13 / 24 (54%) | 🟡 |
| [4. Networking](#domain-4) | 15–20% | 10 | 3 | 8 / 13 (61%) | 🟡 |
| [5. Monitoring & Backup](#domain-5) | 10–15% | 14 | 5 | 7 / 13 (53%) | 🟡 |

**Totals:** 156 practice questions · 19 hands-on labs

**Legend:** 🟢 Strong (≥66%) · 🟡 Partial (33–65%) · 🔴 Low (<33%) — "Covered" = task has ≥1 practice question or ≥1 lab

> **Note:** Practice questions are those missed or not confidently answered correctly.

<!-- END COVERAGE DASHBOARD -->

<!-- BEGIN COVERAGE TABLE -->

<a id="domain-1"></a>
<details>
<summary><b>Domain 1: Manage Azure Identities and Governance (20–25%)</b> — 15 tasks · 14 Qs · 0 Labs</summary>

| Skill | Task | Qs | Labs |
| :--- | :--- | -: | -: |
| Manage Microsoft Entra users and groups | Create users and groups | 0 | 0 |
|  | Manage user and group properties | 0 | 0 |
|  | Manage licenses in Microsoft Entra ID | 0 | 0 |
|  | Manage external users | 0 | 0 |
|  | Configure self-service password reset (SSPR) | 1 | 0 |
| Manage access to Azure resources | Manage built-in Azure roles | 0 | 0 |
|  | Assign roles at different scopes | 0 | 0 |
|  | Interpret access assignments | 2 | 0 |
| Manage Azure subscriptions and governance | Implement and manage Azure Policy | 3 | 0 |
|  | Configure resource locks | 2 | 0 |
|  | Apply and manage tags on resources | 3 | 0 |
|  | Manage resource groups | 1 | 0 |
|  | Manage subscriptions | 1 | 0 |
|  | Manage costs by using alerts, budgets, and Azure Advisor recommendations | 1 | 0 |
|  | Configure management groups | 0 | 0 |

</details>

<a id="domain-2"></a>
<details>
<summary><b>Domain 2: Implement and Manage Storage (15–20%)</b> — 17 tasks · 17 Qs · 5 Labs</summary>

| Skill | Task | Qs | Labs |
| :--- | :--- | -: | -: |
| Configure access to storage | Configure Azure Storage firewalls and virtual networks | 2 | 0 |
|  | Create and use shared access signature (SAS) tokens | 4 | 0 |
|  | Configure stored access policies | 1 | 0 |
|  | Manage access keys | 3 | 0 |
|  | Configure identity-based access for Azure Files | 1 | 0 |
| Configure and manage storage accounts | Create and configure storage accounts | 0 | 0 |
|  | Configure Azure Storage redundancy | 1 | 0 |
|  | Configure object replication | 1 | 1 |
|  | Configure storage account encryption | 0 | 0 |
|  | Manage data by using Azure Storage Explorer and AzCopy | 0 | 2 |
| Configure Azure Files and Azure Blob Storage | Create and configure a file share in Azure Storage | 0 | 0 |
|  | Create and configure a container in Blob Storage | 0 | 0 |
|  | Configure storage tiers | 0 | 0 |
|  | Configure soft delete for blobs and containers | 0 | 0 |
|  | Configure snapshots and soft delete for Azure Files | 1 | 0 |
|  | Configure blob lifecycle management | 2 | 1 |
|  | Configure blob versioning | 1 | 1 |

</details>

<a id="domain-3"></a>
<details>
<summary><b>Domain 3: Deploy and Manage Azure Compute Resources (20–25%)</b> — 24 tasks · 21 Qs · 6 Labs</summary>

| Skill | Task | Qs | Labs |
| :--- | :--- | -: | -: |
| Automate deployment of resources by using ARM templates or Bicep files | Interpret an Azure Resource Manager template or a Bicep file | 1 | 0 |
|  | Modify an existing Azure Resource Manager template | 1 | 0 |
|  | Modify an existing Bicep file | 1 | 0 |
|  | Deploy resources by using an ARM template or a Bicep file | 3 | 0 |
|  | Export a deployment as an ARM template or convert an ARM template to a Bicep file | 2 | 0 |
| Create and configure virtual machines | Create a virtual machine | 0 | 0 |
|  | Configure Azure Disk Encryption | 1 | 1 |
|  | Move a VM to another resource group, subscription, or region | 0 | 0 |
|  | Manage virtual machine sizes | 1 | 0 |
|  | Manage virtual machine disks | 0 | 0 |
|  | Deploy VMs to availability zones and availability sets | 0 | 0 |
|  | Deploy and configure an Azure Virtual Machine Scale Sets | 1 | 1 |
| Provision and manage containers in the Azure portal | Create and manage an Azure container registry | 1 | 0 |
|  | Provision a container by using Azure Container Instances | 0 | 0 |
|  | Provision a container by using Azure Container Apps | 0 | 0 |
|  | Manage sizing and scaling for containers, including Azure Container Instances and Azure Container Apps | 1 | 1 |
| Create and configure Azure App Service | Provision an App Service plan | 4 | 1 |
|  | Configure scaling for an App Service plan | 4 | 1 |
|  | Create an App Service | 2 | 0 |
|  | Configure certificates and TLS for an App Service | 0 | 0 |
|  | Map an existing custom DNS name to an App Service | 0 | 0 |
|  | Configure backup for an App Service | 0 | 0 |
|  | Configure networking settings for an App Service | 0 | 0 |
|  | Configure deployment slots for an App Service | 1 | 1 |

</details>

<a id="domain-4"></a>
<details>
<summary><b>Domain 4: Implement and Manage Virtual Networking (15–20%)</b> — 13 tasks · 10 Qs · 3 Labs</summary>

| Skill | Task | Qs | Labs |
| :--- | :--- | -: | -: |
| Configure and manage virtual networks in Azure | Create and configure virtual networks and subnets | 2 | 0 |
|  | Create and configure virtual network peering | 2 | 0 |
|  | Configure public IP addresses | 0 | 0 |
|  | Configure user-defined network routes | 0 | 0 |
|  | Troubleshoot network connectivity | 0 | 0 |
| Configure secure access to virtual networks | Create and configure NSGs and application security groups | 1 | 0 |
|  | Evaluate effective security rules in NSGs | 0 | 0 |
|  | Implement Azure Bastion | 0 | 0 |
|  | Configure service endpoints for Azure PaaS | 1 | 0 |
|  | Configure private endpoints for Azure PaaS | 1 | 1 |
| Configure name resolution and load balancing | Configure Azure DNS | 1 | 0 |
|  | Configure an internal or public load balancer | 1 | 1 |
|  | Troubleshoot load balancing | 2 | 1 |

</details>

<a id="domain-5"></a>
<details>
<summary><b>Domain 5: Monitor and Maintain Azure Resources (10–15%)</b> — 13 tasks · 14 Qs · 5 Labs</summary>

| Skill | Task | Qs | Labs |
| :--- | :--- | -: | -: |
| Monitor resources in Azure | Interpret metrics in Azure Monitor | 1 | 1 |
|  | Configure log settings in Azure Monitor | 1 | 0 |
|  | Query and analyze logs in Azure Monitor | 1 | 0 |
|  | Set up alert rules, action groups, and alert processing rules in Azure Monitor | 4 | 1 |
|  | Configure and interpret monitoring of VMs, storage accounts, and networks by using Azure Monitor Insights | 1 | 1 |
|  | Use Azure Network Watcher and Connection Monitor | 4 | 1 |
| Implement backup and recovery | Create a Recovery Services vault | 0 | 0 |
|  | Create an Azure Backup vault | 0 | 0 |
|  | Create and configure a backup policy | 0 | 0 |
|  | Perform backup and restore operations by using Azure Backup | 2 | 1 |
|  | Configure Azure Site Recovery for Azure resources | 0 | 0 |
|  | Perform a failover to a secondary region by using Site Recovery | 0 | 0 |
|  | Configure and interpret reports and alerts for backups | 0 | 0 |

</details>

<!-- END COVERAGE TABLE -->