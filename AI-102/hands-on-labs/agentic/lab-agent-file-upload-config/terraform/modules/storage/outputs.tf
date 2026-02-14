# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for storage module
# Context: AI-102 Lab - Agent Service file upload configuration
# Author: Greg Tate
# Date: 2026-02-14
# -------------------------------------------------------------------------

output "storage_account_id" {
  description = "Resource ID of the storage account"
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.this.name
}

output "agents_blobstore_container_name" {
  description = "Name of the agents blobstore container"
  value       = azurerm_storage_container.agents_blobstore.name
}

output "azureml_blobstore_container_name" {
  description = "Name of the Azure ML blobstore container"
  value       = azurerm_storage_container.azureml_blobstore.name
}

output "primary_connection_string" {
  description = "Primary connection string for the storage account"
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}
