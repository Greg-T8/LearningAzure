# -------------------------------------------------------------------------
# Program: modules/private-link/outputs.tf
# Description: Output values for private link module
# Context: AZ-104 Lab - Azure Private Link Service network policies
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

output "pls_id" {
  description = "ID of the Private Link Service"
  value       = azurerm_private_link_service.main.id
}

output "pls_name" {
  description = "Name of the Private Link Service"
  value       = azurerm_private_link_service.main.name
}

output "pls_alias" {
  description = "Alias of the Private Link Service (used for cross-tenant connections)"
  value       = azurerm_private_link_service.main.alias
}

output "pe_name" {
  description = "Name of the Private Endpoint"
  value       = azurerm_private_endpoint.main.name
}

output "pe_id" {
  description = "ID of the Private Endpoint"
  value       = azurerm_private_endpoint.main.id
}

output "pe_private_ip" {
  description = "Private IP address of the Private Endpoint"
  value       = azurerm_private_endpoint.main.private_service_connection[0].private_ip_address
}
