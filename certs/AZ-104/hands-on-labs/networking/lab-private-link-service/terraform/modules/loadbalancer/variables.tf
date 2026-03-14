# -------------------------------------------------------------------------
# Program: modules/loadbalancer/variables.tf
# Description: Input variables for load balancer module
# Context: AZ-104 Lab - Azure Private Link Service network policies
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "pls_subnet_id" {
  description = "ID of the subnet for ILB frontend IP"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}
