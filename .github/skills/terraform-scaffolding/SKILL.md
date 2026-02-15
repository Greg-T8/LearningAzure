---
name: terraform-scaffolding
description: Terraform code generation procedures and patterns for Azure hands-on labs. Cross-cutting rules are in the shared-contract skill.
---

# Terraform Scaffolding

Terraform-specific code generation procedures. All cross-cutting rules (naming, tags, SKUs, regions, limits) are defined in the `shared-contract` skill — reference by ID, do not restate.

## When to Use

- Generating Terraform code for a lab
- Scaffolding a new Terraform module structure
- Applying Terraform-specific patterns (provider, state, passwords, soft-delete)

---

## Starter Templates

Located in `azure-lab-governance` skill (see R-160):
`.github/skills/azure-lab-governance/templates/terraform-module.stub/`

Files: `main.tf`, `variables.tf`, `outputs.tf`, `providers.tf`, `terraform.tfvars`

---

## R-120: Provider / Version Configuration

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

Use AzureRM by default. Use AzAPI only if AzureRM lacks a required feature.

---

## R-121: State Management

- Local state only — never configure remote backend.
- Ensure `.tfstate*` is in `.gitignore`.

---

## R-122: Required File Structure

| File              | Content                                                                     |
| ----------------- | --------------------------------------------------------------------------- |
| `providers.tf`    | Per R-120                                                                   |
| `main.tf`         | Thin orchestration: locals, resource group, module calls. Tags per `shared-contract` R-023 |
| `variables.tf`    | Must include: `lab_subscription_id`, `location`, `owner`, `date_created`    |
| `outputs.tf`      | Resource group name, key endpoints, sensitive values                        |
| `terraform.tfvars`| Per R-125                                                                   |

---

## R-123: Module File Pattern

Each module directory contains:

- `main.tf` — resource definitions
- `variables.tf` — inputs (must accept `tags` map + resource IDs from other modules)
- `outputs.tf` — resource IDs, endpoints, principal IDs

Module organization rules: see `shared-contract` R-022.

---

## R-124: Password Generation

See `shared-contract` R-024 for the canonical pattern and rules. Terraform implementation uses `hashicorp/random`. Never define passwords as input variables. Output as `sensitive = true`.

---

## R-125: terraform.tfvars Template

```hcl
lab_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"
location            = "eastus"
owner               = "Greg Tate"
date_created        = "<YYYY-MM-DD>"
```

Subscription ID: see `shared-contract` R-020.

---

## R-126: Soft-Delete Implementation

See `shared-contract` R-016 for the resource table and Terraform disable patterns. Apply those settings to all resources in the R-016 table that are deployed in the lab.

---

## R-127: Storage Container Pattern

See `shared-contract` R-025. Always use `storage_account_id` (not `storage_account_name`):

```hcl
resource "azurerm_storage_container" "example" {
  name               = "content"
  storage_account_id = azurerm_storage_account.example.id
}
```

---

## R-128: Validation Script Pattern

Generate a PowerShell script in `validation/` that:

1. Sources `Confirm-LabSubscription` from the `azure-lab-governance` skill (see R-161).
2. Validates deployed resources exist (using `Get-AzResource` or `az resource list`).
3. Tests key functionality (endpoints, connectivity).
4. Uses the `$Main` / `$Helpers` script block pattern.
5. Includes code header per `shared-contract` R-012.
