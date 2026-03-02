# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for blob storage lifecycle lab deployment
# Context: AZ-104 Lab - Configure Blob Storage Lifecycle Management
# Author: Greg Tate
# Date: 2026-03-02
# -------------------------------------------------------------------------

variable "lab_subscription_id" {
  description = "Azure subscription ID for lab deployments"
  type        = string
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "eastus"
}

variable "owner" {
  description = "Resource owner name"
  type        = string
  default     = "Greg Tate"
}

variable "date_created" {
  description = "Static date for DateCreated tag (YYYY-MM-DD)"
  type        = string
}
