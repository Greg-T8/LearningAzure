# AZ-104: Microsoft Azure Administrator — Hands-On Lab Series

**Objective:** Gain real-world, exam-aligned proficiency for the **AZ-104: Microsoft Azure Administrator** certification through a sequence of medium-to-hard, scenario-driven labs.

---

## 🎯 Overview

This repository provides a **structured, hands-on learning path** mapped directly to Microsoft’s official **AZ-104** objectives.

Each lab:

- Maps to an **official exam subskill**
- Integrates multiple **deployment modalities** (Portal, CLI, PowerShell, Bicep, Terraform)
- Intentionally requires referencing **Microsoft documentation**
- Reinforces **governance, automation, and troubleshooting**

Average lab duration: **1.5–2 hours**

---

## 📘 Exam Domains

| Domain                                       | Weight |
| -------------------------------------------- | ------ |
| 1. Manage Azure identities and governance    | 20–25% |
| 2. Implement and manage storage              | 15–20% |
| 3. Deploy and manage Azure compute resources | 20–25% |
| 4. Implement and manage virtual networking   | 15–20% |
| 5. Monitor and maintain Azure resources      | 10–15% |

> Source: [Microsoft Official Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-104)

---

## 🧭 Learning Approach

- **Hands-on:** Every lab deploys and validates live Azure resources.  
- **Multi-modal:** Work through each scenario using Portal, CLI, PowerShell, and IaC (Bicep/Terraform).  
- **Exam-driven:** Fully aligned to the “Skills Measured” outline.  
- **Documentation-first:** Some parameters are intentionally omitted to encourage doc lookup.  
- **Scenario-based:** Assume the role of an Azure administrator responding to operational challenges.

---

## 🗓 8-Week Lab Roadmap

| Phase | Week    | Focus Area                                | Labs                                                                                                                                                                                                             |
| ----- | ------- | ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **A** | **1–2** | 🧠 **Identity & Governance Foundations** | [Lab 1 – Setup and Identity Baseline](./labs/lab01-setup-identity-baseline/Lab01_Setup-Identity-Baseline.md) <br>Lab 2 – RBAC and Scoping <br>Lab 3 – Policy & Resource Locks <br>Lab 4 – Subscription & Budgets |
| **B** | **3**   | 💾 **Storage and Data Management**       | Lab 5 – Secure Azure Storage Accounts <br>Lab 6 – Azure Files & Blob Management                                                                                                                                  |
| **C** | **4–5** | ☁️ **Compute and Automation**           | Lab 7 – Infrastructure as Code (Bicep & Terraform) <br>Lab 8 – Virtual Machines & Disks <br>Lab 9 – Scale Sets & Containers <br>Lab 10 – App Services & Web Apps                                                 |
| **D** | **6–7** | 🌐 **Networking & Hybrid Connectivity**  | Lab 11 – Virtual Networks & Routing <br>Lab 12 – Network Security & Private Access <br>Lab 13 – VPN, ExpressRoute, Virtual WAN <br>Lab 14 – Load Balancing & Front Door <br>Lab 15 – Azure DNS Zones             |
| **E** | **8**   | 🩺 **Monitoring & Resilience**           | Lab 16 – Monitoring & Diagnostics <br>Lab 17 – Backup & Recovery <br>Lab 18 – Capstone: End-to-End Scenario                                                                                                      |

---

### 📁 Artifact Index

Each lab folder includes:

| **Category**               | **Folder Path**          | **Description**                                                                             |
| -------------------------- | ------------------------ | ------------------------------------------------------------------------------------------- |
| **Lab Guide**              | `Lab##_Name.md`          | Step-by-step guide for completing the lab                                                   |
| **Infrastructure as Code** | `/bicep/`, `/terraform/` | Bicep and Terraform templates for IaC deployments                                           |
| **Automation Scripts**     | `/powershell/`, `/cli/`  | PowerShell and Azure CLI automation scripts                                                 |
| **Logs**                   | `/artifacts/logs/`       | Command-line transcripts (CLI / PowerShell)                                                 |
| **Configs**                | `/artifacts/configs/`    | JSON, YAML, or exported policy/configuration data                                           |
| **Outputs**                | `/artifacts/outputs/`    | Deployment results, state files, or verification exports                                    |
| **Reports**                | `/artifacts/reports/`    | Downloaded reports, cost exports, or audit outputs                                          |
| **Docs**                   | `/docs/`                 | Supporting study materials (e.g., License Matrix, Feature Comparison, Exam Readiness notes) |

**Example Lab Folder Structure:**  

```text
/labs/
  lab01-setup-identity-baseline/
    Lab01_Setup-Identity-Baseline.md
    /bicep/
    /terraform/
    /powershell/
    /cli/
    /artifacts/
      /logs/
      /configs/
      /outputs/
      /reports/
    /docs/
      License-Feature-Matrix.md
      SSPR-Troubleshooting.md
      Exam-Readiness-Notes.md
```

---

## 🧩 Lab Modules Overview

| Lab    | Title / Focus                                                                                        | Key Subskills                                                                                 | Dependencies      | Status          |
| ------ | ---------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ----------------- | --------------- |
| **1**  | [Setup and Identity Baseline](./labs/lab01-setup-identity-baseline/Lab01_Setup-Identity-Baseline.md) | Create users & groups, manage user/group properties, license management, external users, SSPR | None              | 🚧 In Progress |
| **2**  | Role-Based Access & Scoping                                                                          | Built-in roles, assign roles by scope, interpret access assignments                           | Lab 1             | 🕒 Not Started |
| **3**  | Governance & Policies                                                                                | Policy definition/initiative, resource locks, tags, moving resources                          | Lab 2             | 🕒 Not Started |
| **4**  | Subscription & Cost Management                                                                       | Management groups, budgets, cost alerts, Advisor recommendations                              | Lab 3             | 🕒 Not Started |
| **5**  | Storage Accounts & Access Controls                                                                   | Redundancy, firewall rules, SAS tokens, stored access policies                                | Lab 1 (optional)  | 🕒 Not Started |
| **6**  | Data & Storage Operations                                                                            | Blob lifecycle, soft delete, Azure Files, AD-based access                                     | Lab 5             | 🕒 Not Started |
| **7**  | Infrastructure as Code (Bicep/Terraform)                                                             | Create, modify, and deploy IaC templates                                                      | Labs 1–6          | 🕒 Not Started |
| **8**  | Virtual Machines & Disks                                                                             | VM creation, encryption, availability sets/zones, moves                                       | Lab 7             | 🕒 Not Started |
| **9**  | VM Scale Sets & Containers                                                                           | VMSS, container registry, ACI/ACA basics                                                      | Lab 8             | 🕒 Not Started |
| **10** | App Services & Web Apps                                                                              | App Service plans, TLS, scaling, deployment slots                                             | Lab 9             | 🕒 Not Started |
| **11** | Virtual Networks & Routing                                                                           | VNets, subnets, peering, public IPs, UDRs                                                     | Core prerequisite | 🕒 Not Started |
| **12** | Network Security & Private Access                                                                    | NSG, ASG, Bastion, endpoints                                                                  | Lab 11            | 🕒 Not Started |
| **13** | Hybrid Connectivity                                                                                  | VPN Gateway, ExpressRoute, Virtual WAN                                                        | Lab 12            | 🕒 Not Started |
| **14** | Load Balancing & Traffic Management                                                                  | Load Balancer, App Gateway, Front Door, Traffic Manager                                       | Labs 10–13        | 🕒 Not Started |
| **15** | DNS & Name Resolution                                                                                | Public/private DNS, linking, conditional forwarding                                           | Lab 11            | 🕒 Not Started |
| **16** | Monitoring & Diagnostics                                                                             | Metrics, logs, alerts, diagnostic settings                                                    | Labs 7–15         | 🕒 Not Started |
| **17** | Backup & Recovery                                                                                    | Azure Backup, Recovery Services Vault, restore validation                                     | Lab 8             | 🕒 Not Started |
| **18** | Capstone: End-to-End Scenario                                                                        | Multi-tier deployment, governance, monitoring, troubleshooting                                | All prior labs    | 🕒 Not Started |

**Legend:**  

| Emoji | Meaning     |
| ----- | ----------- |
| 🕒   | Not Started |
| 🚧   | In Progress |
| ✅    | Complete    |

---

## 🧠 Additional Resources

- [Exam Readiness Zone](https://learn.microsoft.com/en-us/shows/exam-readiness-zone/?terms=az-104)  
- [Microsoft Learn: AZ-104 Learning Path](https://learn.microsoft.com/en-us/training/paths/azure-administrator/)  
- [Official Exam Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-104)  
- [Exam-Readiness.md →](./Exam-Readiness.md)

### Skill References

#### 1. Manage Azure identities and governance (20-25%)

- **Manage Microsoft Entra ID objects**
  - Create users and groups
    - [Types of users](https://learn.microsoft.com/en-us/entra/fundamentals/how-to-create-delete-users#types-of-users)
    - [Default user permissions](https://learn.microsoft.com/en-us/entra/fundamentals/users-default-permissions)
    - [Create users in bulk](https://learn.microsoft.com/en-us/entra/identity/users/users-bulk-add)
  - Manage user and group properties
  - Manage licenses in Microsoft Entra ID
    - [Microsoft Entra Licensing](https://learn.microsoft.com/en-us/entra/fundamentals/licensing)
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

---

*Last updated: 2025-10-08*  
