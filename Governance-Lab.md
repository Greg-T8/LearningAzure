# Hands-On Labs Governance Policy

Standards for all Terraform and Bicep labs (AI-102, AZ-104).

`Governance-Lab.md` remains the authoritative implementation standard.

---

## 1. Core Policies

### 1.1 Location

| Setting          | Value                               |
| ---------------- | ----------------------------------- |
| Default Region   | `eastus`                            |
| Fallback Regions | `westus2`, `eastus2`, `centralus`   |
| Allowed Regions  | Any US region                       |

Use `eastus` unless capacity requires fallback.

---

### 1.2 Required Tags (All Resources)

> `DateCreated` must be static (no `timestamp()` / `utcNow()`).

| Tag              | Example           |
| ---------------- | ----------------- |
| Environment      | Lab               |
| Project          | AI-102 / AZ-104   |
| Domain           | Networking        |
| Purpose          | VNet Peering      |
| Owner            | Greg Tate         |
| DateCreated      | 2026-02-09        |
| DeploymentMethod | Terraform / Bicep |

---

## 2. Naming Standards

### 2.1 Resource Group

Pattern:

```
<exam>-<domain>-<topic>-<deployment>
```

Examples:

* `az104-networking-vnet-peering-tf`
* `ai102-generative-ai-dalle-image-gen-bicep`

---

## 2.2 Resource Naming

Pattern:

```
<type>-<topic>[-instance]
```

### Common Prefixes (AZ-104)

| Resource       | Prefix                       |
| -------------- | ---------------------------- |
| VNet           | vnet                         |
| Subnet         | snet                         |
| NSG            | nsg                          |
| VM             | vm                           |
| Storage        | st<exam><topic> (no hyphens) |
| Load Balancer  | lb                           |
| Key Vault      | kv                           |
| Log Analytics  | law                          |
| Recovery Vault | rsv                          |

---

#### AI-102 Prefixes

| Resource            | Prefix          |
| ------------------- | --------------- |
| OpenAI              | oai             |
| Multi-service       | cog             |
| Vision              | cv              |
| Language            | lang            |
| AI Search           | srch            |
| Deployment          | deploy          |
| Cosmos DB           | cosmos          |
| Storage (AI output) | st<exam><topic> |

OpenAI accounts require random suffix for global uniqueness.

---

### 2.3 Bicep Stack Naming

```
stack-<domain>-<topic>
```

No exam code in stack name.

---

## 3. Cost Governance

### 3.1 Cleanup Policy

* Destroy within 7 days
* Track via `DateCreated`
* Reference labs must justify permanence in README

---

### 3.2 Resource Limits (Per Lab)

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

### 3.3 Default SKUs

#### Infrastructure

| Resource      | Default                    |
| ------------- | -------------------------- |
| VM            | Standard_B2s (B1s minimal) |
| Storage       | Standard LRS               |
| Load Balancer | Basic                      |
| Public IP     | Basic                      |
| SQL           | Basic / S0                 |
| Disk          | Standard HDD               |

---

#### AI Services

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

Start free when available.

---

## 4. Soft-Delete & Purge Management

### 4.1 Resources Requiring Purge

| Resource           | Retention | Manual Purge |
| ------------------ | --------- | ------------ |
| Cognitive Services | 48 hrs    | Yes          |
| Key Vault          | 7–90 days | Yes          |
| API Management     | 48 hrs    | Yes          |
| Recovery Vault     | 14 days   | Yes          |
| App Insights       | 14 days   | No           |
| Log Analytics      | 14 days   | No           |

If not purgeable → use unique naming.

---

### 4.2 Disable Soft-Delete (When Possible)

Disable soft-delete during creation:

Terraform:

```
soft_delete_enabled = false
purge_soft_delete_on_destroy = true
```

Bicep:

```
softDeleteState: 'Disabled'
```

---

## 5. Code Standards

### 5.1 Header Block (All Code Files)

```
# -------------------------------------------------------------------------
# Program: filename
# Description: purpose
# Context: EXAM Lab - scenario
# Author: Greg Tate
# Date: YYYY-MM-DD
# -------------------------------------------------------------------------
```

---

### 5.2 Commenting Rules

* Comment above logical code blocks
* Describe intent, not syntax
* Use descriptive naming

---

### 5.3 Language Conventions

| Tool        | Style            |
| ----------- | ---------------- |
| Terraform   | snake_case       |
| Bicep       | camelCase params |
| Azure Names | Prefix standards |

---

## 6. Documentation Requirements

Each lab must include:

1. Lab Overview
2. Exam Objective reference
3. Prerequisites
4. Deployment steps
5. Validation steps
6. Cleanup steps
7. AI labs: sample API calls
8. Troubleshooting (if needed)

---

## 7. Terraform Standards

### 7.1 Provider

Use **AzureRM** by default.
Use azure/AzAPI only if azure/AzureRM lacks required feature.

Required:

```hcl
required_version = ">= 1.0"
azurerm ~> 4.0
random ~> 3.0
```

#### Lab Environment Configuration

For lab environments, configure provider to allow resource group deletion even if resources remain:

```hcl
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.lab_subscription_id
}
```

This ensures `terraform destroy` can complete even if orphaned resources exist.

---

### 7.2 State

* Local state only
* `.tfstate*` in `.gitignore`

---

### 7.3 Required terraform.tfvars

```hcl
lab_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"
location            = "eastus"
owner               = "Greg Tate"
date_created        = "YYYY-MM-DD"
```

Never store secrets.

---

### 7.4 Modules

Use modules when 2+ related resources.

Principles:

* Domain grouping (one concern per module)
* Self-contained with clear inputs/outputs
* Pass `common_tags` and identity references
* Thin orchestration layer in `main.tf`

Module organization takes precedence over inline dependency wiring. Pass `principal_id` as input for RBAC assignments within modules.

Example structure:

```
modules/
├── ai-foundry/      # AI Services, monitoring
├── storage/         # Storage Account
├── ai-search/       # AI Search + role assignments
├── cosmos-db/       # Cosmos DB + role assignments
├── key-vault/       # Key Vault
└── orchestration/   # Project, connections, capability hosts
```

---

### 7.5 Password Generation (Lab-Safe)

Use `hashicorp/random`.

Pattern example:

```
AzureLab2026!
```

Must:

* Meet complexity
* Output as sensitive
* Never defined as input variable

---

## 8. Bicep Standards

### 8.1 Required Files

```
main.bicep
main.bicepparam
bicep.ps1 (copied from shared)
bicepconfig.json
```

---

### 8.2 Deployment Script

* Must copy shared `bicep.ps1`
* Use stack deployments
* Allowed commands: validate, plan, apply, destroy, show, list

#### Lab Environment Cleanup

The `destroy` command must include `--force-deletion-types` to ensure complete resource group cleanup:

```powershell
az stack sub delete --name $stackName --yes --force-deletion-types $forceTypes
```

Wrapper script handles orphaned resources automatically.

---

### 8.3 Modules

Use when 2+ related resources.

* Self-contained
* Pass `commonTags`
* Thin `main.bicep`

---

### 8.4 Password Pattern

```
AzureLab2026!
```

Output for testing.
Production → Key Vault.

---

## 9. Azure Configuration Guardrails

### 9.1 AI Deployment Patterns

#### OpenAI Multi-Model

Single account, multiple deployments (GPT-4 + embeddings).

#### Multi-Service Cognitive

One account serving Vision, Language, Speech.

#### Custom Vision

Separate Training + Prediction resources.

---

### 9.2 Load Balancer SNAT

If frontend used for inbound + outbound rules:

```
disableOutboundSnat = true
```

---

### 9.3 NIC + Public IP + Outbound Rule Conflict

NIC with instance public IP cannot join outbound backend pool.

---

### 9.4 Storage Containers (Terraform)

Use:

```
storage_account_id
```

Not `storage_account_name`.

---

### 9.5 AI Services

* Enable public network access (lab only)
* Validate model availability per region
* Start with minimal capacity
* Output keys as sensitive

---

### 9.6 AI Agent Service RBAC

Requires both:

* Data plane roles
* Control plane roles (e.g., Cosmos DB Operator)

Missing control-plane role causes capability host failure.

---

## 10. Pre-Deployment Checklist (Condensed)

### Naming

* RG matches pattern
* Prefix standards used
* Stack naming correct (Bicep)

### Tagging

* All required tags
* Uppercase Project
* Static DateCreated

### Region & SKU

* US region
* Capacity validated (AI/Search/Cosmos/GPU)
* Cost-appropriate SKUs

### Documentation

* README complete
* Deployment + validation steps
* Cleanup documented

### Code

* Header included
* AzureRM provider used
* Version constraints defined
* Secrets handled properly

### Testing

* Deploy validated
* AI endpoints tested (if applicable)
* Destroy verified
* No orphaned resources

---
