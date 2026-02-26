# -------------------------------------------------------------------------
# Program: modules/compute/variables.tf
# Description: Input variables for compute module
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

variable "backend_subnet_id" {
  description = "ID of the backend subnet for VM NIC"
  type        = string
}

variable "backend_pool_id" {
  description = "ID of the load balancer backend address pool"
  type        = string
}

variable "provider_vnet_id" {
  description = "ID of the provider VNet for Bastion Developer SKU"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}
