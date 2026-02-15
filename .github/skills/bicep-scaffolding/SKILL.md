---
name: bicep-scaffolding
description: Bicep code generation procedures and patterns for Azure hands-on labs. Cross-cutting rules are in the shared-contract skill.
---

# Bicep Scaffolding

Bicep-specific code generation procedures. All cross-cutting rules (naming, tags, SKUs, regions, limits) are defined in the `shared-contract` skill — reference by ID, do not restate.

## When to Use

- Generating Bicep code for a lab
- Scaffolding a new Bicep module structure
- Applying Bicep-specific patterns (scope, stack, wrapper, parameters)

---

## Starter Templates

Located in `azure-lab-governance` skill (see R-160):
`.github/skills/azure-lab-governance/templates/bicep-module.stub/`

Files: `main.bicep`, `main.bicepparam`

---

## R-130: Required Files

| File               | Content                                                       |
| ------------------ | ------------------------------------------------------------- |
| `main.bicep`       | Root module with `targetScope = 'subscription'`               |
| `main.bicepparam`  | Per R-136                                                     |
| `bicepconfig.json` | Bicep lint/compile configuration                              |
| `bicep.ps1`        | Deployment wrapper — copy from shared, never modify (see R-135) |

---

## R-131: Deployment Scope

Use `targetScope = 'subscription'` for labs that create resource groups. Use stack deployments via the wrapper script.

---

## R-132: Module File Pattern

Each module is a `.bicep` file in `modules/`:

- Accepts `location`, `tags` (object), and cross-module references as parameters.
- Outputs resource IDs, endpoints, principal IDs.
- Uses `@description()` decorators on all parameters.

Module organization rules: see `shared-contract` R-022.

---

## R-133: Parameter Conventions

Use `camelCase` for parameter names (see `shared-contract` R-021). Include `@description()` decorator on every parameter. Provide governance-compliant defaults where possible.

```bicep
@description('Azure region for resource deployment')
param location string = 'eastus'

@description('Resource owner name')
param owner string = 'Greg Tate'

@description('Static date for DateCreated tag (YYYY-MM-DD)')
param dateCreated string
```

---

## R-134: Password Implementation

See `shared-contract` R-024 for rules. Use `uniqueString()` or static pattern. Mark with `@secure()` decorator.

---

## R-135: Deployment Wrapper (bicep.ps1)

- **Must copy** shared `bicep.ps1` — never create a custom one.
- Allowed commands: `validate`, `plan`, `apply`, `destroy`, `show`, `list`.
- Script validates subscription context automatically.

Stack naming: see `shared-contract` R-004.

Cleanup destroy command:

```powershell
az stack sub delete --name $stackName --yes --force-deletion-types $forceTypes
```

---

## R-136: main.bicepparam Template

```bicep-params
using './main.bicep'

param location = 'eastus'
param owner = 'Greg Tate'
param dateCreated = '<YYYY-MM-DD>'
```

---

## R-137: Soft-Delete Implementation

See `shared-contract` R-016 for the resource table and Bicep disable pattern. Apply to all resources in the R-016 table that are deployed in the lab.

---

## R-138: Validation Script Pattern

Generate a PowerShell script in `validation/` that:

1. Sources `Confirm-LabSubscription` from the `azure-lab-governance` skill (see R-161).
2. Validates deployed resources exist.
3. Tests key functionality.
4. Uses the `$Main` / `$Helpers` script block pattern.
5. Includes code header per `shared-contract` R-012.
