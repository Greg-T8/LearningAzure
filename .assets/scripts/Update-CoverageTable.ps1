<#
.SYNOPSIS
Update the exam README coverage table with practice question and lab counts.

.DESCRIPTION
Scans practice question metadata (**Domain:**/**Skill:**/**Task:**) and lab README
metadata to count items per task, then updates the Qs and Labs columns in the exam
README coverage table between the BEGIN/END COVERAGE TABLE markers.

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
        $labReadmes = Get-ChildItem -Path $LabsDir -Filter 'README.md' -Recurse -File

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
                Write-Warning "No **Task:** metadata found in $($readme.FullName)"
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
        # Replace Qs and Labs values in the exam README coverage table
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

        foreach ($line in $lines) {
            # Detect coverage table boundaries
            if ($line -match '<!-- BEGIN COVERAGE TABLE -->') {
                $inCoverage = $true
                $output.Add($line)
                continue
            }

            if ($line -match '<!-- END COVERAGE TABLE -->') {
                $inCoverage = $false
                $output.Add($line)
                continue
            }

            # Update task rows: | <task> | <qs> | <labs> |
            if ($inCoverage -and $line -match '^\|\s+(?!Task\b|:---)(.+?)\s+\|\s+\d+\s+\|\s+\d+\s+\|') {
                $taskName = $Matches[1].Trim()
                $qs = if ($QuestionCounts.ContainsKey($taskName)) { $QuestionCounts[$taskName] } else { 0 }
                $labs = if ($LabCounts.ContainsKey($taskName)) { $LabCounts[$taskName] } else { 0 }
                $newLine = "| $taskName | $qs | $labs |"
                $output.Add($newLine)
                $updatedRows++
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
}
#endregion

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
