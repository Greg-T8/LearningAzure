# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Provider configuration for Azure lab deployment
# Context: <EXAM> Lab - <scenario>
# Author: Greg Tate
# Date: <YYYY-MM-DD>
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

# Configure the Azure provider for lab environments
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = var.lab_subscription_id
}
