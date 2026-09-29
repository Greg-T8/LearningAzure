# Applied Skills

Applied Skills are self-directed technical learning tracks used to build practical depth in a focused topic. They are separate from certification study and are not necessarily Microsoft Applied Skills credentials.

This directory is the central tracker. The catalog defines the available skill IDs, and the shared [study log](./StudyLog.md) records time across every track. Substantial development, labs, and curated content belong in the linked topic repository when one is available.

## Catalog

The status and repository fields are maintained manually. Study dates, distinct days, and committed hours are generated from the shared study log.

<!-- APPLIED_SKILLS_CATALOG_START -->
| ID | Applied Skill | Description | Status | Repository | First Studied | Last Studied | Days Studied | Hours Committed |
|:---|:--------------|:------------|:-------|:-----------|:--------------|:-------------|-------------:|----------------:|
| ALZ | Azure Landing Zones | Plan, deploy, and operate Azure landing zones using the ALZ Terraform Accelerator and Azure Verified Modules. | In Progress | [Repository](https://github.com/Greg-T8/ALZ) | 7/14/26 | 9/12/26 | 36 | 74.2h |
| AMBA | Azure Monitor Baseline Alerts | Deploy and operate policy-driven Azure Monitor baseline alerts for Azure landing zones. | Not Started | TBD | — | — | 0 | 0.0h |
| AVS | Azure VMware Solution | Develop practical proficiency with AVS architecture, connectivity, migration, security, storage, and operations. | Paused | [Repository](https://github.com/Greg-T8/LearningAVS) | 7/25/26 | 7/25/26 | 1 | 2.3h |
| SQL-AOAG | SQL Server Always On Availability Groups | Build operational knowledge of SQL Server Always On availability groups, including design, deployment, failover, and troubleshooting. | Not Started | TBD | — | — | 0 | 0.0h |
<!-- APPLIED_SKILLS_CATALOG_END -->

## Lifecycle

- **Not Started** — Registered for future study with no active learning effort.
- **In Progress** — An active learning priority.
- **Paused** — Previously studied but not currently active.
- **Completed** — The intended learning outcome has been achieved.

Status is independent of logged time. A paused or completed track retains its full history and metrics.

## Study Sessions

Use the catalog ID when starting or logging a session. All Applied Skills sessions are written to the same log and use one global session sequence.

```powershell
Invoke-StudySession -Action Start -AppliedSkill ALZ -Notes 'Explore bootstrap permissions'
Invoke-StudySession -Action Stop -AppliedSkill ALZ -Notes 'Continue with policy assignments'
Invoke-StudySession -Action Log -AppliedSkill SQL-AOAG -StartTime '9/29/26 5:00 AM' -EndTime '9/29/26 6:00 AM' -Notes 'Reviewed quorum models'
```

Certification sessions continue to use their certification-specific study logs.

## Adding a Track

Run the helper from the repository root. A repository URL is optional and can be added to the catalog later.

```powershell
& ./.assets/scripts/Add-AppliedSkill.ps1 `
    -Id 'EXAMPLE' `
    -Name 'Example Technology' `
    -Description 'Build practical proficiency with the example technology.'
```

The helper validates the ID, status, repository URL, and catalog uniqueness. It adds only a catalog entry; it does not create a topic folder or an external repository.

## Repository Boundary

- Keep the catalog, shared study log, and aggregate learning history in LearningAzure.
- Keep implementation code, lab environments, detailed notes, and curated topic content in a dedicated repository.
- Use `TBD` until a repository exists; the track can still be studied and logged.
- Treat the current `ALZ`, `AMBA`, and `AVS` directories as legacy content pending verification and retirement. Do not add new study logs beneath them.

## Exploration Backlog

### Azure Landing Zones

- [Azure Landing Zones IaC Accelerator](https://azure.github.io/Azure-Landing-Zones/accelerator/)
- [Azure landing zone documentation](https://azure.github.io/Azure-Landing-Zones/policy/policyupdate2latest/)
- [Azure Monitor Baseline Alerts](https://azure.github.io/azure-monitor-baseline-alerts/welcome/)

### Cost Management

- [Terraform Community Module for Cost Alert](https://registry.terraform.io/modules/CloudNationHQ/costs/azure/latest)
- [FinOps Toolkit - Microsoft Learn](https://learn.microsoft.com/en-us/cloud-computing/finops/toolkit/finops-toolkit-overview)
- [FinOps Toolkit - GitHub](https://github.com/microsoft/finops-toolkit/tree/dev/src/bicep-registry/scheduled-action)
- [Power BI Cost Management Connector](https://learn.microsoft.com/en-us/power-bi/connect-data/desktop-connect-azure-cost-management)

### Governance

- [Awesome Azure Policy](https://github.com/globalbao/awesome-azure-policy)
- [Azure Governance Visualizer](https://github.com/JulianHayward/Azure-MG-Sub-Governance-Reporting)
- [Azure Naming Tool](https://github.com/Azure/AzureNamingTool/wiki)