# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for storage module
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

variable "storage_account_name" {
  description = "Name of the storage account (3-24 lowercase alphanumeric)"
  type        = string
}

variable "workspace_id" {
  description = "Workspace ID prefix for container names (simulates project workspace ID)"
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
