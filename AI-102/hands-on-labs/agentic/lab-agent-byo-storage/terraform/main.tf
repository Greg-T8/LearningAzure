# -------------------------------------------------------------------------
# Program: main.tf
# Description: Deploy Azure AI Agent Service infrastructure with BYO storage
#              and correct RBAC for file upload operations
# Context: AI-102 Lab - Agent Service BYO Storage Configuration
# Author: Greg Tate
# Date: 2026-02-20
# -------------------------------------------------------------------------

# =========================================================================
# Local values
# =========================================================================

locals {
  resource_group_name = "${var.exam}-${var.domain}-${var.topic}-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = upper(var.exam)
    Domain           = title(replace(var.domain, "-", " "))
    Purpose          = "Agent BYO Storage"
    Owner            = var.owner
    DateCreated      = var.date_created
    DeploymentMethod = "Terraform"
  }
}

# Random suffix for globally unique resource names
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

# =========================================================================
# Resource Group
# =========================================================================

resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# =========================================================================
# Azure AI Services Account (Foundry Account)
# =========================================================================

# AI Services multi-service account with managed identity for agent operations
resource "azurerm_cognitive_account" "ai_services" {
  name                = "cog-agent-byo-${random_string.suffix.result}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  kind                  = "AIServices"
  sku_name              = var.ai_services_sku
  custom_subdomain_name = "cog-agent-byo-${random_string.suffix.result}"

  # Lab-friendly settings
  public_network_access_enabled = true

  # System-assigned managed identity for RBAC on BYO resources
  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

# =========================================================================
# BYO Storage Account (for Agent file uploads)
# =========================================================================

# Storage account that the agent service uses for file uploads and blob storage
resource "azurerm_storage_account" "agent_byo" {
  name                = "stai102agentbyo${random_string.suffix.result}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # Lab-friendly settings
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false

  tags = local.common_tags
}

# =========================================================================
# RBAC: Storage Blob Data Owner on BYO Storage
# =========================================================================

# Get current client config for additional role assignments
data "azurerm_client_config" "current" {}

# CRITICAL: The AI Services managed identity needs Storage Blob Data Owner
# (data plane access) to upload files to the BYO storage account.
# Storage Account Contributor (management plane) does NOT grant blob access.
resource "azurerm_role_assignment" "ai_services_blob_owner" {
  scope                = azurerm_storage_account.agent_byo.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_cognitive_account.ai_services.identity[0].principal_id
  description          = "AI Agent Service needs data plane access for file uploads"
}

# Grant the deployer Storage Blob Data Owner for validation testing
resource "azurerm_role_assignment" "deployer_blob_owner" {
  scope                = azurerm_storage_account.agent_byo.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
  description          = "Lab deployer access for validation testing"
}

# =========================================================================
# Key Vault (required for Foundry account)
# =========================================================================

# Key Vault for secrets management
resource "azurerm_key_vault" "lab" {
  name                = "kv-agent-byo-${random_string.suffix.result}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  # Enable RBAC authorization for Key Vault access
  rbac_authorization_enabled = true

  tags = local.common_tags
}

# =========================================================================
# Azure AI Search (for agent vector store)
# =========================================================================

# AI Search service for agent knowledge retrieval and vector storage
resource "azurerm_search_service" "lab" {
  name                = "srch-agent-byo-${random_string.suffix.result}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  sku = var.search_sku

  # Lab-friendly settings
  public_network_access_enabled = true
  local_authentication_enabled  = true

  tags = local.common_tags
}

# =========================================================================
# Azure Cosmos DB (for agent thread storage)
# =========================================================================

# Cosmos DB for storing agent conversations, threads, and metadata
resource "azurerm_cosmosdb_account" "lab" {
  name                = "cosmos-agent-byo-${random_string.suffix.result}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  offer_type = "Standard"
  kind       = "GlobalDocumentDB"

  # Serverless mode for lowest lab cost
  capabilities {
    name = "EnableServerless"
  }

  # Session consistency as required by Agent Service
  consistency_policy {
    consistency_level = "Session"
  }

  # Single region for lab
  geo_location {
    location          = azurerm_resource_group.lab.location
    failover_priority = 0
  }

  # Lab-friendly settings
  public_network_access_enabled = true

  tags = local.common_tags
}

# RBAC: Cosmos DB data plane access for AI Services managed identity
resource "azurerm_cosmosdb_sql_role_assignment" "ai_services_cosmos" {
  resource_group_name = azurerm_resource_group.lab.name
  account_name        = azurerm_cosmosdb_account.lab.name
  role_definition_id  = "${azurerm_cosmosdb_account.lab.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = azurerm_cognitive_account.ai_services.identity[0].principal_id
  scope               = azurerm_cosmosdb_account.lab.id
}
