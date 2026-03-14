---
name: exam-question-organizer
description: 'Reorganize practice exam questions by domain, skill, and task metadata for any certification exam, then update the coverage table on the exam README. Use when asked to organize practice exams, classify exam questions by domain, or update practice exam coverage.'
user-invokable: true
argument-hint: '[exam]'
---

# Practice Exam Organizer

Reorganize a practice exam `README.md` to group questions under their correct exam domain and skill headings, with task-level metadata on each question. After reorganizing, update the coverage table on the exam's main README.

## When to Use

- Organizing or reorganizing practice exam questions by domain structure
- Classifying exam questions into domain → skill → task hierarchy
- Updating the Practice Exam Coverage table after questions are added or removed

## Prerequisites

Every question block **must** already have `**Domain:**`, `**Skill:**`, and `**Task:**` metadata lines immediately after its `####` heading. These metadata lines are the single source of truth for classification — the script does not infer classification from question content.

If questions are missing metadata, add the metadata manually before running the organizer. Use the exam README's coverage table to find the correct domain, skill, and task values.

## Target Files

| Exam   | Practice Exam File                     | Domain Reference                                    | Coverage Table                                      |
| ------ | -------------------------------------- | --------------------------------------------------- | --------------------------------------------------- |
| AZ-104 | `certs/AZ-104/practice-questions/README.md`  | `certs/AZ-104/README.md` — Practice Exam Coverage section | `certs/AZ-104/README.md` — Practice Exam Coverage section |
| AI-102 | `certs/AI-102/practice-questions/README.md`  | `certs/AI-102/README.md` — Practice Exam Coverage section | `certs/AI-102/README.md` — Practice Exam Coverage section |

If no exam is specified, ask which exam to process.

## Script

The reorganizer is implemented as a deterministic PowerShell script:

```
.assets/scripts/Invoke-PracticeExamReorganizer.ps1
```

### Usage

```powershell
# Preview changes without modifying files
.assets/scripts/Invoke-PracticeExamReorganizer.ps1 -ExamName AZ-104 -WhatIf -Verbose

# Execute reorganization
.assets/scripts/Invoke-PracticeExamReorganizer.ps1 -ExamName AZ-104 -Verbose
```

### What the Script Does

1. **Loads domain structure** — Parses the exam README's coverage table (`<!-- BEGIN COVERAGE TABLE -->` to `<!-- END COVERAGE TABLE -->`) to extract the canonical domain → skill → task ordering.
2. **Parses question blocks** — Extracts every `####` question block with its `**Domain:**`, `**Skill:**`, and `**Task:**` metadata. Preserves full body content exactly (question text, answer options, `<details>` blocks, `▶ Related Lab:` links).
3. **Sorts by canonical order** — Orders questions by domain index, then skill index (from the exam README), preserving relative order within each skill.
4. **Regenerates file** — Writes the reorganized file with proper `#`/`##`/`###`/`####` heading hierarchy, nested TOC with anchor links (including GitHub-style `-1`, `-2` dedup for duplicates), and `---` separators between questions.
5. **Updates coverage table** — Counts questions per task from metadata and updates the Qs column in the exam README's coverage table.
6. **Verifies** — Confirms question count matches, all metadata is present, and reports any gaps or unrecognized domain/skill values.

### Warnings

The script emits warnings for:

- **Unrecognized domain/skill** — When a question's `**Skill:**` value does not match any skill in the exam README's coverage table. These questions sort to the end of their domain group. Fix the metadata to match the exact wording from the exam README.
- **Metadata gaps** — When questions are missing `**Domain:**`, `**Skill:**`, or `**Task:**` lines. Add the missing metadata before re-running.
- **Count mismatch** — When the number of questions written differs from the number parsed. This indicates a parsing bug.

## Output Structure

### Heading Hierarchy

| Element    | Heading | Notes                                                    |
| ---------- | ------- | -------------------------------------------------------- |
| Page title | `#`     | `# Practice Exam Questions - <EXAM>` (single H1)        |
| Domain     | `##`    | Matches the domain name from the question metadata       |
| Skill      | `###`   | Matches the skill name from the question metadata        |
| Question   | `####`  | Existing question title — preserved exactly              |

### Question Metadata Format

Immediately after each `####` question heading (separated by a blank line):

**Single task:**

```markdown
**Domain:** <domain name>
**Skill:** <skill name>
**Task:** <task description>
```

**Multiple tasks:**

```markdown
**Domain:** <domain name>
**Skill:** <skill name>
**Task:**

- <task description 1>
- <task description 2>
```

Task descriptions **must match the exact wording** from the exam README's coverage table.

### Table of Contents

After the page title, a nested bullet-point TOC with anchor links:

```markdown
* [Domain Name](#domain-anchor)
  * [Skill Name](#skill-anchor)
    * [Question Title](#question-anchor)
```

### Ordering Rules

1. **Domains** appear in exam order (Domain 1 first).
2. **Skills** appear in the order listed in the exam README.
3. **Questions** within a skill preserve their relative order from the source file.
4. **Omit** skills that have no questions assigned to them.

## Workflow

### Step 1 — Run the Script

Execute the reorganizer script for the target exam:

```powershell
.assets/scripts/Invoke-PracticeExamReorganizer.ps1 -ExamName <EXAM> -Verbose
```

### Step 2 — Review Output

Check the script's summary output for:

- Question count verification (parsed vs. written)
- Metadata completeness (all Domain/Skill/Task present)
- Warnings about unrecognized domain/skill values

### Step 3 — Fix Issues (if any)

If warnings were reported:

1. **Unrecognized domain/skill** — Edit the question's metadata to match the exact wording from the exam README's coverage table, then re-run the script.
2. **Missing metadata** — Add `**Domain:**`, `**Skill:**`, and `**Task:**` lines to the question block, then re-run.
3. **Count mismatch** — Investigate the practice questions file for parsing edge cases (missing `---` separators, malformed headings).

## Rules

- **Do not** alter question text, answer options, screenshots, `<details>` blocks, explanation content, or `▶ Related Lab:` links.
- **Do** normalize question heading levels to `####`.
- **Do** ensure every question has `**Domain:**`, `**Skill:**`, and `**Task:**` metadata.
- Metadata is the **single source of truth** for classification — no LLM inference is used.
- The script is **idempotent** — running it multiple times produces the same result.
