# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Terraform and Azure provider configuration
# Context: AZ-104 hands-on lab - Alert Notification Rate Limits (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Azure provider locked to specific subscription
provider "azurerm" {
  features {}

  # Subscription ID is defined in variables.tf and terraform.tfvars
  subscription_id = var.lab_subscription_id
}
