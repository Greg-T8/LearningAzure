---
name: lab-readme-authoring
description: Procedures for generating lab README.md content, section by section. Section order is defined in lab-shared-contract R-011.
user-invokable: false
---

# Lab README Authoring

Procedures for generating README content for Azure hands-on labs. Section order and count are defined in `lab-shared-contract` R-011 — this skill defines the content guidelines for each section.

## When to Use

- Writing README content for a new lab
- Validating README content completeness
- Generating specific sections of a lab README

---

## README Template

Starting template: `.github/skills/lab-azure-governance/templates/README.template.md` (see `lab-azure-governance` R-160).

---

## R-140: Per-Section Content Guidelines

Section order: see `lab-shared-contract` R-011.

### Section 0: Title and Exam Coverage Metadata

The H1 title is followed immediately by exam coverage metadata. These lines are used by `Update-CoverageTable.ps1` to populate the Exam Coverage table in each exam README.

```markdown
# <Lab Title>

**Domain:** <Exam Domain from intake>
**Skill:** <Skill from intake>
**Task:** <Task from intake>
```

Rules:

- Use the `Exam Domain`, `Skill`, and `Task` values from the intake metadata (R-041/R-043) — **not** the folder-path `Domain`.
- Use exact wording — these values are copied verbatim from the exam's `Skills.psd1` hierarchy.
- If the intake specifies multiple tasks, use a header plus bullets:

```markdown
**Task:**
- <task 1>
- <task 2>
```

- Insert a blank line after the metadata block before the first `##` section heading.

### Section 1: Exam Question Scenario / Exam Task

Content depends on the `Intake Mode` field from the Phase 1 metadata.

**Question Mode (`Intake Mode: Question`):**

```markdown
## Exam Question

> **Exam**: [EXAM] — [Domain]

### <Title from intake>

*<Question Type>*

<Scenario text, options, and answer table — copied verbatim from intake file>
```

- The `## Exam Question` heading and `> **Exam**` context line are the only new content.
- Everything below them **must be copied verbatim** from the intake file (everything before `## Phase 1 — Metadata Output`).
- Preserve the Lab-Intake format exactly: H3 title, italic question type, paragraph breaks, lettered options with trailing spaces, answer tables, code blocks, and blank-token syntax.
- Do **not** restructure, re-wrap, renumber, or paraphrase any part of the question.
- **Do NOT reveal the correct answer in this section.**

**Task Mode (`Intake Mode: Task`):**

```markdown
## Exam Task

> **Exam**: [EXAM] — [Domain]

### <Task name>

<Task overview and learning objectives — copied verbatim from intake file>
```

- The `## Exam Task` heading and `> **Exam**` context line are the only new content.
- Everything below them **must be copied verbatim** from the intake file (everything before `## Phase 1 — Metadata Output`).
- Preserve the Lab-Intake format exactly: task overview paragraphs, numbered learning objectives.
- Do **not** restructure or paraphrase.

### Section 2: Solution Architecture

```markdown
## Solution Architecture

[2-4 sentences from the architecture summary]
```

### Section 3: Architecture Diagram

```markdown
## Architecture Diagram
```

- A Mermaid diagram is **always required** (`lab-shared-contract` R-013).
- When 2+ interconnected resources: diagram the resource topology.
- When fewer than 2 interconnected resources: diagram the overall process reflective of the exam question.

### Section 4: Lab Objectives

```markdown
## Lab Objectives

1. [Objective 1]
2. [Objective 2]
3. [Objective 3]
```

- 3–5 specific, measurable objectives aligned with the exam question.

### Section 5: Lab Structure

```markdown
## Lab Structure
```

- Show the actual file tree of the lab.

### Section 6: Prerequisites

```markdown
## Prerequisites

- Azure subscription with required permissions
- Azure CLI installed and authenticated
- [Terraform >= 1.0 | Bicep CLI] installed
- PowerShell 7+ with Az module
```

- Adapt to the deployment method.

### Section 7: Deployment

- Include the validation sequence from `lab-shared-contract` R-018 for IaaC labs.
- Keep deployment instructions brief and actionable.

### Section 8: Testing the Solution

- Step-by-step validation with specific commands or portal navigation.
- Include expected outcomes for each step.

### Section 9: Cleanup

```markdown
## Cleanup

> Destroy within 7 days per governance policy.
```

- Include cleanup command for the deployment method.
- Note purge requirements for soft-delete resources (`lab-shared-contract` R-016).

### Section 10: Scenario Analysis / Task Deep Dive

Content depends on the `Intake Mode` field from the Phase 1 metadata.

**Question Mode (`Intake Mode: Question`):**

```markdown
## Scenario Analysis

### Correct Answer: [Letter]

[Explanation]

### Why Other Options Are Incorrect

- **[Option]**: [Reasoning]
```

- This is the **only section** where the correct answer is revealed.
- Provide reasoning for every incorrect option.

**Task Mode (`Intake Mode: Task`):**

```markdown
## Task Deep Dive

### Key Concepts

[Core concepts and terminology the user must understand]

### Best Practices

[Recommended configurations, patterns, and approaches]

### Common Pitfalls

[Frequent mistakes and misconceptions to avoid]

### Exam Relevance

[How this task typically appears on the exam — question patterns, tested scenarios, depth of knowledge expected]
```

- Cover the task comprehensively to bring the user up to speed.
- Reference findings from the question bank scan (if related practice questions were found).
- Keep each sub-section concise (3–5 bullet points or short paragraphs).

### Section 11: Key Learning Points

- 5–8 concise, actionable points focused on exam-relevant knowledge.

### Section 12: Related Objectives

- Link to specific exam objective references.

### Section 13: Additional Resources

- Links to official Microsoft documentation.
- Relevant Learn modules or training paths.

### Section 14: Related Labs

```markdown
▶ Related Lab: [lab-folder-name](../../domain/lab-folder-name/README.md)
```

- 0–2 related labs using relative paths.

---

## R-141: Template Reference

Starting template: `.github/skills/lab-azure-governance/templates/README.template.md`

---

## R-142: Rules

- **No code header block** in README (`lab-shared-contract` R-012 applies to code files only).
- Correct answer revealed **only** in Section 10.
- All 14 sections must appear, even if brief.
- Use Mermaid diagrams only when meaningful (`lab-shared-contract` R-013).

---

## R-143: When-to-Use Criteria

Use this skill when creating or validating README content for a hands-on lab.
