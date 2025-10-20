# Lab 02 – Role-Based Access & Scoping

This lab focuses on implementing and validating Azure role-based access control (RBAC) across different scopes.

## 📁 Folder Structure

```
lab02-rbac-scoping/
├── Lab02_Role-Based-Access-Scoping.md   # Main lab guide
├── bicep/                                # Bicep templates
│   └── role-assignment.bicep             # Role assignment template
├── terraform/                            # Terraform configurations
│   └── role-assignment.tf                # Role assignment with Terraform
├── powershell/                           # PowerShell scripts
│   └── Manage-RBAC.ps1                   # Helper functions for RBAC management
├── cli/                                  # Azure CLI scripts
│   └── manage-rbac.sh                    # Helper functions for RBAC management
└── images/                               # Screenshots and diagrams
```

## 🎯 Learning Objectives

After completing this lab, you will be able to:

* Understand Azure built-in roles and their permissions
* Create custom roles with specific permissions
* Assign roles at different scopes (subscription, resource group, resource)
* Verify permission inheritance and effective access
* Implement least privilege access principles
* Manage service principal access
* Understand deny assignments and their precedence

## 🧰 Tools and Technologies

* **Azure Portal** - Visual RBAC management
* **Azure PowerShell** - Scripted role assignments
* **Azure CLI** - Command-line role management
* **Bicep** - Infrastructure as Code for role assignments
* **Terraform** - Alternative IaC approach

## 🚀 Quick Start

### Option 1: PowerShell

```powershell
# Navigate to the PowerShell directory
cd powershell

# Load the helper functions
. .\Manage-RBAC.ps1

# Assign a role at subscription scope
Assign-RoleAtSubscription -PrincipalName "user@domain.com" -RoleName "Reader" -PrincipalType "User"

# View assignments
Get-RoleAssignmentReport -Scope "Subscription"
```

### Option 2: Azure CLI

```bash
# Navigate to the CLI directory
cd cli

# Source the helper functions
source manage-rbac.sh

# Assign a role at resource group scope
assign_role_at_resource_group "Dev-Team" "Contributor" "rg-dev-test" "Group"

# View assignments
get_role_assignment_report "ResourceGroup" "rg-dev-test"
```

### Option 3: Bicep

```powershell
# Navigate to the Bicep directory
cd bicep

# Get user principal ID
$principalId = (Get-AzADUser -UserPrincipalName "user@domain.com").Id

# Deploy the template
New-AzResourceGroupDeployment `
    -ResourceGroupName "rg-dev-test" `
    -TemplateFile "./role-assignment.bicep" `
    -principalId $principalId `
    -principalType "User"
```

### Option 4: Terraform

```bash
# Navigate to the Terraform directory
cd terraform

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

## 📋 Prerequisites

* Completed [Lab 01 - Setup and Identity Baseline](../lab01-setup-identity-baseline/Lab01_Setup-Identity-Baseline.md)
* Azure subscription with Owner or User Access Administrator role
* Users and groups created in Lab 01
* Azure PowerShell module installed
* Azure CLI installed
* (Optional) Terraform installed

## 🔗 Key Resources

* [Azure Built-in Roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles)
* [Assign Azure Roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal)
* [Understand Scope](https://learn.microsoft.com/en-us/azure/role-based-access-control/scope-overview)
* [Azure RBAC Best Practices](https://learn.microsoft.com/en-us/azure/role-based-access-control/best-practices)

## ⏱ Estimated Time

**90–120 minutes**

## 🎓 Related Labs

* **Previous:** [Lab 01 - Setup and Identity Baseline](../lab01-setup-identity-baseline/Lab01_Setup-Identity-Baseline.md)
* **Next:** Lab 03 - Policy & Resource Locks (Coming Soon)

---

*Created: 2025-10-20*
