# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variable declarations for Azure AI Content Safety lab
# Context: AI-102 Lab - Azure AI Content Safety text and image moderation
# Author: Greg Tate
# Date: 2026-02-12
# -------------------------------------------------------------------------

variable "lab_subscription_id" {
  description = "Azure subscription ID for the lab environment"
  type        = string
}

variable "exam" {
  description = "Certification exam code (lowercase)"
  type        = string
  default     = "ai102"

  validation {
    condition     = contains(["ai102", "az104"], var.exam)
    error_message = "Exam must be: ai102 or az104."
  }
}

variable "domain" {
  description = "Exam domain or service area"
  type        = string
  default     = "ai-services"

  validation {
    condition     = contains(["ai-services", "generative-ai", "computer-vision", "nlp", "knowledge-mining"], var.domain)
    error_message = "Domain must be a valid AI-102 domain."
  }
}

variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
  default     = "content-safety"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"

  validation {
    condition     = contains(["eastus", "eastus2", "westus2"], var.location)
    error_message = "Location must be: eastus, eastus2, or westus2."
  }
}

variable "owner" {
  description = "Lab owner identifier"
  type        = string
  default     = "Greg Tate"
}

variable "date_created" {
  description = "Date the lab resources were created (YYYY-MM-DD format)"
  type        = string

  validation {
    condition     = can(regex("^\\d{4}-\\d{2}-\\d{2}$", var.date_created))
    error_message = "Date must be in YYYY-MM-DD format."
  }
}

variable "content_safety_sku" {
  description = "SKU tier for the Content Safety resource (F0 = Free, S0 = Standard)"
  type        = string
  default     = "S0"

  validation {
    condition     = contains(["F0", "S0"], var.content_safety_sku)
    error_message = "Content Safety SKU must be F0 or S0."
  }
}
