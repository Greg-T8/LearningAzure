# -------------------------------------------------------------------------
# Program: main.tf
# Description: Root orchestration for Azure Monitor Metrics Batch API lab
# Context: AZ-104 Lab - Azure Monitor Metrics Batch API (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-20
# -------------------------------------------------------------------------

# Common tags and naming
locals {
  resource_group_name = "az104-${var.domain}-${var.topic}-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = "AZ-104"
    Domain           = "Monitoring"
    Purpose          = "Metrics Batch API"
    Owner            = var.owner
    DateCreated      = var.date_created
    DeploymentMethod = "Terraform"
  }
}

# Resource group
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Networking module — VNet, subnet, NSG, NICs
module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  topic               = var.topic
  vm_count            = 2
  common_tags         = local.common_tags
}

# Compute module — VMs, auto-shutdown schedules
module "compute" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  topic               = var.topic
  vm_count            = 2
  nic_ids             = module.networking.nic_ids
  common_tags         = local.common_tags
}
