# -------------------------------------------------------------------------
# Program: main.tf
# Description: Main orchestration for object replication lab
# Context: AZ-104 Lab - Configure object replication between storage accounts
# Author: Greg Tate
# Date: 2026-02-08
# -------------------------------------------------------------------------

# Local variables for resource naming and tagging
locals {
  resource_group_name = "az104-${var.domain}-${var.topic}-tf"

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

# Resource group for lab resources
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Random suffix for globally unique storage account names
resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

# Source storage account with object replication enabled
module "source_storage" {
  source = "./modules/storage"

  resource_group_name  = azurerm_resource_group.lab.name
  location             = var.location
  storage_account_name = "staz104objrepsrc${random_integer.suffix.result}"
  is_source            = true
  tags = merge(local.common_tags, {
    ReplicationRole = "Source"
  })
}

# Destination storage account with object replication enabled
module "destination_storage" {
  source = "./modules/storage"

  resource_group_name  = azurerm_resource_group.lab.name
  location             = var.destination_location
  storage_account_name = "staz104objrepdst${random_integer.suffix.result}"
  is_source            = false
  tags = merge(local.common_tags, {
    ReplicationRole = "Destination"
  })
}

# Object replication policy
resource "azurerm_storage_object_replication" "policy" {
  source_storage_account_id      = module.source_storage.storage_account_id
  destination_storage_account_id = module.destination_storage.storage_account_id

  rules {
    source_container_name      = module.source_storage.container_name
    destination_container_name = module.destination_storage.container_name
  }

  # Ensure both storage accounts are fully configured before creating replication policy
  depends_on = [
    module.source_storage,
    module.destination_storage
  ]
}
