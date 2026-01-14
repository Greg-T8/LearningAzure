# -------------------------------------------------------------------------
# Program: DeleteUsersAzCli.ps1
# Description: Delete (and optionally purge) Azure AD users listed in a JSON file
# Context: AZ-104 lab - setup identity baseline (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------

# Describe the script parameters used to control deletion and optional purge
param(
    [string]$UsersFile = '.\AzCliUsers.json',
    [switch]$Purge  # If set, also permanently delete from Deleted users
)

$Main = {
    # This block orchestrates the deletion process by reading user data from
    # a JSON file and removing users from Azure AD, with optional purging.

    # Dot-source the helper functions
    . $Helpers

    # Initialize process with validation and read the users from the JSON file
    $users = Initialize-UserDeletionProcess -UsersFilePath $UsersFile

    # Delete users and optionally purge them
    $results = Remove-AzureADUser -Users $users -Purge:$Purge

    # Display summary of the operation
    Show-OperationSummary -Results $results -Purge:$Purge
}

$Helpers = {
    function Initialize-UserDeletionProcess {
        param (
            [string]$UsersFilePath
        )

        # Check that the users file exists before proceeding
        if (-not (Test-Path $UsersFilePath)) {
            throw "Users file not found: $UsersFilePath"
        }

        # Attempt to load and parse the users JSON file into PowerShell objects
        try {
            $users = Get-Content -Path $UsersFilePath -Raw | ConvertFrom-Json
        }
        catch {
            throw "Failed to parse $UsersFilePath as JSON. $_"
        }

        # Normalize the parsed input so $users is always an array for iteration
        if ($null -eq $users) { throw "No users found in $UsersFilePath." }
        if ($users -isnot [System.Collections.IEnumerable] -or $users -is [string]) {
            $users = @($users)
        }

        Write-Host "Deleting $($users.Count) user(s) listed in $UsersFilePath ..." -ForegroundColor Cyan
        return $users
    }

    function Remove-AzureADUser {
        param (
            [array]$Users,
            [switch]$Purge
        )

        # Prepare collections to record outcomes for reporting
        $success = @()
        $failed  = @()
        $purged  = @()
        $purgeFailed = @()

        # Initialize loop index for reporting while iterating users
        $idx = 0

        # Iterate each user object from the input and attempt delete (and optional purge)
        foreach ($u in $Users) {
            $idx++
            $upn = $u.userPrincipalName

            # Validate that a userPrincipalName is present before attempting delete
            if (-not $upn) {
                $failed += [pscustomobject]@{ Index=$idx; UPN=$null; Error='Missing userPrincipalName' }
                Write-Warning "[$idx] Skipping: missing userPrincipalName"
                continue
            }

            # Perform the soft delete via Graph
            $code, $out = Remove-SingleAzureADUser -Upn $upn

            if ($code -eq 0) {
                $success += [pscustomobject]@{ Index=$idx; UPN=$upn; Note='Deleted (soft)' }
                Write-Host "[$idx] Deleted (soft): $upn" -ForegroundColor Green

                # If purge requested, attempt to locate the deleted user and permanently remove it
                if ($Purge) {
                    Start-Sleep -Seconds 2  # small delay so object appears in DeletedUsers
                    $deletedId = Get-DeletedUserId -Upn $upn

                    if ($deletedId) {
                        $pcode, $pout = Remove-DeletedAzureADUser -DeletedUserId $deletedId

                        if ($pcode -eq 0) {
                            $purged += [pscustomobject]@{ Index=$idx; UPN=$upn; DeletedId=$deletedId; Note='Purged' }
                            Write-Host "[$idx] Purged:     $upn  (id: $deletedId)" -ForegroundColor Yellow
                        }
                        else {
                            $purgeFailed += [pscustomobject]@{ Index=$idx; UPN=$upn; DeletedId=$deletedId; Error=[string]$pout }
                            Write-Host "[$idx] Purge failed: $upn" -ForegroundColor Red
                        }
                    }
                    else {
                        $purgeFailed += [pscustomobject]@{ Index=$idx; UPN=$upn; DeletedId=$null; Error='Deleted user not found in directory/deletedItems' }
                        Write-Host "[$idx] Purge lookup failed (not found in Deleted users): $upn" -ForegroundColor Red
                    }
                }
            }
            else {
                # Record deletion failure and capture CLI output for diagnostics
                $failed += [pscustomobject]@{ Index=$idx; UPN=$upn; Error=([string]$out | ForEach-Object { $_ }) }
                Write-Host "[$idx] Delete failed: $upn  (exit $code)" -ForegroundColor Red
            }
        }

        return @{
            Success = $success
            Failed = $failed
            Purged = $purged
            PurgeFailed = $purgeFailed
        }
    }

    function Remove-SingleAzureADUser {
        param([string]$Upn)

        # URL-encode the UPN safely across PS versions/platforms
        $encoded = [uri]::EscapeDataString($Upn)

        $resp = az rest `
            --method delete `
            --url "https://graph.microsoft.com/v1.0/users/$encoded" `
            --headers 'Accept=application/json'

        return $LASTEXITCODE, $resp
    }

    function Get-DeletedUserId {
        param([string]$Upn)

        # Query deleted users and find a match client-side (stable & simple)
        $list = az rest `
            --method get `
            --url 'https://graph.microsoft.com/v1.0/directory/deletedItems/microsoft.graph.user' `
            --headers 'Accept=application/json'

        if ($LASTEXITCODE -ne 0 -or -not $list) { return $null }

        try {
            $obj = $list | ConvertFrom-Json
            $match = $obj.value | Where-Object { $_.userPrincipalName -eq $Upn }
            return $match.id
        }
        catch {
            return $null
        }
    }

    function Remove-DeletedAzureADUser {
        param([string]$DeletedUserId)

        if (-not $DeletedUserId) { return 1, 'No deleted user id' }

        $resp = az rest `
            --method delete `
            --url "https://graph.microsoft.com/v1.0/directory/deletedItems/$DeletedUserId" `
            --headers 'Accept=application/json'

        return $LASTEXITCODE, $resp
    }

    function Show-OperationSummary {
        param(
            [hashtable]$Results,
            [switch]$Purge
        )

        # Print a concise summary of results
        Write-Host ''
        Write-Host 'Summary:' -ForegroundColor Cyan
        Write-Host "  Deleted (soft): $($Results.Success.Count)"

        if ($Purge) {
            Write-Host "  Purged        : $($Results.Purged.Count)"
            Write-Host "  Purge failed  : $($Results.PurgeFailed.Count)"
        }

        Write-Host "  Delete failed : $($Results.Failed.Count)"

        # Display tables of results where applicable for operator review
        if ($Results.Success.Count -gt 0) {
            $Results.Success | Format-Table -AutoSize
        }

        if ($Purge -and $Results.Purged.Count -gt 0) {
            "`nPurged:" | Write-Host -ForegroundColor Yellow
            $Results.Purged | Format-Table -AutoSize
        }

        if ($Results.Failed.Count -gt 0) {
            "`nFailures:" | Write-Host -ForegroundColor Yellow
            $Results.Failed | Format-Table -Wrap -AutoSize
        }

        if ($Purge -and $Results.PurgeFailed.Count -gt 0) {
            "`nPurge Failures:" | Write-Host -ForegroundColor Yellow
            $Results.PurgeFailed | Format-Table -Wrap -AutoSize
        }

        # Uncomment to fail CI if any delete/purge failed:
        # if ($Results.Failed.Count -gt 0 -or ($Purge -and $Results.PurgeFailed.Count -gt 0)) { throw "One or more operations failed." }
    }
}

# Execute the main script block
try {
    Push-Location $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}