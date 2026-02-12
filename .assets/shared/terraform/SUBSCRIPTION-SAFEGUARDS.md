# Terraform Subscription Safeguards Setup

## Architecture

The subscription safeguards use a **single source of truth** approach:

```
terraform.tfvars (or environment variable)
    ↓
variables.tf (lab_subscription_id variable)
    ↓
┌─────────────────────────────────────┐
│   providers.tf                      │
│   Uses var.lab_subscription_id      │
│   (Hard-blocks provider lock)       │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│   subscription-guard.tf             │
│   Uses var.lab_subscription_id      │
│   (Pretty error message)            │
└─────────────────────────────────────┘
```

---

## Files and Purposes

| File | Purpose | Protection Type |
|------|---------|-----------------|
| **providers.tf** | Configures Azure provider with subscription lock | Hard block at provider level |
| **subscription-guard.tf** | Validates subscription with user-friendly error | Precondition check with formatted message |
| **variables.tf** | Defines `lab_subscription_id` variable | Single source definition |
| **terraform.tfvars** | Contains your actual subscription ID | Single place to update |

---

## Setup Instructions

### Step 1: Copy to Lab Folder

For each lab, copy these shared files to your `terraform/` directory:

```powershell
# From lab terraform folder (e.g., AZ-104/hands-on-labs/domain/lab-name/terraform/)
Copy-Item ..\..\..\..\..\..\..\..\..\assets\shared\terraform\providers.tf .\
Copy-Item ..\..\..\..\..\..\..\..\..\assets\shared\terraform\subscription-guard.tf .\
```

Or use symbolic links to avoid duplication:

```powershell
# From lab terraform folder
New-Item -ItemType SymbolicLink -Name "providers.tf" -Target "..\..\..\..\..\..\..\..\..\assets\shared\terraform\providers.tf"
New-Item -ItemType SymbolicLink -Name "subscription-guard.tf" -Target "..\..\..\..\..\..\..\..\..\assets\shared\terraform\subscription-guard.tf"
```

### Step 2: Create terraform.tfvars

```powershell
# From lab terraform folder
Copy-Item ..\..\..\..\..\..\..\..\..\assets\shared\terraform\terraform.tfvars.template .\terraform.tfvars
```

### Step 3: Configure Your Subscription

Edit `terraform.tfvars` and add your subscription ID:

```hcl
lab_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"
```

Or pass as environment variable:

```powershell
$env:TF_VAR_lab_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"
```

---

## How It Works

### Layer 1: Provider Lock (Hard Block)

```hcl
# providers.tf
provider "azurerm" {
  subscription_id = var.lab_subscription_id
}
```

- **When**: At `terraform plan` / `terraform apply`
- **If wrong subscription**: Terraform fails with provider error
- **Message**: Generic Terraform provider error

### Layer 2: Precondition Validation (Pretty Error)

```hcl
# subscription-guard.tf
resource "terraform_data" "subscription_guard" {
  lifecycle {
    precondition {
      condition = data.azurerm_subscription.current.subscription_id == var.lab_subscription_id
      error_message = "╔════... DEPLOYMENT BLOCKED ════╗"
    }
  }
}
```

- **When**: At `terraform plan` (after provider is initialized)
- **If wrong subscription**: Fails with formatted error message
- **Message**: User-friendly box with current vs. expected subscription

---

## Benefits of Variable-Based Approach

| Aspect | Benefit |
|--------|---------|
| **Single source of truth** | Update subscription ID in one place: `terraform.tfvars` |
| **No hardcoded values** | Shared files contain only `var.lab_subscription_id` reference |
| **Reusable** | Same files work across all labs without modification |
| **Flexible override** | Can override via CLI: `terraform apply -var="lab_subscription_id=xxx"` |
| **Environment variable** | Can set `TF_VAR_lab_subscription_id` for automation |
| **Pretty errors** | Box-formatted error message with context |

---

## Example Workflow

```powershell
# Navigate to lab
cd hands-on-labs\compute\lab-app-service-tiers\terraform

# Initialize (first time only)
terraform init

# Plan - validates subscription before showing changes
terraform plan

# Apply - double-protection from subscription lock + precondition
terraform apply

# Destroy
terraform destroy -auto-approve
```

---

## Troubleshooting

### Error: "DEPLOYMENT BLOCKED - WRONG SUBSCRIPTION"

**Cause**: Logged into wrong Azure subscription

**Fix**:
```powershell
# Check current subscription
az account show --query "{Name:name, Id:id}"

# Switch to lab subscription
az account set --subscription "e091f6e7-031a-4924-97bb-8c983ca5d21a"

# Verify
az account show --query "{Name:name, Id:id}"
```

### How to Find Your Lab Subscription ID

```powershell
# List all subscriptions
az account list --query "[].{Name:name, Id:id}" -o table

# Or set it as active first
az account set --subscription "<your-lab-sub-name>"
az account show --query "id" -o tsv
```

---

## File Locations

```
.assets/
├── shared/
│   ├── terraform/
│   │   ├── providers.tf                    ← Copy to each lab
│   │   ├── subscription-guard.tf           ← Copy to each lab
│   │   └── terraform.tfvars.template       ← Copy & customize per lab
│   └── bicep/
│       └── bicep.ps1                       ← Copy to each Bicep lab
│
<EXAM>/
└── hands-on-labs/
    └── <domain>/
        └── lab-<topic>/
            └── terraform/
                ├── providers.tf            ← (copied from .assets/shared)
                ├── subscription-guard.tf   ← (copied from .assets/shared)
                ├── terraform.tfvars        ← (created from template)
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
```
