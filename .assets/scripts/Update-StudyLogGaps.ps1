<#
.SYNOPSIS
Insert zero-hour entries for days with no study activity.

.DESCRIPTION
Scans the StudyLog.md for each active exam and identifies date gaps between
the most recent recorded entry and yesterday. For each missing day, inserts
a zero-hour session row with blank Start, End, and Notes fields. This ensures
the study log reflects days off (e.g., travel, breaks) rather than hiding them.

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
        # Check for date gaps in an exam's study log and insert zero-hour entries
        param([Parameter(Mandatory)] [string]$Exam)

        $logFile = Join-Path -Path $RepoRoot -ChildPath "certs\$Exam\StudyLog.md"

        if (-not (Test-Path -Path $logFile)) {
            Write-Verbose "No StudyLog.md for $Exam — skipping."
            return
        }

        $lines = Get-Content -Path $logFile -Encoding UTF8

        # Collect all data rows from the table
        $dataRows = @($lines | Where-Object { $_ -match '^\|\s*\d+\s*\|' })

        if ($dataRows.Count -eq 0) {
            Write-Verbose "No session entries in $Exam StudyLog — skipping."
            return
        }

        # Parse the most recent date from the first data row (newest entry)
        $latestRow = $dataRows[0]
        $columns = $latestRow -split '\|'
        $latestDateStr = $columns[2].Trim()
        $latestDate = [datetime]::ParseExact($latestDateStr, 'M/d/yy', $null).Date

        # Determine the gap range: day after latest entry through yesterday
        $yesterday = (Get-Date).Date.AddDays(-1)

        if ($latestDate -ge $yesterday) {
            Write-Verbose "$Exam study log is current — no gaps to fill."
            return
        }

        # Collect all recorded dates for duplicate checking
        $recordedDates = [System.Collections.Generic.HashSet[string]]::new()
        foreach ($row in $dataRows) {
            $rowCols = $row -split '\|'
            $null = $recordedDates.Add($rowCols[2].Trim())
        }

        # Build list of missing dates (oldest to newest for sequential numbering)
        $gapDates = [System.Collections.Generic.List[datetime]]::new()
        $current = $latestDate.AddDays(1)

        while ($current -le $yesterday) {
            $dateStr = $current.ToString('M/d/yy')

            if (-not $recordedDates.Contains($dateStr)) {
                $gapDates.Add($current)
            }

            $current = $current.AddDays(1)
        }

        if ($gapDates.Count -eq 0) {
            Write-Verbose "$Exam study log has no date gaps."
            return
        }

        # Get the current max session number across all rows
        $maxSession = 0
        foreach ($row in $dataRows) {
            $rowCols = $row -split '\|'
            $num = [int]$rowCols[1].Trim()

            if ($num -gt $maxSession) { $maxSession = $num }
        }

        # Find the insert index (right after the header separator)
        $insertIndex = $null
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^\|:') {
                $insertIndex = $i + 1
                break
            }
        }

        if ($null -eq $insertIndex) {
            Write-Warning "Table header separator not found in $Exam StudyLog — skipping."
            return
        }

        # Detect whether the log uses the extended format (Mode + Skill columns)
        $headerLine = $lines | Where-Object { $_ -match '^\|\s*#\s*\|' } | Select-Object -First 1
        $hasExtendedColumns = $headerLine -match '\|\s*Mode\s*\|'

        # Build zero-hour rows (oldest to newest, then reverse for table insertion)
        $newRows = [System.Collections.Generic.List[string]]::new()
        $sessionNum = $maxSession + 1

        foreach ($gapDate in $gapDates) {
            $dateStr = $gapDate.ToString('M/d/yy')

            if ($hasExtendedColumns) {
                $newRows.Add("| $sessionNum | $dateStr |  |  | 0h 0m |  |  |  |")
            }
            else {
                $newRows.Add("| $sessionNum | $dateStr |  |  | 0h 0m |  |")
            }

            $sessionNum++
        }

        # Reverse so newest gap date appears at the top of the table
        $newRows.Reverse()

        if ($PSCmdlet.ShouldProcess("$Exam StudyLog.md", "Insert $($newRows.Count) zero-hour gap entries")) {
            # Build updated content with gap rows inserted at the top of the data section
            $updated = @()
            $updated += $lines[0..($insertIndex - 1)]
            $updated += $newRows
            if ($insertIndex -lt $lines.Count) {
                $updated += $lines[$insertIndex..($lines.Count - 1)]
            }

            Set-Content -Path $logFile -Value $updated -Encoding UTF8
            Write-Host "  $Exam`: inserted $($newRows.Count) zero-hour entries for gaps." -ForegroundColor Yellow
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
