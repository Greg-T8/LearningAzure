# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Variable definitions for Azure Storage object replication lab
# Context: AZ-104 Lab - Configure object replication between storage accounts
# Author: Greg Tate
# Date: 2026-02-05
# -------------------------------------------------------------------------

# Azure subscription ID for lab resources
variable "lab_subscription_id" {
  description = "Azure subscription ID for lab resources"
  type        = string
  sensitive   = true
}

# AZ-104 exam domain
variable "domain" {
  description = "AZ-104 exam domain"
  type        = string
  default     = "storage"

  validation {
    condition     = contains(["identity", "networking", "storage", "compute", "monitoring"], var.domain)
    error_message = "Domain must be: identity, networking, storage, compute, or monitoring."
  }
}

# Lab topic in kebab-case
variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
  default     = "object-replication"
}

# Azure region for source storage account
variable "source_location" {
  description = "Azure region for source storage account"
  type        = string
  default     = "eastus"
}

# Azure region for destination storage account
variable "destination_location" {
  description = "Azure region for destination storage account"
  type        = string
  default     = "westus2"
}

# Lab owner
variable "owner" {
  description = "Lab owner"
  type        = string
  default     = "Greg Tate"
}

# Source container name
variable "source_container_name" {
  description = "Name of the source blob container"
  type        = string
  default     = "source-data"
}

# Destination container name
variable "destination_container_name" {
  description = "Name of the destination blob container"
  type        = string
  default     = "replicated-data"
}
