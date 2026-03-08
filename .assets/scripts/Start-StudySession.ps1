<#
.SYNOPSIS
Manage study sessions for certification exam tracking.

.DESCRIPTION
Manages study session tracking for certification exams. Supports start/stop actions:
Start — appends a new row to StudyLog.md with session number, date, and start time.
End/Stop — closes the active session with end time and duration.
Start also auto-closes any currently active session before opening a new session.

.CONTEXT
LearningAzure repository — certification study tracking.

.AUTHOR
Greg Tate

.NOTES
Program: Start-StudySession.ps1
#>

[CmdletBinding()]
param(
    [ValidateSet('Start', 'Stop', 'End')]
    [string]$Action = 'Start',

    [ValidateSet('AI-102', 'AZ-104', 'Other')]
    [string]$ExamName
)

# Configuration
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
$StudyLogFile = $null
$AllExams = @('AI-102', 'AZ-104', 'Other')
$ExamFolderMap = @{
    'AI-102' = 'AI-102'
    'AZ-104' = 'AZ-104'
    'Other'  = '.assets\workflow-development'
}
$ExamLogFileMap = @{
    'Other' = 'WorkLog.md'
}

$Main = {
    . $Helpers

    Confirm-GitRepository
    Sync-Repository

    # Route to the appropriate action handler
    switch ($Action) {
        'Start' {
            if (-not $ExamName) {
                throw "ExamName is required when Action is 'Start'."
            }

            $folder = Resolve-ExamFolder -Exam $ExamName
            $logFileName = Resolve-ExamLogFileName -Exam $ExamName
            $script:StudyLogFile = Join-Path -Path $RepoRoot -ChildPath "$folder\$logFileName"

            # End any currently active session before starting a new one
            $sourceExam = Find-ActiveExam
            if ($sourceExam) {
                $sourceFolder = Resolve-ExamFolder -Exam $sourceExam
                $sourceLogFileName = Resolve-ExamLogFileName -Exam $sourceExam
                $sourceLog = Join-Path -Path $RepoRoot -ChildPath "$sourceFolder\$sourceLogFileName"
                $sourceSession = Get-ActiveSessionNumber -LogFile $sourceLog
                Close-SessionEntry -SessionNumber $sourceSession -LogFile $sourceLog
                Push-StudyLogChange -SessionNumber $sourceSession -Type 'end' -Exam $sourceExam
                Show-Confirmation -Message "Study session #$sourceSession ended for $sourceExam"
            }

            Confirm-StudyLogExists
            $session = Get-NextSessionNumber
            Add-SessionEntry -SessionNumber $session
            Push-StudyLogChange -SessionNumber $session -Type 'start' -Exam $ExamName
            Show-Confirmation -Message "Study session #$session started for $ExamName"
        }
        'Stop' {
            $sourceExam = Find-ActiveExam
            if (-not $sourceExam) {
                throw 'No active study session found in any exam study log.'
            }

            $sourceFolder = Resolve-ExamFolder -Exam $sourceExam
            $sourceLogFileName = Resolve-ExamLogFileName -Exam $sourceExam
            $sourceLog = Join-Path -Path $RepoRoot -ChildPath "$sourceFolder\$sourceLogFileName"
            $sourceSession = Get-ActiveSessionNumber -LogFile $sourceLog
            Close-SessionEntry -SessionNumber $sourceSession -LogFile $sourceLog
            Push-StudyLogChange -SessionNumber $sourceSession -Type 'end' -Exam $sourceExam
            Show-Confirmation -Message "Study session #$sourceSession ended for $sourceExam"
        }
        'End' {
            $sourceExam = Find-ActiveExam
            if (-not $sourceExam) {
                throw 'No active study session found in any exam study log.'
            }

            $sourceFolder = Resolve-ExamFolder -Exam $sourceExam
            $sourceLogFileName = Resolve-ExamLogFileName -Exam $sourceExam
            $sourceLog = Join-Path -Path $RepoRoot -ChildPath "$sourceFolder\$sourceLogFileName"
            $sourceSession = Get-ActiveSessionNumber -LogFile $sourceLog
            Close-SessionEntry -SessionNumber $sourceSession -LogFile $sourceLog
            Push-StudyLogChange -SessionNumber $sourceSession -Type 'end' -Exam $sourceExam
            Show-Confirmation -Message "Study session #$sourceSession ended for $sourceExam"
        }
    }
}

$Helpers = {
    function Resolve-ExamFolder {
        # Map an exam name to its workspace folder using the ExamFolderMap
        param([Parameter(Mandatory)] [string]$Exam)

        if ($ExamFolderMap.ContainsKey($Exam)) {
            return $ExamFolderMap[$Exam]
        }

        return $Exam
    }

    function Resolve-ExamLogFileName {
        # Map an exam name to its log filename and default to StudyLog.md
        param([Parameter(Mandatory)] [string]$Exam)

        if ($ExamLogFileMap.ContainsKey($Exam)) {
            return $ExamLogFileMap[$Exam]
        }

        return 'StudyLog.md'
    }

    function Confirm-StudyLogExists {
        # Verify the StudyLog.md file is present in the exam folder
        if (-not (Test-Path -Path $StudyLogFile)) {
            throw "StudyLog.md not found at '$StudyLogFile'. Please create it first."
        }
    }

    function Confirm-GitRepository {
        # Ensure the workspace root is a Git repository before attempting commit and push
        $isGitRepo = git -C $RepoRoot rev-parse --is-inside-work-tree 2>$null

        if ($LASTEXITCODE -ne 0 -or $isGitRepo -ne 'true') {
            throw "Git repository not found at '$RepoRoot'."
        }
    }

    function Sync-Repository {
        # Pull latest remote changes to absorb periodic statistics commits
        git -C $RepoRoot pull --quiet --no-rebase --no-edit

        if ($LASTEXITCODE -ne 0) {
            throw 'Failed to pull remote changes.'
        }
    }

    function Get-NextSessionNumber {
        # Count existing data rows to determine the next session number
        $lines = Get-Content -Path $StudyLogFile

        $dataRows = $lines |
            Where-Object { $_ -match '^\|\s*\d+\s*\|' }

        if ($dataRows) {
            return ($dataRows | Measure-Object).Count + 1
        }

        return 1
    }

    function Get-ActiveSessionNumber {
        # Find the last open session (started but not ended) in a study log
        param([string]$LogFile = $StudyLogFile)

        $lines = Get-Content -Path $LogFile

        $dataRows = $lines |
            Where-Object { $_ -match '^\|\s*\d+\s*\|' }

        if (-not $dataRows) {
            throw "No sessions found in '$LogFile'."
        }

        # Check the last data row for an empty End column
        $lastRow = if ($dataRows -is [array]) { $dataRows[-1] } else { $dataRows }
        $columns = $lastRow -split '\|'

        if ([string]::IsNullOrWhiteSpace($columns[4])) {
            return [int]$columns[1].Trim()
        }

        throw "No active session found in '$LogFile'. The last session is already closed."
    }

    function Find-ActiveExam {
        # Search all exam logs for an open session to determine the active exam
        foreach ($exam in $AllExams) {
            $folder = Resolve-ExamFolder -Exam $exam
            $logFileName = Resolve-ExamLogFileName -Exam $exam
            $logFile = Join-Path -Path $RepoRoot -ChildPath "$folder\$logFileName"

            if (-not (Test-Path -Path $logFile)) { continue }

            $lines = Get-Content -Path $logFile

            $dataRows = $lines |
                Where-Object { $_ -match '^\|\s*\d+\s*\|' }

            if (-not $dataRows) { continue }

            # Return the exam name when its last session has no End time
            $lastRow = if ($dataRows -is [array]) { $dataRows[-1] } else { $dataRows }
            $columns = $lastRow -split '\|'

            if ([string]::IsNullOrWhiteSpace($columns[4])) {
                return $exam
            }
        }

        return $null
    }

    function Add-SessionEntry {
        # Append a new session row with the current date and start time
        param(
            [Parameter(Mandatory)]
            [int]$SessionNumber
        )

        $now   = Get-Date
        $date  = $now.ToString('M/d/yy')
        $start = $now.ToString('h:mm tt')

        $row = "| $SessionNumber | $date | $start |  |  |  |"

        Add-Content -Path $StudyLogFile -Value $row
    }

    function Close-SessionEntry {
        # Update the active session row with end time and calculated duration
        param(
            [Parameter(Mandatory)]
            [int]$SessionNumber,

            [string]$LogFile = $StudyLogFile
        )

        $lines = Get-Content -Path $LogFile
        $now = Get-Date

        # Search from the bottom for the matching session row
        for ($i = $lines.Count - 1; $i -ge 0; $i--) {
            if ($lines[$i] -match ('^\|\s*' + $SessionNumber + '\s*\|')) {
                $columns = $lines[$i] -split '\|'

                # Parse start datetime from Date and Start columns
                $dateStr  = $columns[2].Trim()
                $startStr = $columns[3].Trim()
                $startDateTime = [datetime]::ParseExact(
                    "$dateStr $startStr",
                    'M/d/yy h:mm tt',
                    $null
                )

                # Calculate session duration
                $duration    = $now - $startDateTime
                $hours       = [math]::Floor($duration.TotalHours)
                $minutes     = $duration.Minutes
                $durationStr = '{0}h {1}m' -f $hours, $minutes

                # Update End and Duration columns
                $endStr      = $now.ToString('h:mm tt')
                $columns[4]  = " $endStr "
                $columns[5]  = " $durationStr "
                $lines[$i]   = $columns -join '|'

                break
            }
        }

        Set-Content -Path $LogFile -Value $lines
    }

    function Push-StudyLogChange {
        # Stage, commit, and push the study log change
        param(
            [Parameter(Mandatory)]
            [int]$SessionNumber,

            [Parameter(Mandatory)]
            [ValidateSet('start', 'end')]
            [string]$Type,

            [string]$Exam = $ExamName
        )

        $folder          = Resolve-ExamFolder -Exam $Exam
        $logFileName     = Resolve-ExamLogFileName -Exam $Exam
        $relativeLogPath = "$folder/$logFileName"
        $commitMessage   = "docs($Exam): $Type study session #$SessionNumber"

        # Stage the study log file
        git -C $RepoRoot add -- $relativeLogPath
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to stage '$relativeLogPath'."
        }

        # Commit the change
        git -C $RepoRoot commit --quiet -m $commitMessage
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to commit changes for '$relativeLogPath'."
        }

        # Push with retry after sync
        git -C $RepoRoot push --quiet
        if ($LASTEXITCODE -ne 0) {
            Sync-Repository

            git -C $RepoRoot push --quiet
            if ($LASTEXITCODE -ne 0) {
                throw 'Failed to push committed changes after syncing remote updates.'
            }
        }
    }

    function Show-Confirmation {
        # Display session action summary
        param([Parameter(Mandatory)] [string]$Message)

        $now  = Get-Date
        $date = $now.ToString('M/d/yy')
        $time = $now.ToString('h:mm tt')

        Write-Output ''
        Write-Output "  $Message"
        Write-Output "  Date : $date"
        Write-Output "  Time : $time"
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
