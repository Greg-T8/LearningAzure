# Lab 02 - Custom Role Management Scripts
# Purpose: Create and manage custom Azure roles using PowerShell

# Prerequisites: Connect to Azure
# Connect-AzAccount

# ============================================================================
# VARIABLES - Update these for your environment
# ============================================================================
$subscriptionId = (Get-AzContext).Subscription.Id

# ============================================================================
# FUNCTION: Create Custom Role from Built-in Role
# ============================================================================
function New-CustomRoleFromBuiltIn {
    param(
        [string]$BuiltInRoleName,
        [string]$NewRoleName,
        [string]$Description,
        [string[]]$AdditionalActions = @(),
        [string[]]$RemoveActions = @(),
        [string[]]$AssignableScopes
    )

    Write-Host "Creating custom role '$NewRoleName' based on '$BuiltInRoleName'..." -ForegroundColor Cyan

    # Get built-in role
    $role = Get-AzRoleDefinition $BuiltInRoleName

    # Modify properties
    $role.Id = $null
    $role.Name = $NewRoleName
    $role.Description = $Description
    $role.IsCustom = $true

    # Add additional actions
    foreach ($action in $AdditionalActions) {
        $role.Actions.Add($action)
    }

    # Remove specified actions
    foreach ($action in $RemoveActions) {
        $role.Actions.Remove($action)
    }

    # Set assignable scopes
    if ($AssignableScopes) {
        $role.AssignableScopes.Clear()
        foreach ($scope in $AssignableScopes) {
            $role.AssignableScopes.Add($scope)
        }
    }

    # Create the role
    try {
        $newRole = New-AzRoleDefinition -Role $role
        Write-Host "✅ Custom role created successfully" -ForegroundColor Green
        return $newRole
    }
    catch {
        Write-Host "❌ Failed to create custom role: $_" -ForegroundColor Red
    }
}

# ============================================================================
# FUNCTION: Create Custom Role from Scratch
# ============================================================================
function New-CustomRoleFromScratch {
    param(
        [string]$RoleName,
        [string]$Description,
        [string[]]$Actions,
        [string[]]$DataActions = @(),
        [string[]]$NotActions = @(),
        [string[]]$NotDataActions = @(),
        [string[]]$AssignableScopes
    )

    Write-Host "Creating custom role '$RoleName' from scratch..." -ForegroundColor Cyan

    # Create new role object
    $role = [Microsoft.Azure.Commands.Resources.Models.Authorization.PSRoleDefinition]::new()
    $role.Name = $RoleName
    $role.Description = $Description
    $role.IsCustom = $true
    $role.Actions = $Actions
    $role.NotActions = $NotActions
    $role.DataActions = $DataActions
    $role.NotDataActions = $NotDataActions
    $role.AssignableScopes = $AssignableScopes

    # Create the role
    try {
        $newRole = New-AzRoleDefinition -Role $role
        Write-Host "✅ Custom role created successfully" -ForegroundColor Green
        return $newRole
    }
    catch {
        Write-Host "❌ Failed to create custom role: $_" -ForegroundColor Red
    }
}

# ============================================================================
# FUNCTION: Create Custom Role from JSON File
# ============================================================================
function New-CustomRoleFromJson {
    param(
        [string]$JsonFilePath,
        [switch]$ReplaceSubscriptionId
    )

    Write-Host "Creating custom role from JSON file: $JsonFilePath" -ForegroundColor Cyan

    # Replace subscription ID placeholder if requested
    if ($ReplaceSubscriptionId) {
        $content = Get-Content $JsonFilePath -Raw
        $content = $content -replace '\{subscription-id\}', $subscriptionId
        $tempFile = [System.IO.Path]::GetTempFileName() + ".json"
        $content | Set-Content $tempFile
        $JsonFilePath = $tempFile
    }

    try {
        $newRole = New-AzRoleDefinition -InputFile $JsonFilePath
        Write-Host "✅ Custom role created successfully" -ForegroundColor Green

        # Clean up temp file
        if ($ReplaceSubscriptionId) {
            Remove-Item $tempFile -Force
        }

        return $newRole
    }
    catch {
        Write-Host "❌ Failed to create custom role: $_" -ForegroundColor Red
    }
}

# ============================================================================
# FUNCTION: List Custom Roles
# ============================================================================
function Get-CustomRoles {
    Write-Host "`nListing all custom roles..." -ForegroundColor Cyan

    Get-AzRoleDefinition | Where-Object {$_.IsCustom -eq $true} |
        Select-Object Name, Description, IsCustom, AssignableScopes |
        Format-Table -AutoSize
}

# ============================================================================
# FUNCTION: Update Custom Role
# ============================================================================
function Update-CustomRole {
    param(
        [string]$RoleName,
        [string[]]$AddActions = @(),
        [string[]]$RemoveActions = @(),
        [string]$NewDescription
    )

    Write-Host "Updating custom role: $RoleName" -ForegroundColor Cyan

    # Get existing role
    $role = Get-AzRoleDefinition $RoleName

    if (-not $role.IsCustom) {
        Write-Host "❌ '$RoleName' is not a custom role" -ForegroundColor Red
        return
    }

    # Add actions
    foreach ($action in $AddActions) {
        if (-not $role.Actions.Contains($action)) {
            $role.Actions.Add($action)
            Write-Host "  Added action: $action" -ForegroundColor Green
        }
    }

    # Remove actions
    foreach ($action in $RemoveActions) {
        if ($role.Actions.Contains($action)) {
            $role.Actions.Remove($action)
            Write-Host "  Removed action: $action" -ForegroundColor Yellow
        }
    }

    # Update description if provided
    if ($NewDescription) {
        $role.Description = $NewDescription
    }

    # Update the role
    try {
        Set-AzRoleDefinition -Role $role | Out-Null
        Write-Host "✅ Custom role updated successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Failed to update custom role: $_" -ForegroundColor Red
    }
}

# ============================================================================
# FUNCTION: Delete Custom Role
# ============================================================================
function Remove-CustomRole {
    param(
        [string]$RoleName,
        [switch]$Force
    )

    Write-Host "Attempting to delete custom role: $RoleName" -ForegroundColor Yellow

    # Check for active assignments
    $role = Get-AzRoleDefinition $RoleName
    $assignments = Get-AzRoleAssignment -RoleDefinitionId $role.Id

    if ($assignments) {
        Write-Host "❌ Cannot delete: Role has $($assignments.Count) active assignments" -ForegroundColor Red
        Write-Host "`nActive assignments:" -ForegroundColor Yellow
        $assignments | Format-Table DisplayName, Scope, ObjectType

        if (-not $Force) {
            Write-Host "`nUse -Force to remove assignments and delete the role" -ForegroundColor Cyan
            return
        }

        # Remove assignments if Force is specified
        Write-Host "`nRemoving all role assignments..." -ForegroundColor Yellow
        foreach ($assignment in $assignments) {
            Remove-AzRoleAssignment -InputObject $assignment -Force
        }
    }

    # Delete the role
    try {
        Remove-AzRoleDefinition -Name $RoleName -Force
        Write-Host "✅ Custom role deleted successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Failed to delete custom role: $_" -ForegroundColor Red
    }
}

# ============================================================================
# FUNCTION: Export Custom Role to JSON
# ============================================================================
function Export-CustomRole {
    param(
        [string]$RoleName,
        [string]$OutputPath
    )

    Write-Host "Exporting custom role to JSON: $OutputPath" -ForegroundColor Cyan

    $role = Get-AzRoleDefinition $RoleName

    if (-not $role.IsCustom) {
        Write-Host "❌ '$RoleName' is not a custom role" -ForegroundColor Red
        return
    }

    # Convert to JSON
    $role | Select-Object Name, IsCustom, Description, Actions, NotActions, DataActions, NotDataActions, AssignableScopes |
        ConvertTo-Json -Depth 5 |
        Set-Content $OutputPath

    Write-Host "✅ Custom role exported successfully" -ForegroundColor Green
}

# ============================================================================
# EXAMPLE USAGE
# ============================================================================

# Example 1: Create VM Operator role from Virtual Machine Contributor
<#
New-CustomRoleFromBuiltIn `
    -BuiltInRoleName "Virtual Machine Contributor" `
    -NewRoleName "Virtual Machine Operator" `
    -Description "Can monitor, start, and restart virtual machines" `
    -RemoveActions @("Microsoft.Compute/virtualMachines/write", "Microsoft.Compute/virtualMachines/delete") `
    -AssignableScopes @("/subscriptions/$subscriptionId")
#>

# Example 2: Create Storage Blob Operator from scratch
<#
$actions = @(
    "Microsoft.Storage/*/read",
    "Microsoft.Storage/storageAccounts/blobServices/containers/read",
    "Microsoft.Authorization/*/read",
    "Microsoft.Resources/subscriptions/resourceGroups/read"
)

$dataActions = @(
    "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
    "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
    "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete"
)

New-CustomRoleFromScratch `
    -RoleName "Storage Blob Operator" `
    -Description "Can read, write, and delete blobs but not manage storage accounts" `
    -Actions $actions `
    -DataActions $dataActions `
    -AssignableScopes @("/subscriptions/$subscriptionId")
#>

# Example 3: Create role from JSON file
<#
New-CustomRoleFromJson -JsonFilePath ".\custom-role.json" -ReplaceSubscriptionId
#>

# Example 4: List all custom roles
# Get-CustomRoles

# Example 5: Update a custom role
<#
Update-CustomRole `
    -RoleName "Virtual Machine Operator" `
    -AddActions @("Microsoft.Compute/virtualMachines/deallocate/action") `
    -NewDescription "Can monitor, start, restart, and deallocate virtual machines"
#>

# Example 6: Export custom role to JSON
# Export-CustomRole -RoleName "Virtual Machine Operator" -OutputPath ".\vm-operator.json"

# Example 7: Delete a custom role
# Remove-CustomRole -RoleName "Virtual Machine Operator" -Force

Write-Host "`n✅ Custom role management script loaded." -ForegroundColor Green
Write-Host "Use the functions above to manage custom roles." -ForegroundColor Cyan
Write-Host "Example: New-CustomRoleFromBuiltIn -BuiltInRoleName 'Reader' -NewRoleName 'Custom Reader' ..." -ForegroundColor Cyan
