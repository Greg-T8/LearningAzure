<#
.SYNOPSIS
Convert a Word document (.docx) to GitHub-Flavored Markdown using pandoc.

.DESCRIPTION
Wrapper script that invokes pandoc to convert a .docx file to markdown.
Uses sensible defaults: ATX-style headings, no line wrapping, and automatic
media extraction for embedded images. Output defaults to the same directory
as the input file but can be overridden.

.PARAMETER Path
Full or relative path to the .docx file to convert.

.PARAMETER OutputPath
Optional path for the output .md file. Defaults to the same directory and
base name as the input file with a .md extension.

.EXAMPLE
.\Convert-DocxToMarkdown.ps1 -Path "..\..\certs\AZ-305\Guide.docx"

.EXAMPLE
.\Convert-DocxToMarkdown.ps1 -Path "C:\docs\Report.docx" -OutputPath "C:\output\Report.md"

.CONTEXT
LearningAzure repository — utility script for converting research guides.

.AUTHOR
Greg Tate

.NOTES
Program: Convert-DocxToMarkdown.ps1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Path,

    [string]$OutputPath
)

$Main = {
    . $Helpers

    Confirm-Prerequisite
    $script:OutputPath = Resolve-OutputFilePath
    Invoke-PandocConversion
    Show-Result
}

#region HELPER FUNCTIONS
$Helpers = {
    function Confirm-Prerequisite {
        # Verify pandoc is installed and the input file is a valid .docx
        $pandoc = Get-Command -Name 'pandoc' -CommandType Application -ErrorAction SilentlyContinue

        if (-not $pandoc) {
            throw 'pandoc is not installed or not on PATH. Install from https://pandoc.org/installing.html'
        }

        if (-not (Test-Path -Path $Path)) {
            throw "Input file not found: $Path"
        }

        $extension = [System.IO.Path]::GetExtension($Path)

        if ($extension -ne '.docx') {
            throw "Expected a .docx file but received '$extension'."
        }
    }

    function Resolve-OutputFilePath {
        # Derive the output .md path from the input file when not explicitly provided
        if ($OutputPath) {
            return $OutputPath
        }

        $inputItem = Get-Item -Path $Path
        $baseName  = [System.IO.Path]::GetFileNameWithoutExtension($inputItem.Name)
        return Join-Path -Path $inputItem.DirectoryName -ChildPath "$baseName.md"
    }

    function Invoke-PandocConversion {
        # Run pandoc to convert the .docx file to GitHub-Flavored Markdown
        $inputItem  = Get-Item -Path $Path
        $baseName   = [System.IO.Path]::GetFileNameWithoutExtension($inputItem.Name)
        $outputDir  = [System.IO.Path]::GetDirectoryName((Resolve-Path -Path $OutputPath -ErrorAction SilentlyContinue) ?? $OutputPath)

        # Fall back to the input file's directory when OutputPath directory can't be resolved yet
        if (-not $outputDir) {
            $outputDir = $inputItem.DirectoryName
        }

        $mediaDir = Join-Path -Path $outputDir -ChildPath "$baseName-media"

        $pandocArgs = @(
            '--from=docx'
            '--to=gfm'
            '--wrap=none'
            '--markdown-headings=atx'
            "--extract-media=$mediaDir"
            "-o", $OutputPath
            $Path
        )

        Write-Verbose "Running: pandoc $($pandocArgs -join ' ')"
        & pandoc @pandocArgs

        if ($LASTEXITCODE -ne 0) {
            throw "pandoc exited with code $LASTEXITCODE"
        }
    }

    function Show-Result {
        # Display a summary of the conversion
        $outputItem = Get-Item -Path $OutputPath

        Write-Host ''
        Write-Host 'Conversion complete.' -ForegroundColor Green
        Write-Host "  Input:  $Path"
        Write-Host "  Output: $($outputItem.FullName)"
        Write-Host "  Size:   $([math]::Round($outputItem.Length / 1KB, 1)) KB"
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
