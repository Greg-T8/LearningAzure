# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for Storage Explorer RBAC permissions lab
# Context: AZ-104 hands-on lab - Storage RBAC (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
# Subscription Guard Variable
# -------------------------------------------------------------------------
variable "lab_subscription_id" {
  description = "Azure subscription ID for lab deployments (prevents wrong-subscription mistakes)"
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.lab_subscription_id))
    error_message = "lab_subscription_id must be a valid GUID format."
  }
}

# -------------------------------------------------------------------------
# Domain and Lab Configuration
# -------------------------------------------------------------------------
variable "domain" {
  description = "AZ-104 exam domain"
  type        = string
  default     = "storage"

  validation {
    condition     = contains(["identity", "networking", "storage", "compute", "monitoring"], var.domain)
    error_message = "Domain must be: identity, networking, storage, compute, or monitoring."
  }
}

variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
  default     = "storage-explorer-rbac"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "owner" {
  description = "Lab owner for tagging"
  type        = string
  default     = "Greg Tate"
}

# -------------------------------------------------------------------------
# Storage Configuration
# -------------------------------------------------------------------------
variable "storage_account_tier" {
  description = "Storage account tier (Standard or Premium)"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "Storage account tier must be Standard or Premium."
  }
}

variable "storage_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS"], var.storage_replication_type)
    error_message = "Replication type must be LRS, GRS, RAGRS, or ZRS."
  }
}

variable "container_name" {
  description = "Name of the blob container to create"
  type        = string
  default     = "documents"
}

variable "file_share_name" {
  description = "Name of the file share to create"
  type        = string
  default     = "reports"
}
