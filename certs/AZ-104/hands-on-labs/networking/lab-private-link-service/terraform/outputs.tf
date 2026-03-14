# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for Private Link Service lab
# Context: AZ-104 Lab - Azure Private Link Service network policies
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "provider_vnet_name" {
  description = "Name of the provider virtual network"
  value       = module.networking.provider_vnet_name
}

output "consumer_vnet_name" {
  description = "Name of the consumer virtual network"
  value       = module.networking.consumer_vnet_name
}

output "private_link_service_name" {
  description = "Name of the Private Link Service"
  value       = module.private_link.pls_name
}

output "private_link_service_id" {
  description = "ID of the Private Link Service"
  value       = module.private_link.pls_id
}

output "private_endpoint_name" {
  description = "Name of the Private Endpoint"
  value       = module.private_link.pe_name
}

output "private_endpoint_ip" {
  description = "Private IP address of the Private Endpoint"
  value       = module.private_link.pe_private_ip
}

output "lb_frontend_ip" {
  description = "Private IP address of the Internal Load Balancer frontend"
  value       = module.loadbalancer.frontend_ip_address
}

output "vm_private_ip" {
  description = "Private IP address of the backend VM"
  value       = module.compute.vm_private_ip
}

output "admin_username" {
  description = "Administrator username for the Linux VM"
  value       = module.compute.admin_username
}

output "admin_password" {
  description = "Generated admin password for the Linux VM"
  value       = module.compute.admin_password
  sensitive   = true
}
