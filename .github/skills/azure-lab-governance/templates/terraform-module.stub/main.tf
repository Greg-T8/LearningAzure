# -------------------------------------------------------------------------
# Program: main.tf
# Description: Root module — orchestrates child modules
# Context: <EXAM> Lab - <scenario>
# Author: Greg Tate
# Date: <YYYY-MM-DD>
# -------------------------------------------------------------------------

# Local values for resource group naming and common tags
locals {
  resource_group_name = "<exam>-<domain>-<topic>-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = "<EXAM>"
    Domain           = "<Domain>"
    Purpose          = "<Purpose>"
    Owner            = var.owner
    DateCreated      = var.date_created
    DeploymentMethod = "Terraform"
  }
}

# Create the resource group
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Example module call (replace with actual modules)
# module "networking" {
#   source              = "./modules/networking"
#   resource_group_name = azurerm_resource_group.lab.name
#   location            = azurerm_resource_group.lab.location
#   tags                = local.common_tags
# }
