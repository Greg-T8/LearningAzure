# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Terraform provider configuration for Azure Storage object replication lab
# Context: AZ-104 Lab - Configure object replication between storage accounts
# Author: Greg Tate
# Date: 2026-02-05
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
      version = "~> 3.6"
    }
  }
}

# Configure Azure provider with lab subscription
provider "azurerm" {
  features {}
  subscription_id = var.lab_subscription_id
}
