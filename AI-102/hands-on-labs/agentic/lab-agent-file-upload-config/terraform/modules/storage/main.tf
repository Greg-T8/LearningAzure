# -------------------------------------------------------------------------
# Program: main.tf
# Description: Storage Account with agent containers and RBAC role assignments
# Context: AI-102 Lab - Agent Service file upload configuration
# Author: Greg Tate
# Date: 2026-02-14
# -------------------------------------------------------------------------

# Storage account for agent file uploads
resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Lab-friendly settings
  public_network_access_enabled = true

  tags = var.common_tags
}

# Agent file storage container (stores uploaded files and blob data)
resource "azurerm_storage_container" "agents_blobstore" {
  name               = "${var.workspace_id}-agents-blobstore"
  storage_account_id = azurerm_storage_account.this.id
}

# Azure ML blobstore container (stores intermediate system data: chunks, embeddings)
resource "azurerm_storage_container" "azureml_blobstore" {
  name               = "${var.workspace_id}-azureml-blobstore"
  storage_account_id = azurerm_storage_account.this.id
}

# Storage Account Contributor role on the storage account (management plane)
resource "azurerm_role_assignment" "storage_account_contributor" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.principal_id
}

# Storage Blob Data Owner on agents-blobstore container (data plane - CRITICAL)
# This role is REQUIRED for agent file uploads to succeed.
# Missing this role is one of the two correct answers in the exam question.
resource "azurerm_role_assignment" "blob_data_owner_agents" {
  scope                = "${azurerm_storage_account.this.id}/blobServices/default/containers/${azurerm_storage_container.agents_blobstore.name}"
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.principal_id
}

# Storage Blob Data Contributor on azureml-blobstore container (data plane)
resource "azurerm_role_assignment" "blob_data_contributor_azureml" {
  scope                = "${azurerm_storage_account.this.id}/blobServices/default/containers/${azurerm_storage_container.azureml_blobstore.name}"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.principal_id
}
