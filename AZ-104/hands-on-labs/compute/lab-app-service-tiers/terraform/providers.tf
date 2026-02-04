# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Shared Azure provider configuration with subscription lock
# Context: AZ-104 hands-on labs - Terraform shared configuration
# Author: Greg Tate
# -------------------------------------------------------------------------
#
# USAGE: Copy this file to your lab's terraform/ folder, or reference via symlink.
#
# IMPORTANT: Replace the placeholder subscription ID with your actual lab subscription.
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

# Locked to specific subscription - prevents accidental deployment to wrong environment
provider "azurerm" {
  features {}

  # Subscription ID is defined in variables.tf and terraform.tfvars
  subscription_id = var.lab_subscription_id
}
