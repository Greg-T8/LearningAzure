# -------------------------------------------------------------------------
# Program: main.tf
# Description: Storage account module for object replication
# Context: AZ-104 Lab - Configure storage accounts with replication support
# Author: Greg Tate
# Date: 2026-02-08
# -------------------------------------------------------------------------

# Storage account with versioning and change feed enabled
resource "azurerm_storage_account" "account" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Blob versioning is required for object replication (both source and destination)
  blob_properties {
    versioning_enabled = true

    # Change feed is required on the SOURCE account for object replication
    change_feed_enabled = var.is_source

    # Retention policy for change feed (required when change feed is enabled)
    change_feed_retention_in_days = var.is_source ? 7 : null
  }

  tags = var.tags
}

# Blob container for replication
resource "azurerm_storage_container" "container" {
  name                  = var.is_source ? "source-data" : "replicated-data"
  storage_account_name  = azurerm_storage_account.account.name
  container_access_type = "private"
}
