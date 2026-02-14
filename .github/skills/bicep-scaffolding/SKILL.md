---
name: bicep-scaffolding
description: 'Generate governance-compliant Bicep code for Azure hands-on labs. Provides module patterns, stack naming, parameter conventions, deployment wrapper, and cleanup configuration. Use when building Bicep labs, generating .bicep files, or scaffolding Bicep module structure for AI-102 or AZ-104.'
user-invokable: false
---

# Bicep Scaffolding

Bicep-specific code generation patterns, templates, and conventions for Azure hands-on labs. All generated code must comply with the `azure-lab-governance` skill.

## When to Use

- Generating Bicep code for a lab
- Scaffolding a new Bicep lab from a plan
- Creating Bicep modules for Azure resources
- Configuring parameters, stack deployments, and wrapper scripts
- Applying naming, tagging, password, and SKU patterns in Bicep

## Templates

Starter templates are in the `azure-lab-governance` skill at:
`.github/skills/azure-lab-governance/templates/bicep-module.stub/`

Files: `main.bicep`, `main.bicepparam`

Use these as the starting point for every new lab. Replace `<EXAM>`, `<Domain>`, `<topic>`, `<scenario>`, and `<YYYY-MM-DD>` placeholders.

## Required Files

Every Bicep lab must include:

| File | Purpose |
|------|---------|
| `main.bicep` | Root module with `targetScope = 'subscription'` |
| `main.bicepparam` | Parameter file |
| `bicepconfig.json` | Bicep configuration |
| `bicep.ps1` | Deployment wrapper (copy from shared — do NOT modify) |

## Deployment Scope

- Use `targetScope = 'subscription'` for labs creating resource groups
- Use stack deployments via the wrapper script

## Stack Naming

```
stack-<domain>-<topic>
```

No exam code in stack name.

## Module Rules

- Create modules when 2+ related resource types exist
- One concern per module (domain grouping)
- Each module gets its own `.bicep` file in `modules/`
- Pass `commonTags` object to all modules
- Pass identity references as explicit parameters for RBAC
- Root `main.bicep` orchestrates modules — minimal direct resource definitions

## Header Block

Include in ALL `.bicep` files:

```
// -------------------------------------------------------------------------
// Program: [filename]
// Description: [purpose]
// Context: [EXAM] Lab - [scenario]
// Author: Greg Tate
// Date: [YYYY-MM-DD]
// -------------------------------------------------------------------------
```

## Parameter Conventions

- Use `camelCase` for parameter names
- Include descriptions via `@description()` decorator
- Provide governance-compliant defaults where possible

```bicep
@description('Azure region for resource deployment')
param location string = 'eastus'

@description('Resource owner name')
param owner string = 'Greg Tate'

@description('Static date for DateCreated tag (YYYY-MM-DD)')
param dateCreated string
```

## Naming & Tags

- Resource group: `<exam>-<domain>-<topic>-bicep`
- Resources: `<type>-<topic>[-instance]` per governance prefix tables
- All resources must include the 7 required tags via `commonTags`
- `DateCreated` must be a static string parameter (never use `utcNow()`)

Common tags pattern in `main.bicep`:

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

## Password Generation

- Use `uniqueString()` or static pattern for lab-safe passwords
- Pattern: `AzureLab2026!` style (meets complexity)
- Mark with `@secure()` decorator

## Default SKUs

| Resource | Default |
|----------|---------|
| VM | `Standard_B2s` (or `Standard_B1s` if sufficient) |
| Storage | Standard LRS |
| Load Balancer | Basic |
| Public IP | Basic |
| OpenAI | S0 |
| Cognitive Services | F0 → S0 |
| AI Search | Free / Basic |

## Soft-Delete Configuration

Disable soft-delete at creation:

```bicep
softDeleteState: 'Disabled'
```

## Deployment Wrapper (bicep.ps1)

- Must copy shared `bicep.ps1` — never create a custom one
- Only allowed commands: `validate`, `plan`, `apply`, `destroy`, `show`, `list`
- Script validates subscription context automatically

## Cleanup

The `destroy` command must include force-deletion for complete resource group cleanup:

```powershell
az stack sub delete --name $stackName --yes --force-deletion-types $forceTypes
```

## Validation Script

Generate a PowerShell validation script in `validation/` that:

- Confirms lab subscription context (reference `Confirm-LabSubscription` from governance skill)
- Validates deployed resources exist
- Tests key functionality
- Uses the `$Main` / `$Helpers` script pattern

## main.bicepparam

Always pre-populate:

```bicep-params
using './main.bicep'

param location = 'eastus'
param owner = 'Greg Tate'
param dateCreated = '<YYYY-MM-DD>'
```
