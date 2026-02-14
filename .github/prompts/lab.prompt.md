---
name: Lab
description: Generates a governance-compliant hands-on lab from an exam scenario using Terraform, Bicep, Scripted, or Manual methods
---

# Hands-on Lab Generator

Create a fully working lab from an exam scenario using the **most appropriate deployment method**, strictly aligned to `Governance-Lab.md` (workspace root).
`Governance-Lab.md` is the single source of truth for naming, tagging, regions, versions, and standards.

---

## 1. Deployment Method Selection

Evaluate the scenario and choose the best-fit method.

### Priority Order

**IaaC > Scripted > Manual (Portal/UI)**
Default to IaaC unless clearly inappropriate.

### Infrastructure as Code (Preferred)

Use when:

* Deploying Azure resources
* Architecture/configuration focus
* Repeatable provisioning required

Examples:

* Deploy VM with networking
* Provision App Service + SQL

#### IaaC Choice (Mandatory Prompt)

Ask user to choose:

* Terraform
* Bicep

Do not auto-select.

---

### Scripted (PowerShell/Azure CLI)

Use when:

* Question explicitly requires commands
* Imperative workflows/configuration
* Operational focus

---

### Manual (Portal/UI)

Use when:

* Portal navigation is tested
* UI workflows are core to the question

---

## 2. Mandatory Standards

### Governance

All labs must follow `Governance-Lab.md` for:

* Naming conventions
* Resource group patterns
* Required tags (on all resources)
* Allowed regions
* Provider/version/state standards
* Configuration best practices

---

### Subscription Validation (All Labs)

Must validate deployment to:

```
e091f6e7-031a-4924-97bb-8c983ca5d21a
```

* Terraform → `terraform.tfvars` variable
* Bicep → validate in wrapper or param file
* Scripted → validate before resource creation

Required PowerShell pattern:

```powershell
function Confirm-LabSubscription {
    $expectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
    $currentSubscription = (Get-AzContext).Subscription.Id
    
    if ($currentSubscription -ne $expectedSubscriptionId) {
        Write-Error "Not connected to lab subscription."
        exit 1
    }
}
```

---

## 3. README Requirements (Exact Order)

README must contain:

1. Exam Question Scenario (verbatim options, no correct answer revealed)
2. Solution Architecture
3. Architecture Diagram (Mermaid if 3+ interconnected resources)
4. Lab Objectives (3–5)
5. Lab Structure (brief tree)
6. Prerequisites
7. Deployment (brief)
8. Testing the Solution
9. Cleanup (brief)
10. Scenario Analysis (correct + incorrect reasoning)
11. Key Learning Points (5–8)
12. Related `<EXAM>` Objectives
13. Additional Resources
14. Related Labs (0–2)

---

## 4. Folder Structure

Create under:

```
<EXAM>/hands-on-labs/<domain>/lab-<topic>/
```

### IaaC

```
lab-<topic>/
├── README.md
├── terraform/ OR bicep/
│   ├── main.*
│   ├── variables.* / params
│   ├── outputs.*
│   ├── providers.tf (Terraform)
│   ├── terraform.tfvars (Terraform)
│   └── modules/ (if needed)
└── validation/
```

Use modules when deploying multiple resource types.

---

### Scripted

```
lab-<topic>/
├── README.md
├── scripts/
│   ├── deploy.*
│   ├── config.* (if needed)
│   └── cleanup.*
└── validation/
```

---

### Manual

```
lab-<topic>/
├── README.md
└── screenshots/ (optional)
```

---

## 5. Code Header Block (Code Files Only)

Include in `.tf`, `.bicep`, `.ps1`:

```
# -------------------------------------------------------------------------
# Program: [filename]
# Description: [purpose]
# Context: <EXAM> Lab - [scenario]
# Author: Greg Tate
# Date: [YYYY-MM-DD]
# -------------------------------------------------------------------------
```

Do not include in README.

---

## 6. Cost Guardrails

Default to lowest viable SKU:

* VM → `Standard_B2s` (or B1s if sufficient)
* Storage → Standard LRS
* Lowest App Service / SQL tier unless required

If higher tier required, explain in README analysis (not deployment steps).

---

## 7. Regional Validation (After Architecture Design, Before Code)

**Prerequisites**: Complete architecture design. Identify ALL Azure services needed before validating.

Before deployment, confirm region supports:

* All required services and SKUs
* All models (if AI)
* **Subscription capacity** (Cosmos DB, specialized services often constrained)
* All preview features

Regional validation is **mandatory** before ANY deployment phase.

### Three-Step Validation Process

#### Step 1: Provider & Service Registration

```powershell
# Verify each service is available in region via provider manifest
$services = @("Microsoft.CognitiveServices", "Microsoft.DocumentDB", "Microsoft.Search")
foreach ($provider in $services) {
    $locations = az provider show --namespace $provider `
        --query "resourceTypes[*].locations[]" -o tsv
    if ($locations -match $region) { Write-Host "✅ Available" }
}
```

#### Step 2: Deployment Capacity Test

For services with strict quota limits (Cosmos DB, AI Search, OpenAI), test capacity via dry-run or validation API before actual deployment:

```powershell
# Catch ServiceUnavailable / quota errors in pre-check
az deployment group validate --resource-group test-rg --template-file main.bicep
```

#### Step 3: Region Fallback Logic

If Step 2 fails with `ServiceUnavailable` or quota error:

1. Try next approved region (westus2 → eastus2 → centralus)
2. Update variable file (terraform.tfvars or bicep params)
3. Rerun validation
4. Document chosen region and validation date in README

Create a **validation script** (`validate-regional-capacity.ps1` or equivalent) that:

* Checks provider registration
* Tests deployment capacity
* Auto-updates config if fallback succeeds
* Documents which region was validated

Region is **not final** until all services validate together in Step 2.

---

## 8. Terraform Rules

* `terraform.tfvars` must include lab subscription ID
* Use modules when deploying multiple resource types
* Use `hashicorp/random` for lab-safe passwords
* Output sensitive values properly

### Required Validation Commands

```
Use-AzProfile Lab
Test-Path terraform.tfvars
terraform init
terraform validate
terraform fmt
terraform plan
```

---

## 9. Bicep Rules

* Use `main.bicep` + `main.bicepparam`
* Use modules when deploying multiple resource types
* Copy shared `bicep.ps1` (do not modify)
* Only allowed wrapper actions:

  * validate
  * plan
  * apply
  * destroy
  * show
  * list
* Validate subscription context

### Required Commands

```
Use-AzProfile Lab
.\bicep.ps1 validate
.\bicep.ps1 plan
```

---

## 10. Scripted Validation

Must include and capture:

```
Use-AzProfile Lab
Subscription validation check
Test-ScriptFileInfo
Get-Command -Syntax
-WhatIf or dry-run
```

---

## 11. Common Azure Pitfalls

Follow `Governance-Lab.md` for:

* Load balancer SNAT
* NIC/backend pool rules
* AI RBAC requirements
* Preview resource recovery
* Validation script practices

All governance standards are mandatory.

---

## 12. Final Response Format

Respond with:

1. Deployment Method Decision
2. Lab Summary
3. File List
4. Validation Results
5. README Compliance Confirmation
6. Governance Compliance Confirmation

---

## 13. Invocation Examples

* Create a hands-on lab for this `<EXAM>` question: …
* Create a Terraform hands-on lab for this `<EXAM>` question: …
* Create a scripted hands-on lab for this `<EXAM>` question: …
* Create a Bicep hands-on lab for this `<EXAM>` question: …

---
