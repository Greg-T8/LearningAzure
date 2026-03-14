# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Provider configuration for Azure AI Search performance lab
# Context: AI-102 Lab - Improve Azure AI Search query performance with partitions
# Author: Greg Tate
# Date: 2026-02-11
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

# Configure the Azure provider with the lab subscription
provider "azurerm" {
  features {}
  subscription_id = var.lab_subscription_id
}
