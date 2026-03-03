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
2. Assigns each commit to one category (AI-102, AZ-104, or Other)
  using changed file paths; exam-folder priority is alphabetical
  (AI-102 before AZ-104)
3. Calculates hours of activity using a diff-based model:
  time between consecutive commits before 8:00 AM is credited to
  the first commit's category
4. Applies weekend exception: commits at/after 8:00 AM on Sat/Sun
  are credited as flat 0.5h each (no diffs)

5. Calculates running totals since each certification's start date:
   - AZ-104: Started 1/14/26
   - AI-102: Started 2/9/26
6. Generates a markdown table with daily activity hours, weekly totals, and
  running totals for exam folders
7. Updates the README.md file between the markers
8. Displays timestamp in Central Time (CST/CDT)

## 🔧 How It Works

1. The workflow checks out the repository with full git history
2. Python script runs to analyze commits:
  Looks at the last 7 days of commits, classifies each commit into
  AI-102/AZ-104/Other, credits pre-8:00 AM consecutive commit deltas
  to the first commit's category, and applies the weekend 0.5h rule
  for commits after 8:00 AM.

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
| Date | AI-102 | AZ-104 | Other | Total |
|------|--------|--------|-------|-------|
| Tue, Jan 27 | 🟢 1.4h | 🟡 0.8h | 🟡 0.4h | **2.6h** |
| Mon, Jan 26 | 🟡 0.5h |  |  | **0.5h** |
...
| **Weekly Total** | **12.5h** | **10.7h** | **3.2h** | **26.4h** |
| ***Running Total*** | ***142.3h*** | ***168.9h*** | ***21.4h*** | ***332.6h*** |

*Activity Levels: 🟡 Low (< 1hr) | 🟢 Medium (1-2hrs) | 🟣 High (> 2hrs)*

*Pre-8 AM: time between consecutive commits credited to first commit's folder*
*Weekends after 8 AM: 0.5h flat per commit*
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

You can run the script locally in two modes:

### Console-only mode (preview without writing)

Use `--console-only` to print the generated statistics table to the console without modifying `README.md`. This is useful for validating numbers before committing:

```bash
# From the repository root
python3 .github/workflows/update-commit-stats.py --console-only
```

### Full update mode

Run without arguments to update your local `README.md` with current commit statistics:

```bash
# From the repository root
python3 .github/workflows/update-commit-stats.py
```

### CLI options

| Option | Description |
|--------|-------------|
| *(none)* | Generate stats and update `README.md` |
| `--console-only` | Print stats to console; skip `README.md` update |
| `--help` | Display usage information |

## 📝 Notes

- Activity is measured in hours from commit patterns
- Commits are assigned to AI-102/AZ-104/Other by file-path classification
- If a commit includes multiple exam folders, alphabetical priority applies
  (AI-102 before AZ-104)
- **Mon-Sun (before 8:00 AM)**: Hours come from diffs between consecutive commits,
  credited to the first commit's category
- **Sat/Sun (after 8:00 AM)**: Each commit is credited as 0.5h (no diffs)
- A single pre-8:00 AM commit on a day contributes 0h (no following commit to diff)
- Days with 0h activity show as blank cells in the table
- Files outside exam folders are credited to `Other`
- The workflow uses `[skip ci]` in commit messages to avoid triggering itself
- Dates and timestamps are shown in Central Time (CST/CDT)
- The table shows the most recent 7 days (rolling window)

---

*Last updated: March 3, 2026*
