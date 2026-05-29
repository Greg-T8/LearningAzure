# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values from the compute module
# Context: AZ-104 Lab - App Service Plan Tiers (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-12
# -------------------------------------------------------------------------

output "app_service_plan_name" {
  description = "Name of the App Service Plan"
  value       = azurerm_service_plan.lab.name
}

output "app_service_plan_sku" {
  description = "SKU of the App Service Plan"
  value       = azurerm_service_plan.lab.sku_name
}

output "web_app_name" {
  description = "Name of the Web App"
  value       = azurerm_linux_web_app.lab.name
}

output "web_app_url" {
  description = "Default URL of the Web App"
  value       = "https://${azurerm_linux_web_app.lab.default_hostname}"
}

output "autoscale_setting_name" {
  description = "Name of the autoscale setting"
  value       = azurerm_monitor_autoscale_setting.lab.name
}

output "tier_comparison" {
  description = "App Service Plan tier comparison for exam reference"
  value = {
    shared     = "Multi-tenant VMs (shared with other customers' apps), no autoscale, limited compute"
    standard   = "Dedicated VMs (not shared with customers), autoscale up to 10, standard compute performance"
    premium_v3 = "Dedicated VMs (not shared with customers), autoscale up to 30, enhanced compute with high-performance SKUs"
    isolated   = "Dedicated VMs on dedicated infrastructure (ASE), network + compute isolation, autoscale up to 100, highest cost"
  }
}
