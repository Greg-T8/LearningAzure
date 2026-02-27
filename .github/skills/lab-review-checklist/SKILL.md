---
name: lab-review-checklist
description: 10-category compliance checklist and evaluation procedure for lab review. All check items reference shared-contract requirement IDs.
user-invokable: false
---

# Lab Review Checklist

Compliance checklist and evaluation procedure for validating generated lab content. Report format is defined in `shared-contract` R-014.

## When to Use

- Reviewing generated lab files before delivery
- Auditing existing labs for compliance
- Re-validating after remediation

---

## R-150: 10-Category Checklist

### Category 1: Naming Compliance

- [ ] Resource group follows `shared-contract` R-001
- [ ] Resources use correct prefixes per `shared-contract` R-002 / R-003
- [ ] Bicep stack name (if applicable) per `shared-contract` R-004
- [ ] No naming convention violations
- [ ] All resource names referenced in README match names defined in IaC code per `shared-contract` R-027
- [ ] All resource names defined in IaC code match names referenced in README per `shared-contract` R-027

### Category 2: Required Tags

- [ ] All 7 tags present per `shared-contract` R-005
- [ ] `Project` is uppercase
- [ ] `DateCreated` is static (no dynamic functions)
- [ ] `Environment` is `Lab`
- [ ] `DeploymentMethod` matches actual method

### Category 3: Region Rules

- [ ] Default region is `eastus` per `shared-contract` R-006
- [ ] Only US regions used
- [ ] Fallback chain documented if non-default region

### Category 4: README Structure

- [ ] All 14 sections present per `shared-contract` R-011
- [ ] Sections in correct order
- [ ] Mermaid diagram present when required per `shared-contract` R-013
- [ ] Correct answer NOT in Section 1, only in Section 10 (per `lab-readme-authoring` R-142)

### Category 5: Validation Sequence

- [ ] Syntax validation step present per `shared-contract` R-018
- [ ] Regional capacity test present for constrained services per `shared-contract` R-019
- [ ] Final validation step present
- [ ] Steps in correct order

### Category 6: Code Quality

- [ ] Header block in all code files per `shared-contract` R-012
- [ ] Header includes: Program, Description, Context, Author, Date
- [ ] No header in README (per `lab-readme-authoring` R-142)
- [ ] Correct provider/version constraints (per `terraform-scaffolding` R-120 or Bicep equivalents)
- [ ] Local state only (no remote backend)
- [ ] Secrets handled properly
- [ ] Sensitive outputs marked

### Category 7: Module Structure

- [ ] Modules used when 2+ types per `shared-contract` R-022
- [ ] One concern per module
- [ ] Thin root orchestration
- [ ] Tags passed to all modules per `shared-contract` R-023
- [ ] No anti-pattern: unrelated resources in one module

### Category 8: Cost & Limits

- [ ] SKUs match `shared-contract` R-007 / R-008
- [ ] Resource counts within `shared-contract` R-009
- [ ] Cleanup references 7-day policy per `shared-contract` R-015

### Category 9: Soft-Delete & Purge

- [ ] Soft-delete disabled where possible per `shared-contract` R-016
- [ ] Purge flags set for applicable resources
- [ ] Purge documented in cleanup section
- [ ] Unique naming for non-purgeable resources

### Category 10: Subscription Validation

- [ ] Lab subscription ID correct per `shared-contract` R-020
- [ ] Terraform: ID in `terraform.tfvars`
- [ ] Bicep: subscription context validated
- [ ] Validation script checks subscription

---

## R-151: Review Procedure

1. Read all generated files in the lab folder.
2. Evaluate every item in each of the 10 categories.
3. Mark PASS or FAIL with a specific explanation.
4. Produce report per `shared-contract` R-014.

---

## R-152: Evaluation Rules

- A single FAIL in categories 1, 2, 4, or 5 → overall FAIL (critical).
- FAILs in categories 3, 6–10 → overall FAIL.
- Every FAIL must include actionable fix instructions.
- Do not approve labs that skip capacity validation for services in `shared-contract` R-019.

---

## R-153: When-to-Use Criteria

Use this skill when reviewing generated lab content for governance compliance.
