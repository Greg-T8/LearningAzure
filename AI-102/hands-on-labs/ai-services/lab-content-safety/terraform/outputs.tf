# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for Azure AI Content Safety lab
# Context: AI-102 Lab - Azure AI Content Safety text and image moderation
# Author: Greg Tate
# Date: 2026-02-12
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the lab resource group"
  value       = azurerm_resource_group.lab.name
}

output "content_safety_endpoint" {
  description = "Azure AI Content Safety endpoint URL"
  value       = azurerm_cognitive_account.content_safety.endpoint
}

output "content_safety_name" {
  description = "Azure AI Content Safety account name"
  value       = azurerm_cognitive_account.content_safety.name
}

output "content_safety_primary_key" {
  description = "Azure AI Content Safety primary API key"
  value       = azurerm_cognitive_account.content_safety.primary_access_key
  sensitive   = true
}

output "content_safety_secondary_key" {
  description = "Azure AI Content Safety secondary API key"
  value       = azurerm_cognitive_account.content_safety.secondary_access_key
  sensitive   = true
}

output "content_safety_studio_url" {
  description = "URL for Azure AI Content Safety Studio"
  value       = "https://contentsafety.cognitive.azure.com"
}
