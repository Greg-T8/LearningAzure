---
name: azure-lab-governance
description: Template and script inventory for Azure hands-on labs. All cross-cutting rules are in the shared-contract skill.
---

# Azure Lab Governance

Physical templates and scripts for lab scaffolding. All rules (naming, tags, regions, SKUs, etc.) are defined in the `shared-contract` skill — this skill is an inventory of starter files only.

For the full Azure governance policy document, see `Governance-Lab.md` at the workspace root.

---

## R-160: Template Inventory

### Terraform Starter

Path: `.github/skills/azure-lab-governance/templates/terraform-module.stub/`

| File              | Contents                                    |
| ----------------- | ------------------------------------------- |
| `main.tf`         | Locals, resource group, module call stubs   |
| `variables.tf`    | Standard input variables                    |
| `outputs.tf`      | Resource group name output                  |
| `providers.tf`    | AzureRM + random provider config            |
| `terraform.tfvars`| Pre-populated defaults                      |

### Bicep Starter

Path: `.github/skills/azure-lab-governance/templates/bicep-module.stub/`

| File              | Contents                                     |
| ----------------- | -------------------------------------------- |
| `main.bicep`      | Root module with subscription scope, tags, RG |
| `main.bicepparam` | Pre-populated parameters                     |

### README Template

Path: `.github/skills/azure-lab-governance/templates/README.template.md`

14-section skeleton matching `shared-contract` R-011.

---

## R-161: Script Inventory

### Confirm-LabSubscription.ps1

Path: `.github/skills/azure-lab-governance/scripts/Confirm-LabSubscription.ps1`

Pre-deployment guardrail that validates the active Azure subscription matches the lab subscription (`shared-contract` R-020).

---

## R-162: Governance-Lab.md Reference

Full Azure governance policy: `Governance-Lab.md` at workspace root.

This is the authoritative document for Azure-specific implementation details beyond what the `shared-contract` covers (e.g., detailed Azure service behavior, SNAT edge cases, NIC conflict specifics).
