# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for AI Search module
# Context: AI-102 Lab - Agent Service file upload configuration
# Author: Greg Tate
# Date: 2026-02-14
# -------------------------------------------------------------------------

output "service_id" {
  description = "Resource ID of the AI Search service"
  value       = azurerm_search_service.this.id
}

output "service_name" {
  description = "Name of the AI Search service"
  value       = azurerm_search_service.this.name
}
