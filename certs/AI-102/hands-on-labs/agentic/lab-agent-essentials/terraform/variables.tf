# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variable declarations for Azure AI Agent Service essentials lab
# Context: AI-102 Lab - Agent Service Essentials (Threads, Files, Vector Stores)
# Author: Greg Tate
# Date: 2026-02-22
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
  default     = "agentic"

  validation {
    condition     = contains(["agentic", "ai-services", "generative-ai", "computer-vision", "nlp", "knowledge-mining"], var.domain)
    error_message = "Domain must be a valid AI-102 domain."
  }
}

variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
  default     = "agent-essentials"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"

  validation {
    condition     = contains(["eastus", "eastus2", "westus2", "centralus"], var.location)
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

variable "ai_services_sku" {
  description = "SKU tier for the AI Services account"
  type        = string
  default     = "S0"

  validation {
    condition     = contains(["S0"], var.ai_services_sku)
    error_message = "AI Services SKU must be S0."
  }
}

variable "model_name" {
  description = "OpenAI model name to deploy"
  type        = string
  default     = "gpt-4o-mini"
}

variable "model_version" {
  description = "OpenAI model version to deploy"
  type        = string
  default     = "2024-07-18"
}
