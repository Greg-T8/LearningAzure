<#
.SYNOPSIS
Manage study sessions for certification exam tracking.

.DESCRIPTION
Manages study session tracking for certification exams. Supports Start and Stop actions:
Start — inserts a new row at the top of StudyLog.md with session number, date, and start time.
        Auto-closes any currently active session in another exam before opening the new one.
Stop  — closes the active session with end time and duration.
Sessions may optionally be tagged with a Task from the exam's Skills.psd1.

.CONTEXT
LearningAzure repository — certification study tracking.

.AUTHOR
Greg Tate

.NOTES
Program: Invoke-AzStudySession.ps1
#>

[CmdletBinding()]
param(
    [ValidateSet('Start', 'Stop')]
    [string]$Action = 'Start',

    [string]$Exam,

    [ValidateSet('Prepare', 'Research', 'Practice', 'Review')]
    [string]$Mode,

    [ArgumentCompleter({
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

        $examValue = $fakeBoundParameters['Exam']
        if (-not $examValue) { return }

        # Resolve the script directory from the command path
        $resolved = Resolve-Path -Path $commandName -ErrorAction SilentlyContinue
        if (-not $resolved) { return }

        $scriptDir  = Split-Path -Parent $resolved.Path
        $repoRoot   = (Resolve-Path -Path "$scriptDir\..\.."  ).Path
        $skillsFile = Join-Path -Path $repoRoot -ChildPath "certs\$examValue\Skills.psd1"
        if (-not (Test-Path -Path $skillsFile)) { return }

        # Return matching task names from the exam's skills file (deduped across skills)
        (Import-PowerShellDataFile -Path $skillsFile).Domains |
            ForEach-Object { $_.Skills } |
            ForEach-Object { $_.Tasks } |
            Sort-Object -Unique |
            Where-Object { $_ -like "$wordToComplete*" } |
            ForEach-Object {
                [System.Management.Automation.CompletionResult]::new("'$_'", $_, 'ParameterValue', $_)
            }
    })]
    [string]$Task,

    [string]$Notes
)

# Configuration
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
$StudyLogFile = $null
$GetActiveExamScript = Join-Path -Path $PSScriptRoot -ChildPath 'Get-ActiveExam.ps1'

$Main = {
    . $Helpers

    Confirm-GitRepository
    Sync-Repository

    # Route to the appropriate action handler
    switch ($Action) {
        'Start' {
            if (-not $Exam) {
                throw "Exam is required when Action is 'Start'."
            }

            Confirm-ValidExam -Exam $Exam

            if (-not $Mode) {
                throw "Mode is required when Action is 'Start'."
            }

            # Task is optional; validate against Skills.psd1 tasks when supplied
            if ($Task) {
                Confirm-ValidTask -Exam $Exam -Task $Task
            }

            $folder = Resolve-ExamFolder -Exam $Exam
            $logFileName = Resolve-ExamLogFileName -Exam $Exam
            $script:StudyLogFile = Join-Path -Path $RepoRoot -ChildPath "$folder\$logFileName"

            # End any currently active session before starting a new one
            $sourceExam = Find-ActiveExam
            if ($sourceExam) {
                $sourceFolder = Resolve-ExamFolder -Exam $sourceExam
                $sourceLogFileName = Resolve-ExamLogFileName -Exam $sourceExam
                $sourceLog = Join-Path -Path $RepoRoot -ChildPath "$sourceFolder\$sourceLogFileName"
                $sourceSession = Get-ActiveSessionNumber -LogFile $sourceLog
                Close-SessionEntry -SessionNumber $sourceSession -LogFile $sourceLog -UseLastCommit
                Push-StudyLogChange -SessionNumber $sourceSession -Type 'end' -Exam $sourceExam
                Show-Confirmation -Message "Study session #$sourceSession ended for $sourceExam (auto-closed at last commit)"
            }

            Confirm-StudyLogExists
            $session = Get-NextSessionNumber
            Add-SessionEntry -SessionNumber $session -Mode $Mode -Task $Task -Notes $Notes
            Push-StudyLogChange -SessionNumber $session -Type 'start' -Exam $Exam
            Show-Confirmation -Message "Study session #$session started for $Exam"
        }
        'Stop' {
            # If Exam is provided, stop the active session in that exam log; otherwise detect the active exam.
            $sourceExam = if ($Exam) { $Exam } else { Find-ActiveExam }
            if (-not $sourceExam) {
                throw 'No active study session found in any exam study log.'
            }

            if ($Exam) {
                Confirm-ValidExam -Exam $sourceExam
            }

            $sourceFolder = Resolve-ExamFolder -Exam $sourceExam
            $sourceLogFileName = Resolve-ExamLogFileName -Exam $sourceExam
            $sourceLog = Join-Path -Path $RepoRoot -ChildPath "$sourceFolder\$sourceLogFileName"

            if (-not (Test-Path -Path $sourceLog)) {
                throw "Study log not found at '$sourceLog'."
            }

            $sourceSession = Get-ActiveSessionNumber -LogFile $sourceLog
            Close-SessionEntry -SessionNumber $sourceSession -LogFile $sourceLog -Notes $Notes
            Push-StudyLogChange -SessionNumber $sourceSession -Type 'end' -Exam $sourceExam
            Show-Confirmation -Message "Study session #$sourceSession ended for $sourceExam"
        }
    }
}

$Helpers = {
    function Resolve-ExamFolder {
        # Map an exam name to its workspace folder under certs\<exam>
        param([Parameter(Mandatory)] [string]$Exam)

        return "certs\$Exam"
    }

    function Resolve-ExamLogFileName {
        # All exams use a StudyLog.md file in their folder
        param([Parameter(Mandatory)] [string]$Exam)

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
        # Find the most recent open session (started but not ended) in a study log
        param([string]$LogFile = $StudyLogFile)

        $lines = Get-Content -Path $LogFile

        $dataRows = $lines |
            Where-Object { $_ -match '^\|\s*\d+\s*\|' }

        if (-not $dataRows) {
            throw "No sessions found in '$LogFile'."
        }

        # Check the first data row for a started-but-not-ended session (latest entry is at the top)
        $firstRow = if ($dataRows -is [array]) { $dataRows[0] } else { $dataRows }
        $columns = $firstRow -split '\|'

        # A session is active only when Start is populated and End is blank;
        # gap-fill rows have both blank and must not be treated as active.
        if (-not [string]::IsNullOrWhiteSpace($columns[3]) -and [string]::IsNullOrWhiteSpace($columns[4])) {
            return [int]$columns[1].Trim()
        }

        throw "No active session found in '$LogFile'. The latest session is already closed."
    }

    function Find-ActiveExam {
        # Search all exam logs for an open session to determine the active exam
        $allExams = Get-AllExamWithLog

        foreach ($exam in $allExams) {
            $folder = Resolve-ExamFolder -Exam $exam
            $logFileName = Resolve-ExamLogFileName -Exam $exam
            $logFile = Join-Path -Path $RepoRoot -ChildPath "$folder\$logFileName"

            if (-not (Test-Path -Path $logFile)) { continue }

            $lines = Get-Content -Path $logFile

            $dataRows = $lines |
                Where-Object { $_ -match '^\|\s*\d+\s*\|' }

            if (-not $dataRows) { continue }

            # Return the exam name when its latest session is started but not ended (top of table);
            # gap-fill rows (blank Start and blank End) are not active sessions.
            $firstRow = if ($dataRows -is [array]) { $dataRows[0] } else { $dataRows }
            $columns = $firstRow -split '\|'

            if (-not [string]::IsNullOrWhiteSpace($columns[3]) -and [string]::IsNullOrWhiteSpace($columns[4])) {
                return $exam
            }
        }

        return $null
    }

    function Get-AllExamWithLog {
        # Discover all exams that have a StudyLog.md file
        $allExams = [System.Collections.Generic.List[string]]::new()

        $certsDir = Join-Path -Path $RepoRoot -ChildPath 'certs'

        if (Test-Path -Path $certsDir) {
            Get-ChildItem -Path $certsDir -Directory |
                Where-Object { $_.Name -notmatch '^\.' } |
                ForEach-Object {
                    $logFile = Join-Path -Path $_.FullName -ChildPath 'StudyLog.md'

                    if (Test-Path -Path $logFile) {
                        $allExams.Add($_.Name)
                    }
                }
        }

        return $allExams
    }

    function Confirm-ValidExam {
        # Validate that the requested exam is an active exam
        param([Parameter(Mandatory)] [string]$Exam)

        $activeExams = & $GetActiveExamScript

        if ($Exam -notin $activeExams) {
            throw "Exam '$Exam' is not active. Valid exams: $($activeExams -join ', ')"
        }
    }

    function Get-ExamTask {
        # Load deduplicated task names from the exam's Skills.psd1 file
        param([Parameter(Mandatory)] [string]$Exam)

        $folder     = Resolve-ExamFolder -Exam $Exam
        $skillsFile = Join-Path -Path $RepoRoot -ChildPath "$folder\Skills.psd1"

        if (-not (Test-Path -Path $skillsFile)) {
            return @()
        }

        $data = Import-PowerShellDataFile -Path $skillsFile

        $data.Domains |
            ForEach-Object { $_.Skills } |
            ForEach-Object { $_.Tasks } |
            Sort-Object -Unique
    }

    function Confirm-ValidTask {
        # Validate that the specified task exists under any skill in the exam's skills file
        param(
            [Parameter(Mandatory)] [string]$Exam,
            [Parameter(Mandatory)] [string]$Task
        )

        $validTasks = @(Get-ExamTask -Exam $Exam)

        if ($validTasks.Count -eq 0) {
            throw "No Skills.psd1 found for exam '$Exam'."
        }

        if ($Task -notin $validTasks) {
            throw "Task '$Task' is not valid for $Exam. Valid tasks:`n  $($validTasks -join "`n  ")"
        }
    }

    function Add-SessionEntry {
        # Insert a new session row at the top of the table (after the header separator)
        param(
            [Parameter(Mandatory)]
            [int]$SessionNumber,

            [string]$Mode,

            [string]$Task,

            [string]$Notes,

            [datetime]$StartTime
        )

        # Use explicit start time when provided, otherwise current time
        $now       = if ($PSBoundParameters.ContainsKey('StartTime')) { $StartTime } else { Get-Date }
        $date      = $now.ToString('M/d/yy')
        $start     = $now.ToString('h:mm tt')
        $safeMode  = ConvertTo-LogNote -Notes $Mode
        $safeTask  = ConvertTo-LogNote -Notes $Task
        $safeNotes = ConvertTo-LogNote -Notes $Notes
        $lines     = Get-Content -Path $StudyLogFile

        # Detect whether the log uses the extended format (Mode + Skill/Task columns)
        $headerIndex = $null
        for ($h = 0; $h -lt $lines.Count; $h++) {
            if ($lines[$h] -match '^\|\s*#\s*\|') {
                $headerIndex = $h
                break
            }
        }
        $headerLine = if ($null -ne $headerIndex) { $lines[$headerIndex] } else { $null }
        $hasExtendedColumns = $headerLine -match '\|\s*Mode\s*\|'

        # Rename legacy "Skill" header cell to "Task" on first write so new rows align
        if ($hasExtendedColumns -and $headerLine -match '\|\s*Skill\s*\|') {
            $lines[$headerIndex] = $headerLine -replace '(\|\s*)Skill(\s*\|)', '$1Task$2'
        }

        # Build the row to match the log's column format
        if ($hasExtendedColumns) {
            $row = "| $SessionNumber | $date | $start |  |  | $safeMode | $safeTask | $safeNotes |"
        }
        else {
            $row = "| $SessionNumber | $date | $start |  |  | $safeNotes |"
        }

        # Find the separator line and insert the new row right after it
        $insertIndex = $null
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^\|:') {
                $insertIndex = $i + 1
                break
            }
        }

        if ($null -eq $insertIndex) {
            throw "Table header separator not found in '$StudyLogFile'."
        }

        # Build updated content with the new row inserted at the top of the data rows
        $updated = @()
        $updated += $lines[0..($insertIndex - 1)]
        $updated += $row
        if ($insertIndex -lt $lines.Count) {
            $updated += $lines[$insertIndex..($lines.Count - 1)]
        }

        Set-Content -Path $StudyLogFile -Value $updated
    }

    function ConvertTo-LogNote {
        # Normalize user note text so markdown table formatting is preserved
        param([string]$Notes)

        if ([string]::IsNullOrWhiteSpace($Notes)) {
            return ''
        }

        $normalized = $Notes.Trim() -replace '\|', '\\|'
        return $normalized
    }

    function Close-SessionEntry {
        # Update the active session row with end time and calculated duration
        param(
            [Parameter(Mandatory)]
            [int]$SessionNumber,

            [string]$LogFile = $StudyLogFile,

            [string]$Notes,

            [switch]$UseLastCommit,

            [datetime]$EndTime
        )

        $lines = Get-Content -Path $LogFile

        # Resolve end time: explicit parameter, last git commit, or current time
        $endTime = if ($PSBoundParameters.ContainsKey('EndTime')) { $EndTime }
                   elseif ($UseLastCommit) { Get-LastCommitTime }
                   else { Get-Date }

        # Search from the top for the matching session row (latest entries are first)
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match ('^\|\s*' + $SessionNumber + '\s*\|')) {
                $columns = $lines[$i] -split '\|'

                # Parse start datetime from Date and Start columns
                $dateStr  = $columns[2].Trim()
                $startStr = $columns[3].Trim()

                # Guard: skip gap-fill rows (blank Start) when auto-closing — they are not real sessions
                if ([string]::IsNullOrWhiteSpace($startStr) -and $UseLastCommit) {
                    break
                }

                # Parse the start datetime defensively to handle historical rows with blank Start values
                $startText = if ([string]::IsNullOrWhiteSpace($startStr)) { $dateStr } else { "$dateStr $startStr" }
                $startDateTime = [datetime]::MinValue

                # Prefer current culture, then invariant culture, to tolerate host-specific parsing behavior.
                $parsedStart = [datetime]::TryParse(
                    $startText,
                    [System.Globalization.CultureInfo]::CurrentCulture,
                    [System.Globalization.DateTimeStyles]::AllowWhiteSpaces,
                    [ref]$startDateTime
                )

                if (-not $parsedStart) {
                    $parsedStart = [datetime]::TryParse(
                        $startText,
                        [System.Globalization.CultureInfo]::InvariantCulture,
                        [System.Globalization.DateTimeStyles]::AllowWhiteSpaces,
                        [ref]$startDateTime
                    )
                }

                if (-not $parsedStart) {
                    if ($UseLastCommit) {
                        $startDateTime = $endTime
                    }
                    else {
                        throw "Unable to parse session start date/time '$startText' for session #$SessionNumber in '$LogFile'."
                    }
                }

                if ($startDateTime -gt $endTime) {
                    $startDateTime = $endTime
                }

                # Calculate session duration
                $duration    = $endTime - $startDateTime
                $hours       = [math]::Floor($duration.TotalHours)
                $minutes     = $duration.Minutes
                $durationStr = '{0}h {1}m' -f $hours, $minutes

                # Update End and Duration columns
                $endStr      = $endTime.ToString('h:mm tt')
                $columns[4]  = " $endStr "
                $columns[5]  = " $durationStr "

                # Determine Notes column index (supports both 6-column and 8-column formats)
                $notesIdx = $columns.Count - 2

                # Tag auto-closed sessions so the log shows they were estimated
                if ($UseLastCommit) {
                    $autoNote = 'auto-closed at last commit'
                    $existingNotes = $columns[$notesIdx].Trim()

                    if ([string]::IsNullOrWhiteSpace($existingNotes)) {
                        $columns[$notesIdx] = " $autoNote "
                    }
                    else {
                        $columns[$notesIdx] = " $existingNotes; $autoNote "
                    }
                }

                # Append a user-provided note to the Notes column when supplied
                $safeNotes = ConvertTo-LogNote -Notes $Notes
                if (-not [string]::IsNullOrWhiteSpace($safeNotes)) {
                    $existingNotes = $columns[$notesIdx].Trim()

                    if ([string]::IsNullOrWhiteSpace($existingNotes)) {
                        $columns[$notesIdx] = " $safeNotes "
                    }
                    else {
                        $columns[$notesIdx] = " $existingNotes; $safeNotes "
                    }
                }

                $lines[$i]   = $columns -join '|'

                break
            }
        }

        Set-Content -Path $LogFile -Value $lines
    }

    function Get-LastCommitTime {
        # Retrieve the author date of the last user commit, excluding automated [skip ci] commits
        $isoDate = git -C $RepoRoot log -1 --format=%aI --grep='\[skip ci\]' --invert-grep

        if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($isoDate)) {
            throw 'Failed to retrieve last commit timestamp.'
        }

        return [datetimeoffset]::Parse($isoDate).LocalDateTime
    }

    function Push-StudyLogChange {
        # Stage, commit, and push the study log change
        param(
            [Parameter(Mandatory)]
            [int]$SessionNumber,

            [Parameter(Mandatory)]
            [ValidateSet('start', 'end')]
            [string]$Type,

            [string]$Exam = $script:Exam
        )

        $folder          = Resolve-ExamFolder -Exam $Exam
        $logFileName     = Resolve-ExamLogFileName -Exam $Exam
        $relativeLogPath = "$folder/$logFileName"
        $commitMessage   = "docs($Exam): $Type study session #$SessionNumber"

        Push-FileChange -RelativePath $relativeLogPath -CommitMessage $commitMessage
    }

    function Push-FileChange {
        # Stage, commit, and push a single file change
        param(
            [Parameter(Mandatory)]
            [string]$RelativePath,

            [Parameter(Mandatory)]
            [string]$CommitMessage
        )

        # Stage the target file
        git -C $RepoRoot add -- $RelativePath
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to stage '$RelativePath'."
        }

        # Commit the change
        git -C $RepoRoot commit --quiet -m $CommitMessage
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to commit changes for '$RelativePath'."
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
