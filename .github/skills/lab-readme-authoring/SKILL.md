---
name: lab-readme-authoring
description: Procedures for generating lab README.md content, section by section. Section order is defined in shared-contract R-011.
user-invokable: false
---

# Lab README Authoring

Procedures for generating README content for Azure hands-on labs. Section order and count are defined in `shared-contract` R-011 — this skill defines the content guidelines for each section.

## When to Use

- Writing README content for a new lab
- Validating README content completeness
- Generating specific sections of a lab README

---

## README Template

Starting template: `.github/skills/azure-lab-governance/templates/README.template.md` (see `azure-lab-governance` R-160).

---

## R-140: Per-Section Content Guidelines

Section order: see `shared-contract` R-011.

### Section 1: Exam Question Scenario

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

### Section 2: Solution Architecture

```markdown
## Solution Architecture

[2-4 sentences from the architecture summary]
```

### Section 3: Architecture Diagram

```markdown
## Architecture Diagram
```

- See `shared-contract` R-013 for when a diagram is required.
- Include Mermaid code block if required; otherwise include a brief note.

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

- Include the validation sequence from `shared-contract` R-018 for IaaC labs.
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
- Note purge requirements for soft-delete resources (`shared-contract` R-016).

### Section 10: Scenario Analysis

```markdown
## Scenario Analysis

### Correct Answer: [Letter]

[Explanation]

### Why Other Options Are Incorrect

- **[Option]**: [Reasoning]
```

- This is the **only section** where the correct answer is revealed.
- Provide reasoning for every incorrect option.

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

Starting template: `.github/skills/azure-lab-governance/templates/README.template.md`

---

## R-142: Rules

- **No code header block** in README (`shared-contract` R-012 applies to code files only).
- Correct answer revealed **only** in Section 10.
- All 14 sections must appear, even if brief.
- Use Mermaid diagrams only when meaningful (`shared-contract` R-013).

---

## R-143: When-to-Use Criteria

Use this skill when creating or validating README content for a hands-on lab.
