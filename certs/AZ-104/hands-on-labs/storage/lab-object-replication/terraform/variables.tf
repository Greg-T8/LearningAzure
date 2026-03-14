# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Variable definitions for object replication lab
# Context: AZ-104 Lab - Configure object replication between storage accounts
# Author: Greg Tate
# Date: 2026-02-08
# -------------------------------------------------------------------------

# Lab subscription ID (required)
variable "lab_subscription_id" {
  description = "Azure subscription ID for lab resources"
  type        = string
  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.lab_subscription_id))
    error_message = "Subscription ID must be a valid GUID."
  }
}

# AZ-104 exam domain
variable "domain" {
  description = "AZ-104 exam domain"
  type        = string
  validation {
    condition     = contains(["identity", "networking", "storage", "compute", "monitoring"], var.domain)
    error_message = "Domain must be one of: identity, networking, storage, compute, monitoring."
  }
}

# Lab topic in kebab-case
variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
}

# Azure region for source storage account
variable "location" {
  description = "Azure region for source storage account"
  type        = string
  default     = "eastus"
  validation {
    condition     = contains(["eastus", "eastus2", "westus2"], var.location)
    error_message = "Location must be one of: eastus, eastus2, westus2."
  }
}

# Azure region for destination storage account
variable "destination_location" {
  description = "Azure region for destination storage account (must differ from source)"
  type        = string
  default     = "eastus2"
  validation {
    condition     = contains(["eastus", "eastus2", "westus2"], var.destination_location)
    error_message = "Destination location must be one of: eastus, eastus2, westus2."
  }
}

# Lab owner
variable "owner" {
  description = "Lab owner name"
  type        = string
  default     = "Greg Tate"
}
