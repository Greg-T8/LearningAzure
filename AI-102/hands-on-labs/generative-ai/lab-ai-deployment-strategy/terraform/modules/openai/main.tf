# -------------------------------------------------------------------------
# Program: main.tf
# Description: Deploy Azure OpenAI account and model deployments.
# Context: AI-102 Lab - select an Azure AI deployment strategy (Generative AI)
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

terraform {
  required_providers {
    azapi = {
      source = "azure/azapi"
    }
  }
}

resource "random_string" "openai_suffix" {
  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}

locals {
  openai_account_name = "${var.openai_name_prefix}${random_string.openai_suffix.result}"
}

resource "azurerm_cognitive_account" "openai" {
  name                = local.openai_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "OpenAI"
  sku_name            = "S0"

  custom_subdomain_name          = local.openai_account_name
  public_network_access_enabled  = true
  outbound_network_access_restricted = false
  local_auth_enabled             = true

  tags = var.tags
}

resource "azapi_resource" "standard_deployment" {
  type      = "Microsoft.CognitiveServices/accounts/deployments@2024-10-01"
  name      = var.standard_deployment_name
  parent_id = azurerm_cognitive_account.openai.id

  schema_validation_enabled = false

  body = {
    properties = {
      model = {
        format  = "OpenAI"
        name    = var.model_name
        version = var.model_version
      }
      versionUpgradeOption = "OnceNewDefaultVersionAvailable"
    }
    sku = {
      name     = "Standard"
      capacity = var.standard_capacity
    }
    tags = var.tags
  }
}

resource "azapi_resource" "provisioned_deployment" {
  type      = "Microsoft.CognitiveServices/accounts/deployments@2024-10-01"
  name      = var.provisioned_deployment_name
  parent_id = azurerm_cognitive_account.openai.id

  schema_validation_enabled = false

  body = {
    properties = {
      model = {
        format  = "OpenAI"
        name    = var.model_name
        version = var.model_version
      }
      versionUpgradeOption = "NoAutoUpgrade"
    }
    sku = {
      name     = "ProvisionedManaged"
      capacity = var.provisioned_capacity
    }
    tags = var.tags
  }
}

resource "azapi_resource" "batch_deployment" {
  type      = "Microsoft.CognitiveServices/accounts/deployments@2024-10-01"
  name      = var.batch_deployment_name
  parent_id = azurerm_cognitive_account.openai.id

  schema_validation_enabled = false

  body = {
    properties = {
      model = {
        format  = "OpenAI"
        name    = var.model_name
        version = var.model_version
      }
      versionUpgradeOption = "NoAutoUpgrade"
    }
    sku = {
      name     = "GlobalBatch"
      capacity = var.batch_capacity
    }
    tags = var.tags
  }
}
