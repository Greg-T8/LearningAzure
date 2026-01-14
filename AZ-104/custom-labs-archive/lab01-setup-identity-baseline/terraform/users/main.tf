# -------------------------------------------------------------------------
# Program: main.tf
# Description: Creates Azure AD users from YAML configuration with secure passwords
# Context: AZ-104 lab - setup identity baseline (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------

locals {
  # Decode YAML into list(object)
  users = yamldecode(file("${path.module}/users.yaml"))

  # Convert list to map keyed by UPN
  users_by_upn = {
    for u in local.users : u.userPrincipalName => u
  }
}

# Generate one random password per user
resource "random_password" "user_pw" {
  for_each = local.users_by_upn

  # Configure password complexity requirements to meet Azure AD standards
  length           = 16
  override_special = "!@#$%&*()-_=+[]{}"
  special          = true
  numeric          = true
  lower            = true
  upper            = true

  #   Optional: keepers will force regeneration only when a keeper changes.
  #   Leave empty or include stable inputs (like each.key) to avoid accidental rotates.
  keepers = {
    version = "1" # Increment to force all passwords to regenerate
    upn     = each.key
  }
}

# Create Azure AD users based on the YAML configuration file
resource "azuread_user" "user" {
  for_each = local.users_by_upn

  # Set core user attributes from the configuration
  user_principal_name = each.value.userPrincipalName
  display_name        = each.value.displayName
  mail_nickname       = coalesce(each.value.mailNickname, replace(each.value.userPrincipalName, "@.*$", ""))

  # Set optional profile attributes if provided in the configuration
  given_name = try(each.value.givenName, null)
  surname    = try(each.value.surname, null)
  department = try(each.value.department, null)
  job_title  = try(each.value.jobTitle, null)

  # Set account settings with defaults where appropriate
  usage_location        = try(each.value.usageLocation, var.usage_location, "US")
  account_enabled       = true
  password              = random_password.user_pw[each.key].result
  force_password_change = try(each.value.forceChangePasswordNextSignIn, true)

  # Prevent Terraform from managing certain attribute changes after creation
  lifecycle {
    ignore_changes = [
      password,
      force_password_change,
      display_name,
      department,
      job_title,
      given_name,
      surname,
      usage_location
    ]
  }
}
