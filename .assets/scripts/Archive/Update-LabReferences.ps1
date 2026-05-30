<#
.SYNOPSIS
Deterministic lab catalog, statistics, and cross-reference updater.

.DESCRIPTION
Scans lab READMEs for metadata (Domain/Skill/Task), matches labs to practice
exam questions by Task value, then:
  1. Adds practice question links to each lab's metadata section.
  2. Removes legacy Related Labs and Related Practice Exam Questions sections.
  3. Regenerates each exam's hands-on-labs/README.md with accurate statistics
     and catalog entries.

.CONTEXT
LearningAzure repository — deterministic lab catalog and reference management.

.AUTHOR
Greg Tate

.NOTES
Program: Update-LabReferences.ps1
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [string[]]$ExamName
)

# Configuration
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
$GetActiveExamScript = Join-Path -Path $PSScriptRoot -ChildPath 'Get-ActiveExam.ps1'

# Domain display names keyed by exam → folder name
$DomainConfig = @{
    'AZ-104' = [ordered]@{
        'storage'             = 'Storage'
        'compute'             = 'Compute'
        'monitoring'          = 'Monitoring'
        'identity-governance' = 'Identity & Governance'
        'networking'          = 'Networking'
    }
    'AI-102'  = [ordered]@{
        'generative-ai'   = 'Generative AI'
        'agentic'          = 'Agentic'
        'ai-services'      = 'AI Services'
        'computer-vision'  = 'Computer Vision'
        'nlp'              = 'Natural Language Processing'
        'knowledge-mining' = 'Knowledge Mining'
    }
    'AI-900'  = [ordered]@{
        'information-extraction' = 'Information Extraction'
    }
    'AZ-305'  = [ordered]@{
        'identity-governance-monitoring' = 'Identity, Governance & Monitoring'
        'data-storage'                   = 'Data Storage'
        'business-continuity'            = 'Business Continuity'
        'compute'                        = 'Compute'
        'networking'                     = 'Networking'
    }
}

$Main = {
    . $Helpers

    # Auto-discover exams if none specified
    $exams = Get-TargetExam

    foreach ($exam in $exams) {
        Write-Host "`n=== Processing $exam ===" -ForegroundColor Cyan

        $labsDir = Join-Path -Path $RepoRoot -ChildPath "certs\$exam\hands-on-labs"
        $practiceDir = Join-Path -Path $RepoRoot -ChildPath "certs\$exam\practice-questions"
        $practiceFile = Join-Path -Path $practiceDir -ChildPath 'README.md'

        if (-not (Test-Path -Path $labsDir)) {
            Write-Warning "Labs directory not found: $labsDir — skipping $exam"
            continue
        }

        # Detect multi-file mode: per-domain .md files exist beyond README.md
        $multiFile = $false
        if (Test-Path -Path $practiceDir) {
            $domainFiles = Get-ChildItem -Path $practiceDir -Filter '*.md' |
                Where-Object { $_.Name -ne 'README.md' }
            $multiFile = ($domainFiles.Count -gt 0)
        }

        # Step 1: Scan labs and practice questions
        $labs = Get-LabMetadata -LabsDir $labsDir -Exam $exam

        if ($multiFile) {
            $questionIndex = Get-QuestionIndexMulti -PracticeDir $practiceDir
        }
        else {
            $questionIndex = Get-QuestionIndex -PracticeFile $practiceFile
        }

        # Step 2: Update each lab README (add question links, remove related sections)
        if ($labs.Count -gt 0) {
            Update-LabReadme -Labs $labs -QuestionIndex $questionIndex -Exam $exam
        }

        # Step 3: Regenerate the hands-on-labs catalog README
        if (-not $labs) { $labs = @() }
        Update-CatalogReadme -Labs $labs -LabsDir $labsDir -Exam $exam
    }

    Write-Host "`nDone." -ForegroundColor Green
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

        # Get active exams that have a hands-on-labs directory
        $activeExams = & $GetActiveExamScript
        $discovered = [System.Collections.Generic.List[string]]::new()

        foreach ($exam in $activeExams) {
            $labsDir = Join-Path -Path $RepoRoot -ChildPath "certs\$exam\hands-on-labs"

            if (Test-Path -Path $labsDir) {
                $discovered.Add($exam)
            }
        }

        Write-Verbose "Auto-discovered exams: $($discovered -join ', ')"
        return $discovered
    }

    function Get-LabMetadata {
        # Scan all lab-* folders for metadata
        param(
            [Parameter(Mandatory)]
            [string]$LabsDir,

            [Parameter(Mandatory)]
            [string]$Exam
        )

        $catalogReadme = Join-Path -Path $LabsDir -ChildPath 'README.md'
        $labs = [System.Collections.Generic.List[hashtable]]::new()

        $labReadmes = Get-ChildItem -Path $LabsDir -Filter 'README.md' -Recurse -File |
            Where-Object {
                $_.FullName -ne $catalogReadme -and
                (Split-Path -Path $_.DirectoryName -Leaf) -like 'lab-*'
            }

        foreach ($readme in $labReadmes) {
            $labFolder = Split-Path -Path $readme.DirectoryName -Leaf
            $domainFolder = Split-Path -Path (Split-Path -Path $readme.DirectoryName -Parent) -Leaf
            $lines = Get-Content -Path $readme.FullName -Encoding UTF8
            $scanLines = $lines | Select-Object -First 20

            # Extract title from first H1
            $title = ''
            foreach ($line in $scanLines) {
                if ($line -match '^# Lab:\s+(.+)$') {
                    $title = $Matches[1].Trim()
                    break
                }
                if ($line -match '^#\s+(.+)$') {
                    $title = $Matches[1].Trim()
                    break
                }
            }

            # Extract Domain, Skill, Task
            $domain = ''
            $skill = ''
            $tasks = [System.Collections.Generic.List[string]]::new()
            $foundTaskHeader = $false

            foreach ($line in $scanLines) {
                if ($line -match '^\*\*Domain:\*\*\s+(.+)$') {
                    $domain = $Matches[1].Trim()
                }
                if ($line -match '^\*\*Skill:\*\*\s+(.+)$') {
                    $skill = $Matches[1].Trim()
                }

                # Single-line task
                if ($line -match '^\*\*Task:\*\*\s+(.+)$') {
                    $tasks.Add($Matches[1].Trim())
                    continue
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
                    $foundTaskHeader = $false
                }
            }

            if (-not $title) {
                Write-Warning "No title found in $($readme.FullName) — skipping"
                continue
            }

            $labs.Add(@{
                Title        = $title
                Folder       = $labFolder
                DomainFolder = $domainFolder
                Domain       = $domain
                Skill        = $skill
                Tasks        = $tasks
                ReadmePath   = $readme.FullName
            })
        }

        if ($labs.Count -gt 0) {
            $sorted = [System.Collections.Generic.List[hashtable]]::new()
            $labs | Sort-Object { $_.Title } | ForEach-Object { $sorted.Add($_) }
            $labs = $sorted
        }
        Write-Verbose "Found $($labs.Count) labs in $Exam"
        return $labs
    }

    function Get-QuestionIndex {
        # Build an index of practice questions keyed by Task value
        # Returns: hashtable { TaskName → list of { Title, Anchor } }
        param(
            [Parameter(Mandatory)]
            [string]$PracticeFile
        )

        $index = @{}

        if (-not (Test-Path -Path $PracticeFile)) {
            Write-Verbose "No practice questions file at $PracticeFile"
            return $index
        }

        $lines = Get-Content -Path $PracticeFile -Encoding UTF8
        $currentTitle = ''
        $currentAnchor = ''
        $currentTasks = [System.Collections.Generic.List[string]]::new()
        $inQuestion = $false

        foreach ($line in $lines) {
            # Question heading (H4) starts a new block
            if ($line -match '^####\s+(.+)$') {
                # Flush previous question
                if ($inQuestion -and $currentTitle -and $currentTasks.Count -gt 0) {
                    Add-QuestionToIndex -Index $index -Title $currentTitle -Anchor $currentAnchor -Tasks $currentTasks
                }

                $currentTitle = $Matches[1].Trim()
                $currentAnchor = ConvertTo-Anchor -Text $currentTitle
                $currentTasks = [System.Collections.Generic.List[string]]::new()
                $inQuestion = $true
                continue
            }

            if (-not $inQuestion) { continue }

            # Single-line task
            if ($line -match '^\*\*Task:\*\*\s+(.+)$') {
                $currentTasks.Add($Matches[1].Trim())
            }
        }

        # Flush the last question
        if ($inQuestion -and $currentTitle -and $currentTasks.Count -gt 0 -and $currentTasks.Count -gt 0) {
            Add-QuestionToIndex -Index $index -Title $currentTitle -Anchor $currentAnchor -Tasks $currentTasks
        }

        $totalQuestions = ($index.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
        Write-Verbose "Indexed $totalQuestions question-task mappings"
        return $index
    }

    function Get-QuestionIndexMulti {
        # Build a question index from per-domain .md files using ### headings
        # Returns: hashtable { TaskName → list of { Title, Anchor, File } }
        param(
            [Parameter(Mandatory)]
            [string]$PracticeDir
        )

        $index = @{}

        $domainFiles = Get-ChildItem -Path $PracticeDir -Filter '*.md' |
            Where-Object { $_.Name -ne 'README.md' } |
            Sort-Object Name

        foreach ($file in $domainFiles) {
            $lines = Get-Content -Path $file.FullName -Encoding UTF8
            $currentTitle = ''
            $currentAnchor = ''
            $currentTasks = [System.Collections.Generic.List[string]]::new()
            $inQuestion = $false

            foreach ($line in $lines) {
                # Question heading (H3, not H4) starts a new block
                if ($line -match '^###\s+(.+)$' -and $line -notmatch '^####') {
                    # Flush previous question
                    if ($inQuestion -and $currentTitle -and $currentTasks.Count -gt 0) {
                        Add-QuestionToIndexMulti -Index $index -Title $currentTitle -Anchor $currentAnchor -Tasks $currentTasks -FileName $file.Name
                    }

                    $currentTitle = $Matches[1].Trim()
                    $currentAnchor = ConvertTo-Anchor -Text $currentTitle
                    $currentTasks = [System.Collections.Generic.List[string]]::new()
                    $inQuestion = $true
                    continue
                }

                if (-not $inQuestion) { continue }

                # Single-line task
                if ($line -match '^\*\*Task:\*\*\s+(.+)$') {
                    $currentTasks.Add($Matches[1].Trim())
                }
            }

            # Flush the last question from this file
            if ($inQuestion -and $currentTitle -and $currentTasks.Count -gt 0) {
                Add-QuestionToIndexMulti -Index $index -Title $currentTitle -Anchor $currentAnchor -Tasks $currentTasks -FileName $file.Name
            }
        }

        $totalQuestions = ($index.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
        Write-Verbose "Indexed $totalQuestions question-task mappings from $($domainFiles.Count) domain files"
        return $index
    }

    function Add-QuestionToIndexMulti {
        # Add a question to the task-keyed index with per-domain file reference
        param(
            [Parameter(Mandatory)]
            [hashtable]$Index,

            [Parameter(Mandatory)]
            [string]$Title,

            [Parameter(Mandatory)]
            [string]$Anchor,

            [Parameter(Mandatory)]
            [System.Collections.Generic.List[string]]$Tasks,

            [Parameter(Mandatory)]
            [string]$FileName
        )

        foreach ($task in $Tasks) {
            if (-not $Index.ContainsKey($task)) {
                $Index[$task] = [System.Collections.Generic.List[hashtable]]::new()
            }

            $exists = $Index[$task] | Where-Object { $_.Anchor -eq $Anchor -and $_.File -eq $FileName }
            if (-not $exists) {
                $Index[$task].Add(@{
                    Title  = $Title
                    Anchor = $Anchor
                    File   = $FileName
                })
            }
        }
    }

    function Add-QuestionToIndex {
        # Add a question to the task-keyed index
        param(
            [Parameter(Mandatory)]
            [hashtable]$Index,

            [Parameter(Mandatory)]
            [string]$Title,

            [Parameter(Mandatory)]
            [string]$Anchor,

            [Parameter(Mandatory)]
            [System.Collections.Generic.List[string]]$Tasks
        )

        foreach ($task in $Tasks) {
            if (-not $Index.ContainsKey($task)) {
                $Index[$task] = [System.Collections.Generic.List[hashtable]]::new()
            }

            # Avoid duplicate entries for the same anchor
            $exists = $Index[$task] | Where-Object { $_.Anchor -eq $Anchor }
            if (-not $exists) {
                $Index[$task].Add(@{ Title = $Title; Anchor = $Anchor })
            }
        }
    }

    function ConvertTo-Anchor {
        # Convert heading text to GitHub-style anchor slug
        param(
            [Parameter(Mandatory)]
            [string]$Text
        )

        $slug = $Text.ToLower()

        # Remove characters that GitHub strips (keep alphanumeric, spaces, hyphens)
        $slug = $slug -replace '[^a-z0-9\s\-]', ''

        # Replace spaces with hyphens
        $slug = $slug -replace '\s+', '-'

        # Collapse multiple hyphens
        $slug = $slug -replace '-{2,}', '-'

        # Trim leading/trailing hyphens
        $slug = $slug.Trim('-')

        return $slug
    }

    function Update-LabReadme {
        # Update each lab README: add question links to metadata, remove related sections
        param(
            [Parameter(Mandatory)]
            [System.Collections.Generic.List[hashtable]]$Labs,

            [Parameter(Mandatory)]
            [hashtable]$QuestionIndex,

            [Parameter(Mandatory)]
            [string]$Exam
        )

        foreach ($lab in $Labs) {
            $lines = Get-Content -Path $lab.ReadmePath -Encoding UTF8
            $output = [System.Collections.Generic.List[string]]::new()
            $changes = $false

            # Determine the relative path prefix from this lab to practice-questions/
            $practiceRelPrefix = "../../../practice-questions"

            # Find matching questions for this lab's tasks
            $matchedQuestions = [System.Collections.Generic.List[hashtable]]::new()
            foreach ($task in $lab.Tasks) {
                if ($QuestionIndex.ContainsKey($task)) {
                    foreach ($q in $QuestionIndex[$task]) {
                        $exists = $matchedQuestions | Where-Object { $_.Anchor -eq $q.Anchor }
                        if (-not $exists) {
                            $matchedQuestions.Add($q)
                        }
                    }
                }
            }

            # Phase 1: Build output with question links in metadata and without related sections
            $metadataInserted = $false
            $skipRelatedSection = $false

            for ($i = 0; $i -lt $lines.Count; $i++) {
                $line = $lines[$i]

                # Detect the start of any "Related" section to remove
                if ($line -match '^#{2,3}\s+.*[Rr]elated\s+(Labs|Practice)') {
                    $skipRelatedSection = $true
                    $changes = $true
                    continue
                }

                # Also detect the ▶ prefix variant as a heading
                if ($line -match '^#{2,3}\s+▶\s+Related') {
                    $skipRelatedSection = $true
                    $changes = $true
                    continue
                }

                # While skipping, stop when we hit the next H2 or H3 that is NOT a related section
                if ($skipRelatedSection) {
                    if ($line -match '^#{1,2}\s+' -and $line -notmatch '[Rr]elated' -and $line -notmatch '▶') {
                        $skipRelatedSection = $false
                        # Fall through to add this line normally
                    }
                    else {
                        continue
                    }
                }

                # Insert practice question links after **Task:** metadata
                if (-not $metadataInserted -and $line -match '^\*\*Task:\*\*') {
                    $output.Add($line)

                    # Check if this is a multi-task header (no inline value)
                    if ($line -match '^\*\*Task:\*\*\s*$') {
                        # Consume the bullet lines
                        $i++
                        while ($i -lt $lines.Count -and $lines[$i] -match '^- ') {
                            $output.Add($lines[$i])
                            $i++
                        }
                        $i-- # Back up one since the for loop will increment
                    }

                    # Now add the question links after the task metadata
                    if ($matchedQuestions.Count -gt 0) {
                        $output.Add('')
                        $output.Add('**Practice Exam Questions:**')
                        foreach ($q in $matchedQuestions) {
                            # Use per-domain file if available, otherwise fall back to README.md
                            $targetFile = if ($q.ContainsKey('File') -and $q.File) { $q.File } else { 'README.md' }
                            $output.Add("- [$($q.Title)]($practiceRelPrefix/$targetFile#$($q.Anchor))")
                        }
                        $changes = $true
                    }

                    $metadataInserted = $true
                    continue
                }

                # Remove any existing **Practice Exam Questions:** block in metadata area
                if ($line -match '^\*\*Practice Exam Questions:\*\*') {
                    $changes = $true
                    # Skip this line and following bullet lines
                    $i++
                    while ($i -lt $lines.Count -and $lines[$i] -match '^- \[') {
                        $i++
                    }
                    $i-- # Back up for the for loop increment
                    continue
                }

                $output.Add($line)
            }

            # Clean up trailing blank lines and separators
            while ($output.Count -gt 0 -and ($output[$output.Count - 1] -eq '' -or $output[$output.Count - 1] -eq '---')) {
                $output.RemoveAt($output.Count - 1)
                $changes = $true
            }

            # Ensure file ends with a single newline
            $output.Add('')

            if ($changes) {
                $labName = $lab.Folder
                if ($PSCmdlet.ShouldProcess($lab.ReadmePath, "Update lab README for $labName")) {
                    Set-Content -Path $lab.ReadmePath -Value ($output -join "`n") -Encoding UTF8 -NoNewline
                    Write-Host "  Updated: $labName" -ForegroundColor Yellow
                }
            }
            else {
                Write-Verbose "  No changes: $($lab.Folder)"
            }
        }
    }

    function Get-DomainDisplayConfig {
        # Return domain folder → display name mapping, using explicit config or auto-discovery
        param([Parameter(Mandatory)] [string]$Exam)

        if ($DomainConfig.ContainsKey($Exam)) {
            return $DomainConfig[$Exam]
        }

        # Auto-discover domain folders under hands-on-labs
        $labsDir = Join-Path -Path $RepoRoot -ChildPath "certs\$Exam\hands-on-labs"

        if (-not (Test-Path -Path $labsDir)) {
            return [ordered]@{}
        }

        $config = [ordered]@{}

        Get-ChildItem -Path $labsDir -Directory |
            Where-Object { $_.Name -notmatch '^\.' } |
            Sort-Object Name |
            ForEach-Object {
                $displayName = ($_.Name -split '-' | ForEach-Object {
                    $_.Substring(0, 1).ToUpper() + $_.Substring(1)
                }) -join ' '
                $config[$_.Name] = $displayName
            }

        return $config
    }

    function Update-CatalogReadme {
        # Regenerate the hands-on-labs/README.md with statistics and lab listings
        param(
            [Parameter(Mandatory)]
            $Labs,

            [Parameter(Mandatory)]
            [string]$LabsDir,

            [Parameter(Mandatory)]
            [string]$Exam
        )

        $catalogPath = Join-Path -Path $LabsDir -ChildPath 'README.md'
        if (-not (Test-Path -Path $catalogPath)) {
            Write-Warning "Catalog README not found: $catalogPath"
            return
        }

        $domains = Get-DomainDisplayConfig -Exam $Exam

        if ($domains.Count -eq 0) {
            Write-Warning "No domain folders found for $Exam"
            return
        }

        # Group labs by domain folder
        $labsByDomain = @{}
        foreach ($lab in $Labs) {
            if (-not $labsByDomain.ContainsKey($lab.DomainFolder)) {
                $labsByDomain[$lab.DomainFolder] = [System.Collections.Generic.List[hashtable]]::new()
            }
            $labsByDomain[$lab.DomainFolder].Add($lab)
        }

        # Read existing file to preserve title/description and governance section
        $existingLines = Get-Content -Path $catalogPath -Encoding UTF8

        # Extract the title and description (everything before the first ---)
        $headerLines = [System.Collections.Generic.List[string]]::new()
        foreach ($line in $existingLines) {
            if ($line -eq '---') { break }
            $headerLines.Add($line)
        }

        # Extract governance section (everything from ## 📋 onward)
        $governanceLines = [System.Collections.Generic.List[string]]::new()
        $inGovernance = $false
        foreach ($line in $existingLines) {
            if ($line -match '^## 📋') {
                $inGovernance = $true
            }
            if ($inGovernance) {
                $governanceLines.Add($line)
            }
        }

        # Build the output
        $out = [System.Collections.Generic.List[string]]::new()

        # Header
        foreach ($line in $headerLines) { $out.Add($line) }
        $out.Add('')
        $out.Add('---')
        $out.Add('')

        # Statistics
        $out.Add('## 📊 Lab Statistics')
        $out.Add('')
        $out.Add("- **Total Labs**: $($Labs.Count)")
        foreach ($domainFolder in $domains.Keys) {
            $displayName = $domains[$domainFolder]
            $count = if ($labsByDomain.ContainsKey($domainFolder)) { $labsByDomain[$domainFolder].Count } else { 0 }
            $out.Add("- **$displayName**: $count")
        }
        $out.Add('')
        $out.Add('---')
        $out.Add('')

        # Labs section
        $out.Add('## 🧪 Labs')
        $out.Add('')
        foreach ($domainFolder in $domains.Keys) {
            $displayName = $domains[$domainFolder]
            $out.Add("### $displayName")
            $out.Add('')

            if ($labsByDomain.ContainsKey($domainFolder) -and $labsByDomain[$domainFolder].Count -gt 0) {
                $sortedLabs = $labsByDomain[$domainFolder] | Sort-Object { $_.Title }
                foreach ($lab in $sortedLabs) {
                    $description = Get-LabDescription -ReadmePath $lab.ReadmePath
                    $out.Add("- **[$($lab.Title)]($domainFolder/$($lab.Folder)/README.md)** - $description")
                }
            }
            else {
                $out.Add('- No labs available.')
            }

            $out.Add('')
        }

        # Governance
        $out.Add('---')
        $out.Add('')
        foreach ($line in $governanceLines) { $out.Add($line) }

        # Ensure trailing newline
        if ($out[$out.Count - 1] -ne '') { $out.Add('') }

        if ($PSCmdlet.ShouldProcess($catalogPath, "Regenerate catalog README for $Exam")) {
            Set-Content -Path $catalogPath -Value ($out -join "`n") -Encoding UTF8 -NoNewline
            Write-Host "  Regenerated catalog: $catalogPath" -ForegroundColor Green
        }
    }

    function Get-LabDescription {
        # Extract a brief description from the lab's Scenario Analysis or Solution Architecture
        param(
            [Parameter(Mandatory)]
            [string]$ReadmePath
        )

        $lines = Get-Content -Path $ReadmePath -Encoding UTF8
        $title = ''

        # Try to find a description from the first substantive paragraph
        # after "## Exam Question Scenario" or "## Solution Architecture"
        $inSection = $false
        $sectionPriority = @('## Solution Architecture', '## Exam Question Scenario')

        foreach ($section in $sectionPriority) {
            $inSection = $false
            foreach ($line in $lines) {
                if ($line -eq $section) {
                    $inSection = $true
                    continue
                }

                if ($inSection) {
                    # Skip blank lines and sub-headings
                    if ($line -eq '' -or $line -match '^#') { continue }

                    # Skip markdown structure elements
                    if ($line -match '^\*\*' -or $line -match '^>' -or $line -match '^-' -or $line -match '^\|') { continue }

                    # Found a prose paragraph — take the first sentence
                    $desc = $line -replace '\s+', ' '
                    if ($desc.Length -gt 120) {
                        $periodIdx = $desc.IndexOf('.')
                        if ($periodIdx -gt 0 -and $periodIdx -lt 120) {
                            $desc = $desc.Substring(0, $periodIdx + 1)
                        }
                        else {
                            $desc = $desc.Substring(0, 117) + '...'
                        }
                    }
                    return $desc
                }

                # Stop if we hit the next H2
                if ($inSection -and $line -match '^## ' -and $line -ne $section) {
                    break
                }
            }
        }

        return 'Hands-on lab'
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
