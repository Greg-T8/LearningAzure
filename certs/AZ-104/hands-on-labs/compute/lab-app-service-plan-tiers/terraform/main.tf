# -------------------------------------------------------------------------
# Program: main.tf
# Description: Orchestration for App Service Plan tier comparison lab
# Context: AZ-104 Lab - App Service Plan Tiers (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-12
# -------------------------------------------------------------------------
# This lab deploys an App Service Plan with autoscale to demonstrate
# scalability and compute requirements for Azure App Service tier selection.
# Standard S1 is used for cost efficiency; the README explains why the
# Isolated tier is the correct exam answer.
# -------------------------------------------------------------------------

# Generate random suffix for globally unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Local variables for naming and tagging
locals {
  resource_group_name = "az104-${var.domain}-${var.topic}-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = "AZ-104"
    Domain           = title(var.domain)
    Purpose          = "App Service Plan Tiers"
    Owner            = var.owner
    DateCreated      = formatdate("YYYY-MM-DD", timestamp())
    DeploymentMethod = "Terraform"
  }
}

# Resource Group
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Compute module - App Service Plan, Web App, and Autoscale
module "compute" {
  source = "./modules/compute"

  resource_group_name     = azurerm_resource_group.lab.name
  location                = azurerm_resource_group.lab.location
  suffix                  = random_string.suffix.result
  app_service_sku         = var.app_service_sku
  autoscale_max_instances = var.autoscale_max_instances
  common_tags             = local.common_tags
}
