# Deep Technical Facts and Requirements for Resource Organization and Resource Tagging

## Scope

- Exam: AZ-305: Designing Microsoft Azure Infrastructure Solutions
- Task: Recommend a structure for management groups, subscriptions, and resource groups, and a strategy for resource tagging.
- Source guide: *Landing_Zone_task_brief.md*, resolved through *Landing_Zone_task_map.md* and *Skills.psd1*.
- Research date: September 2026.
- Product selection method: Products and major topics were extracted from the supplied study guide, then checked against current official Microsoft documentation.

## Product coverage summary

| Product / topic | Classification | Why it matters for this task |
|---|---|---|
| Azure management groups and Azure landing-zone hierarchy | Core | Defines the inherited governance and broad-access boundary above subscriptions. |
| Azure subscriptions and subscription vending | Core | Defines independent management, billing, quota, security, and scale boundaries. |
| Azure Resource Manager resource groups | Core | Defines the deployment, administration, and deletion lifecycle boundary inside a subscription. |
| Azure resource tags | Core | Provides cross-cutting metadata without adding hierarchy depth. |
| Azure Policy tag governance and remediation | Supporting | Enforces and repairs an approved tag dictionary. |
| Azure RBAC, Cost Management tag inheritance, and Azure Resource Graph | Supporting | Separates authorization, billing-record allocation, and cross-scope inventory from the hierarchy itself. |

---

## Azure management groups and Azure landing-zone hierarchy

**Classification:** Core  
**Why it matters:** Management groups are the scope above subscriptions at which inherited Policy and broad platform access are designed. They must represent durable governance archetypes, not every reporting dimension.  
**Primary Microsoft source:** [Azure management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)  
**Limits and quotas source:** [Management-group facts and limits](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#important-facts-about-management-groups)

### Deep technical facts / requirements

1. A Microsoft Entra directory has one management-group hierarchy; every management group and subscription ultimately rolls up to its single tenant-root management group, and a management group or subscription can have only one parent. This makes a hierarchy a governance inheritance tree, not a multi-membership classification system. [Azure management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#important-facts-about-management-groups)
2. One directory supports up to **10,000 management groups**, and the tree supports at most **six** management-group levels below the root (the root and subscription levels do not count). CAF nevertheless recommends a reasonably flat hierarchy of ideally **three to four levels** to limit inheritance and administration complexity. [Management-group limits](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#important-facts-about-management-groups) [CAF management-group recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-group-recommendations)
3. Azure Policy and Azure RBAC assignments made at a management group inherit to descendant management groups, subscriptions, resource groups, and resources. A role assignment at a management group can therefore grant a principal access to every applicable descendant resource. [Azure management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview) [Azure Resource Manager scope](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#understand-scope)
4. The tenant-root management group has the Entra tenant ID as its ID, cannot be moved or deleted, and receives new subscriptions by default. Because assignments there apply to all tenant resources, only universal, must-have controls belong at that scope. [Root management group behavior](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#root-management-group-for-each-directory)
5. All subscriptions grouped under a management group must trust the same Microsoft Entra tenant; a shared management-group tree is not a cross-tenant governance mechanism. [Azure management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)
6. CAF recommends using management groups to aggregate Policy and initiative assignments for subscriptions with the same security, compliance, connectivity, and feature needs. It specifically warns against copying the organization chart, regions, or billing structure into a deep hierarchy. [CAF management-group recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-group-recommendations)
7. The reference landing-zone pattern places an organization-controlled intermediate root beneath the tenant root, then separates Platform, Landing zones, Sandboxes, and Decommissioned branches. Platform commonly has Management, Connectivity, Identity, and Security child scopes; Landing zones commonly has `Corp`, `Online`, and `Local` workload archetypes. [CAF landing-zone hierarchy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-groups-in-the-azure-landing-zone-architecture)
8. `Corp`, `Online`, and `Local` are connectivity and policy archetypes: `Corp` is for workloads needing corporate or hybrid connectivity, `Online` is for internet-facing or non-VNet workloads, and `Local` covers Azure Local workloads with different Policy needs. They are not department labels. [CAF landing-zone hierarchy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-groups-in-the-azure-landing-zone-architecture)
9. Do not create management groups for development, test, and production by default; separate those environments into subscriptions in the applicable workload archetype when their access, policy, cost, or lifecycle differs. [CAF management-group recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-group-recommendations)
10. Do not create management groups solely to represent Azure regions. A location-based hierarchy is justified when data residency, data security, data sovereignty, or other location-specific controls require different inherited governance. [CAF multiregion management-group guidance](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-group-recommendations)
11. CAF recommends a dedicated default management group for new subscriptions so they do not remain at the tenant root; a sandbox is a suitable default for experimentation because it is isolated from development, test, and production policies. [CAF default management-group guidance](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-group-recommendations)
12. Moving a subscription or management group requires management-group write access on the child, current parent, and target parent, plus role-assignment write/delete permissions on the child. Azure Resource Manager can cache hierarchy details for up to **30 minutes**, so portal hierarchy display is not immediate move confirmation. [Move management groups and subscriptions](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#moving-management-groups-and-subscriptions)

### Incompatibilities and mutual exclusions

If a requirement is only to locate resources by owner, cost center, application, or environment across several subscriptions, another management-group branch is the wrong mechanism because a management group gives each subscription only one parent and carries inherited controls; use tags and Resource Graph for horizontal classification instead. [Management-group single-parent limit](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#important-facts-about-management-groups) [CAF tagging recommendation](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-group-recommendations)

### Edge cases and gotchas

- Management groups are not supported in Cost Management features for Microsoft Customer Agreement (MCA) subscriptions, so do not assume a management-group cost view is available under every billing agreement. [Management-group Cost Management note](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)
- A custom role with `DataActions` cannot be assigned at management-group scope, even though other custom roles can inherit from that scope. [Management-group custom-role limits](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#limitations)
- Moving a subscription can be blocked when a role assignment on it depends on a custom role definition whose assignable scope is in the old branch; changing the role scope, assignment, or definition is required first. [Management-group role-definition move constraint](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#issues-with-breaking-the-role-definition-and-assignment-hierarchy-path)
- The CAF decommissioned branch is intended for canceled landing zones and describes deletion after **30–60 days**; it is a lifecycle/governance staging pattern, not a platform-enforced retention timer. [CAF decommissioned management group](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-groups-in-the-azure-landing-zone-architecture)

### AZ-305 exam discriminator

Choose a management group when multiple subscriptions need the same inherited Policy/RBAC archetype; choose a subscription when the requirement is an independent quota, cost, security, or scale boundary, and choose tags when the requirement is only cross-cutting discovery or reporting. [CAF management groups](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups) [CAF subscriptions](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions)

### Common trap

Do not treat management groups as folders: a Policy or role assignment at a parent is inherited by descendants, so a reorganized tree can change effective governance and access even though no resource itself moved. [Azure management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)

---

## Azure subscriptions and subscription vending

**Classification:** Core  
**Why it matters:** A subscription is the principal workload or platform landing-zone unit because it combines management, billing, quota, security, governance, and scale isolation.  
**Primary Microsoft source:** [CAF subscription considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions)  
**Limits and quotas source:** [Azure subscription and service limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits)

### Deep technical facts / requirements

1. A subscription is a boundary for scale, quota, cost, governance, security, and identity controls. A resource group does not create a separate subscription quota pool or billing boundary. [CAF subscription design considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions#organization-and-governance-design-considerations)
2. Subscriptions are global logical constructs, so a primary/secondary regional workload can remain in one subscription when ownership, policy, lifecycle, and quotas align. Region alone is not a subscription-boundary requirement. [CAF multiple-region considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions#multiple-region-considerations)
3. CAF identifies policy/compliance, security and isolation, organization/ownership, billing, quotas and capacity, application portfolio, and regional requirements as independent subscription-design inputs. A new subscription is justified when one of these creates a material hard boundary. [CAF subscription considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions)
4. Platform services are normally isolated from application landing zones. The CAF hierarchy puts centralized management, connectivity, identity, and security tooling into dedicated platform subscriptions so their lifecycle, operators, and guardrails do not mix with workload teams' subscriptions. [CAF platform-subscription pattern](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-groups-in-the-azure-landing-zone-architecture)
5. One application per subscription is a strong default because it gives the application team an independent management boundary; CAF permits multiple small applications to share a subscription when they have aligned policy, risk, owner, lifecycle, and quota needs. [CAF subscription recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions#recommendations)
6. Separate production from nonproduction into subscriptions when their access model, risk posture, budgets, operational ownership, or lifecycle must be independently governed. An environment label by itself does not require a distinct management-group branch. [CAF application-environment guidance](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-application-environments) [CAF management-group recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-group-recommendations)
7. A separate regional subscription becomes appropriate when the region has a different sovereign/regulatory operating model, needs independent active-active lifecycle, or must avoid subscription or regional quota constraints. [CAF multiple-region recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions#multiple-regions-recommendations)
8. Subscription vending should capture the owner, cost center/budget, workload classification, required management-group placement, RBAC model, networking, and tag requirements before provisioning the subscription. It turns a landing-zone decision into a repeatable onboarding contract rather than an ad hoc portal action. [CAF subscription vending](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending)
9. A subscription must be placed under the correct management group before workload deployment if inherited Policy and RBAC are prerequisites, because assignments made above it apply downward to its resource groups and resources. [Azure Resource Manager scope](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#understand-scope)
10. Subscription resource limits are service-specific and can be adjusted in some cases; architects must test the required service quota in the target region rather than assume that adding resource groups creates capacity. [Azure subscription and service limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits)

### Incompatibilities and mutual exclusions

If a workload requires an independent quota, billing, security, or policy boundary, a resource group cannot meet the requirement because those boundaries are defined by the subscription; use a new or correctly vended subscription. [CAF subscription design considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions#organization-and-governance-design-considerations)

### Edge cases and gotchas

- A subscription can have only one management-group parent, so a workload needing two unrelated reporting dimensions cannot be put in two governance branches; retain one archetype placement and model the other dimension with tags. [Management-group hierarchy facts](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#important-facts-about-management-groups)
- A subscription's billing relationship can impose limits that differ among Enterprise Agreement, MCA Enterprise, and CSP/partner agreements; validate the relevant billing-account and subscription limits before a mass-vending design. [CAF subscription billing note](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions)
- A separate region does not automatically mean separate subscription. The exception is material regional governance, independent active-active operations, or quota/capacity need. [CAF multiple-region recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions#multiple-regions-recommendations)
- Moving a subscription changes the inherited governance context. Evaluate effective Policy, RBAC, and custom-role dependencies before the move rather than treating it as a reporting-only operation. [Move management groups and subscriptions](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#moving-management-groups-and-subscriptions)

### AZ-305 exam discriminator

“Separate quota, budget, security boundary, or operations team” points to a subscription; “separate deployment lifecycle” points to a resource group; “same inherited compliance/connectivity baseline across many subscriptions” points to a management group. [CAF subscriptions](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions) [Azure Resource Manager resource groups](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#what-is-a-resource-group)

### Common trap

Do not select a new subscription merely for a different Azure region. Subscriptions are global; add the hard boundary only when the regional requirement also changes governance, independent operations, or capacity. [CAF multiple-region considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions#multiple-region-considerations)

---

## Azure Resource Manager resource groups

**Classification:** Core  
**Why it matters:** Resource groups organize resources that share a deployment, administration, and retirement lifecycle without attempting to replace the subscription's governance boundary.  
**Primary Microsoft source:** [What is Azure Resource Manager?](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview)  
**Limits and quotas source:** [Resource-group limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#resource-group-limits)

### Deep technical facts / requirements

1. Azure has four management scopes—management group, subscription, resource group, and resource—and settings at a higher scope apply to lower scopes. Scope selection determines the blast radius of Policy, RBAC, locks, and other Resource Manager controls. [Azure Resource Manager scope](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#understand-scope)
2. All resources in a resource group should share a lifecycle: deploy, update, and delete them together. A resource that must survive a different deployment or retirement cycle belongs in another resource group. [Resource-group lifecycle guidance](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#what-is-a-resource-group)
3. Deleting a resource group deletes the resources it contains. This makes lifecycle alignment a hard design requirement, not merely a naming or navigation convention. [Resource-group deletion behavior](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#what-is-a-resource-group)
4. Each resource can exist in only one resource group, although it can connect to resources in other resource groups. A web application and database may therefore be separated by lifecycle or ownership even when they are tightly coupled at runtime. [Resource-group membership and cross-group dependencies](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#what-is-a-resource-group)
5. A resource group can scope Azure RBAC, Policy, and resource locks for its contained resources. This is appropriate for a workload component's administrative boundary but does not create independent subscription billing or quotas. [Resource-group controls](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#what-is-a-resource-group) [CAF subscription boundaries](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions#organization-and-governance-design-considerations)
6. A resource group has a location because Azure stores its metadata there; resources may be in other regions, but Microsoft recommends aligning the resource-group location with its resources. The resource-group location governs Resource Manager control-plane metadata, not the workload data plane. [Resource-group location behavior](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#which-location-should-i-use-for-my-resource-group)
7. If the resource-group location is unavailable, Azure Resource Manager transparently routes control-plane operations to a backup region. This does not make the contained regional services or their data-plane endpoints available. [Resource-group location resiliency](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#which-location-should-i-use-for-my-resource-group)
8. A resource group can contain up to **800 instances of a resource type**, subject to documented resource-type exemptions. A design that exceeds this per-type limit must split the deployment or use an exempt/alternative architecture. [Resource-group limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#what-is-a-resource-group)
9. Resources can be moved between resource groups, but move support is resource-type specific and requires review of dependencies; do not use a prospective move as a substitute for lifecycle design. [Move Azure resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/move-resource-group-and-subscription)
10. Resource groups can be tagged, but their resources do not inherit those tags natively. A tag propagation design requires Azure Policy or another automation mechanism. [Resource-group tags](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#what-is-a-resource-group)

### Incompatibilities and mutual exclusions

If two resources have independent deletion or deployment cycles, they cannot safely share one resource group because deleting that group deletes both; their runtime dependency does not override the lifecycle rule. [Resource-group lifecycle and deletion](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#what-is-a-resource-group)

### Edge cases and gotchas

- The resource-group location is metadata storage and control-plane routing, not proof that all contained resources are in that region or that their data plane has regional resiliency. [Resource-group location behavior](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#which-location-should-i-use-for-my-resource-group)
- Resource locks and Policy can be applied at resource-group scope, but locks restrict control-plane actions while Policy evaluates desired resource state; neither is a replacement for RBAC authorization. [Azure Policy and RBAC](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-policy-and-azure-rbac) [Resource locks](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources)
- Resource groups can cross regions technically, but CAF recommends region-aligned groups for multiregion workloads so operations and lifecycle are intelligible. [CAF multiple-region recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions#multiple-regions-recommendations)
- Not every Azure resource is deployed in a resource group; specific types are valid at subscription, management-group, or tenant scope. [Azure Resource Manager scopes](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#what-is-a-resource-group)

### AZ-305 exam discriminator

Choose a resource group when components deploy, change, and retire together or need the same component-level administration; do not choose it when the clue requires independent quota, billing, or tenant-wide policy inheritance. [Resource-group lifecycle guidance](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#what-is-a-resource-group) [CAF subscriptions](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions)

### Common trap

Do not put all resources of the same technology into one resource group. Lifecycle and administrative ownership, not resource type, determine the correct group. [Resource-group lifecycle guidance](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#what-is-a-resource-group)

---

## Azure resource tags

**Classification:** Core  
**Why it matters:** Tags provide controlled, horizontal metadata for inventory, cost allocation, ownership, operations, classification, and automation without producing inherited governance or a hard isolation boundary.  
**Primary Microsoft source:** [Use tags to organize Azure resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources)  
**Limits and quotas source:** [Tag limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources#limitations)

### Deep technical facts / requirements

1. Tags are key-value metadata that can be applied to subscriptions, resource groups, and supported Azure resources; management groups do not support tags. Tags therefore cannot classify a management-group branch itself. [Tag usage and recommendations](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources#tag-usage-and-recommendations)
2. A resource, resource group, or subscription normally supports at most **50 tag name-value pairs**. Some resource types have different limits, so a large taxonomy must be designed as a concise dictionary rather than copied from every reporting field. [Tag limitations](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources#limitations)
3. Tag names are case-insensitive while tag values are case-sensitive. Standardize both key spelling and allowed value casing to prevent fragmented Cost Management and Resource Graph grouping. [Tag limitations](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources#limitations)
4. Tags are plaintext and should not contain passwords, secrets, or sensitive information. They can be exposed by APIs and usage/billing data. [Tag usage security warning](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources#tag-usage-and-recommendations)
5. Resource tags do not inherit from the subscription or resource group by default. A tag that must appear on children needs Policy `modify`/`append` or an external automation process. [Tag inheritance](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources#inherit-tags)
6. Not every Azure resource type supports tags, and support can differ between resource and resource-group scenarios. Check the current tag-support list before making a tag mandatory through deny Policy. [Tag support for Azure resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-support)
7. Tags are appropriate for function, accounting, purpose, ownership, classification, operations, automation, and compliance reporting. A governed dictionary should define each tag's owner, allowed values, source, consumer, scope, enforcement method, and retirement rule. [CAF tagging strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)
8. Stable resource identity belongs primarily in names, whereas mutable and multi-dimensional information belongs in tags. A name cannot be changed for many resources, but a tag can be changed without renaming the resource. [CAF resource naming](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming) [CAF resource tagging](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)
9. Azure Resource Graph can query Azure Resource Manager resource properties and tags across subscriptions and management groups, making tags a horizontal inventory and compliance-reporting mechanism rather than a hierarchy substitute. [Azure Resource Graph overview](https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview)
10. A tag does not grant access, encrypt data, create a network boundary, or independently enforce compliance. Policy can evaluate a tag as part of a state rule, while RBAC determines who can take an action. [Azure Policy and RBAC](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-policy-and-azure-rbac)

### Incompatibilities and mutual exclusions

If a requirement needs authorization, encryption, network isolation, or a separate quota/billing boundary, tags cannot satisfy it because tags are metadata; use RBAC, security/network controls, or a subscription as appropriate. [Tag usage and limitations](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources) [CAF subscription boundaries](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions#organization-and-governance-design-considerations)

### Edge cases and gotchas

- Resource-group tags do not automatically appear on resources. “Tag inheritance” in a requirement must be translated into a Policy effect or automation mechanism. [Tag inheritance](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources#inherit-tags)
- A tag value differing only in letter case is distinct from another value, so `Prod` and `prod` can split reports even though the tag key is case-insensitive. [Tag limitations](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources#limitations)
- The `CostCenter` tag on a resource may not automatically appear in every usage record; Cost Management tag inheritance is a separate billing-record feature. [Cost Management tag inheritance](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/enable-tag-inheritance)
- A mandatory tag Policy can block a deployment for a resource type that does not support tags; verify support and rollout with audit before using deny broadly. [Tag support for Azure resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-support) [Azure Policy effects](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics)

### AZ-305 exam discriminator

Use tags when the requirement is cross-subscription discovery, showback/chargeback metadata, ownership, classification, or automation targeting; do not deepen the management-group tree unless the same subscriptions require different inherited governance. [CAF tagging strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging) [CAF management-group recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-group-recommendations)

### Common trap

Do not assume tags inherit or secure resources. Native resource-tag inheritance does not exist, and a tag is visible plaintext metadata rather than an enforcement boundary. [Tag inheritance and security](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources)

---

## Azure Policy tag governance and remediation

**Classification:** Supporting  
**Why it matters:** Azure Policy makes a tag taxonomy durable by auditing, denying, adding, replacing, inheriting, and remediating tags at management-group, subscription, resource-group, or resource scope.  
**Primary Microsoft source:** [Policy definitions for tagging resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-policies)  
**Limits and quotas source:** [Azure Policy limits](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure#policy-definition-limits)

### Deep technical facts / requirements

1. Built-in tag policies include `deny` definitions that require a tag or tag/value on resources or resource groups. The resource definitions do not apply to resource groups, so choose the scope-specific built-in definition deliberately. [Built-in tag policy definitions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-policies)
2. `modify` tag policies can add a missing tag, add or replace a tag, inherit a tag from a resource group or subscription, or inherit only if the resource's tag is missing. The “if missing” definitions preserve an existing different resource-specific value; the replace/inherit definitions do not. [Built-in tag policy definitions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-policies)
3. `append` can add a tag during a create or update operation but cannot remediate pre-existing resources until they are changed. `modify` supports remediation of existing resources and is the appropriate built-in effect when a historical estate must be repaired. [Built-in tag policy definitions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-policies)
4. Remediation for `modify` and `deployIfNotExists` uses a managed identity associated with the Policy assignment. That identity needs the least Azure RBAC role required to modify the target resources. [Azure Policy remediation access control](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#how-remediation-access-control-works)
5. Each Policy assignment can have only one managed identity, although that identity can hold multiple roles. Portal-created assignments can grant the policy's listed roles automatically; SDK-created assignments require the roles to be granted manually. [Azure Policy remediation identity requirements](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources)
6. Policy evaluation uses the identity of the caller making the request, whereas the assignment managed identity performs remediation/deployment. A remediation identity does not grant the original caller permission to create noncompliant resources. [Azure Policy remediation access control](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#how-remediation-access-control-works)

### Incompatibilities and mutual exclusions

If existing resources must receive copied or repaired tags without waiting for a future resource update, `append` alone cannot meet the requirement because it does not modify pre-existing resources; use a `modify` policy and remediation task. [Built-in tag policy definitions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-policies)

### Edge cases and gotchas

- Editing a Policy definition does not automatically update existing assignments or their managed-identity permissions; grant any newly required roles explicitly. [Azure Policy remediation identity requirements](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources)
- A custom `modify` or `deployIfNotExists` definition must include the least-privilege `roleDefinitionIds` that remediation requires. [Azure Policy remediation prerequisites](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#configure-the-policy-definition)
- Start a new mandatory-tag policy in audit where deployment compatibility is uncertain, then advance to deny after unsupported types, exceptions, and deployment sequencing are understood. [Azure Policy effects](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics)

### AZ-305 exam discriminator

Use `deny` to prevent missing tags on new writes, `modify` plus remediation to repair existing resources or inherit a parent value, and `append` only when a future-write-only operation is acceptable. [Built-in tag policy definitions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-policies)

### Common trap

Do not expect assigning a tag policy to retroactively alter existing resources. Only a remediation task for a supported `modify` or `deployIfNotExists` assignment performs that repair. [Remediate non-compliant resources](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources)

---

## Azure RBAC, Cost Management tag inheritance, and Azure Resource Graph

**Classification:** Supporting  
**Why it matters:** These services answer three often-confused requirements: who can act, how usage records are cost-allocated, and how resources are queried across the hierarchy.  
**Primary Microsoft sources:** [Azure RBAC scope](https://learn.microsoft.com/en-us/azure/role-based-access-control/scope-overview), [Cost Management tag inheritance](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/enable-tag-inheritance), and [Azure Resource Graph](https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview)

### Deep technical facts / requirements

1. Azure RBAC roles can be assigned at management-group, subscription, resource-group, or resource scope, and assignments inherit to lower scopes. Grant the narrowest scope that meets the access need to reduce blast radius. [Azure RBAC scope](https://learn.microsoft.com/en-us/azure/role-based-access-control/scope-overview)
2. CAF advises against assigning application-team permissions at management-group scope because inherited access can over-permission users. Controlled platform teams may need branch-wide access, preferably through just-in-time privileged access processes. [CAF management-group RBAC recommendation](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-group-recommendations)
3. Cost Management tag inheritance adds selected subscription or resource-group tags to **usage records** for billing allocation; it does not change the tags on the Azure resource. This is separate from Azure Policy resource-tag inheritance. [Cost Management tag inheritance](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/enable-tag-inheritance)
4. Cost Management tag inheritance supports resource-group and subscription tags and lets each configuration choose which source wins if the same tag exists. It should therefore be configured intentionally for cost allocation rather than presumed as native resource inheritance. [Configure Cost Management tag inheritance](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/enable-tag-inheritance#enable-tag-inheritance)
5. Azure Resource Graph is an Azure service that queries resource properties at scale across subscriptions and management groups; tags can be queried as resource properties to detect missing, malformed, or inconsistent metadata. [Azure Resource Graph overview](https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview)

### Incompatibilities and mutual exclusions

If a requirement says “inherit tags onto the resource,” Cost Management tag inheritance cannot satisfy it because it enriches billing usage records only; use Azure Policy `modify` or automation for resource tags. [Cost Management tag inheritance](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/enable-tag-inheritance) [Built-in tag policies](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-policies)

### Edge cases and gotchas

- A role assignment changes authorization, while a Policy assignment evaluates resource state; Owner-level RBAC does not bypass an inherited deny Policy. [Azure Policy and RBAC](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-policy-and-azure-rbac)
- Resource Graph reports inventory; it does not itself correct tag values or enforce a tagging standard. Pair it with Policy or controlled automation. [Azure Resource Graph overview](https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview) [Azure Policy overview](https://learn.microsoft.com/en-us/azure/governance/policy/overview)
- Cost Management tag inheritance has billing-scope and usage-record prerequisites; validate support for the billing account and target scope before using it as the basis for chargeback. [Cost Management tag inheritance](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/enable-tag-inheritance)

### AZ-305 exam discriminator

Use RBAC for authorization, Azure Policy for desired-state compliance and tag propagation, Cost Management tag inheritance for usage-record allocation, and Resource Graph for cross-scope inventory. These are complementary controls, not interchangeable hierarchy features. [Azure Policy and RBAC](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-policy-and-azure-rbac) [Cost Management tag inheritance](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/enable-tag-inheritance) [Azure Resource Graph overview](https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview)

### Common trap

Do not call Cost Management tag inheritance “resource-tag inheritance.” It changes cost/usage records, while resource tags require Policy or a resource-writing automation path. [Cost Management tag inheritance](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/enable-tag-inheritance)

---

## Highest-yield exam discriminators

| Scenario clue | Best answer | Why |
|---|---|---|
| Several subscriptions need the same inherited security and connectivity policies. | Management group based on the common workload archetype. | Policy/RBAC assignments inherit through descendant scopes, and CAF groups subscriptions by shared security, compliance, connectivity, and feature needs. [Azure management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview) [CAF management-group recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-group-recommendations) |
| A workload needs an independent quota and budget. | Subscription. | Subscriptions are boundaries for quota, cost, governance, security, and scale; resource groups are not. [CAF subscription design considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions#organization-and-governance-design-considerations) |
| A set of resources must deploy, update, and be deleted together. | Resource group. | Shared lifecycle is the resource-group design rule, and deleting the group deletes contained resources. [Resource-group lifecycle](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#what-is-a-resource-group) |
| Resources in many subscriptions need to be found by owner or cost center. | Tags plus Azure Resource Graph. | Tags are horizontal metadata, and Resource Graph queries resource properties across subscriptions and management groups. [CAF tagging strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging) [Azure Resource Graph overview](https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview) |
| A new subscription must never remain at tenant root. | Configure a default management group, commonly Sandbox. | New subscriptions normally default to root; CAF recommends a dedicated default group so they are not left there. [CAF default management-group guidance](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-group-recommendations) |
| Development, test, and production differ in access/risk/budget but share the same workload archetype. | Separate subscriptions under the same landing-zone archetype. | CAF advises not to create environment management groups by default; subscriptions provide the needed hard boundaries. [CAF management-group recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-group-recommendations) [CAF application environments](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-application-environments) |
| A workload has primary and DR resources in two Azure regions, but identical ownership and governance. | One global subscription with regional resource groups. | A subscription is global, and region alone does not require a new subscription or management group. [CAF multiple-region considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions#multiple-region-considerations) |
| A region has unique data-residency policy and regional administrators. | Location/regulated management-group archetype, with subscriptions as needed. | Location-based hierarchy is justified when residency, sovereignty, security, or regulatory controls differ. [CAF multiregion management-group guidance](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-group-recommendations) |
| A resource must retain a deliberately different `CostCenter` value from its resource group. | “Inherit a tag from the resource group if missing” Policy. | The built-in `modify` policy preserves an existing different resource value, unlike replace/inherit behavior. [Built-in tag policies](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-policies) |
| All existing resources must receive a missing tag. | Policy `modify` plus remediation. | `modify` supports remediation of existing resources; `append` only affects create/update behavior. [Built-in tag policies](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-policies) |
| A new resource without `Environment` must be rejected. | A scope-appropriate required-tag `deny` Policy. | Built-in deny definitions require tags on resources or resource groups; check type support first. [Built-in tag policies](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-policies) [Tag support](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-support) |
| Billing reports need the resource-group `CostCenter`, but resource tags must remain untouched. | Cost Management tag inheritance. | It adds source tags to usage records and does not modify the Azure resource's tags. [Cost Management tag inheritance](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/enable-tag-inheritance) |
| Application team needs access only to its workload resources. | RBAC at resource-group or subscription scope, not management-group scope. | Roles inherit down, and CAF warns that application-team access at management-group scope can over-permission users. [Azure RBAC scope](https://learn.microsoft.com/en-us/azure/role-based-access-control/scope-overview) [CAF management-group recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-group-recommendations) |
| A central network team must operate all connectivity subscriptions. | Controlled RBAC at the connectivity platform branch. | A management-group assignment inherits to that branch, allowing platform duties without granting access to landing-zone branches. [Azure management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview) |
| A design proposes seven layers of management groups. | Redesign the hierarchy. | The hard maximum is six levels below root, while CAF ideally recommends three to four levels. [Management-group limits](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#important-facts-about-management-groups) [CAF management-group recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups#management-group-recommendations) |

---

_Model used to research and author this fact sheet: GPT-5 (reasoning mode not supplied)._ 
