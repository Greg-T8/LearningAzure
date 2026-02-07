# -------------------------------------------------------------------------
# Program: test-storage-permissions.ps1
# Description: Validate storage account permissions and test RBAC scenarios
# Context: AZ-104 Lab - Storage Explorer permission troubleshooting
# Author: Greg Tate
# Date: 2026-02-07
# -------------------------------------------------------------------------

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupName = "az104-storage-storage-explorer-permissions-tf",

    [Parameter(Mandatory = $false)]
    [string]$UserPrincipalName,

    [Parameter(Mandatory = $false)]
    [ValidateSet('StorageBlobDataReader', 'StorageBlobDataContributor', 'Reader', 'Contributor')]
    [string]$RoleToAssign
)

$Main = {
    Write-Host "`n=== Storage Explorer Permissions Test ===" -ForegroundColor Cyan

    # Get storage accounts in the resource group
    Write-Host "`nRetrieving storage accounts in resource group: $ResourceGroupName" -ForegroundColor Yellow
    $storageAccounts = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName

    if ($storageAccounts.Count -eq 0) {
        Write-Host "No storage accounts found. Please deploy the lab first." -ForegroundColor Red
        return
    }

    # Display storage accounts
    Write-Host "`nStorage Accounts:" -ForegroundColor Green
    foreach ($sa in $storageAccounts) {
        Write-Host "  - $($sa.StorageAccountName)" -ForegroundColor White

        # Check for resource locks
        $locks = Get-AzResourceLock -ResourceName $sa.StorageAccountName -ResourceType "Microsoft.Storage/storageAccounts" -ResourceGroupName $ResourceGroupName
        if ($locks) {
            foreach ($lock in $locks) {
                Write-Host "    Lock: $($lock.Properties.level) - $($lock.Properties.notes)" -ForegroundColor Magenta
            }
        }
    }

    # Test key listing capability
    Write-Host "`n=== Testing Account Key Listing ===" -ForegroundColor Cyan
    foreach ($sa in $storageAccounts) {
        Write-Host "`nTesting: $($sa.StorageAccountName)" -ForegroundColor Yellow

        try {
            $keys = Get-AzStorageAccountKey `
                -ResourceGroupName $ResourceGroupName `
                -Name $sa.StorageAccountName `
                -ErrorAction Stop

            Write-Host "  ✓ Successfully listed account keys" -ForegroundColor Green
        }
        catch {
            Write-Host "  ✗ Failed to list account keys: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    # Assign role if requested
    if ($UserPrincipalName -and $RoleToAssign) {
        Write-Host "`n=== Assigning RBAC Role ===" -ForegroundColor Cyan

        $user = Get-AzADUser -UserPrincipalName $UserPrincipalName
        if (-not $user) {
            Write-Host "User not found: $UserPrincipalName" -ForegroundColor Red
            return
        }

        # Get the first storage account
        $sa = $storageAccounts[0]

        Write-Host "Assigning role '$RoleToAssign' to '$UserPrincipalName' on storage account '$($sa.StorageAccountName)'" -ForegroundColor Yellow

        try {
            New-AzRoleAssignment `
                -ObjectId $user.Id `
                -RoleDefinitionName $RoleToAssign `
                -Scope $sa.Id `
                -ErrorAction Stop

            Write-Host "  ✓ Role assignment successful" -ForegroundColor Green
            Write-Host "`n  Test this user in Azure Storage Explorer:" -ForegroundColor Cyan
            Write-Host "    1. Open Azure Storage Explorer" -ForegroundColor White
            Write-Host "    2. Sign in as $UserPrincipalName" -ForegroundColor White
            Write-Host "    3. Try to browse $($sa.StorageAccountName)" -ForegroundColor White
            Write-Host "    4. Observe the permission behavior" -ForegroundColor White
        }
        catch {
            Write-Host "  ✗ Role assignment failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    # Display exam scenario explanation
    Write-Host "`n=== Exam Scenario Analysis ===" -ForegroundColor Cyan
    Write-Host @"

Storage Explorer Error: "Unable to list resources in account due to inadequate permissions"

Two main reasons for this error:

1. Storage Blob Data Reader/Contributor Role ONLY
   - These are data plane roles (Azure RBAC for data access)
   - They do NOT grant permission to list account keys
   - Storage Explorer tries to use account keys by default
   - Solution: User needs Reader role (management plane) OR use Azure AD auth in Storage Explorer

2. ReadOnly Resource Lock
   - Prevents the listKeys operation (POST action)
   - Storage Explorer cannot retrieve account keys
   - Solution: Remove the ReadOnly lock OR use Azure AD auth

Note: CanNotDelete lock does NOT prevent key listing
      It only prevents resource deletion

"@ -ForegroundColor White

    Write-Host "=== Test Complete ===" -ForegroundColor Cyan
}

# Execute main function
& $Main
