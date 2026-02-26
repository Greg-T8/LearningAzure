# -------------------------------------------------------------------------
# Program: modules/loadbalancer/outputs.tf
# Description: Output values for load balancer module
# Context: AZ-104 Lab - Azure Private Link Service network policies
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

output "lb_id" {
  description = "ID of the Standard Internal Load Balancer"
  value       = azurerm_lb.main.id
}

output "frontend_ip_config_id" {
  description = "ID of the load balancer frontend IP configuration"
  value       = azurerm_lb.main.frontend_ip_configuration[0].id
}

output "frontend_ip_address" {
  description = "Private IP address of the load balancer frontend"
  value       = azurerm_lb.main.frontend_ip_configuration[0].private_ip_address
}

output "backend_pool_id" {
  description = "ID of the backend address pool"
  value       = azurerm_lb_backend_address_pool.main.id
}
