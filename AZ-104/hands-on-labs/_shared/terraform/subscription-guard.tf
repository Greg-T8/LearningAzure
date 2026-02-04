# -------------------------------------------------------------------------
# Program: subscription-guard.tf
# Description: Validates deployment target before creating any resources
# Context: AZ-104 hands-on labs - Terraform shared configuration
# Author: Greg Tate
# -------------------------------------------------------------------------
#
# USAGE: Copy this file to your lab's terraform/ folder to add fail-fast
#        subscription validation.
#
# This creates a precondition that will cause Terraform to fail immediately
# if the active subscription doesn't match the expected lab subscription.
# -------------------------------------------------------------------------

# Fetch current subscription context
data "azurerm_subscription" "current" {}

# Configuration - REPLACE with your lab subscription details
locals {
  # Your lab subscription ID (REPLACE THIS)
  allowed_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"

  # Your lab subscription name (for display in error messages)
  allowed_subscription_name = "sub-gtate-mpn-lab"
}

# Validation resource - fails fast with clear error message
resource "terraform_data" "subscription_guard" {
  lifecycle {
    precondition {
      condition     = data.azurerm_subscription.current.subscription_id == local.allowed_subscription_id
      error_message = <<-EOT

        ╔══════════════════════════════════════════════════════════════════╗
        ║  ⛔ DEPLOYMENT BLOCKED - WRONG SUBSCRIPTION DETECTED             ║
        ╠══════════════════════════════════════════════════════════════════╣
        ║  Current:  ${data.azurerm_subscription.current.display_name}
        ║  Expected: ${local.allowed_subscription_name}
        ╠══════════════════════════════════════════════════════════════════╣
        ║  To fix: az account set --subscription "${local.allowed_subscription_id}"
        ╚══════════════════════════════════════════════════════════════════╝

      EOT
    }
  }
}
