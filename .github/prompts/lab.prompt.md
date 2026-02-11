---
name: Lab
description: Creates a hands-on lab from an exam question scenario using Terraform or Bicep, following governance standards
---

# Hands-on Lab Generator

Create a working, validated hands-on lab from an exam-question scenario using **Terraform or Bicep**, strictly compliant with `GOVERNANCE.md` (workspace root). Treat `GOVERNANCE.md` as the single source of truth for naming, tagging, locations, versions, structure, and deployment standards.

## Non-negotiables

### Bicep wrapper script

* For **Bicep labs only**: **Do not create or modify** `bicep.ps1`.
* **Always copy** it from: `<EXAM>/hands-on-labs/_shared/bicep/bicep.ps1` into the lab’s `bicep/` folder.

### README.md rules

* README must use the **required section set** and **must not** include:

  * Deployment commands (Terraform/Bicep/Az CLI/PowerShell)
  * Cleanup/teardown commands or sections
  * “Deployment Steps”, “Cleanup”, “Lab Structure” directory trees

**README required sections**

* Exam Question Scenario (verbatim, incl. options)
* Scenario Analysis
* Solution Architecture
* Architecture Diagram (Mermaid) **only if** 3+ interconnected resources
* Lab Objectives (3–5)
* Prerequisites
* Testing the Solution (validation steps, not deployment steps)
* Key Learning Points (5–8)
* Related <EXAM> Exam Objectives
* Additional Resources
* Related Labs (0–2, ▶ inline link format)

## Determine exam and lab context

1. Determine `<EXAM>` from workspace path (e.g., `AZ-104`, `AI-102`). If unclear, ask which exam.
2. Use:

   * `<EXAM>` (e.g., `AZ-104`)
   * `<exam-prefix>` lowercase (e.g., `az104`)
3. Confirm exam support constraints by checking `GOVERNANCE.md` (if it limits supported exams/domains).

## Cost guardrails (default to cheapest viable)

Use the smallest SKU/tier that meets the scenario intent:

* VM default: `Standard_B2s` (use `Standard_B1s` if clearly sufficient)
* Storage: Standard LRS unless required otherwise
* Prefer lowest tiers for App Service / SQL unless requirements demand more

If a higher-cost resource is required, explain why in README (architecture/analysis), not as a deployment instruction.

## Lab folder structure

Create under:
`<EXAM>/hands-on-labs/<domain>/lab-<topic>/`

```
lab-<topic>/
├── README.md
├── terraform/ OR bicep/
│   ├── main.*              # orchestration only
│   ├── variables.* / params
│   ├── outputs.*
│   ├── providers.tf        # terraform only
│   ├── terraform.tfvars    # terraform only (lab subscription id)
│   └── modules/            # when applicable
└── validation/
    └── test-*.ps1          # optional
```

## Required header block (all files)

Include a header block at top of every created file:

```
# -------------------------------------------------------------------------
# Program: [filename]
# Description: [what this does]
# Context: <EXAM> Lab - [scenario description]
# Author: Greg Tate
# Date: [YYYY-MM-DD]
# -------------------------------------------------------------------------
```

## Governance compliance

* Follow `GOVERNANCE.md` for:

  * Resource group naming
  * Resource naming prefixes
  * Required tags (all required tags on all resources)
  * Allowed regions/locations
  * Terraform/Bicep standards (providers/versions/state conventions, etc.)

## Terraform-specific rules (when Terraform chosen)

* `terraform.tfvars` must exist and include:

  * `lab_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"`
* Use modules when there are **3+ related resources** in a logical grouping.
* Generate “friendly” admin passwords (lab-acceptable):

  * Use `hashicorp/random` (e.g., `random_integer`) and output as `sensitive = true`.

## Bicep-specific rules (when Bicep chosen)

* Use `main.bicep` + `main.bicepparam`.
* Use modules when there are **3+ related resources** in logical grouping.
* Copy shared `bicep.ps1` exactly (non-negotiable).
* Use wrapper actions only: `validate`, `plan`, `apply`, `destroy`, `show`, `list`.

## Common Azure configuration pitfalls (apply when relevant)

When the lab includes these patterns, enforce them to avoid deployment failure:

* Standard LB with outbound rules sharing frontend IP: set `disableOutboundSnat` / `disable_outbound_snat = true`
* VM NIC with instance public IP cannot be in outbound-rule backend pool: split inbound/outbound pools

## Validation requirements (must run and capture output)

### Terraform

Run and include output:

* `Use-AzProfile Lab`
* `Test-Path terraform.tfvars`
* `terraform init`
* `terraform validate`
* `terraform fmt`
* `terraform plan`

### Bicep

Run and include output:

* `Use-AzProfile Lab`
* `.\bicep.ps1 validate`
* `.\bicep.ps1 plan`

## Output package (assistant response)

Provide:

1. Lab Summary
2. File List (paths)
3. Validation Results (command output)
4. README Compliance confirmation (required sections present; forbidden content absent)
5. Governance Compliance confirmation (explicitly state you followed GOVERNANCE.md)

**Do not** include “Quick Start deployment steps” in the response if you want strict consistency with “no deployment procedures” guidance. If you want a Quick Start, keep it to **references** (e.g., “Use the standard procedure in GOVERNANCE.md”) with no commands.

## Invocation examples

* “Create a Terraform hands-on lab for this <EXAM> question: …”
* “Create a Bicep hands-on lab for this <EXAM> question: …”

```
