# Lab 02 - RBAC Role Assignment Scripts
# Purpose: Assign roles at different scopes using PowerShell

# Prerequisites: Connect to Azure
# Connect-AzAccount

# ============================================================================
# VARIABLES - Update these for your environment
# ============================================================================
$subscriptionId = (Get-AzContext).Subscription.Id
$resourceGroupName = "rg-dev-test"
$location = "eastus"
$userPrincipalName = "user1@637djb.onmicrosoft.com"
$groupName = "Dev-Team"

# ============================================================================
# FUNCTION: Assign Role at Subscription Scope
# ============================================================================
function Assign-RoleAtSubscription {
    param(
        [string]$PrincipalName,
        [string]$RoleName,
        [string]$PrincipalType = "User"  # User, Group, ServicePrincipal
    )

    Write-Host "Assigning $RoleName to $PrincipalName at subscription scope..." -ForegroundColor Cyan

    $principalId = if ($PrincipalType -eq "User") {
        (Get-AzADUser -UserPrincipalName $PrincipalName).Id
    } elseif ($PrincipalType -eq "Group") {
        (Get-AzADGroup -DisplayName $PrincipalName).Id
    }

    New-AzRoleAssignment `
        -ObjectId $principalId `
        -RoleDefinitionName $RoleName `
        -Scope "/subscriptions/$subscriptionId"

    Write-Host "✅ Role assigned successfully" -ForegroundColor Green
}

# ============================================================================
# FUNCTION: Assign Role at Resource Group Scope
# ============================================================================
function Assign-RoleAtResourceGroup {
    param(
        [string]$PrincipalName,
        [string]$RoleName,
        [string]$ResourceGroupName,
        [string]$PrincipalType = "User"
    )

    Write-Host "Assigning $RoleName to $PrincipalName at resource group scope..." -ForegroundColor Cyan

    $principalId = if ($PrincipalType -eq "User") {
        (Get-AzADUser -UserPrincipalName $PrincipalName).Id
    } elseif ($PrincipalType -eq "Group") {
        (Get-AzADGroup -DisplayName $PrincipalName).Id
    }

    New-AzRoleAssignment `
        -ObjectId $principalId `
        -RoleDefinitionName $RoleName `
        -ResourceGroupName $ResourceGroupName

    Write-Host "✅ Role assigned successfully" -ForegroundColor Green
}

# ============================================================================
# FUNCTION: List Role Assignments
# ============================================================================
function Get-RoleAssignmentReport {
    param(
        [string]$Scope = "Subscription",
        [string]$ResourceGroupName
    )

    Write-Host "`nGenerating Role Assignment Report..." -ForegroundColor Cyan

    if ($Scope -eq "Subscription") {
        $assignments = Get-AzRoleAssignment -Scope "/subscriptions/$subscriptionId"
    } else {
        $assignments = Get-AzRoleAssignment -ResourceGroupName $ResourceGroupName
    }

    $assignments | Select-Object DisplayName, RoleDefinitionName, ObjectType, Scope |
        Format-Table -AutoSize
}

# ============================================================================
# FUNCTION: Remove Role Assignment
# ============================================================================
function Remove-RoleFromPrincipal {
    param(
        [string]$PrincipalName,
        [string]$RoleName,
        [string]$Scope,
        [string]$PrincipalType = "User"
    )

    Write-Host "Removing $RoleName from $PrincipalName..." -ForegroundColor Yellow

    $principalId = if ($PrincipalType -eq "User") {
        (Get-AzADUser -UserPrincipalName $PrincipalName).Id
    } elseif ($PrincipalType -eq "Group") {
        (Get-AzADGroup -DisplayName $PrincipalName).Id
    }

    Remove-AzRoleAssignment `
        -ObjectId $principalId `
        -RoleDefinitionName $RoleName `
        -Scope $Scope `
        -Verbose

    Write-Host "✅ Role removed successfully" -ForegroundColor Green
}

# ============================================================================
# EXAMPLE USAGE
# ============================================================================

# Example 1: Assign Reader at subscription scope
# Assign-RoleAtSubscription -PrincipalName $userPrincipalName -RoleName "Reader" -PrincipalType "User"

# Example 2: Assign Contributor at resource group scope
# Ensure resource group exists
# New-AzResourceGroup -Name $resourceGroupName -Location $location -Force
# Assign-RoleAtResourceGroup -PrincipalName $groupName -RoleName "Contributor" -ResourceGroupName $resourceGroupName -PrincipalType "Group"

# Example 3: View role assignments
# Get-RoleAssignmentReport -Scope "Subscription"
# Get-RoleAssignmentReport -Scope "ResourceGroup" -ResourceGroupName $resourceGroupName

# Example 4: Remove role assignment
# Remove-RoleFromPrincipal -PrincipalName $userPrincipalName -RoleName "Reader" -Scope "/subscriptions/$subscriptionId" -PrincipalType "User"

Write-Host "`n✅ Script loaded. Use the functions above to manage RBAC." -ForegroundColor Green
Write-Host "Example: Assign-RoleAtSubscription -PrincipalName 'user@domain.com' -RoleName 'Reader' -PrincipalType 'User'" -ForegroundColor Cyan
