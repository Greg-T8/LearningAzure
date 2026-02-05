# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Terraform provider configuration for object replication lab
# Context: AZ-104 Lab - Object replication between storage accounts
# Author: Greg Tate
# Date: 2026-02-05
# -------------------------------------------------------------------------

# Terraform settings and required providers.
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

# Azure provider configuration.
provider "azurerm" {
  features {}
  subscription_id = var.lab_subscription_id
}
