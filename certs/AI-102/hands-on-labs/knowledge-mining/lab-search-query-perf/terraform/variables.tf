# -------------------------------------------------------------------------
# Program: variables.tf
# Description: Input variables for Azure AI Search performance lab
# Context: AI-102 Lab - Improve Azure AI Search query performance with partitions
# Author: Greg Tate
# Date: 2026-02-11
# -------------------------------------------------------------------------

variable "lab_subscription_id" {
  description = "Azure subscription ID for lab deployments"
  type        = string
}

variable "exam" {
  description = "Certification exam code (lowercase)"
  type        = string
  default     = "ai102"

  validation {
    condition     = contains(["ai102", "az104"], var.exam)
    error_message = "Exam must be: ai102 or az104."
  }
}

variable "domain" {
  description = "Exam domain"
  type        = string
  default     = "knowledge-mining"

  validation {
    condition     = contains(["ai-services", "generative-ai", "computer-vision", "nlp", "knowledge-mining"], var.domain)
    error_message = "Domain must be a valid AI-102 domain."
  }
}

variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
  default     = "search-query-perf"
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "eastus"

  validation {
    condition     = contains(["eastus", "eastus2", "westus2"], var.location)
    error_message = "Location must be: eastus, eastus2, or westus2."
  }
}

variable "owner" {
  description = "Lab owner identifier"
  type        = string
  default     = "Greg Tate"
}

variable "date_created" {
  description = "Date the lab resources were created (YYYY-MM-DD format)"
  type        = string

  validation {
    condition     = can(regex("^\\d{4}-\\d{2}-\\d{2}$", var.date_created))
    error_message = "Date must be in YYYY-MM-DD format."
  }
}

variable "search_sku" {
  description = "Azure AI Search SKU (basic supports up to 3 partitions)"
  type        = string
  default     = "basic"

  validation {
    condition     = contains(["basic", "standard"], var.search_sku)
    error_message = "Search SKU must be basic or standard for partition scaling."
  }
}

variable "partition_count" {
  description = "Number of search partitions (split index for parallel query processing)"
  type        = number
  default     = 3

  validation {
    condition     = var.partition_count >= 1 && var.partition_count <= 3
    error_message = "Partition count must be between 1 and 3 for Basic SKU."
  }
}

variable "replica_count" {
  description = "Number of search replicas (for query throughput, not individual query speed)"
  type        = number
  default     = 3

  validation {
    condition     = var.replica_count >= 1 && var.replica_count <= 3
    error_message = "Replica count must be between 1 and 3 for Basic SKU."
  }
}
