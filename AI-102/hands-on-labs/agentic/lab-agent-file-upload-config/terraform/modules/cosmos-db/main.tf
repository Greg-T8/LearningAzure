# -------------------------------------------------------------------------
# Program: main.tf
# Description: Cosmos DB for NoSQL with RBAC for agent thread storage
# Context: AI-102 Lab - Agent Service file upload configuration
# Author: Greg Tate
# Date: 2026-02-14
# -------------------------------------------------------------------------

# Cosmos DB account for agent conversation thread storage (serverless)
resource "azurerm_cosmosdb_account" "this" {
  name                = var.account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  offer_type          = "Standard"

  # Serverless mode (pay-per-request, no RU/s configuration needed)
  capabilities {
    name = "EnableServerless"
  }

  # Session consistency (suitable for agent conversations)
  consistency_policy {
    consistency_level = "Session"
  }

  # Primary region (single region for serverless)
  geo_location {
    location          = var.location
    failover_priority = 0
  }

  # Lab-friendly settings
  public_network_access_enabled = true

  tags = var.common_tags
}

# Enterprise memory database (stores agent threads and conversation history)
resource "azurerm_cosmosdb_sql_database" "enterprise_memory" {
  name                = "enterprise_memory"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
}

# Cosmos DB Operator role (control plane - REQUIRED for capability host provisioning)
resource "azurerm_role_assignment" "cosmos_operator" {
  scope                = azurerm_cosmosdb_account.this.id
  role_definition_name = "Cosmos DB Operator"
  principal_id         = var.principal_id
}

# Cosmos DB Built-in Data Contributor (data plane - REQUIRED for agent data operations)
resource "azurerm_cosmosdb_sql_role_assignment" "data_contributor" {
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  role_definition_id  = "${azurerm_cosmosdb_account.this.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = var.principal_id
  scope               = "${azurerm_cosmosdb_account.this.id}/dbs/${azurerm_cosmosdb_sql_database.enterprise_memory.name}"
}
