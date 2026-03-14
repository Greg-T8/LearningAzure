# -------------------------------------------------------------------------
# Program: modules/loadbalancer/outputs.tf
# Description: Output values from load balancer module
# Context: AZ-104 Lab - Configure Standard Load Balancer outbound traffic and IP allocation
# Author: Greg Tate
# Date: 2026-02-13
# -------------------------------------------------------------------------

output "lb_id" {
  description = "ID of the Standard Load Balancer"
  value       = azurerm_lb.main.id
}

output "inbound_pool_id" {
  description = "ID of the inbound backend address pool"
  value       = azurerm_lb_backend_address_pool.inbound.id
}

output "outbound_pool_id" {
  description = "ID of the outbound backend address pool"
  value       = azurerm_lb_backend_address_pool.outbound.id
}
