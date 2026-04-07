# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variable declarations for AI-103 Foundry project lab
# Context: AI-103 Lab - Explore AI Studio project provisioning with Terraform
# Author: Greg Tate
# Date: 2026-04-06
# -------------------------------------------------------------------------

# Identify the Azure subscription for lab resource deployment.
variable "lab_subscription_id" {
  description = "Azure subscription ID for lab deployments"
  type        = string
}

# Define the exam code segment used in naming.
variable "exam" {
  description = "Certification exam code used in resource group naming"
  type        = string
  default     = "ai103"

  validation {
    condition     = contains(["ai103"], var.exam)
    error_message = "Exam must be ai103 for this lab scaffold."
  }
}

# Define the domain segment used in naming and tags.
variable "domain" {
  description = "AI-103 domain slug used in naming"
  type        = string
  default     = "agentic"

  validation {
    condition = contains([
      "agentic",
      "generative-ai",
      "nlp",
      "computer-vision",
      "information-extraction",
      "ai-services"
    ], var.domain)
    error_message = "Domain must be one of: agentic, generative-ai, nlp, computer-vision, information-extraction, ai-services."
  }
}

# Define the topic segment used in naming.
variable "topic" {
  description = "Lab topic slug used in resource group naming"
  type        = string
  default     = "foundry-project"
}

# Select the Azure region for all resources.
variable "location" {
  description = "Azure region for lab resources"
  type        = string
  default     = "eastus"

  validation {
    condition     = contains(["eastus", "eastus2", "westus2", "centralus"], var.location)
    error_message = "Location must be one of: eastus, eastus2, westus2, centralus."
  }
}

# Set the owner tag applied across resources.
variable "owner" {
  description = "Resource owner for governance tagging"
  type        = string
  default     = "Greg Tate"
}

# Set a static date tag in YYYY-MM-DD format.
variable "date_created" {
  description = "Static date string for DateCreated tag (YYYY-MM-DD)"
  type        = string

  validation {
    condition     = can(regex("^\\d{4}-\\d{2}-\\d{2}$", var.date_created))
    error_message = "date_created must use YYYY-MM-DD format."
  }
}

# Define the Purpose tag text.
variable "purpose" {
  description = "Purpose tag value for this lab deployment"
  type        = string
  default     = "Explore AI Studio Foundry Project"
}

# Set the AI Services SKU for the Foundry parent resource.
variable "ai_services_sku" {
  description = "SKU for the Azure AI Services (Foundry parent) resource"
  type        = string
  default     = "S0"

  validation {
    condition     = contains(["S0"], var.ai_services_sku)
    error_message = "ai_services_sku must be S0 for this baseline scaffold."
  }
}

# Configure model deployment identity and version.
variable "model_name" {
  description = "Model name to deploy in the Foundry project"
  type        = string
  default     = "gpt-4.1"
}

# Configure model version to target in deployment.
variable "model_version" {
  description = "Model version to deploy; update based on regional availability"
  type        = string
  default     = "2025-04-14"
}

# Set the deployment resource name.
variable "model_deployment_name" {
  description = "Deployment name for the model deployment resource"
  type        = string
  default     = "deploy-gpt41"
}

# Configure the deployment SKU for model capacity.
variable "deployment_sku" {
  description = "SKU for the model deployment"
  type        = string
  default     = "GlobalStandard"
}

# Configure deployment capacity units.
variable "deployment_capacity" {
  description = "Capacity units for the model deployment"
  type        = number
  default     = 1

  validation {
    condition     = var.deployment_capacity >= 1
    error_message = "deployment_capacity must be at least 1."
  }
}
