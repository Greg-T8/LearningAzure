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
  }
}

# Locked to specific subscription - prevents accidental deployment to wrong environment
provider "azurerm" {
  features {}

  # REPLACE with your lab subscription ID
  subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"  # sub-gtate-mpn-lab
}
