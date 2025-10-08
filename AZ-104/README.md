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

| Phase | Week    | Focus Area                              | Labs                                                                                                                                                                                                             |
| ----- | ------- | --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **A** | **1–2** | 🧠 **Identity & Governance Foundations** | [Lab 1 – Setup and Identity Baseline](./labs/lab01-setup-identity-baseline/Lab01_Setup-Identity-Baseline.md) <br>Lab 2 – RBAC and Scoping <br>Lab 3 – Policy & Resource Locks <br>Lab 4 – Subscription & Budgets |
| **B** | **3**   | 💾 **Storage and Data Management**       | Lab 5 – Secure Azure Storage Accounts <br>Lab 6 – Azure Files & Blob Management                                                                                                                                  |
| **C** | **4–5** | ☁️ **Compute and Automation**            | Lab 7 – Infrastructure as Code (Bicep & Terraform) <br>Lab 8 – Virtual Machines & Disks <br>Lab 9 – Scale Sets & Containers <br>Lab 10 – App Services & Web Apps                                                 |
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

| Lab    | Title / Focus                                                                                        | Key Subskills                                                                                 | Dependencies      | Status        |
| ------ | ---------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ----------------- | ------------- |
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
| 🕒     | Not Started |
| 🚧     | In Progress |
| ✅     | Complete    |

---

## 🧠 Additional Resources

- [Exam Readiness Zone](https://learn.microsoft.com/en-us/shows/exam-readiness-zone/?terms=az-104)  
- [Microsoft Learn: AZ-104 Learning Path](https://learn.microsoft.com/en-us/training/paths/azure-administrator/)  
- [Official Exam Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-104)  
- [Exam-Readiness.md →](./Exam-Readiness.md)

---

*Last updated: 2025-10-08*
