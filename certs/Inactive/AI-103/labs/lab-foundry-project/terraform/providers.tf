# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Terraform and provider configuration for AI-103 Foundry project lab
# Context: AI-103 Lab - Explore AI Studio project provisioning with Terraform
# Author: Greg Tate
# Date: 2026-04-06
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

# Configure the Azure provider with the target lab subscription.
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }

    cognitive_account {
      purge_soft_delete_on_destroy = false
    }
  }

  subscription_id = var.lab_subscription_id
}
