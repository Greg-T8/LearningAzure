# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variable declarations for Private Link Service lab
# Context: AZ-104 Lab - Azure Private Link Service network policies
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

variable "lab_subscription_id" {
  description = "Azure subscription ID for lab deployments"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "centralus"

  validation {
    condition     = contains(["centralus", "eastus", "eastus2", "westus2", "northcentralus"], var.location)
    error_message = "Location must be a supported US region."
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
  default     = "2026-02-26"
}
