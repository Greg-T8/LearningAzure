# Lab: App Service Pricing Tiers

## Exam Reference

- **Source**: MU AZ-104 Assessment - Solution Evaluation, Question 1
- **Domain**: Compute
- **Topic**: App Service Plans and Pricing Tiers

## Scenario

You deploy an Azure web app named **MyApp** in a **Free (F1)** pricing tier service plan named **MyPlan**. During testing, you discover that MyApp stops after 60 minutes and cannot be restarted until the next day.

**Goal**: Ensure MyApp can run 8 hours each day during testing while keeping costs minimal.

**Proposed Solution**: Change the pricing tier for MyPlan to **Shared D1**.

## Key Concepts

| Tier | SKU | CPU Time/Day | Cost | Notes |
|------|-----|--------------|------|-------|
| Free | F1 | 60 minutes | $0 | Stops when limit reached |
| Shared | D1 | 240 minutes | ~$9.49/month | Shared infrastructure |
| Basic | B1 | Unlimited | ~$13.14/month | Dedicated, no daily limit |

⚠️ **Analysis**: Shared D1 provides 240 CPU minutes (4 hours), not 8 hours. For true 8-hour runtime, **Basic B1** or higher is required. However, the exam answer indicates D1 meets the goal—this may relate to how "CPU minutes" vs "wall-clock time" are measured.

## Objectives

1. Deploy an App Service Plan in Free tier and observe the 60-minute limit
2. Upgrade to Shared D1 tier and test extended runtime
3. Compare with Basic B1 for unlimited runtime
4. Understand the differences between shared and dedicated compute

## Prerequisites

- Azure subscription
- **For Terraform**: Terraform CLI installed
- **For Bicep**: Azure CLI with Bicep installed
- Azure CLI authenticated (`az login`)

---

# Terraform Deployment

## First-Time Setup

```powershell
cd terraform

# Copy the tfvars template and add your subscription ID
Copy-Item ..\..\..\_shared\terraform\terraform.tfvars.template .\terraform.tfvars

# Edit terraform.tfvars and replace the placeholder subscription ID
# lab_subscription_id = "your-actual-subscription-id"
```

## Deploy

```powershell
cd terraform

# Initialize
terraform init

# Option A: Using the safe wrapper (recommended)
# Validates subscription before running Terraform
..\..\..\..\_shared\terraform-safe.ps1 apply -var="sku_name=F1"

# Option B: Direct Terraform (subscription guard built into config)
terraform apply -var="sku_name=F1"

# Deploy with Shared tier
terraform apply -var="sku_name=D1"

# Deploy with Basic tier
terraform apply -var="sku_name=B1"
```

## Validate

1. Navigate to the App Service in Azure Portal
2. Check **App Service Plan** → **Scale up** to see current tier
3. Monitor **Quotas** under the App Service to see CPU time usage
4. For Free/Shared tiers, observe the daily quota limits

### Test CPU Time Consumption

```powershell
# Get the app URL from Terraform output
$appUrl = terraform output -raw app_url

# Generate load to consume CPU time (run for a few minutes)
while ($true) { Invoke-WebRequest -Uri $appUrl -UseBasicParsing | Out-Null; Start-Sleep -Milliseconds 100 }
```

## Cleanup

```powershell
terraform destroy -auto-approve
```

---

# Bicep Deployment (Azure Deployment Stacks)

## First-Time Setup

```powershell
cd bicep

# Edit main.bicepparam and update your subscription ID
# labSubscriptionId = 'your-actual-subscription-id'
```

## Deploy

```powershell
cd bicep

# Deploy with Free tier (default)
az stack group create `
    --name "stack-compute-app-service-tiers" `
    --resource-group "az104-compute-app-service-tiers-bicep" `
    --template-file main.bicep `
    --parameters main.bicepparam `
    --action-on-unmanage deleteAll `
    --deny-settings-mode none `
    --yes

# Deploy with Shared tier
az stack group create `
    --name "stack-compute-app-service-tiers" `
    --resource-group "az104-compute-app-service-tiers-bicep" `
    --template-file main.bicep `
    --parameters main.bicepparam `
    --parameters skuName=D1 `
    --action-on-unmanage deleteAll `
    --deny-settings-mode none `
    --yes

# Deploy with Basic tier
az stack group create `
    --name "stack-compute-app-service-tiers" `
    --resource-group "az104-compute-app-service-tiers-bicep" `
    --template-file main.bicep `
    --parameters main.bicepparam `
    --parameters skuName=B1 `
    --action-on-unmanage deleteAll `
    --deny-settings-mode none `
    --yes
```

## Validate

1. Navigate to the App Service in Azure Portal
2. Check **App Service Plan** → **Scale up** to see current tier
3. Monitor **Quotas** under the App Service to see CPU time usage
4. For Free/Shared tiers, observe the daily quota limits

### View Deployment Stack

```powershell
# List deployment stacks
az stack group list --resource-group "az104-compute-app-service-tiers-bicep" -o table

# Show stack details
az stack group show `
    --name "stack-compute-app-service-tiers" `
    --resource-group "az104-compute-app-service-tiers-bicep"

# List managed resources in the stack
az stack group show `
    --name "stack-compute-app-service-tiers" `
    --resource-group "az104-compute-app-service-tiers-bicep" `
    --query "resources[].id" -o table
```

### Test CPU Time Consumption

```powershell
# Get the app URL from deployment outputs
az stack group show `
    --name "stack-compute-app-service-tiers" `
    --resource-group "az104-compute-app-service-tiers-bicep" `
    --query "outputs.appUrl.value" -o tsv

# Generate load to consume CPU time (run for a few minutes)
$appUrl = az stack group show `
    --name "stack-compute-app-service-tiers" `
    --resource-group "az104-compute-app-service-tiers-bicep" `
    --query "outputs.appUrl.value" -o tsv

while ($true) { Invoke-WebRequest -Uri $appUrl -UseBasicParsing | Out-Null; Start-Sleep -Milliseconds 100 }
```

## Cleanup

```powershell
# Delete the deployment stack (removes all managed resources)
az stack group delete `
    --name "stack-compute-app-service-tiers" `
    --resource-group "az104-compute-app-service-tiers-bicep" `
    --action-on-unmanage deleteAll `
    --yes

# Delete the resource group if needed
az group delete --name "az104-compute-app-service-tiers-bicep" --yes --no-wait
```

---

# Comparison: Terraform vs Bicep

| Aspect | Terraform | Bicep |
|--------|-----------|-------|
| **Resource Group Name** | `az104-compute-app-service-tiers-tf` | `az104-compute-app-service-tiers-bicep` |
| **State Management** | Local state file | Deployment stack tracks resources |
| **Cleanup** | `terraform destroy` | `az stack group delete` |
| **Plan/Preview** | `terraform plan` | `az deployment group what-if` |
| **Variables** | `terraform.tfvars` | `main.bicepparam` |
| **Provider Lock** | Explicit subscription ID | Resource group must exist first |

---

# General Validation & Notes

_Record your observations here after running the lab:_

- [ ] Observed Free tier stopping at 60 minutes?
- [ ] Shared tier allowed extended runtime?
- [ ] Quota dashboard showed usage correctly?

---

## Answer Analysis

**Does changing to Shared D1 meet the goal?**

The exam says **Yes**, but consider:
- D1 provides 240 CPU minutes/day (4× more than F1)
- "CPU minutes" ≠ "wall-clock minutes" for low-traffic apps
- An idle app consumes minimal CPU, so 240 CPU minutes could sustain 8+ hours of light testing
- For guaranteed 8 hours regardless of load, Basic B1 (no daily limit) is required
