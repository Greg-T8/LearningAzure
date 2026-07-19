<#
.SYNOPSIS
Parse exam names from the main README certifications table.

.DESCRIPTION
Reads the certifications table in README.md and returns exam names matching the
specified status filter. Defaults to returning 'In Progress' exams. Used by
sibling scripts for dynamic exam discovery instead of hardcoded ValidateSet lists.

.CONTEXT
LearningAzure repository — shared utility for dynamic exam discovery.

.AUTHOR
Greg Tate

.NOTES
Program: Get-ActiveExam.ps1
#>

[CmdletBinding()]
param(
    [string[]]$Status = @('In Progress'),

    [switch]$IncludeAppliedSkills
)

# Configuration
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
$MainReadme = Join-Path -Path $RepoRoot -ChildPath 'README.md'

$Main = {
    . $Helpers

    $exams = Read-CertificationTable -IncludeAppliedSkills:$IncludeAppliedSkills
    Write-Output $exams
}

#region HELPER FUNCTIONS
$Helpers = {
    function Read-CertificationTable {
        # Parse the certifications table and return exam names matching the status filter
        param([switch]$IncludeAppliedSkills)

        if (-not (Test-Path -Path $MainReadme)) {
            Write-Warning "Main README not found: $MainReadme"
            return @()
        }

        $lines = Get-Content -Path $MainReadme -Encoding UTF8
        $results = [System.Collections.Generic.List[string]]::new()

        foreach ($line in $lines) {
            # Skip non-table rows, header rows, and separator rows
            if ($line -notmatch '^\|') { continue }
            if ($line -match '^\|\s*Exam\s*\|' -or $line -match '^\|\s*[-:]') { continue }

            # Extract track item from markdown link path for certs and optionally applied-skills
            $itemName = $null
            $isCertRow = $line -match '\[\*\*[^\]]+\*\*\]\(certs/(?:Inactive/)?([^/]+)/README\.md\)'
            if ($isCertRow) {
                $itemName = $Matches[1]
            }
            elseif ($IncludeAppliedSkills -and $line -match '\[\*\*[^\]]+\*\*\]\(applied-skills/([^/]+)/README\.md\)') {
                $itemName = $Matches[1]
            }

            if (-not $itemName) { continue }

            # Split by pipe to isolate the Status column (4th cell, index 3)
            $cells = $line -split '\|'

            if ($cells.Count -ge 5) {
                $statusCell = $cells[3].Trim()

                # Match against any requested status value
                foreach ($s in $Status) {
                    if ($statusCell -like "*$s*") {
                        $results.Add($itemName)
                        break
                    }
                }
            }
        }

        return $results.ToArray()
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
