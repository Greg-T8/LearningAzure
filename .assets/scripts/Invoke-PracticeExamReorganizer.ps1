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
    [string[]]$ExamName
)

# Configuration
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
$CollapseDetailScript = Join-Path -Path $PSScriptRoot -ChildPath 'Invoke-CollapseDetailBlock.ps1'
$GetActiveExamScript = Join-Path -Path $PSScriptRoot -ChildPath 'Get-ActiveExam.ps1'

$Main = {
    . $Helpers

    $exams = Get-TargetExam

    # Reorganize practice questions for each exam
    foreach ($exam in $exams) {
        Write-Host "`n=== Reorganizing $exam ===" -ForegroundColor Cyan
        $ExamName = $exam
        $ExamDir = Join-Path -Path $RepoRoot -ChildPath "certs\$exam"
        $ExamReadme = Join-Path -Path $ExamDir -ChildPath 'README.md'
        $PracticeDir = Join-Path -Path $ExamDir -ChildPath 'practice-questions'
        $PracticeFile = Join-Path -Path $PracticeDir -ChildPath 'README.md'

        # Detect multi-file mode: domain .md files exist beyond README.md
        $MultiFile = Test-MultiFileMode -PracticeDir $PracticeDir

        if ($MultiFile) {
            Write-Verbose "Multi-file mode detected for $exam"
        }
        else {
            Write-Verbose "Single-file mode for $exam"
        }

        Confirm-InputFile
        $domainStructure = Get-DomainStructure

        if ($MultiFile) {
            $questionBlocks = Get-QuestionBlockMulti -PracticeDir $PracticeDir
        }
        else {
            $questionBlocks = Get-QuestionBlock
        }

        # Ensure questionBlocks is always a typed List (PowerShell returns $null for empty lists)
        if (-not $questionBlocks) {
            $questionBlocks = [System.Collections.Generic.List[hashtable]]::new()
        }

        # Sort only if there are questions; otherwise use empty list
        if ($questionBlocks.Count -gt 0) {
            $sortedBlocks = Sort-QuestionBlock -DomainStructure $domainStructure -QuestionBlocks $questionBlocks
        }
        else {
            $sortedBlocks = [System.Collections.Generic.List[hashtable]]::new()
        }

        if ($MultiFile) {
            Write-PracticeFileMulti -DomainStructure $domainStructure -SortedBlocks $sortedBlocks -PracticeDir $PracticeDir
            Update-PracticeIndex -DomainStructure $domainStructure -SortedBlocks $sortedBlocks -PracticeDir $PracticeDir
        }
        else {
            $output = Build-PracticeFile -DomainStructure $domainStructure -SortedBlocks $sortedBlocks
            Write-PracticeFile -Content $output
        }

        Update-CoverageTable -DomainStructure $domainStructure -SortedBlocks $sortedBlocks
        Show-Summary -OriginalCount $questionBlocks.Count -SortedBlocks $sortedBlocks
    }

    # Collapse detail blocks once after all exams are processed
    Invoke-CollapseDetailBlock
}

#region HELPER FUNCTIONS
$Helpers = {

    function New-DeterministicId {
        # Compute SHA-256 hash of the normalized title and return the first 7 hex characters
        param(
            [Parameter(Mandatory)]
            [string]$Title
        )

        $normalized = $Title.Trim().ToLowerInvariant()
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($normalized)
        $hash = [System.Security.Cryptography.SHA256]::HashData($bytes)
        $hex = [System.BitConverter]::ToString($hash).Replace('-', '').ToLowerInvariant()

        return $hex.Substring(0, 7)
    }

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
        # Validate that the exam README, Skills.psd1, and practice questions file exist
        if (-not (Test-Path -Path $ExamReadme)) {
            throw "Exam README not found: $ExamReadme"
        }

        $skillsFile = Join-Path -Path $ExamDir -ChildPath 'Skills.psd1'

        if (-not (Test-Path -Path $skillsFile)) {
            throw "Skills.psd1 not found: $skillsFile"
        }

        if (-not $MultiFile -and -not (Test-Path -Path $PracticeFile)) {
            throw "Practice questions file not found: $PracticeFile"
        }
    }

    function Test-MultiFileMode {
        # Check if the practice-questions directory contains per-domain .md files beyond README.md
        param(
            [Parameter(Mandatory)]
            [string]$PracticeDir
        )

        if (-not (Test-Path -Path $PracticeDir)) {
            return $false
        }

        $domainFiles = Get-ChildItem -Path $PracticeDir -Filter '*.md' |
            Where-Object { $_.Name -ne 'README.md' }

        return ($domainFiles.Count -gt 0)
    }

    function Get-DomainStructure {
        # Load the canonical domain → skill → task ordering from Skills.psd1
        $skillsFile = Join-Path -Path $ExamDir -ChildPath 'Skills.psd1'

        if (-not (Test-Path -Path $skillsFile)) {
            throw "Skills.psd1 not found at '$skillsFile'. Cannot determine canonical domain ordering."
        }

        $data = Import-PowerShellDataFile -Path $skillsFile
        $domains = [System.Collections.Generic.List[hashtable]]::new()

        foreach ($d in $data.Domains) {
            $domain = @{
                Name   = $d.Name
                Skills = [System.Collections.Generic.List[hashtable]]::new()
            }

            foreach ($s in $d.Skills) {
                $skill = @{
                    Name  = $s.Name
                    Tasks = [System.Collections.Generic.List[string]]::new()
                }

                foreach ($t in $s.Tasks) {
                    $skill.Tasks.Add($t)
                }

                $domain.Skills.Add($skill)
            }

            $domains.Add($domain)
        }

        Write-Verbose "Loaded $($domains.Count) domains from $skillsFile"
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
                    $currentBlock.Skill = ($Matches[1].Trim() -replace '\s*\(\d+\s+tasks?\)\s*$', '')
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

        # Build case-insensitive ordering indexes and canonical name maps
        $domainOrder = @{}
        $skillOrder = @{}
        $canonicalDomain = @{}
        $canonicalSkill = @{}

        for ($d = 0; $d -lt $DomainStructure.Count; $d++) {
            $domainName = $DomainStructure[$d].Name
            $domainOrder[$domainName.ToLower()] = $d
            $canonicalDomain[$domainName.ToLower()] = $domainName

            for ($s = 0; $s -lt $DomainStructure[$d].Skills.Count; $s++) {
                $skillName = $DomainStructure[$d].Skills[$s].Name
                $key = "$($domainName.ToLower())|$($skillName.ToLower())"
                $skillOrder[$key] = $s
                $canonicalSkill[$skillName.ToLower()] = $skillName
            }
        }

        # Assign sort keys to each block (case-insensitive lookup, normalize to canonical names)
        $decorated = foreach ($block in $QuestionBlocks) {
            $dKey = $block.Domain.ToLower()
            $dIdx = if ($domainOrder.ContainsKey($dKey)) { $domainOrder[$dKey] } else { 999 }
            $sKey = "$dKey|$($block.Skill.ToLower())"
            $sIdx = if ($skillOrder.ContainsKey($sKey)) { $skillOrder[$sKey] } else { 999 }

            # Answer result priority: wrong → unsure → correct (missing defaults to unsure)
            $rIdx = switch ($block.AnswerResult) {
                'wrong'   { 0 }
                'correct' { 2 }
                default   { 1 }
            }

            # Normalize block metadata to canonical names from the exam README
            if ($canonicalDomain.ContainsKey($dKey)) {
                $block.Domain = $canonicalDomain[$dKey]
            }

            if ($canonicalSkill.ContainsKey($block.Skill.ToLower())) {
                $block.Skill = $canonicalSkill[$block.Skill.ToLower()]
            }

            if ($dIdx -eq 999 -or $sIdx -eq 999) {
                Write-Warning "Unrecognized domain/skill for '$($block.Title)': Domain='$($block.Domain)', Skill='$($block.Skill)'"
            }

            [PSCustomObject]@{
                DomainIndex = $dIdx
                SkillIndex  = $sIdx
                ResultIndex = $rIdx
                Block       = $block
            }
        }

        # Sort by domain index, then skill index, then answer result (wrong first, correct last)
        $sorted = $decorated |
            Sort-Object -Property DomainIndex, SkillIndex, ResultIndex

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
            [AllowEmptyCollection()]
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

                    # Answer result metadata — default to unsure if missing
                    $resultValue = if ($block.AnswerResult) { $block.AnswerResult } else { 'unsure' }
                    [void]$sb.AppendLine("**Answer Result:** $resultValue")

                    # Unique question identifier — generate deterministically from title if missing
                    $idValue = if ($block.ID) { $block.ID } else { New-DeterministicId -Title $block.Title }
                    $block.ID = $idValue
                    [void]$sb.AppendLine("**ID:** $idValue")

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
            [AllowEmptyCollection()]
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

    function Get-QuestionBlockMulti {
        # Parse all per-domain .md files in PracticeDir for ### question blocks
        param(
            [Parameter(Mandatory)]
            [string]$PracticeDir
        )

        $blocks = [System.Collections.Generic.List[hashtable]]::new()

        $domainFiles = Get-ChildItem -Path $PracticeDir -Filter '*.md' |
            Where-Object { $_.Name -ne 'README.md' } |
            Sort-Object Name

        foreach ($file in $domainFiles) {
            Write-Verbose "Parsing multi-file questions from $($file.Name)"
            $lines = Get-Content -Path $file.FullName -Encoding UTF8
            $currentBlock = $null
            $inPreamble = $true

            for ($i = 0; $i -lt $lines.Count; $i++) {
                $line = $lines[$i]

                # Skip preamble before the first --- separator
                if ($inPreamble) {
                    if ($line -match '^---\s*$') {
                        $inPreamble = $false
                    }
                    continue
                }

                # Skip domain heading (#) and skill headings (##) — they will be regenerated
                if ($line -match '^##?\s+' -and $line -notmatch '^###') {
                    continue
                }

                # Question heading: ### <Title> (not ####)
                if ($line -match '^###\s+(.+)$' -and $line -notmatch '^####') {
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
                        $currentBlock.Skill = ($Matches[1].Trim() -replace '\s*\(\d+\s+tasks?\)\s*$', '')
                        continue
                    }

                    # Single-line task
                    if ($line -match '^\*\*Task:\*\*\s+(.+)$') {
                        $currentBlock.Task.Add($Matches[1].Trim())
                        continue
                    }

                    # Standalone **Task:** header (multi-task — bullets follow)
                    if ($line -match '^\*\*Task:\*\*\s*$') {
                        continue
                    }

                    # Multi-task bullet (only before body content starts)
                    if ($line -match '^- (.+)$' -and $currentBlock.Body.Count -eq 0) {
                        $currentBlock.Task.Add($Matches[1].Trim())
                        continue
                    }

                    # --- separator between questions
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

            # Save the last block from this file
            if ($currentBlock) {
                $currentBlock.Body = Trim-BlockBody -Lines $currentBlock.Body
                $blocks.Add($currentBlock)
            }
        }

        Write-Verbose "Parsed $($blocks.Count) question blocks from $($domainFiles.Count) domain files"
        return $blocks
    }

    function Build-DomainFile {
        # Build the content for a single per-domain practice questions file
        param(
            [Parameter(Mandatory)]
            [string]$DomainName,

            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [System.Collections.Generic.List[hashtable]]$DomainBlocks,

            [Parameter(Mandatory)]
            [System.Collections.Generic.List[hashtable]]$DomainStructure
        )

        $sb = [System.Text.StringBuilder]::new()

        # Page title — domain heading
        [void]$sb.AppendLine("# Practice Questions $([char]0x2014) $DomainName")
        [void]$sb.AppendLine()
        [void]$sb.AppendLine('Accounts for questions missed or unsure about in the practice exams.')
        [void]$sb.AppendLine()

        # Build TOC — group blocks by skill
        $groupedBySkill = Group-BlockBySkill -Blocks $DomainBlocks

        if ($groupedBySkill.Count -gt 0) {
            foreach ($skillGroup in $groupedBySkill) {
                $skillAnchor = ConvertTo-Anchor -Text $skillGroup.SkillName
                [void]$sb.AppendLine("* [$($skillGroup.SkillName)](#$skillAnchor)")

                $anchorCounts = @{}
                foreach ($block in $skillGroup.Blocks) {
                    $baseAnchor = ConvertTo-Anchor -Text $block.Title
                    $anchor = Resolve-DuplicateAnchor -BaseAnchor $baseAnchor -AnchorCounts ([ref]$anchorCounts)
                    [void]$sb.AppendLine("  * [$($block.Title)](#$anchor)")
                }
            }
            [void]$sb.AppendLine()
        }

        [void]$sb.AppendLine('---')

        # Find the canonical skill list for this domain from DomainStructure
        $domainDef = $DomainStructure | Where-Object { $_.Name -eq $DomainName }
        $canonicalSkills = if ($domainDef) { $domainDef.Skills } else { @() }

        # Emit all canonical skill headings (even empty ones)
        foreach ($skillDef in $canonicalSkills) {
            [void]$sb.AppendLine()
            [void]$sb.AppendLine("## $($skillDef.Name)")

            # Find questions for this skill
            $skillBlocks = $DomainBlocks | Where-Object { $_.Skill -eq $skillDef.Name }

            foreach ($block in $skillBlocks) {
                [void]$sb.AppendLine()
                [void]$sb.AppendLine("### $($block.Title)")
                [void]$sb.AppendLine()

                # Write metadata
                [void]$sb.AppendLine("**Domain:** $($block.Domain)")
                [void]$sb.AppendLine("**Skill:** $($block.Skill)")

                # Task metadata
                if ($block.Task.Count -eq 1) {
                    [void]$sb.AppendLine("**Task:** $($block.Task[0])")
                }
                elseif ($block.Task.Count -gt 1) {
                    [void]$sb.AppendLine('**Task:**')
                    [void]$sb.AppendLine()
                    foreach ($task in $block.Task) {
                        [void]$sb.AppendLine("- $task")
                    }
                }

                # Answer result metadata — default to unsure if missing
                $resultValue = if ($block.AnswerResult) { $block.AnswerResult } else { 'unsure' }
                [void]$sb.AppendLine("**Answer Result:** $resultValue")

                # Unique question identifier — generate deterministically from title if missing
                $idValue = if ($block.ID) { $block.ID } else { New-DeterministicId -Title $block.Title }
                $block.ID = $idValue
                [void]$sb.AppendLine("**ID:** $idValue")

                [void]$sb.AppendLine()

                # Write body
                foreach ($bodyLine in $block.Body) {
                    [void]$sb.AppendLine($bodyLine)
                }

                [void]$sb.AppendLine()
                [void]$sb.AppendLine('---')
            }
        }

        return $sb.ToString().TrimEnd() + "`n"
    }

    function Group-BlockBySkill {
        # Group blocks by Skill into an ordered list
        param(
            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [object[]]$Blocks
        )

        $result = [System.Collections.Generic.List[hashtable]]::new()
        $currentSkill = $null

        foreach ($block in $Blocks) {
            if (-not $currentSkill -or $currentSkill.SkillName -ne $block.Skill) {
                $currentSkill = @{
                    SkillName = $block.Skill
                    Blocks    = [System.Collections.Generic.List[hashtable]]::new()
                }
                $result.Add($currentSkill)
            }
            $currentSkill.Blocks.Add($block)
        }

        return $result
    }

    function Get-DomainFileName {
        # Map a domain name to its per-domain filename using the DomainStructure index
        param(
            [Parameter(Mandatory)]
            [string]$DomainName,

            [Parameter(Mandatory)]
            [System.Collections.Generic.List[hashtable]]$DomainStructure,

            [Parameter(Mandatory)]
            [string]$PracticeDir
        )

        # Look for existing numbered domain files and match by index
        $domainFiles = Get-ChildItem -Path $PracticeDir -Filter '*.md' |
            Where-Object { $_.Name -ne 'README.md' } |
            Sort-Object Name

        for ($d = 0; $d -lt $DomainStructure.Count; $d++) {
            if ($DomainStructure[$d].Name -eq $DomainName -and $d -lt $domainFiles.Count) {
                return $domainFiles[$d].Name
            }
        }

        # Fallback: should not happen with correctly scaffolded files
        Write-Warning "No domain file found for '$DomainName'"
        return $null
    }

    function Write-PracticeFileMulti {
        # Write reorganized questions to per-domain files
        param(
            [Parameter(Mandatory)]
            [System.Collections.Generic.List[hashtable]]$DomainStructure,

            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [System.Collections.Generic.List[hashtable]]$SortedBlocks,

            [Parameter(Mandatory)]
            [string]$PracticeDir
        )

        # Group sorted blocks by domain
        $blocksByDomain = @{}
        foreach ($block in $SortedBlocks) {
            if (-not $blocksByDomain.ContainsKey($block.Domain)) {
                $blocksByDomain[$block.Domain] = [System.Collections.Generic.List[hashtable]]::new()
            }
            $blocksByDomain[$block.Domain].Add($block)
        }

        # Write each domain file
        foreach ($domainDef in $DomainStructure) {
            $fileName = Get-DomainFileName -DomainName $domainDef.Name -DomainStructure $DomainStructure -PracticeDir $PracticeDir
            if (-not $fileName) { continue }

            $filePath = Join-Path -Path $PracticeDir -ChildPath $fileName

            if ($blocksByDomain.ContainsKey($domainDef.Name)) {
                $domainBlocks = $blocksByDomain[$domainDef.Name]
            }
            else {
                $domainBlocks = [System.Collections.Generic.List[hashtable]]::new()
            }

            $content = Build-DomainFile -DomainName $domainDef.Name -DomainBlocks $domainBlocks -DomainStructure $DomainStructure

            if ($PSCmdlet.ShouldProcess($filePath, 'Write reorganized domain questions')) {
                Set-Content -Path $filePath -Value $content -Encoding UTF8 -NoNewline
                Write-Host "Wrote $($domainBlocks.Count) questions to $fileName" -ForegroundColor Green
            }
        }
    }

    function Update-PracticeIndex {
        # Regenerate the practice-questions/README.md index page with per-domain links and counts
        param(
            [Parameter(Mandatory)]
            [System.Collections.Generic.List[hashtable]]$DomainStructure,

            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [System.Collections.Generic.List[hashtable]]$SortedBlocks,

            [Parameter(Mandatory)]
            [string]$PracticeDir
        )

        # Count questions per domain
        $domainCounts = @{}
        foreach ($block in $SortedBlocks) {
            if ($domainCounts.ContainsKey($block.Domain)) {
                $domainCounts[$block.Domain]++
            }
            else {
                $domainCounts[$block.Domain] = 1
            }
        }

        $sb = [System.Text.StringBuilder]::new()
        [void]$sb.AppendLine("# Practice Exam Questions $([char]0x2014) $ExamName")
        [void]$sb.AppendLine()
        [void]$sb.AppendLine('Accounts for questions missed or unsure about in the practice exams. Questions are organized into per-domain files to keep each file small and responsive.')
        [void]$sb.AppendLine()
        [void]$sb.AppendLine('| # | Domain | File | Qs |')
        [void]$sb.AppendLine('| -: | :----- | :--- | -: |')

        for ($d = 0; $d -lt $DomainStructure.Count; $d++) {
            $domainName = $DomainStructure[$d].Name
            $fileName = Get-DomainFileName -DomainName $domainName -DomainStructure $DomainStructure -PracticeDir $PracticeDir
            $count = if ($domainCounts.ContainsKey($domainName)) { $domainCounts[$domainName] } else { 0 }
            [void]$sb.AppendLine("| $($d + 1) | $domainName | [$fileName]($fileName) | $count |")
        }

        $indexPath = Join-Path -Path $PracticeDir -ChildPath 'README.md'
        $content = $sb.ToString().TrimEnd() + "`n"

        if ($PSCmdlet.ShouldProcess($indexPath, 'Update practice questions index')) {
            Set-Content -Path $indexPath -Value $content -Encoding UTF8 -NoNewline
            Write-Host "Updated practice questions index at $indexPath" -ForegroundColor Green
        }
    }

    function Update-CoverageTable {
        # Update the Qs column in the exam README coverage table based on question metadata
        param(
            [Parameter(Mandatory)]
            [System.Collections.Generic.List[hashtable]]$DomainStructure,

            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
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

    function Invoke-CollapseDetailBlock {
        # Invoke the markdown cleanup script to collapse open details after reorganization
        if (-not (Test-Path -Path $CollapseDetailScript)) {
            throw "Collapse detail script not found: $CollapseDetailScript"
        }

        $invokeParams = @{
            ErrorAction = 'Stop'
            Verbose     = [bool]$PSBoundParameters.ContainsKey('Verbose')
            WhatIf      = [bool]$WhatIfPreference
        }

        if ($PSCmdlet.ShouldProcess($CollapseDetailScript, 'Invoke detail block collapse cleanup')) {
            & $CollapseDetailScript @invokeParams
        }
    }

    function Show-Summary {
        # Display a summary of the reorganization results
        param(
            [Parameter(Mandatory)]
            [int]$OriginalCount,

            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
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

        # Count answer result distribution
        $wrongCount = ($SortedBlocks | Where-Object { $_.AnswerResult -eq 'wrong' }).Count
        $unsureCount = ($SortedBlocks | Where-Object { $_.AnswerResult -eq 'unsure' -or -not $_.AnswerResult }).Count
        $correctCount = ($SortedBlocks | Where-Object { $_.AnswerResult -eq 'correct' }).Count

        Write-Host "  Answer results:     $wrongCount wrong, $unsureCount unsure, $correctCount correct"

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
