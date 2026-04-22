<#
.SYNOPSIS
Render the Focus List in an exam README from its SkillRanking.md.

.DESCRIPTION
Reads certs/<Exam>/SkillRanking.md, sorts tasks by Rank ascending (blank/non-numeric
treated as 0 so unassessed tasks rise to the top), and replaces the content between
the <!-- BEGIN FOCUS LIST --> / <!-- END FOCUS LIST --> markers in the exam README
with a markdown table of the top N lowest-ranked tasks.

.CONTEXT
LearningAzure repository — SC-300 prioritization workflow. Run on demand; not part
of Invoke-ContentMaintenance.

.AUTHOR
Greg Tate

.NOTES
Program: Update-FocusList.ps1
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$Exam = 'SC-300',

    [int]$Top = 20
)

# Configuration
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
$ExamDir = Join-Path -Path $RepoRoot -ChildPath "certs\$Exam"
$RankingFile = Join-Path -Path $ExamDir -ChildPath 'SkillRanking.md'
$ExamReadme = Join-Path -Path $ExamDir -ChildPath 'README.md'

$BeginMarker = '<!-- BEGIN FOCUS LIST -->'
$EndMarker = '<!-- END FOCUS LIST -->'

$Main = {
    . $Helpers

    # Validate inputs
    if (-not (Test-Path -Path $RankingFile)) {
        throw "Ranking file not found: $RankingFile"
    }
    if (-not (Test-Path -Path $ExamReadme)) {
        throw "Exam README not found: $ExamReadme"
    }

    # Parse ranking rows and sort lowest-rank-first (ties keep source order)
    $rows = Read-RankingTable -Path $RankingFile
    $breakdown = Get-RankingBreakdown -Rows $rows
    Write-Verbose "Parsed $($rows.Count) ranking rows from $RankingFile"

    $sorted = $rows | Sort-Object -Property @{ Expression = 'SortRank' }, @{ Expression = 'Index' }
    $top = $sorted | Select-Object -First $Top

    # Build the replacement block
    $block = New-FocusListBlock -Rows $top -Breakdown $breakdown

    # Replace content between markers in the README
    Update-ReadmeBetweenMarkers -Path $ExamReadme -BeginMarker $BeginMarker -EndMarker $EndMarker -NewContent $block -TopCount $script:Top
}

#region HELPER FUNCTIONS
$Helpers = {
    function Read-RankingTable {
        param([Parameter(Mandatory)][string]$Path)

        # Parse the ranking markdown table into typed objects
        $lines = Get-Content -Path $Path -Encoding UTF8
        $results = [System.Collections.Generic.List[object]]::new()
        $headerSeen = $false
        $idx = 0

        foreach ($line in $lines) {
            # Skip non-table lines
            if ($line -notmatch '^\|') { continue }

            # Skip the header separator row
            if ($line -match '^\|\s*[-:]+\s*\|') { continue }

            # First table row is the header (| # | Domain | Skill | Task | Rank |)
            if (-not $headerSeen) {
                $headerSeen = $true
                continue
            }

            # Data row: split into cells
            $cells = ($line.TrimStart('|').TrimEnd('|')) -split '\|'
            if ($cells.Count -lt 5) { continue }

            $rankRaw = $cells[4].Trim()
            $rankNum = 0
            $hasRank = $false
            if ($rankRaw -match '^\d+$') {
                $rankNum = [int]$rankRaw
                $hasRank = $true
            }

            $idx++
            $results.Add([pscustomobject]@{
                Index    = $idx
                Number   = $cells[0].Trim()
                Domain   = $cells[1].Trim()
                Skill    = $cells[2].Trim()
                Task     = $cells[3].Trim()
                Rank     = $rankRaw
                SortRank = if ($hasRank) { $rankNum } else { 0 }
            })
        }

        return $results
    }

    function Get-RankingBreakdown {
        param([Parameter(Mandatory)][object[]]$Rows)

        # Group tasks into fixed ranking buckets for summary display
        $counts = [ordered]@{
            'Unassessed' = 0
            '1' = 0
            '2' = 0
            '3' = 0
            '4' = 0
            '5' = 0
        }

        foreach ($row in $Rows) {
            $rank = "$($row.Rank)".Trim()
            if ($rank -match '^[1-5]$') {
                $counts[$rank]++
            }
            else {
                $counts['Unassessed']++
            }
        }

        $total = [double]$Rows.Count
        $result = [System.Collections.Generic.List[object]]::new()

        foreach ($bucket in $counts.Keys) {
            $count = [int]$counts[$bucket]
            $percent = if ($total -gt 0) { ($count / $total) * 100 } else { 0 }
            $result.Add([pscustomobject]@{
                Ranking = $bucket
                Count = $count
                PercentText = ('{0:0.0}%' -f $percent)
            })
        }

        return $result
    }

    function New-FocusListBlock {
        param(
            [Parameter(Mandatory)][object[]]$Rows,
            [Parameter(Mandatory)][object[]]$Breakdown
        )

        # Build the marker-bracketed block (excluding the markers themselves)
        $lines = [System.Collections.Generic.List[string]]::new()
        $lines.Add('')
        $lines.Add('### Ranking Breakdown')
        $lines.Add('')
        $lines.Add('| Ranking | Tasks | Percentage |')
        $lines.Add('| :------ | ----: | ---------: |')

        foreach ($item in $Breakdown) {
            $rankingLabel = if ($item.Ranking -eq 'Unassessed') { 'Unassessed (blank)' } else { $item.Ranking }
            $lines.Add("| $rankingLabel | $($item.Count) | $($item.PercentText) |")
        }

        $lines.Add('')
        $lines.Add('| # | Domain | Skill | Task | Rank |')
        $lines.Add('| -: | :----- | :---- | :--- | -: |')

        $i = 0
        foreach ($row in $Rows) {
            $i++
            $rankDisplay = if ($row.Rank) { $row.Rank } else { '—' }
            $lines.Add("| $i | $($row.Domain) | $($row.Skill) | $($row.Task) | $rankDisplay |")
        }

        $lines.Add('')

        return $lines -join "`n"
    }

    function Update-ReadmeBetweenMarkers {
        param(
            [Parameter(Mandatory)][string]$Path,
            [Parameter(Mandatory)][string]$BeginMarker,
            [Parameter(Mandatory)][string]$EndMarker,
            [Parameter(Mandatory)][string]$NewContent,
            [Parameter(Mandatory)][int]$TopCount
        )

        # Locate marker pair and substitute the content between them
        $original = Get-Content -Path $Path -Raw -Encoding UTF8

        $beginIdx = $original.IndexOf($BeginMarker)
        $endIdx = $original.IndexOf($EndMarker)

        if ($beginIdx -lt 0) {
            throw "Begin marker not found in $Path : $BeginMarker"
        }
        if ($endIdx -lt 0) {
            throw "End marker not found in $Path : $EndMarker"
        }
        if ($endIdx -lt $beginIdx) {
            throw "End marker appears before begin marker in $Path"
        }

        $before = $original.Substring(0, $beginIdx + $BeginMarker.Length)
        $after  = $original.Substring($endIdx)

        $updated = $before + "`n" + $NewContent + "`n" + $after

        if ($updated -ceq $original) {
            Write-Host "No focus list changes detected in $Path"
            return
        }

        if ($WhatIfPreference) {
            Write-Host "What if: Performing the operation ""Update focus list ($TopCount tasks)"" on target ""$Path""."
        }
        else {
            Set-Content -Path $Path -Value $updated -Encoding UTF8 -NoNewline
            Write-Host "Updated focus list in $Path" -ForegroundColor Green
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
