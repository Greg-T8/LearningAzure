# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Provider configuration for Azure lab deployment
# Context: AZ-104 Lab - Configure Blob Storage Lifecycle Management
# Author: Greg Tate
# Date: 2026-03-02
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

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = var.lab_subscription_id
}
