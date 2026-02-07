# -------------------------------------------------------------------------
# Program: main.tf (storage module)
# Description: Storage resources for permission scenario testing
# Context: AZ-104 Lab - Storage Explorer permission troubleshooting
# Author: Greg Tate
# Date: 2026-02-07
# -------------------------------------------------------------------------

# Random suffix for globally unique storage account names
resource "random_integer" "suffix" {
  min = 100000
  max = 999999
}

# Storage account without any locks (baseline)
resource "azurerm_storage_account" "unlocked" {
  name                     = "staz104unlocked${random_integer.suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = var.tags
}

# Blob container in unlocked storage account
resource "azurerm_storage_container" "unlocked_blob" {
  name                  = "documents"
  storage_account_name  = azurerm_storage_account.unlocked.name
  container_access_type = "private"
}

# File share in unlocked storage account
resource "azurerm_storage_share" "unlocked_file" {
  name                 = "fileshare"
  storage_account_name = azurerm_storage_account.unlocked.name
  quota                = 5
}

# Storage account with ReadOnly lock (if enabled)
resource "azurerm_storage_account" "readonly_lock" {
  count                    = var.enable_readonly_lock ? 1 : 0
  name                     = "staz104readonly${random_integer.suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = var.tags
}

# Blob container in readonly storage account
resource "azurerm_storage_container" "readonly_blob" {
  count                 = var.enable_readonly_lock ? 1 : 0
  name                  = "documents"
  storage_account_name  = azurerm_storage_account.readonly_lock[0].name
  container_access_type = "private"
}

# ReadOnly resource lock
resource "azurerm_management_lock" "readonly" {
  count      = var.enable_readonly_lock ? 1 : 0
  name       = "lock-readonly"
  scope      = azurerm_storage_account.readonly_lock[0].id
  lock_level = "ReadOnly"
  notes      = "Prevents listing account keys - demonstrates Storage Explorer authentication issue"
}

# Storage account with CanNotDelete lock (if enabled)
resource "azurerm_storage_account" "cannotdelete_lock" {
  count                    = var.enable_cannotdelete_lock ? 1 : 0
  name                     = "staz104cannotdel${random_integer.suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = var.tags
}

# Blob container in cannotdelete storage account
resource "azurerm_storage_container" "cannotdelete_blob" {
  count                 = var.enable_cannotdelete_lock ? 1 : 0
  name                  = "documents"
  storage_account_name  = azurerm_storage_account.cannotdelete_lock[0].name
  container_access_type = "private"
}

# CanNotDelete resource lock (does NOT prevent key listing)
resource "azurerm_management_lock" "cannotdelete" {
  count      = var.enable_cannotdelete_lock ? 1 : 0
  name       = "lock-cannotdelete"
  scope      = azurerm_storage_account.cannotdelete_lock[0].id
  lock_level = "CanNotDelete"
  notes      = "Prevents resource deletion but allows key listing - Storage Explorer should work"
}
