<#
.SYNOPSIS
Validates deployed resources for the blob storage lifecycle lab.

.DESCRIPTION
Confirms the lab subscription, storage account, container, and lifecycle
management policy configuration for AZ-104 lifecycle management validation.

.CONTEXT
AZ-104 Storage Lab - Configure Blob Storage Lifecycle Management.

.AUTHOR
Greg Tate

.NOTES
Program: Confirm-BlobStorageLifecycle.ps1
#>

# -------------------------------------------------------------------------
# Program: Confirm-BlobStorageLifecycle.ps1
# Description: Validates storage lifecycle resources and policy settings
# Context: AZ-104 Lab - Configure Blob Storage Lifecycle Management
# Author: Greg Tate
# Date: 2026-03-02
# -------------------------------------------------------------------------

[CmdletBinding()]
param()

$Main = {
    . $Helpers

    Confirm-Subscription
    Confirm-StorageResources
    Confirm-LifecyclePolicy

    Write-Host "Blob storage lifecycle validation passed." -ForegroundColor Green
}

$Helpers = {
    function Confirm-Subscription {
        # Run the shared subscription guardrail script for the lab subscription.
        $subscriptionScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "../../../../../.github/skills/azure-lab-governance/scripts/Confirm-LabSubscription.ps1"

        if (-not (Test-Path -Path $subscriptionScriptPath)) {
            throw "Confirm-LabSubscription script was not found at '$subscriptionScriptPath'."
        }

        & $subscriptionScriptPath
    }

    function Confirm-StorageResources {
        # Confirm that the resource group, storage account, and container are present.
        $resourceGroupName = "az104-storage-blob-storage-lifecycle-tf"
        $storageAccountName = "staz104bloblifecycle"
        $containerName = "container2"

        $resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
        if (-not $resourceGroup) {
            throw "Resource group '$resourceGroupName' was not found."
        }

        $storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -ErrorAction SilentlyContinue
        if (-not $storageAccount) {
            throw "Storage account '$storageAccountName' was not found in '$resourceGroupName'."
        }

        $container = Get-AzStorageContainer -Name $containerName -Context $storageAccount.Context -ErrorAction SilentlyContinue
        if (-not $container) {
            throw "Container '$containerName' was not found in '$storageAccountName'."
        }

        if (-not $storageAccount.EnableBlobVersioning) {
            throw "Blob versioning is not enabled on '$storageAccountName'."
        }
    }

    function Confirm-LifecyclePolicy {
        # Validate key lifecycle policy values required by the exam scenario.
        $resourceGroupName = "az104-storage-blob-storage-lifecycle-tf"
        $storageAccountName = "staz104bloblifecycle"

        $policy = Get-AzStorageAccountManagementPolicy -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName
        $rule = $policy.Rules | Where-Object Name -eq "myrule"

        if (-not $rule) {
            throw "Lifecycle rule 'myrule' was not found."
        }

        if ($rule.Definition.Actions.Version.Delete.DaysAfterCreationGreaterThan -ne 90) {
            throw "Version delete retention is not set to 90 days."
        }

        if ($rule.Definition.Actions.BaseBlob.TierToCool.DaysAfterModificationGreaterThan -ne 30) {
            throw "Tier to cool threshold is not set to 30 days."
        }

        if ($rule.Definition.Actions.BaseBlob.TierToArchive.DaysAfterModificationGreaterThan -ne 90) {
            throw "Tier to archive threshold is not set to 90 days."
        }

        if ($rule.Definition.Actions.BaseBlob.Delete.DaysAfterModificationGreaterThan -ne 365) {
            throw "Delete threshold is not set to 365 days."
        }

        if (-not $rule.Definition.Actions.BaseBlob.EnableAutoTierToHotFromCool) {
            throw "enableAutoTierToHotFromCool is not set to true."
        }

        if ($rule.Definition.Filters.PrefixMatch -notcontains "container2/myblob") {
            throw "Lifecycle prefix filter does not include 'container2/myblob'."
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
