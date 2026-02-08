# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values from storage account module
# Context: AZ-104 Lab - Storage account module outputs
# Author: Greg Tate
# Date: 2026-02-08
# -------------------------------------------------------------------------

# Storage account identification
output "storage_account_id" {
  description = "Resource ID of the storage account"
  value       = azurerm_storage_account.account.id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.account.name
}

# Container information
output "container_name" {
  description = "Name of the blob container"
  value       = azurerm_storage_container.container.name
}

# Blob endpoints
output "primary_blob_endpoint" {
  description = "Primary blob storage endpoint"
  value       = azurerm_storage_account.account.primary_blob_endpoint
}

# Connection string (sensitive)
output "primary_connection_string" {
  description = "Primary connection string for the storage account"
  value       = azurerm_storage_account.account.primary_connection_string
  sensitive   = true
}

# Access key (sensitive)
output "primary_access_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.account.primary_access_key
  sensitive   = true
}
