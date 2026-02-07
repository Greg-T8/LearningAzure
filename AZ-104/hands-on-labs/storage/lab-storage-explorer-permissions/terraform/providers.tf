# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Terraform and provider version configuration
# Context: AZ-104 Lab - Storage Explorer permission troubleshooting
# Author: Greg Tate
# Date: 2026-02-07
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
  features {}
  subscription_id = var.lab_subscription_id
}
