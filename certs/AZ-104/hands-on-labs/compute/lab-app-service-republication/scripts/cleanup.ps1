# -------------------------------------------------------------------------
# Program: cleanup.ps1
# Description: Remove all lab resources for the App Service republication lab
# Context: AZ-104 Lab - Prepare App Service for Web App Republication
# Author: Greg Tate
# Date: 2026-02-12
# -------------------------------------------------------------------------

<#
.SYNOPSIS
Removes all Azure resources created by the App Service republication lab.

.DESCRIPTION
Deletes the resource group and all contained resources (App Service Plan,
Web App, deployment slot) for the App Service republication lab.

.CONTEXT
AZ-104 Lab - Prepare App Service for Web App Republication (Cleanup)

.AUTHOR
Greg Tate

.NOTES
Program: cleanup.ps1
#>

[CmdletBinding()]

# Configuration
$ResourceGroupName = 'az104-compute-app-svc-republish-ps'

$Main = {
    . $Helpers

    Confirm-AzureConnection
    Confirm-LabSubscription
    Remove-LabResourceGroup
}

$Helpers = {
    function Confirm-AzureConnection {
        # Verify Azure PowerShell connection is active
        Write-Host "`n[Pre-check] Verifying Azure connection..." -ForegroundColor Yellow

        $context = Get-AzContext
        if (-not $context) {
            Write-Error "Not connected to Azure. Run 'Connect-AzAccount' first."
            exit 1
        }

        Write-Host "  Connected as: $($context.Account.Id)`n" -ForegroundColor Green
    }

    function Confirm-LabSubscription {
        # Verify cleanup is targeting the correct lab subscription
        Write-Host "[Pre-check] Verifying lab subscription..." -ForegroundColor Yellow

        $expectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
        $currentSubscription = (Get-AzContext).Subscription.Id

        if ($currentSubscription -ne $expectedSubscriptionId) {
            Write-Error "Not connected to lab subscription. Expected: $expectedSubscriptionId, Current: $currentSubscription"
            exit 1
        }

        Write-Host "  Lab subscription verified: $expectedSubscriptionId`n" -ForegroundColor Green
    }

    function Remove-LabResourceGroup {
        # Delete the resource group and all contained resources
        Write-Host "[Cleanup] Removing resource group '$ResourceGroupName'..." -ForegroundColor Yellow

        # Check if resource group exists before attempting removal
        $rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue

        if (-not $rg) {
            Write-Host "  Resource group '$ResourceGroupName' does not exist. Nothing to clean up.`n" -ForegroundColor DarkYellow
            return
        }

        Remove-AzResourceGroup `
            -Name $ResourceGroupName `
            -Force

        Write-Host "  Resource group '$ResourceGroupName' and all resources removed.`n" -ForegroundColor Green
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
