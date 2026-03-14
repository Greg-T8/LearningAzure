# -------------------------------------------------------------------------
# Program: modules/networking/outputs.tf
# Description: Output values from networking module
# Context: AZ-104 Lab - Configure Standard Load Balancer outbound traffic and IP allocation
# Author: Greg Tate
# Date: 2026-02-13
# -------------------------------------------------------------------------

output "subnet_id" {
  description = "ID of the web subnet"
  value       = azurerm_subnet.web.id
}

output "vm_pip_id" {
  description = "ID of VM01's public IP (IP01)"
  value       = azurerm_public_ip.vm_pip.id
}

output "vm_pip_address" {
  description = "IP address of VM01's public IP (IP01)"
  value       = azurerm_public_ip.vm_pip.ip_address
}

output "lb_pip_01_id" {
  description = "ID of LB frontend public IP (IP02)"
  value       = azurerm_public_ip.lb_pip_01.id
}

output "lb_pip_01_address" {
  description = "IP address of LB frontend public IP (IP02)"
  value       = azurerm_public_ip.lb_pip_01.ip_address
}

output "lb_pip_02_id" {
  description = "ID of LB frontend public IP (IP03)"
  value       = azurerm_public_ip.lb_pip_02.id
}

output "lb_pip_02_address" {
  description = "IP address of LB frontend public IP (IP03)"
  value       = azurerm_public_ip.lb_pip_02.ip_address
}
