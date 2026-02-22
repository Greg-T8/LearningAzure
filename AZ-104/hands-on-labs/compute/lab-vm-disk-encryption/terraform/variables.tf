# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Variable definitions for VM disk encryption lab
# Context: AZ-104 Lab - VM Disk Encryption with Key Vault
# Author: Greg Tate
# Date: 2026-02-22
# -------------------------------------------------------------------------

variable "lab_subscription_id" {
  description = "Azure lab subscription ID"
  type        = string
}

variable "domain" {
  description = "AZ-104 exam domain"
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
  default     = "vm-disk-encryption"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"

  validation {
    condition     = contains(["eastus", "eastus2", "westus2", "centralus", "northcentralus"], var.location)
    error_message = "Location must be an allowed US region."
  }
}

variable "owner" {
  description = "Lab owner"
  type        = string
  default     = "Greg Tate"
}

variable "date_created" {
  description = "Static date for resource tagging (YYYY-MM-DD)"
  type        = string
  default     = "2026-02-22"
}
