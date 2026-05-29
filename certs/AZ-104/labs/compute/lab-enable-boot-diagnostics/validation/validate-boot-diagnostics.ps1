<#
.SYNOPSIS
Validates the Enable Boot Diagnostics lab deployment.

.DESCRIPTION
Checks that both lab VMs and storage accounts exist with the expected
regional placement and SKU characteristics required by the exam scenario.

.CONTEXT
AZ-104 Lab - Enable Boot Diagnostics for Azure VMs

.AUTHOR
Greg Tate

.NOTES
Program: validate-boot-diagnostics.ps1
#>

# -------------------------------------------------------------------------
# Program: validate-boot-diagnostics.ps1
# Description: Validate resources and constraints for boot diagnostics lab
# Context: AZ-104 Lab - Enable Boot Diagnostics for Azure VMs (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-28
# -------------------------------------------------------------------------

[CmdletBinding()]
param()

# Define static names used by this lab deployment.
$ResourceGroupName = 'az104-compute-enable-boot-diagnostics-bicep'
$Vm1Name = 'vm-boot-1'
$Vm2Name = 'vm-boot-2'
$Storage1Name = 'staz104boot1'
$Storage2Name = 'staz104boot2'
$Storage3Name = 'staz104boot3'
$ConfirmSubscriptionScript = Join-Path -Path $PSScriptRoot -ChildPath '..\..\..\..\..\.\.github\skills\lab-azure-governance\scripts\Confirm-LabSubscription.ps1'

$Main = {
    # Load helper functions for validation tasks.
    . $Helpers

    # Validate the active subscription context before checking resources.
    Confirm-LabContext

    # Validate that the resource group exists.
    Confirm-ResourceGroup -Name $ResourceGroupName

    # Validate storage account placement and SKU constraints.
    Confirm-StorageAccount -ResourceGroupName $ResourceGroupName -StorageAccountName $Storage1Name -ExpectedLocation 'centralus' -ExpectedSku 'Premium_LRS' -ExpectedKind 'StorageV2'
    Confirm-StorageAccount -ResourceGroupName $ResourceGroupName -StorageAccountName $Storage2Name -ExpectedLocation 'eastus' -ExpectedSku 'Standard_LRS' -ExpectedKind 'Storage'
    Confirm-StorageAccount -ResourceGroupName $ResourceGroupName -StorageAccountName $Storage3Name -ExpectedLocation 'centralus' -ExpectedSku 'Standard_GRS' -ExpectedKind 'StorageV2'

    # Validate VM placement and verify boot diagnostics starts disabled.
    Confirm-VirtualMachine -ResourceGroupName $ResourceGroupName -VmName $Vm1Name -ExpectedLocation 'centralus'
    Confirm-VirtualMachine -ResourceGroupName $ResourceGroupName -VmName $Vm2Name -ExpectedLocation 'eastus'

    # Emit success summary when all checks pass.
    Write-Host "All boot diagnostics lab validation checks passed." -ForegroundColor Green
}

$Helpers = {
    function Confirm-LabContext {
        # Execute the shared subscription guardrail script.

        if (-not (Test-Path -Path $ConfirmSubscriptionScript)) {
            throw "Subscription validation script not found: $ConfirmSubscriptionScript"
        }

        & $ConfirmSubscriptionScript

        if ($LASTEXITCODE -ne 0) {
            throw 'Subscription validation failed.'
        }
    }

    function Confirm-ResourceGroup {
        # Ensure the target resource group exists before deeper checks.

        param(
            [Parameter(Mandatory)]
            [string]$Name
        )

        $resourceGroup = Get-AzResourceGroup -Name $Name -ErrorAction SilentlyContinue

        if ($null -eq $resourceGroup) {
            throw "Resource group '$Name' was not found."
        }

        Write-Host "Resource group found: $($resourceGroup.ResourceGroupName)" -ForegroundColor Green
    }

    function Confirm-StorageAccount {
        # Validate storage account location and SKU required by the scenario.

        param(
            [Parameter(Mandatory)]
            [string]$ResourceGroupName,

            [Parameter(Mandatory)]
            [string]$StorageAccountName,

            [Parameter(Mandatory)]
            [string]$ExpectedLocation,

            [Parameter(Mandatory)]
            [string]$ExpectedSku,

            [Parameter(Mandatory)]
            [string]$ExpectedKind
        )

        $account = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -ErrorAction SilentlyContinue

        if ($null -eq $account) {
            throw "Storage account '$StorageAccountName' was not found."
        }

        if ($account.PrimaryLocation -ne $ExpectedLocation) {
            throw "Storage account '$StorageAccountName' location mismatch. Expected '$ExpectedLocation', found '$($account.PrimaryLocation)'."
        }

        if ($account.Sku.Name -ne $ExpectedSku) {
            throw "Storage account '$StorageAccountName' SKU mismatch. Expected '$ExpectedSku', found '$($account.Sku.Name)'."
        }

        if ($account.Kind -ne $ExpectedKind) {
            throw "Storage account '$StorageAccountName' kind mismatch. Expected '$ExpectedKind', found '$($account.Kind)'."
        }

        Write-Host "Storage account validated: $StorageAccountName ($ExpectedKind, $ExpectedSku, $ExpectedLocation)" -ForegroundColor Green
    }

    function Confirm-VirtualMachine {
        # Validate VM location and initial boot diagnostics state.

        param(
            [Parameter(Mandatory)]
            [string]$ResourceGroupName,

            [Parameter(Mandatory)]
            [string]$VmName,

            [Parameter(Mandatory)]
            [string]$ExpectedLocation
        )

        $vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VmName -ErrorAction SilentlyContinue

        if ($null -eq $vm) {
            throw "Virtual machine '$VmName' was not found."
        }

        if ($vm.Location -ne $ExpectedLocation) {
            throw "VM '$VmName' location mismatch. Expected '$ExpectedLocation', found '$($vm.Location)'."
        }

        $bootDiagnosticsEnabled = $false

        if ($null -ne $vm.DiagnosticsProfile -and $null -ne $vm.DiagnosticsProfile.BootDiagnostics) {
            $bootDiagnosticsEnabled = [bool]$vm.DiagnosticsProfile.BootDiagnostics.Enabled
        }

        if ($bootDiagnosticsEnabled) {
            throw "VM '$VmName' boot diagnostics is expected to be disabled immediately after deployment."
        }

        Write-Host "VM validated: $VmName ($ExpectedLocation, boot diagnostics disabled)" -ForegroundColor Green
    }
}

try {
    # Execute validation from this script directory.
    Push-Location -Path $PSScriptRoot

    # Run validation orchestration.
    & $Main
}
finally {
    # Restore caller location.
    Pop-Location
}
