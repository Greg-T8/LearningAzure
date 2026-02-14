# -------------------------------------------------------------------------
# Program: main.tf
# Description: AI Services account with system-assigned managed identity
# Context: AI-102 Lab - Agent Service file upload configuration
# Author: Greg Tate
# Date: 2026-02-14
# -------------------------------------------------------------------------

# AI Services account (AI Foundry account) with system-assigned managed identity
resource "azurerm_cognitive_account" "this" {
  name                = var.account_name
  resource_group_name = var.resource_group_name
  location            = var.location

  kind     = "AIServices"
  sku_name = "S0"

  custom_subdomain_name = var.account_name

  # Lab-friendly settings
  public_network_access_enabled = true

  # System-assigned managed identity (used for RBAC on BYO resources)
  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}
