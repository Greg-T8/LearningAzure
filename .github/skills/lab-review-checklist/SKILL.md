---
name: lab-review-checklist
description: 'Validate hands-on lab content against governance compliance standards. Checks naming, tags, regions, README structure, code quality, module organization, cost limits, and soft-delete configuration. Use when reviewing a lab for compliance, running a governance audit, or performing quality control on generated lab code.'
user-invokable: false
---

# Lab Review Checklist

Compliance validation checklist for generated lab content. Evaluates all content against the `azure-lab-governance` skill standards and returns a structured PASS/FAIL report.

## When to Use

- Reviewing generated lab files for governance compliance
- Performing a quality gate before delivering a lab
- Auditing existing labs for standards adherence
- Validating a lab after remediation fixes

## Review Process

Evaluate every item below. For each, report **PASS** or **FAIL** with a specific explanation.

### 1. Naming Compliance

- [ ] Resource group follows pattern: `<exam>-<domain>-<topic>-<deployment>`
- [ ] Resources use correct prefix per governance tables
- [ ] Bicep stack name (if applicable): `stack-<domain>-<topic>` (no exam code)
- [ ] No naming convention violations

### 2. Required Tags

- [ ] All 7 required tags present on every resource: `Environment`, `Project`, `Domain`, `Purpose`, `Owner`, `DateCreated`, `DeploymentMethod`
- [ ] `Project` is uppercase (`AI-102`, `AZ-104`)
- [ ] `DateCreated` is static (no `timestamp()`, no `utcNow()`)
- [ ] `Environment` is `Lab`
- [ ] `DeploymentMethod` matches actual method

### 3. Region Rules

- [ ] Default region is `eastus`
- [ ] Only US regions used
- [ ] Fallback chain documented if non-default region used

### 4. README Structure

Verify all 14 sections exist in this exact order:

1. [ ] Exam Question Scenario (verbatim options, correct answer NOT revealed in this section)
2. [ ] Solution Architecture
3. [ ] Architecture Diagram (Mermaid present if 2+ interconnected resources)
4. [ ] Lab Objectives (3–5 items)
5. [ ] Lab Structure (file tree)
6. [ ] Prerequisites
7. [ ] Deployment
8. [ ] Testing the Solution
9. [ ] Cleanup
10. [ ] Scenario Analysis (correct + incorrect reasoning)
11. [ ] Key Learning Points (5–8 items)
12. [ ] Related Objectives
13. [ ] Additional Resources
14. [ ] Related Labs

### 5. Validation Sequence (IaaC Labs)

- [ ] Syntax validation step present (`terraform validate` or `bicep build`)
- [ ] Regional capacity test step present (for constrained services)
- [ ] Final validation step present (`terraform plan` or deployment preview)
- [ ] Steps are in correct order: validate → capacity → plan

### 6. Code Quality

- [ ] Header block present in ALL code files (`.tf`, `.bicep`, `.ps1`)
- [ ] Header includes: Program, Description, Context, Author, Date
- [ ] No header block in README
- [ ] Correct provider/version constraints (AzureRM ~> 4.0, Terraform >= 1.0)
- [ ] Local state only (no remote backend configured)
- [ ] Secrets handled properly (no hardcoded credentials)
- [ ] Sensitive outputs marked correctly

### 7. Module Structure

- [ ] Modules used when 2+ resource types deployed
- [ ] One concern per module (domain grouping)
- [ ] Thin root orchestration (resource group + module calls only)
- [ ] `common_tags` / `commonTags` passed to all modules
- [ ] No anti-pattern: unrelated resources in single module

### 8. Cost & Limits

- [ ] SKUs are governance-compliant defaults (lowest viable)
- [ ] Per-lab resource limits not exceeded (4 VMs, 5 Public IPs, 3 Storage, 4 VNets)
- [ ] Cleanup instructions reference 7-day policy

### 9. Soft-Delete & Purge

- [ ] Soft-delete disabled at creation where possible
- [ ] Purge-on-destroy flags set for applicable resources
- [ ] Purge considerations documented in cleanup section
- [ ] Unique naming used for non-purgeable resources (if applicable)

### 10. Subscription Validation

- [ ] Lab subscription ID referenced: `e091f6e7-031a-4924-97bb-8c983ca5d21a`
- [ ] Terraform: subscription ID in `terraform.tfvars`
- [ ] Bicep: subscription context validated
- [ ] Validation script checks subscription context

## Output Format

Return a structured report:

```
## Review Summary
- Overall: [PASS | FAIL]
- Checks Passed: [X/Y]
- Critical Violations: [count]

## Detailed Results

### [Category Name]
- [Check]: PASS
- [Check]: FAIL — [specific issue and fix]

## Required Fixes (if FAIL)
1. [File]: [exact change needed]
2. [File]: [exact change needed]
```

## Rules

- **Be strict** — governance is mandatory, not advisory
- A single FAIL in any critical category (naming, tags, README order, validation sequence) fails the entire review
- Provide **actionable fix instructions**, not just violations
- Do not approve labs that skip regional capacity validation for constrained services
- Maximum 2 remediation cycles before escalating to the user
