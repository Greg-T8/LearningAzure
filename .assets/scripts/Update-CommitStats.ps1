<#
.SYNOPSIS
Update commit statistics in README.md using a diff-based approach.

.DESCRIPTION
Analyzes git commit history for the last 7 days, assigns each commit to active
certification categories (auto-discovered from README via Get-ActiveExam plus
Other) based on changed file paths, detects
study session boundaries from commit messages, and calculates hours using a
session-aware diff model:
  - Matched sessions (start + end): time between consecutive commits within
    the session window is credited to the session exam category.
  - Non-session pre-8 AM: time between consecutive commits credited to the
    first commit's category.
  - Non-session weekends post-8 AM: flat 0.5h per commit.
Generates a markdown table with daily activity, weekly totals, and running
totals, then updates README.md between marker comments.

.PARAMETER ConsoleOnly
Print the generated table to console without updating README.md.

.CONTEXT
LearningAzure repository — commit statistics automation.

.AUTHOR
Greg Tate

.NOTES
Program: Update-CommitStats.ps1
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$ConsoleOnly
)

#region CONFIGURATION
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
$MainReadme = Join-Path -Path $RepoRoot -ChildPath 'README.md'
$GetActiveExamScript = Join-Path -Path $PSScriptRoot -ChildPath 'Get-ActiveExam.ps1'

$CertificationStartDates = @{}
$ExamFolders = @()
$TableColumns = @('Other')

$WorkdayStartHour  = 8
$WeekendFlatHours  = 0.5
$MaxDiffHours      = 2.5

$SessionStartPattern = '^docs\(([^)]+)\): start study session #(\d+)$'
$SessionEndPattern   = '^docs\(([^)]+)\): end study session #(\d+)$'
#endregion

$Main = {
    . $Helpers

    # Discover target exams and load certification start dates from the root README
    [string[]]$ExamFolders = @(Get-TargetExam)
    $CertificationStartDates = Get-CertificationStartDateMap -ExamNames $ExamFolders
    [string[]]$TableColumns = @($ExamFolders) + @('Other')

    Write-Host "Generating commit statistics (diff-based)..."

    # Retrieve commits from the last 7 days
    $commits = Get-CommitList -Days 7

    # Generate markdown table from commit data
    $table = Build-CommitTable -Commits $commits -Days 7

    # Display the generated table
    Write-Host "`nGenerated table:"
    Write-Host $table

    # Exit after displaying generated table in console-only mode
    if ($ConsoleOnly) {
        Write-Host "`nConsole-only mode enabled; README.md was not updated."
        return
    }

    # Update README with new statistics
    $success = Update-Readme -NewTable $table

    # Report result
    if ($success) {
        Write-Host "`nCommit statistics updated successfully!" -ForegroundColor Green
    }
    else {
        Write-Warning "Failed to update README.md"
    }

    # Update each active exam README with hours committed
    $running = Get-RunningTotal
    Update-ExamHour -RunningTotal $running -ExamNames $ExamFolders
}

#region HELPER FUNCTIONS
$Helpers = {

    function Get-TargetExam {
        # Return active exams discovered from the shared Get-ActiveExam utility
        if (-not (Test-Path -Path $GetActiveExamScript)) {
            throw "Active exam discovery script not found: $GetActiveExamScript"
        }

        $discovered = & $GetActiveExamScript

        if (-not $discovered) {
            throw 'No active exams found in main README.'
        }

        return @($discovered | Sort-Object)
    }

    function Get-CertificationStartDateMap {
        # Parse certification start dates from the root README certifications table
        param(
            [string[]]$ExamNames
        )

        if (-not (Test-Path -Path $MainReadme)) {
            throw "Main README not found: $MainReadme"
        }

        $lineByExam = @{}
        $lines = Get-Content -Path $MainReadme -Encoding UTF8

        foreach ($line in $lines) {
            if ($line -notmatch '^\|') { continue }
            if ($line -match '^\|\s*Exam\s*\|' -or $line -match '^\|\s*[-:]') { continue }

            if ($line -match '\[\*\*([A-Z]+-\d+)\*\*\]') {
                $lineByExam[$Matches[1]] = $line
            }
        }

        $result = @{}
        foreach ($exam in $ExamNames) {
            if (-not $lineByExam.ContainsKey($exam)) {
                throw "Certification row not found for active exam '$exam' in $MainReadme"
            }

            $cells = $lineByExam[$exam] -split '\|'
            if ($cells.Count -lt 5) {
                throw "Malformed certifications table row for exam '$exam'"
            }

            $durationCell = $cells[4].Trim()
            if ($durationCell -notmatch '(\d{1,2}/\d{1,2}/\d{2,4})') {
                throw "Could not parse start date for exam '$exam' from duration '$durationCell'"
            }

            $startDate = Get-NormalizedDateString -DateText $Matches[1]
            $result[$exam] = $startDate
        }

        return $result
    }

    function Get-NormalizedDateString {
        # Normalize a certification start date to yyyy-MM-dd for consistent comparisons
        param(
            [Parameter(Mandatory)]
            [string]$DateText
        )

        [datetime]$parsedDate = [datetime]::MinValue
        [string[]]$dateFormats = @(
            'M/d/yy',
            'M/d/yyyy',
            'MM/dd/yy',
            'MM/dd/yyyy'
        )

        $culture = [System.Globalization.CultureInfo]::InvariantCulture
        $styles = [System.Globalization.DateTimeStyles]::None

        if (-not [datetime]::TryParseExact($DateText, $dateFormats, $culture, $styles, [ref]$parsedDate)) {
            throw "Could not parse certification start date '$DateText'"
        }

        return $parsedDate.ToString('yyyy-MM-dd')
    }

    function Get-ClassifiedCategory {
        # Determine category for a commit based on its changed file paths
        param(
            [string[]]$FilePaths
        )

        foreach ($exam in $ExamFolders) {
            foreach ($path in $FilePaths) {
                if ($path.StartsWith("certs/$exam/")) {
                    return $exam
                }
            }
        }

        return 'Other'
    }

    function Find-StudySession {
        # Identify matched study session start/end pairs from commit messages
        param(
            [array]$Commits
        )

        $openStarts = @{}
        $sessions = [System.Collections.Generic.List[object]]::new()

        foreach ($commit in $Commits) {

            # Check for session start pattern
            if ($commit.Message -match $SessionStartPattern) {
                $key = "$($Matches[1])|$($Matches[2])"
                $openStarts[$key] = $commit
                continue
            }

            # Check for session end pattern
            if ($commit.Message -match $SessionEndPattern) {
                $key = "$($Matches[1])|$($Matches[2])"

                # Build session only when a matching start exists
                if ($openStarts.ContainsKey($key)) {
                    $sessions.Add([PSCustomObject]@{
                        Exam          = $Matches[1]
                        SessionNumber = [int]$Matches[2]
                        StartCommit   = $openStarts[$key]
                        EndCommit     = $commit
                    })

                    # Close this session key after it is paired
                    $openStarts.Remove($key)
                }
            }
        }

        return $sessions.ToArray()
    }

    function Get-CappedDiffHours {
        # Return capped, non-negative diff hours between two timestamps
        param(
            [datetime]$Start,
            [datetime]$End
        )

        $diffHours = [Math]::Max(0.0, ($End - $Start).TotalHours)
        return [Math]::Min($diffHours, $MaxDiffHours)
    }

    function Get-SessionCategory {
        # Map a session exam label to a table category
        param(
            [string]$Exam
        )

        if ($ExamFolders -contains $Exam) {
            return $Exam
        }

        return 'Other'
    }

    function Test-InSession {
        # Check if a commit falls within any matched study session window
        param(
            [object]$Commit,
            [array]$Sessions
        )

        foreach ($session in $Sessions) {
            if ($Commit.Timestamp -ge $session.StartCommit.Timestamp -and
                $Commit.Timestamp -le $session.EndCommit.Timestamp) {
                return $true
            }
        }

        return $false
    }

    function Get-CommitList {
        # Get chronologically sorted list of commits with categories
        param(
            [int]$Days = 7,
            [string]$SinceDate
        )

        if (-not $SinceDate) {
            $SinceDate = (Get-Date).AddDays(-$Days).ToString('yyyy-MM-dd')
        }

        # Execute git log command to retrieve commits with timestamps and paths
        $gitArgs = @(
            'log'
            "--since=$SinceDate"
            '--name-only'
            '--pretty=format:%H|%ad|%s'
            '--date=format:%Y-%m-%d %H:%M:%S'
        )
        $output = & git @gitArgs 2>&1

        # Exit early if no output
        if (-not $output) {
            return @()
        }

        $commits = [System.Collections.Generic.List[object]]::new()
        $currentTimestamp = $null
        $currentMessage   = $null
        $currentFiles     = [System.Collections.Generic.List[string]]::new()

        # Parse git log output line by line
        foreach ($line in ($output -split "`n")) {

            # Parse commit metadata when line contains pipe separator
            if ($line -match '\|') {
                $parts = $line -split '\|', 3

                if ($parts.Count -ge 3) {

                    # Save previous commit if one is in progress
                    if ($null -ne $currentTimestamp) {
                        $category = Get-ClassifiedCategory -FilePaths $currentFiles.ToArray()
                        $commits.Add([PSCustomObject]@{
                            Timestamp = $currentTimestamp
                            Category  = $category
                            Message   = $currentMessage
                        })
                    }

                    $datetimeStr    = $parts[1]
                    $currentMessage = $parts[2]

                    # Skip automated workflow commits
                    if ($currentMessage -match '\[skip ci\]' -or
                        $currentMessage -match 'Update commit statistics') {
                        $currentTimestamp = $null
                        $currentFiles.Clear()
                        continue
                    }

                    # Parse timestamp and reset file list
                    $currentTimestamp = [datetime]::ParseExact(
                        $datetimeStr, 'yyyy-MM-dd HH:mm:ss', $null
                    )
                    $currentFiles.Clear()
                }
            }
            # Collect file paths for the current commit
            elseif ($line.Trim() -and $null -ne $currentTimestamp) {
                $currentFiles.Add($line.Trim())
            }
        }

        # Save the final commit in the output
        if ($null -ne $currentTimestamp) {
            $category = Get-ClassifiedCategory -FilePaths $currentFiles.ToArray()
            $commits.Add([PSCustomObject]@{
                Timestamp = $currentTimestamp
                Category  = $category
                Message   = $currentMessage
            })
        }

        # Sort commits chronologically (oldest first)
        $sorted = $commits | Sort-Object -Property Timestamp
        return @($sorted)
    }

    function Get-DailyHour {
        # Calculate hours per category for a single day
        param(
            [array]$DayCommits,
            [datetime]$Date,
            [array]$Sessions = @()
        )

        $hours = @{}

        # Calculate session-first diffs inside each matched session pair
        $coveredIndices = [System.Collections.Generic.HashSet[int]]::new()

        foreach ($session in $Sessions) {
            $sessionCategory = Get-SessionCategory -Exam $session.Exam

            # Find commits within this session window
            $sessionCommits = @($DayCommits | Where-Object {
                $_.Timestamp -ge $session.StartCommit.Timestamp -and
                $_.Timestamp -le $session.EndCommit.Timestamp
            } | Sort-Object -Property Timestamp)

            # Credit time between consecutive session commits
            for ($i = 0; $i -lt ($sessionCommits.Count - 1); $i++) {
                $diffHours = Get-CappedDiffHours -Start $sessionCommits[$i].Timestamp -End $sessionCommits[$i + 1].Timestamp
                if (-not $hours.ContainsKey($sessionCategory)) { $hours[$sessionCategory] = 0.0 }
                $hours[$sessionCategory] += $diffHours
            }

            # Mark session commits as covered
            foreach ($sc in $sessionCommits) {
                for ($j = 0; $j -lt $DayCommits.Count; $j++) {
                    if ([object]::ReferenceEquals($DayCommits[$j], $sc)) {
                        [void]$coveredIndices.Add($j)
                    }
                }
            }
        }

        # Filter out commits already covered by sessions
        $outSession = @(for ($k = 0; $k -lt $DayCommits.Count; $k++) {
            if (-not $coveredIndices.Contains($k)) {
                $DayCommits[$k]
            }
        })

        # Separate pre-8AM and post-8AM non-session commits
        $pre8am  = @($outSession | Where-Object { $_.Timestamp.Hour -lt $WorkdayStartHour } | Sort-Object -Property Timestamp)
        $post8am = @($outSession | Where-Object { $_.Timestamp.Hour -ge $WorkdayStartHour })

        # Pre-8AM: credit time diff between consecutive commits to first commit
        for ($i = 0; $i -lt ($pre8am.Count - 1); $i++) {
            $diffHours = Get-CappedDiffHours -Start $pre8am[$i].Timestamp -End $pre8am[$i + 1].Timestamp
            $cat = $pre8am[$i].Category
            if (-not $hours.ContainsKey($cat)) { $hours[$cat] = 0.0 }
            $hours[$cat] += $diffHours
        }

        # Weekend post-8AM: flat 0.5h per commit
        $isWeekend = $Date.DayOfWeek -eq 'Saturday' -or $Date.DayOfWeek -eq 'Sunday'
        if ($isWeekend) {
            foreach ($commit in $post8am) {
                $cat = $commit.Category
                if (-not $hours.ContainsKey($cat)) { $hours[$cat] = 0.0 }
                $hours[$cat] += $WeekendFlatHours
            }
        }

        return $hours
    }

    function Get-ActivityEmoji {
        # Return color-coded emoji based on activity hours
        param(
            [double]$Hours
        )

        if ($Hours -eq 0)     { return '' }
        if ($Hours -lt 1.0)   { return '🟡' }
        if ($Hours -le 2.0)   { return '🟢' }
        return '🟣'
    }

    function Get-RunningTotal {
        # Calculate running totals since each certification's start date
        $earliestStart = ($CertificationStartDates.Values | Sort-Object | Select-Object -First 1)
        $allCommits = Get-CommitList -SinceDate $earliestStart

        # Find study sessions from the full commit history
        $sessions = Find-StudySession -Commits $allCommits

        # Group commits by date
        $commitsByDate = @{}
        foreach ($commit in $allCommits) {
            $dateStr = $commit.Timestamp.ToString('yyyy-MM-dd')
            if (-not $commitsByDate.ContainsKey($dateStr)) {
                $commitsByDate[$dateStr] = [System.Collections.Generic.List[object]]::new()
            }
            $commitsByDate[$dateStr].Add($commit)
        }

        # Accumulate hours per category filtered by certification start dates
        $running = @{}
        foreach ($dateStr in $commitsByDate.Keys) {
            $dayCommits = $commitsByDate[$dateStr].ToArray()
            $dateObj = [datetime]::ParseExact($dateStr, 'yyyy-MM-dd', $null)
            $daily = Get-DailyHour -DayCommits $dayCommits -Date $dateObj -Sessions $sessions

            # Add hours to each category, respecting start dates for certs
            foreach ($category in $daily.Keys) {
                $catHours = $daily[$category]

                if ($CertificationStartDates.ContainsKey($category)) {
                    $certStart = $CertificationStartDates[$category]

                    # Only count hours from dates on or after the cert start
                    if ($dateStr -ge $certStart) {
                        if (-not $running.ContainsKey($category)) { $running[$category] = 0.0 }
                        $running[$category] += $catHours
                    }
                }
                else {
                    # 'Other' counts from the earliest start date
                    if (-not $running.ContainsKey($category)) { $running[$category] = 0.0 }
                    $running[$category] += $catHours
                }
            }
        }

        # Round all values
        $rounded = @{}
        foreach ($key in $running.Keys) {
            $rounded[$key] = [Math]::Round($running[$key], 1)
        }

        return $rounded
    }

    function Build-CommitTable {
        # Generate markdown table for commit statistics
        param(
            [array]$Commits,
            [int]$Days = 7
        )

        # Build list of dates in reverse chronological order
        $dates = @()
        for ($i = 0; $i -lt $Days; $i++) {
            $dates += (Get-Date).AddDays(-$i).ToString('yyyy-MM-dd')
        }

        # Group commits by date
        $commitsByDate = @{}
        foreach ($commit in $Commits) {
            $dateStr = $commit.Timestamp.ToString('yyyy-MM-dd')
            if (-not $commitsByDate.ContainsKey($dateStr)) {
                $commitsByDate[$dateStr] = [System.Collections.Generic.List[object]]::new()
            }
            $commitsByDate[$dateStr].Add($commit)
        }

        # Find study sessions for session-aware time calculation
        $sessions = Find-StudySession -Commits $Commits

        # Initialize markdown table header
        $headerCols = $TableColumns -join ' | '
        $table = "## 📈 Recent Activity (Last 7 Days)`n`n"
        $table += "| Date | $headerCols | Total |`n"

        # Build separator row
        $sepCols = ($TableColumns | ForEach-Object { '------' }) -join '|'
        $table += "|------|$sepCols|-------|`n"

        # Initialize weekly totals
        $weeklyTotals = @{}
        foreach ($col in $TableColumns) { $weeklyTotals[$col] = 0.0 }
        $weeklyGrandTotal = 0.0

        # Process each day in reverse chronological order
        foreach ($date in $dates) {
            $dayCommits = @()
            if ($commitsByDate.ContainsKey($date)) {
                $dayCommits = $commitsByDate[$date].ToArray()
            }
            $dateObj = [datetime]::ParseExact($date, 'yyyy-MM-dd', $null)

            # Calculate daily hours per category
            $daily = @{}
            if ($dayCommits.Count -gt 0) {
                $daily = Get-DailyHour -DayCommits $dayCommits -Date $dateObj -Sessions $sessions
            }
            $dailyTotal = 0.0

            # Build column values for each category
            $colValues = @()
            foreach ($col in $TableColumns) {
                $rawHours = 0.0
                if ($daily.ContainsKey($col)) { $rawHours = $daily[$col] }
                $rounded = [Math]::Round($rawHours, 1)
                $weeklyTotals[$col] += $rounded
                $dailyTotal += $rounded

                # Format cell with activity emoji
                $emoji = Get-ActivityEmoji -Hours $rounded
                if ($rounded -gt 0) {
                    $colValues += "$emoji ${rounded}h"
                }
                else {
                    $colValues += ''
                }
            }

            # Accumulate grand total
            $dailyTotal = [Math]::Round($dailyTotal, 1)
            $weeklyGrandTotal += $dailyTotal

            # Format date display string
            $formattedDate = $dateObj.ToString('ddd, MMM dd')

            # Format total string
            $totalStr = ''
            if ($dailyTotal -gt 0) { $totalStr = "**$($dailyTotal.ToString('0.0'))h**" }

            # Build table row
            $colStr = $colValues -join ' | '
            $table += "| $formattedDate | $colStr | $totalStr |`n"
        }

        # Add weekly totals row
        $weeklyCols = ($TableColumns | ForEach-Object {
            "**$($weeklyTotals[$_].ToString('0.0'))h**"
        }) -join ' | '
        $table += "| **Weekly Total** | $weeklyCols | **$($weeklyGrandTotal.ToString('0.0'))h** |`n"

        # Calculate and add running totals row
        $running = Get-RunningTotal
        $runningCols = @()
        $runningGrand = 0.0
        foreach ($col in $TableColumns) {
            $val = 0.0
            if ($running.ContainsKey($col)) { $val = $running[$col] }
            $runningGrand += $val
            $runningCols += "***$($val.ToString('0.0'))h***"
        }
        $runningStr = $runningCols -join ' | '
        $table += "| ***Running Total*** | $runningStr | ***$($runningGrand.ToString('0.0'))h*** |`n"

        # Add legend and metadata
        $table += "`n*Activity Levels: 🟡 Low (< 1hr) | 🟢 Medium (1-2hrs) | 🟣 High (> 2hrs)*`n"

        $table += "`n*Other = Lab workflow and automation design, content structure and development*  `n"

        # Add timestamp in Central timezone
        try {
            $centralTz = [System.TimeZoneInfo]::FindSystemTimeZoneById('Central Standard Time')
            $centralTime = [System.TimeZoneInfo]::ConvertTime([datetime]::Now, $centralTz)
            $tzAbbrev = if ($centralTz.IsDaylightSavingTime($centralTime)) { 'CDT' } else { 'CST' }
            $table += "`n*Last updated: $($centralTime.ToString('MMMM dd, yyyy')) at $($centralTime.ToString('HH:mm')) $tzAbbrev*`n"
        }
        catch {
            $table += "`n*Last updated: $(Get-Date -Format 'MMMM dd, yyyy') at $(Get-Date -Format 'HH:mm')*`n"
        }

        return $table
    }

    function Update-ExamHour {
        # Update each active exam README with total hours committed
        param(
            [hashtable]$RunningTotal,
            [string[]]$ExamNames
        )

        $startMarker = '<!-- HOURS_COMMITTED -->'
        $endMarker   = '<!-- /HOURS_COMMITTED -->'

        foreach ($exam in $ExamNames) {
            $examReadme = Join-Path $RepoRoot "certs/$exam/README.md"

            # Skip exams without a README
            if (-not (Test-Path -Path $examReadme)) {
                Write-Warning "Exam README not found: $examReadme"
                continue
            }

            $content = Get-Content -Path $examReadme -Raw -Encoding utf8

            # Skip READMEs without the hours markers
            if (-not ($content.Contains($startMarker) -and $content.Contains($endMarker))) {
                continue
            }

            # Look up this exam's running total hours
            $hours = 0.0
            if ($RunningTotal.ContainsKey($exam)) { $hours = $RunningTotal[$exam] }

            # Format hours value (omit decimal for zero)
            $hoursStr = if ($hours -eq 0) { '0h' } else { "$($hours.ToString('0.0'))h" }

            # Replace content between markers
            $pattern  = [regex]::Escape($startMarker) + '.*?' + [regex]::Escape($endMarker)
            $newValue = "$startMarker**Hours Committed:** $hoursStr$endMarker"
            $newContent = [regex]::Replace($content, $pattern, $newValue)

            # Write updated content back to file
            if ($PSCmdlet.ShouldProcess($examReadme, 'Update hours committed')) {
                Set-Content -Path $examReadme -Value $newContent -NoNewline -Encoding utf8
                Write-Host "  Updated hours committed for $exam ($hoursStr)" -ForegroundColor Cyan
            }
        }
    }

    function Update-Readme {
        # Update README.md with new commit statistics table
        param(
            [string]$NewTable
        )

        $readmePath = Join-Path $PSScriptRoot '..\..\README.md'

        # Read current README content
        if (-not (Test-Path -Path $readmePath)) {
            Write-Warning "README.md not found at: $readmePath"
            return $false
        }
        $content = Get-Content -Path $readmePath -Raw -Encoding utf8

        # Define markers for the commit stats section
        $startMarker = '<!-- COMMIT_STATS_START -->'
        $endMarker   = '<!-- COMMIT_STATS_END -->'

        # Replace existing section or insert new one
        if ($content.Contains($startMarker) -and $content.Contains($endMarker)) {

            # Update existing section between markers
            $pattern = [regex]::Escape($startMarker) + '[\s\S]*?' + [regex]::Escape($endMarker)
            $newSection = "$startMarker`n$NewTable`n$endMarker"
            $newContent = [regex]::Replace($content, $pattern, $newSection)
        }
        else {
            # Insert after badges section
            $insertAfter = "</div>`n`n---`n`n## `u{1F3AF} About"
            if ($content.Contains($insertAfter)) {
                $newSection = "`n`n$startMarker`n$NewTable`n$endMarker"
                $newContent = $content.Replace($insertAfter, $insertAfter + $newSection)
            }
            else {
                Write-Warning 'Could not find insertion point in README.md'
                return $false
            }
        }

        # Write updated content back to file
        if ($PSCmdlet.ShouldProcess($readmePath, 'Update commit statistics')) {
            Set-Content -Path $readmePath -Value $newContent -NoNewline -Encoding utf8
            Write-Host 'README.md updated successfully' -ForegroundColor Green
        }

        return $true
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
