# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for the lab
# Context: <EXAM> Lab - <scenario>
# Author: Greg Tate
# Date: <YYYY-MM-DD>
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
