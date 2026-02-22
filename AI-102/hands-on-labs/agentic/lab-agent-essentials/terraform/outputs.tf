# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for Azure AI Agent Service essentials lab
# Context: AI-102 Lab - Agent Service Essentials (Threads, Files, Vector Stores)
# Author: Greg Tate
# Date: 2026-02-22
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the lab resource group"
  value       = azurerm_resource_group.lab.name
}

# =========================================================================
# AI Foundry Account outputs
# =========================================================================

output "ai_foundry_name" {
  description = "AI Foundry account name"
  value       = azurerm_cognitive_account.ai_foundry.name
}

output "ai_foundry_endpoint" {
  description = "AI Foundry cognitive services endpoint"
  value       = azurerm_cognitive_account.ai_foundry.endpoint
}

# =========================================================================
# Foundry Project outputs
# =========================================================================

output "project_name" {
  description = "Foundry project name"
  value       = azurerm_cognitive_account_project.lab.name
}

output "project_endpoint" {
  description = "Foundry project endpoint for the Agent SDK (PROJECT_ENDPOINT)"
  value       = "https://${azurerm_cognitive_account.ai_foundry.custom_subdomain_name}.services.ai.azure.com/api/projects/${azurerm_cognitive_account_project.lab.name}"
}

# =========================================================================
# Model Deployment outputs
# =========================================================================

output "model_deployment_name" {
  description = "Deployed model name (MODEL_DEPLOYMENT_NAME)"
  value       = azurerm_cognitive_deployment.model.name
}
