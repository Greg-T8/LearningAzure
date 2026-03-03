# -------------------------------------------------------------------------
# Program: update-commit-stats.py
# Description: Update commit statistics in README.md using a diff-based
#              approach. For consecutive pre-8AM commits on the same day,
#              the time delta is credited to the first commit's exam folder.
#              Weekend post-8AM commits receive a flat 0.5h credit each.
# Context: LearningAzure repository - commit statistics automation
# Author: Greg Tate
# -------------------------------------------------------------------------

#region IMPORTS
import argparse
import re
import subprocess
import sys
from collections import defaultdict
from dataclasses import dataclass
from datetime import datetime, timedelta
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError
#endregion


#region CONSTANTS
CERTIFICATIONS = {
    'AI-102': '2026-02-09',
    'AZ-104': '2026-01-14',
}

EXAM_FOLDERS = sorted(CERTIFICATIONS.keys())
TABLE_COLUMNS = EXAM_FOLDERS + ['Other']

WORKDAY_START_HOUR = 8
WEEKEND_FLAT_HOURS = 0.5
#endregion


#region DATA CLASSES
@dataclass
class Commit:
    """Represents a single git commit with its assigned category."""

    timestamp: datetime
    category: str
    message: str
#endregion


#region MAIN WORKFLOW
def main() -> int:
    """Main function that orchestrates commit statistics update.

    Retrieves recent commits, generates activity table, and updates README.md.
    """
    args = parse_argument()

    # Show progress status in the console
    print("📊 Generating commit statistics (diff-based)...")

    # Retrieve commits from the last 7 days
    commits = get_commit_list(days=7)

    # Generate markdown table from commit data
    table = build_commit_table(commits, days=7)

    # Display the generated table output
    print("\nGenerated table:")
    print(table)

    # Exit after displaying generated table in console-only mode
    if args.console_only:
        print("\nℹ️ Console-only mode enabled; README.md was not updated.")
        return 0

    # Update README with new statistics
    success = update_readme(table)

    # Return appropriate process status code
    if success:
        print("\n✅ Commit statistics updated successfully!")
        return 0
    else:
        print("\n❌ Failed to update README.md")
        return 1
#endregion


# Helper Functions
# -------------------------------------------------------------------------

#region HELPER FUNCTIONS

def parse_argument() -> argparse.Namespace:
    """Parse command-line arguments for commit statistics generation.

    Returns:
        Parsed command-line arguments
    """
    parser = argparse.ArgumentParser(
        description=(
            "Generate commit statistics (diff-based) for "
            "LearningAzure and optionally update README.md."
        )
    )
    parser.add_argument(
        '--console-only',
        action='store_true',
        help=(
            'Print generated commit statistics to console '
            'without updating README.md.'
        ),
    )
    return parser.parse_args()


def classify_commit(file_paths: list[str]) -> str:
    """Determine category for a commit based on its changed file paths.

    Checks exam folders in alphabetical order. First match wins.
    Falls back to 'Other' when no exam folder matches.

    Args:
        file_paths: List of file paths changed in the commit

    Returns:
        Exam folder name or 'Other'
    """
    # Check each exam folder in alphabetical priority order
    for exam_folder in EXAM_FOLDERS:
        for path in file_paths:
            if path.startswith(f'{exam_folder}/'):
                return exam_folder

    return 'Other'


def get_commit_list(
    days: int = 7,
    since_date: str | None = None
) -> list['Commit']:
    """Get chronologically sorted list of commits with categories.

    Args:
        days: Number of days to look back (default: 7)
        since_date: Specific date to start from (overrides days parameter)

    Returns:
        List of Commit objects sorted by timestamp (oldest first)
    """
    if since_date is None:
        since_date = (
            datetime.now() - timedelta(days=days)
        ).strftime('%Y-%m-%d')

    # Build git command to retrieve commits with timestamps and paths
    cmd = [
        'git', 'log',
        f'--since={since_date}',
        '--name-only',
        '--pretty=format:%H|%ad|%s',
        '--date=format:%Y-%m-%d %H:%M:%S',
    ]

    # Execute git log command
    result = subprocess.run(cmd, capture_output=True, text=True)

    # Exit early if git command failed
    if result.returncode != 0:
        print(f"Error running git log: {result.stderr}")
        return []

    # Parse commits from git log output
    commits: list[Commit] = []
    lines = result.stdout.strip().split('\n')
    current_timestamp: datetime | None = None
    current_message: str | None = None
    current_files: list[str] = []

    # Iterate through git log output to build commit objects
    for line in lines:

        # Parse commit metadata when line contains pipe separator
        if '|' in line:
            parts = line.split('|')
            if len(parts) >= 3:

                # Save previous commit if one is in progress
                if current_timestamp is not None:
                    category = classify_commit(current_files)
                    commits.append(Commit(
                        timestamp=current_timestamp,
                        category=category,
                        message=current_message,
                    ))

                datetime_str = parts[1]
                current_message = parts[2]

                # Skip automated workflow commits
                if (
                    '[skip ci]' in current_message
                    or 'Update commit statistics' in current_message
                ):
                    current_timestamp = None
                    current_files = []
                    continue

                # Parse timestamp and reset file list
                current_timestamp = datetime.strptime(
                    datetime_str, '%Y-%m-%d %H:%M:%S'
                )
                current_files = []

        # Collect file paths for the current commit
        elif line.strip() and current_timestamp is not None:
            current_files.append(line.strip())

    # Save the final commit in the output
    if current_timestamp is not None:
        category = classify_commit(current_files)
        commits.append(Commit(
            timestamp=current_timestamp,
            category=category,
            message=current_message,
        ))

    # Sort commits chronologically (oldest first)
    commits.sort(key=lambda c: c.timestamp)

    return commits


def calculate_daily_hour(
    day_commits: list['Commit'],
    date: datetime
) -> dict[str, float]:
    """Calculate hours per category for a single day using diff approach.

    Pre-8AM commits: consecutive time diffs credited to first commit's
    folder. Weekend post-8AM commits: flat 0.5h credited to each commit's
    folder.

    Args:
        day_commits: List of Commit objects for the day
        date: Date object for weekend detection

    Returns:
        Dict mapping category names to hours
    """
    hours: dict[str, float] = defaultdict(float)

    # Separate pre-8AM and post-8AM commits
    pre_8am = [
        c for c in day_commits
        if c.timestamp.hour < WORKDAY_START_HOUR
    ]
    post_8am = [
        c for c in day_commits
        if c.timestamp.hour >= WORKDAY_START_HOUR
    ]

    # Pre-8AM: credit time diff between consecutive commits to first commit
    pre_8am.sort(key=lambda c: c.timestamp)
    for i in range(len(pre_8am) - 1):
        diff_seconds = (
            pre_8am[i + 1].timestamp - pre_8am[i].timestamp
        ).total_seconds()
        diff_hours = diff_seconds / 3600
        hours[pre_8am[i].category] += diff_hours

    # Weekend post-8AM: flat 0.5h per commit
    is_weekend = date.weekday() >= 5
    if is_weekend:
        for commit in post_8am:
            hours[commit.category] += WEEKEND_FLAT_HOURS

    return dict(hours)


def get_activity_emoji(hours: float) -> str:
    """Return color-coded emoji based on activity hours.

    Args:
        hours: Number of hours of activity

    Returns:
        Emoji: empty string (0h), 🟡 (<1h), 🟢 (1-2h), 🟣 (>2h)
    """
    if hours == 0:
        return ""
    elif hours < 1.0:
        return "🟡"
    elif hours <= 2.0:
        return "🟢"
    else:
        return "🟣"


def calculate_running_total() -> dict[str, float]:
    """Calculate running totals since each certification's start date.

    Returns:
        Dict mapping category names to cumulative hours
    """
    # Get commits from the earliest certification start date
    earliest_start = min(CERTIFICATIONS.values())
    all_commits = get_commit_list(since_date=earliest_start)

    # Group commits by date
    commits_by_date: dict[str, list[Commit]] = defaultdict(list)
    for commit in all_commits:
        date_str = commit.timestamp.strftime('%Y-%m-%d')
        commits_by_date[date_str].append(commit)

    # Accumulate hours per category filtered by certification start dates
    running: dict[str, float] = defaultdict(float)
    for date_str, day_commits in commits_by_date.items():
        date_obj = datetime.strptime(date_str, '%Y-%m-%d')
        daily = calculate_daily_hour(day_commits, date_obj)

        # Add hours to each category, respecting start dates for certs
        for category, cat_hours in daily.items():
            if category in CERTIFICATIONS:
                cert_start = CERTIFICATIONS[category]

                # Only count hours from dates on or after the cert start
                if date_str >= cert_start:
                    running[category] += cat_hours
            else:

                # 'Other' counts from the earliest start date
                running[category] += cat_hours

    # Round all values
    return {k: round(v, 1) for k, v in running.items()}


def build_commit_table(
    commits: list['Commit'],
    days: int = 7
) -> str:
    """Generate markdown table for commit statistics.

    Args:
        commits: List of Commit objects
        days: Number of days to include in table (default: 7)

    Returns:
        Formatted markdown table as string
    """
    # Build list of dates in reverse chronological order
    dates = []
    for i in range(days):
        date = (
            datetime.now() - timedelta(days=i)
        ).strftime('%Y-%m-%d')
        dates.append(date)

    # Group commits by date
    commits_by_date: dict[str, list[Commit]] = defaultdict(list)
    for commit in commits:
        date_str = commit.timestamp.strftime('%Y-%m-%d')
        commits_by_date[date_str].append(commit)

    # Initialize markdown table header
    table = "## 📈 Recent Activity (Last 7 Days)\n\n"
    header_cols = " | ".join(TABLE_COLUMNS)
    table += f"| Date | {header_cols} | Total |\n"

    # Build separator row
    sep_cols = "|".join(["------" for _ in TABLE_COLUMNS])
    table += f"|------|{sep_cols}|-------|\n"

    # Initialize weekly totals
    weekly_totals = {col: 0.0 for col in TABLE_COLUMNS}
    weekly_grand_total = 0.0

    # Process each day in reverse chronological order
    for date in dates:
        day_commits = commits_by_date.get(date, [])
        date_obj = datetime.strptime(date, '%Y-%m-%d')

        # Calculate daily hours per category
        daily = (
            calculate_daily_hour(day_commits, date_obj)
            if day_commits
            else {}
        )
        daily_total = 0.0

        # Build column values for each category
        col_values = []
        for col in TABLE_COLUMNS:
            raw_hours = daily.get(col, 0.0)
            rounded = round(raw_hours, 1)
            weekly_totals[col] += rounded
            daily_total += rounded

            # Format cell with activity emoji
            emoji = get_activity_emoji(rounded)
            if rounded > 0:
                col_values.append(f"{emoji} {rounded}h")
            else:
                col_values.append("")

        # Accumulate grand total
        daily_total = round(daily_total, 1)
        weekly_grand_total += daily_total

        # Format date display string
        formatted_date = date_obj.strftime('%a, %b %d')
        total_str = (
            f"**{daily_total:.1f}h**" if daily_total > 0 else ""
        )

        # Build table row
        col_str = " | ".join(col_values)
        table += (
            f"| {formatted_date} | {col_str} | "
            f"{total_str} |\n"
        )

    # Add weekly totals row
    weekly_cols = " | ".join(
        f"**{weekly_totals[col]:.1f}h**"
        for col in TABLE_COLUMNS
    )
    table += (
        f"| **Weekly Total** | {weekly_cols} | "
        f"**{weekly_grand_total:.1f}h** |\n"
    )

    # Calculate and add running totals row
    running = calculate_running_total()
    running_cols = []
    running_grand = 0.0
    for col in TABLE_COLUMNS:
        val = running.get(col, 0.0)
        running_grand += val
        running_cols.append(f"***{val:.1f}h***")
    running_str = " | ".join(running_cols)
    table += (
        f"| ***Running Total*** | {running_str} | "
        f"***{running_grand:.1f}h*** |\n"
    )

    # Add legend and metadata
    table += (
        "\n*Activity Levels: "
        "🟡 Low (< 1hr) | 🟢 Medium (1-2hrs) | "
        "🟣 High (> 2hrs)*\n"
    )
    table += (
        "\n*Pre-8 AM: time between consecutive commits "
        "credited to first commit's folder*  \n"
        "*Weekends after 8 AM: 0.5h flat per commit*  \n"
        "*Other = Lab workflow and automation design, "
        "content structure and development*  \n"
    )

    # Add timestamp in Central timezone (fallback to local)
    try:
        central_time = datetime.now(ZoneInfo('America/Chicago'))
    except ZoneInfoNotFoundError:
        central_time = datetime.now().astimezone()
    table += (
        f"\n*Last updated: "
        f"{central_time.strftime('%B %d, %Y at %H:%M %Z')}*\n"
    )

    return table


def update_readme(new_table: str) -> bool:
    """Update README.md with new commit statistics table.

    Args:
        new_table: Formatted markdown table string

    Returns:
        True if update succeeded, False otherwise
    """
    # Read current README content
    with open('README.md', 'r', encoding='utf-8') as f:
        content = f.read()

    # Define markers for the commit stats section
    start_marker = "<!-- COMMIT_STATS_START -->"
    end_marker = "<!-- COMMIT_STATS_END -->"

    # Replace existing section or insert new one
    if start_marker in content and end_marker in content:

        # Update existing section between markers
        pattern = (
            f"{re.escape(start_marker)}.*?{re.escape(end_marker)}"
        )
        new_section = (
            f"{start_marker}\n{new_table}\n{end_marker}"
        )
        new_content = re.sub(
            pattern, new_section, content, flags=re.DOTALL
        )
    else:

        # Insert after badges section
        insert_after = "</div>\n\n---\n\n## 🎯 About"
        if insert_after in content:
            new_section = (
                f"\n\n{start_marker}\n{new_table}\n{end_marker}"
            )
            new_content = content.replace(
                insert_after,
                insert_after + new_section,
            )
        else:
            print(
                "Warning: Could not find insertion point "
                "in README.md"
            )
            return False

    # Write updated content back to file
    with open('README.md', 'w', encoding='utf-8') as f:
        f.write(new_content)

    print("✅ README.md updated successfully")
    return True
#endregion


# -------------------------------------------------------------------------
# Script Entry Point
# -------------------------------------------------------------------------

#region SCRIPT ENTRY POINT
if __name__ == "__main__":
    sys.exit(main())
#endregion
