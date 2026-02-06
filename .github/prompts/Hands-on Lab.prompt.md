---
name: Hands-on Lab
description: Creates a hands-on lab from an exam question scenario using Terraform or Bicep, following governance standards
---

# Hands-on Lab Generator

You are tasked with creating a comprehensive hands-on lab based on an exam question scenario. The lab must follow strict governance standards and produce working, validated infrastructure-as-code.

---

## Exam Context

### Determine Exam

**CRITICAL**: Before starting, determine which exam this lab is for:
1. Check the user's current working directory or file path
2. Look for exam folder in workspace structure (e.g., AZ-104, AI-900, AZ-305)
3. If unclear, ask the user which exam this lab is for

Use the exam identifier throughout (e.g., "AZ-104", "AI-900") and lowercase prefix (e.g., "az104", "ai900").

### Governance File

Read and strictly follow the governance requirements in:
- `#file:<EXAM>/hands-on-labs/GOVERNANCE.md` (replace `<EXAM>` with the determined exam)

### Exam-Specific Considerations

Different exams focus on different Azure services:

- **AZ-104** (Azure Administrator): Infrastructure resources (VMs, Networks, Storage, Identity)
- **AI-900** (Azure AI Fundamentals): Cognitive Services, Azure AI services, Machine Learning basics
- **AZ-305** (Azure Solutions Architect): Complex architectures, multi-service integrations
- **DP-203** (Azure Data Engineer): Data Factory, Synapse, Databricks, Storage
- **AZ-400** (DevOps Engineer): Pipelines, Container registries, monitoring, deployment

Adapt resource types and domains accordingly based on the exam context.

---

## Cost Optimization Principles

**CRITICAL**: All labs must use cost-effective resources to minimize Azure spending:

### Virtual Machines
- **Default**: Use `Standard_B2s` (2 vCPU, 4 GB RAM) for general-purpose VMs
- **Minimum**: Use `Standard_B1s` (1 vCPU, 1 GB RAM) for simple scenarios
- **Only use D-series or higher** if the exam question explicitly requires higher performance, memory, or specific capabilities

### Other Resources
- **Storage Accounts**: Use Standard LRS (Locally Redundant Storage) unless redundancy is required
- **Load Balancers**: Use Basic SKU for simple scenarios; Standard SKU only when required
- **Public IPs**: Use Basic SKU unless Standard is required for specific features
- **App Services**: Use Free or Basic tier unless specific features require higher tiers
- **SQL Database**: Use Basic or S0 tier for labs unless performance testing is the objective

### General Guidelines
- Choose the smallest SKU/tier that demonstrates the required functionality
- Use spot instances or reserved capacity only if cost optimization is the learning objective
- Document in README if higher-cost resources are necessary and why

---

## Lab Structure & Coding Standards

### Directory Layout

Create the following structure in `<EXAM>/hands-on-labs/<domain>/lab-<topic>/`:

```
lab-<topic>/
├── README.md
├── terraform/  OR  bicep/
│   ├── main.tf (or main.bicep)           # Orchestration only - calls modules
│   ├── variables.tf (or main.bicepparam)
│   ├── outputs.tf (or outputs.bicep)
│   ├── providers.tf (Terraform only)
│   ├── terraform.tfvars (Terraform - with lab subscription ID)
│   └── modules/                           # Resource modules (when applicable)
│       ├── <resource-group>/              # e.g., networking/, compute/, storage/
│       │   ├── main.tf (or <module>.bicep)
│       │   ├── variables.tf (or parameters in module)
│       │   └── outputs.tf (or outputs in module)
│       └── ...
└── validation/
    └── test-<scenario>.ps1 (optional validation scripts)
```

**Note**: `terraform.tfvars` contains the lab subscription ID and is created for each lab.

### Header Comments

Every file must have a header section:
```
# -------------------------------------------------------------------------
# Program: [filename]
# Description: [what this does]
# Context: <EXAM> Lab - [scenario description]
# Author: Greg Tate
# Date: [YYYY-MM-DD]
# -------------------------------------------------------------------------
```

### Code Style

- Add comments above code blocks separated by blank lines
- Use clear, descriptive names for all resources and variables

---

## Naming & Tagging Standards

### Resource Group Naming

**CRITICAL**: Follow this pattern exactly:
- Pattern: `<exam-prefix>-<domain>-<topic>-<deployment_method>`
- Exam Prefix: Lowercase exam identifier (e.g., `az104`, `ai900`, `az305`)
- Domain: Exam-specific domain (see governance file for valid domains)
- Topic: Kebab-case description (e.g., `vnet-peering`, `custom-vision`, `app-gateway`)
- Deployment Method: `tf` (Terraform) or `bicep` (Bicep)

Examples:
- AZ-104: `az104-networking-vnet-peering-tf`, `az104-storage-blob-lifecycle-bicep`
- AI-900: `ai900-cognitive-custom-vision-tf`, `ai900-ml-training-bicep`
- AZ-305: `az305-architecture-hub-spoke-tf`

### Resource Naming Conventions

Follow these prefixes (from GOVERNANCE.md):
- Virtual Network: `vnet-<name>`
- Subnet: `snet-<name>`
- Network Security Group: `nsg-<name>`
- Storage Account: `st<name>` (no hyphens, lowercase, max 24 chars)
- Virtual Machine: `vm-<name>-<instance>`
- Public IP: `pip-<name>`
- Load Balancer: `lb-<name>`
- Log Analytics Workspace: `law-<name>`

### Required Tags

**ALL resources must include these tags**:

```
Environment = "Lab"
Project     = "<EXAM>"    # e.g., "AZ-104", "AI-900", "AZ-305"
Domain      = "<Domain>"  # e.g., "Networking", "Storage", "Cognitive Services"
Purpose     = "<Purpose>" # What the lab demonstrates
Owner       = "Greg Tate"
DateCreated = "<YYYY-MM-DD>"  # Use current date
DeploymentMethod = "Terraform" or "Bicep"
```

---

## Terraform Requirements

### File Structure

**providers.tf**:
```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    # Add additional providers as needed (e.g., random, time, etc.)
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.lab_subscription_id
}
```

**Note**: Include additional providers (random, time, etc.) in required_providers section as needed for the lab.

**variables.tf**:
- **REQUIRED**: Include `lab_subscription_id` variable (sensitive, no default)
- Include domain validation constraint
- Set default location to `eastus`
- Include all required variables with descriptions
- Add owner variable with default "Greg Tate"

Example:
```hcl
variable "lab_subscription_id" {
  description = "Azure subscription ID for lab resources"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "<EXAM> exam domain"
  type        = string
  validation {
    condition     = contains([<domain-list>], var.domain)
    error_message = "Domain must be one of the valid <EXAM> domains."
  }
}

# Note: Replace <domain-list> with exam-specific domains from governance file
# AZ-104 example: ["identity", "networking", "storage", "compute", "monitoring"]
# AI-900 example: ["ai-concepts", "ml", "cognitive-services", "computer-vision", "nlp"]

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "owner" {
  description = "Lab owner"
  type        = string
  default     = "Greg Tate"
}
```

**main.tf** (orchestration layer):
- Define locals for resource group name and common tags
- Use standardized naming patterns
- Call modules for resource creation — keep `main.tf` as a thin orchestration layer
- Pass `common_tags`, `location`, and naming values into modules
- **Do NOT define individual resources directly in `main.tf`** when a module is more appropriate

**outputs.tf**:
- Output resource IDs
- Output connection strings (if applicable)
- Output any important resource properties for validation
- Reference module outputs (e.g., `module.networking.vnet_id`)
- **CRITICAL**: Output any generated admin passwords (marked as `sensitive = true`) so users can access resources

### Credentials and Secrets

**CRITICAL**: For lab environments, automatically generate friendly admin passwords that are easy to type but still meet complexity requirements:

**Terraform**:
- Use `random_integer` to create variation in a friendly password pattern
- Include `random` provider in `required_providers`
- Mark password outputs as `sensitive = true`
- Output passwords so users can access resources

Example:
```hcl
# In providers.tf, add to required_providers:
random = {
  source  = "hashicorp/random"
  version = "~> 3.0"
}

# In main.tf or module:
resource "random_integer" "password_suffix" {
  min = 1000
  max = 9999
}

locals {
  admin_password = "AzureLab${random_integer.password_suffix.result}!"
}

# In outputs.tf:
output "admin_password" {
  description = "Generated admin password for resources (friendly format)"
  value       = local.admin_password
  sensitive   = true
}
```

**Bicep**:
- Use a friendly pattern with minimal variation for easy typing
- Ensure complexity requirements are met (uppercase, lowercase, numbers, special characters)
- Output passwords for user reference

Example:
```bicep
// In main.bicep:
var adminPassword = 'AzureLab${uniqueString(resourceGroup().id, '2026')}!'

// Or for even more friendly:
var adminPassword = 'AzureLab2026!'

// In outputs:
@description('Admin password for resources (friendly format)')
output adminPassword string = adminPassword
```

**Friendly Password Patterns**:
- `AzureLab2026!` - Simple, meets complexity (uppercase, lowercase, numbers, special)
- `LabPassword${variation}!` - Pattern with variation
- `Learning@Azure123` - Descriptive and memorable
- `Demo${year}Pass!` - Year-based variation

**Note**: Since this is a lab environment, these friendly passwords and their outputs are acceptable. In production, use Key Vault and avoid predictable patterns.

### Terraform Modules

**When to create modules**: Use modules when the lab creates **3 or more related resources** within a logical grouping (e.g., networking, compute, storage). For very simple labs with only 1-2 resources total, modules are optional.

**Module structure** — each module in `modules/<group>/`:
- `main.tf` — resource definitions
- `variables.tf` — input variables (tags, location, names, etc.)
- `outputs.tf` — values needed by other modules or root outputs

**Module design principles**:
- Group resources by logical domain: `modules/networking/`, `modules/compute/`, `modules/storage/`, etc.
- Each module should be self-contained — it receives everything it needs via variables
- Pass `common_tags` as a `map(string)` variable and merge with any resource-specific tags
- Keep inter-module dependencies explicit via output references

**Example module call in main.tf**:
```hcl
module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.lab.name
  location            = var.location
  vnet_name           = "vnet-lab"
  tags                = local.common_tags
}

module "compute" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.lab.name
  location            = var.location
  subnet_id           = module.networking.subnet_id
  vm_size             = "Standard_B2s"
  tags                = local.common_tags
}
```

**Note**: The resource group itself is typically defined in `main.tf` (not in a module) since most modules need its name as an input.

**terraform.tfvars**:

Create `terraform.tfvars` based on the shared template with lab-specific subscription ID:

```hcl
# -------------------------------------------------------------------------
# Program: terraform.tfvars
# Description: Lab-specific variable values for [lab description]
# Context: <EXAM> Lab - [scenario description]
# Author: Greg Tate
# Date: [YYYY-MM-DD]
# -------------------------------------------------------------------------
#
# IMPORTANT: This file is in .gitignore to prevent committing sensitive values
# -------------------------------------------------------------------------

# Azure lab subscription ID (REQUIRED)
lab_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"

# Optional overrides
location = "eastus"
owner    = "Greg Tate"

# Add lab-specific variables here if needed
# Example: container_name = "data"

# NOTE: Do NOT add admin passwords here - use random_password resource instead
```

**CRITICAL**: Always use subscription ID `e091f6e7-031a-4924-97bb-8c983ca5d21a` in terraform.tfvars

**CRITICAL**: Never define admin password variables in variables.tf or terraform.tfvars - always generate them using `random_password` resource

### Terraform Validation Steps

After generating files, you must run these commands in the terminal and include the output in your response:

```powershell
# CRITICAL: Switch to Lab Azure profile first
Use-AzProfile Lab

# Verify terraform.tfvars exists
Test-Path terraform.tfvars

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt

# Show what will be created
terraform plan
```

Confirm these commands succeed before considering the task complete.

**Note**: The terraform.tfvars file should already be created with the lab subscription ID.

---

## Bicep Requirements

### File Structure

**main.bicep** (orchestration layer):
- Use `@allowed()` decorator for domain parameter
- Define commonTags variable
- Use kebab-case for resource symbolic names
- Apply tags to all resources
- Use latest stable API versions
- Call modules for resource creation — keep `main.bicep` as a thin orchestration layer
- **Do NOT define individual resources directly in `main.bicep`** when a module is more appropriate

**main.bicepparam**:
```bicep
using './main.bicep'

param domain = '<domain>'
param topic = '<topic>'
param location = 'eastus'
param owner = 'Greg Tate'
```

**outputs** (in main.bicep):
- Output resource IDs
- Output relevant properties for validation
- **CRITICAL**: Output any generated admin passwords so users can access resources
- Reference module outputs (e.g., `networking.outputs.vnetId`)

### Bicep Modules

**When to create modules**: Use modules when the lab creates **3 or more related resources** within a logical grouping (e.g., networking, compute, storage). For very simple labs with only 1-2 resources total, modules are optional.

**Module structure** — each module in `modules/`:
- `modules/<group>.bicep` (e.g., `modules/networking.bicep`, `modules/compute.bicep`)
- Declare parameters for all inputs (tags, location, names, etc.)
- Declare outputs for values needed by other modules or the root template

**Module design principles**:
- Group resources by logical domain: `networking.bicep`, `compute.bicep`, `storage.bicep`, etc.
- Each module should be self-contained — it receives everything it needs via parameters
- Pass `commonTags` as an `object` parameter and use `union()` with any resource-specific tags
- Keep inter-module dependencies explicit via output references

**Example module call in main.bicep**:
```bicep
// Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: commonTags
}

// Networking module
module networking 'modules/networking.bicep' = {
  scope: resourceGroup
  name: 'networking-deployment'
  params: {
    location: location
    vnetName: 'vnet-lab'
    tags: commonTags
  }
}

// Compute module
module compute 'modules/compute.bicep' = {
  scope: resourceGroup
  name: 'compute-deployment'
  params: {
    location: location
    subnetId: networking.outputs.subnetId
    vmSize: 'Standard_B2s'
    tags: commonTags
  }
}
```

**Example module file** (`modules/networking.bicep`):
```bicep
@description('Azure region for resources')
param location string

@description('Name of the virtual network')
param vnetName string

@description('Tags to apply to all resources')
param tags object

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
  }
}

@description('The resource ID of the virtual network')
output vnetId string = vnet.id
```

**Note**: The resource group is typically defined in `main.bicep` (as a subscription-scoped deployment) and modules are scoped to it.

**bicep.ps1**:
- Always copy `bicep.ps1` from `<EXAM>/hands-on-labs/_shared/bicep/bicep.ps1` into the lab's `bicep/` folder so it sits beside `main.bicep`

Example copy command:
```bash
cp <EXAM>/hands-on-labs/_shared/bicep/bicep.ps1 <EXAM>/hands-on-labs/<domain>/lab-<topic>/bicep/bicep.ps1
```

### Deployment Stacks & bicep.ps1

The `bicep.ps1` wrapper script manages deployment stacks with built-in subscription safety.

**Stack Naming**: The script auto-derives stack names from `main.bicepparam`:
- Pattern: `stack-<domain>-<topic>` (extracted from domain/topic parameters)
- Example: If `domain = "networking"` and `topic = "vnet-peering"`, stack name is `stack-networking-vnet-peering`

**Available Commands**:
```powershell
.\bicep.ps1 validate       # Validates Bicep syntax
.\bicep.ps1 plan           # Shows what-if preview (requires subscription validation)
.\bicep.ps1 apply          # Deploys with subscription-level stack (validates subscription first)
.\bicep.ps1 destroy        # Removes stack and all resources (validates subscription first)
.\bicep.ps1 show           # Shows current stack details
.\bicep.ps1 list           # Lists all stacks in subscription
```

**Subscription Safety**: The script validates you're using the correct lab subscription before any deployment operations. It will block operations targeting wrong subscriptions.

**Direct Azure CLI Alternative** (not recommended - use bicep.ps1 instead):
```bash
# Only use if bicep.ps1 is unavailable
az stack sub create \
  --name stack-<domain>-<topic> \
  --location eastus \
  --template-file main.bicep \
  --parameters main.bicepparam \
  --deny-settings-mode none \
  --action-on-unmanage deleteAll
```

### Bicep Validation Steps

After generating files, you must run these commands in the terminal and include the output in your response:

```powershell
# CRITICAL: Switch to Lab Azure profile first
Use-AzProfile Lab

# Validate Bicep syntax using bicep.ps1 wrapper
.\bicep.ps1 validate

# Show what will be deployed (what-if/plan)
.\bicep.ps1 plan
```

Confirm these commands succeed before considering the task complete.

---

## README.md Template

Create a comprehensive README with this structure:

```markdown
# Lab: [Lab Title]

## Exam Question Scenario

[Paste the original exam question scenario here]

## Scenario Analysis

[Break down what the scenario requires]

## Solution Architecture

[Describe the Azure resources needed and their relationships]

**Cost Optimization**: This lab uses cost-effective resources:
- VMs: Standard_B2s (or B1s for minimal scenarios)
- [List other cost-optimized resource SKUs/tiers used]
- [Note if any higher-cost resources are required and why]

## Prerequisites

- Azure CLI installed and authenticated
- [Terraform OR Bicep] installed
- Azure subscription with appropriate permissions
- Resource provider registered: [list providers]

**CRITICAL**: Before executing ANY Azure CLI, Terraform, or Bicep commands, you MUST switch to the Lab Azure profile:

```powershell
Use-AzProfile Lab
```

This ensures all commands execute in the correct Lab subscription environment. The profile switch persists for the terminal session.

### Terraform Prerequisites

**CRITICAL**: Switch to Lab Azure profile before any Terraform operations:

```powershell
Use-AzProfile Lab
```

Ensure you have a `terraform.tfvars` file with your subscription ID:

```bash
# The terraform.tfvars should contain:
lab_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"
```

Register the provider if needed:
```bash
az provider register --namespace Microsoft.Storage  # or other required providers
```

## Lab Objectives

1. [Objective 1]
2. [Objective 2]
3. [Objective 3]

## Deployment

### [Terraform OR Bicep] Deployment

1. **CRITICAL**: Switch to Lab Azure profile:
   ```powershell
   Use-AzProfile Lab
   ```

2. Navigate to the terraform/bicep directory:
   ```bash
   cd terraform  # or cd bicep
   ```

3. [For Terraform]:
   Verify terraform.tfvars exists with your subscription ID:
   ```bash
   # File should already exist with lab subscription ID
   cat terraform.tfvars
   ```

   Initialize Terraform:
   ```bash
   terraform init
   ```

   Validate the configuration:
   ```bash
   terraform validate
   ```

   Review the planned changes:
   ```bash
   terraform plan
   ```

   Deploy the infrastructure:
   ```bash
   terraform apply
   ```
View generated credentials (if applicable):
   ```bash
   terraform output admin_password
   # or
   terraform output -json
   ```

   [For Bicep]:
   Ensure you've switched to the Lab profile (step 1), then validate the Bicep template:
   ```powershell
   .\bicep.ps1 validate
   ```

   Review the planned changes (what-if):
   ```powershell
   .\bicep.ps1 plan
   ```

   Deploy the infrastructure:
   ```powershell
   .\bicep.ps1 apply
   ```

   View outputs including generated credentials:
   ```powershell
   .\bicep.ps1 show
   # Look for adminPassword or similar in the outputs section
   .\bicep.ps1 apply
   ```

## Validation Steps

[Detailed steps to verify the deployment meets the scenario requirements]

## Testing the Solution

[Step-by-step testing procedures to validate the solution works as expected]

## Cleanup

### [Terraform OR Bicep] Cleanup

**CRITICAL**: Ensure you're using the Lab profile before cleanup:

```powershell
Use-AzProfile Lab
```

[For Terraform]:
```bash
terraform destroy
```

[For Bicep]:
```powershell
.\bicep.ps1 destroy
```

## Key Learning Points

- [Learning point 1]
- [Learning point 2]
- [Learning point 3]

## Related <EXAM> Exam Objectives

[List relevant exam objectives this lab covers]

## Additional Resources

- [Relevant Microsoft Learn modules]
- [Azure documentation links]
```

---

## Workflow

1. **Determine exam** from workspace context or prompt user if unclear
2. **Read governance file** for exam-specific domains and requirements
3. **Analyze** the exam question scenario provided
4. **Identify** required Azure resources and their configuration
5. **Create** directory structure under `<EXAM>/hands-on-labs/<domain>/lab-<topic>/`
6. **Copy** `bicep.ps1` into the lab's `bicep/` folder for Bicep labs
7. **Generate** infrastructure code (Terraform OR Bicep as specified)
8. **Create terraform.tfvars** (Terraform only) with lab subscription ID: `e091f6e7-031a-4924-97bb-8c983ca5d21a`
9. **Validate** the code using appropriate tool commands
  - **Terraform**: Always run `terraform init`, `terraform validate`, and `terraform plan`
  - **Bicep**: Always run `bicep.ps1 validate` and `bicep.ps1 plan`
10. **Create** comprehensive README.md with all required sections
11. **Include** validation/testing scripts if complex verification is needed
12. **Verify** all governance standards are met:
    - [ ] Exam determined correctly
    - [ ] Resource group naming follows pattern with correct exam prefix
    - [ ] All resources have required tags (with correct Project value)
    - [ ] Resource names follow conventions
    - [ ] Domain is valid for the exam
    - [ ] Location is `eastus` (or allowed region)
    - [ ] Code follows header format with correct exam context
    - [ ] terraform.tfvars created with correct subscription ID
    - [ ] Validation commands run successfully

---

## Output Format

After creating the lab, provide:

1. **Lab Summary**: Brief description of what was created
2. **File List**: All files created with their paths (including terraform.tfvars with subscription ID confirmation)
3. **Validation Results**: Output from validation commands (including confirmation that terraform.tfvars exists)
4. **Quick Start**: Condensed deployment steps
5. **Next Steps**: Suggestions for additional learning or variations

**CRITICAL Validation**: Confirm terraform.tfvars contains subscription ID `e091f6e7-031a-4924-97bb-8c983ca5d21a`

---

## Example Invocations

```
Create a Terraform hands-on lab for the following AZ-104 exam question:

[Paste exam question here]
```

```
Create a Bicep hands-on lab for the following AI-900 exam question:

[Paste exam question here]
```

### With Context-Based Exam Detection
```
[User is in AZ-104/hands-on-labs/ directory]

Create a Terraform hands-on lab for the following exam question:

[Paste exam question here]
```

### When Exam Cannot Be Determined
If you cannot determine the exam from context or the user's request, ask:

```
Which exam is this lab for? (e.g., AZ-104, AI-900, AZ-305)
```

Then proceed with the appropriate exam-specific configuration.

[Paste exam question here]
```
