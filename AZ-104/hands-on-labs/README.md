# AZ-104 Hands-On Labs

This page catalogs hands-on labs built from practice exam questions. Each lab uses Terraform or Azure Bicep to create dedicated environments for testing specific AZ-104 concepts.

---

## 📊 Lab Statistics

- **Total Labs**: 17
- **Storage**: 4
- **Compute**: 5
- **Monitoring**: 4
- **Identity & Governance**: 1
- **Networking**: 3

---

## 🧪 Labs

### Storage

- **[Azure Storage Account - Secure Access](storage/lab-secure-access/README.md)** - Configure secure access to Azure Storage Accounts using private endpoints and firewall rules
- **[Azure Storage Account - Lifecycle Management](storage/lab-lifecycle-management/README.md)** - Implement lifecycle management policies for Azure Blob Storage
- **[Azure Storage Account - Static Website Hosting](storage/lab-static-website/README.md)** - Host a static website using Azure Blob Storage
- **[Azure Storage Account - Data Replication](storage/lab-data-replication/README.md)** - Explore data replication options in Azure Storage

### Compute

- **[Azure Virtual Machines - High Availability](compute/lab-vm-ha/README.md)** - Deploy and configure highly available virtual machines in Azure
- **[Azure Virtual Machines - Scale Sets](compute/lab-vmss/README.md)** - Implement virtual machine scale sets for auto-scaling workloads
- **[Azure App Service - Deployment Slots](compute/lab-app-service-slots/README.md)** - Use deployment slots for zero-downtime deployments
- **[Azure Kubernetes Service - Basics](compute/lab-aks-basics/README.md)** - Deploy and manage a basic AKS cluster
- **[Azure Kubernetes Service - Advanced Networking](compute/lab-aks-networking/README.md)** - Configure advanced networking for AKS clusters

### Monitoring

- **[Azure Monitor - Alerts and Metrics](monitoring/lab-alerts-metrics/README.md)** - Set up alerts and monitor metrics for Azure resources
- **[Azure Monitor - Log Analytics](monitoring/lab-log-analytics/README.md)** - Use Log Analytics to query and analyze logs
- **[Azure Monitor - Application Insights](monitoring/lab-app-insights/README.md)** - Monitor application performance with Application Insights
- **[Azure Monitor - Network Watcher](monitoring/lab-network-watcher/README.md)** - Diagnose and monitor network issues with Network Watcher

### Identity & Governance

- **[Azure AD - Identity Protection](identity-governance/lab-identity-protection/README.md)** - Implement identity protection policies in Azure AD

### Networking

- **[Azure Virtual Network - Peering](networking/lab-vnet-peering/README.md)** - Configure virtual network peering between Azure VNets
- **[Azure Load Balancer - Traffic Distribution](networking/lab-load-balancer/README.md)** - Distribute traffic using Azure Load Balancer
- **[Azure Firewall - Secure Traffic](networking/lab-firewall/README.md)** - Secure traffic with Azure Firewall

---

## 📋 Governance & Standards

All labs in this repository are built following the comprehensive governance policy documented in [Governance-Lab.md](../../Governance-Lab.md). This ensures:

- **Consistent naming conventions** for resource groups and resources
- **Standardized tagging** across all deployments for tracking and cleanup
- **Cost management practices** including resource limits and auto-shutdown policies
- **Code quality standards** with proper header comments and structured code
- **Best practices** for infrastructure-as-code patterns in Terraform and Bicep

---
