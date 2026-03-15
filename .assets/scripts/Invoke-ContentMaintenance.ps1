<#
.SYNOPSIS
Orchestrate automated content maintenance across the workspace.

.DESCRIPTION
Controller script that invokes content maintenance scripts in dependency order:
  1. Update-ProgressTrackerDays — recalculate in-progress day counts.
  2. Update-CoverageTable — refresh coverage table and dashboard per exam.
  3. Update-LabReferences — regenerate lab catalogs and cross-references.
  4. Invoke-CollapseDetailBlock — normalize markdown detail elements.
  5. Remove-UnusedImages — clean up unreferenced images.
  6. Update-CommitStats — refresh commit statistics in README.md.

When invoked with the -Reorganize switch, also runs practice exam question
reorganization before the other steps.

Designed to run in a GitHub Actions workflow or locally.

.CONTEXT
LearningAzure repository — automated content maintenance pipeline.

.AUTHOR
Greg Tate

.NOTES
Program: Invoke-ContentMaintenance.ps1
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$Reorganize
)

# Configuration
$ScriptsDir = $PSScriptRoot

$Main = {
    . $Helpers

    # Step 1 (optional): Reorganize practice exam questions
    if ($Reorganize) {
        Invoke-Step -Name 'Invoke-PracticeExamReorganizer' -ScriptPath (Join-Path $ScriptsDir 'Invoke-PracticeExamReorganizer.ps1')
    }

    # Step 2: Update progress tracker day counts
    Invoke-Step -Name 'Update-ProgressTrackerDays' -ScriptPath (Join-Path $ScriptsDir 'Update-ProgressTrackerDays.ps1')

    # Step 3: Update coverage tables for active exams
    Invoke-Step -Name 'Update-CoverageTable' -ScriptPath (Join-Path $ScriptsDir 'Update-CoverageTable.ps1')

    # Step 4: Update lab references and catalogs
    Invoke-Step -Name 'Update-LabReferences' -ScriptPath (Join-Path $ScriptsDir 'Update-LabReferences.ps1')

    # Step 5: Collapse open detail blocks
    Invoke-Step -Name 'Invoke-CollapseDetailBlock' -ScriptPath (Join-Path $ScriptsDir 'Invoke-CollapseDetailBlock.ps1')

    # Step 6: Remove unreferenced images
    Invoke-Step -Name 'Remove-UnusedImages' -ScriptPath (Join-Path $ScriptsDir 'Remove-UnusedImages.ps1')

    # Step 7: Update commit statistics in README.md
    Invoke-Step -Name 'Update-CommitStats' -ScriptPath (Join-Path $ScriptsDir 'Update-CommitStats.ps1')

    Write-Host "`nContent maintenance complete." -ForegroundColor Green
}

#region HELPER FUNCTIONS
$Helpers = {
    function Invoke-Step {
        # Execute a maintenance script as a named step with error handling
        param(
            [Parameter(Mandatory)]
            [string]$Name,

            [Parameter(Mandatory)]
            [string]$ScriptPath
        )

        Write-Host "`n=== $Name ===" -ForegroundColor Cyan

        if (-not (Test-Path -Path $ScriptPath)) {
            Write-Warning "Script not found: $ScriptPath — skipping"
            return
        }

        # Pass through WhatIf and Verbose preferences
        $invokeParams = @{}
        if ($WhatIfPreference) { $invokeParams['WhatIf'] = $true }
        if ($VerbosePreference -eq 'Continue') { $invokeParams['Verbose'] = $true }

        try {
            & $ScriptPath @invokeParams
        }
        catch {
            Write-Warning "$Name failed: $_"
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
