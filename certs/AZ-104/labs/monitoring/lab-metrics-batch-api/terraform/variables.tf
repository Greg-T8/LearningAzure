# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for metrics batch API lab
# Context: AZ-104 Lab - Azure Monitor Metrics Batch API (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-20
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
# Subscription Guard
# -------------------------------------------------------------------------
variable "lab_subscription_id" {
  description = "Azure subscription ID for lab deployments"
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.lab_subscription_id))
    error_message = "lab_subscription_id must be a valid GUID format."
  }
}

# -------------------------------------------------------------------------
# Lab Configuration
# -------------------------------------------------------------------------
variable "domain" {
  description = "AZ-104 exam domain"
  type        = string
  default     = "monitoring"

  validation {
    condition     = contains(["identity", "networking", "storage", "compute", "monitoring"], var.domain)
    error_message = "Domain must be: identity, networking, storage, compute, or monitoring."
  }
}

variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
  default     = "metrics-batch-api"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "centralus"
}

variable "owner" {
  description = "Lab owner for tagging"
  type        = string
  default     = "Greg Tate"
}

variable "date_created" {
  description = "Static date for DateCreated tag (YYYY-MM-DD)"
  type        = string
  default     = "2026-02-20"

  validation {
    condition     = can(regex("^\\d{4}-\\d{2}-\\d{2}$", var.date_created))
    error_message = "date_created must be in YYYY-MM-DD format."
  }
}
