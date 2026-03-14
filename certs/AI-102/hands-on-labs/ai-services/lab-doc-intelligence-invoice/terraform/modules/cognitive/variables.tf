# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for the cognitive module
# Context: AI-102 Lab - Document Intelligence Invoice Model
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
}

variable "random_suffix" {
  description = "Random suffix for globally unique naming"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
}
