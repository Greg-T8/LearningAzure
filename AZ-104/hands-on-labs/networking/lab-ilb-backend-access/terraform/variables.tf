# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variable declarations for Internal Load Balancer backend access lab
# Context: AZ-104 Lab - Troubleshoot Internal Load Balancer backend VM access
# Author: Greg Tate
# Date: 2026-02-16
# -------------------------------------------------------------------------

variable "lab_subscription_id" {
  description = "Azure subscription ID for lab deployments"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus"

  validation {
    condition     = contains(["eastus", "eastus2", "westus2"], var.location)
    error_message = "Location must be one of: eastus, eastus2, westus2."
  }
}

variable "owner" {
  description = "Owner tag value for resource identification"
  type        = string
  default     = "Greg Tate"
}

variable "date_created" {
  description = "Static date string for DateCreated tag (YYYY-MM-DD format)"
  type        = string
  default     = "2026-02-16"
}
