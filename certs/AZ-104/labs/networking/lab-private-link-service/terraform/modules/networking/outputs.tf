# -------------------------------------------------------------------------
# Program: modules/networking/outputs.tf
# Description: Output values for networking module
# Context: AZ-104 Lab - Azure Private Link Service network policies
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

output "provider_vnet_id" {
  description = "ID of the provider virtual network"
  value       = azurerm_virtual_network.provider.id
}

output "provider_vnet_name" {
  description = "Name of the provider virtual network"
  value       = azurerm_virtual_network.provider.name
}

output "consumer_vnet_name" {
  description = "Name of the consumer virtual network"
  value       = azurerm_virtual_network.consumer.name
}

output "backend_subnet_id" {
  description = "ID of the backend subnet"
  value       = azurerm_subnet.backend.id
}

output "pls_subnet_id" {
  description = "ID of the Private Link Service subnet"
  value       = azurerm_subnet.pls.id
}

output "pe_subnet_id" {
  description = "ID of the Private Endpoint subnet in consumer VNet"
  value       = azurerm_subnet.pe.id
}

output "nsg_name" {
  description = "Name of the backend NSG"
  value       = azurerm_network_security_group.backend.name
}
