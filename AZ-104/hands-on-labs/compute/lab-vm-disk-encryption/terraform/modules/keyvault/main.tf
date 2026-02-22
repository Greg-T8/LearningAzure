# -------------------------------------------------------------------------
# Program: main.tf (keyvault module)
# Description: Key Vault configured for Azure Disk Encryption
# Context: AZ-104 Lab - VM Disk Encryption with Key Vault
# Author: Greg Tate
# Date: 2026-02-22
# -------------------------------------------------------------------------

# Get current client config for tenant ID and access policy
data "azurerm_client_config" "current" {}

# Random suffix for globally unique Key Vault name
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Key Vault with disk encryption enabled
resource "azurerm_key_vault" "lab" {
  name                        = "kv-disk-enc-${random_string.suffix.result}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = false
  enabled_for_disk_encryption = true

  # Access policy for the deploying user
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
      "WrapKey",
      "UnwrapKey",
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
    ]
  }

  tags = var.tags
}
