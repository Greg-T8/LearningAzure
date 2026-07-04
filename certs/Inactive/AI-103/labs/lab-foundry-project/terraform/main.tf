# -------------------------------------------------------------------------
# Program: main.tf
# Description: Deploy AI Services Foundry resource, project, and model deployment
# Context: AI-103 Lab - Explore AI Studio project provisioning with Terraform
# Author: Greg Tate
# Date: 2026-04-06
# -------------------------------------------------------------------------

# Generate a suffix for globally unique cognitive resource naming.
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

# Build canonical naming and tags for the AI-103 lab deployment.
locals {
  resource_group_name = "${var.exam}-${var.domain}-${var.topic}-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = "AI-103"
    Domain           = title(replace(var.domain, "-", " "))
    Purpose          = var.purpose
    Owner            = var.owner
    DateCreated      = var.date_created
    DeploymentMethod = "Terraform"
  }
}

# Create the lab resource group.
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Deploy the Foundry parent resource as an AI Services cognitive account.
resource "azurerm_cognitive_account" "foundry" {
  name                = "cog-foundry-${random_string.suffix.result}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  kind                  = "AIServices"
  sku_name              = var.ai_services_sku
  custom_subdomain_name = "cog-foundry-${random_string.suffix.result}"

  project_management_enabled    = true
  public_network_access_enabled = true
  local_auth_enabled            = true

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

# Create the Foundry project used by the lab exercise.
resource "azurerm_cognitive_account_project" "project" {
  name                 = "proj-foundry-${random_string.suffix.result}"
  cognitive_account_id = azurerm_cognitive_account.foundry.id
  location             = azurerm_resource_group.lab.location

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

# Deploy the requested model into the Foundry resource.
resource "azurerm_cognitive_deployment" "model" {
  name                 = var.model_deployment_name
  cognitive_account_id = azurerm_cognitive_account.foundry.id

  sku {
    name     = var.deployment_sku
    capacity = var.deployment_capacity
  }

  model {
    format  = "OpenAI"
    name    = var.model_name
    version = var.model_version
  }

  depends_on = [azurerm_cognitive_account.foundry]
}

# Resolve current deployer identity for role assignment.
data "azurerm_client_config" "current" {}

# Grant data-plane model usage permissions for immediate testing.
resource "azurerm_role_assignment" "deployer_cognitive_user" {
  scope                = azurerm_cognitive_account.foundry.id
  role_definition_name = "Cognitive Services User"
  principal_id         = data.azurerm_client_config.current.object_id
  description          = "Lab deployer access for model inference and testing"
}

# Grant contributor permissions for Foundry project operations.
resource "azurerm_role_assignment" "deployer_cognitive_contributor" {
  scope                = azurerm_cognitive_account.foundry.id
  role_definition_name = "Cognitive Services Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
  description          = "Lab deployer access for Foundry resource and project operations"
}
