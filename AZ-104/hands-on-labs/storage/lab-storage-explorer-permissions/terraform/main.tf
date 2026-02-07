# -------------------------------------------------------------------------
# Program: main.tf
# Description: Main orchestration for storage explorer permissions lab
# Context: AZ-104 Lab - Storage Explorer permission troubleshooting
# Author: Greg Tate
# Date: 2026-02-07
# -------------------------------------------------------------------------

# Common tags
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

# Resource group
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Storage module - creates storage accounts with different permission scenarios
module "storage" {
  source = "./modules/storage"

  resource_group_name      = azurerm_resource_group.lab.name
  location                 = var.location
  topic                    = var.topic
  enable_readonly_lock     = var.enable_readonly_lock
  enable_cannotdelete_lock = var.enable_cannotdelete_lock
  tags                     = local.common_tags
}
