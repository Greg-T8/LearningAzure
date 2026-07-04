<#
.SYNOPSIS
Combine all markdown files in a folder (and its subfolders) into a single markdown file.

.DESCRIPTION
Recursively walks a source folder, concatenates every `.md` file it finds,
and writes the result to one output markdown file. Files are ordered with
files in the root folder first, then subfolder files (alphabetically by
folder, then by file name).

Each source file is prefixed with a markdown heading derived from the file
name. Top-level subfolders become `##` sections; files in the root or inside
a subfolder become `##` / `###` subsections. The original file headings are
demoted so they nest correctly under the generated headings.

.PARAMETER SourceFolder
Full or relative path to the folder containing markdown files to combine.

.PARAMETER OutputPath
Full or relative path for the combined output markdown file. If omitted,
defaults to `<SourceFolder-name>.md` written next to the source folder.

.PARAMETER Title
Optional title rendered as the H1 heading at the top of the output file.
Defaults to the source folder name.

.PARAMETER DemoteHeadings
When set (default), all headings inside each source file are shifted down
so they fall under the synthesized `##` / `###` wrappers. Pass
`-DemoteHeadings:$false` to keep headings verbatim.

.EXAMPLE
.\Merge-MarkdownFolder.ps1 -SourceFolder "..\..\certs\SC-300\review\Implement authentication and access management"

.EXAMPLE
.\Merge-MarkdownFolder.ps1 `
    -SourceFolder "C:\notes\topic" `
    -OutputPath   "C:\notes\topic-combined.md" `
    -Title        "Topic Review Sheet"

.CONTEXT
LearningAzure repository — utility for combining per-topic markdown notes
into a single review sheet.

.AUTHOR
Greg Tate

.NOTES
Program: Merge-MarkdownFolder.ps1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$SourceFolder,

    [string]$OutputPath,

    [string]$Title,

    [switch]$DemoteHeadings = $true
)

# Resolve the input path from the caller's working directory before Push-Location
if ($SourceFolder -and (Test-Path -Path $SourceFolder)) {
    $SourceFolder = (Resolve-Path -Path $SourceFolder).Path
}

# Resolve the output path against PWD if it is relative, before Push-Location changes CWD
if ($OutputPath -and -not [System.IO.Path]::IsPathRooted($OutputPath)) {
    $OutputPath = [System.IO.Path]::GetFullPath(
        (Join-Path -Path (Get-Location).Path -ChildPath $OutputPath)
    )
}

$Main = {
    . $Helpers

    # Validate the source folder exists and is a directory
    $resolvedFolder = Resolve-SourceFolder

    # Determine the output file path and effective title
    $resolvedOutput = Resolve-OutputPath -SourceFolder $resolvedFolder
    $effectiveTitle = Resolve-Title -SourceFolder $resolvedFolder

    # Discover every markdown file under the source folder, ordered for output
    $files = Get-MarkdownFile -SourceFolder $resolvedFolder -OutputPath $resolvedOutput

    if ($files.Count -eq 0) {
        throw "No markdown files found under: $resolvedFolder"
    }

    # Build the combined markdown content in memory
    $content = Build-CombinedContent `
        -SourceFolder $resolvedFolder `
        -Files $files `
        -Title $effectiveTitle

    # Write the combined content to disk as UTF-8 without BOM
    Write-OutputFile -Path $resolvedOutput -Content $content

    # Display a summary of files merged and output location
    Show-Summary -Files $files -OutputPath $resolvedOutput
}

#region HELPER FUNCTIONS
$Helpers = {
    function Resolve-SourceFolder {
        # Validate that the source path exists and points to a directory
        if (-not (Test-Path -Path $SourceFolder -PathType Container)) {
            throw "Source folder not found or not a directory: $SourceFolder"
        }

        return (Resolve-Path -Path $SourceFolder).Path
    }

    function Resolve-OutputPath {
        # Compute the output file path, defaulting next to the source folder
        param(
            [Parameter(Mandatory)]
            [string]$SourceFolder
        )

        if ($OutputPath) {
            # If caller pointed at an existing directory, append a derived file name
            if (Test-Path -Path $OutputPath -PathType Container) {
                $fileName = if ($Title) { $Title } else { [System.IO.Path]::GetFileName($SourceFolder) }
                return Join-Path -Path (Resolve-Path -Path $OutputPath).Path -ChildPath "$fileName.md"
            }

            return $OutputPath
        }

        # Default: <parent>\<folder-name>.md
        $parent = [System.IO.Path]::GetDirectoryName($SourceFolder)
        $name   = [System.IO.Path]::GetFileName($SourceFolder)
        return Join-Path -Path $parent -ChildPath "$name.md"
    }

    function Resolve-Title {
        # Use caller-provided title if supplied, otherwise derive from folder name
        param(
            [Parameter(Mandatory)]
            [string]$SourceFolder
        )

        if ($Title) {
            return $Title
        }

        return [System.IO.Path]::GetFileName($SourceFolder)
    }

    function Get-MarkdownFile {
        # Discover all .md files; order root files first, then subfolders alphabetically
        param(
            [Parameter(Mandatory)]
            [string]$SourceFolder,

            [Parameter(Mandatory)]
            [string]$OutputPath
        )

        $all = Get-ChildItem -Path $SourceFolder -Filter '*.md' -Recurse -File

        # Exclude the output file itself if it happens to live under the source folder
        $all = $all | Where-Object { $_.FullName -ne $OutputPath }

        # Tag each file with the relative subfolder path for grouping
        $tagged = $all | ForEach-Object {
            $relativeDir = $_.DirectoryName.Substring($SourceFolder.Length).TrimStart('\', '/')

            [pscustomobject]@{
                File        = $_
                RelativeDir = $relativeDir
                IsRoot      = [string]::IsNullOrEmpty($relativeDir)
            }
        }

        # Root files first (sorted), then subfolder files grouped by folder
        $rootFiles = $tagged |
            Where-Object { $_.IsRoot } |
            Sort-Object { $_.File.Name }

        $subFiles = $tagged |
            Where-Object { -not $_.IsRoot } |
            Sort-Object RelativeDir, { $_.File.Name }

        return @($rootFiles) + @($subFiles)
    }

    function Build-CombinedContent {
        # Assemble the combined markdown text with synthesized section headings
        param(
            [Parameter(Mandatory)]
            [string]$SourceFolder,

            [Parameter(Mandatory)]
            [object[]]$Files,

            [Parameter(Mandatory)]
            [string]$Title
        )

        $sb = [System.Text.StringBuilder]::new()

        # HTML comment header block (markdown-safe equivalent of the script header)
        [void]$sb.AppendLine("<!--")
        [void]$sb.AppendLine("File: $Title.md")
        [void]$sb.AppendLine("Description: Combined markdown content merged from '$([System.IO.Path]::GetFileName($SourceFolder))'")
        [void]$sb.AppendLine("Generated: $(Get-Date -Format 'yyyy-MM-dd')")
        [void]$sb.AppendLine("Author: Greg Tate")
        [void]$sb.AppendLine("-->")
        [void]$sb.AppendLine()

        # H1 document title
        [void]$sb.AppendLine("# $Title")
        [void]$sb.AppendLine()

        # Track the current subfolder so each ## section is emitted only once
        $currentDir = $null

        foreach ($entry in $Files) {
            $file = $entry.File

            if ($entry.IsRoot) {
                # Root-level file: emit as ## section using the file's base name
                $sectionName = Get-PrettyName -BaseName $file.BaseName
                [void]$sb.AppendLine("## $sectionName")
                [void]$sb.AppendLine()
            }
            else {
                # Emit ## for the subfolder the first time it appears
                if ($entry.RelativeDir -ne $currentDir) {
                    $currentDir = $entry.RelativeDir
                    $folderName = Get-PrettyName -BaseName (Split-Path -Path $entry.RelativeDir -Leaf)
                    [void]$sb.AppendLine("## $folderName")
                    [void]$sb.AppendLine()
                }

                # Then emit ### for the file inside the subfolder
                $sectionName = Get-PrettyName -BaseName $file.BaseName
                [void]$sb.AppendLine("### $sectionName")
                [void]$sb.AppendLine()
            }

            # Read and append the file body, demoting headings if requested
            $body = Get-FileBody -Path $file.FullName -IsRoot $entry.IsRoot

            [void]$sb.AppendLine($body.TrimEnd())
            [void]$sb.AppendLine()
        }

        return $sb.ToString()
    }

    function Get-FileBody {
        # Read a markdown file and optionally demote its headings to nest under wrappers
        param(
            [Parameter(Mandatory)]
            [string]$Path,

            [Parameter(Mandatory)]
            [bool]$IsRoot
        )

        $raw = Get-Content -Path $Path -Encoding UTF8 -Raw

        if (-not $DemoteHeadings) {
            return $raw
        }

        # Root files nest under ## (offset 2); subfolder files nest under ### (offset 3)
        $offset = if ($IsRoot) { 2 } else { 3 }

        # Demote each ATX heading by adding '#' characters, capped at 6 total
        $demoted = [regex]::Replace(
            $raw,
            '(?m)^(#{1,6})(\s+)',
            {
                param($m)

                $current = $m.Groups[1].Value.Length
                $new     = [Math]::Min(6, $current + $offset)
                return ('#' * $new) + $m.Groups[2].Value
            }
        )

        return $demoted
    }

    function Get-PrettyName {
        # Convert a file/folder base name into a human-friendly heading
        param(
            [Parameter(Mandatory)]
            [string]$BaseName
        )

        # Replace common separators with spaces and collapse repeats
        $name = $BaseName -replace '[-_]+', ' '
        $name = ($name -replace '\s+', ' ').Trim()
        return $name
    }

    function Write-OutputFile {
        # Write the combined content to disk as UTF-8 without BOM
        param(
            [Parameter(Mandatory)]
            [string]$Path,

            [Parameter(Mandatory)]
            [string]$Content
        )

        # Ensure the target directory exists
        $dir = [System.IO.Path]::GetDirectoryName($Path)

        if ($dir -and -not (Test-Path -Path $dir)) {
            New-Item -Path $dir -ItemType Directory -Force | Out-Null
        }

        # UTF-8 no BOM to match repo convention
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
    }

    function Show-Summary {
        # Display a summary of files merged and the output location
        param(
            [Parameter(Mandatory)]
            [object[]]$Files,

            [Parameter(Mandatory)]
            [string]$OutputPath
        )

        Write-Host ""
        Write-Host "Merged $($Files.Count) markdown file(s) into:" -ForegroundColor Green
        Write-Host "  $OutputPath" -ForegroundColor Cyan
        Write-Host ""
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
