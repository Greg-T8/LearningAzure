# -------------------------------------------------------------------------
# Program: test-app-service.ps1
# Description: Validate App Service republication lab deployment
# Context: AZ-104 Lab - Prepare App Service for Web App Republication
# Author: Greg Tate
# Date: 2026-02-12
# -------------------------------------------------------------------------

<#
.SYNOPSIS
Validates that the App Service republication lab resources were deployed correctly.

.DESCRIPTION
Checks for the existence and correct configuration of the resource group,
App Service Plan (Standard tier), web app, and staging deployment slot.

.CONTEXT
AZ-104 Lab - Prepare App Service for Web App Republication (Validation)

.AUTHOR
Greg Tate

.NOTES
Program: test-app-service.ps1
#>

[CmdletBinding()]

# Configuration
$ResourceGroupName = 'az104-compute-app-svc-republish-ps'
$AppServicePlanName = 'asp-republish'
$SlotName = 'staging'

$Main = {
    . $Helpers

    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host " Validation: App Service Republication" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan

    $results = @()

    # Validate resource group exists with correct tags
    $results += Test-ResourceGroup

    # Validate App Service Plan exists with Standard tier
    $results += Test-AppServicePlan

    # Validate web app exists in the resource group
    $results += Test-WebApp

    # Validate staging deployment slot exists
    $results += Test-DeploymentSlot

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

    function Test-AppServicePlan {
        # Verify App Service Plan exists with Standard tier (required for slots)
        Write-Host "[Test 2] App Service Plan..." -NoNewline

        $asp = Get-AzAppServicePlan `
            -ResourceGroupName $ResourceGroupName `
            -Name $AppServicePlanName `
            -ErrorAction SilentlyContinue

        if (-not $asp) {
            Write-Host " FAIL" -ForegroundColor Red
            return @{ Test = 'App Service Plan'; Status = 'FAIL'; Detail = 'Not found' }
        }

        # Verify tier supports deployment slots (Standard or higher)
        $tier = $asp.Sku.Tier
        $supportedTiers = @('Standard', 'Premium', 'PremiumV2', 'PremiumV3', 'Isolated', 'IsolatedV2')

        if ($tier -notin $supportedTiers) {
            Write-Host " FAIL" -ForegroundColor Red
            return @{ Test = 'App Service Plan'; Status = 'FAIL'; Detail = "Tier '$tier' does not support deployment slots" }
        }

        Write-Host " PASS" -ForegroundColor Green
        return @{ Test = 'App Service Plan'; Status = 'PASS'; Detail = "Tier: $tier, SKU: $($asp.Sku.Name)" }
    }

    function Test-WebApp {
        # Verify a web app exists in the resource group
        Write-Host "[Test 3] Web App..." -NoNewline

        $webApps = Get-AzWebApp `
            -ResourceGroupName $ResourceGroupName `
            -ErrorAction SilentlyContinue

        if (-not $webApps -or $webApps.Count -eq 0) {
            Write-Host " FAIL" -ForegroundColor Red
            return @{ Test = 'Web App'; Status = 'FAIL'; Detail = 'No web apps found' }
        }

        # Store the web app name for deployment slot check
        $script:WebAppName = $webApps[0].Name
        Write-Host " PASS" -ForegroundColor Green
        return @{ Test = 'Web App'; Status = 'PASS'; Detail = "Name: $($script:WebAppName)" }
    }

    function Test-DeploymentSlot {
        # Verify the staging deployment slot exists on the web app
        Write-Host "[Test 4] Deployment Slot..." -NoNewline

        if (-not $script:WebAppName) {
            Write-Host " SKIP" -ForegroundColor Yellow
            return @{ Test = 'Deployment Slot'; Status = 'SKIP'; Detail = 'Web app not found' }
        }

        $slot = Get-AzWebAppSlot `
            -ResourceGroupName $ResourceGroupName `
            -Name $script:WebAppName `
            -Slot $SlotName `
            -ErrorAction SilentlyContinue

        if (-not $slot) {
            Write-Host " FAIL" -ForegroundColor Red
            return @{ Test = 'Deployment Slot'; Status = 'FAIL'; Detail = "Slot '$SlotName' not found" }
        }

        # Check slot state
        $state = $slot.State

        Write-Host " PASS" -ForegroundColor Green
        return @{ Test = 'Deployment Slot'; Status = 'PASS'; Detail = "Slot: $SlotName, State: $state" }
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
