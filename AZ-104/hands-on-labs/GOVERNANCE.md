# Hands-On Labs Governance Policy

Standards and naming conventions for all Terraform and Bicep implementations in AZ-104 hands-on labs.

---

## General Policies

### Location Policy

| Setting | Value | Rationale |
|---------|-------|-----------|
| Default Region | `eastus` | Cost-effective, wide service availability |
| Allowed Regions | `eastus`, `eastus2`, `westus2` | Limit to minimize latency and cost |

### Tagging Policy

All resources **must** include these tags:

| Tag | Description | Example |
|-----|-------------|---------|
| `Environment` | Fixed value | `Lab` |
| `Project` | Certification context | `AZ-104` |
| `Domain` | Exam domain | `Networking` |
| `Purpose` | What the lab demonstrates | `VNet Peering` |
| `Owner` | Your identifier | `Greg Tate` |
| `DateCreated` | Resource creation date | `2026-02-05` |
| `DeploymentMethod` | IaC tool used | `Terraform` or `Bicep` |

---

## Quick Reference

### Domain to Resource Type Mapping

| Domain | Common Resource Types |
|--------|----------------------|
| `identity` | Resource Groups, RBAC Roles, Managed Identities, Key Vaults |
| `networking` | VNets, Subnets, NSGs, Load Balancers, Public IPs, NAT Gateways, Application Gateways, Bastion |
| `storage` | Storage Accounts, Blob Containers, File Shares, Disks |
| `compute` | Virtual Machines, VM Scale Sets, Availability Sets, App Services |
| `monitoring` | Log Analytics Workspaces, Recovery Services Vaults, Action Groups, Alerts |

---

## Naming Conventions

### Resource Group Naming

**Pattern:** `<exam>-<domain>-<topic>-<deployment_method>`

| Segment | Description | Allowed Values |
|---------|-------------|----------------|
| `<exam>` | Fixed prefix for all labs | `az104` |
| `<domain>` | AZ-104 exam domain | `identity`, `networking`, `storage`, `compute`, `monitoring` |
| `<topic>` | Lab topic (kebab-case) | e.g., `vnet-peering`, `load-balancer`, `rbac-roles` |
| `<deployment_method>` | IaC tool used | `tf` (Terraform), `bicep` (Bicep) |

**Examples:**

| Lab | Deployment | Resource Group Name |
|-----|------------|---------------------|
| VNet Peering | Terraform | `az104-networking-vnet-peering-tf` |
| VNet Peering | Bicep | `az104-networking-vnet-peering-bicep` |
| Custom RBAC Roles | Terraform | `az104-identity-rbac-roles-tf` |
| Storage Lifecycle | Bicep | `az104-storage-blob-lifecycle-bicep` |
| VM Availability Sets | Terraform | `az104-compute-vm-availability-tf` |
| Log Analytics | Bicep | `az104-monitoring-log-analytics-bicep` |

### Resource Naming

**Pattern:** `<type>-<topic>[-<instance>]`

| Resource Type | Prefix | Example | Notes |
|---------------|--------|---------|-------|
| Virtual Network | `vnet` | `vnet-hub`, `vnet-spoke` | |
| Subnet | `snet` | `snet-web`, `snet-db` | |
| Network Security Group | `nsg` | `nsg-web` | |
| Network Interface | `nic` | `nic-vm-web-01` | |
| Load Balancer | `lb` | `lb-public` | |
| Public IP | `pip` | `pip-lb` | |
| NAT Gateway | `natgw` | `natgw-outbound` | |
| Application Gateway | `agw` | `agw-frontend` | |
| Azure Bastion | `bas` | `bas-management` | |
| Storage Account | `staz104` | `staz104vnetpeer01` | No hyphens; max 24 chars; globally unique; append random/sequence |
| Managed Disk | `disk` | `disk-vm-web-01-os` | |
| Virtual Machine | `vm` | `vm-web-01` | |
| Availability Set | `avset` | `avset-web` | |
| VM Scale Set | `vmss` | `vmss-web` | |
| App Service | `app` | `app-api` | Globally unique |
| Key Vault | `kv` | `kv-az104-secrets` | Globally unique; 3-24 chars |
| Log Analytics Workspace | `law` | `law-central` | |
| Recovery Services Vault | `rsv` | `rsv-backup` | |

### Deployment Stack Naming (Bicep-Specific)

**Pattern:** `stack-<domain>-<topic>`

**Note:** Deployment stack names don't include the `-bicep` suffix since they're Bicep-specific constructs.

**Example:** `stack-networking-vnet-peering`

---

## Cost Management

### Resource Cleanup Policy

- **Mandatory Cleanup:** All lab resources must be destroyed within **7 days** of creation
- **Tagging for Tracking:** Use `DateCreated` tag to identify resources approaching cleanup deadline
- **Exception Process:** Document permanent reference labs in `README.md` with justification

### Resource Limits

| Resource Type | Maximum per Lab | Rationale |
|---------------|-----------------|--------|
| Virtual Machines | 4 | Control costs; most labs don't need more |
| Public IPs | 5 | Limit exposure and costs |
| Storage Accounts | 3 | Sufficient for most scenarios |
| VNets | 4 | Typical hub-spoke plus extras |

### Cost Control Measures

- **VM Auto-Shutdown:** Configure 7:00 PM EST daily shutdown for all VMs
- **VM Sizing:** Use `Standard_B2s` or smaller unless lab specifically requires larger
- **Disk Type:** Use Standard HDD unless Premium SSD required for testing
- **Budget Alerts:** (Optional) Set up Azure Budget alerts at $50 threshold

### Resource SKU/Tier Standards

| Resource Type | Default SKU/Tier | Notes |
|---------------|------------------|-------|
| Virtual Machines | `Standard_B2s` (2 vCPU, 4 GB RAM) | General-purpose default |
| Virtual Machines (Minimal) | `Standard_B1s` (1 vCPU, 1 GB RAM) | Use for simple scenarios |
| Virtual Machines (High-Performance) | D-series or higher | Only when explicitly required by scenario |
| Storage Accounts | Standard LRS | Use unless redundancy required |
| Load Balancers | Basic SKU | Standard SKU only when required |
| Public IPs | Basic SKU | Standard SKU only for specific features |
| App Services | Free or Basic tier | Higher tiers only when needed |
| SQL Database | Basic or S0 tier | Higher tiers only for performance testing |
| Managed Disks | Standard HDD | Premium SSD only when required |

---

## Code Style Standards

### Header Comments

All code files (Terraform, Bicep, PowerShell) **must** include a header comment section:

```
# -------------------------------------------------------------------------
# Program: [filename]
# Description: [what this does]
# Context: AZ-104 Lab - [scenario description]
# Author: Greg Tate
# Date: [YYYY-MM-DD]
# -------------------------------------------------------------------------
```

### Code Commenting Rules

1. **Add comments above code blocks** separated by blank lines
2. **Code block definition**: Any of the following:
   - Group of declarations/initializations separated by blank lines
   - Single significant assignment separated by blank lines
   - Each loop (`for`, `while`) body
   - Each `if` / `else if` / `else` body
3. Comments must describe the **intent** of the code block
4. Use **clear, descriptive names** for all resources, variables, and modules

### Naming Conventions (Code)

- **Terraform**: Use snake_case for resource names, variables, locals
- **Bicep**: Use camelCase for parameters, variables; kebab-case for symbolic resource names
- **Both**: Resource name values must follow Azure naming prefixes (see Resource Naming section)

---

## Azure Resource Configuration Best Practices

These standards prevent common deployment errors and ensure reliable infrastructure code.

### Load Balancers with Outbound Rules

**CRITICAL**: When configuring Standard Load Balancers with BOTH load balancing rules AND outbound rules that share the same frontend IP configuration:

- **Always set `disableOutboundSnat: true`** (Bicep) or `disable_outbound_snat = true` (Terraform) on the load balancing rule
- This prevents SNAT port allocation conflicts between the two rule types
- Azure requires this when a frontend IP is referenced by both rule types

**Error if omitted**: `LoadBalancingRuleMustDisableSNATSinceSameFrontendIPConfigurationIsReferencedByOutboundRule`

### Network Security Groups

- Ensure required ports are open for service functionality:
  - Port 80 for HTTP
  - Port 443 for HTTPS
  - Port 22 for SSH (Linux)
  - Port 3389 for RDP (Windows)
- Document any custom ports in README
- Use specific source IP ranges when possible (avoid 0.0.0.0/0 except for public-facing services)

### Public IP SKU Compatibility

- **Standard Load Balancers** require **Standard SKU** public IPs (not Basic)
- **Basic Load Balancers** can use **Basic SKU** public IPs
- Standard SKU IPs support availability zones; Basic SKU does not

### Subnet Delegation

Some services require subnet delegation:

- Azure Container Instances: `Microsoft.ContainerInstance/containerGroups`
- Azure Databricks: `Microsoft.Databricks/workspaces`
- Azure NetApp Files: `Microsoft.NetApp/volumes`
- Document delegation requirements in README

### Resource Dependencies

- Prefer **implicit dependencies** (resource references) over explicit `depends_on`/`dependsOn`
- Use **explicit dependencies** only when:
  - Relationship is not captured by resource references
  - Timing/sequencing is critical (e.g., role assignments after resource creation)
- Document why explicit dependencies are needed with comments

---

## Documentation Requirements

### Required README.md Contents

Every lab directory must include a `README.md` with:

1. **Lab Overview**
   - Brief description of what the lab demonstrates
   - AZ-104 exam objective reference (e.g., "Configure and manage virtual networks (25-30%)")

2. **Prerequisites**
   - Azure CLI or PowerShell requirements
   - Required permissions (e.g., Contributor on subscription)
   - Any pre-existing resources needed

3. **Deployment Steps**

   ```bash
   # Terraform example
   terraform init
   terraform plan -var="domain=networking" -var="topic=vnet-peering"
   terraform apply -auto-approve
   ```

   ```powershell
   # Bicep example
   ./bicep.ps1 Plan
   ./bicep.ps1 Deploy
   ```

4. **Validation Steps**
   - How to verify the deployment worked
   - Expected outcomes or tests to run

5. **Cleanup Procedure**

   ```bash
   # Terraform
   terraform destroy -auto-approve
   
   # Bicep
   ./bicep.ps1 Destroy
   ```

6. **Troubleshooting** (if applicable)
   - Common issues and resolutions

---

## Tool-Specific Standards

### Terraform Standards

#### Provider Selection: AzureRM vs AzAPI

**Use AzureRM provider for all AZ-104 labs** unless a specific feature absolutely requires AzAPI.

| Provider | When to Use | Characteristics |
|----------|-------------|-----------------|
| **AzureRM** (Standard) | Default for all labs | ✅ Mature, well-documented<br>✅ Strongly-typed with IntelliSense<br>✅ Best for learning and production<br>✅ Comprehensive resource coverage |
| **AzAPI** (Advanced) | Only when AzureRM lacks a feature | ⚠️ Direct REST API access<br>⚠️ More complex, less intuitive<br>⚠️ For preview/bleeding-edge features<br>⚠️ Requires Azure REST API knowledge |

**Rationale**: AzureRM is the appropriate choice for certification labs because it's:

- Industry standard for Azure infrastructure-as-code
- Better documented with more examples
- Easier to read and understand
- More aligned with exam objectives and real-world usage

**AzAPI use cases** (rare in AZ-104 context):

- A brand-new Azure service not yet in AzureRM
- Preview feature with no AzureRM support
- Specific property not exposed by AzureRM resource

#### Required Versions

```hcl
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    # Add additional providers as needed:
    # random = {
    #   source  = "hashicorp/random"
    #   version = "~> 3.0"
    # }
    #
    # Only add azapi if absolutely necessary for a specific unsupported feature:
    # azapi = {
    #   source  = "Azure/azapi"
    #   version = "~> 2.0"
    # }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.lab_subscription_id
}
```

#### State Management

- **Local State:** Default for all labs (stored in `.tfstate` files)
- **Remote State:** Not required for learning labs
- **State Security:** Add `*.tfstate*` to `.gitignore`

#### File Structure

```
lab-<topic>/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars  (gitignored, use .tfvars.example)
│   └── README.md
```

#### Variable Files

- Use `terraform.tfvars` for local values (gitignored)
- **Required content**:

  ```hcl
  lab_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"
  location = "eastus"
  owner    = "Greg Tate"
  ```

- Provide `terraform.tfvars.example` as template
- Document all variables in `variables.tf` with descriptions
- **Never** store admin passwords in variable files

#### Module Standards

**When to create modules**: Use modules when the lab creates **3 or more related resources** within a logical grouping (e.g., networking, compute, storage). For very simple labs with only 1-2 resources total, modules are optional.

**Module structure** — each module in `modules/<group>/`:

- `main.tf` — resource definitions
- `variables.tf` — input variables (tags, location, names, etc.)
- `outputs.tf` — values needed by other modules or root outputs

**Module design principles**:

- **Group by logical domain**: `modules/networking/`, `modules/compute/`, `modules/storage/`
- **Self-contained**: Each module receives everything it needs via variables
- **Tag passing**: Pass `common_tags` as a `map(string)` variable and merge with resource-specific tags
- **Explicit dependencies**: Keep inter-module dependencies explicit via output references
- **Resource group placement**: Typically define resource group in `main.tf` (not in a module) since most modules need its name as input

**Orchestration layer** (`main.tf`):

- Keep `main.tf` thin — it should primarily call modules
- Define resource group, locals (common_tags, resource_group_name), and module calls
- Pass `common_tags`, `location`, and naming values into modules
- Do not define individual resources directly when a module is more appropriate

#### Credentials and Secrets

**Password Generation for Lab Environments**:

**CRITICAL**: Automatically generate friendly admin passwords that are easy to type but meet complexity requirements.

**Terraform approach**:

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

**Friendly password patterns** (all meet complexity requirements):

- `AzureLab2026!` - Simple, memorable
- `LabPassword${variation}!` - Pattern with variation
- `Learning@Azure123` - Descriptive
- `Demo${year}Pass!` - Year-based

**Requirements**:

- Must include: uppercase, lowercase, numbers, special characters
- Output passwords so users can access resources
- Mark password outputs as `sensitive = true`
- **Never** define password variables in `variables.tf` or `terraform.tfvars`

**Note**: These friendly patterns are acceptable for lab environments. In production, use Key Vault and avoid predictable patterns.

### Bicep Standards

#### Required Configuration

```json
// bicepconfig.json
{
  "analyzers": {
    "core": {
      "enabled": true,
      "rules": {
        "no-hardcoded-env-urls": { "level": "warning" },
        "no-unused-params": { "level": "warning" }
      }
    }
  }
}
```

#### File Structure

```
lab-<topic>/
├── bicep/
│   ├── main.bicep
│   ├── main.bicepparam
│   ├── modules/  (if needed)
│   ├── bicep.ps1  (deployment script)
│   └── README.md
```

#### Parameter Files

- Use `.bicepparam` for all deployments
- Store deployment-specific values in parameter files
- Use `@secure()` decorator for sensitive parameters

#### Deployment Scripts

- **Always copy** `bicep.ps1` from `AZ-104/hands-on-labs/_shared/bicep/bicep.ps1` to lab's `bicep/` folder
- Script provides: validate, plan, apply, destroy, show, list commands
- Use deployment stacks for easier cleanup
- Stack naming: Auto-derived as `stack-<domain>-<topic>` from parameters

#### Module Standards

**When to create modules**: Use modules when the lab creates **3 or more related resources** within a logical grouping. For very simple labs with only 1-2 resources total, modules are optional.

**Module structure** — each module in `modules/`:

- `modules/<group>.bicep` (e.g., `modules/networking.bicep`, `modules/compute.bicep`)
- Declare parameters for all inputs (tags, location, names, etc.)
- Declare outputs for values needed by other modules or root template

**Module design principles**:

- **Group by logical domain**: `networking.bicep`, `compute.bicep`, `storage.bicep`
- **Self-contained**: Each module receives everything it needs via parameters
- **Tag passing**: Pass `commonTags` as an `object` parameter, use `union()` for resource-specific tags
- **Explicit dependencies**: Keep inter-module dependencies explicit via output references
- **Resource group placement**: Typically define resource group in `main.bicep` (subscription-scoped), modules are scoped to it

**Orchestration layer** (`main.bicep`):

- Keep `main.bicep` thin — it should primarily call modules
- Define resource group, commonTags variable, and module calls
- Use `@allowed()` decorator for domain parameter validation
- Pass `commonTags`, `location`, and naming values into modules
- Do not define individual resources directly when a module is more appropriate

#### Credentials and Secrets

**Password Generation for Lab Environments**:

**Bicep approach**:

```bicep
// In main.bicep:
var adminPassword = 'AzureLab${uniqueString(resourceGroup().id, '2026')}!'

// Or for even more friendly:
var adminPassword = 'AzureLab2026!'

// In outputs:
@description('Admin password for resources (friendly format)')
output adminPassword string = adminPassword
```

**Friendly password patterns** (all meet complexity requirements):

- `AzureLab2026!` - Simple, memorable
- `LabPassword${variation}!` - Pattern with variation
- `Learning@Azure123` - Descriptive
- `Demo${year}Pass!` - Year-based

**Requirements**:

- Must include: uppercase, lowercase, numbers, special characters
- Output passwords so users can access resources
- Ensure complexity requirements are met

**Note**: These friendly patterns are acceptable for lab environments. In production, use Key Vault and avoid predictable patterns.

---

## Lab Lifecycle Policy

### Lab States

| State | Description | Action Required |
|-------|-------------|----------------|
| **Active** | Currently being developed or used | Regular updates |
| **Reference** | Completed, kept for future reference | Document in main README |
| **Archived** | No longer relevant; kept for history | Move to `archived/` directory |
| **Deleted** | Resources destroyed, code removed | Remove from repository |

### Decision Criteria

- **Keep as Reference:** Lab demonstrates important exam concept, well-documented, validated
- **Archive:** Lab outdated due to Azure changes or exam updates
- **Delete:** Experimental/incomplete work, duplicate of better implementation

### Archival Process

1. Move lab directory to `archived/<domain>/`
2. Update main domain README to remove archived lab
3. Add entry to `archived/README.md` with reason and date
4. Ensure all Azure resources destroyed before archiving

---

## Implementation Examples

### Terraform

```hcl
# variables.tf
variable "domain" {
  description = "AZ-104 exam domain"
  type        = string
  validation {
    condition     = contains(["identity", "networking", "storage", "compute", "monitoring"], var.domain)
    error_message = "Domain must be: identity, networking, storage, compute, or monitoring."
  }
}

variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
}

variable "owner" {
  description = "Lab owner"
  type        = string
  default     = "Greg Tate"
}

locals {
  resource_group_name = "az104-${var.domain}-${var.topic}-tf"
  
  common_tags = {
    Environment = "Lab"
    Project     = "AZ-104"
    Domain      = title(var.domain)
    Purpose     = replace(title(var.topic), "-", " ")
    Owner       = var.owner
    DateCreated = formatdate("YYYY-MM-DD", timestamp())
    DeploymentMethod = "Terraform"
  }
}

# main.tf
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}
```

### Bicep

```bicep
// main.bicep
@allowed(['identity', 'networking', 'storage', 'compute', 'monitoring'])
param domain string

param topic string
param location string = resourceGroup().location
param owner string = 'Greg Tate'
param dateCreated string = utcNow('yyyy-MM-dd')

var commonTags = {
  Environment: 'Lab'
  Project: 'AZ-104'
  Domain: toUpper(substring(domain, 0, 1)) + substring(domain, 1)
  Purpose: replace(topic, '-', ' ')
  Owner: owner
  DateCreated: dateCreated
  DeploymentMethod: 'Bicep'
}

// Apply tags to resources
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'st${replace(topic, '-', '')}'
  location: location
  tags: commonTags
  // ...
}
```

---

## Pre-Deployment Checklist

Before deploying any lab:

### Naming & Organization

- [ ] Resource group follows `az104-<domain>-<topic>-<deployment_method>` pattern
- [ ] Resource names follow defined prefix patterns
- [ ] Deployment stack (Bicep) follows `stack-<domain>-<topic>` pattern

### Tagging & Metadata

- [ ] All resources include required tags: `Environment`, `Project`, `Domain`, `Purpose`, `Owner`, `DateCreated`, `DeploymentMethod`
- [ ] `DateCreated` set to current date for cleanup tracking

### Configuration

- [ ] Location is in allowed regions (`eastus`, `eastus2`, `westus2`)
- [ ] VM sizes are cost-appropriate (`Standard_B2s` or smaller)
- [ ] VM auto-shutdown configured for 7:00 PM EST
- [ ] Resource counts within limits (VMs ≤4, Public IPs ≤5, etc.)

### Documentation

- [ ] README.md includes lab overview and AZ-104 exam objective
- [ ] README.md documents prerequisites and required permissions
- [ ] README.md provides deployment steps with example commands
- [ ] README.md includes validation/testing steps
- [ ] README.md documents cleanup procedure with actual commands
- [ ] Parameter file example provided (`.tfvars.example` or `.bicepparam`)

### Code Quality

- [ ] **Terraform:** Using AzureRM provider (not AzAPI) unless specific feature requires it
- [ ] **Terraform:** Version constraints specified (`>= 1.0`)
- [ ] **Terraform:** `terraform.tfvars` in `.gitignore`
- [ ] **Bicep:** `bicepconfig.json` present with linter rules
- [ ] **Bicep:** Deployment script (`bicep.ps1`) included
- [ ] Sensitive values use appropriate security mechanisms

### Testing

- [ ] Deployment tested and validates successfully
- [ ] Cleanup/destroy commands tested and verified
- [ ] No orphaned resources remain after cleanup
