# Practice Exam Questions - AZ-104

Accounts for questions missed or unsure about in the practice exams.

* [Manage Azure identities and governance](#manage-azure-identities-and-governance)
  * [Manage Microsoft Entra users and groups](#manage-microsoft-entra-users-and-groups)
    * [Configure Microsoft Entra SSPR For Specific Users](#configure-microsoft-entra-sspr-for-specific-users)
  * [Manage access to Azure resources](#manage-access-to-azure-resources)
    * [Retrieve the Catalog Identifier for Entitlement Management](#retrieve-the-catalog-identifier-for-entitlement-management)
    * [Missing role assignments after migration](#missing-role-assignments-after-migration)
    * [Interpret Role Assignments](#interpret-role-assignments)
  * [Manage Azure subscriptions and governance](#manage-azure-subscriptions-and-governance)
    * [Move subscription between management groups](#move-subscription-between-management-groups)
    * [Move Resources Between Resource Groups](#move-resources-between-resource-groups)
    * [Configure Azure Cost Center Tags and Cost Analysis](#configure-azure-cost-center-tags-and-cost-analysis)
    * [Lift resource locks using PowerShell](#lift-resource-locks-using-powershell)
    * [Implement resource locks](#implement-resource-locks)
    * [Append Tag Using PowerShell](#append-tag-using-powershell)
    * [Azure Policy Effects Verification](#azure-policy-effects-verification)
    * [Tagging Policy](#tagging-policy)
    * [Azure Policy Not Functioning](#azure-policy-not-functioning)
* [Implement and manage storage](#implement-and-manage-storage)
  * [Configure access to storage](#configure-access-to-storage)
    * [Configure AzCopy Authentication for Blob and File Storage](#configure-azcopy-authentication-for-blob-and-file-storage)
    * [Configure storage account network access](#configure-storage-account-network-access)
    * [Shared Access Signature (SAS) practices](#shared-access-signature-sas-practices)
    * [Provide least-privilege access to a report](#provide-least-privilege-access-to-a-report)
    * [Modify Stored Access Policy](#modify-stored-access-policy)
    * [Diagnose Storage Explorer Permission Errors](#diagnose-storage-explorer-permission-errors)
  * [Configure and manage storage accounts](#configure-and-manage-storage-accounts)
    * [Configure Object Replication Between Storage Accounts](#configure-object-replication-between-storage-accounts)
    * [Rotate compromised storage account keys](#rotate-compromised-storage-account-keys)
    * [Azure Storage Redundancy Recommendation](#azure-storage-redundancy-recommendation)
  * [Configure Azure Files and Azure Blob Storage](#configure-azure-files-and-azure-blob-storage)
    * [Configure Lifecycle Management Policy for Azure Storage](#configure-lifecycle-management-policy-for-azure-storage)
    * [Lifecycle Management Policy Configuration](#lifecycle-management-policy-configuration)
    * [Delete Soft-Deleted File Share](#delete-soft-deleted-file-share)
    * [Identify Blob Write Operations That Create New Versions](#identify-blob-write-operations-that-create-new-versions)
  * [Create and use shared access signature (SAS) tokens](#create-and-use-shared-access-signature-sas-tokens)
    * [SAS key configuration scenarios](#sas-key-configuration-scenarios)
* [Deploy and Manage Azure Compute Resources](#deploy-and-manage-azure-compute-resources)
  * [Automate deployment of resources by using ARM templates or Bicep files](#automate-deployment-of-resources-by-using-arm-templates-or-bicep-files)
    * [Export ARM Template](#export-arm-template)
  * [Create and configure virtual machines](#create-and-configure-virtual-machines)
    * [VM Resize Failure Cause](#vm-resize-failure-cause)
    * [Encrypt VM Disk With Key Vault](#encrypt-vm-disk-with-key-vault)
    * [Apply Change to VMSS OS and Data Disk Profile](#apply-change-to-vmss-os-and-data-disk-profile)
  * [Provision and manage containers in the Azure portal](#provision-and-manage-containers-in-the-azure-portal)
    * [Configure Scaling Rules in Azure Container Apps](#configure-scaling-rules-in-azure-container-apps)
  * [Create and configure Azure App Service](#create-and-configure-azure-app-service)
    * [Resolve Azure App Service Pricing Tier for Runtime Requirements](#resolve-azure-app-service-pricing-tier-for-runtime-requirements)
    * [Configure Azure App Service Plan for Website Hosting](#configure-azure-app-service-plan-for-website-hosting)
    * [Resolve Azure App Service Pricing Tier for Runtime Requirements](#resolve-azure-app-service-pricing-tier-for-runtime-requirements-1)
    * [Resolve Azure App Service Pricing Tier for Runtime Requirements](#resolve-azure-app-service-pricing-tier-for-runtime-requirements-2)
    * [Prepare Azure App Service for Web App Republication](#prepare-azure-app-service-for-web-app-republication)
  * [Automate deployment of resources by using Azure Resource Manager (ARM) templates or Bicep files](#automate-deployment-of-resources-by-using-azure-resource-manager-arm-templates-or-bicep-files)
    * [Convert Array to Object](#convert-array-to-object)
    * [Resource dependencies in Bicep](#resource-dependencies-in-bicep)
* [Implement and manage virtual networking](#implement-and-manage-virtual-networking)
  * [Configure secure access to virtual networks](#configure-secure-access-to-virtual-networks)
    * [Configure Private Link Service Source IP](#configure-private-link-service-source-ip)
  * [Configure name resolution and load balancing](#configure-name-resolution-and-load-balancing)
    * [IMDS Load Balancer Metadata Error](#imds-load-balancer-metadata-error)
    * [Configure DNS Records for App Service](#configure-dns-records-for-app-service)
    * [Diagnose Internal Load Balancer Hairpin Traffic Failure](#diagnose-internal-load-balancer-hairpin-traffic-failure)
    * [Configure Standard Load Balancer Outbound Traffic and IP Allocation](#configure-standard-load-balancer-outbound-traffic-and-ip-allocation)
* [Monitor and maintain Azure resources](#monitor-and-maintain-azure-resources)
  * [Monitor resources in Azure](#monitor-resources-in-azure)
    * [Capture SFTP Packets with Network Watcher](#capture-sftp-packets-with-network-watcher)
    * [Storage Insights Overview](#storage-insights-overview)
    * [Configure Azure Monitor Alert for Database CPU Usage](#configure-azure-monitor-alert-for-database-cpu-usage)
    * [Load Balancer Metrics Batch API](#load-balancer-metrics-batch-api)
    * [Enable Boot Diagnostics for Azure Virtual Machines](#enable-boot-diagnostics-for-azure-virtual-machines)
    * [Diagnose Network Watcher Tool for Web Server Packet Flow](#diagnose-network-watcher-tool-for-web-server-packet-flow)
    * [Configure Azure Monitor Alert Notification Rate Limits](#configure-azure-monitor-alert-notification-rate-limits)
  * [Implement backup and recovery](#implement-backup-and-recovery)
    * [Recover Configuration File from Azure VM Backup](#recover-configuration-file-from-azure-vm-backup)
    * [Recover Azure VM from Deleted Backup](#recover-azure-vm-from-deleted-backup)

---

## Manage Azure identities and governance

### Manage Microsoft Entra users and groups

#### Configure Microsoft Entra SSPR For Specific Users

**Domain:** Manage Azure identities and governance
**Skill:** Manage Microsoft Entra users and groups
**Task:** Configure self-service password reset (SSPR)

You are asked to configure Self-Service Password Reset (SSPR) for a subset of users in your organization.

You need to configure SSPR to meet the following requirements:

* You should be able to add and remove users who are allowed to use SSPR to reset their passwords.
* The users should provide one additional piece of personal information before they are allowed to reset their passwords.

Which four actions should you perform in sequence to meet the goal? To answer, move the appropriate actions from the list of possible actions to the answer area and arrange them in order.

**Available options:**

* Enable SSPR with the All option.
* Add users to the SSPR list of users.
* Register an authentication method for SSPR.
* Create a Microsoft Entra group and add users to the group.
* Select the Microsoft Entra group for which you want to allow SSPR.
* Enable SSPR with the Selected option.

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-05-33-53.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Your Answer vs. The Correct Sequence**

**Your selected order:**

1. Create a Microsoft Entra group and add users to the group ✓
2. Select the Microsoft Entra group for which you want to allow SSPR ✗
3. Register an authentication method for SSPR ✗
4. Enable SSPR with the Selected option ✗

**The Issue:**

The main problem is with **steps 2-4**. You're trying to select a group for SSPR (step 2) before SSPR is even enabled (step 4). Additionally, you should configure the authentication method requirements before enabling SSPR.

**The Correct Order Should Be:**

1. **Create a Microsoft Entra group and add users to the group** ✓
   - This satisfies the requirement to "add and remove users" by managing group membership

2. **Register an authentication method for SSPR**
   - This configures "one additional piece of personal information" that users must provide (like security questions, phone, email, etc.)

3. **Enable SSPR with the Selected option**
   - You use "Selected" (not "All") because you only want a subset of users to have SSPR access
   - This must be done before you can assign groups to SSPR

4. **Select the Microsoft Entra group for which you want to allow SSPR**
   - Now you can specify which group(s) should have SSPR enabled
   - Users can be added/removed from SSPR by managing group membership

**Key Takeaway:**

You must **configure the authentication requirements and enable SSPR** before you can **assign it to specific groups**. Think of it as: configure what → enable it → specify who gets it.

</details>

---

### Manage access to Azure resources

#### Retrieve the Catalog Identifier for Entitlement Management

**Domain:** Manage Azure identities and governance
**Skill:** Manage access to Azure resources
**Task:** Manage identity and access lifecycle using Microsoft Entra ID Governance

Your organization is using Microsoft Entra ID Governance. You are the Azure administrator in the organization.

You are using Microsoft Graph PowerShell to provide and manage identity and access lifecycle at scale for all users and groups within the organization.

You have a group named Sales. You need to grant users in the Sales group the adequate level of access using entitlement management. Your organization's policy dictates the use of the general catalog.

What should you do first?

A. Retrieve the catalog resources.  
B. Retrieve the resource roles assigned to the catalog.  
C. Retrieve the catalog identifier.  
D. Add the Sales group to the catalog.  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-08-06-34-08.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is correct (C)**

In this scenario, you are essentially managing access to resources in your organization. You are using Microsoft Entra ID entitlement management with Microsoft Graph PowerShell v1.0. Since the users and group already exist, you need to initiate the process by getting the catalog identifier.

An access package is a collection of resources that is governed by policies. Access packages are defined in containers called catalogs. However, to add resources to the catalog, you will require details of the catalog identifier. Thus, you should retrieve the catalog identifier as the initial step by using the following command:

```powershell
Get-MgIdentityGovernanceEntitlementManagementCatalog -Filter "DisplayName eq 'General'" | Format-List
```

**Why the other options are incorrect**

* **A. Retrieve the catalog resources**: You should get the catalog resources as a later step. To be able to do this, you will require the identifier that is assigned to the group resource in the catalog.
* **B. Retrieve the resource roles assigned to the catalog**: This should be done at a later stage. The access package assigns users to the roles of a resource, which in the case of a group used in an access package is typically the member role. You will need this role when you add a resource role to the access package.
* **D. Add the Sales group to the catalog**: This is the second step. To add the group to the catalog, you need the properties of a group object, which represents the resource.

**Key takeaway**

When working with Microsoft Entra ID entitlement management and access packages, the **first step is always to retrieve the catalog identifier**. This identifier is required before you can add resources, assign roles, or add groups to the access package.

In Microsoft Entra ID entitlement management, a **catalog** is the container that holds resources (such as groups, applications, and SharePoint sites) that can be granted through access packages. The **General catalog** is the default catalog in every tenant and is typically used for organization-wide resources that many users may request. Administrators add resources to the catalog, define the available resource roles, bundle them into **access packages**, and then apply policies that control who can request access and how it is approved and reviewed. When automating this process with Microsoft Graph PowerShell, the **catalog identifier must be retrieved first**, because most entitlement-management operations require the catalog ID before resources, access packages, or policies can be created or managed.

**References**

* [What is entitlement management?](https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-overview)
* [Tutorial: Manage access to resources in Microsoft Entra entitlement management using Microsoft Graph PowerShell](https://learn.microsoft.com/en-us/powershell/microsoftgraph/tutorial-entitlement-management?view=graph-powershell-1.0)

</details>

---

#### Missing role assignments after migration

**Domain:** Manage Azure Identities and Governance
**Skill:** Manage access to Azure resources
**Task:** Interpret access assignments

You manage a number of Azure subscriptions for a global organization and have ownership of all of the subscriptions. You have been asked to use PowerShell to migrate the resources on an existing subscription called sub010 to a new subscription called sub020. After the migration, you find that all the Azure role assignments for individual resources have been orphaned on the virtual machines (VMs) but are still in place for the Resource Groups.

You need to find what has caused the missing role assignments to ensure that it is mitigated in future migrations.

What should you identify as the cause?

A. The Azure portal was not used for the migration.  
B. The migration was between subscriptions.  
C. The user account moving the resources to sub020 did not have the relevant permissions.  
D. There was a network outage during the migration.  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-10-04-49-49.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

The migration was between subscriptions, and therefore, any roles assigned directly to the resources were not moved. All role assignments that are directly assigned to a resource or a child resource are not fully migrated, but instead orphaned in the destination subscription. Once the move has been completed, all Azure role assignments need to be re-created and the orphaned role assignments will be removed automatically.

It is not necessary to have used the Azure Portal for the migration. In this scenario, you were using PowerShell to complete the migration of resources from sub010 to sub020, but it is irrelevant if the task is done via PowerShell or via the Azure portal, the outcome would still be orphaned role assignments directly assigned to resources.

The user account moving the resources to sub020 did have the relevant permissions. The scenario states that you are the owner of all the subscriptions and you therefore have the highest level of permissions.

There was not a network outage during the migration. Any type of network outage would cause the entire migration to potentially stop, rather than just affecting the Azure role assignment.

<img src='.img/2026-03-10-04-54-38.png' width=600>

References

- [Transfer an Azure subscription to a different Microsoft Entra directory](https://learn.microsoft.com/en-us/azure/role-based-access-control/transfer-subscription)
- [Move Azure resources to a new resource group or subscription](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/move-resource-group-and-subscription?tabs=azure-cli)

</details>

---

#### Interpret Role Assignments

**Domain:** Manage Azure identities and governance
**Skill:** Manage access to Azure resources
**Task:** Interpret access assignments

You are tasked with assigning Azure role-based access control (Azure RBAC) roles to users in your company.

You are trying to interpret access assignments for UserA. You want to validate the role assignments for UserA scoped to the groups of which UserA is a member.

You need to complete the Azure CLI command shown below.

Which cmdlets should you use? To answer, complete the commands by selecting the correct parts from the drop-down menus.

```bash
az role assignment ___[1]___ ___[2]___ --assignee UserA@myorg.com\ \
  --output json --query '[].{principalName:principalName, \
  roleDefinitionName:roleDefinitionName, scope:scope}'
```

Drop-Down Options:

<!-- Dropdown options not yet provided. Paste screenshots of each expanded drop-down to populate. -->

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-09-03-48-14.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

Azure role-based access control (Azure RBAC) is the authorization system you use to manage access to Azure resources. To determine what resources users, groups, service principals, or managed identities have access to, you need to list their role assignments. You could further adjust access control by updating the role assignments, or create new ones. In this scenario, you are using the Azure CLI to interpret access assignments for a user named UserA in your company. Additionally, you need to retrieve information on the extra assignments to the groups of which UserA is a member. You should complete the CLI command as follows:

```bash
az role assignment list --include-groups --assignee UserA@myorg.com \
  --output json --query '[].{principalName:principalName, \
  roleDefinitionName:roleDefinitionName, scope:scope}'
```

You should use the `list` command and the `--include-groups` parameter. The `list` command lists the role assignments for the <UserA@myorg.com> user. The parameter retrieves information on the extra assignments to the groups of which UserA is a member.

You should not use the `create` command. You can use the `create` command when you want to create a new role assignment for a user, group, or service principal.

You should not use the `list-changelogs` command. You should use the `list-changelogs` command when you want to retrieve and exhibit the changelogs for role assignments.

You should not use the `update` command. You should use the `update` command when you want to update an existing role assignment for a user, group, or service principal.

You should not use the `--all` parameter. You should use this parameter when you want to retrieve and display all assignments under the current subscription. It is turned off by default.

You should not use the `--include-inherited` parameter. You should use this parameter when you want to retrieve and display all assignments including assignments applied on parent scopes.

You should not use the `--include-classic-administrators` parameter. You should use this parameter when you want to retrieve and exhibit all default role assignments for subscription classic administrators, or co-admins.

</details>

---

### Manage Azure subscriptions and governance

#### Move subscription between management groups

**Domain:** Manage Azure Identities and Governance
**Skill:** Manage Azure subscriptions and governance
**Task:** Manage subscriptions

Your company creates multiple management groups under your Root management Group. You are re-organizing the management groups and want to move all resources for the Sales and Marketing management groups under the Marketing management group. Once finished, you plan to delete the Sales management group.

You need to move the subscription named `SalesSub` to the Marketing management group.

Which two PowerShell cmdlets should you use? Each correct answer presents part of the solution.

A. `New-AzManagementGroupSubscription`  
B. `Update-AzManagementGroup`  
C. `Remove-AzManagementGroup`  
D. `Remove-AzManagementGroupSubscription`  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-10-05-02-26.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

Moving an existing subscription to another management Group implicitly means that the subscription already has a management group. To perform this action, you should execute the following two PowerShell cmdlets:

1. `New-AzManagementGroupSubscription`. This cmdlet is used to add a subscription to a specified management group. After removing the subscription from the Sales management group, you will use this cmdlet to add it to the Marketing management group.

2. `Remove-AzManagementGroupSubscription`. This cmdlet is used to remove a subscription from its current management group. Since you need to move the subscription named `SalesSub` from the Sales management group, you first need to remove it from its current group.

You should not use `Update-AzManagementGroup`. This is used to update supported parameters, such as the management group display name or change the management group parent. It is not used for moving subscriptions between management groups.

You should not use `Remove-AzManagementGroup`. This cmdlet is used to delete a management group. While you plan to delete the Sales management group eventually, this cmdlet is not used for moving subscriptions between management groups.

References

- Manage your Azure subscriptions at scale with management groups
- Remove-AzManagementGroupSubscription
- New-AzManagementGroupSubscription
- Remove-AzManagementGroup
- Update-AzManagementGroup

</details>

---

#### Move Resources Between Resource Groups

**Domain:** Manage Azure identities and governance
**Skill:** Manage Azure subscriptions and governance
**Task:** Manage resource groups

You deploy an application in a resource group named App-RG01 in your Azure subscription.

App-RG01 contains the following components:

- Two App Services, each with a free App Service managed Secure Sockets Layer (SSL) certificate
- A peered virtual network (VNet)
- Redis cache deployed in the VNet
- A Standard Load Balancer

You need to move all resources in App-RG01 to a new resource group named App-RG02. For each of the following statements, select Yes if the statement is true. Otherwise, select No.

| STATEMENT | YES | NO |
|-----------|-----|----|
| You need to delete the SSL certificate from each App Service before moving it to the new resource group. | ☐ | ☐ |
| You can move the Standard Load Balancer across two Azure subscriptions. | ☐ | ☐ |
| You need to disable the peer before moving the VNet. | ☐ | ☐ |
| You can move the VNet within the same subscription. | ☐ | ☐ |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-09-04-14-38.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

You need to delete the Secure Sockets Layer (SSL) certificate from each App Service before moving it to the new resource group. You cannot move an App Service with an SSL certificate configured since in our use-case scenario, you are using the free App Service managed Secure Sockets Layer (SSL) certificate. You need to delete the certificate first, move the App Service, and then upload the certificate again.

You cannot move the Standard Load Balancer across two Azure subscriptions. Within a single Azure subscription, Resource Group move operations for both Standard Load Balancer and standard Public IP are allowed. But for a Standard Load Balancer, move operations across Azure Subscriptions are not allowed.

You need to disable the peer before moving the VNet. When you want to move a VNet with a peer configured, you need to disable it before moving the VNet. When you move a VNet, you need to move all of its dependent resources.

You can move the VNet within the same subscription. When you want to move a VNet, you also need to move all of its dependent resources. In this case, you also need to move the Redis cache, which can be moved only within the same subscription. Because you want to move the resources from App-RG01 to App-RG02, which is in the same subscription, you can move the VNet with no problem.

<img src='.img/2026-03-09-04-16-58.png' width=600>

<img src='.img/2026-03-09-04-18-10.png' width=600>

<img src='.img/2026-03-09-04-19-07.png' width=600>

<img src='.img/2026-03-09-04-20-30.png' width=600>

References

* [Move resources to a new resource group or subscription](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/move-resource-group-and-subscription?tabs=azure-cli)
* [Move networking resources to new resource group or subscription](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/move-limitations/networking-move-limitations)
* [Azure Load Balancer SKUs](https://learn.microsoft.com/en-us/azure/load-balancer/skus)

</details>

---

#### Configure Azure Cost Center Tags and Cost Analysis

**Domain:** Manage Azure identities and governance
**Skill:** Manage Azure subscriptions and governance
**Task:**

- Apply and manage tags on resources
- Manage costs by using alerts, budgets, and Azure Advisor recommendations

Your company has an Azure Subscription with several resources deployed. The subscription is managed by a Cloud Service Provider.

The accounting department is currently granted the billing reader role, so they are able to see cost-related information. They need to get a better understanding of the costs so they can assign them to the correct cost center.

You need to provide cost center information. Your solution should minimize administrative effort.

What two actions should you perform? Each correct answer presents part of the solution.

A. Instruct the accounting department to use the Azure Account Center.  
B. Create a tag named CostCenter and assign it to each resource group.  
C. Instruct the accounting department to use the Cost Analysis blade in the subscription panel.  
D. Create a tag named CostCenter and assign it to each resource.  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-06-20-49.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

Looking at your selected answers, I can help you understand what went wrong.

**Your Selected Answers:**

1. ✗ Create a tag named CostCenter and assign it to each **resource group**
2. ✓ Instruct the accounting department to use the Cost Analysis blade in the subscription panel

**The Problem with Your Answer:**

You got **one correct** (Cost Analysis), but your tagging strategy is at the **wrong level of granularity**.

**Why Resource Group Tagging is Insufficient:**

**Resource group-level tags** can cause issues when:

- Multiple resources in the same resource group belong to **different cost centers**
- You need **granular cost allocation** at the resource level
- Resources are moved between resource groups

For example, if RG1 contains:

- 5 VMs for Cost Center A
- 3 VMs for Cost Center B

Tagging the resource group only gives you one cost center value, preventing accurate cost allocation.

**The Correct Answers Should Be:**

1. **Create a tag named CostCenter and assign it to each resource** ✓
   - Provides granular cost tracking at the resource level
   - Each resource can be assigned to its specific cost center
   - More accurate cost allocation

2. **Instruct the accounting department to use the Cost Analysis blade in the subscription panel** ✓
   - This is the correct tool for CSP-managed subscriptions
   - Azure Account Center is NOT available for CSP subscriptions
   - Cost Analysis can filter and group costs by tags

**Why "Azure Account Center" is Wrong:**

The **Azure Account Center** is not accessible in **Cloud Service Provider (CSP) managed subscriptions**. Only direct Enterprise Agreement (EA) or other subscription types have access to it.

**Key Takeaway:**

For cost center allocation:

- Tag at the **resource level** (not resource group level) for accurate, granular tracking
- Use **Cost Analysis** (not Account Center) for CSP subscriptions
- Cost Analysis allows filtering and grouping by tags to assign costs to cost centers

</details>

---

#### Lift resource locks using PowerShell

**Domain:** Manage Azure Identities and Governance
**Skill:** Manage Azure subscriptions and governance
**Task:** Configure resource locks

You have an Azure resource group named RG1. RG1 contains 12 virtual machines (VMs) that run Windows Server or Linux.

You need to use Azure Cloud Shell to lift any resource locks that were applied to the VMs.

How should you complete the Azure PowerShell command? To answer, select the appropriate options from the drop-down menus.

```powershell
$rg = "rg1"
___[1]___ | ___[2]___ ResourceGroupName -eq "$rg" | ___[3]___ -Force
```

<!-- Dropdown options not yet provided. Paste screenshots of each expanded drop-down to populate. -->

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-10-04-08-46.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

You should use the following command:

```powershell
$rg = "rg1"
Get-AzResourceLock |
Where-Object ResourceGroupName -eq "$rg" |
Remove-AzResourceLock -Force
```

To programmatically lift resource locks in Azure, start with the `Get-AzResourceLock` command to retrieve all resource locks in your current subscription context. You can add a `Where-Object` filter expression to retrieve only locks from a particular resource group.

Next, you can take advantage of the PowerShell pipeline by piping your results to the `Remove-AzResourceLock` cmdlet to actually remove the locks. The `-Force` switch parameter forces the command to run without asking for user confirmation.

You should not use the `Get-AzResource` or `Remove-AzResource` cmdlets because doing so requires far more PowerShell code than is shown in the scenario, and you only need to retrieve the locked resources from a specific resource group.

You should not use the `Select-Object` cmdlet because it filters at the property level, and not the row level, and would therefore not restrict output to locked resources within a single resource group.

</details>

---

#### Implement resource locks

**Domain:** Manage Azure Identities and Governance
**Skill:** Manage Azure subscriptions and governance
**Task:** Configure resource locks

Your Azure subscription has resource groups for production and testing environments.

A user member of the RegularUsers group accidentally deletes the testing resource groups named TST01-RG and TST02-RG. TST01-RG had a storage account named STA01 configured. TST02-RG had an App Service named APP01 configured.

You recover the affected resource from the backups. You then decide to implement resource locks so this will not happen again. Your manager would like the following points implemented in order to prevent this type of incident from happening again:

- No resources can be deleted by accident again.
- All resource types should work correctly after implementing the resource locks.
- Any new resource that is added to the subscription should also be protected against accidental deletion.
- The solution should require the least administrative effort.

You need to implement a solution that fulfils all the requirements above.

What should you do?

A. Configure a Read-only lock on your subscription.  
B. Configure a Read-only lock on TST01-RG and TST02-RG.  
C. Configure a Delete lock on TST01-RG and TST02-RG.  
D. Configure a Delete lock on your subscription.  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-10-04-17-21.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

You should configure a Delete lock on your subscription. You can configure locks at the subscription, resource group, and resource levels. Delete or CanNotDelete lock prevents any resource from being deleted by accident. You still can make modifications to the resources, but you get an error if you try to remove a resource with a Delete lock. When you apply a lock on a container, like a subscription or a resource group, all children inside the container are also affected by the resource lock. This way you ensure that no other resource is deleted by accident without affecting the normal operation of the resources.

You should not configure a Read-only lock on your subscription. A Read-only or ReadOnly lock prevents users from making modifications to the attributes of the resource, although they can still make modifications to the data of the resource itself. Depending on the resource type, applying a Read-only lock may lead to unpredictable behavior. When you configure a Read-only lock in a resource, you are blocking the ability to perform any operation other than read access. There are some resources that perform operations other than reading operations when you try to perform actions that initially could seem to be read-only. For example, if you set a Read-only lock on a storage account, you are preventing users from listing the access keys of the storage account. This is because the service uses a POST request internally to list the keys because these keys are also available for writing operations.

You should not configure a Delete lock on TST01-RG and TST02-RG. This configuration protects both resource groups against accidental deletions, but it does not meet the objective of protecting all resources in the subscription, and it requires more administrative effort. Setting the Delete lock at the subscription level is more efficient and meets all the requirements.

You should not configure a Read-only lock on TST01-RG and TST02-RG. This configuration does not meet the least administrative effort requirement or the requirement that all resource types should work correctly after implementing the lock.

</details>

---

#### Append Tag Using PowerShell

**Domain:** Manage Azure identities and governance
**Skill:** Manage Azure subscriptions and governance
**Task:** Apply and manage tags on resources

You use taxonomic tags to logically organize resources and to make billing reporting easier.

You use Azure PowerShell to append an additional tag on a storage account named corptorage99. The code is as follows:

```powershell
$r = Get-AzResource -ResourceName "corptorage99" -ResourceGroupName "prod-rg"
Set-AzResource -Tag @{Dept="IT"} -ResourceId $r.ResourceId -Force
```

The code returns unexpected results.

You need to append the additional tag as quickly as possible.

What should you do?

A. Edit the script to call the Add() method after getting the resource to append the new tag.  
B. Assign the Enforce tag and its value Azure Policy to the resource group.  
C. Deploy the tag by using an Azure Resource Manager (ARM) template.  
D. Refactor the code by using the Azure Command-Line Interface (CLI).  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-09-04-08-19.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

You should edit the script to call the Add() method after getting the resource to append the new tag as shown in the second line of this refactored Azure PowerShell code:

```powershell
$r = Get-AzResource -ResourceName "corptorage99" -ResourceGroupName "prod-rg"
$r.Tags.Add("Dept", "IT")
Set-AzResource -Tag $r.Tags -ResourceId $r.ResourceId -Force
```

Unless you call the Add() method, the Set-AzResource cmdlet will overwrite any existing taxonomic tags on the resource. The Add() method preserves existing tags and includes one or more tags to the resource tag list.

You should not deploy the tag by using an Azure Resource Manager (ARM) template. Doing so is unnecessary in this case because the Azure PowerShell is mostly complete as-is. Furthermore, you must find the solution as quickly as possible.

You should not assign the Enforce tag and its value Azure Policy to the resource group. Azure Policy is a governance feature that helps businesses enforce compliance in resource creation. In this case, the solution involves too much administrative overhead to be a viable option. Moreover, the scenario makes no mention of the need for governance policy in specific terms.

You should not refactor the code by using the Azure Command-Line Interface (CLI). Either Azure PowerShell or Azure CLI can be used to institute this solution. It makes no sense to change the development language, since you have already completed most of the code in PowerShell.

<img src='.img/2026-03-09-04-11-46.png' width=600>

</details>

---

#### Azure Policy Effects Verification

**Domain:** Manage Azure identities and governance
**Skill:** Manage Azure subscriptions and governance
**Task:** Implement and manage Azure Policy

Your company requires all resources deployed in Azure to be assigned to a cost center.

You use a tag named CostCenter to assign each resource to the correct cost center. This tag has a set of valid values assigned.

Some of the resources deployed in your subscription already have a value assigned to the CostCenter tag.

You decide to deploy a subscription policy to verify that all resources in the subscription have a valid value assigned.

For each of the following statements, select Yes if the statement is true. Otherwise, select No.

| Statement | Yes | No |
|----------|-----|----|
| The Deny effect is evaluated first. | ☐ | ☐ |
| The Append effect modifies the value of an existing field in a resource. | ☐ | ☐ |
| The Audit effect will create a warning event in the activity log for non-compliant resources. | ☐ | ☐ |
| The DeployIfNotExists effect is only evaluated if the request executed by the Resource Provider returns a success status code. | ☐ | ☐ |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-09-03-54-46.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

The Deny effect is not evaluated first. When a policy is evaluated, the Disabled effect is always evaluated first to decide whether the rule should be evaluated afterwards. The correct order of evaluation of the policy effects is: Disabled, Append, Deny and Audit.

The Append effect does not modify the value of an existing field in a resource. The Append effect adds additional fields during the creation or update of a resource. If the field already exists in the resource and the values in the resource and the policy are different, then the policy acts as a deny and rejects the request.

The Audit effect will create a warning event in the activity log for non-compliant resources. The audit effect is evaluated last, before the Resource Provider handles a create or update request. You typically use the audit effect when you want to track non-compliant resources.

The DeployIfNotExists effect is only evaluated if the request executed by the Resource Provider returns a success status code. Once the effect has been evaluated, it is triggered if the resource does not exist or if the resource defined by ExistenceCondition is evaluated as false.

<img src='.img/2026-03-09-03-56-52.png' width=600>

<img src='.img/2026-03-09-03-58-31.png' width=600>

<img src='.img/2026-03-09-04-01-30.png' width=600>

<img src='.img/2026-03-09-04-02-34.png' width=600>

References

* [Understand Azure Policy effects](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics)
* [Azure Policy Samples](https://learn.microsoft.com/en-us/azure/governance/policy/samples/)

</details>

---

#### Tagging Policy

**Domain:** Manage Azure identities and governance
**Skill:** Manage Azure subscriptions and governance
**Task:**

- Implement and manage Azure Policy
- Apply and manage tags on resources

You are developing a policy that will deny the creation of any resource that does not have an environment tag with a value of either dev, qa, or prod.

You need to ensure that only resources that support tagging are checked by the policy.

How should you configure the policy? To answer, complete the JSON template by selecting the correct options from the drop-down menus.

```json
{
  "properties": {
    "displayName": "Tagging Policy",
    "policyType": "Custom",
    "mode": "___[1]___",
    "policyRule": {
      "if": {
        "field": "___[2]___",
        "___[3]___": ["dev", "qa", "prod"]
      },
      "then": {
        "effect": "___[4]___"
      }
    }
  },
  "name": "policyDefinition01",
  "type": "Microsoft.Authorization/policyDefinitions"
}
```

Drop-Down Options:

| Blank | Options |
|-------|---------|
| [1] | Indexed / All / Supported |
| [2] | [tags[Environment]] / Environment / tag:Environment |
| [3] | notIn / eq / notContains |
| [4] | deny / audit / append |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-03-04-10-10.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

The should configure the policy as follows:

```json
{
  "properties": {
    "displayName": "Tagging Policy",
    "policyType": "Custom",
    "mode": "Indexed",
    "policyRule": {
      "if": {
        "field": "[tags[Environment]]",
        "notIn": ["dev, qa, prod"]
      },
      "then": {
        "effect": "deny"
      }
    }
  },
  "name": "policyDefinition01",
  "type": "Microsoft.Authorization/policyDefinitions"
}
```

You should use Indexed for the mode property. Indexed policies check whether a resource supports a feature before it checks for it. Selecting All would try to apply the policy to all resources even if the resource does not support tagging. Supported is not a valid option for the mode property.

You should use [tags[Environment]] as the field value. You should not select Environment because there is no field for Azure resources named Environment. You should not select tag:Environment because tags are an array.

You should use notIn for the check condition. If the tag value for Environment is not in dev, qa, and prod, you want to deny the creation of the resource. You should not select eq or notContains. Neither can be applied to check for an array value. They will check for string values.

You should use deny for the effect property. The "then" block specifies the effect to apply if the policy rule block evaluates to false. In this case, you want to deny creation. You should not use audit because that would allow creation and generate a compliance log entry. You should not use append because it would add an empty Environment tag to the resource and not set a value equal to either dev, qa, or prod.

</details>

---

#### Azure Policy Not Functioning

**Domain:** Manage Azure identities and governance
**Skill:** Manage Azure subscriptions and governance
**Task:** Implement and manage Azure Policy

A company has an existing on-premises environment and a newly created Azure subscription. You need to start testing cloud features and services with a view to eventually migrating the company environment to the Cloud. You have been given Global Administrator rights and the Scheduled Patching Contributor role on the subscription level, and you need to test Azure Policy first.

You have downloaded version 2.62 of the Azure Command-Line-Interface (CLI) to configure new policies, but you find that the Azure Policies you are creating are not working with your subscription.

You need to find the cause of this problem.

What is causing the Azure Policy to not function with your subscription when using the Azure CLI?

A. Your version of the Azure CLI needs updating.  
B. You do not have the relevant role assignment to manage Azure Policy.  
C. You do not have the relevant access to the subscription.  
D. You have not registered the Azure Policy Insights resource provider.  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-03-04-46-56.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

The cause of the issue is that you have not registered the Azure Policy Insights resource provider. Azure Policy requires the Azure Policy Insights resource provider to be registered in your subscription to function properly. If this resource provider is not registered, the policies you create will not work as expected. To resolve this issue, you can register the resource provider using the Azure CLI with the following command:

```powershell
az provider register --namespace 'Microsoft.PolicyInsights'
```

Microsoft.PolicyInsights backs the insights and compliance side of Azure Policy, including:

Policy compliance state

Policy evaluation results

Remediation tasks

Policy events and historical data

Policy state queries via REST/CLI

When you run commands such as:

az policy state list

az policy event list

az policy remediation create

those operations rely on this provider.

The cause of the issue is not that you do not have the relevant access to the subscription. You have been given Global Administrator rights, which is sufficient to manage Azure Policy.

The cause of the issue is not that your version of the Azure CLI needs updating. While keeping the Azure CLI updated is important, version 2.62 is recent enough to support Azure Policy commands.

The cause of the issue is not that you do not have the relevant role assignment to manage Azure Policy. The Global Administrator role provides the necessary permissions to manage Azure Policy. By registering the Azure Policy Insights resource provider, you should be able to test and use Azure Policy successfully.

References

[Azure Policy overview - Azure RBAC permissions in Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-rbac-permissions-in-azure-policy)

</details>

---

## Implement and manage storage

### Configure access to storage

#### Configure AzCopy Authentication for Blob and File Storage

**Domain:** Implement and manage storage
**Skill:** Configure access to storage
**Task:**

- Create and use shared access signature (SAS) tokens
- Manage access keys
- Configure identity-based access for Azure Files

You create a new storage account named DevStore for Azure Blob Storage and Azure File Storage. You plan to use AzCopy to copy data from blob storage and file storage in other storage accounts to DevStore. You have access to the storage account access keys for the source storage accounts and for DevStore. You also have valid Microsoft Entra user accounts and shared access signatures (SAS) with access to the source data.

You need to identify the authorization methods you can use to copy the data to DevStore.

Which authorization methods can you use to copy each storage type? To answer, select the appropriate options from the drop-down menus.

Blob storage: $PLACEHOLDER$

File storage: $PLACEHOLDER$

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-05-58-51.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

Looking at your answer, I can explain why you got the File storage authorization wrong.

**Your Answer:**

- **Blob storage**: Microsoft Entra ID, access keys, and SAS ✓
- **File storage**: Microsoft Entra ID only ✗

**The Problem:**

You selected **Microsoft Entra ID only** for File storage, which is incorrect because:

**1. Microsoft Entra ID has LIMITED/NO support for Azure Files with AzCopy:**

While Microsoft Entra ID (Azure AD) works excellently for **Blob storage** with AzCopy, it has **very limited or no support** for **Azure Files** (File shares).

AzCopy's Azure AD authentication is primarily designed for:

- ✓ Blob storage
- ✓ Azure Data Lake Storage Gen2
- ✗ Azure Files (not supported or very limited)

**2. You Excluded Valid Methods:**

The scenario explicitly states:
> "You have access to the storage account access keys for the source storage accounts and for DevStore. You also have valid Microsoft Entra user accounts and **shared access signatures (SAS)**."

For Azure Files, AzCopy **DOES support**:

- ✓ **SAS tokens** - Fully supported and commonly used
- ✓ **Access keys** - Supported
- ✗ **Microsoft Entra ID** - Not supported/limited

**The Correct Answer Should Be:**

- **Blob storage**: Microsoft Entra ID, access keys, and SAS ✓
- **File storage**: **Access keys and SAS** (or possibly just SAS)

**Why This Matters:**

The critical distinction:

| Storage Type | Entra ID | Access Keys | SAS |
|-------------|----------|-------------|-----|
| **Blob Storage** | ✓ Yes | ✓ Yes | ✓ Yes |
| **File Storage** | ✗ Limited/No | ✓ Yes | ✓ Yes |

**Key Detail: "Commands target only the file share or the account":**

This hint suggests:

- **File share level**: Use SAS tokens (most common)
- **Account level**: Use access keys

Both are valid for Azure Files, but **not** Microsoft Entra ID.

**AzCopy Command Examples:**

**For Blob (with Entra ID):**

```bash
azcopy login
azcopy copy "source" "https://devstore.blob.core.windows.net/container"
```

**For File Storage (with SAS):**

```bash
azcopy copy "source" "https://devstore.file.core.windows.net/share?<SAS-token>"
```

**For File Storage (with Account Key):**

```bash
# Set environment variable
export AZCOPY_ACCOUNT_KEY="<account-key>"
azcopy copy "source" "https://devstore.file.core.windows.net/share"
```

**Key Takeaway:**

**Microsoft Entra ID authentication is NOT supported for Azure Files with AzCopy**, unlike Blob storage where it works perfectly. For File storage, you must use **SAS tokens or access keys**. Don't assume that authentication methods work the same across all storage types!

</details>

▶ **Related Lab:** [lab-azcopy-auth-methods](/AZ-104/hands-on-labs/storage/lab-azcopy-auth-methods/README.md)

---

#### Configure storage account network access

**Domain:** Implement and Manage Storage
**Skill:** Configure access to storage
**Task:** Configure Azure Storage firewalls and virtual networks

You deploy a new storage account named `storage01` in a resource group named `RG01`.

You need to ensure that the App Services, the backup vault, and the event hub can access the new storage account. Access should be enabled from within Azure only, and not via public internet.

You decide to use PowerShell to configure all the settings.

How should you complete the command string? To answer, select the appropriate options from the drop-down menus.

```powershell
Get-AzVirtualNetwork -ResourceGroupName "RG01" -Name "VNET01" |
  Set-AzVirtualNetworkSubnetConfig -Name "VSUBNET01" \
    -AddressPrefix "10.0.0.0/24" -ServiceEndpoint "___[1]___" \
  | Set-AzVirtualNetwork

$subnet = Get-AzVirtualNetwork -ResourceGroupName "RG01" -Name "VNET01"
Get-AzVirtualNetworkSubnetConfig -Name "VSUBNET01"

___[2]___ -ResourceGroupName "RG01" \
  -Name "storage01" -VirtualNetworkResourceId $subnet.Id

___[3]___ -ResourceGroupName "RG01" \
  -Name "storage01" -Bypass ___[4]___
```

Drop-Down Options:

| Blank | Options |
|-------|---------|
| [1] | AzureServices / Logging / Metrics / Microsoft.Storage / None |
| [2] | Add-AzStorageAccountNetworkRule / Remove-AzStorageAccountNetworkRuleSet / Set-AzStorageAccount / Update-AzStorageAccountNetworkRuleSet |
| [3] | Add-AzStorageAccountNetworkRule / Remove-AzStorageAccountNetworkRuleSet / Set-AzStorageAccount / Update-AzStorageAccountNetworkRuleSet |
| [4] | AzureServices / Logging / Metrics / Microsoft.Storage / None |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-11-03-48-09.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

You should run the following script to ensure that the backup vault and the event hub services have access to the storage account:

```powershell
Get-AzVirtualNetwork -ResourceGroupName "RG01" -Name "VNET01" |
Set-AzVirtualNetworkSubnetConfig -Name "VSUBNET01" \
    -AddressPrefix "10.0.0.0/24" -ServiceEndpoint "Microsoft.Storage" \
| Set-AzVirtualNetwork

$subnet = Get-AzVirtualNetwork -ResourceGroupName "RG01" -Name "VNET01"
Get-AzVirtualNetworkSubnetConfig -Name "VSUBNET01"

Add-AzStorageAccountNetworkRule -ResourceGroupName "RG01" \
    -Name "storage01" -VirtualNetworkResourceId $subnet.Id

Update-AzStorageAccountNetworkRuleSet -ResourceGroupName "RG01" \
    -Name "storage01" -Bypass AzureServices
```

You should use `Microsoft.Storage` as the service endpoint. Using the `Set-AzVirtualNetworkSubnetConfig` cmdlet enables the service endpoint on the subnet `VSUBNET01` for a storage account. This will allow connections to the virtual subnet from the storage account. This cmdlet makes modifications only to the memory representation of the virtual network. You need to run `Set-AzVirtualNetwork` to make the changes persistent.

You should use the `Add-AzStorageAccountNetworkRule` cmdlet to add a firewall exception on the `NetworkRule` property in the storage account. This will allow communication from the virtual subnet to the storage account.

You should use the `Update-AzStorageAccountNetworkRuleSet` cmdlet. This cmdlet also updates the `NetworkRule` property. It allows you to modify the `NetworkRule` property to allow other Azure services, like Backup or Event Hubs, to have access to the storage account.

You should use `AzureServices` for the `-Bypass` parameter. This way, you instruct the `Update-AzStorageAccountNetworkRuleSet` cmdlet to allow connections from other Azure services. Allowed values are `AzureServices`, `Metrics`, `Logging`, and `None`.

You should not use the `Set-AzStorageAccount` cmdlet. You can use this cmdlet to modify a storage account, but not the `NetworkRule` property of the storage account. You typically use this cmdlet when you want to set a tag to a storage account, update a customer domain, or update the type of the account.

You should not use the `Remove-AzStorageAccountNetworkRuleSet` cmdlet. You use this cmdlet to remove a `NetworkRule` property from the storage account. In this scenario, you need to add and modify a new network rule, not remove it.

You should not use the `Logging`, `None`, or `Metrics` values. These are valid for the `-Bypass` parameter for `Update-AzStorageAccountNetworkRuleSet`. Use the `None` value when you want to remove the access to all Azure services, including monitoring and logging services. Use the `Metrics` or `Logging` values when you want to allow access to monitoring or logging Azure Services respectively.

**References**:  

* [Azure Storage firewall rules](https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security)
* [Update-AzStorageAccountNetworkRuleSet](https://learn.microsoft.com/en-us/powershell/module/az.storage/update-azstorageaccountnetworkruleset?view=azps-15.4.0&viewFallbackFrom=azps-2.6.0)
* [Add-AzStorageAccountNetworkRule](https://learn.microsoft.com/en-us/powershell/module/az.storage/add-azstorageaccountnetworkrule?view=azps-15.4.0)

</details>

---

#### Shared Access Signature (SAS) practices

**Domain:** Implement and Manage Storage
**Skill:** Configure access to storage
**Task:** Create and use shared access signature (SAS) tokens

Your company is developing a .NET application that stores part of the information in an Azure Storage account. The application will be installed on end users' computers.

You want to ensure that the information stored in the storage account is accessed in a secure way, so you ask the developers to use a shared access signature (SAS) when accessing said information. You want to make the required configurations on the storage account to follow security best practices and enable access to the account with immediate effect.

For each of the following statements, select Yes if the statement is true. Otherwise, select No.

| STATEMENT | YES | NO |
|-----------|-----|----|
| You should configure a stored access policy. | ☐ | ☐ |
| You should set the shared access signature (SAS) start time to now. | ☐ | ☐ |
| You should validate data that has been written using a SAS. | ☐ | ☐ |
| One option for revoking a SAS is by deleting a stored access policy. | ☐ | ☐ |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-11-04-16-22.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

You can configure a stored access policy. When you use a shared access signature (SAS), you have two different options. You can either use an ad-hoc SAS or configure a stored access policy. By using an ad-hoc SAS, you specify the start time, expiration time, and permissions in the Uniform Resource Identifier (URI). If someone copies this URI, they will have the same level of access as the corresponding user. This means that this type of SAS can be used by anyone in the world. By configuring a stored access policy, you define the start time, expiration time, and permissions in the policy and then associate a SAS with that policy. You can associate more than one SAS with the same policy.

You should not set the SAS start time to now. When you set the start time of a SAS to now, there can be slight differences in the clocks of the servers that host the storage account. These differences could lead to an access problem for a few minutes after the configuration. If you need your SAS to be available as soon as possible, you should set the start time to 15 minutes before the current time, or you can just not set the start time. Not setting the start time parameter means that the SAS will be active immediately.

You should validate data that has been written using a SAS. When the user uses a SAS, the information they write to the storage account can cause problems, such as communication issues or corruption. Because of this, it is a best practice to validate the data written to the storage account after it is written and before the information is used by any other service or application.

You can revoke a SAS by deleting a stored access policy. If you associate a SAS with a stored access policy, the start time, expiration time, and permissions are inherited from the policy. If you remove the policy, you are invalidating the SAS, thus making it unusable. Keep in mind that if you remove a stored access policy with an associated SAS and then create another stored access policy with the exact same name as the original policy, the associated SAS will be enabled again.

<img src='.img/2026-03-11-04-19-52.png' width=600>

<img src='.img/2026-03-11-04-20-50.png' width=600>

<img src='.img/2026-03-11-04-22-57.png' width=600>

References

* [Grant limited access to Azure Storage resources using shared access signatures (SAS)](https://learn.microsoft.com/en-us/azure/storage/common/storage-sas-overview)
* [Create a stored access policy](https://learn.microsoft.com/en-us/azure/storage/common/storage-stored-access-policy-define-dotnet?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&bc=%2Fazure%2Fstorage%2Fblobs%2Fbreadcrumb%2Ftoc.json)

</details>

---

#### Provide least-privilege access to a report

**Domain:** Implement and Manage Storage
**Skill:** Configure access to storage
**Task:** Create and use shared access signature (SAS) tokens

You create a binary large object (blob) storage account named `reportstorage99` that contains archival reports from past corporate board meetings.

A board member requests access to a specific report. The member does not have a Microsoft Entra user account. Moreover, they have access only to a web browser on his Google Chromebook device.

To fulfill the request, you will provide the board member with least-privilege access to the requested report while maintaining security compliance and minimizing administrative overhead.

What should you do?

A. Deploy a point-to-site (P2S) virtual private network (VPN) connection on the board member's Chromebook and grant the board member role-based access control (RBAC) access to the report.  
B. Generate a shared access signature (SAS) token for the report and share the Uniform Resource Locator (URL) with the board member.  
C. Copy the report to an Azure File Service share and provide the board member with a PowerShell connection script.  
D. Create a Microsoft Entra account for the board member and grant him role-based access control (RBAC) access to the storage account.  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-11-04-28-34.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

You should generate a shared access signature (SAS) token for the report and share the Uniform Resource Locator (URL) with the board member. SAS enables you to define time-limited read-only or read-write access to Azure storage account resources. It is important that you set the time restriction properly because the SAS includes no authentication. Any person with access to the URL can access the target resource(s) within the token's lifetime. In this case, you both minimize administrative effort as well as maintain security compliance because the SAS token points only to a single file, not the entire blob container that hosts the requested report.

You should not create a Microsoft Entra account for the board member and grant him role-based access control (RBAC) access to the storage account. First, it requires significant management overhead to create and manage Microsoft Entra accounts, even for external (guest) users. Second, SAS and not RBAC is the way Azure provides screened access to individual storage account resources. You can use RBAC roles only at the storage account scope.

You should not copy the report to an Azure File Service share and provide the board member with a PowerShell connection script. Here you create security and governance problems by creating multiple copies of the source report, as well as producing unnecessary administrative complexity.

You should not deploy a point-to-site (P2S) VPN connection on the board member's Chromebook and grant the board member RBAC access to the report. The scenario stipulates that the board member is limited to using a web browser on his Chromebook. Furthermore, the Azure P2S VPN client is supported only on Windows, macOS, and endorsed Linux distributions. Chrome OS is not supported.

References

* Grant limited access to Azure Storage resources using shared access signatures (SAS)

</details>

---

#### Modify Stored Access Policy

**Domain:** Implement and manage storage
**Skill:** Configure access to storage
**Task:** Configure stored access policies

You are an Azure administrator for a manufacturing organization. You are using shared access signature (SAS) to configure control over storage accounts.

You create a stored access policy as an additional level of control over SAS on the server side for file shares.

You need to modify a stored access policy.

What should you do?

A. Execute a Set Share ACL operation with the SMB protocol.  
B. Execute a Set Table ACL operation.  
C. Execute a Set Container ACL operation with public read access for blobs only.  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-03-03-53-49.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

In this scenario, you are using a stored access policy that acts as an additional level of control over shared access signature (SAS) on the server side for file shares. The access policy for an SAS consists of the start time, expiry time, and permissions for the signature. To create or modify a stored access policy, call the Set ACL operation for the resource (Set Container ACL, Set Queue ACL, Set Table ACL, or Set Share ACL) with a request body that specifies the terms of the access policy. An important point to note here is that, for a file share, you need to execute a Set Share ACL operation, which only supports the Server Message Block (SMB) protocol as the enabled file share protocol.

You should not execute a Set Table ACL operation. The Set Table ACL operation sets the stored access policies for the table that can be used with SAS. In this scenario, since you want to modify stored access policies for an Azure File share, you need to use the Set Share ACL with SMB.

You should not execute a Set Container ACL operation with public read access for blobs only. The Set Container ACL operation with public read access for blobs only will mean that Blob data within a container could be read via anonymous request, but container data is not available. In this scenario, since you are aiming to modify stored access policies for an Azure File share, you need to use the Set Share ACL with SMB.

References

[Define a stored access policy](https://learn.microsoft.com/en-us/rest/api/storageservices/define-stored-access-policy)

</details>

---

#### Diagnose Storage Explorer Permission Errors

**Domain:** Implement and manage storage
**Skill:** Configure access to storage
**Task:** Manage access keys

You have storage accounts in your Azure subscription with blob containers and file shares configured. Some users access these storage accounts using Azure Storage Explorer and are reporting an error when they try to browse the storage account contents.

You need to resolve the issue.

What are two possible reasons why users are getting this error message? Each correct answer presents a complete solution.

A. Your users have the Storage Blob Data Reader role assigned in the storage accounts.  
B. There is a ReadOnly resource lock configured.  
C. There is a CanNotDelete resource lock configured.  
D. Your users have the Read role assigned in the storage accounts.  
E. Your users have the Storage Blob Data Contributor role assigned in the storage accounts.  

<details>
<summary>📸 Click to expand screenshot</summary>
<img src='.img/2026-01-30-05-46-07.png' width=700>

<img src='.img/2026-02-08-04-07-45.png' width=400>
</details>

<details>
<summary>💡 Click to expand explanation</summary>

Looking at your selected answers, I can see you've made the same mistake again with this question (which appears to be the same as image 3).

**Your Selected Answers:**

1. ✗ Your users have the Storage Blob Data Reader role assigned in the storage accounts
2. ✗ Your users have the Storage Blob Data Contributor role assigned in the storage accounts

**The Problem - You're Still Selecting SOLUTIONS Instead of PROBLEMS:**

The error message clearly states:
> "**Unable to list resources in account due to inadequate permissions**. Permission to list containers or to list account keys is required."

You selected answers that indicate users **already have proper data access roles**. If they had Storage Blob Data Reader or Contributor, they **wouldn't be getting this error** - the problem would already be solved!

**The Correct Answers Should Be:**

1. **Your users have the Read role assigned in the storage accounts** ✓
   - **This IS a problem**: The generic "Read" role only provides management plane access
   - It does NOT grant data plane access to browse blob/file contents
   - Users can see the storage account exists but cannot access the data inside

2. **There is a ReadOnly resource lock configured** ✓
   - **This IS a problem**: ReadOnly locks can block operations in Storage Explorer
   - Locks can override permissions and prevent certain actions

**Understanding the Logic:**

**Error exists** = Something is wrong/missing

- ❌ "Users have Storage Blob Data Reader" = No error (they have correct access)
- ✓ "Users have Read role" = Error! (they lack data plane access)
- ✓ "ReadOnly lock configured" = Error! (lock blocks operations)

**Key Takeaway:**

When a question asks for "**reasons why users are getting an error**," you need to identify what's **CAUSING the problem** (wrong role, locks), not what would **FIX the problem** (correct roles).

**More Detail:**

Great question! Let me explain how ReadOnly locks interact with Azure Storage Explorer and why they can cause issues.

**What ReadOnly Locks Do:**

**ReadOnly locks** in Azure prevent **any modifications** to a resource, including:

- Changing resource configuration
- Modifying properties
- Regenerating access keys
- Updating firewall rules
- ANY write operation at the management plane

**How Storage Explorer Accesses Storage:**

Azure Storage Explorer can authenticate and access storage using **multiple methods**:

**1. Account Keys (Management Plane):**

- Storage Explorer attempts to **list and retrieve storage account keys**
- This is a **write-equivalent operation** (POST request to list keys)
- ReadOnly lock **BLOCKS** this operation
- Result: ❌ Access denied

**2. Azure AD / RBAC (Data Plane):**

- Uses your Azure AD identity with data plane roles
- Directly accesses blobs/files without needing account keys
- ReadOnly lock does **NOT** block this
- Result: ✓ Should work

**3. SAS Tokens:**

- Uses pre-generated shared access signatures
- ReadOnly lock does **NOT** block this
- Result: ✓ Should work

**Why ReadOnly Locks Cause the Error:**

When Storage Explorer opens and tries to browse a storage account:

```
1. Storage Explorer connects to storage account
2. Attempts to list containers/shares
3. Tries to retrieve account keys (common default method)
4. POST /listKeys operation is attempted
5. ReadOnly lock intercepts: "NO MODIFICATIONS ALLOWED"
6. Error: "Unable to list resources due to inadequate permissions"
```

**The Confusing Part:**

The error message says "**inadequate permissions**," but it's actually:

- Not about RBAC permissions ✗
- About the **lock preventing the listKeys operation** ✓

Even if you have **Owner** or **Contributor** role, the ReadOnly lock **overrides** your permissions and blocks management plane operations.

**Visual Representation:**

```
Without ReadOnly Lock:
User → Storage Explorer → List Keys API → ✓ Success → Browse Storage

With ReadOnly Lock:
User → Storage Explorer → List Keys API → ✗ BLOCKED by Lock → Error Message
```

**How to Verify This is the Issue:**

1. Check if a ReadOnly lock exists:

   ```
   Storage Account → Locks → See "ReadOnly" lock
   ```

2. Remove the lock temporarily and test Storage Explorer
   - If it works now, the lock was the problem

**Solutions When ReadOnly Lock Exists:**

**Option 1: Remove the Lock** (if policy allows)

- Not always possible due to governance requirements

**Option 2: Use Azure AD Authentication**

- In Storage Explorer, explicitly connect using "Azure AD"
- Assign proper data plane roles (Storage Blob Data Reader)
- Bypasses the need for account keys

**Option 3: Use SAS Tokens**

- Generate SAS token before the lock was applied
- Connect to storage using SAS URL

**Option 4: Use Azure Portal**

- Portal has built-in handling for locked resources
- May provide better error messages

**Key Takeaway:**

ReadOnly locks block the **listKeys operation** that Storage Explorer commonly uses for authentication. While users might have proper RBAC permissions, the lock creates a hard stop at the management plane level, preventing Storage Explorer from retrieving the keys needed to access the data using the default authentication method.

The solution is either:

- Remove the lock, OR
- Use authentication methods that don't require listing keys (Azure AD, SAS tokens)

</details>

▶ **Related Lab:** [lab-storage-explorer-permissions](/AZ-104/hands-on-labs/storage/lab-storage-explorer-permissions/README.md)

---

### Configure and manage storage accounts

#### Configure Object Replication Between Storage Accounts

**Domain:** Implement and manage storage
**Skill:** Configure and manage storage accounts
**Task:** Configure object replication

You plan to configure object replication between storage accounts in two different regions. You need to ensure that Azure Storage features are configured to support object storage replication. You want to minimize the configuration changes that you make.

How should you configure the Azure Storage features? To answer, select the configuration settings from the drop-down menus.

Change feed: Source account only  
Blob versioning: Both source and destination accounts  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-05-31-43.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

Looking at your answer, I can explain why you got the object replication configuration wrong.

**Your Selected Answers:**

- **Change feed**: Destination account only ✗
- **Blob versioning**: Source account only ✗

**The Problem - You Have Both Settings Backwards:**

You've essentially reversed the requirements for object replication. Let me explain what each feature does and where it's needed.

**What Object Replication Requires:**

**Change Feed:**

**Purpose**: Tracks all create, modify, and delete operations on blobs

- **Where needed**: **SOURCE account only** ✓
- **Why**: The source needs to track what changed so it knows what to replicate
- **Destination doesn't need it**: The destination is passively receiving data

**Blob Versioning:**

**Purpose**: Maintains previous versions of blobs when they're modified or deleted

- **Where needed**: **BOTH source and destination accounts** ✓
- **Why source needs it**: To track and maintain versions of objects being replicated
- **Why destination needs it**: To properly receive and store the replicated blob versions

**The Correct Answer Should Be:**

- **Change feed**: **Source account only** ✓
- **Blob versioning**: **Both source and destination accounts** ✓

**Why Your Answer Was Wrong:**

**Issue #1: Change Feed on Wrong Account:**

**You selected**: Destination account only ✗

**Problem**:

- The destination account doesn't need to track changes - it's just receiving replicated data
- The SOURCE account needs change feed to detect which blobs have changed and need replication
- Without change feed on the source, object replication cannot track what to replicate

**Issue #2: Blob Versioning on Only One Account:**

**You selected**: Source account only ✗

**Problem**:

- Object replication replicates blob **versions**, not just the latest blob
- BOTH accounts must support versioning to properly handle the replication
- Without versioning on the destination, it cannot properly receive and store the versioned blobs

**The Logic Flow:**

```
SOURCE ACCOUNT                    DESTINATION ACCOUNT
┌─────────────────┐              ┌──────────────────┐
│ Blob versioning │ ✓ Required   │ Blob versioning  │ ✓ Required
│ Change feed     │ ✓ Required   │ Change feed      │ ✗ Not needed
└─────────────────┘              └──────────────────┘
         │                                │
         │   Detects changes              │
         │   Creates replication          │
         │   tasks                        │
         │                                │
         └────────── Replicates ─────────>│
                     blob versions
```

**Visual Comparison:**

| Feature | Your Answer | Correct Answer | Why |
|---------|------------|----------------|-----|
| **Change feed** | Destination only | **Source only** | Source tracks changes to replicate |
| **Blob versioning** | Source only | **Both accounts** | Both need to handle blob versions |

**Why "Minimize Configuration Changes" Matters:**

The question asks to "minimize configuration changes." The correct answer requires:

- 1 account with change feed (source)
- 2 accounts with blob versioning (both)
- Total: 3 configuration changes

If you enabled change feed on both accounts, that would be 4 changes (unnecessary).

**Key Takeaway:**

For **Azure Storage Object Replication**:

1. **Change feed = Source only** (to detect what needs replicating)
2. **Blob versioning = Both accounts** (to support version replication)

Think of it this way:

- **Change feed** = The "sensor" that detects changes (only needed where changes originate)
- **Blob versioning** = The "infrastructure" that both accounts need to support versioned objects

You had the logic completely reversed - change feed on the wrong end, and versioning on only one side when both need it!

**References:**

- [Prerequisites and caveats for object replication](https://learn.microsoft.com/en-us/azure/storage/blobs/object-replication-overview#prerequisites-and-caveats-for-object-replication)
- [Enable and manage blob versioning](https://learn.microsoft.com/en-us/azure/storage/blobs/versioning-enable?tabs=portal)
- [Change feed support in Azure Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal)

<img src='.img/2026-02-02-04-12-42.png' width=700>

<img src='.img/2026-02-02-04-15-32.png' width=600>

</details>

▶ **Related Lab:** [lab-object-replication](../../hands-on-labs/storage/lab-object-replication/README.md)

---

#### Rotate compromised storage account keys

**Domain:** Implement and Manage Storage
**Skill:** Configure and manage storage accounts
**Task:** Manage access keys

You have two storage account keys: `key1` and `key2`. Your apps and services use `key1`, and you maintain `key2` as a backup key.

You are concerned that both keys may have been compromised. You want to use the Azure portal to regenerate them without interrupting access to the storage account.

Which five actions should you perform in sequence? To answer, move the appropriate actions from the list of possible actions to the answer area and arrange them in the correct order.

Available options:

A. Regenerate `key1` using the Azure portal.  
B. Update connection strings in all relevant apps and services to use `key1`.  
C. Regenerate `key2` using the Azure portal.  
D. Update connection strings in all relevant apps and services to use `key2`.  
E. Verify that all apps and services are running correctly using the new key. Regenerate `key2`.  
F. Create a new Key using the Azure Portal called key3

Select and order 5:

| Step | Action |
|------|--------|
| 1 | |
| 2 | |
| 3 | |
| 4 | |
| 5 | |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-11-04-43-07.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

You should perform the following steps in order:

1. Regenerate `key2` using the Azure portal.  
2. Update connection strings in all relevant apps and services to use `key2`.  
3. Regenerate `key1` using the Azure portal.  
4. Update connection strings in all relevant apps and services to use `key1`.  
5. Verify that all apps and services are running correctly using the new key. Regenerate `key2`.

You should first regenerate `key2` using the Azure portal. This ensures that you are not using any key that has been compromised in the past. This is very important since, in this scenario, you are concerned that both keys may have been compromised. After regenerating the `key2`, you should then proceed to update the connection strings for all the relevant apps to use `key2`, then regenerate `key1` as it is not the primary key now.

Next, you should update the connection strings for all the relevant apps to use newly generated `key1`, then regenerate `key2` as it is not the primary key. This is important because the apps and services will not be able to use the previous primary key after it is regenerated.

Finally, you should check that all apps and services are working correctly. As a final step, as a best practice, you should regenerate `key2` again.

You do not need to create a new key called key3 as you can regenerate both `key1` and `key2`, which will mitigate any security concerns if the keys have been compromised.

<img src='.img/2026-03-11-04-45-26.png' width=600>

</details>

---

#### Azure Storage Redundancy Recommendation

**Domain:** Implement and manage storage
**Skill:** Configure and manage storage accounts
**Task:** Configure Azure Storage redundancy

You are a Cloud engineer who works for a global organization with offices all around the world. The organization currently uses Azure to host its infrastructure, including file shares. It uses premium zone-redundant storage (ZRS) accounts for its existing file storage in Azure, as well as Azure Files workloads.

The company is planning to open new offices in the Azure (Europe) UK South region.

You need to decide which option for Azure Storage you should use based on Microsoft's current recommendations.

Which solution should you recommend?

A. Read-access geo-redundant storage (RA-GRS) with six replications.  
B. Locally redundant storage (LRS) with three replications.  
C. Zone-redundant storage (ZRS) with three replications.  
D. Geo-redundant storage (GRS) with six replications.  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-03-03-46-17.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

You should recommend Zone-redundant storage (ZRS) with three replications. Zone-redundant storage (ZRS) with three replications is the correct choice because ZRS replicates your data across multiple availability zones within the same region. This provides high availability and durability, protecting against both local hardware failures and zone-level failures, making it ideal for a global organization with critical Azure Files workloads.

You should not recommend Locally redundant storage (LRS) with three replications. Microsoft does not recommend using LRS as it copies your data synchronously three times within a single physical location in the primary region. LRS provides at least 99.9999999999 (11 nines) durability of objects over a given year. LRS is the lowest-cost redundancy option but offers the least durability compared to other options. This is a poor architectural choice since in case the primary region goes down owing to a region-wide failure, you could possibly face a data loss.

You should not recommend Geo-redundant storage (GRS) with six replications. GRS replicates your data to a secondary region, providing higher durability by ensuring data is available even if the primary region fails. However, GRS does not offer read access to the secondary region unless a failover occurs, which might not meet the needs for high availability and quick access in a multi-office setup.

You should not recommend Read-access geo-redundant storage (RA-GRS) with six replications. RA-GRS provides the same redundancy as GRS but with read access to the secondary region. While this offers better availability than GRS, it might still not be the best choice for performance-sensitive applications that require low-latency access to data across multiple zones within a region.

References

[Azure Storage redundancy](https://learn.microsoft.com/azure/storage/common/storage-redundancy)

</details>

---

### Configure Azure Files and Azure Blob Storage

#### Configure Lifecycle Management Policy for Azure Storage

**Domain:** Implement and manage storage
**Skill:** Configure Azure Files and Azure Blob Storage
**Task:** Configure blob lifecycle management

Your company has an Azure Subscription with several resources deployed. The subscription is managed by a Cloud Service Provider. You plan to migrate archive data into Azure Blob Storage and you have used Azure Storage Explorer to complete the initial bulk upload.

To complete the task, you need to create a lifecycle management policy using PowerShell to transfer data that has not been modified in the last 30 days from the existing hot storage tier into the cool storage tier.

Which four cmdlets should you run in sequence to complete this goal? To answer, move the appropriate cmdlets to the answer area and arrange them in order.

Available cmdlets:

* Add-AzStorageAccountManagementPolicyAction  
* New-AzStorageAccountManagementPolicyFilter  
* New-AzStorageBlobInventoryPolicyRule  
* New-AzStorageAccountManagementPolicyRule  
* New-AzStorageBlobInventoryPolicyFilter  
* Set-AzStorageAccountManagementPolicy  
* Set-AzStorageBlobInventoryPolicy  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-05-50-54.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

You're absolutely right! Let me correct my response.

**Your Selected Answers:**

- **$action** (not visible in dropdown, but should be first): ✗ Wrong cmdlet used
- **$filter**: New-AzStorageAccountManagementPolicyFilter ✓
- **$rule2**: New-AzStorageBlobInventoryPolicyRule ✗
- **Final command**: Set-AzStorageBlobInventoryPolicy ✗

**The Problem - You Mixed Up Two Different Features:**

You confused **Lifecycle Management Policies** with **Blob Inventory Policies**, AND the first command uses the wrong cmdlet structure.

**The Correct Script Structure:**

```powershell
$rgName = "RgGroup01"
$accountName = "storageaccount01"

$action = Add-AzStorageAccountManagementPolicyAction `  ✓ CORRECT
    -BaseBlobAction TierToCool `
    -daysAfterModificationGreaterThan 30

$filter = New-AzStorageAccountManagementPolicyFilter `  ✓ CORRECT
    -PrefixMatch ef,gh `
    -BlobType blockBlob

$rule2 = New-AzStorageAccountManagementPolicyRule `  ✓ CORRECT
    -Name test-rule `
    -Action $action `
    -Filter $filter

Set-AzStorageAccountManagementPolicy `  ✓ CORRECT
    -ResourceGroupName $rgName `
    -StorageAccountName $accountName `
    -Rule $rule2
```

**The Correct Cmdlets:**

1. **$action**: `Add-AzStorageAccountManagementPolicyAction`
   - **ADD** an action to the policy (TierToCool after 30 days)

2. **$filter**: `New-AzStorageAccountManagementPolicyFilter` ✓ You got this one
   - **CREATE** a filter (which blobs to target)

3. **$rule2**: `New-AzStorageAccountManagementPolicyRule`
   - **CREATE** a rule by combining action + filter
   - ✗ You used: `New-AzStorageBlobInventoryPolicyRule` (wrong - for inventory)

4. **Final**: `Set-AzStorageAccountManagementPolicy`
   - **SET/APPLY** the management policy to the storage account
   - Creates or modifies the management policy of an Azure Storage account.
   - ✗ You used: `Set-AzStorageBlobInventoryPolicy` (wrong - for inventory)

**Why Your Answer Was Wrong:**

**Issue #1: Wrong Cmdlet Pattern for $action:**

The first command should use `Add-AzStorageAccountManagementPolicyAction` to **add an action** (what to do with the blobs).

**Issue #2: Inventory vs Management (Last Two Cmdlets):**

**You selected:**

- `New-AzStorageBlobInventoryPolicyRule` ✗ (creates inventory reports)
- `Set-AzStorageBlobInventoryPolicy` ✗ (applies inventory policy)

**Should be:**

- `New-AzStorageAccountManagementPolicyRule` ✓ (creates lifecycle rule)
- `Set-AzStorageAccountManagementPolicy` ✓ (applies lifecycle policy)

**The Logic Flow:**

1. **$action** = `Add-AzStorageAccountManagementPolicyAction`
   - Define WHAT to do: "Tier to Cool after 30 days"

2. **$filter** = `New-AzStorageAccountManagementPolicyFilter` ✓
   - Define WHICH blobs: "blockBlobs with prefix ef,gh"

3. **$rule2** = `New-AzStorageAccountManagementPolicyRule`
   - Combine action + filter = complete rule

4. **Apply** = `Set-AzStorageAccountManagementPolicy`
   - Apply the rule to the storage account

**Cmdlet Naming Pattern:**

| Step | Verb | Object |
|------|------|--------|
| Create action | **Add**-AzStorageAccount**ManagementPolicyAction** | Action definition |
| Create filter | **New**-AzStorageAccount**ManagementPolicyFilter** | Filter definition |
| Create rule | **New**-AzStorageAccount**ManagementPolicyRule** | Rule (action + filter) |
| Apply policy | **Set**-AzStorageAccount**ManagementPolicy** | Complete policy |

**Key Differences:**

**Lifecycle Management (What you need):**

```powershell
Add-AzStorageAccountManagementPolicyAction      # Define action
New-AzStorageAccountManagementPolicyFilter      # Define filter
New-AzStorageAccountManagementPolicyRule        # Combine to rule
Set-AzStorageAccountManagementPolicy            # Apply policy
# Purpose: Move blobs between tiers, delete old blobs
```

**Blob Inventory (What you incorrectly selected):**

```powershell
New-AzStorageBlobInventoryPolicyRule            # \u2717 Wrong!
Set-AzStorageBlobInventoryPolicy                # \u2717 Wrong!
# Purpose: Generate CSV/Parquet reports of blob metadata
```

**Key takeaway:**

1. **Use `Add-` for actions**, `New-` for filters and rules, `Set-` to apply
2. **Management Policy ≠ Inventory Policy**
   - **Management Policy** = Lifecycle automation (tier/delete based on rules)
   - **Inventory Policy** = Generate reports about blob metadata
3. All cmdlets must have `*ManagementPolicy*` in the name for lifecycle management tasks
4. The cmdlet structure follows a pattern: Add action → Create filter → Create rule → Set policy

</details>

---

#### Lifecycle Management Policy Configuration

**Domain:** Implement and manage storage
**Skill:** Configure Azure Files and Azure Blob Storage
**Task:** Configure blob lifecycle management

Your company implements block blob storage in a general-purpose version 2 (GPv2) storage account and uses the following rule to help optimize storage costs:

```json
{
  "rules": [
    {
      "enabled": true,
      "name": "myrule",
      "type": "Lifecycle",
      "definition": {
        "actions": {
          "version": {
            "delete": {
              "daysAfterCreationGreaterThan": 90
            }
          },
          "baseBlob": {
            "enableAutoTierToHotFromCool": true,
            "tierToCool": {
              "daysAfterModificationGreaterThan": 30
            },
            "tierToArchive": {
              "daysAfterModificationGreaterThan": 90
            },
            "delete": {
              "daysAfterModificationGreaterThan": 365
            }
          }
        },
        "filters": {
          "blobTypes": [
            "blockBlob"
          ],
          "prefixMatch": [
            "container2/myblob"
          ]
        }
      }
    }
  ]
}
```

You need to determine how blob storage is configured by this rule.

For each of the following statements, select Yes if the statement is true. Otherwise, select No.

| Statement | Yes | No |
|-----------|-----|----|
| Previous blob versions are deleted automatically 90 days after creation. | ☐ | ☐ |
| Rehydrating a blob from archive with a Copy Blob operation resets the days after modification counter to zero. | ☐ | ☐ |
| You should transition blobs from cool to hot tier storage to optimize performance. | ☐ | ☐ |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-02-04-47-23.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

</details>

▶ Related Lab: [lab-blob-storage-lifecycle](../hands-on-labs/storage/lab-blob-storage-lifecycle/README.md)

---

#### Delete Soft-Deleted File Share

**Domain:** Implement and manage storage
**Skill:** Configure Azure Files and Azure Blob Storage
**Task:** Configure snapshots and soft delete for Azure Files

Your company is using Azure Files for storing files. You are the Azure administrator in your company.

You need to permanently delete an Azure file share that has been soft deleted.

You execute the PowerShell command shown below:

```powershell
Update-AzStorageFilesServiceProperty `
  -ResourceGroupName $resourceGroupName `
  -StorageAccountName $storageAccountName `
  -EnableShareDeleteRetentionPolicy $false
```

Which statement is correct regarding this command?

A. The PowerShell command undeletes the file share.  
B. The PowerShell command disables soft delete on your storage account and permanently deletes an Azure file share that has been soft deleted.  
C. The PowerShell command only disables soft delete on your storage account.  
D. The PowerShell command does not disable soft delete on your storage account.  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-04-04-27-15.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

To permanently delete a file share that has been soft deleted, you must undelete it, disable soft delete, and then delete it again. The provided PowerShell command, which uses the `-EnableShareDeleteRetentionPolicy $false` parameter value, only disables soft delete on your storage account, but this does not permanently delete a file share as is the desired outcome in this scenario. Thus, the option that the PowerShell command only disables soft delete on your storage account is the correct choice.

The PowerShell command does not undelete the file share. To permanently delete a file share that has been soft deleted, you must undelete it, disable soft delete, and then delete it again.

<img src='.img/2026-03-04-04-36-13.png' width=600>

References

- [Prevent File Share Deletion](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-prevent-file-share-deletion?tabs=azure-portal)

</details>

---

#### Identify Blob Write Operations That Create New Versions

**Domain:** Implement and manage storage
**Skill:** Configure Azure Files and Azure Blob Storage
**Task:** Configure blob versioning

Your organization is using Azure Blobs for storing data. You enable blob versioning for a storage account.

You need to determine which write operations create a new version.

Which four write operations create a new version? Each correct answer presents a complete solution.

A. Put Blob  
B. Append Block  
C. Put Block List  
D. Copy Blob  
E. Set Blob Metadata  
F. Put Blob From URL  
G. Put Page  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-06-01-29.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

You're absolutely correct to question this. I made an error in my original response.

**The correct four operations that create new versions are:**

1. **Put Blob** ✓ (You selected this correctly)
2. **Put Block List** (You did not select this)
3. **Copy Blob** (You did not select this)
4. **Set Blob Metadata** (You did not select this)

**Why your selected answers were wrong:**

- **Append Block** – Does NOT create a new version. It appends data to an append blob without overwriting the blob itself.
- **Put Blob From URL** – I incorrectly stated this creates a version. The documentation does NOT list this as a versioning operation. While it creates or overwrites a blob, it's not explicitly mentioned in Microsoft's versioning documentation as triggering a new version.
- **Put Page** – Does NOT create a new version. It updates page ranges within a page blob in place.

**Why Set Blob Metadata creates a version:**

I incorrectly stated that metadata changes don't trigger versioning. According to Microsoft's documentation, **Set Blob Metadata** is explicitly listed as a write operation that creates a new version. This is a key exam concept: metadata changes are considered blob modifications that warrant version tracking.

**Key takeaway:**

The four versioning operations are **Put Blob**, **Put Block List**, **Copy Blob**, and **Set Blob Metadata**. These are the operations Microsoft explicitly lists in their documentation. Don't assume operations like "Put Blob From URL" trigger versioning unless explicitly documented.

**References:**

- [Blob versioning - How blob versioning works](https://learn.microsoft.com/en-us/azure/storage/blobs/versioning-overview#how-blob-versioning-works)

<img src='.img/2026-02-02-04-41-46.png' width=600>

</details>

▶ **Related Lab:** [lab-blob-versioning](../../hands-on-labs/storage/lab-blob-versioning/README.md)

---

### Create and use shared access signature (SAS) tokens

#### SAS key configuration scenarios

**Domain:** Implement and Manage Storage
**Skill:** Create and use shared access signature (SAS) tokens
**Task:** Create and use shared access signature (SAS) tokens

You have a storage account named `salesstorage` in a subscription named `SalesSubscription`. You create a container in a blob storage named `salecontainer`.

You create the shared access signature (SAS) shown in the exhibit.

You try to carry out actions from several computers at different times using the SAS key1 configurations shown in the exhibit.

What level of access would be available in each scenario? To answer, select the appropriate options from the drop-down menus.

| Configuration | Value | Action | Action result |
|---------------|-------|--------|---------------|
| 151.112.10.6 | March 4th, 2020 at 11 AM | Connect to Storage Account | ***[1]*** |
| 151.112.11.6 | March 4th, 2020 at 12 AM | Connect to Storage Account | ***[2]*** |
| 151.112.10.6 | March 10th, 2020 at 10 AM | Create a Container | ***[3]*** |
| 151.112.10.6 | March 10th, 2020 at 12 AM | Read a File Share | ***[4]*** |

Drop-Down Options:

| Blank | Options |
|-------|---------|
| [1] | Connection success with read, write, and list access / Connection failure with read, write, and list access / Connection failure with read access |
| [2] | Connection success with read, write, and list access / Connection failure with read, write, and list access / Connection failure with read access |
| [3] | Connection success with read, write, and list access / Connection failure with read, write, and list access / Connection failure with read access |
| [4] | Connection success with read, write, and list access / Connection failure with read, write, and list access / Connection failure with read access |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-11-04-35-29.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

In the first scenario, you would have connection success with read, write, and list access, because the IP address and the dates meet the criteria when the shared access signature (SAS) key1 is active.

In the second scenario, you would have connection failure with read, write, and list access, because the IP address does not fall in the allowed IP address range. Additionally, it would also fail because the start time is 12am on March 4th, 2020, for the request, but the SAS token starts at 11am on March 4th, 2020.

In the third scenario, you would have connection failure with read, write, and list access, because the permissions provided for the SAS key1 do not grant permissions to create a new container.

In the fourth scenario, you would have connection failure with read, write, and list access, because the permissions granted are only for blob containers and not file shares.

</details>

---

## Deploy and Manage Azure Compute Resources

### Automate deployment of resources by using ARM templates or Bicep files

#### Export ARM Template

**Domain:** Deploy and Manage Azure Compute Resources
**Skill:** Automate deployment of resources by using ARM templates or Bicep files
**Task:** Export a deployment as an ARM template or convert an ARM template to a Bicep file

You deploy a line of business (LOB) application. All resources that are part of the LOB application are deployed in a single resource group. The resources were added in different phases.

You need to export the current configuration of the LOB application resources to an Azure Resource Manager (ARM) template. You will later use this template for deploying the LOB application infrastructure in different environments for testing or development purposes.

You are using the Complete mode for ARM deployment.

For each of the following statements, select Yes if the statement is true. Otherwise, select No.

| Statement | Yes | No |
|----------|-----|----|
| You need to export the Azure Resource Manager (ARM) template from the latest deployment. | ☐ | ☐ |
| Each deployment contains only the resources that have been added in that deployment. | ☐ | ☐ |
| The parameters file contains the values used during the deployment. | ☐ | ☐ |
| The template contains the scripts needed for deploying the template. | ☐ | ☐ |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-12-03-11-57.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

You do not need to export the Azure Resource Manager (ARM) template from the latest deployment. In this scenario, the line of business (LOB) application was deployed in several phases. The latest deployment will export only the latest resources added to the application. If you want to export the ARM template with all the resources needed for the LOB application, you will need to export the ARM template from the resource group.

Each deployment contains only the resources that have been added in that deployment. When deploying your resources, you specify that the deployment is either an Incremental update or a Complete update. The difference between these two modes is how the Resource Manager handles existing resources in the resource group that are not in the template. In this scenario, since you are using the Complete mode, each deployment contains only the resources that have been added in that deployment and the Resource Manager will delete all the resources that exist in the resource group but are not specified in the template. On the other hand, in an Incremental mode, the Resource Manager leaves unchanged resources that exist in the resource group but are not specified in the template. Resources in the template are added to the resource group.

The parameters file contains the values used during the deployment. The parameters file is a JSON file that stores all the parameters used in the ARM template. You can use this file to reuse the template in different deployments, just changing the values of the parameters file. If you use this file in templates created from resource groups, you need to make significant edits to the template before you can effectively use the parameters file.

The template does not contain the scripts needed for deploying the template. When you download an ARM template from a deployment or a resource group, the downloaded package contains only the ARM template and the parameters file. You can reference Azure CLI scripts or a PowerShell script in the Azure docs linked in the export template pane.

<img src='.img/2026-03-12-03-47-36.png' width=600>

<img src='.img/2026-03-12-03-31-11.png' width=600>

References

- [Use Azure portal to export a template](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/export-template-portal)
- [Understand the structure and syntax of ARM templates](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax)
- [Azure Resource Manager deployment modes: COMPLETE versus INCREMENTAL](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-modes)
- [Azure Resource Manager deployment modes](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-modes)
- [Manage Azure resources by using Azure CLI](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resources-cli)

</details>

---

### Create and configure virtual machines

#### VM Resize Failure Cause

**Domain:** Deploy and manage Azure compute resources
**Skill:** Create and configure virtual machines
**Task:** Manage virtual machine sizes

You have a Linux virtual machine (VM) named VM1 that runs in Azure. VM1 has the following properties:

- Size: Standard_D4s_v3
- Number of virtual CPUs: four
- Storage type: Premium
- Number of data disks: eight
- Public IP address: Standard SKU

You attempt to resize the VM to the Standard_D2s_v3 size, but the resize operation fails.

Which VM property is the most likely cause of the failure?

A. Public IP address  
B. Number of data disks  
C. Storage type  
D. Number of virtual CPUs  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-21-05-43-55.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is correct (Number of data disks)**

The Standard_D2s_v3 size supports a maximum of **4 data disks**. VM1 currently has **8 data disks** attached. When Azure attempts to resize the VM, it validates that the target size can accommodate all currently attached resources. Because 8 data disks exceeds the 4-disk limit of Standard_D2s_v3, the resize operation is blocked. This is the most likely cause of the failure.

**Why the other options are incorrect**

**Public IP address — Standard SKU**
A Standard SKU public IP address is compatible with both Standard_D4s_v3 and Standard_D2s_v3. IP address SKU has no bearing on VM size compatibility and would not cause a resize failure.

**Storage type — Premium**
Both Standard_D4s_v3 and Standard_D2s_v3 support Premium storage (indicated by the "s" in the size name). Premium storage compatibility is not a constraint that would block this resize.

**Number of virtual CPUs**
Resizing from 4 vCPUs to 2 vCPUs is a valid downscale operation. Azure does not block a resize based on reducing vCPU count. The operating system and applications may be affected, but Azure will not prevent the operation for this reason alone.

**Key takeaway**
When resizing a VM, Azure validates that all currently attached resources (data disks, NICs, etc.) fall within the limits of the target size. If the number of attached data disks exceeds the maximum supported by the target VM size, the resize will fail. Always check the target size's data disk limit before attempting to resize down.

**References**

* [Sizes for virtual machines in Azure](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/overview?tabs=breakdownseries%2Cgeneralsizelist%2Ccomputesizelist%2Cmemorysizelist%2Cstoragesizelist%2Cgpusizelist%2Chpcsizelist)
* [Introduction to Azure managed disks](https://learn.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview)
* [Public IP addresses](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses)

</details>

---

#### Encrypt VM Disk With Key Vault

**Domain:** Deploy and manage Azure compute resources
**Skill:** Create and configure virtual machines
**Task:** Configure Azure Disk Encryption

You have a subscription named SubscriptionA that hosts the following resources:

- A key vault named mySecureVault in a resource group named myKeyVaultResourceGroup.
- A virtual machine (VM) named mySecureVM in a resource group named myVirtualMachineResourceGroup.

You need to write a PowerShell script that will encrypt the disk for mySecureVM using the keys stored in the mySecureVault.

How should you complete the script? To answer, select the appropriate options from the drop-down menus.

```powershell
$keyVaultRG = 'myKeyVaultResourceGroup';
$vmRG = 'myVirtualMachineResourceGroup';
$vmName = 'mySecureVM';
$keyVaultName = 'mySecureVault';

$keyVault = Get-AzKeyVault [Select 1 ▼] $keyVaultName -ResourceGroupName $keyVaultRG;
$diskEncryptionKeyVaultUrl = [Select 2 ▼];
$keyVaultId = [Select 3 ▼];

Set-AzVMDiskEncryptionExtension -ResourceGroupName [Select 4 ▼] `
  -DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl `  
  -DiskEncryptionKeyVaultId $keyVaultId -VMName $vmName;
```

**Select 1 options:**  
○ Name  
○ VaultName  

**Select 2 options:**  
○ keyVault.Path  
○ keyVault.Url  
○ keyVault.VaultUri  

**Select 3 options:**  
○ keyVault.Id  
○ keyVault.ResourceId  

**Select 4 options:**  
○ keyVaultRG  
○ vmRG  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-21-15-24-34.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the correct answers are correct**

**Select 1 — VaultName**
The `Get-AzKeyVault` cmdlet uses the `-VaultName` parameter to identify the key vault by name. There is no `-Name` parameter on this cmdlet. Using `-Name` would cause the command to fail entirely, so `-VaultName` is the only valid choice.

**Select 2 — keyVault.VaultUri**
The `$diskEncryptionKeyVaultUrl` variable must hold the URI of the key vault. The correct property on the object returned by `Get-AzKeyVault` is `.VaultUri`. The `.Path` property does not exist on this object, and `.Url` is not a valid property either. VaultUri is the documented property that returns the vault endpoint URL required by `Set-AzVMDiskEncryptionExtension`.

**Select 3 — keyVault.ResourceId**
The `-DiskEncryptionKeyVaultId` parameter requires the Azure Resource Manager resource ID of the key vault. The correct property is `.ResourceId`. The `.Id` property is not a valid property on the key vault object returned by `Get-AzKeyVault`. ResourceId returns the full ARM resource identifier in the format `/subscriptions/.../resourceGroups/.../providers/Microsoft.KeyVault/vaults/...`.

**Select 4 — vmRG**
The `-ResourceGroupName` parameter on `Set-AzVMDiskEncryptionExtension` must reference the resource group where the **VM** resides, not where the key vault resides. The extension is applied to the VM, so Azure needs the VM's resource group to locate it. Using `$keyVaultRG` would point to the wrong resource group and the cmdlet would fail to find the VM.

**Key takeaway**
When encrypting a VM disk with Azure Key Vault, `Get-AzKeyVault` uses `-VaultName` (not `-Name`), the vault URL comes from `.VaultUri`, the vault resource ID comes from `.ResourceId`, and `Set-AzVMDiskEncryptionExtension` requires the **VM's resource group**, not the key vault's resource group.

**References**

* [Get-AzKeyVault](https://learn.microsoft.com/en-us/powershell/module/az.keyvault/get-azkeyvault)
* [Set-AzVMDiskEncryptionExtension](https://learn.microsoft.com/en-us/powershell/module/az.compute/set-azvmdiskencryptionextension)
* [Azure Disk Encryption scenarios on Windows VMs](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/disk-encryption-windows)

</details>

▶ Related Lab: [lab-vm-disk-encryption](../hands-on-labs/compute/lab-vm-disk-encryption/README.md)

---

#### Apply Change to VMSS OS and Data Disk Profile

**Domain:** Deploy and manage Azure compute resources
**Skill:** Create and configure virtual machines
**Task:** Deploy and configure an Azure Virtual Machine Scale Sets

You deploy a virtual machine scale set (VMSS) to support a critical application. The upgrade policy for the VMSS is set to Rolling.

You need to apply a change in the scale set OS and Data disk Profile for the VMSS to the existing VM images.

Which PowerShell cmdlet should you use?

A. Update-AzVmss  
B. Start-AzVmssRollingOSUpgrade  
C. Update-AzVmssInstance  
D. Set-AzVmssVM  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-23-03-46-35.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is correct (Set-AzVmssVM)**

The exam suggests using the `Set-AzVmssVM` cmdlet because it directly applies changes to the scale set OS and Data disk Profile for each existing instance. This cmdlet is used for manual updates to individual instances, bypassing the scale set model and upgrade policy.

**Why the other options are incorrect**

**Update-AzVmss**
This cmdlet updates the VMSS model, which defines the configuration for all instances in the scale set. When the upgrade policy is set to Rolling, changes to the model are automatically propagated to existing instances in batches, ensuring application availability. While this cmdlet works in practice for updating the OS and Data disk Profile, the exam question may be emphasizing direct instance-level updates, which `Set-AzVmssVM` provides.

**Start-AzVmssRollingOSUpgrade**
This cmdlet is used to upgrade existing VM instances to the latest available platform image OS version. It does not apply changes to the scale set OS or Data disk Profile.

**Update-AzVmssInstance**
This cmdlet is used to update an instance when the VMSS upgrade policy is set to Manual. It does not include changes to the scale set OS and Data disk Profile.

**Key takeaway**
For real-world scenarios, `Update-AzVmss` is the preferred cmdlet to update the VMSS model and propagate changes to all instances when using a Rolling upgrade policy. However, the exam question appears to focus on direct instance-level updates, which aligns with the `Set-AzVmssVM` cmdlet.

**References**

* [Modify a Virtual Machine Scale Set](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-upgrade-scale-set)
* [Set-AzVmssVM](https://learn.microsoft.com/en-us/powershell/module/az.compute/set-azvmssvm)
* [Update-AzVmss](https://learn.microsoft.com/en-us/powershell/module/az.compute/update-azvmss)
* [Update-AzVmssInstance](https://learn.microsoft.com/en-us/powershell/module/az.compute/update-azvmssinstance)
* [Start-AzVmssRollingOSUpgrade](https://learn.microsoft.com/en-us/powershell/module/az.compute/start-azvmssrollingosupgrade)

</details>

▶ Related Lab: [lab-vmss-rolling-upgrade](../hands-on-labs/compute/lab-vmss-rolling-upgrade/README.md)

---

### Provision and manage containers in the Azure portal

#### Configure Scaling Rules in Azure Container Apps

**Domain:** Deploy and manage Azure compute resources
**Skill:** Provision and manage containers in the Azure portal
**Task:** Manage sizing and scaling for containers, including Azure Container Instances and Azure Container Apps

You are an Azure Administrator for a company. Your company is using Azure Container Apps to run containerized applications. You are tasked with configuring scaling rules in Azure Container Apps.

You are using a custom Container Apps scaling rule based on any ScaledObject-based Kubernetes-based Event Driven Autoscaler (KEDA) scaler specification. The default scale rule is applied to your container application.

You have created the following scale rule in JSON as shown below:

```json
{
  "minReplicas": 0,
  "maxReplicas": 32,
  "rules": [
    {
      "name": "azure-servicebus-queue-rule",
      "custom": {
        "type": "azure-servicebus",
        "metadata": {
          "queueName": "my-sample-queue",
          "namespace": "service-bus-namespace",
          "messageCount": "15"
        }
      }
    }
  ]
}
```

You need to implement the solution.

For each of the following statements, select Yes if the statement is true. Otherwise, select No.

| Statement | Yes | No |
|-----------|-----|----|
| KEDA checks my-sample-queue once every 30 seconds. | ☐ | ☐ |
| If the queue length is > 15, KEDA scales the app by adding one new instance (aka replica). | ☐ | ☐ |
| The code snippet uses the TriggerAuthentication type for the authentication of objects. | ☐ | ☐ |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-06-05-55-39.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

<img src='.img/2026-03-06-05-57-51.png' width=600>

**Why the selected answers are correct**

KEDA polls the Azure Service Bus queue on a 30-second interval by default for ScaledObject-based scalers, so the statement that KEDA checks `my-sample-queue` every 30 seconds is accurate. The `messageCount` metadata value ("15") is the threshold used to trigger scaling when the number of active messages exceeds that value.

When the threshold is exceeded, KEDA initiates a scale-up. The initial scale-up step adds at least one replica; KEDA's scale-up behavior then proceeds by increasing replicas according to its step pattern (the first step starts with a single new replica and can grow in subsequent steps up to the configured maximum, here `maxReplicas: 32`). Therefore the statement that KEDA scales the app by adding one new instance when the queue length is greater than 15 is consistent with the scaler's initial scale-up behavior.

**Why the selected answer is wrong**

The code snippet does not include a `triggerAuthentication` (or `authenticationRef`) entry or any `TriggerAuthentication` object references. For KEDA to use a `TriggerAuthentication`, the scaled object must reference a `TriggerAuthentication` resource and that resource must define `secretTargetRef` entries that point to the required secrets. Because the JSON shown only contains the `custom` scaler and its `metadata`, the statement that the snippet uses the `TriggerAuthentication` type for authentication is incorrect.

**Key takeaway**

The JSON defines an Azure Service Bus scaler with a `messageCount` threshold and a `maxReplicas` cap. KEDA's default polling interval (30s) and its scale-up behavior explain why the first two statements are treated as true in the exam content, while authentication requires a separate `TriggerAuthentication` configuration which is not present in the snippet.

**References**

- [Scale App](https://learn.microsoft.com/en-us/azure/container-apps/scale-app?pivots=azure-resource-manager)
- [Scalers](https://keda.sh/docs/2.11/scalers/)
- [Scaling Deployments](https://keda.sh/docs/2.11/concepts/scaling-deployments/)
- [Authentication](https://keda.sh/docs/2.11/concepts/authentication/)

</details>

▶ Related Lab: [lab-keda-scaling-rule](../hands-on-labs/compute/lab-keda-scaling-rule/README.md)

---

### Create and configure Azure App Service

#### Resolve Azure App Service Pricing Tier for Runtime Requirements

**Domain:** Deploy and manage Azure compute resources
**Skill:** Create and configure Azure App Service
**Task:**

- Provision an App Service plan
- Configure scaling for an App Service plan

You deploy an Azure web app named MyApp. MyApp runs in a Free pricing tier service plan named MyPlan. During testing, you discover that MyApp stops after 60 minutes and that it cannot be restarted until the next day.

You need to ensure that MyApp can run eight hours each day during the testing period. You want to keep the additional costs incurred to a minimum.

Does changing the pricing tier for MyPlan to Standard S1 meet the goal?

A. Yes  
B. No  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-06-18-07.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Correct answer: No**

**Why the selected answer is incorrect**
Changing the App Service plan from **Free (F1)** to **Standard S1** does remove the 60-minute daily execution limit, so the app can run for eight hours per day. However, the solution also explicitly requires keeping **additional costs to a minimum**. Standard S1 is **not the lowest-cost plan** that satisfies the runtime requirement, so the solution does not fully meet the goal.

**Why the correct answer is correct**
While Standard S1 technically works from a functionality standpoint, it fails the cost-minimization requirement. A **Basic (B1)** plan would also allow the app to run continuously beyond 60 minutes and is **cheaper than Standard S1**, making S1 an unnecessarily expensive choice for testing.

**Why other options are less appropriate**

* Staying on **Free (F1)** is not viable because of the enforced 60-minute daily limit and the inability to restart the app the same day.
* Moving to **Standard S1** overprovisions features (such as scaling and advanced capabilities) that are not required for this scenario and increases cost unnecessarily.

**Key takeaway**
For App Service questions, always evaluate both **technical capability and cost efficiency**. If multiple plans meet the runtime requirement, the **lowest-cost qualifying tier** is the correct exam choice.

**References**

* [https://learn.microsoft.com/azure/app-service/overview-hosting-plans](https://learn.microsoft.com/azure/app-service/overview-hosting-plans)
* [https://learn.microsoft.com/azure/app-service/management-scale-up](https://learn.microsoft.com/azure/app-service/management-scale-up)
* [https://learn.microsoft.com/azure/app-service/operating-system-functionality#app-service-plan-tiers](https://learn.microsoft.com/azure/app-service/operating-system-functionality#app-service-plan-tiers)

<img src='.img/2026-02-05-02-52-17.png' width=600>

**What the ACU/vCPU column represents**

The **ACU/vCPU** column indicates the **relative CPU performance available per virtual CPU** for that App Service plan.

**ACU (Azure Compute Unit)**

* ACU is a **normalized performance score**, not a physical measurement.
* Microsoft uses it to compare CPU performance **across different underlying hardware generations**.
* Higher ACU means **more compute power per vCPU**.

**How to read the values**

* **N/A (Free F1 / Shared D1)**
  These tiers don't provide dedicated vCPUs. They run on shared infrastructure with enforced time quotas, so ACU isn't applicable.

* **100 ACU**
  Baseline compute performance. This is common for **Basic (B-series)** and **Standard (S-series)** plans and many legacy Premium plans.

* **195 ACU / 210 ACU**
  Indicates **newer, faster CPU hardware** (for example, Premium v3 or Premium v2).
  Each vCPU delivers roughly **~2× the compute performance** of a 100 ACU vCPU.

**What this means in practice (exam-relevant)**

* ACU is about **CPU speed per vCPU**, not total compute.
* Total compute = **ACU × number of vCPUs**.
* Two plans with the same vCPU count but different ACU values will have **different performance**.
* ACU does **not** change memory, storage, features, or scaling rules—only relative CPU power.

**Common exam trap**

* Assuming "1 vCPU = same performance everywhere."
  This is incorrect. A **1-vCPU plan at 195 ACU** is significantly faster than **1 vCPU at 100 ACU**.

**Key takeaway**

ACU/vCPU is a **relative CPU performance indicator**. Higher numbers mean **faster CPUs per core**, typically reflecting newer App Service hardware generations.

</details>

---

#### Configure Azure App Service Plan for Website Hosting

**Domain:** Deploy and manage Azure compute resources
**Skill:** Create and configure Azure App Service
**Task:** Provision an App Service plan

You have to provide a website hosting environment that meets the following scalability and security requirements:

* At peak loads, the web application should be able to scale up to 10 host instances.
* The web application storage requirements are minimal and will not exceed 5 GB.
* The web application will perform complex calculations and will require enhanced compute capabilities.
* The virtual machines where the web applications are hosted should be dedicated to your company only.

You need to propose an Azure App Service to host the application. The solution must ensure minimal costs.

Which Azure App Service plan should you use?

A. Premium V3  
B. Isolated  
C. Standard  
D. Shared  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-05-38-46.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is wrong (Isolated)**
You chose **Isolated**, which corresponds to an App Service Environment (ASE). While this does meet the requirement that compute resources are **dedicated to your company**, it is **not a minimal-cost solution**. Isolated plans are designed for scenarios requiring **network isolation, private endpoints, and high compliance**, and they carry **significantly higher fixed costs** (ASE infrastructure + workers), regardless of scale.
The question did **not** require VNet isolation, internal load balancing, or compliance-driven isolation—only dedicated compute.

This is a common exam trap: *“dedicated” does not automatically mean “Isolated/ASE.”*

**Why the correct answer is right (Premium V3)**
**Premium V3** satisfies **all stated requirements at lower cost**:

* **Scales to 10 instances** → Supported by Premium tiers
* **Minimal storage (< 5 GB)** → Storage is not a differentiator here
* **Enhanced compute for complex calculations** → Premium V3 provides higher CPU/memory SKUs
* **Dedicated VMs** → Premium (and Standard) plans run on **dedicated hosts**, not shared multi-tenant compute
* **Minimal cost** → Premium V3 avoids the large fixed overhead of an App Service Environment

Premium V3 is specifically positioned as the **cost-effective choice for high-performance, dedicated App Service workloads** without the complexity of ASE.

**Key takeaway**
On Azure exams, **“dedicated to your company” means “not shared (Free/Shared)”**, not “App Service Environment.”
Choose **Isolated (ASE)** only when **network isolation or compliance requirements are explicitly stated**. Otherwise, **Premium V3** is the correct balance of performance and cost.

**References**

* [https://learn.microsoft.com/azure/app-service/overview-hosting-plans](https://learn.microsoft.com/azure/app-service/overview-hosting-plans)
* [https://learn.microsoft.com/azure/app-service/environment/overview](https://learn.microsoft.com/azure/app-service/environment/overview)
* [https://learn.microsoft.com/azure/app-service/plan-manage-costs](https://learn.microsoft.com/azure/app-service/plan-manage-costs)

**Why Standard is not the correct answer**

Although **Standard** App Service plans do run on **dedicated VMs**, they fail to meet the **enhanced compute** requirement in the question.

Key limitations of Standard in this scenario:

* **Compute performance**: Standard tiers (S1–S3) offer significantly lower CPU and memory compared to Premium V3. They are intended for general-purpose workloads, not applications performing **complex calculations**.
* **Exam wording matters**: The phrase *“will perform complex calculations and will require enhanced compute capabilities”* is a strong signal on Microsoft exams to choose **Premium**, not Standard.
* **Scale headroom vs. suitability**: While Standard *can* scale to multiple instances, scaling more **underpowered instances** does not satisfy a requirement for **high-performance compute per instance**.

This is another common exam trap: focusing only on instance count and missing the **compute class** requirement.

**Why Premium V3 is still the best fit**

Premium V3 provides:

* Higher vCPU-to-memory ratios
* Better performance per instance for CPU-intensive workloads
* Faster scaling and more modern VM hardware
* Dedicated compute without ASE-level cost overhead

It is explicitly designed for **compute-heavy and performance-sensitive web applications**, which is exactly what the question describes.

**Key takeaway**

On Azure exams, when you see:

* *complex calculations*
* *enhanced compute*
* *minimal cost but not cheapest*

➡️ **Standard is too weak**, **Isolated is too expensive**, **Premium V3 is the correct balance**.

<img src='.img/2026-02-03-03-22-57.png' width=700>

**References**

* [https://learn.microsoft.com/azure/app-service/overview-hosting-plans](https://learn.microsoft.com/azure/app-service/overview-hosting-plans)
* [https://learn.microsoft.com/azure/app-service/plan-manage-costs](https://learn.microsoft.com/azure/app-service/plan-manage-costs)
* [https://learn.microsoft.com/azure/app-service/environment/overview](https://learn.microsoft.com/azure/app-service/environment/overview)

</details>

▶ **Related Lab:** [lab-app-service-plan-tiers](../hands-on-labs/compute/lab-app-service-plan-tiers/README.md)

---

#### Resolve Azure App Service Pricing Tier for Runtime Requirements

**Domain:** Deploy and manage Azure compute resources
**Skill:** Create and configure Azure App Service
**Task:**

- Provision an App Service plan
- Configure scaling for an App Service plan

You deploy an Azure web app named MyApp. MyApp runs in a Free pricing tier service plan named MyPlan. During testing, you discover that MyApp stops after 60 minutes and that it cannot be restarted until the next day.

You need to ensure that MyApp can run eight hours each day during the testing period. You want to keep the additional costs incurred to a minimum.

Does changing the pricing tier for MyPlan to Basic B1 meet the goal?

A. Yes  
B. No  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-06-17-46.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why "Yes" is correct**
Changing the App Service plan from **Free (F1)** to **Basic (B1)** removes the **Free/Shared quota enforcement** behavior. In Free/Shared tiers, Azure enforces CPU/Bandwidth quotas; when the app exceeds its quota (for example, CPU (Day)), the app is **stopped until the quota resets** (which matches "stops after 60 minutes" and "can't be restarted until the next day"). Scaling up to a dedicated tier (Basic) avoids those per-app CPU-minute/day quotas, allowing the app to run for the required **8 hours/day**.

**Why "No" would be a trap**
A common misconception is that "Free just means no SLA" or "it only affects performance." In reality, Free/Shared tiers have **hard quotas** that can stop the app for the rest of the day once exceeded.

**Cost reasoning (exam perspective)**
Basic **B1** is typically the lowest-cost **dedicated compute** App Service plan tier. Since the requirement is to run several hours daily, moving to the cheapest dedicated tier is the minimal-cost way to meet the runtime goal.

**Key takeaway**
Free/Shared App Service plans can stop apps when usage quotas are exceeded; moving to a dedicated tier like **Basic B1** eliminates that daily CPU-minute quota enforcement and meets the 8-hours/day requirement.

<img src='.img/2026-02-05-04-17-27.png' width=800>

**References**

* [https://learn.microsoft.com/en-us/azure/app-service/web-sites-monitor](https://learn.microsoft.com/en-us/azure/app-service/web-sites-monitor)
* [https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans](https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans)

</details>

---

#### Resolve Azure App Service Pricing Tier for Runtime Requirements

**Domain:** Deploy and manage Azure compute resources
**Skill:** Create and configure Azure App Service
**Task:**

- Provision an App Service plan
- Configure scaling for an App Service plan

You deploy an Azure web app named MyApp. MyApps runs in a Free pricing tier service plan named MyPlan. During testing, you discover that MyApp stops after 60 minutes and that it cannot be restarted until the next day.

You need to ensure that MyApp can run eight hours each day during the testing period. You want to keep the additional costs incurred to a minimum.

Does changing the pricing tier for MyPlan to Shared D1 meet the goal?

A. Yes  
B. No  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-06-17-12.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is wrong (Yes)**
Moving from **Free (F1)** to **Shared (D1)** increases the daily CPU quota, but it **does not remove quotas**. Your symptom ("stops after 60 minutes and can't be restarted until the next day") matches hitting the **CPU (Day)** quota, which causes the app to be stopped until the quota resets. In Shared (D1), the app can still hit **CPU (Day)** and be stopped again—just later—so it won't reliably run **8 hours/day**.

**Why the correct answer is correct (No)**
To meet "run 8 hours each day," you need a plan where you **don't get stopped due to Free/Shared quotas**. That generally means moving to a **Dedicated compute** tier (Basic/Standard/Premium), where the app runs on dedicated VMs and the Free/Shared CPU (Day) quota enforcement doesn't apply in the same way. Shared (D1) remains a shared-compute tier with quota enforcement, so it doesn't meet the requirement.

**Why other options are incorrect or less appropriate**

* **Stay on Free (F1):** guaranteed to stop once the quota is exceeded (as observed).
* **Shared (D1):** still quota-enforced; may extend runtime but not to the required 8 hours consistently.
* **Basic (B1) or higher:** costs more than Shared, but it's the minimum tier change that aligns with the requirement to keep the app running during the testing window.

**Key takeaway**
**Free and Shared tiers have CPU quotas that can stop the app until the daily reset.** If you need predictable multi-hour runtime, move to a **Dedicated compute** tier (Basic or higher).

**References**

* [https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans](https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans)
* [https://learn.microsoft.com/en-us/azure/app-service/web-sites-monitor](https://learn.microsoft.com/en-us/azure/app-service/web-sites-monitor)

</details>

▶ **Related Lab:** [lab-app-service-plan-quotas](../hands-on-labs/compute/lab-app-service-plan-quotas/README.md)

---

#### Prepare Azure App Service for Web App Republication

**Domain:** Deploy and manage Azure compute resources
**Skill:** Create and configure Azure App Service
**Task:**

- Create an App Service
- Configure deployment slots for an App Service

You are developing a new web app. The source code is located in an Azure DevOps Git repository. Before you move the web app into production, its functionality must be reviewed by your test users.

You need to prepare the target environment to be ready to republish the web app.

Which four commands should you run in sequence? To answer, move the appropriate commands from the list of possible commands to the answer area and arrange them in the correct order.

Available options:

* Publish-AzWebApp  
* New-AzAppServicePlan  
* New-AzResourceGroup  
* New-AzWebAppSlot  
* Start-AzWebAppSlot  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-06-12-43.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is wrong**

Your sequence prepares Azure infrastructure objects but **never deploys the application code** from the Azure DevOps Git repository.
The exam question explicitly states that the target environment must be ready to **republish the web app** so test users can review functionality. That implies pushing code into an App Service (or slot), not just provisioning resources.

Specific issues with your sequence:

* **New-AzWebAppSlot** is unnecessary unless the question explicitly mentions deployment slots. Slots are optional, not required to republish.
* **Start-AzWebAppSlot** is redundant in most exam scenarios. Newly created web apps and slots start automatically.
* **Publish-AzWebApp** (or equivalent deployment command) is missing, which is the key step that actually deploys the application.
* You created infrastructure only; no deployment occurred.

This is a common exam trap: confusing *environment preparation* with *application deployment*.

**Why the correct answer is right**

The correct sequence includes the deployment step and follows the required dependency order:

1. **New-AzResourceGroup**
   A resource group must exist before any App Service resources can be created.

2. **New-AzAppServicePlan**
   An App Service Plan is required before creating a web app.

3. **New-AzWebApp**
   Creates the App Service that will host the application.

4. **Publish-AzWebApp**
   Deploys the application code so testers can access and validate functionality.

This sequence ensures:

* Infrastructure dependencies are respected.
* The web app actually contains code to test.
* The environment is truly “ready to republish,” per the wording of the question.

**Key takeaway**

On Azure exams, **“prepare the environment to republish” always includes deploying code**, not just creating resources.
If a deployment-related command is available (like `Publish-AzWebApp`) and the scenario involves testers or validation, it is almost always required.

**References**

* [https://learn.microsoft.com/azure/app-service/overview](https://learn.microsoft.com/azure/app-service/overview)
* [https://learn.microsoft.com/powershell/module/az.websites/new-azwebapp](https://learn.microsoft.com/powershell/module/az.websites/new-azwebapp)
* [https://learn.microsoft.com/powershell/module/az.websites/publish-azwebapp](https://learn.microsoft.com/powershell/module/az.websites/publish-azwebapp)
* [https://learn.microsoft.com/azure/app-service/deploy-local-git](https://learn.microsoft.com/azure/app-service/deploy-local-git)

</details>

▶ **Related Lab:** [lab-app-service-republication](../hands-on-labs/compute/lab-app-service-republication/README.md)

---

### Automate deployment of resources by using Azure Resource Manager (ARM) templates or Bicep files

#### Convert Array to Object

**Domain:** Deploy and manage Azure compute resources
**Skill:** Automate deployment of resources by using Azure Resource Manager (ARM) templates or Bicep files
**Task:** Modify an existing Bicep file

You are an Azure administrator for a company. You are deploying Azure resources using Bicep and you want to use Lambda functions to handle an array.

You need to convert an array to an object with a custom key function and optional custom value function to produce the following output:

{"MrFunny":{"name":"MrFunny","age":2},"MrNaughty":{"name":"MrNaughty","age":3}}

Which Lambda function should you use to complete the code snippet below? To answer, select the appropriate option from the drop-down menu.

```
var cats = [
  {
    name: 'MrFunny'
    age: 2
  }
  {
    name: 'MrNaughty'
    age: 3
  }
]

output twocats object = ___[1]___ (cats, entry => entry.name)
```

Drop-Down Options:

<!-- Dropdown options not yet provided. Paste screenshots of each expanded drop-down to populate. -->

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-03-04-28-34.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

Lambda expressions (or lambda functions) are essentially blocks of code that can be passed as an argument. They can take multiple parameters but are restricted to a single line of code. In this scenario, you need to convert an array to an object with a custom key function and optional custom value function. To do this, you should use the toObject lambda function. In this scenario, you use the toObject with two required parameters: output twocats object = toObject(cats, entry => entry.name), which produces the following output:

{"MrFunny":{"name":"MrFunny","age":2},"MrNaughty":{"name":"MrNaughty","age":3}}

You should not use the map lambda function. You would use map lambda function when you want to apply a custom mapping function to each element of an array.

You should not use the reduce lambda function. You would use the reduce lambda function when you want to reduce an array with a custom reduce function. This would not produce the desired output since the return value is an array and not an object.

You should not use sort lambda function. You would use the sort lambda function when you want to sort an array with a custom sort function.

<img src='.img/2026-03-03-04-32-17.png' width=600>

<img src='.img/2026-03-03-04-32-49.png' width=600>

References

* [Bicep Functions Lambda - ToObject](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions-lambda#toobject)
* [Bicep Functions Lambda - Map](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions-lambda#map)p>

</details>

---

#### Resource dependencies in Bicep

**Domain:** Deploy and manage Azure compute resources
**Skill:** Automate deployment of resources by using Azure Resource Manager (ARM) templates or Bicep files
**Task:** Interpret an Azure Resource Manager template or a Bicep file

You are an Azure Administrator for an eCommerce organization. You are deploying Azure resources and have created a Bicep file as shown below:

```bicep
resource PrimaryDnsZone 'Microsoft.Network/dnszones@2018-05-01' = {
  name: 'myZone'
  location: 'global'
}

resource otherResource 'Microsoft.Example/examples@2023-05-01' = {
  name: 'egResource'
  properties: {
    // get read-only DNS zone property
    nameServers: PrimaryDnsZone.properties.nameServers
  }
}

resource otherZone 'Microsoft.Network/dnszones@2023-06-01' = {
  name: 'demoZone2'
  location: 'global'
  dependsOn: [
    PrimaryDnsZone
  ]
}
```

For each of the following statements, select Yes if the statement is true. Otherwise, select No.

| Statement | Yes | No |
|----------|-----|----|
| The resource named otherResource is implicitly dependent on PrimaryDnsZone. | ☐ | ☐ |
| The resource named otherZone is implicitly dependent on PrimaryDnsZone. | ☐ | ☐ |
| Azure Resource Manager deploys the PrimaryDnsZone and otherZone resources in parallel. | ☐ | ☐ |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-03-03-30-51.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

There are two kinds of resource dependencies in Azure Bicep. An implicit dependency is created when one resource declaration references another resource in the same deployment. The other type is referred to as an explicit dependency, where you use the dependsOn property. The dependsOn property accepts an array of resource identifiers, so you can specify more than one dependency. You can specify a nested resource dependency by using the :: operator.

The resource named otherResource is implicitly dependent on PrimaryDnsZone. The `nameServers: PrimaryDnsZone.properties.nameServers` in otherResource uses an implicit dependency.

The resource named otherZone is not implicitly dependent on PrimaryDnsZone. The otherZone uses the `dependsOn: [ PrimaryDnsZone ]`, which denotes that otherZone resource uses an explicit dependency.

Azure Resource Manager (ARM) does not deploy the PrimaryDnsZone and otherZone resources in parallel. ARM only deploys resources in parallel if the resources are not dependent on one another. In this scenario, since the otherZone resource is explicitly dependent on the PrimaryDnsZone resource, ARM will not deploy the resources in parallel.

References

* [Resource dependencies in Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/resource-dependencies)

</details>

---

## Implement and manage virtual networking

### Configure secure access to virtual networks

#### Configure Private Link Service Source IP

**Domain:** Implement and manage virtual networking
**Skill:** Configure secure access to virtual networks
**Task:** Configure private endpoints for Azure PaaS

You are an Azure administrator for an e-commerce company. Your organization wants to access Azure SQL Database services and Azure-hosted customer-owned resources over a private endpoint in your virtual network (VNet).

You use Azure Private Link service to achieve the desired outcome.

You need to select a source IP address for your Azure Private Link service.

You have created the following JSON code in order to use an Azure Resource Manager (ARM) template.

```json
{
  "name": "orgvirtualN",
  "type": "Microsoft.Network/virtualNetworks",
  "apiVersion": "2023-02-01",
  "location": "EastUS",
  "properties": {
    "addressSpace": {
      "addressPrefixes": [
        "10.1.0.0/16"
      ]
    },
    "subnets": [
      {
        "name": "default",
        "properties": {
          "addressPrefix": "10.1.4.0/24",
          "privateLinkServiceNetworkPolicies": "Disabled"
        }
      }
    ]
  }
}
```

For each of the following statements, select Yes if the statement is true. Otherwise, select No.

| Statement | Yes | No |
|-----------|-----|----|
| The "privateLinkServiceNetworkPolicies": "Disabled" setting is only applicable for the specific private IP address you select as the source IP of the Private Link service. | ☐ | ☐ |
| The "privateLinkServiceNetworkPolicies": "Disabled" setting is configured automatically if you are using Azure portal to create a Private Link service. | ☐ | ☐ |
| For other resources in the subnet, network traffic is filtered by Access Control Lists (ACL). | ☐ | ☐ |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-26-03-33-48.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why statement 1 is true**  
The privateLinkServiceNetworkPolicies:"Disabled" setting disables subnet-level network policies for the specific private IP used by the Private Link service source IP. It applies to that chosen private IP (the Private Link endpoint) so you can accept inbound Private Link connections.

**Why statement 2 is true**  
When you create a Private Link service through the Azure portal, the portal configures the required privateLinkServiceNetworkPolicies disablement automatically. When using ARM/CLI/PowerShell you must set the property explicitly.

**Why statement 3 is false**  
Access Control Lists (ACLs) refer to data-level access (for example, ADLS folder ACLs) and do not filter subnet network traffic. Network traffic for resources in the subnet is controlled by network security group (NSG) rules and other network policy mechanisms.

**Key takeaway**  
Disabling privateLinkServiceNetworkPolicies is a per‑private‑IP (per Private Link source IP) setting; the portal can handle it for you, but templates/CLI/PowerShell require you to set it explicitly. Network traffic filtering is enforced by NSGs, not ACLs.

**References**

- [Disable Private Link Service Network Policy](https://learn.microsoft.com/en-us/azure/private-link/disable-private-link-service-network-policy?tabs=private-link-network-policy-powershell)

</details>

▶ Related Lab: [lab-private-link-service](../hands-on-labs/networking/lab-private-link-service/README.md)

---

### Configure name resolution and load balancing

#### IMDS Load Balancer Metadata Error

**Domain:** Implement and manage virtual networking
**Skill:** Configure name resolution and load balancing
**Task:** Troubleshoot load balancing

Your organization is using an Azure Load Balancer service. You are the Azure administrator in your organization.

You are tasked with retrieving Load Balancer information using Azure Instance Metadata Service (IMDS).

You see the following error message:

`Error code: 404; No load balancer metadata is found.`

You need to troubleshoot this issue.

Which two things can you infer from the error message? Each correct answer presents a complete solution.

A. There is a rate limit.  
B. The path is misconfigured.  
C. The load balancer has the Basic instead of the Standard SKU.  
D. The virtual machine is not associated with a load balancer.  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-03-04-57-09.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

The Azure Instance Metadata Service (IMDS) provides information about currently running virtual machine instances. The Instance Metadata Service is only accessible from within a running virtual machine instance on a non-routable IP address.

You can use the SKU, storage, network configurations, and upcoming maintenance events-related information effectively for managing and configuring the virtual machines. In this scenario, since the retrieved data from IMDS displays the No load balancer metadata is found error message, this could be owing to either of the following two reasons:

1. The virtual machine is not associated with a load balancer.

2. The load balancer has the Basic instead of Standard SKU.

The error code does not indicate a misconfiguration of the path. In such a case, you would see Error 404, but with a different error message displayed:

404; API is not found: Path = "<UrlPath>", Method = "<Method>".

The error code does not indicate a rate limit. In this case, you would see Error 429 displayed with the "Too many requests" message.

<img src='.img/2026-03-03-05-00-22.png' width=600>

<img src='.img/2026-03-03-05-03-19.png' width=600>

> Basic Load Balancer SKU was retired in 2025.

References

- [Instance Metadata Service](https://learn.microsoft.com/en-us/azure/virtual-machines/instance-metadata-service?tabs=windows)
- [Load Balancer SKUs](https://learn.microsoft.com/en-us/azure/load-balancer/skus)

</details>

---

#### Configure DNS Records for App Service

**Domain:** Implement and manage virtual networking
**Skill:** Configure name resolution and load balancing
**Task:** Configure Azure DNS

Your company plans to release a new web application called 'appilcations'. This application is deployed by using an App Service in Azure and will be available to users of the company1.com domain. You have already purchased the company1.com domain name.

You configure the company1.com Azure DNS zone and delegate it to Azure DNS.

You need to ensure that web application can be accessed by using the company1.com domain name.

You decide to use PowerShell to accomplish this task.

How should you complete the command? To answer, select the appropriate options from the drop-down menus.

```powershell
New-AzDnsRecordSet -Name ___[1]___ -RecordType ___[2]___ `
  -ZoneName "company1.com" -ResourceGroupName "APP-RG" -Ttl 600 `
  -DnsRecords (New-AzDnsRecordConfig `
  -IPv4Address "<IP address>")

New-AzDnsRecordSet -ZoneName company1.com -ResourceGroupName APP-RG `
  -Name ___[3]___ -RecordType ___[4]___ -Ttl 600 `
  -DnsRecords (New-AzDnsRecordConfig -Value "appilcations.azurewebsites.net")
```

Drop-Down Options:

<!-- Dropdown options not yet provided. Paste screenshots of each expanded drop-down to populate. -->

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-03-03-06-02.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>
**Why the selected answers are correct**  
Create an A record named "@" with RecordType "A" to map the root of company1.com to the App Service's IPv4 address. Create a TXT record named "@" with RecordType "TXT" and value "appilcations.azurewebsites.net" so App Service can verify domain ownership and configure the custom domain settings.

**Why other options are incorrect**  

- CNAME/CNAME-like approaches are wrong for the root (@"") because a CNAME cannot coexist with other records at the zone apex and cannot point to an IPv4 address.  
- AAAA is for IPv6 addresses; the App Service verification here requires an IPv4 A record.  
- Using literal names like "company1.com", "www.company1.com", or "appilcations.azurewebsites.net" as the Name value would either be redundant, create the wrong record target, or prevent apex records from working as intended.

**Key takeaway**  
Use an A record (Name "@", RecordType "A") for the IPv4 mapping of the root domain and a TXT record (Name "@", RecordType "TXT") for App Service domain verification; avoid CNAME at the zone apex and do not use AAAA unless you have an IPv6 IP.

<img src='.img/2026-03-03-03-19-52.png' width=600>

<img src='.img/2026-03-03-03-20-54.png' width=600>

References

* [DNS Web Sites Custom Domain](https://learn.microsoft.com/en-us/azure/dns/dns-web-sites-custom-domain?tabs=azure-portal)

</details>

---

#### Diagnose Internal Load Balancer Hairpin Traffic Failure

**Domain:** Implement and manage virtual networking
**Skill:** Configure name resolution and load balancing
**Task:** Troubleshoot load balancing

You are an Azure administrator at an independent software vendor. Your company is using an Azure internal load balancer that is configured inside an Azure virtual network (VNet).

Your virtual machines (VMs) comprising the backend pool VM behind the load balancer are listed as healthy and respond to the health probes. However, the backend VMs are not responding to traffic on the configured data port.

You diagnose and find that one of the participant backend VMs is trying to access the internal load balancer frontend, resulting in the failure of data flow.

You need to troubleshoot this issue.

Which two actions should you perform? Each correct answer presents a complete solution.

A. Combine the Azure internal load balancer with a third-party proxy (e.g., Nginx).  
B. Configure separate backend pool VMs per application.  
C. Evaluate the network security groups (NSGs) configured on the backend VM, list them, and reconfigure the NSG rules on the backend VMs.  
D. Use internal Application Gateway with HTTP/HTTPS.  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-05-30-07.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is wrong**

**Configure separate backend pool VMs per application** does not address the actual failure mode.
The issue described is a **backend VM attempting to access the internal load balancer (ILB) frontend**, which causes **hairpin (loopback) traffic**. Azure **Standard Internal Load Balancer does not support backend instances directly calling the ILB frontend**. Even if health probes succeed, the backend VMs cannot access the ILB frontend. Splitting applications into separate backend pools does not change the traffic pattern, so the data path still fails.

This option is a design reorganization, not a troubleshooting or functional fix.

**Why the correct answers are right**

**Combine the Azure internal load balancer with a third-party proxy (e.g., Nginx)**
A proxy running on a VM breaks the hairpin scenario by terminating the connection and re-initiating traffic to the backend. This is a valid workaround because:

* Azure ILB does not support backend instances directly calling the ILB frontend
* A proxy introduces a new source IP and symmetric flow
* This is a documented and supported pattern for resolving ILB loopback limitations

**Use internal Application Gateway with HTTP/HTTPS**
Application Gateway **does support backend-to-frontend scenarios** because it operates at Layer 7 and manages connections differently:

* It avoids the SNAT/loopback limitation of Azure Load Balancer
* It is explicitly designed for HTTP/HTTPS internal routing
* Backend instances can safely access the frontend endpoint

This is a complete architectural fix when the workload is HTTP/HTTPS-based.

**Why the other option is not correct**

**Evaluate and reconfigure NSGs on the backend VMs**
NSGs are not the problem here:

* Health probes are succeeding, which already proves NSGs allow required traffic
* The failure is due to **load balancer behavior**, not packet filtering
* NSG changes cannot fix ILB hairpin traffic limitations

**Key takeaway**

Azure **Internal Load Balancer does not support backend VMs accessing the ILB frontend**. When this traffic pattern is required, you must introduce an intermediary (proxy) or switch to a service like **Application Gateway** that supports it. Configuration-only changes (backend pools, NSGs) do not resolve this limitation.

**References**

* [Cause 4: Access of the internal load balancer frontend from the participating load balancer backend pool VM](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-troubleshoot-backend-traffic#cause-4-access-of-the-internal-load-balancer-frontend-from-the-participating-load-balancer-backend-pool-vm)

* Azure Load Balancer limitations and hairpinning:
  [https://learn.microsoft.com/azure/load-balancer/load-balancer-troubleshoot#hairpinning](https://learn.microsoft.com/azure/load-balancer/load-balancer-troubleshoot#hairpinning)

* Azure Application Gateway overview:
  [https://learn.microsoft.com/azure/application-gateway/overview](https://learn.microsoft.com/azure/application-gateway/overview)

* Azure Load Balancer architecture and behavior:
  [https://learn.microsoft.com/azure/load-balancer/load-balancer-overview](https://learn.microsoft.com/azure/load-balancer/load-balancer-overview)

</details>

▶ **Related Lab:** [lab-ilb-backend-access](../hands-on-labs/networking/lab-ilb-backend-access/README.md)

---

#### Configure Standard Load Balancer Outbound Traffic and IP Allocation

**Domain:** Implement and manage virtual networking
**Skill:** Configure name resolution and load balancing
**Task:** Configure an internal or public load balancer

You deploy three Windows virtual machines (VMs) named VM01, VM02, and VM03 that host the front-end layer of a web application. You configure a Standard Load Balancer named LB01. VM01, VM02, and VM03 are configured as part of the backend pool for LB01. You configure a load balancing rule for Transmission Control Protocol (TCP) traffic only.

You also configure three public static IP addresses named IP01, IP02, and IP03 which are assigned as follows:

* IP01 is assigned to VM01.  
* IP02 and IP03 are assigned to LB01.  

For each of the following statements, select Yes if the statement is true. Otherwise, select No.

| STATEMENT | YES | NO |
|-----------|-----|-----|
| Outbound flow on VM01 will always use IP02. | | |
| Outbound flow on LB01 uses IP02 and IP03 at the same time. | | |
| Outbound flow on VM03 will use IP02 or IP03 for User Datagram Protocol (UDP) traffic. | | |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-05-53-50.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why your selected answers are incorrect**

* **Outbound flow on LB01 uses IP02 and IP03 at the same time — you selected No (incorrect).**
  A *Standard* Load Balancer with multiple outbound public IP addresses can use **multiple SNAT IPs concurrently**. Azure hashes outbound flows (per 5-tuple) across the available frontend public IPs. This means LB01 **can actively use both IP02 and IP03 at the same time**, even though any single flow uses only one IP.

* **Outbound flow on VM03 will use IP02 or IP03 for UDP traffic — you selected Yes (incorrect).**
  Your load balancing rule is configured for **TCP only**. UDP traffic is **not associated with the load balancer rule**, so it does **not** use the load balancer’s outbound SNAT IPs (IP02/IP03). Instead, UDP outbound traffic from VM03 uses the VM’s **own assigned public IP if present**, or default outbound behavior if not. The presence of a TCP-only rule is the key trap here.

**Why the correct answers are correct**

* **Outbound flow on VM01 will always use IP02 — No (correct).**
  VM01 has its own public IP (IP01). Azure prefers a VM’s **directly assigned public IP** for outbound traffic over load balancer SNAT. Therefore, VM01 does not “always” use IP02.

* **Outbound flow on LB01 uses IP02 and IP03 at the same time — Yes (correct).**
  Standard Load Balancer supports **multiple outbound frontend IPs**, distributing outbound connections across them. This increases SNAT port capacity and resiliency.

* **Outbound flow on VM03 will use IP02 or IP03 for UDP traffic — No (correct).**
  Since the load balancing rule is TCP-only, UDP traffic bypasses the load balancer’s SNAT configuration entirely.

**Key takeaway**

* **Standard Load Balancer outbound SNAT applies only to traffic matching its rules (TCP in this case).**
* **Multiple outbound public IPs can be used concurrently.**
* **A VM’s own public IP always takes precedence for outbound traffic.**

**References**

* [https://learn.microsoft.com/azure/load-balancer/load-balancer-outbound-connections](https://learn.microsoft.com/azure/load-balancer/load-balancer-outbound-connections)
* [https://learn.microsoft.com/azure/load-balancer/load-balancer-standard-overview](https://learn.microsoft.com/azure/load-balancer/load-balancer-standard-overview)
* [https://learn.microsoft.com/azure/virtual-network/ip-services/public-ip-addresses](https://learn.microsoft.com/azure/virtual-network/ip-services/public-ip-addresses)

</details>

▶ **Related Lab:** [lab-slb-outbound-traffic](../hands-on-labs/networking/lab-slb-outbound-traffic/README.md)

---

## Monitor and maintain Azure resources

### Monitor resources in Azure

#### Capture SFTP Packets with Network Watcher

**Domain:** Monitor and maintain Azure resources
**Skill:** Monitor resources in Azure
**Task:** Use Azure Network Watcher and Connection Monitor

You deploy several virtual machines (VMs) for different purposes. You deploy Network Watcher in the East US region.

You see some odd traffic on a virtual machine named VM01. This machine is making connections to an unknown Secure File Transfer Protocol (SFTP) service.

You need to configure a filter for capturing those packets for the unknown SFTP service. You decide to use PowerShell for this task.

How should you complete the PowerShell script? To answer, select the appropriate options from the drop-down menus.

```powershell
$res = Get-AzResource | Where {$_.ResourceType -eq ___[1]___ -and $_.Location -eq "EastUS"}

$networkWatcher = Get-AzNetworkWatcher -Name $res.Name -ResourceGroupName $res.ResourceGroupName
$diagnosticSA = Get-AzStorageAccount -ResourceGroupName Diagnostics-RG `
  -Name "Diagnostics-Storage"

$filter1 = New-AzPacketCaptureFilterConfig -Protocol TCP `
  -RemoteIPAddress ___[2]___ `
  -LocalIPAddress "10.0.0.3" -LocalPort ___[3]___ -RemotePort ___[4]___

New-AzNetworkWatcherPacketCapture -NetworkWatcher ___[5]___ `
  -TargetVirtualMachineId $vm.Id `
  -PacketCaptureName "Capture SFTP Traffic" -StorageAccountId $diagnosticSA.Id `
  -TimeLimitInSeconds 60 -Filter $filter1
```

Drop-Down Options:

| Blank | Options |
|-------|---------|
| [1] | -Select- / Microsoft.Network/networkWatchers / Microsoft.Network/networkWatchers/packetCaptures |
| [2] | -Select- / "0.0.0.0" / "0.0.0.0-255.255.255.255" |
| [3] | -Select- / "0" / "1-65535" / "20;21" / "20-21" / "22" |
| [4] | -Select- / "0" / "1-65535" / "20;21" / "20-21" / "22" |
| [5] | -Select- / New-AzNetworkWatcher / New-AzNetworkWatcherPacketCapture |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-27-03-19-02.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is wrong**  
The filter and cmdlet choices in the original answer are incorrect for capturing unknown SFTP traffic. You should target the Network Watcher resource type, use a remote IP range that captures any possible destination, allow the full dynamic range for the local (ephemeral) port, and filter for the SFTP service port.

**Why the correct answer is correct**  

- Use Microsoft.Network/networkWatchers to find the existing Network Watcher in the East US region.  
- Use "0.0.0.0-255.255.255.255" for -RemoteIPAddress because you do not know the remote SFTP server IP; this selects any remote address the VM may contact.  
- Use "1-65535" for -LocalPort because outgoing connections use ephemeral local ports chosen dynamically by the OS.  
- Use "22" for -RemotePort because SFTP runs over SSH (TCP port 22).  
- Use New-AzNetworkWatcherPacketCapture with -NetworkWatcher $networkWatcher and -Filter $filter1 to start a packet capture on the existing Network Watcher; this cmdlet applies the filter to the VM capture and stores results in the specified storage account.

**Key takeaway**  
When creating a packet capture for unknown outbound service endpoints, allow any remote IP, permit the full local ephemeral port range, filter on the known service port (22 for SFTP), and run the capture with New-AzNetworkWatcherPacketCapture against the existing Network Watcher.

References

* [Manage Packet Captures with Network Watcher](https://learn.microsoft.com/en-us/azure/network-watcher/packet-capture-manage?tabs=portal)

</details>

▶ Related Lab: [lab-capture-sftp-packets](../hands-on-labs/monitoring/lab-capture-sftp-packets/README.md)

---

#### Storage Insights Overview

**Domain:** Monitor and maintain Azure resources
**Skill:** Monitor resources in Azure
**Task:** Configure and interpret monitoring of virtual machines, storage accounts, and networks by using Azure Monitor Insights

You are an Azure administrator at a retail organization. Your organization uses 4,500 Azure storage accounts across two Azure subscriptions.

You have been tasked with performing an audit by implementing the following:

1. Identification of storage accounts with no use.  
2. Enabling of viewing interactive storage metrics for 4,500 Azure storage accounts across both Azure subscriptions.  
3. Customized dashboard coloring for availability.

You have decided to use the Storage Insights view in Azure Monitor.

You need to implement the solution.

For each of the following statements, select Yes if the statement is true. Otherwise, select No.

| STATEMENT | YES | NO |
|-----------|-----|----|
| You can sort your storage accounts in ascending order by using the Transactions column to identify storage accounts with no use. | ☐ | ☐ |
| The Overview workbook for selected subscriptions will exhibit up to 500 storage accounts. | ☐ | ☐ |
| You can apply customized coloring in the Availability threshold section. | ☐ | ☐ |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-03-04-04-42-35.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

Storage Insights is a dashboard on top of Azure Storage metrics and logs. You can use Storage Insights to examine the transaction volume and used capacity of all your accounts.

You can sort your storage accounts in ascending order by using the Transactions column in the Storage Insights view in Azure Monitor to identify storage accounts with no use.

The Overview workbook for selected subscriptions will not exhibit up to 500 storage accounts. In the Overview workbook, which displays data for a selected subscription, the table displays interactive storage metrics and service availability state. The data is displayed for up to five storage accounts grouped together. If you select all or multiple storage accounts in the scope selector, up to 200 storage accounts will be returned. In this scenario, since you have 4,500 Azure storage accounts across two Azure subscriptions, if you select both Azure subscriptions, only 200 accounts would be displayed at a maximum.

You can apply customized coloring in the Availability threshold section.

<img src='.img/2026-03-04-04-53-05.png' width=600>

<img src='.img/2026-03-04-05-01-25.png' width=600>

<img src='.img/2026-03-04-05-01-35.png' width=600>

<img src='.img/2026-03-04-05-09-02.png' width=800>

References

- [Blob Storage Monitoring Scenarios](https://learn.microsoft.com/en-us/azure/storage/blobs/blob-storage-monitoring-scenarios)
- [Storage Insights Overview](https://learn.microsoft.com/en-us/azure/storage/common/storage-insights-overview?toc=%2Fazure%2Fazure-monitor%2Ftoc.json)

</details>

---

#### Configure Azure Monitor Alert for Database CPU Usage

**Domain:** Monitor and maintain Azure resources
**Skill:** Monitor resources in Azure
**Task:** Set up alert rules, action groups, and alert processing rules in Azure Monitor

Your company has a line-of-business (LOB) application that uses Azure SQL Database for storing transactional information. Your company also has System Center Service Manager deployed.

You need to configure an alert when the database reaches 70% of central processing unit (CPU) usage. When this alert rises, you need to notify several users by email and by SMS. You also need to automatically create a ticket in the IT service management (ITSM) system. Your solution should require minimum administrative effort.

Which two actions should you perform? Each correct answer presents part of the solution.

A. Configure System Center Service Manager with Azure Automation.  
B. Configure one action group with two actions: one for email and SMS notification and one for IT service management (ITSM) ticket creation.  
C. Configure an IT Service Management Connector (ITSMC).  
D. Configure two action groups: one for email and SMS notification and one for IT service management (ITSM) ticket creation.  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-05-26-15.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**The correct answers are B and C.**

**Why B is correct:**
Azure Monitor action groups are designed to consolidate multiple notification and automation actions into a single reusable unit. One action group can contain email, SMS, voice, webhook, Logic App, Automation Runbook, and ITSM actions together. This design allows you to configure all required notifications and ticket creation in a single action group, which minimizes administrative overhead and is the recommended approach.

**Why C is correct:**
ITSM ticket creation in Azure Monitor requires an IT Service Management Connector (ITSMC) to bridge Azure Monitor alerts with system-center or third-party ITSM systems. Without the ITSMC, Azure Monitor cannot create incidents or tickets in Service Manager, regardless of how the action group is configured.

**Why A is incorrect:**
While Azure Automation can integrate with Azure Monitor, it is not a requirement for basic ITSM alerting. The ITSMC provides direct integration without needing custom automation runbooks.

**Why D is incorrect:**
Creating separate action groups for different notification types adds unnecessary complexity and administrative effort. Azure Monitor is designed to support multiple actions within a single action group, making D an inefficient solution.

**Key takeaway:**
For Azure Monitor alerts requiring multiple notification methods and ITSM integration, use a **single action group with multiple actions** and configure an **ITSM Connector** for Service Manager integration. This minimizes administrative overhead and follows Azure best practices.

</details>

---

#### Load Balancer Metrics Batch API

**Domain:** Monitor and maintain Azure resources
**Skill:** Monitor resources in Azure
**Task:** Interpret metrics in Azure Monitor

Your company uses an Azure standard public load balancer. You are the Azure administrator at your company.

You have been tasked with troubleshooting common outbound connectivity issues with Azure Load Balancer.

You want to proactively monitor the data path availability and perform health probe status checks on the load balancer.

You create the following metrics:getBatch API request shown below:

```
POST /subscriptions/87654765-4321-9999-1251-4532243211xfe/metrics:getBatch?metricNamespace=microsoft.compute/virtualMachines&api-version=2023-03-01-preview
Host: eastus.metrics.monitor.azure.com
Content-Type: application/json
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJh...XaTddvfcFlgsas
{
   "resourceids":[".../virtualMachines/vmss-002_1sdf4cc9",
   ".../virtualMachines/vmss-003_s1187c3h"]
}
```

You need to retrieve multi-dimensional definitions and metrics programmatically via APIs.

For each of the following statements, select Yes if the statement is true. Otherwise, select No.

| Statement | Yes | No |
|----------|-----|----|
| The metrics:getBatch API here allows you to prevent throttling and performance issues when querying multiple resources in a single REST request. | ☐ | ☐ |
| Both VMs vmss-002_1sdf4cc9 and vmss-003_s1187c3h can be spread across multiple Azure regions. | ☐ | ☐ |
| Both VMs vmss-002_1sdf4cc9 and vmss-003_s1187c3h must be the same resource type. | ☐ | ☐ |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-20-16-52-36.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why Statement 1 is Yes (correct)**

The metrics:getBatch API was designed to query metrics for multiple resources in a single HTTP request. Rather than issuing one API call per resource — which scales poorly and can trigger throttling — batching all resource IDs into a single POST reduces the total number of requests against Azure Monitor's metrics endpoint. Preventing throttling and improving performance when querying multiple resources is the primary purpose of the batch endpoint.

**Why Statement 2 is No (correct)**

The metrics:getBatch endpoint is a **regional endpoint**. In the example, the host is `eastus.metrics.monitor.azure.com`, which means all resources in the batch must exist in the **East US region**. Resources spread across multiple Azure regions cannot be combined in a single batch call. If you need metrics from resources in different regions, you must issue separate batch calls against each region's respective endpoint.

**Why Statement 3 is Yes (correct)**

Each metrics:getBatch request includes a single `metricNamespace` query parameter. In the example, that value is `microsoft.compute/virtualMachines`. All resource IDs submitted in the request body must belong to that same resource type and namespace. You cannot mix resource types (for example, virtual machines and load balancers) within a single batch request.

**Key takeaway**

The metrics:getBatch API reduces throttling risk by batching multi-resource metric queries into a single request, but it enforces two important constraints: all resources must be in the **same Azure region** (determined by the regional endpoint hostname), and all resources must be the **same resource type** (determined by the `metricNamespace` parameter).

**References**

* [How to migrate from the metrics API to the getBatch API](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/migrate-to-batch-api?tabs=individual-response)
* [Troubleshoot Azure Load Balancer outbound connectivity issues](https://learn.microsoft.com/en-us/azure/load-balancer/troubleshoot-outbound-connection)
* [Standard load balancer diagnostics with metrics, alerts, and resource health](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-standard-diagnostics)
* [Azure monitoring REST API walkthrough](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/rest-api-walkthrough?tabs=rest%2Cportal)

</details>

▶ Related Lab: [lab-metrics-batch-api](../hands-on-labs/monitoring/lab-metrics-batch-api/README.md)

---

#### Enable Boot Diagnostics for Azure Virtual Machines

**Domain:** Monitor and maintain Azure resources
**Skill:** Monitor resources in Azure
**Task:** Configure and interpret monitoring of virtual machines, storage accounts, and networks by using Azure Monitor Insights

You have two Azure Virtual Machines (VMs) and three storage accounts provisioned in an Azure subscription. The subscription configuration is shown in the exhibit.

You need to enable boot diagnostics in the Azure VMs using the available storage accounts.

Which storage accounts should you use? To answer, select the appropriate options from the drop-down menus.

Enable boot diagnostics in vm1 by using $PLACEHOLDER$

Enable boot diagnostics in vm2 by using $PLACEHOLDER$

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-05-36-07.png' width=700>

<img src='.img/2026-01-30-05-34-11.png' width=500>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answers are wrong**

* **Using storage1 for vm1**
  Boot diagnostics **cannot use a Premium storage account**. Boot diagnostics requires a **Standard** storage account (Blob service). `storage1` is explicitly a **Premium storage account**, so it is not eligible, even though it is in the same region and resource group as vm1.

* **Using storage2 for vm2**
  While `storage2` is a Standard storage account, it is a **Storage account v1 (Classic)**. Boot diagnostics **does not support storage account v1**. Only **Storage account v2 (General-purpose v2)** or supported Standard accounts are valid.

**Why the correct answers are right**

* **vm1 → storage3**
  `storage3` is a **Storage account v2**, which is supported for boot diagnostics. It is also in the **same region (Central US)** as vm1.
  Replication type (GRS vs LRS) and resource group **do not matter** for boot diagnostics—only account type and region do.

* **vm2 → storage3**
  Boot diagnostics **does not require the storage account to be in the same resource group**, but it **must be in the same region** as the VM.
  vm2 is in **East US**, so none of the available accounts in East US meet the requirements (`storage2` fails due to v1). Therefore, **storage3 is the only valid supported account**, and this question is testing that **account type restrictions override resource group and replication considerations**.

**Key takeaway**

Boot diagnostics requires:

* **Standard storage**
* **Storage account v2**
* **Same region as the VM**

Premium storage accounts and storage account v1 are **not supported**, regardless of region or resource group.

<img src='.img/2026-02-03-04-29-59.png' width=700>

**References**  

* [Limitations](https://learn.microsoft.com/en-us/azure/virtual-machines/boot-diagnostics#limitations)
* [https://learn.microsoft.com/azure/virtual-machines/boot-diagnostics](https://learn.microsoft.com/azure/virtual-machines/boot-diagnostics)
* [https://learn.microsoft.com/azure/storage/common/storage-account-overview](https://learn.microsoft.com/azure/storage/common/storage-account-overview)
* [https://learn.microsoft.com/azure/virtual-machines/troubleshooting/boot-diagnostics#requirements](https://learn.microsoft.com/azure/virtual-machines/troubleshooting/boot-diagnostics#requirements)

</details>

---

#### Diagnose Network Watcher Tool for Web Server Packet Flow

**Domain:** Monitor and maintain Azure resources
**Skill:** Monitor resources in Azure
**Task:** Use Azure Network Watcher and Connection Monitor

Your company hosts its infrastructure in Azure. The infrastructure consists of virtual machines (VMs), storage (managed disks and Azure file shares) and multiple networks (VNets and subnets). The service desk is seeing an influx of support tickets that have been logged in the last 24 hours regarding intermittent connectivity issues to a web server. After some initial investigation, the support ticket has been escalated to you.

You need to use the relevant Network Watcher diagnostic tool to check if packets are being allowed or denied to the web server.

Which Network Watcher diagnostic tool should you use?

A. IP flow verify  
B. Next hop  
C. Effective security rules  
D. Connection troubleshoot  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-05-24-16.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is correct (IP flow verify)**
IP flow verify is the Network Watcher tool specifically designed to determine whether traffic is **allowed or denied** to or from a VM. You define the 5-tuple (source IP, destination IP, source port, destination port, protocol), and Azure evaluates the effective NSG rules applied to the NIC and subnet to return an **Allow** or **Deny** decision. This directly answers the requirement to check whether packets are being allowed or denied to the web server.

**Why the other options are incorrect**

* **Next hop**: Shows where traffic is routed (e.g., Internet, virtual appliance, VNet peering). It does not evaluate security rules or allow/deny decisions.
* **Effective security rules**: Lists the merged NSG rules applied to a NIC or subnet, but does not simulate a specific packet flow or return an explicit allow/deny result for given traffic.
* **Connection troubleshoot**: Tests end-to-end connectivity between a source and destination and identifies potential failures, but it is broader than required and not focused on evaluating packet allow/deny decisions at the NSG level.

**Key takeaway**
When the question asks whether packets are **allowed or denied**, the correct Network Watcher tool is **IP flow verify**.

**References**

* [https://learn.microsoft.com/azure/network-watcher/network-watcher-ip-flow-verify-overview](https://learn.microsoft.com/azure/network-watcher/network-watcher-ip-flow-verify-overview)
* [https://learn.microsoft.com/azure/network-watcher/network-watcher-monitoring-overview](https://learn.microsoft.com/azure/network-watcher/network-watcher-monitoring-overview)
* [https://learn.microsoft.com/azure/virtual-network/security-overview](https://learn.microsoft.com/azure/virtual-network/security-overview)

No. **Windows Firewall rules do not impact IP flow verify results.**

**Why**
IP flow verify evaluates traffic **only at the Azure networking layer**, specifically:

* Network Security Groups (NSGs) applied to the **subnet** and **NIC**
* Azure’s effective security rule evaluation (priority-based NSG processing)

It does **not** inspect or consider:

* Guest OS firewalls (Windows Firewall, iptables, etc.)
* Application-level listeners or services
* VM-level routing inside the OS

**Common exam trap**
It is easy to assume that “packet allowed or denied” includes the OS firewall. On Azure exams, **IP flow verify = NSG evaluation only**. If IP flow verify returns **Allow** but connectivity still fails, the next suspects are:

* Windows Firewall rules
* Application not listening on the port
* Local OS routing or security software

**Key takeaway**
IP flow verify answers: *“Would Azure networking allow this packet?”*
It does **not** answer: *“Can the VM actually accept this connection?”*

**References**

* [https://learn.microsoft.com/azure/network-watcher/network-watcher-ip-flow-verify-overview](https://learn.microsoft.com/azure/network-watcher/network-watcher-ip-flow-verify-overview)
* [https://learn.microsoft.com/azure/virtual-network/network-security-groups-overview](https://learn.microsoft.com/azure/virtual-network/network-security-groups-overview)

</details>

---

#### Configure Azure Monitor Alert Notification Rate Limits

**Domain:** Monitor and maintain Azure resources
**Skill:** Monitor resources in Azure
**Task:** Set up alert rules, action groups, and alert processing rules in Azure Monitor

Your company has an Azure Subscription and an Azure SQL Database. You configure an Azure Monitor alert rule named Alert1 that is triggered when the database CPU usage exceeds 70%. Alert1 fires approximately every minute.

You configure an action group with the following notification methods:

* Email alerts  
* Voice alerts  
* SMS alerts  

For each of the following statements, select Yes if the statement is true. Otherwise, select No.

| STATEMENT | YES | NO |
|-----------|-----|-----|
| How many alert notifications will be generated for each type of alert per hour? | Email: 60, Voice: 4, SMS: 60 | |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-06-20-01.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is wrong**

The dropdown values shown (Email 60, Voice 4, SMS 60 per hour) don't match Azure Monitor's service-level notification rate limits for action groups. Even if an alert fires every minute, Azure Monitor will throttle notifications per recipient based on those limits—not based on the alert frequency.

**Why the correct answer is right**

Azure Monitor action group notification limits (production) are:

* **Email:** No more than 100 emails per hour per email address (per region)
* **SMS:** No more than 1 SMS every 5 minutes per phone number ⇒ 12 per hour
* **Voice:** No more than 1 voice call every 5 minutes per phone number ⇒ 12 per hour

So, with Alert1 firing every minute (60 times/hour), the maximum notifications actually sent per hour are:

* **Email:** 60 (because the alert only fires 60 times/hour, which is under the 100/hour cap)
* **SMS:** 12 (throttled by 1 per 5 minutes)
* **Voice:** 12 (throttled by 1 per 5 minutes)

**Key takeaway**

Action group notification "rate limiting" is per recipient, and for SMS/voice it effectively translates to 12/hour (1 per 5 minutes). Email has a higher cap (100/hour), so the alert's firing rate (60/hour) becomes the limiting factor.

Related resources:

* [Azure Monitor service limits](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/service-limits#action-groups)
* [Create and manage action groups in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups)

</details>

---

### Implement backup and recovery

#### Recover Configuration File from Azure VM Backup

**Domain:** Monitor and maintain Azure resources
**Skill:** Implement backup and recovery
**Task:** Perform backup and restore operations by using Azure Backup

You have two Azure virtual machines (VMs) named VM1 and VM2 running Windows Server 2019. The VMs are backed up by an Azure Recovery Services vault. A configuration file on VM1 was updated, and you need to restore it to a version from six days ago.

You need to perform this action as quickly as possible without affecting other system files.

Which four actions should you perform in sequence? To answer, move the appropriate actions from the list of actions to the answer area and arrange them in the correct order.

**Available options:**

* Start the file recovery process and select the recovery point of six days ago.
* Download and execute the PowerShell script to mount the recovery volume.
* Copy the file from the mounted volume to the VM.
* Unmount the volumes.
* Restore the disk containing the configuration file.
* Restore the VM to a previous state.

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-05-41-40.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is wrong**

“Restore the disk containing the configuration file” is incorrect because a disk restore is a **full disk–level operation**. It replaces or attaches an entire managed disk from a recovery point. That is slower and risks overwriting or impacting other files on the disk, which directly violates the requirement to restore **only one file** as quickly as possible and **without affecting other system files**.
On Azure exams, disk restore is a common trap when the scenario clearly calls for **granular recovery**.

**Why the correct answer is right**

The scenario is testing **Azure VM File Recovery** from a Recovery Services vault. File Recovery allows you to restore individual files from a specific recovery point **without restoring the VM or disk**.

The correct sequence is:

1. Start the file recovery process and select the recovery point of six days ago.
2. Download and execute the PowerShell script to mount the recovery volume.
3. Copy the required configuration file from the mounted volume to the VM.
4. Unmount the volumes.

This approach is the **fastest**, least disruptive method and is exactly what Azure Backup File Recovery is designed for.

**Key takeaway**

If the requirement is **one or a few files**, always choose **File Recovery**, not disk or VM restore.
Disk restore = coarse-grained, higher impact.
File Recovery = granular, fast, exam-preferred.

**References**

Azure VM file recovery
[https://learn.microsoft.com/azure/backup/backup-azure-restore-files-from-vm](https://learn.microsoft.com/azure/backup/backup-azure-restore-files-from-vm)

Restore Azure VM data using Azure Backup
[https://learn.microsoft.com/azure/backup/backup-azure-vms-restore](https://learn.microsoft.com/azure/backup/backup-azure-vms-restore)

Azure Recovery Services vault overview
[https://learn.microsoft.com/azure/backup/backup-azure-recovery-services-vault-overview](https://learn.microsoft.com/azure/backup/backup-azure-recovery-services-vault-overview)

</details>

▶ **Related Lab:** [lab-vm-file-recovery](../hands-on-labs/monitoring/lab-vm-file-recovery/README.md)

---

#### Recover Azure VM from Deleted Backup

**Domain:** Monitor and maintain Azure resources
**Skill:** Implement backup and recovery
**Task:** Perform backup and restore operations by using Azure Backup

An Infrastructure-as-a-Service (IaaS) virtual machine (VM) named VM10 is backed up to an Azure Recovery Services vault. VM10 and all of its restore points are deleted by mistake.

You need to recover VM10.

How many days does VM10's data remain available for recovery?

A. 365 days  
B. 30 days  
C. 14 days  
D. 90 days  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-01-30-05-24-56.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is right**
Azure Backup uses **Soft Delete** for Azure IaaS VM backups. When a VM and its backup data are deleted (intentionally or accidentally), the backup data is **retained for 14 days** in a soft-deleted state. During this window, the VM’s backup data can be recovered by undeleting the backup item from the Recovery Services vault. After 14 days, the data is permanently deleted and cannot be recovered.

**Key takeaway**
For Azure IaaS VMs protected by a Recovery Services vault, **soft delete provides a fixed 14-day recovery window** after deletion—independent of the configured backup retention policy.

<img src='.img/2026-02-04-03-04-12.png' width=500>

**References**

* [Soft delete for virtual machines](https://learn.microsoft.com/en-us/azure/backup/soft-delete-virtual-machines?utm_source=chatgpt.com&tabs=azure-portal)

</details>

---
