# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for AI Services module
# Context: AI-102 Lab - Agent Service file upload configuration
# Author: Greg Tate
# Date: 2026-02-14
# -------------------------------------------------------------------------

output "account_id" {
  description = "Resource ID of the AI Services account"
  value       = azurerm_cognitive_account.this.id
}

output "account_name" {
  description = "Name of the AI Services account"
  value       = azurerm_cognitive_account.this.name
}

output "endpoint" {
  description = "Endpoint of the AI Services account"
  value       = azurerm_cognitive_account.this.endpoint
}

output "principal_id" {
  description = "Principal ID of the system-assigned managed identity"
  value       = azurerm_cognitive_account.this.identity[0].principal_id
}

output "primary_access_key" {
  description = "Primary access key for the AI Services account"
  value       = azurerm_cognitive_account.this.primary_access_key
  sensitive   = true
}
