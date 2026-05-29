# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values from networking module
# Context: AZ-104 Lab - Azure Monitor Metrics Batch API (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-20
# -------------------------------------------------------------------------

output "nic_ids" {
  description = "List of network interface IDs"
  value       = azurerm_network_interface.this[*].id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.this.name
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = azurerm_subnet.this.name
}
