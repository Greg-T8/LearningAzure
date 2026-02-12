# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for the compute module
# Context: AZ-104 Lab - App Service Plan Tiers (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-12
# -------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "suffix" {
  description = "Random suffix for globally unique names"
  type        = string
}

variable "app_service_sku" {
  description = "SKU name for the App Service Plan"
  type        = string
}

variable "autoscale_max_instances" {
  description = "Maximum number of instances for autoscale"
  type        = number
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
