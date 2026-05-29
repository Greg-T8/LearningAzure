# -------------------------------------------------------------------------
# Program: modules/compute/outputs.tf
# Description: Output values from compute module
# Context: AZ-104 Lab - Troubleshoot Internal Load Balancer backend VM access
# Author: Greg Tate
# Date: 2026-02-16
# -------------------------------------------------------------------------

output "admin_username" {
  description = "Administrator username for Linux VMs"
  value       = local.admin_username
}

output "admin_password" {
  description = "Generated admin password for Linux VMs"
  value       = local.admin_password
  sensitive   = true
}

output "proxy_private_ip" {
  description = "Private IP address of the proxy VM"
  value       = azurerm_network_interface.proxy.ip_configuration[0].private_ip_address
}

output "backend_vm_ids" {
  description = "Map of backend VM instance keys to their IDs"
  value       = { for k, v in azurerm_linux_virtual_machine.backend : k => v.id }
}

output "proxy_vm_id" {
  description = "ID of the proxy VM"
  value       = azurerm_linux_virtual_machine.proxy.id
}
