---
name: azure-lab-governance
description: Governance policy for Azure hands-on labs — enforces naming conventions, required tags, region rules, cost guardrails, README structure, Terraform standards, Bicep standards, soft-delete/purge management, and code quality for AI-102 and AZ-104 exam labs.
---

# Azure Lab Governance Skill

## When to Use

This skill applies to any task involving:

- Creating, reviewing, or modifying hands-on labs (Terraform, Bicep, Scripted, Manual)
- Validating lab compliance with naming, tagging, region, or cost standards
- Generating README documentation for labs
- Reviewing lab code for governance adherence

## How to Apply

1. **Load the full policy** from [Governance-Lab.md](Governance-Lab.md) in this skill folder (authoritative copy mirrors workspace root)
2. **Enforce all rules** — governance is mandatory, not advisory
3. **Report violations** as PASS/FAIL with specific rule references

## Quick Reference

### Naming

- **Resource Group**: `<exam>-<domain>-<topic>-<deployment>` (e.g., `az104-networking-vnet-peering-tf`)
- **Resources**: `<type>-<topic>[-instance]` using standard prefixes
- **Bicep Stacks**: `stack-<domain>-<topic>` (no exam code)

### Required Tags (All Resources)

| Tag              | Rule                                      |
| ---------------- | ----------------------------------------- |
| Environment      | Always `Lab`                              |
| Project          | `AI-102` or `AZ-104` (uppercase)          |
| Domain           | e.g., Networking, Storage, Generative AI  |
| Purpose          | Descriptive (e.g., VNet Peering)          |
| Owner            | `Greg Tate`                               |
| DateCreated      | Static `YYYY-MM-DD` — no dynamic functions |
| DeploymentMethod | `Terraform` or `Bicep`                    |

### Regions

- Default: `eastus`
- Fallback: `westus2` → `eastus2` → `centralus`
- Only US regions allowed

### Deployment Method Priority

**IaaC > Scripted > Manual** — always prefer IaaC unless clearly inappropriate.
If IaaC, **ask user**: Terraform or Bicep (never auto-select).

### Validation Sequence (IaaC)

1. Design — identify all Azure services
2. Code — implement configuration
3. Validate Syntax — `terraform validate` or `bicep build`
4. Regional Capacity Test — for constrained services
5. Final Validation — `terraform plan` or deployment preview

### Soft-Delete & Purge

Resources requiring purge attention: Cognitive Services (48h), Key Vault (7-90d), API Management (48h), Recovery Vault (14d).
Disable soft-delete at creation when possible.

### README Sections (Exact Order)

1. Exam Question Scenario
2. Solution Architecture
3. Architecture Diagram (Mermaid if 2+ interconnected resources)
4. Lab Objectives
5. Lab Structure
6. Prerequisites
7. Deployment
8. Testing the Solution
9. Cleanup
10. Scenario Analysis
11. Key Learning Points
12. Related Objectives
13. Additional Resources
14. Related Labs

### Code Standards

- Header block in all `.tf`, `.bicep`, `.ps1` files
- AzureRM provider by default; AzAPI only if needed
- Modules when 2+ related resource types
- Local state only; `.tfstate*` in `.gitignore`
- Lab-safe passwords via `hashicorp/random`

### Cost Guardrails

- Use lowest viable SKUs (VM: `Standard_B2s`, Storage: Standard LRS)
- Max per lab: 4 VMs, 5 Public IPs, 3 Storage Accounts, 4 VNets
- Destroy within 7 days; track via `DateCreated`

## Full Policy

For complete details on any rule, consult [Governance-Lab.md](Governance-Lab.md) in this skill folder.
