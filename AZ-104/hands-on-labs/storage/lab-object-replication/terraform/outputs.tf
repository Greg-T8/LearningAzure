# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for object replication lab
# Context: AZ-104 Lab - Object replication between storage accounts
# Author: Greg Tate
# Date: 2026-02-05
# -------------------------------------------------------------------------

# Resource group name for validation.
output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.lab.name
}

# Source storage account details.
output "source_storage_account" {
  description = "Source storage account name"
  value       = azurerm_storage_account.source.name
}

# Destination storage account details.
output "destination_storage_account" {
  description = "Destination storage account name"
  value       = azurerm_storage_account.destination.name
}

# Object replication policy identifier.
output "object_replication_policy_id" {
  description = "Object replication policy ID"
  value       = azurerm_storage_object_replication.replication.id
}
