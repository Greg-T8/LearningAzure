# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Expose key deployment outputs for validation and testing.
# Context: AI-102 Lab - select an Azure AI deployment strategy (Generative AI)
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the deployed resource group."
  value       = azurerm_resource_group.main.name
}

output "openai_account_name" {
  description = "Name of the Azure OpenAI account."
  value       = module.openai.openai_account_name
}

output "openai_endpoint" {
  description = "Endpoint URL for Azure OpenAI requests."
  value       = module.openai.openai_endpoint
}

output "openai_key" {
  description = "Primary access key for Azure OpenAI account."
  value       = module.openai.openai_primary_access_key
  sensitive   = true
}

output "deployment_names" {
  description = "Model deployment names created for the lab."
  value = {
    standard    = module.openai.standard_deployment_name
    provisioned = module.openai.provisioned_deployment_name
    batch       = module.openai.batch_deployment_name
  }
}
