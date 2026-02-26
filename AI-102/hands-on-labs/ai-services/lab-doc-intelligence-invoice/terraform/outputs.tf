# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for the lab
# Context: AI-102 Lab - Document Intelligence Invoice Model
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the lab resource group"
  value       = azurerm_resource_group.lab.name
}

output "resource_group_id" {
  description = "ID of the lab resource group"
  value       = azurerm_resource_group.lab.id
}

output "cognitive_account_name" {
  description = "Name of the Document Intelligence account"
  value       = module.cognitive.account_name
}

output "cognitive_account_endpoint" {
  description = "Endpoint URL for the Document Intelligence account"
  value       = module.cognitive.endpoint
}

output "cognitive_account_key" {
  description = "Primary access key for the Document Intelligence account"
  value       = module.cognitive.primary_key
  sensitive   = true
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage.storage_account_name
}

output "storage_container_name" {
  description = "Name of the storage container for sample invoices"
  value       = module.storage.container_name
}
