# Custom Role Examples

This directory contains example custom role definitions for common scenarios in Azure.

## 📋 Available Custom Roles

### 1. Virtual Machine Operator (`vm-operator.json`)

**Use Case:** Operations team needs to manage VM power state without ability to modify VM configuration.

**Permissions:**
- ✅ Read all compute, network, and storage resources
- ✅ Start, restart, and deallocate virtual machines
- ✅ View diagnostics and create support tickets
- ❌ Create, modify, or delete VMs
- ❌ Change VM size or configuration

**Assignable Scope:** Subscription or resource group

**Deployment:**
```powershell
New-AzRoleDefinition -InputFile ".\custom-roles\vm-operator.json"
```

---

### 2. Storage Blob Operator (`storage-blob-operator.json`)

**Use Case:** Application needs to read/write blob data without access to storage account keys.

**Permissions:**
- ✅ Read storage account properties
- ✅ Read, write, delete, add, and move blobs (data plane)
- ❌ List storage account keys
- ❌ Regenerate keys
- ❌ Delete storage accounts

**Assignable Scope:** Subscription or resource group

**Important:** This role uses `DataActions` for blob operations, so it **cannot** be assigned at management group scope.

**Deployment:**
```powershell
New-AzRoleDefinition -InputFile ".\custom-roles\storage-blob-operator.json"
```

---

### 3. Network Security Reader (`network-security-reader.json`)

**Use Case:** Security auditor needs read-only access to network configurations.

**Permissions:**
- ✅ Read all network resources (VNets, NSGs, Load Balancers, etc.)
- ✅ View alert rules
- ✅ Create support tickets
- ❌ Modify any network resources
- ❌ Create or delete network resources

**Assignable Scope:** Subscription or resource group

**Deployment:**
```powershell
New-AzRoleDefinition -InputFile ".\custom-roles\network-security-reader.json"
```

---

### 4. Resource Group Admin No Delete (`rg-admin-no-delete.json`)

**Use Case:** Compliance requirement prevents deletion of resources even by administrators.

**Permissions:**
- ✅ Read and write all resources
- ✅ Deploy resources using templates
- ✅ Configure monitoring and alerts
- ❌ Delete any resources
- ❌ Delete the resource group itself

**Assignable Scope:** Resource group only

**Important:** Uses `NotActions` to exclude all delete operations while allowing other modifications.

**Deployment:**
```powershell
New-AzRoleDefinition -InputFile ".\custom-roles\rg-admin-no-delete.json"
```

---

## 🚀 Quick Start

### 1. Update Subscription ID

Before deploying, replace `{subscription-id}` placeholders:

```powershell
# Get your subscription ID
$subscriptionId = (Get-AzContext).Subscription.Id

# Update JSON files
$files = Get-ChildItem ".\custom-roles\*.json"
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $content = $content -replace '\{subscription-id\}', $subscriptionId
    $content | Set-Content $file.FullName
}
```

### 2. Deploy Custom Roles

```powershell
# Deploy all custom roles
Get-ChildItem ".\custom-roles\*.json" | ForEach-Object {
    Write-Host "Creating role from $($_.Name)..." -ForegroundColor Cyan
    New-AzRoleDefinition -InputFile $_.FullName
}
```

### 3. Assign Custom Role

```powershell
# Assign VM Operator role to a user
New-AzRoleAssignment `
    -SignInName "user@domain.com" `
    -RoleDefinitionName "Virtual Machine Operator" `
    -ResourceGroupName "rg-production"
```

---

## 📝 Best Practices

1. **Test in Non-Production First**
   - Deploy custom roles in dev/test subscriptions
   - Validate permissions work as expected
   - Document any issues or edge cases

2. **Use Descriptive Names**
   - Include purpose in the role name
   - Avoid generic names like "Custom Role 1"
   - Consider versioning if roles evolve

3. **Document Use Cases**
   - Explain why the custom role was created
   - Document which built-in roles were insufficient
   - Track which teams/projects use the role

4. **Version Control**
   - Store role definitions in Git
   - Review changes through pull requests
   - Tag releases for production deployments

5. **Regular Reviews**
   - Audit custom role usage quarterly
   - Remove unused custom roles
   - Update permissions as Azure adds new features

---

## 🔍 Validation Commands

### List All Custom Roles
```powershell
Get-AzRoleDefinition | Where-Object {$_.IsCustom -eq $true} | Format-Table Name, Description
```

### View Role Details
```powershell
Get-AzRoleDefinition "Virtual Machine Operator" | Format-List
```

### Find Role Assignments
```powershell
$roleId = (Get-AzRoleDefinition "Virtual Machine Operator").Id
Get-AzRoleAssignment -RoleDefinitionId $roleId | Format-Table DisplayName, Scope
```

### Export Role to JSON
```powershell
Get-AzRoleDefinition "Virtual Machine Operator" | ConvertTo-Json -Depth 5 | Out-File "exported-role.json"
```

---

## 🗑️ Cleanup

To delete custom roles:

```powershell
# Remove role assignments first
$roleId = (Get-AzRoleDefinition "Virtual Machine Operator").Id
Get-AzRoleAssignment -RoleDefinitionId $roleId | Remove-AzRoleAssignment

# Delete the custom role
Remove-AzRoleDefinition -Name "Virtual Machine Operator" -Force
```

---

## ⚠️ Important Notes

- Maximum of **5,000 custom roles** per Azure AD tenant
- Custom roles with `DataActions` **cannot** be assigned at management group scope
- Only **one management group** allowed in `AssignableScopes`
- Root scope (`"/"`) is not allowed for custom roles (built-in roles only)
- Requires `Microsoft.Authorization/roleDefinitions/write` permission on all assignable scopes

---

## 📚 References

- [Azure custom roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles)
- [Azure resource provider operations](https://learn.microsoft.com/en-us/azure/role-based-access-control/resource-provider-operations)
- [Tutorial: Create a custom role using Azure PowerShell](https://learn.microsoft.com/en-us/azure/role-based-access-control/tutorial-custom-role-powershell)

---

*Created: 2025-10-20*
