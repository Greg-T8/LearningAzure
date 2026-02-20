<#
.SYNOPSIS
Validates Azure AI Agent Service BYO storage configuration.

.DESCRIPTION
Verifies RBAC role assignments, storage account configuration, and
data plane access for the AI Agent Service standard setup. Demonstrates
the difference between management plane and data plane roles.

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
$ExpectedRole = 'Storage Blob Data Owner'
$ManagementPlaneRole = 'Storage Account Contributor'

$Main = {
    . $Helpers

    Confirm-LabSubscription
    Get-TerraformOutput
    Confirm-StorageAccountExists
    Confirm-RbacRoleAssignment
    Confirm-DataPlaneAccess
    Show-RoleDifference
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
        # Retrieve resource names from Terraform outputs
        Push-Location $TerraformDir

        try {
            $script:ResourceGroupName = (terraform output -raw resource_group_name 2>$null)
            $script:StorageAccountName = (terraform output -raw storage_account_name 2>$null)
            $script:AiServicesPrincipalId = (terraform output -raw ai_services_principal_id 2>$null)
            $script:AiServicesName = (terraform output -raw ai_services_name 2>$null)
            $script:CosmosDbName = (terraform output -raw cosmosdb_account_name 2>$null)
            $script:SearchServiceName = (terraform output -raw search_service_name 2>$null)
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

    function Confirm-StorageAccountExists {
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

    function Confirm-RbacRoleAssignment {
        # Verify Storage Blob Data Owner is assigned to the AI Services managed identity
        Write-Host "`n--- RBAC Verification ---" -ForegroundColor Cyan

        $storageId = (Get-AzStorageAccount `
            -ResourceGroupName $script:ResourceGroupName `
            -Name $script:StorageAccountName).Id

        # Check for the correct data plane role
        $dataOwnerAssignment = Get-AzRoleAssignment `
            -Scope $storageId `
            -PrincipalId $script:AiServicesPrincipalId `
            -RoleDefinitionName $ExpectedRole `
            -ErrorAction SilentlyContinue

        if ($dataOwnerAssignment) {
            Write-Host "[PASS] '$ExpectedRole' assigned to AI Services identity" -ForegroundColor Green
            Write-Host "  Scope: $($dataOwnerAssignment.Scope)"
        }
        else {
            Write-Host "[FAIL] '$ExpectedRole' NOT assigned to AI Services identity" -ForegroundColor Red
            Write-Host "  File uploads will fail without data plane access!" -ForegroundColor Yellow
        }

        # Check for the INCORRECT management plane role (to demonstrate the exam concept)
        $contributorAssignment = Get-AzRoleAssignment `
            -Scope $storageId `
            -PrincipalId $script:AiServicesPrincipalId `
            -RoleDefinitionName $ManagementPlaneRole `
            -ErrorAction SilentlyContinue

        if ($contributorAssignment) {
            Write-Host "[INFO] '$ManagementPlaneRole' is also assigned (management plane only)" -ForegroundColor Yellow
            Write-Host "  This role alone would NOT enable file uploads" -ForegroundColor Yellow
        }
        else {
            Write-Host "[INFO] '$ManagementPlaneRole' is NOT assigned (correct - not needed)" -ForegroundColor Gray
        }
    }

    function Confirm-DataPlaneAccess {
        # Test actual data plane access by creating a test blob container
        Write-Host "`n--- Data Plane Access Test ---" -ForegroundColor Cyan

        try {
            $ctx = New-AzStorageContext `
                -StorageAccountName $script:StorageAccountName `
                -UseConnectedAccount

            # Create a test container to simulate agent blobstore
            $containerName = "validation-test-container"
            $container = New-AzStorageContainer `
                -Name $containerName `
                -Context $ctx `
                -Permission Off `
                -ErrorAction Stop

            Write-Host "[PASS] Data plane write access confirmed (created test container)" -ForegroundColor Green

            # Clean up the test container
            Remove-AzStorageContainer -Name $containerName -Context $ctx -Force
            Write-Host "  Test container cleaned up" -ForegroundColor Gray
        }
        catch {
            Write-Host "[FAIL] Data plane access denied: $_" -ForegroundColor Red
            Write-Host "  The deployer identity may need Storage Blob Data Owner" -ForegroundColor Yellow
        }
    }

    function Show-RoleDifference {
        # Display the critical difference between management and data plane roles
        Write-Host "`n--- Management Plane vs Data Plane Roles ---" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  Storage Account Contributor (Management Plane):" -ForegroundColor Yellow
        Write-Host "    - Can manage storage account configuration"
        Write-Host "    - Can view/rotate access keys"
        Write-Host "    - CANNOT read or write blob data"
        Write-Host "    - CANNOT create/delete containers via data plane"
        Write-Host ""
        Write-Host "  Storage Blob Data Owner (Data Plane):" -ForegroundColor Green
        Write-Host "    - Can read, write, and delete blob data"
        Write-Host "    - Can create and manage containers"
        Write-Host "    - Can manage blob ACLs and metadata"
        Write-Host "    - REQUIRED for Agent Service file uploads"
        Write-Host ""
        Write-Host "  Key Insight:" -ForegroundColor White
        Write-Host "    The AI Agent Service performs blob operations (file uploads),"
        Write-Host "    which require DATA PLANE access. Management plane roles like"
        Write-Host "    Storage Account Contributor cannot perform blob operations."
    }

    function Show-ValidationSummary {
        # Display validation results summary
        Write-Host "`n==========================================" -ForegroundColor Cyan
        Write-Host " Validation Complete" -ForegroundColor Cyan
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "This lab demonstrates the correct RBAC configuration"
        Write-Host "for Azure AI Agent Service with BYO storage."
        Write-Host ""
        Write-Host "Exam Answer: Options A and E are correct." -ForegroundColor White
        Write-Host "  A - Storage Blob Data Owner is required on the blobstore container"
        Write-Host "  E - Capability host connection string must reference the correct storage"
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
