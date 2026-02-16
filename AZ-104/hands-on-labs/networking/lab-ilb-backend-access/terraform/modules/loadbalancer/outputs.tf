# -------------------------------------------------------------------------
# Program: modules/loadbalancer/outputs.tf
# Description: Output values from load balancer module
# Context: AZ-104 Lab - Troubleshoot Internal Load Balancer backend VM access
# Author: Greg Tate
# Date: 2026-02-16
# -------------------------------------------------------------------------

output "lb_id" {
  description = "ID of the Internal Load Balancer"
  value       = azurerm_lb.internal.id
}

output "backend_pool_id" {
  description = "ID of the backend address pool"
  value       = azurerm_lb_backend_address_pool.backend.id
}

output "frontend_ip_address" {
  description = "Private frontend IP address of the Internal Load Balancer"
  value       = azurerm_lb.internal.frontend_ip_configuration[0].private_ip_address
}
