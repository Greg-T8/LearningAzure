# Landing Zone Technical Guide

## Scope and study objectives

This guide consolidates the governance notes for AZ-305 Domain **Design identity, governance, and monitoring solutions**, Skill **Design governance**, and the task of recommending management-group, subscription, resource-group, and tagging strategies. It treats the Azure landing zone as a policy and access model for a multi-subscription estate—not as an organizational chart or a collection of individual resource deployments. The source notes covered management-group design, hierarchy operations, Azure Policy, RBAC, naming, limits, and cost allocation.

The architecture decision starts with the boundary that needs different policy, access, connectivity, compliance, scale, or lifecycle treatment. Choose the smallest scope that provides that boundary: management group for a common subscription archetype, subscription for a management and isolation boundary, resource group for a shared lifecycle, and tags for cross-cutting metadata. [Management groups](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups) and [Azure Resource Manager management scopes](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview) define these roles.

## Missed-question priorities

The following concepts came from notes that explicitly identified an incorrect answer. Learn the decision rule, rather than only the fact.

| Misconception | Correct rule | Why the distinction matters |
|---|---|---|
| RBAC cannot assign a principal across separate Platform branches. | Azure RBAC assignments can be made at multiple scopes; effective permissions are additive. | Split a Platform branch only for genuine regulatory, security, or operational separation—not because RBAC cannot span branches. [Azure RBAC scope](https://learn.microsoft.com/en-us/azure/role-based-access-control/scope-overview) |
| A non-root-to-non-root subscription move needs no source-parent permission. | The mover needs permissions on the child, target parent, and current parent. The root exception applies only when the existing or target parent is the tenant root group. [Move management groups and subscriptions](https://learn.microsoft.com/en-us/azure/governance/management-groups/manage) | A migration can fail before governance is evaluated, or remove inherited access after it succeeds. |
| Cost Management tag inheritance updates ARM resource tags. | Cost Management inheritance applies tags to usage records; Azure Policy `modify` changes resource properties and needs remediation for existing resources. [Group and allocate costs using tag inheritance](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/enable-tag-inheritance) | Chargeback completeness and resource-governance compliance are related but separate controls. |
| An 800-subscription limit exists per management group. | A management group can contain unlimited subscriptions. The management-group hierarchy limit is root plus six levels, and a tenant can have 10,000 management groups. [Azure subscription and service limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits) | Do not introduce arbitrary hierarchy or subscription sharding for a nonexistent management-group subscription limit. |
| The tenant root group ID can be renamed, or a Global Administrator automatically has the needed Azure RBAC access. | The root management-group ID is the tenant ID and is immutable; its display name can be changed. Microsoft Entra directory privilege and Azure RBAC are separate. [Management groups overview](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview) | Use the correct identity property and obtain the required management-group permission before changing the hierarchy. |
| Tenant-root policy is unsupported, or policy must begin lower in the tree. | Root-level policy and RBAC assignments are supported, but should be **must-have only** because they apply directory-wide. [Management groups overview](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview) | A mistaken root-level Deny policy has tenant-wide blast radius and creates exclusion complexity. |
| A support request can raise the 800-resources-of-one-type limit in a resource group. | That resource-group limit is hard; partition resources across resource groups while preserving appropriate lifecycle boundaries. [Azure subscription and service limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits) | Distinguish adjustable service quota from a platform limit before proposing escalation. |

## Landing-zone hierarchy and core concepts

An Azure landing zone provides a repeatable foundation for governing, securing, and scaling workloads across subscriptions. The hierarchy exists to deliver inherited Azure Policy and RBAC where subscriptions genuinely share a workload archetype; it should remain deliberately shallow. [What is an Azure landing zone?](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/) 

```text
Tenant root group (must-have global assignments only)
└── Intermediate root
    ├── Platform
    │   ├── Identity
    │   ├── Management
    │   ├── Security
    │   └── Connectivity
    └── Landing zones
        ├── Corp
        ├── Online
        └── Sandbox
```

* **Tenant root group:** The tenant root is created automatically. Its management-group ID is the Microsoft Entra tenant ID and cannot be changed; its display name is a friendly property that can be changed. Root assignments inherit through the directory, so apply only controls with a true tenant-wide requirement. [Management groups overview](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)
* **Intermediate root:** Put the organization-specific landing-zone hierarchy immediately below the tenant root. This lets an organization apply baseline governance without using the tenant root as the routine workload-governance scope. [Management groups in Azure landing zones](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups)
* **Platform:** Centralized platform subscriptions host shared capabilities such as connectivity, identity, management/monitoring, and security tooling. Keep the Platform group shared whenever allowed; splitting part of it for a regulated boundary means partially replicating policy, operations, and role-assignment maintenance.
* **Landing zones:** This parent contains workload subscriptions and workload-agnostic guardrails such as activity-log collection, baseline security monitoring, approved locations, and core governance metadata.

### How to select a management-group boundary

Management groups organize subscriptions that need the same security, compliance, connectivity, feature, policy, and access configuration. The recommended design is horizontal: add a peer branch for a distinct governance archetype, not another level for every business unit, department, region, project, or environment. [Management group recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups)

| Need | Preferred boundary | Reason |
|---|---|---|
| Shared policy and RBAC for a class of subscriptions | Management group | Inheritance makes the control consistent across the class. |
| Billing, quota, isolation, delegated administration, or workload-scale boundary | Subscription | A subscription is a management, policy, quota, billing, and access boundary. [Subscription design](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions) |
| Resources deployed, administered, and removed together | Resource group | Resources in a group should share lifecycle, administration, policy, and deployment requirements. [Resource groups](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview) |
| Ownership, cost, purpose, classification, or reporting dimension spanning the hierarchy | Tags | Tags provide horizontal discovery and reporting without making the tree deeper. [Define your tagging strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging) |

> **Exam discriminator:** Do not mirror the corporate organization chart in management groups. A business unit normally needs tags and possibly a subscription; it needs a management group only when its subscriptions require a distinct inherited governance or access model.

### Workload archetypes: Corp, Online, and Sandbox

Each child of the Landing zones group inherits the common baseline, then adds controls appropriate to its workload type. This is why these branches should be peers.

| Archetype | Defining need | Representative guardrails |
|---|---|---|
| **Corp** | Private or hybrid connectivity with the corporate network through centrally managed connectivity. | Restrict direct public exposure; require approved private connectivity, private endpoints where applicable, and controlled egress. |
| **Online** | Direct internet inbound/outbound connectivity or a workload that might not need a virtual network. | Permit deliberate public ingress, but require protection, encryption, logging, and monitored edge controls such as WAF and DDoS design. |
| **Sandbox** | Isolated experimentation and proof-of-concept work. | Keep inherited audit/security baseline, isolate networks, set budgets and expiration expectations, and avoid broad controls that prevent service evaluation. [Sandbox environments](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/sandbox-environments) |

> **Architectural interpretation:** A policy assigned to the Landing zones parent also applies to Sandbox. Put only safe, workload-agnostic controls there; place private-endpoint or production-network requirements at Corp/Online when they would defeat sandbox experimentation.

### Platform-group tradeoff

The Platform branch commonly separates Connectivity, Management, Identity, and Security because each has a distinct operator model and resource set. Identity can apply VM hardening, backup, monitoring, and network-isolation controls; Connectivity can govern virtual WAN, firewall, gateways, DNS, and DDoS; Management can govern Log Analytics and Automation; Security can govern SIEM, Event Hubs, Key Vault, and security automation.

* **Share the platform by default:** A common platform keeps shared services, baseline policy, and administration centralized.
* **Split only for a true boundary:** Regulatory, sovereignty, or security requirements can justify a separate identity/security or connectivity branch.
* **Do not cite RBAC as the reason to split:** A principal can have role assignments at multiple management groups. Splitting increases operational burden because the partially replicated branches need synchronized policy, RBAC, monitoring, and change control. [Azure RBAC scope](https://learn.microsoft.com/en-us/azure/role-based-access-control/scope-overview)

## Management-group mechanics, limits, and operations

Management groups form a single-parent hierarchy within one Microsoft Entra tenant. Policy and RBAC assignments inherit downward, which makes hierarchy placement a security and operational decision rather than a visual organization exercise. [Management groups overview](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)

| Constraint or behavior | Current rule | Design consequence |
|---|---|---|
| Parentage | A management group or subscription has one direct parent management group. | Moving it changes inherited controls. |
| Hierarchy depth | Tenant root plus six management-group levels; subscriptions are not included in the six levels. | Keep the tree flatter than the hard limit to preserve explainability. |
| Management groups per tenant | 10,000. | Count rarely drives normal architecture; shared governance does. |
| Subscriptions per management group | Unlimited. | Do not add branches merely to distribute subscriptions. |
| Tags on a management group | Not supported. | Store management-group classification elsewhere; tag subscriptions, resource groups, and supported resources. [Use tags to organize Azure resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources) |
| Root assignment scope | Policies and RBAC are supported and inherited directory-wide. | Make them must-have only. |

### Creating management groups

By default, users can create management groups and become Owner of the group they create. If the tenant-root hierarchy setting **Require write permissions for creating new management groups** is enabled, creation requires `Microsoft.Management/managementGroups/write` at the root scope. A subscription-level Owner role does not travel upward to satisfy that check. [Protect your resource hierarchy](https://learn.microsoft.com/en-us/azure/governance/management-groups/how-to/protect-resource-hierarchy)

1. Decide whether a new peer branch is justified by a distinct policy/access archetype.
2. Confirm the creator has the required management-group-scope permission if hierarchy protection is enabled.
3. Place the group under the intended parent and assign only the baseline appropriate to that scope.
4. Verify the group does not create accidental policy inheritance for existing subscriptions.

### Moving a subscription safely

Moving a subscription between management groups changes what it inherits. The move does not convert inherited role assignments into direct assignments; access granted only from the old parent disappears when the subscription leaves that branch. [Move management groups and subscriptions](https://learn.microsoft.com/en-us/azure/governance/management-groups/manage)

1. **Inventory effective policy and RBAC** at the current and target paths, including ancestors.
2. **Preserve required access first.** Create a direct subscription assignment or an appropriate target-parent assignment before moving if users rely on old-parent inherited access.
3. **Validate permissions for the move.** The mover needs the required child, target-parent, and current-parent permissions. If either parent is the tenant root group, permissions on the root itself are excepted. [Move permission requirements](https://learn.microsoft.com/en-us/azure/governance/management-groups/manage#move-management-groups-and-subscriptions)
4. **Move the subscription, not merely an adjacent management group,** when the requirement is to change the subscription's placement.
5. **Re-evaluate access and compliance** after the move. The subscription begins inheriting policies and RBAC from the new parent and its ancestors.

> **Failure condition:** Moving a legacy management group under a new cloud-native group can expose all subscriptions still inside Legacy to the new policies. It does not by itself satisfy a requirement to place the subscriptions directly in the new branch.

### Subscription and resource-group scale

Subscriptions are the preferred scale and isolation boundary when a workload needs different billing, quotas, policy, RBAC, security, or lifecycle treatment. Subscription vending makes placement repeatable by capturing ownership, budget, network, classification, RBAC, quota, and management-group parameters at provisioning time. [Subscription vending](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending)

* **Resource-group lifecycle:** Group resources that deploy, update, receive policy, and delete together. Do not partition a workload solely for visual organization.
* **Hard resource-group limit:** A resource group can contain 800 instances of a specific resource type. If that ceiling is the constraint, partition across multiple resource groups while keeping each partition's lifecycle coherent. [Azure subscription and service limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits)
* **Quota versus limit:** Service quotas can be adjustable; hard platform limits require a design change. Do not promise a support-request increase without checking the current service-limit classification.

## Azure Policy, RBAC, naming, and locks

Azure Policy controls which resource configurations are allowed or required. Azure RBAC controls who can perform actions at a scope. Resource locks protect control-plane changes or deletion. These controls complement each other; a contributor who is authorized to deploy can still be blocked by a Deny policy. [Azure Policy overview](https://learn.microsoft.com/en-us/azure/governance/policy/overview)

| Control | Primary question | Example |
|---|---|---|
| Azure RBAC | Who can create or manage a resource? | Give a workload team Contributor at its subscription. |
| Azure Policy | Which state is permitted or required? | Deny an unapproved location or deploy diagnostics when missing. |
| Resource lock | Can the control plane delete or modify this protected object? | Protect a shared hub resource group from accidental deletion. |

### Effect selection

Policy effects have different enforcement and remediation behavior. Treat `Audit` as evidence gathering and `Deny` as a preventative control; neither is a substitute for thoughtful rollout and scope selection.

| Effect | Request-time behavior | Existing-resource outcome | Best use in this topic |
|---|---|---|---|
| `Audit` / `AuditIfNotExists` | Allows the request and reports noncompliance. | Reports compliance state. | Measure a proposed baseline before enforcing it. |
| `Deny` | Blocks a noncompliant create or update request. | Does not rename or repair existing resources. | Allowed locations, prohibited public exposure, or a service-specific naming rule. |
| `Append` | Adds a property to the incoming request; a conflicting value can cause denial. | Existing resources are evaluated but not changed. | Additive properties, especially arrays, when no repair is required. [Append effect](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-append) |
| `Modify` | Adds, replaces, or removes supported properties/tags during create or update. | Can remediate existing resources with an assignment identity and permissions. | Tag inheritance, tag normalization, and repair of existing tag drift. [Modify effect](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-modify) |
| `DeployIfNotExists` | Evaluates for a related configuration and can deploy it when absent. | Remediation can deploy the missing configuration. | Diagnostic settings and other required dependent configurations. [DeployIfNotExists effect](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deploy-if-not-exists) |

### Naming policy

Naming is a preventive design concern because most Azure resources cannot be renamed in place. Use a custom, service-specific policy with `Deny` after an audit phase when a naming standard must be enforced at deployment. Azure Policy's name matching operators are pattern matching, not full regular expressions. [Policy rule structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-policy-rule) 

* **Use a separate pattern per resource type or category.** Storage accounts, virtual networks, resource groups, and Key Vaults have different length, character, uniqueness, and DNS constraints. [Naming rules and restrictions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules)
* **Do not expect Modify or Append to rename a resource.** A noncompliant physical name normally requires redeployment under a compliant name.
* **Pilot with Audit.** Examine false positives, child resources created by Azure, and deployment tooling before moving to Deny.
* **Use tags for information that need not be encoded into the physical name.** This avoids an unwieldy universal naming expression.

## Tagging strategy and FinOps

Tags are key/value metadata on subscriptions, resource groups, and supported resources. They are plaintext, do not automatically inherit, and should never contain secrets or sensitive data. Azure normally supports up to 50 tag pairs per subscription, resource group, or resource; use a concise taxonomy rather than a large mandatory checklist. [Use tags to organize Azure resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources)

### Tag taxonomy and authoritative scope

Put each tag at the highest scope where its value is true, then inherit only if it remains true for the child. The resource group is commonly the workload-metadata boundary; a resource can become more specific than its group.

| Tag category | Question answered | Examples | Recommended authoritative scope |
|---|---|---|---|
| Functional | What technical function/context is this? | `application`, `environment`, `tier`, `region` | Resource group for application/environment; resource for tier/actual region. |
| Classification | What protection or service expectation applies? | `criticality`, `dataclassification`, `sla`, `regulatorycompliance` | Resource group when homogeneous; resource when it differs. |
| Accounting | Where should costs be allocated? | `costcenter`, `department`, `billingcode` | Subscription only when uniform; otherwise resource group. |
| Purpose | Why does it exist and what value does it provide? | `businessprocess`, `businessimpact`, `revenueimpact` | Usually resource group/workload. |
| Ownership | Who is accountable or operates it? | `businessunit`, `opsteam` | Subscription for broad ownership; resource group for workload operations. |

**Purpose is not ownership.** `businessunit` and `opsteam` identify accountable parties. `businessprocess`, `businessimpact`, and `revenueimpact` identify business function and value. A chargeback design often needs both, plus an accounting tag such as `costcenter`. [Define your tagging strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)

### Inheritance and enforcement pattern

Use Azure Policy to make operational tags real resource properties. Built-in policies can require tags and inherit a tag from a subscription or resource group; `if missing` semantics preserve a legitimate child value. [Policy definitions for tagging resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-policies)

1. **Define a minimal required schema.** A practical base includes `businessunit`, `costcenter`, `application`, `environment`, `criticality`, `opsteam`, and `dataclassification`; include `region` only with a reliable source for its actual value.
2. **Set the authoritative value.** For example, set a uniform `businessunit` at subscription, workload values at resource group, and resource-specific classification at the resource.
3. **Use `Modify` to inherit defaults.** Use `add` when a child value must be preserved; use `addOrReplace` only where a parent must be authoritative. [Modify operations](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-modify#modify-operations)
4. **Assign an identity and grant remediation permissions.** Existing noncompliant resources are not automatically rewritten simply because a Modify assignment exists; create a remediation task after validating the policy.
5. **Progress from Audit to Modify/inherit to Require/Deny.** This reduces false positives and disruption while the taxonomy matures.

> **Documentation correction:** Subscription-to-resource and resource-group-to-resource built-ins do not automatically create a universal subscription-to-resource-group-to-resource chain. If subscription tags must populate resource groups, design and test a scoped custom Modify policy, then use the appropriate downstream inheritance policy.

### `Modify` versus `Append` for tags

`Modify` is the default policy effect for tag governance because it has more operations and supports remediation of existing resources. `Append` can be appropriate for an additive incoming property, especially an array element, but cannot repair deployed resources. [Modify effect guidance](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-modify)

| Requirement | Correct effect/design | Why |
|---|---|---|
| Add a missing `CostCenter` tag to new resources and backfill existing resources | `Modify` plus remediation | It writes the tag and can remediate drift. |
| Preserve a valid child-specific tag value | `Modify` with `add`, or an `if missing` built-in | It establishes a default without overwriting. |
| Force the child to equal an authoritative parent value | `Modify` with `addOrReplace` | It can replace a conflicting value. |
| Add a required member to an array in an incoming request, with no historical repair need | `Append` | This is an additive request transformation. |
| Repair a bad resource name | Redeploy under a compliant name; use Deny prospectively | Tags are modifiable; physical names generally are not. |

### Cost Management is a different inheritance system

Cost Management tag inheritance is for financial allocation, not ARM resource configuration. It can add subscription, resource-group, and—in supported MCA contexts—billing-profile or invoice-section tags to **usage records**. It does not write tags to the Azure resource. [Group and allocate costs using tag inheritance](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/enable-tag-inheritance)

| Requirement | Primary mechanism |
|---|---|
| A tag must be visible on a resource and evaluated for governance | Azure Policy `Modify`; use remediation for existing resources. |
| Cost data needs a parent tag when a resource does not emit its own tag consistently | Cost Management tag inheritance. |
| Departmental costs in a shared subscription | Required/inherited accounting tags, Cost Analysis grouped by tag, budgets, and exports. |
| Invoices, payment methods, agreements, billing profiles, and invoice sections | Cost Management + Billing billing-administration experience. |
| Day-to-day cost analysis, budgets, exports, allocation, and tag inheritance configuration | Cost Management at a supported scope. [Cost Management scopes](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/understand-work-scopes) |

> **Operational recommendation:** Enable both Azure Policy tag governance and Cost Management tag inheritance when chargeback must be complete. The former makes resource metadata reliable; the latter improves cost-record allocation for services that do not expose resource tags consistently.

## Policy placement, rollout, validation, and troubleshooting

Policy placement follows the same boundary logic as the hierarchy. Place a rule at the lowest common ancestor of every scope that truly needs it, and evaluate how an assignment affects Sandbox before assigning it to the Landing zones parent. [Azure Policy overview](https://learn.microsoft.com/en-us/azure/governance/policy/overview)

| Scope | Appropriate policy class | Avoid |
|---|---|---|
| Tenant root | Must-have, low-variance global requirements. | Routine workload Deny policies or rules with many exceptions. |
| Intermediate root | Organization-wide landing-zone baseline. | Service-specific workload design rules. |
| Platform | Shared platform requirements. | Workload policies that do not apply to platform subscriptions. |
| Landing zones | Workload-agnostic monitoring, security baseline, tagging, and location controls. | Controls that prevent all sandbox experimentation. |
| Corp | Private/hybrid connectivity and non-public workload posture. | Rules designed for public web ingress. |
| Online | WAF, DDoS, TLS, logging, and controlled public exposure. | A blanket ban on all public ingress. |
| Sandbox | Isolation, budget/lifecycle accountability, audit logging, and appropriate service guardrails. | Blanket production private-endpoint standards unless the sandbox purpose requires them. |

### Safe rollout sequence

1. **Discover:** Inventory resources, current tags, names, network patterns, and existing policy assignments with Azure Resource Graph and policy compliance.
2. **Design:** Define the intended state, the assignment scope, exclusions/exemptions, effect, identity requirements, and a rollback plan.
3. **Pilot:** Assign `Audit` or use a limited scope. Validate expected and unexpected noncompliance.
4. **Remediate:** For Modify or DeployIfNotExists, ensure the assignment identity has the least required permissions and create remediation tasks only after reviewing impact.
5. **Enforce:** Move well-understood rules to Deny/required-state enforcement.
6. **Operate:** Review compliance, exceptions, cost allocation, and policy changes as part of landing-zone change control.

### Troubleshooting decision path

1. **A deployment is blocked:** Read the `RequestDisallowedByPolicy` details, find the assignment and inherited scope, and decide whether the resource should comply, the assignment should change, or an approved exemption is justified.
2. **A tag is absent from the resource:** Check whether the policy is `Modify`, whether the alias/operation applies, whether the assignment identity and remediation task have required permission, and whether the resource type supports tags.
3. **A tag is absent from cost data:** Verify the tag was present while the resource produced usage, allow cost-data refresh, and check Cost Management tag inheritance at the supported billing/subscription scope. [How tags are used in cost data](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/understand-cost-mgt-data#how-tags-are-used-in-cost-and-usage-data)
4. **A user lost access after a subscription move:** Compare direct subscription assignments with old-parent and target-parent inherited assignments; restore access at a surviving scope.
5. **A proposed management group seems necessary:** State the distinct policy/RBAC/connectivity/compliance requirement. If none exists, use subscription placement, resource groups, or tags instead.

## Common misconceptions and exam discriminators

| Plausible answer | Why it fails | Decision rule |
|---|---|---|
| “Use management groups for every department, region, and lifecycle environment.” | It creates a deep inheritance tree without a distinct governance need. | Use management groups for shared archetypes; use tags for reporting and subscriptions for isolation. |
| “Move Legacy under Cloud-Native before moving subscriptions.” | It changes inheritance for all subscriptions still in Legacy and does not itself move them. | Preserve access, move the intended subscription, then validate effective policy/RBAC. |
| “Cost tag inheritance updates resource properties.” | It affects usage records only. | Use Policy Modify for ARM tags; use Cost Management inheritance for billing allocation. |
| “Append and Modify are interchangeable for tags.” | Append cannot remediate existing resources and conflicts can deny a request. | Prefer Modify for tagging; select operation semantics deliberately. |
| “A global administrator automatically can rename the tenant root group.” | Microsoft Entra directory role and Azure RBAC are separate. | Obtain the required management-group write permission and distinguish ID from display name. |
| “Use one universal regex naming policy.” | Azure Policy does not support full regex and resource types have different name constraints. | Use service-specific policy rules and test with Audit first. |
| “Increase the resource-group limit through support.” | The 800-instances-of-one-type limit is hard. | Partition by lifecycle-compatible resource groups or subscriptions. |

## Architecture summary

The durable landing-zone design is policy-driven and subscription-centered. It uses a shallow management-group hierarchy for common guardrails, subscriptions for workload/platform boundaries, resource groups for shared lifecycle, and tags for metadata that must cut across the hierarchy.

```text
Requirement arrives
    │
    ├─ Different shared governance/access/connectivity archetype?
    │      └─ Create or select a peer management-group branch.
    ├─ Different billing/quota/isolation/workload boundary?
    │      └─ Create or select a subscription and place it in the right archetype.
    ├─ Same workload lifecycle/deployment boundary?
    │      └─ Use a resource group.
    └─ Cross-cutting reporting/ownership/classification data?
           └─ Use tags, Policy enforcement, and Cost Management allocation.
```

## Final review checklist

- [ ] I can explain why Corp, Online, and Sandbox are peer workload archetypes with different inherited guardrails.
- [ ] I know that root-level policy/RBAC is supported but should be must-have only because it inherits directory-wide.
- [ ] I know that the tenant root management-group ID is immutable and the display name is editable with proper Azure RBAC permission.
- [ ] I can identify the child, target-parent, and current-parent permission checks for a non-root subscription move.
- [ ] I preserve required access at the subscription or target-parent scope before removing old-parent inheritance.
- [ ] I know that subscriptions per management group are unlimited, management-group depth is root plus six levels, and a tenant can have 10,000 management groups.
- [ ] I distinguish a hard platform limit from an adjustable quota and partition resources when the 800-per-resource-type-per-resource-group limit applies.
- [ ] I distinguish RBAC (who can act), Policy (allowed state), and locks (control-plane protection).
- [ ] I use `Deny` to prevent a noncompliant name prospectively and do not expect policy to rename an existing resource.
- [ ] I use `Modify` and remediation for resource tags; I use Cost Management tag inheritance for usage-record allocation.
- [ ] I use `add`/`if missing` for child overrides and `addOrReplace` only when the parent value must win.
- [ ] I can distinguish purpose tags from ownership tags and set each tag at the highest scope where its value remains true.
- [ ] I would pilot with Audit, validate compliance and exclusions, then remediate and enforce deliberately.

## Documentation and interpretation notes

* The policy matrices in the source notes are design examples, not a universal built-in assignment catalog. Validate exact built-in definition availability, aliases, effects, SKUs, and regional applicability before assigning them.
* A separation by regulated identity/security or connectivity is an architectural option. It increases replicated-platform operational complexity and should be justified by the requirement, not by a presumed RBAC restriction.
* The recommended tag schema is a design starting point. Reduce or adjust required tags where their value is not stable at a given scope; tags are plaintext and should not contain sensitive values.
