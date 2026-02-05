# -------------------------------------------------------------------------
# Program: main.tf
# Description: Storage Explorer RBAC permissions demonstration lab
# Context: AZ-104 hands-on lab - Storage RBAC (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------
#
# This lab demonstrates why users with Storage Blob Data Reader/Contributor
# roles cannot list containers in Azure Storage Explorer. It creates:
#   1. A storage account with blob containers and file shares
#   2. Service principals with different RBAC role assignments
#   3. Demonstrates data plane vs management plane access
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
# Data Sources
# -------------------------------------------------------------------------

# Get current Azure client configuration
data "azurerm_client_config" "current" {}

# Get current subscription details
data "azurerm_subscription" "current" {}

# -------------------------------------------------------------------------
# Random Suffix for Unique Names
# -------------------------------------------------------------------------

# Generate random suffix for globally unique resource names
resource "random_string" "suffix" {
  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}

# -------------------------------------------------------------------------
# Local Values
# -------------------------------------------------------------------------
locals {
  # Resource naming prefix
  name_prefix = "lab${random_string.suffix.result}"

  # Common tags for all resources
  common_tags = {
    Domain      = var.domain
    Topic       = var.topic
    Owner       = var.owner
    Environment = "lab"
    CreatedBy   = "Terraform"
    Purpose     = "AZ-104 Storage Explorer RBAC Lab"
  }
}

# -------------------------------------------------------------------------
# Resource Group
# -------------------------------------------------------------------------

# Create resource group for the lab
resource "azurerm_resource_group" "lab" {
  name     = "rg-${var.domain}-${var.topic}-${random_string.suffix.result}"
  location = var.location
  tags     = local.common_tags
}

# -------------------------------------------------------------------------
# Storage Account and Containers
# -------------------------------------------------------------------------

# Create storage account
resource "azurerm_storage_account" "lab" {
  name                     = "st${local.name_prefix}"
  resource_group_name      = azurerm_resource_group.lab.name
  location                 = azurerm_resource_group.lab.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type

  # Enable hierarchical namespace for better demonstration
  is_hns_enabled = false

  # Allow shared key access (for comparison testing)
  shared_access_key_enabled = true

  tags = local.common_tags
}

# Create blob container
resource "azurerm_storage_container" "documents" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.lab.id
  container_access_type = "private"
}

# Create file share
resource "azurerm_storage_share" "reports" {
  name               = var.file_share_name
  storage_account_id = azurerm_storage_account.lab.id
  quota              = 5
}

# Upload a sample blob for testing data access
resource "azurerm_storage_blob" "sample" {
  name                   = "sample-document.txt"
  storage_account_name   = azurerm_storage_account.lab.name
  storage_container_name = azurerm_storage_container.documents.name
  type                   = "Block"
  source_content         = "This is a sample document for testing Storage Explorer RBAC permissions."
}

# -------------------------------------------------------------------------
# Microsoft Entra ID Applications (Service Principals)
# -------------------------------------------------------------------------

# Service Principal 1: Storage Blob Data Reader only (WILL FAIL to list containers)
resource "azuread_application" "data_reader_only" {
  display_name = "sp-${local.name_prefix}-data-reader-only"
  owners       = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal" "data_reader_only" {
  client_id = azuread_application.data_reader_only.client_id
  owners    = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal_password" "data_reader_only" {
  service_principal_id = azuread_service_principal.data_reader_only.id
  end_date_relative    = "8760h" # 1 year
}

# Service Principal 2: Storage Blob Data Contributor only (WILL ALSO FAIL to list containers)
resource "azuread_application" "data_contributor_only" {
  display_name = "sp-${local.name_prefix}-data-contributor-only"
  owners       = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal" "data_contributor_only" {
  client_id = azuread_application.data_contributor_only.client_id
  owners    = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal_password" "data_contributor_only" {
  service_principal_id = azuread_service_principal.data_contributor_only.id
  end_date_relative    = "8760h"
}

# Service Principal 3: Reader + Storage Blob Data Reader (WILL SUCCEED)
resource "azuread_application" "both_roles" {
  display_name = "sp-${local.name_prefix}-reader-and-data-reader"
  owners       = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal" "both_roles" {
  client_id = azuread_application.both_roles.client_id
  owners    = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal_password" "both_roles" {
  service_principal_id = azuread_service_principal.both_roles.id
  end_date_relative    = "8760h"
}

# -------------------------------------------------------------------------
# RBAC Role Assignments
# -------------------------------------------------------------------------

# SP1: Storage Blob Data Reader only (Data Plane)
resource "azurerm_role_assignment" "data_reader_only" {
  scope                = azurerm_storage_account.lab.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azuread_service_principal.data_reader_only.object_id
}

# SP2: Storage Blob Data Contributor only (Data Plane)
resource "azurerm_role_assignment" "data_contributor_only" {
  scope                = azurerm_storage_account.lab.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.data_contributor_only.object_id
}

# SP3: Reader role (Management Plane) - enables listing containers
resource "azurerm_role_assignment" "both_roles_reader" {
  scope                = azurerm_storage_account.lab.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.both_roles.object_id
}

# SP3: Storage Blob Data Reader (Data Plane) - enables reading blob data
resource "azurerm_role_assignment" "both_roles_data_reader" {
  scope                = azurerm_storage_account.lab.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azuread_service_principal.both_roles.object_id
}

# -------------------------------------------------------------------------
# Time delay for role propagation
# -------------------------------------------------------------------------

# Allow time for role assignments to propagate
resource "time_sleep" "role_propagation" {
  depends_on = [
    azurerm_role_assignment.data_reader_only,
    azurerm_role_assignment.data_contributor_only,
    azurerm_role_assignment.both_roles_reader,
    azurerm_role_assignment.both_roles_data_reader
  ]

  create_duration = "30s"
}
