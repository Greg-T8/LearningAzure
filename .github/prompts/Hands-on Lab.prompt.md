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

**CRITICAL**: Read and strictly follow the governance requirements in:
- `#file:<EXAM>/hands-on-labs/GOVERNANCE.md` (replace `<EXAM>` with the determined exam)

The GOVERNANCE.md file is the **single source of truth** for:
- Naming conventions (resource groups, resources, deployment stacks)
- Tagging requirements (all required tags)
- Location policies and allowed regions
- Tool-specific standards (Terraform/Bicep file structure, providers, versions)
- Cost management policies
- Documentation requirements
- Pre-deployment checklist

**Always consult GOVERNANCE.md** for these standards rather than relying on memory or assumptions.

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

**CRITICAL**: Consult `GOVERNANCE.md` for complete naming and tagging specifications.

### Quick Reference

**Resource Group Pattern**: `<exam-prefix>-<domain>-<topic>-<deployment_method>`
- Example: `az104-networking-vnet-peering-tf`

**Resource Naming**: Follow standardized prefixes defined in GOVERNANCE.md
- VNet: `vnet-<name>`, Storage: `st<name>`, VM: `vm-<name>-<instance>`, etc.

**Required Tags**: All resources must include 7 required tags (see GOVERNANCE.md):
- Environment, Project, Domain, Purpose, Owner, DateCreated, DeploymentMethod

**Stack Naming (Bicep)**: `stack-<domain>-<topic>`
- Example: `stack-networking-vnet-peering`

---

## Azure Resource Configuration Best Practices

When creating Azure resources, follow these configuration best practices to avoid common deployment errors:

### Load Balancer with Outbound Rules

**CRITICAL**: When configuring Standard Load Balancers with BOTH load balancing rules AND outbound rules that share the same frontend IP configuration:

- **Always set `disableOutboundSnat: true`** on the load balancing rule
- This prevents SNAT port allocation conflicts between the two rule types
- Azure requires this when a frontend IP is referenced by both rule types

Example (Bicep):
```bicep
loadBalancingRules: [
  {
    name: 'my-lb-rule'
    properties: {
      // ... other properties ...
      disableOutboundSnat: true  // REQUIRED when frontend IP is also in outbound rules
    }
  }
]
```

Example (Terraform):
```hcl
resource "azurerm_lb_rule" "example" {
  # ... other properties ...
  disable_outbound_snat = true  # REQUIRED when frontend IP is also in outbound rules
}
```

**Error if omitted**: `LoadBalancingRuleMustDisableSNATSinceSameFrontendIPConfigurationIsReferencedByOutboundRule`

### Other Common Pitfalls

- **Network Security Groups**: Ensure required ports are open for service functionality (e.g., port 80 for HTTP, 443 for HTTPS)
- **Public IP SKUs**: Standard Load Balancers require Standard SKU public IPs, not Basic
- **Subnet Delegation**: Some services (e.g., Azure Container Instances, Azure Databricks) require subnet delegation
- **Resource Dependencies**: Use explicit `dependsOn` only when implicit dependencies don't capture the relationship

---

## Terraform Requirements

**CRITICAL**: Consult `GOVERNANCE.md` for complete Terraform standards (versions, state management, file structure).

### File Structure Overview

Create these files following GOVERNANCE.md specifications:
- **providers.tf**: Terraform version ≥1.0, azurerm provider ~>4.0, additional providers as needed
- **variables.tf**: Required variables with validation (lab_subscription_id, domain, location, owner)
- **main.tf**: Thin orchestration layer calling modules
- **outputs.tf**: Resource IDs, connection strings, **generated passwords** (sensitive)
- **terraform.tfvars**: Lab subscription ID and overrides (gitignored)
- **modules/**: Logical resource groupings (when ≥3 related resources)

### Key Requirements

**Subscription ID**:
- Always use: `e091f6e7-031a-4924-97bb-8c983ca5d21a`
- Store in `terraform.tfvars` (not committed to git)

**Domain Validation**:
```hcl
variable "domain" {
  description = "<EXAM> exam domain"
  type        = string
  validation {
    condition     = contains([<domain-list>], var.domain)
    error_message = "Domain must be one of valid <EXAM> domains."
  }
}
# Consult GOVERNANCE.md for exam-specific domain lists
```

**Common Tags**:
```hcl
locals {
  common_tags = {
    Environment      = "Lab"
    Project          = "<EXAM>"
    Domain           = title(var.domain)
    Purpose          = replace(title(var.topic), "-", " ")
    Owner            = var.owner
    DateCreated      = formatdate("YYYY-MM-DD", timestamp())
    DeploymentMethod = "Terraform"
  }
}
```

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

### terraform.tfvars Template

```hcl
# -------------------------------------------------------------------------
# Program: terraform.tfvars
# Description: Lab-specific variable values for [lab description]
# Context: <EXAM> Lab - [scenario description]
# Author: Greg Tate
# Date: [YYYY-MM-DD]
# -------------------------------------------------------------------------

# Azure lab subscription ID (REQUIRED)
lab_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"

# Optional overrides
location = "eastus"
owner    = "Greg Tate"

# Add lab-specific variables as needed
# NOTE: Do NOT add admin passwords - use random_password resource instead
```

### Validation Steps

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

**CRITICAL**: Consult `GOVERNANCE.md` for complete Bicep standards (configuration, file structure, parameter files).

### File Structure Overview

Create these files following GOVERNANCE.md specifications:
- **main.bicep**: Thin orchestration layer with @allowed() decorator for domain, commonTags variable
- **main.bicepparam**: Parameter values (domain, topic, location, owner)
- **modules/*.bicep**: Logical resource groupings (when ≥3 related resources)
- **bicep.ps1**: Deployment wrapper script (copy from `_shared/bicep/bicep.ps1`)

### Key Requirements

**Domain Validation**:
```bicep
@allowed(['identity', 'networking', 'storage', 'compute', 'monitoring'])
param domain string
// Consult GOVERNANCE.md for exam-specific domain lists
```

**Common Tags**:
```bicep
var commonTags = {
  Environment: 'Lab'
  Project: '<EXAM>'
  Domain: toUpper(substring(domain, 0, 1)) + substring(domain, 1)
  Purpose: replace(topic, '-', ' ')
  Owner: owner
  DateCreated: dateCreated
  DeploymentMethod: 'Bicep'
}
```

**Outputs**: Include resource IDs, validation properties, and **generated passwords** (sensitive)

### Module Design

**When to use modules**: ≥3 related resources in logical groupings

**Module principles**:
- Group by domain (networking.bicep, compute.bicep, storage.bicep)
- Self-contained with parameters for all inputs
- Pass commonTags as object parameter, use union() for resource-specific tags
- Explicit dependencies via output references

**Example**:
```bicep
module networking 'modules/networking.bicep' = {
  scope: resourceGroup
  name: 'networking-deployment'
  params: {
    location: location
    vnetName: 'vnet-lab'
    tags: commonTags
  }
}
```

### Deployment Stacks & bicep.ps1

**Copy bicep.ps1**: Always copy from `<EXAM>/hands-on-labs/_shared/bicep/bicep.ps1` to lab's `bicep/` folder

**Stack Naming**: Auto-derived as `stack-<domain>-<topic>` from parameters

**Commands**:
- `.\bicep.ps1 validate` - Validates syntax
- `.\bicep.ps1 plan` - What-if preview
- `.\bicep.ps1 apply` - Deploy stack
- `.\bicep.ps1 destroy` - Remove all resources
- `.\bicep.ps1 show` - Stack details

**Subscription Safety**: Script validates correct lab subscription before operations

### Validation Steps

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
2. **Read GOVERNANCE.md** for exam-specific domains, naming conventions, and all compliance requirements
3. **Analyze** the exam question scenario provided
4. **Identify** required Azure resources and their configuration
5. **Create** directory structure under `<EXAM>/hands-on-labs/<domain>/lab-<topic>/`
6. **Copy** `bicep.ps1` into the lab's `bicep/` folder for Bicep labs
7. **Generate** infrastructure code (Terraform OR Bicep as specified)
   - Apply naming conventions from GOVERNANCE.md
   - Include required tags from GOVERNANCE.md
   - Follow tool-specific standards from GOVERNANCE.md
8. **Create terraform.tfvars** (Terraform only) with lab subscription ID: `e091f6e7-031a-4924-97bb-8c983ca5d21a`
9. **Validate** the code using appropriate tool commands
   - **Terraform**: Run `terraform init`, `terraform validate`, `terraform plan`
   - **Bicep**: Run `.\bicep.ps1 validate`, `.\bicep.ps1 plan`
10. **Create** comprehensive README.md with all required sections
11. **Include** validation/testing scripts if complex verification is needed
12. **Verify** all GOVERNANCE.md standards are met - consult the pre-deployment checklist in GOVERNANCE.md

---

## Output Format

After creating the lab, provide:

1. **Lab Summary**: Brief description of what was created
2. **File List**: All files created with their paths
3. **Validation Results**: Output from validation commands
4. **Quick Start**: Condensed deployment steps
5. **Governance Compliance**: Confirm alignment with GOVERNANCE.md standards
6. **Next Steps**: Suggestions for additional learning or variations

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
