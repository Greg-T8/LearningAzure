# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for the storage lifecycle module
# Context: AZ-104 Lab - Configure Blob Storage Lifecycle Management
# Author: Greg Tate
# Date: 2026-03-02
# -------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for storage resources"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the GPv2 storage account"
  type        = string
}

variable "container_name" {
  description = "Name of the blob container"
  type        = string
}

variable "blob_prefix" {
  description = "Blob prefix targeted by lifecycle rule"
  type        = string
}

variable "tags" {
  description = "Common tags applied to taggable resources"
  type        = map(string)
}
