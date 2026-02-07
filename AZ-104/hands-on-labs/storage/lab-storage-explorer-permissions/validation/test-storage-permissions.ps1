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
    [ValidateSet('Storage Blob Data Reader', 'Storage Blob Data Contributor', 'Read', 'Reader', 'Contributor')]
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
            Write-Host "`n  Tes			.\test-storage-permissions.ps1 `
				-ResourceGroupName az104-storage-storage-explorer-permissions-tf `
				-UserPrincipalName IsaiahL@637djb.onmicrosoft.com `
				-RoleToAssign "Storage Blob Data Reader"				.\test-storage-permissions.ps1 `
					-ResourceGroupName az104-storage-storage-explorer-permissions-tf `
					-UserPrincipalName IsaiahL@637djb.onmicrosoft.com `
					-RoleToAssign "Storage Blob Data Reader"t this user in Azure Storage Explorer:" -ForegroundColor Cyan
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

Two correct reasons for this error:

1. Read Role (Management Plane Only)
   - Provides management plane access (can see containers)
   - Does NOT provide data plane access (cannot browse contents)
   - User can see the storage account exists but cannot access blob data
   - Solution: Add Storage Blob Data Reader/Contributor role OR use full Contributor role

2. ReadOnly Resource Lock
   - Prevents the listKeys operation (POST action)
   - Storage Explorer cannot retrieve account keys
   - Solution: Remove the ReadOnly lock OR use Azure AD auth

Common misconceptions (INCORRECT answers):

✗ Storage Blob Data Reader/Contributor roles - Users with these roles CAN browse contents
   - These are data plane roles that provide direct blob access
   - They work with Azure AD authentication in Storage Explorer

✗ CanNotDelete lock - Does NOT prevent Storage Explorer access
   - Only prevents resource deletion
   - Does not block listKeys operation

"@ -ForegroundColor White

    Write-Host "=== Test Complete ===" -ForegroundColor Cyan
}

# Execute main function
& $Main
