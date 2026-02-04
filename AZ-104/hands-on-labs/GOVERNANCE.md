# Hands-On Labs Governance Policy

Standards and naming conventions for all Terraform and Bicep implementations.

---

## Resource Group Naming

**Pattern:** `az104-<domain>-<topic>`

| Segment | Description | Allowed Values |
|---------|-------------|----------------|
| `az104` | Fixed prefix for all labs | `az104` |
| `<domain>` | AZ-104 exam domain | `identity`, `networking`, `storage`, `compute`, `monitoring` |
| `<topic>` | Lab topic (kebab-case) | e.g., `vnet-peering`, `load-balancer`, `rbac-roles` |

### Examples

| Lab | Resource Group Name |
|-----|---------------------|
| VNet Peering | `az104-networking-vnet-peering` |
| Custom RBAC Roles | `az104-identity-rbac-roles` |
| Storage Lifecycle | `az104-storage-blob-lifecycle` |
| VM Availability Sets | `az104-compute-vm-availability` |
| Log Analytics | `az104-monitoring-log-analytics` |

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
  resource_group_name = "az104-${var.domain}-${var.topic}"
  
  common_tags = {
    Environment = "Lab"
    Project     = "AZ-104"
    Domain      = title(var.domain)
    Purpose     = replace(title(var.topic), "-", " ")
    Owner       = var.owner
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

var resourceGroupName = 'az104-${domain}-${topic}'

var commonTags = {
  Environment: 'Lab'
  Project: 'AZ-104'
  Domain: toUpper(substring(domain, 0, 1)) + substring(domain, 1)
  Purpose: replace(topic, '-', ' ')
  Owner: owner
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

Example: `stack-networking-vnet-peering`

---

## Checklist Before Deployment

- [ ] Resource group follows `az104-<domain>-<topic>` pattern
- [ ] All resources have required tags
- [ ] Location is in allowed list
- [ ] README.md documents the exam question reference
- [ ] Destroy/cleanup commands are tested
