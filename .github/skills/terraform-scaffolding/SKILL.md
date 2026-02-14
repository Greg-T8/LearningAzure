---
name: terraform-scaffolding
description: 'Generate governance-compliant Terraform code for Azure hands-on labs. Provides provider configuration, module patterns, naming conventions, password generation, SKU defaults, and soft-delete settings. Use when building Terraform labs, generating .tf files, or scaffolding Terraform module structure for AI-102 or AZ-104.'
user-invokable: false
---

# Terraform Scaffolding

Terraform-specific code generation patterns, templates, and conventions for Azure hands-on labs. All generated code must comply with the `azure-lab-governance` skill.

## When to Use

- Generating Terraform code for a lab
- Scaffolding a new Terraform lab from a plan
- Creating Terraform modules for Azure resources
- Configuring providers, state, and variables
- Applying naming, tagging, password, and SKU patterns in Terraform

## Templates

Starter templates are in the `azure-lab-governance` skill at:
`.github/skills/azure-lab-governance/templates/terraform-module.stub/`

Files: `main.tf`, `variables.tf`, `outputs.tf`, `providers.tf`, `terraform.tfvars`

Use these as the starting point for every new lab. Replace `<EXAM>`, `<Domain>`, `<topic>`, `<scenario>`, and `<YYYY-MM-DD>` placeholders.

## Provider & Version Configuration

Every `providers.tf` must contain:

```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.lab_subscription_id
}
```

## State Management

- **Local state only** — never configure remote backend
- `.tfstate*` must be in `.gitignore`

## Required File Structure

Every Terraform lab must include:

| File | Purpose |
|------|---------|
| `providers.tf` | Provider and version configuration |
| `main.tf` | Thin orchestration: locals, resource group, module calls |
| `variables.tf` | Input variables (always include `lab_subscription_id`, `location`, `owner`, `date_created`) |
| `outputs.tf` | Useful outputs (resource group name, key endpoints) |
| `terraform.tfvars` | Pre-populated with lab subscription ID and defaults |

## Module Rules

- Create modules when 2+ related resource types exist
- One concern per module (domain grouping)
- Each module gets: `main.tf`, `variables.tf`, `outputs.tf`
- Pass `common_tags` map to all modules
- Pass identity references (e.g., `principal_id`) as explicit inputs for RBAC
- Root `main.tf` contains **only orchestration** — no resource definitions except the resource group

## Header Block

Include in ALL `.tf` files:

```
# -------------------------------------------------------------------------
# Program: [filename]
# Description: [purpose]
# Context: [EXAM] Lab - [scenario]
# Author: Greg Tate
# Date: [YYYY-MM-DD]
# -------------------------------------------------------------------------
```

## Naming & Tags

- Resource group: `<exam>-<domain>-<topic>-tf`
- Resources: `<type>-<topic>[-instance]` per governance prefix tables
- All resources must include the 7 required tags via `common_tags`
- `DateCreated` must be a static string (never use `timestamp()`)

Common tags pattern in `main.tf`:

```hcl
locals {
  resource_group_name = "<exam>-<domain>-<topic>-tf"

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

## Password Generation (Lab-Safe)

Use `hashicorp/random` for passwords. Never define passwords as input variables.

```hcl
resource "random_password" "admin" {
  length           = 16
  special          = true
  override_special = "!@#$%"
}
```

Pattern: `AzureLab2026!` style — must meet Azure complexity requirements.
Output as `sensitive = true`.

## Default SKUs

| Resource | Default |
|----------|---------|
| VM | `Standard_B2s` (or `Standard_B1s` if sufficient) |
| Storage | Standard LRS |
| Load Balancer | Basic |
| Public IP | Basic |
| SQL | Basic / S0 |
| Disk | Standard HDD |
| OpenAI | S0 |
| Cognitive Services | F0 → S0 |
| Computer Vision | F0 |
| Language | F0 |
| Speech | F0 |
| AI Search | Free / Basic |

## Soft-Delete Configuration

Disable soft-delete at creation for lab resources:

```hcl
soft_delete_enabled               = false
purge_soft_delete_on_destroy      = true
permanently_delete_on_destroy     = true   # Log Analytics
purge_protected_items_from_vault_on_destroy = true  # Recovery Vault
```

## Storage Containers

Always use `storage_account_id` (not `storage_account_name`):

```hcl
resource "azurerm_storage_container" "example" {
  name               = "content"
  storage_account_id = azurerm_storage_account.example.id
}
```

## Validation Script

Generate a PowerShell validation script in `validation/` that:

- Confirms lab subscription context (reference `Confirm-LabSubscription` from governance skill)
- Validates deployed resources exist
- Tests key functionality (endpoints, connectivity)
- Uses the `$Main` / `$Helpers` script pattern

## terraform.tfvars

Always pre-populate:

```hcl
lab_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"
location            = "eastus"
owner               = "Greg Tate"
date_created        = "<YYYY-MM-DD>"
```
