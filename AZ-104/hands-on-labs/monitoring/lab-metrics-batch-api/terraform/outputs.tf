# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for metrics batch API lab
# Context: AZ-104 Lab - Azure Monitor Metrics Batch API (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-20
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.lab.name
}

output "vm_names" {
  description = "Names of the deployed VMs"
  value       = module.compute.vm_names
}

output "vm_resource_ids" {
  description = "Resource IDs of the deployed VMs (use with metrics:getBatch API)"
  value       = module.compute.vm_ids
}

output "admin_password" {
  description = "Admin password for VMs"
  value       = module.compute.admin_password
  sensitive   = true
}

output "metrics_batch_endpoint" {
  description = "Azure Monitor metrics:getBatch regional endpoint"
  value       = "https://${var.location}.metrics.monitor.azure.com/subscriptions/${var.lab_subscription_id}/metrics:getBatch"
}
