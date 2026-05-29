# -------------------------------------------------------------------------
# Program: variables.tf (storage module)
# Description: Variable definitions for storage module
# Context: AZ-104 Lab - Storage Explorer permission troubleshooting
# Author: Greg Tate
# Date: 2026-02-07
# -------------------------------------------------------------------------

# Resource group name
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Location
variable "location" {
  description = "Azure region for resources"
  type        = string
}

# Topic for naming
variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
}

# Resource lock flags
variable "enable_readonly_lock" {
  description = "Enable ReadOnly resource lock on storage account"
  type        = bool
  default     = false
}

variable "enable_cannotdelete_lock" {
  description = "Enable CanNotDelete resource lock on storage account"
  type        = bool
  default     = false
}

# Tags
variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
