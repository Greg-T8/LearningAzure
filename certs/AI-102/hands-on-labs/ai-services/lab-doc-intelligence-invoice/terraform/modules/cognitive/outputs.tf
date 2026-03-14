# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for the cognitive module
# Context: AI-102 Lab - Document Intelligence Invoice Model
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

output "account_name" {
  description = "Name of the Document Intelligence account"
  value       = azurerm_cognitive_account.doc_intelligence.name
}

output "endpoint" {
  description = "Endpoint URL for the Document Intelligence account"
  value       = azurerm_cognitive_account.doc_intelligence.endpoint
}

output "primary_key" {
  description = "Primary access key for the Document Intelligence account"
  value       = azurerm_cognitive_account.doc_intelligence.primary_access_key
  sensitive   = true
}

output "id" {
  description = "Resource ID of the Document Intelligence account"
  value       = azurerm_cognitive_account.doc_intelligence.id
}
