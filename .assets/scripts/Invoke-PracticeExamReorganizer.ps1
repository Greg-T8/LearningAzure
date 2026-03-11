<#
.SYNOPSIS
Reorganize practice exam questions by domain/skill/task metadata.

.DESCRIPTION
Reads an exam's main README to extract the canonical domain → skill → task
ordering, then parses the practice questions README to extract question blocks
with their **Domain:**/**Skill:**/**Task:** metadata. Sorts question blocks
according to the canonical ordering, regenerates the file with correct headings,
TOC, and ordering, then updates the coverage table in the exam's main README.

.CONTEXT
LearningAzure repository — practice exam organization and coverage tracking.

.AUTHOR
Greg Tate

.NOTES
Program: Invoke-PracticeExamReorganizer.ps1
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

$Main = {
    . $Helpers

    Confirm-InputFile
    $domainStructure = Get-DomainStructure
    $questionBlocks = Get-QuestionBlock
    $sortedBlocks = Sort-QuestionBlock -DomainStructure $domainStructure -QuestionBlocks $questionBlocks
    $output = Build-PracticeFile -DomainStructure $domainStructure -SortedBlocks $sortedBlocks
    Write-PracticeFile -Content $output
    Update-CoverageTable -DomainStructure $domainStructure -SortedBlocks $sortedBlocks
    Show-Summary -OriginalCount $questionBlocks.Count -SortedBlocks $sortedBlocks
}

#region HELPER FUNCTIONS
$Helpers = {

    function Confirm-InputFile {
        # Validate that the exam README and practice questions file exist
        if (-not (Test-Path -Path $ExamReadme)) {
            throw "Exam README not found: $ExamReadme"
        }

        if (-not (Test-Path -Path $PracticeFile)) {
            throw "Practice questions file not found: $PracticeFile"
        }
    }

    function Get-DomainStructure {
        # Parse the exam README coverage table to extract the canonical domain → skill → task ordering
        $lines = Get-Content -Path $ExamReadme -Encoding UTF8
        $inCoverage = $false
        $domains = [System.Collections.Generic.List[hashtable]]::new()
        $currentDomain = $null
        $currentSkill = $null

        foreach ($line in $lines) {
            # Detect coverage table boundaries
            if ($line -match '<!-- BEGIN COVERAGE TABLE -->') {
                $inCoverage = $true
                continue
            }

            if ($line -match '<!-- END COVERAGE TABLE -->') {
                break
            }

            if (-not $inCoverage) {
                continue
            }

            # Domain heading: ### Domain N: <Name> (<Weight>)
            if ($line -match '^### Domain \d+:\s+(.+?)\s+\(') {
                $currentDomain = @{
                    Name   = $Matches[1]
                    Skills = [System.Collections.Generic.List[hashtable]]::new()
                }
                $domains.Add($currentDomain)
                $currentSkill = $null
                continue
            }

            # Task row (4-column format): | <skill-or-empty> | <task> | <qs> | <labs> |
            if ($currentDomain -and $line -match '^\|\s*(.*?)\s*\|\s*(?!Task\b|:---)(.+?)\s+\|\s+\d+\s+\|\s+\d+\s+\|') {
                $skillName = $Matches[1].Trim()
                $taskName = $Matches[2].Trim()

                # Non-empty skill column starts a new skill group
                if ($skillName) {
                    $currentSkill = @{
                        Name  = $skillName
                        Tasks = [System.Collections.Generic.List[string]]::new()
                    }
                    $currentDomain.Skills.Add($currentSkill)
                }

                if ($currentSkill) {
                    $currentSkill.Tasks.Add($taskName)
                }
            }
        }

        Write-Verbose "Parsed $($domains.Count) domains from $ExamReadme"
        return $domains
    }

    function Get-QuestionBlock {
        # Parse the practice questions README to extract individual question blocks with metadata
        $lines = Get-Content -Path $PracticeFile -Encoding UTF8
        $blocks = [System.Collections.Generic.List[hashtable]]::new()
        $currentBlock = $null
        $inPreamble = $true

        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]

            # Skip until we find the first --- separator after the TOC
            if ($inPreamble) {
                if ($line -match '^---\s*$') {
                    $inPreamble = $false
                }

                continue
            }

            # Skip domain headings (##) and skill headings (###) — they will be regenerated
            if ($line -match '^##\s+' -and $line -notmatch '^####') {
                continue
            }

            if ($line -match '^###\s+' -and $line -notmatch '^####') {
                continue
            }

            # Question heading: #### <Title>
            if ($line -match '^####\s+(.+)$') {
                # Save previous block
                if ($currentBlock) {
                    $currentBlock.Body = Trim-BlockBody -Lines $currentBlock.Body
                    $blocks.Add($currentBlock)
                }

                $currentBlock = @{
                    Title  = $Matches[1]
                    Domain = ''
                    Skill  = ''
                    Task   = [System.Collections.Generic.List[string]]::new()
                    Body   = [System.Collections.Generic.List[string]]::new()
                }

                continue
            }

            # Parse metadata lines within a question block
            if ($currentBlock) {
                if ($line -match '^\*\*Domain:\*\*\s+(.+)$') {
                    $currentBlock.Domain = $Matches[1].Trim()
                    continue
                }

                if ($line -match '^\*\*Skill:\*\*\s+(.+)$') {
                    $currentBlock.Skill = $Matches[1].Trim()
                    continue
                }

                # Single-line task: **Task:** <task>
                if ($line -match '^\*\*Task:\*\*\s+(.+)$') {
                    $currentBlock.Task.Add($Matches[1].Trim())
                    continue
                }

                # Standalone **Task:** header (multi-task — bullets follow)
                if ($line -match '^\*\*Task:\*\*\s*$') {
                    continue
                }

                # Multi-task bullet: - <task> (only before body content starts)
                if ($line -match '^- (.+)$' -and $currentBlock.Body.Count -eq 0) {
                    $currentBlock.Task.Add($Matches[1].Trim())
                    continue
                }

                # --- separator between questions — save and reset
                if ($line -match '^---\s*$') {
                    continue
                }

                # Skip leading blank lines before body content starts
                if ($currentBlock.Body.Count -eq 0 -and $line.Trim() -eq '') {
                    continue
                }

                # Accumulate body lines
                $currentBlock.Body.Add($line)
            }
        }

        # Save the last block
        if ($currentBlock) {
            $currentBlock.Body = Trim-BlockBody -Lines $currentBlock.Body
            $blocks.Add($currentBlock)
        }

        Write-Verbose "Parsed $($blocks.Count) question blocks from $PracticeFile"
        return $blocks
    }

    function Trim-BlockBody {
        # Remove leading and trailing empty lines from a block body
        param(
            [object]$Lines
        )

        if (-not $Lines -or $Lines.Count -eq 0) {
            return [System.Collections.Generic.List[string]]::new()
        }

        $arr = [string[]]@($Lines)

        # Trim leading empty lines
        while ($arr.Count -gt 0 -and $arr[0].Trim() -eq '') {
            $arr = $arr[1..($arr.Count - 1)]
        }

        # Trim trailing empty lines
        while ($arr.Count -gt 0 -and $arr[-1].Trim() -eq '') {
            $arr = $arr[0..($arr.Count - 2)]
        }

        if ($arr.Count -eq 0) {
            return [System.Collections.Generic.List[string]]::new()
        }

        return [System.Collections.Generic.List[string]]::new([string[]]$arr)
    }

    function Sort-QuestionBlock {
        # Sort question blocks according to canonical domain → skill ordering
        param(
            [Parameter(Mandatory)]
            [System.Collections.Generic.List[hashtable]]$DomainStructure,

            [Parameter(Mandatory)]
            [System.Collections.Generic.List[hashtable]]$QuestionBlocks
        )

        # Build an ordering index: domain name → position, skill name → position
        $domainOrder = @{}
        $skillOrder = @{}

        for ($d = 0; $d -lt $DomainStructure.Count; $d++) {
            $domainName = $DomainStructure[$d].Name
            $domainOrder[$domainName] = $d

            for ($s = 0; $s -lt $DomainStructure[$d].Skills.Count; $s++) {
                $skillName = $DomainStructure[$d].Skills[$s].Name
                $key = "$domainName|$skillName"
                $skillOrder[$key] = $s
            }
        }

        # Assign sort keys to each block
        $decorated = foreach ($block in $QuestionBlocks) {
            $dIdx = if ($domainOrder.ContainsKey($block.Domain)) { $domainOrder[$block.Domain] } else { 999 }
            $sKey = "$($block.Domain)|$($block.Skill)"
            $sIdx = if ($skillOrder.ContainsKey($sKey)) { $skillOrder[$sKey] } else { 999 }

            if ($dIdx -eq 999 -or $sIdx -eq 999) {
                Write-Warning "Unrecognized domain/skill for '$($block.Title)': Domain='$($block.Domain)', Skill='$($block.Skill)'"
            }

            [PSCustomObject]@{
                DomainIndex = $dIdx
                SkillIndex  = $sIdx
                Block       = $block
            }
        }

        # Sort by domain index, then skill index (preserve relative order within skill)
        $sorted = $decorated |
            Sort-Object -Property DomainIndex, SkillIndex

        $result = [System.Collections.Generic.List[hashtable]]::new()

        foreach ($item in $sorted) {
            $result.Add($item.Block)
        }

        return $result
    }

    function Build-PracticeFile {
        # Assemble the reorganized practice questions file with TOC, headings, and question blocks
        param(
            [Parameter(Mandatory)]
            [System.Collections.Generic.List[hashtable]]$DomainStructure,

            [Parameter(Mandatory)]
            [System.Collections.Generic.List[hashtable]]$SortedBlocks
        )

        $sb = [System.Text.StringBuilder]::new()

        # Page title
        [void]$sb.AppendLine("# Practice Exam Questions - $ExamName")
        [void]$sb.AppendLine()
        [void]$sb.AppendLine("Accounts for questions missed or unsure about in the practice exams.")
        [void]$sb.AppendLine()

        # Build TOC — group blocks by domain then skill
        $groupedByDomain = Group-BlockByDomain -SortedBlocks $SortedBlocks

        foreach ($domainGroup in $groupedByDomain) {
            $domainAnchor = ConvertTo-Anchor -Text $domainGroup.DomainName
            [void]$sb.AppendLine("* [$($domainGroup.DomainName)](#$domainAnchor)")

            foreach ($skillGroup in $domainGroup.Skills) {
                $skillAnchor = ConvertTo-Anchor -Text $skillGroup.SkillName
                [void]$sb.AppendLine("  * [$($skillGroup.SkillName)](#$skillAnchor)")

                # Track duplicate anchors for GitHub-style dedup
                $anchorCounts = @{}

                foreach ($block in $skillGroup.Blocks) {
                    $baseAnchor = ConvertTo-Anchor -Text $block.Title
                    $anchor = Resolve-DuplicateAnchor -BaseAnchor $baseAnchor -AnchorCounts ([ref]$anchorCounts)
                    [void]$sb.AppendLine("    * [$($block.Title)](#$anchor)")
                }
            }
        }

        [void]$sb.AppendLine()
        [void]$sb.AppendLine("---")

        # Build body — domain headings, skill headings, question blocks
        # Reset anchor counts for body anchor consistency
        $globalAnchorCounts = @{}

        foreach ($domainGroup in $groupedByDomain) {
            [void]$sb.AppendLine()
            [void]$sb.AppendLine("## $($domainGroup.DomainName)")

            foreach ($skillGroup in $domainGroup.Skills) {
                [void]$sb.AppendLine()
                [void]$sb.AppendLine("### $($skillGroup.SkillName)")

                foreach ($block in $skillGroup.Blocks) {
                    [void]$sb.AppendLine()
                    [void]$sb.AppendLine("#### $($block.Title)")
                    [void]$sb.AppendLine()

                    # Write metadata
                    [void]$sb.AppendLine("**Domain:** $($block.Domain)")
                    [void]$sb.AppendLine("**Skill:** $($block.Skill)")

                    # Task metadata — inline for single, bullets for multiple
                    if ($block.Task.Count -eq 1) {
                        [void]$sb.AppendLine("**Task:** $($block.Task[0])")
                    }
                    elseif ($block.Task.Count -gt 1) {
                        [void]$sb.AppendLine("**Task:**")
                        [void]$sb.AppendLine()

                        foreach ($task in $block.Task) {
                            [void]$sb.AppendLine("- $task")
                        }
                    }

                    [void]$sb.AppendLine()

                    # Write body
                    foreach ($bodyLine in $block.Body) {
                        [void]$sb.AppendLine($bodyLine)
                    }

                    [void]$sb.AppendLine()
                    [void]$sb.AppendLine("---")
                }
            }
        }

        return $sb.ToString().TrimEnd() + "`n"
    }

    function Group-BlockByDomain {
        # Group sorted blocks into a domain → skill hierarchy for output generation
        param(
            [Parameter(Mandatory)]
            [System.Collections.Generic.List[hashtable]]$SortedBlocks
        )

        $result = [System.Collections.Generic.List[hashtable]]::new()
        $currentDomain = $null
        $currentSkill = $null

        foreach ($block in $SortedBlocks) {
            # New domain group
            if (-not $currentDomain -or $currentDomain.DomainName -ne $block.Domain) {
                $currentDomain = @{
                    DomainName = $block.Domain
                    Skills     = [System.Collections.Generic.List[hashtable]]::new()
                }
                $result.Add($currentDomain)
                $currentSkill = $null
            }

            # New skill group
            if (-not $currentSkill -or $currentSkill.SkillName -ne $block.Skill) {
                $currentSkill = @{
                    SkillName = $block.Skill
                    Blocks    = [System.Collections.Generic.List[hashtable]]::new()
                }
                $currentDomain.Skills.Add($currentSkill)
            }

            $currentSkill.Blocks.Add($block)
        }

        return $result
    }

    function ConvertTo-Anchor {
        # Convert a heading text to a GitHub-compatible anchor link
        param(
            [Parameter(Mandatory)]
            [string]$Text
        )

        $anchor = $Text.ToLower() -replace '[^\w\s-]', '' -replace '\s+', '-'
        return $anchor
    }

    function Resolve-DuplicateAnchor {
        # Append -1, -2, etc. for duplicate anchors (GitHub-style)
        param(
            [Parameter(Mandatory)]
            [string]$BaseAnchor,

            [Parameter(Mandatory)]
            [ref]$AnchorCounts
        )

        if ($AnchorCounts.Value.ContainsKey($BaseAnchor)) {
            $AnchorCounts.Value[$BaseAnchor]++
            return "$BaseAnchor-$($AnchorCounts.Value[$BaseAnchor] - 1)"
        }
        else {
            $AnchorCounts.Value[$BaseAnchor] = 1
            return $BaseAnchor
        }
    }

    function Write-PracticeFile {
        # Write the reorganized content to the practice questions file
        param(
            [Parameter(Mandatory)]
            [string]$Content
        )

        if ($PSCmdlet.ShouldProcess($PracticeFile, 'Write reorganized practice questions')) {
            Set-Content -Path $PracticeFile -Value $Content -Encoding UTF8 -NoNewline
            Write-Host "Wrote reorganized practice questions to $PracticeFile" -ForegroundColor Green
        }
    }

    function Update-CoverageTable {
        # Update the Qs column in the exam README coverage table based on question metadata
        param(
            [Parameter(Mandatory)]
            [System.Collections.Generic.List[hashtable]]$DomainStructure,

            [Parameter(Mandatory)]
            [System.Collections.Generic.List[hashtable]]$SortedBlocks
        )

        # Count questions per task
        $taskCounts = @{}

        foreach ($block in $SortedBlocks) {
            foreach ($task in $block.Task) {
                if ($taskCounts.ContainsKey($task)) {
                    $taskCounts[$task]++
                }
                else {
                    $taskCounts[$task] = 1
                }
            }
        }

        # Read the exam README and update Qs values (preserving Labs column)
        $lines = Get-Content -Path $ExamReadme -Encoding UTF8
        $output = [System.Collections.Generic.List[string]]::new()
        $inCoverage = $false
        $updated = 0

        foreach ($line in $lines) {
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

            # Match 4-column rows: | <skill-or-empty> | <task> | <qs> | <labs> |
            if ($inCoverage -and $line -match '^\|\s*(.*?)\s*\|\s*(?!Task\b|:---)(.+?)\s+\|\s+\d+\s+\|\s+(\d+)\s+\|') {
                $skillCell = $Matches[1].Trim()
                $taskName = $Matches[2].Trim()
                $existingLabs = $Matches[3]
                $count = if ($taskCounts.ContainsKey($taskName)) { $taskCounts[$taskName] } else { 0 }
                $newLine = "| $skillCell | $taskName | $count | $existingLabs |"
                $output.Add($newLine)
                $updated++
            }
            else {
                $output.Add($line)
            }
        }

        if ($PSCmdlet.ShouldProcess($ExamReadme, "Update $updated coverage table rows")) {
            Set-Content -Path $ExamReadme -Value ($output -join "`n") -Encoding UTF8 -NoNewline
            Write-Host "Updated $updated coverage table rows in $ExamReadme" -ForegroundColor Green
        }
    }

    function Show-Summary {
        # Display a summary of the reorganization results
        param(
            [Parameter(Mandatory)]
            [int]$OriginalCount,

            [Parameter(Mandatory)]
            [System.Collections.Generic.List[hashtable]]$SortedBlocks
        )

        $finalCount = $SortedBlocks.Count

        # Count questions missing metadata
        $missingDomain = ($SortedBlocks | Where-Object { -not $_.Domain }).Count
        $missingSkill = ($SortedBlocks | Where-Object { -not $_.Skill }).Count
        $missingTask = ($SortedBlocks | Where-Object { $_.Task.Count -eq 0 }).Count

        Write-Host "`nReorganization Summary for $ExamName" -ForegroundColor Cyan
        Write-Host "  Questions parsed:   $OriginalCount"
        Write-Host "  Questions written:  $finalCount"

        if ($OriginalCount -ne $finalCount) {
            Write-Warning "Question count mismatch! Parsed $OriginalCount but wrote $finalCount."
        }
        else {
            Write-Host "  Count verified:     OK" -ForegroundColor Green
        }

        # Report metadata gaps
        if ($missingDomain -gt 0 -or $missingSkill -gt 0 -or $missingTask -gt 0) {
            Write-Warning "Metadata gaps: $missingDomain missing Domain, $missingSkill missing Skill, $missingTask missing Task"
        }
        else {
            Write-Host "  All metadata present: OK" -ForegroundColor Green
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
