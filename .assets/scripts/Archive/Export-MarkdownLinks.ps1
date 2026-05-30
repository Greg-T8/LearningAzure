<#
.SYNOPSIS
Export flat URLs from a markdown file or a named section and its subsections.

.DESCRIPTION
Parses a markdown file and extracts unique URLs from markdown links,
either from the full file or from a named heading and its subsections.

When -Section is provided, the script locates the first heading matching the
specified section name (case-insensitive), then captures all content through
its subsections until a heading at the same or higher level.

Output defaults to a .txt file in the same directory as the input markdown
file, named <input-basename>-links.txt. Use -OutputPath to override.

.PARAMETER Path
Full or relative path to the markdown (.md) file to parse.

.PARAMETER Section
The heading text to match (without leading # characters).
Matches the first occurrence, case-insensitive. If omitted, the script
processes the entire markdown file.

.PARAMETER OutputPath
Optional path for the output .txt file. Defaults to the same directory
as the input file with the name <input-basename>-links.txt.

.EXAMPLE
.\Export-MarkdownLinks.ps1 -Path "..\..\certs\AZ-305\research-guides\guide.md" -Section "Recommend a logging solution"

.EXAMPLE
.\Export-MarkdownLinks.ps1 -Path "guide.md" -Section "Core docs you must read" -OutputPath "C:\temp\core-links.txt"

.EXAMPLE
.\Export-MarkdownLinks.ps1 -Path "guide.md"

.CONTEXT
LearningAzure repository — utility for extracting reference URLs from research guides.

.AUTHOR
Greg Tate

.NOTES
Program: Export-MarkdownLinks.ps1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Path,

    [string]$Section,

    [string]$OutputPath
)

# Resolve the input path from the caller's working directory before Push-Location
if ($Path -and (Test-Path -Path $Path)) {
    $Path = (Resolve-Path -Path $Path).Path
}

$Main = {
    . $Helpers

    # Validate the input file exists and is markdown
    $resolvedPath = Resolve-InputFile

    # Read the markdown content
    $lines = Get-Content -Path $resolvedPath -Encoding UTF8

    # Determine whether to process a specific section or the full file
    if ([string]::IsNullOrWhiteSpace($Section)) {
        $range = @{ Start = 0; End = $lines.Count - 1 }
        Write-Verbose "No section specified. Processing full file (lines 1-$($lines.Count))."
    }
    else {
        # Find the line range for the target section and its subsections
        $range = Find-SectionRange -Lines $lines
    }

    # Extract unique URLs from markdown links within the section
    $urls = @(Get-MarkdownLink -Lines $lines -Range $range)

    # Write the URLs to the output text file
    Export-LinkFile -Urls $urls -SourcePath $resolvedPath

    # Display a summary of the extraction
    Show-Summary -Urls $urls
}

#region HELPER FUNCTIONS
$Helpers = {
    function Resolve-InputFile {
        # Validate that the input path exists and points to a markdown file
        if (-not (Test-Path -Path $Path)) {
            throw "Input file not found: $Path"
        }

        $resolved = (Resolve-Path -Path $Path).Path

        if ([System.IO.Path]::GetExtension($resolved) -ne '.md') {
            throw "Input file is not a markdown file (.md): $resolved"
        }

        return $resolved
    }

    function Find-SectionRange {
        # Locate the first heading matching -Section and return the start/end line indices
        param(
            [Parameter(Mandatory)]
            [AllowEmptyString()]
            [string[]]$Lines
        )

        $startIndex = -1
        $sectionLevel = 0

        # Find the matching heading
        for ($i = 0; $i -lt $Lines.Count; $i++) {
            if ($Lines[$i] -match '^(#{1,6})\s+(.+)$') {
                $level = $Matches[1].Length
                $headingText = $Matches[2].Trim()

                if ($headingText -ieq $Section) {
                    $startIndex = $i
                    $sectionLevel = $level
                    break
                }
            }
        }

        if ($startIndex -eq -1) {
            throw "Section not found: '$Section'"
        }

        # Find the end of the section (next heading at same or higher level)
        $endIndex = $Lines.Count - 1

        for ($i = $startIndex + 1; $i -lt $Lines.Count; $i++) {
            if ($Lines[$i] -match '^(#{1,6})\s+') {
                $level = $Matches[1].Length

                # Stop at a heading with same or higher level (fewer or equal # chars)
                if ($level -le $sectionLevel) {
                    $endIndex = $i - 1
                    break
                }
            }
        }

        Write-Verbose "Matched heading: '$($Lines[$startIndex])' (level $sectionLevel, lines $($startIndex + 1)-$($endIndex + 1))"

        return @{ Start = $startIndex; End = $endIndex }
    }

    function Get-MarkdownLink {
        # Extract unique, sorted URLs from markdown links in the specified line range
        param(
            [Parameter(Mandatory)]
            [AllowEmptyString()]
            [string[]]$Lines,

            [Parameter(Mandatory)]
            [hashtable]$Range
        )

        $urlSet = [System.Collections.Generic.HashSet[string]]::new(
            [System.StringComparer]::OrdinalIgnoreCase
        )

        # Pattern matches [any text](url), including escaped brackets in footnotes
        $linkPattern = '\[(?:[^\[\]]|\\.)*\]\(([^)]+)\)'

        for ($i = $Range.Start; $i -le $Range.End; $i++) {
            $linkMatches = [regex]::Matches($Lines[$i], $linkPattern)

            foreach ($match in $linkMatches) {
                $url = $match.Groups[1].Value.Trim()

                # Skip empty URLs and fragment-only anchors
                if ([string]::IsNullOrWhiteSpace($url) -or $url.StartsWith('#')) {
                    continue
                }

                # Strip surrounding angle brackets if present
                if ($url.StartsWith('<') -and $url.EndsWith('>')) {
                    $url = $url.Substring(1, $url.Length - 2)
                }

                [void]$urlSet.Add($url)
            }
        }

        # Return sorted for deterministic output
        return @($urlSet | Sort-Object)
    }

    function Export-LinkFile {
        # Write the URL list to a text file, one URL per line
        param(
            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [string[]]$Urls,

            [Parameter(Mandatory)]
            [string]$SourcePath
        )

        if ($OutputPath) {
            $script:OutputFilePath = $OutputPath
        }
        else {
            # Default: same directory as input, named <basename>-links.txt
            $dir = [System.IO.Path]::GetDirectoryName($SourcePath)
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($SourcePath)
            $script:OutputFilePath = Join-Path -Path $dir -ChildPath "$baseName-links.txt"
        }

        if ($Urls.Count -eq 0) {
            $targetLabel = if ([string]::IsNullOrWhiteSpace($Section)) { 'the file' } else { "section '$Section'" }
            Write-Warning "No links found in $targetLabel. Output file not created."
            return
        }

        $Urls | Set-Content -Path $script:OutputFilePath -Encoding UTF8
    }

    function Show-Summary {
        # Display extraction results
        param(
            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [string[]]$Urls
        )

        $sectionLabel = if ([string]::IsNullOrWhiteSpace($Section)) { '[FULL FILE]' } else { $Section }

        Write-Host "Section:  $sectionLabel" -ForegroundColor Cyan
        Write-Host "Links:    $($Urls.Count)" -ForegroundColor Cyan

        if ($Urls.Count -gt 0) {
            Write-Host "Output:   $($script:OutputFilePath)" -ForegroundColor Green
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
