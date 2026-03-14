<#
.SYNOPSIS
Update the Days column in exam README progress trackers.

.DESCRIPTION
Scans each exam README for a progress tracker table and updates the Days
column for in-progress (🚧) items. Calculates days elapsed from the Started
date to today. Completed (✅) and not-started (🕒) items are skipped.
Automatically discovers exam READMEs that contain progress tracker tables.

.CONTEXT
LearningAzure repository — exam progress tracking.

.AUTHOR
Greg Tate

.NOTES
Program: Update-ProgressTrackerDays.ps1
#>

[CmdletBinding(SupportsShouldProcess)]
param()

# Configuration
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
$TrackerHeaderPattern = '^\|\s*Priority\s*\|.*Status.*Started.*Completed.*Days\s*\|'

$Main = {
    . $Helpers

    # Discover exam READMEs with progress tracker tables
    $readmeFiles = Find-ProgressTrackerReadme

    $updatedCount = 0

    # Update the Days column for each exam's in-progress items
    foreach ($readme in $readmeFiles) {
        $result = Update-ProgressTrackerDay -ReadmePath $readme
        $updatedCount += $result
    }

    Show-Summary -UpdatedCount $updatedCount
}

#region HELPER FUNCTIONS
$Helpers = {

    function Find-ProgressTrackerReadme {
        # Scan certs/ directories for README.md files containing a progress tracker table
        $results = [System.Collections.Generic.List[string]]::new()

        $certsDir = Join-Path -Path $RepoRoot -ChildPath 'certs'
        $dirs = Get-ChildItem -Path $certsDir -Directory |
            Where-Object { $_.Name -notmatch '^\.' }

        foreach ($dir in $dirs) {
            $readme = Join-Path -Path $dir.FullName -ChildPath 'README.md'

            if (-not (Test-Path -Path $readme)) { continue }

            # Check if the file contains a progress tracker header
            $hasTracker = Select-String -Path $readme -Pattern $TrackerHeaderPattern -Quiet

            if ($hasTracker) {
                $results.Add($readme)
                Write-Verbose "Found progress tracker in $($dir.Name)/README.md"
            }
        }

        if ($results.Count -eq 0) {
            Write-Host 'No progress tracker tables found in any exam README.' -ForegroundColor Yellow
        }

        return $results
    }

    function Update-ProgressTrackerDay {
        # Parse the progress tracker table and update Days for in-progress items
        param(
            [Parameter(Mandatory)]
            [string]$ReadmePath
        )

        $examName = Split-Path -Path (Split-Path -Path $ReadmePath -Parent) -Leaf
        $lines = Get-Content -Path $ReadmePath -Encoding UTF8
        $today = (Get-Date).Date
        $updated = 0
        $inTracker = $false
        $modified = $false

        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]

            # Detect the progress tracker header row
            if ($line -match $TrackerHeaderPattern) {
                $inTracker = $true
                continue
            }

            # Skip the separator row
            if ($inTracker -and $line -match '^\|\s*:?-') {
                continue
            }

            # Exit tracker when we hit a non-table line
            if ($inTracker -and $line -notmatch '^\|') {
                $inTracker = $false
                continue
            }

            if (-not $inTracker) { continue }

            # Split into cells: [0]='' [1]=Priority [2]=Modality ... [4]=Status [5]=Started [6]=Completed [7]=Days [8]=''
            $cells = $line -split '\|'

            if ($cells.Count -lt 9) { continue }

            $status = $cells[4].Trim()
            $started = $cells[5].Trim()
            $modality = $cells[2].Trim()

            # Skip completed items
            if ($status -match '✅') { continue }

            # Skip non-in-progress items
            if ($status -notmatch '🚧') { continue }

            # Skip if no start date
            if ([string]::IsNullOrWhiteSpace($started)) { continue }

            # Parse the start date
            [datetime]$startDate = [datetime]::MinValue
            [string[]]$dateFormats = @('M/d/yy', 'M/dd/yy', 'MM/d/yy', 'MM/dd/yy')
            $culture = [System.Globalization.CultureInfo]::InvariantCulture
            $style = [System.Globalization.DateTimeStyles]::None

            if (-not [datetime]::TryParseExact($started, $dateFormats, $culture, $style, [ref]$startDate)) {
                Write-Warning "$examName — Could not parse start date: '$started'"
                continue
            }

            # Calculate elapsed days
            $elapsed = [math]::Floor(($today - $startDate).TotalDays)

            # Only update if the value changed
            $currentDays = $cells[7].Trim()

            if ($currentDays -eq "$elapsed") { continue }

            # Find the Days cell boundaries by counting pipe characters
            $pipeCount = 0
            $daysCellStart = -1
            $daysCellEnd = -1

            for ($j = 0; $j -lt $line.Length; $j++) {
                if ($line[$j] -eq '|') {
                    $pipeCount++

                    if ($pipeCount -eq 7) { $daysCellStart = $j + 1 }
                    if ($pipeCount -eq 8) { $daysCellEnd = $j; break }
                }
            }

            if ($daysCellStart -lt 0 -or $daysCellEnd -lt 0) { continue }

            # Replace only the Days cell content
            $newLine = $line.Substring(0, $daysCellStart) + " $elapsed " + $line.Substring($daysCellEnd)

            if ($PSCmdlet.ShouldProcess("$examName — $modality", "Update Days from '$currentDays' to $elapsed")) {
                $lines[$i] = $newLine
                $modified = $true
                $updated++
                Write-Verbose "$examName — ${modality}: Days updated to $elapsed"
            }
        }

        # Write back only if changes were made
        if ($modified) {
            Set-Content -Path $ReadmePath -Value $lines -Encoding UTF8
        }

        return $updated
    }

    function Show-Summary {
        # Display the number of progress tracker rows updated
        param(
            [int]$UpdatedCount
        )

        if ($UpdatedCount -eq 0) {
            Write-Host 'No progress tracker days needed updating.' -ForegroundColor Yellow
        }
        else {
            Write-Host "$UpdatedCount progress tracker row(s) updated." -ForegroundColor Green
        }
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
