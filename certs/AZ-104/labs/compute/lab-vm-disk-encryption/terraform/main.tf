# -------------------------------------------------------------------------
# Program: main.tf
# Description: Main orchestration for VM disk encryption lab
# Context: AZ-104 Lab - VM Disk Encryption with Key Vault
# Author: Greg Tate
# Date: 2026-02-22
# -------------------------------------------------------------------------

locals {
  resource_group_name = "az104-${var.domain}-${var.topic}-tf"

  # Required tags per Governance-Lab.md
  common_tags = {
    Environment      = "Lab"
    Project          = "AZ-104"
    Domain           = "Compute"
    Purpose          = "VM Disk Encryption"
    Owner            = var.owner
    DateCreated      = var.date_created
    DeploymentMethod = "Terraform"
  }
}

# Lab resource group
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Key Vault module — vault enabled for disk encryption
module "keyvault" {
  source = "./modules/keyvault"

  resource_group_name = azurerm_resource_group.lab.name
  location            = var.location
  topic               = var.topic
  tags                = local.common_tags
}

# Compute module — VNet, Subnet, NIC, Windows VM
module "compute" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.lab.name
  location            = var.location
  topic               = var.topic
  tags                = local.common_tags
}
