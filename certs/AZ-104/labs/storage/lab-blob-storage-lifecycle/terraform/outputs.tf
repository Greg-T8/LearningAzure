# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for blob storage lifecycle resources
# Context: AZ-104 Lab - Configure Blob Storage Lifecycle Management
# Author: Greg Tate
# Date: 2026-03-02
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the lab resource group"
  value       = azurerm_resource_group.lab.name
}

output "storage_account_name" {
  description = "Name of the lifecycle-managed storage account"
  value       = module.storage.storage_account_name
}

output "storage_account_id" {
  description = "ID of the lifecycle-managed storage account"
  value       = module.storage.storage_account_id
}

output "container_name" {
  description = "Name of the container targeted by lifecycle filters"
  value       = module.storage.container_name
}
