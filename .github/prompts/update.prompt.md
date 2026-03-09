---
name: Update-Exam-And-Lab-Pages
description: Updates top-level exam READMEs, hands-on-lab catalogs, and practice exam question pages across all exams
---

# Exam & Lab Page Updater

Performs a full refresh of top-level exam pages, hands-on-lab catalogs, and practice exam question pages.

Uses the `lab-catalog-updater` skill for lab scanning, catalog updates, and cross-references.
Uses the `exam-question-organizer` skill to reorganize practice exam questions and update coverage tables.

## Link Fidelity Requirement

> **Every lab link, Related Lab cross-reference, and Related Practice Exam Question link MUST be verified against the filesystem before it is written.** Use directory-listing and file-read tool calls to confirm that lab folders and target markdown files actually exist. Never generate, guess, or infer lab folder names or paths — only reference items confirmed to exist on disk. If a path cannot be verified, omit it.

## Scope

### Hands-on Lab Catalogs

- `AI-102/hands-on-labs/README.md`
- `AZ-104/hands-on-labs/README.md`
- `AI-900/hands-on-labs/README.md` (if present)

### Practice Exam Pages

- `AZ-104/practice-exams/README.md`
- `AI-102/practice-exams/README.md`

### Exam READMEs (Coverage Tables)

- `AZ-104/README.md` — Practice Exam Coverage section
- `AI-102/README.md` — Practice Exam Coverage section

## Workflow

### 1. Update Lab Catalogs

Use the `lab-catalog-updater` skill to scan and update hands-on-labs README files, lab statistics, Related Labs cross-references, and Related Practice Exam Questions links.

### 2. Organize Practice Exam Questions

Use the `exam-question-organizer` skill to reorganize practice exam questions by domain/skill/task hierarchy, insert `**Exam Task:**` metadata, and update the coverage table on each exam README.

> **MANDATORY FULL PIPELINE — NO SHORT-CIRCUITING.** You MUST execute every step of the exam-question-organizer skill (Load → Parse → Classify → Assemble → Verify → Update Coverage). The presence of existing `**Exam Task:**` metadata or existing domain headings does NOT mean questions are correctly placed. A question's `**Exam Task:**` value may not match the domain/skill section it currently sits under. You MUST classify every question against the domain structure and move any misplaced questions to the correct section. Skipping classification because "metadata already exists" is a critical error.

### 3. Collapse Explanation Blocks

Search all practice exam question README files (under `practice-exams/` folders and individual assessment MDs such as `Microsoft_Assessment_*.md`, `TutorialsDojo_*.md`, etc.) and ensure any `<details>` blocks that include the `open` attribute (e.g., `<details open>`) are changed to plain `<details>` so explanations are collapsed by default.

### 4. Remove Unused Images

After all updates are complete, run the unused image cleanup script:

```powershell
& ".assets\scripts\Remove-UnusedImages.ps1"
```

- Run with `-WhatIf` first to preview what will be deleted before committing to removal.
- The script scans every `.img` directory in the workspace and deletes any image file not referenced by a sibling markdown file.

## Invocation Examples

- "Update everything"
- "Update the hands-on-labs README files"
- "Organize AZ-104 practice exam questions"
- "Update AI-102 hands-on-labs README with latest labs"
- "Refresh the lab catalog in AZ-104"
- "Update Related Labs sections across all labs"
- "Update practice exam coverage tables"
