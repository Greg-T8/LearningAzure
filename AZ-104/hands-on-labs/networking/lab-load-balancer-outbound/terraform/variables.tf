# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Terraform variables for the lab
# Context: AZ-104 Lab - Load balancer outbound traffic
# Author: Greg Tate
# Date: 2026-02-05
# -------------------------------------------------------------------------

# Azure subscription for lab resources
variable "lab_subscription_id" {
  description = "Azure subscription ID for lab resources"
  type        = string
  sensitive   = true
}

# Lab domain aligned to AZ-104 governance
variable "domain" {
  description = "AZ-104 exam domain"
  type        = string
  validation {
    condition     = contains(["identity", "networking", "storage", "compute", "monitoring"], var.domain)
    error_message = "Domain must be one of: identity, networking, storage, compute, monitoring."
  }
}

# Lab topic in kebab-case
variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
}

# Azure region for deployment
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

# Lab owner tag value
variable "owner" {
  description = "Lab owner"
  type        = string
  default     = "Greg Tate"
}

# Local admin username for Windows VMs
variable "admin_username" {
  description = "Local administrator username for Windows VMs"
  type        = string
  default     = "azureuser"
}

# Local admin password for Windows VMs
variable "admin_password" {
  description = "Local administrator password for Windows VMs"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.admin_password) >= 12
    error_message = "Admin password must be at least 12 characters long."
  }
}

# VM size for the web tier
variable "vm_size" {
  description = "VM size for the web tier"
  type        = string
  default     = "Standard_D2s_v3"
}

# Allowed CIDR for RDP access
variable "allowed_rdp_cidr" {
  description = "CIDR block allowed to RDP into the VMs"
  type        = string
  default     = "0.0.0.0/0"
}
