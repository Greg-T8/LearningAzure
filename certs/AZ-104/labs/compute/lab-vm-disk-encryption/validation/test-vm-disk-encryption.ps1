# -------------------------------------------------------------------------
# Program: test-vm-disk-encryption.ps1
# Description: Validate VM disk encryption lab resources and test ADE
# Context: AZ-104 Lab - VM Disk Encryption with Key Vault
# Author: Greg Tate
# Date: 2026-02-22
# -------------------------------------------------------------------------

<#
.SYNOPSIS
Validates the VM disk encryption lab deployment and optionally encrypts the VM disk.

.DESCRIPTION
Verifies that the Key Vault and VM are deployed correctly, retrieves Key Vault
properties (VaultUri, ResourceId) as tested in the exam, and optionally runs
Set-AzVMDiskEncryptionExtension to encrypt the VM disk.

.CONTEXT
AZ-104 Lab - VM Disk Encryption with Key Vault

.AUTHOR
Greg Tate

.NOTES
Program: test-vm-disk-encryption.ps1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupName = "az104-compute-vm-disk-encryption-tf",

    [Parameter(Mandatory = $false)]
    [switch]$EncryptDisk
)

# Expected subscription ID for lab environment
$ExpectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'

$Main = {
    . $Helpers

    Confirm-LabSubscription
    Test-KeyVaultConfiguration
    Show-ExamProperties
    Test-VMConfiguration

    # Encrypt the VM disk if requested
    if ($EncryptDisk) {
        Invoke-DiskEncryption
        Test-EncryptionStatus
    } else {
        Write-Host "`n  To encrypt the disk, re-run with -EncryptDisk switch:" -ForegroundColor Yellow
        Write-Host "    .\test-vm-disk-encryption.ps1 -EncryptDisk" -ForegroundColor White
    }

    Write-Host "`n=== Validation Complete ===" -ForegroundColor Cyan
}

$Helpers = {
    function Confirm-LabSubscription {
        # Validate that the current context is the lab subscription
        Write-Host "`n=== Subscription Validation ===" -ForegroundColor Cyan
        $currentSubscription = (Get-AzContext).Subscription.Id

        if ($currentSubscription -ne $ExpectedSubscriptionId) {
            Write-Error "Not connected to lab subscription. Run: Use-AzProfile Lab"
            exit 1
        }

        Write-Host "  Subscription: $currentSubscription" -ForegroundColor Green
    }

    function Test-KeyVaultConfiguration {
        # Verify Key Vault exists and is enabled for disk encryption
        Write-Host "`n=== Key Vault Configuration ===" -ForegroundColor Cyan

        $script:keyVaults = Get-AzKeyVault -ResourceGroupName $ResourceGroupName
        if (-not $script:keyVaults) {
            Write-Error "No Key Vault found in $ResourceGroupName. Deploy the lab first."
            exit 1
        }

        $script:kv = Get-AzKeyVault -VaultName $script:keyVaults[0].VaultName -ResourceGroupName $ResourceGroupName
        Write-Host "  Key Vault Name: $($script:kv.VaultName)" -ForegroundColor Green
        Write-Host "  Enabled for Disk Encryption: $($script:kv.EnabledForDiskEncryption)" -ForegroundColor Green

        if (-not $script:kv.EnabledForDiskEncryption) {
            Write-Host "  WARNING: Key Vault is NOT enabled for disk encryption" -ForegroundColor Red
        }
    }

    function Show-ExamProperties {
        # Display the Key Vault properties tested in exam blanks [2] and [3]
        Write-Host "`n=== Exam Scenario Properties ===" -ForegroundColor Cyan
        Write-Host "  These are the properties tested in the exam question:" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  Blank [2] - DiskEncryptionKeyVaultUrl:" -ForegroundColor White
        Write-Host "    `$keyVault.VaultUri  = $($script:kv.VaultUri)" -ForegroundColor Green
        Write-Host ""
        Write-Host "  Blank [3] - DiskEncryptionKeyVaultId:" -ForegroundColor White
        Write-Host "    `$keyVault.ResourceId = $($script:kv.ResourceId)" -ForegroundColor Green
    }

    function Test-VMConfiguration {
        # Verify the Windows VM exists in the resource group
        Write-Host "`n=== VM Configuration ===" -ForegroundColor Cyan

        $script:vm = Get-AzVM -ResourceGroupName $ResourceGroupName
        if (-not $script:vm) {
            Write-Error "No VM found in $ResourceGroupName. Deploy the lab first."
            exit 1
        }

        Write-Host "  VM Name: $($script:vm[0].Name)" -ForegroundColor Green
        Write-Host "  VM Size: $($script:vm[0].HardwareProfile.VmSize)" -ForegroundColor Green
        Write-Host "  OS Type: $($script:vm[0].StorageProfile.OsDisk.OsType)" -ForegroundColor Green

        # Check current encryption status
        $encStatus = Get-AzVMDiskEncryptionStatus `
            -ResourceGroupName $ResourceGroupName `
            -VMName $script:vm[0].Name

        Write-Host "  OS Disk Encrypted: $($encStatus.OsVolumeEncrypted)" -ForegroundColor Green
        Write-Host "  Data Disks Encrypted: $($encStatus.DataVolumesEncrypted)" -ForegroundColor Green
    }

    function Invoke-DiskEncryption {
        # Run the Set-AzVMDiskEncryptionExtension command from the exam scenario
        Write-Host "`n=== Encrypting VM Disk ===" -ForegroundColor Cyan
        Write-Host "  Running Set-AzVMDiskEncryptionExtension..." -ForegroundColor Yellow

        $vmName = $script:vm[0].Name

        # This mirrors the completed exam script
        Set-AzVMDiskEncryptionExtension `
            -ResourceGroupName $ResourceGroupName `
            -DiskEncryptionKeyVaultUrl $script:kv.VaultUri `
            -DiskEncryptionKeyVaultId $script:kv.ResourceId `
            -VMName $vmName `
            -VolumeType "All" `
            -Force

        Write-Host "  Disk encryption initiated successfully" -ForegroundColor Green
    }

    function Test-EncryptionStatus {
        # Verify disk encryption status after applying ADE
        Write-Host "`n=== Encryption Status ===" -ForegroundColor Cyan

        $vmName = $script:vm[0].Name
        $status = Get-AzVMDiskEncryptionStatus `
            -ResourceGroupName $ResourceGroupName `
            -VMName $vmName

        Write-Host "  OS Volume Encrypted: $($status.OsVolumeEncrypted)" -ForegroundColor Green
        Write-Host "  Data Volumes Encrypted: $($status.DataVolumesEncrypted)" -ForegroundColor Green
        Write-Host "  OS Volume Encryption Settings: $($status.OsVolumeEncryptionSettings)" -ForegroundColor Green

        if ($status.OsVolumeEncrypted -eq "Encrypted") {
            Write-Host "`n  Disk encryption verified successfully!" -ForegroundColor Green
        } else {
            Write-Host "`n  Encryption may still be in progress. Re-check in a few minutes:" -ForegroundColor Yellow
            Write-Host "    Get-AzVMDiskEncryptionStatus -ResourceGroupName $ResourceGroupName -VMName $vmName" -ForegroundColor White
        }
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
