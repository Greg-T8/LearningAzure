# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for App Service pricing tier lab
# Context: AZ-104 hands-on lab - App Service Plans (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.lab.name
}

output "app_service_plan_name" {
  description = "Name of the App Service Plan"
  value       = azurerm_service_plan.myplan.name
}

output "app_service_plan_sku" {
  description = "SKU of the App Service Plan"
  value       = azurerm_service_plan.myplan.sku_name
}

output "app_name" {
  description = "Name of the Web App"
  value       = azurerm_windows_web_app.myapp.name
}

output "app_url" {
  description = "URL of the Web App"
  value       = "https://${azurerm_windows_web_app.myapp.default_hostname}"
}

output "tier_info" {
  description = "Information about the current tier"
  value = {
    sku          = var.sku_name
    daily_limit  = var.sku_name == "F1" ? "60 CPU minutes" : var.sku_name == "D1" ? "240 CPU minutes" : "Unlimited"
    compute_type = var.sku_name == "F1" || var.sku_name == "D1" ? "Shared" : "Dedicated"
  }
}

output "portal_url" {
  description = "Direct link to App Service Plan in Azure Portal"
  value       = "https://portal.azure.com/#@/resource${azurerm_service_plan.myplan.id}/scaleUp"
}
