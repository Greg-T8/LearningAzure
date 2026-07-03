# AMBA: Azure Monitor Baseline Alerts — Applied Skill

**Objective:** Build hands-on proficiency with **Azure Monitor Baseline Alerts (AMBA)** — the Microsoft-curated library of alert definitions and its policy-driven, at-scale deployment model for Azure Landing Zones.

- **Reference:** [Azure Monitor Baseline Alerts](https://azure.github.io/azure-monitor-baseline-alerts/)
- **ALZ Terraform Accelerator Template:** [platform_landing_zone](https://github.com/Azure/alz-terraform-accelerator/tree/main/templates/platform_landing_zone)
- **Study Log:** [Session-by-session study time tracker](./StudyLog.md)

<!-- STUDY_SUMMARY -->
**Hours Committed:** 0.0h · **Days Studied:** 0
<!-- /STUDY_SUMMARY -->
- **Target Pace:** 3 days/week for 3-4 weeks, roughly 9-12 sessions

---

## 📘 Study Guide

This applied skill is not an exam objective list. The goal is to leave with working deployment muscle memory, a practical alert-selection model, and a reusable decision process for AMBA in landing-zone environments.

**Last researched:** 2026-07-03

### Completion Criteria

You are done when you can:

- Explain what AMBA deploys, where it deploys it, and how Azure Policy remediation turns recommendations into alert resources.
- Deploy or dry-run an Azure platform landing zone using Terraform and Azure Verified Modules (AVM).
- Deploy AMBA through the Azure portal accelerator.
- Deploy AMBA through Terraform.
- Choose AMBA scope at three levels: initiative/category, individual policy/alert, and resource-level exclusion.
- Prove the result with policy assignment, policy compliance, alert rule, action group, and alert processing rule checks.

---

## Study Domains

### 1. Landing Zone Foundation with Terraform and AVM

| Skill | Tasks | Practice Evidence |
|:------|:------|:------------------|
| [Understand the ALZ Terraform Accelerator](./lessons/01-understand-alz-terraform-accelerator.md) | Identify the accelerator phases: planning, prerequisites, bootstrap, and run. Explain when to use GitHub, Azure DevOps, or local filesystem output. | Notes describing selected path for your lab environment. |
| Understand the `platform_landing_zone` template | Map the template files, generated variables, examples, and AVM modules. Identify what deploys management groups, policy, role definitions, management resources, connectivity, DDoS, and private DNS. | Annotated file map of the template. |
| Deploy or dry-run the platform landing zone | Configure subscriptions, starter locations, and either hub-and-spoke or Virtual WAN. Prefer `terraform plan` first; only apply if cost and permissions are acceptable. | Saved plan output and a short architecture summary. |
| Verify the baseline landing zone | Validate management group hierarchy, policy assignments, Log Analytics workspace, automation account, and connectivity resources. | CLI/portal screenshots or notes with resource IDs. |

### 2. AMBA Concepts and Alert Catalog

| Skill | Tasks | Practice Evidence |
|:------|:------|:------------------|
| Explain AMBA | Summarize the Azure Resources, Patterns/Scenarios, and Visualizations sections of the AMBA docs. | One-page AMBA architecture note. |
| Classify alerts | Distinguish activity log alerts, metric alerts, log-search alerts, static thresholds, dynamic thresholds, default enabled alerts, and default disabled alerts. | Table with 10 sample alerts and their type/default state. |
| Understand AMBA-ALZ policy initiatives | Map initiatives such as Resource and Service Health, Connectivity, Identity, Management, VM, Key Management, Load Balancing, Network Changes, Recovery Services, Storage, Web, and Notification Assets. | Initiative-to-management-group mapping. |
| Understand remediation | Explain why greenfield resources can be handled automatically while existing resources often need policy remediation. | Remediation notes and command/portal path. |

### 3. AMBA Deployment Methods

| Skill | Tasks | Practice Evidence |
|:------|:------|:------------------|
| Deploy via Azure portal | Use the AMBA-ALZ portal accelerator. Practice both management group and subscription deployment paths if you have a safe test scope. | Parameter choices, enabled initiatives, notification settings. |
| Deploy via Terraform | Use the AMBA Terraform module and/or the ALZ Terraform Accelerator AMBA option. Configure library references, AMBA archetypes, AMBA resource group, managed identity, and policy default values. | `terraform plan` and, if applied, deployed AMBA resources. |
| Configure notifications | Practice AMBA-created notification assets and Bring Your Own Notifications (BYON). Compare email, ARM role, webhook, Logic App, Event Hub, and Function options. | Action group/APR resource IDs and routing notes. |
| Validate deployment | Check policy assignments, policy states, remediation tasks, metric alerts, activity log alerts, action groups, and alert processing rules. | Validation checklist with commands and results. |

### 4. Alert Selection, Tuning, and Operations

| Skill | Tasks | Practice Evidence |
|:------|:------|:------------------|
| Select alert categories | Use portal or parameter toggles such as `enableAMBAStorage`, `enableAMBAVM`, and `enableAMBAServiceHealth` to deploy broad initiatives. | A category-only deployment decision record. |
| Select individual alerts | Use Terraform/custom policy assignments when the requirement is "only these 10 alerts." Avoid treating the portal accelerator as the precise-alert selection mechanism. | Custom 10-alert design with policy names and assignments. |
| Disable or suppress alerts | Compare `AlertState`, `PolicyEffect`, `MonitorDisable`, management group/subscription exclusions, and alert processing rules. | Scenario notes for each control. |
| Tune thresholds | Adjust assignment parameters for global thresholds and use threshold override tags for resource-specific metric/log-search thresholds. | Before/after threshold notes. |
| Operate AMBA over time | Practice version lookup, update planning, cleanup, and brownfield remediation. | Runbook for update/remediate/cleanup. |

---

## 3-4 Week Plan

Each session is intended to be 2-3 hours. The core plan is 12 sessions; for a 3-week run, combine sessions 10-12 into a single capstone week.

### Week 1: Orient and Build the Landing Zone Base

| Session | Focus | Outcomes |
|:--------|:------|:---------|
| 1 | AMBA and ALZ orientation | Read the AMBA welcome, AMBA-ALZ overview, policy initiatives, and alerts detail pages. Create a simple architecture sketch: management group scope -> policy assignment -> remediation -> alert/action group/APR. |
| 2 | ALZ Terraform Accelerator | Inspect the IaC accelerator phases and the `platform_landing_zone` template. Decide whether the lab uses GitHub bootstrap, Azure DevOps bootstrap, local filesystem output, or direct Terraform examples. |
| 3 | Platform landing zone plan | Configure a safe lab plan for the platform landing zone. Prefer a management/policy-only or minimal-cost configuration first; only use full hub-and-spoke or Virtual WAN when budget and subscriptions are ready. |

### Week 2: Deploy AMBA Through the Portal

| Session | Focus | Outcomes |
|:--------|:------|:---------|
| 4 | AMBA catalog review | Pick a resource set to care about first: Service Health, Resource Health, Key Vault, Storage, VM, and one network component. Build a 10-alert candidate list. |
| 5 | Portal deployment | Use the AMBA portal accelerator. Enable only the initiative categories needed for the first lab, configure notification settings, and capture all parameter choices. |
| 6 | Portal validation and remediation | Validate policy assignments and compliance. Remediate non-compliant existing resources. Confirm expected alert rules, action groups, and alert processing rules exist. |

### Week 3: Deploy AMBA Through Terraform

| Session | Focus | Outcomes |
|:--------|:------|:---------|
| 7 | Terraform AMBA default path | Add the AMBA library/archetypes or the AMBA Terraform module to the landing zone Terraform pattern. Configure the AMBA resource group, managed identity, notification defaults, and policy defaults. |
| 8 | Terraform plan/apply | Run `terraform init`, `terraform validate`, and `terraform plan`. Apply only in a safe test scope. Compare Terraform-managed AMBA deployment with the portal deployment. |
| 9 | Selective Terraform deployment | Practice a subset deployment. Start with "Service Health only" because the docs provide a clean example, then adapt the pattern toward your 10-alert target list. |

### Week 4: Control, Tune, and Operate

| Session | Focus | Outcomes |
|:--------|:------|:---------|
| 10 | Alert controls | Test `PolicyEffect`, `AlertState`, and `MonitorDisable`. Document which control prevents deployment, disables deployed alerts, excludes resources, or only suppresses notifications. |
| 11 | Thresholds and notifications | Override thresholds globally through parameters and per-resource through tags. Practice BYON with an existing action group and alert processing rule. |
| 12 | Capstone | Rebuild the full path from scratch in notes: landing zone Terraform plan, AMBA portal deployment, AMBA Terraform deployment, 10-alert selection design, validation, remediation, cleanup. |

---

## Primary References

- [AMBA welcome](https://azure.github.io/azure-monitor-baseline-alerts/welcome/)
- [AMBA alert details](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/getting-started/Alerts-Details/index.html)
- [AMBA policy initiatives](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/getting-started/Policy-Initiatives/index.html)
- [Deploy AMBA via the Azure portal](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/HowTo/deploy/Deploy-via-Azure-Portal-UI/index.html)
- [Deploy AMBA with Terraform](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/HowTo/deploy/Deploy-with-Terraform/index.html)
- [AMBA Terraform module](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/Resources/Terraform-Module/index.html)
- [Customize AMBA policy assignment](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/HowTo/deploy/Customize-Policy-Assignment/)
- [Deploy only Service Health alerts](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/HowTo/deploy/Deploy-only-Service-Health-Alerts/index.html)
- [Disable AMBA policies](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/HowTo/Disabling-Policies/index.html)
- [Override AMBA alert thresholds](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/HowTo/Threshold-Override/index.html)
- [Bring Your Own Notifications](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/HowTo/Bring-your-own-Notifications/index.html)
- [Remediate AMBA policies](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/HowTo/deploy/Remediate-Policies/index.html)
- [ALZ IaC Accelerator](https://azure.github.io/Azure-Landing-Zones/accelerator/)
- [ALZ Terraform Accelerator: deploy AMBA option](https://azure.github.io/Azure-Landing-Zones/accelerator/starter-terraform/options/amba/)
- [ALZ Terraform Accelerator `platform_landing_zone` template](https://github.com/Azure/alz-terraform-accelerator/tree/main/templates/platform_landing_zone)
