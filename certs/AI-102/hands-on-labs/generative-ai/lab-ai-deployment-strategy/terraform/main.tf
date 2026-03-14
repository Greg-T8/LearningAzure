# -------------------------------------------------------------------------
# Program: main.tf
# Description: Orchestrate resource group and OpenAI module deployment.
# Context: AI-102 Lab - select an Azure AI deployment strategy (Generative AI)
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

locals {
  resource_group_name = "ai102-generative-ai-ai-deployment-strategy-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = "AI-102"
    Domain           = "Generative AI"
    Purpose          = "AI Deployment Strategy"
    Owner            = var.owner
    DateCreated      = var.date_created
    DeploymentMethod = "Terraform"
  }
}

resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

module "openai" {
  source = "./modules/openai"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = local.common_tags
  openai_name_prefix  = var.openai_name_prefix
}
