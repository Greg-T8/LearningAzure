<#
.SYNOPSIS
Insert blank entries for days with no study activity.

.DESCRIPTION
Scans the StudyLog.md for each active exam and identifies date gaps across
the full range of recorded entries (and through yesterday). For each missing
day — whether between existing rows or after the latest entry — inserts a
blank row with only the date populated (no session number). Renumbers actual
study sessions sequentially so the index tracks real sessions only. This
ensures the study log reflects days off (e.g., travel, breaks) rather than
hiding them.

Designed to run as a step in the content-maintenance pipeline or standalone.

.CONTEXT
LearningAzure repository — study log gap-fill maintenance.

.AUTHOR
Greg Tate

.NOTES
Program: Update-StudyLogGaps.ps1
#>

[CmdletBinding(SupportsShouldProcess)]
param()

# Configuration
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
$GetActiveExamScript = Join-Path -Path $PSScriptRoot -ChildPath 'Get-ActiveExam.ps1'

$Main = {
    . $Helpers

    # Discover active exams from the certifications table
    $activeExams = & $GetActiveExamScript

    if (-not $activeExams) {
        Write-Host 'No active exams found — skipping study log gap fill.'
        return
    }

    # Fill date gaps in each active exam's study log
    foreach ($exam in $activeExams) {
        Update-StudyLogGap -Exam $exam
    }
}

#region HELPER FUNCTIONS
$Helpers = {
    function Update-StudyLogGap {
        # Scan the full date range for interior and trailing gaps, then insert blank entries
        param([Parameter(Mandatory)] [string]$Exam)

        $logFile = Join-Path -Path $RepoRoot -ChildPath "certs\$Exam\StudyLog.md"

        if (-not (Test-Path -Path $logFile)) {
            Write-Verbose "No StudyLog.md for $Exam — skipping."
            return
        }

        $lines = Get-Content -Path $logFile -Encoding UTF8

        # Find the header separator index (the |:-- row)
        $separatorIndex = $null
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^\|:') {
                $separatorIndex = $i
                break
            }
        }

        if ($null -eq $separatorIndex) {
            Write-Warning "Table header separator not found in $Exam StudyLog — skipping."
            return
        }

        # Collect data rows and their line indices (numbered sessions and blank gap rows)
        $dataRowIndices = [System.Collections.Generic.List[int]]::new()
        for ($i = $separatorIndex + 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^\|\s*(\d+)?\s*\|') {
                $dataRowIndices.Add($i)
            }
        }

        if ($dataRowIndices.Count -eq 0) {
            Write-Verbose "No session entries in $Exam StudyLog — skipping."
            return
        }

        # Parse dates from all data rows, classify each as gap or real session
        $recordedDates = [System.Collections.Generic.HashSet[string]]::new()
        $allDates = [System.Collections.Generic.List[datetime]]::new()
        $existingGapIndices = [System.Collections.Generic.HashSet[int]]::new()

        foreach ($idx in $dataRowIndices) {
            $cols = $lines[$idx] -split '\|'
            $dateStr = $cols[2].Trim()
            $parsed = [datetime]::ParseExact($dateStr, 'M/d/yy', $null).Date
            $allDates.Add($parsed)
            $null = $recordedDates.Add($dateStr)

            # Detect existing gap rows: all fields after Date are empty
            $dataFields = $cols[3..($cols.Count - 2)] | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }

            if ($dataFields.Count -eq 0) {
                $null = $existingGapIndices.Add($idx)
            }
        }

        # Determine the full gap range: earliest recorded date through max(latest, yesterday)
        $earliest = ($allDates | Measure-Object -Minimum).Minimum
        $latest   = ($allDates | Measure-Object -Maximum).Maximum
        $yesterday = (Get-Date).Date.AddDays(-1)
        $rangeEnd  = @($latest, $yesterday) | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum

        # Identify all missing dates within the range
        $gapDates = [System.Collections.Generic.List[datetime]]::new()
        $current = $earliest.AddDays(1)

        while ($current -le $rangeEnd) {
            $dateStr = $current.ToString('M/d/yy')

            if (-not $recordedDates.Contains($dateStr)) {
                $gapDates.Add($current)
            }

            $current = $current.AddDays(1)
        }

        # Check if any existing gap rows still have session numbers that need stripping
        $needsReformat = $false

        foreach ($idx in $existingGapIndices) {
            if ($lines[$idx] -match '^\|\s*\d+\s*\|') {
                $needsReformat = $true
                break
            }
        }

        if ($gapDates.Count -eq 0 -and -not $needsReformat) {
            Write-Verbose "$Exam study log has no date gaps."
            return
        }

        # Detect whether the log uses the extended format (Mode + Skill columns)
        $headerLine = $lines | Where-Object { $_ -match '^\|\s*#\s*\|' } | Select-Object -First 1
        $hasExtendedColumns = $headerLine -match '\|\s*Mode\s*\|'

        # Build a merged list of all rows (existing + gap) sorted by date descending
        $mergedRows = [System.Collections.Generic.List[PSCustomObject]]::new()

        # Add existing data rows, flagging gap rows by their empty data fields
        foreach ($idx in $dataRowIndices) {
            $cols = $lines[$idx] -split '\|'
            $dateStr = $cols[2].Trim()
            $parsed = [datetime]::ParseExact($dateStr, 'M/d/yy', $null).Date

            $mergedRows.Add([PSCustomObject]@{
                Date    = $parsed
                Content = $lines[$idx]
                IsGap   = $existingGapIndices.Contains($idx)
            })
        }

        # Add new gap rows with no session number (date-only placeholder)
        foreach ($gapDate in $gapDates) {
            $dateStr = $gapDate.ToString('M/d/yy')

            if ($hasExtendedColumns) {
                $blankRow = "|  | $dateStr |  |  |  |  |  |  |"
            }
            else {
                $blankRow = "|  | $dateStr |  |  |  |  |"
            }

            $mergedRows.Add([PSCustomObject]@{
                Date    = $gapDate
                Content = $blankRow
                IsGap   = $true
            })
        }

        # Sort by date descending (newest at top); existing rows keep original order within same date
        $sorted = $mergedRows | Sort-Object -Property @{ Expression = { $_.Date }; Descending = $true }, @{ Expression = { $_.IsGap }; Descending = $false }

        # Renumber actual sessions sequentially (1 = oldest, N = newest); leave gap rows unnumbered
        $renumbered = [System.Collections.Generic.List[string]]::new()
        $sessionCount = @($sorted | Where-Object { -not $_.IsGap }).Count
        $sessionNum = $sessionCount

        for ($i = 0; $i -lt $sorted.Count; $i++) {
            $entry = $sorted[$i]
            $row = $entry.Content

            if ($entry.IsGap) {
                # Strip any existing session number from gap rows
                $row = $row -replace '^\|\s*\d*\s*\|', '|  |'
                $renumbered.Add($row)
            }
            else {
                # Replace the session number column for actual study sessions
                $row = $row -replace '^\|\s*\d*\s*\|', "| $sessionNum |"
                $renumbered.Add($row)
                $sessionNum--
            }
        }

        # Build the action description for ShouldProcess
        $actions = [System.Collections.Generic.List[string]]::new()

        if ($gapDates.Count -gt 0) {
            $actions.Add("insert $($gapDates.Count) gap entries")
        }

        if ($needsReformat) {
            $actions.Add("strip session numbers from gap rows")
        }

        $actionDesc = $actions -join ' and '

        if ($PSCmdlet.ShouldProcess("$Exam StudyLog.md", "$actionDesc and renumber sessions")) {
            # Rebuild the file: header lines + renumbered data rows
            $updated = [System.Collections.Generic.List[string]]::new()
            $updated.AddRange([string[]]$lines[0..$separatorIndex])
            $updated.AddRange($renumbered)

            Set-Content -Path $logFile -Value $updated -Encoding UTF8
            Write-Host "  $Exam`: $actionDesc." -ForegroundColor Yellow
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
