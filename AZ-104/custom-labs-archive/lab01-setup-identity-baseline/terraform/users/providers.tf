terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
}

provider "azuread" {
  # Auth options include: Azure CLI login, Managed Identity, or Service Principal.
  # If using a Service Principal, set env vars:
  #   ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_TENANT_ID
  # Or log in first with: az login
}
