# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for Azure AI Search performance lab
# Context: AI-102 Lab - Improve Azure AI Search query performance with partitions
# Author: Greg Tate
# Date: 2026-02-11
# -------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the lab resource group"
  value       = azurerm_resource_group.lab.name
}

output "search_service_name" {
  description = "Azure AI Search service name"
  value       = azurerm_search_service.search.name
}

output "search_service_endpoint" {
  description = "Azure AI Search service endpoint URL"
  value       = "https://${azurerm_search_service.search.name}.search.windows.net"
}

output "search_sku" {
  description = "Azure AI Search SKU tier"
  value       = azurerm_search_service.search.sku
}

output "search_partition_count" {
  description = "Number of search partitions (split index for parallel query processing)"
  value       = azurerm_search_service.search.partition_count
}

output "search_replica_count" {
  description = "Number of search replicas (copies for concurrent query handling)"
  value       = azurerm_search_service.search.replica_count
}

output "search_primary_key" {
  description = "Azure AI Search primary admin key"
  value       = azurerm_search_service.search.primary_key
  sensitive   = true
}

output "search_query_key" {
  description = "Azure AI Search query key (read-only)"
  value       = azurerm_search_service.search.query_keys[0].key
  sensitive   = true
}

output "storage_account_name" {
  description = "Storage account for sample documents"
  value       = azurerm_storage_account.data.name
}

output "storage_container_name" {
  description = "Blob container for sample documents"
  value       = azurerm_storage_container.documents.name
}

output "storage_connection_string" {
  description = "Storage account connection string (for indexer data source)"
  value       = azurerm_storage_account.data.primary_connection_string
  sensitive   = true
}
