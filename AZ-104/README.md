# AZ-104: Microsoft Azure Administrator — Study Guide

**Objective:** Achieve the **AZ-104: Microsoft Azure Administrator** certification through a structured, multi-resource study approach.

---

## 🎯 Overview

This repository provides a **comprehensive study path** combining official Microsoft resources, video courses, hands-on labs, and practice exams.

### 📚 Learning Resource Priorities

| Priority | Resource | Purpose | Location |
|----------|----------|---------|----------|
| 1 | [Microsoft Learn Paths](./learning-paths/README.md) | Core concepts & knowledge | `learning-paths/` |
| 2 | [Microsoft GitHub Labs](./microsoft-labs/README.md) | Official hands-on practice | `microsoft-labs/` |
| 3 | [John Savill's Training](./video-courses/john-savill/README.md) | Visual reinforcement & deep dives | `video-courses/john-savill/` |
| 4 | [O'Reilly Courses](./video-courses/oreilly/README.md) | Alternative explanations | `video-courses/oreilly/` |
| 5 | [MeasureUp Practice Exams](./practice-exams/README.md) | Exam readiness assessment | `practice-exams/` |

### 🔄 Study Workflow Per Domain

1. **Learn** — Complete Microsoft Learn modules → take notes
2. **Practice** — Do official Microsoft GitHub lab
3. **Reinforce** — Watch video content for gaps
4. **Assess** — Practice exam questions for domain
5. **Review** — Update weak areas, refine notes

---

## 📊 Exam Domains and Consolidated Progress Tracker

| Domain | Weight | MS Learn | MS Labs | Video |
|--------|--------|----------|---------|-------|
| 1. Identities & Governance | 20-25% | 🕒 | 🕒 | 🕒 |
| 2. Storage | 15-20% | 🕒 | 🕒 | 🕒 |
| 3. Compute | 20-25% | 🕒 | 🕒 | 🕒 |
| 4. Networking | 15-20% | 🕒 | 🕒 | 🕒 |
| 5. Monitoring & Backup | 10-15% | 🕒 | 🕒 | 🕒 |

**Legend:** 🕒 Not Started | 🚧 In Progress | ✅ Complete

> Source: [Microsoft Official Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-104)


## 🧠 Additional Resources

| Resource | Link |
|----------|------|
| Exam Readiness Zone | [Microsoft Learn](https://learn.microsoft.com/en-us/shows/exam-readiness-zone/?terms=az-104) |
| Official Exam Guide | [Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-104) |
| Quick Reference | [Exam-Readiness.md](./Exam-Readiness.md) |
| Microsoft Labs (GitHub) | [AZ-104 Labs](https://github.com/MicrosoftLearning/AZ-104-MicrosoftAzureAdministrator) |
| John Savill Study Cram | [YouTube](https://youtu.be/0Knf9nub4-k) |

### Skill References

#### 1. Manage Azure identities and governance (20-25%)

- **Manage Microsoft Entra ID objects**
  - Create users and groups
    - Types of users
    - Default user permissions
    - Create users in bulk
  - Manage user and group properties
    - Restore a deleted user
  - Manage licenses in Microsoft Entra ID
    - Microsoft Entra Licensing
    - Group-based licensing limitations
  - Manage external users
  - Configure self-service password reset
- **Manage access to Azure resources**
  - Manage built-in Azure roles
  - Assign roles at different scopes
  - Interpret access assignments
- **Manage Azure subscriptions and governance**
  - Configure and manage Azure Policy
  - Configure resource locks
  - Apply and manage tags on resources
  - Manage resource groups
  - Manage subscriptions
  - Manage costs using alerts, budgets, and recommendations
  - Configure management groups

#### 2. Implement and manage storage (15-20%)

- **Configure access to storage**
  - Configure network access to storage
  - Configure private endpoints for Azure Storage
  - Create and implement shared access signatures
  - Configure stored access policies
- **Configure and manage storage accounts**
  - Create and configure storage accounts
  - Configure Azure Storage redundancy
  - Configure object replication
  - Configure storage account encryption
  - Configure Azure Blob Storage
  - Configure soft delete for Azure Blob Storage
  - Configure lifecycle management for Azure Blob Storage
  - Configure Azure Files for storage
  - Configure Azure Files for access

#### 3. Deploy and manage Azure compute resources (20-25%)

- **Automate deployment using templates**
  - Create and save Azure Resource Manager templates (ARM templates) and Azure Bicep templates
  - Deploy virtual machines (VMs) and Azure container instances by using ARM templates and Bicep templates
  - Modify existing templates
- **Create and configure VMs**
  - Configure VM sizes and VM availability
  - Deploy VMs to availability zones and availability sets
  - Deploy and configure scale sets
  - Configure Azure Disk Encryption
  - Move VMs from one resource group to another
  - Manage VM sizes
  - Add data disks
  - Configure networking
  - Configure VM extensions
- **Provision and manage containers**
  - Create and manage Azure container registry
  - Create and manage Azure container instances
- **Create and configure Azure App Service**
  - Create and configure an App Service plan
  - Configure scaling settings in an App Service plan
  - Create and manage App Service environments
  - Create and deploy an App Service web app
  - Configure web app settings including SSL, API settings, and connection strings
  - Configure deployment slots

#### 4. Implement and manage virtual networking (15-20%)

- **Configure secure access to virtual networks**
  - Create and configure network security groups (NSGs) and application security groups (ASGs)
  - Configure Azure Bastion
  - Configure private endpoints
  - Configure Azure DNS
  - Configure service endpoints on subnets
  - Configure Azure Firewall
  - Configure user-defined routes
- **Configure Azure Virtual Network**
  - Create and configure virtual networks and subnets
  - Create and configure virtual network peering
  - Configure public IP addresses
  - Configure private IP addresses
- **Configure Azure Load Balancer**
  - Configure Azure Load Balancer
  - Configure public and internal load balancers
  - Configure load balancing rules
- **Configure Azure Application Gateway**
  - Configure Azure Application Gateway
  - Configure SSL termination
  - Configure web application firewall (WAF) on Azure Application Gateway
  - Configure Azure Front Door

#### 5. Monitor and maintain Azure resources (10-15%)

- **Monitor resources by using Azure Monitor**
  - Configure and interpret metrics
  - Configure Azure Monitor logs
  - Configure diagnostic settings
  - Configure and interpret Application Insights
  - Configure and manage log alerts, metric alerts, and service health alerts
- **Implement backup and recovery**
  - Create a Recovery Services vault
  - Create and configure backup policy
  - Perform backup and restore operations by using Azure Backup
  - Configure Azure Site Recovery for Azure VMs
  - Configure and review backup reports