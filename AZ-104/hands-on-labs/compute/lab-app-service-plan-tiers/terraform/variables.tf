# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variable declarations for the App Service Plan lab
# Context: AZ-104 Lab - App Service Plan Tiers (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-12
# -------------------------------------------------------------------------

# -------------------------------------------------------
# Subscription Guard Variable
# -------------------------------------------------------

variable "lab_subscription_id" {
  description = "Azure subscription ID for lab deployments (prevents accidental deployment to wrong subscription)"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.lab_subscription_id))
    error_message = "Must be a valid Azure subscription GUID."
  }
}

# -------------------------------------------------------
# Domain and Lab Configuration
# -------------------------------------------------------

variable "domain" {
  description = "AZ-104 exam domain for this lab"
  type        = string
  default     = "compute"

  validation {
    condition     = contains(["identity", "networking", "storage", "compute", "monitoring"], var.domain)
    error_message = "Domain must be: identity, networking, storage, compute, or monitoring."
  }
}

variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
  default     = "app-service-plan-tiers"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus"

  validation {
    condition     = contains(["eastus", "eastus2", "westus2"], var.location)
    error_message = "Location must be: eastus, eastus2, or westus2."
  }
}

variable "owner" {
  description = "Lab owner identifier"
  type        = string
  default     = "Greg Tate"
}

# -------------------------------------------------------
# App Service Configuration
# -------------------------------------------------------

variable "app_service_sku" {
  description = "SKU name for the App Service Plan (S1=Standard, demonstrates autoscale)"
  type        = string
  default     = "S1"

  validation {
    condition     = contains(["S1", "S2", "S3", "P1v3", "P2v3", "P3v3"], var.app_service_sku)
    error_message = "SKU must be a Standard or Premium tier that supports autoscale."
  }
}

variable "autoscale_max_instances" {
  description = "Maximum number of instances for autoscale"
  type        = number
  default     = 10

  validation {
    condition     = var.autoscale_max_instances >= 1 && var.autoscale_max_instances <= 30
    error_message = "Max instances must be between 1 and 30."
  }
}
