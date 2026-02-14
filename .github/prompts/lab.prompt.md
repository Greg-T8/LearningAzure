---
name: Lab
description: Generates a governance-compliant hands-on lab from an exam scenario
agent: Lab-Orchestrator
tools:
  - agent
---

# Hands-on Lab Generator

Create a fully working hands-on lab from an exam scenario.

Paste the exam question below and the Lab Orchestrator will:

1. **Plan** — Analyze the scenario, extract metadata, design architecture (via `lab-planning` skill)
2. **Select method** — Choose deployment method (IaaC > Scripted > Manual) and ask you to pick Terraform or Bicep
3. **Build** — Generate all code and documentation (via `terraform-scaffolding` / `bicep-scaffolding` and `lab-readme-authoring` skills)
4. **Review** — Validate governance compliance (via `lab-review-checklist` skill)
5. **Finalize** — Deliver the complete lab with a summary

All standards enforced by the `azure-lab-governance` skill.

---

## 6. Cost Guardrails

Default to lowest viable SKU:

* VM → `Standard_B2s` (or B1s if sufficient)
* Storage → Standard LRS
* Lowest App Service / SQL tier unless required

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
  * apply
  * destroy
  * show
  * list
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
