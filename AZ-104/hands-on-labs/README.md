# AZ-104 Hands-On Labs

This page catalogs hands-on labs built from practice exam questions. Each lab uses Terraform or Azure Bicep to create dedicated environments for testing specific AZ-104 concepts.

---

## 📊 Lab Statistics

- **Total Labs**: 15
- **Storage**: 4
- **Compute**: 5
- **Monitoring**: 3
- **Identity & Governance**: 0
- **Networking**: 3

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
- **[Azure VM Disk Encryption with Key Vault](compute/lab-vm-disk-encryption/README.md)** - Encrypt VM disks using Azure Key Vault and PowerShell
- **[VMSS Rolling Upgrade - Update-AzVmss](compute/lab-vmss-rolling-upgrade/README.md)** - Demonstrate rolling upgrade policies for VM scale sets

### Monitoring

- **[Azure Monitor Alert Notification Rate Limits](monitoring/lab-alert-notification-rate-limits/README.md)** - Understand notification rate limits for email, SMS, and voice alerts in Azure Monitor action groups
- **[Azure Monitor Metrics - Batch API and Aggregations](monitoring/lab-metrics-batch-api/README.md)** - Query multiple metrics using the Azure Monitor Metrics batch API with aggregations
- **[Recover Configuration File from Azure VM Backup](monitoring/lab-vm-file-recovery/README.md)** - Practice file-level recovery from Azure VM backup using Recovery Services vault

### Networking

- **[Configure Standard Load Balancer Outbound Traffic and IP Allocation](networking/lab-slb-outbound-traffic/README.md)** - Learn how outbound traffic and IP allocation work with Azure Standard Load Balancers including TCP/UDP protocol rules
- **[Configure Internal Load Balancer Backend Access](networking/lab-ilb-backend-access/README.md)** - Configure backend access for internal load balancers
- **[Configure VNet Peering](networking/lab-vnet-peering/README.md)** - Set up VNet peering to enable communication between virtual networks

---

## 📋 Governance & Standards

All labs in this repository are built following the comprehensive governance policy documented in [Governance-Lab.md](../../Governance-Lab.md). This ensures:

- **Consistent naming conventions** for resource groups and resources
- **Standardized tagging** across all deployments for tracking and cleanup
- **Cost management practices** including resource limits and auto-shutdown policies
- **Code quality standards** with proper header comments and structured code
- **Best practices** for infrastructure-as-code patterns in Terraform and Bicep

---
