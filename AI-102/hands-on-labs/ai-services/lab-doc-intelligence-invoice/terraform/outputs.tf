# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for Document Intelligence lab
# Context: AI-102 Lab - Document Intelligence prebuilt invoice model
# Author: Greg Tate
# Date: 2026-02-20
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the lab resource group"
  value       = azurerm_resource_group.lab.name
}

output "doc_intelligence_endpoint" {
  description = "Azure AI Document Intelligence endpoint URL"
  value       = azurerm_cognitive_account.doc_intelligence.endpoint
}

output "doc_intelligence_name" {
  description = "Azure AI Document Intelligence account name"
  value       = azurerm_cognitive_account.doc_intelligence.name
}

output "doc_intelligence_primary_key" {
  description = "Azure AI Document Intelligence primary API key"
  value       = azurerm_cognitive_account.doc_intelligence.primary_access_key
  sensitive   = true
}

output "doc_intelligence_secondary_key" {
  description = "Azure AI Document Intelligence secondary API key"
  value       = azurerm_cognitive_account.doc_intelligence.secondary_access_key
  sensitive   = true
}

output "doc_intelligence_studio_url" {
  description = "URL for Azure AI Document Intelligence Studio"
  value       = "https://documentintelligence.ai.azure.com/studio"
}
