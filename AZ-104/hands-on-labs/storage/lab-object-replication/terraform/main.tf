# -------------------------------------------------------------------------
# Program: main.tf
# Description: Main Terraform configuration for Azure Storage object replication lab
# Context: AZ-104 Lab - Configure object replication between storage accounts
# Author: Greg Tate
# Date: 2026-02-05
# -------------------------------------------------------------------------

# Local values for naming and tagging
locals {
  resource_group_name = "az104-${var.domain}-${var.topic}-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = "AZ-104"
    Domain           = "Storage"
    Purpose          = "Object Replication"
    Owner            = var.owner
    DateCreated      = "2026-02-05"
    DeploymentMethod = "Terraform"
  }
}

# Generate random suffix for globally unique storage account names
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Resource group for all lab resources
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.source_location
  tags     = local.common_tags
}

# Source storage account in first region
resource "azurerm_storage_account" "source" {
  name                     = "stsource${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.lab.name
  location                 = var.source_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # Enable blob versioning on source account (required for object replication)
  blob_properties {
    versioning_enabled = true

    change_feed_enabled = false
  }

  tags = local.common_tags
}

# Destination storage account in second region
resource "azurerm_storage_account" "destination" {
  name                     = "stdest${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.lab.name
  location                 = var.destination_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # Enable change feed on destination account (required for object replication)
  # Enable blob versioning on destination account (also required)
  blob_properties {
    versioning_enabled  = true
    change_feed_enabled = true
  }

  tags = local.common_tags
}

# Source blob container
resource "azurerm_storage_container" "source" {
  name                  = var.source_container_name
  storage_account_name  = azurerm_storage_account.source.name
  container_access_type = "private"
}

# Destination blob container
resource "azurerm_storage_container" "destination" {
  name                  = var.destination_container_name
  storage_account_name  = azurerm_storage_account.destination.name
  container_access_type = "private"
}

# Object replication policy (configured via Azure CLI after deployment)
# Note: As of Terraform AzureRM provider 4.x, object replication policy
# must be configured using Azure CLI or Portal after initial deployment
