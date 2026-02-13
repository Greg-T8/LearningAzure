# -------------------------------------------------------------------------
# Program: modules/loadbalancer/variables.tf
# Description: Input variables for load balancer module
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

variable "lb_pip_01_id" {
  description = "ID of the first public IP for LB frontend (IP02)"
  type        = string
}

variable "lb_pip_02_id" {
  description = "ID of the second public IP for LB frontend (IP03)"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
