# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Terraform and Azure provider configuration
# Context: AZ-104 Lab - Azure Monitor Metrics Batch API (Microsoft Azure Administrator)
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

# Azure provider locked to lab subscription
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = var.lab_subscription_id
}
