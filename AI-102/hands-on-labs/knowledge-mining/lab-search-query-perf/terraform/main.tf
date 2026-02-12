# -------------------------------------------------------------------------
# Program: main.tf
# Description: Orchestration for Azure AI Search with partitions for query performance
# Context: AI-102 Lab - Improve Azure AI Search query performance with partitions
# Author: Greg Tate
# Date: 2026-02-11
# -------------------------------------------------------------------------

# Generate a random suffix for globally unique resource names
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# Build common tags applied to all resources
locals {
  resource_group_name = "${var.exam}-${var.domain}-${var.topic}-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = upper(var.exam)
    Domain           = title(replace(var.domain, "-", " "))
    Purpose          = "Search Query Performance"
    Owner            = var.owner
    DateCreated      = var.date_created
    DeploymentMethod = "Terraform"
  }
}

# Create the lab resource group
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# ---------------------------------------------------------------------------
# Azure AI Search Service
# Basic SKU with configurable partitions to demonstrate query performance.
# Partitions split the index across physical shards, enabling parallel query
# processing and improving individual query latency.
# ---------------------------------------------------------------------------
resource "azurerm_search_service" "search" {
  name                = "srch-query-perf-${random_string.suffix.result}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  # Basic SKU supports up to 3 partitions and 3 replicas
  sku = var.search_sku

  # Partitions: split index data for parallel query processing (improves latency)
  partition_count = var.partition_count

  # Replicas: copies of the index for concurrent query handling (improves throughput)
  replica_count = var.replica_count

  # Enable public access for lab environment
  public_network_access_enabled = true

  # Use key-based auth for simplicity in lab
  local_authentication_enabled = true

  tags = local.common_tags
}

# ---------------------------------------------------------------------------
# Storage Account for Sample Documents
# Provides a data source for populating the search index.
# ---------------------------------------------------------------------------
resource "azurerm_storage_account" "data" {
  name                     = "stai102srch${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.lab.name
  location                 = azurerm_resource_group.lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public = false

  tags = merge(local.common_tags, {
    Purpose = "Search Data Source"
  })
}

# Create a blob container for sample documents
resource "azurerm_storage_container" "documents" {
  name                  = "documents"
  storage_account_id    = azurerm_storage_account.data.id
  container_access_type = "private"
}
