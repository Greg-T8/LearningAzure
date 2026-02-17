# -------------------------------------------------------------------------
# Program: update-commit-stats.py
# Description: Update commit statistics in README.md tracking activity per
#              certification (AI-102, AZ-104) for the last 7 days.
#              Hours calculated as time between first and last commit per day.
#              Overlapping activity windows are split evenly.
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


def main() -> None:
    """Main function that orchestrates commit statistics update.

    Retrieves recent commits, generates activity table, and updates README.md.
    """
    print("📊 Generating commit statistics...")

    # Retrieve commits from the last 7 days
    commits = get_commits_by_path(days=7)

    # Generate markdown table from commit data
    table = generate_commit_table(commits, days=7)

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

def get_commits_by_path(
    days: int = 7,
    since_date: str | None = None
) -> dict:
    """Get commit timestamps by path for the last N days or since date.

    Args:
        days: Number of days to look back (default: 7)
        since_date: Specific date to start from (overrides days parameter)

    Returns:
        dict: Commits grouped by date and certification
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
        '--pretty=format:%H|%ad|%s',
        '--date=format:%Y-%m-%d %H:%M:%S'
    ]

    # Execute git log command
    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        print(f"Error running git log: {result.stderr}")
        return {}

    # Parse commits and organize by date and certification
    commits_by_date_cert = defaultdict(lambda: defaultdict(list))

    lines = result.stdout.strip().split('\n')
    current_datetime = None
    current_date = None
    current_message = None

    for line in lines:
        # Parse commit metadata when line contains pipe separator
        if '|' in line:
            parts = line.split('|')
            if len(parts) >= 3:
                current_datetime = parts[1]
                current_date = current_datetime.split()[0]
                current_message = parts[2]

                # Skip automated workflow commits
                if '[skip ci]' in current_message or 'Update commit statistics' in current_message:
                    current_datetime = None
                    continue

                # Track all commits for total daily activity window
                commits_by_date_cert[current_date]['__all__'].append(
                    current_datetime
                )
        # Categorize file paths by certification
        elif line.strip() and current_datetime:
            if line.startswith('AI-102/'):
                commits_by_date_cert[current_date]['AI-102'].append(
                    current_datetime
                )
            elif line.startswith('AZ-104/'):
                commits_by_date_cert[current_date]['AZ-104'].append(
                    current_datetime
                )

    return commits_by_date_cert


def get_activity_interval(
    timestamps: list[str]
) -> tuple[datetime, datetime] | None:
    """Get activity interval (earliest, latest) for a set of timestamps.

    Caps the end time at 8:00 AM local date for all days.
    Returns None if interval cannot produce positive duration.
    For single commits, assumes 1-hour activity window.

    Args:
        timestamps: List of timestamp strings in format '%Y-%m-%d %H:%M:%S'

    Returns:
        Tuple of (earliest_datetime, latest_datetime) or None
    """
    if not timestamps:
        return None

    # Parse timestamps into datetime objects
    dt_objects = [
        datetime.strptime(ts, '%Y-%m-%d %H:%M:%S')
        for ts in timestamps
    ]

    # For single commit, assume 1-hour activity window
    if len(timestamps) == 1:
        earliest = dt_objects[0]
        latest = earliest + timedelta(hours=1)

        # Cap end time at 8:00 AM
        morning_cap = earliest.replace(hour=8, minute=0, second=0)
        if latest > morning_cap:
            latest = morning_cap

        if latest <= earliest:
            return None

        return earliest, latest

    # Determine earliest and latest commit times
    earliest = min(dt_objects)
    latest = max(dt_objects)

    # Cap end time at 8:00 AM only if commits extend beyond it
    morning_cap = earliest.replace(hour=8, minute=0, second=0)
    if latest > morning_cap:
        latest = morning_cap

    if latest <= earliest:
        return None

    return earliest, latest


def calculate_hours(timestamps: list[str]) -> float:
    """Calculate hours between first and last commit after 8:00 AM cap.

    Args:
        timestamps: List of timestamp strings

    Returns:
        Hours of activity rounded to 1 decimal place
    """
    interval = get_activity_interval(timestamps)

    if interval is None:
        return 0.0

    earliest, latest = interval
    time_diff = latest - earliest
    hours = time_diff.total_seconds() / 3600

    return round(hours, 1)


def calculate_hours_raw(timestamps: list[str]) -> float:
    """Calculate unrounded hours between first and last commit.

    Args:
        timestamps: List of timestamp strings

    Returns:
        Hours of activity as a float
    """
    interval = get_activity_interval(timestamps)

    if interval is None:
        return 0.0

    earliest, latest = interval
    time_diff = latest - earliest

    return time_diff.total_seconds() / 3600


def split_overlapping_hours(
    date_commits: dict
) -> dict[str, float]:
    """Split overlapping activity windows evenly across certifications.

    For each certification, build a daily activity interval from first to last
    commit (with weekday cap applied). When intervals overlap, overlapping
    segments are divided equally among active certifications.

    Args:
        date_commits: Dict mapping certification names to timestamp lists

    Returns:
        Dict mapping certification names to allocated hours
    """
    # Build activity intervals for each certification
    intervals_by_cert = {}

    for cert in CERTIFICATIONS:
        timestamps = date_commits.get(cert, [])
        interval = get_activity_interval(timestamps)
        if interval is not None:
            intervals_by_cert[cert] = interval

    if not intervals_by_cert:
        return {cert: 0.0 for cert in CERTIFICATIONS}

    # Create events for interval start and end points
    events = []
    for cert, (start, end) in intervals_by_cert.items():
        events.append((start, 'start', cert))
        events.append((end, 'end', cert))

    # Sort events chronologically
    events.sort(
        key=lambda event: (event[0], 0 if event[1] == 'end' else 1)
    )

    # Process events and allocate hours
    allocated_hours = {cert: 0.0 for cert in CERTIFICATIONS}
    active_certs = set()
    previous_time = None

    for current_time, event_type, cert in events:
        # Allocate segment hours evenly across active certifications
        if (
            previous_time is not None
            and current_time > previous_time
            and active_certs
        ):
            segment_hours = (
                (current_time - previous_time).total_seconds() / 3600
            )
            split_hours = segment_hours / len(active_certs)
            for active_cert in active_certs:
                allocated_hours[active_cert] += split_hours

        if event_type == 'start':
            active_certs.add(cert)
        else:
            active_certs.discard(cert)

        previous_time = current_time

    return allocated_hours


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
        commits = get_commits_by_path(since_date=start_date)

        # Sum hours across all days
        total_hours = 0.0
        for date_commits in commits.values():
            day_hours = split_overlapping_hours(date_commits)
            total_hours += day_hours.get(cert, 0.0)

        running_totals[cert] = round(total_hours, 1)

    # Calculate cumulative other hours from earliest certification start date
    earliest_start_date = min(CERTIFICATIONS.values())
    commits = get_commits_by_path(since_date=earliest_start_date)
    running_other_total = 0.0

    # Sum other hours across all days
    for date_commits in commits.values():
        # Calculate exam commit window (combined AI-102 + AZ-104)
        exam_commits = []
        exam_commits.extend(date_commits.get('AI-102', []))
        exam_commits.extend(date_commits.get('AZ-104', []))
        exam_window_hours = calculate_hours_raw(exam_commits)

        # Calculate all commits window
        all_window_hours = calculate_hours_raw(date_commits.get('__all__', []))

        # Other = time beyond exam window
        other_hours = max(0.0, all_window_hours - exam_window_hours)
        running_other_total += other_hours

    running_totals['Other'] = round(running_other_total, 1)

    return running_totals


def generate_commit_table(
    commits_by_date_cert: dict,
    days: int = 7
) -> str:
    """Generate markdown table for commit statistics.

    Args:
        commits_by_date_cert: Commit data grouped by date and certification
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
        date_commits = commits_by_date_cert.get(date, {})
        split_hours = split_overlapping_hours(date_commits)

        # Calculate exam commit window (combined AI-102 + AZ-104)
        exam_commits = []
        exam_commits.extend(date_commits.get('AI-102', []))
        exam_commits.extend(date_commits.get('AZ-104', []))
        exam_window_hours = calculate_hours_raw(exam_commits)

        # Extract hours for each certification from the split
        ai102_raw_hours = split_hours.get('AI-102', 0.0)
        az104_raw_hours = split_hours.get('AZ-104', 0.0)

        # Calculate all commits window
        all_window_hours = calculate_hours_raw(date_commits.get('__all__', []))

        # Other = time beyond exam window (if non-exam commits extend it)
        other_raw_hours = max(0.0, all_window_hours - exam_window_hours)

        # Total is the larger of exam window or all window
        total_raw_hours = max(exam_window_hours, all_window_hours)

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
        "\n*Total = first to last commit of day (mornings to 8:00 AM)*  \n"
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
