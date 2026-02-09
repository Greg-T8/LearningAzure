#!/usr/bin/env python3
"""
Update commit statistics in README.md
Tracks hours of activity per certification for the last 7 days
(Hours = time between first and last commit of the day)
"""

import subprocess
import re
from datetime import datetime, timedelta
from zoneinfo import ZoneInfo
from collections import defaultdict

def get_commits_by_path(days=7):
    """Get commit timestamps by path for the last N days"""
    since_date = (datetime.now() - timedelta(days=days)).strftime('%Y-%m-%d')

    # Get all commits since the date with file paths and timestamps
    cmd = [
        'git', 'log',
        f'--since={since_date}',
        '--name-only',
        '--pretty=format:%H|%ad|%s',
        '--date=format:%Y-%m-%d %H:%M:%S'
    ]

    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        print(f"Error running git log: {result.stderr}")
        return {}

    # Parse commits and group timestamps by date and certification
    commits_by_date_cert = defaultdict(lambda: defaultdict(list))

    lines = result.stdout.strip().split('\n')
    current_commit = None
    current_datetime = None
    current_date = None

    for line in lines:
        if '|' in line:  # Commit info line
            parts = line.split('|')
            if len(parts) >= 2:
                current_datetime = parts[1]
                current_date = current_datetime.split()[0]  # Extract just the date
        elif line.strip() and current_datetime:  # File path line
            # Determine certification from path
            if line.startswith('AI-900/'):
                commits_by_date_cert[current_date]['AI-900'].append(current_datetime)
            elif line.startswith('AI-102/'):
                commits_by_date_cert[current_date]['AI-102'].append(current_datetime)
            elif line.startswith('AZ-104/'):
                commits_by_date_cert[current_date]['AZ-104'].append(current_datetime)
            elif line.startswith('.github/') or line == 'README.md':
                commits_by_date_cert[current_date]['Repo'].append(current_datetime)

    return commits_by_date_cert

def calculate_hours(timestamps):
    """Calculate hours between first and last commit
    For weekdays (Mon-Fri), caps the end time at 8:00 AM Central"""
    if not timestamps or len(timestamps) == 0:
        return 0.0

    if len(timestamps) == 1:
        return 0.0  # Single commit = 0 hours of activity

    # Parse timestamps
    dt_objects = [datetime.strptime(ts, '%Y-%m-%d %H:%M:%S') for ts in timestamps]

    # Get earliest and latest
    earliest = min(dt_objects)
    latest = max(dt_objects)

    # For weekdays (Mon=0 to Fri=4), cap the latest time at 8:00 AM
    if earliest.weekday() < 5:  # Monday through Friday
        work_start = earliest.replace(hour=8, minute=0, second=0)
        if latest > work_start:
            latest = work_start

    # Calculate difference in hours
    time_diff = latest - earliest
    hours = time_diff.total_seconds() / 3600

    return round(hours, 1)

def generate_commit_table(commits_by_date_cert, days=7):
    """Generate markdown table for commit statistics"""

    # Get last 7 days (most recent first)
    dates = []
    for i in range(0, days):
        date = (datetime.now() - timedelta(days=i)).strftime('%Y-%m-%d')
        dates.append(date)

    # Build table
    table = "## 📈 Recent Activity (Last 7 Days)\n\n"
    table += "| Date | AI-102 | AZ-104 | AI-900 | Total |\n"
    table += "|------|--------|--------|--------|-------|\n"

    total_ai102 = 0.0
    total_az104 = 0.0
    total_ai900 = 0.0

    for date in dates:
        ai102_timestamps = commits_by_date_cert.get(date, {}).get('AI-102', [])
        az104_timestamps = commits_by_date_cert.get(date, {}).get('AZ-104', [])
        ai900_timestamps = commits_by_date_cert.get(date, {}).get('AI-900', [])

        ai102_hours = calculate_hours(ai102_timestamps)
        az104_hours = calculate_hours(az104_timestamps)
        ai900_hours = calculate_hours(ai900_timestamps)
        daily_total = ai102_hours + az104_hours + ai900_hours

        total_ai102 += ai102_hours
        total_az104 += az104_hours
        total_ai900 += ai900_hours

        # Format date as Mon, Oct 29
        date_obj = datetime.strptime(date, '%Y-%m-%d')
        formatted_date = date_obj.strftime('%a, %b %d')

        # Use emoji indicators for activity
        ai102_str = f"{'🟢 ' if ai102_hours > 0 else ''}{ai102_hours}h" if ai102_hours > 0 else "0h"
        az104_str = f"{'🟢 ' if az104_hours > 0 else ''}{az104_hours}h" if az104_hours > 0 else "0h"
        ai900_str = f"{'🟢 ' if ai900_hours > 0 else ''}{ai900_hours}h" if ai900_hours > 0 else "0h"
        total_str = f"**{daily_total:.1f}h**" if daily_total > 0 else "0h"

        table += f"| {formatted_date} | {ai102_str} | {az104_str} | {ai900_str} | {total_str} |\n"

    # Add totals row
    grand_total = total_ai102 + total_az104 + total_ai900
    table += f"| **Total** | **{total_ai102:.1f}h** | **{total_az104:.1f}h** | **{total_ai900:.1f}h** | **{grand_total:.1f}h** |\n"

    table += "\n*🟢 = Activity on this day (hours between first and last commit in that certification folder)*\n"

    # Get current time in Central timezone
    central_time = datetime.now(ZoneInfo('America/Chicago'))
    table += f"\n*Last updated: {central_time.strftime('%B %d, %Y at %H:%M %Z')}*\n"

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
        # Add section after badges
        insert_after = "</div>\n\n---\n\n## 🎯 About"
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
