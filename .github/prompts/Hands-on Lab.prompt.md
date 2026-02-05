---
name: Hands-on Lab
description: Creates a hands-on lab from an exam question scenario using Terraform or Bicep, following governance standards
---

# Hands-on Lab Generator

You are tasked with creating a comprehensive hands-on lab based on an exam question scenario. The lab must follow strict governance standards and produce working, validated infrastructure-as-code.

## Context Files

Read and strictly follow the governance requirements in:
- `#file:AZ-104/hands-on-labs/GOVERNANCE.md`

Read and follow coding standards from:
- `#file:c:/Users/gregt/OneDrive/Apps/Profiles/VSCode/instructions/General Coding Guidelines.instructions.md`
- `#file:c:/Users/gregt/OneDrive/Apps/Profiles/VSCode/instructions/PowerShell Style Guidelines.instructions.md` (if creating PowerShell scripts)

## Lab Structure Requirements

Create the following structure in `AZ-104/hands-on-labs/<domain>/lab-<topic>/`:

```
lab-<topic>/
├── README.md
├── terraform/  OR  bicep/
│   ├── main.tf (or main.bicep)
│   ├── variables.tf (or main.bicepparam)
│   ├── outputs.tf (or outputs.bicep)
│   ├── providers.tf (Terraform only)
│   └── terraform.tfvars (Terraform - with lab subscription ID)
└── validation/
    └── test-<scenario>.ps1 (optional validation scripts)
```

**Note**: `terraform.tfvars` contains the lab subscription ID and is created for each lab.

## Resource Group Naming

**CRITICAL**: Follow this pattern exactly:
- Pattern: `az104-<domain>-<topic>-<deployment_method>`
- Domain: One of `identity`, `networking`, `storage`, `compute`, `monitoring`
- Topic: Kebab-case description (e.g., `vnet-peering`, `rbac-roles`)
- Deployment Method: `tf` (Terraform) or `bicep` (Bicep)

Examples:
- `az104-networking-vnet-peering-tf`
- `az104-storage-blob-lifecycle-bicep`

## Resource Naming Conventions

Follow these prefixes (from GOVERNANCE.md):
- Virtual Network: `vnet-<name>`
- Subnet: `snet-<name>`
- Network Security Group: `nsg-<name>`
- Storage Account: `st<name>` (no hyphens, lowercase, max 24 chars)
- Virtual Machine: `vm-<name>-<instance>`
- Public IP: `pip-<name>`
- Load Balancer: `lb-<name>`
- Log Analytics Workspace: `law-<name>`

## Required Tags

**ALL resources must include these tags**:

```
Environment = "Lab"
Project     = "AZ-104"
Domain      = "<Domain>"  # e.g., "Networking", "Storage"
Purpose     = "<Purpose>" # What the lab demonstrates
Owner       = "Greg Tate"
DateCreated = "<YYYY-MM-DD>"  # Use current date
DeploymentMethod = "Terraform" or "Bicep"
```

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

## Prerequisites

- Azure CLI installed and authenticated
- [Terraform OR Bicep] installed
- Azure subscription with appropriate permissions
- Resource provider registered: [list providers]

### Terraform Prerequisites

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

1. Navigate to the terraform/bicep directory:
   ```bash
   cd terraform  # or cd bicep
   ```

2. [For Terraform]:
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

   [For Bicep]:
   Create deployment stack:
   ```bash
   az stack sub create \
     --name stack-<domain>-<topic> \
     --location eastus \
     --template-file main.bicep \
     --parameters main.bicepparam \
     --deny-settings-mode none
   ```

## Validation Steps

[Detailed steps to verify the deployment meets the scenario requirements]

## Testing the Solution

[Step-by-step testing procedures to validate the solution works as expected]

## Cleanup

### [Terraform OR Bicep] Cleanup

[For Terraform]:
```bash
terraform destroy
```

[For Bicep]:
```bash
az stack sub delete --name stack-<domain>-<topic> --delete-all
```

## Key Learning Points

- [Learning point 1]
- [Learning point 2]
- [Learning point 3]

## Related AZ-104 Exam Objectives

[List relevant exam objectives this lab covers]

## Additional Resources

- [Relevant Microsoft Learn modules]
- [Azure documentation links]
```

## Terraform-Specific Requirements

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
  description = "AZ-104 exam domain"
  type        = string
  validation {
    condition     = contains(["identity", "networking", "storage", "compute", "monitoring"], var.domain)
    error_message = "Domain must be: identity, networking, storage, compute, or monitoring."
  }
}

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

**main.tf**:
- Define locals for resource group name and common tags
- Use standardized naming patterns
- Apply common_tags to all resources
- Include comments following General Coding Guidelines

**outputs.tf**:
- Output resource IDs
- Output connection strings (if applicable)
- Output any important resource properties for validation

**terraform.tfvars** (copy from template):

Create `terraform.tfvars` based on the shared template with lab-specific subscription ID:

```hcl
# -------------------------------------------------------------------------
# Program: terraform.tfvars
# Description: Lab-specific variable values for [lab description]
# Context: AZ-104 Lab - [scenario description]
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
```

**CRITICAL**: Always use subscription ID `e091f6e7-031a-4924-97bb-8c983ca5d21a` in terraform.tfvars

### Validation Steps

After generating files, include these steps in your response:

```bash
# Verify terraform.tfvars exists
test -f terraform.tfvars && echo "✓ terraform.tfvars found" || echo "✗ Create terraform.tfvars"

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

## Bicep-Specific Requirements

### File Structure

**main.bicep**:
- Use `@allowed()` decorator for domain parameter
- Define commonTags variable
- Use kebab-case for resource symbolic names
- Apply tags to all resources
- Include comments following General Coding Guidelines
- Use latest stable API versions

**main.bicepparam**:
```bicep
using './main.bicep'

param domain = '<domain>'
param topic = '<topic>'
param location = 'eastus'
param owner = 'Greg Tate'
```

**outputs.bicep** (or outputs in main.bicep):
- Output resource IDs
- Output relevant properties for validation

### Validation Steps

After generating files, include these steps in your response:

```bash
# Validate Bicep syntax
az bicep build --file main.bicep

# Show what will be deployed
az deployment sub what-if \
  --location eastus \
  --template-file main.bicep \
  --parameters main.bicepparam
```

Confirm these commands succeed before considering the task complete.

## Deployment Stack Requirements (Bicep)

When using Bicep, create a deployment stack using this pattern:

**Stack Name**: `stack-<domain>-<topic>`
- Example: `stack-networking-vnet-peering`
- Note: No `-bicep` suffix needed

**Subscription-level deployment stack**:
```bash
az stack sub create \
  --name stack-<domain>-<topic> \
  --location eastus \
  --template-file main.bicep \
  --parameters main.bicepparam \
  --deny-settings-mode none \
  --action-on-unmanage deleteAll
```

**Cleanup**:
```bash
az stack sub delete \
  --name stack-<domain>-<topic> \
  --action-on-unmanage deleteAll \
  --yes
```

## Coding Standards Compliance

Follow the workspace coding guidelines:

1. **Header Comments**: Every file must have a header section:
   ```
   # -------------------------------------------------------------------------
   # Program: [filename]
   # Description: [what this does]
   # Context: AZ-104 Lab - [scenario description]
   # Author: Greg Tate
   # Date: [YYYY-MM-DD]
   # -------------------------------------------------------------------------
   ```

2. **Code Block Comments**: Add comments above code blocks separated by blank lines

3. **Naming**: Use clear, descriptive names for all resources and variables

## Workflow

1. **Analyze** the exam question scenario provided
2. **Identify** required Azure resources and their configuration
3. **Create** directory structure under `AZ-104/hands-on-labs/<domain>/lab-<topic>/`
4. **Generate** infrastructure code (Terraform OR Bicep as specified)
5. **Create terraform.tfvars** (Terraform only) with lab subscription ID: `e091f6e7-031a-4924-97bb-8c983ca5d21a`
6. **Validate** the code using appropriate tool commands
7. **Create** comprehensive README.md with all required sections
8. **Include** validation/testing scripts if complex verification is needed
9. **Verify** all governance standards are met:
   - [ ] Resource group naming follows pattern
   - [ ] All resources have required tags
   - [ ] Resource names follow conventions
   - [ ] Location is `eastus` (or allowed region)
   - [ ] Code follows header format
   - [ ] terraform.tfvars created with correct subscription ID
   - [ ] Validation commands run successfully

## Output Format

After creating the lab, provide:

1. **Lab Summary**: Brief description of what was created
2. **File List**: All files created with their paths (including terraform.tfvars with subscription ID confirmation)
3. **Validation Results**: Output from validation commands (including confirmation that terraform.tfvars exists)
4. **Quick Start**: Condensed deployment steps
5. **Next Steps**: Suggestions for additional learning or variations

**CRITICAL Validation**: Confirm terraform.tfvars contains subscription ID `e091f6e7-031a-4924-97bb-8c983ca5d21a`

## Example Invocation

```
Create a Terraform hands-on lab for the following AZ-104 exam question:

[Paste exam question here]
```

or

```
Create a Bicep hands-on lab using deployment stacks for the following AZ-104 exam question:

[Paste exam question here]
```