# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for App Service pricing tier lab
# Context: AZ-104 hands-on lab - App Service Plans (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------

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
  default     = "app-service-tiers"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "owner" {
  description = "Lab owner for tagging"
  type        = string
  default     = "Greg Tate"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "MyPlan"
}

variable "app_name" {
  description = "Name of the Web App"
  type        = string
  default     = "MyApp"
}

variable "sku_name" {
  description = "SKU for App Service Plan: F1 (Free), D1 (Shared), B1 (Basic)"
  type        = string
  default     = "F1"

  validation {
    condition     = contains(["F1", "D1", "B1", "B2", "B3", "S1", "S2", "S3"], var.sku_name)
    error_message = "SKU must be a valid App Service Plan SKU (F1, D1, B1, B2, B3, S1, S2, S3)."
  }
}
