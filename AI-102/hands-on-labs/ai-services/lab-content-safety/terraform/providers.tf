# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Provider configuration for Azure AI Content Safety lab
# Context: AI-102 Lab - Azure AI Content Safety text and image moderation
# Author: Greg Tate
# Date: 2026-02-12
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
  features {}
  subscription_id = var.lab_subscription_id
}
