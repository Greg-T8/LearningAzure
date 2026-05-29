# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for storage explorer permissions lab
# Context: AZ-104 Lab - Storage Explorer permission troubleshooting
# Author: Greg Tate
# Date: 2026-02-07
# -------------------------------------------------------------------------

# Resource group outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.lab.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.lab.id
}

# Storage account outputs
output "storage_account_unlocked_name" {
  description = "Name of the unlocked storage account"
  value       = module.storage.storage_account_unlocked_name
}

output "storage_account_unlocked_id" {
  description = "ID of the unlocked storage account"
  value       = module.storage.storage_account_unlocked_id
}

output "storage_account_readonly_lock_name" {
  description = "Name of the storage account with ReadOnly lock (if enabled)"
  value       = module.storage.storage_account_readonly_lock_name
}

output "storage_account_readonly_lock_id" {
  description = "ID of the storage account with ReadOnly lock (if enabled)"
  value       = module.storage.storage_account_readonly_lock_id
}

output "storage_account_cannotdelete_lock_name" {
  description = "Name of the storage account with CanNotDelete lock (if enabled)"
  value       = module.storage.storage_account_cannotdelete_lock_name
}

output "storage_account_cannotdelete_lock_id" {
  description = "ID of the storage account with CanNotDelete lock (if enabled)"
  value       = module.storage.storage_account_cannotdelete_lock_id
}

# Connection string (sensitive)
output "storage_account_unlocked_connection_string" {
  description = "Connection string for the unlocked storage account"
  value       = module.storage.storage_account_unlocked_connection_string
  sensitive   = true
}

# Instructions
output "next_steps" {
  description = "Next steps for testing the lab"
  value       = <<-EOT
    Lab deployment complete!

    To test Storage Explorer permission scenarios:

    1. Assign RBAC roles to users/service principals:
       - Read role (management plane) - can see containers but NOT browse contents
       - Storage Blob Data Reader (data plane) - CAN browse blob contents
       - Storage Blob Data Contributor (data plane) - CAN browse and modify blob contents

    2. Test with Azure Storage Explorer:
       - Try to browse storage accounts with different role assignments
       - Observe: Read role shows containers but cannot browse
       - Observe: Data plane roles allow browsing contents

    3. Test with resource locks:
       - ReadOnly lock prevents listing account keys (causes error)
       - CanNotDelete lock does NOT prevent access (allows normal operation)

    Storage Accounts Created:
    - ${module.storage.storage_account_unlocked_name} (no locks)
    ${var.enable_readonly_lock ? "- ${module.storage.storage_account_readonly_lock_name} (ReadOnly lock - prevents key listing)" : ""}
    ${var.enable_cannotdelete_lock ? "- ${module.storage.storage_account_cannotdelete_lock_name} (CanNotDelete lock - allows access)" : ""}
