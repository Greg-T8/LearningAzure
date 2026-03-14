# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values from compute module
# Context: AZ-104 Lab - Azure Monitor Metrics Batch API (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-20
# -------------------------------------------------------------------------

output "vm_ids" {
  description = "List of VM resource IDs"
  value       = azurerm_linux_virtual_machine.this[*].id
}

output "vm_names" {
  description = "List of VM names"
  value       = azurerm_linux_virtual_machine.this[*].name
}

output "admin_password" {
  description = "Admin password for VMs"
  value       = random_password.admin.result
  sensitive   = true
}
