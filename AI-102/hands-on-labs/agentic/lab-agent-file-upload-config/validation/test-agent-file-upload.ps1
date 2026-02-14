<#
.SYNOPSIS
Validate Azure AI Agent Service standard setup RBAC and resource deployment.

.DESCRIPTION
Confirms resource deployment and validates all RBAC role assignments required
for the standard agent setup. Checks Storage Blob Data Owner on agents-blobstore,
Cosmos DB roles, and AI Search roles.

.CONTEXT
AI-102 Lab - Agent Service file upload configuration

.AUTHOR
Greg Tate

.NOTES
Program: test-agent-file-upload.ps1
Date: 2026-02-14
#>

[CmdletBinding()]
param()

$script:ExpectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
$script:TestResults = @()

$Main = {
    . $Helpers

    Show-ValidationHeader
    Confirm-LabSubscription

    # Get Terraform outputs
    $outputs = Get-TerraformOutputs

    # Test resource existence
    $storageExists = Test-StorageAccount `
        -ResourceGroupName $outputs.ResourceGroupName `
        -StorageAccountName $outputs.StorageAccountName

    $aiServicesExists = Test-AIServicesAccount `
        -ResourceGroupName $outputs.ResourceGroupName `
        -AccountName $outputs.AIServicesName

    # Test RBAC role assignments (the core learning of this lab)
    $rbacResults = Test-RBACAssignments `
        -PrincipalId $outputs.PrincipalId `
        -ResourceGroupName $outputs.ResourceGroupName `
        -StorageAccountName $outputs.StorageAccountName `
        -AgentsContainer $outputs.AgentsContainer `
        -AzureMLContainer $outputs.AzureMLContainer `
        -CosmosDbName $outputs.CosmosDbName `
        -AISearchName $outputs.AISearchName

    Show-ValidationSummary
}

$Helpers = {
    function Show-ValidationHeader {
        Write-Host ''
        Write-Host '=== Azure AI Agent Service File Upload Configuration Validation ===' -ForegroundColor Magenta
        Write-Host ''
    }

    function Confirm-LabSubscription {
        $currentSubscription = (Get-AzContext).Subscription.Id

        if ($currentSubscription -ne $script:ExpectedSubscriptionId) {
            Write-Error "Not connected to lab subscription. Expected: $script:ExpectedSubscriptionId, Current: $currentSubscription"
            exit 1
        }

        Write-Host "Subscription validated: $currentSubscription" -ForegroundColor Green
    }

    function Get-TerraformOutputs {
        Write-Host "`n--- Retrieving Terraform Outputs ---" -ForegroundColor Cyan
        $terraformDir = Join-Path $PSScriptRoot '..' 'terraform'

        Push-Location $terraformDir
        $rgName = terraform output -raw resource_group_name
        $storageName = terraform output -raw storage_account_name
        $agentsContainer = terraform output -raw agents_blobstore_container
        $azuremlContainer = terraform output -raw azureml_blobstore_container
        $aiServicesName = terraform output -raw ai_services_name
        $principalId = terraform output -raw ai_services_principal_id
        $cosmosDbName = terraform output -raw cosmos_db_name
        $aiSearchName = terraform output -raw ai_search_name
        Pop-Location

        Write-Host "  Resource Group: $rgName"
        Write-Host "  Storage Account: $storageName"
        Write-Host "  Agents Container: $agentsContainer"
        Write-Host "  AI Services: $aiServicesName"
        Write-Host "  Principal ID: $principalId"
        Write-Host "  Cosmos DB: $cosmosDbName"
        Write-Host "  AI Search: $aiSearchName"

        return @{
            ResourceGroupName = $rgName
            StorageAccountName = $storageName
            AgentsContainer = $agentsContainer
            AzureMLContainer = $azuremlContainer
            AIServicesName = $aiServicesName
            PrincipalId = $principalId
            CosmosDbName = $cosmosDbName
            AISearchName = $aiSearchName
        }
    }

    function Add-TestResult {
        param(
            [string]$TestName,
            [bool]$Passed,
            [string]$Details = ''
        )

        $script:TestResults += @{
            TestName = $TestName
            Passed   = $Passed
            Details  = $Details
        }

        # Display result inline
        if ($Passed) {
            Write-Host "  PASS: $TestName" -ForegroundColor Green
        }
        else {
            Write-Host "  FAIL: $TestName - $Details" -ForegroundColor Red
        }
    }

    function Test-StorageAccount {
        param([string]$ResourceGroupName, [string]$StorageAccountName)
        Write-Host "`n--- Testing Storage Account ---" -ForegroundColor Cyan

        try {
            $storage = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName
            Add-TestResult -TestName 'Storage Account exists' -Passed $true
            Write-Host "  Location: $($storage.Location)"
            Write-Host "  SKU: $($storage.Sku.Name)"
            return $true
        }
        catch {
            Add-TestResult -TestName 'Storage Account exists' -Passed $false -Details $_
            return $false
        }
    }

    function Test-AIServicesAccount {
        param([string]$ResourceGroupName, [string]$AccountName)
        Write-Host "`n--- Testing AI Services Account ---" -ForegroundColor Cyan

        try {
            $account = Get-AzCognitiveServicesAccount -ResourceGroupName $ResourceGroupName -Name $AccountName
            Add-TestResult -TestName 'AI Services Account exists' -Passed $true
            Write-Host "  Kind: $($account.Kind)"
            Write-Host "  SKU: $($account.Sku.Name)"
            Write-Host "  Identity: $($account.Identity.Type)"
            return $true
        }
        catch {
            Add-TestResult -TestName 'AI Services Account exists' -Passed $false -Details $_
            return $false
        }
    }

    function Test-RBACAssignments {
        param(
            [string]$PrincipalId,
            [string]$ResourceGroupName,
            [string]$StorageAccountName,
            [string]$AgentsContainer,
            [string]$AzureMLContainer,
            [string]$CosmosDbName,
            [string]$AISearchName
        )
        Write-Host "`n--- Testing RBAC Role Assignments ---" -ForegroundColor Cyan

        # Get all role assignments for the principal
        $allAssignments = Get-AzRoleAssignment -ObjectId $PrincipalId

        # Test 1: Storage Account Contributor on storage account
        $storageContributor = $allAssignments | Where-Object {
            $_.RoleDefinitionName -eq 'Storage Account Contributor' -and
            $_.Scope -like "*/storageAccounts/$StorageAccountName"
        }
        Add-TestResult `
            -TestName 'Storage Account Contributor on storage account' `
            -Passed ($null -ne $storageContributor) `
            -Details 'Management plane role for storage account management'

        # Test 2: Storage Blob Data Owner on agents-blobstore container (CRITICAL)
        $blobDataOwner = $allAssignments | Where-Object {
            $_.RoleDefinitionName -eq 'Storage Blob Data Owner' -and
            $_.Scope -like "*containers/$AgentsContainer"
        }
        Add-TestResult `
            -TestName 'Storage Blob Data Owner on agents-blobstore (CRITICAL)' `
            -Passed ($null -ne $blobDataOwner) `
            -Details 'This is the role that causes file upload failures when missing'

        # Test 3: Storage Blob Data Contributor on azureml-blobstore container
        $blobDataContributor = $allAssignments | Where-Object {
            $_.RoleDefinitionName -eq 'Storage Blob Data Contributor' -and
            $_.Scope -like "*containers/$AzureMLContainer"
        }
        Add-TestResult `
            -TestName 'Storage Blob Data Contributor on azureml-blobstore' `
            -Passed ($null -ne $blobDataContributor) `
            -Details 'Data plane role for intermediate system data'

        # Test 4: Cosmos DB Operator on Cosmos DB account
        $cosmosOperator = $allAssignments | Where-Object {
            $_.RoleDefinitionName -eq 'Cosmos DB Operator' -and
            $_.Scope -like "*/databaseAccounts/$CosmosDbName"
        }
        Add-TestResult `
            -TestName 'Cosmos DB Operator on Cosmos DB account' `
            -Passed ($null -ne $cosmosOperator) `
            -Details 'Control plane role required for capability host'

        # Test 5: Search Index Data Contributor on AI Search
        $searchIndex = $allAssignments | Where-Object {
            $_.RoleDefinitionName -eq 'Search Index Data Contributor' -and
            $_.Scope -like "*/searchServices/$AISearchName"
        }
        Add-TestResult `
            -TestName 'Search Index Data Contributor on AI Search' `
            -Passed ($null -ne $searchIndex) `
            -Details 'Required for agent vector store operations'

        # Test 6: Search Service Contributor on AI Search
        $searchService = $allAssignments | Where-Object {
            $_.RoleDefinitionName -eq 'Search Service Contributor' -and
            $_.Scope -like "*/searchServices/$AISearchName"
        }
        Add-TestResult `
            -TestName 'Search Service Contributor on AI Search' `
            -Passed ($null -ne $searchService) `
            -Details 'Required for managing search service configuration'
    }

    function Show-ValidationSummary {
        Write-Host "`n=== Validation Summary ===" -ForegroundColor Magenta

        $passed = ($script:TestResults | Where-Object { $_.Passed }).Count
        $failed = ($script:TestResults | Where-Object { -not $_.Passed }).Count
        $total = $script:TestResults.Count

        Write-Host "Total: $total | Passed: $passed | Failed: $failed"

        if ($failed -eq 0) {
            Write-Host "`nAll validations PASSED. Standard agent setup RBAC is correctly configured." -ForegroundColor Green
        }
        else {
            Write-Host "`nSome validations FAILED. Review the RBAC assignments above." -ForegroundColor Red
        }

        Write-Host ''
    }
}

try {
    Push-Location $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
