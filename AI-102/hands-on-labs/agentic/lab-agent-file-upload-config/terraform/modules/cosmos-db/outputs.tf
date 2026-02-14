# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for Cosmos DB module
# Context: AI-102 Lab - Agent Service file upload configuration
# Author: Greg Tate
# Date: 2026-02-14
# -------------------------------------------------------------------------

output "account_id" {
  description = "Resource ID of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.this.id
}

output "account_name" {
  description = "Name of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.this.name
}

output "endpoint" {
  description = "Endpoint of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.this.endpoint
}

output "database_name" {
  description = "Name of the enterprise memory database"
  value       = azurerm_cosmosdb_sql_database.enterprise_memory.name
}
