<#
.SYNOPSIS
Collapse open detail blocks in practice exam markdown files.

.DESCRIPTION
Scans markdown files under practice-questions folders and individual assessment
files for HTML detail elements with the open attribute and removes it so
explanations render collapsed by default. Also removes empty related-lab lines
such as "▶ Related Lab: []()".

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

            if ($detailBlockCount -eq 0 -and $emptyRelatedLabCount -eq 0) { continue }

            # Build the corrected content
            $updated = [regex]::Replace($content, $Pattern, '<details>', 'IgnoreCase')
            $updated = [regex]::Replace($updated, $EmptyRelatedLabPattern, '', 'IgnoreCase,Multiline')

            # Build a concise action message for WhatIf/ShouldProcess output
            $changeParts = [System.Collections.Generic.List[string]]::new()

            if ($detailBlockCount -gt 0) {
                $changeParts.Add("Collapse $detailBlockCount detail block(s)")
            }

            if ($emptyRelatedLabCount -gt 0) {
                $changeParts.Add("Remove $emptyRelatedLabCount empty related lab line(s)")
            }

            if ($PSCmdlet.ShouldProcess($file.FullName, ($changeParts -join '; '))) {
                Set-Content -Path $file.FullName -Value $updated -NoNewline
            }

            $results.Add([PSCustomObject]@{
                File                 = $file.FullName
                DetailBlockCount     = $detailBlockCount
                EmptyRelatedLabCount = $emptyRelatedLabCount
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
            Write-Host "`nNo open detail blocks or empty related lab lines found." -ForegroundColor Green
            return
        }

        $totalDetailBlocks = ($Results | Measure-Object -Property DetailBlockCount -Sum).Sum
        $totalEmptyRelatedLabs = ($Results | Measure-Object -Property EmptyRelatedLabCount -Sum).Sum
        $actionDetail = if ($WhatIfPreference) { 'would be collapsed' } else { 'collapsed' }
        $actionEmptyLab = if ($WhatIfPreference) { 'would be removed' } else { 'removed' }

        Write-Host "`n--- Summary ---" -ForegroundColor Cyan
        Write-Host "$totalDetailBlocks detail block(s) $actionDetail across $($Results.Count) file(s)" -ForegroundColor Cyan
        Write-Host "$totalEmptyRelatedLabs empty related lab line(s) $actionEmptyLab across $($Results.Count) file(s)" -ForegroundColor Cyan

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

            Write-Host "  $relativePath — $($changeDescriptions -join ', ')" -ForegroundColor Gray
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
