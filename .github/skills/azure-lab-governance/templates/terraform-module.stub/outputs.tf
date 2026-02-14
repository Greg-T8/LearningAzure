# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for the lab
# Context: <EXAM> Lab - <scenario>
# Author: Greg Tate
# Date: <YYYY-MM-DD>
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the lab resource group"
  value       = azurerm_resource_group.lab.name
}

output "resource_group_id" {
  description = "ID of the lab resource group"
  value       = azurerm_resource_group.lab.id
}
