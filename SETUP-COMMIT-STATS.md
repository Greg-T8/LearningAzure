# Setup Guide for Commit Statistics Workflow

## 🎯 What This Does

The workflow automatically tracks and displays your commit activity for the last 7 days in your main README, broken down by certification (AI-900, AZ-104, and repository files).

## ✅ Setup Steps

### 1. Commit and Push the Files

First, commit all the new files to your repository:

```bash
git add .github/
git add README.md
git commit -m "Add automated commit statistics workflow"
git push origin main
```

### 2. Verify Workflow Permissions (GitHub.com)

1. Go to your repository on GitHub
2. Click **Settings** tab
3. In the left sidebar, click **Actions** → **General**
4. Scroll to **Workflow permissions**
5. Ensure **Read and write permissions** is selected
6. Click **Save**

### 3. Test the Workflow

#### Option A: Automatic (Wait for Push)
The workflow will run automatically when you push to main.

#### Option B: Manual Trigger
1. Go to **Actions** tab on GitHub
2. Click **Update Commit Statistics** in the left sidebar
3. Click **Run workflow** dropdown
4. Select `main` branch
5. Click **Run workflow** button

### 4. Verify the Update

After the workflow runs (takes about 30 seconds):
1. Check the **Actions** tab to see if it completed successfully (green checkmark)
2. Go to your main README.md
3. Look for the "Recent Activity (Last 7 Days)" table
4. It should show your actual commit data with timestamps

## 🔧 Testing Locally (Optional)

Before pushing, you can test the script locally:

```bash
# Make sure you're in the repository root
cd /path/to/LearningAzure

# Run the Python script
python3 .github/scripts/update-commit-stats.py

# Check the changes
git diff README.md
```

If it works correctly:
- The table should show real commit data
- Dates should be the last 7 days
- Totals should be accurate

## 🎨 What the Table Shows

```markdown
| Date | AI-900 | AZ-104 | Repo | Total |
|------|--------|--------|------|-------|
| Mon, Oct 29 | 🟢 3 | 🟢 5 | 🟢 1 | **9** |
```

- **Date**: Day of the week and date
- **AI-900**: Number of commits touching AI-900 files
- **AZ-104**: Number of commits touching AZ-104 files
- **Repo**: Number of commits to repository files (.github, root README, etc.)
- **Total**: Sum of all commits that day
- **🟢**: Green dot indicates activity on that day

## 📅 Update Schedule

The table updates automatically:
- **Daily** at midnight UTC
- **On every push** to the main branch
- **Manually** whenever you trigger it

## 🐛 Troubleshooting

### Workflow Fails
- Check the Actions tab for error messages
- Ensure Python 3.11 is available (workflow installs it)
- Verify the script has the correct markers in README.md

### Table Doesn't Update
- Check workflow permissions (step 2 above)
- Verify the workflow file is in `.github/workflows/`
- Check that markers exist: `<!-- COMMIT_STATS_START -->` and `<!-- COMMIT_STATS_END -->`

### Wrong Commit Counts
- The script counts file changes, not commits
- One commit touching multiple AI-900 files counts multiple times
- This is intentional to show activity volume

## 🔄 How to Disable

If you want to temporarily disable:

1. Go to **Actions** tab
2. Click **Update Commit Statistics**
3. Click the **•••** menu (three dots)
4. Select **Disable workflow**

To re-enable, follow the same steps and select **Enable workflow**.

## 📝 Next Steps

After setup:
1. Make some commits to your certification folders
2. Wait for the workflow to run (or trigger manually)
3. See your activity tracked automatically!

The table will always show a rolling 7-day window, so you can track your daily learning progress.

---

**Need help?** Check the [Workflow README](.github/README.md) for more details.

*Created: October 29, 2025*
