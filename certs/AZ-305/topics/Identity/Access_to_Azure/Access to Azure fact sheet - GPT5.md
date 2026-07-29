# Deep Technical Facts and Requirements for Recommend a solution for authorizing access to Azure resources

## Scope

- Exam: AZ-305: Designing Microsoft Azure Infrastructure Solutions
- Task: Recommend a solution for authorizing access to Azure resources
- Source guide: *Access to Azure study guide - GPT5.md*, validated against *Access to Azure task map.md* and the AZ-305 skill hierarchy
- Research date: July 2026
- Product selection method: Products and major topics were extracted from the provided guide, then validated against current official Microsoft documentation.

## Product coverage summary

| Product / topic | Classification | Why it matters for this task |
|---|---|---|
| Azure RBAC roles, assignments, and scopes | Core | Defines the principal-role-scope authorization model for Azure management and integrated data planes. |
| Azure ABAC conditions and deny assignments | Supporting | Refines supported grants with attributes and explains the only true deny behavior in Azure RBAC evaluation. |
| Microsoft Entra Privileged Identity Management and access reviews | Core | Adds eligible, time-bound, approval-controlled, and recertified privileged Azure resource access. |
| Managed identities and service principals | Core | Supplies non-human principals for workload-to-resource authorization without human accounts. |
| Azure Resource Manager planes and management hierarchy | Core | Determines whether an operation is management-plane or data-plane and where inherited authorization applies. |
| Azure Storage and Data Lake Storage authorization | Core | Combines Entra RBAC, ABAC, ACLs, SAS, Shared Key, Kerberos, and service-specific behavior. |
| Azure Key Vault authorization | Supporting | Exposes the design choice between recommended Azure RBAC and legacy access policies. |
| Azure Lighthouse | Supporting | Delegates supported Azure management roles across tenant boundaries. |
| Conditional Access, Azure Policy, resource locks, and authorization monitoring | Supporting | Protects token issuance, constrains resource state, prevents control-plane changes, and provides audit evidence without replacing RBAC. |
| Well-Architected Framework and Cloud Adoption Framework access design | Architecture guidance | Turns product mechanics into workload- and estate-scale least-privilege patterns. |

---

## Azure RBAC roles, assignments, and scopes

**Classification:** Core  
**Why it matters:** Azure RBAC is the primary authorization system for Azure resources. It binds a security principal to a role definition at a scope and evaluates inherited, overlapping, conditional, and denied permissions.  
**Primary Microsoft source:** [Azure RBAC overview](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)  
**Limits and quotas source:** [Troubleshoot Azure RBAC limits](https://learn.microsoft.com/en-us/azure/role-based-access-control/troubleshoot-limits)

### Deep technical facts / requirements

1. **Identity and access:** A role assignment consists of a security principal, role definition, and scope; supported principal types include users, groups, service principals, and managed identities. [Azure RBAC overview](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview).
2. **Evaluation behavior:** Azure RBAC is additive: effective permissions are the union of applicable role assignments, so a Reader assignment at a child scope cannot subtract Contributor inherited from an ancestor. [Azure RBAC multiple role assignments](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview#multiple-role-assignments).
3. **Role semantics:** `Actions` and `NotActions` describe control-plane permissions, while `DataActions` and `NotDataActions` describe data-plane permissions; `NotActions` and `NotDataActions` subtract from one role definition but do not create an explicit deny against another assignment. [Understand Azure role definitions](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-definitions).
4. **Scope dependency:** Azure RBAC supports management group, subscription, resource group, and resource scopes, and assignments made at a parent scope are inherited by descendants. [Understand Azure RBAC scope](https://learn.microsoft.com/en-us/azure/role-based-access-control/scope-overview).
5. **Limits:** A subscription supports a fixed maximum of **4,000** role assignments across subscription, resource-group, and resource scopes; management-group assignments, eligible assignments, and future-scheduled assignments do not count toward that subscription limit, and the limit cannot be increased. [Troubleshoot Azure RBAC limits](https://learn.microsoft.com/en-us/azure/role-based-access-control/troubleshoot-limits).
6. **Limits:** A Microsoft Entra tenant supports **5,000** custom Azure roles; Microsoft Azure operated by 21Vianet supports **2,000** custom roles. [Azure custom-role limits](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles).
7. **Prerequisite:** Creating, updating, or deleting a custom role requires `Microsoft.Authorization/roleDefinitions/write` on every scope listed in `AssignableScopes`; viewing an available role requires `roleDefinitions/read`. [Who can manage custom roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles#who-can-create-delete-update-or-view-a-custom-role).
8. **Automation behavior:** Role assignment resource names must be unique within the Microsoft Entra tenant even when assignments use different scopes; IaC should use deterministic assignment names and the principal object ID. [Understand Azure role assignments](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments).
9. **Automation behavior:** Role-definition IDs remain stable when role names change, so Microsoft recommends using the unique role ID rather than a display name in scripts and templates. [Azure RBAC best practices](https://learn.microsoft.com/en-us/azure/role-based-access-control/best-practices#assign-roles-using-the-unique-role-id-instead-of-the-role-name).
10. **Edge behavior:** Wildcards in custom `Actions` or `DataActions` can silently grant future operations that a resource provider adds; explicit operation lists are safer for least privilege. [Azure RBAC custom-role wildcard guidance](https://learn.microsoft.com/en-us/azure/role-based-access-control/best-practices#avoid-using-a-wildcard-when-creating-custom-roles).
11. **Cost and licensing:** Azure RBAC itself is free and included with an Azure subscription; paid Microsoft Entra licensing is required only when adding services such as PIM or license-gated Conditional Access. [Azure RBAC license requirements](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview#license-requirements).
12. **Resiliency:** Role definitions, role assignments, and deny assignments are stored globally because Azure Resource Manager enforces RBAC through a global endpoint; they are not region-specific objects that need duplicate regional assignments. [Where Azure RBAC data is stored](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview#where-is-azure-rbac-data-stored).
13. **Version and retirement:** Classic Account Administrator, Service Administrator, and Co-Administrator roles were retired on **August 31, 2024**; Azure began automatic Owner conversion for remaining public-cloud assignments in **December 2025**, and the classic roles were fully retired by **May 2026**. [Azure roles and retired classic administrators](https://learn.microsoft.com/en-us/azure/role-based-access-control/rbac-and-directory-admin-roles#classic-subscription-administrator-roles).
14. **Identity boundary:** Azure roles authorize Azure Resource Manager resources, whereas Microsoft Entra roles authorize directory objects such as users, groups, and applications; Global Administrator does not inherently equal subscription Owner. [Azure roles versus Microsoft Entra roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/rbac-and-directory-admin-roles).
15. **Recovery path:** A Global Administrator can elevate access to receive User Access Administrator at root scope `/`, which exposes all subscriptions and management groups in the tenant; Microsoft instructs administrators to remove the elevated assignment after the required work. [Elevate access for a Global Administrator](https://learn.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin).
16. **Operational scale:** Microsoft recommends assigning roles to groups rather than individual users because group membership centralizes lifecycle changes and each group assignment consumes one role assignment regardless of membership count. [Assign Azure roles to groups](https://learn.microsoft.com/en-us/azure/role-based-access-control/best-practices#assign-roles-to-groups-not-users).

### Incompatibilities and mutual exclusions

If a design requires a lower-scope role assignment to remove permissions inherited from a higher scope, ordinary Azure RBAC grants cannot satisfy it because assignments are additive; the higher-scope grant must be removed or narrowed, or an Azure-managed deny mechanism must apply. [Azure RBAC multiple role assignments](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview#multiple-role-assignments).

### Edge cases and gotchas

- Deleting a user, group, service principal, or managed identity does not automatically provide clean role-assignment hygiene; stale assignments should be removed, and already issued tokens can remain usable until they expire. [Role assignments and deleted principals](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments#principal).
- A new service principal or managed identity can produce transient `PrincipalNotFound` failures during IaC deployment because directory replication has not completed; explicitly setting `principalType` helps avoid this failure path. [Troubleshoot Azure RBAC principal replication](https://learn.microsoft.com/en-us/azure/role-based-access-control/troubleshooting#symptom---assigning-a-role-to-a-new-principal-sometimes-fails).
- Azure role assignment changes can take up to **10 minutes** to refresh in common cases, and management-group assignment changes can take longer; signing out and back in can force a token refresh for interactive tools. [Troubleshoot Azure RBAC propagation](https://learn.microsoft.com/en-us/azure/role-based-access-control/troubleshooting).
- Owner grants both resource management and access management; Contributor grants resource management but not Azure RBAC assignment, while Role Based Access Control Administrator focuses on access management without general resource administration. [Azure privileged built-in roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/privileged).

### AZ-305 exam discriminator

When a scenario names an exact Azure operation, select the narrowest built-in role at the narrowest practical scope before considering Contributor, Owner, or a custom role; use a custom role only when the built-in catalog cannot express the required operation set. [Azure RBAC best practices](https://learn.microsoft.com/en-us/azure/role-based-access-control/best-practices).

### Common trap

Do not assume `NotActions` is a deny: another inherited or direct role assignment can still grant the excluded operation. [Understand Azure role definitions](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-definitions).

---

## Azure ABAC conditions and deny assignments

**Classification:** Supporting  
**Why it matters:** ABAC conditions refine supported role grants with attributes, while deny assignments explain the explicit-deny stage in Azure RBAC evaluation.  
**Primary Microsoft source:** [Azure ABAC overview](https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-overview)  
**Limits and quotas source:** [Azure ABAC limits](https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-overview#limits)

### Deep technical facts / requirements

1. **Service support:** Azure role assignment conditions currently apply only to built-in or custom role assignments containing supported Azure Blob Storage or Azure Queue Storage data actions; they are not a universal condition engine for every Azure service. [Azure ABAC conditions overview](https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-overview).
2. **Evaluation:** A condition filters permissions granted by its own role assignment; it cannot add operations absent from the role definition and cannot explicitly deny access granted by another assignment. [Azure ABAC evaluation](https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-overview#what-are-role-assignment-conditions).
3. **Attribute sources:** Supported conditions can reference resource, request, environment, and principal attributes for supported actions, including Blob paths, tags, container names, encryption scopes, and time-related attributes where documented. [Azure ABAC attributes](https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-overview#why-use-conditions).
4. **Syntax:** Condition version `2.0` is required for current role assignment condition syntax; version `1.0` produces an invalid-condition error. [Troubleshoot Azure ABAC condition syntax](https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-troubleshoot#symptom---condition-is-not-valid-error-when-adding-a-condition).
5. **Limit:** The visual editor supports up to **5 expressions**; the code editor can represent more, subject to condition syntax and platform limits. [Azure ABAC limits](https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-overview#limits).
6. **Propagation:** A new or changed condition normally reaches Storage resource-provider caches within **1–2 minutes** but can take up to **5 minutes** to enforce. [Troubleshoot Azure ABAC propagation](https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-troubleshoot#symptom---condition-is-not-enforced).
7. **PIM integration:** PIM can attach conditions to eligible Azure resource assignments only for supported roles/actions; current documented built-in examples include Storage Blob Data Owner, Contributor, and Reader. [Assign Azure roles with PIM conditions](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-assign-roles).
8. **Deny behavior:** A deny assignment blocks specified `Actions` or `DataActions` even when a role assignment grants them, and can apply at a scope with inheritance and excluded principals. [List Azure deny assignments](https://learn.microsoft.com/en-us/azure/role-based-access-control/deny-assignments).
9. **Creation constraint:** Customers cannot directly create arbitrary deny assignments; Azure creates and manages them for supported platform features such as deployment-stack deny settings. [How deny assignments are created](https://learn.microsoft.com/en-us/azure/role-based-access-control/deny-assignments#how-deny-assignments-are-created).

### Incompatibilities and mutual exclusions

If a requirement needs attribute-based authorization for Key Vault, SQL, or an arbitrary Azure resource type, Azure RBAC conditions cannot be selected because current ABAC support is limited to documented Blob and Queue data actions. [Azure ABAC conditions overview](https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-overview).

### Edge cases and gotchas

- A broader unconditional assignment that grants the same data action bypasses the intended condition because Azure RBAC grants are additive. [Troubleshoot non-enforced conditions](https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-troubleshoot#symptom---condition-is-not-enforced).
- If multiple actions can authorize the same operation, the condition must target every relevant action; filtering only one path can leave another path unconditioned. [Troubleshoot Azure ABAC permission paths](https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-troubleshoot#symptom---condition-is-not-enforced).
- `NotActions` in a custom role and `NotDataActions` in a deny assignment have different semantics: the former subtracts from a grant, while the latter excludes actions from the deny. [Role definitions](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-definitions) [Deny assignment properties](https://learn.microsoft.com/en-us/azure/role-based-access-control/deny-assignments#deny-assignment-properties).

### AZ-305 exam discriminator

Choose ABAC when a supported Blob or Queue data requirement depends on attributes and per-resource assignments would cause sprawl; eliminate ABAC when the target service or data action is not in the supported set. [Azure ABAC overview](https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-overview).

### Common trap

Do not propose a customer-authored deny assignment as a routine design control; customers can view Azure-managed deny assignments but cannot directly create arbitrary ones. [List Azure deny assignments](https://learn.microsoft.com/en-us/azure/role-based-access-control/deny-assignments).

---

## Microsoft Entra Privileged Identity Management and access reviews

**Classification:** Core  
**Why it matters:** PIM reduces standing Azure privilege through eligibility, activation, expiry, approval, MFA, and audit; access reviews recertify whether assignments remain justified.  
**Primary Microsoft source:** [PIM overview](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure)  
**Limits and quotas source:** [Configure Azure resource role settings](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-configure-role-settings)

### Deep technical facts / requirements

1. **Assignment model:** PIM distinguishes eligible and active assignments, and each can be permanent or time-bound; eligible users must activate before receiving the role’s permissions. [PIM terminology](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure#terminology).
2. **Activation limit:** Azure resource role activation maximum duration is configurable from **1 to 24 hours**. [Configure PIM Azure role activation duration](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-configure-role-settings#activation-maximum-duration).
3. **Approval limit:** Delegated approvers have **24 hours** to approve an Azure resource role activation request; the window is not configurable, and an unapproved request must be resubmitted. [Approve Azure resource role requests](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-approval-workflow).
4. **Assignment timing:** A new PIM Azure role assignment cannot have a duration shorter than **5 minutes** and cannot be removed within **5 minutes** of assignment. [Assign Azure resource roles in PIM](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-assign-roles).
5. **Policy scope:** Azure resource role settings are defined per role and per resource; settings configured at subscription scope do not inherit to resource groups or resources. [PIM Azure role settings scope](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-configure-role-settings).
6. **Prerequisite roles:** Managing PIM settings and assignments for an Azure resource requires access-administration permissions such as Owner or User Access Administrator at the resource; Privileged Role Administrator alone does not automatically grant Azure resource administration. [PIM resource administrator permissions](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-assign-roles).
7. **Licensing:** PIM requires Microsoft Entra ID P2 or Microsoft Entra ID Governance licenses for users with eligible or time-bound Microsoft Entra or Azure role assignments and other users covered by the licensing rules. [Microsoft Entra ID Governance licensing for PIM](https://learn.microsoft.com/en-us/entra/id-governance/licensing-fundamentals#privileged-identity-management).
8. **Activation controls:** PIM role policy can require MFA, Conditional Access authentication context, business justification, ticket information, and approval; ticket information is informational and PIM does not validate it against an external ticketing system. [Configure PIM Azure role settings](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-configure-role-settings).
9. **Approver design:** Approval requires at least **1** configured approver, there are no default approvers, and Microsoft recommends at least **2** to reduce operational dependence on one person. [Configure PIM approval](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-configure-role-settings#require-approval-to-activate).
10. **Activation implementation:** Activating an eligible role creates a temporary active role assignment within seconds, and deactivation removes it within seconds, but application-side caches can delay observed access changes. [Activate Azure resource roles in PIM](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-activate-your-roles).
11. **Reduced scope:** A user eligible at management-group scope can request activation at a reduced descendant scope, such as a child management group or subscription, instead of activating the entire eligible scope. [Activate an Azure role at reduced scope](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-activate-your-roles).
12. **Access review limit:** A recurring monthly privileged-role access review can run for a maximum of **27 days**, preventing overlap with the next monthly instance. [Create PIM access reviews](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-create-roles-and-resource-roles-review).
13. **Review snapshot:** Each access review instance captures a snapshot at its start; assignment changes during the review appear in the next recurrence rather than rewriting the active snapshot. [PIM access review behavior](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-create-roles-and-resource-roles-review).
14. **Service-principal review licensing:** Reviewing service-principal access to Azure resource roles requires Microsoft Entra Workload ID Premium in addition to Microsoft Entra ID P2 or Microsoft Entra ID Governance. [PIM access review prerequisites](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-create-roles-and-resource-roles-review#prerequisites).
15. **Audit:** PIM audit history records assignment changes and activations; longer retention can be achieved by routing relevant logs through Azure Monitor to a storage account or analytics destination. [PIM audit history](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-how-to-use-audit-log).
16. **Reauthentication behavior:** When activation policy requires Microsoft Entra MFA, authentication completed within the preceding **10 minutes** satisfies that activation check; this window is a PIM behavior and is not a configurable activation-duration setting. [Configure PIM Azure role settings](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-configure-role-settings#on-activation-require-microsoft-entra-multifactor-authentication).
17. **Notification limit:** PIM sends notification email to a maximum of **1,000 recipients** per event; when a group has more than 1,000 members, only the first 1,000 receive email. [Configure PIM Azure role notifications](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-configure-role-settings#notifications).

### Incompatibilities and mutual exclusions

If administrators require uninterrupted, noninteractive access every minute, an eligible-only PIM assignment with approval cannot be the sole authorization because it requires activation and may wait up to the nonconfigurable **24-hour** approval window; retain an appropriately scoped active operational path or redesign the requirement. [PIM approval workflow](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-approval-workflow).

### Edge cases and gotchas

- PIM does not change the permissions inside a role; eligible Owner becomes full Owner when active, so role and scope still require least-privilege design. [PIM assignment terminology](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure#terminology).
- A user can reduce activation scope, but selecting a management group only filters the grid; the resource must be explicitly selected from the results. [PIM reduced-scope activation](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-activate-your-roles).
- Azure resource PIM is distinct from Microsoft Entra role PIM; Privileged Role Administrator manages directory-role PIM but does not inherently own Azure subscriptions. [PIM overview and permissions](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure).
- Access review decisions can remove denied privileged access, so reviewer selection and “if reviewers don’t respond” behavior are security-critical configuration rather than reporting-only choices. [Create PIM access reviews](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-create-roles-and-resource-roles-review).

### AZ-305 exam discriminator

Clues such as **JIT**, **approval**, **temporary elevation**, **MFA on activation**, **justification**, or **periodic recertification** point to PIM and access reviews, subject to P2/Governance licensing and the **1–24-hour** activation range. [PIM Azure resource role settings](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-configure-role-settings).

### Common trap

Do not choose Conditional Access alone for a requirement that privilege must expire after use; Conditional Access controls token issuance conditions, while PIM controls role eligibility and activation duration. [PIM overview](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure).

---

## Managed identities and service principals

**Classification:** Core  
**Why it matters:** Workloads need an Entra principal before Azure RBAC can authorize them. Managed identities eliminate application-managed credentials when the source and target support Entra tokens.  
**Primary Microsoft source:** [Managed identities overview](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview)  
**Limits and quotas source:** [Azure Managed Identity limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-managed-identity-limits)

### Deep technical facts / requirements

1. **Lifecycle:** A system-assigned managed identity is created with one Azure resource and deleted with it; a user-assigned managed identity is an independent Azure resource that can be attached to multiple supported sources. [Managed identity type comparison](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview#differences-between-system-assigned-and-user-assigned-managed-identities).
2. **Default recommendation:** Microsoft recommends user-assigned managed identities for most scenarios because they support reuse, preauthorization, and lifecycle separation; system-assigned identities remain appropriate when identity lifecycle must exactly match one source. [Managed identity developer guidance](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview-for-developers).
3. **Authentication prerequisite:** A managed identity can obtain a Microsoft Entra token for any target that supports Entra authentication, but a target or client library without Entra-token support forces a service-native credential or another supported design. [Managed identity target support](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview-for-developers#what-resources-can-managed-identities-connect-to).
4. **Authorization requirement:** Enabling a managed identity creates a principal but grants no target permissions; Azure RBAC or the target service’s authorization model must still authorize that principal. [Managed identities overview](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview).
5. **Token lifetime:** Managed identity tokens are valid for **24 hours**; repeatedly requesting a token does not force new claims because the endpoint returns a cached token, and application caches should expire about **5 minutes** before `expires_on`. [Managed identity developer token guidance](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview-for-developers).
6. **Authorization-change delay:** Group or app-role membership changes for a managed identity can take several hours to appear because the managed identity backend caches tokens per resource URI for around **24 hours** and offers no forced refresh. [Managed identity authorization limitations](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations#limitation-of-using-managed-identities-for-authorization).
7. **Rate limit:** Managed identity creation is limited to **400 operations per 20 seconds** per tenant per Azure region and **80 operations per 20 seconds** per subscription per region. [Azure Managed Identity limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-managed-identity-limits).
8. **Assignment rate limit:** Assigning a user-assigned managed identity to an Azure resource is limited to **400 operations per 20 seconds** per tenant per region and **300 operations per 20 seconds** per subscription per region. [Azure Managed Identity limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-managed-identity-limits).
9. **Tenant quota:** Every managed identity consumes a Microsoft Entra directory object and therefore counts against the tenant’s object quota. [Azure Managed Identity limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-managed-identity-limits).
10. **Ephemeral scale:** Rapidly creating many system-assigned identities can hit directory object creation throttles and return HTTP **429**; a reusable user-assigned identity avoids creating one principal per ephemeral source. [Managed identity best practices for rapid creation](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations).
11. **Separation of duties:** Managed Identity Contributor can create and manage user-assigned identities, while Managed Identity Operator can assign them to supported resources; these roles separate identity lifecycle from workload configuration. [Managed identity best-practice roles](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations).
12. **Code-execution risk:** An operator who can deploy or modify code on a resource can often act as that resource’s managed identity, so downstream permissions must be considered when granting control-plane access to the source. [Managed identity security recommendations](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations).
13. **Service-principal distinction:** A service principal is the tenant-local representation of an application; unlike a managed identity, its credentials or workload federation configuration are normally administered explicitly. [Application and service principal objects](https://learn.microsoft.com/en-us/entra/identity-platform/app-objects-and-service-principals).
14. **Alternative:** External OIDC-capable workloads can use workload identity federation to obtain Entra tokens without stored client secrets when a managed identity attached to an Azure resource is not the correct source model. [Microsoft Entra workload identities](https://learn.microsoft.com/en-us/entra/workload-id/workload-identities-overview).
15. **Preview:** `[Preview]` User-assigned managed identity assignment restrictions can limit which resource providers may attach the identity; the restriction controls source-resource attachment, not which target resources the identity can access. [Managed identity assignment restrictions](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identities-assignment-restriction).
16. **Regional constraint:** A user-assigned managed identity is a regional Azure resource and cannot be moved to a different region in place; a regional move requires creating an identity in the target region, recreating its role assignments, and attaching it to the moved resources. [Move user-assigned managed identities between regions](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-to-managed-identity-regional-move).
17. **Resiliency behavior:** The VM managed identity token endpoint can return HTTP **410 Gone** during a transient update and is expected to recover within **70 seconds**; clients should retry 410 and HTTP **429 Too Many Requests** responses with backoff. [Acquire managed identity tokens from an Azure VM](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-to-use-vm-token#error-handling).
18. **Conditional Access boundary:** Conditional Access for workload identities applies to service principals but excludes managed identities, so a requirement to apply workload-identity Conditional Access directly to the principal rules out a managed identity. [Conditional Access for workload identities](https://learn.microsoft.com/en-us/entra/identity/conditional-access/workload-identity#implementation).

### Incompatibilities and mutual exclusions

If a workload source does not support managed identities or its target cannot accept Microsoft Entra tokens, managed identity cannot provide direct authentication and authorization; use supported workload federation, a service principal, or the safest required service-native credential. [Managed identity developer guidance](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview-for-developers#what-resources-can-managed-identities-connect-to).

### Edge cases and gotchas

- A system-assigned identity cannot be shared or precreated independently, so active/passive resources receive different principals unless a user-assigned identity is used. [Managed identity type comparison](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview#differences-between-system-assigned-and-user-assigned-managed-identities).
- Applying target permissions directly to a shared user-assigned identity can change effective authorization faster than adding or removing managed identities from a permission-bearing group because the latter depends on cached group claims. [Managed identity authorization limitations](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations#limitation-of-using-managed-identities-for-authorization).
- Reusing one user-assigned identity reduces principal and assignment sprawl but increases blast radius across every attached source, so attachment permissions must be tightly governed. [Managed identity best practices](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations).
- Assignment restrictions are preview as of July 2026 and must be flagged rather than assumed as a generally available exam default. [Managed identity assignment restrictions](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identities-assignment-restriction).

### AZ-305 exam discriminator

“Azure-hosted,” “no credentials,” and “target supports Entra” point to managed identity; choose user-assigned when the identity must be shared, preauthorized, survive source recreation, or avoid mass principal-creation throttles. [Managed identity best-practice decision table](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations).

### Common trap

Enabling a managed identity does not authorize anything by itself; the identity still requires a target role assignment or service-specific grant. [Managed identities overview](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview).

---

## Azure Resource Manager planes and management hierarchy

**Classification:** Core  
**Why it matters:** Authorization can be correct only when the architect identifies the operation plane and the scope hierarchy through which permissions inherit.  
**Primary Microsoft source:** [Control-plane and data-plane operations](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/control-plane-and-data-plane)  
**Limits and quotas source:** [Azure management-group limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-management-group-limits)

### Deep technical facts / requirements

1. **Plane behavior:** Control-plane requests go through Azure Resource Manager at `management.azure.com`; data-plane requests go to a service-specific endpoint, and the two planes can use different permissions and authorization systems. [Azure control and data planes](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/control-plane-and-data-plane).
2. **Role mapping:** Role-definition `Actions` authorize control-plane calls and `DataActions` authorize supported data-plane calls, so a management role does not automatically read service data. [Understand Azure role definitions](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-definitions).
3. **Indirect data exposure:** Some control-plane operations, such as listing Storage account keys, return credentials that can provide data access even when the role has no `DataActions`. [Prevent Storage Shared Key authorization](https://learn.microsoft.com/en-us/azure/storage/common/shared-key-authorization-prevent#permissions-for-allowing-or-disallowing-shared-key-access).
4. **Hierarchy limit:** A tenant supports up to **10,000** management groups. [Azure management-group limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-management-group-limits).
5. **Depth limit:** The hierarchy supports the root management group plus **6** additional management-group levels; the subscription level is not counted in the six. [Azure management-group limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-management-group-limits).
6. **Parent constraint:** Each management group has exactly **1** direct parent, while the number of subscriptions in a management group is unlimited. [Azure management-group limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-management-group-limits).
7. **Inheritance:** A role assigned to a management group inherits to descendant management groups, subscriptions, resource groups, and resources, including future descendants unless a structural or assignment change alters the hierarchy. [Management-group inheritance](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview).
8. **Tenant boundary:** All management groups and subscriptions in one hierarchy trust the same Microsoft Entra tenant; moving a subscription to another tenant changes its identity trust and requires authorization reassessment. [Management groups overview](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview).
9. **Global service:** Azure Resource Manager provides a globally available management endpoint, and Azure RBAC authorization data is globally replicated rather than tied to the deployment region of a resource. [Azure RBAC data resiliency](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview#why-is-azure-rbac-data-global).
10. **Locks limit:** A unique Azure scope supports up to **20** management locks, separate from role assignments and Policy. [Azure Resource Manager resource-group limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-resource-group-limits).
11. **Operational boundary:** Resource providers can expose operations on different planes even when the portal presents one resource, so architects must inspect the operation and role definition rather than infer the plane from the resource name. [Azure control and data planes](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/control-plane-and-data-plane).
12. **Default hierarchy:** Every directory has one tenant root management group, and new subscriptions are placed under that root by default; administrators can configure a different default management group for new subscriptions. [Root management group behavior](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#root-management-group-for-each-directory).

### Incompatibilities and mutual exclusions

If a requirement demands access to a service’s data but the proposed role contains only control-plane `Actions`, that role cannot satisfy the requirement unless a separate credential-bearing management action creates an unintended bypass; select a data role or supported service-native authorization. [Azure control and data planes](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/control-plane-and-data-plane).

### Edge cases and gotchas

- A subscription can have only one management-group parent, so it cannot natively inherit two independent management-group branches at once. [Azure management-group limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-management-group-limits).
- High-scope assignments efficiently cover future subscriptions but also expand blast radius automatically as the hierarchy grows. [Management-group inheritance](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview).
- A management lock affects control-plane operations only and does not protect data-plane content such as blobs or SQL rows. [Understand resource-lock scope](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources#understand-scope-of-locks).

### AZ-305 exam discriminator

Words such as **deploy**, **configure**, and **delete the account** point to the control plane; **read blobs**, **retrieve a secret**, and **query data** point to the data plane, often requiring a different role. [Azure control and data planes](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/control-plane-and-data-plane).

### Common trap

Contributor on a resource is not a universal data-reader role; its control-plane permissions can manage configuration while data access remains separately denied. [Azure roles and control/data planes](https://learn.microsoft.com/en-us/azure/role-based-access-control/rbac-and-directory-admin-roles).

---

## Azure Storage and Data Lake Storage authorization

**Classification:** Core  
**Why it matters:** Storage is the highest-yield example of service-specific authorization because it supports Entra RBAC, ABAC, ACLs, multiple SAS types, Shared Key, and protocol-specific Azure Files behavior.  
**Primary Microsoft source:** [Authorize Azure Storage data](https://learn.microsoft.com/en-us/azure/storage/common/authorize-data-access)  
**Limits and quotas source:** [Storage SAS expiration policy](https://learn.microsoft.com/en-us/azure/storage/common/sas-expiration-policy)

### Deep technical facts / requirements

1. **Preferred identity model:** Microsoft recommends Microsoft Entra ID with managed identities for Blob, Queue, and Table requests whenever supported because it avoids account-key distribution and supplies principal-specific authorization. [Authorize Azure Storage data](https://learn.microsoft.com/en-us/azure/storage/common/authorize-data-access).
2. **Control/data split:** Owner, Contributor, Reader, and Storage Account Contributor manage the account but do not directly grant Blob data access; non-Reader management roles may still list keys and use them for full data access. [Data Lake Storage access-control model](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-access-control-model#role-based-access-control-azure-rbac).
3. **Shared Key power:** A Storage account key grants full account data access and can generate SAS tokens; Microsoft recommends carefully limiting, monitoring, and rotating keys and disabling Shared Key when compatibility permits. [Protect Storage access keys](https://learn.microsoft.com/en-us/azure/storage/common/authorize-data-access#protect-your-access-keys).
4. **Disable-key behavior:** With `AllowSharedKeyAccess=false`, Shared Key requests, service SAS, and account SAS are rejected, while a Blob user delegation SAS remains valid because it is authorized through Microsoft Entra ID. [Prevent Shared Key authorization](https://learn.microsoft.com/en-us/azure/storage/common/shared-key-authorization-prevent#understand-how-disallowing-shared-key-affects-sas-tokens).
5. **Conditional Access dependency:** Protecting Storage with Microsoft Entra Conditional Access requires disabling Shared Key, because key-authorized requests have no Entra sign-in context to evaluate. [Prevent Shared Key for Conditional Access](https://learn.microsoft.com/en-us/azure/storage/common/shared-key-authorization-prevent#disallow-shared-key-authorization-to-use-microsoft-entra-conditional-access).
6. **SAS hard limit:** A user delegation SAS has a maximum validity interval of **7 days**, regardless of the account’s configured SAS expiration policy. [Configure a SAS expiration policy](https://learn.microsoft.com/en-us/azure/storage/common/sas-expiration-policy).
7. **SAS policy default:** SAS expiration action defaults to **Log**, which permits out-of-policy requests and records status when diagnostics are configured; **Block** denies out-of-policy requests. [SAS expiration action](https://learn.microsoft.com/en-us/azure/storage/common/sas-expiration-policy#define-the-sas-expiration-action).
8. **SAS prerequisite:** When a SAS expiration policy is enabled, the signed start field is required to evaluate the validity interval; keys may need rotation before the portal allows the policy if key creation time is absent. [Configure a SAS expiration policy](https://learn.microsoft.com/en-us/azure/storage/common/sas-expiration-policy).
9. **Stored policy limit:** A Blob container, file share, queue, or table supports at most **5** stored access policies, and each signed identifier is limited to **64 characters**. [Define a stored access policy](https://learn.microsoft.com/en-us/rest/api/storageservices/define-stored-access-policy).
10. **Stored policy incompatibility:** Stored access policies apply to service SAS but are not supported for user delegation SAS or account SAS. [Define a stored access policy](https://learn.microsoft.com/en-us/rest/api/storageservices/define-stored-access-policy).
11. **Data Lake ACL limit:** A Data Lake Storage file or directory supports **32** access ACL entries and **32** default ACL entries; mandatory owner, owning-group, and other entries make the effective named-entry capacity approximately **28**. [Data Lake Storage access-control limits](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-access-control-model#limits-on-azure-role-assignments-and-acl-entries).
12. **Evaluation order:** Data Lake Storage evaluates Azure RBAC and ABAC before ACLs; if a role assignment grants sufficient access, an ACL cannot restrict that grant. [Data Lake Storage permission evaluation](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-access-control-model#how-permissions-are-evaluated).
13. **Identity bypass:** Shared Key, account SAS, and service SAS do not identify an Entra principal, so Azure RBAC, ABAC, and Data Lake ACLs do not constrain them; a user delegation SAS can participate in principal-based checks under documented conditions. [Data Lake Storage Shared Key and SAS evaluation](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-access-control-model#shared-key-and-shared-access-signature-sas-authorization).
14. **Azure Files layers:** Azure Files SMB authorization can use Azure RBAC for share-level access and Windows ACLs for directory/file-level permissions; the user identity must be available in or synchronized to the relevant Entra/AD identity source. [Azure Files authorization overview](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-authorization-overview).
15. **Compatibility edge:** Disabling Shared Key without first configuring Azure Files identity-based authorization can break portal and client access to file shares. [Prevent Shared Key authorization for Azure Files](https://learn.microsoft.com/en-us/azure/storage/common/shared-key-authorization-prevent#authorize-access-to-file-data-or-transition-azure-files-workloads).
16. **Network prerequisite:** Managing Data Lake ACLs through private endpoints requires both `blob` and `dfs` private endpoints because tools can call both endpoint types. [Manage Data Lake ACLs with private endpoints](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-explorer-acl).
17. **Tool-version requirement:** Recursive Data Lake ACL application in Azure Storage Explorer requires Storage Explorer version **1.28.1 or later**. [Apply Data Lake ACLs recursively with Storage Explorer](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-explorer-acl#apply-acls-recursively).

### Incompatibilities and mutual exclusions

If a design requires both Shared Key to remain enabled for legacy clients and Conditional Access to govern every Storage data request, the requirements are incompatible because Shared Key requests bypass Entra identity evaluation; migrate the legacy client or accept an explicitly bounded exception. [Prevent Shared Key for Conditional Access](https://learn.microsoft.com/en-us/azure/storage/common/shared-key-authorization-prevent#disallow-shared-key-authorization-to-use-microsoft-entra-conditional-access).

### Edge cases and gotchas

- A service SAS or account SAS stops working when Shared Key is disabled, but a user delegation SAS can continue. [Shared Key effects on SAS](https://learn.microsoft.com/en-us/azure/storage/common/shared-key-authorization-prevent#understand-how-disallowing-shared-key-affects-sas-tokens).
- An ACL cannot remove access already granted by a matching RBAC assignment; reduce or condition the RBAC grant first. [Data Lake Storage permission evaluation](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-access-control-model#how-permissions-are-evaluated).
- Default ACLs are templates inherited only by newly created child items; changing a parent default ACL does not retroactively rewrite every existing child without a recursive operation. [Manage Data Lake ACL inheritance](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-explorer-acl).
- Storage account management roles that include `listKeys` can be an indirect data-access path even though they contain no Blob `DataActions`. [Prevent Shared Key permissions](https://learn.microsoft.com/en-us/azure/storage/common/shared-key-authorization-prevent#permissions-for-allowing-or-disallowing-shared-key-access).

### AZ-305 exam discriminator

Prefer Entra RBAC and managed identity for supported clients; choose user delegation SAS for temporary Blob delegation; retain Shared Key only for a documented compatibility constraint, and remember the **7-day** user delegation SAS ceiling. [Authorize Azure Storage data](https://learn.microsoft.com/en-us/azure/storage/common/authorize-data-access) [SAS expiration policy](https://learn.microsoft.com/en-us/azure/storage/common/sas-expiration-policy).

### Common trap

Do not assume a Data Lake ACL can override broad Storage Blob Data access granted through RBAC; RBAC/ABAC are evaluated first and a sufficient grant bypasses ACL evaluation. [Data Lake Storage permission evaluation](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-access-control-model#how-permissions-are-evaluated).

---

## Azure Key Vault authorization

**Classification:** Supporting  
**Why it matters:** Key Vault exposes a high-value separation-of-duties choice between centralized Azure RBAC and the legacy vault access-policy model.  
**Primary Microsoft source:** [Key Vault RBAC versus access policies](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-access-policy)  
**Limits and quotas source:** [Key Vault access-control default and API timeline](https://learn.microsoft.com/en-us/azure/key-vault/general/access-control-default)

### Deep technical facts / requirements

1. Key Vault uses Microsoft Entra ID for authentication and supports Azure RBAC or legacy vault access policies for data-plane authorization. [Key Vault RBAC versus access policies](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-access-policy).
2. Under the access-policy model, Contributor, Key Vault Contributor, or any role containing `Microsoft.KeyVault/vaults/write` can configure an access policy and potentially grant itself data access; RBAC limits role assignment to access administrators such as Owner or User Access Administrator. [Key Vault authorization-model comparison](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-access-policy).
3. Azure RBAC is Microsoft’s recommended Key Vault authorization model because it centralizes access, supports PIM, and improves separation between resource configuration and data access. [Key Vault authorization-model recommendation](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-access-policy#data-plane-access-control-recommendation).
4. For new vaults created with control-plane API version `2026-02-01` or later, `enableRbacAuthorization` defaults to `true`; existing vaults retain their current access model unless explicitly changed. [Key Vault API 2026-02-01 access-control default](https://learn.microsoft.com/en-us/azure/key-vault/general/access-control-default).
5. All Key Vault control-plane API versions earlier than `2026-02-01` retire on **February 27, 2027**; data-plane API versions are not affected by that retirement. [Key Vault API retirement timeline](https://learn.microsoft.com/en-us/azure/key-vault/general/access-control-default).
6. Object-scope Key Vault RBAC assignments support read-oriented access, while administrative operations such as network configuration, monitoring, and object management require vault-level permissions; Microsoft recommends one vault per application for secure isolation. [Secure Azure Key Vault authorization](https://learn.microsoft.com/en-us/azure/key-vault/general/secure-key-vault).
7. Migrating from access policies requires both `Microsoft.KeyVault/vaults/write` and `Microsoft.Authorization/roleAssignments/write`, inventory of every existing identity/policy, and validation before changing `enableRbacAuthorization`. [Migrate Key Vault to Azure RBAC](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-migration).
8. PIM can make Key Vault Azure roles eligible and require approval/MFA, whereas the legacy access-policy model does not integrate with Azure RBAC assignment lifecycle in the same way. [Key Vault RBAC versus access policies](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-access-policy).
9. Azure Policy includes controls to audit or deny vaults that do not use the RBAC permission model, but Policy enforcement can lag after assignment. [Integrate Key Vault with Azure Policy](https://learn.microsoft.com/en-us/azure/key-vault/general/azure-policy).
10. Key Vault network restrictions and private endpoints limit reachability but do not replace Entra authentication and RBAC/access-policy authorization. [Secure Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/secure-key-vault).

### Incompatibilities and mutual exclusions

If a design requires strict separation so ordinary vault Contributors cannot grant themselves secret access, the legacy access-policy model cannot meet that boundary safely; use Azure RBAC with separate access administrators. [Key Vault RBAC versus access policies](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-access-policy).

### Edge cases and gotchas

- Upgrading an existing vault through API `2026-02-01` does not automatically migrate its access-policy model to RBAC. [Key Vault API access-control behavior](https://learn.microsoft.com/en-us/azure/key-vault/general/access-control-default).
- Switching authorization models without first creating equivalent RBAC assignments can lock applications and operators out of vault data. [Migrate Key Vault to Azure RBAC](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-migration).
- Access-policy mode remains supported after the 2026 default change, but new API-based deployments must explicitly set `enableRbacAuthorization=false` to continue using it. [Key Vault API 2026-02-01 access-control default](https://learn.microsoft.com/en-us/azure/key-vault/general/access-control-default).

### AZ-305 exam discriminator

Choose Key Vault RBAC when separation of duties, centralized access, PIM, or a new API `2026-02-01` design is required; treat access policies as a legacy compatibility choice that needs explicit justification. [Key Vault RBAC versus access policies](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-access-policy).

### Common trap

Key Vault Contributor manages the vault control plane but is not the correct least-privilege role for reading secrets; choose an appropriate Key Vault data role for the principal. [Key Vault built-in roles](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide).

---

## Azure Lighthouse

**Classification:** Supporting  
**Why it matters:** Lighthouse projects customer subscriptions or resource groups into a managing tenant and grants scoped cross-tenant Azure management without individual customer-tenant accounts.  
**Primary Microsoft source:** [Lighthouse tenants, users, and roles](https://learn.microsoft.com/en-us/azure/lighthouse/concepts/tenants-users-roles)  
**Limits and quotas source:** [Create eligible Lighthouse authorizations](https://learn.microsoft.com/en-us/azure/lighthouse/how-to/create-eligible-authorizations)

### Deep technical facts / requirements

1. A Lighthouse authorization pairs a managing-tenant principal ID with a supported Azure built-in role over a delegated customer subscription or resource group. [Lighthouse tenants, users, and roles](https://learn.microsoft.com/en-us/azure/lighthouse/concepts/tenants-users-roles).
2. Lighthouse supports managing-tenant users, security groups, and service principals for permanent authorizations; assigning a group requires a Microsoft Entra **Security** group. [Lighthouse authorization principals](https://learn.microsoft.com/en-us/azure/lighthouse/concepts/tenants-users-roles).
3. Lighthouse does not support custom Azure roles, classic subscription administrator roles, Owner, or roles containing `DataActions`. [Lighthouse role support](https://learn.microsoft.com/en-us/azure/lighthouse/concepts/tenants-users-roles#role-support-for-azure-lighthouse).
4. User Access Administrator is supported only for constrained assignment of specified roles to managed identities in the customer tenant, not for unrestricted customer access administration. [Lighthouse role support](https://learn.microsoft.com/en-us/azure/lighthouse/concepts/tenants-users-roles#role-support-for-azure-lighthouse).
5. Microsoft recommends including Managed Services Registration Assignment Delete Role so the managing tenant can remove a delegation; without it, only an authorized customer-tenant user can remove the delegated access. [Lighthouse authorization best practices](https://learn.microsoft.com/en-us/azure/lighthouse/concepts/tenants-users-roles#best-practices-for-defining-azure-lighthouse-users-and-roles).
6. Eligible Lighthouse authorizations support activation durations from **30 minutes to 8 hours**. [Create eligible Lighthouse authorizations](https://learn.microsoft.com/en-us/azure/lighthouse/how-to/create-eligible-authorizations#access-policy).
7. An eligible authorization can specify up to **10** approver users or groups, and an approver cannot approve their own elevation. [Lighthouse eligible authorization approvers](https://learn.microsoft.com/en-us/azure/lighthouse/how-to/create-eligible-authorizations#approvers).
8. Eligible authorizations require a valid PIM-capable Microsoft Entra ID Governance license in the managing tenant and are not supported in national clouds. [Lighthouse eligible authorization requirements](https://learn.microsoft.com/en-us/azure/lighthouse/how-to/create-eligible-authorizations#license-requirements).
9. Service principals cannot use eligible Lighthouse authorizations because a noninteractive principal cannot perform the activation workflow. [Lighthouse eligible authorization users](https://learn.microsoft.com/en-us/azure/lighthouse/how-to/create-eligible-authorizations#user).
10. A principal with an eligible authorization also needs a permanent authorization such as Reader to see the delegation and activate through the Azure portal. [Lighthouse eligible authorization role requirements](https://learn.microsoft.com/en-us/azure/lighthouse/how-to/create-eligible-authorizations#role).
11. Managing-tenant administrators see PIM activity in their audit logs, while the customer sees delegated actions in the customer subscription Activity Log. [Lighthouse eligible authorization audit](https://learn.microsoft.com/en-us/azure/lighthouse/how-to/create-eligible-authorizations#how-eligible-authorizations-work).

### Incompatibilities and mutual exclusions

If cross-tenant access requires Owner, a custom role, or direct data-plane `DataActions`, Azure Lighthouse cannot provide that role; separate the management delegation from the required data-access design. [Lighthouse role support](https://learn.microsoft.com/en-us/azure/lighthouse/concepts/tenants-users-roles#role-support-for-azure-lighthouse).

### Edge cases and gotchas

- A supported management role can contain operations that indirectly expose data even though Lighthouse rejects explicit `DataActions`, so least-privilege review still matters. [Lighthouse role support](https://learn.microsoft.com/en-us/azure/lighthouse/concepts/tenants-users-roles#role-support-for-azure-lighthouse).
- An eligible authorization cannot use User Access Administrator and cannot be assigned to a service principal. [Create eligible Lighthouse authorizations](https://learn.microsoft.com/en-us/azure/lighthouse/how-to/create-eligible-authorizations).
- Users need Reader or another role containing Reader access to view **My customers** in the portal. [Lighthouse authorization best practices](https://learn.microsoft.com/en-us/azure/lighthouse/concepts/tenants-users-roles#best-practices-for-defining-azure-lighthouse-users-and-roles).

### AZ-305 exam discriminator

“Manage resources across customer or subsidiary tenants without creating operator accounts in each tenant” points to Lighthouse, but any Owner, custom-role, or data-plane requirement eliminates Lighthouse for that portion. [Lighthouse role support](https://learn.microsoft.com/en-us/azure/lighthouse/concepts/tenants-users-roles#role-support-for-azure-lighthouse).

### Common trap

Do not assume Lighthouse is generic cross-tenant RBAC: its supported built-in role set deliberately excludes Owner, custom roles, and roles with `DataActions`. [Lighthouse role support](https://learn.microsoft.com/en-us/azure/lighthouse/concepts/tenants-users-roles#role-support-for-azure-lighthouse).

---

## Conditional Access, Azure Policy, resource locks, and authorization monitoring

**Classification:** Supporting  
**Why it matters:** These controls secure, constrain, and audit authorization but answer different questions from Azure RBAC.  
**Primary Microsoft source:** [Azure Policy and Azure RBAC](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-policy-and-azure-rbac)  
**Limits and quotas source:** [Azure Activity Log retention for RBAC changes](https://learn.microsoft.com/en-us/azure/role-based-access-control/change-history-report)

### Deep technical facts / requirements

1. Conditional Access evaluates identity, device, location, risk, and target-resource signals before or during token issuance; it does not define Azure resource operations or scope. [Conditional Access overview](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview).
2. Targeting the Windows Azure Service Management API applies Conditional Access to Azure Resource Manager, Azure portal, Azure CLI, Azure PowerShell, and documented related management services; it no longer covers Azure DevOps. [Conditional Access target resources](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-cloud-apps#windows-azure-service-management-api).
3. Conditional Access requires Microsoft Entra ID P1 or another license that includes it; risk-based policies and ID Protection capabilities can require P2. [Conditional Access license requirements](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview#license-requirements).
4. Azure Policy evaluates resource state without regard to who made the change, while Azure RBAC evaluates whether a caller may perform an action; an authorized caller can still be blocked when the resulting state violates Policy. [Azure Policy versus Azure RBAC](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-policy-and-azure-rbac).
5. Policy remediation through `deployIfNotExists` or `modify` uses a managed identity that must receive the necessary Azure RBAC permissions; Policy does not confer those permissions implicitly. [Azure Policy RBAC permissions](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-rbac-permissions-in-azure-policy).
6. A `CanNotDelete` lock permits reads and updates but blocks deletion; a `ReadOnly` lock blocks update and deletion and behaves similarly to imposing Reader-like control-plane restrictions on all authorized users. [Azure resource-lock types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources).
7. Locks inherit from parent scopes, and the most restrictive lock in the inheritance chain takes precedence. [Azure resource-lock inheritance](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources#lock-inheritance).
8. Locks affect control-plane operations only; they do not protect Blob, Queue, Table, File, or database data modified through service data-plane endpoints. [Azure resource-lock scope](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources#understand-scope-of-locks).
9. Azure records role assignment create/delete and custom role create/update/delete operations in the Activity Log for **90 days**. [View Azure RBAC Activity Logs](https://learn.microsoft.com/en-us/azure/role-based-access-control/change-history-report).
10. Routing the Activity Log to Azure Monitor Logs enables longer retention, cross-resource queries, alerts, and correlation but introduces ingestion, retention, query, and alerting costs. [Azure RBAC changes in Azure Monitor Logs](https://learn.microsoft.com/en-us/azure/role-based-access-control/change-history-report#azure-monitor-logs).
11. Azure Monitor can alert on privileged role assignment creation by querying `Microsoft.Authorization/roleAssignments/write`, and the alert incurs Azure Monitor/query/notification cost. [Alert on privileged Azure role assignments](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-alert).
12. Key Vault Policy assignments with `deny` can take up to **30 minutes average** and **1 hour worst case** to begin denying new noncompliant resources; existing component compliance can take up to **1 hour average** and **2 hours worst case** to appear. [Key Vault Azure Policy limitations](https://learn.microsoft.com/en-us/azure/key-vault/general/azure-policy#feature-limitations).

### Incompatibilities and mutual exclusions

If a requirement is to grant a principal permission to an Azure resource, Conditional Access, Policy, and locks cannot replace Azure RBAC because none defines a principal-role-scope grant. [Azure Policy versus Azure RBAC](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-policy-and-azure-rbac).

### Edge cases and gotchas

- A ReadOnly lock can block control-plane operations that appear read-like, including POST-based key listing and creation or deletion of child/extension resources. [Resource-lock considerations](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources#considerations-before-applying-your-locks).
- Conditional Access targeting the management API can affect portal, CLI, PowerShell, and dependent services together; test report-only behavior and service dependencies before enforcement. [Conditional Access target resources](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-cloud-apps#windows-azure-service-management-api).
- The native **90-day** Activity Log window is not a compliance-retention architecture; export before expiry when longer evidence retention is mandatory. [View Azure RBAC Activity Logs](https://learn.microsoft.com/en-us/azure/role-based-access-control/change-history-report).

### AZ-305 exam discriminator

Use RBAC for **who can act**, Conditional Access for **under which sign-in conditions**, Policy for **which resource states are allowed**, locks for **blocking control-plane update/delete**, and Activity Log/Azure Monitor for **evidence and alerting**. [Azure Policy versus Azure RBAC](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-policy-and-azure-rbac) [Azure resource locks](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources).

### Common trap

A private endpoint, firewall, Conditional Access rule, Policy assignment, or resource lock can deny a request, but none grants the target operation; successful access still needs the appropriate identity and authorization. [Azure Well-Architected identity and access guidance](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access).

---

## Well-Architected Framework and Cloud Adoption Framework access design

**Classification:** Architecture guidance  
**Why it matters:** The frameworks define how to apply RBAC mechanics consistently to workloads, platform teams, landing zones, and privileged-access boundaries.  
**Primary Microsoft source:** [Well-Architected identity and access strategies](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access)  
**Limits and quotas source:** Not applicable; framework guidance consumes product limits rather than defining a separate service quota.

### Deep technical facts / requirements

1. The Well-Architected Framework recommends centralized identity, least privilege, short-lived privilege, workload identities, and explicit emergency-access design instead of shared or embedded credentials. [Well-Architected identity and access strategies](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access).
2. Least privilege has three dimensions—permission set, scope, and duration—so narrowing only the role while leaving subscription-wide, permanent access does not complete the design. [Azure RBAC best practices](https://learn.microsoft.com/en-us/azure/role-based-access-control/best-practices).
3. The Cloud Adoption Framework landing-zone model separates platform and application responsibilities and recommends group-based RBAC, PIM for privileged operations, and standardized roles across the hierarchy. [Landing-zone identity and access management](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones).
4. High-scope custom roles and assignments become enterprise controls because every descendant landing zone can inherit them; change management must match their blast radius. [Management-group inheritance](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview).
5. Human and workload authorization require different lifecycle controls: human access follows group membership, PIM, and review, while workload access follows identity attachment, code-execution boundaries, and target-role assignment. [Well-Architected identity and access strategies](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access).
6. Emergency access must be deliberately designed and tested because normal Conditional Access, approval, or identity dependencies can fail during an incident; emergency paths should not become routine standing privilege. [Well-Architected emergency access](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access#emergency-access).
7. Network isolation is defense in depth rather than authorization: a private endpoint limits reachable paths, while the resource still evaluates Entra identity and RBAC or its service-native authorization model. [Well-Architected networking security](https://learn.microsoft.com/en-us/azure/well-architected/security/networking).
8. Access architecture must define owners for role catalog, group membership, PIM policy, workload identities, service data authorization, and evidence retention; leaving all functions with one platform group undermines separation of duties. [Landing-zone identity and access management](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones).

### Incompatibilities and mutual exclusions

If a landing-zone requirement calls for strict workload-team isolation, a broad management-group Contributor or Owner assignment to all application teams cannot satisfy it because inheritance crosses every descendant scope. [Landing-zone identity and access management](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones).

### Edge cases and gotchas

- Standardization does not mean every assignment belongs at management-group scope; high scope is appropriate only when responsibility truly spans every descendant. [Understand Azure RBAC scope](https://learn.microsoft.com/en-us/azure/role-based-access-control/scope-overview).
- A shared user-assigned identity can reduce deployment friction but creates a shared security boundary across every attached workload. [Managed identity best practices](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations).
- Governance controls must preserve operational recovery; an approval model with one approver or an untested emergency path creates availability risk. [Configure PIM approvers](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-configure-role-settings#require-approval-to-activate).

### AZ-305 exam discriminator

Use Well-Architected guidance for workload-level role, identity, and privilege choices; use Cloud Adoption Framework guidance when the scenario adds many subscriptions, platform/application separation, management groups, or landing zones. [Well-Architected identity and access strategies](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access) [Landing-zone identity and access management](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones).

### Common trap

Do not turn a narrow application authorization requirement into an enterprise management-group assignment merely because the Cloud Adoption Framework uses management groups; scope must follow actual ownership and blast-radius requirements. [Understand Azure RBAC scope](https://learn.microsoft.com/en-us/azure/role-based-access-control/scope-overview).

---

## Highest-yield exam discriminators

| Scenario clue | Best answer | Why |
|---|---|---|
| User needs to manage Azure VMs, not directory users | Azure RBAC role | Azure roles govern Resource Manager resources; Microsoft Entra roles govern directory objects. [Azure roles versus Microsoft Entra roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/rbac-and-directory-admin-roles). |
| Team changes membership frequently | Security group role assignment | One group assignment centralizes membership lifecycle and conserves the fixed **4,000** assignments per subscription. [Azure RBAC best practices](https://learn.microsoft.com/en-us/azure/role-based-access-control/best-practices#assign-roles-to-groups-not-users) [RBAC assignment limit](https://learn.microsoft.com/en-us/azure/role-based-access-control/troubleshoot-limits). |
| Exact operation set does not match a built-in role | Custom Azure role | Custom roles define explicit `Actions`/`DataActions`, but the tenant limit is **5,000** and wildcards can expand silently. [Azure custom roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles). |
| Reader at resource scope is intended to reduce inherited Contributor | Remove or narrow the inherited grant | Azure RBAC grants are additive; a lower-scope Reader assignment cannot subtract Contributor. [Azure RBAC multiple assignments](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview#multiple-role-assignments). |
| Blob access depends on tag/path/principal attribute | Azure ABAC condition | Conditions refine supported Blob/Queue data actions; they are not supported for arbitrary Azure services. [Azure ABAC overview](https://learn.microsoft.com/en-us/azure/role-based-access-control/conditions-overview). |
| Temporary privileged Azure role with approval and MFA | PIM eligible assignment | PIM provides JIT activation from **1–24 hours**, approval, MFA, justification, and audit with P2/Governance licensing. [PIM Azure role settings](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-configure-role-settings). |
| Quarterly confirmation that Azure Owners still need access | PIM access review | PIM can run recurring Azure resource-role reviews; monthly reviews can last at most **27 days**. [Create PIM access reviews](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-create-roles-and-resource-roles-review). |
| Azure workload needs target access without a stored secret | Managed identity plus target role | Azure manages the credential, but enabling the identity grants no target permissions by itself. [Managed identities overview](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview). |
| Identity must be shared, preauthorized, or survive source recreation | User-assigned managed identity | Its lifecycle is independent and it can attach to multiple supported resources. [Managed identity comparison](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview#differences-between-system-assigned-and-user-assigned-managed-identities). |
| Rapid managed-identity permission revocation is required | Direct role on a user-assigned identity and propagation-aware design | Group/role claim changes can remain in managed identity token caches for around **24 hours**. [Managed identity authorization limitations](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations#limitation-of-using-managed-identities-for-authorization). |
| Contributor can create a storage account but cannot read blobs | Add a Storage data role | Control-plane `Actions` and data-plane `DataActions` are distinct. [Azure control and data planes](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/control-plane-and-data-plane). |
| Temporary delegated Blob access | User delegation SAS | It is secured with Entra credentials and has a hard maximum validity of **7 days**. [Storage SAS expiration policy](https://learn.microsoft.com/en-us/azure/storage/common/sas-expiration-policy). |
| Every Storage request must be governed by Conditional Access | Disable Shared Key after migration | Shared Key, service SAS, and account SAS bypass Entra evaluation; disabling Shared Key rejects them while user delegation SAS can continue. [Prevent Shared Key authorization](https://learn.microsoft.com/en-us/azure/storage/common/shared-key-authorization-prevent). |
| Data Lake directory-level permission must restrict a broad RBAC grant | Narrow the RBAC grant first | RBAC/ABAC are evaluated before ACLs, and an ACL cannot subtract access already granted by RBAC. [Data Lake Storage permission evaluation](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-access-control-model#how-permissions-are-evaluated). |
| New Key Vault created with API `2026-02-01` | Azure RBAC authorization | RBAC is the new-vault default for that API version; existing vaults retain their prior model. [Key Vault access-control default](https://learn.microsoft.com/en-us/azure/key-vault/general/access-control-default). |
| Strict Key Vault separation of resource management and secret access | Key Vault Azure RBAC | Legacy access policies let principals with `vaults/write` grant themselves data access; RBAC separates access assignment. [Key Vault RBAC versus access policies](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-access-policy). |
| Service provider manages customer subscriptions without customer accounts | Azure Lighthouse | Lighthouse projects supported built-in roles across tenants but excludes Owner, custom roles, and roles with `DataActions`. [Lighthouse role support](https://learn.microsoft.com/en-us/azure/lighthouse/concepts/tenants-users-roles#role-support-for-azure-lighthouse). |
| Authorized user must be blocked from deploying outside approved regions | Azure Policy plus RBAC | RBAC decides whether the caller can deploy; Policy blocks a noncompliant resulting resource state. [Azure Policy versus Azure RBAC](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-policy-and-azure-rbac). |
| Prevent accidental resource deletion for all authorized principals | `CanNotDelete` resource lock | The lock overrides user permissions for control-plane deletion but does not protect data-plane content. [Azure resource locks](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources). |
| Retain RBAC-change evidence longer than native history | Export Activity Log to Azure Monitor/Storage | Native RBAC change history is **90 days**; routing supports longer retention and correlation at additional monitoring cost. [View Azure RBAC Activity Logs](https://learn.microsoft.com/en-us/azure/role-based-access-control/change-history-report). |

---

_Model used to research and author this fact sheet: GPT5 (reasoning mode not supplied)._
