---
name: LabPrompt
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
3. Architecture Diagram (Mermaid if 2+ interconnected resources)
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

**Testing the Solution Note:** Split code blocks by step, allowing screenshot insertion between each step.

Example:

```powershell
# 1. Verify resource
$resource = Get-Az... 
$resource.Property  # Expected value
```
<!-- Screenshot -->
<img src='.img/example_screenshot.png' width=700>

```powershell
# 2. Verify next configuration
$config = Get-Az...
```

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
* Bastion → Developer or Basic SKU
* Lowest App Service / SQL tier unless required

**Remote Access:** Prefer bastion service over public IPs for VM access. Use public IPs only when solution explicitly requires external connectivity (load balancer frontend, NAT gateway, exam scenario requires it).

If higher tier required, explain in README analysis (not deployment steps).

---

## 7. Deployment Platform Rules

Rules specific to IaaC and scripted deployment platforms.

Use the Microsoft Docs MCP for the latest guidance on API requirements.

### Required Workflow Order (IaaC)

All Infrastructure as Code labs must follow this sequence:

1. **Design** — Complete architecture design and identify all Azure services
2. **Code** — Implement Terraform/Bicep configuration with modules
3. **Validate Syntax** — Run `terraform validate` or `bicep build` to verify syntax
4. **Regional Capacity Test** — Perform capacity validation for services listed in Section 10
5. **Final Validation** — Run `terraform plan` or deployment preview to verify end-to-end configuration

**Do not skip Step 4** for labs deploying capacity-constrained services (see Section 10 for the authoritative list). Discovering regional capacity issues after completing code wastes time and may require region changes or SKU adjustments.

---

### 7.1 Terraform

* `terraform.tfvars` must include lab subscription ID
* Provider must set `prevent_deletion_if_contains_resources = false` for lab cleanup
* Use modules when deploying multiple resource types
* Use `hashicorp/random` for lab-safe passwords
* Output sensitive values properly

#### Required Validation Sequence

```
Use-AzProfile Lab
Test-Path terraform.tfvars
terraform init
terraform validate
terraform fmt
# Perform regional capacity tests here (Section 10) before final plan
terraform plan
```

**Note:** Regional capacity testing must occur after `terraform validate` and before `terraform plan` for labs with capacity-constrained services (see Section 10 for the list).

### 7.2 Bicep

* Use `main.bicep` + `main.bicepparam`
* Use modules when deploying multiple resource types
* Copy shared `bicep.ps1` (do not modify)
* Only allowed wrapper actions:

  * validate
  * plan
  * show
  * list
  * output
* Validate subscription context

#### Required Validation Sequence

```
Use-AzProfile Lab
.\bicep.ps1 validate
# Perform regional capacity tests here (Section 10) before plan
.\bicep.ps1 plan
```

**Note:** Regional capacity testing must occur after `bicep.ps1 validate` and before `bicep.ps1 plan` for labs with capacity-constrained services (see Section 10 for the list).

---

## 8. Scripted Validation

Must include and capture:

```
Use-AzProfile Lab
Subscription validation check
Test-ScriptFileInfo
Get-Command -Syntax
-WhatIf or dry-run
```

---

## 9. Common Azure Pitfalls

Follow `Governance-Lab.md` for:

* Load balancer SNAT
* NIC/backend pool rules
* AI RBAC requirements
* Preview resource recovery
* Validation script practices

All governance standards are mandatory.

---

## 10. Regional Validation

For labs deploying regionally constrained services, verify provider availability in target region before deployment.

Check provider availability:

```powershell
# Cosmos DB
az provider show --namespace Microsoft.DocumentDB `
    --query "resourceTypes[?resourceType=='databaseAccounts'].locations[]"

# AI Search
az provider show --namespace Microsoft.Search `
    --query "resourceTypes[?resourceType=='searchServices'].locations[]"

# OpenAI
az provider show --namespace Microsoft.CognitiveServices `
    --query "resourceTypes[?resourceType=='accounts'].locations[]"
```

If target region unavailable, use fallback regions: westus2 → eastus2 → centralus.

Update `terraform.tfvars` or `main.bicepparam` with chosen region and document in README.

---

## 11. Final Response Format

Respond with:

1. Deployment Method Decision
2. Lab Summary
3. File List
4. Validation Results
5. README Compliance Confirmation
6. Governance Compliance Confirmation

---

## 12. Invocation Examples

* Create a hands-on lab for this `<EXAM>` question: …
* Create a Terraform hands-on lab for this `<EXAM>` question: …
* Create a scripted hands-on lab for this `<EXAM>` question: …
* Create a Bicep hands-on lab for this `<EXAM>` question: …

---
