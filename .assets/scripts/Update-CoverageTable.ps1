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
  - Updates In Progress duration day counts in the certifications table.
  - Generates a 7-day rolling activity table from StudyLog and WorkLog entries,
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

$Main = {
    . $Helpers

    $exams = Get-TargetExam

    # Update coverage for each exam
    foreach ($exam in $exams) {
        try {
            Write-Host "`n=== Updating coverage for $exam ===" -ForegroundColor Cyan
            $ExamName = $exam
            $ExamDir = Join-Path -Path $RepoRoot -ChildPath "certs\$exam"
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
            Write-Warning "Skipping $exam — $_"
        }
    }

    # Update In Progress duration once for all exams
    Update-InProgressDuration

    # Always use full set of active exams for the activity table, regardless of -ExamName scope
    $allActiveExams = & $GetActiveExamScript

    # Update the 7-day activity table in root README from study log data
    Update-ActivityTable -ExamNames $allActiveExams
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
            throw 'No active exams found in main README.'
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
        # Parse study sessions to derive total time and unique study days
        $lines = Get-Content -Path $StudyLogFile -Encoding UTF8
        $totalMinutes = 0
        $studiedDates = [System.Collections.Generic.HashSet[string]]::new()

        foreach ($line in $lines) {
            if ($line -notmatch '^\|\s*\d+\s*\|') { continue }

            $cells = ($line.TrimStart('|').TrimEnd('|')) -split '\|'
            if ($cells.Count -lt 8) { continue }

            $dateCell = $cells[1].Trim()
            $durationCell = $cells[4].Trim()

            if ($durationCell -match '^(?:(\d+)\s*h)?\s*(?:(\d+)\s*m)?$') {
                $hours = if ([string]::IsNullOrWhiteSpace($Matches[1])) { 0 } else { [int]$Matches[1] }
                $minutes = if ([string]::IsNullOrWhiteSpace($Matches[2])) { 0 } else { [int]$Matches[2] }
                $sessionMinutes = ($hours * 60) + $minutes
                $totalMinutes += $sessionMinutes

                if ($sessionMinutes -gt 0 -and -not [string]::IsNullOrWhiteSpace($dateCell)) {
                    $studiedDates.Add($dateCell) | Out-Null
                }
            }
        }

        $totalHours = [math]::Round($totalMinutes / 60, 1)
        return @{
            HoursText = ('{0:N1}h' -f $totalHours)
            DaysStudied = $studiedDates.Count
        }
    }

    function Update-StudySummary {
        [CmdletBinding(SupportsShouldProcess)]

        # Place the study summary directly under Study Log and remove legacy marker locations
        $summary = Get-StudySummary
        $summaryLines = @(
            '<!-- STUDY_SUMMARY -->',
            "**Hours Committed:** $($summary.HoursText) · **Days Studied:** $($summary.DaysStudied)",
            '<!-- /STUDY_SUMMARY -->'
        )
        $lines = Get-Content -Path $ExamReadme -Encoding UTF8
        $filtered = [System.Collections.Generic.List[string]]::new()
        $inserted = $false

        foreach ($line in $lines) {
            if (
                $line -match '<!--\s*HOURS_COMMITTED\s*-->' -or
                $line -match '<!--\s*/HOURS_COMMITTED\s*-->' -or
                $line -match '<!--\s*STUDY_SUMMARY\s*-->' -or
                $line -match '<!--\s*/STUDY_SUMMARY\s*-->' -or
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

    function Update-InProgressDuration {
        [CmdletBinding(SupportsShouldProcess)]

        # Update Duration day counts for all In Progress certifications in root README
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
            # Match any 4-column markdown table row
            if ($line -match '^\|\s*(.+?)\s*\|\s*(.+?)\s*\|\s*(.+?)\s*\|\s*(.+?)\s*\|$') {
                $examCell = $Matches[1].Trim()
                $descriptionCell = $Matches[2].Trim()
                $statusCell = $Matches[3].Trim()
                $durationCell = $Matches[4].Trim()

                # Recalculate duration only for active exams
                if ($statusCell -eq 'In Progress') {
                    if ($durationCell -match '(\d{1,2}/\d{1,2}/\d{2,4})') {
                        $startDateText = $Matches[1]
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
                            $days = ($today - $startDate.Date).Days
                            $todayText = $today.ToString('M/d/yy')
                            $newDuration = "$startDateText – $todayText (${days}d)"
                            $output.Add("| $examCell | $descriptionCell | $statusCell | $newDuration |")
                            $updatedRows++
                            continue
                        }

                        Write-Warning "Could not parse start date '$startDateText' in row: $line"
                    }
                    else {
                        Write-Warning "No start date found for In Progress row: $line"
                    }
                }
            }

            $output.Add($line)
        }

        if ($updatedRows -gt 0) {
            if ($WhatIfPreference) {
                Write-Host "What if: Performing the operation \"Update $updatedRows duration values for In Progress exams\" on target \"$MainReadme\"."
            }
            else {
                Set-Content -Path $MainReadme -Value ($output -join "`n") -Encoding UTF8 -NoNewline
                Write-Host "Updated $updatedRows in-progress duration values in $MainReadme" -ForegroundColor Green
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
        # Aggregate StudyLog durations by Skill and Mode
        # Returns hashtable: skillName → @{ ML; MD; NB; Lab; VPQ; Total }
        $result = @{}

        if (-not (Test-Path -Path $StudyLogFile)) { return $result }

        $lines = Get-Content -Path $StudyLogFile -Encoding UTF8

        foreach ($line in $lines) {
            if ($line -notmatch '^\|\s*\d+\s*\|') { continue }

            $cells = ($line.TrimStart('|').TrimEnd('|')) -split '\|'
            if ($cells.Count -lt 7) { continue }

            $durationCell = $cells[4].Trim()
            $modeCell = $cells[5].Trim()
            $skillCell = $cells[6].Trim()
            $notesCell = if ($cells.Count -ge 8) { $cells[7].Trim() } else { '' }

            # Parse duration
            if ($durationCell -notmatch '^(?:(\d+)\s*h)?\s*(?:(\d+)\s*m)?$') { continue }
            $hours = if ([string]::IsNullOrWhiteSpace($Matches[1])) { 0 } else { [int]$Matches[1] }
            $minutes = if ([string]::IsNullOrWhiteSpace($Matches[2])) { 0 } else { [int]$Matches[2] }
            $sessionHours = ($hours * 60 + $minutes) / 60.0
            if ($sessionHours -eq 0) { continue }
            if ([string]::IsNullOrWhiteSpace($skillCell)) { continue }

            # Initialize skill entry
            if (-not $result.ContainsKey($skillCell)) {
                $result[$skillCell] = @{ ML = 0.0; MD = 0.0; NB = 0.0; Lab = 0.0; PQ = 0.0; Total = 0.0 }
            }

            # Map mode to column key
            $modeKey = switch ($modeCell) {
                'MSLearn'          { 'ML' }
                'MSDocs'           { 'MD' }
                'NotebookLM'       { 'NB' }
                'Lab'              { 'Lab' }
                'PracticeQuestion' { 'PQ' }
                default            { $null }
            }

            if ($modeKey) {
                $result[$skillCell][$modeKey] += $sessionHours
            }
            $result[$skillCell].Total += $sessionHours
        }

        # Round all values
        foreach ($skill in $result.Keys) {
            foreach ($key in @('ML', 'MD', 'NB', 'Lab', 'PQ', 'Total')) {
                $result[$skill][$key] = [math]::Round($result[$skill][$key], 1)
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

    function Update-PerSkillProgress {
        [CmdletBinding(SupportsShouldProcess)]

        # Update Tasks, per-mode hours, and total Hours in the Per-Skill Progress table
        $studyHours = Get-StudyLogHoursBySkill
        $taskCounts = Get-TaskCountBySkill

        $lines = Get-Content -Path $ExamReadme -Encoding UTF8
        $output = [System.Collections.Generic.List[string]]::new()
        $inTracker = $false
        $headerParsed = $false
        $updatedRows = 0

        # Column indices (set from header)
        $colIndices = @{}

        foreach ($line in $lines) {
            if ($line -match '### Per-Skill Progress') {
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
                for ($i = 0; $i -lt $headers.Count; $i++) {
                    $h = $headers[$i].Trim()
                    if ($h -eq 'Skill')  { $colIndices['Skill'] = $i }
                    if ($h -eq 'Tasks')  { $colIndices['Tasks'] = $i }
                    if ($h -eq 'ML')     { $colIndices['ML'] = $i }
                    if ($h -eq 'MD')     { $colIndices['MD'] = $i }
                    if ($h -eq 'NB')     { $colIndices['NB'] = $i }
                    if ($h -eq 'Lab')    { $colIndices['Lab'] = $i }
                    if ($h -eq 'PQ')     { $colIndices['PQ'] = $i }
                    if ($h -eq 'Hours')  { $colIndices['Hours'] = $i }
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

                $skillIdx = $colIndices['Skill']
                if ($null -eq $skillIdx -or $cells.Count -le $skillIdx) {
                    $output.Add($line)
                    continue
                }

                $skillName = $cells[$skillIdx].Trim()

                # Update Tasks column
                if ($colIndices.ContainsKey('Tasks') -and $taskCounts.ContainsKey($skillName)) {
                    $cells[$colIndices['Tasks']] = " $($taskCounts[$skillName]) "
                }

                # Update mode columns and Hours column with study log data
                $skillHours = if ($studyHours.ContainsKey($skillName)) { $studyHours[$skillName] } else { $null }
                $modeKeys = @('ML', 'MD', 'NB', 'Lab', 'PQ')

                foreach ($modeKey in $modeKeys) {
                    if (-not $colIndices.ContainsKey($modeKey)) { continue }
                    $idx = $colIndices[$modeKey]
                    if ($idx -ge $cells.Count) { continue }

                    $currentCell = $cells[$idx].Trim()
                    $modeHours = if ($skillHours) { $skillHours[$modeKey] } else { 0.0 }

                    # Extract existing emoji (first character sequence before any digit or space-digit)
                    $emoji = $currentCell -replace '\s+[\d].*$', ''
                    $emoji = $emoji.Trim()

                    # Build new cell: emoji + hours (omit hours text when zero)
                    if ($modeHours -gt 0) {
                        $cells[$idx] = " $emoji $($modeHours.ToString('0.0'))h "
                    }
                    else {
                        $cells[$idx] = " $emoji "
                    }
                }

                # Update total Hours column
                if ($colIndices.ContainsKey('Hours')) {
                    $totalHours = if ($skillHours) { $skillHours.Total } else { 0.0 }
                    $cells[$colIndices['Hours']] = " $($totalHours.ToString('0.0'))h "
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
        # Parse Per-Skill Progress table and count completed skills per domain
        # Returns ordered hashtable: domainNum → @{ Total; Completed; Skills }
        $lines = Get-Content -Path $ExamReadme -Encoding UTF8
        $domainMap = [ordered]@{}

        # Build domain name → number mapping from dashboard rows
        $nameToNum = @{}
        $inDashboard = $false
        foreach ($line in $lines) {
            if ($line -match '<!-- BEGIN COVERAGE DASHBOARD -->') { $inDashboard = $true; continue }
            if ($line -match '<!-- END COVERAGE DASHBOARD -->') { break }
            if ($inDashboard -and $line -match '^\|\s*\[(\d+)\.\s*(.+?)\]') {
                $nameToNum[$Matches[2].Trim()] = $Matches[1]
            }
        }

        # Parse Per-Skill Progress table for skill completion
        # Supports two formats:
        #   Legacy: separate Status column (value = 'Completed')
        #   Compact: Progress column (completed = cell starts with ✅)
        $inTracker = $false
        $domainCol = -1
        $statusCol = -1
        $progressCol = -1
        $skillsCol = -1
        foreach ($line in $lines) {
            if ($line -match '### Per-Skill Progress') { $inTracker = $true; continue }
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
                    $domainMap[$domainNum] = @{ Total = 0; Completed = 0; Skills = 0 }
                }

                $domainMap[$domainNum].Total++
                $domainMap[$domainNum].Skills++
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

        # Regenerate the coverage dashboard from Per-Skill Progress completion data
        $lines = Get-Content -Path $ExamReadme -Encoding UTF8
        $domainStats = Get-SkillCompletionByDomain

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
                $totalSkills = ($domainStats.Values | ForEach-Object { $_.Total } | Measure-Object -Sum).Sum
                $totalCompleted = ($domainStats.Values | ForEach-Object { $_.Completed } | Measure-Object -Sum).Sum
                $output.Add("**Totals:** $totalCompleted / $totalSkills skills completed")
                $updatedRows++
                continue
            }

            # Legend line
            if ($inDashboard -and $line -match '^\*\*Legend:\*\*') {
                $output.Add('**Legend:** 🟢 Strong (≥66%) · 🟡 Partial (33–65%) · 🔴 Low (<33%) — "Covered" = skill completed in Per-Skill Progress')
                continue
            }

            # Dashboard data row: | [N. Domain Name](#domain-n) | weight | ... |
            if ($inDashboard -and $line -match '^\|\s*\[(\d+)\.') {
                $domainNum = $Matches[1]
                if ($domainStats.Contains($domainNum)) {
                    $stats = $domainStats[$domainNum]

                    # Preserve domain link and weight from existing line
                    $cells = ($line.TrimStart('|').TrimEnd('|')) -split '\|'
                    $domainLink = $cells[0].Trim()
                    $weight = $cells[1].Trim()

                    $pct = if ($stats.Total -gt 0) { [math]::Floor(($stats.Completed / $stats.Total) * 100) } else { 0 }
                    $indicator = if ($pct -ge 66) { '🟢' } elseif ($pct -ge 33) { '🟡' } else { '🔴' }
                    $newLine = "| $domainLink | $weight | $($stats.Skills) | $($stats.Completed) / $($stats.Total) ($pct%) | $indicator |"
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

            if ($line -match '\[\*\*([A-Z]+-\d+)\*\*\]') {
                $lineByExam[$Matches[1]] = $line
            }
        }

        $result = @{}
        foreach ($exam in $ExamNames) {
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

    function Get-AllStudyLogEntry {
        # Read study log entries for active exams and WorkLog, returning flat list of date/exam/duration objects
        param(
            [string[]]$ExamNames
        )

        $entries = [System.Collections.Generic.List[object]]::new()
        $dateFormats = @('M/d/yy', 'M/d/yyyy', 'MM/dd/yy', 'MM/dd/yyyy')
        $culture = [System.Globalization.CultureInfo]::InvariantCulture
        $styles = [System.Globalization.DateTimeStyles]::None

        # Collect log files: one per active exam plus the WorkLog for Other
        $logSources = [System.Collections.Generic.List[object]]::new()
        foreach ($exam in $ExamNames) {
            $logPath = Join-Path -Path $RepoRoot -ChildPath "certs\$exam\StudyLog.md"
            if (Test-Path -Path $logPath) {
                $logSources.Add([PSCustomObject]@{ Path = $logPath; Exam = $exam })
            }
        }

        $workLogPath = Join-Path -Path $RepoRoot -ChildPath '.assets\workflow-development\WorkLog.md'
        if (Test-Path -Path $workLogPath) {
            $logSources.Add([PSCustomObject]@{ Path = $workLogPath; Exam = 'Other' })
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
        $earliestStart = ($CertStartDates.Values | Sort-Object | Select-Object -First 1)

        foreach ($entry in $Entries) {
            $exam = $entry.Exam

            if ($CertStartDates.ContainsKey($exam)) {
                # Only count entries on or after the cert start date
                if ($entry.Date -ge $CertStartDates[$exam]) {
                    if (-not $running.ContainsKey($exam)) { $running[$exam] = 0.0 }
                    $running[$exam] += $entry.DurationHours
                }
            }
            elseif ($exam -eq 'Other') {
                # Other counts from the earliest cert start date
                if ($null -ne $earliestStart -and $entry.Date -ge $earliestStart) {
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
        $table += "`n*Other = Lab workflow and automation design, content structure and development*  `n"

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

        [string[]]$tableColumns = @($ExamNames | Sort-Object) + @('Other')

        # Gather all study log entries across active exams and WorkLog
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
