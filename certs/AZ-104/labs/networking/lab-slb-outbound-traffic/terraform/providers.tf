# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Provider configuration for Standard Load Balancer outbound traffic lab
# Context: AZ-104 Lab - Configure Standard Load Balancer outbound traffic and IP allocation
# Author: Greg Tate
# Date: 2026-02-13
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
