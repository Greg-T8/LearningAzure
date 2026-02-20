# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Provider configuration for Azure AI Agent Service BYO storage lab
# Context: AI-102 Lab - Agent Service BYO Storage Configuration
# Author: Greg Tate
# Date: 2026-02-20
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
  }
}

# Configure the Azure provider with lab subscription
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }

    cognitive_account {
      purge_soft_delete_on_destroy = true
    }

    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }

  subscription_id = var.lab_subscription_id
}
