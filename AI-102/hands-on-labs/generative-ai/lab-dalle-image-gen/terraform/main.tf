# -------------------------------------------------------------------------
# Program: main.tf
# Description: Deploy Azure OpenAI with DALL-E 3 for image generation
# Context: AI-102 Lab - Generate and manipulate images with DALL-E
# Author: Greg Tate
# Date: 2026-02-09
# -------------------------------------------------------------------------

# Local values for resource naming and tagging
locals {
  resource_group_name = "${var.exam}-${var.domain}-${var.topic}-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = upper(var.exam)
    Domain           = title(replace(var.domain, "-", " "))
    Purpose          = "DALL-E Image Generation"
    Owner            = var.owner
    DateCreated      = formatdate("YYYY-MM-DD", timestamp())
    DeploymentMethod = "Terraform"
  }
}

# Random suffix for globally unique names
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# Resource group for all lab resources
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Azure OpenAI cognitive services account
resource "azurerm_cognitive_account" "openai" {
  name                = "oai-dalle-${random_string.suffix.result}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  kind     = "OpenAI"
  sku_name = "S0"

  # Enable public network access for lab testing
  public_network_access_enabled = true

  # System-assigned managed identity for RBAC scenarios
  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

# Deploy DALL-E 3 model
resource "azurerm_cognitive_deployment" "dalle" {
  name                 = "deploy-dalle3"
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format = "OpenAI"
    name   = var.image_model_name
  }

  sku {
    name = "Standard"
  }
}

# Storage account for generated images
resource "azurerm_storage_account" "images" {
  name                     = "stai102img${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.lab.name
  location                 = azurerm_resource_group.lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Disable public blob access
  allow_nested_items_to_be_public = false

  tags = merge(local.common_tags, {
    Purpose = "Store DALL-E Generated Images"
  })
}

# Blob container for storing generated images
resource "azurerm_storage_container" "images" {
  name                  = "images"
  storage_account_id    = azurerm_storage_account.images.id
  container_access_type = "private"
}
