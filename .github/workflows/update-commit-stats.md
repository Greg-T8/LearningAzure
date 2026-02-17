# GitHub Actions Workflow - Commit Statistics

This directory contains the GitHub Actions workflow that automatically updates commit statistics in the main README.

## 📁 Files

### `workflows/update-commit-stats.yml`

The GitHub Actions workflow file that runs the statistics update.

**Triggers:**

- **Daily**: Automatically at 8:00 AM Central Time (14:00 UTC)
- **Manual**: Can be triggered manually from the Actions tab

### `workflows/update-commit-stats.py`

Python script that:

1. Analyzes git commit history for the last 7 days
2. Groups commits by certification (AI-102, AZ-104)
3. Calculates hours of activity (time between first and last commit per day)
  Certification overlaps on the same day are split evenly.

4. Calculates running totals since each certification's start date:
   - AZ-104: Started 1/14/26
   - AI-102: Started 2/9/26
5. Generates a markdown table with daily activity hours, weekly totals, and
  running totals for exam folders
6. Updates the README.md file between the markers
7. Displays timestamp in Central Time (CST/CDT)

## 🔧 How It Works

1. The workflow checks out the repository with full git history
2. Python script runs to analyze commits:
  Looks at the last 7 days of commits, categorizes files by path
  (AI-102/, AZ-104/), tracks timestamps per day, calculates hours,
  and splits overlapping activity windows evenly.

3. Generates a markdown table with:
   - Date (formatted as "Day, Mon DD")
   - Hours of activity per certification
   - Daily totals
   - Weekly totals (sum of last 7 days)
   - Running totals (cumulative hours since each certification's start date)
   - Color-coded activity indicators:
     - 🟡 Light Yellow: Low activity (< 1 hour)
     - 🟢 Green: Medium activity (1-2 hours)
     - 🟣 Purple: High activity (> 2 hours)

4. Updates README.md between `<!-- COMMIT_STATS_START -->` and `<!-- COMMIT_STATS_END -->` markers
5. Commits and pushes changes if any updates were made

## 📊 Table Format

```markdown
| Date | AI-102 | AZ-104 | Total |
|------|--------|--------|-------|
| Tue, Jan 27 | 🟣 8.5h | 🟣 6.2h | **14.7h** |
| Mon, Jan 26 | 🟡 0.5h |  | **0.5h** |
...
| **Weekly Total** | **42.5h** | **38.7h** | **81.2h** |
| ***Running Total*** | ***142.3h*** | ***168.9h*** | ***311.2h*** |

*Activity Levels: 🟡 Low (< 1hr) | 🟢 Medium (1-2hrs) | 🟣 High (> 2hrs)*

*Hours = time between first and last commit of the day in that certification folder*
*Last updated: January 27, 2026 at 14:09 CST*
```

## 🚀 Manual Trigger

To manually trigger the workflow:

1. Go to the **Actions** tab in your GitHub repository
2. Select **Update Commit Statistics** workflow
3. Click **Run workflow** button
4. Select the branch (usually `main`)
5. Click **Run workflow**

## 🔐 Permissions

The workflow requires `contents: write` permission to update the README file. This is configured in the workflow file.

## 🛠️ Testing Locally

You can test the script locally before pushing:

```bash
# From the repository root
python3 .github/workflows/update-commit-stats.py
```

This will update your local README.md with current commit statistics.

## 📝 Notes

- Activity is measured in hours (time between first and last commit of the day)
- Overlapping certification timeframes are split evenly across active certifications
- **Weekdays (Mon-Fri)**: Last commit time is capped at 8:00 AM Central (work start time)
- **Weekends**: No time cap applied
- Single commits count as 0h of activity (no time span)
- Days with 0h activity show as blank cells in the table
- Files are categorized by their path prefix (AI-102/, AZ-104/)
- The workflow uses `[skip ci]` in commit messages to avoid triggering itself
- Dates and timestamps are shown in Central Time (CST/CDT)
- The table shows the most recent 7 days (rolling window)

---

*Last updated: February 9, 2026*
