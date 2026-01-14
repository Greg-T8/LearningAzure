# -------------------------------------------------------------------------
# Program: CreateUsersAzCli.ps1
# Description: Create Azure AD users from a JSON file using the Azure CLI (az rest).
# Context: AZ-104 lab - setup identity baseline (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------

$Main = {
    # This block orchestrates the user creation process by reading user data from
    # a JSON file and creating users in Azure AD using Microsoft Graph API.

    # Dot-source the helper functions
    . $Helpers

    $usersFile = ".\AzCliUsers.json"

    # Initialize process with validation and read the users from the JSON file
    $users = Initialize-UserCreationProcess -UsersFilePath $usersFile

    # Create users and collect results
    $results = New-AzureADUser -Users $users

    # Display summary of the operation
    Show-OperationSummary -Results $results
}

$Helpers = {
    function Initialize-UserCreationProcess {
        param (
            [string]$UsersFilePath
        )

        # Validate the existence of the users file
        if (-not (Test-Path $UsersFilePath)) {
            throw "Users file not found: $UsersFilePath"
        }

        # Read and parse the users file
        try {
            $users = Get-Content -Path $UsersFilePath -Raw | ConvertFrom-Json
        } catch {
            throw "Failed to parse $UsersFilePath as JSON. $_"
        }

        # Normalize to an array even if a single object was provided
        if ($null -eq $users) {
            throw "No users found in $UsersFilePath."
        }

        if ($users -isnot [System.Collections.IEnumerable] -or $users -is [string]) {
            $users = @($users)
        }

        Write-Host "Processing $($users.Count) user(s) from $UsersFilePath ..." -ForegroundColor Cyan
        return $users
    }

    function New-AzureADUser {
        param (
            [array]$Users
        )

        # Prepare success/failure collectors
        $success = @()
        $failed = @()

        # Required fields for user creation
        $required = @("accountEnabled","displayName","userPrincipalName","mailNickname","passwordProfile")
        $idx = 0

        # Process each user
        foreach ($u in $Users) {
            $idx++

            # Validate required fields
            $result = Confirm-UserObject -UserObject $u -RequiredFields $required -Index $idx

            if ($result.IsValid -eq $false) {
                $failed += $result.ValidationResult
                Write-Warning "[$idx] Skipping $($u.userPrincipalName): missing $($result.MissingFields -join ', ')"
                continue
            }

            # Create the user in Azure AD
            $createResult = New-SingleAzureADUser -UserObject $u -Index $idx

            if ($createResult.Success) {
                $success += $createResult.Result
                Write-Host "[$idx] Created: $($u.userPrincipalName)" -ForegroundColor Green
            } else {
                $failed += $createResult.Result
                Write-Host "[$idx] Failed: $($u.userPrincipalName) ($($createResult.ExitCode))" -ForegroundColor Red
            }
        }

        return @{
            Success = $success
            Failed = $failed
        }
    }

    function Confirm-UserObject {
        param (
            $UserObject,
            [array]$RequiredFields,
            [int]$Index
        )

        # Check for missing required fields
        $missing = @()
        foreach ($r in $RequiredFields) {
            if (-not ($UserObject.PSObject.Properties.Name -contains $r)) {
                $missing += $r
            }
        }

        # Return validation result
        if ($missing.Count -gt 0) {
            return @{
                IsValid = $false
                ValidationResult = [pscustomobject]@{
                    Index = $Index
                    UPN = $UserObject.userPrincipalName
                    Error = "Missing required field(s): $($missing -join ', ')"
                }
                MissingFields = $missing
            }
        } else {
            return @{
                IsValid = $true
            }
        }
    }

    function New-SingleAzureADUser {
        param (
            $UserObject,
            [int]$Index
        )

        # Compress to single-line JSON for Graph
        $json = $UserObject | ConvertTo-Json -Depth 10 -Compress

        # Write to a unique temp file (UTF-8, no BOM)
        $tempPath = Join-Path ([System.IO.Path]::GetTempPath()) ("user-" + [guid]::NewGuid().ToString() + ".json")
        Set-Content -Path $tempPath -Value $json -Encoding utf8

        $exit = 0
        $resp = $null

        try {
            # Call Microsoft Graph via az rest to create the user
            $resp = az rest `
                --method post `
                --url "https://graph.microsoft.com/v1.0/users" `
                --headers "Content-Type=application/json" `
                --body "@$tempPath"

            $exit = $LASTEXITCODE
        }
        finally {
            # Clean up temp file
            if (Test-Path $tempPath) {
                Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
            }
        }

        # Create result object based on operation outcome
        if ($exit -eq 0) {
            return @{
                Success = $true
                Result = [pscustomobject]@{
                    Index = $Index
                    UPN = $UserObject.userPrincipalName
                    Note = "Created"
                }
                ExitCode = $exit
            }
        } else {
            $errText = if ($resp) { [string]$resp } else { "az rest exited with code $exit" }
            return @{
                Success = $false
                Result = [pscustomobject]@{
                    Index = $Index
                    UPN = $UserObject.userPrincipalName
                    Error = $errText
                }
                ExitCode = $exit
            }
        }
    }

    function Show-OperationSummary {
        param (
            [hashtable]$Results
        )

        # Display summary counts
        Write-Host ""
        Write-Host "Summary:" -ForegroundColor Cyan
        Write-Host "  Succeeded: $($Results.Success.Count)"
        Write-Host "  Failed   : $($Results.Failed.Count)"

        # Display successful operations
        if ($Results.Success.Count -gt 0) {
            $Results.Success | Format-Table -AutoSize
        }

        # Display failures with details
        if ($Results.Failed.Count -gt 0) {
            Write-Host "`nFailures:" -ForegroundColor Yellow
            $Results.Failed | Format-Table -Wrap -AutoSize
        }

        # Uncomment to throw an error if any operations failed
        # if ($Results.Failed.Count -gt 0) { throw "$($Results.Failed.Count) user(s) failed to create." }
    }
}

try {
    # Ensure script runs with its own directory as the current location
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    # Restore the original working directory even if an error occurred
    Pop-Location
}
