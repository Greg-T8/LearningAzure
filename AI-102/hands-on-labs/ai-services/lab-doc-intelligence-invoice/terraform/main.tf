# -------------------------------------------------------------------------
# Program: main.tf
# Description: Root module — orchestrates child modules
# Context: AI-102 Lab - Document Intelligence Invoice Model
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

# Generate a random suffix for globally unique resource names
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Local values for resource group naming and common tags
locals {
  resource_group_name = "ai102-ai-services-doc-intelligence-invoice-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = "AI-102"
    Domain           = "AI Services"
    Purpose          = "Document Intelligence Invoice"
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

# Deploy the storage account for sample invoices
module "storage" {
  source = "./modules/storage"

  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  random_suffix       = random_string.suffix.result
  tags                = local.common_tags
}

# Deploy the Document Intelligence (Form Recognizer) resource
module "cognitive" {
  source = "./modules/cognitive"

  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  random_suffix       = random_string.suffix.result
  tags                = local.common_tags
}
