<#
.SYNOPSIS
Purge soft-deleted Azure resources across supported deployment types.

.DESCRIPTION
Removes soft-deleted Cognitive Services, Key Vault, API Management, and Recovery Services vault resources.

.CONTEXT
Lab utility - Works with Terraform, Bicep, Azure CLI deployments

.AUTHOR
Greg Tate

.NOTES
Program: Purge-SoftDeletedResources.ps1
Date: 2026-02-13
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,

    [Parameter(Mandatory = $false)]
    [ValidateSet('CognitiveServices', 'KeyVault', 'ApiManagement', 'RecoveryVault', 'All')]
    [string[]]$ResourceTypes = @('All'),

    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupFilter
)

#region MAIN
# High-level orchestration for purge operations.
$Main = {
    . $Helpers

    Set-AzureSubscriptionContext
    Show-PurgeContext
    Invoke-SelectedDeletedResourcePurge
    Write-Host "`n✅ Purge operation completed.`n" -ForegroundColor Green
}
#endregion

#region HELPERS
# Helper functions for subscription setup, filtering, and purge execution.
$Helpers = {
    function Set-AzureSubscriptionContext {
        # Set and validate the Azure subscription context for all subsequent commands.
        Write-Host '🔄 Setting subscription context...' -ForegroundColor Cyan
        az account set --subscription $SubscriptionId

        # Stop execution when subscription context cannot be established.
        if ($LASTEXITCODE -ne 0) {
            Write-Host '❌ Failed to set subscription context. Please check your subscription ID and Azure CLI login.' -ForegroundColor Red
            exit 1
        }

        $subscriptionName = az account show --query name -o tsv
        Write-Host "✅ Using subscription: $subscriptionName ($SubscriptionId)" -ForegroundColor Green
    }

    function Show-PurgeContext {
        # Display the purge scope before resource processing begins.
        Write-Host "`n🚀 Purging soft-deleted resources in subscription: $SubscriptionId" -ForegroundColor Cyan

        # Show resource group filtering details when a filter is provided.
        if (-not [string]::IsNullOrEmpty($ResourceGroupFilter)) {
            Write-Host "📋 Filtering by resource group pattern: $ResourceGroupFilter" -ForegroundColor Cyan
        }
    }

    function Clear-DeletedCognitiveService {
        # Purge soft-deleted Cognitive Services accounts.
        Write-Host "`n🧹 Purging Cognitive Services accounts..." -ForegroundColor Cyan
        $deletedAccounts = az cognitiveservices account list-deleted --query "[].{name:name, location:location, resourceGroup:resourceGroup}" -o json | ConvertFrom-Json

        # Exit early when no deleted accounts exist.
        if ($null -eq $deletedAccounts -or $deletedAccounts.Count -eq 0) {
            Write-Host '   No soft-deleted Cognitive Services accounts found.' -ForegroundColor Gray
            return
        }

        # Apply optional resource-group filtering to deleted accounts.
        if (-not [string]::IsNullOrEmpty($ResourceGroupFilter)) {
            $deletedAccounts = $deletedAccounts |
                Where-Object { $_.resourceGroup -like $ResourceGroupFilter }

            # Exit when filter removes all candidate accounts.
            if ($deletedAccounts.Count -eq 0) {
                Write-Host "   No soft-deleted Cognitive Services accounts match filter: $ResourceGroupFilter" -ForegroundColor Gray
                return
            }
        }

        Write-Host "   Found $($deletedAccounts.Count) soft-deleted account(s)" -ForegroundColor Yellow

        # Purge each deleted account and report the result.
        foreach ($account in $deletedAccounts) {
            Write-Host "   Purging: $($account.name) (RG: $($account.resourceGroup), Location: $($account.location))" -ForegroundColor Yellow
            az cognitiveservices account purge --name $account.name --resource-group $account.resourceGroup --location $account.location 2>$null

            # Report purge success or warning for the current account.
            if ($LASTEXITCODE -eq 0) {
                Write-Host "   ✅ Purged: $($account.name)" -ForegroundColor Green
            }
            else {
                Write-Host "   ⚠️  Could not purge: $($account.name)" -ForegroundColor Yellow
            }
        }
    }

    function Clear-DeletedKeyVault {
        # Purge soft-deleted Key Vault resources.
        Write-Host "`n🧹 Purging Key Vaults..." -ForegroundColor Cyan
        $deletedVaults = az keyvault list-deleted --query "[].{name:name, location:location, properties:properties}" -o json | ConvertFrom-Json

        # Exit early when no deleted vaults exist.
        if ($null -eq $deletedVaults -or $deletedVaults.Count -eq 0) {
            Write-Host '   No soft-deleted Key Vaults found.' -ForegroundColor Gray
            return
        }

        # Apply optional resource-group filtering using the vault resource ID.
        if (-not [string]::IsNullOrEmpty($ResourceGroupFilter)) {
            $deletedVaults = $deletedVaults |
                Where-Object {
                    $_.properties.vaultId -match '/resourceGroups/([^/]+)/' -and $Matches[1] -like $ResourceGroupFilter
                }

            # Exit when filter removes all candidate vaults.
            if ($deletedVaults.Count -eq 0) {
                Write-Host "   No soft-deleted Key Vaults match filter: $ResourceGroupFilter" -ForegroundColor Gray
                return
            }
        }

        Write-Host "   Found $($deletedVaults.Count) soft-deleted vault(s)" -ForegroundColor Yellow

        # Purge each deleted vault and report the result.
        foreach ($vault in $deletedVaults) {
            Write-Host "   Purging: $($vault.name) (Location: $($vault.location))" -ForegroundColor Yellow
            az keyvault purge --name $vault.name 2>$null

            # Report purge success or warning for the current vault.
            if ($LASTEXITCODE -eq 0) {
                Write-Host "   ✅ Purged: $($vault.name)" -ForegroundColor Green
            }
            else {
                Write-Host "   ⚠️  Could not purge: $($vault.name)" -ForegroundColor Yellow
            }
        }
    }

    function Clear-DeletedApiManagementService {
        # Purge soft-deleted API Management services.
        Write-Host "`n🧹 Purging API Management services..." -ForegroundColor Cyan
        $deletedApiManagementServices = az apim deletedservice list --query "[].{name:name, location:location, serviceId:serviceId}" -o json | ConvertFrom-Json

        # Exit early when no deleted API Management services exist.
        if ($null -eq $deletedApiManagementServices -or $deletedApiManagementServices.Count -eq 0) {
            Write-Host '   No soft-deleted API Management services found.' -ForegroundColor Gray
            return
        }

        # Apply optional resource-group filtering using the service resource ID.
        if (-not [string]::IsNullOrEmpty($ResourceGroupFilter)) {
            $deletedApiManagementServices = $deletedApiManagementServices |
                Where-Object {
                    $_.serviceId -match '/resourceGroups/([^/]+)/' -and $Matches[1] -like $ResourceGroupFilter
                }

            # Exit when filter removes all candidate API Management services.
            if ($deletedApiManagementServices.Count -eq 0) {
                Write-Host "   No soft-deleted API Management services match filter: $ResourceGroupFilter" -ForegroundColor Gray
                return
            }
        }

        Write-Host "   Found $($deletedApiManagementServices.Count) soft-deleted service(s)" -ForegroundColor Yellow

        # Purge each deleted API Management service and report the result.
        foreach ($apiManagementService in $deletedApiManagementServices) {
            Write-Host "   Purging: $($apiManagementService.name) (Location: $($apiManagementService.location))" -ForegroundColor Yellow
            az apim deletedservice purge --service-name $apiManagementService.name --location $apiManagementService.location 2>$null

            # Report purge success or warning for the current API Management service.
            if ($LASTEXITCODE -eq 0) {
                Write-Host "   ✅ Purged: $($apiManagementService.name)" -ForegroundColor Green
            }
            else {
                Write-Host "   ⚠️  Could not purge: $($apiManagementService.name)" -ForegroundColor Yellow
            }
        }
    }

    function Clear-DeletedRecoveryVault {
        # Purge soft-deleted Recovery Services vault resources.
        Write-Host "`n🧹 Purging Recovery Services vaults..." -ForegroundColor Cyan
        $deletedRecoveryVaults = az resource list --resource-type 'Microsoft.RecoveryServices/locations/deletedVaults' --query "[].{id:id, name:name, location:location, vaultId:properties.vaultId}" -o json | ConvertFrom-Json

        # Exit early when no deleted Recovery Services vault resources exist.
        if ($null -eq $deletedRecoveryVaults -or $deletedRecoveryVaults.Count -eq 0) {
            Write-Host '   No soft-deleted Recovery Services vaults found.' -ForegroundColor Gray
            return
        }

        # Apply optional resource-group filtering using the original vault resource ID.
        if (-not [string]::IsNullOrEmpty($ResourceGroupFilter)) {
            $deletedRecoveryVaults = $deletedRecoveryVaults |
                Where-Object {
                    $_.vaultId -match '/resourceGroups/([^/]+)/' -and $Matches[1] -like $ResourceGroupFilter
                }

            # Exit when filter removes all candidate Recovery Services vaults.
            if ($deletedRecoveryVaults.Count -eq 0) {
                Write-Host "   No soft-deleted Recovery Services vaults match filter: $ResourceGroupFilter" -ForegroundColor Gray
                return
            }
        }

        Write-Host "   Found $($deletedRecoveryVaults.Count) soft-deleted vault(s)" -ForegroundColor Yellow

        # Purge each deleted Recovery Services vault and report the result.
        foreach ($vault in $deletedRecoveryVaults) {
            Write-Host "   Purging: $($vault.name) (Location: $($vault.location))" -ForegroundColor Yellow
            az resource delete --ids $vault.id 2>$null

            # Report purge success or warning for the current Recovery Services vault.
            if ($LASTEXITCODE -eq 0) {
                Write-Host "   ✅ Purged: $($vault.name)" -ForegroundColor Green
            }
            else {
                Write-Host "   ⚠️  Could not purge: $($vault.name)" -ForegroundColor Yellow
            }
        }
    }

    function Invoke-SelectedDeletedResourcePurge {
        # Execute purge actions for all or selected resource types.
        if ($ResourceTypes -contains 'All') {
            Clear-DeletedCognitiveService
            Clear-DeletedKeyVault
            Clear-DeletedApiManagementService
            Clear-DeletedRecoveryVault
            return
        }

        # Execute only the requested resource-type purge handlers.
        if ($ResourceTypes -contains 'CognitiveServices') {
            Clear-DeletedCognitiveService
        }

        if ($ResourceTypes -contains 'KeyVault') {
            Clear-DeletedKeyVault
        }

        if ($ResourceTypes -contains 'ApiManagement') {
            Clear-DeletedApiManagementService
        }

        if ($ResourceTypes -contains 'RecoveryVault') {
            Clear-DeletedRecoveryVault
        }
    }
}
#endregion

#region EXECUTION
# Execute from script root and always restore original location.
try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
#endregion
