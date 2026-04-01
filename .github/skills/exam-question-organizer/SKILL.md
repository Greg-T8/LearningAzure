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

Every question block **must** already have `**Domain:**`, `**Skill:**`, and `**Task:**` metadata lines immediately after its question heading (`####` in single-file mode, `###` in per-domain mode). An optional `**Answer Result:**` line (values: `wrong`, `unsure`, `correct`) may appear after the Task metadata. These metadata lines are the single source of truth for classification — the script does not infer classification from question content.

If questions are missing metadata, add the metadata manually before running the organizer. Use the exam README's coverage table to find the correct domain, skill, and task values. Missing `**Answer Result:**` defaults to `unsure`.

### File Modes

The script auto-detects the file layout per exam:

- **Single-file mode** — All questions live in `practice-questions/README.md`. Used by AZ-104 and legacy exams.
- **Per-domain mode** — Questions are split into numbered `.md` files (e.g., `01-identity-governance-monitoring.md`). `README.md` is an index page. Used by AZ-305 and future exams.

Detection: if `practice-questions/` contains `.md` files beyond `README.md`, the script uses per-domain mode.

## Target Files

**Single-file exams:**

| Exam   | Practice Exam File                     | Domain Reference                                    | Coverage Table                                      |
| ------ | -------------------------------------- | --------------------------------------------------- | --------------------------------------------------- |
| AZ-104 | `certs/AZ-104/practice-questions/README.md`  | `certs/AZ-104/README.md` — Practice Exam Coverage section | `certs/AZ-104/README.md` — Practice Exam Coverage section |
| AI-103 | `certs/AI-103/practice-questions/README.md`  | `certs/AI-103/README.md` — Practice Exam Coverage section | `certs/AI-103/README.md` — Practice Exam Coverage section |

**Per-domain exams:**

| Exam   | Practice Exam Files                    | Domain Reference                                    | Coverage Table                                      |
| ------ | -------------------------------------- | --------------------------------------------------- | --------------------------------------------------- |
| AZ-305 | `certs/AZ-305/practice-questions/01-identity-governance-monitoring.md`<br>`certs/AZ-305/practice-questions/02-data-storage.md`<br>`certs/AZ-305/practice-questions/03-business-continuity.md`<br>`certs/AZ-305/practice-questions/04-infrastructure.md` | `certs/AZ-305/README.md` — Practice Exam Coverage section | `certs/AZ-305/README.md` — Practice Exam Coverage section |

Legacy support (explicit request only):

| Exam   | Practice Exam File                     | Domain Reference                                    | Coverage Table                                      |
| ------ | -------------------------------------- | --------------------------------------------------- | --------------------------------------------------- |
| AI-900 | `certs/AI-900/practice-questions/README.md`  | `certs/AI-900/README.md` — Practice Exam Coverage section | `certs/AI-900/README.md` — Practice Exam Coverage section |

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

**Single-file mode** (AZ-104, AI-103, legacy):

| Element    | Heading | Notes                                                    |
| ---------- | ------- | -------------------------------------------------------- |
| Page title | `#`     | `# Practice Exam Questions - <EXAM>` (single H1)        |
| Domain     | `##`    | Matches the domain name from the question metadata       |
| Skill      | `###`   | Matches the skill name from the question metadata        |
| Question   | `####`  | Existing question title — preserved exactly              |

**Per-domain mode** (AZ-305, future exams):

| Element    | Heading | Notes                                                    |
| ---------- | ------- | -------------------------------------------------------- |
| Page title | `#`     | `# Practice Questions — <Domain Name>` (one file per domain) |
| Skill      | `##`    | Matches the skill name from the question metadata        |
| Question   | `###`   | Existing question title — preserved exactly              |

### Question Metadata Format

Immediately after each question heading (`####` single-file, `###` per-domain), separated by a blank line:

**Single task:**

```markdown
**Domain:** <domain name>
**Skill:** <skill name>
**Task:** <task description>
**Answer Result:** <wrong|unsure|correct>
```

**Multiple tasks:**

```markdown
**Domain:** <domain name>
**Skill:** <skill name>
**Task:**

- <task description 1>
- <task description 2>

**Answer Result:** <wrong|unsure|correct>
```

Task descriptions **must match the exact wording** from the exam README's coverage table.

`**Answer Result:**` accepts three values:

- `wrong` — answered incorrectly
- `unsure` — uncertain or not yet answered (default when omitted)
- `correct` — answered correctly

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
3. **Answer result** within each skill group: `wrong` first, then `unsure`, then `correct`.
4. **Questions** within the same result group preserve their relative order from the source file.
5. **Omit** skills that have no questions assigned to them.

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
- **Do** normalize question heading levels to `####` (single-file) or `###` (per-domain).
- **Do** ensure every question has `**Domain:**`, `**Skill:**`, and `**Task:**` metadata.
- Metadata is the **single source of truth** for classification — no LLM inference is used.
- The script is **idempotent** — running it multiple times produces the same result.
