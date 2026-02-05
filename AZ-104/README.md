# AZ-104: Microsoft Azure Administrator — Study Guide

**Objective:** Achieve the **AZ-104: Microsoft Azure Administrator** certification using a structured, multi-resource study approach.

- **Certification Page:** [AZ-104: Microsoft Azure Administrator](https://learn.microsoft.com/en-us/credentials/certifications/azure-administrator/?practice-assessment-type=certification#certification-prepare-for-the-exam)
- **Official Study Guide:** [AZ-104 Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-104)

---

### 📚 Learning Modality Progress Tracker

| Priority | Modality         | My Notes                                                        | Status | Started | Completed | Days |
| :------- | :--------------- | :-------------------------------------------------------------- | :----- | :------ | :-------- | :--- |
| 1        | Microsoft Learn | [Microsoft Learning Paths](./learning-paths/README.md)          | ✅     | 1/14/26 | 1/25/26   | 11   |
| 2        | Video            | [John Savill's Training](./video-courses/savill/README.md) | ✅    | 1/29/26 | 2/1/26          | 4      |
| 3        | Assessment Exam  | [Assessment Exam](./practice-exams/README.md)                  | 🚧    | 2/2/26        |           |      |
| 4        | Hands-on Labs    | [Hands-on Labs](./hands-on-labs/README.md)             | 🕒    |         |           |      |
| 5        | Practice Exams   | [MeasureUp Practice Exams](./practice-exams/README.md)          | 🕒    |         |           |      |

**Legend:** 🕒 Not Started | 🚧 In Progress | ✅ Complete

---
## 📊 Exam Domains

| Domain                     | Weight |
| :------------------------- | :----- |
| 1. Identities & Governance | 20-25% |
| 2. Storage                 | 15-20% |
| 3. Compute                 | 20-25% |
| 4. Networking              | 15-20% |
| 5. Monitoring & Backup     | 10-15% |

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
