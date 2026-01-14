# -------------------------------------------------------------------------
# Program: main.tf (Microsoft 365 Group)
# Description: Terraform configuration to create a Microsoft 365 (Unified) group
# Context: AZ-104 lab - setup identity baseline (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------

// Configure Terraform and required providers for Azure AD
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      # Version pin to a recent provider supporting Unified groups
      version = ">= 2.48.0"
    }
  }
}

// Initialize the Azure AD provider (authentication via Azure CLI/Environment by default)
provider "azuread" {}

// Input: Display name for the Microsoft 365 group
variable "display_name" {
  type        = string
  description = "Display name of the Microsoft 365 group."
}

// Input: Optional mail alias (nickname) override; auto-derived from display_name when not provided
variable "mail_nickname" {
  type        = string
  default     = null
  description = "Optional. Mail alias (nickname) for the Microsoft 365 group. If null/blank, it is derived from display_name by removing invalid characters and lowercasing."
}

// Input: Optional description for the Microsoft 365 group
variable "description" {
  type        = string
  default     = ""
  description = "Optional description for the group."
}

// Input: Group visibility with validation (Private, Public, HiddenMembership)
variable "visibility" {
  type        = string
  default     = "Private"
  description = "Group visibility: Private, Public, or HiddenMembership (Unified groups only)."

  validation {
    condition     = contains(["Private", "Public", "HiddenMembership"], var.visibility)
    error_message = "visibility must be one of: Private, Public, HiddenMembership."
  }
}

# New: list of users to add as group members (by UPN)
variable "member_user_principal_names" {
  type        = list(string)
  default     = []
  description = "List of user principal names (UPNs) to add as members to the group."
}

// Derive an effective mail_nickname from display_name when not explicitly set
locals {
  // Remove characters not allowed by mailNickname policy and lowercase it
  // Use regexall to select only allowed characters, then join them back together
  nickname_from_display   = lower(join("", regexall("[0-9A-Za-z._-]", var.display_name)))
}

# Create a Microsoft 365 (Unified) group
resource "azuread_group" "m365_group" {
  display_name     = var.display_name
  description      = var.description
  mail_enabled     = true
  mail_nickname    = local.nickname_from_display
  security_enabled = false
  types            = ["Unified"]
  visibility       = var.visibility
}

# Resolve each UPN to a user object
data "azuread_user" "members" {
  for_each             = toset(var.member_user_principal_names)
  user_principal_name  = each.value
}

# Add each user as a member of the group
resource "azuread_group_member" "members" {
  for_each        = data.azuread_user.members
  group_object_id = azuread_group.m365_group.id
  member_object_id = each.value.id
}

// Output: Object ID of the created Microsoft 365 group
output "group_id" {
  value       = azuread_group.m365_group.id
  description = "The object ID of the created Microsoft 365 group."
}

// Output: Primary SMTP address of the created Microsoft 365 group
output "group_mail" {
  value       = azuread_group.m365_group.mail
  description = "The primary SMTP address of the created Microsoft 365 group."
}
