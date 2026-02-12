---
name: Lab
description: Creates a hands-on lab from an exam question scenario using Terraform or Bicep, following governance standards
---

# Hands-on Lab Generator

Create a working, validated hands-on lab from an exam-question scenario using the **most appropriate deployment method**, strictly compliant with `GOVERNANCE.md` (workspace root). Treat `GOVERNANCE.md` as the single source of truth for naming, tagging, locations, versions, structure, and deployment standards.

## Deployment method evaluation

**Analyze the exam question to determine the best-fit deployment method. Preference order: IaaC > Scripted > Manual (UI).**

### When to use Infrastructure as Code (Terraform or Bicep) - **PREFERRED**

Use when:

* Question involves deploying/provisioning Azure resources
* Scenario requires repeatable infrastructure deployment
* Focus is on resource configuration and architecture
* Example: "Deploy a VM with specific networking configuration"

### When to use Scripted (PowerShell/Azure CLI)

Use when:

* Question explicitly asks for command sequences
* Scenario involves imperative operations or workflows
* Focus is on operational tasks, not resource provisioning
* Example: "Run these commands to configure deployment slots" or "Prepare App Service for republication"

### When to use Manual (Portal/UI)

Use when:

* Question tests knowledge of Azure Portal navigation
* Scenario requires interactive UI features (e.g., specific portal blades)
* Focus is on understanding portal workflows
* Example: "Configure monitoring alerts through Azure Portal"

**Default to IaaC unless the exam question clearly requires scripting or manual steps.**

### IaaC choice selection

When IaaC is determined to be the appropriate deployment method, **ask the user** whether they want to use:

* **Terraform**, or
* **Bicep**

Do not assume or auto-select between Terraform and Bicep—always prompt for user preference.

## Non-negotiables

### Bicep wrapper script

* For **Bicep labs only**: **Do not create or modify** `bicep.ps1`.
* **Always copy** it from: `.assets/shared/bicep/bicep.ps1` (workspace root) into the lab's `bicep/` folder.

### README.md rules

* README must use the **required section set** in the order specified below.

**README required sections (in this order)**

* Exam Question Scenario (verbatim options, **DO NOT mark or reveal the correct answer**)
* Solution Architecture
* Architecture Diagram (Mermaid) **only if** 3+ interconnected resources
* Lab Objectives (3–5)
* Lab Structure (directory tree showing key files - **keep brief**)
* Prerequisites
* Deployment (deployment commands/steps - **keep brief**)
* Testing the Solution (validation steps, not deployment steps)
* Cleanup (teardown commands/steps - **keep brief**)
* Scenario Analysis (explain correct answer and why other options are wrong)
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

### For IaaC labs (Terraform or Bicep)

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

### For Scripted labs (PowerShell/Azure CLI)

```
lab-<topic>/
├── README.md
├── scripts/
│   ├── deploy.ps1 OR deploy.sh
│   ├── config.ps1 OR config.sh   # if needed
│   └── cleanup.ps1 OR cleanup.sh
└── validation/
    └── test-*.ps1          # optional
```

### For Manual labs (Portal/UI)

```
lab-<topic>/
├── README.md
└── screenshots/            # optional, if helpful
    └── step-*.png
```

## Required header block (code files only)

Include a header block at the top of all **code files** (Terraform `.tf`, Bicep `.bicep`, PowerShell `.ps1`).

**Do NOT include header blocks in README.md or other markdown documentation files.**

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

## Subscription validation (all modalities)

**All labs must validate deployment to the correct lab subscription before provisioning resources.**

Lab Subscription ID: `e091f6e7-031a-4924-97bb-8c983ca5d21a`

* **Terraform**: Include in `terraform.tfvars` as `lab_subscription_id` variable
* **Bicep**: Validate subscription context in deployment script or parameter file
* **Scripted**: Include subscription validation in deploy script before resource creation

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
* Include subscription ID validation in deployment wrapper or parameter file:
  * Validate current Azure context targets `e091f6e7-031a-4924-97bb-8c983ca5d21a`

## Common Azure configuration pitfalls (apply when relevant)

When the lab includes these patterns, enforce them to avoid deployment failure:

* Standard LB with outbound rules sharing frontend IP: set `disableOutboundSnat` / `disable_outbound_snat = true`
* VM NIC with instance public IP cannot be in outbound-rule backend pool: split inbound/outbound pools

## Validation requirements (must run and capture output)

### For IaaC labs

**Terraform:**

* `Use-AzProfile Lab`
* `Test-Path terraform.tfvars`
* `terraform init`
* `terraform validate`
* `terraform fmt`
* `terraform plan`

**Bicep:**

* `Use-AzProfile Lab`
* `.\bicep.ps1 validate`
* `.\bicep.ps1 plan`

### For Scripted labs

Run and include output:

* `Use-AzProfile Lab`
* Subscription validation: Verify script checks for lab subscription ID `e091f6e7-031a-4924-97bb-8c983ca5d21a`
* PowerShell: `Test-ScriptFileInfo -Path .\scripts\deploy.ps1` (if using script metadata)
* Syntax validation: `Get-Command .\scripts\deploy.ps1 -Syntax`
* Dry-run validation (use `-WhatIf` where supported or echo-mode execution)

**Required subscription check pattern for PowerShell scripts:**

```powershell
function Confirm-LabSubscription {
    $expectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
    $currentSubscription = (Get-AzContext).Subscription.Id
    
    if ($currentSubscription -ne $expectedSubscriptionId) {
        Write-Error "Not connected to lab subscription. Expected: $expectedSubscriptionId, Current: $currentSubscription"
        exit 1
    }
}
```

## Final response format

1. **Deployment Method Decision** (explain why IaaC/Scripted/Manual was chosen)
2. Lab Summary
3. File List (paths)
4. Validation Results (command output)
5. README Compliance confirmation (all required sections present in correct order)
6. Governance Compliance confirmation (explicitly state you followed GOVERNANCE.md)

## Invocation examples

* "Create a hands-on lab for this <EXAM> question: …" (auto-selects method)
* "Create a Terraform hands-on lab for this <EXAM> question: …" (force IaaC)
* "Create a scripted hands-on lab for this <EXAM> question: …" (force scripted)
* "Create a Bicep hands-on lab for this <EXAM> question: …" (force Bicep)

```
