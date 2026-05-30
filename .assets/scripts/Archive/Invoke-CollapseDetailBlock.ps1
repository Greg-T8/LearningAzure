<#
.SYNOPSIS
Collapse open detail blocks in practice exam markdown files.

.DESCRIPTION
Scans markdown files under practice-questions folders and individual assessment
files for: (1) HTML detail elements with the open attribute (removes it so
explanations render collapsed by default), (2) empty related-lab lines such
as "▶ Related Lab: []()", and (3) standalone More Detail / Detail / Details
bold headings (wraps them in collapsible <details> blocks).

.CONTEXT
LearningAzure repository — practice exam content formatting.

.AUTHOR
Greg Tate

.NOTES
Program: Invoke-CollapseDetailBlock.ps1
#>

[CmdletBinding(SupportsShouldProcess)]
param()

# Configuration
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
$Pattern = '<details\s+open\s*>'
$EmptyRelatedLabPattern = '^[ \t]*▶\s*(?:\*\*)?Related Lab:(?:\*\*)?\s*\[\s*\]\(\s*\)\s*(?:\r?\n)?'
$MoreDetailHeadingPattern = '^\*\*((More\s)?Details?):?\*\*[:\s]*$'

$Main = {
    . $Helpers

    $files = Get-TargetFile
    $results = Update-MarkdownFormatting -Files $files
    Show-Summary -Results $results
}

#region HELPER FUNCTIONS
$Helpers = {
    function Get-TargetFile {
        # Collect all markdown files under practice-questions folders
        $mdFiles = [System.Collections.Generic.List[System.IO.FileInfo]]::new()

        # Recurse into every practice-questions directory
        $practiceQuestionDirs = Get-ChildItem -Path $RepoRoot -Directory -Recurse -Filter 'practice-questions'

        foreach ($dir in $practiceQuestionDirs) {
            $files = Get-ChildItem -Path $dir.FullName -Filter '*.md' -File -Recurse

            foreach ($file in $files) {
                $mdFiles.Add($file)
            }
        }

        return $mdFiles
    }

    function Update-MarkdownFormatting {
        # Apply markdown formatting cleanup in each file that contains matches
        param(
            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [System.Collections.Generic.List[System.IO.FileInfo]]$Files
        )

        $results = [System.Collections.Generic.List[PSCustomObject]]::new()

        foreach ($file in $Files) {
            $content = Get-Content -Path $file.FullName -Raw

            # Count current matches before replacing
            $detailBlockCount = ([regex]::Matches($content, $Pattern, 'IgnoreCase')).Count
            $emptyRelatedLabCount = ([regex]::Matches($content, $EmptyRelatedLabPattern, 'IgnoreCase,Multiline')).Count

            # Build the corrected content
            $updated = $content

            if ($detailBlockCount -gt 0) {
                $updated = [regex]::Replace($updated, $Pattern, '<details>', 'IgnoreCase')
            }

            if ($emptyRelatedLabCount -gt 0) {
                $updated = [regex]::Replace($updated, $EmptyRelatedLabPattern, '', 'IgnoreCase,Multiline')
            }

            # Wrap standalone More Detail headings in collapsible blocks
            $moreDetailResult = ConvertTo-CollapsibleMoreDetail -Content $updated
            $updated = $moreDetailResult.Content
            $moreDetailCount = $moreDetailResult.Count

            if ($detailBlockCount -eq 0 -and $emptyRelatedLabCount -eq 0 -and $moreDetailCount -eq 0) { continue }

            # Build a concise action message for WhatIf/ShouldProcess output
            $changeParts = [System.Collections.Generic.List[string]]::new()

            if ($detailBlockCount -gt 0) {
                $changeParts.Add("Collapse $detailBlockCount detail block(s)")
            }

            if ($emptyRelatedLabCount -gt 0) {
                $changeParts.Add("Remove $emptyRelatedLabCount empty related lab line(s)")
            }

            if ($moreDetailCount -gt 0) {
                $changeParts.Add("Wrap $moreDetailCount More Detail section(s)")
            }

            if ($PSCmdlet.ShouldProcess($file.FullName, ($changeParts -join '; '))) {
                Set-Content -Path $file.FullName -Value $updated -NoNewline
            }

            $results.Add([PSCustomObject]@{
                File                 = $file.FullName
                DetailBlockCount     = $detailBlockCount
                EmptyRelatedLabCount = $emptyRelatedLabCount
                MoreDetailCount      = $moreDetailCount
            })
        }

        # Wrap in array operator to prevent PowerShell from unrolling an empty list to $null
        return , $results
    }

    function Show-Summary {
        # Display a summary of files updated and total formatting changes
        param(
            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [System.Collections.Generic.List[PSCustomObject]]$Results
        )

        if (-not $Results -or $Results.Count -eq 0) {
            Write-Host "`nNo open detail blocks, empty related lab lines, or unwrapped More Detail sections found." -ForegroundColor Green
            return
        }

        $totalDetailBlocks = ($Results | Measure-Object -Property DetailBlockCount -Sum).Sum
        $totalEmptyRelatedLabs = ($Results | Measure-Object -Property EmptyRelatedLabCount -Sum).Sum
        $totalMoreDetails = ($Results | Measure-Object -Property MoreDetailCount -Sum).Sum
        $actionDetail = if ($WhatIfPreference) { 'would be collapsed' } else { 'collapsed' }
        $actionEmptyLab = if ($WhatIfPreference) { 'would be removed' } else { 'removed' }
        $actionMoreDetail = if ($WhatIfPreference) { 'would be wrapped' } else { 'wrapped' }

        Write-Host "`n--- Summary ---" -ForegroundColor Cyan
        Write-Host "$totalDetailBlocks detail block(s) $actionDetail across $($Results.Count) file(s)" -ForegroundColor Cyan
        Write-Host "$totalEmptyRelatedLabs empty related lab line(s) $actionEmptyLab across $($Results.Count) file(s)" -ForegroundColor Cyan
        Write-Host "$totalMoreDetails More Detail section(s) $actionMoreDetail across $($Results.Count) file(s)" -ForegroundColor Cyan

        foreach ($result in $Results) {
            # Show workspace-relative path for readability
            $relativePath = $result.File.Replace("$RepoRoot\", '')

            # Show only change types that actually occurred in the file
            $changeDescriptions = [System.Collections.Generic.List[string]]::new()

            if ($result.DetailBlockCount -gt 0) {
                $changeDescriptions.Add("$($result.DetailBlockCount) detail block(s)")
            }

            if ($result.EmptyRelatedLabCount -gt 0) {
                $changeDescriptions.Add("$($result.EmptyRelatedLabCount) empty related lab line(s)")
            }

            if ($result.MoreDetailCount -gt 0) {
                $changeDescriptions.Add("$($result.MoreDetailCount) More Detail section(s)")
            }

            Write-Host "  $relativePath — $($changeDescriptions -join ', ')" -ForegroundColor Gray
        }
    }

    function ConvertTo-CollapsibleMoreDetail {
        # Wrap standalone More Detail / Detail / Details headings in collapsible blocks
        param(
            [Parameter(Mandatory)]
            [string]$Content
        )

        $lineEnding = if ($Content.Contains("`r`n")) { "`r`n" } else { "`n" }
        $lines = $Content -split "`r?`n"
        $result = [System.Collections.Generic.List[string]]::new()
        $inMoreDetail = $false
        $buffer = [System.Collections.Generic.List[string]]::new()
        $headingText = ''
        $count = 0

        for ($i = 0; $i -lt $lines.Count; $i++) {
            $trimmed = $lines[$i].TrimEnd()

            # Detect standalone bold heading (More Detail, Detail, or Details)
            if (-not $inMoreDetail -and $trimmed -match $MoreDetailHeadingPattern) {
                $inMoreDetail = $true
                $headingText = $Matches[1]
                $buffer = [System.Collections.Generic.List[string]]::new()
                $count++
                continue
            }

            if ($inMoreDetail) {
                # Terminate at References heading or closing </details> tag
                if ($trimmed -match '^\*\*References\*\*' -or $trimmed -eq '</details>') {
                    # Trim leading blank lines from buffer
                    while ($buffer.Count -gt 0 -and $buffer[0].Trim() -eq '') {
                        $buffer.RemoveAt(0)
                    }

                    # Trim trailing blank lines from buffer
                    while ($buffer.Count -gt 0 -and $buffer[$buffer.Count - 1].Trim() -eq '') {
                        $buffer.RemoveAt($buffer.Count - 1)
                    }

                    # Emit the collapsible block
                    $result.Add('<details>')
                    $result.Add("<summary>📝 $headingText</summary>")
                    $result.Add('')
                    foreach ($bufLine in $buffer) {
                        $result.Add($bufLine)
                    }
                    $result.Add('')
                    $result.Add('</details>')
                    $result.Add('')
                    $result.Add($lines[$i])
                    $inMoreDetail = $false
                } else {
                    $buffer.Add($lines[$i])
                }
            } else {
                $result.Add($lines[$i])
            }
        }

        # Edge case: file ends while still collecting content
        if ($inMoreDetail -and $buffer.Count -gt 0) {
            while ($buffer.Count -gt 0 -and $buffer[0].Trim() -eq '') {
                $buffer.RemoveAt(0)
            }
            while ($buffer.Count -gt 0 -and $buffer[$buffer.Count - 1].Trim() -eq '') {
                $buffer.RemoveAt($buffer.Count - 1)
            }
            $result.Add('<details>')
            $result.Add("<summary>📝 $headingText</summary>")
            $result.Add('')
            foreach ($bufLine in $buffer) { $result.Add($bufLine) }
            $result.Add('')
            $result.Add('</details>')
        }

        return @{
            Content = $result -join $lineEnding
            Count   = $count
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
