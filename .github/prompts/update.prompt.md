---
name: Update-Exam-And-Lab-Pages
description: Updates top-level exam READMEs, hands-on-lab catalogs, and practice exam question pages across all exams
---

# Exam & Lab Page Updater

Performs a full refresh of top-level exam pages, hands-on-lab catalogs, and practice exam question pages.

Uses the `lab-catalog-updater` skill for lab scanning, catalog updates, and cross-references.
Uses the `exam-question-organizer` skill to reorganize practice exam questions by domain/skill/task hierarchy.
Uses `Update-CoverageTable.ps1` to update the Qs and Labs columns in each exam README's coverage table.

## Link Fidelity Requirement

> **Every lab link, Related Lab cross-reference, and Related Practice Exam Question link MUST be verified against the filesystem before it is written.** Use directory-listing and file-read tool calls to confirm that lab folders and target markdown files actually exist. Never generate, guess, or infer lab folder names or paths — only reference items confirmed to exist on disk. If a path cannot be verified, omit it.

## Scope

### Hands-on Lab Catalogs

- `AI-102/hands-on-labs/README.md`
- `AZ-104/hands-on-labs/README.md`
- `AI-900/hands-on-labs/README.md` (if present)

### Practice Exam Pages

- `AZ-104/practice-questions/README.md`
- `AI-102/practice-questions/README.md`

### Exam READMEs (Coverage Tables)

- `AZ-104/README.md` — Exam Coverage section
- `AI-102/README.md` — Exam Coverage section

## Workflow

### 1. Update Lab Catalogs

Use the `lab-catalog-updater` skill to scan and update hands-on-labs README files, lab statistics, Related Labs cross-references, and Related Practice Exam Questions links.

### 2. Organize Practice Exam Questions

Use the `exam-question-organizer` skill to reorganize practice exam questions by domain/skill/task hierarchy, insert `**Exam Task:**` metadata, and sort questions under correct domain/skill headings.

> **MANDATORY FULL PIPELINE — NO SHORT-CIRCUITING.** You MUST execute every step of the exam-question-organizer skill (Load → Parse → Classify → Assemble → Verify → Update Coverage). The presence of existing `**Exam Task:**` metadata or existing domain headings does NOT mean questions are correctly placed. A question's `**Exam Task:**` value may not match the domain/skill section it currently sits under. You MUST classify every question against the domain structure and move any misplaced questions to the correct section. Skipping classification because "metadata already exists" is a critical error.

### 3. Update Coverage Tables

Run the coverage table script to update both the Qs and Labs columns in each exam README:

```powershell
& ".assets\scripts\Update-CoverageTable.ps1" -ExamName AZ-104 -Verbose
& ".assets\scripts\Update-CoverageTable.ps1" -ExamName AI-102 -Verbose
```

- The script reads `**Task:**` metadata from practice questions and lab READMEs to count items per task.
- It updates the `Qs` and `Labs` columns between `<!-- BEGIN COVERAGE TABLE -->` and `<!-- END COVERAGE TABLE -->` markers.
- This is the **authoritative source** for coverage table values — it supersedes any coverage update performed by the reorganizer script.

### 4. Collapse Explanation Blocks

Run the collapse script to ensure all `<details>` blocks default to collapsed:

```powershell
& ".assets\scripts\Invoke-CollapseDetailBlock.ps1"
```

- Run with `-WhatIf` first to preview which files contain open detail blocks.
- The script scans every `practice-questions/` directory and replaces `<details open>` with `<details>`.

### 5. Remove Unused Images

After all updates are complete, run the unused image cleanup script:

```powershell
& ".assets\scripts\Remove-UnusedImages.ps1"
```

- The script scans every `.img` directory in the workspace and deletes any image file not referenced by a sibling markdown file.

## Invocation Examples

- "Update everything"
- "Update the hands-on-labs README files"
- "Organize AZ-104 practice exam questions"
- "Update AI-102 hands-on-labs README with latest labs"
- "Refresh the lab catalog in AZ-104"
- "Update Related Labs sections across all labs"
- "Update practice exam coverage tables"
