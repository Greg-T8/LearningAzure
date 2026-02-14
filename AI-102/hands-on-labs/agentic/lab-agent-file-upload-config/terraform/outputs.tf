# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for Azure AI Agent Service file upload lab
# Context: AI-102 Lab - Agent Service file upload configuration
# Author: Greg Tate
# Date: 2026-02-14
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the lab resource group"
  value       = azurerm_resource_group.lab.name
}

output "ai_services_name" {
  description = "Name of the AI Services account"
  value       = module.ai_services.account_name
}

output "ai_services_endpoint" {
  description = "Endpoint of the AI Services account"
  value       = module.ai_services.endpoint
}

output "ai_services_principal_id" {
  description = "Principal ID of the AI Services managed identity"
  value       = module.ai_services.principal_id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage.storage_account_name
}

output "agents_blobstore_container" {
  description = "Name of the agents blobstore container"
  value       = module.storage.agents_blobstore_container_name
}

output "azureml_blobstore_container" {
  description = "Name of the Azure ML blobstore container"
  value       = module.storage.azureml_blobstore_container_name
}

output "cosmos_db_name" {
  description = "Name of the Cosmos DB account"
  value       = module.cosmos_db.account_name
}

output "cosmos_db_endpoint" {
  description = "Endpoint of the Cosmos DB account"
  value       = module.cosmos_db.endpoint
}

output "ai_search_name" {
  description = "Name of the AI Search service"
  value       = module.ai_search.service_name
}
