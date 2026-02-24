---
name: shared-contract
description: Single source of truth for cross-cutting rules referenced by all agents and skills in the lab pipeline. Every requirement has a unique ID (R-0xx).
---

# Shared Contract

Authoritative cross-cutting rules for the hands-on lab pipeline. Every requirement is identified by a unique ID (`R-0xx`). Other files **MUST** reference these IDs — never restate the rule.

For the full Azure governance implementation policy, see `Governance-Lab.md` at the workspace root.

---

## R-001: Resource Group Naming

Pattern: `<exam>-<domain>-<topic>-<deployment>`

- `<exam>`: lowercase exam code (`az104`, `ai102`)
- `<domain>`: lowercase domain slug (e.g., `networking`, `storage`, `generative-ai`)
- `<topic>`: lowercase topic slug (e.g., `vnet-peering`, `blob-versioning`)
- `<deployment>`: `tf` | `bicep` | `scripted`

Example: `az104-networking-vnet-peering-tf`

---

## R-002: Resource Naming — AZ-104 Prefixes

Pattern: `<prefix>-<topic>[-instance]`

| Resource       | Prefix                       |
| -------------- | ---------------------------- |
| VNet           | vnet                         |
| Subnet         | snet                         |
| NSG            | nsg                          |
| VM             | vm                           |
| Storage        | st\<exam\>\<topic\> (no hyphens) |
| Load Balancer  | lb                           |
| Key Vault      | kv                           |
| Log Analytics  | law                          |
| Recovery Vault | rsv                          |

---

## R-003: Resource Naming — AI-102 Prefixes

| Resource            | Prefix          |
| ------------------- | --------------- |
| OpenAI              | oai             |
| Multi-service       | cog             |
| Vision              | cv              |
| Language            | lang            |
| AI Search           | srch            |
| Deployment          | deploy          |
| Cosmos DB           | cosmos          |
| Storage (AI output) | st\<exam\>\<topic\> |

OpenAI accounts require random suffix for global uniqueness.

---

## R-004: Bicep Stack Naming

Pattern: `stack-<domain>-<topic>`

No exam code in stack name.

---

## R-005: Required Tags (All Resources)

| Tag              | Rule                                                        |
| ---------------- | ----------------------------------------------------------- |
| Environment      | Always `Lab`                                                |
| Project          | Uppercase: `AI-102` or `AZ-104`                             |
| Domain           | e.g., Networking, Storage, Generative AI                    |
| Purpose          | Descriptive (e.g., VNet Peering)                            |
| Owner            | `Greg Tate`                                                 |
| DateCreated      | Static `YYYY-MM-DD` — no `timestamp()` / `utcNow()`        |
| DeploymentMethod | `Terraform` or `Bicep`                                      |

---

## R-006: Region Rules

| Setting          | Value                             |
| ---------------- | --------------------------------- |
| Default          | `eastus`                          |
| Fallback         | `westus2` → `eastus2` → `centralus` |
| Allowed          | Any US region                     |

Use `eastus` unless capacity requires fallback.

---

## R-007: Infrastructure SKU Defaults

| Resource      | Default                        |
| ------------- | ------------------------------ |
| VM            | Standard_B2s (B1s if sufficient) |
| Storage       | Standard LRS                   |
| Load Balancer | Basic                          |
| Public IP     | Basic                          |
| SQL           | Basic / S0                     |
| Disk          | Standard HDD                   |

---

## R-008: AI Service SKU Defaults

| Service            | Default      |
| ------------------ | ------------ |
| OpenAI             | S0           |
| Cognitive Services | F0 → S0      |
| Computer Vision    | F0           |
| Custom Vision      | F0           |
| Language           | F0           |
| Translator         | F0           |
| Speech             | F0           |
| Form Recognizer    | F0           |
| AI Search          | Free / Basic |

Start free tier when available.

---

## R-009: Per-Lab Resource Limits

| Resource           | Max |
| ------------------ | --- |
| VMs                | 4   |
| Public IPs         | 5   |
| Storage Accounts   | 3   |
| VNets              | 4   |
| OpenAI Accounts    | 2   |
| Cognitive Accounts | 3   |
| Model Deployments  | 4   |

---

## R-010: Lab Folder Structure

### IaaC (Terraform)

```
<EXAM>/hands-on-labs/<domain>/lab-<topic>/
├── README.md
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── terraform.tfvars
│   └── modules/
│       └── <module>/
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
└── validation/
    └── <validation-script>.ps1
```

### IaaC (Bicep)

```
<EXAM>/hands-on-labs/<domain>/lab-<topic>/
├── README.md
├── bicep/
│   ├── main.bicep
│   ├── main.bicepparam
│   ├── bicepconfig.json
│   ├── bicep.ps1
│   └── modules/
│       └── <module>.bicep
└── validation/
    └── <validation-script>.ps1
```

### Scripted

```
<EXAM>/hands-on-labs/<domain>/lab-<topic>/
├── README.md
├── scripts/
│   ├── deploy.*
│   ├── config.* (if needed)
│   └── cleanup.*
└── validation/
```

### Manual

```
<EXAM>/hands-on-labs/<domain>/lab-<topic>/
├── README.md
└── screenshots/ (optional)
```

---

## R-011: README 14-Section Order

Every lab README must contain these sections in this exact sequence:

1. Exam Question Scenario
2. Solution Architecture
3. Architecture Diagram
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

---

## R-012: Code Header Block

Include in **all** `.tf`, `.bicep`, `.ps1` files. Do **NOT** include in README.

```
# -------------------------------------------------------------------------
# Program: [filename]
# Description: [purpose]
# Context: [EXAM] Lab - [scenario]
# Author: Greg Tate
# Date: [YYYY-MM-DD]
# -------------------------------------------------------------------------
```

Use `//` for `.bicep` files, `#` for `.tf` and `.ps1`.

---

## R-013: Mermaid Diagram Criteria

- **Always required** — every lab README must include a Mermaid diagram
- When 2+ interconnected resources are deployed, diagram the resource topology (dependencies, network paths, data flow)
- When fewer than 2 interconnected resources, diagram the **overall process** reflective of the exam question (e.g., data flow from source → service → output, access methods, decision paths)
- Use `graph TD` (top-down) for hierarchical layouts or `graph LR` (left-right) for pipeline / process flows
- Resource names must match governance naming conventions
- Show dependencies and relationships

---

## R-014: Review Report Schema

```
## Review Summary
- Overall: [PASS | FAIL]
- Checks Passed: [X/Y]
- Critical Violations: [count]

## Detailed Results

### [Category Name]
- [Check]: PASS
- [Check]: FAIL — [issue and fix]

## Required Fixes (if FAIL)
1. [File]: [exact change]
```

---

## R-015: Cleanup Policy

- Destroy lab resources within 7 days
- Track via `DateCreated` tag
- README cleanup section must reference 7-day policy
- Reference labs must justify permanence in README

---

## R-016: Soft-Delete / Purge

### Resources Requiring Purge

| Resource           | Retention | Manual Purge |
| ------------------ | --------- | ------------ |
| Cognitive Services | 48 hrs    | Yes          |
| Key Vault          | 7–90 days | Yes          |
| API Management     | 48 hrs    | Yes          |
| Recovery Vault     | 14 days   | Yes          |
| App Insights       | 14 days   | No           |
| Log Analytics      | 14 days   | No           |

If not purgeable → use unique naming.

### Disable Patterns

**Terraform:**

```hcl
soft_delete_enabled                          = false
purge_soft_delete_on_destroy                 = false   # Unique names eliminate need to purge; false speeds up destroy
permanently_delete_on_destroy                = true    # Log Analytics
purge_protected_items_from_vault_on_destroy  = true    # Recovery Vault
```

**Bicep:**

```bicep
softDeleteState: 'Disabled'
```

---

## R-017: Deployment Method Priority

**IaaC > Scripted > Manual**

| Method                   | Use When                                                    |
| ------------------------ | ----------------------------------------------------------- |
| IaaC (Terraform / Bicep) | Deploying Azure resources, architecture focus, repeatable   |
| Scripted (PowerShell/CLI)| Imperative workflows, operational focus                     |
| Manual (Portal / UI)     | Portal navigation is tested, UI-centric                     |

If IaaC, **always ask user** to choose Terraform or Bicep. Never auto-select.

---

## R-018: IaaC Validation Sequence

1. Validate Syntax — `terraform validate` or `bicep build`
2. Regional Capacity Test — for constrained services (see R-019)
3. Final Validation — `terraform plan` or deployment preview

**Terraform:**

```
Use-AzProfile Lab
Test-Path terraform.tfvars
terraform init
terraform validate
terraform fmt
# Capacity tests here (R-019)
terraform plan
```

**Bicep:**

```
Use-AzProfile Lab
.\bicep.ps1 validate
# Capacity tests here (R-019)
.\bicep.ps1 plan
```

---

## R-019: Capacity-Constrained Services

Services requiring regional capacity validation before deployment:

- Cosmos DB (`Microsoft.DocumentDB`)
- AI Search (`Microsoft.Search`)
- OpenAI / Cognitive Services (`Microsoft.CognitiveServices`)

Validation commands:

```powershell
az provider show --namespace Microsoft.DocumentDB `
    --query "resourceTypes[?resourceType=='databaseAccounts'].locations[]"

az provider show --namespace Microsoft.Search `
    --query "resourceTypes[?resourceType=='searchServices'].locations[]"

az provider show --namespace Microsoft.CognitiveServices `
    --query "resourceTypes[?resourceType=='accounts'].locations[]"
```

If unavailable, use fallback regions per R-006.

---

## R-020: Lab Subscription

```
e091f6e7-031a-4924-97bb-8c983ca5d21a
```

Must appear in:

- `terraform.tfvars` → `lab_subscription_id`
- Bicep → subscription context validation
- Validation scripts → subscription check

---

## R-021: Language Style Conventions

| Tool        | Style            |
| ----------- | ---------------- |
| Terraform   | snake_case       |
| Bicep       | camelCase params |
| Azure Names | Prefix standards per R-002 / R-003 |

---

## R-022: Module Rule

Use modules when 2+ related resource types are deployed.

- Domain grouping (one concern per module)
- Self-contained with clear inputs/outputs
- Pass `common_tags` (TF) / `commonTags` (Bicep) to all modules
- Pass identity references (e.g., `principal_id`) as explicit inputs for RBAC
- Thin orchestration in root `main.tf` / `main.bicep`
- **Anti-pattern**: consolidating unrelated resource types into a single module

---

## R-023: Common Tags Variable Pattern

**Terraform:**

```hcl
locals {
  common_tags = {
    Environment      = "Lab"
    Project          = "<EXAM>"
    Domain           = "<Domain>"
    Purpose          = "<Purpose>"
    Owner            = var.owner
    DateCreated      = var.date_created
    DeploymentMethod = "Terraform"
  }
}
```

**Bicep:**

```bicep
var commonTags = {
  Environment: 'Lab'
  Project: '<EXAM>'
  Domain: '<Domain>'
  Purpose: '<Purpose>'
  Owner: owner
  DateCreated: dateCreated
  DeploymentMethod: 'Bicep'
}
```

---

## R-024: Password Generation

Must meet Azure complexity. Never define as input variable. Output as sensitive.

**Terraform:** Use `hashicorp/random`.

```hcl
resource "random_password" "admin" {
  length           = 16
  special          = true
  override_special = "!@#$%"
}
```

**Bicep:** Use `uniqueString()` or static pattern. Mark `@secure()`.

Target pattern: `AzureLab2026!`

---

## R-025: Azure Configuration Guardrails

- **Load Balancer SNAT**: Set `disableOutboundSnat = true` when frontend used for inbound + outbound
- **NIC + Public IP**: NIC with instance public IP cannot join outbound backend pool
- **Storage Containers (TF)**: Use `storage_account_id` not `storage_account_name`
- **AI Services**: Enable public network access for labs; validate model availability per region; start minimal capacity; output keys as sensitive
- **AI Agent RBAC**: Requires both data plane + control plane roles (e.g., Cosmos DB Operator)

For full details, see `Governance-Lab.md` at the workspace root.
