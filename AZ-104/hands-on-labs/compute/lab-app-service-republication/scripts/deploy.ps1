# -------------------------------------------------------------------------
# Program: deploy.ps1
# Description: Deploy Azure App Service with deployment slot for republication testing
# Context: AZ-104 Lab - Prepare App Service for Web App Republication
# Author: Greg Tate
# Date: 2026-02-12
# -------------------------------------------------------------------------

<#
.SYNOPSIS
Provisions an App Service environment with a deployment slot for web app republication.

.DESCRIPTION
Demonstrates the correct Azure PowerShell command sequence for preparing an App Service
environment with deployment slots. Creates a resource group, App Service Plan (Standard S1),
web app, staging deployment slot, and publishes a sample app to the slot for test user review.

.CONTEXT
AZ-104 Lab - Prepare App Service for Web App Republication (Deployment Slots)

.AUTHOR
Greg Tate

.NOTES
Program: deploy.ps1
#>

[CmdletBinding()]
param(
    [string]$Location = 'eastus'
)

# Configuration
$ResourceGroupName  = 'az104-compute-app-svc-republish-ps'
$AppServicePlanName = 'asp-republish'
$SlotName           = 'staging'
$RandomSuffix       = -join ((97..122) | Get-Random -Count 6 | ForEach-Object { [char]$_ })
$WebAppName         = "app-republish-$RandomSuffix"
$DateCreated        = (Get-Date -Format 'yyyy-MM-dd')

# Required tags per GOVERNANCE.md
$Tags = @{
    Environment      = 'Lab'
    Project          = 'AZ-104'
    Domain           = 'Compute'
    Purpose          = 'App Service Republication with Deployment Slots'
    Owner            = 'Greg Tate'
    DateCreated      = $DateCreated
    DeploymentMethod = 'PowerShell'
}

$Main = {
    . $Helpers

    Show-LabBanner
    Confirm-AzureConnection
    Confirm-LabSubscription

    # Step 1: Create the resource group (exam command: New-AzResourceGroup)
    New-LabResourceGroup

    # Step 2: Create the App Service Plan (exam command: New-AzAppServicePlan)
    New-LabAppServicePlan

    # Prerequisite: Create the web app (not in exam options but required for slots)
    New-LabWebApp

    # Step 3: Create the deployment slot (exam command: New-AzWebAppSlot)
    New-LabDeploymentSlot

    # Step 4: Publish the web app to the slot (exam command: Publish-AzWebApp)
    Publish-LabWebApp

    Show-DeploymentResult
}

$Helpers = {
    function Show-LabBanner {
        # Display lab information header
        Write-Host "`n========================================" -ForegroundColor Cyan
        Write-Host " AZ-104 Lab: App Service Republication" -ForegroundColor Cyan
        Write-Host "========================================`n" -ForegroundColor Cyan
        Write-Host "Resource Group : $ResourceGroupName"
        Write-Host "App Service    : $WebAppName"
        Write-Host "Slot           : $SlotName"
        Write-Host "Location       : $Location`n"
    }

    function Confirm-AzureConnection {
        # Verify Azure PowerShell connection is active
        Write-Host "[Pre-check] Verifying Azure connection..." -ForegroundColor Yellow

        $context = Get-AzContext
        if (-not $context) {
            Write-Error "Not connected to Azure. Run 'Connect-AzAccount' first."
            exit 1
        }

        Write-Host "  Connected as: $($context.Account.Id)" -ForegroundColor Green
        Write-Host "  Subscription: $($context.Subscription.Name)`n" -ForegroundColor Green
    }

    function Confirm-LabSubscription {
        # Verify deployment is targeting the correct lab subscription
        Write-Host "[Pre-check] Verifying lab subscription..." -ForegroundColor Yellow

        $expectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
        $currentSubscription = (Get-AzContext).Subscription.Id

        if ($currentSubscription -ne $expectedSubscriptionId) {
            Write-Error "Not connected to lab subscription. Expected: $expectedSubscriptionId, Current: $currentSubscription"
            exit 1
        }

        Write-Host "  Lab subscription verified: $expectedSubscriptionId`n" -ForegroundColor Green
    }

    function New-LabResourceGroup {
        # Create the resource group to contain all App Service resources
        Write-Host "[Step 1] New-AzResourceGroup" -ForegroundColor Yellow
        Write-Host "  Creating resource group '$ResourceGroupName'..."

        New-AzResourceGroup `
            -Name $ResourceGroupName `
            -Location $Location `
            -Tag $Tags `
            -Force |
            Out-Null

        Write-Host "  Resource group created.`n" -ForegroundColor Green
    }

    function New-LabAppServicePlan {
        # Create the App Service Plan with Standard S1 tier (required for deployment slots)
        Write-Host "[Step 2] New-AzAppServicePlan" -ForegroundColor Yellow
        Write-Host "  Creating App Service Plan '$AppServicePlanName' (Standard S1)..."
        Write-Host "  Note: Standard tier or higher is required for deployment slots." -ForegroundColor DarkYellow

        New-AzAppServicePlan `
            -ResourceGroupName $ResourceGroupName `
            -Name $AppServicePlanName `
            -Location $Location `
            -Tier 'Standard' `
            -WorkerSize 'Small' `
            -NumberofWorkers 1 `
            -Tag $Tags |
            Out-Null

        Write-Host "  App Service Plan created.`n" -ForegroundColor Green
    }

    function New-LabWebApp {
        # Create the web app (prerequisite for deployment slots, not in exam options)
        Write-Host "[Step 2.5] New-AzWebApp (prerequisite)" -ForegroundColor Yellow
        Write-Host "  Creating Web App '$WebAppName'..."
        Write-Host "  Note: A web app must exist before creating a deployment slot." -ForegroundColor DarkYellow

        New-AzWebApp `
            -ResourceGroupName $ResourceGroupName `
            -Name $WebAppName `
            -Location $Location `
            -AppServicePlan $AppServicePlanName `
            -Tag $Tags |
            Out-Null

        Write-Host "  Web App created.`n" -ForegroundColor Green
    }

    function New-LabDeploymentSlot {
        # Create the staging deployment slot for test user review
        Write-Host "[Step 3] New-AzWebAppSlot" -ForegroundColor Yellow
        Write-Host "  Creating deployment slot '$SlotName' on '$WebAppName'..."

        New-AzWebAppSlot `
            -ResourceGroupName $ResourceGroupName `
            -Name $WebAppName `
            -Slot $SlotName |
            Out-Null

        Write-Host "  Deployment slot created.`n" -ForegroundColor Green
    }

    function Publish-LabWebApp {
        # Publish the sample web app to the staging deployment slot
        Write-Host "[Step 4] Publish-AzWebApp" -ForegroundColor Yellow
        Write-Host "  Publishing web app to slot '$SlotName'..."

        # Create a temporary zip archive from the sample app
        $appPath = Join-Path -Path $PSScriptRoot -ChildPath 'app'
        $zipPath = Join-Path -Path $env:TEMP -ChildPath "app-republish-$RandomSuffix.zip"

        # Compress the sample app into a zip for deployment
        if (Test-Path $zipPath) {
            Remove-Item -Path $zipPath -Force
        }

        Compress-Archive `
            -Path "$appPath\*" `
            -DestinationPath $zipPath `
            -Force

        # Publish to the staging slot using zip deployment
        Publish-AzWebApp `
            -ResourceGroupName $ResourceGroupName `
            -Name $WebAppName `
            -Slot $SlotName `
            -ArchivePath $zipPath `
            -Force |
            Out-Null

        # Clean up the temporary zip file
        Remove-Item -Path $zipPath -Force -ErrorAction SilentlyContinue

        Write-Host "  Web app published to staging slot.`n" -ForegroundColor Green
    }

    function Show-DeploymentResult {
        # Display deployment summary with URLs for testing
        $productionUrl = "https://$WebAppName.azurewebsites.net"
        $stagingUrl = "https://$WebAppName-$SlotName.azurewebsites.net"

        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host " Deployment Complete" -ForegroundColor Cyan
        Write-Host "========================================`n" -ForegroundColor Cyan
        Write-Host "Production URL : $productionUrl"
        Write-Host "Staging URL    : $stagingUrl"
        Write-Host "Resource Group : $ResourceGroupName"
        Write-Host "Web App        : $WebAppName"
        Write-Host "Slot           : $SlotName`n"
        Write-Host "Test users can review the app at the Staging URL above." -ForegroundColor Yellow
        Write-Host "When ready, swap slots with:" -ForegroundColor Yellow
        Write-Host "  Switch-AzWebAppSlot -ResourceGroupName '$ResourceGroupName' -Name '$WebAppName' -SourceSlotName '$SlotName' -DestinationSlotName 'production'`n"
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
