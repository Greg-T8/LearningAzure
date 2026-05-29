# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Variable definitions for storage account module
# Context: AZ-104 Lab - Storage account module inputs
# Author: Greg Tate
# Date: 2026-02-08
# -------------------------------------------------------------------------

# Resource group name
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Azure location
variable "location" {
  description = "Azure region for the storage account"
  type        = string
}

# Storage account name (must be globally unique)
variable "storage_account_name" {
  description = "Name of the storage account (3-24 chars, lowercase alphanumeric)"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Storage account name must be 3-24 characters, lowercase letters and numbers only."
  }
}

# Source or destination flag
variable "is_source" {
  description = "Whether this is the source storage account (determines change feed configuration)"
  type        = bool
}

# Resource tags
variable "tags" {
  description = "Tags to apply to the storage account"
  type        = map(string)
  default     = {}
}
