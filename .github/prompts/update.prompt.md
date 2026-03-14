---
name: Update-Exam-And-Lab-Pages
description: Updates top-level exam READMEs, hands-on-lab catalogs, and practice exam question pages across all exams
---

# Exam & Lab Page Updater

Performs a full refresh of top-level exam pages, hands-on-lab catalogs, and practice exam question pages.

Uses `Update-LabReferences.ps1` to deterministically update lab catalogs, statistics, and practice question cross-references.
Uses the `exam-question-organizer` skill to reorganize practice exam questions by domain/skill/task hierarchy.
Uses `Update-CoverageTable.ps1` to update the Qs and Labs columns in each exam README's coverage table.
Uses `Update-ProgressTrackerDays.ps1` to refresh the Days column in each exam's progress tracker.

## Link Fidelity Requirement

> **All lab links and catalog entries are generated deterministically by `Update-LabReferences.ps1`.** The script scans the filesystem for lab folders, reads metadata directly from lab READMEs, and matches practice questions by exact Task value. No manual link verification is needed for steps handled by scripts.

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

## Execution Model

> **Run each step individually.** Execute one command at a time, wait for it to finish, check the output for errors or warnings, and only proceed to the next step after the previous one succeeds. Do NOT chain all commands into a single terminal call.

## Workflow

### 1. Update Lab Catalogs and References (Script)

Run the lab references script to update all lab catalogs, statistics, and practice question cross-references:

```powershell
& ".assets\scripts\Update-LabReferences.ps1" -Verbose
```

- Scans all lab READMEs for metadata (Domain/Skill/Task).
- Matches labs to practice exam questions by exact Task value.
- Adds `**Practice Exam Questions:**` links to each lab's metadata section.
- Removes legacy Related Labs and Related Practice Exam Questions sections from lab READMEs.
- Regenerates each exam's `hands-on-labs/README.md` with accurate statistics and catalog entries.
- Use `-ExamName AZ-104` to target a single exam.

### 2. Organize Practice Exam Questions (Script)

Run the reorganizer script for each exam. The script reads `**Task:**` metadata from each question block, sorts questions by the canonical domain/skill ordering from the exam README, and regenerates the file.

```powershell
& ".assets\scripts\Invoke-PracticeExamReorganizer.ps1" -ExamName AZ-104 -Verbose
& ".assets\scripts\Invoke-PracticeExamReorganizer.ps1" -ExamName AI-102 -Verbose
```

After running, check the summary output for warnings about unrecognized domain/skill values or metadata gaps. Fix any issues and re-run before proceeding.

### 3. Update Coverage Tables (Script)

Run the coverage table script for each exam, one at a time:

```powershell
& ".assets\scripts\Update-CoverageTable.ps1" -ExamName AZ-104 -Verbose
```

```powershell
& ".assets\scripts\Update-CoverageTable.ps1" -ExamName AI-102 -Verbose
```

- The script reads `**Task:**` metadata from practice questions and lab READMEs to count items per task.
- It updates the `Qs` and `Labs` columns between `<!-- BEGIN COVERAGE TABLE -->` and `<!-- END COVERAGE TABLE -->` markers.
- This is the **authoritative source** for coverage table values -- it supersedes any coverage update performed by the reorganizer script.

### 4. Update Progress Tracker Days (Script)

Run the progress tracker days script to refresh elapsed days for in-progress items:

```powershell
& ".assets\scripts\Update-ProgressTrackerDays.ps1" -Verbose
```

- The script auto-discovers all exam READMEs containing progress tracker tables.
- For in-progress items with a Started date, it calculates days elapsed from Started to today.
- Completed and not-started items are skipped.

### 5. Collapse Explanation Blocks (Script)

Run the collapse script to ensure all `<details>` blocks default to collapsed:

```powershell
& ".assets\scripts\Invoke-CollapseDetailBlock.ps1"
```

- The script scans every `practice-questions/` directory and replaces `<details open>` with `<details>`.
- If no open blocks are found, the script reports "No open detail blocks found" and exits successfully.

### 6. Remove Unused Images (Script)

After all updates are complete, run the unused image cleanup script:

```powershell
& ".assets\scripts\Remove-UnusedImages.ps1"
```

- The script scans every `.img` directory in the workspace and deletes any image file not referenced by a sibling markdown file.

## Invocation Examples

everything"

- "Update the hands-on-labs README files"
- "Organize AZ-104 practice exam questions"
- "Update AI-102 hands-on-labs README with latest labs"
- "Refresh the lab catalog in AZ-104"
- "Update practice exam coverage tables"
