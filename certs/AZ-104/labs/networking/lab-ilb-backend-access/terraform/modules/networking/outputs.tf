# -------------------------------------------------------------------------
# Program: modules/networking/outputs.tf
# Description: Output values from networking module
# Context: AZ-104 Lab - Troubleshoot Internal Load Balancer backend VM access
# Author: Greg Tate
# Date: 2026-02-16
# -------------------------------------------------------------------------

output "backend_subnet_id" {
  description = "ID of the backend subnet"
  value       = azurerm_subnet.backend.id
}

output "proxy_subnet_id" {
  description = "ID of the proxy subnet"
  value       = azurerm_subnet.proxy.id
}

output "pip_backend_01_id" {
  description = "ID of vm-backend-01 public IP"
  value       = azurerm_public_ip.backend_01.id
}

output "pip_backend_01_address" {
  description = "IP address of vm-backend-01 public IP"
  value       = azurerm_public_ip.backend_01.ip_address
}

output "pip_backend_02_id" {
  description = "ID of vm-backend-02 public IP"
  value       = azurerm_public_ip.backend_02.id
}

output "pip_backend_02_address" {
  description = "IP address of vm-backend-02 public IP"
  value       = azurerm_public_ip.backend_02.ip_address
}

output "pip_proxy_01_id" {
  description = "ID of vm-proxy-01 public IP"
  value       = azurerm_public_ip.proxy_01.id
}

output "pip_proxy_01_address" {
  description = "IP address of vm-proxy-01 public IP"
  value       = azurerm_public_ip.proxy_01.ip_address
}
