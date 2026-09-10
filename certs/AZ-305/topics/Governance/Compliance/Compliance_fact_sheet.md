# Deep Technical Facts and Requirements for Recommend a solution for managing compliance

## Scope

- Exam: AZ-305: Designing Microsoft Azure Infrastructure Solutions
- Task: Recommend a solution for managing compliance (Design identity, governance, and monitoring solutions → Design governance)
- Source guide: `Compliance_task_brief.md` and its companion `Compliance_task_map.md`
- Research date: September 2026
- Product selection method: Products and major topics were extracted from the provided guide, then validated against current official Microsoft documentation.

## Product coverage summary

| Product / topic | Classification | Why it matters for this task |
|---|---|---|
| Azure Policy — evaluation engine, scope, and limits | Core | Evaluates Resource Manager state at request time and on a 24-hour cycle across inherited scopes. [Overview of Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview) |
| Azure Policy — effects and remediation | Core | The effect and its remediation identity determine whether a control observes, blocks, mutates, deploys, protects, or requests attestation. [Effect basics](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics) |
| Azure Policy — exclusions, exemptions, and staged enforcement | Core | Governs legitimate deviations and progressive rollout without forking the control set. [Policy exemption structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure) |
| Azure Machine Configuration | Core | The only Policy-integrated way to audit or apply settings inside Azure and Arc-enabled machines. [What is Azure Machine Configuration?](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/01-overview-concepts) |
| Microsoft Defender for Cloud regulatory compliance | Core | Continuously assesses mapped security and regulatory standards across Azure, AWS, and GCP. [Regulatory compliance in Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-regulatory-compliance-standards) |
| Microsoft Purview Compliance Manager | Core | Manages assessments, owners, improvement actions, evidence, and a risk-based score across the digital estate. [Microsoft Purview Compliance Manager](https://learn.microsoft.com/en-us/purview/compliance-manager) |
| Management groups | Supporting | Supplies the inherited scope at which compliance controls apply to many subscriptions. [Management groups overview](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview) |
| Regulatory Compliance initiatives and the Microsoft cloud security benchmark | Supporting | Map policy definitions to controls, domains, and Microsoft/customer/shared responsibility. [Regulatory Compliance in initiative definitions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance) |
| Azure compliance offerings and Service Trust Portal | Supporting | Supply Microsoft's third-party audit evidence for the Microsoft-responsible part of shared responsibility. [Get started with the Service Trust Portal](https://learn.microsoft.com/en-us/compliance/assurance/stp-get-started) |
| Azure Arc-enabled servers | Supporting | Projects non-Azure servers into Resource Manager so Policy and Machine Configuration can govern them. [Azure Arc-enabled servers overview](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview) |
| Azure Resource Graph and Policy Insights reporting | Supporting | Stores and serves compliance records for portal, API, and at-scale reporting. [Get policy compliance data](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data) |
| Deployment stacks, template specs, and Azure Blueprints retirement | Adjacent | Replace Blueprints packaging and locking during its phased retirement. [Azure Blueprints retirement](https://learn.microsoft.com/en-us/azure/governance/blueprints/blueprint-retirement) |
| Microsoft Entra ID Governance | Adjacent | Satisfies access-certification and identity-lifecycle obligations that resource policies cannot. [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview) |
| Cloud Adoption Framework — enforce cloud governance policies | Framework / methodology | Defines inheritance, monitor-first rollout, policy as code, and delegated enforcement. [Enforce cloud governance policies](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/govern/enforce-cloud-governance-policies) |

## Documentation changes and discrepancies to know

Several behaviors changed in 2026 or differ subtly from the task brief. Treat this table as a pre-exam watch list.

| Change or discrepancy | Date / status | Design impact |
|---|---|---|
| Foundational CSPM moves to opt-in and is no longer enabled by default for **new** Azure subscriptions; existing enabled subscriptions stay enabled and AWS/GCP onboarding isn't affected. [What is CSPM](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-cloud-security-posture-management) | Starts October 27, 2026 | The brief's "MCSB is enabled by default" is true for existing subscriptions but not for newly created Azure subscriptions after that date. |
| Azure Blueprints phased retirement: no new definitions/versions (July 31, 2026); no definition edits or new assignments (October 31, 2026); no assignment edits (December 31, 2026); service retired, unexported objects deleted, and blueprint locks stop working (January 31, 2027). Originally announced September 14, 2023 with a July 11, 2026 date. [Azure Blueprints retirement](https://learn.microsoft.com/en-us/azure/governance/blueprints/blueprint-retirement) | In progress | Blueprints is never a valid new-design answer; migrate to deployment stacks plus template specs. |
| Assignments now document a third enforcement mode, `Enroll`, backed by `Microsoft.Authorization/policyEnrollments` resources whose documented API version is `2025-02-01-preview`. [Policy enrollment structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/enrollment-structure) | [Preview API — verify GA status before specifying] | Adds a scope-owner opt-in path for staged enforcement beyond `DoNotEnforce`. |
| Microsoft cloud security benchmark v2 is available in preview; v2 baselines aren't yet available, so baselines remain v1. [MCSB introduction](https://learn.microsoft.com/en-us/security/benchmark/azure/introduction) | [Preview] | Don't specify MCSB v2 baselines as an exam answer. |
| Regulatory Compliance in Azure Policy initiative definitions is labeled a Preview feature. [Regulatory Compliance in initiative definitions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance) | [Preview] | Control/domain grouping in Policy is still preview even though the built-in initiatives are widely used. |
| The Defender dashboard page says nondefault standards can be added when **at least one paid plan** is enabled, while the CSPM plan comparison table lists "Regulatory compliance assessments" only under **Defender CSPM**. [Improve regulatory compliance](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard#before-you-start) [What is CSPM](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-cloud-security-posture-management) | Documentation inconsistency | When a scenario requires nondefault regulatory standards, a free-only (Foundational CSPM) answer is wrong under either reading. |
| The compliance-percentage prose lists Compliant, Exempt, and Unknown in the numerator, but the formula on the same page also counts Protected. [Azure Policy compliance states](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/compliance-states#compliance-percentage) | Documentation inconsistency | Follow the formula: `denyAction`-protected resources count toward compliance. |
| Essential Machine Management (preview) bundles Machine Configuration auditing, Update Manager, Azure Monitor, and Change Tracking. It's free during the initial preview, but will cost $9 per server per month for most Arc-enabled servers once billing begins on a future date. [Enable Essential Machine Management](https://learn.microsoft.com/en-us/azure/azure-arc/servers/essential-machine-management/enrollment) | [Preview] | Current published Machine Configuration pricing for Arc-enabled servers remains $6 per server per month. [Azure Policy pricing](https://azure.microsoft.com/en-us/pricing/details/azure-policy/) |

---

## Azure Policy — evaluation engine, scope, and limits

**Classification:** Core
**Why it matters:** Azure Policy is the engine that evaluates Resource Manager resource properties and actions against business rules and can deny, alter, deploy, or block at scale. Almost every "prevent," "audit," or "across subscriptions" clue begins here. [Overview of Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview)
**Primary Microsoft source:** [Overview of Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview)
**Limits and quotas source:** [Maximum count of Azure Policy objects](https://learn.microsoft.com/en-us/azure/governance/policy/overview#maximum-count-of-azure-policy-objects) and [Azure subscription and service limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits)

### Deep technical facts / requirements

1. **[Limits and quotas]** Maximums: `500` policy definitions and `200` initiative definitions per definition scope; `2,500` initiative definitions per tenant; `200` assignments per scope; `1,000` exemptions per scope; `20` parameters per policy definition; `1,000` policies and `400` parameters per initiative; `400` `notScopes` per assignment; `512` nested conditionals per rule; `1,048,576` bytes per definition, initiative, or assignment request body. [Maximum count of Azure Policy objects](https://learn.microsoft.com/en-us/azure/governance/policy/overview#maximum-count-of-azure-policy-objects) [Azure subscription and service limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits).
2. **[Prerequisites — definition location]** A definition must be saved at a management group or subscription. A definition saved in a subscription can be assigned only within that subscription, so a control intended for several subscriptions must be defined at a management group that contains all of them. [Understand scope in Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/scope#definition-location).
3. **[Scope edge case]** Although a policy can be assigned at a management group, only resources at the subscription or resource-group level are evaluated. By design, resources under the `Microsoft.Resources` provider are exempt from evaluation except subscriptions and resource groups. [Resources covered by Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview#resources-covered-by-azure-policy) [Evaluation triggers](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data#evaluation-triggers).
4. **[Defaults — evaluation timing]** A new or updated assignment takes about `5` minutes to apply before its evaluation cycle begins, with no predefined completion time for large scopes. A resource create/update result appears about `15` minutes later and doesn't re-evaluate other resources. A subscription created or moved within a management group hierarchy is evaluated in about `30` minutes. The standard compliance cycle re-evaluates every `24` hours. [Evaluation triggers](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data#evaluation-triggers).
5. **[Defaults — on-demand scans]** On-demand scans target a subscription or resource group and run asynchronously. The REST call returns `202 Accepted`, and a second request for a scope already being scanned returns the same status URI instead of starting a new scan. The VS Code extension scan of a single resource is synchronous. [On-demand evaluation scan](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data#on-demand-evaluation-scan).
6. **[Incompatibility — explicit deny]** Azure Policy is an explicit-deny system. A more permissive assignment at a child management group or subscription can't override a parent deny, and layered assignments are cumulative most restrictive. The only way to allow a denied resource is to modify the denying assignment, for example by excluding the child scope. [Assignments](https://learn.microsoft.com/en-us/azure/governance/policy/overview#assignments) [Layering policy definitions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics#layering-policy-definitions).
7. **[Version requirements]** Assignments always evaluate the latest state of the assigned definition, so editing a shared definition immediately changes every assignment. For built-ins, `definitionVersion` defaults to the latest major version with minor and patch changes auto-ingested. `#.#.*` pins a minor version, and patch changes are always auto-ingested for security. [Assignments](https://learn.microsoft.com/en-us/azure/governance/policy/overview#assignments) [Policy definition ID and version](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#policy-definition-id-and-version).
8. **[Configuration — mode]** `all` evaluates resource groups, subscriptions, and all resource types; `indexed` evaluates only types that support tags and location. Portal-created definitions use `all`. A definition without `mode` defaults to `all` in PowerShell but `null` (equivalent to `indexed`) in Azure CLI. Tag or location rules should use `indexed`, except rules targeting resource groups or subscriptions, which must use `all`. [Resource Manager modes](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-basics#resource-manager-modes).
9. **[Preview vs GA — Resource Provider modes]** Fully supported: `Microsoft.Kubernetes.Data` (effects `audit`, `deny`, `disabled`), `Microsoft.KeyVault.Data`, and `Microsoft.Network.Data`. **[Preview]**: `Microsoft.ManagedHSM.Data`, `Microsoft.DataFactory.Data` (enforcement only, no compliance reporting), `Microsoft.MachineLearningServices.v2.Data` (compliance records retained `24` hours), and `Microsoft.LoadTestService.Data`. Unless stated otherwise, Resource Provider modes support only built-in definitions and no component-level exemptions. [Resource Provider modes](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-basics#resource-provider-modes).
10. **[Identity, RBAC, and access]** Resource Policy Contributor includes most Policy operations and Owner has full rights. Contributor and Reader get only read operations. Contributor can trigger remediation but can't create or update definitions or assignments. User Access Administrator (or equivalent) is required to grant permissions to the managed identity of `deployIfNotExists`/`modify` assignments. [Azure RBAC permissions in Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-rbac-permissions-in-azure-policy).
11. **[Access — transparency]** All Policy objects (definitions, initiatives, assignments) are readable by every role holder at the object's scope and below, so assignment parameters and names aren't a place for confidential information. [Azure RBAC permissions in Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-rbac-permissions-in-azure-policy).
12. **[Identity-aware rules]** Rules can inspect `requestContext().identity` to block actions based on who makes the request, for example blocking user-initiated deletes of critical resources or requiring MFA for create/update/delete. Policy can therefore govern *who* as well as *what* in narrow cases, but RBAC remains the tool for general action authorization. [Manage identity-based actions and usage](https://learn.microsoft.com/en-us/azure/governance/policy/overview#manage-identity-based-actions-and-usage) [Azure Policy and Azure RBAC](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-policy-and-azure-rbac).
13. **[Cost]** There's no charge for Azure Policy on Azure resources. Machine Configuration on Azure Arc-enabled servers is priced at $6 per server per month. [Azure Policy pricing](https://azure.microsoft.com/en-us/pricing/details/azure-policy/).
14. **[Compliance math]** Compliance percentage = (compliant + exempt + unknown + protected) ÷ (compliant + exempt + unknown + non-compliant + conflicting + error + protected). `Not started` and `Not registered` are excluded. Rollup rank order is Non-compliant > Compliant > Error > Conflicting > Protected (preview) > Exempted > Unknown (preview). [Compliance rollup and percentage](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/compliance-states#compliance-rollup).
15. **[Resiliency / evidence retention]** The portal Overview chart shows only the last `7` days, and `PolicyStates/latest` queries default to the last `24` hours. Compliance records are stored in Azure Resource Graph, so long-term audit history requires export rather than reliance on the portal. [Portal](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data#portal) [Query for resources](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data#query-for-resources) [Azure Resource Graph](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data#azure-resource-graph).

### Incompatibilities and mutual exclusions

- If a management-group assignment denies a resource type **and** one child subscription must legally deploy it, a permissive child assignment can't be used, because Policy is explicit deny. Exclude the child from the parent assignment (or exempt it) and then assign the permissive rule at the child. [Assignments](https://learn.microsoft.com/en-us/azure/governance/policy/overview#assignments).
- If a tag or location rule must evaluate **resource groups or subscriptions** **and** the definition uses `indexed` mode, those containers won't be evaluated; the definition must use `all` and target `Microsoft.Resources/subscriptions/resourceGroups` or `Microsoft.Resources/subscriptions`. [Resource Manager modes](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-basics#resource-manager-modes).
- If a control must be applied to several subscriptions **and** the definition is stored in one subscription, it can't be assigned to the others; store it at a management group that contains every target subscription. [Definition location](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/scope#definition-location).

### Edge cases and gotchas

- `PATCH` requests that change only tag fields restrict evaluation to policies whose conditions inspect tags, so a non-tag rule doesn't fire on a tags-only update. [Order of evaluation](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics#order-of-evaluation).
- Azure Virtual Network Manager doesn't support manual evaluation triggers or the daily standard evaluation cycle. [On-demand evaluation scan](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data#on-demand-evaluation-scan).
- A `Not registered` state means the `Microsoft.PolicyInsights` resource provider isn't registered or the signed-in account lacks permission to read compliance data; it isn't a resource verdict. [Not registered](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/compliance-states#not-registered).
- Custom non-compliance messages are supported only for definitions using Resource Manager modes. [Non-compliance messages](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#non-compliance-messages).
- A resource exempt from one policy but compliant with the other nine policies in an initiative rolls up as **Compliant**, not Exempt. [Comparing different compliance states](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/compliance-states#comparing-different-compliance-states).

### AZ-305 exam discriminator

When the scenario says **many subscriptions**, **prevent**, or **consistent resource configuration**, choose a management-group-scoped Azure Policy (usually an initiative). The definition must live at or above that management group, and the explicit-deny model means exceptions must be designed into the parent assignment rather than added as looser child assignments. [Understand scope in Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/scope) [Assignments](https://learn.microsoft.com/en-us/azure/governance/policy/overview#assignments).

### Common trap

Assuming a pipeline can check compliance immediately after creating an assignment. Assignment application takes about 5 minutes, and large-scope evaluation has no predefined completion time, so a timing-unaware release gate produces false failures. [Evaluation triggers](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data#evaluation-triggers).

---

## Azure Policy — effects and remediation

**Classification:** Core
**Why it matters:** The effect decides whether a control is detective, preventive, corrective, protective, or manual. Corrective effects succeed only when a correctly permissioned managed identity and a remediation task exist. [Effect basics](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics) [Remediate non-compliant resources](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources)
**Primary Microsoft source:** [Azure Policy definitions effect basics](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics)
**Limits and quotas source:** [Remediate non-compliant resources](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources) and [Maximum count of Azure Policy objects](https://learn.microsoft.com/en-us/azure/governance/policy/overview#maximum-count-of-azure-policy-objects)

### Deep technical facts / requirements

1. **[Supported effects]** Each definition has exactly one effect from `addToNetworkGroup`, `append`, `audit`, `auditIfNotExists`, `deny`, `denyAction`, `deployIfNotExists`, `disabled`, `manual`, `modify`, and `mutate`. [Effect basics](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics).
2. **[Evaluation order]** For Resource Manager modes, Policy checks `disabled` first, then `append`/`modify` (which can change the request and prevent a later deny/audit), then `deny`, `audit`, `manual`, `auditIfNotExists`, and finally `denyAction`. `auditIfNotExists` and `deployIfNotExists` evaluate again after the resource provider returns success. `append` and `modify` are available only in Resource Manager modes. [Order of evaluation](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics#order-of-evaluation).
3. **[Incompatibility — interchangeability]** `audit`, `deny`, and `modify`/`append` are often interchangeable through a parameterized effect. `auditIfNotExists` and `deployIfNotExists` are often interchangeable. `manual` isn't interchangeable with anything, and `disabled` is interchangeable with every effect. `audit` checks the resource's own properties, whereas `auditIfNotExists` checks a child or extension resource and requires extra rule details. [Interchanging effects](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics#interchanging-effects).
4. **[Compliance state by effect]** `audit`, `auditIfNotExists`, and `modify` mark matching resources non-compliant for new, updated, and existing resources. `append`, `deny`, and `deployIfNotExists` show non-compliance only for **existing** resources because new/updated requests are denied or remediated at request time. [Non-compliant](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/compliance-states#non-compliant).
5. **[modify — operations and defaults]** `modify` supports `addOrReplace`, `add`, and `remove`, but `remove` works only on tags and `identity.type` can be changed only on VMs and VM scale sets. An alias must be **Modifiable** in the request's API version, otherwise the `conflictEffect` applies. `conflictEffect` accepts `audit`, `deny`, or `disabled` and **defaults to `deny`**; Microsoft recommends `audit` for alias-based modify definitions. [Azure Policy definitions modify effect](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-modify).
6. **[modify — existing resources]** During an evaluation cycle, `modify` doesn't change existing resources; it marks them non-compliant for a remediation task. It also skips modification when a nested property's parent object is absent from the request payload. [Skipped modification](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-modify#skipped-modification).
7. **[deployIfNotExists — defaults and maximums]** `evaluationDelay` defaults to `PT10M` (10 minutes) and accepts `AfterProvisioning`, `AfterProvisioningSuccess`, `AfterProvisioningFailure`, or an ISO 8601 duration of `0–360` minutes; provisioning longer than `6` hours counts as failure. `existenceScope` and `deploymentScope` both default to `ResourceGroup`, and subscription-level deployments require a `location`. Nested templates are supported but linked templates aren't. [deployIfNotExists properties](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deploy-if-not-exists#deployifnotexists-properties).
8. **[Identity split]** For `deployIfNotExists`, the **caller's** identity evaluates the existence condition and the **assignment's** identity performs the template deployment. For example, a diagnostic-settings policy needs the caller to hold `Microsoft.Insights/diagnosticSettings/read` and the assignment identity to hold the corresponding write permission. [Identity](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#identity) [How remediation access control works](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#how-remediation-access-control-works).
9. **[Prerequisites — managed identity]** Assignments with `deployIfNotExists` or `modify` need a managed identity, and each assignment can have only **one** identity (system- or user-assigned), though it can hold multiple roles. A system-assigned identity requires a top-level `location` that can't be `global` and can't be changed. A user-assigned identity can live at a different scope but must be in the same tenant. [Identity](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#identity) [Configure the managed identity](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#configure-the-managed-identity).
10. **[Prerequisites — roleDefinitionIds]** Custom `deployIfNotExists`/`modify` definitions must declare `roleDefinitionIds` as full role-definition resource IDs, not role names; built-ins are prepopulated. A `modify` role must include all operations granted by Contributor/Tag Contributor. [Configure the policy definition](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#configure-the-policy-definition) [Modify properties](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-modify#modify-properties).
11. **[Identity edge case — portal vs SDK]** The portal automatically grants listed roles to the assignment identity; SDK, CLI, PowerShell, and template deployments don't, so remediation fails until roles are granted manually. Manual grants are also required when the modified resource, or a property the template reads, is outside the assignment scope. Editing `roleDefinitionIds` later requires a manual grant even in the portal. [Grant permissions to the managed identity](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#grant-permissions-to-the-managed-identity-through-defined-roles).
12. **[Limits — remediation task]** `ResourceCount` defaults to `500` and has a maximum of `50,000` resources per task. `ParallelDeploymentCount` accepts `1–30` and defaults to `10`. `FailureThreshold` accepts `0–100` percent and defaults to `100`. A task remediates one `deployIfNotExists` or `modify` policy at a time, even inside an initiative assignment. [Create a remediation task](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#create-a-remediation-task).
13. **[denyAction — scope of protection]** `denyAction` supports only the `DELETE` action and returns `403 Forbidden`. Policy assignments, deny assignments, blueprint assignments, deployment stacks, subscriptions, and locks are exempt from `denyAction` to prevent lockout, and resources removed during subscription deletion aren't protected. Protected resources report the **Protected** compliance state. [DenyAction evaluation](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deny-action#denyaction-evaluation) [Protected](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/compliance-states#protected).
14. **[manual — defaults]** `manual` sets `defaultState` to `Unknown` (default), `Compliant`, or `Non-compliant`. Compliance changes only through attestations, which can be created only through the ARM API, PowerShell, or Azure CLI. Each applicable resource needs one attestation per manual assignment, so target subscriptions or resource groups. An attestation's `expiresOn` reverts the resource to the default state, and attestations are deleted when the assignment or reference ID is deleted. [Manual effect](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-manual) [Attestation structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/attestation-structure).
15. **[append vs modify]** Microsoft recommends `modify` over `append` for tags because `modify` has more operations and can remediate existing resources. Use `append` only when a managed identity can't be created or `modify` doesn't yet support the alias. [Azure Policy definitions modify effect](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-modify).

### Incompatibilities and mutual exclusions

- If a requirement demands **automatic correction of existing resources** **and** forbids creating managed identities, `modify` and `deployIfNotExists` can't be used because both require an assignment identity for remediation. `append` doesn't remediate existing resources, so the design falls back to `audit` plus owned manual change. [Remediate non-compliant resources](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources) [Azure Policy definitions modify effect](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-modify).
- If a `denyAction` policy must stop **resource group deletion** **and** the protected resources don't support tags and location (or the definition uses `mode: all`), resource group deletion isn't blocked. Blocking requires `indexed` mode with `cascadeBehaviors` set to `deny`. [Resource group deletion](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deny-action#resource-group-deletion).
- If `remove` is required for a non-tag property, `modify` can't perform it because `remove` is supported only for tags. [Modify operations](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-modify#modify-operations).

### Edge cases and gotchas

- `denyAction` on a child or extension resource (such as `diagnosticSettings`) doesn't stop deletion of the parent (such as a storage account), which cascade-deletes the protected child. [Cascade deletion](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deny-action#cascade-deletion).
- If more than one `modify` definition with `deny` conflicts on a new request, the request is denied as a conflict; for existing resources the compliance state becomes `Conflict`. [Modify properties](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-modify#modify-properties).
- A long `evaluationDelay` can leave a resource's recorded compliance state stale until the next evaluation trigger. [deployIfNotExists properties](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deploy-if-not-exists#deployifnotexists-properties).
- The portal's "create a remediation task during assignment" option is supported for subscription-scoped assignments. For management-group assignments, create the task after evaluation has determined compliance. [Option 3: Create a remediation task during policy assignment](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#option-3-create-a-remediation-task-during-policy-assignment).
- Changing a policy definition doesn't automatically update the assignment or its managed identity's permissions. [How remediation access control works](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#how-remediation-access-control-works).

### AZ-305 exam discriminator

"Block new noncompliant deployments" selects `deny`. "Fix existing resources" requires `modify` or `deployIfNotExists` **plus** a remediation task (up to 50,000 resources per task) and a least-privilege assignment identity. "Stop deletion regardless of role" selects `denyAction` (DELETE only). "Controls needing human proof" selects `manual` with attestations. [Effect basics](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics) [Remediate non-compliant resources](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources) [denyAction effect](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deny-action).

### Common trap

Believing a policy-as-code pipeline that deploys a `deployIfNotExists` assignment through CLI or Bicep will remediate on its own. Only the portal auto-grants the identity's roles, and even then existing resources stay non-compliant until a remediation task runs. [Grant permissions to the managed identity](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#grant-permissions-to-the-managed-identity-through-defined-roles).

---

## Azure Policy — exclusions, exemptions, and staged enforcement

**Classification:** Core
**Why it matters:** Auditors care as much about how exceptions are approved, scoped, and expired as about the baseline itself. Rollout controls determine whether a new guardrail breaks production. [Understand scope in Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/scope) [Safe deployment of Azure Policy assignments](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/policy-safe-deployment-practices)
**Primary Microsoft source:** [Details of the policy exemption structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure)
**Limits and quotas source:** [Maximum count of Azure Policy objects](https://learn.microsoft.com/en-us/azure/governance/policy/overview#maximum-count-of-azure-policy-objects) and [Details of the policy assignment structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure)

### Deep technical facts / requirements

1. **[Limits and quotas]** `1,000` exemptions per scope and `400` `notScopes` per assignment. Exemption and assignment `displayName` is limited to `128` characters and `description` to `512`, and each assignment `metadata` property to `1,024` characters. [Maximum count of Azure Policy objects](https://learn.microsoft.com/en-us/azure/governance/policy/overview#maximum-count-of-azure-policy-objects) [Display name and description](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure#display-name-and-description) [Metadata](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#metadata).
2. **[Behavior — exclusion vs exemption]** Resources in `notScopes` aren't evaluated and aren't counted toward compliance, and adding an exclusion modifies the assignment object. An exemption is a separate Resource Manager object that leaves the assignment unchanged and reports resources as **Exempt**. Microsoft recommends exclusions for permanent, broad bypass (for example, a test environment) and exemptions for time-bound or specific cases that must stay tracked. [Scope comparison](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/scope#scope-comparison).
3. **[Configuration — categories]** `Mitigated` means the policy intent is met another way. `Waiver` means non-compliance is temporarily accepted, or the resource should be excluded from specific definitions rather than the entire initiative. [Exemption category](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure#exemption-category).
4. **[Defaults — expiration]** `expiresOn` is optional ISO 8601 UTC. When the date passes, the exemption **isn't deleted**; it's kept for record-keeping but no longer honored. [Expiration](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure#expiration).
5. **[Identity, RBAC, and access]** Creating an exemption requires `Microsoft.Authorization/policyExemptions/write` on the target **and** the `exempt/Action` permission on the target assignment. Resource Policy Contributor and Security Admin have read and write on exemptions, and Policy Insights Data Writer (Preview) has read. [Required permissions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure#required-permissions).
6. **[Lifecycle]** An exemption is a child object of the exempted resource or hierarchy and is removed when that parent is removed. Creating, updating, or deleting an exemption re-evaluates the assignment for the exemption scope. [Details of the policy exemption structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure) [Evaluation triggers](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data#evaluation-triggers).
7. **[Initiative-specific exemptions]** `policyAssignmentId` is a single string, not an array. For initiative assignments, the `policyDefinitionReferenceId` array exempts only the listed member definitions. [Policy definition IDs](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure#policy-definition-ids).
8. **[Preview — cross-scope exemptions]** **[Preview]** `assignmentScopeValidation: DoNotValidate` allows an exemption outside the assignment scope. It exists to pre-exempt a subscription's resources before moving it into a management group whose policy would otherwise block the move. [Assignment scope validation (preview)](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure#assignment-scope-validation-preview).
9. **[Identity-based exemptions]** Exemption resource selectors support `userPrincipalId` and `groupPrincipalId`, letting a specific user, managed identity, service principal, or security group bypass an assignment's enforcement. [Identity based exemptions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure#identity-based-exemptions).
10. **[Evidence — compliance substate]** For exempt resources, the compliance substate shows what the state would be without the exemption. It's queryable org-wide in Azure Resource Graph at `properties.stateDetails.complianceSubState` in `policyresources`. [Compliance substate](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure#compliance-substate).
11. **[Limits — staged rollout controls]** Each assignment allows up to `10` `resourceSelectors`, with kinds `resourceLocation`, `resourceType`, and `resourceWithoutLocation` and up to `50` values per `in`/`notIn` list. It allows up to `10` overrides, each covering up to `50` `policyDefinitionReferenceId` values. Override kinds are `policyEffect` and `policyVersion`, and overrides are evaluated in order and validated against the rule's allowed values. [Resource selectors](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#resource-selectors) [Overrides](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#overrides).
12. **[Defaults — enforcementMode]** `Default` enforces and writes Activity Log entries. `DoNotEnforce` still evaluates compliance but doesn't enforce the effect or write Activity Log entries. `Enroll` enforces only for enrolled resources, and non-enrolled in-scope resources behave like `DoNotEnforce` by default. Remediation tasks can still start for `deployIfNotExists` policies under `DoNotEnforce`. [Enforcement mode](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#enforcement-mode).
13. **[Preview — enrollments]** **[Preview API — verify GA status before specifying]** Policy enrollments (`Microsoft.Authorization/policyEnrollments`, documented API `2025-02-01-preview`) require the referenced assignment to use `Enroll` mode. They can be managed with Azure CLI, ARM, Bicep, or Terraform AzAPI, support up to `10` resource selectors, and `PATCH` updates only `assignmentScopeValidation` and `resourceSelectors`. [Details of the policy enrollment structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/enrollment-structure).
14. **[Safe deployment practice]** For `deny`/`append`, Microsoft's rollout assigns at the highest scope, narrows with a `resourceLocation` selector to the least critical tier, overrides the effect to `audit`, expands tier by tier, then switches to `deny` and expands again. For `modify`/`deployIfNotExists`, `enforcementMode: DoNotEnforce` replaces the audit override and remediation is validated at each tier. [Safe deployment of Azure Policy assignments](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/policy-safe-deployment-practices).

### Incompatibilities and mutual exclusions

- If an exception must **remain visible, approved, and expiring** in compliance reports, `notScopes` can't be used, because excluded resources aren't evaluated or counted. Use an exemption with category, metadata, and `expiresOn`. [Scope comparison](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/scope#scope-comparison).
- If an exception must target an individual **Resource Provider mode component** (for example, a single Kubernetes pod), an exemption can't be created at that component level. [Details of the policy exemption structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure) [Resource Provider modes](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-basics#resource-provider-modes).
- A single resource selector can't combine `resourceLocation` with `resourceWithoutLocation`, and a list can't use both `in` and `notIn`. [Resource selectors](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#resource-selectors).

### Edge cases and gotchas

- Expired exemptions still exist as objects, so periodic cleanup and renewal review is a design requirement, not an automatic behavior. [Exemption creation and management](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure#exemption-creation-and-management).
- An override of kind `policyVersion` must specify a version greater than or equal to the assignment's `definitionVersion`. [Overrides](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#overrides).
- Exemptions also work with `Microsoft.Kubernetes.Data`, `Microsoft.KeyVault.Data`, and `Microsoft.Network.Data` modes at the resource or hierarchy level. [Details of the policy exemption structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure).
- `notScopes` can be added or updated after the assignment is created, but doing so changes the governed assignment object and should go through policy-as-code review. [Excluded scopes](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#excluded-scopes) [Design Azure Policy as Code workflows](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/policy-as-code).

### AZ-305 exam discriminator

**One resource + approved compensating control + auditor + expiry date** means a `Mitigated` exemption with metadata and `expiresOn`. **Permanently ungoverned sandbox** means `notScopes`. **Roll out gradually without forking the initiative** means resource selectors plus effect overrides (or `DoNotEnforce`). [Scope comparison](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/scope#scope-comparison) [Safe deployment of Azure Policy assignments](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/policy-safe-deployment-practices).

### Common trap

Assuming `expiresOn` deletes the exemption or that Contributor can create one. The object persists after expiry, and creation needs both exemption write permission and `exempt/Action` on the assignment. [Expiration](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure#expiration) [Required permissions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure#required-permissions).

---

## Azure Machine Configuration

**Classification:** Core
**Why it matters:** Ordinary Resource Manager policy can't see registry keys, local files, packages, or cipher settings inside an OS. Machine Configuration audits or applies those settings on Azure VMs and Arc-enabled servers and reports through Azure Policy. [What is Azure Machine Configuration?](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/01-overview-concepts)
**Primary Microsoft source:** [What is Azure Machine Configuration?](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/01-overview-concepts)
**Limits and quotas source:** [Azure Machine Configuration prerequisites](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites) and [Azure Policy pricing](https://azure.microsoft.com/en-us/pricing/details/azure-policy/)

### Deep technical facts / requirements

1. **[Limits and quotas]** A machine supports up to `50` guest assignments. The in-guest agent may not exceed `5%` CPU, and the same cap applies to the Machine Configuration service in the Arc Connected Machine agent. [What is Azure Machine Configuration?](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/01-overview-concepts) [Limits set on the extension](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites#limits-set-on-the-extension).
2. **[Enforcement modes]** Assignments use `Audit` (report only), `ApplyAndMonitor` (apply once, then report drift), or `ApplyAndAutoCorrect` (apply and restore conformance when drift occurs). [Enforcement modes for custom policies](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/01-overview-concepts#enforcement-modes-for-custom-policies) [Understand machine configuration assignment resources](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/concepts/assignments).
3. **[Prerequisites — resource provider]** The `Microsoft.GuestConfiguration` resource provider must be registered. It's registered automatically when a Machine Configuration policy is assigned through the portal or when the subscription is enrolled in Defender for Cloud. [Resource provider](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites#resource-provider).
4. **[Prerequisites — Azure VMs vs Arc]** Azure VMs require the Machine Configuration extension **and** a system-assigned managed identity. Arc-enabled servers don't need the extension because it's built into the Connected Machine agent. The at-scale prerequisite initiative is `Deploy prerequisites to enable Guest Configuration policies on virtual machines`. [Deploy requirements for Azure virtual machines](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites#deploy-requirements-for-azure-virtual-machines).
5. **[Version requirements]** Packages that **apply** configuration require Azure VM guest configuration extension version `1.26.24` or later. In-guest validation uses side-loaded PowerShell DSC v2 on Windows, and on Linux uses PowerShell DSC v3 or installs Chef InSpec `2.2.61`. [Validation tools](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites#validation-tools).
6. **[Defaults — evaluation frequency]** The agent checks for new or changed guest assignments every `5` minutes and re-checks each received configuration every `15` minutes. Multiple configurations run sequentially, so a long-running configuration delays the others. [Validation frequency](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites#validation-frequency).
7. **[Supported platforms]** Supported Azure images include Windows Server `2012–2025`, Windows 10/11, Ubuntu `16.04–24.x`, RHEL `7.4–10.x`, SLES 12 SP5 and 15.x, Debian `10.x–13.x`, Rocky 8–9, AlmaLinux 9, and Azure Linux 3. Red Hat CoreOS and Arm64 Azure VMs aren't supported, and out-of-support Linux versions are excluded. [Supported client types](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/01-overview-concepts#supported-client-types).
8. **[Incompatibility — scale sets]** Machine Configuration doesn't support Virtual Machine Scale Sets in Uniform orchestration; it supports scale sets with Flexible orchestration. [Supported client types](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/01-overview-concepts#supported-client-types).
9. **[Identity]** The prerequisite initiative adds a **system-assigned** identity even when a user-assigned identity already exists. Applications that don't specify their user-assigned identity in token requests then default to the system-assigned identity. [Managed identity requirements](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites#managed-identity-requirements).
10. **[Resource model]** For `auditIfNotExists` and `deployIfNotExists` definitions, the service creates a `Microsoft.GuestConfiguration/guestConfigurationAssignments` extension resource on the machine. Azure Policy reads its `complianceStatus` to report compliance. [How Azure Policy uses machine configuration assignments](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/concepts/assignments#how-azure-policy-uses-machine-configuration-assignments).
11. **[Hybrid coverage]** Audit definitions include the `Microsoft.HybridCompute/machines` type, so Arc-enabled servers in scope are included automatically. [Assigning policies to machines outside of Azure](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites#assigning-policies-to-machines-outside-of-azure).
12. **[Cost]** Azure Policy has no charge on Azure resources, and Machine Configuration on Arc-enabled servers costs $6 per server per month, including access to configuration and change tracking in Azure Automation. [Azure Policy pricing](https://azure.microsoft.com/en-us/pricing/details/azure-policy/).
13. **[Preview — Essential Machine Management]** **[Preview]** Essential Machine Management enables Machine Configuration (Windows/Linux security baselines in **Audit only** mode) with Update Manager, Azure Monitor, and Change Tracking. It's free for Azure VMs and for Arc servers covered by Windows Server Software Assurance, PayGo, or ESU. Other Arc servers will cost $9 per server per month once billing begins on a future date, and VMs can't be excluded in an enabled subscription. [Enable Essential Machine Management (preview)](https://learn.microsoft.com/en-us/azure/azure-arc/servers/essential-machine-management/enrollment).

### Incompatibilities and mutual exclusions

- If in-guest compliance is required **and** the workload runs on a **Uniform** scale set or an **Arm64 Azure VM**, Machine Configuration can't be used as specified. Move to Flexible orchestration or a supported architecture, or use another assessment mechanism. [Supported client types](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/01-overview-concepts#supported-client-types).
- If Azure VMs must be governed **and** a system-assigned managed identity is prohibited, Machine Configuration can't manage them, because the extension and a system-assigned identity are both required on Azure VMs. [Deploy requirements for Azure virtual machines](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites#deploy-requirements-for-azure-virtual-machines).

### Edge cases and gotchas

- An on-demand Azure Policy scan retrieves the latest value from the Machine Configuration resource provider but **doesn't** trigger new activity inside the machine. [Validation frequency](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites#validation-frequency).
- Deleting a policy assignment deletes the guest assignments it created. Removing a policy from an **initiative** leaves those guest assignments behind until they're deleted manually. [Deletion of guest assignments from Azure Policy](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/concepts/assignments#deletion-of-guest-assignments-from-azure-policy).
- On custom deploy policies, `assignmentType` can temporarily show `Null`, typically resolving within one hour. [How Azure Policy uses machine configuration assignments](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/concepts/assignments#how-azure-policy-uses-machine-configuration-assignments).
- Configurations are distinct from policy definitions and can be assigned manually without Azure Policy; manually created assignments must be deleted manually. [Deletion of manually created machine configuration assignments](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/concepts/assignments#deletion-of-manually-created-machine-configuration-assignments).

### AZ-305 exam discriminator

Any requirement phrased as "inside the operating system" (registry, file, package, TLS/cipher, local account) on Azure VMs **or** on-premises/other-cloud servers selects Machine Configuration, with Azure Arc for non-Azure machines. Choose `ApplyAndAutoCorrect` when drift must be reversed automatically, and plan for 50 assignments per machine and 15-minute re-checks. [What is Azure Machine Configuration?](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/01-overview-concepts) [Validation frequency](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites#validation-frequency).

### Common trap

Assuming the extension alone is enough on Azure VMs, or that Arc servers need it too. Azure VMs need the extension **and** a system-assigned identity, while Arc-enabled servers get the capability from the Connected Machine agent. [Deploy requirements for Azure virtual machines](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites#deploy-requirements-for-azure-virtual-machines).

---

## Microsoft Defender for Cloud regulatory compliance

**Classification:** Core
**Why it matters:** Defender for Cloud continuously assesses resources in Azure, AWS, and GCP against security benchmarks and regulatory standards. It surfaces pass/fail controls, manual attestations, reports, and export, but its plan and role prerequisites often decide scenario answers. [Improve regulatory compliance in Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard)
**Primary Microsoft source:** [Regulatory compliance in Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-regulatory-compliance-standards)
**Limits and quotas source:** [What is CSPM (plan comparison and billable resources)](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-cloud-security-posture-management) and [Set up continuous export](https://learn.microsoft.com/en-us/azure/defender-for-cloud/continuous-export)

### Deep technical facts / requirements

1. **[Defaults — standards per cloud]** Enabling Defender for Cloud enables MCSB on Azure; MCSB plus AWS Foundational Security Best Practices on AWS; and MCSB plus GCP Default on GCP. [Default compliance standards](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-regulatory-compliance-standards#default-compliance-standards).
2. **[Preview vs GA / change]** Starting **October 27, 2026**, Foundational CSPM becomes opt-in and is no longer enabled by default for new Azure subscriptions. It stays free, existing enabled subscriptions stay enabled, and AWS/GCP onboarding is unaffected. [What is CSPM](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-cloud-security-posture-management).
3. **[Plan gating]** Nondefault compliance standards can be added only when at least one paid Defender plan is enabled. The CSPM comparison lists regulatory compliance assessments, governance rules, attack path analysis, and custom recommendations under Defender CSPM, not Foundational CSPM. [Before you start](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard#before-you-start) [What is CSPM](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-cloud-security-posture-management).
4. **[Regional/cloud availability of standards]** PCI DSS v4.0.1, ISO/IEC 27001:2022, NIST SP 800-53 R5.1.1, SOC 2023, DORA, and the EU AI Act are available for Azure, AWS, and GCP. HIPAA, FedRAMP H and M, and UK OFFICIAL/UK NHS are Azure-only, and CCPA is AWS and GCP only. [Available compliance standards](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-regulatory-compliance-standards#available-compliance-standards).
5. **[Defaults — assessment frequency]** Regulatory compliance assessments run approximately every `12` hours, so remediation appears in the dashboard only after the next run. [Investigate issues](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard#investigate-issues).
6. **[Identity, RBAC, and access]** Reading the dashboard requires access to policy compliance data. **Reader** on the subscription has that access and **Security Reader doesn't**, and Microsoft lists Resource Policy Contributor plus Security Admin as the minimum roles. [Before you start](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard#before-you-start).
7. **[Edge — non-automatable controls]** Controls that can't be assessed automatically show greyed out with no verdict. A standard doesn't appear on the dashboard at all if the subscription has no relevant resources, even when assigned. [Compliance controls](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-regulatory-compliance-standards#compliance-controls).
8. **[Manual evidence]** Manual assessments can be attested per subscription with evidence attached. A **Download report** produces a point-in-time PDF/CSV summary, and **Audit reports** downloads Microsoft certification reports (PCI, SOC, ISO, and others). [Remediate a manual assessment](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard#remediate-a-manual-assessment) [Generate compliance status reports and certificates](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard#generate-compliance-status-reports-and-certificates).
9. **[Resiliency / export defaults]** Continuous export targets a Log Analytics workspace or Event Hubs, including in another subscription or tenant. **Streaming** sends assessments only when a resource's health state changes (nothing if no updates occur), while **snapshots** send current state once a week per subscription (field `IsSnapshot`). [Create a continuous export configuration](https://learn.microsoft.com/en-us/azure/defender-for-cloud/continuous-export#create-a-continuous-export-configuration).
10. **[Limits — export]** Log Analytics accepts only records up to `32` KB; larger records trigger a "Data limit has been exceeded" alert. [Set up continuous export](https://learn.microsoft.com/en-us/azure/defender-for-cloud/continuous-export).
11. **[Prerequisites — export permissions]** Continuous export requires Security Admin or Owner on the resource group, write permission on the target, and write on the Event Hubs policy for Event Hubs targets. Workspaces without the SecurityCenterFree solution need `Microsoft.OperationsManagement/solutions/action`. At-scale configuration uses `DeployIfNotExists` policies and requires policy-assignment permissions. [Prerequisites](https://learn.microsoft.com/en-us/azure/defender-for-cloud/continuous-export#prerequisites).
12. **[Cost]** Defender CSPM bills only specific resource types: on Azure, VMs, scale sets, and classic VMs (excluding deallocated and Databricks VMs); storage accounts (excluding those without blob containers or file shares); SQL servers; PostgreSQL and MySQL flexible servers; and Synapse workspaces. [Supported clouds and resources](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-cloud-security-posture-management#supported-clouds-and-resources).
13. **[Integration]** When a standard is added in Defender for Cloud (including AWS/GCP standards), resource-level compliance data automatically appears in Purview Compliance Manager for the same standard. Workflow automation can trigger Logic Apps when a compliance assessment changes state. [Integration with Purview](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard#integration-with-purview) [Trigger a workflow when assessments change](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard#trigger-a-workflow-when-assessments-change).

### Incompatibilities and mutual exclusions

- If auditors are given **Security Reader only** **and** must view regulatory compliance data, the design fails, because Security Reader lacks access to policy compliance data; grant Reader (or higher) at the correct scope. [Before you start](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard#before-you-start).
- If a design must **assign or configure** standards **and** uses only the Defender portal, it can't, because the Defender portal is consumption-only and assignment is managed in the Azure portal. [Regulatory compliance in Defender for Cloud — Defender portal](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-regulatory-compliance-standards).
- If organization-specific KQL-based assessments are required **and** only Foundational CSPM is enabled, custom recommendations aren't available; they require Defender CSPM. [Custom recommendations](https://learn.microsoft.com/en-us/azure/defender-for-cloud/security-policy-concept#custom-recommendations).

### Edge cases and gotchas

- Streaming export is change-driven, so it never produces a full inventory of unchanged findings; combine it with weekly snapshots when auditors need complete periodic state. [Create a continuous export configuration](https://learn.microsoft.com/en-us/azure/defender-for-cloud/continuous-export#create-a-continuous-export-configuration).
- Downloading certification reports records the user and selected subscriptions so Microsoft can notify about report updates. [Generate compliance status reports and certificates](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard#generate-compliance-status-reports-and-certificates).
- Risk prioritization of recommendations doesn't affect the secure score. [Security recommendations](https://learn.microsoft.com/en-us/azure/defender-for-cloud/security-policy-concept#security-recommendations).
- New Azure subscriptions created on or after October 27, 2026 won't show MCSB posture until someone opts in to Foundational CSPM. [What is CSPM](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-cloud-security-posture-management).

### AZ-305 exam discriminator

"Continuous assessment against PCI DSS / ISO 27001 / NIST across Azure **and AWS/GCP**" selects Defender for Cloud regulatory compliance with a paid plan (Defender CSPM). "Export weekly posture for auditors" selects continuous export **snapshots**, and "SIEM streaming" selects Event Hubs streaming. Defender assesses, but it isn't the request-time deny engine. [Available compliance standards](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-regulatory-compliance-standards#available-compliance-standards) [Set up continuous export](https://learn.microsoft.com/en-us/azure/defender-for-cloud/continuous-export).

### Common trap

Treating a green dashboard as certification. Non-automatable controls are greyed out with no verdict, and standards with no relevant resources are hidden entirely. [Compliance controls](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-regulatory-compliance-standards#compliance-controls).

---

## Microsoft Purview Compliance Manager

**Classification:** Core
**Why it matters:** Compliance Manager is the program-level system for assessments, owners, improvement actions, evidence, and scoring across Microsoft 365, Azure, AWS, and GCP. It's the answer when the scenario emphasizes auditors, evidence, and accountability rather than resource enforcement. [Microsoft Purview Compliance Manager](https://learn.microsoft.com/en-us/purview/compliance-manager)
**Primary Microsoft source:** [Microsoft Purview Compliance Manager](https://learn.microsoft.com/en-us/purview/compliance-manager)
**Limits and quotas source:** [Learn about regulations — availability and licensing](https://learn.microsoft.com/en-us/purview/compliance-manager-regulations#regulation-availability-and-licensing) and [Compliance Manager scoring](https://learn.microsoft.com/en-us/purview/compliance-manager-scoring)

### Deep technical facts / requirements

1. **[Limits — templates]** Compliance Manager provides more than `360` regulatory templates, and custom regulation templates can be created. [Regulations](https://learn.microsoft.com/en-us/purview/compliance-manager#regulations).
2. **[Licensing gating]** The Microsoft Data Protection Baseline template is available at every subscription level, while **premium** templates require a purchased license. Depending on the licensing agreement, up to `3` extra premium templates may be free. A purchased template license allows unlimited assessments for that regulation for `1` year (auto-renewing), and templates appear within `48` hours. [Regulation availability and licensing](https://learn.microsoft.com/en-us/purview/compliance-manager-regulations#regulation-availability-and-licensing) [Purchasing premium regulations](https://learn.microsoft.com/en-us/purview/compliance-manager-regulations#purchasing-premium-regulations).
3. **[Limits — trial]** Premium trial licenses cover up to `25` templates for `90` days. [Staring a premium trial](https://learn.microsoft.com/en-us/purview/compliance-manager-regulations#staring-a-premium-trial).
4. **[Prerequisites — licensing]** Compliance Manager is available to organizations with Office 365 or Microsoft 365 licenses and to US GCC Moderate, GCC High, and DoD customers. Assessment availability depends on the licensing agreement. [Who can access Compliance Manager](https://learn.microsoft.com/en-us/purview/compliance-manager-setup#who-can-access-compliance-manager).
5. **[Identity, RBAC, and access]** Roles are Compliance Manager Reader, Contribution (edit and create assessments), Assessor (edit, can't create), and Administration (manage assessments, templates, and tenant data). A user holds one role at a time, and at least Reader (or Entra Global Reader) is required. GCC High and DoD customers can set these roles only in Microsoft Entra ID. [Role types](https://learn.microsoft.com/en-us/purview/compliance-manager-setup#role-types).
6. **[Scoped access]** Roles can be granted per assessment or per regulation, and a regulation-level role applies to existing and future assessments built on that regulation. External auditors receive access through a Microsoft Entra role. [Role-based access to assessments and regulations](https://learn.microsoft.com/en-us/purview/compliance-manager-setup#role-based-access-to-assessments-and-regulations) [Grant user access to regulations](https://learn.microsoft.com/en-us/purview/compliance-manager-regulations#grant-user-access-to-regulations).
7. **[Scoring values]** Action points: preventative mandatory `27`, preventative discretionary `9`, detective mandatory `3`, detective discretionary `1`, corrective mandatory `3`, corrective discretionary `1`. Points are awarded per action per assessment, except tenant-scoped technical actions, which count once. [Action types and scoring](https://learn.microsoft.com/en-us/purview/compliance-manager-scoring#action-types-and-scoring).
8. **[Defaults — score and testing]** The initial score is based on the Microsoft 365 data protection baseline (drawn from NIST CSF, ISO, FedRAMP, and GDPR). Automated testing is on by default, takes about `7` days to collect data, and updates action status within `24` hours of a change. [Initial score](https://learn.microsoft.com/en-us/purview/compliance-manager-scoring#initial-score-based-on-microsoft-365-data-protection-baseline) [Testing source for automated testing](https://learn.microsoft.com/en-us/purview/compliance-manager-setup#testing-source-for-automated-testing).
9. **[Multicloud dependency]** Assessment of Azure, AWS, and GCP relies on Defender for Cloud integration. Automated test results are pulled from Defender for Cloud only for subscriptions in scope for a matching regulation, and unsupported services use a universal template with manual implementation and testing. [Multicloud support in Compliance Manager](https://learn.microsoft.com/en-us/purview/compliance-manager-multicloud).
10. **[Defender-backed scoring]** A Defender-supported action's score is the average of its subscriptions' scores; for example, 0% on one subscription and 50% on another gives 25%. [Actions for services supported by Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/purview/compliance-manager-scoring#actions-for-services-supported-by-microsoft-defender-for-cloud).
11. **[Responsibility model]** Assessments separate Microsoft-managed controls, customer ("your") controls, and shared controls, and Microsoft-managed actions show implementation details and audit results. [Key elements](https://learn.microsoft.com/en-us/purview/compliance-manager#key-elements-controls-assessments-regulations-improvement-actions).
12. **[Evidence retention / reporting]** The Reports page shows `7` days of activity by default, filterable back up to `6` months. User history can be exported per user, and deleting a user's history is permanent. [Reports page](https://learn.microsoft.com/en-us/purview/compliance-manager-setup#reports-page) [Delete user history](https://learn.microsoft.com/en-us/purview/compliance-manager-setup#delete-user-history).

### Incompatibilities and mutual exclusions

- If users have **Microsoft Entra identities but no Office 365 or Microsoft 365 subscription**, they can't access Compliance Manager in the Purview portal. [Set user permissions and assign roles](https://learn.microsoft.com/en-us/purview/compliance-manager-setup#set-user-permissions-and-assign-roles).
- If the organization is in **GCC Moderate, GCC High, or DoD** **and** needs to assess a non-listed service, universal templates aren't available to it. [Regulations overview](https://learn.microsoft.com/en-us/purview/compliance-manager-regulations#regulations-overview).
- If a requirement needs **automated testing** of an improvement action **and** the team uploads its own testing data or evidence into that action, automated testing turns off for that action to avoid overwriting data. [When actions are added or updated](https://learn.microsoft.com/en-us/purview/compliance-manager-setup#when-actions-are-added-or-updated).

### Edge cases and gotchas

- Templates in the same regulation family (for example, CMMC Level 1 and Level 2) count as **one** activated template. [Regulations details page](https://learn.microsoft.com/en-us/purview/compliance-manager-regulations#regulations-details-page).
- A licenses counter such as `5/2` means the tenant exceeds its entitlement and must purchase `3` more premium regulations. [Regulation licenses counter](https://learn.microsoft.com/en-us/purview/compliance-manager-regulations#regulation-licenses-counter).
- The overall compliance score can differ from the average of assessment scores because actions are de-duplicated differently at tenant and assessment levels. [Understanding your compliance score](https://learn.microsoft.com/en-us/purview/compliance-manager-scoring#understanding-your-compliance-score).
- Microsoft states Compliance Manager recommendations aren't a guarantee of compliance; customers must validate control effectiveness for their regulatory environment. [Compliance Manager scoring](https://learn.microsoft.com/en-us/purview/compliance-manager-scoring).

### AZ-305 exam discriminator

"Auditor," "evidence," "improvement actions assigned to owners," "Microsoft 365 plus Azure/AWS/GCP," or "compliance score" select Purview Compliance Manager, with Defender for Cloud feeding resource-level results. "Block noncompliant Azure deployments" never selects it. [Microsoft Purview Compliance Manager](https://learn.microsoft.com/en-us/purview/compliance-manager) [Multicloud support](https://learn.microsoft.com/en-us/purview/compliance-manager-multicloud).

### Common trap

Maximizing the score by chasing 27-point preventative mandatory actions regardless of applicability. The score is risk-weighted guidance, and Microsoft explicitly says it isn't a guarantee of compliance. [Compliance Manager scoring](https://learn.microsoft.com/en-us/purview/compliance-manager-scoring).

---

## Management groups

**Classification:** Supporting
**Why it matters:** Compliance controls inherit from management groups to every descendant subscription, and hierarchy settings decide whether newly created subscriptions land under the right controls. [Management groups overview](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)
**Primary Microsoft source:** [Organize your resources with management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)
**Limits and quotas source:** [Azure subscription and service limits — management groups](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits)

### Deep technical facts / requirements

1. **[Limits and quotas]** `10,000` management groups per Microsoft Entra tenant, depth of root plus `6` levels (excluding root and subscription level), one direct parent per group or subscription, unlimited subscriptions per group, and `800` management-group-level deployments in history. [Azure subscription and service limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits) [Important facts about management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#important-facts-about-management-groups).
2. **[Defaults — new subscriptions]** New subscriptions default to the root management group, so root-level policy applies to them immediately. The **default management group** hierarchy setting sends new subscriptions to a different group with controls suited to them. [Setting: Define the default management group](https://learn.microsoft.com/en-us/azure/governance/management-groups/how-to/protect-resource-hierarchy#setting-define-the-default-management-group).
3. **[Identity — hierarchy settings]** By default any user can create management groups. **Require authorization** limits creation to principals with `Microsoft.Management/managementGroups/write` on the root. Configuring hierarchy settings requires `settings/write` and `settings/read` on the root, available in the Hierarchy Settings Administrator role. [Protect your resource hierarchy](https://learn.microsoft.com/en-us/azure/governance/management-groups/how-to/protect-resource-hierarchy).
4. **[Identity — root access]** No one has default access to the root management group, and only Microsoft Entra Global Administrators can elevate themselves to gain it. Any policy or access assignment at root applies to every resource in the directory. [Important facts about the root management group](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#important-facts-about-the-root-management-group).
5. **[Incompatibility — custom roles]** Custom roles with `DataActions` can't be assigned at management-group scope, and a custom role's assignable scopes can include only one management group. [Limitations](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#limitations).
6. **[Edge — propagation]** Azure Resource Manager caches hierarchy details for up to `30` minutes, so moves may not appear immediately. [Moving management groups and subscriptions](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#moving-management-groups-and-subscriptions).
7. **[Prerequisites — moves]** Moving a subscription requires management-group write and role-assignment write on the child plus management-group write on the current and target parents. The requirement is waived when either parent is the root. [Moving management groups and subscriptions](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#moving-management-groups-and-subscriptions).

### Incompatibilities and mutual exclusions

If subscriptions from **multiple Microsoft Entra tenants** must share one inherited compliance baseline, a single management group can't hold them, because all subscriptions in a management group must trust the same tenant. [Organize your resources with management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview).

### Edge cases and gotchas

- Moving a subscription out from under a management group where a custom role is defined breaks the role-assignment path and the move is rejected. Remove the assignment or widen assignable scopes first. [Issues with breaking the role definition and assignment hierarchy path](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#issues-with-breaking-the-role-definition-and-assignment-hierarchy-path).
- Management groups aren't currently supported in Cost Management for Microsoft Customer Agreement subscriptions. [Hierarchy of management groups and subscriptions](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#hierarchy-of-management-groups-and-subscriptions).
- Management-group activity (including policy-assignment changes) appears in Activity Log and can be routed to Log Analytics, Storage, or Event Hubs through management-group diagnostic settings via REST. [Auditing management groups by using activity logs](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#auditing-management-groups-by-using-activity-logs).

### AZ-305 exam discriminator

"Ensure every new subscription is immediately governed by the regulated baseline, without applying it tenant-wide" selects a **default management group** hierarchy setting pointing to the regulated branch, not a root assignment. [Protect your resource hierarchy](https://learn.microsoft.com/en-us/azure/governance/management-groups/how-to/protect-resource-hierarchy).

### Common trap

Assuming a subscription move is reflected instantly in inherited compliance. The hierarchy is cached for up to 30 minutes, and subscription-targeted policy evaluation after a move takes about 30 minutes. [Moving management groups and subscriptions](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#moving-management-groups-and-subscriptions) [Evaluation triggers](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data#evaluation-triggers).

---

## Regulatory Compliance initiatives and the Microsoft cloud security benchmark

**Classification:** Supporting
**Why it matters:** These supply the framework-to-control mapping that makes Policy and Defender results readable as compliance evidence, including who owns each control. [Regulatory Compliance in initiative definitions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance)
**Primary Microsoft source:** [Regulatory Compliance in initiative definitions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance) and [Microsoft cloud security benchmark introduction](https://learn.microsoft.com/en-us/security/benchmark/azure/introduction)

### Deep technical facts / requirements

1. **[Preview status]** **[Preview]** Regulatory Compliance in Azure Policy is labeled a Preview feature, and existing standard initiatives are still being updated to support it. [Regulatory Compliance in initiative definitions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance).
2. **[Prerequisites — structure]** A Regulatory Compliance initiative must set `category` to **Regulatory Compliance** and use `policyDefinitionGroups` for each control (name), compliance domain (category), and `policyMetadata` reference. The portal then adds a **Controls** tab showing responsibility and per-control counts. [Regulatory Compliance defined](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance#regulatory-compliance-defined).
3. **[Responsibility model]** Controls are grouped by Customer, Microsoft, or Shared responsibility. Microsoft-responsible controls use `policyType: Static`, shown as **Microsoft managed**, with results from non-Microsoft audits of Microsoft infrastructure. [Regulatory Compliance in initiative definitions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance) [Policy type](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-basics#policy-type).
4. **[Maintenance edge]** Customers can copy built-in regulatory initiatives, and Microsoft recommends monitoring the Azure Policy GitHub source for changes. Linking a custom Regulatory Compliance initiative to the Defender for Cloud dashboard is a separate configuration step. [Regulatory Compliance defined](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance#regulatory-compliance-defined).
5. **[Manual controls]** Built-in regulatory initiatives with `manual`-effect definitions include FedRAMP High/Moderate, HIPAA, HITRUST, ISO 27001, NIST SP 800-171 Rev. 2, NIST SP 800-53 Rev. 4/5, PCI DSS 3.2.1 and 4.0, and SWIFT CSP CSCF v2022. [Manual effect](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-manual).
6. **[Version / preview — MCSB]** **[Preview]** MCSB v2 adds an Artificial Intelligence Security domain with `7` recommendations, uses `12` security domains, and references more than `420` Azure Policy built-in definitions. MCSB v2 baselines aren't yet available, so service baselines remain v1. [The Microsoft cloud security benchmark v2 (preview)](https://learn.microsoft.com/en-us/security/benchmark/azure/introduction#the-microsoft-cloud-security-benchmark-v2-preview) [Terminology](https://learn.microsoft.com/en-us/security/benchmark/azure/introduction#terminology).
7. **[Mappings]** MCSB controls are pre-mapped to industry frameworks such as CIS Controls, NIST, and PCI-DSS, and MCSB status is monitored in the Defender for Cloud Regulatory Compliance dashboard. [Implement Microsoft cloud security benchmark](https://learn.microsoft.com/en-us/security/benchmark/azure/introduction#implement-microsoft-cloud-security-benchmark).

### Incompatibilities and mutual exclusions

If a design requires a **stable, Microsoft-maintained regulatory initiative** **and** local modification of its rules, a built-in can't be edited in place. Duplicating it into a custom initiative transfers upstream-change tracking to the organization. [Regulatory Compliance defined](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance#regulatory-compliance-defined).

### Edge cases and gotchas

- The MCSB introduction still lists Azure Blueprints as a guardrail option, but Blueprints entered phased retirement on July 31, 2026, so prefer Azure Policy and deployment stacks. [Implement Microsoft cloud security benchmark](https://learn.microsoft.com/en-us/security/benchmark/azure/introduction#implement-microsoft-cloud-security-benchmark) [Azure Blueprints retirement](https://learn.microsoft.com/en-us/azure/governance/blueprints/blueprint-retirement).
- Regulatory Compliance adds `policyGroupDetails` counts by compliance state to SDK `summarize` results. [Regulatory Compliance in SDK](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance#regulatory-compliance-in-sdk).

### AZ-305 exam discriminator

"Dashboard by control and compliance domain showing customer vs Microsoft responsibility" selects a Regulatory Compliance initiative. "Microsoft's recommended cloud security baseline mapped to CIS/NIST/PCI" selects MCSB. Neither is a certification. [Regulatory Compliance in initiative definitions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance) [MCSB introduction](https://learn.microsoft.com/en-us/security/benchmark/azure/introduction).

### Common trap

Treating **Microsoft managed** control results as the customer's own compliance. They reflect third-party audits of Microsoft infrastructure, not customer configuration. [Policy type](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-basics#policy-type).

---

## Azure compliance offerings and Service Trust Portal

**Classification:** Supporting
**Why it matters:** These establish what Microsoft has independently audited, which is supplier evidence for the Microsoft side of shared responsibility and a prerequisite check for region or service selection. [Azure compliance documentation](https://learn.microsoft.com/en-us/azure/compliance/)
**Primary Microsoft source:** [Get started with the Microsoft Service Trust Portal](https://learn.microsoft.com/en-us/compliance/assurance/stp-get-started)

### Deep technical facts / requirements

1. **[Offering categories]** Azure compliance offerings are grouped into Global (for example, SOC 1/2/3 and ISO 27001/27017/27018/27701), US government (for example, FedRAMP, DoD IL2/IL4/IL5/IL6, CJIS, ITAR), financial services, healthcare and life sciences (for example, HIPAA and HITRUST), industry, and regional (Americas, Asia Pacific, EMEA) categories. [Azure compliance documentation](https://learn.microsoft.com/en-us/azure/compliance/).
2. **[Prerequisites — access]** Some Service Trust Portal resources require signing in with a Microsoft Entra organization account and accepting the Microsoft Non-Disclosure Agreement for Compliance Materials. Existing Microsoft 365, Dynamics 365, or Azure subscriptions (trial or paid) grant access. [Accessing the Service Trust Portal](https://learn.microsoft.com/en-us/compliance/assurance/stp-get-started#accessing-the-service-trust-portal).
3. **[Identity — restricted documents]** Restricted documents require the Tenant Admin, Compliance Administrator, Security Administrator, or Security Reader role. [Restricted Documents](https://learn.microsoft.com/en-us/compliance/assurance/stp-get-started#restricted-documents).
4. **[Retention]** Documents remain downloadable for at least `12` months after publishing or until a newer version is released, and download history covers the last `18` months with CSV export. [Search](https://learn.microsoft.com/en-us/compliance/assurance/stp-get-started#search) [My Download History](https://learn.microsoft.com/en-us/compliance/assurance/stp-get-started#my-download-history).
5. **[Content types]** The portal publishes audit reports produced by external auditors (ISO/IEC, SOC, FedRAMP, PCI, CSA STAR, and more) and pen-test attestations. **Resources for your Organization** are restricted by tenant. [Using the Service Trust Portal](https://learn.microsoft.com/en-us/compliance/assurance/stp-get-started#using-the-service-trust-portal).

### Incompatibilities and mutual exclusions

If an auditor needs **Microsoft's SOC 2 report** **and** the team offers a Policy or Defender dashboard export, that evidence doesn't substitute. Microsoft audit reports come from the Service Trust Portal or Defender's **Audit reports** option. [Get started with the Service Trust Portal](https://learn.microsoft.com/en-us/compliance/assurance/stp-get-started) [Generate compliance status reports and certificates](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard#generate-compliance-status-reports-and-certificates).

### Edge cases and gotchas

- **My Library** notifications email you when Microsoft updates saved documents or document series, which is useful for audit-period currency. [My Library](https://learn.microsoft.com/en-us/compliance/assurance/stp-get-started#my-library).
- Some browser PDF viewers block the license-agreement JavaScript, preventing documents from opening. [Resources for your Organization](https://learn.microsoft.com/en-us/compliance/assurance/stp-get-started#resources-for-your-organization).

### AZ-305 exam discriminator

"Provide evidence of Microsoft's certifications or third-party audits" selects the Service Trust Portal. "Customer-side resource configuration evidence" selects Policy or Defender. [Get started with the Service Trust Portal](https://learn.microsoft.com/en-us/compliance/assurance/stp-get-started).

### Common trap

Assuming an Azure ISO 27001 or SOC 2 offering certifies the customer's workload. Offerings cover Microsoft's audited scope, and customer controls remain customer responsibility. [Regulatory Compliance in initiative definitions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance).

---

## Azure Arc-enabled servers

**Classification:** Supporting
**Why it matters:** Arc gives on-premises and other-cloud servers an Azure resource ID so Azure Policy and Machine Configuration can govern them like Azure VMs. [Azure Arc-enabled servers overview](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview)
**Primary Microsoft source:** [Azure Arc-enabled servers overview](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview)

### Deep technical facts / requirements

1. **[Defaults — connectivity]** The Connected Machine agent sends a heartbeat every `5` minutes. Without heartbeats a machine becomes **Disconnected** within `15–30` minutes, and after `45` days disconnected it may become **Expired** and must be disconnected and reconnected. The managed identity credential is valid up to `90` days and renews every `45` days. [Agent status](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview#agent-status).
2. **[Incompatibility]** Arc-enabled servers isn't designed or supported for managing VMs running in Azure. [Supported environments](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview#supported-environments).
3. **[Limits]** There's no limit on Arc-enabled servers or VM extensions per resource group or subscription, but the Azure Arc Private Link Scope resource type is subject to the `800`-instance per-resource-group limit. [Service limits](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview#service-limits).
4. **[Data residency]** Customer data such as instance metadata is stored in the region selected during onboarding, and data at rest stays within that region's geography. [Data residency](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview#data-residency) [Supported regions](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview#supported-regions).
5. **[Cost]** Machine Configuration on Arc-enabled servers is billed per the Azure Policy pricing page at $6 per server per month. [Supported cloud operations](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview#supported-cloud-operations) [Azure Policy pricing](https://azure.microsoft.com/en-us/pricing/details/azure-policy/).

### Incompatibilities and mutual exclusions

If a scenario requires governing **Azure VMs** in-guest, Arc onboarding isn't the path. Use the Machine Configuration extension with a system-assigned identity on the Azure VM. [Supported environments](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview#supported-environments) [Deploy requirements for Azure virtual machines](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites#deploy-requirements-for-azure-virtual-machines).

### Edge cases and gotchas

- Incorrectly cloned machines can produce `429` errors or intermittent connection status. [Agent status](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview#agent-status).
- Onboarding region choice is a residency decision, not just a latency decision. [Data residency](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview#data-residency).

### AZ-305 exam discriminator

"Apply the same OS baseline to on-premises and AWS servers and report in Azure Policy" selects Arc-enabled servers plus Machine Configuration. [Assigning policies to machines outside of Azure](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites#assigning-policies-to-machines-outside-of-azure).

### Common trap

Assuming a disconnected Arc server keeps reporting fresh compliance indefinitely. It goes Disconnected within 15–30 minutes and can Expire after 45 days. [Agent status](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview#agent-status).

---

## Azure Resource Graph and Policy Insights reporting

**Classification:** Supporting
**Why it matters:** Enterprise compliance reporting, exemption-age tracking, and CI/CD gates query Policy state through Resource Graph and Policy Insights rather than the portal. [Get policy compliance data](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data)
**Primary Microsoft source:** [Get policy compliance data](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data)
**Limits and quotas source:** [Guidance for throttled requests in Azure Resource Graph](https://learn.microsoft.com/en-us/azure/governance/resource-graph/concepts/guidance-for-throttled-requests)

### Deep technical facts / requirements

1. **[Limits — throttling]** A user can typically send at most `15` queries per `5`-second window, as reported by the `x-ms-user-quota-remaining` and `x-ms-user-quota-resets-after` headers. The quota value can change. [Understand throttling headers](https://learn.microsoft.com/en-us/azure/governance/resource-graph/concepts/guidance-for-throttled-requests#understand-throttling-headers).
2. **[Limits — result size]** A query returns at most `1,000` entries per response, requiring skip-token pagination, and each page consumes quota. When a principal can see more than `10,000` subscriptions, results are limited to the first `10,000` and `x-ms-tenant-subscription-limit-hit` is `true`. [Pagination](https://learn.microsoft.com/en-us/azure/governance/resource-graph/concepts/guidance-for-throttled-requests#pagination) [Understand throttling headers](https://learn.microsoft.com/en-us/azure/governance/resource-graph/concepts/guidance-for-throttled-requests#understand-throttling-headers).
3. **[Design guidance]** Grouping queries by subscription is more quota-efficient than parallel single-subscription queries, with a recommended group size under `300`. [Grouping queries](https://learn.microsoft.com/en-us/azure/governance/resource-graph/concepts/guidance-for-throttled-requests#grouping-queries).
4. **[Data sources]** Policy compliance is exposed through the portal, REST/CLI/PowerShell (`PolicyStates` and `PolicyEvents` in `Microsoft.PolicyInsights`), Azure Monitor logs (`AzureActivity` for new/updated resource results, supporting alerts), and Azure Resource Graph. [Get policy compliance data](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data).
5. **[Automation gate]** The Azure Policy Compliance Scan GitHub Action can trigger on-demand scans on resources, resource groups, or subscriptions and gate a workflow on the result. [On-demand evaluation scan using GitHub Actions](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data#on-demand-evaluation-scan-using-github-actions).

### Incompatibilities and mutual exclusions

If a reporting job needs full state across **more than 10,000 subscriptions** in a single tenant-scope query, one Resource Graph request can't return it; partition the query by management group or subscription batches. [Understand throttling headers](https://learn.microsoft.com/en-us/azure/governance/resource-graph/concepts/guidance-for-throttled-requests#understand-throttling-headers).

### Edge cases and gotchas

- `AzureActivity`-based Log Analytics alerting covers non-compliance from evaluation of **new and updated** resources, not a full-state inventory. [Azure Monitor logs](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data#azure-monitor-logs).
- ARM throttling is a separate, hard limit from Resource Graph throttling and can't be increased. [Differentiate between throttling requests for ARG and ARM](https://learn.microsoft.com/en-us/azure/governance/resource-graph/concepts/guidance-for-throttled-requests#differentiate-between-throttling-requests-for-arg-and-arm).

### AZ-305 exam discriminator

"Custom organization-wide compliance dashboard across hundreds of subscriptions, including exempt resources and what their state would be" selects Resource Graph queries over `policyresources` (including `complianceSubState`), not per-subscription portal views. [Compliance substate](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure#compliance-substate).

### Common trap

Parallelizing one query per subscription for speed, which exhausts the per-user window faster than grouped queries. [Grouping queries](https://learn.microsoft.com/en-us/azure/governance/resource-graph/concepts/guidance-for-throttled-requests#grouping-queries).

---

## Deployment stacks, template specs, and Azure Blueprints retirement

**Classification:** Adjacent
**Why it matters:** Legacy compliance designs packaged policy, roles, and resources in Blueprints with locks. The retirement forces migration to deployment stacks (lifecycle and deny settings) plus template specs or Git (versioning), while Azure Policy remains the continuous compliance engine. [Azure Blueprints retirement](https://learn.microsoft.com/en-us/azure/governance/blueprints/blueprint-retirement)
**Primary Microsoft source:** [Azure Blueprints retirement](https://learn.microsoft.com/en-us/azure/governance/blueprints/blueprint-retirement) and [Create and deploy Azure deployment stacks in Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks)

### Deep technical facts / requirements

1. **[Retirement timeline]** Azure Blueprints (Preview): July 31, 2026, no new definitions/versions; October 31, 2026, no definition edits or new assignments; December 31, 2026, no assignment edits; January 31, 2027, API, CLI, PowerShell, and portal stop, blueprint locks stop working, and unexported definitions/versions/assignments are permanently deleted. Deployed resources remain. [Phased retirement timeline](https://learn.microsoft.com/en-us/azure/governance/blueprints/blueprint-retirement#phased-retirement-timeline).
2. **[Replacement mapping]** Blueprint definitions map to template specs or Git, and blueprint assignments and locks map to deployment stacks. Both replacements are GA, and template spec scope is resource group. [Feature comparison](https://learn.microsoft.com/en-us/azure/governance/blueprints/blueprint-retirement#feature-comparison).
3. **[Limits — deny settings]** Deployment stack deny settings support modes `None`, `DenyDelete`, and `DenyWriteAndDelete`, with up to `200` excluded actions and up to `5` excluded principals. Exceeding five principals **doesn't return an error**, so consolidate identities into groups. [Protect managed resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks#protect-managed-resources) [Exclude principals from deny settings](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks#exclude-principals-from-deny-settings).
4. **[Scope]** Stacks can be created at resource group, subscription, or management group scope. A management-group stack deploys its template to a subscription. [Create deployment stacks](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks#create-deployment-stacks).
5. **[Identity]** Azure Deployment Stack Contributor can manage stacks but can't create or delete deny assignments; Azure Deployment Stack Owner can. [Built-in roles](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks#built-in-roles).
6. **[Version requirements]** Deployment stacks require Azure PowerShell `12.0.0`+ or Azure CLI `2.61.0`+. [Create and deploy Azure deployment stacks in Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks).

### Incompatibilities and mutual exclusions

- If a lock must protect **data-plane child objects** (such as secrets or blob containers) or **implicitly created resources** (such as AKS-created VMs), deployment stack deny settings can't be used; they cover only explicitly declared control-plane resources. [Protect managed resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks#protect-managed-resources).
- If a new design after July 31, 2026 requires creating a **blueprint definition**, it can't be done. [Phased retirement timeline](https://learn.microsoft.com/en-us/azure/governance/blueprints/blueprint-retirement#phased-retirement-timeline).

### Edge cases and gotchas

- `actionOnUnmanage` values are `detachAll`, `deleteResources`, and `deleteAll`, and the default behavior detaches rather than deletes. [Control detachment and deletion](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks#control-detachment-and-deletion) [Detach managed resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks#detach-managed-resources-from-deployment-stack).
- `denyAction` policy enforcement exempts `Microsoft.Resources/deploymentStacks` and `Microsoft.Blueprint/blueprintAssignments` to prevent lockout. [DenyAction evaluation](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deny-action#denyaction-evaluation).
- Azure Advisor surfaces a recommendation listing subscriptions and management groups still using Blueprints. [Identify where Azure Blueprints is used](https://learn.microsoft.com/en-us/azure/governance/blueprints/blueprint-retirement#identify-where-azure-blueprints-is-used).

### AZ-305 exam discriminator

"Deploy a governed baseline environment as a unit and prevent deletion of its resources" selects a deployment stack with `DenyDelete` plus a template spec. "Continuously assess and enforce configuration" remains Azure Policy. [Which one should I use?](https://learn.microsoft.com/en-us/azure/governance/blueprints/blueprint-retirement#which-one-should-i-use).

### Common trap

Choosing Blueprints because older study material does. Existing blueprint locks stop functioning at retirement on January 31, 2027. [Phased retirement timeline](https://learn.microsoft.com/en-us/azure/governance/blueprints/blueprint-retirement#phased-retirement-timeline).

---

## Microsoft Entra ID Governance

**Classification:** Adjacent
**Why it matters:** Many regulations require access certification and joiner/mover/leaver evidence, which resource-configuration policy can't provide. [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview)
**Primary Microsoft source:** [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview)

### Deep technical facts / requirements

1. **[Licensing]** Identity Governance features require Microsoft Entra ID Governance or Microsoft Entra Suite licenses. [License requirements](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview#license-requirements).
2. **[Capabilities]** Access reviews provide recurring access recertification, entitlement management enforces separation-of-duties checks on access requests, and PIM provides just-in-time access for directory, Microsoft 365, Azure resource roles, and group memberships. [Access lifecycle](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview#access-lifecycle) [Privileged access lifecycle](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview#privileged-access-lifecycle).
3. **[Edge — guests]** Entitlement management automatically adds approved external requesters as B2B guests and removes them from the directory when their access expires or is revoked. [Identity lifecycle](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview#identity-lifecycle).
4. **[Preview]** **[Preview]** Agent identity governance requires a human sponsor for every agent identity, and sponsorship transfers automatically to the sponsor's manager if the sponsor leaves. [Identity governance for agents (preview)](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview#identity-governance-for-agents-preview).

### Incompatibilities and mutual exclusions

If the obligation is **periodic manager recertification of human access**, Azure Policy can't satisfy it, because Policy evaluates resource state regardless of who has permission. Use access reviews. [Azure Policy and Azure RBAC](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-policy-and-azure-rbac) [Access lifecycle](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview#access-lifecycle).

### AZ-305 exam discriminator

"Quarterly certification of privileged Azure role holders" plus "time-bound elevation" selects Entra access reviews plus PIM under an Entra ID Governance or Suite license. [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview).

### Common trap

Choosing Compliance Manager or Policy because the word "compliance" appears, even though the control concerns identity lifecycle. [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview).

---

## Cloud Adoption Framework — enforce cloud governance policies

**Classification:** Framework / methodology
**Why it matters:** CAF sets the operating model the exam expects: delegated enforcement, inheritance, monitor-first rollout, and policy as code. [Enforce cloud governance policies](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/govern/enforce-cloud-governance-policies)
**Primary Microsoft source:** [Enforce cloud governance policies](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/govern/enforce-cloud-governance-policies)

### Key guidance

1. **[Responsibility]** The cloud governance team sets strategy but shouldn't apply enforcement controls itself. Platform teams apply inherited policies, and workload teams enforce governance within their workloads. [Define an approach](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/govern/enforce-cloud-governance-policies#1-define-an-approach-for-enforcing-cloud-governance-policies).
2. **[Rollout]** Use a monitor-first approach for lower-priority risks, start with a small set of automated policies, and prefer block lists over allow lists. [Define an approach](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/govern/enforce-cloud-governance-policies#1-define-an-approach-for-enforcing-cloud-governance-policies) [Enforce automatically](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/govern/enforce-cloud-governance-policies#2-enforce-cloud-governance-policies-automatically).
3. **[Tooling]** Azure Policy is Azure's primary governance tool, supplemented by Defender for Cloud (security), Purview (data), Entra ID Governance (identity), Azure Monitor (operations), and management groups plus IaC (resource management). CAF recommends Enterprise Azure Policy as Code (EPAC). [Enforce automatically](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/govern/enforce-cloud-governance-policies#2-enforce-cloud-governance-policies-automatically).
4. **[Manual enforcement]** Where automation isn't possible, use checklists, regular training, scheduled reviews, and dedicated manual monitoring. [Enforce manually](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/govern/enforce-cloud-governance-policies#3-enforce-cloud-governance-policies-manually).
5. **[Policy as code pipeline]** Microsoft's workflow is: create definitions, test with `enforcementMode` disabled in a dedicated scope, gate on compliance, grant identity roles and validate remediation, then enable enforcement environment by environment. It also recommends restricting Policy write permissions to the deployment identity. [Design Azure Policy as Code workflows](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/policy-as-code).

---

## Highest-yield exam discriminators

| Scenario clue | Best answer | Why |
|---|---|---|
| Block new resources outside approved regions across 60 subscriptions | Azure Policy `deny` (Allowed locations) initiative assigned at a parent management group | The definition must be stored at a management group containing all target subscriptions, and assignments inherit to descendants. [Definition location](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/scope#definition-location) [Assignments](https://learn.microsoft.com/en-us/azure/governance/policy/overview#assignments) |
| A subsidiary may legally use a service the parent management group denies | Exclude (or exempt) the subsidiary from the parent assignment, then assign the permissive rule at the child | Policy is explicit deny; a permissive child assignment can't override an inherited deny. [Assignments](https://learn.microsoft.com/en-us/azure/governance/policy/overview#assignments) |
| One legacy resource, compensating firewall control, auditor approval, expires in four months | Policy exemption, category `Mitigated`, with metadata and `expiresOn` | Exemptions stay visible as Exempt; `expiresOn` stops honoring the exemption but keeps the object for record-keeping. [Details of the policy exemption structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure) |
| Sandbox management group should never be governed by the corporate baseline | `notScopes` exclusion | Excluded scopes aren't evaluated or counted and are recommended for permanent broad bypass (up to 400 per assignment). [Scope comparison](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/scope#scope-comparison) [Maximum count](https://learn.microsoft.com/en-us/azure/governance/policy/overview#maximum-count-of-azure-policy-objects) |
| Existing storage accounts must have a property corrected | `modify` plus a remediation task | Evaluation cycles don't change existing resources; a remediation task can cover up to 50,000 resources. [Skipped modification](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-modify#skipped-modification) [Create a remediation task](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#create-a-remediation-task) |
| Every key vault must have diagnostic settings, including existing vaults | `deployIfNotExists` plus managed identity plus remediation task | DINE deploys after a default 10-minute delay for new resources; existing resources need a remediation task and the identity needs the declared roles. [deployIfNotExists properties](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deploy-if-not-exists#deployifnotexists-properties) |
| DINE assignment deployed via Bicep reports non-compliance but remediation fails | Grant the assignment identity the `roleDefinitionIds` roles | Only the portal auto-grants roles; SDK/template deployments require manual grants. [Grant permissions to the managed identity](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources#grant-permissions-to-the-managed-identity-through-defined-roles) |
| Prevent deletion of production database accounts even by Owners | `denyAction` policy (with `cascadeBehaviors` deny in `indexed` mode) | `denyAction` supports only DELETE and returns 403; resource group deletion is blocked only when `cascadeBehaviors` is deny. [denyAction effect](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deny-action) |
| TLS registry setting on Azure VMs and on-premises Windows servers | Machine Configuration plus Azure Arc | ARM-mode policy can't see in-guest state; Arc servers include the agent capability, and up to 50 guest assignments per machine are supported. [Azure Machine Configuration prerequisites](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites) [What is Azure Machine Configuration?](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/01-overview-concepts) |
| In-guest settings must revert automatically when changed | Machine Configuration `ApplyAndAutoCorrect` | Only this mode restores conformance on drift; the agent re-checks every 15 minutes. [Enforcement modes](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/01-overview-concepts#enforcement-modes-for-custom-policies) [Validation frequency](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/02-setup-prerequisites#validation-frequency) |
| Guest OS baseline on a Uniform VM scale set | Move to Flexible orchestration (or another assessment method) | Machine Configuration doesn't support Uniform scale sets. [Supported client types](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview/01-overview-concepts#supported-client-types) |
| Continuous PCI DSS v4.0.1 assessment across Azure, AWS, and GCP | Defender for Cloud regulatory compliance with a paid plan (Defender CSPM) | PCI DSS v4.0.1 is available on all three clouds; nondefault standards require a paid plan. [Available compliance standards](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-regulatory-compliance-standards#available-compliance-standards) [Before you start](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard#before-you-start) |
| Auditor needs a complete weekly posture record in Log Analytics | Defender continuous export with **snapshots** | Streaming sends only health-state changes; snapshots send current state once a week per subscription. [Create a continuous export configuration](https://learn.microsoft.com/en-us/azure/defender-for-cloud/continuous-export#create-a-continuous-export-configuration) |
| Auditors granted Security Reader can't see regulatory compliance | Grant Reader at the subscription | Reader has policy compliance data access and Security Reader doesn't. [Before you start](https://learn.microsoft.com/en-us/azure/defender-for-cloud/regulatory-compliance-dashboard#before-you-start) |
| Improvement actions with owners and uploaded evidence spanning Microsoft 365, Azure, and AWS | Purview Compliance Manager (integrated with Defender for Cloud) | Improvement actions store evidence and status; multicloud testing comes from Defender for Cloud; more than 360 templates. [Microsoft Purview Compliance Manager](https://learn.microsoft.com/en-us/purview/compliance-manager) [Multicloud support](https://learn.microsoft.com/en-us/purview/compliance-manager-multicloud) |
| Need Microsoft's SOC 2 and ISO 27001 audit reports | Service Trust Portal | Publishes external-auditor reports; restricted documents require sign-in, NDA acceptance, and specific roles. [Get started with the Service Trust Portal](https://learn.microsoft.com/en-us/compliance/assurance/stp-get-started) |
| Attest quarterly that each subscription has a contingency plan | Policy `manual` effect targeting subscriptions plus attestations | Default state is Unknown until attested; one attestation per applicable resource, so target subscriptions. [Manual effect](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-manual) [Attestation structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/attestation-structure#best-practices) |
| Roll out a deny initiative region by region without forking it | Resource selectors plus effect overrides on one assignment | Up to 10 selectors with 50 values each and 10 overrides covering 50 reference IDs each. [Resource selectors](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#resource-selectors) [Overrides](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#overrides) |
| Package a governed baseline and lock it against deletion in a new design | Deployment stack (`DenyDelete`) plus template spec | New blueprint definitions stopped July 31, 2026, and new assignments stop October 31, 2026. [Azure Blueprints retirement](https://learn.microsoft.com/en-us/azure/governance/blueprints/blueprint-retirement) |
| Quarterly manager certification of privileged Azure access | Entra ID Governance access reviews plus PIM | Policy evaluates resource state, not who should retain access; requires Entra ID Governance or Suite licensing. [Microsoft Entra ID Governance](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview) [Azure Policy and Azure RBAC](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-policy-and-azure-rbac) |

---

*Model used to research and author this fact sheet: Claude Opus 5.*
