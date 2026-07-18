# ALZ: Azure Landing Zone — Applied Skill

**Objective:** Build hands-on proficiency with the **Azure Landing Zone (ALZ)** platform, using the ALZ Terraform Accelerator and Azure Verified Modules (AVM) to plan, deploy, and verify a baseline landing zone.

- **Reference:** [Azure Landing Zones](https://azure.github.io/Azure-Landing-Zones/)
- **ALZ Terraform Accelerator Template:** [platform_landing_zone](https://github.com/Azure/alz-terraform-accelerator/tree/main/templates/platform_landing_zone)
- **Study Log:** [Session-by-session study time tracker](./StudyLog.md)

<!-- STUDY_SUMMARY -->
**Hours Committed:** 5.0h · **Days Studied:** 4
- Research: 5.0h
<!-- /STUDY_SUMMARY -->





- **Target Pace:** 3 days/week for 2-3 weeks, roughly 6-9 sessions

---

## 📘 Study Guide

This applied skill is not an exam objective list. The goal is to leave with working deployment muscle memory for the ALZ Terraform Accelerator and a reusable decision process for standing up a platform landing zone.

**Last researched:** 2026-07-03

### Completion Criteria

You are done when you can:

- Explain the ALZ Terraform Accelerator phases and how bootstrap builds the deployment machinery.
- Map the `platform_landing_zone` template files, AVM modules, and core resources.
- Deploy or dry-run an Azure platform landing zone using Terraform and Azure Verified Modules (AVM).
- Prove the result with baseline management group hierarchy, policy, and management-resource checks.

---

## Study Domains

### 1. Landing Zone Foundation with Terraform and AVM

| Skill | Tasks | Practice Evidence |
|:------|:------|:------------------|
| [Understand the ALZ Terraform Accelerator](./lessons/01-understand-alz-terraform-accelerator.md) | Identify accelerator phases and output strategy. | Notes describing selected path for your lab environment. |
| Understand the `platform_landing_zone` template | Map template files, AVM modules, and core resources. | Annotated file map of the template. |
| Deploy or dry-run the platform landing zone | Configure scope and run a safe landing zone plan. | Saved plan output and a short architecture summary. |
| Verify the baseline landing zone | Validate baseline hierarchy, policies, and management resources. | CLI/portal screenshots or notes with resource IDs. |

---

## 2-3 Week Plan

Each session is intended to be 2-3 hours.

### Week 1: Orient and Inspect the Accelerator

| Session | Focus | Outcomes |
|:--------|:------|:---------|
| 1 | ALZ orientation | Read the ALZ overview and accelerator landing page. Create a simple architecture sketch: management group hierarchy -> policy -> management resources. |
| 2 | ALZ Terraform Accelerator | Inspect the IaC accelerator phases and the `platform_landing_zone` template. Decide whether the lab uses GitHub bootstrap, Azure DevOps bootstrap, local filesystem output, or direct Terraform examples. |
| 3 | Platform landing zone plan | Configure a safe lab plan for the platform landing zone. Prefer a management/policy-only or minimal-cost configuration first; only use full hub-and-spoke or Virtual WAN when budget and subscriptions are ready. |

### Week 2: Build and Verify the Landing Zone Base

| Session | Focus | Outcomes |
|:--------|:------|:---------|
| 4 | Template file map | Map `terraform.tf`, `main.management.groups.tf`, `main.management.resources.tf`, connectivity files, variable files, and examples. Identify AVM module responsibilities. |
| 5 | Plan/apply | Run `terraform init`, `terraform validate`, and `terraform plan`. Review management group, policy, role, Log Analytics, Automation, networking, DDoS, and private DNS changes. Apply only when plan, permissions, and cost profile are acceptable. |
| 6 | Verify baseline | Validate baseline management group hierarchy, policy assignments, and management resources. Capture resource IDs. |

---

## Primary References

- [Azure Landing Zones](https://azure.github.io/Azure-Landing-Zones/)
- [ALZ IaC Accelerator](https://azure.github.io/Azure-Landing-Zones/accelerator/)
- [Accelerator: Planning](https://azure.github.io/Azure-Landing-Zones/accelerator/0_planning/)
- [Accelerator: Prerequisites](https://azure.github.io/Azure-Landing-Zones/accelerator/1_prerequisites/)
- [Accelerator: Bootstrap](https://azure.github.io/Azure-Landing-Zones/accelerator/2_bootstrap/)
- [Accelerator: Run](https://azure.github.io/Azure-Landing-Zones/accelerator/3_run/)
- [ALZ Terraform Accelerator `platform_landing_zone` template](https://github.com/Azure/alz-terraform-accelerator/tree/main/templates/platform_landing_zone)