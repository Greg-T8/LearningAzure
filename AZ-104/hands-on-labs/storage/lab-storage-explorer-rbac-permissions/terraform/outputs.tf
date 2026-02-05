# -------------------------------------------------------------------------
# Program: outputs.tf
# Description: Output values for Storage Explorer RBAC permissions lab
# Context: AZ-104 hands-on lab - Storage RBAC (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
# Subscription and Tenant Info
# -------------------------------------------------------------------------
output "tenant_id" {
  description = "Azure tenant ID for service principal authentication"
  value       = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  description = "Azure subscription ID"
  value       = data.azurerm_subscription.current.subscription_id
}

# -------------------------------------------------------------------------
# Resource Group Info
# -------------------------------------------------------------------------
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.lab.name
}

# -------------------------------------------------------------------------
# Storage Account Info
# -------------------------------------------------------------------------
output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.lab.name
}

output "storage_account_id" {
  description = "Resource ID of the storage account"
  value       = azurerm_storage_account.lab.id
}

output "container_name" {
  description = "Name of the blob container"
  value       = azurerm_storage_container.documents.name
}

output "file_share_name" {
  description = "Name of the file share"
  value       = azurerm_storage_share.reports.name
}

# -------------------------------------------------------------------------
# Service Principal 1: Data Reader Only (WILL FAIL to list containers)
# -------------------------------------------------------------------------
output "sp_data_reader_app_id" {
  description = "Application (client) ID for the data-reader-only service principal"
  value       = azuread_application.data_reader_only.client_id
}

output "sp_data_reader_password" {
  description = "Password for the data-reader-only service principal"
  value       = azuread_service_principal_password.data_reader_only.value
  sensitive   = true
}

output "sp_data_reader_object_id" {
  description = "Object ID for the data-reader-only service principal"
  value       = azuread_service_principal.data_reader_only.object_id
}

# -------------------------------------------------------------------------
# Service Principal 2: Data Contributor Only (WILL ALSO FAIL)
# -------------------------------------------------------------------------
output "sp_data_contributor_app_id" {
  description = "Application (client) ID for the data-contributor-only service principal"
  value       = azuread_application.data_contributor_only.client_id
}

output "sp_data_contributor_password" {
  description = "Password for the data-contributor-only service principal"
  value       = azuread_service_principal_password.data_contributor_only.value
  sensitive   = true
}

output "sp_data_contributor_object_id" {
  description = "Object ID for the data-contributor-only service principal"
  value       = azuread_service_principal.data_contributor_only.object_id
}

# -------------------------------------------------------------------------
# Service Principal 3: Reader + Data Reader (WILL SUCCEED)
# -------------------------------------------------------------------------
output "sp_both_roles_app_id" {
  description = "Application (client) ID for the reader-and-data-reader service principal"
  value       = azuread_application.both_roles.client_id
}

output "sp_both_roles_password" {
  description = "Password for the reader-and-data-reader service principal"
  value       = azuread_service_principal_password.both_roles.value
  sensitive   = true
}

output "sp_both_roles_object_id" {
  description = "Object ID for the reader-and-data-reader service principal"
  value       = azuread_service_principal.both_roles.object_id
}

# -------------------------------------------------------------------------
# Quick Test Commands
# -------------------------------------------------------------------------
output "test_commands" {
  description = "Commands to test the different service principals"
  value       = <<-EOT

    ═══════════════════════════════════════════════════════════════════════
    STORAGE EXPLORER RBAC PERMISSIONS LAB - TEST COMMANDS
    ═══════════════════════════════════════════════════════════════════════

    Storage Account: ${azurerm_storage_account.lab.name}
    Container: ${azurerm_storage_container.documents.name}
    File Share: ${azurerm_storage_share.reports.name}

    ───────────────────────────────────────────────────────────────────────
    TEST 1: Data Reader Only (EXPECTED TO FAIL listing containers)
    ───────────────────────────────────────────────────────────────────────

    # Login as data-reader-only service principal
    az login --service-principal -u "${azuread_application.data_reader_only.client_id}" -p "$(terraform output -raw sp_data_reader_password)" --tenant "${data.azurerm_client_config.current.tenant_id}"

    # Try to list containers (WILL FAIL - no management plane access)
    az storage container list --account-name ${azurerm_storage_account.lab.name} --auth-mode login

    # Try to read blob data directly (WILL SUCCEED - has data plane access)
    az storage blob list --account-name ${azurerm_storage_account.lab.name} --container-name ${azurerm_storage_container.documents.name} --auth-mode login

    ───────────────────────────────────────────────────────────────────────
    TEST 2: Reader + Data Reader (EXPECTED TO SUCCEED)
    ───────────────────────────────────────────────────────────────────────

    # Login as reader-and-data-reader service principal
    az login --service-principal -u "${azuread_application.both_roles.client_id}" -p "$(terraform output -raw sp_both_roles_password)" --tenant "${data.azurerm_client_config.current.tenant_id}"

    # List containers (WILL SUCCEED - has management plane access)
    az storage container list --account-name ${azurerm_storage_account.lab.name} --auth-mode login

    # Read blob data (WILL ALSO SUCCEED - has data plane access)
    az storage blob list --account-name ${azurerm_storage_account.lab.name} --container-name ${azurerm_storage_container.documents.name} --auth-mode login

    ───────────────────────────────────────────────────────────────────────
    CLEANUP: Return to your normal account
    ───────────────────────────────────────────────────────────────────────

    az login

  EOT
}
