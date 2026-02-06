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

#### Required Versions

```hcl
terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
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
- Provide `terraform.tfvars.example` as template
- Document all variables in `variables.tf` with descriptions

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

- Provide PowerShell wrapper script (`bicep.ps1`) with Plan/Deploy/Destroy functions
- Use deployment stacks for easier cleanup

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
- [ ] **Terraform:** Version constraints specified (`>= 1.5.0`)
- [ ] **Terraform:** `terraform.tfvars` in `.gitignore`
- [ ] **Bicep:** `bicepconfig.json` present with linter rules
- [ ] **Bicep:** Deployment script (`bicep.ps1`) included
- [ ] Sensitive values use appropriate security mechanisms

### Testing
- [ ] Deployment tested and validates successfully
- [ ] Cleanup/destroy commands tested and verified
- [ ] No orphaned resources remain after cleanup
