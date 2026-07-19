<#
.SYNOPSIS
Update exam README coverage tables, study summaries, and root README activity table.

.DESCRIPTION
For each active exam:
  - Updates the study summary (hours committed, days studied) from StudyLog.md.
  - Recalculates in-progress day counts in exam progress tables.
  - Updates per-skill progress (tasks, per-mode hours) from StudyLog and Skills.psd1.
  - Updates coverage table summary tags (task counts per domain).
  - Updates the coverage dashboard from Per-Skill Progress completion data.

For the root README:
    - Updates duration day counts and study summary columns in certifications/applied-skills tables.
  - Generates a 7-day rolling activity table from StudyLog entries,
    replacing the section between COMMIT_STATS_START/END markers.

.CONTEXT
LearningAzure repository — exam coverage and activity tracking.

.AUTHOR
Greg Tate

.NOTES
Program: Update-CoverageTable.ps1
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [string[]]$ExamName
)

# Configuration
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
$MainReadme = Join-Path -Path $RepoRoot -ChildPath 'README.md'
$GetActiveExamScript = Join-Path -Path $PSScriptRoot -ChildPath 'Get-ActiveExam.ps1'

# Applied Skills topics roll up into a single aggregate column in the activity table
$AppliedSkillsColumn = 'Applied Skills'

$Main = {
    . $Helpers

    # Capture whether the run is scoped to specific exams before Get-TargetExam is consulted
    $scopedToExam = [bool]$ExamName
    $exams = Get-TargetExam

    # Build the set of track items to refresh: cert exams, plus (on unscoped runs) in-progress applied-skills topics
    $items = [System.Collections.Generic.List[object]]::new()
    foreach ($exam in $exams) {
        $items.Add([pscustomobject]@{ Name = $exam; Dir = (Join-Path -Path $RepoRoot -ChildPath "certs\$exam") })
    }
    if (-not $scopedToExam) {
        $inProgressItems = @(& $GetActiveExamScript -Status 'In Progress' -IncludeAppliedSkills)
        $inProgressTopics = @($inProgressItems | Where-Object {
            Test-Path -Path (Join-Path -Path $RepoRoot -ChildPath "applied-skills\$_\StudyLog.md")
        })

        foreach ($topic in $inProgressTopics) {
            $items.Add([pscustomobject]@{ Name = $topic; Dir = (Join-Path -Path $RepoRoot -ChildPath "applied-skills\$topic") })
        }
    }

    # Update coverage for each track item (coverage/dashboard/per-skill helpers no-op on marker-less topic READMEs)
    foreach ($item in $items) {
        try {
            Write-Host "`n=== Updating coverage for $($item.Name) ===" -ForegroundColor Cyan
            $ExamName = $item.Name
            $ExamDir = $item.Dir
            $ExamReadme = Join-Path -Path $ExamDir -ChildPath 'README.md'
            $StudyLogFile = Join-Path -Path $ExamDir -ChildPath 'StudyLog.md'
            Confirm-InputFile
            Update-StudySummary
            Update-ExamInProgressDays
            Update-PerSkillProgress

            # Update coverage table and dashboard from study log / skills data
            Update-CoverageTable
            Update-CoverageDashboard
        }
        catch {
            Write-Warning "Skipping $($item.Name) — $_"
        }
    }

    # Update In Progress duration once for all exams and applied skills
    Update-InProgressDuration

    # Always use full set of active exams for the activity table, regardless of -ExamName scope
    $allActiveExams = & $GetActiveExamScript

    # Include any exam with study log activity in the last 7 days, even if not currently In Progress
    $recentExams = Get-ExamWithRecentActivity
    $activityColumns = @(@($allActiveExams) + @($recentExams) | Where-Object { $_ } | Sort-Object -Unique)

    # Append a single aggregate Applied Skills column when any topic is In Progress or recently studied
    if (Test-AppliedSkillActivity) {
        $activityColumns += $AppliedSkillsColumn
    }

    # Update the 7-day activity table in root README from study log data
    Update-ActivityTable -ExamNames $activityColumns
}

#region HELPER FUNCTIONS
$Helpers = {

    function Get-TargetExam {
        # Return exams from parameter or auto-discover active exams from README
        if ($ExamName) {
            return $ExamName
        }

        if (-not (Test-Path -Path $GetActiveExamScript)) {
            throw "Active exam discovery script not found: $GetActiveExamScript"
        }

        $discovered = & $GetActiveExamScript

        if (-not $discovered) {
            Write-Verbose 'No active exams found in main README; continuing with applied-skills and recent activity data.'
            return @()
        }

        Write-Verbose "Auto-discovered exams: $($discovered -join ', ')"
        return $discovered
    }

    function Confirm-InputFile {
        # Validate that required files and directories exist
        if (-not (Test-Path -Path $ExamReadme)) {
            throw "Exam README not found: $ExamReadme"
        }

        if (-not (Test-Path -Path $StudyLogFile)) {
            throw "Study log not found: $StudyLogFile"
        }

        if (-not (Test-Path -Path $MainReadme)) {
            throw "Main README not found: $MainReadme"
        }
    }

    function Get-StudySummary {
        # Parse study sessions to derive total time, unique study days, and per-mode hours
        $lines = Get-Content -Path $StudyLogFile -Encoding UTF8
        $totalMinutes = 0
        $studiedDates = [System.Collections.Generic.HashSet[string]]::new()

        # Track minutes for canonical modes only (matches Invoke-StudySession.ps1 ValidateSet)
        $modeMinutes = [ordered]@{
            Prepare  = 0
            Research = 0
            Practice = 0
            Review   = 0
        }

        foreach ($line in $lines) {
            if ($line -notmatch '^\|\s*\d+\s*\|') { continue }

            $cells = ($line.TrimStart('|').TrimEnd('|')) -split '\|'
            if ($cells.Count -lt 8) { continue }

            $dateCell = $cells[1].Trim()
            $durationCell = $cells[4].Trim()
            $modeCell = $cells[5].Trim()

            if ($durationCell -match '^(?:(\d+)\s*h)?\s*(?:(\d+)\s*m)?$') {
                $hours = if ([string]::IsNullOrWhiteSpace($Matches[1])) { 0 } else { [int]$Matches[1] }
                $minutes = if ([string]::IsNullOrWhiteSpace($Matches[2])) { 0 } else { [int]$Matches[2] }
                $sessionMinutes = ($hours * 60) + $minutes
                $totalMinutes += $sessionMinutes

                if ($sessionMinutes -gt 0 -and -not [string]::IsNullOrWhiteSpace($dateCell)) {
                    $studiedDates.Add($dateCell) | Out-Null
                }

                # Only accumulate against canonical mode names; ignore legacy/free-form values
                if ($sessionMinutes -gt 0 -and $modeMinutes.Contains($modeCell)) {
                    $modeMinutes[$modeCell] += $sessionMinutes
                }
            }
        }

        # Build ordered hashtable of modes with logged time, formatted as hours
        $modeHours = [ordered]@{}
        foreach ($mode in $modeMinutes.Keys) {
            if ($modeMinutes[$mode] -gt 0) {
                $modeHours[$mode] = ('{0:N1}h' -f [math]::Round($modeMinutes[$mode] / 60, 1))
            }
        }

        $totalHours = [math]::Round($totalMinutes / 60, 1)
        return @{
            HoursText = ('{0:N1}h' -f $totalHours)
            DaysStudied = $studiedDates.Count
            ModeHours = $modeHours
        }
    }

    function Update-StudySummary {
        [CmdletBinding(SupportsShouldProcess)]

        # Place the study summary directly under Study Log and remove legacy marker locations
        $summary = Get-StudySummary

        # Build summary block with optional per-mode bullets for modes that have logged time
        $summaryLines = [System.Collections.Generic.List[string]]::new()
        $summaryLines.Add('<!-- STUDY_SUMMARY -->')
        $summaryLines.Add("**Hours Committed:** $($summary.HoursText) · **Days Studied:** $($summary.DaysStudied)")
        foreach ($mode in $summary.ModeHours.Keys) {
            $summaryLines.Add("- $mode`: $($summary.ModeHours[$mode])")
        }
        $summaryLines.Add('<!-- /STUDY_SUMMARY -->')

        $lines = Get-Content -Path $ExamReadme -Encoding UTF8
        $filtered = [System.Collections.Generic.List[string]]::new()
        $inserted = $false
        $inSummary = $false

        foreach ($line in $lines) {

            # Skip everything between STUDY_SUMMARY markers so the block is fully regenerated
            if ($line -match '<!--\s*STUDY_SUMMARY\s*-->') {
                $inSummary = $true
                continue
            }
            if ($line -match '<!--\s*/STUDY_SUMMARY\s*-->') {
                $inSummary = $false
                continue
            }
            if ($inSummary) { continue }

            if (
                $line -match '<!--\s*HOURS_COMMITTED\s*-->' -or
                $line -match '<!--\s*/HOURS_COMMITTED\s*-->' -or
                $line -match '^\*\*Hours Committed:\*\*.*\*\*Days Studied:\*\*'
            ) {
                continue
            }

            $filtered.Add($line)

            if (-not $inserted -and $line -match '^-\s+\*\*Study Log:\*\*') {
                $filtered.Add('')
                foreach ($summaryLine in $summaryLines) {
                    $filtered.Add($summaryLine)
                }
                $inserted = $true
            }
        }

        if (-not $inserted) {
            foreach ($line in $lines) {
                if ($line -match '^\*\*Objective:\*\*') {
                    $objectiveIndex = $filtered.IndexOf($line)
                    if ($objectiveIndex -ge 0) {
                        $filtered.Insert($objectiveIndex + 1, '')
                        for ($i = 0; $i -lt $summaryLines.Count; $i++) {
                            $filtered.Insert($objectiveIndex + 2 + $i, $summaryLines[$i])
                        }
                        $inserted = $true
                    }
                    break
                }
            }
        }

        if (-not $inserted) {
            for ($i = $summaryLines.Count - 1; $i -ge 0; $i--) {
                $filtered.Insert(0, $summaryLines[$i])
            }
            $filtered.Insert($summaryLines.Count, '')
        }

        if ($WhatIfPreference) {
            Write-Host "What if: Performing the operation \"Update study summary\" on target \"$ExamReadme\"."
        }
        else {
            Set-Content -Path $ExamReadme -Value ($filtered -join "`n") -Encoding UTF8 -NoNewline
            Write-Host "Updated study summary in $ExamReadme" -ForegroundColor Green
        }
    }

    function Get-StudyLogStats {
        param([string]$Path)

        # Parse a StudyLog.md and return first session date and total study hours
        $result = [pscustomobject]@{
            FirstDate  = $null
            TotalHours = 0
        }

        if (-not (Test-Path -Path $Path)) { return $result }

        $totalMinutes = 0
        foreach ($line in Get-Content -Path $Path -Encoding UTF8) {
            if ($line -notmatch '^\|\s*\d+\s*\|') { continue }

            $cells = ($line.TrimStart('|').TrimEnd('|')) -split '\|'
            if ($cells.Count -lt 5) { continue }

            $dateCell = $cells[1].Trim()
            $durationCell = $cells[4].Trim()

            if (-not $result.FirstDate -and $dateCell -match '^\d{1,2}/\d{1,2}/\d{2,4}$') {
                $result.FirstDate = $dateCell
            }

            if ($durationCell -match '^(?:(\d+)\s*h)?\s*(?:(\d+)\s*m)?$') {
                $hours = if ([string]::IsNullOrWhiteSpace($Matches[1])) { 0 } else { [int]$Matches[1] }
                $minutes = if ([string]::IsNullOrWhiteSpace($Matches[2])) { 0 } else { [int]$Matches[2] }
                $totalMinutes += ($hours * 60) + $minutes
            }
        }

        $result.TotalHours = [int][math]::Round($totalMinutes / 60, 0)
        return $result
    }

    function Get-StudySummaryFromReadme {
        param([string]$Path)

        # Parse STUDY_SUMMARY line in an exam/topic README for hours committed and days studied
        $result = [pscustomobject]@{
            DaysStudiedText = ''
            HoursText = ''
        }

        if (-not (Test-Path -Path $Path)) { return $result }

        foreach ($line in Get-Content -Path $Path -Encoding UTF8) {
            if ($line -match '^\*\*Hours Committed:\*\*\s*([^·]+?)\s*·\s*\*\*Days Studied:\*\*\s*(\d+)\s*$') {
                $result.HoursText = $Matches[1].Trim()
                $result.DaysStudiedText = $Matches[2].Trim()
                break
            }
        }

        return $result
    }

    function Update-InProgressDuration {
        [CmdletBinding(SupportsShouldProcess)]

        # Update Duration/Days Studied/Hours Committed columns in root README track tables
        $lines = Get-Content -Path $MainReadme -Encoding UTF8
        $output = [System.Collections.Generic.List[string]]::new()
        $updatedRows = 0
        $today = (Get-Date).Date
        $dateFormats = @(
            'M/d/yy',
            'M/d/yyyy',
            'MM/dd/yy',
            'MM/dd/yyyy'
        )

        foreach ($line in $lines) {
            # Match any 6-column markdown table row
            if ($line -match '^\|\s*(.+?)\s*\|\s*(.+?)\s*\|\s*(.+?)\s*\|\s*(.*?)\s*\|\s*(.*?)\s*\|\s*(.*?)\s*\|$') {
                $examCell = $Matches[1].Trim()
                $descriptionCell = $Matches[2].Trim()
                $statusCell = $Matches[3].Trim()
                $durationCell = $Matches[4].Trim()
                $daysStudiedCell = $Matches[5].Trim()
                $hoursCommittedCell = $Matches[6].Trim()

                # Update only tracked certification/applied-skill rows that link to a track README
                if ($examCell -match '(certs|applied-skills)/([A-Za-z0-9_-]+)/README\.md') {
                    $trackRoot = $Matches[1]
                    $examSlug = $Matches[2]

                    # Resolve StudyLog/README for date and summary metadata
                    $candidateLog = Join-Path -Path $RepoRoot -ChildPath "$trackRoot\$examSlug\StudyLog.md"
                    $candidateReadme = Join-Path -Path $RepoRoot -ChildPath "$trackRoot\$examSlug\README.md"
                    $logStats = Get-StudyLogStats -Path $candidateLog
                    $studySummary = Get-StudySummaryFromReadme -Path $candidateReadme

                    # Normalize any existing ", Nh" suffix so Duration remains date range + day count only
                    $normalizedDuration = $durationCell -replace ',\s*\d+(?:\.\d+)?h(?=\))', ''

                    # Recalculate Duration for active rows from start date through today
                    $startDateText = $null
                    $newDuration = $normalizedDuration

                    if ($statusCell -eq 'In Progress') {
                        # Prefer an existing start date already present in the Duration cell
                        if ($normalizedDuration -match '(\d{1,2}/\d{1,2}/\d{2,4})') {
                            $startDateText = $Matches[1]
                        }
                        elseif ($logStats -and $logStats.FirstDate) {
                            $startDateText = $logStats.FirstDate
                        }
                        else {
                            Write-Warning "No start date found for In Progress row: $line"
                        }

                        if ($startDateText) {
                            $startDate = $null

                            foreach ($format in $dateFormats) {
                                try {
                                    $startDate = [datetime]::ParseExact(
                                        $startDateText,
                                        $format,
                                        [System.Globalization.CultureInfo]::InvariantCulture
                                    )
                                    break
                                }
                                catch {
                                    continue
                                }
                            }

                            if ($null -ne $startDate) {
                                $days = ($today - $startDate.Date).Days + 1
                                $todayText = $today.ToString('M/d/yy')
                                $newDuration = "$startDateText – $todayText (${days}d)"
                            }
                            else {
                                Write-Warning "Could not parse start date '$startDateText' in row: $line"
                            }
                        }
                    }

                    # Pull summary values directly from each track README
                    if ($studySummary.DaysStudiedText) {
                        $daysStudiedCell = $studySummary.DaysStudiedText
                    }
                    else {
                        $daysStudiedCell = ''
                    }

                    if ($studySummary.HoursText) {
                        $hoursCommittedCell = $studySummary.HoursText
                    }
                    else {
                        $hoursCommittedCell = ''
                    }

                    $updatedLine = "| $examCell | $descriptionCell | $statusCell | $newDuration | $daysStudiedCell | $hoursCommittedCell |"
                    if ($updatedLine -cne $line) {
                        $updatedRows++
                    }

                    $output.Add($updatedLine)
                    continue
                }
            }

            $output.Add($line)
        }

        if ($updatedRows -gt 0) {
            if ($WhatIfPreference) {
                Write-Host "What if: Performing the operation \"Update $updatedRows duration/study summary values\" on target \"$MainReadme\"."
            }
            else {
                Set-Content -Path $MainReadme -Value ($output -join "`n") -Encoding UTF8 -NoNewline
                Write-Host "Updated $updatedRows duration/study summary values in $MainReadme" -ForegroundColor Green
            }
        }
    }

    function Update-ExamInProgressDays {
        [CmdletBinding(SupportsShouldProcess)]

        # Recalculate Days in exam progress tables for rows marked In Progress
        # Supports two table formats:
        #   Legacy (AZ-104/AI-102): separate Status | Started | Completed | Days columns
        #   Compact (AZ-305):       single Progress column with "⏳ date → _ · Nd" format
        $lines = Get-Content -Path $ExamReadme -Encoding UTF8
        $output = [System.Collections.Generic.List[string]]::new()
        $updatedRows = 0
        $today = (Get-Date).Date
        $dateFormats = @(
            'M/d/yy',
            'M/d/yyyy',
            'MM/dd/yy',
            'MM/dd/yyyy'
        )

        foreach ($line in $lines) {

            # Compact format: Progress column contains "⏳ <date> → _ · <days>d"
            if ($line -match '^\|\s*\d+\s*\|' -and $line -match '⏳\s*(\S+)\s*→\s*_\s*·\s*(\d+)d') {
                $startedText = $Matches[1].Trim()
                $startDate = $null

                foreach ($format in $dateFormats) {
                    try {
                        $startDate = [datetime]::ParseExact(
                            $startedText,
                            $format,
                            [System.Globalization.CultureInfo]::InvariantCulture
                        )
                        break
                    }
                    catch {
                        continue
                    }
                }

                if ($null -ne $startDate) {
                    $days = ($today - $startDate.Date).Days
                    $currentDays = [int]$Matches[2]

                    # Only update if the value changed
                    if ($days -ne $currentDays) {
                        $newLine = $line -replace '(⏳\s*\S+\s*→\s*_\s*·\s*)\d+d', "`${1}${days}d"
                        $output.Add($newLine)
                        $updatedRows++
                        continue
                    }
                }

                $output.Add($line)
                continue
            }

            # Legacy format: separate Status | Started | Completed | Days columns
            if ($line -match '^\|\s*\d+\s*\|.*\|\s*In Progress\s*\|\s*([^|]+?)\s*\|\s*([^|]*)\|\s*([^|]*)\|$') {
                $rowCells = ($line.TrimStart('|').TrimEnd('|')) -split '\|'

                if ($rowCells.Count -ge 7) {
                    $startedText = $Matches[1].Trim()
                    $startDate = $null

                    foreach ($format in $dateFormats) {
                        try {
                            $startDate = [datetime]::ParseExact(
                                $startedText,
                                $format,
                                [System.Globalization.CultureInfo]::InvariantCulture
                            )
                            break
                        }
                        catch {
                            continue
                        }
                    }

                    if ($null -ne $startDate) {
                        $days = ($today - $startDate.Date).Days
                        $rowCells[$rowCells.Count - 1] = " $days "
                        $output.Add('|' + ($rowCells -join '|') + '|')
                        $updatedRows++
                        continue
                    }
                }
            }

            $output.Add($line)
        }

        if ($updatedRows -gt 0) {
            if ($WhatIfPreference) {
                Write-Host "What if: Performing the operation ""Update $updatedRows in-progress day values"" on target ""$ExamReadme""."
            }
            else {
                Set-Content -Path $ExamReadme -Value ($output -join "`n") -Encoding UTF8 -NoNewline
                Write-Host "Updated $updatedRows in-progress day values in $ExamReadme" -ForegroundColor Green
            }
        }
    }

    function Update-CoverageTable {
        [CmdletBinding(SupportsShouldProcess)]

        # Update <summary> tags in the coverage table with task counts per domain
        $lines = Get-Content -Path $ExamReadme -Encoding UTF8
        $output = [System.Collections.Generic.List[string]]::new()
        $inCoverage = $false

        # Domain-level tracking for <summary> updates
        $domainTaskCount = 0
        $pendingSummaryIndex = -1
        $summarySuffixPattern = '(?:\\u2014|—).*</summary>$'

        foreach ($line in $lines) {
            # Detect coverage table boundaries
            if ($line -match '<!-- BEGIN COVERAGE TABLE -->') {
                $inCoverage = $true
                $output.Add($line)
                continue
            }

            if ($line -match '<!-- END COVERAGE TABLE -->') {
                # Flush pending summary for the last domain
                if ($pendingSummaryIndex -ge 0) {
                    $summarySuffix = "— $domainTaskCount tasks</summary>"
                    $output[$pendingSummaryIndex] = $output[$pendingSummaryIndex] -replace $summarySuffixPattern, $summarySuffix
                }
                $inCoverage = $false
                $output.Add($line)
                continue
            }

            if (-not $inCoverage) {
                $output.Add($line)
                continue
            }

            # Domain <summary> line — flush previous domain's summary and record new index
            if ($line -match '^<summary><b>(Domain \d+:.+?)</b>') {
                if ($pendingSummaryIndex -ge 0) {
                    $summarySuffix = "— $domainTaskCount tasks</summary>"
                    $output[$pendingSummaryIndex] = $output[$pendingSummaryIndex] -replace $summarySuffixPattern, $summarySuffix
                }
                $domainTaskCount = 0
                $pendingSummaryIndex = $output.Count
                $output.Add($line)
                continue
            }

            # Count task rows: | <skill-or-empty> | <task> | (with optional extra columns)
            if ($line -match '^\|\s*(.*?)\s*\|\s*(?!Task\b|:---)(.+?)\s*\|') {
                $domainTaskCount++
            }

            $output.Add($line)
        }

        $newContent = $output -join "`n"
        $originalContent = $lines -join "`n"
        $hasChanges = $newContent -cne $originalContent

        if ($WhatIfPreference) {
            Write-Host "What if: Performing the operation \"Update coverage table summary tags\" on target \"$ExamReadme\"."
        }
        else {
            if ($hasChanges) {
                Set-Content -Path $ExamReadme -Value $newContent -Encoding UTF8 -NoNewline
                Write-Host "Updated coverage table summary tags in $ExamReadme" -ForegroundColor Green
            }
            else {
                Write-Host "No coverage table changes detected in $ExamReadme"
            }
        }
    }

    function Get-StudyLogHoursBySkill {
        # Aggregate StudyLog durations by tracker entity (Skill or Task) and mode buckets
        # Returns hashtable: entityName → @{ Prepare; Research; Practice; Review; ML; MD; NB; Lab; PQ; Total }
        $result = @{}

        if (-not (Test-Path -Path $StudyLogFile)) { return $result }

        $lines = Get-Content -Path $StudyLogFile -Encoding UTF8

        foreach ($line in $lines) {
            if ($line -notmatch '^\|\s*\d+\s*\|') { continue }

            $cells = ($line.TrimStart('|').TrimEnd('|')) -split '\|'
            if ($cells.Count -lt 7) { continue }

            $durationCell = $cells[4].Trim()
            $modeCell = $cells[5].Trim()
            $entityCell = $cells[6].Trim()

            # Parse duration
            if ($durationCell -notmatch '^(?:(\d+)\s*h)?\s*(?:(\d+)\s*m)?$') { continue }
            $hours = if ([string]::IsNullOrWhiteSpace($Matches[1])) { 0 } else { [int]$Matches[1] }
            $minutes = if ([string]::IsNullOrWhiteSpace($Matches[2])) { 0 } else { [int]$Matches[2] }
            $sessionHours = ($hours * 60 + $minutes) / 60.0
            if ($sessionHours -eq 0) { continue }
            if ([string]::IsNullOrWhiteSpace($entityCell)) { continue }

            # Initialize entity entry
            if (-not $result.ContainsKey($entityCell)) {
                $result[$entityCell] = @{
                    Prepare  = 0.0
                    Research = 0.0
                    Practice = 0.0
                    Review   = 0.0
                    ML       = 0.0
                    MD       = 0.0
                    NB       = 0.0
                    Lab      = 0.0
                    PQ       = 0.0
                    Total    = 0.0
                }
            }

            # Map canonical and legacy mode names into both legacy and task-level buckets
            switch ($modeCell) {
                'Prepare' {
                    $result[$entityCell].Prepare += $sessionHours
                }
                'Research' {
                    $result[$entityCell].Research += $sessionHours
                }
                'Practice' {
                    $result[$entityCell].Practice += $sessionHours
                }
                'Review' {
                    $result[$entityCell].Review += $sessionHours
                }
                'MSLearn' {
                    $result[$entityCell].ML += $sessionHours
                    $result[$entityCell].Research += $sessionHours
                }
                'MSDocs' {
                    $result[$entityCell].MD += $sessionHours
                    $result[$entityCell].Research += $sessionHours
                }
                'NotebookLM' {
                    $result[$entityCell].NB += $sessionHours
                    $result[$entityCell].Practice += $sessionHours
                }
                'Lab' {
                    $result[$entityCell].Lab += $sessionHours
                    $result[$entityCell].Practice += $sessionHours
                }
                'PracticeQuestion' {
                    $result[$entityCell].PQ += $sessionHours
                    $result[$entityCell].Practice += $sessionHours
                }
            }

            $result[$entityCell].Total += $sessionHours
        }

        # Round all values
        foreach ($entity in $result.Keys) {
            foreach ($key in @('Prepare', 'Research', 'Practice', 'Review', 'ML', 'MD', 'NB', 'Lab', 'PQ', 'Total')) {
                $result[$entity][$key] = [math]::Round($result[$entity][$key], 1)
            }
        }

        return $result
    }

    function Get-TaskCountBySkill {
        # Read Skills.psd1 and return hashtable: skillName → taskCount
        $skillsFile = Join-Path -Path $ExamDir -ChildPath 'Skills.psd1'
        $result = @{}

        if (-not (Test-Path -Path $skillsFile)) { return $result }

        $data = Import-PowerShellDataFile -Path $skillsFile

        foreach ($domain in $data.Domains) {
            foreach ($skill in $domain.Skills) {
                $result[$skill.Name] = $skill.Tasks.Count
            }
        }

        return $result
    }

    function Get-CellIcon {
        # Return the leading status icon from a tracker cell
        param(
            [string]$CellText
        )

        if ([string]::IsNullOrWhiteSpace($CellText)) { return '' }
        $trimmed = $CellText.Trim()

        if ($trimmed -match '^(✅|⏳|🔲)') {
            return $Matches[1]
        }

        return ''
    }

    function Get-ModeCellIcon {
        # Resolve mode icon from hours while preserving completed state
        param(
            [string]$CurrentCell,
            [double]$ModeHours
        )

        $currentIcon = Get-CellIcon -CellText $CurrentCell
        if ($currentIcon -eq '✅') { return '✅' }
        if ($ModeHours -gt 0) { return '⏳' }
        return '🔲'
    }

    function Get-TrackerFormat {
        # Detect progress tracker shape: 'Task' (AZ-305 Per-Task) or 'Skill' (legacy Per-Skill)
        if (-not (Test-Path -Path $ExamReadme)) { return 'Skill' }

        foreach ($line in Get-Content -Path $ExamReadme -Encoding UTF8) {
            if ($line -match '^###\s+Per-Task Progress')  { return 'Task' }
            if ($line -match '^###\s+Per-Skill Progress') { return 'Skill' }
        }

        return 'Skill'
    }

    function Get-ProgressCellValue {
        # Resolve progress cell from total hours while preserving completed and dated in-progress states
        param(
            [string]$CurrentCell,
            [double]$TotalHours
        )

        $currentTrimmed = $CurrentCell.Trim()
        $currentIcon = Get-CellIcon -CellText $currentTrimmed

        if ($currentIcon -eq '✅') {
            return $currentTrimmed
        }

        if ($TotalHours -gt 0) {
            if ($currentIcon -eq '⏳') {
                return $currentTrimmed
            }

            return '⏳'
        }

        return '🔲'
    }

    function Update-PerSkillProgress {
        [CmdletBinding(SupportsShouldProcess)]

        # Update progress tracker (per-skill or per-task) with study log hours
        $trackerFormat = Get-TrackerFormat
        $studyHours = Get-StudyLogHoursBySkill
        $taskCounts = Get-TaskCountBySkill

        # Heading and lookup-column vary by format
        $trackerHeading = if ($trackerFormat -eq 'Task') { '### Per-Task Progress' } else { '### Per-Skill Progress' }
        $lookupColumn   = if ($trackerFormat -eq 'Task') { 'Task' } else { 'Skill' }

        $lines = Get-Content -Path $ExamReadme -Encoding UTF8
        $output = [System.Collections.Generic.List[string]]::new()
        $inTracker = $false
        $headerParsed = $false
        $updatedRows = 0

        # Column indices (set from header)
        $colIndices = @{}
        $headerColumnCount = 0

        foreach ($line in $lines) {
            if ($line -match [regex]::Escape($trackerHeading)) {
                $inTracker = $true
                $output.Add($line)
                continue
            }

            if (-not $inTracker) {
                $output.Add($line)
                continue
            }

            # Parse header row to find column indices
            if (-not $headerParsed -and $line -match '^\|.*Domain.*\|') {
                $headers = ($line.TrimStart('|').TrimEnd('|')) -split '\|'
                $headerColumnCount = $headers.Count
                for ($i = 0; $i -lt $headers.Count; $i++) {
                    $h = $headers[$i].Trim()
                    if ($h -eq 'Skill')    { $colIndices['Skill'] = $i }
                    if ($h -eq 'Task')     { $colIndices['Task'] = $i }
                    if ($h -eq 'Tasks')    { $colIndices['Tasks'] = $i }
                    if ($h -eq 'ML')       { $colIndices['ML'] = $i }
                    if ($h -eq 'MD')       { $colIndices['MD'] = $i }
                    if ($h -eq 'NB')       { $colIndices['NB'] = $i }
                    if ($h -eq 'Lab')      { $colIndices['Lab'] = $i }
                    if ($h -eq 'PQ')       { $colIndices['PQ'] = $i }
                    if ($h -eq 'Prepare')  { $colIndices['Prepare'] = $i }
                    if ($h -eq 'Research') { $colIndices['Research'] = $i }
                    if ($h -eq 'Practice') { $colIndices['Practice'] = $i }
                    if ($h -eq 'Total')    { $colIndices['Total'] = $i }
                    if ($h -eq 'Hours')    { $colIndices['Hours'] = $i }
                    if ($h -eq 'Progress') { $colIndices['Progress'] = $i }
                }
                $headerParsed = $true
                $output.Add($line)
                continue
            }

            # Skip separator row
            if ($line -match '^\|\s*[-:]+\s*\|') {
                $output.Add($line)
                continue
            }

            # Data row
            if ($headerParsed -and $line -match '^\|\s*\d+\s*\|') {
                $cells = ($line.TrimStart('|').TrimEnd('|')) -split '\|'
                if ($headerColumnCount -gt 0 -and $cells.Count -lt $headerColumnCount) {
                    $paddingNeeded = $headerColumnCount - $cells.Count
                    for ($i = 0; $i -lt $paddingNeeded; $i++) {
                        $cells += ''
                    }
                }

                $lookupIdx = $colIndices[$lookupColumn]
                if ($null -eq $lookupIdx -or $cells.Count -le $lookupIdx) {
                    $output.Add($line)
                    continue
                }

                $lookupName = $cells[$lookupIdx].Trim()

                # Update Tasks column (skill-format only)
                if ($colIndices.ContainsKey('Tasks') -and $taskCounts.ContainsKey($lookupName)) {
                    $cells[$colIndices['Tasks']] = " $($taskCounts[$lookupName]) "
                }

                # Look up aggregated hours for this row's entity (skill name or task name)
                $entityHours = if ($studyHours.ContainsKey($lookupName)) { $studyHours[$lookupName] } else { $null }

                # Preserve existing progress cell value during column-layout transitions
                $currentProgress = ''
                if ($colIndices.ContainsKey('Progress')) {
                    $progressIdx = $colIndices['Progress']
                    if ($progressIdx -lt $cells.Count) {
                        $currentProgress = $cells[$progressIdx]
                    }

                    if (
                        [string]::IsNullOrWhiteSpace($currentProgress) -and
                        $trackerFormat -eq 'Task' -and
                        $colIndices.ContainsKey('Total')
                    ) {
                        $legacyProgressIdx = $colIndices['Total']
                        if ($legacyProgressIdx -lt $cells.Count) {
                            $legacyProgress = $cells[$legacyProgressIdx]
                            if (-not [string]::IsNullOrWhiteSpace((Get-CellIcon -CellText $legacyProgress))) {
                                $currentProgress = $legacyProgress
                            }
                        }
                    }
                }

                if ($trackerFormat -eq 'Task') {
                    # Per-Task table can be either legacy icon buckets or mode-total hours columns
                    $prepareHours = 0.0
                    $researchHours = 0.0
                    $practiceHours = 0.0
                    if ($entityHours) {
                        $prepareHours = $entityHours['Prepare']
                        $researchHours = $entityHours['Research']
                        $practiceHours = $entityHours['Practice']
                    }

                    $hasModeTotalsColumns = $colIndices.ContainsKey('Prepare') -or $colIndices.ContainsKey('Total')

                    if ($hasModeTotalsColumns) {
                        if ($colIndices.ContainsKey('Prepare')) {
                            $idx = $colIndices['Prepare']
                            if ($idx -lt $cells.Count) {
                                $cells[$idx] = " $($prepareHours.ToString('0.0'))h "
                            }
                        }

                        if ($colIndices.ContainsKey('Research')) {
                            $idx = $colIndices['Research']
                            if ($idx -lt $cells.Count) {
                                $cells[$idx] = " $($researchHours.ToString('0.0'))h "
                            }
                        }

                        if ($colIndices.ContainsKey('Practice')) {
                            $idx = $colIndices['Practice']
                            if ($idx -lt $cells.Count) {
                                $cells[$idx] = " $($practiceHours.ToString('0.0'))h "
                            }
                        }
                    }
                    else {
                        if ($colIndices.ContainsKey('Research')) {
                            $idx = $colIndices['Research']
                            if ($idx -lt $cells.Count) {
                                $emoji = Get-ModeCellIcon -CurrentCell $cells[$idx].Trim() -ModeHours $researchHours
                                $cells[$idx] = " $emoji "
                            }
                        }

                        if ($colIndices.ContainsKey('Practice')) {
                            $idx = $colIndices['Practice']
                            if ($idx -lt $cells.Count) {
                                $emoji = Get-ModeCellIcon -CurrentCell $cells[$idx].Trim() -ModeHours $practiceHours
                                $cells[$idx] = " $emoji "
                            }
                        }
                    }
                }
                else {
                    # Legacy Per-Skill table: per-mode hours cells
                    foreach ($modeKey in @('ML', 'MD', 'NB', 'Lab', 'PQ')) {
                        if (-not $colIndices.ContainsKey($modeKey)) { continue }
                        $idx = $colIndices[$modeKey]
                        if ($idx -ge $cells.Count) { continue }

                        $currentCell = $cells[$idx].Trim()
                        $modeHours = if ($entityHours) { $entityHours[$modeKey] } else { 0.0 }
                        $emoji = Get-ModeCellIcon -CurrentCell $currentCell -ModeHours $modeHours

                        # Build new cell: emoji + hours (omit hours text when zero)
                        if ($modeHours -gt 0) {
                            $cells[$idx] = " $emoji $($modeHours.ToString('0.0'))h "
                        }
                        else {
                            $cells[$idx] = " $emoji "
                        }
                    }
                }

                # Update total-hours column regardless of legacy/new header naming
                $totalHours = if ($entityHours) { $entityHours.Total } else { 0.0 }
                $totalColumnKey = if ($colIndices.ContainsKey('Total')) {
                    'Total'
                }
                elseif ($colIndices.ContainsKey('Hours')) {
                    'Hours'
                }
                else {
                    $null
                }

                if ($totalColumnKey) {
                    $cells[$colIndices[$totalColumnKey]] = " $($totalHours.ToString('0.0'))h "
                }

                # Update Progress column from total hours while preserving completed rows
                if ($colIndices.ContainsKey('Progress')) {
                    $progressIdx = $colIndices['Progress']
                    if ($progressIdx -lt $cells.Count) {
                        $progressValue = Get-ProgressCellValue -CurrentCell $currentProgress -TotalHours $totalHours
                        $cells[$progressIdx] = " $progressValue "
                    }
                }

                $output.Add('|' + ($cells -join '|') + '|')
                $updatedRows++
                continue
            }

            # End of table (blank line or heading)
            if ($headerParsed -and ($line -match '^\s*$' -or $line -match '^#')) {
                $inTracker = $false
            }

            $output.Add($line)
        }

        if ($updatedRows -gt 0) {
            $newContent = $output -join "`n"
            $originalContent = $lines -join "`n"
            $hasChanges = $newContent -cne $originalContent

            if ($WhatIfPreference) {
                Write-Host "What if: Performing the operation ""Update $updatedRows per-skill progress rows"" on target ""$ExamReadme""."
            }
            elseif ($hasChanges) {
                Set-Content -Path $ExamReadme -Value $newContent -Encoding UTF8 -NoNewline
                Write-Host "Updated $updatedRows per-skill progress rows in $ExamReadme" -ForegroundColor Green
            }
            else {
                Write-Host "No per-skill progress changes detected in $ExamReadme"
            }
        }
    }

    function Get-SkillCompletionByDomain {
        # Parse progress tracker (per-skill or per-task) and count completed rows per domain
        # Returns ordered hashtable: domainNum → @{ Total; Completed; Skills; Tasks; Format }
        $trackerFormat = Get-TrackerFormat
        $trackerHeading = if ($trackerFormat -eq 'Task') { '### Per-Task Progress' } else { '### Per-Skill Progress' }

        $lines = Get-Content -Path $ExamReadme -Encoding UTF8
        $domainMap = [ordered]@{}

        # Build domain name → number mapping from dashboard rows.
        # Supports linked form: "| [N. Name](#anchor) | ..." and unlinked form: "| N. Name | ..."
        $nameToNum = @{}
        $inDashboard = $false
        foreach ($line in $lines) {
            if ($line -match '<!-- BEGIN COVERAGE DASHBOARD -->') { $inDashboard = $true; continue }
            if ($line -match '<!-- END COVERAGE DASHBOARD -->') { break }
            if (-not $inDashboard) { continue }

            if ($line -match '^\|\s*\[(\d+)\.\s*(.+?)\]') {
                $nameToNum[$Matches[2].Trim()] = $Matches[1]
            }
            elseif ($line -match '^\|\s*(\d+)\.\s*([^|]+?)\s*\|') {
                $nameToNum[$Matches[2].Trim()] = $Matches[1]
            }
        }

        # Parse the progress tracker for row completion
        # Supports two formats:
        #   Legacy: separate Status column (value = 'Completed')
        #   Compact: Progress column (completed = cell starts with ✅)
        $inTracker = $false
        $domainCol = -1
        $statusCol = -1
        $progressCol = -1
        $skillsCol = -1
        foreach ($line in $lines) {
            if ($line -match [regex]::Escape($trackerHeading)) { $inTracker = $true; continue }
            if (-not $inTracker) { continue }

            # Header row — find column indices
            if ($domainCol -lt 0 -and $line -match '^\|.*Domain.*\|') {
                $headers = ($line.TrimStart('|').TrimEnd('|')) -split '\|'
                for ($i = 0; $i -lt $headers.Count; $i++) {
                    $h = $headers[$i].Trim()
                    if ($h -eq 'Domain')   { $domainCol = $i }
                    elseif ($h -eq 'Skill')    { $skillsCol = $i }
                    elseif ($h -eq 'Status')   { $statusCol = $i }
                    elseif ($h -eq 'Progress') { $progressCol = $i }
                }
                continue
            }

            # Skip separator row
            if ($line -match '^\|\s*[-:]+\s*\|') { continue }

            # Data row
            if ($domainCol -ge 0 -and $line -match '^\|\s*\d+\s*\|') {
                $cells = ($line.TrimStart('|').TrimEnd('|')) -split '\|'

                # Determine completion from Status column (legacy) or Progress column (compact)
                $isCompleted = $false
                if ($progressCol -ge 0 -and $cells.Count -gt $progressCol) {
                    $isCompleted = $cells[$progressCol].Trim() -match '^✅'
                }
                elseif ($statusCol -ge 0 -and $cells.Count -gt $statusCol) {
                    $isCompleted = $cells[$statusCol].Trim() -eq 'Completed'
                }

                $domainName = $cells[$domainCol].Trim()

                # Map domain name to number
                $domainNum = $nameToNum[$domainName]
                if (-not $domainNum) { continue }

                # Initialize domain entry
                if (-not $domainMap.Contains($domainNum)) {
                    $domainMap[$domainNum] = @{ Total = 0; Completed = 0; Skills = 0; Tasks = 0; Format = $trackerFormat }
                }

                $domainMap[$domainNum].Total++
                if ($trackerFormat -eq 'Task') {
                    $domainMap[$domainNum].Tasks++
                }
                else {
                    $domainMap[$domainNum].Skills++
                }
                if ($isCompleted) {
                    $domainMap[$domainNum].Completed++
                }
            }

            # End of table
            if ($inTracker -and $domainCol -ge 0 -and $line -match '^\s*$') { break }
        }

        return $domainMap
    }

    function Update-CoverageDashboard {
        [CmdletBinding(SupportsShouldProcess)]

        # Regenerate the coverage dashboard from progress tracker completion data
        $lines = Get-Content -Path $ExamReadme -Encoding UTF8
        $domainStats = Get-SkillCompletionByDomain
        $trackerFormat = Get-TrackerFormat
        $entityWord = if ($trackerFormat -eq 'Task') { 'tasks' } else { 'skills' }
        $entityField = if ($trackerFormat -eq 'Task') { 'Tasks' } else { 'Skills' }
        $legendSuffix = if ($trackerFormat -eq 'Task') {
            'task marked complete in Per-Task Progress'
        } else {
            'skill completed in Per-Skill Progress'
        }

        # Update dashboard rows
        $output = [System.Collections.Generic.List[string]]::new()
        $inDashboard = $false
        $updatedRows = 0

        foreach ($line in $lines) {
            if ($line -match '<!-- BEGIN COVERAGE DASHBOARD -->') {
                $inDashboard = $true
                $output.Add($line)
                continue
            }

            if ($line -match '<!-- END COVERAGE DASHBOARD -->') {
                $inDashboard = $false
                $output.Add($line)
                continue
            }

            # Totals line
            if ($inDashboard -and $line -match '^\*\*Totals:\*\*') {
                $totalEntities = ($domainStats.Values | ForEach-Object { $_.Total } | Measure-Object -Sum).Sum
                $totalCompleted = ($domainStats.Values | ForEach-Object { $_.Completed } | Measure-Object -Sum).Sum
                $output.Add("**Totals:** $totalCompleted / $totalEntities $entityWord completed")
                $updatedRows++
                continue
            }

            # Legend line
            if ($inDashboard -and $line -match '^\*\*Legend:\*\*') {
                $output.Add("**Legend:** 🟢 Strong (≥66%) · 🟡 Partial (33–65%) · 🔴 Low (<33%) — ""Covered"" = $legendSuffix")
                continue
            }

            # Dashboard data row: linked "| [N. Name](#domain-n) | ..." or unlinked "| N. Name | ..."
            $isLinkedRow = $line -match '^\|\s*\[(\d+)\.'
            $isUnlinkedRow = -not $isLinkedRow -and $line -match '^\|\s*(\d+)\.\s*[^|]+\|'

            if ($inDashboard -and ($isLinkedRow -or $isUnlinkedRow)) {
                $domainNum = $Matches[1]
                if ($domainStats.Contains($domainNum)) {
                    $stats = $domainStats[$domainNum]

                    # Preserve domain link/name and weight from existing line
                    $cells = ($line.TrimStart('|').TrimEnd('|')) -split '\|'
                    $domainLabel = $cells[0].Trim()
                    $weight = $cells[1].Trim()

                    $pct = if ($stats.Total -gt 0) { [math]::Floor(($stats.Completed / $stats.Total) * 100) } else { 0 }
                    $indicator = if ($pct -ge 66) { '🟢' } elseif ($pct -ge 33) { '🟡' } else { '🔴' }
                    $entityCount = $stats[$entityField]
                    $newLine = "| $domainLabel | $weight | $entityCount | $($stats.Completed) / $($stats.Total) ($pct%) | $indicator |"
                    $output.Add($newLine)
                    $updatedRows++
                }
                else {
                    $output.Add($line)
                }
                continue
            }

            $output.Add($line)
        }

        if ($updatedRows -gt 0) {
            if ($WhatIfPreference) {
                Write-Host "What if: Performing the operation \"Update $updatedRows coverage dashboard rows\" on target \"$ExamReadme\"."
            }
            else {
                Set-Content -Path $ExamReadme -Value ($output -join "`n") -Encoding UTF8 -NoNewline
                Write-Host "Updated $updatedRows dashboard rows in $ExamReadme" -ForegroundColor Green
            }
        }
    }

    function Get-CertificationStartDateMap {
        # Parse certification start dates for active exams from the root README certifications table
        param(
            [string[]]$ExamNames
        )

        $lines = Get-Content -Path $MainReadme -Encoding UTF8
        $lineByExam = @{}
        $dateFormats = @('M/d/yy', 'M/d/yyyy', 'MM/dd/yy', 'MM/dd/yyyy')
        $culture = [System.Globalization.CultureInfo]::InvariantCulture
        $styles = [System.Globalization.DateTimeStyles]::None

        # Find the certifications table row for each exam
        foreach ($line in $lines) {
            if ($line -notmatch '^\|') { continue }
            if ($line -match '^\|\s*Exam\s*\|' -or $line -match '^\|\s*[-:]') { continue }

            if ($line -match '\[\*\*[^\]]+\*\*\]\(certs/(?:Inactive/)?([^/]+)/README\.md\)') {
                $lineByExam[$Matches[1]] = $line
            }
        }

        $result = @{}
        foreach ($exam in $ExamNames) {
            # Aggregate Applied Skills column: running total spans all logged applied-skills time
            if ($exam -eq $AppliedSkillsColumn) {
                $result[$exam] = '0001-01-01'
                continue
            }

            if (-not $lineByExam.ContainsKey($exam)) {
                Write-Warning "Certification row not found for exam '$exam' in $MainReadme — skipping from running totals"
                continue
            }

            $cells = $lineByExam[$exam] -split '\|'
            if ($cells.Count -lt 5) { continue }

            $durationCell = $cells[4].Trim()
            if ($durationCell -notmatch '(\d{1,2}/\d{1,2}/\d{2,4})') { continue }

            # Parse the start date from the duration cell using individual format attempts
            [datetime]$parsedDate = [datetime]::MinValue
            $startDateText = $Matches[1]
            foreach ($fmt in $dateFormats) {
                if ([datetime]::TryParseExact($startDateText, $fmt, $culture, $styles, [ref]$parsedDate)) {
                    $result[$exam] = $parsedDate.ToString('yyyy-MM-dd')
                    break
                }
            }
        }

        return $result
    }

    function Get-ExamWithRecentActivity {
        # Return exam folder names whose StudyLog.md contains an entry within the last 7 days
        $certsRoot = Join-Path -Path $RepoRoot -ChildPath 'certs'
        $results = [System.Collections.Generic.List[string]]::new()

        if (-not (Test-Path -Path $certsRoot)) { return @() }

        $cutoff = (Get-Date).Date.AddDays(-6)
        $dateFormats = @('M/d/yy', 'M/d/yyyy', 'MM/dd/yy', 'MM/dd/yyyy')
        $culture = [System.Globalization.CultureInfo]::InvariantCulture
        $styles = [System.Globalization.DateTimeStyles]::None

        # Scan every exam's StudyLog.md for recent session entries
        $logFiles = Get-ChildItem -Path $certsRoot -Directory | ForEach-Object {
            $logPath = Join-Path -Path $_.FullName -ChildPath 'StudyLog.md'
            if (Test-Path -Path $logPath) {
                [PSCustomObject]@{ Path = $logPath; Exam = $_.Name }
            }
        }

        foreach ($source in $logFiles) {
            $lines = Get-Content -Path $source.Path -Encoding UTF8
            $found = $false

            foreach ($line in $lines) {
                if ($line -notmatch '^\|\s*\d+\s*\|') { continue }

                $cells = ($line.TrimStart('|').TrimEnd('|')) -split '\|'
                if ($cells.Count -lt 5) { continue }

                $dateCell = $cells[1].Trim()
                [datetime]$parsedDate = [datetime]::MinValue

                foreach ($fmt in $dateFormats) {
                    if ([datetime]::TryParseExact($dateCell, $fmt, $culture, $styles, [ref]$parsedDate)) {
                        if ($parsedDate.Date -ge $cutoff) {
                            $found = $true
                        }
                        break
                    }
                }

                if ($found) { break }
            }

            if ($found) {
                $results.Add($source.Exam)
            }
        }

        return $results.ToArray()
    }

    function Get-AppliedSkillFolder {
        # Return applied-skills topic folder names that contain a StudyLog.md
        $root = Join-Path -Path $RepoRoot -ChildPath 'applied-skills'
        if (-not (Test-Path -Path $root)) { return @() }

        return Get-ChildItem -Path $root -Directory |
            Where-Object {
                $_.Name -notmatch '^\.' -and
                (Test-Path -Path (Join-Path -Path $_.FullName -ChildPath 'StudyLog.md'))
            } |
            ForEach-Object { $_.Name }
    }

    function Get-AppliedSkillInProgress {
        # Return applied-skills topic names whose Status is 'In Progress' in the root README table
        $results = [System.Collections.Generic.List[string]]::new()
        if (-not (Test-Path -Path $MainReadme)) { return @() }

        foreach ($line in Get-Content -Path $MainReadme -Encoding UTF8) {
            # Only consider table rows linking into applied-skills/<topic>/README.md
            if ($line -notmatch '\[\*\*([^\]]+)\*\*\]\(applied-skills/') { continue }
            $topic = $Matches[1].Trim()

            $cells = $line -split '\|'
            if ($cells.Count -ge 5 -and $cells[3].Trim() -like '*In Progress*') {
                $results.Add($topic)
            }
        }

        return $results.ToArray()
    }

    function Test-AppliedSkillActivity {
        # True when any applied-skills topic is In Progress or has a StudyLog entry in the last 7 days
        if (@(Get-AppliedSkillInProgress).Count -gt 0) { return $true }

        $cutoff = (Get-Date).Date.AddDays(-6)
        $dateFormats = @('M/d/yy', 'M/d/yyyy', 'MM/dd/yy', 'MM/dd/yyyy')
        $culture = [System.Globalization.CultureInfo]::InvariantCulture
        $styles = [System.Globalization.DateTimeStyles]::None

        foreach ($topic in (Get-AppliedSkillFolder)) {
            $log = Join-Path -Path $RepoRoot -ChildPath "applied-skills\$topic\StudyLog.md"
            if (-not (Test-Path -Path $log)) { continue }

            foreach ($line in Get-Content -Path $log -Encoding UTF8) {
                if ($line -notmatch '^\|\s*\d+\s*\|') { continue }

                $cells = ($line.TrimStart('|').TrimEnd('|')) -split '\|'
                if ($cells.Count -lt 5) { continue }

                $dateCell = $cells[1].Trim()
                [datetime]$parsed = [datetime]::MinValue
                foreach ($fmt in $dateFormats) {
                    if ([datetime]::TryParseExact($dateCell, $fmt, $culture, $styles, [ref]$parsed)) {
                        if ($parsed.Date -ge $cutoff) { return $true }
                        break
                    }
                }
            }
        }

        return $false
    }

    function Get-AllStudyLogEntry {
        # Read study log entries for active exams, returning flat list of date/exam/duration objects
        param(
            [string[]]$ExamNames
        )

        $entries = [System.Collections.Generic.List[object]]::new()
        $dateFormats = @('M/d/yy', 'M/d/yyyy', 'MM/dd/yy', 'MM/dd/yyyy')
        $culture = [System.Globalization.CultureInfo]::InvariantCulture
        $styles = [System.Globalization.DateTimeStyles]::None

        # Collect log files: one StudyLog per cert exam; all applied-skills topics roll into one column
        $logSources = [System.Collections.Generic.List[object]]::new()
        foreach ($exam in $ExamNames) {
            if ($exam -eq $AppliedSkillsColumn) {
                foreach ($topic in (Get-AppliedSkillFolder)) {
                    $logPath = Join-Path -Path $RepoRoot -ChildPath "applied-skills\$topic\StudyLog.md"
                    if (Test-Path -Path $logPath) {
                        $logSources.Add([PSCustomObject]@{ Path = $logPath; Exam = $AppliedSkillsColumn })
                    }
                }
                continue
            }

            $logPath = Join-Path -Path $RepoRoot -ChildPath "certs\$exam\StudyLog.md"
            if (Test-Path -Path $logPath) {
                $logSources.Add([PSCustomObject]@{ Path = $logPath; Exam = $exam })
            }
        }

        foreach ($source in $logSources) {
            $lines = Get-Content -Path $source.Path -Encoding UTF8

            foreach ($line in $lines) {
                # Match data rows starting with a session number
                if ($line -notmatch '^\|\s*\d+\s*\|') { continue }

                $cells = ($line.TrimStart('|').TrimEnd('|')) -split '\|'
                if ($cells.Count -lt 5) { continue }

                $dateCell = $cells[1].Trim()
                $durationCell = $cells[4].Trim()

                # Parse the date using individual format attempts
                [datetime]$parsedDate = [datetime]::MinValue
                $dateParsed = $false
                foreach ($fmt in $dateFormats) {
                    if ([datetime]::TryParseExact($dateCell, $fmt, $culture, $styles, [ref]$parsedDate)) {
                        $dateParsed = $true
                        break
                    }
                }
                if (-not $dateParsed) { continue }

                # Parse the duration
                if ($durationCell -notmatch '^(?:(\d+)\s*h)?\s*(?:(\d+)\s*m)?$') { continue }
                $hours = if ([string]::IsNullOrWhiteSpace($Matches[1])) { 0 } else { [int]$Matches[1] }
                $minutes = if ([string]::IsNullOrWhiteSpace($Matches[2])) { 0 } else { [int]$Matches[2] }
                $totalMinutes = ($hours * 60) + $minutes
                if ($totalMinutes -eq 0) { continue }

                # Cap unreasonable durations (e.g., auto-closed sessions) at 12 hours
                if ($totalMinutes -gt 720) {
                    Write-Verbose "Capping $($source.Exam) entry on $dateCell from $durationCell to 12h (auto-closed session)"
                    $totalMinutes = 720
                }

                $entries.Add([PSCustomObject]@{
                    Date           = $parsedDate.ToString('yyyy-MM-dd')
                    DateObj        = $parsedDate
                    Exam           = $source.Exam
                    DurationHours  = [math]::Round($totalMinutes / 60.0, 2)
                })
            }
        }

        return $entries.ToArray()
    }

    function Get-ActivityEmoji {
        # Return color-coded emoji based on activity hours
        param(
            [double]$Hours
        )

        if ($Hours -eq 0)     { return '' }
        if ($Hours -lt 1.0)   { return '🟡' }
        if ($Hours -le 2.0)   { return '🟢' }
        return '🟣'
    }

    function Build-ActivityTable {
        # Generate the 7-day rolling activity markdown table from study log entries
        param(
            [array]$Entries,
            [string[]]$TableColumns,
            [hashtable]$CertStartDates
        )

        $today = (Get-Date).Date

        # Build list of dates in reverse chronological order (last 7 days)
        $dates = @()
        for ($i = 0; $i -lt 7; $i++) {
            $dates += $today.AddDays(-$i).ToString('yyyy-MM-dd')
        }

        # Group entries by date and exam
        $byDateExam = @{}
        foreach ($entry in $Entries) {
            $key = "$($entry.Date)|$($entry.Exam)"
            if (-not $byDateExam.ContainsKey($key)) { $byDateExam[$key] = 0.0 }
            $byDateExam[$key] += $entry.DurationHours
        }

        # Initialize markdown table header
        $headerCols = $TableColumns -join ' | '
        $table = "## 📈 Recent Activity (Last 7 Days)`n`n"
        $table += "| Date | $headerCols | Total |`n"

        # Build separator row
        $sepCols = ($TableColumns | ForEach-Object { '------' }) -join '|'
        $table += "|------|$sepCols|-------|`n"

        # Initialize weekly totals
        $weeklyTotals = @{}
        foreach ($col in $TableColumns) { $weeklyTotals[$col] = 0.0 }
        $weeklyGrandTotal = 0.0

        # Build a row for each day in the 7-day window
        foreach ($date in $dates) {
            $dateObj = [datetime]::ParseExact($date, 'yyyy-MM-dd', $null)
            $formattedDate = $dateObj.ToString('ddd, MMM dd')
            $dailyTotal = 0.0
            $colValues = @()

            foreach ($col in $TableColumns) {
                $key = "$date|$col"
                $rawHours = 0.0
                if ($byDateExam.ContainsKey($key)) { $rawHours = $byDateExam[$key] }
                $rounded = [math]::Round($rawHours, 1)
                $weeklyTotals[$col] += $rounded
                $dailyTotal += $rounded

                # Format cell with activity emoji
                $emoji = Get-ActivityEmoji -Hours $rounded
                if ($rounded -gt 0) {
                    $colValues += "$emoji $($rounded.ToString('0.0'))h"
                }
                else {
                    $colValues += ''
                }
            }

            $dailyTotal = [math]::Round($dailyTotal, 1)
            $weeklyGrandTotal += $dailyTotal

            $totalStr = ''
            if ($dailyTotal -gt 0) { $totalStr = "**$($dailyTotal.ToString('0.0'))h**" }

            $colStr = $colValues -join ' | '
            $table += "| $formattedDate | $colStr | $totalStr |`n"
        }

        # Add weekly totals row
        $weeklyCols = ($TableColumns | ForEach-Object {
            "**$($weeklyTotals[$_].ToString('0.0'))h**"
        }) -join ' | '
        $table += "| **Weekly Total** | $weeklyCols | **$($weeklyGrandTotal.ToString('0.0'))h** |`n"

        # Calculate running totals since each certification start date
        $running = @{}
        foreach ($entry in $Entries) {
            $exam = $entry.Exam

            if ($CertStartDates.ContainsKey($exam)) {
                # Only count entries on or after the cert start date
                if ($entry.Date -ge $CertStartDates[$exam]) {
                    if (-not $running.ContainsKey($exam)) { $running[$exam] = 0.0 }
                    $running[$exam] += $entry.DurationHours
                }
            }
        }

        # Add running totals row
        $runningCols = @()
        $runningGrand = 0.0
        foreach ($col in $TableColumns) {
            $val = 0.0
            if ($running.ContainsKey($col)) { $val = [math]::Round($running[$col], 1) }
            $runningGrand += $val
            $runningCols += "***$($val.ToString('0.0'))h***"
        }
        $runningStr = $runningCols -join ' | '
        $table += "| ***Running Total*** | $runningStr | ***$([math]::Round($runningGrand, 1).ToString('0.0'))h*** |`n"

        # Add legend and metadata
        $table += "`n*Activity Levels: 🟡 Low (< 1hr) | 🟢 Medium (1-2hrs) | 🟣 High (> 2hrs)*`n"

        # Add timestamp in Central timezone
        try {
            $centralTz = [System.TimeZoneInfo]::FindSystemTimeZoneById('Central Standard Time')
            $centralTime = [System.TimeZoneInfo]::ConvertTime([datetime]::Now, $centralTz)
            $tzAbbrev = if ($centralTz.IsDaylightSavingTime($centralTime)) { 'CDT' } else { 'CST' }
            $table += "`n*Last updated: $($centralTime.ToString('MMMM dd, yyyy')) at $($centralTime.ToString('HH:mm')) $tzAbbrev*`n"
        }
        catch {
            $table += "`n*Last updated: $(Get-Date -Format 'MMMM dd, yyyy') at $(Get-Date -Format 'HH:mm')*`n"
        }

        return $table
    }

    function Update-ActivityTable {
        [CmdletBinding(SupportsShouldProcess)]

        # Update the Recent Activity table in the root README from study log data
        param(
            [Parameter(Mandatory)]
            [string[]]$ExamNames
        )

        # Sort cert exam columns; keep the aggregate Applied Skills column last (before Total)
        $examCols = @($ExamNames | Where-Object { $_ -ne $AppliedSkillsColumn } | Sort-Object)
        [string[]]$tableColumns = @($examCols)
        if ($ExamNames -contains $AppliedSkillsColumn) {
            $tableColumns += $AppliedSkillsColumn
        }

        # Gather all study log entries across active exams and applied skills
        $allEntries = Get-AllStudyLogEntry -ExamNames $ExamNames

        # Parse certification start dates for running totals
        $certStartDates = Get-CertificationStartDateMap -ExamNames $ExamNames

        # Build the activity table markdown
        $table = Build-ActivityTable -Entries $allEntries -TableColumns $tableColumns -CertStartDates $certStartDates

        Write-Host "`nGenerated activity table:"
        Write-Host $table

        # Read current README and replace between markers
        $startMarker = '<!-- COMMIT_STATS_START -->'
        $endMarker   = '<!-- COMMIT_STATS_END -->'

        if (-not (Test-Path -Path $MainReadme)) {
            Write-Warning "README.md not found: $MainReadme"
            return
        }

        $content = Get-Content -Path $MainReadme -Raw -Encoding UTF8

        if ($content.Contains($startMarker) -and $content.Contains($endMarker)) {
            $pattern = [regex]::Escape($startMarker) + '[\s\S]*?' + [regex]::Escape($endMarker)
            $newSection = "$startMarker`n$table`n$endMarker"
            $newContent = [regex]::Replace($content, $pattern, $newSection)

            if ($WhatIfPreference) {
                Write-Host "What if: Performing the operation ""Update activity table"" on target ""$MainReadme""."
            }
            else {
                Set-Content -Path $MainReadme -Value $newContent -NoNewline -Encoding UTF8
                Write-Host "`nActivity table updated in $MainReadme" -ForegroundColor Green
            }
        }
        else {
            Write-Warning "Activity table markers not found in $MainReadme — skipping."
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
