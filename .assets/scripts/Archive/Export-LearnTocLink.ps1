<#
.SYNOPSIS
Export all descendant page URLs from a Microsoft Learn documentation section.

.DESCRIPTION
Fetches the toc.json endpoint for a Microsoft Learn documentation section and
recursively walks the table-of-contents tree to produce a flat, deduplicated
list of page URLs. Writes the results to a text file (one URL per line).

Relative hrefs are resolved against the section base URL. Cross-docset Learn
links (absolute paths starting with /) are resolved against learn.microsoft.com.
External URLs (stackoverflow, feedback.azure.com, etc.) are excluded by default;
use -IncludeExternal to include them.

.PARAMETER Url
The Microsoft Learn section URL (e.g., https://learn.microsoft.com/en-us/azure/azure-monitor/).

.PARAMETER OutputPath
Optional path for the output .txt file. Defaults to <section-name>-links.txt
in the current directory.

.PARAMETER IncludeExternal
Include external (non-learn.microsoft.com) URLs in the output.

.EXAMPLE
.\Export-LearnTocLink.ps1 -Url "https://learn.microsoft.com/en-us/azure/azure-monitor/"

.EXAMPLE
.\Export-LearnTocLink.ps1 -Url "https://learn.microsoft.com/en-us/azure/virtual-network/" -IncludeExternal

.EXAMPLE
.\Export-LearnTocLink.ps1 -Url "https://learn.microsoft.com/en-us/azure/azure-monitor/" -OutputPath "C:\temp\monitor-links.txt"

.CONTEXT
LearningAzure repository — utility for extracting all descendant page URLs from Microsoft Learn TOC.

.AUTHOR
Greg Tate

.NOTES
Program: Export-LearnTocLink.ps1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Url,

    [string]$OutputPath,

    [switch]$IncludeExternal
)

$Main = {
    . $Helpers

    # Validate the URL and derive TOC endpoint and base path
    $tocInfo = Confirm-LearnUrl

    # Fetch the table-of-contents JSON from the Learn API
    $toc = Get-TocJson -TocUrl $tocInfo.TocUrl

    # Recursively extract all descendant page URLs from the TOC tree
    $urls = @(Get-DescendantLink -Items $toc.items -BasePath $tocInfo.BasePath)

    # Deduplicate, sort, and write the URL list to a text file
    Export-LinkList -Urls $urls -SectionName $tocInfo.SectionName

    # Display a summary of the extraction
    Show-Summary -Urls $script:FinalUrls
}

#region HELPER FUNCTIONS
$Helpers = {
    function Confirm-LearnUrl {
        # Validate the URL is a Microsoft Learn page and extract the base path and toc.json URL
        $learnHost = 'https://learn.microsoft.com'

        if ($Url -notmatch '^https://learn\.microsoft\.com/') {
            throw "URL must start with https://learn.microsoft.com/. Got: $Url"
        }

        # Ensure the URL ends with a trailing slash for consistent path resolution
        $baseUrl = $Url.TrimEnd('/')
        $uri = [System.Uri]::new("$baseUrl/")

        # The base path is everything after the host, e.g. /en-us/azure/azure-monitor/
        $basePath = $uri.AbsolutePath.TrimEnd('/')

        # Derive the section name from the last path segment
        $segments = $basePath.Split('/', [System.StringSplitOptions]::RemoveEmptyEntries)
        $sectionName = $segments[-1]

        # Construct the toc.json URL
        $tocUrl = "$learnHost$basePath/toc.json"

        Write-Verbose "Base path:    $basePath"
        Write-Verbose "Section name: $sectionName"
        Write-Verbose "TOC URL:      $tocUrl"

        return @{
            BasePath    = $basePath
            SectionName = $sectionName
            TocUrl      = $tocUrl
        }
    }

    function Get-TocJson {
        # Fetch the toc.json from the Learn API endpoint
        param(
            [Parameter(Mandatory)]
            [string]$TocUrl
        )

        try {
            $response = Invoke-RestMethod -Uri $TocUrl -ErrorAction Stop
        }
        catch {
            throw "Failed to fetch TOC from '$TocUrl'. Verify the URL points to a valid Learn documentation section. Error: $_"
        }

        if (-not $response.items) {
            throw "TOC JSON at '$TocUrl' contains no items. The URL may not be a documentation section root."
        }

        # Report expected link count from metadata if available
        $expectedCount = $response.metadata.count_of_node_with_href
        if ($expectedCount) {
            Write-Verbose "TOC metadata reports $expectedCount nodes with href."
        }

        return $response
    }

    function Get-DescendantLink {
        # Recursively walk TOC items and resolve each href to a full URL
        param(
            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [object[]]$Items,

            [Parameter(Mandatory)]
            [string]$BasePath
        )

        $learnHost = 'https://learn.microsoft.com'
        $results = [System.Collections.Generic.List[string]]::new()

        foreach ($item in $Items) {
            # Resolve the href if present
            if ($item.href) {
                $href = $item.href.Trim()
                $resolvedUrl = $null

                if ($href -eq './' -or $href -eq '.') {
                    # Self-reference to the section root
                    $resolvedUrl = "$learnHost$BasePath/"
                }
                elseif ($href -match '^https?://') {
                    # Full external URL — include only if -IncludeExternal
                    if ($IncludeExternal) {
                        $resolvedUrl = $href
                    }
                }
                elseif ($href.StartsWith('/')) {
                    # Absolute path within Learn (cross-docset link)
                    $resolvedUrl = "$learnHost$href"
                }
                else {
                    # Relative path — resolve against the base path
                    $resolvedUrl = "$learnHost$BasePath/$href"
                }

                if ($resolvedUrl) {
                    $results.Add($resolvedUrl)
                }
            }

            # Recurse into children if present
            if ($item.children) {
                $childLinks = Get-DescendantLink -Items $item.children -BasePath $BasePath
                $results.AddRange([string[]]$childLinks)
            }
        }

        return $results.ToArray()
    }

    function Export-LinkList {
        # Deduplicate (case-insensitive), sort, and write URLs to a text file
        param(
            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [string[]]$Urls,

            [Parameter(Mandatory)]
            [string]$SectionName
        )

        # Deduplicate case-insensitively
        $urlSet = [System.Collections.Generic.HashSet[string]]::new(
            [System.StringComparer]::OrdinalIgnoreCase
        )

        foreach ($url in $Urls) {
            [void]$urlSet.Add($url)
        }

        $script:FinalUrls = @($urlSet | Sort-Object)

        if ($script:FinalUrls.Count -eq 0) {
            Write-Warning "No links found in the TOC. Output file not created."
            return
        }

        # Determine output path
        if ($OutputPath) {
            $outFile = $OutputPath
        }
        else {
            $outFile = Join-Path -Path (Get-Location).Path -ChildPath "$SectionName-links.txt"
        }

        $script:FinalUrls | Set-Content -Path $outFile -Encoding UTF8
        $script:OutputFilePath = $outFile
    }

    function Show-Summary {
        # Display extraction results to the console
        param(
            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [string[]]$Urls
        )

        Write-Host "Section:  $Url" -ForegroundColor Cyan
        Write-Host "Links:    $($Urls.Count)" -ForegroundColor Cyan

        if ($Urls.Count -gt 0 -and $script:OutputFilePath) {
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
