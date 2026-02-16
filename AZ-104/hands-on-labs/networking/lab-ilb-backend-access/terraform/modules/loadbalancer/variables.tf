# -------------------------------------------------------------------------
# Program: modules/loadbalancer/variables.tf
# Description: Input variables for load balancer module
# Context: AZ-104 Lab - Troubleshoot Internal Load Balancer backend VM access
# Author: Greg Tate
# Date: 2026-02-16
# -------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "backend_subnet_id" {
  description = "ID of the backend subnet for ILB frontend IP"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
