<#
.SYNOPSIS
Add an Applied Skill to the central LearningAzure catalog.

.DESCRIPTION
Validates Applied Skill metadata and inserts a new alphabetically sorted row in
applied-skills/README.md. The command does not create a topic folder or external
repository.

.CONTEXT
LearningAzure repository — centralized Applied Skills tracking.

.AUTHOR
Greg Tate

.NOTES
Program: Add-AppliedSkill.ps1
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidatePattern('^[A-Z0-9]+(?:-[A-Z0-9]+)*$')]
    [string]$Id,

    [Parameter(Mandatory)]
    [string]$Name,

    [Parameter(Mandatory)]
    [string]$Description,

    [ValidateSet('Not Started', 'In Progress', 'Paused', 'Completed')]
    [string]$Status = 'Not Started',

    [string]$RepositoryUrl
)

# Resolve the central catalog from the script location.
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
$CatalogPath = Join-Path -Path $RepoRoot -ChildPath 'applied-skills\README.md'
$CatalogStartMarker = '<!-- APPLIED_SKILLS_CATALOG_START -->'
$CatalogEndMarker = '<!-- APPLIED_SKILLS_CATALOG_END -->'

$Main = {
    . $Helpers

    Confirm-CatalogFile
    Confirm-SafeField -Name 'Name' -Value $Name
    Confirm-SafeField -Name 'Description' -Value $Description
    $repositoryCell = Resolve-RepositoryCell -RepositoryUrl $RepositoryUrl
    Add-CatalogEntry -RepositoryCell $repositoryCell -WhatIf:$WhatIfPreference
}

#region HELPER FUNCTIONS
# Functions validate metadata and update the central Markdown catalog.
$Helpers = {
    function Confirm-CatalogFile {
        # Confirm the canonical Applied Skills README is available.
        if (-not (Test-Path -LiteralPath $CatalogPath)) {
            throw "Applied Skills catalog not found at '$CatalogPath'."
        }
    }

    function Confirm-SafeField {
        # Reject characters that would break the Markdown table structure.
        param(
            [Parameter(Mandatory)]
            [string]$Name,

            [Parameter(Mandatory)]
            [string]$Value
        )

        if ([string]::IsNullOrWhiteSpace($Value)) {
            throw "$Name must not be empty."
        }

        if ($Value -match '[\r\n|]') {
            throw "$Name must not contain a pipe or newline."
        }
    }

    function Resolve-RepositoryCell {
        # Validate an optional GitHub repository URL and return its catalog cell.
        param([string]$RepositoryUrl)

        if ([string]::IsNullOrWhiteSpace($RepositoryUrl)) {
            return 'TBD'
        }

        [uri]$repositoryUri = $null
        if (-not [uri]::TryCreate($RepositoryUrl, [System.UriKind]::Absolute, [ref]$repositoryUri)) {
            throw 'RepositoryUrl must be an absolute HTTPS GitHub URL.'
        }

        if ($repositoryUri.Scheme -ne 'https' -or $repositoryUri.Host -ne 'github.com') {
            throw 'RepositoryUrl must be an absolute HTTPS GitHub URL.'
        }

        $pathSegments = @($repositoryUri.AbsolutePath.Trim('/') -split '/')
        if ($pathSegments.Count -lt 2 -or $pathSegments[0] -eq '' -or $pathSegments[1] -eq '') {
            throw 'RepositoryUrl must identify a GitHub owner and repository.'
        }

        return "[Repository]($($repositoryUri.AbsoluteUri.TrimEnd('/')))"
    }

    function Get-CatalogEntryId {
        # Extract the Applied Skill ID from a catalog data row.
        param([Parameter(Mandatory)] [string]$Line)

        if ($Line -match '^\|\s*([A-Z0-9]+(?:-[A-Z0-9]+)*)\s*\|') {
            return $Matches[1]
        }

        return $null
    }

    function Add-CatalogEntry {
        # Insert the validated entry and keep catalog rows sorted by ID.
        [CmdletBinding(SupportsShouldProcess)]
        param([Parameter(Mandatory)] [string]$RepositoryCell)

        $lines = @(Get-Content -LiteralPath $CatalogPath -Encoding UTF8)
        $startIndex = [array]::IndexOf($lines, $CatalogStartMarker)
        $endIndex = [array]::IndexOf($lines, $CatalogEndMarker)

        if ($startIndex -lt 0 -or $endIndex -le $startIndex) {
            throw 'Applied Skills catalog markers are missing or out of order.'
        }

        $entryLines = [System.Collections.Generic.List[string]]::new()
        for ($index = $startIndex + 3; $index -lt $endIndex; $index++) {
            $entryId = Get-CatalogEntryId -Line $lines[$index]
            if (-not $entryId) {
                continue
            }

            if ($entryId -ieq $Id) {
                throw "Applied Skill '$Id' already exists in the catalog."
            }

            $entryLines.Add($lines[$index])
        }

        $newEntry = "| $Id | $($Name.Trim()) | $($Description.Trim()) | $Status | $RepositoryCell | — | — | 0 | 0.0h |"
        $entryLines.Add($newEntry)
        $sortedEntries = @($entryLines | Sort-Object { Get-CatalogEntryId -Line $_ })

        $headerLines = @($lines[($startIndex + 1)..($startIndex + 2)])
        $updated = [System.Collections.Generic.List[string]]::new()
        $updated.AddRange([string[]]$lines[0..$startIndex])
        $updated.AddRange([string[]]$headerLines)
        $updated.AddRange([string[]]$sortedEntries)
        $updated.AddRange([string[]]$lines[$endIndex..($lines.Count - 1)])

        if ($PSCmdlet.ShouldProcess($CatalogPath, "Add Applied Skill '$Id'")) {
            Set-Content -LiteralPath $CatalogPath -Value $updated -Encoding UTF8
            Write-Output "Added Applied Skill '$Id' to $CatalogPath."
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
