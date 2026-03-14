# -------------------------------------------------------------------------
# Program: main.tf
# Description: Deploys storage account, container, and lifecycle policy
# Context: AZ-104 Lab - Configure Blob Storage Lifecycle Management
# Author: Greg Tate
# Date: 2026-03-02
# -------------------------------------------------------------------------

resource "azurerm_storage_account" "lifecycle" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  access_tier                     = "Hot"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true
  }

  tags = var.tags
}

resource "azurerm_storage_container" "lifecycle" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.lifecycle.id
  container_access_type = "private"
}

resource "azurerm_storage_management_policy" "lifecycle" {
  storage_account_id = azurerm_storage_account.lifecycle.id

  rule {
    name    = "myrule"
    enabled = true

    filters {
      blob_types   = ["blockBlob"]
      prefix_match = [var.blob_prefix]
    }

    actions {
      base_blob {
        auto_tier_to_hot_from_cool_enabled                    = true
        tier_to_cool_after_days_since_modification_greater_than    = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than          = 365
      }

      version {
        delete_after_days_since_creation = 90
      }
    }
  }
}
