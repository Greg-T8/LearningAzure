<#
.SYNOPSIS
Log the start of a study session to the exam's StudyLog.md.

.DESCRIPTION
Appends a new row to the StudyLog.md markdown table for the specified exam,
recording the session number, date, and start time. End, Duration, and Notes
columns are left blank for the user to fill in when the session concludes.

.CONTEXT
LearningAzure repository — certification study tracking.

.AUTHOR
Greg Tate

.NOTES
Program: Start-StudySession.ps1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('AI-102', 'AZ-104')]
    [string]$ExamName
)

# Configuration
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
$StudyLogFile = Join-Path -Path $RepoRoot -ChildPath "$ExamName\StudyLog.md"

$Main = {
    . $Helpers

    Confirm-StudyLogExists
    Confirm-GitRepository
    Sync-Repository
    $NextSession = Get-NextSessionNumber
    Add-SessionEntry -SessionNumber $NextSession
    Save-StudyLogChange -SessionNumber $NextSession
    Show-Confirmation -SessionNumber $NextSession
}

$Helpers = {
    function Confirm-StudyLogExists {
        # Verify the StudyLog.md file is present in the exam folder
        if (-not (Test-Path -Path $StudyLogFile)) {
            throw "StudyLog.md not found at '$StudyLogFile'. Please create it first."
        }
    }

    function Get-NextSessionNumber {
        # Count existing data rows in the markdown table to determine the next session number
        $lines = Get-Content -Path $StudyLogFile

        $dataRows = $lines |
            Where-Object { $_ -match '^\|\s*\d+\s*\|' }

        if ($dataRows) {
            return ($dataRows | Measure-Object).Count + 1
        }

        return 1
    }

    function Add-SessionEntry {
        # Append a new session row with the current date and start time
        param(
            [Parameter(Mandatory)]
            [int]$SessionNumber
        )

        $now  = Get-Date
        $date  = $now.ToString('M/d/yy')
        $start = $now.ToString('h:mm tt')

        $row = "| $SessionNumber | $date | $start |  |  |  |"

        Add-Content -Path $StudyLogFile -Value $row
    }

    function Confirm-GitRepository {
        # Ensure the workspace root is a Git repository before attempting commit and push
        $isGitRepo = git -C $RepoRoot rev-parse --is-inside-work-tree 2>$null

        if ($LASTEXITCODE -ne 0 -or $isGitRepo -ne 'true') {
            throw "Git repository not found at '$RepoRoot'."
        }
    }

    function Sync-Repository {
        # Pull latest remote changes with merge semantics to absorb periodic statistics commits
        git -C $RepoRoot pull --no-rebase --no-edit

        if ($LASTEXITCODE -ne 0) {
            throw 'Failed to pull remote changes before updating the study log.'
        }
    }

    function Save-StudyLogChange {
        # Stage, commit, and push the updated study log for this session start
        param(
            [Parameter(Mandatory)]
            [int]$SessionNumber
        )

        $relativeLogPath = "$ExamName/StudyLog.md"
        $commitMessage = "docs($ExamName): start study session #$SessionNumber"

        git -C $RepoRoot add -- $relativeLogPath
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to stage '$relativeLogPath'."
        }

        git -C $RepoRoot commit -m $commitMessage
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to commit changes for '$relativeLogPath'."
        }

        git -C $RepoRoot push
        if ($LASTEXITCODE -ne 0) {
            Sync-Repository

            git -C $RepoRoot push
            if ($LASTEXITCODE -ne 0) {
                throw 'Failed to push committed changes after syncing remote updates.'
            }
        }
    }

    function Show-Confirmation {
        # Display a summary of the logged session entry
        param(
            [Parameter(Mandatory)]
            [int]$SessionNumber
        )

        $now   = Get-Date
        $date  = $now.ToString('M/d/yy')
        $start = $now.ToString('h:mm tt')

        Write-Output ''
        Write-Output "  Study session #$SessionNumber started for $ExamName"
        Write-Output "  Date : $date"
        Write-Output "  Start: $start"
        Write-Output "  Log  : $StudyLogFile"
        Write-Output '  Git  : committed and pushed'
        Write-Output ''
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
