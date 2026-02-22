# -------------------------------------------------------------------------
# Program: outputs.tf (compute module)
# Description: Output values from compute module
# Context: AZ-104 Lab - VM Disk Encryption with Key Vault
# Author: Greg Tate
# Date: 2026-02-22
# -------------------------------------------------------------------------

output "vm_name" {
  description = "Name of the Windows VM"
  value       = azurerm_windows_virtual_machine.lab.name
}

output "vm_id" {
  description = "ID of the Windows VM"
  value       = azurerm_windows_virtual_machine.lab.id
}

output "admin_username" {
  description = "VM admin username"
  value       = azurerm_windows_virtual_machine.lab.admin_username
}

output "admin_password" {
  description = "VM admin password"
  value       = random_password.admin.result
  sensitive   = true
}

output "private_ip_address" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.vm.private_ip_address
}
