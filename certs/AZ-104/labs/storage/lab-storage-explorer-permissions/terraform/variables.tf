# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Variable definitions for storage explorer permissions lab
# Context: AZ-104 Lab - Storage Explorer permission troubleshooting
# Author: Greg Tate
# Date: 2026-02-07
# -------------------------------------------------------------------------

# Lab subscription ID (required)
variable "lab_subscription_id" {
  description = "Azure lab subscription ID"
  type        = string
}

# Domain validation
variable "domain" {
  description = "AZ-104 exam domain"
  type        = string
  default     = "storage"
  validation {
    condition     = contains(["identity", "networking", "storage", "compute", "monitoring"], var.domain)
    error_message = "Domain must be: identity, networking, storage, compute, or monitoring."
  }
}

# Lab topic
variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
  default     = "storage-explorer-permissions"
}

# Azure region
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
  validation {
    condition     = contains(["eastus", "eastus2", "westus2"], var.location)
    error_message = "Location must be eastus, eastus2, or westus2."
  }
}

# Owner
variable "owner" {
  description = "Lab owner"
  type        = string
  default     = "Greg Tate"
}

# Resource lock configuration
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
