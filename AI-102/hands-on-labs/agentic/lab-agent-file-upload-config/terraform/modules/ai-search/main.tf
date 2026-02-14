# -------------------------------------------------------------------------
# Program: main.tf
# Description: AI Search service with RBAC for agent vector store operations
# Context: AI-102 Lab - Agent Service file upload configuration
# Author: Greg Tate
# Date: 2026-02-14
# -------------------------------------------------------------------------

# AI Search service for agent vector store operations
resource "azurerm_search_service" "this" {
  name                = var.service_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "free"

  tags = var.common_tags
}

# Search Index Data Contributor (required for agent vector store operations)
resource "azurerm_role_assignment" "search_index_data_contributor" {
  scope                = azurerm_search_service.this.id
  role_definition_name = "Search Index Data Contributor"
  principal_id         = var.principal_id
}

# Search Service Contributor (required for managing search service configuration)
resource "azurerm_role_assignment" "search_service_contributor" {
  scope                = azurerm_search_service.this.id
  role_definition_name = "Search Service Contributor"
  principal_id         = var.principal_id
}
