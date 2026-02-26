# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Define root input variables for the Terraform deployment.
# Context: AI-102 Lab - select an Azure AI deployment strategy (Generative AI)
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

variable "lab_subscription_id" {
  description = "Azure subscription ID for lab deployment."
  type        = string
}

variable "location" {
  description = "Primary Azure region for resources."
  type        = string
  default     = "eastus"
}

variable "owner" {
  description = "Owner tag value applied to all resources."
  type        = string
  default     = "Greg Tate"
}

variable "date_created" {
  description = "Static date used for the DateCreated tag."
  type        = string
  default     = "2026-02-26"
}

variable "openai_name_prefix" {
  description = "Prefix for Azure OpenAI account naming."
  type        = string
  default     = "oaiaideploystrategy"
}
