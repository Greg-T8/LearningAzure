---
name: lab-readme-authoring
description: 'Generate and validate README.md files for Azure hands-on labs with the required 14-section structure, Mermaid diagrams, and governance-compliant formatting. Use when creating a lab README, validating README section order, or generating lab documentation for AI-102 or AZ-104.'
user-invokable: false
---

# Lab README Authoring

Standards and templates for generating lab README.md files. Every lab README must contain exactly 14 sections in the order specified below.

## When to Use

- Creating a README for a new hands-on lab
- Validating an existing README has all required sections in order
- Generating specific README sections (scenario, architecture, objectives, etc.)
- Adding Mermaid architecture diagrams

## README Template

Use the template at `.github/skills/azure-lab-governance/templates/README.template.md` as the starting point.

## Required Sections (Exact Order)

The README must contain these 14 sections in this exact sequence:

### 1. Exam Question Scenario

```markdown
## Exam Question

> **Exam**: [EXAM] — [Domain]

[Paste verbatim exam question with all answer options. Do NOT reveal the correct answer.]
```

- Include the complete question text verbatim
- List all answer options (A, B, C, D or Yes/No)
- Do NOT indicate which answer is correct in this section

### 2. Solution Architecture

```markdown
## Solution Architecture

[2-4 sentences describing the architecture and design decisions.]
```

### 3. Architecture Diagram

```markdown
## Architecture Diagram

\`\`\`mermaid
graph TD
    A[Resource Group] --> B[Resource 1]
    A --> C[Resource 2]
\`\`\`
```

- **Required** when 2+ interconnected resources are deployed
- Use Mermaid `graph TD` (top-down) or `graph LR` (left-right)
- Include resource names matching governance naming conventions
- Show dependencies and relationships

### 4. Lab Objectives

```markdown
## Lab Objectives

1. [Objective 1]
2. [Objective 2]
3. [Objective 3]
```

- Include 3–5 specific, measurable objectives
- Align with the exam question's focus areas

### 5. Lab Structure

```markdown
## Lab Structure

\`\`\`
lab-<topic>/
├── README.md
├── terraform/
│   ├── main.tf
│   └── ...
└── validation/
\`\`\`
```

- Show the actual file tree of the lab

### 6. Prerequisites

```markdown
## Prerequisites

- Azure subscription with required permissions
- Azure CLI installed and authenticated
- Terraform >= 1.0 installed (or Bicep tools)
- PowerShell 7+ with Az module
```

### 7. Deployment

```markdown
## Deployment

\`\`\`bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply
\`\`\`
```

- Keep deployment instructions brief
- Include validation sequence: validate → capacity test (if needed) → plan → apply

### 8. Testing the Solution

```markdown
## Testing the Solution

[Step-by-step validation instructions with specific commands or portal checks.]
```

- Provide concrete, actionable testing steps
- Include expected outcomes

### 9. Cleanup

```markdown
## Cleanup

\`\`\`bash
terraform destroy -auto-approve
\`\`\`

> Destroy within 7 days per governance policy.
```

- Include the 7-day cleanup reminder
- Note purge requirements for soft-delete resources

### 10. Scenario Analysis

```markdown
## Scenario Analysis

### Correct Answer: [Letter]

[Explain why this is correct.]

### Why Other Options Are Incorrect

- **[Option A]**: [Reasoning]
- **[Option B]**: [Reasoning]
- **[Option C]**: [Reasoning]
```

- Reveal and explain the correct answer
- Provide reasoning for every incorrect option

### 11. Key Learning Points

```markdown
## Key Learning Points

1. [Point 1]
2. [Point 2]
3. [Point 3]
4. [Point 4]
5. [Point 5]
```

- Include 5–8 concise, actionable learning points
- Focus on exam-relevant knowledge

### 12. Related Objectives

```markdown
## Related [EXAM] Objectives

- [Objective reference 1]
- [Objective reference 2]
```

### 13. Additional Resources

```markdown
## Additional Resources

- [Resource 1](URL)
- [Resource 2](URL)
```

- Link to official Microsoft documentation
- Include relevant Learn modules or training paths

### 14. Related Labs

```markdown
## Related Labs

- [Related Lab 1](relative-path) — Brief description
```

- Link 0–2 related labs using relative paths
- Use format: `▶ Related Lab: [lab-folder-name](../../domain/lab-folder-name/README.md)`

## Rules

- **Do NOT include a code header block** in the README
- **Correct answer is only revealed in Section 10** (Scenario Analysis), never in Section 1
- All sections must appear even if brief
- Use Mermaid diagrams only when meaningful (2+ interconnected resources)
- Deployment instructions reference the validation sequence
