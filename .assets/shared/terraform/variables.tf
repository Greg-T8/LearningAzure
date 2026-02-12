# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Variable declarations for shared Terraform configuration
# Context: AZ-104 hands-on labs - Terraform shared configuration
# Author: Greg Tate
# -------------------------------------------------------------------------

variable "lab_subscription_id" {
  description = "Azure subscription ID for lab deployments"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.lab_subscription_id))
    error_message = "lab_subscription_id must be a valid Azure subscription ID (GUID format)."
  }
}

variable "location" {
  description = "Default Azure region for resource deployment"
  type        = string
  default     = "eastus"
}

variable "owner" {
  description = "Owner tag for resources"
  type        = string
  default     = "Greg Tate"
}
