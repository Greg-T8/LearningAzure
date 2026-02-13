# AZ-104 Hands-On Labs

This page catalogs hands-on labs built from practice exam questions. Each lab uses Terraform or Azure Bicep to create dedicated environments for testing specific AZ-104 concepts.

---

## 📈 Lab Statistics

- **Total Labs**: 9
- **Storage**: 4
- **Compute**: 3
- **Monitoring**: 1
- **Identity & Governance**: 0
- **Networking**: 1

---

## 🧪 Labs

### Storage

- **[Azure Blob Versioning Write Operations](storage/lab-blob-versioning/README.md)** - Identify which blob write operations create new versions when versioning is enabled
- **[Azure CLI Copy Authentication Methods for Blob and File Storage](storage/lab-azcopy-auth-methods/README.md)** - Test authentication method differences between blob and file storage for AzCopy operations
- **[Azure Storage Explorer Permission Troubleshooting](storage/lab-storage-explorer-permissions/README.md)** - Diagnose and resolve permission issues when accessing storage accounts through Storage Explorer
- **[Configure Azure Storage Object Replication](storage/lab-object-replication/README.md)** - Configure blob versioning and change feed to support cross-region object replication

### Compute

- **[App Service Plan CPU Quotas](compute/lab-app-service-plan-quotas/README.md)** - Understand CPU quota limitations of Free and Shared tiers and learn why Basic B1 is the minimum tier that removes daily CPU quotas
- **[App Service Plan Tiers](compute/lab-app-service-plan-tiers/README.md)** - Explore App Service pricing tier capabilities, scaling limits, and choose the right tier for specific requirements
- **[App Service Republication with Deployment Slots](compute/lab-app-service-republication/README.md)** - Use deployment slots to enable test users to review the web app before it reaches production

### Monitoring

- **[Azure Monitor Alert Notification Rate Limits](monitoring/lab-alert-notification-rate-limits/README.md)** - Understand notification rate limits for email, SMS, and voice alerts in Azure Monitor action groups

### Networking

- **[Configure Standard Load Balancer Outbound Traffic and IP Allocation](networking/lab-slb-outbound-traffic/README.md)** - Learn how outbound traffic and IP allocation work with Azure Standard Load Balancers including TCP/UDP protocol rules

---

## 📋 Governance & Standards

All labs in this repository are built following the comprehensive governance policy documented in [GOVERNANCE.md](../../GOVERNANCE.md). This ensures:

- **Consistent naming conventions** for resource groups and resources
- **Standardized tagging** across all deployments for tracking and cleanup
- **Cost management practices** including resource limits and auto-shutdown policies
- **Code quality standards** with proper header comments and structured code
- **Best practices** for infrastructure-as-code patterns in Terraform and Bicep

---
