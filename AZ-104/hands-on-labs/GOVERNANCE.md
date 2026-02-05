# Hands-On Labs Governance Policy

Standards and naming conventions for all Terraform and Bicep implementations.

---

## Resource Group Naming

**Pattern:** `<exam>-<domain>-<topic>-<deployment_method>`

| Segment | Description | Allowed Values |
|---------|-------------|----------------|
| `<exam>` | Fixed prefix for all labs | `az104` |
| `<domain>` | AZ-104 exam domain | `identity`, `networking`, `storage`, `compute`, `monitoring` |
| `<topic>` | Lab topic (kebab-case) | e.g., `vnet-peering`, `load-balancer`, `rbac-roles` |
| `<deployment_method>` | IaC tool used | `tf` (Terraform), `bicep` (Bicep) |

### Examples

| Lab | Deployment | Resource Group Name |
|-----|------------|---------------------|
| VNet Peering | Terraform | `az104-networking-vnet-peering-tf` |
| VNet Peering | Bicep | `az104-networking-vnet-peering-bicep` |
| Custom RBAC Roles | Terraform | `az104-identity-rbac-roles-tf` |
| Storage Lifecycle | Bicep | `az104-storage-blob-lifecycle-bicep` |
| VM Availability Sets | Terraform | `az104-compute-vm-availability-tf` |
| Log Analytics | Bicep | `az104-monitoring-log-analytics-bicep` |

---

## Resource Naming

**Pattern:** `<type>-<topic>[-<instance>]`

| Resource Type | Prefix | Example |
|---------------|--------|---------|
| Virtual Network | `vnet` | `vnet-hub`, `vnet-spoke` |
| Subnet | `snet` | `snet-web`, `snet-db` |
| Network Security Group | `nsg` | `nsg-web` |
| Load Balancer | `lb` | `lb-public` |
| Public IP | `pip` | `pip-lb` |
| Storage Account | `st` | `stblob01` (no hyphens allowed) |
| Virtual Machine | `vm` | `vm-web-01` |
| VM Scale Set | `vmss` | `vmss-web` |
| App Service | `app` | `app-api` |
| Log Analytics Workspace | `law` | `law-central` |
| Recovery Services Vault | `rsv` | `rsv-backup` |

---

## Tagging Policy

All resources **must** include these tags:

| Tag | Description | Example |
|-----|-------------|---------|
| `Environment` | Fixed value | `Lab` |
| `Project` | Certification context | `AZ-104` |
| `Domain` | Exam domain | `Networking` |
| `Purpose` | What the lab demonstrates | `VNet Peering` |
| `Owner` | Your identifier | `Greg Tate` |
| `DateCreated` | Resource creation date | `2026-02-05` |
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
-bicep'

var commonTags = {
  Environment: 'Lab'
  Project: 'AZ-104'
  Domain: toUpper(substring(domain, 0, 1)) + substring(domain, 1)
  Purpose: replace(topic, '-', ' ')
  Owner: owner
  DateCreated: utcNow('yyyy-MM-dd')
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

## Location Policy

| Setting | Value | Rationale |
|---------|-------|-----------|
| Default Region | `eastus` | Cost-effective, wide service availability |
| Allowed Regions | `eastus`, `eastus2`, `westus2` | Limit to minimize latency and cost |

---

## Deployment Stack Naming (Bicep)

**Pattern:** `stack-<domain>-<topic>`


**Note:** Deployment stack names don't include the `-bicep` suffix since they're already Bicep-specific constructs.
Example: `stack-networking-vnet-peering`

---

## Checklist Before Deployment-<deployment_method>` pattern
- [ ] All resources have required tags (including `DeploymentMethod`)
- [ ] Resource group follows `az104-<domain>-<topic>` pattern
- [ ] All resources have required tags
- [ ] Location is in allowed list
- [ ] README.md documents the exam question reference
- [ ] Destroy/cleanup commands are tested
