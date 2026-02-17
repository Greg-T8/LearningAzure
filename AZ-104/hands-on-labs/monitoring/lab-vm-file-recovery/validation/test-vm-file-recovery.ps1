# -------------------------------------------------------------------------
# Program: test-vm-file-recovery.ps1
# Description: Validate VM file recovery lab deployment
# Context: AZ-104 Lab - Recover Configuration File from Azure VM Backup
# Author: Greg Tate
# Date: 2026-02-17
# -------------------------------------------------------------------------

<#
.SYNOPSIS
Validates that the VM file recovery lab resources were deployed correctly.

.DESCRIPTION
Checks for the existence and correct configuration of the resource group,
Recovery Services vault, backup policy, VM, and backup protection status.

.CONTEXT
AZ-104 Lab - Recover Configuration File from Azure VM Backup (Validation)

.AUTHOR
Greg Tate

.NOTES
Program: test-vm-file-recovery.ps1
#>

[CmdletBinding()]

# Configuration
$ResourceGroupName = 'az104-monitoring-vm-file-recovery-bicep'
$VaultName = 'rsv-file-recovery'
$PolicyName = 'policy-daily-vm'
$VmName = 'vm-file-recovery'

$Main = {
    . $Helpers

    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host " Validation: VM File Recovery Lab" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan

    $results = @()

    # Validate resource group exists with correct tags
    $results += Test-ResourceGroup

    # Validate Recovery Services vault exists
    $results += Test-RecoveryVault

    # Validate backup policy exists with daily schedule
    $results += Test-BackupPolicy

    # Validate VM exists and is running
    $results += Test-VirtualMachine

    # Validate VM backup protection is enabled
    $results += Test-BackupProtection

    Show-ValidationResult -Results $results
}

$Helpers = {
    function Test-ResourceGroup {
        # Verify resource group exists with required tags
        Write-Host "[Test 1] Resource Group..." -NoNewline

        $rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue

        if (-not $rg) {
            Write-Host " FAIL" -ForegroundColor Red
            return @{ Test = 'Resource Group'; Status = 'FAIL'; Detail = 'Not found' }
        }

        # Check for required tags
        $missingTags = @('Environment', 'Project', 'Domain', 'Purpose', 'Owner') |
            Where-Object { -not $rg.Tags.ContainsKey($_) }

        if ($missingTags.Count -gt 0) {
            Write-Host " WARN" -ForegroundColor Yellow
            return @{ Test = 'Resource Group'; Status = 'WARN'; Detail = "Missing tags: $($missingTags -join ', ')" }
        }

        Write-Host " PASS" -ForegroundColor Green
        return @{ Test = 'Resource Group'; Status = 'PASS'; Detail = "Location: $($rg.Location)" }
    }

    function Test-RecoveryVault {
        # Verify Recovery Services vault exists
        Write-Host "[Test 2] Recovery Services Vault..." -NoNewline

        $vault = Get-AzRecoveryServicesVault `
            -ResourceGroupName $ResourceGroupName `
            -Name $VaultName `
            -ErrorAction SilentlyContinue

        if (-not $vault) {
            Write-Host " FAIL" -ForegroundColor Red
            return @{ Test = 'Recovery Vault'; Status = 'FAIL'; Detail = 'Not found' }
        }

        Write-Host " PASS" -ForegroundColor Green
        return @{ Test = 'Recovery Vault'; Status = 'PASS'; Detail = "Name: $($vault.Name), Location: $($vault.Location)" }
    }

    function Test-BackupPolicy {
        # Verify backup policy exists with correct configuration
        Write-Host "[Test 3] Backup Policy..." -NoNewline

        $vault = Get-AzRecoveryServicesVault `
            -ResourceGroupName $ResourceGroupName `
            -Name $VaultName `
            -ErrorAction SilentlyContinue

        if (-not $vault) {
            Write-Host " SKIP" -ForegroundColor Yellow
            return @{ Test = 'Backup Policy'; Status = 'SKIP'; Detail = 'Vault not found' }
        }

        $policy = Get-AzRecoveryServicesBackupProtectionPolicy `
            -Name $PolicyName `
            -VaultId $vault.ID `
            -ErrorAction SilentlyContinue

        if (-not $policy) {
            Write-Host " FAIL" -ForegroundColor Red
            return @{ Test = 'Backup Policy'; Status = 'FAIL'; Detail = "Policy '$PolicyName' not found" }
        }

        Write-Host " PASS" -ForegroundColor Green
        return @{ Test = 'Backup Policy'; Status = 'PASS'; Detail = "Name: $($policy.Name), WorkloadType: $($policy.WorkloadType)" }
    }

    function Test-VirtualMachine {
        # Verify VM exists and is in expected state
        Write-Host "[Test 4] Virtual Machine..." -NoNewline

        $vm = Get-AzVM `
            -ResourceGroupName $ResourceGroupName `
            -Name $VmName `
            -ErrorAction SilentlyContinue

        if (-not $vm) {
            Write-Host " FAIL" -ForegroundColor Red
            return @{ Test = 'Virtual Machine'; Status = 'FAIL'; Detail = 'Not found' }
        }

        # Check VM size
        $vmSize = $vm.HardwareProfile.VmSize

        # Check OS
        $osType = $vm.StorageProfile.OsDisk.OsType

        Write-Host " PASS" -ForegroundColor Green
        return @{ Test = 'Virtual Machine'; Status = 'PASS'; Detail = "Name: $VmName, Size: $vmSize, OS: $osType" }
    }

    function Test-BackupProtection {
        # Verify VM backup protection is enabled
        Write-Host "[Test 5] Backup Protection..." -NoNewline

        $vault = Get-AzRecoveryServicesVault `
            -ResourceGroupName $ResourceGroupName `
            -Name $VaultName `
            -ErrorAction SilentlyContinue

        if (-not $vault) {
            Write-Host " SKIP" -ForegroundColor Yellow
            return @{ Test = 'Backup Protection'; Status = 'SKIP'; Detail = 'Vault not found' }
        }

        $container = Get-AzRecoveryServicesBackupContainer `
            -ContainerType AzureVM `
            -VaultId $vault.ID `
            -ErrorAction SilentlyContinue

        if (-not $container) {
            Write-Host " WARN" -ForegroundColor Yellow
            return @{ Test = 'Backup Protection'; Status = 'WARN'; Detail = 'No backup container registered yet (initial backup may be pending)' }
        }

        $backupItem = Get-AzRecoveryServicesBackupItem `
            -Container $container `
            -WorkloadType AzureVM `
            -VaultId $vault.ID `
            -ErrorAction SilentlyContinue

        if (-not $backupItem) {
            Write-Host " WARN" -ForegroundColor Yellow
            return @{ Test = 'Backup Protection'; Status = 'WARN'; Detail = 'Backup item not yet registered (initial backup may be pending)' }
        }

        Write-Host " PASS" -ForegroundColor Green
        return @{ Test = 'Backup Protection'; Status = 'PASS'; Detail = "Status: $($backupItem.ProtectionStatus)" }
    }

    function Show-ValidationResult {
        # Display summary of all validation results
        param(
            [Parameter(Mandatory)]
            [array]$Results
        )

        Write-Host "`n----------------------------------------"
        Write-Host " Results Summary"
        Write-Host "----------------------------------------"

        foreach ($r in $Results) {
            $color = switch ($r.Status) {
                'PASS' { 'Green' }
                'WARN' { 'Yellow' }
                'FAIL' { 'Red' }
                'SKIP' { 'DarkYellow' }
            }
            Write-Host "  [$($r.Status)] $($r.Test): $($r.Detail)" -ForegroundColor $color
        }

        $passCount = ($Results | Where-Object { $_.Status -eq 'PASS' }).Count
        $totalCount = $Results.Count
        Write-Host "`n  $passCount/$totalCount tests passed.`n"
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
