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

- **[Azure Blob Versioning Write Operations](storage/lab-blob-versioning/README.md)** - This lab deploys a Storage Account with blob versioning enabled and provides a comprehensive testing script to valida...
- **[Azure CLI Copy Authentication Methods for Blob and File Storage](storage/lab-azcopy-auth-methods/README.md)** - This lab creates a destination storage account (DevStore) and two source storage accounts to demonstrate different au...
- **[Azure Storage Explorer Permission Troubleshooting](storage/lab-storage-explorer-permissions/README.md)** - This lab creates storage accounts with different configurations to demonstrate the permission issues:
- **[Configure Azure Storage Object Replication](storage/lab-object-replication/README.md)** - This lab creates two storage accounts in different Azure regions with object replication configured between them.
- **[Configure Blob Storage Lifecycle Management](storage/lab-blob-storage-lifecycle/README.md)** - This lab deploys a GPv2 storage account with blob versioning enabled and a lifecycle management policy that automates...

### Compute

- **[App Service Plan CPU Quotas](compute/lab-app-service-plan-quotas/README.md)** - This lab deploys an Azure App Service Plan on the **Free F1 tier** with a simple Web App to let you observe and explo...
- **[App Service Plan Tiers](compute/lab-app-service-plan-tiers/README.md)** - This lab deploys an Azure App Service Plan with a Web App and autoscale configuration to demonstrate the scaling capa...
- **[App Service Republication with Deployment Slots](compute/lab-app-service-republication/README.md)** - This lab uses Azure PowerShell commands to prepare an App Service environment with deployment slots for web app repub...
- **[Azure VM Disk Encryption with Key Vault](compute/lab-vm-disk-encryption/README.md)** - This lab deploys the infrastructure required to practice Azure Disk Encryption (ADE) with Key Vault:
- **[Configure KEDA Scaling Rule for Azure Container Apps](compute/lab-keda-scaling-rule/README.md)** - This lab deploys an Azure Container Apps environment with a container app that uses a KEDA-based custom scaling rule ...
- **[Enable Boot Diagnostics for Azure VMs](compute/lab-enable-boot-diagnostics/README.md)** - This lab deploys a multi-region environment with two virtual machines and three storage accounts to demonstrate Azure...
- **[VMSS Rolling Upgrade — Set-AzVmssVM](compute/lab-vmss-rolling-upgrade/README.md)** - This lab deploys a Virtual Machine Scale Set with a Rolling upgrade policy behind a Standard Load Balancer.

### Monitoring

- **[Azure Monitor Alert Notification Rate Limits](monitoring/lab-alert-notification-rate-limits/README.md)** - Hands-on lab
- **[Azure Monitor Metrics Batch API](monitoring/lab-metrics-batch-api/README.md)** - This lab deploys two Linux VMs in the same region and resource group.
- **[Capture SFTP Packets with Network Watcher](monitoring/lab-capture-sftp-packets/README.md)** - This lab deploys a virtual machine (VM01) within a virtual network, along with a diagnostic storage account, to demon...
- **[Recover Configuration File from Azure VM Backup](monitoring/lab-vm-file-recovery/README.md)** - This lab deploys a Windows Server 2019 VM backed up by an Azure Recovery Services vault.

### Identity & Governance

- No labs available.

### Networking

- **[Azure Private Link Service Network Policies](networking/lab-private-link-service/README.md)** - This lab deploys a complete Private Link Service environment that demonstrates how `privateLinkServiceNetworkPolicies...
- **[Configure Standard Load Balancer Outbound Traffic and IP Allocation](networking/lab-slb-outbound-traffic/README.md)** - This lab deploys a Standard Load Balancer environment that demonstrates how outbound traffic and IP allocation work w...
- **[Troubleshoot Internal Load Balancer Backend VM Access](networking/lab-ilb-backend-access/README.md)** - This lab deploys an Internal Load Balancer environment that demonstrates the **hairpin/loopback limitation** — a back...

---

## 📋 Governance & Standards

All labs in this repository are built following the comprehensive governance policy documented in [Governance-Lab.md](../../../.assets/shared/Governance-Lab.md). This ensures:

- **Consistent naming conventions** for resource groups and resources
- **Standardized tagging** across all deployments for tracking and cleanup
- **Cost management practices** including resource limits and auto-shutdown policies
- **Code quality standards** with proper header comments and structured code
- **Best practices** for infrastructure-as-code patterns in Terraform and Bicep

---
