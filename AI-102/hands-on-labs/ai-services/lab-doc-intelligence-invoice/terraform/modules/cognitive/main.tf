# -------------------------------------------------------------------------
# Program: main.tf
# Description: Azure AI Document Intelligence (Form Recognizer) resource
# Context: AI-102 Lab - Document Intelligence Invoice Model
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

# Deploy the Document Intelligence cognitive account
resource "azurerm_cognitive_account" "doc_intelligence" {
  name                  = "cog-doc-invoice-${var.random_suffix}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = "FormRecognizer"
  sku_name              = "F0"
  custom_subdomain_name = "cog-doc-invoice-${var.random_suffix}"

  public_network_access_enabled = true

  tags = var.tags
}
