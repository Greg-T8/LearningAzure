# -------------------------------------------------------------------------
# Program: modules/compute/variables.tf
# Description: Input variables for compute module
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
  description = "ID of the backend subnet for VM NICs"
  type        = string
}

variable "proxy_subnet_id" {
  description = "ID of the proxy subnet for proxy VM NIC"
  type        = string
}

variable "pip_backend_01_id" {
  description = "ID of the public IP for vm-backend-01"
  type        = string
}

variable "pip_backend_02_id" {
  description = "ID of the public IP for vm-backend-02"
  type        = string
}

variable "pip_proxy_01_id" {
  description = "ID of the public IP for vm-proxy-01"
  type        = string
}

variable "backend_pool_id" {
  description = "ID of the ILB backend address pool"
  type        = string
}

variable "ilb_frontend_ip" {
  description = "Private frontend IP of the Internal Load Balancer"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
