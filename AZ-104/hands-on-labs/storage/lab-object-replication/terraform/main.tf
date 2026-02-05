# -------------------------------------------------------------------------
# Program: main.tf
# Description: Creates storage accounts and object replication policy
# Context: AZ-104 Lab - Object replication between storage accounts
# Author: Greg Tate
# Date: 2026-02-05
# -------------------------------------------------------------------------

# Define naming and tagging standards for the lab.
locals {
  resource_group_name = "az104-${var.domain}-${var.topic}-tf"
  storage_base_name   = substr("st${replace(var.topic, "-", "")}", 0, 18)

  common_tags = {
    Environment      = "Lab"
    Project          = "AZ-104"
    Domain           = title(var.domain)
    Purpose          = replace(title(var.topic), "-", " ")
    Owner            = var.owner
    DateCreated      = formatdate("YYYY-MM-DD", timestamp())
    DeploymentMethod = "Terraform"
  }
}

# Create a suffix to keep storage account names unique.
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  lower   = true
  numeric = true
  special = false
}

# Resource group for all lab resources.
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Source storage account with change feed and versioning enabled.
resource "azurerm_storage_account" "source" {
  name                       = "${local.storage_base_name}s${random_string.suffix.result}"
  resource_group_name        = azurerm_resource_group.lab.name
  location                   = var.location
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  account_kind               = "StorageV2"
  https_traffic_only_enabled = true
  tags                       = local.common_tags

  blob_properties {
    change_feed_enabled = true
    versioning_enabled  = true
  }
}

# Destination storage account with versioning enabled.
resource "azurerm_storage_account" "destination" {
  name                       = "${local.storage_base_name}d${random_string.suffix.result}"
  resource_group_name        = azurerm_resource_group.lab.name
  location                   = var.destination_location
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  account_kind               = "StorageV2"
  https_traffic_only_enabled = true
  tags                       = local.common_tags

  blob_properties {
    versioning_enabled = true
  }
}

# Source container for blobs to replicate.
resource "azurerm_storage_container" "source" {
  name                  = var.source_container_name
  storage_account_name  = azurerm_storage_account.source.name
  container_access_type = "private"
}

# Destination container for replicated blobs.
resource "azurerm_storage_container" "destination" {
  name                  = var.destination_container_name
  storage_account_name  = azurerm_storage_account.destination.name
  container_access_type = "private"
}

# Object replication policy from source to destination.
resource "azurerm_storage_object_replication" "replication" {
  source_storage_account_id      = azurerm_storage_account.source.id
  destination_storage_account_id = azurerm_storage_account.destination.id

  rules {
    source_container_name      = azurerm_storage_container.source.name
    destination_container_name = azurerm_storage_container.destination.name
  }
}
