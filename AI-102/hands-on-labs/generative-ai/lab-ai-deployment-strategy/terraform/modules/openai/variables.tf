# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Define module inputs for Azure OpenAI resources and deployments.
# Context: AI-102 Lab - select an Azure AI deployment strategy (Generative AI)
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Resource group name that hosts Azure OpenAI resources."
  type        = string
}

variable "location" {
  description = "Azure region for Azure OpenAI account."
  type        = string
}

variable "tags" {
  description = "Common tags applied to all supported resources."
  type        = map(string)
}

variable "openai_name_prefix" {
  description = "Prefix used to generate a globally unique OpenAI account name."
  type        = string
}

variable "model_name" {
  description = "Model name for lab deployments."
  type        = string
  default     = "gpt-4o-mini"
}

variable "model_version" {
  description = "Model version for lab deployments."
  type        = string
  default     = "2024-07-18"
}

variable "standard_deployment_name" {
  description = "Deployment name for serverless Standard deployment."
  type        = string
  default     = "deploy-gpt4o-standard"
}

variable "provisioned_deployment_name" {
  description = "Deployment name for PTU-backed deployment."
  type        = string
  default     = "deploy-gpt4o-provisioned"
}

variable "batch_deployment_name" {
  description = "Deployment name for batch deployment mode."
  type        = string
  default     = "deploy-gpt4o-batch"
}

variable "standard_capacity" {
  description = "Capacity units for Standard deployment."
  type        = number
  default     = 10
}

variable "provisioned_capacity" {
  description = "PTU capacity units for Provisioned deployment."
  type        = number
  default     = 15
}

variable "batch_capacity" {
  description = "Capacity units for batch deployment."
  type        = number
  default     = 10
}
