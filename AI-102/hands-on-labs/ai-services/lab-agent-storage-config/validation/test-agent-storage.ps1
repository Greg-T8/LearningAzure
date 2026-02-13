<#
.SYNOPSIS
Validates Azure AI Agent Service storage configuration.

.DESCRIPTION
Checks the critical configurations that enable file uploads in an Azure AI
Agent Service standard setup: Storage Blob Data Owner role assignment and
correct capability host storage connection.

.CONTEXT
AI-102 Lab - Agent file upload storage configuration

.AUTHOR
Greg Tate

.NOTES
Program: test-agent-storage.ps1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupName = 'ai102-ai-services-agent-storage-config-bicep'
)

$Main = {
    # Dot-source helper functions
    . $Helpers

    # Validate Azure CLI is authenticated
    Confirm-AzCliAuth

    # Discover resources from the deployment
    $resources = Get-DeployedResource

    # Test 1: Verify storage account exists and is correctly configured
    Test-StorageAccount -Resources $resources

    # Test 2: Verify project managed identity has Storage Blob Data Owner role
    Test-StorageBlobDataOwnerRole -Resources $resources

    # Test 3: Verify project managed identity has Storage Blob Data Contributor role
    Test-StorageBlobDataContributorRole -Resources $resources

    # Test 4: Verify capability host has correct storage connection
    Test-CapabilityHostStorageConnection -Resources $resources

    # Summary
    Show-TestSummary
}

# Track test results
$script:TestResults = @()

$Helpers = {
    function Confirm-AzCliAuth {
        # Verify Azure CLI is authenticated to the lab subscription

        $expectedSubId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'

        try {
            $currentSub = az account show --query "id" -o tsv 2>$null
        }
        catch {
            Write-Error "Not authenticated to Azure CLI. Run: az login"
            exit 1
        }

        if ($currentSub -ne $expectedSubId) {
            Write-Error "Wrong subscription. Expected: $expectedSubId, Got: $currentSub"
            exit 1
        }

        Write-Host "`n[AUTH] Subscription verified: $expectedSubId" -ForegroundColor Green
    }

    function Get-DeployedResource {
        # Discover deployed resources from the resource group

        Write-Host "`n[DISCOVERY] Finding resources in $ResourceGroupName..." -ForegroundColor Cyan

        # Get AI account name
        $aiAccount = az cognitiveservices account list `
            --resource-group $ResourceGroupName `
            --query "[?kind=='AIServices'].name" `
            -o tsv 2>$null

        if ([string]::IsNullOrEmpty($aiAccount)) {
            Write-Error "No AI Services account found in $ResourceGroupName"
            exit 1
        }

        # Get storage account name
        $storageAccount = az storage account list `
            --resource-group $ResourceGroupName `
            --query "[0].name" `
            -o tsv 2>$null

        # Get project name (API returns parent/child format, extract child segment)
        $projectFullName = az rest `
            --method get `
            --url "https://management.azure.com/subscriptions/e091f6e7-031a-4924-97bb-8c983ca5d21a/resourceGroups/$ResourceGroupName/providers/Microsoft.CognitiveServices/accounts/$aiAccount/projects?api-version=2025-04-01-preview" `
            --query "value[0].name" `
            -o tsv 2>$null

        # Extract the project segment (name may include parent path)
        $project = ($projectFullName -split '/')[-1]

        # Get project principal ID
        $projectPrincipalId = az rest `
            --method get `
            --url "https://management.azure.com/subscriptions/e091f6e7-031a-4924-97bb-8c983ca5d21a/resourceGroups/$ResourceGroupName/providers/Microsoft.CognitiveServices/accounts/$aiAccount/projects/${project}?api-version=2025-04-01-preview" `
            --query "identity.principalId" `
            -o tsv 2>$null

        Write-Host "  AI Account:    $aiAccount" -ForegroundColor Gray
        Write-Host "  Project:       $project" -ForegroundColor Gray
        Write-Host "  Storage:       $storageAccount" -ForegroundColor Gray
        Write-Host "  Principal ID:  $projectPrincipalId" -ForegroundColor Gray

        return @{
            AiAccount          = $aiAccount
            Project            = $project
            StorageAccount     = $storageAccount
            ProjectPrincipalId = $projectPrincipalId
        }
    }

    function Add-TestResult {
        # Record a test result

        param(
            [string]$TestName,
            [bool]$Passed,
            [string]$Detail
        )

        $script:TestResults += [PSCustomObject]@{
            Test   = $TestName
            Status = if ($Passed) { 'PASS' } else { 'FAIL' }
            Detail = $Detail
        }
    }

    function Test-StorageAccount {
        # Verify storage account exists with correct configuration

        param([hashtable]$Resources)

        Write-Host "`n[TEST 1] Storage Account Configuration" -ForegroundColor Yellow

        $storageJson = az storage account show `
            --name $Resources.StorageAccount `
            --resource-group $ResourceGroupName `
            --query "{name:name, sku:sku.name, sharedKey:allowSharedKeyAccess, tls:minimumTlsVersion}" `
            -o json 2>$null |
            ConvertFrom-Json

        if ($null -eq $storageJson) {
            Add-TestResult -TestName "Storage Account Exists" -Passed $false -Detail "Storage account not found"
            return
        }

        # Check storage account exists
        Add-TestResult -TestName "Storage Account Exists" -Passed $true -Detail $storageJson.name
        Write-Host "  ✅ Storage account exists: $($storageJson.name)" -ForegroundColor Green

        # Check shared key access is disabled (RBAC-only)
        $sharedKeyDisabled = $storageJson.sharedKey -eq $false
        Add-TestResult -TestName "Shared Key Access Disabled" -Passed $sharedKeyDisabled -Detail "allowSharedKeyAccess=$($storageJson.sharedKey)"

        if ($sharedKeyDisabled) {
            Write-Host "  ✅ Shared key access disabled (RBAC-only)" -ForegroundColor Green
        }
        else {
            Write-Host "  ⚠️  Shared key access is enabled (should be disabled for RBAC)" -ForegroundColor Yellow
        }
    }

    function Test-StorageBlobDataOwnerRole {
        # Verify project MI has Storage Blob Data Owner role (KEY EXAM CONCEPT)

        param([hashtable]$Resources)

        Write-Host "`n[TEST 2] Storage Blob Data Owner Role (KEY EXAM CONCEPT)" -ForegroundColor Yellow

        # Storage Blob Data Owner role ID
        $blobDataOwnerRoleId = 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b'

        $storageId = az storage account show `
            --name $Resources.StorageAccount `
            --resource-group $ResourceGroupName `
            --query "id" `
            -o tsv 2>$null

        # Check role assignment exists
        $roleAssignments = az role assignment list `
            --scope $storageId `
            --assignee $Resources.ProjectPrincipalId `
            --query "[?contains(roleDefinitionId, '$blobDataOwnerRoleId')]" `
            -o json 2>$null |
            ConvertFrom-Json

        $hasRole = ($null -ne $roleAssignments) -and ($roleAssignments.Count -gt 0)
        Add-TestResult -TestName "Storage Blob Data Owner" -Passed $hasRole -Detail "Role on storage for project MI"

        if ($hasRole) {
            Write-Host "  ✅ Storage Blob Data Owner role assigned to project MI" -ForegroundColor Green

            # Check if condition is set
            $hasCondition = $roleAssignments | Where-Object { $null -ne $_.condition -and $_.condition -ne '' }

            if ($hasCondition) {
                Write-Host "  ✅ ABAC condition set (restricts to agent containers)" -ForegroundColor Green
            }
            else {
                Write-Host "  ⚠️  No ABAC condition (role applies to all containers)" -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "  ❌ MISSING: Storage Blob Data Owner role" -ForegroundColor Red
            Write-Host "     This is why file uploads fail! (Exam answer option)" -ForegroundColor Red
        }
    }

    function Test-StorageBlobDataContributorRole {
        # Verify project MI has Storage Blob Data Contributor role

        param([hashtable]$Resources)

        Write-Host "`n[TEST 3] Storage Blob Data Contributor Role" -ForegroundColor Yellow

        # Storage Blob Data Contributor role ID
        $blobDataContributorRoleId = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

        $storageId = az storage account show `
            --name $Resources.StorageAccount `
            --resource-group $ResourceGroupName `
            --query "id" `
            -o tsv 2>$null

        # Check role assignment exists
        $roleAssignments = az role assignment list `
            --scope $storageId `
            --assignee $Resources.ProjectPrincipalId `
            --query "[?contains(roleDefinitionId, '$blobDataContributorRoleId')]" `
            -o json 2>$null |
            ConvertFrom-Json

        $hasRole = ($null -ne $roleAssignments) -and ($roleAssignments.Count -gt 0)
        Add-TestResult -TestName "Storage Blob Data Contributor" -Passed $hasRole -Detail "Account-level blob contributor"

        if ($hasRole) {
            Write-Host "  ✅ Storage Blob Data Contributor role assigned" -ForegroundColor Green
        }
        else {
            Write-Host "  ❌ MISSING: Storage Blob Data Contributor role" -ForegroundColor Red
        }
    }

    function Test-CapabilityHostStorageConnection {
        # Verify capability host has correct storage connection (KEY EXAM CONCEPT)

        param([hashtable]$Resources)

        Write-Host "`n[TEST 4] Capability Host Storage Connection (KEY EXAM CONCEPT)" -ForegroundColor Yellow

        # Get project capability host
        $capHostJson = az rest `
            --method get `
            --url "https://management.azure.com/subscriptions/e091f6e7-031a-4924-97bb-8c983ca5d21a/resourceGroups/$ResourceGroupName/providers/Microsoft.CognitiveServices/accounts/$($Resources.AiAccount)/projects/$($Resources.Project)/capabilityHosts/caphost-project?api-version=2025-04-01-preview" `
            -o json 2>$null |
            ConvertFrom-Json

        if ($null -eq $capHostJson) {
            Add-TestResult -TestName "Capability Host Exists" -Passed $false -Detail "Project capability host not found"
            Write-Host "  ❌ Project capability host not found" -ForegroundColor Red
            return
        }

        Add-TestResult -TestName "Capability Host Exists" -Passed $true -Detail "caphost-project found"
        Write-Host "  ✅ Project capability host exists" -ForegroundColor Green

        # Check storage connection
        $storageConnections = $capHostJson.properties.storageConnections

        if ($null -eq $storageConnections -or $storageConnections.Count -eq 0) {
            Add-TestResult -TestName "Storage Connection Configured" -Passed $false -Detail "No storage connections on capability host"
            Write-Host "  ❌ MISSING: No storage connections configured" -ForegroundColor Red
            Write-Host "     This is why file uploads fail! (Exam answer option)" -ForegroundColor Red
            return
        }

        # Verify the storage connection references the correct storage account
        $connectionName = $storageConnections[0]
        $isCorrect = $connectionName -eq $Resources.StorageAccount

        Add-TestResult -TestName "Storage Connection Correct" -Passed $isCorrect -Detail "Connection: $connectionName"

        if ($isCorrect) {
            Write-Host "  ✅ Storage connection correctly references: $connectionName" -ForegroundColor Green
        }
        else {
            Write-Host "  ❌ Storage connection references wrong storage: $connectionName" -ForegroundColor Red
            Write-Host "     Expected: $($Resources.StorageAccount)" -ForegroundColor Red
        }

        # Check thread storage (Cosmos DB) and vector store (AI Search) connections
        $threadConnections = $capHostJson.properties.threadStorageConnections
        $vectorConnections = $capHostJson.properties.vectorStoreConnections

        if ($threadConnections -and $threadConnections.Count -gt 0) {
            Write-Host "  ✅ Thread storage connection configured: $($threadConnections[0])" -ForegroundColor Green
        }

        if ($vectorConnections -and $vectorConnections.Count -gt 0) {
            Write-Host "  ✅ Vector store connection configured: $($vectorConnections[0])" -ForegroundColor Green
        }
    }

    function Show-TestSummary {
        # Display test results summary

        Write-Host "`n" + ("=" * 60) -ForegroundColor Cyan
        Write-Host "TEST RESULTS SUMMARY" -ForegroundColor Cyan
        Write-Host ("=" * 60) -ForegroundColor Cyan

        $passed = ($script:TestResults | Where-Object { $_.Status -eq 'PASS' }).Count
        $failed = ($script:TestResults | Where-Object { $_.Status -eq 'FAIL' }).Count
        $total = $script:TestResults.Count

        $script:TestResults |
            ForEach-Object {
                $color = if ($_.Status -eq 'PASS') { 'Green' } else { 'Red' }
                Write-Host "  [$($_.Status)] $($_.Test): $($_.Detail)" -ForegroundColor $color
            }

        Write-Host "`n  Total: $total | Passed: $passed | Failed: $failed" -ForegroundColor Cyan

        if ($failed -gt 0) {
            Write-Host "`n  ⚠️  Some tests failed - review the exam scenario analysis" -ForegroundColor Yellow
        }
        else {
            Write-Host "`n  ✅ All tests passed - agent storage is correctly configured" -ForegroundColor Green
        }

        Write-Host ""
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
