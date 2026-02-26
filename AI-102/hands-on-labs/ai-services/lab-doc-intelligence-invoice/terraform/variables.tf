# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for the lab
# Context: AI-102 Lab - Document Intelligence Invoice Model
# Author: Greg Tate
# Date: 2026-02-26
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
