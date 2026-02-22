# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Terraform and provider version configuration
# Context: AZ-104 Lab - VM Disk Encryption with Key Vault
# Author: Greg Tate
# Date: 2026-02-22
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

# Configure the Azure provider with lab-specific settings
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.lab_subscription_id
}
