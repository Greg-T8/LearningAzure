# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Terraform and provider version constraints for object replication lab
# Context: AZ-104 Lab - Configure object replication between storage accounts
# Author: Greg Tate
# Date: 2026-02-08
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

# Azure Resource Manager provider configuration
provider "azurerm" {
  features {}
  subscription_id = var.lab_subscription_id
}
