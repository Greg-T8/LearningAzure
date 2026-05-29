# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for the App Service Plan lab
# Context: AZ-104 Lab - App Service Plan Tiers (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-12
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.lab.name
}

output "app_service_plan_name" {
  description = "Name of the App Service Plan"
  value       = module.compute.app_service_plan_name
}

output "app_service_plan_sku" {
  description = "SKU of the App Service Plan"
  value       = module.compute.app_service_plan_sku
}

output "web_app_name" {
  description = "Name of the Web App"
  value       = module.compute.web_app_name
}

output "web_app_url" {
  description = "Default URL of the Web App"
  value       = module.compute.web_app_url
}

output "autoscale_setting_name" {
  description = "Name of the autoscale setting"
  value       = module.compute.autoscale_setting_name
}

output "tier_comparison" {
  description = "App Service Plan tier comparison for exam reference"
  value       = module.compute.tier_comparison
}
