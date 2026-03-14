# -------------------------------------------------------------------------
# Program: outputs.tf (storage module)
# Description: Output values from storage module
# Context: AZ-104 Lab - Storage Explorer permission troubleshooting
# Author: Greg Tate
# Date: 2026-02-07
# -------------------------------------------------------------------------

# Unlocked storage account outputs
output "storage_account_unlocked_name" {
  description = "Name of the unlocked storage account"
  value       = azurerm_storage_account.unlocked.name
}

output "storage_account_unlocked_id" {
  description = "ID of the unlocked storage account"
  value       = azurerm_storage_account.unlocked.id
}

output "storage_account_unlocked_connection_string" {
  description = "Connection string for the unlocked storage account"
  value       = azurerm_storage_account.unlocked.primary_connection_string
  sensitive   = true
}

# ReadOnly lock storage account outputs
output "storage_account_readonly_lock_name" {
  description = "Name of the storage account with ReadOnly lock (if enabled)"
  value       = var.enable_readonly_lock ? azurerm_storage_account.readonly_lock[0].name : null
}

output "storage_account_readonly_lock_id" {
  description = "ID of the storage account with ReadOnly lock (if enabled)"
  value       = var.enable_readonly_lock ? azurerm_storage_account.readonly_lock[0].id : null
}

# CanNotDelete lock storage account outputs
output "storage_account_cannotdelete_lock_name" {
  description = "Name of the storage account with CanNotDelete lock (if enabled)"
  value       = var.enable_cannotdelete_lock ? azurerm_storage_account.cannotdelete_lock[0].name : null
}

output "storage_account_cannotdelete_lock_id" {
  description = "ID of the storage account with CanNotDelete lock (if enabled)"
  value       = var.enable_cannotdelete_lock ? azurerm_storage_account.cannotdelete_lock[0].id : null
}
