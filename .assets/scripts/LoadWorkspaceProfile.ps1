<#
.SYNOPSIS
Initialize the LearningAzure workspace PowerShell profile.

.DESCRIPTION
Loads workspace startup commands for interactive terminals. Initializes the
Lab Azure profile and imports the study-session and coverage-update commands so
they are available without explicit script-path invocation.

.CONTEXT
LearningAzure repository - workspace shell initialization.

.AUTHOR
Greg Tate

.NOTES
Program: LoadWorkspaceProfile.ps1
#>

[CmdletBinding()]
param()

# Configuration
$StudySessionScript = Join-Path -Path $PSScriptRoot -ChildPath 'Invoke-StudySession.ps1'
$CoverageTableScript = Join-Path -Path $PSScriptRoot -ChildPath 'Update-CoverageTable.ps1'

$Main = {
    . $Helpers

    Import-StudySessionCommand
    Import-CoverageTableCommand
    Initialize-LabAzProfile
}

$Helpers = {
    function Import-StudySessionCommand {
        # Dot-source the study session function when it is not already available.
        $command = Get-Command -Name 'Invoke-StudySession' -ErrorAction SilentlyContinue
        if ($command -and $command.CommandType -eq 'Function') {
            return
        }

        if (-not (Test-Path -Path $StudySessionScript)) {
            throw "Study session script not found at '$StudySessionScript'."
        }

        . $StudySessionScript

        # Promote the imported function so it remains available after this helper returns.
        if (Get-Command -Name 'Invoke-StudySession' -ErrorAction SilentlyContinue) {
            Set-Item -Path 'Function:\Global:Invoke-StudySession' -Value ${function:Invoke-StudySession}
        }
        else {
            throw "Import failed: function 'Invoke-StudySession' was not found after dot-sourcing '$StudySessionScript'."
        }
    }

    function Import-CoverageTableCommand {
        # Dot-source the coverage update function when it is not already available.
        $command = Get-Command -Name 'Update-CoverageTable' -ErrorAction SilentlyContinue
        if ($command -and $command.CommandType -eq 'Function') {
            return
        }

        if (-not (Test-Path -Path $CoverageTableScript)) {
            throw "Coverage table script not found at '$CoverageTableScript'."
        }

        . $CoverageTableScript

        # Promote the imported function so it remains available after this helper returns.
        if (Get-Command -Name 'Update-CoverageTable' -ErrorAction SilentlyContinue) {
            Set-Item -Path 'Function:\Global:Update-CoverageTable' -Value ${function:Update-CoverageTable}
        }
        else {
            throw "Import failed: function 'Update-CoverageTable' was not found after dot-sourcing '$CoverageTableScript'."
        }
    }

    function Initialize-LabAzProfile {
        # Ensure the Lab Azure profile is active for this terminal session.
        Use-AzProfile Lab
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
