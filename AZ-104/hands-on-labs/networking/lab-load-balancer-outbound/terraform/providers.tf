# -------------------------------------------------------------------------
# Program: providers.tf
# Description: Terraform provider configuration for the lab
# Context: AZ-104 Lab - Load balancer outbound traffic
# Author: Greg Tate
# Date: 2026-02-05
# -------------------------------------------------------------------------

# Terraform and provider versions
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# AzureRM provider configuration
provider "azurerm" {
  features {}
  subscription_id = var.lab_subscription_id
}
