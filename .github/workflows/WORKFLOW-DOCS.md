# GitHub Actions Workflow - Commit Statistics

This directory contains the GitHub Actions workflow that automatically updates commit statistics in the main README.

## 📁 Files

### `workflows/update-commit-stats.yml`
The GitHub Actions workflow file that runs the statistics update.

**Triggers:**
- **Daily**: Automatically at 8:00 AM Central Time (14:00 UTC)
- **Manual**: Can be triggered manually from the Actions tab

### `scripts/update-commit-stats.py`
Python script that:
1. Analyzes git commit history for the last 7 days
2. Groups commits by certification (AI-900, AZ-104)
3. Generates a markdown table with daily commit counts
4. Updates the README.md file between the markers
5. Displays timestamp in Central Time (CST/CDT)

## 🔧 How It Works

1. The workflow checks out the repository with full git history
2. Python script runs to analyze commits:
   - Looks at the last 7 days of commits
   - Categorizes files by path (AI-900/, AZ-104/)
   - Counts commits per day per certification
3. Generates a markdown table with:
   - Date (formatted as "Day, Mon DD")
   - Commits per certification
   - Daily totals
   - Week totals
   - 🟢 indicators for active days
4. Updates README.md between `<!-- COMMIT_STATS_START -->` and `<!-- COMMIT_STATS_END -->` markers
5. Commits and pushes changes if any updates were made

## 📊 Table Format

```markdown
| Date | AI-900 | AZ-104 | Total |
|------|--------|--------|-------|
| Tue, Jan 27 | 🟢 87 | 🟢 60 | **147** |
| Mon, Jan 26 | 0 | 0 | 0 |
...
| **Total** | **156** | **195** | **351** |

*🟢 = Activity on this day*
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
python3 .github/scripts/update-commit-stats.py
```

This will update your local README.md with current commit statistics.

## 📝 Notes

- The commit count is based on files changed, not individual commits
- Files are categorized by their path prefix (AI-900/, AZ-104/)
- The workflow uses `[skip ci]` in commit messages to avoid triggering itself
- Dates and timestamps are shown in Central Time (CST/CDT)
- The table shows the most recent 7 days (rolling window)
- Activity indicator (🟢) appears next to any day with commits

---

*Last updated: January 28, 2026*
