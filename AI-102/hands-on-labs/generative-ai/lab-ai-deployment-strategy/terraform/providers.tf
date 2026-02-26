# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Configure Terraform and Azure providers for the lab deployment.
# Context: AI-102 Lab - select an Azure AI deployment strategy (Generative AI)
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = var.lab_subscription_id
}

provider "azapi" {
  subscription_id = var.lab_subscription_id
}
