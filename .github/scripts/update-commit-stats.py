#!/usr/bin/env python3
"""
Update commit statistics in README.md
Tracks commits per certification for the last 7 days
"""

import subprocess
import re
from datetime import datetime, timedelta
from collections import defaultdict

def get_commits_by_path(days=7):
    """Get commit counts by path for the last N days"""
    since_date = (datetime.now() - timedelta(days=days)).strftime('%Y-%m-%d')

    # Get all commits since the date with file paths
    cmd = [
        'git', 'log',
        f'--since={since_date}',
        '--name-only',
        '--pretty=format:%H|%ad|%s',
        '--date=format:%Y-%m-%d'
    ]

    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        print(f"Error running git log: {result.stderr}")
        return {}

    # Parse commits and group by date and certification
    commits_by_date_cert = defaultdict(lambda: defaultdict(int))

    lines = result.stdout.strip().split('\n')
    current_commit = None
    current_date = None

    for line in lines:
        if '|' in line:  # Commit info line
            parts = line.split('|')
            if len(parts) >= 2:
                current_date = parts[1]
        elif line.strip() and current_date:  # File path line
            # Determine certification from path
            if line.startswith('AI-900/'):
                commits_by_date_cert[current_date]['AI-900'] += 1
            elif line.startswith('AZ-104/'):
                commits_by_date_cert[current_date]['AZ-104'] += 1
            elif line.startswith('.github/') or line == 'README.md':
                commits_by_date_cert[current_date]['Repo'] += 1

    return commits_by_date_cert

def generate_commit_table(commits_by_date_cert, days=7):
    """Generate markdown table for commit statistics"""

    # Get last 7 days (most recent first)
    dates = []
    for i in range(0, days):
        date = (datetime.now() - timedelta(days=i)).strftime('%Y-%m-%d')
        dates.append(date)

    # Build table
    table = "## 📈 Recent Activity (Last 7 Days)\n\n"
    table += "| Date | AI-900 | AZ-104 | Total |\n"
    table += "|------|--------|--------|-------|\n"

    total_ai900 = 0
    total_az104 = 0

    for date in dates:
        ai900 = commits_by_date_cert.get(date, {}).get('AI-900', 0)
        az104 = commits_by_date_cert.get(date, {}).get('AZ-104', 0)
        daily_total = ai900 + az104

        total_ai900 += ai900
        total_az104 += az104

        # Format date as Mon, Oct 29
        date_obj = datetime.strptime(date, '%Y-%m-%d')
        formatted_date = date_obj.strftime('%a, %b %d')

        # Use emoji indicators for activity
        ai900_str = f"{'🟢 ' if ai900 > 0 else ''}{ai900}"
        az104_str = f"{'🟢 ' if az104 > 0 else ''}{az104}"
        total_str = f"**{daily_total}**" if daily_total > 0 else "0"

        table += f"| {formatted_date} | {ai900_str} | {az104_str} | {total_str} |\n"

    # Add totals row
    grand_total = total_ai900 + total_az104
    table += f"| **Total** | **{total_ai900}** | **{total_az104}** | **{grand_total}** |\n"

    table += "\n*🟢 = Activity on this day*\n"
    table += "\n### What counts as activity?\n"
    table += "- Each **file modified** in a commit counts as one activity\n"
    table += "- Activity is grouped by certification path (`AI-900/` or `AZ-104/`)\n"
    table += "- One commit can generate multiple activities if it modifies multiple files\n"
    table += "- Repository infrastructure changes (`.github/`, `README.md`) are tracked separately\n"
    table += f"\n*Last updated: {datetime.now().strftime('%B %d, %Y at %H:%M UTC')}*\n"

    return table

def update_readme(new_table):
    """Update README.md with new commit statistics table"""

    with open('README.md', 'r', encoding='utf-8') as f:
        content = f.read()

    # Define markers for the section
    start_marker = "<!-- COMMIT_STATS_START -->"
    end_marker = "<!-- COMMIT_STATS_END -->"

    # Check if markers exist
    if start_marker in content and end_marker in content:
        # Replace existing section
        pattern = f"{re.escape(start_marker)}.*?{re.escape(end_marker)}"
        new_section = f"{start_marker}\n{new_table}\n{end_marker}"
        new_content = re.sub(pattern, new_section, content, flags=re.DOTALL)
    else:
        # Add section after Quick Stats
        insert_after = "![In Progress](https://img.shields.io/badge/In%20Progress-2-yellow)"
        if insert_after in content:
            new_section = f"\n\n{start_marker}\n{new_table}\n{end_marker}"
            new_content = content.replace(insert_after, insert_after + new_section)
        else:
            print("Warning: Could not find insertion point in README.md")
            return False

    # Write updated content
    with open('README.md', 'w', encoding='utf-8') as f:
        f.write(new_content)

    print("✅ README.md updated successfully")
    return True

def main():
    print("📊 Generating commit statistics...")

    # Get commits for last 7 days
    commits = get_commits_by_path(days=7)

    # Generate table
    table = generate_commit_table(commits, days=7)

    print("\nGenerated table:")
    print(table)

    # Update README
    success = update_readme(table)

    if success:
        print("\n✅ Commit statistics updated successfully!")
    else:
        print("\n❌ Failed to update README.md")
        exit(1)

if __name__ == "__main__":
    main()
