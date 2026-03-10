<#
.SYNOPSIS
Collapse open detail blocks in practice exam markdown files.

.DESCRIPTION
Scans markdown files under practice-questions folders and individual assessment
files for HTML detail elements with the open attribute and removes it so
explanations render collapsed by default.

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

$Main = {
    . $Helpers

    $files = Get-TargetFile
    $results = Update-DetailBlock -Files $files
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

    function Update-DetailBlock {
        # Replace <details open> with <details> in each file that contains matches
        param(
            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [System.Collections.Generic.List[System.IO.FileInfo]]$Files
        )

        $results = [System.Collections.Generic.List[PSCustomObject]]::new()

        foreach ($file in $Files) {
            $content = Get-Content -Path $file.FullName -Raw

            # Count matches before replacing
            $matchCount = ([regex]::Matches($content, $Pattern, 'IgnoreCase')).Count

            if ($matchCount -eq 0) { continue }

            # Build the corrected content
            $updated = [regex]::Replace($content, $Pattern, '<details>', 'IgnoreCase')

            if ($PSCmdlet.ShouldProcess($file.FullName, "Collapse $matchCount detail block(s)")) {
                Set-Content -Path $file.FullName -Value $updated -NoNewline
            }

            $results.Add([PSCustomObject]@{
                File  = $file.FullName
                Count = $matchCount
            })
        }

        # Wrap in array operator to prevent PowerShell from unrolling an empty list to $null
        return , $results
    }

    function Show-Summary {
        # Display a summary of files updated and total blocks collapsed
        param(
            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [System.Collections.Generic.List[PSCustomObject]]$Results
        )

        if (-not $Results -or $Results.Count -eq 0) {
            Write-Host "`nNo open detail blocks found. All explanations are already collapsed." -ForegroundColor Green
            return
        }

        $totalBlocks = ($Results | Measure-Object -Property Count -Sum).Sum
        $action = if ($WhatIfPreference) { 'would be collapsed' } else { 'collapsed' }

        Write-Host "`n--- Summary ---" -ForegroundColor Cyan
        Write-Host "$totalBlocks detail block(s) $action across $($Results.Count) file(s)" -ForegroundColor Cyan

        foreach ($result in $Results) {
            # Show workspace-relative path for readability
            $relativePath = $result.File.Replace("$RepoRoot\", '')
            Write-Host "  $relativePath — $($result.Count) block(s)" -ForegroundColor Gray
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
