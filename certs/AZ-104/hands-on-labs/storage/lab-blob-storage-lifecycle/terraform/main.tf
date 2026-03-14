# -------------------------------------------------------------------------
# Program: main.tf
# Description: Root module that deploys the resource group and storage module
# Context: AZ-104 Lab - Configure Blob Storage Lifecycle Management
# Author: Greg Tate
# Date: 2026-03-02
# -------------------------------------------------------------------------

locals {
  resource_group_name = "az104-storage-blob-storage-lifecycle-tf"
  storage_account_name = "staz104bloblifecycle"
  container_name       = "container2"
  blob_prefix          = "container2/myblob"

  common_tags = {
    Environment      = "Lab"
    Project          = "AZ-104"
    Domain           = "Storage"
    Purpose          = "Blob Storage Lifecycle Management"
    Owner            = var.owner
    DateCreated      = var.date_created
    DeploymentMethod = "Terraform"
  }
}

resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

module "storage" {
  source = "./modules/storage"

  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  storage_account_name = local.storage_account_name
  container_name       = local.container_name
  blob_prefix          = local.blob_prefix
  tags                 = local.common_tags
}
