<#
.SYNOPSIS
Update the exam README coverage table with practice question counts.

.DESCRIPTION
Scans practice question metadata (**Domain:**/**Skill:**/**Task:**) to count
questions per task, then updates the Qs column in the exam README coverage table
between the BEGIN/END COVERAGE TABLE markers. Also updates domain-level <summary>
tags and the coverage dashboard between BEGIN/END COVERAGE DASHBOARD markers.

.CONTEXT
LearningAzure repository — exam coverage tracking for practice questions.

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
        Write-Host "`n=== Updating coverage for $exam ===" -ForegroundColor Cyan
        $ExamName = $exam
        $ExamDir = Join-Path -Path $RepoRoot -ChildPath "certs\$exam"
        $ExamReadme = Join-Path -Path $ExamDir -ChildPath 'README.md'
        $StudyLogFile = Join-Path -Path $ExamDir -ChildPath 'StudyLog.md'
        $PracticeFile = Join-Path -Path $ExamDir -ChildPath 'practice-questions\README.md'

        Confirm-InputFile
        Update-StudySummary
        Update-ExamInProgressDays
        $questionCounts = Get-QuestionCount
        Update-CoverageTable -QuestionCounts $questionCounts
        Update-CoverageDashboard -QuestionCounts $questionCounts
    }

    # Update In Progress duration once for all exams
    Update-InProgressDuration
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

        if (-not (Test-Path -Path $PracticeFile)) {
            throw "Practice questions file not found: $PracticeFile"
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
        $summaryLine = "<!-- STUDY_SUMMARY -->**Hours Committed:** $($summary.HoursText) · **Days Studied:** $($summary.DaysStudied)<!-- /STUDY_SUMMARY -->"
        $lines = Get-Content -Path $ExamReadme -Encoding UTF8
        $filtered = [System.Collections.Generic.List[string]]::new()
        $inserted = $false

        foreach ($line in $lines) {
            if (
                $line -match '<!--\s*HOURS_COMMITTED\s*-->' -or
                $line -match '<!--\s*/HOURS_COMMITTED\s*-->' -or
                $line -match '<!--\s*STUDY_SUMMARY\s*-->' -or
                $line -match '<!--\s*/STUDY_SUMMARY\s*-->'
            ) {
                continue
            }

            $filtered.Add($line)

            if (-not $inserted -and $line -match '^-\s+\*\*Study Log:\*\*') {
                $filtered.Add('')
                $filtered.Add($summaryLine)
                $inserted = $true
            }
        }

        if (-not $inserted) {
            foreach ($line in $lines) {
                if ($line -match '^\*\*Objective:\*\*') {
                    $objectiveIndex = $filtered.IndexOf($line)
                    if ($objectiveIndex -ge 0) {
                        $filtered.Insert($objectiveIndex + 1, '')
                        $filtered.Insert($objectiveIndex + 2, $summaryLine)
                        $inserted = $true
                    }
                    break
                }
            }
        }

        if (-not $inserted) {
            $filtered.Insert(0, $summaryLine)
            $filtered.Insert(1, '')
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
                Write-Host "What if: Performing the operation \"Update $updatedRows in-progress day values\" on target \"$ExamReadme\"."
            }
            else {
                Set-Content -Path $ExamReadme -Value ($output -join "`n") -Encoding UTF8 -NoNewline
                Write-Host "Updated $updatedRows in-progress day values in $ExamReadme" -ForegroundColor Green
            }
        }
    }

    function Get-QuestionCount {
        # Parse practice questions markdown to count questions per task
        $taskCounts = @{}
        $practiceDir = Split-Path -Path $PracticeFile -Parent
        $allPracticeFiles = Get-ChildItem -Path $practiceDir -Filter '*.md' -File
        $questionFiles = @()

        # Use per-domain files when present; otherwise fall back to README-only mode
        $domainFiles = $allPracticeFiles | Where-Object { $_.Name -ne 'README.md' }
        if ($domainFiles.Count -gt 0) {
            $questionFiles = $domainFiles
        }
        else {
            $questionFiles = @($allPracticeFiles | Where-Object { $_.Name -eq 'README.md' })
        }

        foreach ($questionFile in $questionFiles) {
            $lines = Get-Content -Path $questionFile.FullName -Encoding UTF8
            $currentTasks = [System.Collections.Generic.List[string]]::new()
            $inQuestion = $false

            foreach ($line in $lines) {
                # Question heading starts a new block (supports ### and ####)
                if ($line -match '^###\s+') {
                    # Flush previous question's tasks
                    if ($inQuestion) {
                        foreach ($task in $currentTasks) {
                            if ($taskCounts.ContainsKey($task)) {
                                $taskCounts[$task]++
                            }
                            else {
                                $taskCounts[$task] = 1
                            }
                        }
                    }

                    $inQuestion = $true
                    $currentTasks = [System.Collections.Generic.List[string]]::new()
                    continue
                }

                if (-not $inQuestion) { continue }

                # Single-line task
                if ($line -match '^\*\*Task:\*\*\s+(.+)$') {
                    $currentTasks.Add($Matches[1].Trim())
                    continue
                }

                # Multi-task bullet (before body content)
                if ($line -match '^- (.+)$') {
                    # Only count as task bullet if we haven't hit body content yet
                    $candidate = $Matches[1].Trim()

                    # Heuristic: task bullets appear right after **Task:** header
                    if ($line -match '^- [A-Z]') {
                        $currentTasks.Add($candidate)
                    }
                }
            }

            # Flush the last question block
            if ($inQuestion) {
                foreach ($task in $currentTasks) {
                    if ($taskCounts.ContainsKey($task)) {
                        $taskCounts[$task]++
                    }
                    else {
                        $taskCounts[$task] = 1
                    }
                }
            }
        }

        $total = ($taskCounts.Values | Measure-Object -Sum).Sum
        Write-Verbose "Counted $total question-task mappings from $($questionFiles.Count) practice question file(s) in $practiceDir"
        return $taskCounts
    }

    function Update-CoverageTable {
        [CmdletBinding(SupportsShouldProcess)]

        # Replace Qs values and update <summary> tags in the coverage table
        param(
            [Parameter(Mandatory)]
            [hashtable]$QuestionCounts
        )

        $lines = Get-Content -Path $ExamReadme -Encoding UTF8
        $output = [System.Collections.Generic.List[string]]::new()
        $inCoverage = $false
        $updatedRows = 0

        # Domain-level tracking for <summary> updates
        $domainTaskCount = 0
        $domainQs = 0
        $pendingSummaryIndex = -1
        $summarySuffixPattern = '(?:\\u2014|—).*</summary>$'
        $summarySuffix = "— $domainTaskCount tasks · $domainQs Qs</summary>"

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
                    $summarySuffix = "— $domainTaskCount tasks · $domainQs Qs</summary>"
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
                    $summarySuffix = "— $domainTaskCount tasks · $domainQs Qs</summary>"
                    $output[$pendingSummaryIndex] = $output[$pendingSummaryIndex] -replace $summarySuffixPattern, $summarySuffix
                }
                $domainTaskCount = 0
                $domainQs = 0
                $pendingSummaryIndex = $output.Count
                $output.Add($line)
                continue
            }

            # Normalize table headers to question-only columns
            if ($line -match '^\|\s*Skill\s*\|\s*Task\s*\|\s*Qs\s*\|\s*Labs\s*\|$') {
                $output.Add('| Skill | Task | Qs |')
                continue
            }

            if ($line -match '^\|\s*:---\s*\|\s*:---\s*\|\s*-:\s*\|\s*-:\s*\|$') {
                $output.Add('| :--- | :--- | -: |')
                continue
            }

            # Update task rows and write question-only output:
            # | <skill-or-empty> | <task> | <qs> | [<labs> |]
            if ($line -match '^\|\s*(.*?)\s*\|\s*(?!Task\b|:---)(.+?)\s+\|\s+\d+\s+\|\s*(?:\d+\s+\|)?$') {
                $skillCell = $Matches[1].Trim()
                $taskName = $Matches[2].Trim()
                $qs = if ($QuestionCounts.ContainsKey($taskName)) { $QuestionCounts[$taskName] } else { 0 }
                $newLine = "| $skillCell | $taskName | $qs |"
                $output.Add($newLine)
                $updatedRows++

                # Accumulate for domain summary
                $domainTaskCount++
                $domainQs += $qs
            }
            else {
                $output.Add($line)
            }
        }

        $newContent = $output -join "`n"
        $originalContent = $lines -join "`n"
        $hasChanges = $newContent -cne $originalContent

        if ($WhatIfPreference) {
            Write-Host "What if: Performing the operation \"Update $updatedRows coverage table rows\" on target \"$ExamReadme\"."
        }
        else {
            if ($hasChanges) {
                Set-Content -Path $ExamReadme -Value $newContent -Encoding UTF8 -NoNewline
                Write-Host "Updated $updatedRows coverage rows in $ExamReadme" -ForegroundColor Green
            }
            else {
                Write-Host "No coverage table changes detected in $ExamReadme"
            }
        }

        # Summary
        $totalQs = ($QuestionCounts.Values | Measure-Object -Sum).Sum
        Write-Host "`nCoverage Summary for $ExamName" -ForegroundColor Cyan
        Write-Host "  Practice questions: $totalQs"
        Write-Host "  Table rows updated: $updatedRows"
    }

    function Update-CoverageDashboard {
        [CmdletBinding(SupportsShouldProcess)]

        # Regenerate the coverage dashboard with domain-level aggregates
        param(
            [Parameter(Mandatory)]
            [hashtable]$QuestionCounts
        )

        $lines = Get-Content -Path $ExamReadme -Encoding UTF8

        # First pass: compute domain-level aggregates from coverage table
        $domainStats = [ordered]@{}
        $currentDomain = $null
        $inCoverage = $false

        foreach ($line in $lines) {
            if ($line -match '<!-- BEGIN COVERAGE TABLE -->') { $inCoverage = $true; continue }
            if ($line -match '<!-- END COVERAGE TABLE -->') { break }
            if (-not $inCoverage) { continue }

            # Domain heading (supports both markdown heading and details summary formats)
            if ($line -match '^### Domain (\d+):' -or $line -match '^<summary><b>Domain (\d+):') {
                $domainNum = $Matches[1]
                $currentDomain = @{ Qs = 0; Tasks = 0; Covered = 0; Skills = 0 }
                $domainStats[$domainNum] = $currentDomain
                continue
            }

            # Task row (supports both legacy and question-only formats)
            if ($null -ne $currentDomain -and $line -match '^\|\s*(.*?)\s*\|\s*(?!Task\b|:---)(.+?)\s+\|\s+\d+\s+\|\s*(?:\d+\s+\|)?$') {
                $skillCell = $Matches[1].Trim()
                $taskName = $Matches[2].Trim()

                # Count distinct skills (non-empty first cell indicates a new skill)
                if ($skillCell -ne '') { $currentDomain.Skills++ }
                $qs = if ($QuestionCounts.ContainsKey($taskName)) { $QuestionCounts[$taskName] } else { 0 }
                $currentDomain.Tasks++
                $currentDomain.Qs += $qs
                if ($qs -gt 0) { $currentDomain.Covered++ }
            }
        }

        # Second pass: update dashboard rows
        $output = [System.Collections.Generic.List[string]]::new()
        $inDashboard = $false
        $updatedRows = 0

        foreach ($line in $lines) {
            # Keep the dashboard description aligned with question-only coverage
            if ($line -match '^Task-level coverage from ') {
                $output.Add('Task-level coverage from [Practice Questions](./practice-questions/README.md).')
                continue
            }

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

            # Normalize dashboard headers to question-only columns
            if ($inDashboard -and $line -match '^\|\s*Domain\s*\|\s*Weight\s*\|\s*Skills\s*\|\s*Qs\s*\|\s*Labs\s*\|\s*Tasks Covered\s*\|\s*Status\s*\|$') {
                $output.Add('| Domain | Weight | Skills | Qs | Tasks Covered | Status |')
                continue
            }

            if ($inDashboard -and $line -match '^\|\s*:-----\s*\|\s*:-----\s*\|\s*-+:\s*\|\s*-:\s*\|\s*---:\s*\|\s*:------------\s*\|\s*:----:\s*\|$') {
                $output.Add('| :----- | :----- | -----: | -: | :------------ | :----: |')
                continue
            }

            # Totals line — regenerate with current counts
            if ($inDashboard -and $line -match '^\*\*Totals:\*\*') {
                $totalQs = ($QuestionCounts.Values | Measure-Object -Sum).Sum
                $output.Add("**Totals:** $totalQs practice questions")
                $updatedRows++
                continue
            }

            # Legend line — remove lab references
            if ($inDashboard -and $line -match '^\*\*Legend:\*\*') {
                $output.Add('**Legend:** 🟢 Strong (≥66%) · 🟡 Partial (33–65%) · 🔴 Low (<33%) — "Covered" = task has ≥1 practice question')
                continue
            }

            # Dashboard data row: | [N. Domain Name](#domain-n) | weight | ... |
            if ($inDashboard -and $line -match '^\|\s*\[(\d+)\.') {
                $domainNum = $Matches[1]
                if ($domainStats.Contains($domainNum)) {
                    $stats = $domainStats[$domainNum]
                    $pct = if ($stats.Tasks -gt 0) { [math]::Floor(($stats.Covered / $stats.Tasks) * 100) } else { 0 }
                    $indicator = if ($pct -ge 66) { '🟢' } elseif ($pct -ge 33) { '🟡' } else { '🔴' }

                    # Preserve domain link and weight columns from existing line
                    $cells = ($line.TrimStart('|').TrimEnd('|')) -split '\|'
                    $domainLink = $cells[0].Trim()
                    $weight = $cells[1].Trim()

                    $newLine = "| $domainLink | $weight | $($stats.Skills) | $($stats.Qs) | $($stats.Covered) / $($stats.Tasks) ($pct%) | $indicator |"
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
}
#endregion

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
