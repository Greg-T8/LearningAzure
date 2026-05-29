# -------------------------------------------------------------------------
# Program: main.tf
# Description: App Service Plan, Web App, and Autoscale configuration
# Context: AZ-104 Lab - App Service Plan Tiers (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-12
# -------------------------------------------------------------------------
# Deploys an App Service Plan with Standard S1 SKU and configures autoscale
# to demonstrate scaling capabilities relevant to the exam scenario.
# -------------------------------------------------------------------------

# App Service Plan with Standard tier for autoscale demonstration
resource "azurerm_service_plan" "lab" {
  name                = "asp-web-lab"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_service_sku

  tags = var.common_tags
}

# Linux Web App deployed to the App Service Plan
resource "azurerm_linux_web_app" "lab" {
  name                = "app-web-lab-${var.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.lab.id

  site_config {

    # Node.js runtime for a lightweight web application
    application_stack {
      node_version = "20-lts"
    }

    # Always-on keeps the app loaded (available in Standard+)
    always_on = true
  }

  tags = var.common_tags
}

# Autoscale setting to demonstrate scaling to 10 instances
resource "azurerm_monitor_autoscale_setting" "lab" {
  name                = "autoscale-web-lab"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_service_plan.lab.id

  # Default autoscale profile with CPU-based scaling rules
  profile {
    name = "default-profile"

    # Scale capacity: min 1, max 10 (matches exam requirement)
    capacity {
      default = 1
      minimum = 1
      maximum = var.autoscale_max_instances
    }

    # Scale out when average CPU exceeds 70%
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.lab.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "2"
        cooldown  = "PT5M"
      }
    }

    # Scale in when average CPU drops below 30%
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.lab.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }

  tags = var.common_tags
}
