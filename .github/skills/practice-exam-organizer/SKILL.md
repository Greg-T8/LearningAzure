---
name: practice-exam-organizer
description: 'Reorganize practice exam questions by domain, skill, and task metadata for any certification exam, then update the coverage table on the exam README. Use when asked to organize practice exams, classify exam questions by domain, or update practice exam coverage.'
user-invokable: false
argument-hint: '[exam]'
---

# Practice Exam Organizer

Reorganize a practice exam `README.md` to group questions under their correct exam domain and skill headings, with task-level metadata on each question. After reorganizing, update the coverage table on the exam's main README.

## When to Use

- Organizing or reorganizing practice exam questions by domain structure
- Classifying exam questions into domain → skill → task hierarchy
- Updating the Practice Exam Coverage table after questions are added or removed

## Target Files

| Exam   | Practice Exam File                 | Domain Reference                                       | Coverage Table                                              |
| ------ | ---------------------------------- | ------------------------------------------------------ | ----------------------------------------------------------- |
| AZ-104 | `AZ-104/practice-exams/README.md`  | `AZ-104/README.md` — Domain Quick Reference section    | `AZ-104/README.md` — Practice Exam Coverage section         |
| AI-102 | `AI-102/practice-exams/README.md`  | `AI-102/README.md` — Domain Quick Reference section    | `AI-102/README.md` — Practice Exam Coverage section         |

If no exam is specified, ask which exam to process.

## Output Structure

### Heading Hierarchy

| Element    | Heading | Notes                                                    |
| ---------- | ------- | -------------------------------------------------------- |
| Page title | `#`     | `# Practice Exam Questions - <EXAM>` (single H1)        |
| Domain     | `##`    | Matches the domain name from the exam README             |
| Skill      | `###`   | Matches the skill name from the exam README              |
| Question   | `####`  | Existing question title — preserved exactly              |

A single `#` page title satisfies markdown linters (one H1 per file). Domains at `##` appear as top-level entries in the GitHub sidebar TOC with skills nested beneath them.

### Example

```markdown
# Practice Exam Questions - AZ-104

* [Manage Azure identities and governance](#manage-azure-identities-and-governance)
  * [Manage Microsoft Entra users and groups](#manage-microsoft-entra-users-and-groups)
    * [Configure Microsoft Entra SSPR For Specific Users](#configure-microsoft-entra-sspr-for-specific-users)

---

## Manage Azure identities and governance

### Manage Microsoft Entra users and groups

#### Configure Microsoft Entra SSPR For Specific Users

**Exam Task:** Configure self-service password reset (SSPR)

You are asked to configure Self-Service Password Reset (SSPR)…
```

### Exam Task Metadata

Immediately after each `####` question heading (separated by a blank line), insert:

```markdown
**Exam Task:** Task description
```

If a question maps to multiple tasks, join them with ` · ` (space-middle-dot-space):

```markdown
**Exam Task:** Apply and manage tags on resources · Manage costs by using alerts, budgets, and Azure Advisor recommendations
```

Task descriptions **must match the exact wording** from the exam README's Domain Quick Reference section.

### Table of Contents

After the page title, generate a nested bullet-point TOC with anchor links:

```markdown
* [Domain Name](#domain-anchor)
  * [Skill Name](#skill-anchor)
    * [Question Title](#question-anchor)
```

Handle duplicate question titles by appending `-1`, `-2` to anchors (GitHub-style).

### Ordering Rules

1. **Domains** appear in exam order (Domain 1 first).
2. **Skills** appear in the order listed in the exam README.
3. **Questions** within a skill preserve their relative order from the source file.
4. **Omit** skills that have no questions assigned to them.

### Introductory Content

If the practice exam file contains non-question content at the top (e.g., a "Learning Strategy" section in AI-102), preserve it between the page title and the TOC.

## Workflow

### Step 1 — Load the Domain Structure

Read the exam's main README (e.g., `AZ-104/README.md`) and extract the **Domain Quick Reference** section. Build a structured map:

```
Domain → Skill → [Task, Task, …]
```

Each domain typically has 2–4 skills, and each skill has 3–8 tasks.

### Step 2 — Parse Existing Questions

Read the practice exam README and extract every question block. A question block:

- Starts at a heading (`####`)
- Ends at the next `---` separator or end of file
- Includes **everything**: question text, answer options, `<details>` blocks (screenshots, explanations), `▶ Related Lab:` links

Preserve each block's full content exactly.

### Step 3 — Classify Each Question

For every question block, determine:

1. **Domain** — Which of the exam's domains this question primarily tests
2. **Skill** — Which skill area under that domain
3. **Task(s)** — Which specific task(s) from the skill's task list

Use the question's scenario, answer choices, and explanation to inform classification. When a question spans multiple domains or skills, assign it to the **primary** one being tested.

### Step 4 — Assemble and Write

Generate the reorganized file with the structure defined above. For files with 20+ questions, write a temporary Python script to assemble the output reliably (parse blocks, apply the classification map, generate TOC and body, then write). Delete the script after use.

### Step 5 — Verify

After writing, confirm:

- All original questions are present (count check)
- No question content was altered
- Every question has an **Exam Task** metadata line
- Heading levels are correct (`#` / `##` / `###` / `####`)

### Step 6 — Update Coverage Table

Open the exam's main README and locate the **Practice Exam Coverage** section (between `<!-- BEGIN COVERAGE TABLE -->` and `<!-- END COVERAGE TABLE -->` markers). Update the **Qs** column for every task row:

1. Parse all `**Exam Task:**` lines from the practice exam (split multi-task entries on ` · `).
2. Count occurrences per task.
3. Write the count into the matching row's **Qs** column. Tasks with no matching questions get `0`.

The coverage table uses this structure — do not add or remove headings or rows, only update **Qs** values:

```markdown
### Domain N: <Domain Name> (<Weight>)

#### <Skill Name>

| Task | Qs |
| :--- | -: |
| <task description> | <count> |
```

Each domain is a `###` heading, each skill is a `####` heading, and each skill has a two-column table (Task, Qs). Task names must match the Domain Quick Reference exactly.

## Rules

- **Do not** alter question text, answer options, screenshots, `<details>` blocks, explanation content, or `▶ Related Lab:` links.
- **Do** normalize question heading levels to `####`.
- **Do** insert the `**Exam Task:**` metadata line after each question heading.
- **Do** remove any previous domain/section headings from the source (they will be regenerated).
- If the file already follows this structure from a previous run, strip existing `**Exam Task:**` lines before re-inserting them (idempotent).
