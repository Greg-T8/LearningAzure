# Path to the JSON array of users (each object is a full Graph /users payload)
$usersFile = ".\AzCliUsers.json"

if (-not (Test-Path $usersFile)) {
    throw "Users file not found: $usersFile"
}

# Read & parse the file
try {
    $users = Get-Content -Path $usersFile -Raw | ConvertFrom-Json
} catch {
    throw "Failed to parse $usersFile as JSON. $_"
}

# Normalize to an array even if a single object was provided
if ($null -eq $users) { throw "No users found in $usersFile." }
if ($users -isnot [System.Collections.IEnumerable] -or $users -is [string]) {
    $users = @($users)
}

$success = @()
$failed  = @()

Write-Host "Processing $($users.Count) user(s) from $usersFile ..." -ForegroundColor Cyan

# Optional: quick validation of required fields (adjust as needed)
$required = @("accountEnabled","displayName","userPrincipalName","mailNickname","passwordProfile")
$idx = 0
foreach ($u in $users) {
    $idx++

    # Simple field presence check
    $missing = @()
    foreach ($r in $required) {
        if (-not ($u.PSObject.Properties.Name -contains $r)) {
            $missing += $r
        }
    }
    if ($missing.Count -gt 0) {
        $failed += [pscustomobject]@{
            Index = $idx
            UPN   = $u.userPrincipalName
            Error = "Missing required field(s): $($missing -join ', ')"
        }
        Write-Warning "[$idx] Skipping $($u.userPrincipalName): missing $($missing -join ', ')"
        continue
    }

    # Compress to single-line JSON for Graph
    $json = $u | ConvertTo-Json -Depth 10 -Compress

    # Write to a unique temp file (UTF-8, no BOM)
    $tempPath = Join-Path ([System.IO.Path]::GetTempPath()) ("user-" + [guid]::NewGuid().ToString() + ".json")
    Set-Content -Path $tempPath -Value $json -Encoding utf8

    $exit = 0
    $resp = $null
    try {
        # Use --url and quote the @file path so PowerShell doesn't treat @" as here-string
        $resp = az rest `
            --method post `
            --url "https://graph.microsoft.com/v1.0/users" `
            --headers "Content-Type=application/json" `
            --body "@$tempPath"

        $exit = $LASTEXITCODE
    }
    finally {
        # Always clean up temp file
        if (Test-Path $tempPath) {
            Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
        }
    }

    if ($exit -eq 0) {
        $success += [pscustomobject]@{
            Index = $idx
            UPN   = $u.userPrincipalName
            Note  = "Created"
        }
        Write-Host "[$idx] Created: $($u.userPrincipalName)" -ForegroundColor Green
    }
    else {
        # Capture CLI text output as the error detail
        $errText = if ($resp) { [string]$resp } else { "az rest exited with code $exit" }
        $failed += [pscustomobject]@{
            Index = $idx
            UPN   = $u.userPrincipalName
            Error = $errText
        }
        Write-Host "[$idx] Failed: $($u.userPrincipalName) ($exit)" -ForegroundColor Red
    }
}

# Summary
Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Succeeded: $($success.Count)"
Write-Host "  Failed   : $($failed.Count)"

if ($success.Count -gt 0) {
    $success | Format-Table -AutoSize
}
if ($failed.Count -gt 0) {
    Write-Host "`nFailures:" -ForegroundColor Yellow
    $failed | Format-Table -Wrap -AutoSize
}

# If you want the script to fail the run/CI when any user fails, uncomment:
# if ($failed.Count -gt 0) { throw "$($failed.Count) user(s) failed to create." }
