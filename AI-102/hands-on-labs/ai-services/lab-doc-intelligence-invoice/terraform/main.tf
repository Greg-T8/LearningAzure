# -------------------------------------------------------------------------
# Program: main.tf
# Description: Deploy Azure AI Document Intelligence for invoice analysis
# Context: AI-102 Lab - Document Intelligence prebuilt invoice model
# Author: Greg Tate
# Date: 2026-02-20
# -------------------------------------------------------------------------

# Common local values
locals {
  resource_group_name = "${var.exam}-${var.domain}-${var.topic}-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = upper(var.exam)
    Domain           = title(replace(var.domain, "-", " "))
    Purpose          = "Document Intelligence Invoice"
    Owner            = var.owner
    DateCreated      = var.date_created
    DeploymentMethod = "Terraform"
  }
}

# Random suffix for globally unique resource names (soft-delete requires unique naming)
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

# Resource group for lab resources
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Azure AI Document Intelligence (Form Recognizer) account
resource "azurerm_cognitive_account" "doc_intelligence" {
  name                = "cog-doc-intelligence-${random_string.suffix.result}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  kind                  = "FormRecognizer"
  sku_name              = var.doc_intelligence_sku
  custom_subdomain_name = "cog-doc-intelligence-${random_string.suffix.result}"

  # Lab-friendly settings
  public_network_access_enabled = true

  # Managed identity for RBAC scenarios
  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}
