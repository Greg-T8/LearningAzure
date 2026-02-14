# -------------------------------------------------------------------------
# Program: main.tf
# Description: Orchestrate Azure AI Agent Service standard setup infrastructure
# Context: AI-102 Lab - Agent Service file upload configuration
# Author: Greg Tate
# Date: 2026-02-14
# -------------------------------------------------------------------------

# Common local values
locals {
  resource_group_name = "${var.exam}-${var.domain}-${var.topic}-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = upper(var.exam)
    Domain           = title(replace(var.domain, "-", " "))
    Purpose          = "Agent File Upload Config"
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

# Simulated workspace ID for container naming (in production, derived from project)
resource "random_uuid" "workspace_id" {}

# Resource group for lab resources
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# AI Services account with system-assigned managed identity
module "ai_services" {
  source = "./modules/ai-services"

  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  account_name        = "cog-agent-upload-${random_string.suffix.result}"
  common_tags         = local.common_tags
}

# Storage account with agent containers and RBAC role assignments
module "storage" {
  source = "./modules/storage"

  resource_group_name  = azurerm_resource_group.lab.name
  location             = azurerm_resource_group.lab.location
  storage_account_name = "stai102agentupload${random_string.suffix.result}"
  workspace_id         = random_uuid.workspace_id.result
  principal_id         = module.ai_services.principal_id
  common_tags          = local.common_tags
}

# Cosmos DB for agent conversation thread storage
module "cosmos_db" {
  source = "./modules/cosmos-db"

  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  account_name        = "cosmos-agent-upload-${random_string.suffix.result}"
  principal_id        = module.ai_services.principal_id
  common_tags         = local.common_tags
}

# AI Search for agent vector store operations
module "ai_search" {
  source = "./modules/ai-search"

  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  service_name        = "srch-agent-upload-${random_string.suffix.result}"
  principal_id        = module.ai_services.principal_id
  common_tags         = local.common_tags
}
