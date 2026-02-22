# -------------------------------------------------------------------------
# Program: main.tf
# Description: Deploy Azure AI Foundry account, project, and model deployment
#              for hands-on agent service exercises
# Context: AI-102 Lab - Agent Service Essentials (Threads, Files, Vector Stores)
# Author: Greg Tate
# Date: 2026-02-22
# -------------------------------------------------------------------------

# =========================================================================
# Local values
# =========================================================================

locals {
  resource_group_name = "${var.exam}-${var.domain}-${var.topic}-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = upper(var.exam)
    Domain           = title(replace(var.domain, "-", " "))
    Purpose          = "Agent Service Essentials"
    Owner            = var.owner
    DateCreated      = var.date_created
    DeploymentMethod = "Terraform"
  }
}

# Random suffix for globally unique resource names
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

# =========================================================================
# Resource Group
# =========================================================================

resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# =========================================================================
# Azure AI Foundry Account (Cognitive Services with project management)
# =========================================================================

# AI Services account configured as a Foundry resource with project management
resource "azurerm_cognitive_account" "ai_foundry" {
  name                = "cog-agent-lab-${random_string.suffix.result}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  kind                  = "AIServices"
  sku_name              = var.ai_services_sku
  custom_subdomain_name = "cog-agent-lab-${random_string.suffix.result}"

  # Required for AI Foundry project management and Agent Service
  project_management_enabled    = true
  public_network_access_enabled = true

  # System-assigned managed identity for agent operations
  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

# =========================================================================
# AI Foundry Project
# =========================================================================

# Foundry project — organizational container for agents, threads, and files
resource "azurerm_cognitive_account_project" "lab" {
  name                 = "proj-agent-lab-${random_string.suffix.result}"
  cognitive_account_id = azurerm_cognitive_account.ai_foundry.id
  location             = azurerm_resource_group.lab.location

  # Project-level managed identity
  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

# =========================================================================
# Model Deployment (gpt-4o-mini for cost-effective agent operations)
# =========================================================================

# Deploy gpt-4o-mini for agent inference
resource "azurerm_cognitive_deployment" "model" {
  name                 = var.model_name
  cognitive_account_id = azurerm_cognitive_account.ai_foundry.id

  sku {
    name     = "GlobalStandard"
    capacity = 1
  }

  model {
    format  = "OpenAI"
    name    = var.model_name
    version = var.model_version
  }

  depends_on = [azurerm_cognitive_account.ai_foundry]
}

# =========================================================================
# RBAC: Grant deployer access to the Foundry project
# =========================================================================

# Get current client config for role assignments
data "azurerm_client_config" "current" {}

# Grant Cognitive Services User on the account for model inference
resource "azurerm_role_assignment" "deployer_cognitive_user" {
  scope                = azurerm_cognitive_account.ai_foundry.id
  role_definition_name = "Cognitive Services User"
  principal_id         = data.azurerm_client_config.current.object_id
  description          = "Lab deployer access for agent SDK operations"
}

# Grant Cognitive Services Contributor for agent management operations
resource "azurerm_role_assignment" "deployer_cognitive_contributor" {
  scope                = azurerm_cognitive_account.ai_foundry.id
  role_definition_name = "Cognitive Services Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
  description          = "Lab deployer access for creating agents, files, and vector stores"
}
