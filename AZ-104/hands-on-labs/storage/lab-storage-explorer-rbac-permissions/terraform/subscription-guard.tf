# -------------------------------------------------------------------------
# Program: subscription-guard.tf
# Description: Validates deployment target before creating any resources
# Context: AZ-104 hands-on lab - Storage RBAC (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------

# Validation resource - fails fast with clear error message
# Note: data.azurerm_subscription.current is defined in main.tf
resource "terraform_data" "subscription_guard" {
  lifecycle {
    precondition {
      condition     = data.azurerm_subscription.current.subscription_id == var.lab_subscription_id
      error_message = <<-EOT

        ╔══════════════════════════════════════════════════════════════════╗
        ║  ⛔ DEPLOYMENT BLOCKED - WRONG SUBSCRIPTION DETECTED             ║
        ╠══════════════════════════════════════════════════════════════════╣
        ║  Current:  ${data.azurerm_subscription.current.display_name}
        ║  Expected: ${var.lab_subscription_id}
        ╠══════════════════════════════════════════════════════════════════╣
        ║  To fix: az account set --subscription "${var.lab_subscription_id}"
        ╚══════════════════════════════════════════════════════════════════╝

      EOT
    }
  }
}
