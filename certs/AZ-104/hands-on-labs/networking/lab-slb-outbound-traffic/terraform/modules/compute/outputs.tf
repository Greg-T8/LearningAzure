# -------------------------------------------------------------------------
# Program: modules/compute/outputs.tf
# Description: Output values from compute module
# Context: AZ-104 Lab - Configure Standard Load Balancer outbound traffic and IP allocation
# Author: Greg Tate
# Date: 2026-02-13
# -------------------------------------------------------------------------

output "admin_username" {
  description = "Administrator username for Windows VMs"
  value       = local.admin_username
}

output "admin_password" {
  description = "Generated admin password for Windows VMs (friendly format)"
  value       = local.admin_password
  sensitive   = true
}

output "vm_ids" {
  description = "Map of VM instance keys to their IDs"
  value       = { for k, v in azurerm_windows_virtual_machine.vm : k => v.id }
}
