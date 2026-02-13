# -------------------------------------------------------------------------
# Program: update-commit-stats.py
# Description: Update commit statistics in README.md tracking activity per
#              certification (AI-102, AZ-104, AI-900) for the last 7 days.
#              Hours calculated as time between first and last commit per day.
#              Overlapping activity windows are split evenly.
# Author: Greg Tate
# -------------------------------------------------------------------------

import re
import subprocess
from collections import defaultdict
from datetime import datetime, timedelta
from zoneinfo import ZoneInfo


CERTIFICATIONS = ('AI-102', 'AZ-104', 'AI-900')


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

    for line in lines:
        # Parse commit metadata when line contains pipe separator
        if '|' in line:
            parts = line.split('|')
            if len(parts) >= 2:
                current_datetime = parts[1]
                current_date = current_datetime.split()[0]
        # Categorize file paths by certification
        elif line.strip() and current_datetime:
            if line.startswith('AI-900/'):
                commits_by_date_cert[current_date]['AI-900'].append(
                    current_datetime
                )
            elif line.startswith('AI-102/'):
                commits_by_date_cert[current_date]['AI-102'].append(
                    current_datetime
                )
            elif line.startswith('AZ-104/'):
                commits_by_date_cert[current_date]['AZ-104'].append(
                    current_datetime
                )
            elif line.startswith('.github/') or line == 'README.md':
                commits_by_date_cert[current_date]['Repo'].append(
                    current_datetime
                )

    return commits_by_date_cert


def get_activity_interval(
    timestamps: list[str]
) -> tuple[datetime, datetime] | None:
    """Get activity interval (earliest, latest) for a set of timestamps.

    For weekdays (Mon-Fri), caps the end time at 8:00 AM local date.
    Returns None if interval cannot produce positive duration.

    Args:
        timestamps: List of timestamp strings in format '%Y-%m-%d %H:%M:%S'

    Returns:
        Tuple of (earliest_datetime, latest_datetime) or None
    """
    if not timestamps:
        return None

    if len(timestamps) == 1:
        return None

    # Parse timestamps into datetime objects
    dt_objects = [
        datetime.strptime(ts, '%Y-%m-%d %H:%M:%S')
        for ts in timestamps
    ]

    # Determine earliest and latest commit times
    earliest = min(dt_objects)
    latest = max(dt_objects)

    # Cap weekday end time at 8:00 AM
    if earliest.weekday() < 5:
        work_start = earliest.replace(hour=8, minute=0, second=0)
        if latest > work_start:
            latest = work_start

    if latest <= earliest:
        return None

    return earliest, latest


def calculate_hours(timestamps: list[str]) -> float:
    """Calculate hours between first and last commit after weekday cap.

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
    # Map certification to start date
    start_dates = {
        'AI-900': '2026-01-14',
        'AZ-104': '2026-01-14',
        'AI-102': '2026-02-09'
    }

    running_totals = {}

    # Calculate cumulative hours for each certification
    for cert, start_date in start_dates.items():
        commits = get_commits_by_path(since_date=start_date)

        # Sum hours across all days
        total_hours = 0.0
        for date_commits in commits.values():
            day_hours = split_overlapping_hours(date_commits)
            total_hours += day_hours.get(cert, 0.0)

        running_totals[cert] = round(total_hours, 1)

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
    table += "| Date | AI-102 | AZ-104 | AI-900 | Total |\n"
    table += "|------|--------|--------|--------|-------|\n"

    # Initialize weekly totals
    total_ai102 = 0.0
    total_az104 = 0.0
    total_ai900 = 0.0

    # Process each day
    for date in dates:
        date_commits = commits_by_date_cert.get(date, {})
        split_hours = split_overlapping_hours(date_commits)

        # Extract hours for each certification
        ai102_hours = round(split_hours.get('AI-102', 0.0), 1)
        az104_hours = round(split_hours.get('AZ-104', 0.0), 1)
        ai900_hours = round(split_hours.get('AI-900', 0.0), 1)
        daily_total = ai102_hours + az104_hours + ai900_hours

        # Accumulate weekly totals
        total_ai102 += ai102_hours
        total_az104 += az104_hours
        total_ai900 += ai900_hours

        # Format date string
        date_obj = datetime.strptime(date, '%Y-%m-%d')
        formatted_date = date_obj.strftime('%a, %b %d')

        # Build hour strings with color-coded emoji
        ai102_emoji = get_activity_emoji(ai102_hours)
        az104_emoji = get_activity_emoji(az104_hours)
        ai900_emoji = get_activity_emoji(ai900_hours)

        ai102_str = (
            f"{ai102_emoji} {ai102_hours}h" if ai102_hours > 0 else ""
        )
        az104_str = (
            f"{az104_emoji} {az104_hours}h" if az104_hours > 0 else ""
        )
        ai900_str = (
            f"{ai900_emoji} {ai900_hours}h" if ai900_hours > 0 else ""
        )
        total_str = (
            f"**{daily_total:.1f}h**" if daily_total > 0 else ""
        )

        table += (
            f"| {formatted_date} | {ai102_str} | {az104_str} | "
            f"{ai900_str} | {total_str} |\n"
        )

    # Add weekly totals row
    weekly_total = total_ai102 + total_az104 + total_ai900
    table += (
        f"| **Weekly Total** | **{total_ai102:.1f}h** | "
        f"**{total_az104:.1f}h** | **{total_ai900:.1f}h** | "
        f"**{weekly_total:.1f}h** |\n"
    )

    # Calculate and add running totals row
    running_totals = calculate_running_totals()
    running_ai102 = running_totals.get('AI-102', 0.0)
    running_az104 = running_totals.get('AZ-104', 0.0)
    running_ai900 = running_totals.get('AI-900', 0.0)
    running_grand_total = running_ai102 + running_az104 + running_ai900
    table += (
        f"| ***Running Total*** | ***{running_ai102:.1f}h*** | "
        f"***{running_az104:.1f}h*** | ***{running_ai900:.1f}h*** | "
        f"***{running_grand_total:.1f}h*** |\n"
    )

    # Add legend and metadata
    table += (
        "\n*Activity Levels: 🟡 Low (< 1hr) | 🟢 Medium (1-2hrs) | "
        "🟣 High (> 2hrs)*\n"
    )
    table += (
        "\n*Hours = time between first and last commit of the day "
        "in that certification folder*\n"
    )

    # Add timestamp in Central timezone
    central_time = datetime.now(ZoneInfo('America/Chicago'))
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
