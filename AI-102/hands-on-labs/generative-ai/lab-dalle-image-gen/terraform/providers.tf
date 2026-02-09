# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Terraform and provider configuration for DALL-E lab
# Context: AI-102 Lab - Generate and manipulate images with DALL-E
# Author: Greg Tate
# Date: 2026-02-09
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

# Azure Resource Manager provider
provider "azurerm" {
  features {}
  subscription_id = var.lab_subscription_id
}
