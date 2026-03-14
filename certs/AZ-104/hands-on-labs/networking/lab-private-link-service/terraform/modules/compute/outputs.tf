# -------------------------------------------------------------------------
# Program: modules/compute/outputs.tf
# Description: Output values for compute module
# Context: AZ-104 Lab - Azure Private Link Service network policies
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

output "vm_id" {
  description = "ID of the Linux VM"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_name" {
  description = "Name of the Linux VM"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.vm.private_ip_address
}

output "admin_username" {
  description = "Administrator username for the VM"
  value       = local.admin_username
}

output "admin_password" {
  description = "Generated admin password for the VM"
  value       = local.admin_password
  sensitive   = true
}

output "bastion_name" {
  description = "Name of the Azure Bastion host"
  value       = azurerm_bastion_host.main.name
}
