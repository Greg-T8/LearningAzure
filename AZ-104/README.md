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

> 📝 **Take notes at every step** — capture key concepts, commands, and pitfalls.

1. **Learn** — Complete Microsoft Learn modules
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

---

## 📘 Domain Quick Reference

### Domain 1: Manage Azure Identities and Governance (20–25%)

**Key Topics**

- Create and manage users, groups, and administrative units
- Configure and manage license assignments (Free, P1, P2)
- Manage external users (guest accounts, B2B collaboration)
- Configure self-service password reset (SSPR)
- Implement RBAC: built-in roles, custom roles, scope inheritance
- Implement Azure Policy: definitions, initiatives, remediation
- Configure resource locks: **CanNotDelete** and **ReadOnly**
- Manage resource tagging and management groups

**Common Pitfalls**

- Resource groups cannot be nested
- Scope inheritance cannot be broken
- Policy definitions (individual) vs. initiatives (grouped)
- P1 vs P2 feature sets in Entra ID
- Azure AD roles needed to manage licenses, not just RBAC roles

---

### Domain 2: Implement and Manage Storage (15–20%)

**Key Topics**

- Create and configure storage accounts
- Configure redundancy (LRS, ZRS, GRS, RA-GRS, GZRS)
- Configure Azure Storage firewalls and VNets
- Configure and use SAS tokens and stored access policies
- Configure Azure Files identity-based access (Entra ID, AD DS)
- Configure object replication and encryption
- Manage data using AzCopy and Storage Explorer
- Configure lifecycle management, soft delete, snapshots, versioning

**Common Pitfalls**

- SAS tokens can only be revoked via stored access policy
- Misconfiguring network rules that block access unintentionally
- Confusing Azure File Sync with Azure Files share identity integration

---

### Domain 3: Deploy and Manage Azure Compute Resources (20–25%)

**Key Topics**

- Create and configure VMs (size, disks, images)
- Configure VM availability (sets, zones)
- Configure and manage VM extensions
- Automate deployment using ARM/Bicep/Terraform
- Create and manage VM Scale Sets
- Manage Azure Container Instances and Azure Container Apps
- Configure and manage App Services and Web Apps
- Manage VM moving between subscriptions and regions

**Common Pitfalls**

- Availability sets (within datacenter) vs. zones (across datacenters)
- Forgetting to update NSG rules when using custom VMs
- Not linking diagnostic settings for boot diagnostics

---

### Domain 4: Implement and Manage Virtual Networking (15–20%)

**Key Topics**

- Create and configure VNets, subnets, and peering
- Configure public/private IPs and user-defined routes (UDR)
- Configure NSGs and Application Security Groups (ASGs)
- Configure Bastion, Private Link, and Private Endpoints
- Configure Azure DNS zones (public/private)
- Configure VPN Gateway, ExpressRoute, and Virtual WAN
- Configure Load Balancer, Application Gateway, Front Door, Traffic Manager

**Common Pitfalls**

- NSG rules are stateful
- Forgetting to disable private endpoint network policies
- Confusing service endpoints vs. private endpoints

---

### Domain 5: Monitor and Maintain Azure Resources (10–15%)

**Key Topics**

- Configure diagnostic settings and Azure Monitor
- Query and analyze data in Log Analytics
- Create and manage alerts and action groups
- Configure and interpret metrics and workbooks
- Implement Azure Backup and Recovery Services Vault
- Perform restore operations
- Monitor cost and resource utilization

**Common Pitfalls**

- Forgetting to connect resources to a Log Analytics workspace
- Overlooking monitoring inheritance (diagnostic settings per resource)
- Not validating recovery jobs after backup configuration

---

## 🧾 Final Review Checklist

- [ ] Know the difference between Entra ID and RBAC roles
- [ ] Practice assigning roles at different scopes
- [ ] Deploy and lock resources using Azure Policy
- [ ] Understand redundancy models (LRS → GZRS)
- [ ] Deploy a VM with diagnostics and backup enabled
- [ ] Implement a load balancer + NSG combo
- [ ] Set up Azure Monitor and send logs to Log Analytics
- [ ] Configure a recovery vault and restore a VM
- [ ] Review Advisor recommendations and budgets
