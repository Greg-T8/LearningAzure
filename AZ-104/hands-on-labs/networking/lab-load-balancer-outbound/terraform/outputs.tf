# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for lab validation
# Context: AZ-104 Lab - Load balancer outbound traffic
# Author: Greg Tate
# Date: 2026-02-05
# -------------------------------------------------------------------------

# Resource group name
output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.lab.name
}

# Public IP assigned to VM01
output "vm01_public_ip" {
  description = "Public IP address for VM01"
  value       = azurerm_public_ip.vm01.ip_address
}

# Load balancer frontend IP02
output "lb_frontend_ip02" {
  description = "Public IP address for IP02"
  value       = azurerm_public_ip.lb_02.ip_address
}

# Load balancer frontend IP03
output "lb_frontend_ip03" {
  description = "Public IP address for IP03"
  value       = azurerm_public_ip.lb_03.ip_address
}

# Private IPs for the backend VMs
output "backend_private_ips" {
  description = "Private IP addresses for the backend VMs"
  value = tomap({
    for key, nic in azurerm_network_interface.vm : key => nic.private_ip_address
  })
}
