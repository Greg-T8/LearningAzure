# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Azure and Microsoft Entra ID provider configuration
# Context: AZ-104 hands-on lab - Storage RBAC (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0"

  required_providers {

    # Azure Resource Manager provider
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }

    # Microsoft Entra ID provider (for service principals)
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }

    # Random provider for unique names
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }

    # Time provider for role propagation delay
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

# Azure Resource Manager provider - locked to specific subscription
provider "azurerm" {
  features {}
  subscription_id = var.lab_subscription_id
}

# Microsoft Entra ID provider - uses current Azure CLI context
provider "azuread" {}
