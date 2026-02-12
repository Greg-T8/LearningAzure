# Bicep Deployment Stack Wrapper

PowerShell wrapper that validates Azure subscription before running Bicep deployment stack operations.

## Purpose

Prevents accidental deployments to wrong Azure subscriptions by:

1. ✅ Validating subscription before any deployment
2. ✅ Auto-deriving stack names from parameters file
3. ✅ Using subscription-scoped deployment stacks
4. ✅ Single deployment creates both resource group and resources
5. ✅ Using safe defaults (deleteAll on unmanage)

---

## Architecture

The script deploys a **subscription-scoped** Bicep template that:

- Creates the resource group
- Calls a module to deploy resources into that resource group
- Manages everything as a single deployment stack

```
main.bicep (subscription scope)
├── Creates resource group
└── Calls resources.bicep module
    └── Deploys App Service resources

main.bicepparam
└── Single parameter file for everything
```

---

## Usage

```powershell
.\bicep.ps1 <action> [options]
```

### Actions

| Action | Description | Auto-Derives Stack Name? |
|--------|-------------|-------------------------|
| `apply` | Deploy subscription-scoped stack (creates RG + resources) | ✅ Yes |
| `destroy` | Delete stack and all managed resources (including RG) | ✅ Yes |
| `show` | Show deployment stack details | ✅ Yes |
| `output` | Retrieve deployment outputs as PowerShell object | ✅ Yes |
| `list` | List all subscription-scoped deployment stacks | N/A |
| `validate` | Validate Bicep template syntax | N/A |
| `plan` | Show what-if analysis for deployment | N/A |

### Parameters

| Parameter | Description | Default | Required? |
|-----------|-------------|---------|-----------|
| `-StackName` | Name of the deployment stack | Auto-derived from params | Optional |
| `-TemplateFile` | Bicep template file | `main.bicep` | Optional |
| `-ParametersFile` | Bicep parameters file | `main.bicepparam` | Optional |
| `-Location` | Azure region for deployment | `eastus` | Optional |
| `-AdditionalArgs` | Additional arguments to pass through | (none) | Optional |

### Auto-Derived Stack Names

The script automatically derives the stack name from your parameters file:

- Parses `domain` and `topic` parameters
- Constructs: `stack-{domain}-{topic}`
- Example: `stack-compute-app-service-tiers`

---

## Examples

### Apply Deployment Stack (Auto-Named)

```powershell
# From the bicep directory - stack name auto-derived
.\bicep.ps1 apply

# Output:
# 📋 Auto-derived stack name: stack-compute-app-service-tiers
# 📦 Applying subscription-scoped stack (creates RG and resources)...
```

### Apply with Explicit Stack Name

```powershell
.\bicep.ps1 apply -StackName "my-custom-stack"
```

### Apply with Custom Files

```powershell
.\bicep.ps1 apply `
    -TemplateFile "custom.bicep" `
    -ParametersFile "custom.bicepparam"
```

### Apply with Runtime Parameter Override

```powershell
.\bicep.ps1 apply --parameters skuName=B1
```

### Destroy Deployment Stack

```powershell
# Auto-derives stack name and deletes everything (RG + resources)
.\bicep.ps1 destroy

# Or with explicit name
.\bicep.ps1 destroy -StackName "stack-compute-app-service-tiers"
```

### Show Stack Details

```powershell
# Show full stack details
.\bicep.ps1 show

# Show with explicit name
.\bicep.ps1 show -StackName "stack-compute-app-service-tiers"

# Show only managed resources
.\bicep.ps1 show -StackName "stack-compute-app-service-tiers" `
    --query "resources[].id" -o table
```

### Get Deployment Outputs

```powershell
# Retrieve outputs from the deployment (auto-derives stack name)
.\bicep.ps1 output

# Output:
# 📋 Auto-derived stack name: stack-compute-app-service-tiers
# 📤 Retrieving deployment outputs from stack: stack-compute-app-service-tiers
# 🔍 Querying deployment: stack-compute-app-service-tiers
#
# appServicePlanId : /subscriptions/.../resourceGroups/rg-compute-app-service-tiers/providers/Microsoft.Web/serverfarms/asp-...
# appUrl           : https://app-....azurewebsites.net

# Or with explicit stack name
.\bicep.ps1 output -StackName "stack-compute-app-service-tiers"

# Use output in scripts
$outputs = .\bicep.ps1 output
Write-Host "App URL: $($outputs.appUrl)"
```

### List All Stacks

```powershell
# List all subscription-scoped stacks
.\bicep.ps1 list
```

### Validate Template

```powershell
# Validate Bicep syntax
.\bicep.ps1 validate

# Or with explicit file
.\bicep.ps1 validate -TemplateFile "main.bicep"
```

### Plan Deployment (What-If)

```powershell
# Show what changes will be made without deploying
.\bicep.ps1 plan

# Output:
# 📋 Planning (What-If): main.bicep
# Resource changes: 5 to create, 0 to modify, 0 to delete

# Or with explicit file
.\bicep.ps1 plan -TemplateFile "main.bicep"
```

---

## Parameters File Format

The script supports `.bicepparam` files. Your parameters must include `domain` and `topic` for auto-naming:

```bicep
// main.bicepparam
using './main.bicep'

param labSubscriptionId = 'your-subscription-id'
param domain = 'compute'              // ← Required for auto-naming
param topic = 'app-service-tiers'     // ← Required for auto-naming
param location = 'eastus'
param owner = 'Your Name'

// App-specific parameters
param appServicePlanName = 'MyPlan'
param appName = 'MyApp'
param skuName = 'F1'
```

**Derived Stack Name:** `stack-compute-app-service-tiers`

---

## Subscription Configuration

Update these values in the script to match your lab subscription:

```powershell
$LabSubscriptionId   = "your-subscription-id-here"
$LabSubscriptionName = "Your Subscription Name"
```

---

## Error Handling

### Wrong Subscription

```
╔══════════════════════════════════════════════════════════════════╗
║  ⛔ BLOCKED - WRONG AZURE SUBSCRIPTION                            ║
╠══════════════════════════════════════════════════════════════════╣
║  Current:  sub-client-prod
║  Expected: sub-gtate-mpn-lab
╠══════════════════════════════════════════════════════════════════╣
║  To switch subscriptions, run:
║  az account set --subscription 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
╚══════════════════════════════════════════════════════════════════╝
```

### Not Logged In

```
⛔ ERROR: Not logged into Azure CLI
   Run: az login
```

### Cannot Derive Stack Name

```
⛔ ERROR: Could not derive stack name. Provide -StackName or ensure parameters file has domain/topic.
```

---

## Features

| Feature | Benefit |
|---------|---------|
| **Subscription Lock** | Blocks deployment if wrong subscription is active |
| **Auto Stack Naming** | Derives stack name from `domain` + `topic` parameters |
| **Subscription Scope** | Single deployment stack manages RG and all resources |
| **Module-Based** | Cleaner separation: main.bicep creates RG, resources.bicep deploys resources |
| **Safe Defaults** | Uses `deleteAll` for complete cleanup |
| **Parameter Passthrough** | Supports all `az stack sub` arguments |
| **Validation** | Checks Bicep syntax without deploying |

---

## Comparison with Direct `az stack` Commands

| Task | bicep.ps1 | Direct az stack |
|------|-----------|-----------------||
| **Deploy** | `.\bicep.ps1 apply` | `az stack sub create --name stack-compute-app-service-tiers --location eastus --template-file main.bicep --parameters main.bicepparam --action-on-unmanage deleteAll --deny-settings-mode none --yes` |
| **Subscription Check** | ✅ Automatic | ❌ Manual |
| **Stack Naming** | ✅ Auto-derived | ❌ Manual |
| **Get Outputs** | `.\bicep.ps1 output` | `az deployment sub show --name <deployment-name> --query 'properties.outputs'` |
| **What-If** | `.\bicep.ps1 plan` | `az deployment sub what-if --location eastus --template-file main.bicep --parameters main.bicepparam` |
| **Cleanup** | `.\bicep.ps1 destroy` | `az stack sub delete --name stack-compute-app-service-tiers --action-on-unmanage deleteAll --yes` |

---

## Lab Integration

Use this wrapper in all Bicep labs for simplified workflows:

```powershell
# From any lab's bicep/ directory
cd AZ-104/hands-on-labs/compute/lab-app-service-tiers/bicep

# Deploy (auto-derives stack name from main.bicepparam)
.\bicep.ps1 apply

# Get deployment outputs
.\bicep.ps1 output

# Show status
.\bicep.ps1 show

# Cleanup (removes RG and all resources)
.\bicep.ps1 destroy
```

**Note:** The `bicep.ps1` script should be copied from `.assets/shared/bicep/bicep.ps1` to each lab's `bicep/` directory.

**Note:** The `bicep.ps1` script should be copied from `.assets/shared/bicep/bicep.ps1` to each lab's `bicep/` directory.

### Alternative: Call Directly from Shared Location

```powershell
# From lab's bicep/ directory (e.g., AZ-104/hands-on-labs/compute/lab-name/bicep/)
# Call shared script using relative path (5 levels up to root, then down to .assets/shared)
& "..\..\..\..\..\..\.assets\shared\bicep\bicep.ps1" apply

# Get outputs
& "..\..\..\..\..\..\.assets\shared\bicep\bicep.ps1" output
```

---

## Troubleshooting

### Command Not Found

Ensure Azure CLI is installed and in PATH:

```powershell
az --version
```

### Bicep Not Installed

```powershell
az bicep install
az bicep version
```

### Stack Already Exists

If redeploying, the script will update the existing stack. To start fresh:

```powershell
# Delete first, then recreate
.\bicep.ps1 destroy
.\bicep.ps1 apply
```

### Wrong Location for Subscription-Scoped Deployment

If you see a location-related error, specify the location explicitly:

```powershell
.\bicep.ps1 apply -Location "westus2"
```
