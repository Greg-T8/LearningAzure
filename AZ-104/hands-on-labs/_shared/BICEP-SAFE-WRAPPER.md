# Bicep Deployment Stack Wrapper

PowerShell wrapper that validates Azure subscription before running Bicep deployment stack operations.

## Purpose

Prevents accidental deployments to wrong Azure subscriptions by:

1. ✅ Validating subscription before any deployment
2. ✅ Automatically creating resource groups if needed
3. ✅ Providing consistent deployment stack commands
4. ✅ Using safe defaults (deleteAll on unmanage)

---

## Usage

```powershell
.\bicep-safe.ps1 <action> [options]
```

### Actions

| Action | Description | Required Parameters |
|--------|-------------|---------------------|
| `create` | Deploy a Bicep template via deployment stack | `--stack-name`, `--resource-group` |
| `delete` | Delete a deployment stack and managed resources | `--stack-name`, `--resource-group` |
| `delete-rg` | Delete the resource group (after stack cleanup) | `--resource-group` |
| `show` | Show deployment stack details | `--stack-name`, `--resource-group` |
| `list` | List deployment stacks in resource group | `--resource-group` |
| `validate` | Validate Bicep template syntax | `--template-file` |

### Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `-StackName` | Name of the deployment stack | (required for create/delete/show) |
| `-ResourceGroup` | Resource group name | (required for most operations) |
| `-TemplateFile` | Bicep template file | `main.bicep` |
| `-ParametersFile` | Bicep parameters file | `main.bicepparam` |
| `-AdditionalArgs` | Additional arguments to pass through | (optional) |

---

## Examples

### Create Deployment Stack

```powershell
# Basic deployment
.\bicep-safe.ps1 create `
    -StackName "stack-compute-app-service-tiers" `
    -ResourceGroup "az104-compute-app-service-tiers-bicep"

# With custom files
.\bicep-safe.ps1 create `
    -StackName "stack-networking-vnet" `
    -ResourceGroup "az104-networking-vnet-bicep" `
    -TemplateFile "vnet.bicep" `
    -ParametersFile "vnet.bicepparam"

# Override parameter at runtime
.\bicep-safe.ps1 create `
    -StackName "stack-compute-app-service-tiers" `
    -ResourceGroup "az104-compute-app-service-tiers-bicep" `
    --parameters skuName=B1
```

### Delete Deployment Stack

```powershell
# Delete stack and all managed resources
.\bicep-safe.ps1 delete `
    -StackName "stack-compute-app-service-tiers" `
    -ResourceGroup "az104-compute-app-service-tiers-bicep"
```

### Delete Resource Group

```powershell
# Delete the resource group (after stack cleanup)
.\bicep-safe.ps1 delete-rg `
    -ResourceGroup "az104-compute-app-service-tiers-bicep"
```

### Show Stack Details

```powershell
# Show full stack details
.\bicep-safe.ps1 show `
    -StackName "stack-compute-app-service-tiers" `
    -ResourceGroup "az104-compute-app-service-tiers-bicep"

# Show only managed resources
.\bicep-safe.ps1 show `
    -StackName "stack-compute-app-service-tiers" `
    -ResourceGroup "az104-compute-app-service-tiers-bicep" `
    --query "resources[].id" -o table
```

### List Stacks

```powershell
# List all stacks in resource group
.\bicep-safe.ps1 list `
    -ResourceGroup "az104-compute-app-service-tiers-bicep"
```

### Validate Template

```powershell
# Validate Bicep syntax
.\bicep-safe.ps1 validate -TemplateFile "main.bicep"
```

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

---

## Features

| Feature | Benefit |
|---------|---------|
| **Subscription Lock** | Blocks deployment if wrong subscription is active |
| **Auto Resource Group** | Creates RG if it doesn't exist (create action) |
| **Safe Defaults** | Uses `deleteAll` for complete cleanup |
| **Parameter Passthrough** | Supports all `az stack` arguments |
| **Validation** | Checks Bicep syntax without deploying |

---
 Stack** | `.\bicep-safe.ps1 delete -StackName x -ResourceGroup y` | `az stack group delete --name x --resource-group y --action-on-unmanage deleteAll --yes` |
| **Cleanup RG** | `.\bicep-safe.ps1 delete-rg -ResourceGroup y` | `az group delete --name y --yes --no-wait
## Comparison with Direct `az stack` Commands

| Task | bicep-safe.ps1 | Direct az stack |
|------|----------------|-----------------|
| **Deploy** | `.\bicep-safe.ps1 create -StackName x -ResourceGroup y` | `az stack group create --name x --resource-group y --template-file ... --action-on-unmanage deleteAll --deny-settings-mode none --yes` |
| **Subscription Check** | ✅ Automatic | ❌ Manual |
| **RG Creation** | ✅ Automatic | ❌ Manual |
| **Cleanup** | `.\bicep-safe.ps1 delete -StackName x -ResourceGroup y` | `az stack group delete --name x --resource-group y --action-on-unmanage deleteAll --yes` |

---

## Lab Integration

Use this wrapper in all Bicep labs:

```powershell
# From any lab's bicep/ directory
cd hands-on-labs/compute/lab-app-service-tiers/bicep

# Deploy
..\..\..\_shared\bicep-safe.ps1 create `
    -StackName "stack-compute-app-service-tiers" `
    -ResourceGroup "az104-compute-app-service-tiers-bicep"

# Cleanup
..\..\..\_shared\bicep-safe.ps1 delete `
    -StackName "stack-compute-app-service-tiers" `
    -ResourceGroup "az104-compute-app-service-tiers-bicep"
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

### Resource Group Already Exists

The script checks for existence before creating—no error will occur.
