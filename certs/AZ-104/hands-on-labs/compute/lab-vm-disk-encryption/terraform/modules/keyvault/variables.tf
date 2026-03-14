# -------------------------------------------------------------------------
# Program: variables.tf (keyvault module)
# Description: Variable definitions for Key Vault module
# Context: AZ-104 Lab - VM Disk Encryption with Key Vault
# Author: Greg Tate
# Date: 2026-02-22
# -------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
