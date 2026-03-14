# -------------------------------------------------------------------------
# Program: modules/networking/variables.tf
# Description: Input variables for networking module
# Context: AZ-104 Lab - Configure Standard Load Balancer outbound traffic and IP allocation
# Author: Greg Tate
# Date: 2026-02-13
# -------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
