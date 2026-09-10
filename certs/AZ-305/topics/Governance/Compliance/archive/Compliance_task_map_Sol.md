## Domain: Design identity, governance, and monitoring solutions

### Skill: Design governance

#### Task: Recommend a solution for managing compliance

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview) | <https://learn.microsoft.com/en-us/azure/governance/policy/overview> | Establishes Azure Policy as the primary service for enforcing organizational standards, evaluating compliance at scale, and automatically remediating resources. |
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance) | <https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance> | Explains regulatory-compliance initiatives, compliance domains, controls, and Microsoft, customer, and shared responsibilities. |
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics) | <https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics> | Supports selection among audit, deny, modify, deployIfNotExists, and other effects when designing compliance guardrails. |
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data) | <https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data> | Covers compliance evaluation, reporting, on-demand scans, Policy Insights, Azure Monitor integration, and Resource Graph queries. |
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources) | <https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources> | Explains how `modify` and `deployIfNotExists` policies bring existing noncompliant resources into compliance. |
| [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure) | <https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure> | Supports controlled exception and waiver design, including expiration, scope, justification, and initiative-specific exemptions. |
| [Azure Management Groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview) | <https://learn.microsoft.com/en-us/azure/governance/management-groups/overview> | Supports applying inherited compliance controls consistently across multiple subscriptions. |
| [Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-regulatory-compliance-standards) | <https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-regulatory-compliance-standards> | Explains continuous security-standard assessment and the mapping of recommendations to regulatory controls. |
| [Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard) | <https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard> | Covers compliance dashboards, gap investigation, remediation, reports, certificates, continuous export, and workflow integration. |
| [Microsoft cloud security benchmark](https://learn.microsoft.com/en-us/security/benchmark/azure/introduction) | <https://learn.microsoft.com/en-us/security/benchmark/azure/introduction> | Provides Microsoft’s security-control baseline and mappings to frameworks such as CIS, NIST, and PCI DSS. |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/govern/enforce-cloud-governance-policies) | <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/govern/enforce-cloud-governance-policies> | Provides architecture guidance for inheritance, monitor-first rollout, automated enforcement, policy as code, and governance operating models. |
| [Azure compliance](https://learn.microsoft.com/en-us/azure/compliance/) | <https://learn.microsoft.com/en-us/azure/compliance/> | Identifies Azure compliance offerings, certifications, attestations, and regulatory documentation for determining whether Azure meets external requirements. |
| [Microsoft Purview Compliance Manager](https://learn.microsoft.com/en-us/purview/compliance-manager) | <https://learn.microsoft.com/en-us/purview/compliance-manager> | Supports broader multicloud and Microsoft 365 compliance assessments, improvement actions, evidence collection, auditor reporting, and responsibility tracking. |
| [Azure Resource Graph](https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview) | <https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview> | Supports estate-wide inventory, policy-impact analysis, compliance queries, dashboards, and reporting across subscriptions. |
| [Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/architecture/hybrid/azure-arc-hybrid-config) | <https://learn.microsoft.com/en-us/azure/architecture/hybrid/azure-arc-hybrid-config> | Extends Azure Policy, machine configuration, and Defender for Cloud compliance controls to hybrid and multicloud servers. |

Potentially relevant products considered: Azure Policy, policy initiatives, built-in regulatory standards, policy effects, remediation tasks, policy exemptions, Azure Management Groups, Microsoft Defender for Cloud, Microsoft cloud security benchmark, Azure Resource Graph, Azure Monitor, Azure Landing Zones, Cloud Adoption Framework, Azure compliance offerings, Service Trust Portal, Microsoft Purview Compliance Manager, Azure Arc, machine configuration, Azure RBAC, and policy as code.

Forum-discovery note: Public candidate discussions commonly identify Azure Policy, management groups, Microsoft Defender for Cloud, regulatory standards, and governance design as important AZ-305 coverage. These discussions were used only as discovery signals; every included topic was validated against official Microsoft documentation.

Coverage notes:

- Azure Policy is the primary documentation set for this task. Download it first; the multiple Azure Policy rows represent distinct design concerns contained within the same documentation set.
- Microsoft Defender for Cloud is the next priority when requirements involve security frameworks, continuous assessment, compliance dashboards, or multicloud posture.
- Cloud Adoption Framework guidance is especially valuable for design questions involving scope, inheritance, operating responsibility, phased enforcement, or policy as code.
- Azure compliance documentation establishes Microsoft’s certifications and audit scope; it does not enforce the customer’s resource configurations.
- Microsoft Purview Compliance Manager is most relevant when requirements extend beyond Azure resource configuration into assessments, evidence, data protection, Microsoft 365, or auditor workflows.
- Azure Resource Graph and Azure Arc are secondary coverage areas for large-scale reporting and hybrid or multicloud compliance, respectively.
