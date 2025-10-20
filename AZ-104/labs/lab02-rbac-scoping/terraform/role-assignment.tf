terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

# Data sources
data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "dev" {
  name = "rg-dev-test"
}

data "azuread_user" "dev_user" {
  user_principal_name = "user3@637djb.onmicrosoft.com"
}

# Role assignment at resource group scope
resource "azurerm_role_assignment" "dev_contributor" {
  scope                = data.azurerm_resource_group.dev.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_user.dev_user.object_id
}

# Role assignment at subscription scope
resource "azurerm_role_assignment" "subscription_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = data.azuread_user.dev_user.object_id
}

output "role_assignment_id" {
  value = azurerm_role_assignment.dev_contributor.id
}
