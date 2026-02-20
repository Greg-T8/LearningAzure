# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for compute module
# Context: AZ-104 Lab - Azure Monitor Metrics Batch API (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-20
# -------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "topic" {
  description = "Lab topic slug for resource naming"
  type        = string
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 2
}

variable "nic_ids" {
  description = "List of NIC IDs to attach to VMs"
  type        = list(string)
}

variable "common_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}
