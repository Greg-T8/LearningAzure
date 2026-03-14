# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for AI Agent Service BYO storage lab
# Context: AI-102 Lab - Agent Service BYO Storage Configuration
# Author: Greg Tate
# Date: 2026-02-20
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the lab resource group"
  value       = azurerm_resource_group.lab.name
}

# =========================================================================
# AI Services outputs
# =========================================================================

output "ai_services_name" {
  description = "Azure AI Services account name"
  value       = azurerm_cognitive_account.ai_services.name
}

output "ai_services_endpoint" {
  description = "Azure AI Services endpoint URL"
  value       = azurerm_cognitive_account.ai_services.endpoint
}

output "ai_services_principal_id" {
  description = "Principal ID of the AI Services managed identity"
  value       = azurerm_cognitive_account.ai_services.identity[0].principal_id
}

output "ai_services_primary_key" {
  description = "Azure AI Services primary API key"
  value       = azurerm_cognitive_account.ai_services.primary_access_key
  sensitive   = true
}

# =========================================================================
# BYO Storage outputs
# =========================================================================

output "storage_account_name" {
  description = "BYO storage account name for agent file uploads"
  value       = azurerm_storage_account.agent_byo.name
}

output "storage_account_id" {
  description = "BYO storage account resource ID"
  value       = azurerm_storage_account.agent_byo.id
}

output "storage_primary_connection_string" {
  description = "BYO storage account primary connection string"
  value       = azurerm_storage_account.agent_byo.primary_connection_string
  sensitive   = true
}

output "storage_primary_blob_endpoint" {
  description = "BYO storage account primary blob endpoint"
  value       = azurerm_storage_account.agent_byo.primary_blob_endpoint
}

# =========================================================================
# Supporting resource outputs
# =========================================================================

output "key_vault_name" {
  description = "Key Vault name"
  value       = azurerm_key_vault.lab.name
}

output "search_service_name" {
  description = "AI Search service name"
  value       = azurerm_search_service.lab.name
}

output "cosmosdb_account_name" {
  description = "Cosmos DB account name for agent thread storage"
  value       = azurerm_cosmosdb_account.lab.name
}

output "cosmosdb_endpoint" {
  description = "Cosmos DB account endpoint"
  value       = azurerm_cosmosdb_account.lab.endpoint
}
