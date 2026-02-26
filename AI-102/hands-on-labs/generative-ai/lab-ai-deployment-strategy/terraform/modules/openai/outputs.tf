# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Expose Azure OpenAI module outputs.
# Context: AI-102 Lab - select an Azure AI deployment strategy (Generative AI)
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

output "openai_account_name" {
  description = "Name of the Azure OpenAI account."
  value       = azurerm_cognitive_account.openai.name
}

output "openai_account_id" {
  description = "Resource ID of the Azure OpenAI account."
  value       = azurerm_cognitive_account.openai.id
}

output "openai_endpoint" {
  description = "Endpoint URI for Azure OpenAI account."
  value       = azurerm_cognitive_account.openai.endpoint
}

output "openai_primary_access_key" {
  description = "Primary key for Azure OpenAI access."
  value       = azurerm_cognitive_account.openai.primary_access_key
  sensitive   = true
}

output "standard_deployment_name" {
  description = "Name of the Standard deployment."
  value       = azapi_resource.standard_deployment.name
}

output "provisioned_deployment_name" {
  description = "Name of the Provisioned deployment."
  value       = azapi_resource.provisioned_deployment.name
}

output "batch_deployment_name" {
  description = "Name of the Batch deployment."
  value       = azapi_resource.batch_deployment.name
}
