<#
.SYNOPSIS
Find and remove broken (404) external links from markdown files.

.DESCRIPTION
Scans all markdown files under the workspace certs/ directory, extracts
external HTTP/HTTPS URLs from markdown link syntax [text](url), checks
each unique URL for a 404 response, and removes the lines that contain
only a broken reference link. Supports -WhatIf preview mode and
configurable concurrency throttling to avoid rate-limiting.

.CONTEXT
LearningAzure repository — content quality and link hygiene.

.AUTHOR
Greg Tate

.NOTES
Program: Resolve-BrokenLink.ps1
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [string]$Path,

    [Parameter()]
    [int]$ThrottleDelayMs = 500
)

# Configuration
$LinkPattern = '\[([^\]]+)\]\((https?://[^\s\)]+)\)'
$BulletPattern = '^\s*[-\*]\s+\[.*\]\(https?://.*\)\s*$'
$UserAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) LearningAzure-LinkChecker/1.0'

$Main = {
    . $Helpers

    $repoRoot = Get-RepoRoot
    $mdFiles = Get-MarkdownFile -Root $repoRoot
    $urlMap = Get-ExternalUrl -MarkdownFiles $mdFiles
    $brokenUrls = Find-BrokenUrl -UrlMap $urlMap
    Remove-BrokenLine -BrokenUrls $brokenUrls -UrlMap $urlMap -RepoRoot $repoRoot
    Show-Summary -BrokenUrls $brokenUrls -UrlMap $urlMap
}

#region HELPER FUNCTIONS
$Helpers = {
    function Get-RepoRoot {
        # Resolve the workspace root from the -Path parameter or default to Git root
        if ($Path) {
            return (Resolve-Path -Path $Path).Path
        }

        $gitRoot = & git -C $PSScriptRoot rev-parse --show-toplevel 2>$null

        if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($gitRoot)) {
            return (Resolve-Path -Path $gitRoot.Trim()).Path
        }

        return (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')).Path
    }

    function Get-MarkdownFile {
        # Collect all markdown files under the certs directory
        param(
            [Parameter(Mandatory)]
            [string]$Root
        )

        $certsDir = Join-Path -Path $Root -ChildPath 'certs'

        if (-not (Test-Path -Path $certsDir)) {
            Write-Warning "certs/ directory not found at: $certsDir"
            return @()
        }

        $files = Get-ChildItem -Path $certsDir -Filter '*.md' -Recurse -File
        Write-Host "Found $($files.Count) markdown files to scan." -ForegroundColor Cyan
        return $files
    }

    function Get-ExternalUrl {
        # Extract all external HTTP/HTTPS URLs and map each URL to the files/lines containing it
        param(
            [Parameter(Mandatory)]
            [AllowNull()]
            [AllowEmptyCollection()]
            [object[]]$MarkdownFiles
        )

        if (-not $MarkdownFiles) {
            return @{}
        }

        # Map: URL -> list of @{ File; LineNumber; LineText }
        $map = @{}

        foreach ($file in $MarkdownFiles) {
            $lines = Get-Content -Path $file.FullName -Encoding UTF8
            $lineNum = 0

            foreach ($line in $lines) {
                $lineNum++
                $linkMatches = [regex]::Matches($line, $LinkPattern)

                foreach ($m in $linkMatches) {
                    $url = $m.Groups[2].Value

                    if (-not $map.ContainsKey($url)) {
                        $map[$url] = [System.Collections.Generic.List[object]]::new()
                    }

                    $map[$url].Add(@{
                        File       = $file.FullName
                        LineNumber = $lineNum
                        LineText   = $line
                    })
                }
            }
        }

        $uniqueCount = $map.Count
        $totalRefs = ($map.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
        Write-Host "Found $uniqueCount unique external URLs ($totalRefs total references)." -ForegroundColor Cyan
        return $map
    }

    function Find-BrokenUrl {
        # Check each unique URL and return those that respond with 404
        param(
            [Parameter(Mandatory)]
            [hashtable]$UrlMap
        )

        if ($UrlMap.Count -eq 0) {
            return @()
        }

        $broken = [System.Collections.Generic.List[string]]::new()
        $checked = 0
        $total = $UrlMap.Count

        foreach ($url in $UrlMap.Keys) {
            $checked++
            Write-Progress -Activity 'Checking URLs' -Status "$checked / $total" -PercentComplete (($checked / $total) * 100)

            try {
                # Use HEAD first for efficiency; fall back to GET if HEAD is not allowed
                $null = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing `
                    -UserAgent $UserAgent -MaximumRedirection 5 -TimeoutSec 15 -ErrorAction Stop
            }
            catch {
                $statusCode = $_.Exception.Response.StatusCode.value__

                # Only treat explicit 404 as broken (not 403, 500, timeouts, etc.)
                if ($statusCode -eq 404) {
                    # Retry with GET in case the server rejects HEAD
                    try {
                        $null = Invoke-WebRequest -Uri $url -Method Get -UseBasicParsing `
                            -UserAgent $UserAgent -MaximumRedirection 5 -TimeoutSec 15 -ErrorAction Stop
                    }
                    catch {
                        $retryStatus = $_.Exception.Response.StatusCode.value__

                        if ($retryStatus -eq 404) {
                            Write-Host "  404: $url" -ForegroundColor Red
                            $broken.Add($url)
                        }
                        else {
                            Write-Verbose "  Non-404 on retry ($retryStatus): $url"
                        }
                    }
                }
                elseif ($statusCode -eq 405) {
                    # HEAD not allowed — retry with GET
                    try {
                        $null = Invoke-WebRequest -Uri $url -Method Get -UseBasicParsing `
                            -UserAgent $UserAgent -MaximumRedirection 5 -TimeoutSec 15 -ErrorAction Stop
                    }
                    catch {
                        $retryStatus = $_.Exception.Response.StatusCode.value__

                        if ($retryStatus -eq 404) {
                            Write-Host "  404: $url" -ForegroundColor Red
                            $broken.Add($url)
                        }
                    }
                }
                else {
                    Write-Verbose "  HTTP $statusCode (skipped): $url"
                }
            }

            # Throttle between requests
            if ($ThrottleDelayMs -gt 0) {
                Start-Sleep -Milliseconds $ThrottleDelayMs
            }
        }

        Write-Progress -Activity 'Checking URLs' -Completed
        return $broken.ToArray()
    }

    function Remove-BrokenLine {
        # Remove lines from files that contain only a broken-link reference bullet
        [CmdletBinding(SupportsShouldProcess)]
        param(
            [Parameter(Mandatory)]
            [AllowNull()]
            [AllowEmptyCollection()]
            [string[]]$BrokenUrls,

            [Parameter(Mandatory)]
            [hashtable]$UrlMap,

            [Parameter(Mandatory)]
            [string]$RepoRoot
        )

        if (-not $BrokenUrls -or $BrokenUrls.Count -eq 0) {
            Write-Host "`nNo broken links found." -ForegroundColor Green
            return
        }

        # Group removals by file to batch edits
        $fileEdits = @{}

        foreach ($url in $BrokenUrls) {
            foreach ($ref in $UrlMap[$url]) {
                $file = $ref.File
                $lineText = $ref.LineText

                # Only remove bullet-point reference lines (not inline body links)
                if ($lineText -match $BulletPattern) {
                    if (-not $fileEdits.ContainsKey($file)) {
                        $fileEdits[$file] = [System.Collections.Generic.HashSet[int]]::new()
                    }

                    [void]$fileEdits[$file].Add($ref.LineNumber)
                }
                else {
                    $relativePath = $file.Replace($RepoRoot, '').TrimStart('\', '/')
                    Write-Warning "Skipping inline link (not a standalone bullet) at ${relativePath}:$($ref.LineNumber)"
                }
            }
        }

        # Rewrite each affected file, omitting the broken-link lines
        foreach ($file in $fileEdits.Keys) {
            $linesToRemove = $fileEdits[$file]
            $relativePath = $file.Replace($RepoRoot, '').TrimStart('\', '/')

            if ($PSCmdlet.ShouldProcess($relativePath, "Remove $($linesToRemove.Count) broken link line(s)")) {
                $allLines = Get-Content -Path $file -Encoding UTF8
                $newLines = [System.Collections.Generic.List[string]]::new()
                $lineNum = 0

                foreach ($line in $allLines) {
                    $lineNum++

                    if (-not $linesToRemove.Contains($lineNum)) {
                        $newLines.Add($line)
                    }
                    else {
                        Write-Host "  Removed line $lineNum from $relativePath" -ForegroundColor Yellow
                    }
                }

                # Write file with UTF-8 no BOM
                [System.IO.File]::WriteAllLines($file, $newLines.ToArray(), [System.Text.UTF8Encoding]::new($false))
            }
        }
    }

    function Show-Summary {
        # Display a summary of broken links found and lines removed
        param(
            [Parameter(Mandatory)]
            [AllowNull()]
            [AllowEmptyCollection()]
            [string[]]$BrokenUrls,

            [Parameter(Mandatory)]
            [hashtable]$UrlMap
        )

        $totalChecked = $UrlMap.Count

        if (-not $BrokenUrls -or $BrokenUrls.Count -eq 0) {
            Write-Host "`nChecked $totalChecked URLs — all links are valid." -ForegroundColor Green
            return
        }

        $totalBroken = $BrokenUrls.Count
        $totalReferences = 0

        foreach ($url in $BrokenUrls) {
            $totalReferences += $UrlMap[$url].Count
        }

        Write-Host "`n--- Summary ---" -ForegroundColor Cyan
        Write-Host "URLs checked:     $totalChecked"
        Write-Host "Broken (404):     $totalBroken" -ForegroundColor Red
        Write-Host "Lines affected:   $totalReferences"
    }
}
#endregion

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
