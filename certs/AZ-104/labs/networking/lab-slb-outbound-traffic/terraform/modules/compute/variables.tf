# -------------------------------------------------------------------------
# Program: modules/compute/variables.tf
# Description: Input variables for compute module
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

variable "subnet_id" {
  description = "ID of the subnet for VM NICs"
  type        = string
}

variable "vm_pip_id" {
  description = "ID of the public IP for VM01 (IP01)"
  type        = string
}

variable "inbound_pool_id" {
  description = "ID of the inbound backend address pool"
  type        = string
}

variable "outbound_pool_id" {
  description = "ID of the outbound backend address pool"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
