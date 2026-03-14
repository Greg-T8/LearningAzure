# -------------------------------------------------------------------------
# Program: outputs.tf (keyvault module)
# Description: Output values from Key Vault module
# Context: AZ-104 Lab - VM Disk Encryption with Key Vault
# Author: Greg Tate
# Date: 2026-02-22
# -------------------------------------------------------------------------

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.lab.name
}

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.lab.id
}

# VaultUri — the property tested in exam blank [2]
output "key_vault_uri" {
  description = "Key Vault URI (VaultUri property)"
  value       = azurerm_key_vault.lab.vault_uri
}

# ResourceId — the property tested in exam blank [3]
output "key_vault_resource_id" {
  description = "Key Vault full ARM Resource ID (ResourceId property)"
  value       = azurerm_key_vault.lab.id
}
