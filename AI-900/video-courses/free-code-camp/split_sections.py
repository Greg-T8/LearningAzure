#!/usr/bin/env python3
import re
import os
from pathlib import Path

source_file = "Azure_AI_Fundamentals_Certification_2024_(AI-900)_-_Full_Course_to_PASS_the_Exam_Exam_Notes.md"
output_dir = Path(".")

# Read the source file
with open(source_file, 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Find all ## headers with their line numbers
header_lines = []
for i, line in enumerate(lines):
    if line.startswith('## '):
        header_text = line[3:].strip()
        header_lines.append((i, header_text))

print(f"Total sections found: {len(header_lines)}")
for idx, (line_num, text) in enumerate(header_lines):
    print(f"{idx}: Line {line_num}: {text}")

# Skip first two (Table of Contents, Contents) and start from ML Introduction
sections = header_lines[2:]
print(f"\nProcessing {len(sections)} sections (starting from section 2)")

# Create files for each section
for file_num, (start_line, header_text) in enumerate(sections, start=1):
    # Determine end line
    if file_num < len(sections):
        end_line = sections[file_num][0]
    else:
        end_line = len(lines)

    # Extract content
    section_lines = lines[start_line:end_line]

    # Create filename: 01-ml-introduction.md, etc.
    # Convert header text to kebab-case
    filename_text = re.sub(r'[^a-z0-9\s]+', '', header_text.lower())
    filename_text = re.sub(r'\s+', '-', filename_text)
    filename = f"{file_num:02d}-{filename_text}.md"

    filepath = output_dir / filename

    # Write the file
    with open(filepath, 'w', encoding='utf-8') as f:
        f.writelines(section_lines)

    print(f"Created: {filename} ({len(section_lines)} lines)")

print("\nSplit complete!")
