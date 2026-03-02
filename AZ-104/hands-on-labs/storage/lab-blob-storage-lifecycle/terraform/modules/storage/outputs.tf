# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for storage lifecycle module resources
# Context: AZ-104 Lab - Configure Blob Storage Lifecycle Management
# Author: Greg Tate
# Date: 2026-03-02
# -------------------------------------------------------------------------

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.lifecycle.id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.lifecycle.name
}

output "container_name" {
  description = "Name of the blob container"
  value       = azurerm_storage_container.lifecycle.name
}

output "management_policy_id" {
  description = "ID of the storage management policy"
  value       = azurerm_storage_management_policy.lifecycle.id
}
