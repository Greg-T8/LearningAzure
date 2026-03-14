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
| **Learning Paths** | Microsoft Learn path names and URLs (if available) | See [Learning Paths Format](#learning-paths-format) |
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

### Learning Paths Format

```
01: <Path Title> — <URL> — <Module Count> modules
02: <Path Title> — <URL> — <Module Count> modules
```

If not yet available, the learning-paths README will contain placeholder text.

---

## Phase 1: Create Exam Folder Structure

### 1.1 Directory Tree

Create the following directory structure under the workspace root:

```
<EXAM>/
├── README.md
├── StudyLog.md
├── hands-on-labs/
│   ├── README.md
│   └── <domain-folder>/          ← one per lab domain
│       └── .gitkeep
├── learning-paths/
│   ├── README.md
│   └── <NN>-<path-slug>/        ← one per learning path (if known)
│       └── README.md
├── practice-questions/
│   ├── .img/
│   │   └── .gitkeep
│   └── README.md
└── video-courses/
    └── savill/
        └── README.md
```

### 1.2 File Templates

#### `<EXAM>/README.md` — Main Exam README

Follow the established format from existing exams. Include:

1. **Title** — `# <EXAM>: <Full Title> — Study Guide`
2. **Objective statement** with credential name
3. **Links** — Certification page, study guide, study log
4. **Progress Tracker** — `## 📚 Progress Tracker` section with the table format below, followed by a legend line. All status `🕒` (Not Started) unless a start date is provided.
5. **Coverage Dashboard** — `## 📊 Exam Coverage` header, a preamble sentence linking to practice questions and labs, then the dashboard between `<!-- BEGIN COVERAGE DASHBOARD -->` and `<!-- END COVERAGE DASHBOARD -->` markers. One row per domain with anchor links (`#domain-1`, etc.), weights, and zero counts.
6. **Coverage Table** — Between `<!-- BEGIN COVERAGE TABLE -->` and `<!-- END COVERAGE TABLE -->` markers. Full domain → skill → task hierarchy with `| Qs | Labs |` columns initialized to `0 | 0`.

**Progress Tracker format** (must match this exact header for `Update-ProgressTrackerDays.ps1` auto-discovery):

```markdown
## 📚 Progress Tracker

| Priority | Modality         | My Notes                                                        | Status | Started | Completed | Days |
| :------- | :--------------- | :-------------------------------------------------------------- | :----- | :------ | :-------- | :--- |
| 1        | Hands-on Labs    | [Hands-on Labs](./hands-on-labs/README.md)                      | 🕒     |         |           |      |
| 1        | Practice Questions   | [Practice Questions](./practice-questions/README.md)        | 🕒     |         |           |      |
| 2        | Video            | [Video Courses](./video-courses/savill/README.md)               | 🕒     |         |           |      |
| 3        | Microsoft Learn  | [Microsoft Learning Paths](./learning-paths/README.md)          | 🕒     |         |           |      |

**Legend:** 🕒 Not Started | 🚧 In Progress | ✅ Complete
```

**Coverage section preamble:**

```markdown
## 📊 Exam Coverage

Task-level coverage from [Practice Questions](./practice-questions/README.md) and [Hands-on Labs](./hands-on-labs/README.md).
```

**Domain sections** use the compact `<details>/<summary>` format (no `###` headings):

```markdown
<a id="domain-1"></a>
<details>
<summary><b>Domain 1: <Name> (<Weight>)</b> — N tasks · 0 Qs · 0 Labs</summary>

| Skill | Task | Qs | Labs |
| :--- | :--- | -: | -: |
| <Skill Name> | <Task description> | 0 | 0 |
|  | <Task description> | 0 | 0 |

</details>
```

Dashboard status indicators:
- 🟢 Strong (≥66% tasks covered)
- 🟡 Partial (33–65%)
- 🔴 Low (<33%)

#### `<EXAM>/StudyLog.md` — Study Time Tracker

```markdown
# <EXAM> Study Log

Session-by-session study time tracker. Managed by `Invoke-AzStudySession.ps1`.

| # | Date | Start | End | Duration | Notes |
|:--|:-----|:------|:----|:---------|:------|
```

#### `<EXAM>/hands-on-labs/README.md` — Lab Catalog

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
- **Shared Contract:** [lab-shared-contract](../../.github/skills/lab-shared-contract/SKILL.md)
```

#### `<EXAM>/practice-questions/README.md` — Practice Questions

```markdown
# Practice Exam Questions - <EXAM>

Accounts for questions missed or unsure about in the practice exams.
```

#### `<EXAM>/learning-paths/README.md` — Learning Paths Catalog

Follow the format of existing learning path READMEs. Include a progress table with path names, module counts, and status columns. If paths are not yet available, note that they will be populated when Microsoft publishes the learning paths.

#### `<EXAM>/video-courses/savill/README.md` — Video Notes

```markdown
# <EXAM> — John Savill's Training

Notes from [John Savill's YouTube channel](https://www.youtube.com/@NTFAQGuy).

*No video notes yet.*
```

---

## Phase 2: Update Cross-Cutting Files

### 2.1 Top-Level README.md

Add the new exam to two locations:

**Badge row** (in the `<div align="center">` block):

```markdown
[![<EXAM>](https://img.shields.io/badge/<EXAM-ESCAPED>-Not%20Started-lightgrey)](<EXAM>/)
```

Use `Not%20Started` / `lightgrey` for new exams, or `In%20Progress` / `yellow` if a start date is provided.

**Certifications list** (under `## 📚 Certifications`):

```markdown
- 📕 [**<EXAM>**](<EXAM>/README.md) — <Certification Name> (*not started*)
```

Use the appropriate emoji color (📗📙📘📕) and status text based on start date.

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

#### `Update-CoverageTable.ps1`

Add the exam code to the `ValidateSet`:

```powershell
[ValidateSet('AI-102', 'AZ-104', '<NEW-EXAM>')]
[string]$ExamName
```

#### `Invoke-PracticeExamReorganizer.ps1`

Add the exam code to the `ValidateSet`:

```powershell
[ValidateSet('AI-102', 'AZ-104', '<NEW-EXAM>')]
[string]$ExamName
```

#### `Invoke-AzStudySession.ps1`

Four updates required:

1. **`ValidateSet`** on the `$Mode` parameter:

```powershell
[ValidateSet('AI-102', 'AZ-104', '<NEW-EXAM>', 'WorkflowDevelopment')]
```

2. **`$AllExams`** array:

```powershell
$AllExams = @('AI-102', 'AZ-104', '<NEW-EXAM>', 'WorkflowDevelopment')
```

3. **`$ExamFolderMap`** hashtable:

```powershell
$ExamFolderMap = @{
    'AI-102' = 'AI-102'
    'AZ-104' = 'AZ-104'
    '<NEW-EXAM>' = '<NEW-EXAM>'
    'WorkflowDevelopment' = '.assets\workflow-development'
}
```

4. **`$ExamLogFileMap`** hashtable — only add an entry if the new exam's log file is **not** `StudyLog.md` (the default). Standard exams using `StudyLog.md` do **not** need an entry here:

```powershell
$ExamLogFileMap = @{
    'WorkflowDevelopment' = 'WorkLog.md'
}
```

#### `Update-ProgressTrackerDays.ps1`

No changes required. This script auto-discovers all exam READMEs by scanning top-level directories (excluding `.`-prefixed) for `README.md` files whose progress tracker table matches this header pattern:

```
| Priority | Modality | My Notes | Status | Started | Completed | Days |
```

New exams are picked up automatically when their README includes this exact header row. The script updates the `Days` column for `🚧` (in-progress) rows by computing elapsed days from the `Started` date.

### 2.5 Skills

#### `lab-catalog-updater/SKILL.md`

Add the exam to the **Scope** section and define its **domain ordering**:

```markdown
- `<NEW-EXAM>/hands-on-labs/README.md`
```

Also add a domain ordering entry following the existing pattern:

```markdown
- **<NEW-EXAM>:** <Domain1>, <Domain2>, ...
```

The domain ordering determines how labs are grouped and sequenced in the catalog.

#### `exam-question-organizer/SKILL.md`

Add the exam to the **Target Files** table:

```markdown
| <NEW-EXAM> | `<NEW-EXAM>/practice-questions/README.md` | `<NEW-EXAM>/README.md` — Practice Exam Coverage section | `<NEW-EXAM>/README.md` — Practice Exam Coverage section |
```

---

## Phase 3: Validation

After all files are created and updated, verify:

| Check | How |
| ----- | --- |
| Folder structure exists | List `<EXAM>/` directory recursively |
| README has coverage markers | Confirm `<!-- BEGIN COVERAGE TABLE -->` and `<!-- END COVERAGE DASHBOARD -->` exist |
| Scripts accept new exam | Run `Update-CoverageTable.ps1 -ExamName <NEW-EXAM> -WhatIf` |
| Study session works | Run `Invoke-AzStudySession.ps1 -Action Start -Mode <NEW-EXAM>` then `-Action Stop` |
| Top-level README links resolve | Confirm the exam badge and certification list link to existing files |
| Governance references exam | Search `Governance-Lab.md` for the exam code |
| Domain count matches | Count tasks in coverage table vs. `<summary>` tag totals |

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
