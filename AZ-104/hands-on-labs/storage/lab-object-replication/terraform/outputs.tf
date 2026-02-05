# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for Azure Storage object replication lab
# Context: AZ-104 Lab - Configure object replication between storage accounts
# Author: Greg Tate
# Date: 2026-02-05
# -------------------------------------------------------------------------

# Resource group information
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.lab.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.lab.location
}

# Source storage account information
output "source_storage_account_name" {
  description = "Name of the source storage account"
  value       = azurerm_storage_account.source.name
}

output "source_storage_account_id" {
  description = "ID of the source storage account"
  value       = azurerm_storage_account.source.id
}

output "source_storage_account_location" {
  description = "Location of the source storage account"
  value       = azurerm_storage_account.source.location
}

output "source_container_name" {
  description = "Name of the source container"
  value       = azurerm_storage_container.source.name
}

output "source_versioning_enabled" {
  description = "Whether versioning is enabled on source storage account"
  value       = azurerm_storage_account.source.blob_properties[0].versioning_enabled
}

# Destination storage account information
output "destination_storage_account_name" {
  description = "Name of the destination storage account"
  value       = azurerm_storage_account.destination.name
}

output "destination_storage_account_id" {
  description = "ID of the destination storage account"
  value       = azurerm_storage_account.destination.id
}

output "destination_storage_account_location" {
  description = "Location of the destination storage account"
  value       = azurerm_storage_account.destination.location
}

output "destination_container_name" {
  description = "Name of the destination container"
  value       = azurerm_storage_container.destination.name
}

output "destination_versioning_enabled" {
  description = "Whether versioning is enabled on destination storage account"
  value       = azurerm_storage_account.destination.blob_properties[0].versioning_enabled
}

output "destination_change_feed_enabled" {
  description = "Whether change feed is enabled on destination storage account"
  value       = azurerm_storage_account.destination.blob_properties[0].change_feed_enabled
}

# Azure CLI commands for configuring object replication
output "configure_object_replication_commands" {
  description = "Azure CLI commands to configure object replication policy"
  value       = <<-EOT
    # Step 1: Create replication policy on destination account
    az storage account or-policy create \
      --account-name ${azurerm_storage_account.destination.name} \
      --source-account ${azurerm_storage_account.source.id} \
      --destination-account ${azurerm_storage_account.destination.id} \
      --source-container ${azurerm_storage_container.source.name} \
      --destination-container ${azurerm_storage_container.destination.name}

    # Step 2: Get the policy ID from the destination
    POLICY_ID=$(az storage account or-policy show \
      --account-name ${azurerm_storage_account.destination.name} \
      --policy-id <policy-id-from-step-1> \
      --query 'policyId' -o tsv)

    # Step 3: Apply policy to source account
    az storage account or-policy create \
      --account-name ${azurerm_storage_account.source.name} \
      --policy "@policy.json"
  EOT
}
