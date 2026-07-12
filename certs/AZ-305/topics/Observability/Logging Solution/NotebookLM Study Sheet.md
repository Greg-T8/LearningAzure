# NotebookLM Study Sheet — Recommend a Logging Solution

## Scope

- **Exam:** AZ-305: Designing Microsoft Azure Infrastructure Solutions
- **Domain:** Identity, governance, and monitoring
- **Skill:** Design solutions for logging and monitoring
- **Task(s):** Recommend a logging solution
- **Source notes:** 13 NotebookLM notes from `certs/AZ-305/topics/Identity, governance, and monitoring/Logging and monitoring/Logging Solution/Notes`
- **Output location:** `certs/AZ-305/topics/Identity, governance, and monitoring/Logging and monitoring/Logging Solution/NotebookLM Study Sheet.md`

---

## Study focus

This task tests the ability to select the right log collection mechanism, workspace topology, table plan, retention strategy, and cost-control technique for a given scenario. The core design judgment is knowing which combination of AMA, DCRs, table plans, workspace count, and long-term retention satisfies both functional and non-functional requirements — particularly around cost, data residency, availability, and query capability.

---

## Product and concept coverage

| Product / concept | Why it matters for this task |
|---|---|
| Azure Monitor Agent (AMA) | The only supported agent for guest-OS log collection; legacy MMA/OMS is retired |
| Data Collection Rules (DCRs) | Centralized configuration for what AMA collects, how to transform it, and where to route it |
| Log Analytics workspace | The unit of query, retention, RBAC boundary, and billing for Azure Monitor Logs |
| Table plans (Analytics / Basic / Auxiliary) | Per-table controls that trade query capability for ingestion cost |
| Long-term retention (Archive) | In-workspace retention up to 12 years; data accessible via search jobs or restore, not interactive query |
| Workspace replication | Cross-region DR that keeps logs queryable during a regional outage; manual failover |
| Multiple workspaces + cross-workspace KQL | Architecture pattern forced by data residency, security separation, or RBAC requirements |
| Azure Arc | Extends Azure management (AMA deployment, DCRs) to on-premises and multi-cloud servers |
| Log Analytics gateway | Proxy that forwards AMA telemetry to Azure for servers without direct internet access |
| Network Watcher packet capture | Packet-level network forensics triggered programmatically via Azure Functions |
| Microsoft Sentinel (Analytics / Data Lake tiers) | Two-tier security log model: real-time detection (Analytics) vs. high-volume secondary storage (Data Lake) |
| ContainerLogV2 schema (AKS) | Required to make AKS container logs eligible for the Basic table plan |
| Azure Storage (log export) | Cheapest archival destination but not directly KQL-queryable in place |

---

## Core design patterns and decision rules

### Azure Monitor Agent and Data Collection Rules (DCRs)

- AMA is the only supported agent for collecting guest-OS data (Windows Event Logs, Syslog, custom file-based logs). The legacy Log Analytics agent is retired.
- AMA holds no local configuration. All collection instructions come from a DCR associated to the machine.
- A DCR defines three things: data sources (what to collect), transformations (KQL to reshape or filter in transit), and destinations (where to route the data).
- A single DCR can be associated to hundreds of VMs simultaneously. Use Azure Policy to automatically deploy the AMA extension and assign the DCR to all current and future VMs at scale.
- DCR ingestion-time transformations execute inside the ingestion pipeline before data lands in the workspace, enabling PII stripping, column dropping, and row filtering at the source. This reduces ingestion cost because filtered data is never billed.
- The retired legacy agent applied a blanket configuration and had no source-side filtering capability.

### Custom log collection from file-based sources

- To collect custom JSON or text log files written by an application on a Linux or Windows VM, use AMA with a DCR that specifies a JSON log (or custom log) data source type targeting the local file path.
- The DCR routes the collected records to a custom table in a Log Analytics workspace, making them queryable with KQL.

### Hybrid and on-premises log collection

- For on-premises servers, deploy AMA via Azure Arc. Arc extends Azure management (DCRs, policies, identity) to non-Azure machines with the same model used for native Azure VMs.
- If on-premises servers have no direct internet access, use a Log Analytics gateway as an internal forwarding proxy. Isolated servers send logs to the gateway; the gateway forwards to Azure.

### Table plan selection

| Scenario | Recommended plan | Reasoning |
|---|---|---|
| Alerts, dashboards, active monitoring, full KQL | Analytics | Default; full KQL, up to 730 days interactive retention |
| High-volume verbose logs, rarely queried, need 30-day KQL window | Basic | Cheaper ingestion; per-query scan charge; fixed 30-day interactive window |
| Very high-volume custom data, tolerate async search only | Auxiliary | Cheapest ingestion; no interactive query; no restore; search jobs only |

Key constraints on Basic and Auxiliary:

- Basic is only supported on eligible tables (certain Azure tables and DCR-based custom tables). Switching a table to Basic applies immediately and changes query behavior to a 30-day fixed window with per-scan charges.
- Auxiliary is only settable on DCR-based custom tables created via API. The plan cannot be changed after creation. Supports search jobs but not restore.
- Neither Basic nor Auxiliary are available on legacy per-node/per-GB pricing tiers.
- Auxiliary data is not replicated by Log Analytics workspace replication; it is not protected against regional failure.

### AKS container log cost optimization

- Migrating to AMA for AKS does not change table billing tiers or make container logs eligible for the Basic plan.
- To apply the Basic plan to AKS container logs (stdout/stderr), you must first enable the ContainerLogV2 schema on Container insights. ContainerLogV2 consolidates logs into a single table that is Basic-plan-compatible.
- Leave Kubernetes control plane logs in the Analytics plan so they can be used for real-time alerting.

### Long-term retention and archived data access

- Analytics table interactive retention can be set up to 730 days (2 years); reducing below 31 days does not save money because the first 31 days are included in the ingestion price.
- Long-term retention (formerly Archive) extends a table's total retention up to 12 years within the same workspace. Data past the interactive window drops into this lower-cost archive state automatically.
- Two access methods for archived data:
  - Search jobs — asynchronous; run directly against long-term retention data; pull matching records into a new temporary Analytics table; no full rehydration required.
  - Restore — synchronous rehydration into a hot cache for full interactive KQL over a selected time range. Supported on Analytics and Basic tables only (not Auxiliary).
- Azure Storage is cheaper than long-term retention for raw archival, but logs in Blob Storage cannot be queried directly with KQL. Long-term retention is the correct choice when the requirement is in-place KQL search on historical data.

### Workspace topology and data residency

- Default guidance: use a single centralized Log Analytics workspace to maximize KQL correlation and minimize management overhead.
- Only split into multiple workspaces when forced by one of these requirements:
  - Data residency / sovereignty — a workspace stores data exclusively in its creation region; EU data legally required to stay in the EU requires a separate EU workspace.
  - Security separation — separating SOC/security operations data from operational data.
  - Differing retention or RBAC requirements that cannot be satisfied within a single workspace.
- Multi-workspace environments use cross-workspace KQL queries to correlate data across regions without physically moving or copying the data out of its compliance boundary.

### Workspace replication (cross-region DR)

- Availability Zones provide in-region resilience only; they cannot protect against a full region outage.
- Log Analytics workspace replication (now GA) creates a secondary workspace in another region and actively ingests logs into both simultaneously.
- During a regional outage: switch to the secondary workspace; KQL queries, dashboards, alerts, and Sentinel continue to function normally.
- Failover is manual — the operator must monitor primary workspace health and trigger the switchover.
- Auxiliary table data is not replicated. Design around this if high-availability is required.
- Continuous export to GRS/GZRS Azure Storage preserves data but does not satisfy queryable during outage requirements.

### Microsoft Sentinel: Analytics tier vs. Data Lake tier

- Sentinel uses a two-tier model:
  - Analytics tier — real-time detection, alerting, and hunting; full KQL; higher cost.
  - Data Lake tier — optimized for high-volume secondary security data (firewall logs, NetFlow, cloud storage access logs) that do not require real-time alerting; lower cost; KQL-queryable in place via KQL jobs.
- Moving Sentinel logs to Azure Storage saves cost but removes in-place KQL capability and breaks the native Sentinel query workflow.
- Use the Data Lake tier when the security data is needed for investigations and baseline building but not for live detection rules.

### Automated network forensics

- Network Watcher packet capture collects actual packet-level payload data (vs. NSG flow logs, which capture 5-tuple metadata only). Captures are configurable with a time limit (e.g., 600 seconds).
- Event-driven workflow: alert rule → Action Group → Azure Function → Network Watcher API call → packet capture stored as `.cap` file in Azure Blob Storage.
- This pattern ensures forensic evidence is captured automatically at the moment a threat is detected, without manual intervention.

---

## Service and feature tradeoffs

| Scenario or requirement | Recommended choice | Why |
|---|---|---|
| Guest-OS logs (Windows Events, Syslog, custom files) | AMA + DCR | Only supported guest-OS collection path; legacy agent retired |
| On-premises servers, no internet access | AMA + Azure Arc + Log Analytics gateway | Arc provides management plane; gateway proxies telemetry to Azure |
| Drop noisy event IDs before ingestion | DCR KQL transformation | Filters in transit; dropped data never billed |
| Mask or strip PII before workspace storage | DCR KQL transformation | Runs before data lands; PII never stored or queryable |
| High-volume verbose logs, need 30-day KQL, rare queries | Basic table plan | Cheaper ingestion; per-scan query charge; 30-day fixed window |
| Very high-volume data, async search acceptable | Auxiliary table plan | Cheapest ingestion; no interactive query; permanent plan choice |
| Retain logs for 5+ years, occasional in-place KQL search | Long-term retention + search jobs | Up to 12 years in-workspace; search jobs access archive without full rehydration |
| Retain logs for 5+ years, no query needed | Azure Storage archive | Cheapest raw archival; not KQL-queryable in place |
| Cross-region DR with logs queryable during outage | Workspace replication | Simultaneous dual-region ingestion; KQL available after manual failover |
| EU data sovereignty + centralized operations visibility | Regional workspaces + cross-workspace KQL | Data stays in EU; cross-workspace queries provide unified view |
| Real-time threat detection in Sentinel, cost-optimize volume | Analytics tier + Data Lake tier | Keep detection data in Analytics; shift secondary high-volume logs to Data Lake |
| AKS container log cost reduction | Enable ContainerLogV2 schema + Basic plan | ContainerLogV2 unlocks Basic plan eligibility for container logs |
| Packet-level forensics triggered by security alert | Network Watcher packet capture + Azure Functions | Functions bridge alert to Network Watcher API; stores `.cap` in Blob Storage |

---

## Cost, retention, and operations facts

### Table plan cost model

- Analytics: High ingestion cost; per-GB billing; first 31 interactive days included; full KQL, alerts, dashboards. Interactive retention 30–730 days.
- Basic: Lower ingestion cost; per-GB-scanned query charge; fixed 30-day interactive window only. Eligible tables only; switch applies immediately to existing data.
- Auxiliary: Lowest ingestion cost; DCR-based custom tables via API only; plan is permanent; search jobs only; no restore; not replicated.

### Long-term retention

- Extends any table up to 12 years total retention within the workspace.
- Data past the interactive period is in archive state: not interactively queryable, accessible only through search jobs (async, no rehydration) or restore (Analytics/Basic only).
- Restore rehydrates a selected time range into a hot cache; incurs additional cost.
- Reducing Analytics interactive retention below 31 days does not reduce ingestion billing.

### Workspace replication

- Workspace replication is now GA.
- Auxiliary table data is excluded from replication.
- Requires manual failover; no automatic switchover.

### DCR transformations

- Filtering rows and dropping columns at the DCR level reduces ingestion volume, directly lowering ingestion costs.
- A single DCR can be shared across hundreds of VMs; Azure Policy enforces assignment at scale.

---

## Security, compliance, and residency facts

- A Log Analytics workspace stores all its data in the Azure region where it was created. Data never leaves that region unless explicitly exported.
- Regulatory requirements for EU data residency require a workspace deployed in an EU region (e.g., North Europe, West Europe).
- DCR ingestion-time transformations are the recommended pattern for PII masking; they prevent sensitive data from ever being written to storage.
- Workspace-context vs. resource-context access control governs whether users can query all data in a workspace or only data belonging to resources they own.
- Auxiliary tables are not protected by workspace replication, making them unsuitable for high-availability security logging.

---

## Common wrong-answer patterns

| Wrong assumption | Why it fails | Correct reasoning |
|---|---|---|
| Use Auxiliary plan for any high-volume logs needing occasional query | Auxiliary has no interactive query; search jobs only; plan can't be changed | Use Basic plan when 30-day ad-hoc KQL is required |
| Migrate to AMA to reduce AKS log costs | AMA migration alone does not change table billing tiers | Enable ContainerLogV2 schema to unlock Basic plan eligibility for container logs |
| Export logs to Azure Storage for long-term retention with in-place KQL search | Logs in Azure Storage are not directly KQL-queryable | Use Log Analytics long-term retention with search jobs for in-place archive access |
| Use Availability Zones to protect logs against region-wide outage | AZs provide in-region protection only | Use workspace replication for cross-region DR that keeps logs queryable |
| Continuous export to GRS storage satisfies queryable during outage | Logs in Storage can't be queried with KQL without processing | Workspace replication is the only native feature satisfying this requirement |
| Move Sentinel security logs to Azure Storage to reduce cost | Storage is not KQL-queryable in Sentinel's native environment | Use Sentinel Data Lake tier: lower cost but retains in-place KQL query capability |
| A single global workspace satisfies all scenarios | Data residency requirements legally prohibit storing EU data in a US workspace | Split into region-specific workspaces and use cross-workspace KQL for correlation |
| Flip any table to Basic or Auxiliary to save money | Auxiliary is permanent and custom-table-only; Basic requires eligible tables | Plan selection must match table eligibility and query requirements |

---

## KQL, CLI, and configuration notes

Cross-workspace query syntax:

```kql
union workspace("eastus-workspace").SecurityEvent,
      workspace("northeurope-workspace").SecurityEvent
| where TimeGenerated > ago(1d)
| summarize count() by Computer
```

DCR transformation example — drop rows by event ID:

```kql
source
| where EventID !in (4624, 4625, 4672)
```

DCR transformation example — strip a PII column:

```kql
source
| project-away UserPrincipalName
```

Search job (run against long-term retention):

```kql
SecurityEvent
| where TimeGenerated between (datetime(2022-01-01) .. datetime(2022-03-31))
| where EventID == 4625
```

Search jobs execute asynchronously and write results to a new `*_SRCH` table in the workspace.

---

## Highest-yield exam checklist

- [ ] AMA is the only supported agent for guest-OS log collection; legacy Log Analytics agent is retired
- [ ] DCR defines data sources, transformations (KQL), and destinations; AMA reads from DCR, not from local config
- [ ] DCR KQL transformations run before data lands in the workspace — dropped rows are never billed
- [ ] Basic plan: cheaper ingestion, per-scan query charge, fixed 30-day interactive window, eligible tables only
- [ ] Auxiliary plan: cheapest ingestion, no interactive query, search jobs only, DCR-based custom tables via API, plan is permanent
- [ ] Auxiliary data is not replicated by workspace replication
- [ ] Long-term retention extends up to 12 years in-workspace; archived data accessible via search jobs (no rehydration) or restore
- [ ] Search jobs are asynchronous; restore is synchronous (hot cache); restore is not available on Auxiliary tables
- [ ] Reducing Analytics interactive retention below 31 days does not save money (31 days included in ingestion price)
- [ ] Workspace replication provides cross-region DR with simultaneous dual ingestion; failover is manual; now GA
- [ ] Continuous export to GRS storage preserves data but logs are not queryable with KQL during an outage
- [ ] Single workspace is the default; only split for data residency, security separation, or differing retention/RBAC
- [ ] Cross-workspace KQL queries unify multi-workspace visibility without moving data out of its residency boundary
- [ ] Azure Arc + Log Analytics gateway = the pattern for on-premises servers without internet access
- [ ] ContainerLogV2 schema is required before AKS container logs can be switched to the Basic plan
- [ ] Sentinel Data Lake tier = low-cost, KQL-queryable secondary storage; Azure Storage = no in-place KQL
- [ ] Network Watcher packet capture + Azure Functions = event-driven automated forensic evidence collection
