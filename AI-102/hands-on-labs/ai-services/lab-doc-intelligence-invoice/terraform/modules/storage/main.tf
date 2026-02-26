# -------------------------------------------------------------------------
# Program: main.tf
# Description: Storage account and container for sample invoices
# Context: AI-102 Lab - Document Intelligence Invoice Model
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

# Deploy the storage account for sample invoice documents
resource "azurerm_storage_account" "invoices" {
  name                     = "stai102docinv${var.random_suffix}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

# Create a container for storing sample invoices
resource "azurerm_storage_container" "invoices" {
  name               = "invoices"
  storage_account_id = azurerm_storage_account.invoices.id
}
