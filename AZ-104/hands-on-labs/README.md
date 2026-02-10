# AZ-104 Hands-On Labs

This page catalogs hands-on labs built from practice exam questions. Each lab uses Terraform or Azure Bicep to create dedicated environments for testing specific AZ-104 concepts.

* [📦 Storage Labs](#-storage-labs)
  * [Configure Azure Storage Object Replication](#configure-azure-storage-object-replication)
  * [Azure Storage Explorer Permission Troubleshooting](#azure-storage-explorer-permission-troubleshooting)
  * [Azure CLI Copy Authentication Methods for Blob and File Storage](#azure-cli-copy-authentication-methods-for-blob-and-file-storage)
* [💻 Compute Labs](#-compute-labs)
  * [App Service Pricing Tiers](#app-service-pricing-tiers)
* [📊 Monitoring Labs](#-monitoring-labs)
  * [Azure Monitor Alert Notification Rate Limits](#azure-monitor-alert-notification-rate-limits)
* [📈 Lab Statistics](#-lab-statistics)

---

## 📦 Storage Labs

### [Configure Azure Storage Object Replication](storage/lab-object-replication/README.md)

Understanding blob versioning and change feed prerequisites for object replication between storage accounts across regions.

### [Azure Storage Explorer Permission Troubleshooting](storage/lab-storage-explorer-permissions/README.md)

Diagnosing and resolving permission issues when users cannot browse storage account contents using Azure Storage Explorer. Covers resource locks and RBAC roles.

### [Azure CLI Copy Authentication Methods for Blob and File Storage](storage/lab-azcopy-auth-methods/README.md)

Comparing authentication method support (Azure AD, Access Keys, SAS) differences between Blob Storage and File Storage when using Azure CLI copy commands.

---

## 💻 Compute Labs

### [App Service Pricing Tiers](compute/lab-app-service-tiers/README.md)

Testing CPU time limits across Free, Shared, and Basic App Service tiers to understand runtime restrictions and cost trade-offs.

---

## 📊 Monitoring Labs

### [Azure Monitor Alert Notification Rate Limits](monitoring/lab-alert-notification-rate-limits/README.md)

Understanding rate limiting behavior for email, voice, and SMS notifications in Azure Monitor action groups.

---

## 📈 Lab Statistics

- **Total Labs**: 5
- **Storage**: 3
- **Compute**: 1
- **Monitoring**: 1
- **Identity & Governance**: 0
- **Networking**: 0

---

*Last updated: February 10, 2026*
