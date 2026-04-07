# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for AI-103 Foundry project lab deployment
# Context: AI-103 Lab - Explore AI Studio project provisioning with Terraform
# Author: Greg Tate
# Date: 2026-04-06
# -------------------------------------------------------------------------

# Return the resource group name for cleanup and navigation.
output "resource_group_name" {
  description = "Name of the lab resource group"
  value       = azurerm_resource_group.lab.name
}

# Return the Foundry parent resource name.
output "foundry_resource_name" {
  description = "Name of the Foundry parent AI Services resource"
  value       = azurerm_cognitive_account.foundry.name
}

# Return the Foundry parent resource endpoint.
output "foundry_resource_endpoint" {
  description = "Endpoint URL for the Foundry parent AI Services resource"
  value       = azurerm_cognitive_account.foundry.endpoint
}

# Return the OpenAI endpoint format used for OpenAI APIs.
output "openai_endpoint" {
  description = "Derived OpenAI endpoint for OpenAI API access"
  value       = "https://${azurerm_cognitive_account.foundry.custom_subdomain_name}.openai.azure.com/"
}

# Return the Foundry project name.
output "project_name" {
  description = "Name of the Foundry project"
  value       = azurerm_cognitive_account_project.project.name
}

# Return the project endpoint used by Foundry project APIs.
output "project_endpoint" {
  description = "Project endpoint for Foundry project-level APIs"
  value       = "https://${azurerm_cognitive_account.foundry.custom_subdomain_name}.services.ai.azure.com/api/projects/${azurerm_cognitive_account_project.project.name}"
}

# Return the model deployment name for playground and SDK use.
output "model_deployment_name" {
  description = "Model deployment name"
  value       = azurerm_cognitive_deployment.model.name
}

# Return a key for key-based authentication in lab scenarios.
output "foundry_primary_key" {
  description = "Primary key for Foundry parent resource"
  value       = azurerm_cognitive_account.foundry.primary_access_key
  sensitive   = true
}
