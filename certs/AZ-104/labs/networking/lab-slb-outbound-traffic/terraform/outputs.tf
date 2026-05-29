# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for Standard Load Balancer outbound traffic lab
# Context: AZ-104 Lab - Configure Standard Load Balancer outbound traffic and IP allocation
# Author: Greg Tate
# Date: 2026-02-13
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vm_pip_address" {
  description = "Public IP address assigned to VM01 (IP01)"
  value       = module.networking.vm_pip_address
}

output "lb_pip_01_address" {
  description = "Public IP address assigned to LB frontend (IP02)"
  value       = module.networking.lb_pip_01_address
}

output "lb_pip_02_address" {
  description = "Public IP address assigned to LB frontend (IP03)"
  value       = module.networking.lb_pip_02_address
}

output "admin_username" {
  description = "Administrator username for Windows VMs"
  value       = module.compute.admin_username
}

output "admin_password" {
  description = "Generated admin password for Windows VMs (friendly format)"
  value       = module.compute.admin_password
  sensitive   = true
}

output "load_balancer_id" {
  description = "ID of the Standard Load Balancer"
  value       = module.loadbalancer.lb_id
}
