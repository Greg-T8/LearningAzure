# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for AI Search module
# Context: AI-102 Lab - Agent Service file upload configuration
# Author: Greg Tate
# Date: 2026-02-14
# -------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "service_name" {
  description = "Name of the AI Search service (globally unique)"
  type        = string
}

variable "principal_id" {
  description = "Principal ID of the managed identity for RBAC assignments"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
