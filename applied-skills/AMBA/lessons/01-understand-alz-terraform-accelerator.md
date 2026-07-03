# Lesson 1: Understand the ALZ Terraform Accelerator

**Domain:** 1 — Landing Zone Foundation with Terraform and AVM
**Skill:** Understand the ALZ Terraform Accelerator
**Maps to:** Week 1, Session 2 in the [study plan](../README.md#week-1-orient-and-build-the-landing-zone-base)
**Session length:** 2-3 hours
**Deliverable (Practice Evidence):** A decision record describing the accelerator path selected for your lab environment.

---

## Learning Objectives

By the end of this lesson you can:

1. Name and describe the four accelerator phases — **Planning**, **Prerequisites**, **Bootstrap**, and **Run** — and state what each phase produces.
2. Explain what the ALZ PowerShell module (`Deploy-Accelerator`) does during bootstrap and which configuration files it consumes.
3. Choose between **GitHub**, **Azure DevOps**, and **local filesystem** output, and justify the choice for a given environment.
4. List the bootstrap decisions you must make before running anything, and fill them in for your own lab.

---

## Prework (15 min, before the session)

- Skim the [ALZ IaC Accelerator landing page](https://azure.github.io/Azure-Landing-Zones/accelerator/) — just the overview, not the sub-pages yet.
- Have your lab constraints in mind: available subscriptions, tenant permissions, and whether you have a GitHub org/account or Azure DevOps org you can safely use.

---

## Session Agenda

### Block 1 — The Big Picture (20 min)

Read the accelerator overview and answer in your notes:

- What problem does the accelerator solve compared to cloning the `platform_landing_zone` template and running Terraform by hand?
- What does "bootstrap a continuous delivery environment" actually mean here? (Answer: the accelerator doesn't just deploy the landing zone — it first builds the *machinery* that deploys the landing zone: repo, pipelines/workflows, identities, state storage.)

Sketch this pipeline in your notes before moving on:

```
Planning (decisions) -> Prerequisites (tools + permissions + subscriptions)
    -> Bootstrap (Deploy-Accelerator wizard -> repo/pipelines/identities/state)
    -> Run (plan -> approval -> apply of the platform landing zone)
```

### Block 2 — Phase Deep Dive (60-75 min)

Work through each phase page. For each one, capture the outputs and the decisions in your own words.

#### Phase 0 — Planning

Read: [Planning](https://azure.github.io/Azure-Landing-Zones/accelerator/0_planning/)

The planning phase is a set of decisions, not actions. Download the `checklist.xlsx` the docs provide and record:

| Decision | Your Lab Answer |
|:---------|:----------------|
| IaC tooling (Bicep or Terraform) | Terraform (this applied skill) |
| Version control system (GitHub / Azure DevOps / Local) | |
| Starter module | `platform_landing_zone` |
| Bootstrap region | |
| Platform region(s) | |
| Parent management group (must already exist) | |
| Platform subscriptions (min 2: Management + Connectivity; recommended 4: + Identity, Security) | |
| Bootstrap subscription (usually Management) | |
| Resource naming (service name + environment name) | |
| Agent/runner model (private/self-hosted, public/self-hosted, public/Microsoft-hosted) | |
| Deployment scenario (hub-and-spoke, Virtual WAN, management-only, ...) | |

> Lab note: per the study plan, prefer a management/policy-only or minimal-cost scenario first. You are not committing to hub-and-spoke or Virtual WAN in this lesson.

#### Phase 1 — Prerequisites

Read: [Prerequisites](https://azure.github.io/Azure-Landing-Zones/accelerator/1_prerequisites/)

Record in your notes:

- Required tooling: PowerShell 7.4+, Azure CLI 2.55.0+, Git; VS Code recommended. All must be on PATH.
- Permission requirements for the bootstrap identity (review the Platform Subscriptions and Permissions sub-page).
- VCS-specific prerequisites: PAT scopes for GitHub or Azure DevOps if you choose a hosted VCS.
- Two explicit constraints: **no corporate proxy support** and **no Azure Cloud Shell** — the docs suggest a temporary Azure VM as a workaround if you're behind a proxy.

Verify your own workstation now:

```powershell
$PSVersionTable.PSVersion   # expect 7.4+
az version                  # expect Azure CLI 2.55.0+
git --version
```

#### Phase 2 — Bootstrap

Read: [Bootstrap](https://azure.github.io/Azure-Landing-Zones/accelerator/2_bootstrap/)

Key facts to capture:

- The ALZ PowerShell module's `Deploy-Accelerator` command runs an interactive wizard that gathers your planning answers and applies a Terraform module to build the bootstrap environment.
- Two configuration files drive it: `./config/inputs.yaml` (bootstrap configuration) and `./config/platform-landing-zone.tfvars` (the Terraform platform landing zone configuration).
- You must replace `<region-#>` placeholders and set a Microsoft Defender for Cloud security contact email.
- What gets created depends on the VCS choice — this is the core of Block 3 below.
- There is an **Advanced Bootstrap** path for manual configuration if you need more control; note that it exists, but don't study it yet.

**Do not run `Deploy-Accelerator` in this session.** This lesson is about understanding the machine; Session 3 configures and plans the actual deployment.

#### Phase 3 — Run

Read: [Run](https://azure.github.io/Azure-Landing-Zones/accelerator/3_run/)

Capture how the run phase differs by output choice:

- **GitHub:** an Actions workflow runs a `plan` stage, waits for approval from designated `apply_approvers`, then runs `apply`.
- **Azure DevOps:** a pipeline with the same plan → approval → apply pattern, using configured approvers.
- **Local filesystem:** you run the provided `deploy-local.ps1`, which shows a Terraform plan and asks for a `yes` confirmation before applying.
- Gotcha for all three: if `grant_permissions_to_current_user` was disabled at bootstrap, you must grant management group / subscription / storage account access manually before the run succeeds.

### Block 3 — Choosing the Output Path (30 min)

This is the decision this lesson exists to produce. Build a comparison in your notes, then commit to one path.

| | GitHub | Azure DevOps | Local Filesystem |
|:--|:-------|:-------------|:-----------------|
| Bootstrap creates | Repo, Actions workflows, environments, OIDC federated credentials | Project, repos, pipelines, service connections, variable groups | Terraform module output in a local folder |
| Deployment trigger | Actions workflow with approval gate | Pipeline with approval gate | `deploy-local.ps1` / manual `terraform plan` + `apply` |
| Best when | Team already on GitHub; want OIDC (no long-lived secrets); public-facing or OSS-friendly orgs | Enterprise already on Azure DevOps; existing boards/repos/pipeline governance | Learning, labs, air-gapped evaluation, or when you'll wire up your own automation later |
| Watch out for | Needs a GitHub org/account you control; PAT required for bootstrap | Needs an ADO org + PAT; more moving parts | No approval gates, no CI history, state and credentials handled by you |
| Hosted only? | Yes — hosted GitHub only | Yes — hosted Azure DevOps services only | n/a |

Questions to force the decision for **your** lab:

1. Do you want this applied skill to also exercise CI/CD muscle memory, or is the CI/CD layer noise for now?
2. Will you tear the lab down and re-bootstrap repeatedly? (Local output makes iteration cheaper; VCS bootstrap leaves org-level artifacts to clean up.)
3. Does your tenant/org policy allow creating repos, service connections, or federated credentials?

> Typical lab guidance: **local filesystem** is the lowest-friction path for a study lab and keeps the focus on Terraform and AMBA rather than pipeline plumbing. **GitHub** is the better choice if you want the realistic end-to-end experience and already have an account — which also gives you the plan/approve/apply gate for free. Pick one, but be able to argue for the other two.

### Block 4 — Produce the Practice Evidence (20-30 min)

Write the decision record (suggested location: `applied-skills/AMBA/notes/accelerator-path-decision.md`). It should contain:

1. **Chosen path** (GitHub / Azure DevOps / local filesystem) and 2-3 sentences of justification referencing your lab constraints.
2. **Completed planning table** from Block 2 (Phase 0), with real values for your lab.
3. **Phase summary in your own words** — one sentence per phase, without looking at the docs.
4. **Open questions** to resolve in Session 3 (e.g., which minimal-cost deployment scenario to select, which subscriptions to use).

Log the session in [StudyLog.md](../StudyLog.md).

---

## Knowledge Check (self-test, no notes)

1. Name the four phases and the primary output of each.
2. What command starts the bootstrap wizard, and what two config files does it use?
3. Which two environments does the accelerator explicitly not support running from?
4. Your org blocks creating GitHub repos and you have no Azure DevOps org. Which path do you take, and what do you lose?
5. In the GitHub run phase, what stands between `plan` and `apply`?
6. What is the minimum number of platform subscriptions, and what is the recommended set?

<details>
<summary>Answers</summary>

1. **Planning** → completed decision checklist; **Prerequisites** → tooling installed, permissions and subscriptions ready; **Bootstrap** → CD environment (repo/pipelines or local output, identities, state storage); **Run** → deployed platform landing zone via plan/approve/apply.
2. `Deploy-Accelerator` (ALZ PowerShell module); `./config/inputs.yaml` and `./config/platform-landing-zone.tfvars`.
3. Corporate proxy environments and Azure Cloud Shell.
4. Local filesystem; you lose the built-in CI/CD workflow, approval gates, and pipeline history — you run `deploy-local.ps1` or Terraform manually.
5. A manual approval from the designated `apply_approvers`.
6. Minimum 2 (Management + Connectivity); recommended 4 (add Identity and Security).

</details>

---

## References

- [ALZ IaC Accelerator overview](https://azure.github.io/Azure-Landing-Zones/accelerator/)
- [Phase 0 — Planning](https://azure.github.io/Azure-Landing-Zones/accelerator/0_planning/)
- [Phase 1 — Prerequisites](https://azure.github.io/Azure-Landing-Zones/accelerator/1_prerequisites/)
- [Phase 2 — Bootstrap](https://azure.github.io/Azure-Landing-Zones/accelerator/2_bootstrap/)
- [Phase 3 — Run](https://azure.github.io/Azure-Landing-Zones/accelerator/3_run/)
- [ALZ Terraform Accelerator `platform_landing_zone` template](https://github.com/Azure/alz-terraform-accelerator/tree/main/templates/platform_landing_zone)

**Next lesson:** Understand the `platform_landing_zone` template (Domain 1, Skill 2) — pairs with [Lab 1: ALZ Terraform Accelerator File Map](../Hands-on%20labs%20ideas.md#lab-1-alz-terraform-accelerator-file-map).
