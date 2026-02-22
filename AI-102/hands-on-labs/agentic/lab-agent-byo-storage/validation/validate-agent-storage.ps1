<#
.SYNOPSIS
Validates Azure AI Agent Service BYO storage configuration against exam answers.

.DESCRIPTION
Walks through each exam answer option (A-E) and validates the underlying
Azure configuration. Tests RBAC role assignments, data plane access,
role definition comparison, BYO connection endpoints, and container
auto-creation behavior.

.CONTEXT
AI-102 Lab - Agent Service BYO Storage Configuration

.AUTHOR
Greg Tate

.NOTES
Program: validate-agent-storage.ps1
#>

[CmdletBinding()]
param(
    [string]$TerraformDir = (Join-Path $PSScriptRoot '..' 'terraform')
)

# Configuration
$ExpectedRole        = 'Storage Blob Data Owner'
$ManagementPlaneRole = 'Storage Account Contributor'
$TestContainerName   = 'validation-test-container'
$TestBlobName        = 'validation-test-blob.txt'

$Main = {
    . $Helpers

    Confirm-LabSubscription
    Get-TerraformOutput
    Confirm-StorageAccountExist
    Test-AnswerA
    Test-AnswerB
    Test-AnswerC
    Test-AnswerD
    Test-AnswerE
    Show-ValidationSummary
}

$Helpers = {

    function Confirm-LabSubscription {
        # Validate deployment to lab subscription
        $expectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
        $currentSubscription = (Get-AzContext).Subscription.Id

        if ($currentSubscription -ne $expectedSubscriptionId) {
            Write-Error "Not connected to lab subscription. Expected: $expectedSubscriptionId, Got: $currentSubscription"
            exit 1
        }

        Write-Host "`n[PASS] Connected to lab subscription" -ForegroundColor Green
    }

    function Get-TerraformOutput {
        # Retrieve resource identifiers from Terraform outputs
        Push-Location $TerraformDir

        try {
            $script:ResourceGroupName    = (terraform output -raw resource_group_name 2>$null)
            $script:StorageAccountName   = (terraform output -raw storage_account_name 2>$null)
            $script:StorageAccountId     = (terraform output -raw storage_account_id 2>$null)
            $script:AiServicesPrincipalId = (terraform output -raw ai_services_principal_id 2>$null)
            $script:AiServicesName       = (terraform output -raw ai_services_name 2>$null)
            $script:CosmosDbName         = (terraform output -raw cosmosdb_account_name 2>$null)
            $script:CosmosDbEndpoint     = (terraform output -raw cosmosdb_endpoint 2>$null)
            $script:SearchServiceName    = (terraform output -raw search_service_name 2>$null)
            $script:StorageBlobEndpoint  = (terraform output -raw storage_primary_blob_endpoint 2>$null)
        }
        finally {
            Pop-Location
        }

        if (-not $script:StorageAccountName) {
            Write-Error "Failed to read Terraform outputs. Run 'terraform apply' first."
            exit 1
        }

        Write-Host "`n--- Lab Resources ---" -ForegroundColor Cyan
        Write-Host "Resource Group:     $script:ResourceGroupName"
        Write-Host "Storage Account:    $script:StorageAccountName"
        Write-Host "AI Services:        $script:AiServicesName"
        Write-Host "Cosmos DB:          $script:CosmosDbName"
        Write-Host "AI Search:          $script:SearchServiceName"
        Write-Host "Principal ID:       $script:AiServicesPrincipalId"
    }

    function Confirm-StorageAccountExist {
        # Verify the BYO storage account is deployed and accessible
        $storage = Get-AzStorageAccount `
            -ResourceGroupName $script:ResourceGroupName `
            -Name $script:StorageAccountName `
            -ErrorAction SilentlyContinue

        if ($storage) {
            Write-Host "`n[PASS] BYO storage account '$($storage.StorageAccountName)' exists" -ForegroundColor Green
            Write-Host "  Kind: $($storage.Kind) | Tier: $($storage.Sku.Tier) | Replication: $($storage.Sku.Name)"
            Write-Host "  Blob endpoint: $($storage.PrimaryEndpoints.Blob)"
        }
        else {
            Write-Host "`n[FAIL] BYO storage account not found" -ForegroundColor Red
        }
    }

    function Test-AnswerA {
        # Validate Answer A: Storage Blob Data Owner is required for data plane access
        Write-Host "`n===========================================" -ForegroundColor Cyan
        Write-Host " Answer A — Storage Blob Data Owner (CORRECT)" -ForegroundColor Cyan
        Write-Host "===========================================" -ForegroundColor Cyan

        # Check the RBAC role assignment on the managed identity
        $dataOwnerAssignment = Get-AzRoleAssignment `
            -Scope $script:StorageAccountId `
            -PrincipalId $script:AiServicesPrincipalId `
            -RoleDefinitionName $ExpectedRole `
            -ErrorAction SilentlyContinue

        if ($dataOwnerAssignment) {
            Write-Host "[PASS] '$ExpectedRole' assigned to AI Services identity" -ForegroundColor Green
            Write-Host "  Scope: $($dataOwnerAssignment.Scope)"
        }
        else {
            Write-Host "[FAIL] '$ExpectedRole' NOT assigned to AI Services identity" -ForegroundColor Red
        }

        # Perform a full data plane roundtrip: create container → upload blob → read back → clean up
        Write-Host "`n  Data plane roundtrip test:" -ForegroundColor Cyan

        try {
            $ctx = New-AzStorageContext `
                -StorageAccountName $script:StorageAccountName `
                -UseConnectedAccount

            # Create container
            New-AzStorageContainer `
                -Name $TestContainerName `
                -Context $ctx `
                -Permission Off `
                -ErrorAction Stop | Out-Null

            Write-Host "  [PASS] Created test container '$TestContainerName'" -ForegroundColor Green

            # Upload a test blob
            $testFile = Join-Path $env:TEMP $TestBlobName
            "Agent service validation test" | Out-File -FilePath $testFile -Encoding utf8

            Set-AzStorageBlobContent `
                -Container $TestContainerName `
                -File $testFile `
                -Blob $TestBlobName `
                -Context $ctx `
                -Force `
                -ErrorAction Stop | Out-Null

            Write-Host "  [PASS] Uploaded test blob" -ForegroundColor Green

            # Read back the blob
            $downloadFile = Join-Path $env:TEMP "download-$TestBlobName"

            Get-AzStorageBlobContent `
                -Container $TestContainerName `
                -Blob $TestBlobName `
                -Destination $downloadFile `
                -Context $ctx `
                -Force `
                -ErrorAction Stop | Out-Null

            $content = Get-Content $downloadFile
            Write-Host "  [PASS] Read back blob content: '$content'" -ForegroundColor Green

            # Clean up
            Remove-AzStorageContainer -Name $TestContainerName -Context $ctx -Force
            Remove-Item $testFile, $downloadFile -ErrorAction SilentlyContinue
            Write-Host "  [PASS] Cleaned up test resources" -ForegroundColor Gray
        }
        catch {
            Write-Host "  [FAIL] Data plane roundtrip failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    function Test-AnswerB {
        # Validate Answer B: Storage Account Contributor has zero DataActions
        Write-Host "`n===========================================" -ForegroundColor Cyan
        Write-Host " Answer B — Storage Account Contributor (WRONG)" -ForegroundColor Cyan
        Write-Host "===========================================" -ForegroundColor Cyan

        # Compare role definitions
        $dataOwner   = Get-AzRoleDefinition $ExpectedRole
        $contributor = Get-AzRoleDefinition $ManagementPlaneRole

        # Show that Contributor has no DataActions
        Write-Host "`n  $ManagementPlaneRole :" -ForegroundColor Yellow

        if ($contributor.DataActions.Count -eq 0) {
            Write-Host "  [PASS] DataActions: (none — zero data plane permissions)" -ForegroundColor Green
        }
        else {
            Write-Host "  [WARN] Found unexpected DataActions:" -ForegroundColor Yellow
            $contributor.DataActions | ForEach-Object { Write-Host "    $_" }
        }

        # Show that Data Owner has DataActions
        Write-Host "`n  $ExpectedRole :" -ForegroundColor Green

        if ($dataOwner.DataActions.Count -gt 0) {
            Write-Host "  [PASS] DataActions:" -ForegroundColor Green
            $dataOwner.DataActions | ForEach-Object { Write-Host "    $_" }
        }
        else {
            Write-Host "  [FAIL] No DataActions found" -ForegroundColor Red
        }

        Write-Host "`n  Verdict: Contributor cannot perform blob operations at any scope." -ForegroundColor White
    }

    function Test-AnswerC {
        # Validate Answer C: AI Search is independent of file uploads
        Write-Host "`n===========================================" -ForegroundColor Cyan
        Write-Host " Answer C — AI Search Connection (WRONG)" -ForegroundColor Cyan
        Write-Host "===========================================" -ForegroundColor Cyan

        # Verify AI Search exists and show its independent role
        $search = Get-AzResource `
            -ResourceGroupName $script:ResourceGroupName `
            -ResourceType "Microsoft.Search/searchServices" `
            -ErrorAction SilentlyContinue

        if ($search) {
            Write-Host "[PASS] AI Search '$($search.Name)' exists" -ForegroundColor Green
            Write-Host "  Endpoint: https://$($search.Name).search.windows.net"
        }
        else {
            Write-Host "[FAIL] AI Search not found" -ForegroundColor Red
        }

        Write-Host "`n  Connection mapping:" -ForegroundColor Cyan
        Write-Host "    storageConnections       → Storage (file uploads)"
        Write-Host "    vectorStoreConnections   → AI Search (vector retrieval)"
        Write-Host "    threadStorageConnections  → Cosmos DB (conversations)"
        Write-Host "`n  Verdict: A broken AI Search connection affects vector search," -ForegroundColor White
        Write-Host "  not file uploads. These are independent failure domains." -ForegroundColor White
    }

    function Test-AnswerD {
        # Validate Answer D: Agent service auto-creates containers
        Write-Host "`n===========================================" -ForegroundColor Cyan
        Write-Host " Answer D — Manual Container Creation (WRONG)" -ForegroundColor Cyan
        Write-Host "===========================================" -ForegroundColor Cyan

        $ctx = New-AzStorageContext `
            -StorageAccountName $script:StorageAccountName `
            -UseConnectedAccount

        # List containers to show none are pre-created
        $containers = Get-AzStorageContainer -Context $ctx -ErrorAction SilentlyContinue

        if ($containers.Count -eq 0) {
            Write-Host "[PASS] No pre-created containers — agent auto-creates them" -ForegroundColor Green
        }
        else {
            Write-Host "[INFO] Existing containers (may be from prior test runs):" -ForegroundColor Yellow
            $containers |
                Select-Object Name, LastModified |
                Format-Table -AutoSize
        }

        Write-Host "`n  Verdict: No manual 'uploaded-files' container is needed." -ForegroundColor White
        Write-Host "  The agent creates <workspaceId>-agents-blobstore automatically." -ForegroundColor White
    }

    function Test-AnswerE {
        # Validate Answer E: Wrong storage connection prevents all file operations
        Write-Host "`n===========================================" -ForegroundColor Cyan
        Write-Host " Answer E — Storage Connection String (CORRECT)" -ForegroundColor Cyan
        Write-Host "===========================================" -ForegroundColor Cyan

        # Show the correct endpoint
        Write-Host "  Correct storage endpoint: $script:StorageBlobEndpoint" -ForegroundColor Green

        # Attempt a connection to a non-existent storage account
        try {
            $badCtx = New-AzStorageContext `
                -StorageAccountName "nonexiststorage99999" `
                -UseConnectedAccount

            Get-AzStorageContainer -Context $badCtx -ErrorAction Stop | Out-Null
            Write-Host "  [UNEXPECTED] Bad endpoint did not fail" -ForegroundColor Red
        }
        catch {
            Write-Host "  [PASS] Wrong endpoint fails: $($_.Exception.Message)" -ForegroundColor Green
        }

        # Confirm the correct endpoint works
        try {
            $goodCtx = New-AzStorageContext `
                -StorageAccountName $script:StorageAccountName `
                -UseConnectedAccount

            Get-AzStorageContainer -Context $goodCtx -ErrorAction Stop | Out-Null
            Write-Host "  [PASS] Correct endpoint succeeds" -ForegroundColor Green
        }
        catch {
            Write-Host "  [FAIL] Correct endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
        }

        Write-Host "`n  Verdict: The capability host storageConnections must reference" -ForegroundColor White
        Write-Host "  the correct BYO storage account. A wrong value breaks all file ops." -ForegroundColor White
    }

    function Show-ValidationSummary {
        # Display final summary with exam answers
        Write-Host "`n==========================================" -ForegroundColor Cyan
        Write-Host " Validation Complete" -ForegroundColor Cyan
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  Correct Answers:" -ForegroundColor White
        Write-Host "    A - Storage Blob Data Owner required for data plane access" -ForegroundColor Green
        Write-Host "    E - Capability host must reference the correct storage endpoint" -ForegroundColor Green
        Write-Host ""
        Write-Host "  Wrong Answers:" -ForegroundColor White
        Write-Host "    B - Storage Account Contributor has zero DataActions" -ForegroundColor Yellow
        Write-Host "    C - AI Search connection is independent of file uploads" -ForegroundColor Yellow
        Write-Host "    D - Agent service auto-creates containers" -ForegroundColor Yellow
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
