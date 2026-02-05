# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for alert notification rate limits lab
# Context: AZ-104 hands-on lab - Alert Notification Rate Limits (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
# Subscription Guard Variable
# -------------------------------------------------------------------------
variable "lab_subscription_id" {
  description = "Azure subscription ID for lab deployments (prevents wrong-subscription mistakes)"
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.lab_subscription_id))
    error_message = "lab_subscription_id must be a valid GUID format."
  }
}

# -------------------------------------------------------------------------
# Domain and Lab Configuration
# -------------------------------------------------------------------------
variable "domain" {
  description = "AZ-104 exam domain"
  type        = string
  default     = "monitoring"

  validation {
    condition     = contains(["identity", "networking", "storage", "compute", "monitoring"], var.domain)
    error_message = "Domain must be: identity, networking, storage, compute, or monitoring."
  }
}

variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
  default     = "alert-rate-limits"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "owner" {
  description = "Lab owner for tagging"
  type        = string
  default     = "Greg Tate"
}

# -------------------------------------------------------------------------
# Notification Configuration
# -------------------------------------------------------------------------
variable "email_address" {
  description = "Email address for alert notifications"
  type        = string
  default     = "alerts@example.com"

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email_address))
    error_message = "email_address must be a valid email format."
  }
}

variable "sms_country_code" {
  description = "Country code for SMS notifications (e.g., 1 for US)"
  type        = string
  default     = "1"
}

variable "sms_phone_number" {
  description = "Phone number for SMS notifications (without country code)"
  type        = string
  default     = "5551234567"

  validation {
    condition     = can(regex("^[0-9]{10,15}$", var.sms_phone_number))
    error_message = "sms_phone_number must be 10-15 digits."
  }
}

variable "voice_country_code" {
  description = "Country code for voice notifications (e.g., 1 for US)"
  type        = string
  default     = "1"
}

variable "voice_phone_number" {
  description = "Phone number for voice notifications (without country code)"
  type        = string
  default     = "5551234567"

  validation {
    condition     = can(regex("^[0-9]{10,15}$", var.voice_phone_number))
    error_message = "voice_phone_number must be 10-15 digits."
  }
}
