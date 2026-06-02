Let me confirm the exact skill wording from the official study guide.I have enough on the study guide structure. Let me validate a few of the canonical documentation URLs before finalizing.Here is the focused documentation map for the task you provided.

A quick note on classification: the official study guide groups this under the domain "Design identity, governance, and monitoring solutions." Microsoft's own learning content lists the skill as "Design a solution for logging and monitoring," with "Recommend a logging solution" as a task under it. I have used that wording.

---

## Domain: Design identity, governance, and monitoring solutions

### Skill: Design a solution for logging and monitoring

#### Task: Recommend a logging solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview> | Anchors the design decision. Azure Monitor is the unified service that collects and acts on logs across Azure and hybrid resources, and is the default starting point for any logging recommendation. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs> | Covers Azure Monitor Logs and the Log Analytics workspace, the primary log store. Supports workspace design, KQL querying, retention, and cost tradeoffs that drive most logging recommendations. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/platform-logs-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/platform-logs-overview> | Explains the log sources to plan for: activity logs, resource logs, and Entra logs. Needed to scope what data a logging solution must capture. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/create-diagnostic-settings) | <https://learn.microsoft.com/en-us/azure/azure-monitor/platform/create-diagnostic-settings> | Diagnostic settings are the routing mechanism that sends logs to a workspace, storage, or event hub. Central to deciding where logs land and why. |
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) | <https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview> | Application Insights handles application-level logging and telemetry. Relevant when the logging recommendation must cover app code and request traces, not just infrastructure. |
| [Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/overview) | <https://learn.microsoft.com/en-us/azure/sentinel/overview> | The SIEM layer built on Log Analytics. Supports the design choice of whether security log aggregation and threat detection belong in the logging solution. |
| [Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction) | <https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction> | Generates security findings and audit logs. Useful for distinguishing security logging needs from general operational logging when recommending a solution. |
| [Azure Data Explorer](https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview) | <https://learn.microsoft.com/en-us/azure/data-explorer/data-explorer-overview> | An alternative for high-volume or long-retention log analytics. Supports the cost and scale tradeoff against a standard Log Analytics workspace. |
| [Azure Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-overview) | <https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-overview> | The low-cost destination for long-term log archival and compliance retention. A common piece of a tiered logging design. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about) | <https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about> | The streaming path for exporting logs to third-party or external SIEM tools. Relevant when the design must integrate non-Azure logging systems. |
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview) | <https://learn.microsoft.com/en-us/azure/governance/policy/overview> | Used to deploy diagnostic settings at scale so logging is enforced consistently across subscriptions. Supports the governance dimension of the recommendation. |
| [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/) | <https://learn.microsoft.com/en-us/azure/well-architected/> | Provides operational excellence and observability design guidance. Useful for justifying a logging recommendation against reliability, cost, and operations principles. |

Potentially relevant products considered: Azure Monitor, Azure Monitor Logs (Log Analytics), platform and resource logs, diagnostic settings, activity log, Application Insights, Microsoft Sentinel, Microsoft Defender for Cloud, Azure Data Explorer, Azure Blob Storage, Azure Event Hubs, Azure Policy, Cloud Adoption Framework, Azure Well-Architected Framework.

Forum-discovery note: Public candidate discussions consistently point to Log Analytics workspace design, diagnostic settings, KQL, and the three log destinations (workspace, storage, event hub) as recurring logging themes, along with Sentinel for security scenarios. These were used only as discovery signals and validated against official Microsoft documentation before inclusion. No exam-dump, forum, or blog links appear in the table.

Coverage notes:

- This task is concentrated in one primary documentation set. Most of what you need lives under Azure Monitor, which is why several rows repeat that set for distinct concepts (log store, log sources, routing, application logs).
- The single most important distinction to study is logging versus monitoring. For this task, focus on what gets collected, where it is routed, and how long it is retained, rather than alerting and dashboards.
- Download first: Azure Monitor, then Microsoft Sentinel and Azure Policy. Those cover the workspace, the security log layer, and at-scale enforcement that exam scenarios lean on.
- Lightly covered but testable: Azure Data Explorer, Event Hubs, and Blob Storage usually appear as destination or scale tradeoffs rather than as primary answers, so a working understanding of when each is the right destination is enough.
