<#
.SYNOPSIS
Update the exam README coverage table with practice question and lab counts.

.DESCRIPTION
Scans practice question metadata (**Domain:**/**Skill:**/**Task:**) and lab README
metadata to count items per task, then updates the Qs and Labs columns in the exam
README coverage table between the BEGIN/END COVERAGE TABLE markers. Also updates
domain-level <summary> tags and the coverage dashboard between BEGIN/END COVERAGE
DASHBOARD markers.

.CONTEXT
LearningAzure repository — exam coverage tracking for practice questions and labs.

.AUTHOR
Greg Tate

.NOTES
Program: Update-CoverageTable.ps1
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidateSet('AI-102', 'AZ-104')]
    [string]$ExamName
)

# Configuration
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
$ExamDir = Join-Path -Path $RepoRoot -ChildPath $ExamName
$ExamReadme = Join-Path -Path $ExamDir -ChildPath 'README.md'
$PracticeFile = Join-Path -Path $ExamDir -ChildPath 'practice-questions\README.md'
$LabsDir = Join-Path -Path $ExamDir -ChildPath 'hands-on-labs'

$Main = {
    . $Helpers

    Confirm-InputFile
    $questionCounts = Get-QuestionCount
    $labCounts = Get-LabCount
    Update-CoverageTable -QuestionCounts $questionCounts -LabCounts $labCounts
    Update-CoverageDashboard -QuestionCounts $questionCounts -LabCounts $labCounts
}

#region HELPER FUNCTIONS
$Helpers = {

    function Confirm-InputFile {
        # Validate that required files and directories exist
        if (-not (Test-Path -Path $ExamReadme)) {
            throw "Exam README not found: $ExamReadme"
        }

        if (-not (Test-Path -Path $PracticeFile)) {
            throw "Practice questions file not found: $PracticeFile"
        }

        if (-not (Test-Path -Path $LabsDir)) {
            throw "Labs directory not found: $LabsDir"
        }
    }

    function Get-QuestionCount {
        # Parse practice questions README to count questions per task
        $lines = Get-Content -Path $PracticeFile -Encoding UTF8
        $taskCounts = @{}
        $currentTasks = [System.Collections.Generic.List[string]]::new()
        $inQuestion = $false

        foreach ($line in $lines) {
            # Question heading starts a new block
            if ($line -match '^####\s+') {
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
            if ($line -match '^- (.+)$' -and $currentTasks.Count -ge 0) {
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

        $total = ($taskCounts.Values | Measure-Object -Sum).Sum
        Write-Verbose "Counted $total question-task mappings from $PracticeFile"
        return $taskCounts
    }

    function Get-LabCount {
        # Parse lab README metadata to count labs per task
        $taskCounts = @{}
        $catalogReadme = Join-Path -Path $LabsDir -ChildPath 'README.md'
        $labReadmes = Get-ChildItem -Path $LabsDir -Filter 'README.md' -Recurse -File |
            Where-Object {
                # Only include specific lab READMEs (for example: */lab-*/README.md)
                $_.FullName -ne $catalogReadme -and (Split-Path -Path $_.DirectoryName -Leaf) -like 'lab-*'
            }

        foreach ($readme in $labReadmes) {
            $lines = Get-Content -Path $readme.FullName -Encoding UTF8
            $tasks = [System.Collections.Generic.List[string]]::new()
            $foundTaskHeader = $false

            # Only scan the first 20 lines for metadata
            $scanLines = $lines | Select-Object -First 20

            foreach ($line in $scanLines) {

                # Single-line task
                if ($line -match '^\*\*Task:\*\*\s+(.+)$') {
                    $tasks.Add($Matches[1].Trim())
                    break
                }

                # Multi-task header (no inline value)
                if ($line -match '^\*\*Task:\*\*\s*$') {
                    $foundTaskHeader = $true
                    continue
                }

                # Multi-task bullet
                if ($foundTaskHeader -and $line -match '^- ([A-Z].+)$') {
                    $tasks.Add($Matches[1].Trim())
                    continue
                }

                # Stop collecting bullets on non-bullet line
                if ($foundTaskHeader -and $tasks.Count -gt 0 -and $line -notmatch '^- ') {
                    break
                }
            }

            if ($tasks.Count -eq 0) {
                $labFolder = Split-Path -Path $readme.DirectoryName -Leaf
                Write-Warning "No **Task:** metadata found in lab '$labFolder'. README path: $($readme.FullName)"
                continue
            }

            # Count each task mapping
            foreach ($t in $tasks) {
                if ($taskCounts.ContainsKey($t)) {
                    $taskCounts[$t]++
                }
                else {
                    $taskCounts[$t] = 1
                }
            }
        }

        $total = ($taskCounts.Values | Measure-Object -Sum).Sum
        Write-Verbose "Counted $total lab-task mappings from $LabsDir"
        return $taskCounts
    }

    function Update-CoverageTable {
        # Replace Qs and Labs values and update <summary> tags in the coverage table
        param(
            [Parameter(Mandatory)]
            [hashtable]$QuestionCounts,

            [Parameter(Mandatory)]
            [hashtable]$LabCounts
        )

        $lines = Get-Content -Path $ExamReadme -Encoding UTF8
        $output = [System.Collections.Generic.List[string]]::new()
        $inCoverage = $false
        $updatedRows = 0

        # Domain-level tracking for <summary> updates
        $domainTaskCount = 0
        $domainQs = 0
        $domainLabs = 0
        $pendingSummaryIndex = -1
        $summarySuffixPattern = '(?:\\u2014|—).*</summary>$'
        $summarySuffix = "— $domainTaskCount tasks · $domainQs Qs · $domainLabs Labs</summary>"

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
                    $summarySuffix = "— $domainTaskCount tasks · $domainQs Qs · $domainLabs Labs</summary>"
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
                    $summarySuffix = "— $domainTaskCount tasks · $domainQs Qs · $domainLabs Labs</summary>"
                    $output[$pendingSummaryIndex] = $output[$pendingSummaryIndex] -replace $summarySuffixPattern, $summarySuffix
                }
                $domainTaskCount = 0
                $domainQs = 0
                $domainLabs = 0
                $pendingSummaryIndex = $output.Count
                $output.Add($line)
                continue
            }

            # Update 4-column task rows: | <skill-or-empty> | <task> | <qs> | <labs> |
            if ($line -match '^\|\s*(.*?)\s*\|\s*(?!Task\b|:---)(.+?)\s+\|\s+\d+\s+\|\s+\d+\s+\|') {
                $skillCell = $Matches[1].Trim()
                $taskName = $Matches[2].Trim()
                $qs = if ($QuestionCounts.ContainsKey($taskName)) { $QuestionCounts[$taskName] } else { 0 }
                $labs = if ($LabCounts.ContainsKey($taskName)) { $LabCounts[$taskName] } else { 0 }
                $newLine = "| $skillCell | $taskName | $qs | $labs |"
                $output.Add($newLine)
                $updatedRows++

                # Accumulate for domain summary
                $domainTaskCount++
                $domainQs += $qs
                $domainLabs += $labs
            }
            else {
                $output.Add($line)
            }
        }

        if ($PSCmdlet.ShouldProcess($ExamReadme, "Update $updatedRows coverage table rows")) {
            Set-Content -Path $ExamReadme -Value ($output -join "`n") -Encoding UTF8 -NoNewline
            Write-Host "Updated $updatedRows coverage rows in $ExamReadme" -ForegroundColor Green
        }

        # Summary
        $totalQs = ($QuestionCounts.Values | Measure-Object -Sum).Sum
        $totalLabs = ($LabCounts.Values | Measure-Object -Sum).Sum
        Write-Host "`nCoverage Summary for $ExamName" -ForegroundColor Cyan
        Write-Host "  Practice questions: $totalQs"
        Write-Host "  Hands-on labs:      $totalLabs"
        Write-Host "  Table rows updated: $updatedRows"
    }

    function Update-CoverageDashboard {
        # Regenerate the coverage dashboard with domain-level aggregates
        param(
            [Parameter(Mandatory)]
            [hashtable]$QuestionCounts,

            [Parameter(Mandatory)]
            [hashtable]$LabCounts
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
                $currentDomain = @{ Qs = 0; Labs = 0; Tasks = 0; Covered = 0 }
                $domainStats[$domainNum] = $currentDomain
                continue
            }

            # Task row (4-column format: | skill | task | qs | labs |)
            if ($null -ne $currentDomain -and $line -match '^\|\s*(.*?)\s*\|\s*(?!Task\b|:---)(.+?)\s+\|\s+\d+\s+\|\s+\d+\s+\|') {
                $taskName = $Matches[2].Trim()
                $qs = if ($QuestionCounts.ContainsKey($taskName)) { $QuestionCounts[$taskName] } else { 0 }
                $labs = if ($LabCounts.ContainsKey($taskName)) { $LabCounts[$taskName] } else { 0 }
                $currentDomain.Tasks++
                $currentDomain.Qs += $qs
                $currentDomain.Labs += $labs
                if ($qs -gt 0 -or $labs -gt 0) { $currentDomain.Covered++ }
            }
        }

        # Second pass: update dashboard rows
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

            # Totals line — regenerate with current counts
            if ($inDashboard -and $line -match '^\*\*Totals:\*\*') {
                $totalQs = ($QuestionCounts.Values | Measure-Object -Sum).Sum
                $totalLabs = ($LabCounts.Values | Measure-Object -Sum).Sum
                $output.Add("**Totals:** $totalQs practice questions · $totalLabs hands-on labs")
                $updatedRows++
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

                    $newLine = "| $domainLink | $weight | $($stats.Qs) | $($stats.Labs) | $($stats.Covered) / $($stats.Tasks) ($pct%) | $indicator |"
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

        if ($updatedRows -gt 0 -and $PSCmdlet.ShouldProcess($ExamReadme, "Update $updatedRows coverage dashboard rows")) {
            Set-Content -Path $ExamReadme -Value ($output -join "`n") -Encoding UTF8 -NoNewline
            Write-Host "Updated $updatedRows dashboard rows in $ExamReadme" -ForegroundColor Green
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
