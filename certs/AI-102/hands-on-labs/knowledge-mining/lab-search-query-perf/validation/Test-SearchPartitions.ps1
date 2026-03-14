<#
.SYNOPSIS
Validates Azure AI Search partition and replica configuration.

.DESCRIPTION
Checks the deployed Azure AI Search service to confirm partition count,
replica count, and SKU tier. Demonstrates the difference between partitions
(query speed) and replicas (query throughput).

.CONTEXT
AI-102 Lab - Improve Azure AI Search query performance with partitions

.AUTHOR
Greg Tate

.NOTES
Program: Test-SearchPartitions.ps1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory)]
    [string]$SearchServiceName
)

# Expected configuration values
$ExpectedPartitionCount = 2
$ExpectedReplicaCount   = 1
$ExpectedSku            = "basic"

$Main = {
    . $Helpers

    Show-Header
    Confirm-SearchService
    Show-ScalingConcepts
    Show-Summary
}

$Helpers = {
    function Show-Header {
        # Display lab validation header
        Write-Host "`n========================================" -ForegroundColor Cyan
        Write-Host " AI Search Query Performance Validation" -ForegroundColor Cyan
        Write-Host "========================================`n" -ForegroundColor Cyan
    }

    function Confirm-SearchService {
        # Retrieve and validate the search service configuration
        Write-Host "Checking search service: $SearchServiceName" -ForegroundColor Yellow
        Write-Host "Resource group: $ResourceGroupName`n" -ForegroundColor Yellow

        $script:searchService = Get-AzSearchService `
            -ResourceGroupName $ResourceGroupName `
            -Name $SearchServiceName `
            -ErrorAction Stop

        # Validate SKU tier
        $skuName = $script:searchService.SkuName
        if ($skuName -eq $ExpectedSku) {
            Write-Host "[PASS] SKU: $skuName (supports partition scaling)" -ForegroundColor Green
        } else {
            Write-Host "[INFO] SKU: $skuName (expected: $ExpectedSku)" -ForegroundColor Yellow
        }

        # Validate partition count
        $partitions = $script:searchService.PartitionCount
        if ($partitions -eq $ExpectedPartitionCount) {
            Write-Host "[PASS] Partition count: $partitions (index split for parallel query processing)" -ForegroundColor Green
        } else {
            Write-Host "[WARN] Partition count: $partitions (expected: $ExpectedPartitionCount)" -ForegroundColor Yellow
        }

        # Validate replica count
        $replicas = $script:searchService.ReplicaCount
        if ($replicas -eq $ExpectedReplicaCount) {
            Write-Host "[PASS] Replica count: $replicas" -ForegroundColor Green
        } else {
            Write-Host "[INFO] Replica count: $replicas (expected: $ExpectedReplicaCount)" -ForegroundColor Yellow
        }

        # Display search units (partitions x replicas)
        $searchUnits = $partitions * $replicas
        Write-Host "`nSearch Units: $searchUnits (partitions x replicas = $partitions x $replicas)" -ForegroundColor Cyan

        # Display service status
        $status = $script:searchService.Status
        Write-Host "Service status: $status`n" -ForegroundColor Cyan
    }

    function Show-ScalingConcepts {
        # Explain partition vs replica scaling for exam preparation
        Write-Host "--- Partition vs Replica Scaling ---" -ForegroundColor Magenta
        Write-Host ""
        Write-Host "PARTITIONS (currently: $($script:searchService.PartitionCount))" -ForegroundColor White
        Write-Host "  - Split index data across physical shards" -ForegroundColor Gray
        Write-Host "  - Enable PARALLEL query processing" -ForegroundColor Gray
        Write-Host "  - Improve INDIVIDUAL query latency" -ForegroundColor Gray
        Write-Host "  - Use when: queries slow even with NO load" -ForegroundColor Gray
        Write-Host ""
        Write-Host "REPLICAS (currently: $($script:searchService.ReplicaCount))" -ForegroundColor White
        Write-Host "  - Add copies of the entire index" -ForegroundColor Gray
        Write-Host "  - Handle more CONCURRENT queries" -ForegroundColor Gray
        Write-Host "  - Improve query THROUGHPUT" -ForegroundColor Gray
        Write-Host "  - Use when: queries slow under HEAVY load" -ForegroundColor Gray
        Write-Host ""
    }

    function Show-Summary {
        # Display final validation summary
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host " Validation Complete" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host "`nService endpoint: https://$SearchServiceName.search.windows.net" -ForegroundColor White
        Write-Host "Partitions: $($script:searchService.PartitionCount) | Replicas: $($script:searchService.ReplicaCount) | SKU: $($script:searchService.SkuName)`n" -ForegroundColor White
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
