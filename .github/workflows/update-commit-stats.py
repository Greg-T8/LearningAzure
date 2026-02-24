# -------------------------------------------------------------------------
# Program: update-commit-stats.py
# Description: Update commit statistics in README.md tracking activity per
#              certification (AI-102, AZ-104) for the last 7 days.
#              Hours are calculated as commit-to-commit deltas where the
#              earlier commit determines the category.
# Author: Greg Tate
# -------------------------------------------------------------------------

import re
import subprocess
from collections import defaultdict
from datetime import datetime, timedelta
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError


CERTIFICATIONS = {
    'AI-102': '2026-02-09',
    'AZ-104': '2026-01-14'
}

WORKDAY_START_HOUR = 8


def main() -> None:
    """Main function that orchestrates commit statistics update.

    Retrieves recent commits, generates activity table, and updates README.md.
    """
    print("📊 Generating commit statistics...")

    # Retrieve commits from the last 7 days
    commits = get_commit_records(days=7)

    # Calculate daily category hours from commit-to-commit deltas
    daily_hours = calculate_daily_category_hours(commits)

    # Generate markdown table from commit data
    table = generate_commit_table(daily_hours, days=7)

    print("\nGenerated table:")
    print(table)

    # Update README with new statistics
    success = update_readme(table)

    if success:
        print("\n✅ Commit statistics updated successfully!")
    else:
        print("\n❌ Failed to update README.md")
        exit(1)


# Helper Functions
# -------------------------------------------------------------------------

def get_commit_records(
    days: int = 7,
    since_date: str | None = None
) -> list[dict]:
    """Get commit records with timestamp and certification categories.

    Args:
        days: Number of days to look back (default: 7)
        since_date: Specific date to start from (overrides days parameter)

    Returns:
        List of commit records sorted oldest-to-newest
    """
    if since_date is None:
        since_date = (
            datetime.now() - timedelta(days=days)
        ).strftime('%Y-%m-%d')

    # Build git command to retrieve commits with timestamps and paths
    cmd = [
        'git',
        'log',
        f'--since={since_date}',
        '--name-only',
        '--pretty=format:__COMMIT__|%H|%ad|%s',
        '--date=format:%Y-%m-%d %H:%M:%S'
    ]

    # Execute git log command
    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        print(f"Error running git log: {result.stderr}")
        return []

    # Parse commits and capture file path categories per commit
    commits = []
    lines = result.stdout.splitlines()
    current_commit = None

    for line in lines:
        # Start a new commit record when marker is encountered
        if line.startswith('__COMMIT__|'):
            if current_commit is not None:
                commits.append(current_commit)

            parts = line.split('|', 3)
            if len(parts) < 4:
                current_commit = None
                continue

            commit_message = parts[3]

            # Skip automated workflow commits
            if (
                '[skip ci]' in commit_message
                or 'Update commit statistics' in commit_message
            ):
                current_commit = None
                continue

            commit_time = datetime.strptime(
                parts[2],
                '%Y-%m-%d %H:%M:%S'
            )
            current_commit = {
                'timestamp': commit_time,
                'certifications': set()
            }
            continue

        # Categorize file paths by certification
        if current_commit is not None and line.strip():
            if line.startswith('AI-102/'):
                current_commit['certifications'].add('AI-102')
            elif line.startswith('AZ-104/'):
                current_commit['certifications'].add('AZ-104')

    if current_commit is not None:
        commits.append(current_commit)

    # Return commits sorted oldest-to-newest for delta calculations
    commits.sort(key=lambda commit: commit['timestamp'])
    return commits


def get_category_weights(
    certifications: set[str]
) -> dict[str, float]:
    """Map a commit's categories to allocation weights.

    Args:
        certifications: Certifications touched by the earlier commit

    Returns:
        Allocation weights for AI-102, AZ-104, or Other
    """
    exam_categories = [
        cert
        for cert in CERTIFICATIONS
        if cert in certifications
    ]

    if not exam_categories:
        return {'Other': 1.0}

    split_weight = 1.0 / len(exam_categories)
    return {
        cert: split_weight
        for cert in exam_categories
    }


def get_overlap_hours(
    segment_start: datetime,
    segment_end: datetime,
    window_start: datetime,
    window_end: datetime
) -> float:
    """Get overlap hours between a segment and an allowed window."""
    overlap_start = max(segment_start, window_start)
    overlap_end = min(segment_end, window_end)

    if overlap_end <= overlap_start:
        return 0.0

    return (overlap_end - overlap_start).total_seconds() / 3600


def get_weekend_dense_hour_windows(
    commits: list[dict]
) -> dict[str, list[tuple[datetime, datetime]]]:
    """Build qualified weekend post-8AM hour windows.

    A weekend hour bucket qualifies only when it has more than one commit.

    Args:
        commits: Commit records used to count hour density

    Returns:
        Dict keyed by YYYY-MM-DD with list of qualified hour windows
    """
    dense_hour_counts = defaultdict(int)

    # Count commits in weekend post-8AM hour buckets
    for commit in commits:
        commit_time = commit['timestamp']

        if (
            commit_time.weekday() >= 5
            and commit_time.hour >= WORKDAY_START_HOUR
        ):
            hour_bucket = commit_time.replace(
                minute=0,
                second=0,
                microsecond=0
            )
            dense_hour_counts[hour_bucket] += 1

    # Build windows only for hour buckets with more than one commit
    windows_by_date = defaultdict(list)
    for hour_bucket, commit_count in dense_hour_counts.items():
        if commit_count > 1:
            date_key = hour_bucket.strftime('%Y-%m-%d')
            windows_by_date[date_key].append(
                (hour_bucket, hour_bucket + timedelta(hours=1))
            )

    # Sort windows for deterministic processing
    for date_key in windows_by_date:
        windows_by_date[date_key].sort(key=lambda window: window[0])

    return dict(windows_by_date)


def get_allowed_hours_by_day(
    start_time: datetime,
    end_time: datetime,
    weekend_windows: dict[str, list[tuple[datetime, datetime]]]
) -> dict[str, float]:
    """Calculate allowed hours by day for a commit-to-commit segment.

    Weekday rule: only hours before 8:00 AM count.
    Weekend rule: before 8:00 AM counts, plus dense post-8AM hour windows.

    Args:
        start_time: Start of segment (earlier commit)
        end_time: End of segment (later commit)
        weekend_windows: Qualified weekend post-8AM windows by date

    Returns:
        Dict of YYYY-MM-DD to allowed hours for the segment
    """
    if end_time <= start_time:
        return {}

    hours_by_day = defaultdict(float)
    cursor = start_time

    while cursor < end_time:
        day_start = cursor.replace(
            hour=0,
            minute=0,
            second=0,
            microsecond=0
        )
        next_day = day_start + timedelta(days=1)
        segment_end = min(end_time, next_day)
        date_key = day_start.strftime('%Y-%m-%d')

        # Always allow pre-8AM hours
        pre8_end = day_start.replace(
            hour=WORKDAY_START_HOUR,
            minute=0,
            second=0,
            microsecond=0
        )
        hours_by_day[date_key] += get_overlap_hours(
            cursor,
            segment_end,
            day_start,
            pre8_end
        )

        # On weekends, also allow dense post-8AM hour windows
        if day_start.weekday() >= 5:
            for window_start, window_end in weekend_windows.get(
                date_key,
                []
            ):
                hours_by_day[date_key] += get_overlap_hours(
                    cursor,
                    segment_end,
                    window_start,
                    window_end
                )

        cursor = segment_end

    return {
        date_key: hours
        for date_key, hours in hours_by_day.items()
        if hours > 0
    }


def calculate_daily_category_hours(
    commits: list[dict]
) -> dict[str, dict[str, float]]:
    """Calculate daily hours by category from commit-to-commit deltas.

    Each delta is assigned to the earlier commit's category.

    Args:
        commits: Commit records sorted oldest-to-newest

    Returns:
        Dict of date to category hour totals including Total
    """
    daily_hours = defaultdict(
        lambda: {
            'AI-102': 0.0,
            'AZ-104': 0.0,
            'Other': 0.0,
            'Total': 0.0
        }
    )

    if len(commits) < 2:
        return {}

    weekend_windows = get_weekend_dense_hour_windows(commits)

    # Allocate each commit-to-commit segment to the earlier commit category
    for index in range(len(commits) - 1):
        earlier_commit = commits[index]
        later_commit = commits[index + 1]

        segment_hours_by_day = get_allowed_hours_by_day(
            earlier_commit['timestamp'],
            later_commit['timestamp'],
            weekend_windows
        )

        if not segment_hours_by_day:
            continue

        category_weights = get_category_weights(
            earlier_commit['certifications']
        )

        for date_key, segment_hours in segment_hours_by_day.items():
            daily_hours[date_key]['Total'] += segment_hours

            for category, weight in category_weights.items():
                daily_hours[date_key][category] += segment_hours * weight

    return dict(daily_hours)


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


def calculate_running_totals() -> dict[str, float]:
    """Calculate running totals since each certification's start date.

    Returns:
        Dict mapping certification names to running total hours
    """
    running_totals = {}

    # Calculate cumulative hours for each certification
    for cert, start_date in CERTIFICATIONS.items():
        commits = get_commit_records(since_date=start_date)
        daily_hours = calculate_daily_category_hours(commits)

        # Sum certification hours across all days
        total_hours = 0.0
        for day_hours in daily_hours.values():
            total_hours += day_hours.get(cert, 0.0)

        running_totals[cert] = round(total_hours, 1)

    # Calculate cumulative other hours from earliest certification start date
    earliest_start_date = min(CERTIFICATIONS.values())
    commits = get_commit_records(since_date=earliest_start_date)
    daily_hours = calculate_daily_category_hours(commits)
    running_other_total = 0.0

    # Sum other hours across all days
    for day_hours in daily_hours.values():
        running_other_total += day_hours.get('Other', 0.0)

    running_totals['Other'] = round(running_other_total, 1)

    return running_totals


def generate_commit_table(
    daily_hours: dict[str, dict[str, float]],
    days: int = 7
) -> str:
    """Generate markdown table for commit statistics.

    Args:
        daily_hours: Daily category hours produced from commit deltas
        days: Number of days to include in table (default: 7)

    Returns:
        Formatted markdown table as string
    """
    # Build list of dates in reverse chronological order
    dates = []
    for i in range(0, days):
        date = (
            datetime.now() - timedelta(days=i)
        ).strftime('%Y-%m-%d')
        dates.append(date)

    # Initialize markdown table
    table = "## 📈 Recent Activity (Last 7 Days)\n\n"
    table += "| Date | AI-102 | AZ-104 | Other | Total |\n"
    table += "|------|--------|--------|-------|-------|\n"

    # Initialize weekly totals
    total_ai102 = 0.0
    total_az104 = 0.0
    total_other = 0.0
    total_all = 0.0

    # Process each day
    for date in dates:
        day_hours = daily_hours.get(date, {})
        ai102_raw_hours = day_hours.get('AI-102', 0.0)
        az104_raw_hours = day_hours.get('AZ-104', 0.0)
        other_raw_hours = day_hours.get('Other', 0.0)
        total_raw_hours = day_hours.get('Total', 0.0)

        ai102_hours = round(ai102_raw_hours, 1)
        az104_hours = round(az104_raw_hours, 1)
        other_hours = round(other_raw_hours, 1)
        daily_total = round(total_raw_hours, 1)

        # Accumulate weekly totals
        total_ai102 += ai102_hours
        total_az104 += az104_hours
        total_other += other_hours
        total_all += daily_total

        # Format date string
        date_obj = datetime.strptime(date, '%Y-%m-%d')
        formatted_date = date_obj.strftime('%a, %b %d')

        # Build hour strings with color-coded emoji
        ai102_emoji = get_activity_emoji(ai102_hours)
        az104_emoji = get_activity_emoji(az104_hours)
        other_emoji = get_activity_emoji(other_hours)

        ai102_str = (
            f"{ai102_emoji} {ai102_hours}h" if ai102_hours > 0 else ""
        )
        az104_str = (
            f"{az104_emoji} {az104_hours}h" if az104_hours > 0 else ""
        )
        other_str = (
            f"{other_emoji} {other_hours}h" if other_hours > 0 else ""
        )
        total_str = (
            f"**{daily_total:.1f}h**" if daily_total > 0 else ""
        )

        table += (
            f"| {formatted_date} | {ai102_str} | {az104_str} | "
            f"{other_str} | "
            f"{total_str} |\n"
        )

    # Add weekly totals row
    table += (
        f"| **Weekly Total** | **{total_ai102:.1f}h** | "
        f"**{total_az104:.1f}h** | "
        f"**{total_other:.1f}h** | "
        f"**{total_all:.1f}h** |\n"
    )

    # Calculate and add running totals row
    running_totals = calculate_running_totals()
    running_ai102 = running_totals.get('AI-102', 0.0)
    running_az104 = running_totals.get('AZ-104', 0.0)
    running_other = running_totals.get('Other', 0.0)
    running_grand_total = running_ai102 + running_az104 + running_other
    table += (
        f"| ***Running Total*** | ***{running_ai102:.1f}h*** | "
        f"***{running_az104:.1f}h*** | "
        f"***{running_other:.1f}h*** | "
        f"***{running_grand_total:.1f}h*** |\n"
    )

    # Add legend and metadata
    table += (
        "\n*Activity Levels: 🟡 Low (< 1hr) | 🟢 Medium (1-2hrs) | "
        "🟣 High (> 2hrs)*\n"
    )
    table += (
        "\n*Total = sum of commit-to-commit deltas where the earlier commit determines category*  \n"
        "*Time rules = pre-8:00 AM hours plus qualifying weekend post-8:00 AM hourly blocks*  \n"
        "*Other = Lab workflow and automation design, content structure and development*  \n"
    )

    # Add timestamp in Central timezone (fallback to local timezone if missing)
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
    with open('README.md', 'r', encoding='utf-8') as f:
        content = f.read()

    # Define markers for the commit stats section
    start_marker = "<!-- COMMIT_STATS_START -->"
    end_marker = "<!-- COMMIT_STATS_END -->"

    # Replace existing section or insert new one
    if start_marker in content and end_marker in content:
        # Update existing section between markers
        pattern = f"{re.escape(start_marker)}.*?{re.escape(end_marker)}"
        new_section = f"{start_marker}\n{new_table}\n{end_marker}"
        new_content = re.sub(pattern, new_section, content, flags=re.DOTALL)
    else:
        # Insert after badges section
        insert_after = "</div>\n\n---\n\n## 🎯 About"
        if insert_after in content:
            new_section = f"\n\n{start_marker}\n{new_table}\n{end_marker}"
            new_content = content.replace(
                insert_after,
                insert_after + new_section
            )
        else:
            print("Warning: Could not find insertion point in README.md")
            return False

    # Write updated content back to file
    with open('README.md', 'w', encoding='utf-8') as f:
        f.write(new_content)

    print("✅ README.md updated successfully")
    return True


# -------------------------------------------------------------------------
# Script Entry Point
# -------------------------------------------------------------------------

if __name__ == "__main__":
    main()
