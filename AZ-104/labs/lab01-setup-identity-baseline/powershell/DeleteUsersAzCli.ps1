param(
    [string]$UsersFile = ".\AzCliUsers.json",
    [switch]$Purge  # If set, also permanently delete from Deleted users
)

if (-not (Test-Path $UsersFile)) {
    throw "Users file not found: $UsersFile"
}

# Load users from file (expects an array of user objects with userPrincipalName)
try {
    $users = Get-Content -Path $UsersFile -Raw | ConvertFrom-Json
} catch {
    throw "Failed to parse $UsersFile as JSON. $_"
}

# Normalize to array
if ($null -eq $users) { throw "No users found in $UsersFile." }
if ($users -isnot [System.Collections.IEnumerable] -or $users -is [string]) {
    $users = @($users)
}

Write-Host "Deleting $($users.Count) user(s) listed in $UsersFile ..." -ForegroundColor Cyan

$success = @()
$failed  = @()
$purged  = @()
$purgeFailed = @()

function Invoke-AzDeleteUser {
    param([string]$Upn)

    # URL-encode the UPN safely across PS versions/platforms
    $encoded = [uri]::EscapeDataString($Upn)

    $resp = az rest `
        --method delete `
        --url "https://graph.microsoft.com/v1.0/users/$encoded" `
        --headers "Accept=application/json"

    return $LASTEXITCODE, $resp
}

function Get-DeletedUserId {
    param([string]$Upn)

    # Query deleted users and find a match client-side (stable & simple)
    $list = az rest `
        --method get `
        --url "https://graph.microsoft.com/v1.0/directory/deletedItems/microsoft.graph.user" `
        --headers "Accept=application/json"

    if ($LASTEXITCODE -ne 0 -or -not $list) { return $null }

    try {
        $obj = $list | ConvertFrom-Json
        $match = $obj.value | Where-Object { $_.userPrincipalName -eq $Upn }
        return $match.id
    } catch {
        return $null
    }
}

function Invoke-AzPurgeDeletedUser {
    param([string]$DeletedUserId)

    if (-not $DeletedUserId) { return 1, "No deleted user id" }

    $resp = az rest `
        --method delete `
        --url "https://graph.microsoft.com/v1.0/directory/deletedItems/$DeletedUserId" `
        --headers "Accept=application/json"

    return $LASTEXITCODE, $resp
}

$idx = 0
foreach ($u in $users) {
    $idx++
    $upn = $u.userPrincipalName
    if (-not $upn) {
        $failed += [pscustomobject]@{ Index=$idx; UPN=$null; Error="Missing userPrincipalName" }
        Write-Warning "[$idx] Skipping: missing userPrincipalName"
        continue
    }

    # Delete user (soft delete to 'Deleted users')
    $code, $out = Invoke-AzDeleteUser -Upn $upn
    if ($code -eq 0) {
        $success += [pscustomobject]@{ Index=$idx; UPN=$upn; Note="Deleted (soft)" }
        Write-Host "[$idx] Deleted (soft): $upn" -ForegroundColor Green

        if ($Purge) {
            Start-Sleep -Seconds 2  # small delay so object appears in DeletedUsers
            $deletedId = Get-DeletedUserId -Upn $upn
            if ($deletedId) {
                $pcode, $pout = Invoke-AzPurgeDeletedUser -DeletedUserId $deletedId
                if ($pcode -eq 0) {
                    $purged += [pscustomobject]@{ Index=$idx; UPN=$upn; DeletedId=$deletedId; Note="Purged" }
                    Write-Host "[$idx] Purged:     $upn  (id: $deletedId)" -ForegroundColor Yellow
                } else {
                    $purgeFailed += [pscustomobject]@{ Index=$idx; UPN=$upn; DeletedId=$deletedId; Error=[string]$pout }
                    Write-Host "[$idx] Purge failed: $upn" -ForegroundColor Red
                }
            } else {
                $purgeFailed += [pscustomobject]@{ Index=$idx; UPN=$upn; DeletedId=$null; Error="Deleted user not found in directory/deletedItems" }
                Write-Host "[$idx] Purge lookup failed (not found in Deleted users): $upn" -ForegroundColor Red
            }
        }
    }
    else {
        $failed += [pscustomobject]@{ Index=$idx; UPN=$upn; Error=([string]$out | ForEach-Object { $_ }) }
        Write-Host "[$idx] Delete failed: $upn  (exit $code)" -ForegroundColor Red
    }
}

# Summary
Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Deleted (soft): $($success.Count)"
if ($Purge) {
    Write-Host "  Purged        : $($purged.Count)"
    Write-Host "  Purge failed  : $($purgeFailed.Count)"
}
Write-Host "  Delete failed : $($failed.Count)"

if ($success.Count -gt 0) {
    $success | Format-Table -AutoSize
}
if ($Purge -and $purged.Count -gt 0) {
    "`nPurged:" | Write-Host -ForegroundColor Yellow
    $purged | Format-Table -AutoSize
}
if ($failed.Count -gt 0) {
    "`nFailures:" | Write-Host -ForegroundColor Yellow
    $failed | Format-Table -Wrap -AutoSize
}
if ($Purge -and $purgeFailed.Count -gt 0) {
    "`nPurge Failures:" | Write-Host -ForegroundColor Yellow
    $purgeFailed | Format-Table -Wrap -AutoSize
}

# Uncomment to fail CI if any delete/purge failed:
# if ($failed.Count -gt 0 -or ($Purge -and $purgeFailed.Count -gt 0)) { throw "One or more operations failed." }
