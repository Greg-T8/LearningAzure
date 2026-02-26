# Hands-On Labs Governance Policy

Standards for all Terraform and Bicep labs (AI-102, AZ-104).

`Governance-Lab.md` remains the authoritative implementation standard.

---

## 1. Core Policies

### 1.1 Location

| Setting          | Value                               |
| ---------------- | ----------------------------------- |
| Default Region   | `centralus`                         |
| Fallback Regions | `eastus2`, `westus2`, `northcentralus` |
| Allowed Regions  | Any US region                       |

Use `centralus` unless capacity requires fallback.

**Important:** Central US supports Bastion Developer SKU. If deploying Bastion in a different region, verify it supports Developer SKU at <https://learn.microsoft.com/en-us/azure/bastion/quickstart-host-portal?tabs=developer>

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

**Note:** Resources with purge protection (§4.1) require unique names with random suffix.

---

#### Unique Naming Decision Tree

Use random suffixes when resources require global uniqueness or cannot be immediately recreated.

**Decision criteria (check in order):**

1. **Global uniqueness required?** (Storage, Key Vault, OpenAI) → **Use random suffix**
2. **Soft-delete cannot be disabled?** (Cognitive Services, API Management) → **Use random suffix**
3. **Backup items block deletion?** (Recovery Vault with protected VMs) → **Use random suffix**
4. **Otherwise** → No random suffix needed

**Random suffix format:**

- **Bicep:** `${resourcePrefix}-${topic}-${uniqueString(resourceGroup().id)}`
- **Terraform:** `${resourcePrefix}-${topic}-${random_string.suffix.result}`
- **Length:** 4 lowercase alphanumeric characters
- **Examples:** `rsv-vm-file-recovery-7k3m`, `kv-app-secrets-9x2p`, `oai-dalle-gen-4h8n`

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

#### Remote Access

| Service        | Default              |
| -------------- | -------------------- |
| Bastion        | Developer (Required) |
| Public IP      | Only when required   |

**Deploy Azure Bastion for all VM labs and use Bastion Developer SKU for each VM.**

---

### 3.4 Auto-Shutdown Schedule

Enable daily auto-shutdown on all VMs to control costs:

- **Time:** 8:00 AM Central Time
- **Timezone:** Central Standard Time
- **Notification:** Disabled (for lab environments)

Terraform: Use `azurerm_dev_test_global_vm_shutdown_schedule` resource.
Bicep: Use `Microsoft.DevTestLab/schedules` (namespace: microsoft.devtestlab/schedules).

---

## 4. Soft-Delete & Purge Management

### 4.1 Soft-Delete Retention Periods

| Resource           | Retention | Manual Purge | Unique Name Required |
| ------------------ | --------- | ------------ | -------------------- |
| Cognitive Services | 48 hrs    | Yes          | Yes (soft-delete)    |
| Key Vault          | 7–90 days | Yes          | Yes (soft-delete)    |
| API Management     | 48 hrs    | Yes          | Yes (soft-delete)    |
| Recovery Vault     | 14 days   | Yes          | Yes (backup items)*  |
| App Insights       | 14 days   | No           | No (disable soft-delete) |
| Log Analytics      | 14 days   | No           | No (disable soft-delete) |

*Recovery Vault requires unique naming even with soft-delete disabled because backup items can prevent immediate re-creation.

**Refer to §2.2 Unique Naming Decision Tree for complete criteria.**

---

### 4.2 Disable Soft-Delete (When Possible)

Disable soft-delete during creation:

Terraform:

```
soft_delete_enabled = false
purge_soft_delete_on_destroy = false                   # Unique names eliminate need to purge; false speeds up destroy
purge_protected_items_from_vault_on_destroy = true     # For Recovery Vault
permanently_delete_on_destroy = true                   # For Log Analytics
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

#### Provider Deprecation Guidance

When using `azurerm_key_vault`, use:

```hcl
rbac_authorization_enabled = true|false
```

Do not use the deprecated `enable_rbac_authorization` argument.

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

**Design prioritizations:**

* Structure over speed — proper organization enables lab reuse
* Domain separation — each Azure resource type is a distinct module
* Explicit wiring — parameter passing documents dependencies

Example structure:

```
modules/
├── ai-foundry/      # AI Services, monitoring
├── storage/         # Storage Account + RBAC
├── ai-search/       # AI Search + RBAC
├── cosmos-db/       # Cosmos DB + RBAC
├── key-vault/       # Key Vault
└── orchestration/   # Project, connections, capability hosts
```

**Anti-pattern:** Consolidating BYO resources (Storage, Cosmos, Search) into a single module with AI Foundry. Keep resource domains separate.

#### Bastion Dependency Ordering (Required)

When deploying Azure Bastion, enforce explicit orchestration ordering so Bastion is created only after VNet/subnet resources are fully provisioned (Succeeded state).

Terraform pattern:

```hcl
module "compute" {
  # ...
  depends_on = [module.networking]
}
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

#### Bastion Dependency Ordering (Required)

When deploying Azure Bastion in Bicep, declare explicit `dependsOn` so Bastion deployment waits for networking modules/resources to complete.

Bicep pattern:

```bicep
resource bastion 'Microsoft.Network/bastionHosts@2024-10-01' = {
  name: bastionName
  # ...
  dependsOn: [
    networkingModule
  ]
}
```

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

### 9.7 Cloud-Init Best Practices

#### Use Array Form for runcmd

Always use array form for `runcmd` entries to prevent YAML parsing issues with colons and special characters:

**Correct:**

```yaml
runcmd:
  - [ bash, -lc, 'mkdir -p /var/www/html' ]
  - [ bash, -lc, 'echo "<h1>Hello from $(hostname)</h1><p>Private IP: $(hostname -I | awk ''{print $1}'')</p>" > /var/www/html/index.html' ]
  - [ systemctl, enable, nginx ]
  - [ systemctl, restart, nginx ]
```

**Avoid (string form with colons):**

```yaml
runcmd:
  - echo "Text with: colon" > file.txt  # May parse as key:value
```

#### Key Points

* Unquoted `:` in string-form commands can be misinterpreted as YAML mappings
* Array form `[ bash, -lc, '...' ]` ensures shell expansion and avoids YAML pitfalls
* In YAML single-quoted strings, escape literal `'` by doubling: `''{print $1}''`
* Include `mkdir -p` commands to ensure directories exist before writing files
* Validate with `sudo cloud-init schema --system` after deployment

---

### 9.8 Remote Access Strategy

**Bastion is required for VM remote access in all labs:**

* Deploy Azure Bastion whenever a VM is deployed
* Use **Developer SKU** for each VM access scenario
* Do not use Basic SKU for standard lab VM access

**Public IP usage policy:**

* Public IPs only when solution explicitly requires external access
* Reduces cost (no per-VM public IP charges)
* Improves security (no direct internet exposure)

**Bastion Developer SKU requirements:**

* Only available in select regions (see §1.1 Location)
* Default region (Central US) supports Developer SKU
* If using a different region, verify support: <https://learn.microsoft.com/en-us/azure/bastion/quickstart-host-portal?tabs=developer>
* If Developer SKU is unsupported, move the lab to a supported US region

**When public IP is appropriate:**

* Load balancer frontend (required for inbound traffic)
* NAT Gateway (required for outbound scenarios)
* Application Gateway / Front Door (web traffic)
* Exam scenario explicitly tests public IP configuration

For all other VM access scenarios, use bastion.

---

### 9.9 Recovery Services Vault — Instant Restore Point Collection

Azure Backup always creates a separate resource group for instant restore point collections. By default this is `AzureBackupRG_<Geo>_<number>`. Control the name via the backup policy.

**Requirement:** Set `instantRPDetails.azureBackupRGNamePrefix` to keep the restore point RG identifiable alongside the lab RG.

**Pattern:** `<lab-resource-group>-rpc-` → Azure appends `1`, yielding `<lab-resource-group>-rpc-1`.

**Bicep:**

```bicep
instantRPDetails: {
  azureBackupRGNamePrefix: '${resourceGroupName}-rpc-'
}
```

**Cleanup:** This RG is created by the Backup service at runtime and is outside the deployment stack — delete it manually after destroy. Document in the lab README.

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
* Bastion Developer SKU configured for all VM labs

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
