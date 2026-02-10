# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for DALL-E image generation lab
# Context: AI-102 Lab - Generate and manipulate images with DALL-E
# Author: Greg Tate
# Date: 2026-02-09
# -------------------------------------------------------------------------

# Required: Azure lab subscription ID
variable "lab_subscription_id" {
  description = "Azure subscription ID for lab resources"
  type        = string
  sensitive   = true
}

# Exam and domain configuration
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
  description = "AI-102 exam domain"
  type        = string
  default     = "generative-ai"
  validation {
    condition     = contains(["ai-services", "generative-ai", "computer-vision", "nlp", "knowledge-mining"], var.domain)
    error_message = "Domain must be a valid AI-102 domain: ai-services, generative-ai, computer-vision, nlp, or knowledge-mining."
  }
}

variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
  default     = "dalle-image-gen"
}

# Azure region
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
  validation {
    condition     = contains(["eastus", "eastus2", "westus2"], var.location)
    error_message = "Location must be one of the allowed regions: eastus, eastus2, westus2."
  }
}

# Ownership
variable "owner" {
  description = "Lab owner name"
  type        = string
  default     = "Greg Tate"
}

# DALL-E model configuration
variable "image_model_name" {
  description = "DALL-E model name"
  type        = string
  default     = "dall-e-3"
}
