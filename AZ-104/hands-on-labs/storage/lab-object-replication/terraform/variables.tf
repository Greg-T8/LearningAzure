# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for object replication lab
# Context: AZ-104 Lab - Object replication between storage accounts
# Author: Greg Tate
# Date: 2026-02-05
# -------------------------------------------------------------------------

# Azure subscription ID for lab resources.
variable "lab_subscription_id" {
  description = "Azure subscription ID for lab resources"
  type        = string
  sensitive   = true
}

# AZ-104 exam domain.
variable "domain" {
  description = "AZ-104 exam domain"
  type        = string
  default     = "storage"

  validation {
    condition     = contains(["identity", "networking", "storage", "compute", "monitoring"], var.domain)
    error_message = "Domain must be: identity, networking, storage, compute, or monitoring."
  }
}

# Lab topic in kebab-case.
variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
  default     = "object-replication"
}

# Primary Azure region for source resources.
variable "location" {
  description = "Azure region for source resources"
  type        = string
  default     = "eastus"

  validation {
    condition     = contains(["eastus", "eastus2", "westus2"], var.location)
    error_message = "Location must be eastus, eastus2, or westus2."
  }
}

# Secondary Azure region for destination resources.
variable "destination_location" {
  description = "Azure region for destination resources"
  type        = string
  default     = "westus2"

  validation {
    condition     = contains(["eastus", "eastus2", "westus2"], var.destination_location)
    error_message = "Destination location must be eastus, eastus2, or westus2."
  }
}

# Lab owner.
variable "owner" {
  description = "Lab owner"
  type        = string
  default     = "Greg Tate"
}

# Source container name.
variable "source_container_name" {
  description = "Source container name for replication"
  type        = string
  default     = "src-objects"
}

# Destination container name.
variable "destination_container_name" {
  description = "Destination container name for replication"
  type        = string
  default     = "dst-objects"
}
