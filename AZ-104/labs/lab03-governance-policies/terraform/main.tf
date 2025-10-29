terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Get current subscription
data "azurerm_subscription" "current" {}

# ==============================================================================
# Built-in Policy Assignments
# ==============================================================================

# Assign Allowed Locations policy
resource "azurerm_subscription_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations-policy"
  display_name         = "Allowed Locations - East US and West US Only"
  description          = "Restricts resource deployment to East US and West US regions"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  subscription_id      = data.azurerm_subscription.current.id

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = ["eastus", "westus"]
    }
  })
}

# Assign Require Tag on Resource Groups policy
resource "azurerm_subscription_policy_assignment" "require_costcenter_tag" {
  name                 = "require-costcenter-tag-rg"
  display_name         = "Require CostCenter Tag on Resource Groups"
  description          = "Requires all resource groups to have a CostCenter tag"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
  subscription_id      = data.azurerm_subscription.current.id

  parameters = jsonencode({
    tagName = {
      value = "CostCenter"
    }
  })
}

# Assign Allowed VM SKUs policy
resource "azurerm_subscription_policy_assignment" "allowed_vm_skus" {
  name                 = "allowed-vm-skus"
  display_name         = "Allowed VM SKUs - Budget-Friendly Only"
  description          = "Restricts VM deployments to approved budget-friendly SKUs"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"
  subscription_id      = data.azurerm_subscription.current.id

  parameters = jsonencode({
    listOfAllowedSKUs = {
      value = ["Standard_B2s", "Standard_B2ms", "Standard_D2s_v3"]
    }
  })
}

# ==============================================================================
# Custom Policy Definitions
# ==============================================================================

# Storage Account Naming Convention Policy
resource "azurerm_policy_definition" "storage_naming" {
  name         = "storage-naming-convention"
  display_name = "Enforce Storage Account Naming Convention"
  description  = "Storage account names must follow pattern: st<env><app><region><seq>"
  policy_type  = "Custom"
  mode         = "Indexed"

  metadata = jsonencode({
    category = "Storage"
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Storage/storageAccounts"
        },
        {
          not = {
            field = "name"
            match = "st[dev|test|prod]*[eus|wus|cus]*[0-9][0-9]"
          }
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

# Assign the custom storage naming policy
resource "azurerm_subscription_policy_assignment" "storage_naming" {
  name                 = "enforce-storage-naming"
  display_name         = "Enforce Storage Naming Convention"
  description          = "Enforces storage account naming standards"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.storage_naming.id
}

# Require CostCenter Tag with Allowed Values
resource "azurerm_policy_definition" "require_costcenter_values" {
  name         = "require-costcenter-values"
  display_name = "Require CostCenter Tag with Allowed Values"
  description  = "Requires CostCenter tag with approved department values"
  policy_type  = "Custom"
  mode         = "Indexed"

  metadata = jsonencode({
    category = "Tags"
  })

  parameters = jsonencode({
    tagName = {
      type = "String"
      metadata = {
        displayName = "Tag Name"
        description = "Name of the tag, such as 'CostCenter'"
      }
      defaultValue = "CostCenter"
    }
    allowedValues = {
      type = "Array"
      metadata = {
        displayName = "Allowed Tag Values"
        description = "List of allowed values for the tag"
      }
      defaultValue = ["Engineering", "Marketing", "Sales", "HR"]
    }
  })

  policy_rule = jsonencode({
    if = {
      anyOf = [
        {
          field  = "[concat('tags[', parameters('tagName'), ']')]"
          exists = "false"
        },
        {
          field = "[concat('tags[', parameters('tagName'), ']')]"
          notIn = "[parameters('allowedValues')]"
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

# Assign the CostCenter tag values policy
resource "azurerm_subscription_policy_assignment" "costcenter_values" {
  name                 = "require-costcenter-values"
  display_name         = "Require Valid CostCenter Tag"
  description          = "Requires CostCenter tag with approved values"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.require_costcenter_values.id

  parameters = jsonencode({
    tagName = {
      value = "CostCenter"
    }
    allowedValues = {
      value = ["Engineering", "Marketing", "Sales", "HR", "IT"]
    }
  })
}

# Audit VMs Without Backup
resource "azurerm_policy_definition" "audit_vm_backup" {
  name         = "audit-vm-backup"
  display_name = "Audit VMs Without Backup Enabled"
  description  = "Audits virtual machines that do not have backup protection configured"
  policy_type  = "Custom"
  mode         = "Indexed"

  metadata = jsonencode({
    category = "Backup"
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Compute/virtualMachines"
        },
        {
          field  = "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType"
          exists = "true"
        }
      ]
    }
    then = {
      effect = "auditIfNotExists"
      details = {
        type = "Microsoft.RecoveryServices/backupprotecteditems"
        existenceCondition = {
          field  = "Microsoft.RecoveryServices/backupprotecteditems/friendlyName"
          equals = "[field('name')]"
        }
      }
    }
  })
}

# Assign the VM backup audit policy
resource "azurerm_subscription_policy_assignment" "vm_backup_audit" {
  name                 = "audit-vm-backup"
  display_name         = "Audit VM Backup Compliance"
  description          = "Audits VMs without backup protection"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.audit_vm_backup.id
}

# ==============================================================================
# Outputs
# ==============================================================================

output "subscription_id" {
  value       = data.azurerm_subscription.current.id
  description = "The subscription ID where policies are assigned"
}

output "allowed_locations_assignment_id" {
  value       = azurerm_subscription_policy_assignment.allowed_locations.id
  description = "Policy assignment ID for Allowed Locations"
}

output "storage_naming_policy_id" {
  value       = azurerm_policy_definition.storage_naming.id
  description = "Policy definition ID for Storage Naming Convention"
}

output "storage_naming_assignment_id" {
  value       = azurerm_subscription_policy_assignment.storage_naming.id
  description = "Policy assignment ID for Storage Naming Convention"
}

output "costcenter_tag_policy_id" {
  value       = azurerm_policy_definition.require_costcenter_values.id
  description = "Policy definition ID for CostCenter Tag Values"
}

output "vm_backup_policy_id" {
  value       = azurerm_policy_definition.audit_vm_backup.id
  description = "Policy definition ID for VM Backup Audit"
}
