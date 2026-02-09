# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for DALL-E image generation lab
# Context: AI-102 Lab - Generate and manipulate images with DALL-E
# Author: Greg Tate
# Date: 2026-02-09
# -------------------------------------------------------------------------

# Azure OpenAI endpoint and authentication
output "openai_endpoint" {
  description = "Azure OpenAI endpoint URL"
  value       = azurerm_cognitive_account.openai.endpoint
}

output "openai_account_name" {
  description = "Azure OpenAI account name"
  value       = azurerm_cognitive_account.openai.name
}

output "openai_primary_key" {
  description = "Azure OpenAI primary API key (use for key-based authentication)"
  value       = azurerm_cognitive_account.openai.primary_access_key
  sensitive   = true
}

# DALL-E deployment information
output "image_deployment_name" {
  description = "DALL-E 3 deployment name (use in API calls)"
  value       = azurerm_cognitive_deployment.dalle.name
}

# Storage account for generated images
output "storage_account_name" {
  description = "Storage account name for generated images"
  value       = azurerm_storage_account.images.name
}

output "storage_container_name" {
  description = "Blob container name for generated images"
  value       = azurerm_storage_container.images.name
}

output "storage_connection_string" {
  description = "Storage account connection string"
  value       = azurerm_storage_account.images.primary_connection_string
  sensitive   = true
}

# Resource group information
output "resource_group_name" {
  description = "Resource group name containing all lab resources"
  value       = azurerm_resource_group.lab.name
}

output "location" {
  description = "Azure region where resources are deployed"
  value       = azurerm_resource_group.lab.location
}
