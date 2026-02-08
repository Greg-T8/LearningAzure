# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for object replication lab
# Context: AZ-104 Lab - Configure object replication between storage accounts
# Author: Greg Tate
# Date: 2026-02-08
# -------------------------------------------------------------------------

# Resource group information
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.lab.name
}

# Source storage account details
output "source_storage_account_name" {
  description = "Name of the source storage account"
  value       = module.source_storage.storage_account_name
}

output "source_storage_account_id" {
  description = "Resource ID of the source storage account"
  value       = module.source_storage.storage_account_id
}

output "source_container_name" {
  description = "Name of the source blob container"
  value       = module.source_storage.container_name
}

output "source_primary_blob_endpoint" {
  description = "Primary blob endpoint for source storage account"
  value       = module.source_storage.primary_blob_endpoint
}

# Destination storage account details
output "destination_storage_account_name" {
  description = "Name of the destination storage account"
  value       = module.destination_storage.storage_account_name
}

output "destination_storage_account_id" {
  description = "Resource ID of the destination storage account"
  value       = module.destination_storage.storage_account_id
}

output "destination_container_name" {
  description = "Name of the destination blob container"
  value       = module.destination_storage.container_name
}

output "destination_primary_blob_endpoint" {
  description = "Primary blob endpoint for destination storage account"
  value       = module.destination_storage.primary_blob_endpoint
}

# Object replication policy details
output "replication_policy_id" {
  description = "ID of the object replication policy"
  value       = azurerm_storage_object_replication.policy.id
}

# Connection strings for testing (sensitive)
output "source_connection_string" {
  description = "Connection string for source storage account (for testing purposes)"
  value       = module.source_storage.primary_connection_string
  sensitive   = true
}

output "destination_connection_string" {
  description = "Connection string for destination storage account (for testing purposes)"
  value       = module.destination_storage.primary_connection_string
  sensitive   = true
}
