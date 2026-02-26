# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for the storage module
# Context: AI-102 Lab - Document Intelligence Invoice Model
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.invoices.name
}

output "storage_account_id" {
  description = "Resource ID of the storage account"
  value       = azurerm_storage_account.invoices.id
}

output "container_name" {
  description = "Name of the invoices container"
  value       = azurerm_storage_container.invoices.name
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint URL"
  value       = azurerm_storage_account.invoices.primary_blob_endpoint
}
