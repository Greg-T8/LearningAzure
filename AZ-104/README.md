# AZ-104: Microsoft Azure Administrator — Hands-On Lab Series

**Author:** Greg Tate  
**Objective:** Build real-world, exam-aligned proficiency for the **AZ-104: Microsoft Azure Administrator** certification through a sequence of medium-to-hard, scenario-driven labs.

---

## 🎯 Overview

This repository contains a structured, hands-on path for mastering the **AZ-104** certification objectives.

Each lab is designed to:
- map directly to an **official exam subskill**,
- integrate multiple **deployment modalities** (Portal, CLI, PowerShell, Bicep, Terraform),
- force you to reference the **Microsoft documentation**,
- and reinforce troubleshooting, governance, and automation skills.

Average lab duration: **1.5–2 hours**

---

## 📘 Exam Domains (per Microsoft Learn)

| Domain | Weight |
|--------|--------|
| 1. Manage Azure identities and governance | 20–25% |
| 2. Implement and manage storage | 15–20% |
| 3. Deploy and manage Azure compute resources | 20–25% |
| 4. Implement and manage virtual networking | 15–20% |
| 5. Monitor and maintain Azure resources | 10–15% |

> Source: [Microsoft Official Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-104)

---

## 🧭 Learning Approach

- **Hands-on:** Every lab deploys and validates live Azure resources.  
- **Multi-modal:** Each scenario is implemented using Azure Portal, CLI, PowerShell, and Infrastructure as Code (Bicep or Terraform).  
- **Exam-driven:** Aligned with the **skills measured** outline; every bullet is covered.  
- **Documentation-first:** Labs intentionally omit some parameter details to force interaction with Microsoft Docs.  
- **Scenario-based:** You’ll act as a cloud admin responding to realistic business or operational challenges.

---

## 🗓 8-Week Lab Roadmap

| Phase | Week | Focus Area | Labs |
|-------|------|-------------|------|
| **A** | **1–2** | **Identity & Governance Foundations** | [Lab 1 – Setup and Identity Baseline](./labs/Lab01_IdentityBaseline.md)  <br>[Lab 2 – RBAC and Scoping](./labs/Lab02_RBAC_Scopes.md)  <br>[Lab 3 – Policy & Resource Locks](./labs/Lab03_Policy.md)  <br>[Lab 4 – Subscription & Budgets](./labs/Lab04_Budgets.md) |
| **B** | **3** | **Storage and Data Management** | [Lab 5 – Secure Azure Storage Accounts](./labs/Lab05_StorageAccounts.md)  <br>[Lab 6 – Azure Files & Blob Management](./labs/Lab06_StorageData.md) |
| **C** | **4–5** | **Compute and Automation** | [Lab 7 – Infrastructure as Code (Bicep & Terraform)](./labs/Lab07_IaC.md)  <br>[Lab 8 – Virtual Machines & Disks](./labs/Lab08_VMs.md)  <br>[Lab 9 – Scale Sets & Containers](./labs/Lab09_VMSS_Containers.md)  <br>[Lab 10 – App Services & Web Apps](./labs/Lab10_AppServices.md) |
| **D** | **6–7** | **Networking and Hybrid Connectivity** | [Lab 11 – Virtual Networks & Routing](./labs/Lab11_VNetRouting.md)  <br>[Lab 12 – Network Security (NSG, Private Endpoint)](./labs/Lab12_NetworkSecurity.md)  <br>[Lab 13 – VPN, ExpressRoute, Virtual WAN](./labs/Lab13_HybridConnectivity.md)  <br>[Lab 14 – Load Balancing & Front Door](./labs/Lab14_LoadBalancing.md)  <br>[Lab 15 – Azure DNS Zones](./labs/Lab15_DNS.md) |
| **E** | **8** | **Monitoring & Resilience** | [Lab 16 – Monitoring & Diagnostics](./labs/Lab16_Monitoring.md)  <br>[Lab 17 – Backup & Recovery](./labs/Lab17_Bac_)_)
