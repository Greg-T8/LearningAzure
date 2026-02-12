# -------------------------------------------------------------------------
# Program: main.tf
# Description: Deploy Azure AI Content Safety for text and image moderation
# Context: AI-102 Lab - Azure AI Content Safety text and image moderation
# Author: Greg Tate
# Date: 2026-02-12
# -------------------------------------------------------------------------

# Common local values
locals {
  resource_group_name = "${var.exam}-${var.domain}-${var.topic}-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = upper(var.exam)
    Domain           = title(replace(var.domain, "-", " "))
    Purpose          = "Content Safety Moderation"
    Owner            = var.owner
    DateCreated      = var.date_created
    DeploymentMethod = "Terraform"
  }
}

# Random suffix for globally unique resource names
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# Resource group for lab resources
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Azure AI Content Safety account
resource "azurerm_cognitive_account" "content_safety" {
  name                = "cog-content-safety-${random_string.suffix.result}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  kind     = "ContentSafety"
  sku_name = var.content_safety_sku

  # Lab-friendly settings
  public_network_access_enabled = true

  # Managed identity for RBAC scenarios
  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}
