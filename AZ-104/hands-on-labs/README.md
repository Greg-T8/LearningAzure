# AZ-104 Hands-On Labs

This page catalogs hands-on labs built from practice exam questions. Each lab uses Terraform or Azure Bicep to create dedicated environments for testing specific AZ-104 concepts.

---

## 📊 Lab Statistics

- **Total Labs**: 19
- **Storage**: 5
- **Compute**: 7
- **Monitoring**: 4
- **Identity & Governance**: 0
- **Networking**: 3

---

## 🧪 Labs

### Storage

- **[Azure Storage - AzCopy Auth Methods](storage/lab-azcopy-auth-methods/README.md)** - Explore authentication methods for AzCopy
- **[Azure Storage - Blob Storage Lifecycle](storage/lab-blob-storage-lifecycle/README.md)** - Implement lifecycle management policies for Azure Blob Storage
- **[Azure Storage - Blob Versioning](storage/lab-blob-versioning/README.md)** - Enable and manage blob versioning
- **[Azure Storage - Object Replication](storage/lab-object-replication/README.md)** - Configure object replication across storage accounts
- **[Azure Storage - Explorer Permissions](storage/lab-storage-explorer-permissions/README.md)** - Manage permissions using Azure Storage Explorer

### Compute

- **[App Service - Plan Quotas](compute/lab-app-service-plan-quotas/README.md)** - Configure quotas for Azure App Service plans
- **[App Service - Plan Tiers](compute/lab-app-service-plan-tiers/README.md)** - Explore Azure App Service plan tiers
- **[App Service - Republishing](compute/lab-app-service-republication/README.md)** - Republishing apps in Azure App Service
- **[Enable Boot Diagnostics](compute/lab-enable-boot-diagnostics/README.md)** - Enable and configure boot diagnostics for VMs
- **[KEDA Scaling Rule](compute/lab-keda-scaling-rule/README.md)** - Implement KEDA scaling rules for event-driven workloads
- **[VM Disk Encryption](compute/lab-vm-disk-encryption/README.md)** - Encrypt disks for Azure Virtual Machines
- **[VMSS Rolling Upgrade](compute/lab-vmss-rolling-upgrade/README.md)** - Perform rolling upgrades on Virtual Machine Scale Sets

### Monitoring

- **[Alert Notification Rate Limits](monitoring/lab-alert-notification-rate-limits/README.md)** - Configure rate limits for alert notifications
- **[Capture SFTP Packets](monitoring/lab-capture-sftp-packets/README.md)** - Monitor and capture SFTP traffic
- **[Metrics Batch API](monitoring/lab-metrics-batch-api/README.md)** - Use the Metrics Batch API for monitoring
- **[VM File Recovery](monitoring/lab-vm-file-recovery/README.md)** - Recover files from Azure Virtual Machines

### Networking

- **[ILB Backend Access](networking/lab-ilb-backend-access/README.md)** - Configure backend access for Internal Load Balancers
- **[Private Link Service](networking/lab-private-link-service/README.md)** - Implement Private Link Service for secure connectivity
- **[SLB Outbound Traffic](networking/lab-slb-outbound-traffic/README.md)** - Manage outbound traffic using Standard Load Balancer

### Identity & Governance

- No labs available.

---

## 📋 Governance & Standards

All labs in this repository are built following the comprehensive governance policy documented in [Governance-Lab.md](../../.assets/shared/Governance-Lab.md). This ensures:

- **Consistent naming conventions** for resource groups and resources
- **Standardized tagging** across all deployments for tracking and cleanup
- **Cost management practices** including resource limits and auto-shutdown policies
- **Code quality standards** with proper header comments and structured code
- **Best practices** for infrastructure-as-code patterns in Terraform and Bicep

---
