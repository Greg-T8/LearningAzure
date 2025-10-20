# Lab 2 – Role-Based Access & Scoping

**Domain:** Manage Azure identities and governance  
**Difficulty:** Medium (≈1.5–2 hrs)  
**Dependencies:** Lab 1 – Setup and Identity Baseline

---

<!-- omit in toc -->
## 🧾 Contents

* [🎯 Lab Objective](#-lab-objective)
* [🧱 Skills Measured (Exam Outline)](#-skills-measured-exam-outline)
* [🧠 Scenario](#-scenario)
* [⚙️ Environment Setup](#️-environment-setup)
* [⏱ Estimated Duration](#-estimated-duration)
* [🔹 Exercise 1 – Explore Built-in Azure Roles](#-exercise-1--explore-built-in-azure-roles)
  * [Using the Azure Portal](#using-the-azure-portal)
  * [Using PowerShell (`Get-AzRoleDefinition`)](#using-powershell-get-azroledefinition)
  * [Using Azure CLI (`az role definition list`)](#using-azure-cli-az-role-definition-list)
  * [Understanding Key Built-in Roles](#understanding-key-built-in-roles)
  * [Exam Insights](#exam-insights)
* [🔹 Exercise 2 – Assign Roles at Different Scopes](#-exercise-2--assign-roles-at-different-scopes)
  * [Understanding Scope Hierarchy](#understanding-scope-hierarchy)
  * [Assign Role at Subscription Scope](#assign-role-at-subscription-scope)
    * [Using the Azure Portal](#using-the-azure-portal-1)
    * [Using PowerShell (`New-AzRoleAssignment`)](#using-powershell-new-azroleassignment)
    * [Using Azure CLI (`az role assignment create`)](#using-azure-cli-az-role-assignment-create)
  * [Assign Role at Resource Group Scope](#assign-role-at-resource-group-scope)
    * [Using the Azure Portal](#using-the-azure-portal-2)
    * [Using PowerShell](#using-powershell)
    * [Using Azure CLI](#using-azure-cli)
  * [Assign Role at Resource Scope](#assign-role-at-resource-scope)
    * [Using PowerShell](#using-powershell-1)
    * [Using Azure CLI](#using-azure-cli-1)
  * [Using Bicep for Role Assignments](#using-bicep-for-role-assignments)
  * [Using Terraform for Role Assignments](#using-terraform-for-role-assignments)
  * [Exam Insights](#exam-insights-1)
* [🔹 Exercise 3 – Verify Role Inheritance and Effective Permissions](#-exercise-3--verify-role-inheritance-and-effective-permissions)
  * [Understanding Permission Inheritance](#understanding-permission-inheritance)
  * [Verify Effective Permissions](#verify-effective-permissions)
    * [Using the Azure Portal](#using-the-azure-portal-3)
    * [Using PowerShell (`Get-AzRoleAssignment`)](#using-powershell-get-azroleassignment)
    * [Using Azure CLI (`az role assignment list`)](#using-azure-cli-az-role-assignment-list)
  * [Test Access with a User Account](#test-access-with-a-user-account)
  * [Exam Insights](#exam-insights-2)
* [🔹 Exercise 4 – Implement Just-Enough-Access (JEA) Principle](#-exercise-4--implement-just-enough-access-jea-principle)
  * [Scenario: Developer Access to Specific Resources](#scenario-developer-access-to-specific-resources)
  * [Remove Excessive Permissions](#remove-excessive-permissions)
  * [Exam Insights](#exam-insights-3)
* [🔹 Exercise 5 – Understand Deny Assignments](#-exercise-5--understand-deny-assignments)
  * [What are Deny Assignments?](#what-are-deny-assignments)
  * [View Deny Assignments](#view-deny-assignments)
    * [Using the Azure Portal](#using-the-azure-portal-4)
    * [Using PowerShell (`Get-AzDenyAssignment`)](#using-powershell-get-azdenyassignment)
  * [Common Deny Assignment Scenarios](#common-deny-assignment-scenarios)
  * [Exam Insights](#exam-insights-4)
* [🔹 Exercise 6 – Assign Roles to Service Principals](#-exercise-6--assign-roles-to-service-principals)
  * [Create a Service Principal](#create-a-service-principal)
    * [Using Azure CLI (`az ad sp create-for-rbac`)](#using-azure-cli-az-ad-sp-create-for-rbac)
    * [Using PowerShell (`New-AzADServicePrincipal`)](#using-powershell-new-azadserviceprincipal)
  * [Assign Role to Service Principal](#assign-role-to-service-principal)
  * [Verify Service Principal Access](#verify-service-principal-access)
  * [Exam Insights](#exam-insights-5)
* [🔹 Exercise 7 – Review Access Using Access Control (IAM)](#-exercise-7--review-access-using-access-control-iam)
  * [Check Access for a User](#check-access-for-a-user)
  * [Review All Role Assignments](#review-all-role-assignments)
  * [Exam Insights](#exam-insights-6)
* [🧭 Reflection \& Readiness](#-reflection--readiness)
* [📚 References](#-references)

## 🎯 Lab Objective

Implement and validate Azure role-based access control (RBAC) across different scopes. You will:

* Explore Azure built-in roles and their permissions
* Assign roles at management group, subscription, resource group, and resource scopes
* Verify permission inheritance and effective access
* Implement least privilege access principles
* Understand deny assignments and their precedence
* Manage service principal access

---

## 🧱 Skills Measured (Exam Outline)

* Manage built-in Azure roles
* Assign roles at different scopes
* Interpret access assignments

---

## 🧠 Scenario

Your organization, **Contoso Ltd**, is scaling its Azure environment and needs proper access control. The security team has mandated that:

* **Finance team** needs read-only access to all resources across the subscription
* **Development team** needs contributor access to their specific resource groups only
* **Operations team** needs owner access to production resource groups
* **Service principals** for automation need targeted permissions
* All access must follow the principle of least privilege

You are responsible for implementing this RBAC strategy and validating that users have appropriate access.

---

## ⚙️ Environment Setup

| Component | Example |
| --------- | ------- |
| Subscription | Visual Studio Enterprise Subscription |
| Resource Groups | `rg-finance-prod`, `rg-dev-test`, `rg-ops-prod` |
| Users | Users from Lab 1 (`user1`, `user2`, `user3`) |
| Groups | `Lab-Admins`, `Lab-Users`, `Finance-Team`, `Dev-Team` |
| Service Principal | `sp-automation` |
| Tools | Azure Portal, Azure CLI, PowerShell, Bicep, Terraform |

**Prerequisites:**
* Completed Lab 1 with users and groups created
* At least one resource group deployed
* User Access Administrator or Owner role on the subscription

---

## ⏱ Estimated Duration

**90–120 minutes**

---

## 🔹 Exercise 1 – Explore Built-in Azure Roles

**Goal:** Understand the permission structure of Azure built-in roles.

### Using the Azure Portal

1. Navigate to **Subscriptions** → Select your subscription
2. Go to **Access control (IAM)** → **Roles**
3. Explore the following built-in roles:
   * **Owner** – Full access including role assignment
   * **Contributor** – Manage all resources but cannot assign roles
   * **Reader** – View all resources but cannot make changes
   * **User Access Administrator** – Manage user access to resources
4. Click on a role and select **Permissions** to view detailed actions
5. Note the difference between `Actions`, `NotActions`, `DataActions`, and `NotDataActions`

**Example: Virtual Machine Contributor**

* **Actions:** `Microsoft.Compute/virtualMachines/*`
* **NotActions:** None
* **DataActions:** None (cannot access data inside VMs)

### Using PowerShell (`Get-AzRoleDefinition`)

```powershell
# List all built-in roles
Get-AzRoleDefinition | Where-Object {$_.IsCustom -eq $false} | Select-Object Name, Description

# Get details of a specific role
Get-AzRoleDefinition -Name "Contributor" | Format-List

# View permissions for a role
$role = Get-AzRoleDefinition -Name "Virtual Machine Contributor"
$role.Actions
$role.NotActions
$role.DataActions

# Find roles that can perform a specific action
Get-AzRoleDefinition | Where-Object {$_.Actions -like "*Microsoft.Compute/virtualMachines/write*"}
```

**Output Example:**

```
Name             : Contributor
Id               : b24988ac-6180-42a0-ab88-20f7382dd24c
IsCustom         : False
Description      : Grants full access to manage all resources, but does not allow you to assign roles in Azure RBAC
Actions          : {*}
NotActions       : {Microsoft.Authorization/*/Delete, Microsoft.Authorization/*/Write...}
DataActions      : {}
NotDataActions   : {}
AssignableScopes : {/}
```

### Using Azure CLI (`az role definition list`)

```bash
# List all built-in roles
az role definition list --query "[?roleType=='BuiltInRole'].{Name:roleName, Description:description}" --output table

# Get details of a specific role
az role definition list --name "Contributor" --output json

# Find roles with specific permissions
az role definition list --query "[?contains(permissions[0].actions[0], 'Microsoft.Storage')]"
```

### Understanding Key Built-in Roles

| Role | Scope | Can Assign Roles? | Common Use Case |
|------|-------|-------------------|-----------------|
| **Owner** | All levels | ✅ Yes | Full administrative access |
| **Contributor** | All levels | ❌ No | Manage resources without RBAC |
| **Reader** | All levels | ❌ No | View-only access, auditing |
| **User Access Administrator** | All levels | ✅ Yes (RBAC only) | Delegate access management |
| **Virtual Machine Contributor** | Resource-specific | ❌ No | Manage VMs without networking |
| **Storage Blob Data Contributor** | Storage-specific | ❌ No | Read/write/delete blob data |
| **Network Contributor** | Networking | ❌ No | Manage network resources |

**Key Differences:**

* **Owner vs User Access Administrator:**
  * Owner: Full resource management + RBAC
  * User Access Administrator: RBAC only, no resource management

* **Contributor vs Owner:**
  * Contributor: Cannot assign roles or manage RBAC
  * Owner: Can do everything including RBAC

* **Actions vs DataActions:**
  * Actions: Control plane operations (create, delete, update resources)
  * DataActions: Data plane operations (read/write data within resources)

### Exam Insights

💡 **Exam Tip:** The difference between Owner, Contributor, and User Access Administrator is frequently tested. Remember: only Owner and User Access Administrator can assign roles.

💡 **Exam Tip:** Understand that built-in roles have `AssignableScopes: ["/"]`, meaning they can be assigned at any scope level.

💡 **Exam Tip:** Know that `NotActions` are permissions denied within an allowed `Actions` set. They don't grant access—they restrict it.

💡 **Exam Tip:** Data plane roles (like Storage Blob Data Contributor) require both RBAC role assignment AND potentially storage account configurations (like "Allow Blob public access").

---

## 🔹 Exercise 2 – Assign Roles at Different Scopes

**Goal:** Implement role assignments across the Azure hierarchy.

### Understanding Scope Hierarchy

```
Management Group (Broadest)
    ↓
Subscription
    ↓
Resource Group
    ↓
Resource (Most Specific)
```

**Scope Format:**
```
/providers/Microsoft.Management/managementGroups/{managementGroupName}
/subscriptions/{subscriptionId}
/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}
/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}
```

### Assign Role at Subscription Scope

#### Using the Azure Portal

1. Navigate to **Subscriptions** → Select your subscription
2. Go to **Access control (IAM)** → **+ Add** → **Add role assignment**
3. **Role:** Select **Reader**
4. **Assign access to:** User, group, or service principal
5. **Members:** Search and select `Finance-Team` group
6. Click **Review + assign**

#### Using PowerShell (`New-AzRoleAssignment`)

```powershell
# Get subscription ID
$subscriptionId = (Get-AzContext).Subscription.Id

# Assign Reader role to a user at subscription scope
New-AzRoleAssignment `
    -ObjectId (Get-AzADUser -UserPrincipalName "user1@637djb.onmicrosoft.com").Id `
    -RoleDefinitionName "Reader" `
    -Scope "/subscriptions/$subscriptionId"

# Assign Reader role to a group at subscription scope
$groupId = (Get-AzADGroup -DisplayName "Finance-Team").Id
New-AzRoleAssignment `
    -ObjectId $groupId `
    -RoleDefinitionName "Reader" `
    -Scope "/subscriptions/$subscriptionId"

# Verify assignment
Get-AzRoleAssignment -Scope "/subscriptions/$subscriptionId" | 
    Where-Object {$_.DisplayName -eq "Finance-Team"}
```

#### Using Azure CLI (`az role assignment create`)

```bash
# Get subscription ID
subscriptionId=$(az account show --query id --output tsv)

# Assign Reader role to a user
az role assignment create \
    --assignee "user1@637djb.onmicrosoft.com" \
    --role "Reader" \
    --scope "/subscriptions/$subscriptionId"

# Assign Reader role to a group
groupId=$(az ad group show --group "Finance-Team" --query id --output tsv)
az role assignment create \
    --assignee $groupId \
    --role "Reader" \
    --scope "/subscriptions/$subscriptionId"
```

### Assign Role at Resource Group Scope

#### Using the Azure Portal

1. Navigate to **Resource groups** → Select `rg-dev-test`
2. Go to **Access control (IAM)** → **+ Add** → **Add role assignment**
3. **Role:** Select **Contributor**
4. **Members:** Search and select `Dev-Team` group
5. Click **Review + assign**

#### Using PowerShell

```powershell
# Create resource group if it doesn't exist
New-AzResourceGroup -Name "rg-dev-test" -Location "eastus"

# Assign Contributor role to Dev-Team at resource group scope
$resourceGroupName = "rg-dev-test"
$groupId = (Get-AzADGroup -DisplayName "Dev-Team").Id

New-AzRoleAssignment `
    -ObjectId $groupId `
    -RoleDefinitionName "Contributor" `
    -ResourceGroupName $resourceGroupName

# Verify assignment
Get-AzRoleAssignment -ResourceGroupName $resourceGroupName
```

#### Using Azure CLI

```bash
# Create resource group
az group create --name rg-dev-test --location eastus

# Assign Contributor role
groupId=$(az ad group show --group "Dev-Team" --query id --output tsv)
az role assignment create \
    --assignee $groupId \
    --role "Contributor" \
    --resource-group "rg-dev-test"

# Verify assignment
az role assignment list --resource-group rg-dev-test --output table
```

### Assign Role at Resource Scope

First, create a storage account for testing:

```powershell
# Create storage account
New-AzStorageAccount `
    -ResourceGroupName "rg-dev-test" `
    -Name "stdevtest$(Get-Random -Maximum 9999)" `
    -Location "eastus" `
    -SkuName "Standard_LRS"
```

#### Using PowerShell

```powershell
# Get storage account resource ID
$storageAccount = Get-AzStorageAccount -ResourceGroupName "rg-dev-test" -Name "stdevtest1234"
$resourceId = $storageAccount.Id

# Assign Storage Blob Data Contributor to a user at resource scope
$userId = (Get-AzADUser -UserPrincipalName "user2@637djb.onmicrosoft.com").Id

New-AzRoleAssignment `
    -ObjectId $userId `
    -RoleDefinitionName "Storage Blob Data Contributor" `
    -Scope $resourceId

# Verify assignment
Get-AzRoleAssignment -Scope $resourceId
```

#### Using Azure CLI

```bash
# Get storage account resource ID
resourceId=$(az storage account show \
    --name stdevtest1234 \
    --resource-group rg-dev-test \
    --query id --output tsv)

# Assign role at resource scope
az role assignment create \
    --assignee "user2@637djb.onmicrosoft.com" \
    --role "Storage Blob Data Contributor" \
    --scope "$resourceId"

# Verify assignment
az role assignment list --scope "$resourceId" --output table
```

### Using Bicep for Role Assignments

Create a file named `role-assignment.bicep`:

```bicep
targetScope = 'resourceGroup'

@description('Principal ID of the user, group, or service principal')
param principalId string

@description('Built-in role ID')
param roleDefinitionId string = 'b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor

@description('Principal Type')
@allowed([
  'User'
  'Group'
  'ServicePrincipal'
])
param principalType string = 'User'

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, principalId, roleDefinitionId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: principalId
    principalType: principalType
  }
}

output roleAssignmentId string = roleAssignment.id
```

Deploy the Bicep template:

```powershell
# Get user principal ID
$principalId = (Get-AzADUser -UserPrincipalName "user3@637djb.onmicrosoft.com").Id

# Deploy Bicep template
New-AzResourceGroupDeployment `
    -ResourceGroupName "rg-dev-test" `
    -TemplateFile "./role-assignment.bicep" `
    -principalId $principalId `
    -principalType "User"
```

### Using Terraform for Role Assignments

Create `role-assignment.tf`:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

# Data sources
data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "dev" {
  name = "rg-dev-test"
}

data "azuread_user" "dev_user" {
  user_principal_name = "user3@637djb.onmicrosoft.com"
}

# Role assignment at resource group scope
resource "azurerm_role_assignment" "dev_contributor" {
  scope                = data.azurerm_resource_group.dev.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_user.dev_user.object_id
}

# Role assignment at subscription scope
resource "azurerm_role_assignment" "subscription_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = data.azuread_user.dev_user.object_id
}

output "role_assignment_id" {
  value = azurerm_role_assignment.dev_contributor.id
}
```

Deploy with Terraform:

```bash
terraform init
terraform plan
terraform apply
```

### Exam Insights

💡 **Exam Tip:** Lower scopes inherit permissions from higher scopes. A Reader at subscription scope can read all resources in all resource groups.

💡 **Exam Tip:** You can assign multiple roles to the same principal at different scopes. Permissions are cumulative (union).

💡 **Exam Tip:** Role assignments can take up to 5-10 minutes to propagate, especially at management group scope.

💡 **Exam Tip:** The most restrictive scope should be used to follow least privilege principle. Avoid broad assignments when narrow ones suffice.

💡 **Exam Tip:** When using Bicep/ARM templates, use `guid()` function to generate consistent role assignment names to avoid duplicates.

---

## 🔹 Exercise 3 – Verify Role Inheritance and Effective Permissions

**Goal:** Understand how permissions flow through the scope hierarchy.

### Understanding Permission Inheritance

**Key Principles:**
1. Permissions assigned at parent scope are inherited by child scopes
2. Permissions are cumulative (additive)
3. Deny assignments take precedence over role assignments
4. Lower scopes cannot remove permissions granted at higher scopes

**Example Scenario:**
* User has **Reader** at subscription scope
* User has **Contributor** at resource group scope
* **Effective permission at resource group:** Contributor (more permissive)
* **Effective permission at other resource groups:** Reader (inherited from subscription)

### Verify Effective Permissions

#### Using the Azure Portal

1. Navigate to a resource group (e.g., `rg-dev-test`)
2. Go to **Access control (IAM)** → **Check access**
3. Search for a user (e.g., `user1@637djb.onmicrosoft.com`)
4. Click **View** to see:
   * Direct assignments
   * Inherited assignments
   * Effective permissions
5. Review the **Inheritance path** to understand where permissions come from

#### Using PowerShell (`Get-AzRoleAssignment`)

```powershell
# Get all role assignments for a specific user
$userId = (Get-AzADUser -UserPrincipalName "user1@637djb.onmicrosoft.com").Id

Get-AzRoleAssignment -ObjectId $userId | 
    Select-Object RoleDefinitionName, Scope, ObjectId | 
    Format-Table

# Get role assignments at subscription scope (includes inherited)
$subscriptionId = (Get-AzContext).Subscription.Id
Get-AzRoleAssignment -Scope "/subscriptions/$subscriptionId" | 
    Where-Object {$_.DisplayName -eq "user1"} |
    Format-Table DisplayName, RoleDefinitionName, Scope

# Get role assignments for a resource group (includes inherited)
Get-AzRoleAssignment -ResourceGroupName "rg-dev-test" -ObjectId $userId
```

#### Using Azure CLI (`az role assignment list`)

```bash
# Get all role assignments for a user
userId=$(az ad user show --id "user1@637djb.onmicrosoft.com" --query id --output tsv)
az role assignment list --assignee $userId --all --output table

# Get role assignments at a specific scope
az role assignment list \
    --scope "/subscriptions/$(az account show --query id --output tsv)" \
    --assignee $userId \
    --output table

# Include inherited assignments
az role assignment list \
    --resource-group "rg-dev-test" \
    --assignee $userId \
    --include-inherited \
    --output table
```

### Test Access with a User Account

**Scenario:** Verify that `user1` can read resources but not modify them.

```powershell
# Sign in as user1 in a new PowerShell session
Connect-AzAccount -AccountId "user1@637djb.onmicrosoft.com"

# Test read access (should succeed if Reader role assigned)
Get-AzResourceGroup

# Test write access (should fail if only Reader role assigned)
New-AzResourceGroup -Name "test-rg" -Location "eastus"
# Expected error: AuthorizationFailed - does not have authorization to perform action
```

**Alternative: Use Azure Portal in Private/Incognito Mode**
1. Open browser in private/incognito mode
2. Sign in as `user1@637djb.onmicrosoft.com`
3. Navigate to resource groups
4. Attempt to create a new resource group
5. Verify that "Create" button is grayed out or results in error

### Exam Insights

💡 **Exam Tip:** Use "Check access" in the Portal for quick verification of effective permissions during troubleshooting scenarios.

💡 **Exam Tip:** Inheritance cannot be blocked or disabled. If a user has Owner at subscription, they have Owner everywhere below.

💡 **Exam Tip:** When troubleshooting access issues, check all scopes from resource → resource group → subscription → management group.

💡 **Exam Tip:** Group memberships can cause inherited permissions. Always check both direct assignments and group memberships.

---

## 🔹 Exercise 4 – Implement Just-Enough-Access (JEA) Principle

**Goal:** Apply least privilege by removing excessive permissions.

### Scenario: Developer Access to Specific Resources

**Current State:**
* `Dev-Team` has Contributor at subscription scope (too broad)

**Desired State:**
* `Dev-Team` should only have Contributor on `rg-dev-test`
* `Dev-Team` should have Reader on other resource groups

**Implementation:**

```powershell
# Remove overly permissive assignment
$subscriptionId = (Get-AzContext).Subscription.Id
$groupId = (Get-AzADGroup -DisplayName "Dev-Team").Id

# List current assignments
Get-AzRoleAssignment -ObjectId $groupId

# Remove Contributor at subscription scope if it exists
$assignment = Get-AzRoleAssignment -ObjectId $groupId -Scope "/subscriptions/$subscriptionId" `
    | Where-Object {$_.RoleDefinitionName -eq "Contributor"}

if ($assignment) {
    Remove-AzRoleAssignment -ObjectId $groupId -RoleDefinitionName "Contributor" -Scope "/subscriptions/$subscriptionId"
    Write-Host "Removed Contributor role at subscription scope"
}

# Assign Reader at subscription scope (for visibility)
New-AzRoleAssignment `
    -ObjectId $groupId `
    -RoleDefinitionName "Reader" `
    -Scope "/subscriptions/$subscriptionId"

# Assign Contributor only to dev resource group
New-AzRoleAssignment `
    -ObjectId $groupId `
    -RoleDefinitionName "Contributor" `
    -ResourceGroupName "rg-dev-test"

# Verify new configuration
Get-AzRoleAssignment -ObjectId $groupId | Format-Table RoleDefinitionName, Scope
```

**Verification:**

```powershell
# As a member of Dev-Team:
# Can create resources in rg-dev-test
New-AzStorageAccount `
    -ResourceGroupName "rg-dev-test" `
    -Name "sttest$(Get-Random)" `
    -Location "eastus" `
    -SkuName "Standard_LRS"  # Should succeed

# Cannot create resources in other resource groups
New-AzStorageAccount `
    -ResourceGroupName "rg-finance-prod" `
    -Name "sttest$(Get-Random)" `
    -Location "eastus" `
    -SkuName "Standard_LRS"  # Should fail with AuthorizationFailed
```

### Remove Excessive Permissions

```powershell
# Audit overly permissive assignments
$subscriptionId = (Get-AzContext).Subscription.Id

# Find all Owner and Contributor assignments at subscription scope
Get-AzRoleAssignment -Scope "/subscriptions/$subscriptionId" | 
    Where-Object {$_.RoleDefinitionName -in @("Owner", "Contributor")} |
    Select-Object DisplayName, RoleDefinitionName, ObjectType, Scope |
    Format-Table

# Remove a specific assignment
Remove-AzRoleAssignment `
    -ObjectId $groupId `
    -RoleDefinitionName "Contributor" `
    -Scope "/subscriptions/$subscriptionId" `
    -Verbose
```

### Exam Insights

💡 **Exam Tip:** Always assign roles at the most restrictive scope necessary. Avoid subscription-level assignments when resource group-level is sufficient.

💡 **Exam Tip:** Use Reader at broad scopes for visibility, and higher permissions at narrow scopes for specific work.

💡 **Exam Tip:** Regular access reviews should identify and remove excessive permissions (this requires Azure AD Premium P2).

💡 **Exam Tip:** The `Remove-AzRoleAssignment` cmdlet requires exact match of ObjectId, Role, and Scope—all three must be specified.

---

## 🔹 Exercise 5 – Understand Deny Assignments

**Goal:** Learn how deny assignments work and take precedence over role assignments.

### What are Deny Assignments?

**Deny assignments** block users from performing specific actions even if a role assignment grants them access.

**Key Characteristics:**
* Deny assignments take precedence over role assignments
* Created by Azure services automatically (e.g., Azure Blueprints, Managed Applications)
* Cannot be created manually by users
* Applied to protect system-critical resources

**Precedence Order:**
1. **Deny assignments** (highest priority)
2. **Role assignments**
3. **No access** (default)

### View Deny Assignments

#### Using the Azure Portal

1. Navigate to a resource with deny assignments
2. Go to **Access control (IAM)** → **Deny assignments** tab
3. Review any deny assignments
4. Click on a deny assignment to see:
   * Denied actions
   * Denied data actions
   * Principals (who is denied)
   * Scope

**Note:** Most tenants won't have deny assignments unless Azure Blueprints or Managed Applications are in use.

#### Using PowerShell (`Get-AzDenyAssignment`)

```powershell
# List all deny assignments in the subscription
Get-AzDenyAssignment

# Get deny assignments for a specific resource group
Get-AzDenyAssignment -ResourceGroupName "rg-dev-test"

# Get details of a specific deny assignment
$denyAssignment = Get-AzDenyAssignment | Select-Object -First 1
$denyAssignment | Format-List *

# View denied actions
$denyAssignment.Permissions.Actions
$denyAssignment.Permissions.NotActions
```

Using Azure CLI:

```bash
# List all deny assignments
az role assignment list --include-deny-assignments --query "[?type=='Microsoft.Authorization/denyAssignments']"

# Get deny assignments at subscription scope
az role assignment list \
    --all \
    --include-deny-assignments \
    --query "[?type=='Microsoft.Authorization/denyAssignments']" \
    --output table
```

### Common Deny Assignment Scenarios

**1. Azure Blueprints with Resource Locks**
* When you assign a blueprint with a lock, Azure creates a deny assignment
* Prevents modification or deletion of locked resources
* Even Owners cannot override

**2. Managed Applications**
* Resources in the managed resource group have deny assignments
* Prevents customer modification of provider-managed resources

**3. System-Assigned Deny Assignments**
* Protect Azure system resources
* Example: Deny delete on Azure AD tenant

**Example: Checking for Deny Assignments**

```powershell
# Create a blueprint-locked resource group (if Blueprints available)
# Then check for deny assignments

$rgName = "rg-locked-test"
$denyAssignments = Get-AzDenyAssignment -ResourceGroupName $rgName

if ($denyAssignments) {
    Write-Host "Deny assignments found:"
    $denyAssignments | ForEach-Object {
        Write-Host "  Name: $($_.DenyAssignmentName)"
        Write-Host "  Denied Actions: $($_.Permissions.Actions -join ', ')"
        Write-Host "  Principals: $($_.Principals.Count) affected principals"
    }
} else {
    Write-Host "No deny assignments found in $rgName"
}
```

### Exam Insights

💡 **Exam Tip:** Deny assignments always take precedence. Even an Owner cannot override a deny assignment.

💡 **Exam Tip:** Users cannot create deny assignments manually—only Azure services can create them.

💡 **Exam Tip:** If a user cannot access a resource despite having a role assignment, check for deny assignments first.

💡 **Exam Tip:** Deny assignments are commonly used with Azure Blueprints and are a key governance tool.

---

## 🔹 Exercise 6 – Assign Roles to Service Principals

**Goal:** Manage automated access using service principals.

### Create a Service Principal

#### Using Azure CLI (`az ad sp create-for-rbac`)

```bash
# Create service principal with Contributor role at resource group scope
az ad sp create-for-rbac \
    --name "sp-automation" \
    --role "Contributor" \
    --scopes /subscriptions/$(az account show --query id --output tsv)/resourceGroups/rg-dev-test

# Output includes:
# - appId (Application ID / Client ID)
# - password (Client Secret)
# - tenant (Tenant ID)
```

**Output Example:**
```json
{
  "appId": "12345678-1234-1234-1234-123456789abc",
  "displayName": "sp-automation",
  "password": "secret-password-here",
  "tenant": "87654321-4321-4321-4321-cba987654321"
}
```

⚠️ **Security Note:** Store the password securely immediately. It cannot be retrieved later.

#### Using PowerShell (`New-AzADServicePrincipal`)

```powershell
# Create an Azure AD application
$app = New-AzADApplication -DisplayName "sp-automation"

# Create a service principal for the application
$sp = New-AzADServicePrincipal -ApplicationId $app.AppId

# Create a credential (password)
$credential = New-AzADAppCredential -ApplicationId $app.AppId

# Display important values
Write-Host "Application (Client) ID: $($app.AppId)"
Write-Host "Service Principal Object ID: $($sp.Id)"
Write-Host "Client Secret: $($credential.SecretText)"
Write-Host "Tenant ID: $((Get-AzContext).Tenant.Id)"
```

### Assign Role to Service Principal

```powershell
# Assign Contributor role at resource group scope
$spObjectId = (Get-AzADServicePrincipal -DisplayName "sp-automation").Id

New-AzRoleAssignment `
    -ObjectId $spObjectId `
    -RoleDefinitionName "Contributor" `
    -ResourceGroupName "rg-dev-test"

# Verify assignment
Get-AzRoleAssignment -ObjectId $spObjectId
```

Using Azure CLI:

```bash
# Get service principal object ID
spObjectId=$(az ad sp list --display-name "sp-automation" --query "[0].id" --output tsv)

# Assign role
az role assignment create \
    --assignee $spObjectId \
    --role "Contributor" \
    --resource-group "rg-dev-test"
```

### Verify Service Principal Access

```powershell
# Sign in as service principal
$appId = "12345678-1234-1234-1234-123456789abc"
$secret = "secret-password-here"
$tenantId = "87654321-4321-4321-4321-cba987654321"

$securePassword = ConvertTo-SecureString $secret -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($appId, $securePassword)

Connect-AzAccount -ServicePrincipal -Credential $credential -Tenant $tenantId

# Test access
Get-AzResourceGroup -Name "rg-dev-test"

# Attempt to create a resource
New-AzStorageAccount `
    -ResourceGroupName "rg-dev-test" `
    -Name "stauto$(Get-Random)" `
    -Location "eastus" `
    -SkuName "Standard_LRS"
```

**Best Practices for Service Principals:**

1. **Use Managed Identities when possible** (System-assigned or User-assigned)
   * No credentials to manage
   * Automatic credential rotation
   * More secure than service principals

2. **Limit scope to minimum required**
   * Assign at resource group or resource level, not subscription

3. **Use short-lived credentials**
   * Rotate secrets regularly (90 days or less)
   * Use certificate-based authentication for higher security

4. **Monitor service principal activity**
   * Review sign-in logs in Azure AD
   * Set up alerts for unusual activity

### Exam Insights

💡 **Exam Tip:** Service principals are used for non-interactive authentication (automation, CI/CD pipelines).

💡 **Exam Tip:** Managed Identities are preferred over service principals for Azure resources—no credential management needed.

💡 **Exam Tip:** Service principals can be assigned roles just like users and groups.

💡 **Exam Tip:** The `az ad sp create-for-rbac` command creates the app registration, service principal, AND role assignment in one command.

💡 **Exam Tip:** Service principal passwords (client secrets) expire. Certificate-based authentication is more secure and doesn't expire as quickly.

---

## 🔹 Exercise 7 – Review Access Using Access Control (IAM)

**Goal:** Use Azure Portal IAM blade to audit and troubleshoot access.

### Check Access for a User

1. Navigate to **Subscriptions** → Select your subscription
2. Go to **Access control (IAM)** → **Check access**
3. Search for a user: `user1@637djb.onmicrosoft.com`
4. Review:
   * **Current role assignments** (direct and inherited)
   * **Scope** of each assignment
   * **Source** (direct or group membership)
5. Click **View details** to see:
   * Role permissions (Actions, NotActions, DataActions)
   * Assignment path (which scope granted the permission)

### Review All Role Assignments

```powershell
# Generate a report of all role assignments in the subscription
$subscriptionId = (Get-AzContext).Subscription.Id

$report = Get-AzRoleAssignment -Scope "/subscriptions/$subscriptionId" -IncludeClassicAdministrators | 
    Select-Object DisplayName, SignInName, RoleDefinitionName, ObjectType, Scope |
    Sort-Object RoleDefinitionName, DisplayName

# Export to CSV for review
$report | Export-Csv -Path ".\rbac-assignments-report.csv" -NoTypeInformation

# Count assignments by role
$report | Group-Object RoleDefinitionName | 
    Select-Object Name, Count | 
    Sort-Object Count -Descending

# Find high-privilege assignments (Owner, Contributor, User Access Administrator)
$highPrivilegeRoles = @("Owner", "Contributor", "User Access Administrator")
$report | Where-Object {$_.RoleDefinitionName -in $highPrivilegeRoles} |
    Format-Table DisplayName, RoleDefinitionName, Scope -AutoSize
```

Using Azure CLI:

```bash
# Export all role assignments to JSON
az role assignment list --all > rbac-assignments.json

# Get summary by role
az role assignment list --all --query "[].{Role:roleDefinitionName}" --output tsv | sort | uniq -c

# Find Owner assignments
az role assignment list --all --role "Owner" --output table
```

### Exam Insights

💡 **Exam Tip:** The "Check access" feature in IAM is the fastest way to troubleshoot "why can't user X do Y?"

💡 **Exam Tip:** Classic subscription administrators (Service Administrator, Co-Administrators) automatically have Owner role at subscription scope.

💡 **Exam Tip:** Regular access reviews help identify stale assignments and over-privileged accounts (requires Azure AD Premium P2).

💡 **Exam Tip:** Use Azure Policy to enforce tagging on role assignments for better tracking (custom metadata).

---

## 🧭 Reflection & Readiness

Be able to answer:

1. **What's the difference between Owner and Contributor roles?**

   **Answer:** 
   * **Owner:** Full access to all resources including the ability to assign roles in Azure RBAC. Can manage both resources and access control.
   * **Contributor:** Full access to manage all resources but cannot assign roles in Azure RBAC. Can create, modify, and delete resources but cannot delegate access to others.
   
   **Key Distinction:** Only Owner (and User Access Administrator) can manage RBAC role assignments.

2. **If a user has Reader at subscription and Contributor at resource group, what are their effective permissions in that resource group?**

   **Answer:** 
   * **Effective Permission:** Contributor
   * **Reason:** Azure RBAC permissions are cumulative (additive). The more permissive role takes effect at each scope. Since Contributor includes all Reader permissions plus write/delete capabilities, the user effectively has Contributor access in that specific resource group.
   * **Other Resource Groups:** The user retains only Reader permissions (inherited from subscription) in resource groups where they don't have explicit Contributor assignment.

3. **How does scope inheritance work?**

   **Answer:**
   * Permissions assigned at a parent scope automatically flow down to all child scopes (inheritance)
   * **Hierarchy:** Management Group → Subscription → Resource Group → Resource
   * **Cannot be blocked:** Azure RBAC does not support "deny inheritance"—you cannot prevent inherited permissions from flowing down
   * **Cumulative:** If a user has Reader at subscription and Contributor at resource group, they get both (Contributor being more permissive wins)
   * **Assignment path:** Permissions can come from direct assignments at any level or through group membership
   
   **Example:**
   * Reader assigned at subscription = read access to all resource groups and resources
   * Contributor at resource group = read/write to that RG and all its resources
   * Virtual Machine Contributor at specific VM = manage only that VM

4. **Can you create custom deny assignments?**

   **Answer:** 
   * **No.** Users and administrators cannot manually create deny assignments
   * **Only Azure services** can create deny assignments automatically:
     * Azure Blueprints (when using resource locks)
     * Azure Managed Applications (managed resource groups)
     * System-protection mechanisms
   * **Precedence:** Deny assignments always take precedence over allow (role assignments)
   * **Purpose:** Protect critical resources from accidental or malicious modification/deletion
   * **View only:** You can view and list deny assignments but cannot create, modify, or delete them

5. **Why use service principals instead of user accounts for automation?**

   **Answer:**
   * **Non-interactive authentication:** Service principals are designed for apps, services, and automation tools—no human sign-in required
   * **No MFA prompts:** Automation scripts don't get interrupted by multi-factor authentication
   * **Independent lifecycle:** Not tied to a specific user's employment status or password changes
   * **Principle of least privilege:** Can assign minimal permissions specific to the automation task
   * **Auditing:** Service principal activity is logged separately from user activity, making it easier to audit automated vs. manual changes
   * **Credential management:** Can use certificates or federated credentials (workload identity) instead of passwords
   * **Better alternative:** Managed Identities (when applicable) are even better—no credentials to manage at all

   **Best Practice:** Use Managed Identities > Service Principals > User Accounts for automation.

6. **What's the scope format for a resource group?**

   **Answer:**
   ```
   /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}
   ```
   
   **Full Scope Hierarchy:**
   * **Management Group:** `/providers/Microsoft.Management/managementGroups/{mgName}`
   * **Subscription:** `/subscriptions/{subscriptionId}`
   * **Resource Group:** `/subscriptions/{subscriptionId}/resourceGroups/{rgName}`
   * **Resource:** `/subscriptions/{subscriptionId}/resourceGroups/{rgName}/providers/{providerNamespace}/{resourceType}/{resourceName}`
   
   **Example:**
   ```
   /subscriptions/12345678-1234-1234-1234-123456789abc/resourceGroups/rg-dev-test
   ```
   
   **Usage:** This format is required when assigning roles via CLI or PowerShell with the `-Scope` parameter.

---

## 📚 References

* [What is Azure role-based access control (Azure RBAC)?](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)
* [Steps to assign an Azure role](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-steps)
* [Azure built-in roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles)
* [Understand scope for Azure RBAC](https://learn.microsoft.com/en-us/azure/role-based-access-control/scope-overview)
* [Understand Azure deny assignments](https://learn.microsoft.com/en-us/azure/role-based-access-control/deny-assignments)
* [Create a service principal with Azure CLI](https://learn.microsoft.com/en-us/cli/azure/azure-cli-sp-tutorial-1)
* [Assign Azure roles using Azure PowerShell](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-powershell)
* [List Azure role assignments](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-list-portal)

---

*Lab created: 2025-10-20*
*Last updated: 2025-10-20*
