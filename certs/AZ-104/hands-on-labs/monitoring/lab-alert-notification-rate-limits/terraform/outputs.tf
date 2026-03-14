# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for alert notification rate limits lab
# Context: AZ-104 hands-on lab - Alert Notification Rate Limits (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.lab.name
}

output "vm_name" {
  description = "Name of the virtual machine generating metrics"
  value       = azurerm_linux_virtual_machine.lab.name
}

output "vm_resource_id" {
  description = "Resource ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.lab.id
}

output "alert_rule_name" {
  description = "Name of the metric alert rule"
  value       = azurerm_monitor_metric_alert.alert1.name
}

output "action_group_name" {
  description = "Name of the action group"
  value       = azurerm_monitor_action_group.alert_notifications.name
}

output "rate_limits_info" {
  description = "Azure notification rate limits for reference"
  value = {
    email_limit_per_hour = "100 emails/hour"
    voice_limit_per_hour = "5 voice calls/hour"
    sms_limit_per_hour   = "12 SMS/hour (1 per 5 minutes)"
    alert_frequency      = "Every 1 minute (60 times/hour)"
  }
}

output "expected_notifications_per_hour" {
  description = "Expected notifications per hour with rate limiting"
  value = {
    email_notifications = "60 (all alerts, under 100 limit)"
    voice_notifications = "5 (rate limited from 60 to 5)"
    sms_notifications   = "12 (rate limited from 60 to 12)"
  }
}

output "portal_links" {
  description = "Azure Portal links for validation"
  value = {
    alerts_blade = "https://portal.azure.com/#view/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/~/alertsV2"
    action_groups = "https://portal.azure.com/#view/Microsoft_Azure_Monitoring/ActionGroupsGrid.ReactView"
  }
}
