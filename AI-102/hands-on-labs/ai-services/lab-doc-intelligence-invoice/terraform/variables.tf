# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variable declarations for Document Intelligence lab
# Context: AI-102 Lab - Document Intelligence prebuilt invoice model
# Author: Greg Tate
# Date: 2026-02-20
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
  default     = "doc-intelligence-invoice"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "centralus"

  validation {
    condition     = contains(["centralus", "eastus", "eastus2", "westus2", "northcentralus"], var.location)
    error_message = "Location must be a supported US region."
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

variable "doc_intelligence_sku" {
  description = "SKU tier for Document Intelligence (F0 = Free, S0 = Standard)"
  type        = string
  default     = "F0"

  validation {
    condition     = contains(["F0", "S0"], var.doc_intelligence_sku)
    error_message = "Document Intelligence SKU must be F0 or S0."
  }
}
