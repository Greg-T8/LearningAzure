# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for Internal Load Balancer backend access lab
# Context: AZ-104 Lab - Troubleshoot Internal Load Balancer backend VM access
# Author: Greg Tate
# Date: 2026-02-16
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "ilb_frontend_ip" {
  description = "Private frontend IP address of the Internal Load Balancer"
  value       = module.loadbalancer.frontend_ip_address
}

output "proxy_private_ip" {
  description = "Private IP address of the Nginx proxy VM"
  value       = module.compute.proxy_private_ip
}

output "pip_backend_01_address" {
  description = "Public IP address for SSH to vm-backend-01"
  value       = module.networking.pip_backend_01_address
}

output "pip_backend_02_address" {
  description = "Public IP address for SSH to vm-backend-02"
  value       = module.networking.pip_backend_02_address
}

output "pip_proxy_01_address" {
  description = "Public IP address for SSH to vm-proxy-01"
  value       = module.networking.pip_proxy_01_address
}

output "admin_username" {
  description = "Administrator username for Linux VMs"
  value       = module.compute.admin_username
}

output "admin_password" {
  description = "Generated admin password for Linux VMs"
  value       = module.compute.admin_password
  sensitive   = true
}
