## Hands-On Labs Ideas

### Lab 1: AMBA Portal Deployment

**Goal:** Deploy AMBA through the portal path and understand the portal controls.

Things to try:

- Launch the management group portal accelerator: `https://aka.ms/amba/alz/portal`.
- If testing at subscription scope, use: `https://aka.ms/amba/alz/portal4Subs`.
- Set the deployment region, AMBA resource group, managed identity option, and management subscription.
- Enable only the desired initiative categories.
- Configure at least one notification path.
- Remediate policy assignments for existing resources.

Expected learning: the portal is excellent for initiative-level deployment, but not the best path for an exact 10-alert custom catalog.

### Lab 2: AMBA Terraform Deployment

**Goal:** Deploy AMBA through Terraform against the landing-zone structure.

Things to try:

- Add the AMBA library reference or use the AMBA Terraform module path documented by the ALZ Terraform Accelerator.
- Add the AMBA archetype(s) that match the management group target.
- Configure AMBA resource group and user-assigned managed identity names.
- Set policy default values for notification, managed identity, disable tag, and optional BYON values.
- Run `terraform init`, `terraform validate`, and `terraform plan`.
- Apply only in a safe test scope.

### Lab 3: 10-Alert Custom Selection

**Goal:** Practice selecting a small alert catalog instead of deploying everything.

Start with this practice subset, then replace items based on resources actually deployed in your landing zone:

| # | Candidate Policy Definition | Why Include It |
|--:|:----------------------------|:---------------|
| 1 | `Deploy_activitylog_ServiceHealth_Incident` | Service-wide incident visibility. |
| 2 | `Deploy_activitylog_ServiceHealth_Maintenance` | Planned maintenance awareness. |
| 3 | `Deploy_activitylog_ServiceHealth_HealthAdvisory` | Advisory signal without relying on portal checks. |
| 4 | `Deploy_activitylog_ResourceHealth_Unhealthy_Alert` | Resource-level health changes. |
| 5 | `Deploy_KeyVault_Availability_Alert` | Critical identity/secrets dependency. |
| 6 | `Deploy_KeyVault_Capacity_Alert` | Key Vault saturation signal. |
| 7 | `Deploy_StorageAccount_Availability_Alert` | Core platform storage availability. |
| 8 | `Deploy_VM_HeartBeat_Alert` | VM availability through log-search signal. |
| 9 | `Deploy_VM_CPU_Alert` | Basic VM performance signal. |
| 10 | `Deploy_AFW_FirewallHealth_Alert` | Platform connectivity health if Azure Firewall is deployed. |

Things to try:

- Record the alert type, initiative, default enabled state, policy definition name, policy reference ID, threshold, severity, evaluation frequency, and scope for each alert.
- Start from the AMBA "Service Health only" custom deployment example to understand a minimal custom policy assignment.
- Build a custom Terraform design for your 10-alert subset using one of these approaches:
  - Custom policy set and assignment that references only the selected policies.
  - Full policy set with unwanted alert policies set to `disabled` through policy parameters.
  - Initiative-level deployment plus `MonitorDisable` tags only when the requirement is resource exclusion, not catalog reduction.
- Run `terraform plan` and inspect whether only the intended definitions/assignments/remediations are affected.

Do not treat this candidate list as a production recommendation. It is a study subset designed to exercise common AMBA control points.

### Lab 4: Alert Control Matrix

**Goal:** Understand the difference between not deploying, disabling, excluding, and suppressing.

| Control | Use When | Effect |
|:--------|:---------|:-------|
| Initiative enablement parameters | You want broad categories such as Storage, VM, Web, or Service Health on/off. | Assigns or skips AMBA initiative categories. |
| `PolicyEffect` | You want a policy definition present but not deploying alert resources. | Policy exists, but effect can be disabled. |
| `AlertState` | You want deployed metric alerts disabled without deleting them. | Alert rule can remain deployed with `enabled = false`. |
| `MonitorDisable` tag | You want specific resources excluded from monitoring. | Policy/remediation skips matching resources; does not apply to every alert type. |
| Management group/subscription exclusions | You want to keep whole scopes out of policy assignment. | Policy assignment excludes those scopes. |
| Alert processing rules | You want notifications suppressed or routed differently. | Alert rules still exist; notification behavior changes. |
| BYON | You already have action groups/APRs and do not want AMBA-created notification assets. | AMBA points alerts at existing notification assets. |
| Threshold parameters/tags | You want different thresholds globally or per resource. | Alert criteria changes without redefining the whole alert. |

---
