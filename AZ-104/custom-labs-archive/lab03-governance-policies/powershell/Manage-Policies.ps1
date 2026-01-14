# Azure Policy Management Script
# Purpose: Create and manage Azure Policy definitions and assignments
# Lab 03 - Governance & Policies

#Requires -Modules Az.Resources, Az.PolicyInsights

# ==============================================================================
# Configuration
# ==============================================================================

$ErrorActionPreference = "Stop"

# Get current subscription
$subscription = Get-AzSubscription | Where-Object { $_.State -eq "Enabled" } | Select-Object -First 1
Write-Host "Using subscription: $($subscription.Name) ($($subscription.Id))" -ForegroundColor Cyan

# ==============================================================================
# Function: Create Custom Policy Definitions
# ==============================================================================

function New-CustomPolicyDefinitions {
    Write-Host "`n=== Creating Custom Policy Definitions ===" -ForegroundColor Green

    # Storage Account Naming Convention
    Write-Host "Creating Storage Account Naming Convention policy..." -ForegroundColor Yellow
    $storagePolicy = New-AzPolicyDefinition `
        -Name 'storage-naming-convention' `
        -DisplayName 'Enforce Storage Account Naming Convention' `
        -Description 'Storage account names must follow pattern: st<env><app><region><seq>' `
        -Policy './storage-naming-policy.json' `
        -Mode 'Indexed' `
        -Metadata '{"category":"Storage"}'

    Write-Host "✓ Created: $($storagePolicy.Name)" -ForegroundColor Green

    # Require CostCenter Tag with Allowed Values
    Write-Host "Creating CostCenter Tag Values policy..." -ForegroundColor Yellow
    $tagPolicy = New-AzPolicyDefinition `
        -Name 'require-costcenter-values' `
        -DisplayName 'Require CostCenter Tag with Allowed Values' `
        -Description 'Requires CostCenter tag with approved department values' `
        -Policy './require-costcenter-tag-values.json' `
        -Mode 'Indexed' `
        -Metadata '{"category":"Tags"}'

    Write-Host "✓ Created: $($tagPolicy.Name)" -ForegroundColor Green

    # Audit VMs Without Backup
    Write-Host "Creating VM Backup Audit policy..." -ForegroundColor Yellow
    $backupPolicy = New-AzPolicyDefinition `
        -Name 'audit-vm-backup' `
        -DisplayName 'Audit VMs Without Backup Enabled' `
        -Description 'Audits virtual machines without backup protection' `
        -Policy './audit-vm-backup.json' `
        -Mode 'Indexed' `
        -Metadata '{"category":"Backup"}'

    Write-Host "✓ Created: $($backupPolicy.Name)" -ForegroundColor Green
}

# ==============================================================================
# Function: Assign Built-in Policies
# ==============================================================================

function New-BuiltinPolicyAssignments {
    Write-Host "`n=== Assigning Built-in Policies ===" -ForegroundColor Green

    # Allowed Locations
    Write-Host "Assigning Allowed Locations policy..." -ForegroundColor Yellow
    $locationPolicy = Get-AzPolicyDefinition | Where-Object {
        $_.Properties.DisplayName -eq 'Allowed locations'
    }

    $locationParams = @{
        'listOfAllowedLocations' = @('eastus', 'westus')
    }

    New-AzPolicyAssignment `
        -Name 'allowed-locations-policy' `
        -DisplayName 'Allowed Locations - East US and West US Only' `
        -Scope "/subscriptions/$($subscription.Id)" `
        -PolicyDefinition $locationPolicy `
        -PolicyParameterObject $locationParams `
        -Description 'Restricts resource deployment to East US and West US regions'

    Write-Host "✓ Assigned: Allowed Locations" -ForegroundColor Green

    # Require Tag on Resource Groups
    Write-Host "Assigning Require Tag on Resource Groups policy..." -ForegroundColor Yellow
    $rgTagPolicy = Get-AzPolicyDefinition | Where-Object {
        $_.Properties.DisplayName -eq 'Require a tag on resource groups'
    }

    $rgTagParams = @{
        'tagName' = 'CostCenter'
    }

    New-AzPolicyAssignment `
        -Name 'require-costcenter-tag-rg' `
        -DisplayName 'Require CostCenter Tag on Resource Groups' `
        -Scope "/subscriptions/$($subscription.Id)" `
        -PolicyDefinition $rgTagPolicy `
        -PolicyParameterObject $rgTagParams

    Write-Host "✓ Assigned: Require Tag on Resource Groups" -ForegroundColor Green
}

# ==============================================================================
# Function: Assign Custom Policies
# ==============================================================================

function New-CustomPolicyAssignments {
    Write-Host "`n=== Assigning Custom Policies ===" -ForegroundColor Green

    # Storage Naming Convention
    Write-Host "Assigning Storage Naming Convention policy..." -ForegroundColor Yellow
    $storagePolicyDef = Get-AzPolicyDefinition -Name 'storage-naming-convention'

    New-AzPolicyAssignment `
        -Name 'enforce-storage-naming' `
        -DisplayName 'Enforce Storage Naming Convention' `
        -Scope "/subscriptions/$($subscription.Id)" `
        -PolicyDefinition $storagePolicyDef

    Write-Host "✓ Assigned: Storage Naming Convention" -ForegroundColor Green

    # CostCenter Tag Values
    Write-Host "Assigning CostCenter Tag Values policy..." -ForegroundColor Yellow
    $tagPolicyDef = Get-AzPolicyDefinition -Name 'require-costcenter-values'

    $tagParams = @{
        'tagName' = 'CostCenter'
        'allowedValues' = @('Engineering', 'Marketing', 'Sales', 'HR', 'IT')
    }

    New-AzPolicyAssignment `
        -Name 'require-costcenter-values' `
        -DisplayName 'Require Valid CostCenter Tag' `
        -Scope "/subscriptions/$($subscription.Id)" `
        -PolicyDefinition $tagPolicyDef `
        -PolicyParameterObject $tagParams

    Write-Host "✓ Assigned: CostCenter Tag Values" -ForegroundColor Green
}

# ==============================================================================
# Function: Get Policy Compliance
# ==============================================================================

function Get-PolicyComplianceReport {
    Write-Host "`n=== Policy Compliance Report ===" -ForegroundColor Green

    Write-Host "Fetching compliance data..." -ForegroundColor Yellow

    # Overall compliance summary
    $summary = Get-AzPolicyStateSummary -SubscriptionId $subscription.Id

    Write-Host "`nCompliance Summary:" -ForegroundColor Cyan
    Write-Host "  Total Resources: $($summary.Results.ResourceDetails.TotalResources)"
    Write-Host "  Compliant: $($summary.Results.ResourceDetails.CompliantResources)" -ForegroundColor Green
    Write-Host "  Non-Compliant: $($summary.Results.ResourceDetails.NonCompliantResources)" -ForegroundColor Red

    # Detailed compliance by policy
    Write-Host "`nCompliance by Policy:" -ForegroundColor Cyan
    $policyStates = Get-AzPolicyState -SubscriptionId $subscription.Id |
        Group-Object PolicyAssignmentName |
        Select-Object Name, Count, @{Name="NonCompliant";Expression={($_.Group | Where-Object {$_.ComplianceState -eq "NonCompliant"}).Count}}

    $policyStates | Format-Table -AutoSize
}

# ==============================================================================
# Function: Remove All Policy Assignments
# ==============================================================================

function Remove-AllPolicyAssignments {
    Write-Host "`n=== Removing All Policy Assignments ===" -ForegroundColor Green

    $assignments = Get-AzPolicyAssignment -Scope "/subscriptions/$($subscription.Id)"

    foreach ($assignment in $assignments) {
        Write-Host "Removing: $($assignment.Properties.DisplayName)" -ForegroundColor Yellow
        Remove-AzPolicyAssignment -Id $assignment.ResourceId -Confirm:$false
    }

    Write-Host "✓ All policy assignments removed" -ForegroundColor Green
}

# ==============================================================================
# Function: Remove Custom Policy Definitions
# ==============================================================================

function Remove-CustomPolicyDefinitions {
    Write-Host "`n=== Removing Custom Policy Definitions ===" -ForegroundColor Green

    $customPolicies = @('storage-naming-convention', 'require-costcenter-values', 'audit-vm-backup')

    foreach ($policyName in $customPolicies) {
        try {
            Write-Host "Removing: $policyName" -ForegroundColor Yellow
            Remove-AzPolicyDefinition -Name $policyName -Force
            Write-Host "✓ Removed: $policyName" -ForegroundColor Green
        }
        catch {
            Write-Host "  Policy not found: $policyName" -ForegroundColor Gray
        }
    }
}

# ==============================================================================
# Main Menu
# ==============================================================================

function Show-Menu {
    Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║          Azure Policy Management Script                   ║" -ForegroundColor Cyan
    Write-Host "║          Lab 03 - Governance & Policies                   ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  [1] Create Custom Policy Definitions" -ForegroundColor White
    Write-Host "  [2] Assign Built-in Policies" -ForegroundColor White
    Write-Host "  [3] Assign Custom Policies" -ForegroundColor White
    Write-Host "  [4] Get Policy Compliance Report" -ForegroundColor White
    Write-Host "  [5] Remove All Policy Assignments" -ForegroundColor White
    Write-Host "  [6] Remove Custom Policy Definitions" -ForegroundColor White
    Write-Host "  [7] Run All (Create & Assign)" -ForegroundColor White
    Write-Host "  [0] Exit" -ForegroundColor White
    Write-Host ""
}

# ==============================================================================
# Main Execution
# ==============================================================================

do {
    Show-Menu
    $choice = Read-Host "Select an option"

    switch ($choice) {
        '1' { New-CustomPolicyDefinitions }
        '2' { New-BuiltinPolicyAssignments }
        '3' { New-CustomPolicyAssignments }
        '4' { Get-PolicyComplianceReport }
        '5' { Remove-AllPolicyAssignments }
        '6' { Remove-CustomPolicyDefinitions }
        '7' {
            New-CustomPolicyDefinitions
            New-BuiltinPolicyAssignments
            New-CustomPolicyAssignments
            Write-Host "`n✓ All policies created and assigned" -ForegroundColor Green
        }
        '0' {
            Write-Host "`nExiting..." -ForegroundColor Yellow
            break
        }
        default { Write-Host "`nInvalid option. Please try again." -ForegroundColor Red }
    }

    if ($choice -ne '0') {
        Write-Host "`nPress any key to continue..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
} while ($choice -ne '0')
