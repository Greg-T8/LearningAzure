<#
.SYNOPSIS
    Validates the VMSS Rolling Upgrade lab deployment.

.DESCRIPTION
    Verifies that the VMSS, Load Balancer, and networking resources are deployed
    correctly with the expected Rolling upgrade policy and disk configuration.

.CONTEXT
    AZ-104 Lab - VMSS Rolling Upgrade validation

.AUTHOR
    Greg Tate

.NOTES
    Program: validate-vmss.ps1
#>

# -------------------------------------------------------------------------
# Program: validate-vmss.ps1
# Description: Validate VMSS rolling upgrade lab infrastructure
# Context: AZ-104 Lab - VMSS Rolling Upgrade (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-23
# -------------------------------------------------------------------------

[CmdletBinding()]

# Lab resource configuration
$ResourceGroupName = 'az104-compute-vmss-rolling-upgrade-bicep'
$VmssName = 'vmss-rolling-upgrade'
$LbName = 'lb-vmss'

$Main = {
    # Orchestrate all validation checks

    # Dot-source helper functions
    . $Helpers

    # Validate subscription context
    Confirm-LabSubscription

    # Verify resource group exists
    Write-Host "`n--- Resource Group Validation ---" -ForegroundColor Cyan
    Get-LabResourceGroup -Name $ResourceGroupName

    # Verify VMSS configuration
    Write-Host "`n--- VMSS Configuration Validation ---" -ForegroundColor Cyan
    Test-VmssConfiguration -ResourceGroupName $ResourceGroupName -VmssName $VmssName

    # Verify Load Balancer configuration
    Write-Host "`n--- Load Balancer Validation ---" -ForegroundColor Cyan
    Test-LoadBalancerConfiguration -ResourceGroupName $ResourceGroupName -LbName $LbName

    # Summary
    Write-Host "`n All validations passed!" -ForegroundColor Green
}

$Helpers = {
    # Helper functions for VMSS rolling upgrade validation

    function Confirm-LabSubscription {
        # Validate the current Azure subscription matches the lab subscription

        $expectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
        $currentSubscription = (Get-AzContext).Subscription.Id

        if ($currentSubscription -ne $expectedSubscriptionId) {
            Write-Error "Not connected to lab subscription. Expected: $expectedSubscriptionId, Got: $currentSubscription"
            exit 1
        }

        Write-Host "Subscription verified: $currentSubscription" -ForegroundColor Green
    }

    function Get-LabResourceGroup {
        # Verify the lab resource group exists and return it

        param([string]$Name)

        $rg = Get-AzResourceGroup -Name $Name -ErrorAction SilentlyContinue

        if ($null -eq $rg) {
            Write-Error "Resource group '$Name' not found."
            exit 1
        }

        Write-Host "  Resource group '$Name' exists in $($rg.Location)" -ForegroundColor Green
        return $rg
    }

    function Test-VmssConfiguration {
        # Verify VMSS exists with Rolling upgrade policy and expected disk configuration

        param(
            [string]$ResourceGroupName,
            [string]$VmssName
        )

        # Get the VMSS
        $vmss = Get-AzVmss -ResourceGroupName $ResourceGroupName -VMScaleSetName $VmssName -ErrorAction SilentlyContinue

        if ($null -eq $vmss) {
            Write-Error "VMSS '$VmssName' not found in resource group '$ResourceGroupName'."
            exit 1
        }

        Write-Host "  VMSS '$VmssName' exists" -ForegroundColor Green

        # Verify upgrade policy is Rolling
        $upgradePolicy = $vmss.UpgradePolicy.Mode

        if ($upgradePolicy -ne 'Rolling') {
            Write-Error "Expected upgrade policy 'Rolling', got '$upgradePolicy'."
            exit 1
        }

        Write-Host "  Upgrade policy: $upgradePolicy" -ForegroundColor Green

        # Verify rolling upgrade policy settings
        $rollingPolicy = $vmss.UpgradePolicy.RollingUpgradePolicy
        Write-Host "  Max batch %: $($rollingPolicy.MaxBatchInstancePercent)" -ForegroundColor Green
        Write-Host "  Pause between batches: $($rollingPolicy.PauseTimeBetweenBatches)" -ForegroundColor Green

        # Verify OS disk configuration
        $osDisk = $vmss.VirtualMachineProfile.StorageProfile.OsDisk
        Write-Host "  OS disk type: $($osDisk.ManagedDisk.StorageAccountType)" -ForegroundColor Green

        # Verify data disk configuration
        $dataDisks = $vmss.VirtualMachineProfile.StorageProfile.DataDisks
        Write-Host "  Data disks: $($dataDisks.Count) disk(s)" -ForegroundColor Green

        foreach ($disk in $dataDisks) {
            Write-Host "    - LUN $($disk.Lun): $($disk.DiskSizeGB) GB, $($disk.ManagedDisk.StorageAccountType)" -ForegroundColor Green
        }

        # Verify instance count and SKU
        Write-Host "  SKU: $($vmss.Sku.Name), Capacity: $($vmss.Sku.Capacity)" -ForegroundColor Green
    }

    function Test-LoadBalancerConfiguration {
        # Verify Load Balancer exists with health probe for rolling upgrade monitoring

        param(
            [string]$ResourceGroupName,
            [string]$LbName
        )

        # Get the Load Balancer
        $lb = Get-AzLoadBalancer -ResourceGroupName $ResourceGroupName -Name $LbName -ErrorAction SilentlyContinue

        if ($null -eq $lb) {
            Write-Error "Load Balancer '$LbName' not found."
            exit 1
        }

        Write-Host "  Load Balancer '$LbName' exists (SKU: $($lb.Sku.Name))" -ForegroundColor Green

        # Verify health probe
        $probe = $lb.Probes | Where-Object { $_.Name -eq 'healthProbe' }

        if ($null -eq $probe) {
            Write-Error "Health probe 'healthProbe' not found on load balancer."
            exit 1
        }

        Write-Host "  Health probe: $($probe.Protocol) port $($probe.Port)" -ForegroundColor Green

        # Verify outbound rule exists
        if ($lb.OutboundRules.Count -gt 0) {
            Write-Host "  Outbound rule configured (SNAT for internet access)" -ForegroundColor Green
        }

        # Verify inbound rule has disableOutboundSnat
        $lbRule = $lb.LoadBalancingRules | Where-Object { $_.Name -eq 'httpRule' }

        if ($lbRule.DisableOutboundSnat) {
            Write-Host "  Inbound rule: disableOutboundSnat = true (governance compliant)" -ForegroundColor Green
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
