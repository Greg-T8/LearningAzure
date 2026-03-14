# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for VM disk encryption lab
# Context: AZ-104 Lab - VM Disk Encryption with Key Vault
# Author: Greg Tate
# Date: 2026-02-22
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the lab resource group"
  value       = azurerm_resource_group.lab.name
}

output "resource_group_id" {
  description = "ID of the lab resource group"
  value       = azurerm_resource_group.lab.id
}

# Key Vault outputs — these are the values tested in the exam question
output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.keyvault.key_vault_name
}

output "key_vault_uri" {
  description = "Key Vault URI (VaultUri) — used as DiskEncryptionKeyVaultUrl"
  value       = module.keyvault.key_vault_uri
}

output "key_vault_resource_id" {
  description = "Key Vault Resource ID — used as DiskEncryptionKeyVaultId"
  value       = module.keyvault.key_vault_resource_id
}

# Compute outputs
output "vm_name" {
  description = "Name of the Windows VM"
  value       = module.compute.vm_name
}

output "vm_id" {
  description = "ID of the Windows VM"
  value       = module.compute.vm_id
}

output "admin_username" {
  description = "VM admin username"
  value       = module.compute.admin_username
}

output "admin_password" {
  description = "VM admin password"
  value       = module.compute.admin_password
  sensitive   = true
}
