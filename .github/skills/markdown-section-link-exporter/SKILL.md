---
name: markdown-section-link-exporter
description: 'Extract and export flat URLs from a named markdown section and its subsections to a text file. Use when asked to extract links from a markdown section, flatten markdown links, export URLs from a section, get all links under a heading, or extract section/subsection link list.'
user-invokable: true
argument-hint: '[markdown file path] [section heading text]'
---

# Markdown Section Link Exporter

Extract all URLs from a specified section (and its subsections) of a markdown file and write them as flat links (one URL per line) to a text file.

## Script

The exporter is implemented as a PowerShell script:

```
.assets/scripts/Export-SectionLink.ps1
```

### Parameters

| Parameter    | Required | Description                                                                                     |
|--------------|----------|-------------------------------------------------------------------------------------------------|
| `-Path`      | Yes      | Full or relative path to the markdown (`.md`) file to parse.                                    |
| `-Section`   | Yes      | The heading text to match (without leading `#` characters). Matches the first occurrence, case-insensitive. |
| `-OutputPath` | No      | Override path for the output `.txt` file. Defaults to `<input-basename>-links.txt` in the same directory as the input file. |

### Usage

```powershell
# Extract all links under "Recommend a logging solution" (and its subsections)
.assets/scripts/Export-SectionLink.ps1 -Path "certs\AZ-305\research-guides\AZ-305 Deep Research Guide for Logging and Monitoring on Azure.md" -Section "Recommend a logging solution"

# Extract with a custom output path
.assets/scripts/Export-SectionLink.ps1 -Path "guide.md" -Section "Core docs you must read" -OutputPath "C:\temp\core-links.txt"

# Use -Verbose to see matched heading and line range
.assets/scripts/Export-SectionLink.ps1 -Path "guide.md" -Section "Recommend a monitoring solution" -Verbose
```

### What the Script Does

1. Validates the input file exists and is a `.md` file.
2. Scans all headings to find the **first** heading whose text matches `-Section` (case-insensitive).
3. Captures all content from that heading through its subsections — stopping at the next heading at the same or higher level (fewer or equal `#` characters), or end of file.
4. Extracts all markdown links (`[text](url)`) from the captured lines.
5. Deduplicates URLs (case-insensitive) and sorts them alphabetically.
6. Writes one URL per line to the output text file (overwrites if it exists).
7. Displays a summary: matched section name, link count, and output file path.

### Behavior Notes

- **Duplicate headings**: If the same heading text appears under multiple parent sections (e.g., multiple "Prioritized reading list" subsections), the script matches the **first occurrence** in the file.
- **Fragment-only anchors** (`#some-anchor`) are excluded from output.
- **Empty sections**: If no links are found, the script warns and does not create an output file.

## Workflow

When the user asks to extract or export links from a markdown section:

### Step 1 — Identify Inputs

Determine the markdown file path and the section heading text from the user's request. If the user provides a file path, use it directly. If not, check the currently open editor file.

### Step 2 — Run the Script

Execute the script in the terminal:

```powershell
.assets/scripts/Export-SectionLink.ps1 -Path "<markdown-file>" -Section "<heading text>" -Verbose
```

### Step 3 — Confirm Output

After the script runs, confirm:

- The matched section and heading level
- The number of unique links extracted
- The output file path

Report these to the user.
