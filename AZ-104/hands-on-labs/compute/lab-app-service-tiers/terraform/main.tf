# -------------------------------------------------------------------------
# Program: main.tf
# Description: Deploy App Service with configurable pricing tier
# Context: AZ-104 hands-on lab - App Service Plans (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------
# Note: terraform block and required_providers are defined in providers.tf
# Note: Provider configuration and subscription guard are in providers.tf and subscription-guard.tf

# Generate random suffix for globally unique app name
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
    Purpose          = "App Service Pricing Tiers"
    Owner            = var.owner
    DateCreated      = formatdate("YYYY-MM-DD", timestamp())
    DeploymentMethod = "Terraform"
  }

  # Unique app name (must be globally unique)
  unique_app_name = "${lower(var.app_name)}-${random_string.suffix.result}"
}

# Resource Group
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# App Service Plan with configurable SKU
resource "azurerm_service_plan" "myplan" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  os_type             = "Windows"
  sku_name            = var.sku_name
  tags                = local.common_tags
}

# Web App
resource "azurerm_windows_web_app" "myapp" {
  name                = local.unique_app_name
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  service_plan_id     = azurerm_service_plan.myplan.id
  tags                = local.common_tags

  site_config {
    always_on = var.sku_name == "F1" || var.sku_name == "D1" ? false : true
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "0"
  }
}
