---
name: new-exam-scaffold
description: 'Scaffold a new certification exam into the LearningAzure workspace. Creates the folder structure, README files, StudyLog, and updates all cross-cutting files (scripts, governance, shared contract, top-level README). Use when asked to add a new exam, create an exam, scaffold an exam, or introduce a new certification.'
user-invokable: true
argument-hint: '[exam code]'
---

# New Exam Scaffold

Creates the complete folder structure and updates all cross-cutting files needed to introduce a new certification exam into the LearningAzure workspace.

## When to Use

- Adding a new Microsoft certification exam (e.g., AI-103, AZ-305, DP-100)
- Replacing a retiring exam with its successor
- Scaffolding a new exam structure from scratch

## Input Required

Before scaffolding, gather the following from the user. Do **not** guess or infer — ask explicitly for anything not provided.

| Input | Description | Example |
| ----- | ----------- | ------- |
| **Exam Code** | Uppercase exam identifier | `AI-103` |
| **Full Title** | Official exam title | `Designing and Implementing a Microsoft Azure AI Solution` |
| **Certification Name** | Credential name from Microsoft | `Azure AI Engineer Associate` |
| **Certification URL** | Microsoft credential page URL | `https://learn.microsoft.com/en-us/credentials/certifications/azure-ai-engineer/...` |
| **Study Guide URL** | Official study guide URL | `https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/ai-103` |
| **Exam Domains** | Full domain → skill → task hierarchy with weights | See [Domain Structure Format](#domain-structure-format) |
| **Exam Focus** | `AI` or `Infrastructure` — determines resource naming prefixes | `AI` |
| **Lab Domain Folders** | Subdirectory names for hands-on-labs | `generative-ai`, `agentic`, `computer-vision`, `nlp`, `knowledge-mining` |
| **Start Date** | When study begins (or leave blank for later) | `3/15/26` |

### Domain Structure Format

Provide the official exam domain hierarchy. This populates the coverage table in the exam README:

```
Domain 1: <Name> (<Weight>)
  Skill: <Skill Name>
    Task: <Task description>
    Task: <Task description>
  Skill: <Skill Name>
    Task: <Task description>
Domain 2: <Name> (<Weight>)
  ...
```

The domain/skill/task hierarchy can be found on the official Microsoft study guide page for the exam.

---

## Phase 1: Create Exam Folder Structure

### 1.1 Directory Tree

Create the following directory structure under `certs/`:

```
certs/<EXAM>/
├── README.md
├── StudyLog.md
├── hands-on-labs/
│   ├── README.md
│   └── <domain-folder>/          ← one per lab domain
│       └── .gitkeep
├── learning-paths/
│   └── README.md
├── practice-questions/
│   ├── .img/
│   │   └── .gitkeep
│   └── README.md
└── video-courses/
    └── README.md
```

### 1.2 File Templates

#### `certs/<EXAM>/README.md` — Main Exam README

Follow the established format from existing exams. Include:

1. **Title** — `# <EXAM>: <Full Title> — Study Guide`
2. **Objective statement** with credential name
3. **Links** — Certification page, study guide, study log
4. **Progress Tracker** — `## 📚 Progress Tracker` section with the table format below, followed by a legend line. All status `Not Started` unless a start date is provided.
5. **Coverage Dashboard** — `## 📊 Exam Coverage` header, a preamble sentence linking to practice questions and labs, then the dashboard between `<!-- BEGIN COVERAGE DASHBOARD -->` and `<!-- END COVERAGE DASHBOARD -->` markers. One row per domain with anchor links (`#domain-1`, etc.), weights, skill counts, zero Qs/Labs counts, a `Tasks Covered` column (`0 / N (0%)`), and status emoji. Followed by a Totals line, Legend, and a Note about practice question criteria.
6. **Coverage Table** — Between `<!-- BEGIN COVERAGE TABLE -->` and `<!-- END COVERAGE TABLE -->` markers. Full domain → skill → task hierarchy with `| Qs | Labs |` columns initialized to `0 | 0`. Each skill name includes a `(T tasks)` suffix showing the number of tasks under that skill.

**Progress Tracker format** (must match this exact header for `Update-ProgressTrackerDays.ps1` auto-discovery):

```markdown
## 📚 Progress Tracker

| Priority | Modality         | My Notes                                                        | Status | Started | Completed | Days |
| :------- | :--------------- | :-------------------------------------------------------------- | :----- | :------ | :-------- | :--- |
| 1        | Hands-on Labs    | [Hands-on Labs](./hands-on-labs/README.md)                      | Not Started |         |           |      |
| 1        | Practice Questions   | [Practice Questions](./practice-questions/README.md)        | Not Started |         |           |      |
| 2        | Video            | [Video Courses](./video-courses/README.md)                      | Not Started |         |           |      |
| 3        | Microsoft Learn  | [Microsoft Learning Paths](./learning-paths/README.md)          | Not Started |         |           |      |

**Legend:** Not Started | In Progress | Completed
```

**Coverage section preamble:**

```markdown
## 📊 Exam Coverage

Task-level coverage from [Practice Questions](./practice-questions/README.md) and [Hands-on Labs](./hands-on-labs/README.md).
```

**Dashboard table** (between `<!-- BEGIN COVERAGE DASHBOARD -->` and `<!-- END COVERAGE DASHBOARD -->` markers):

```markdown
<!-- BEGIN COVERAGE DASHBOARD -->

| Domain | Weight | Skills | Qs | Labs | Tasks Covered | Status |
| :----- | :----- | -----: | -: | ---: | :------------ | :----: |
| [1. <Short Name>](#domain-1) | XX–XX% | S | 0 | 0 | 0 / N (0%) | 🔴 |
| [2. <Short Name>](#domain-2) | XX–XX% | S | 0 | 0 | 0 / N (0%) | 🔴 |

**Totals:** 0 practice questions · 0 hands-on labs

**Legend:** 🟢 Strong (≥66%) · 🟡 Partial (33–65%) · 🔴 Low (<33%) — "Covered" = task has ≥1 practice question or ≥1 lab

> **Note:** Practice questions are those missed or not confidently answered correctly.

<!-- END COVERAGE DASHBOARD -->
```

- `S` = number of skills in each domain (from the exam study guide hierarchy).
- `N` = total task count for each domain from the coverage table.
- `<Short Name>` = abbreviated domain name for the dashboard (e.g., "Identities & Governance").
- All new exams start with `🔴` status and zero counts.

**Domain sections** use the compact `<details>/<summary>` format (no `###` headings):

```markdown
<a id="domain-1"></a>
<details>
<summary><b>Domain 1: <Name> (<Weight>)</b> — N tasks · 0 Qs · 0 Labs</summary>

| Skill | Task | Qs | Labs |
| :--- | :--- | -: | -: |
| <Skill Name> (T tasks) | <Task description> | 0 | 0 |
|  | <Task description> | 0 | 0 |

</details>
```

Dashboard status indicators:

- 🟢 Strong (≥66% tasks covered)
- 🟡 Partial (33–65%)
- 🔴 Low (<33%)

#### `certs/<EXAM>/StudyLog.md` — Study Time Tracker

```markdown
# Study Log — <EXAM>: <Full Title>

This log tracks individual study sessions for the **<EXAM>** exam. Fill in **End**, **Duration**, and **Notes** when the session concludes.

---

## Session History

| # | Date | Start | End | Duration | Notes |
|:--|:-----|:------|:----|:---------|:------|
```

#### `certs/<EXAM>/hands-on-labs/README.md` — Lab Catalog

```markdown
# <EXAM> Hands-on Labs

Practice labs that reinforce exam objectives through real Azure deployments.

All labs follow the governance policies in [Governance-Lab.md](../../../.assets/shared/Governance-Lab.md).

---

## 📈 Lab Statistics

- **Total Labs:** 0
<domain counts — one line per domain, all 0>

---

## 🧪 Labs

*No labs yet. Labs are built as practice exam questions reveal knowledge gaps.*

---

## 📋 Governance & Standards

- **Governance Policy:** [Governance-Lab.md](../../../.assets/shared/Governance-Lab.md)
- **Shared Contract:** [lab-shared-contract](../../../.github/skills/lab-shared-contract/SKILL.md)
```

#### `certs/<EXAM>/practice-questions/README.md` — Practice Questions

```markdown
# Practice Exam Questions - <EXAM>

Accounts for questions missed or unsure about in the practice exams.
```

#### `certs/<EXAM>/learning-paths/README.md` — Learning Paths Catalog

Follow the format of existing learning path READMEs. Include a progress table with path names, module counts, and status columns. If paths are not yet available, note that they will be populated when Microsoft publishes the learning paths. Do **not** create subfolders for individual learning paths — those are added later as study progresses.

#### `certs/<EXAM>/video-courses/README.md` — Video Courses

Create a minimal README placeholder. Do **not** create subfolders (e.g., `savill/`) — those are added later when video notes are taken.

```markdown
# <EXAM> — Video Courses

*No video course notes yet.*
```

---

## Phase 2: Update Cross-Cutting Files

### 2.1 Top-Level README.md

Add the new exam to the **Certifications table** (under `## 📚 Certifications`):

```markdown
| 📕 [**<EXAM>**](certs/<EXAM>/README.md) | <Certification Name> | Not Started | |
```

- Use the appropriate emoji color (📗📙📘📕) and status text based on start date.
- If a start date is provided, use `In Progress` as the status and add the start date in the Duration column.
- Adding the exam to this table makes it discoverable by `Get-ActiveExam.ps1`, which all maintenance scripts use for dynamic exam discovery.

### 2.2 Governance-Lab.md

Add the exam code to the title scope:

```markdown
Standards for all Terraform and Bicep labs (AI-102, AZ-104, <NEW-EXAM>).
```

If the exam has a distinct resource focus (e.g., AI services vs. infrastructure), add an exam-specific resource prefix table under `§2.2 Resource Naming` following the format of existing prefix tables:

```markdown
#### <EXAM> Prefixes

| Resource | Prefix |
| -------- | ------ |
| ...      | ...    |
```

Add the exam to the `Project` tag examples in `§1.2 Required Tags`:

```markdown
| Project | AI-102 / AZ-104 / <NEW-EXAM> |
```

### 2.3 lab-shared-contract SKILL.md

**R-001** — Add the lowercase exam code to the `<exam>` definition:

```markdown
- `<exam>`: lowercase exam code (`az104`, `ai102`, `<new-exam-lowercase>`)
```

**R-005** — Add the exam code to the `Project` tag examples:

```markdown
| Project | Uppercase: `AI-102` or `AZ-104` or `<NEW-EXAM>` |
```

**New R-0xx** (if exam has distinct resource types) — Add an exam-specific resource naming rule following the pattern of R-002 and R-003:

```markdown
## R-0xx: Resource Naming — <EXAM> Prefixes

Pattern: `<prefix>-<role>[-instance]`

| Resource | Prefix | Random Suffix? |
| -------- | ------ | -------------- |
| ...      | ...    | ...            |
```

Assign the next available R-0xx ID.

### 2.4 Scripts

All maintenance scripts use **dynamic exam discovery** via `Get-ActiveExam.ps1`, which parses the main README's certifications table. Adding the exam to the top-level README (§2.1) automatically makes it visible to these scripts:

- `Update-CoverageTable.ps1`
- `Invoke-PracticeExamReorganizer.ps1`
- `Update-StudyLogGaps.ps1`

No `ValidateSet` updates or hardcoded exam lists are needed in these scripts.

#### `Update-LabReferences.ps1`

Add the exam to the `$DomainConfig` hashtable with domain folder→display-name mappings:

```powershell
$DomainConfig = @{
    'AZ-104' = [ordered]@{
        'storage'             = 'Storage'
        'compute'             = 'Compute'
        'monitoring'          = 'Monitoring'
        'identity-governance' = 'Identity & Governance'
        'networking'          = 'Networking'
    }
    '<NEW-EXAM>' = [ordered]@{
        '<domain-folder>' = '<Display Name>'
        # ... one entry per lab domain folder
    }
}
```

The domain ordering determines how labs are grouped and sequenced in the catalog.

#### `Invoke-AzStudySession.ps1`

Standard exams under `certs/<EXAM>/` using `StudyLog.md` require **no changes** — the script discovers them automatically via `Get-ActiveExam.ps1` and defaults to `certs\<EXAM>` folder and `StudyLog.md`.

Only add entries if the exam uses a non-standard folder or log file:

- **`$ExamFolderMap`** — Add only if the exam folder is not `certs\<EXAM>`.
- **`$ExamLogFileMap`** — Add only if the log file is not `StudyLog.md`.

#### `Update-ProgressTrackerDays.ps1`

No changes required. This script auto-discovers all exam READMEs by scanning `certs/*/README.md` for files whose progress tracker table matches this header pattern:

```
| Priority | Modality | My Notes | Status | Started | Completed | Days |
```

New exams are picked up automatically when their README includes this exact header row.

#### `Invoke-ContentMaintenance.ps1`

No changes required. This orchestrator script runs all maintenance scripts in dependency order:

1. `Invoke-PracticeExamReorganizer` (when `-Reorganize` is specified)
2. `Update-StudyLogGaps`
3. `Update-ProgressTrackerDays`
4. `Update-CoverageTable`
5. `Update-LabReferences`
6. `Invoke-CollapseDetailBlock`
7. `Remove-UnusedImages`
8. `Update-CommitStats`

Since child scripts use dynamic discovery, the orchestrator automatically processes new exams once they are added to the top-level README.

### 2.5 Skills

#### `lab-catalog-updater/SKILL.md`

Add the exam to the **Scope** section and define its **domain ordering**:

```markdown
- `certs/<NEW-EXAM>/hands-on-labs/README.md`
```

Also add a domain ordering entry following the existing pattern:

```markdown
- **<NEW-EXAM>:** <Domain1>, <Domain2>, ...
```

The domain ordering determines how labs are grouped and sequenced in the catalog.

#### `exam-question-organizer/SKILL.md`

Add the exam to the **Target Files** table:

```markdown
| <NEW-EXAM> | `certs/<NEW-EXAM>/practice-questions/README.md` | `certs/<NEW-EXAM>/README.md` — Practice Exam Coverage section | `certs/<NEW-EXAM>/README.md` — Practice Exam Coverage section |
```

---

## Phase 3: Validation

After all files are created and updated, verify:

| Check | How |
| ----- | --- |
| Folder structure exists | List `certs/<EXAM>/` directory recursively |
| README has coverage markers | Confirm `<!-- BEGIN COVERAGE TABLE -->`, `<!-- END COVERAGE TABLE -->`, `<!-- BEGIN COVERAGE DASHBOARD -->`, and `<!-- END COVERAGE DASHBOARD -->` markers exist |
| Content maintenance passes | Run `Invoke-ContentMaintenance.ps1 -WhatIf` — all steps should complete without errors |
| Study session works | Run `Invoke-AzStudySession.ps1 -Action Start -Mode <NEW-EXAM>` then `-Action Stop` |
| Top-level README links resolve | Confirm the certifications table links to existing `certs/<EXAM>/README.md` |
| Governance references exam | Search `Governance-Lab.md` for the exam code |
| Lab domain config | Confirm `Update-LabReferences.ps1` `$DomainConfig` contains the new exam entry |
| Domain count matches | Count tasks in coverage table vs. `<summary>` tag totals |
| No raw unicode escapes | Scan all generated files for literal unicode escape sequences (`\uXXXX`, `\u{XXXXX}`, `&#xNNNN;`). If any are found, replace them with the actual rendered character. |

---

## Rules

- **Do not** pre-populate question or lab content — those are built organically from practice exams.
- **Do** initialize all coverage counts to zero.
- **Do** use the compact `<details>/<summary>` format for domain sections (no `###` headings).
- **Do** preserve exact domain/skill/task wording from the official study guide — these are the single source of truth for the `exam-question-organizer` metadata matching.
- **Do** assign the next available R-0xx ID when adding shared contract rules.
- **Do** follow existing file formatting conventions exactly (line endings, marker comments, table alignment).
- **Do not** modify any existing exam's content — only add the new exam and update shared references.

## Output

After completing the scaffold, report:

1. **Files Created** — Full list of new files and directories
2. **Files Updated** — Each cross-cutting file modified with a one-line description of the change
3. **Validation Results** — Pass/fail for each check in Phase 3
4. **Next Steps** — Remind user to populate the exam domains from the official study guide if placeholder was used
