# Deep Technical Facts and Requirements for Recommend an Identity Management Solution

## Scope

- Exam: AZ-305: Designing Microsoft Azure Infrastructure Solutions
- Task: Recommend an identity management solution
- Source guide: *Identity management study guide - GPT5.md*, validated against *Identity management task map.md* and the AZ-305 skill hierarchy
- Research date: July 2026
- Product selection method: Products and major topics were extracted from the provided guide, then validated against current official Microsoft documentation.

## Product coverage summary

| Product / topic | Classification | Why it matters for this task |
|---|---|---|
| Microsoft Entra ID workforce tenants, users, groups, domains, and licenses | Core | Defines the primary workforce directory, tenant boundary, identity objects, assignment units, and directory-scale constraints. [Microsoft Entra enterprise user management](https://learn.microsoft.com/en-us/entra/identity/users/) |
| Hybrid identity: Microsoft Entra Cloud Sync and Connect Sync | Core | Determines how AD DS-authoritative identities are represented in Entra ID and which synchronization engine can meet the topology, scale, and writeback requirements. [Cloud Sync decision guide](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/connect-to-cloud-sync-decision-guide) |
| Microsoft Entra External ID: B2B collaboration and external tenants | Core | Separates partner collaboration in a workforce tenant from customer identity and access management in a dedicated external tenant. [External ID tenant configurations](https://learn.microsoft.com/en-us/entra/external-id/tenant-configurations) |
| Multitenant organizations and cross-tenant synchronization | Core | Coordinates identity lifecycle when legal, sovereignty, merger, or operational constraints require multiple workforce tenants. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview) |
| Application, HR-driven, and API-driven provisioning | Core | Automates joiner, mover, and leaver changes from a system of record to Entra ID, AD DS, and application directories. [Microsoft Entra provisioning overview](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/user-provisioning) |
| Microsoft Entra Domain Services and self-managed AD DS | Core | Supplies traditional domain join, LDAP, Kerberos, NTLM, DNS, and Group Policy where modern Entra ID protocols alone cannot satisfy a workload. [Compare Microsoft directory-based services](https://learn.microsoft.com/en-us/entra/identity/domain-services/compare-identity-solutions) |
| Microsoft Entra device identities | Supporting | Distinguishes personal registration, cloud join, and hybrid join as different identity objects and lifecycle models. [Microsoft Entra device identity](https://learn.microsoft.com/en-us/entra/identity/devices/overview) |
| Microsoft Entra Backup and Recovery and identity monitoring | Supporting | Defines which cloud directory objects can be recovered and how audit, sign-in, and provisioning evidence must be retained. [Microsoft Entra Backup and Recovery](https://learn.microsoft.com/en-us/entra/backup/overview) |
| Tenant-boundary and source-of-authority architecture | Architecture guidance | Establishes when one tenant and one authority are sufficient and when isolation or multiple lifecycle flows are justified. [Multitenant user management](https://learn.microsoft.com/en-us/entra/architecture/multi-tenant-user-management-introduction) |

---

## Microsoft Entra ID workforce tenants, users, groups, domains, and licenses

**Classification:** Core  
**Why it matters:** A workforce-identity design begins with the tenant boundary, authoritative user objects, group model, domain namespace, and licensing model. These constraints determine whether a proposed central directory can scale and whether membership and license automation are valid. [Microsoft Entra enterprise user management](https://learn.microsoft.com/en-us/entra/identity/users/)  
**Primary Microsoft source:** [Microsoft Entra ID documentation](https://learn.microsoft.com/en-us/entra/identity/)  
**Limits and quotas source:** [Microsoft Entra service limits and restrictions](https://learn.microsoft.com/en-us/entra/identity/users/directory-service-limits-restrictions)

### Deep technical facts / requirements

1. A Microsoft Entra tenant allows **50,000** objects by default; verifying a custom domain raises the default limit to **300,000**, and directories that need more than **500,000** objects require a qualifying license such as Microsoft 365, Entra ID P1/P2, or Enterprise Mobility + Security. [Microsoft Entra Connect prerequisites and directory limits](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-install-prerequisites).
2. One user can be a member or guest in at most **500** Entra tenants, and a tenant can contain at most **300** license-based subscriptions such as Microsoft 365 subscriptions. [Microsoft Entra service limits and restrictions](https://learn.microsoft.com/en-us/entra/identity/users/directory-service-limits-restrictions).
3. A tenant can add up to **5,000 managed custom domains** or up to **2,500 federated domains**; the primary domain can be changed only to a verified, nonfederated domain, and changing it does not rename existing users. [Manage custom domain names](https://learn.microsoft.com/en-us/entra/identity/users/domains-manage).
4. A nonadministrator can create at most **250 groups**, while an administrator with an appropriate group-management role is limited only by the tenant object quota. A group can have at most **100 owners**, and a tenant can contain at most **500 role-assignable groups**. [Microsoft Entra service limits and restrictions](https://learn.microsoft.com/en-us/entra/identity/users/directory-service-limits-restrictions).
5. A tenant can contain at most **15,000** dynamic membership groups and dynamic administrative units combined. A dynamic group can contain users or devices, but one rule cannot mix both object types, and device rules can reference only device attributes—not attributes of a device owner. [Manage dynamic membership groups](https://learn.microsoft.com/en-us/entra/identity/users/groups-dynamic-membership).
6. Dynamic membership requires enough Entra ID P1 licenses to cover every unique user who belongs to one or more dynamic groups; devices in device-based dynamic groups do not require licenses. Membership is system-computed, so administrators cannot manually add or remove members from a dynamic group. [Manage dynamic membership groups](https://learn.microsoft.com/en-us/entra/identity/users/groups-dynamic-membership).
7. Dynamic membership changes are usually processed within a few hours but can take more than **24 hours** depending on tenant scale, rule complexity, attribute volume, and operators such as `CONTAINS`, `MATCH`, or `memberOf`; dynamic membership is therefore not a synchronous entitlement mechanism. [Troubleshoot dynamic group processing](https://learn.microsoft.com/en-us/troubleshoot/entra/entra-id/dir-dmns-obj/troubleshoot-dynamic-group-processing).
8. Group-based licensing does not expand nested groups: if a license is assigned to a group that contains another group, only direct user members of the licensed group receive the license. [Assign licenses to groups](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/manage-group-licenses?view=o365-worldwide).
9. Microsoft Entra Connect can synchronize a group with at most **250,000 members**. This is distinct from the number of members a cloud-only group may contain and can invalidate a hybrid group design even when the target Entra group itself can hold more members. [Microsoft Entra service limits and restrictions](https://learn.microsoft.com/en-us/entra/identity/users/directory-service-limits-restrictions).
10. When group claims are requested, a SAML assertion carries at most **150** group memberships and a JWT/OIDC token at most **200**; above the relevant limit Entra emits an overage indication instead of the complete group list. Group filtering is supported only when the user has **1,000 or fewer** direct and transitive group memberships. [Microsoft Entra service limits and restrictions](https://learn.microsoft.com/en-us/entra/identity/users/directory-service-limits-restrictions).
11. A user can belong to any number of groups as a directory relationship, but downstream controls impose separate ceilings: Conditional Access evaluates up to **4,096** direct and indirect memberships, and some access evaluations can fail when a user exceeds **2,048** direct and nested memberships. [Microsoft Entra service limits and restrictions](https://learn.microsoft.com/en-us/entra/identity/users/directory-service-limits-restrictions).
12. Built-in Entra roles are available without P1, but every user assigned a custom directory role requires Entra ID P1. Administrative-unit role scoping also requires P1 for each scoped administrator, and dynamic administrative-unit membership requires P1 coverage for members. [Microsoft Entra licensing](https://learn.microsoft.com/en-us/entra/fundamentals/licensing).

### Incompatibilities and mutual exclusions

If a design requires one dynamic group to contain both users and devices, that group cannot be used because dynamic membership rules are object-type specific; create separate user and device groups. If the same design expects a group-assigned license to flow through nested groups, group-based licensing also cannot satisfy it because only first-level user members are licensed. [Manage dynamic membership groups](https://learn.microsoft.com/en-us/entra/identity/users/groups-dynamic-membership) [Assign licenses to groups](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/manage-group-licenses?view=o365-worldwide).

### Edge cases and gotchas

- A newly created tenant has a temporary quota of only **600 directory objects** for its first **2 days**; afterward the normal **50,000**-object or verified-domain **300,000**-object quota applies. [Microsoft Entra service limits and restrictions](https://learn.microsoft.com/en-us/entra/identity/users/directory-service-limits-restrictions).
- A custom domain already verified in one tenant generally cannot be verified in another tenant, although a separately verified subdomain can be placed in another tenant; namespace ownership is therefore part of tenant-topology design. [Microsoft Entra Connect supported topologies](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/plan-connect-topologies) [Manage custom domain names](https://learn.microsoft.com/en-us/entra/identity/users/domains-manage).
- A role-assignable group must use assigned membership; using a writable attribute to drive a sensitive dynamic group can let anyone who can change that attribute influence access. [Manage dynamic membership groups](https://learn.microsoft.com/en-us/entra/identity/users/groups-dynamic-membership).
- The `memberOf` dynamic membership operator is **[Preview]** and Microsoft advises using the preview only in test environments because it can affect tenant-wide dynamic-group processing. [Dynamic `memberOf` rules](https://learn.microsoft.com/en-us/entra/identity/users/groups-dynamic-rule-member-of).
- Verifying a domain raises the default object quota but does not automatically grant unlimited capacity; requirements above **500,000** objects still introduce a licensing dependency. [Microsoft Entra Connect prerequisites and directory limits](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-install-prerequisites).

### AZ-305 exam discriminator

Use a workforce tenant with cloud users and groups when Entra ID is the authority and no traditional domain or upstream HR/AD authority is required; then validate dynamic membership, group nesting, group-claim, domain, and object-count limits before treating groups as the universal scale mechanism. [Microsoft Entra enterprise user management](https://learn.microsoft.com/en-us/entra/identity/users/) [Microsoft Entra service limits and restrictions](https://learn.microsoft.com/en-us/entra/identity/users/directory-service-limits-restrictions).

### Common trap

Do not assume that a group which can hold a large population will behave identically in synchronization, licensing, tokens, and policy evaluation: those consumers have independent limits of **250,000**, direct-members-only nesting behavior, **150/200** token memberships, and separate Conditional Access membership ceilings. [Microsoft Entra service limits and restrictions](https://learn.microsoft.com/en-us/entra/identity/users/directory-service-limits-restrictions) [Assign licenses to groups](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/manage-group-licenses?view=o365-worldwide).

---

## Hybrid identity: Microsoft Entra Cloud Sync and Connect Sync

**Classification:** Core  
**Why it matters:** Hybrid identity preserves an AD DS source of authority while giving users a corresponding cloud identity. The synchronization-engine choice is separate from the authentication-method choice and is constrained by topology, scale, writeback, agent, database, and version requirements. [Hybrid identity overview](https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity)  
**Primary Microsoft source:** [Cloud Sync and Connect Sync decision guide](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/connect-to-cloud-sync-decision-guide)  
**Limits and quotas source:** [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq) and [Microsoft Entra Connect prerequisites](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-install-prerequisites)

### Deep technical facts / requirements

1. Cloud Sync stores the synchronization configuration in Entra ID and runs orchestration in the cloud through lightweight on-premises provisioning agents; Connect Sync stores and runs the synchronization configuration on an on-premises Connect server. [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).
2. The Cloud Sync agent must run on a domain-joined Windows Server **2016, 2019, or 2022** host with at least **4 GB RAM** and .NET Framework **4.7.1 or later**; Windows Server Core is unsupported. As of July 2026, Windows Server 2025 is not supported, even though installing the October 20, 2025 update or later mitigates a known synchronization issue after an in-place upgrade. [Cloud Sync prerequisites](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites).
3. Cloud Sync requires a non-guest Hybrid Identity Administrator in Entra ID and Domain Administrator or Enterprise Administrator credentials to create its group managed service account. The server is a control-plane asset, and Microsoft recommends restricting its administration accordingly. [Cloud Sync prerequisites](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites).
4. Microsoft recommends **3 active Cloud Sync agents** for high availability. Multiple agents provide failover, but they do not load-balance a job—only one agent processes it at a time. [Cloud Sync prerequisites](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites) [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).
5. Cloud Sync schedules password-hash synchronization every **2–5 minutes** and user/group provisioning approximately every **10–20 minutes**; actual completion time grows with the queued change volume. [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).
6. Cloud Sync supports up to **50,000 members** in a group synchronized with OU scoping. Security-group scoping does not include nested objects beyond the first level and is recommended only for pilots; use OU scoping for production scale. [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).
7. Across Cloud Sync forests, users and groups must be uniquely identifiable; Cloud Sync does not match objects across forests. It automatically selects `ms-DS-ConsistencyGuid` as the source anchor when present and otherwise uses `objectGUID`, and that choice cannot be changed. [Cloud Sync supported topologies](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/plan-cloud-sync-topologies).
8. Cloud Sync and Connect Sync may coexist in one forest during a pilot or staged migration, but an object must be in scope for only one engine. Moving an object from a Cloud Sync-scoped OU to a Connect Sync-scoped OU is treated as deletion followed by reprovisioning and can create a new Entra object. [Cloud Sync supported topologies](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/plan-cloud-sync-topologies) [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).
9. Deleting a Cloud Sync configuration does not delete the identities it created. To deprovision them, first change the scope to an empty group or OU, let a cleanup cycle run, and only then disable and remove the configuration. [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).
10. The Cloud Sync agent needs outbound TCP **443**, TCP **80** for certificate-revocation checks, and optionally TCP **8080** for status if 443 is unavailable; for group provisioning to AD DS it must reach domain controllers on TCP **389** and TCP **3268**. Cloud Sync across AD forests separated by NAT is unsupported. [Cloud Sync prerequisites](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites) [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).
11. Connect Sync versions below **2.5.79.0** stop all synchronization services on **September 30, 2026**. The minimum also requires .NET Framework **4.7.2** and TLS **1.2**, so an architecture that retains Connect Sync must include the upgrade before that date. [Connect Sync security hardening and mandatory upgrade](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/security-updates-pks).
12. Connect Sync installs SQL Server 2019 Express LocalDB by default; its **10 GB** database limit supports approximately **100,000 objects**. Larger directories require a supported full SQL Server deployment, while Azure SQL Database and Azure SQL Managed Instance are unsupported. [Microsoft Entra Connect prerequisites](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-install-prerequisites).
13. Connect Sync supports mainstream-supported SQL Server versions through SQL Server 2022, but not SQL Server 2012 or 2016, case-sensitive collations, Named Pipes, or more than one sync engine in the same SQL instance. [Microsoft Entra Connect prerequisites](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-install-prerequisites).

### Incompatibilities and mutual exclusions

If the same AD object is in scope for both Cloud Sync and Connect Sync, the design is unsupported because each engine can independently create, update, or delete the cloud representation; use disjoint scopes and validate object matching before cutover. [Cloud Sync supported topologies](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/plan-cloud-sync-topologies).

### Edge cases and gotchas

- Cloud Sync has no staging-server mode; high availability uses multiple active agents, with one agent active for a given job rather than load balancing across agents. [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).
- Renaming or moving a scoped OU does not delete its previously synchronized users, so an OU reorganization can leave cloud objects in place unless scope and cleanup are handled explicitly. [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).
- In a multitenant Connect topology, one physical device may be synchronized to multiple tenants but can be Microsoft Entra hybrid joined to only one tenant; forest-level hybrid features can overwrite each other's configuration. [Microsoft Entra Connect supported topologies](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/plan-connect-topologies).
- Cloud Sync's disconnected-source object merge is **[Preview]** and requires matching `ms-DS-ConsistencyGuid` values plus nonoverlapping attribute mappings; it should not be treated as a general cross-forest matching capability. [Cloud Sync supported topologies](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/plan-cloud-sync-topologies).

### AZ-305 exam discriminator

Prefer Cloud Sync for a supported new hybrid design because configuration is cloud-managed, agents auto-upgrade, and multiple lightweight agents provide failover; retain Connect Sync only when a documented topology, scale, or feature requirement is unsupported in Cloud Sync, and include the **September 30, 2026** version deadline. [Cloud Sync decision guide](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/connect-to-cloud-sync-decision-guide) [Connect Sync security hardening and mandatory upgrade](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/security-updates-pks).

### Common trap

Do not select a synchronization engine to answer a sign-in-method requirement: synchronization establishes and updates the cloud identity, while password hash synchronization, pass-through authentication, or federation determines how the credential is validated. [Hybrid identity overview](https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity).

---

## Microsoft Entra External ID: B2B collaboration and external tenants

**Classification:** Core  
**Why it matters:** External ID has two materially different tenant patterns: B2B collaboration adds partner representations to a workforce tenant, while customer identity uses a separate tenant in an external configuration. [External ID tenant configurations](https://learn.microsoft.com/en-us/entra/external-id/tenant-configurations)  
**Primary Microsoft source:** [Microsoft Entra External ID overview](https://learn.microsoft.com/en-us/entra/external-id/external-identities-overview)  
**Limits and quotas source:** [External ID pricing and billing model](https://learn.microsoft.com/en-us/entra/external-id/external-identities-pricing) and [Plan an external-tenant CIAM deployment](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-planning-your-solution)

### Deep technical facts / requirements

1. B2B collaboration creates a user object in the resource workforce tenant while the partner normally authenticates with an identity managed by its home organization or another supported identity provider; the B2B user is typically `UserType=Guest` and has `#EXT#` in its generated user principal name. [What is B2B collaboration?](https://learn.microsoft.com/en-us/entra/external-id/what-is-b2b).
2. By default, all users in a workforce tenant—including existing guests and nonadministrators—can invite B2B guests. The default guest directory permission level is limited access to directory-object properties and memberships, but administrators can make it more or less restrictive. [Configure external collaboration settings](https://learn.microsoft.com/en-us/entra/external-id/external-collaboration-settings-configure).
3. Email one-time passcode is enabled by default in new tenants and in existing tenants where it was never explicitly disabled. A passcode is valid for **30 minutes**, and the resulting guest session expires after **24 hours**. [Email one-time passcode authentication](https://learn.microsoft.com/en-us/entra/external-id/one-time-passcode).
4. Disabling email one-time passcode prevents guests who previously redeemed with that method from signing in until their redemption status is reset or another authentication path is established. A guest who later obtains another account type continues using its original one-time-passcode redemption binding until reset. [Email one-time passcode authentication](https://learn.microsoft.com/en-us/entra/external-id/one-time-passcode).
5. A tenant in an external configuration is a separate directory used exclusively for consumer and business-customer applications; it contains the customer-facing app registrations, sign-up/sign-in flows, and customer accounts rather than the organization's workforce resources. [External ID tenant configurations](https://learn.microsoft.com/en-us/entra/external-id/tenant-configurations).
6. Users created in an external tenant have restricted default permissions and cannot enumerate other users, groups, or devices unless an administrator grants a role. Customer accounts and administrators can coexist, but administrative users must be deliberately assigned directory roles. [Default user permissions in external tenants](https://learn.microsoft.com/en-us/entra/external-id/customers/reference-user-permissions).
7. An external tenant supports up to **10 user flows**. One user flow can serve multiple app registrations, but each application can be associated with only **one** user flow. [Plan an external-tenant CIAM deployment](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-planning-your-solution) [Add an application to a user flow](https://learn.microsoft.com/en-us/entra/external-id/customers/how-to-user-flow-add-application).
8. Browser-delegated external-tenant authentication supports federated identity providers, whereas native authentication does not; applications requiring Google, Facebook, Apple, another Entra tenant, or custom OIDC federation must use the browser-delegated approach. [Plan an external-tenant CIAM deployment](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-planning-your-solution).
9. External-tenant custom attributes are stored as directory extensions in the automatically created `b2c-extensions-app`; deleting or modifying that application can break the custom-attribute model. Supported custom attribute data types include String, Boolean, and Integer. [Collect custom attributes during sign-up](https://learn.microsoft.com/en-us/entra/external-id/customers/how-to-define-custom-attributes).
10. External ID uses monthly active user billing: the core offer is free for the first **50,000 MAU**. In workforce tenants MAU applies to external users with `UserType=Guest`, while in external tenants it applies to every user regardless of `UserType`. [External ID pricing and billing model](https://learn.microsoft.com/en-us/entra/external-id/external-identities-pricing).
11. Azure AD B2C has not been available for purchase by new customers since **May 1, 2025**. Existing customers can continue to use it, but B2C P2 was discontinued on **March 15, 2026**, and remaining P2 tenants were scheduled to move to P1 by the end of March 2026. [Azure AD B2C FAQ](https://learn.microsoft.com/en-us/azure/active-directory-b2c/faq).
12. Microsoft commits to support existing Azure AD B2C customers until at least **May 2030**; B2C is pay-as-you-go and its P1/P2 offers are distinct from workforce Entra ID P1/P2 licenses. [Azure AD B2C FAQ](https://learn.microsoft.com/en-us/azure/active-directory-b2c/faq).
13. Workforce-tenant B2B invitation throttles differ by age and licensing: during the first **30 days**, paid tenants can send **200 invitations per day** and unpaid tenants **10 per day**; after 30 days, unpaid tenants can send **100 per day**, while paid tenants are governed by general Entra service quotas. [Microsoft Entra service limits and restrictions](https://learn.microsoft.com/en-us/entra/identity/users/directory-service-limits-restrictions).

### Incompatibilities and mutual exclusions

If a design requires one directory to host employees and also provide the external-tenant CIAM feature set for public customers, an external tenant cannot satisfy both because it is exclusively configured for External ID customer scenarios; use a workforce tenant for employees and a separate external tenant for customers. [External ID tenant configurations](https://learn.microsoft.com/en-us/entra/external-id/tenant-configurations).

### Edge cases and gotchas

- An invitation object can remain `PendingAcceptance` until the guest completes redemption and accepts the resource tenant's consent terms; sending an invitation does not itself prove that the guest can use the resource. [B2B invitation redemption](https://learn.microsoft.com/en-us/entra/external-id/redemption-experience).
- If an external-tenant administrator creates a customer account with the same email address as the admin identity, tenant-qualified sign-in can select the lower-privileged customer account and block administration. [Known issues in external tenants](https://learn.microsoft.com/en-us/entra/external-id/customers/troubleshooting-known-issues).
- In a hand-created external-tenant web API registration, `accessTokenAcceptedVersion` must be set to **2** or token validation can fail against the external-tenant signing-key endpoint. [Known issues in external tenants](https://learn.microsoft.com/en-us/entra/external-id/customers/troubleshooting-known-issues).
- Username or alias sign-up in an external tenant is **[Preview]**; the alias must be unique across the tenant and should not be treated as a generally available exam default. [Sign up with an alias](https://learn.microsoft.com/en-us/entra/external-id/customers/how-to-sign-in-alias).

### AZ-305 exam discriminator

Choose workforce-tenant B2B when identifiable partners should keep their home credentials and access organizational resources; choose a separate external tenant when consumer or business-customer applications need self-service registration, branded journeys, customer profiles, and MAU billing. [External ID tenant configurations](https://learn.microsoft.com/en-us/entra/external-id/tenant-configurations) [External tenant overview](https://learn.microsoft.com/en-us/entra/external-id/customers/overview-customers-ciam).

### Common trap

Do not propose a new Azure AD B2C purchase for a greenfield CIAM scenario: new sales ended on **May 1, 2025**, while Microsoft Entra External ID external tenants are the current customer-identity model. [Azure AD B2C FAQ](https://learn.microsoft.com/en-us/azure/active-directory-b2c/faq) [External ID tenant configurations](https://learn.microsoft.com/en-us/entra/external-id/tenant-configurations).

---

## Multitenant organizations and cross-tenant synchronization

**Classification:** Core  
**Why it matters:** When one workforce tenant cannot satisfy legal, sovereignty, acquisition, or administrative-isolation requirements, a multitenant organization defines the owned-tenant boundary and cross-tenant synchronization manages identity representations between those tenants. [Multitenant user management](https://learn.microsoft.com/en-us/entra/architecture/multi-tenant-user-management-introduction)  
**Primary Microsoft source:** [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview)  
**Limits and quotas source:** [Multitenant organization overview and limits](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/multi-tenant-organization-overview)

### Deep technical facts / requirements

1. A multitenant organization can contain at most **100 active tenants**, including the owner tenant. A tenant can create or join only **one** multitenant organization, and the organization must always retain at least one active owner tenant. [Multitenant organization overview and limits](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/multi-tenant-organization-overview).
2. Cross-tenant synchronization is a source-initiated push built on the Entra provisioning engine. Configuration, scope, and attribute mappings reside in the source tenant, while the target tenant enables inbound synchronization through cross-tenant access settings. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview).
3. The service synchronizes internal member users from a source tenant; it does not synchronize source-tenant guests, contacts, or devices. Users can be created in the target as external members—the default—or external guests. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview).
4. A cross-tenant synchronization job starts at a fixed **40-minute** interval, although the duration varies with the number of in-scope users and the initial cycle takes longer than incremental cycles. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview).
5. Same-cloud user synchronization requires Entra ID P1 for every synchronized user in the source tenant. Same-cloud group synchronization requires Entra ID Governance or Entra Suite in the source, and cross-cloud synchronization requires Governance or Suite for each synchronized source user. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview).
6. The target tenant does not require a cross-tenant synchronization license, but external-user activity can incur External ID MAU billing. Enabling automatic redemption in the target requires at least one Entra ID P1 license there. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview) [Microsoft Entra licensing](https://learn.microsoft.com/en-us/entra/fundamentals/licensing).
7. Automatic redemption suppresses the invitation email and first-use consent prompt only when the source tenant enables it outbound and the target tenant enables it inbound; configuring only one side does not suppress consent. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview).
8. Synchronization is a directional peer-to-peer configuration. Only one sync instance can exist for a given source-target pair, although a tenant can participate in multiple directional pairs to form hub-and-spoke or mesh topologies. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview).
9. Cross-tenant synchronization is not a tenant-migration tool: synchronized users continue to authenticate in the source tenant, and the service does not migrate SharePoint, OneDrive, or other user data. Microsoft positions it for lifecycle management among tenants within one organization. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview).
10. Removing a synchronized user from scope, deleting it in the source, or making it fail a scoping filter soft-deletes the target representation. If the source user returns to scope within **30 days**, it can be restored; otherwise the target object is hard-deleted after the soft-delete window. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview).
11. Group synchronization can create a static security group in the target from a static or dynamic security group or Microsoft 365 group in the source, but it does not create target Microsoft 365 groups, mail-enabled security groups, distribution groups, nested groups, or role-assignable groups. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview).
12. The target tenant can stop synchronization at any time. Target-side edits are not queried by the source job and can persist until a later source-side change causes that attribute to be written again; target blocking of a synchronized user can therefore be reversed by a later source update. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview).

### Incompatibilities and mutual exclusions

If the objective is to move a user's authentication authority and data permanently from tenant A to tenant B, cross-tenant synchronization cannot be used as the migration mechanism because the source tenant remains required for authentication and user data is not moved. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview).

### Edge cases and gotchas

- Cross-tenant synchronization is unsupported in external tenants; it is a workforce-tenant capability. [On-demand provisioning limitations](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/provision-on-demand).
- The multitenant organization model is unsupported across sovereign clouds, and self-service management for organizations larger than **100 tenants** is unsupported. Tenants in a multitenant organization must be in the same cloud. [Multitenant organization limitations](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/multi-tenant-organization-known-issues).
- New cross-tenant synchronized users default to B2B members, but existing B2B guests remain guests unless attribute mapping explicitly converts them. [Multitenant organization limitations](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/multi-tenant-organization-known-issues).
- At-scale B2B provisioning can collide with contact objects, and the provisioning service does not currently convert or reconcile those contacts. [Multitenant organization limitations](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/multi-tenant-organization-known-issues).

### AZ-305 exam discriminator

Use a multitenant organization plus directional cross-tenant synchronization when several workforce tenants are intentionally retained inside one enterprise and selected employees need automatically maintained B2B representations; use ordinary B2B or entitlement management for collaboration between independent organizations. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview).

### Common trap

Do not assume that a multitenant organization merges tenants or creates one shared directory: each tenant keeps separate objects, policies, roles, and resources, and cross-tenant synchronization creates managed external representations rather than moving authority. [Resource isolation with multiple tenants](https://learn.microsoft.com/en-us/entra/architecture/secure-multiple-tenants) [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview).

---

## Application, HR-driven, and API-driven provisioning

**Classification:** Core  
**Why it matters:** Provisioning is the lifecycle plane that creates, updates, disables, and deletes accounts. It is distinct from SSO: an application can authenticate users centrally while still retaining unmanaged, stale local accounts. [Microsoft Entra provisioning overview](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/user-provisioning)  
**Primary Microsoft source:** [How Microsoft Entra application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works)  
**Limits and quotas source:** [Application provisioning quarantine thresholds](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/application-provisioning-quarantine-status) and [Inbound provisioning API limits](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/inbound-provisioning-api-issues)

### Deep technical facts / requirements

1. The Entra provisioning service normally connects to an application's SCIM **2.0** user-management endpoint and uses HTTPS with TLS **1.2** to create, update, disable, and remove users; selected connectors also provision groups and related objects. [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).
2. An initial cycle queries the full scoped source, matches or creates target objects, stores target identifiers, processes reference attributes, and writes a watermark. Incremental cycles then query changes since the watermark; changing mappings or scoping filters clears the watermark and triggers a new initial evaluation. [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).
3. For a custom SCIM application, incremental provisioning cycles run approximately every **40 minutes** while the service is active; the initial cycle is longer because it evaluates the full source scope. [Develop a SCIM provisioning endpoint](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/use-scim-to-provision-users-and-groups).
4. Assignment-based application provisioning can scope to directly assigned users and groups, but group-based assignment requires Entra ID P1/P2 and the assigned group must be security-enabled. The group object is provisioned only if the target connector supports groups. [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).
5. On-demand provisioning usually completes in under **30 seconds** but accepts only one user at a time in the admin center, or one group with at most **5 members** through its request API. It does not process nested groups that are not directly assigned. [On-demand provisioning](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/provision-on-demand).
6. The provisioning service does not provision null attributes. Matching attributes must be populated and uniquely identify one target object; a missing, nonunique, or unsupported target filter can cause a match failure or duplicate account. [On-demand provisioning](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/provision-on-demand).
7. By default, a user who leaves scope is disabled or soft-deleted in the target. Entra soft-deleted users become hard-deleted after **30 days**, at which point the service can send a permanent DELETE to the target; an administrator can hard-delete earlier. [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).
8. Accidental-deletion prevention compares proposed disables/deletes with an administrator-set threshold on every cycle. Exceeding the threshold quarantines the job and requires an administrator to allow or reject the changes; the threshold is not cumulative across cycles. [Prevent accidental deletions](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/accidental-deletions).
9. General provisioning quarantine evaluation begins at **5,000 failures**. A job can be quarantined when more than **40%** of events fail, when nonreference failures exceed **40,000**, or when total reference plus nonreference failures exceed **60,000**. [Application provisioning quarantine thresholds](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/application-provisioning-quarantine-status).
10. In quarantine, incremental frequency is reduced gradually to once per day. Retries normally occur after **6 hours**, **12 hours**, and **24 hours**, then every **24 hours** for up to **28 days**; a job that remains quarantined for more than four weeks is disabled. [Application provisioning quarantine thresholds](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/application-provisioning-quarantine-status).
11. HR-driven provisioning makes the HR system the source of authority and supports create, update, termination, and rehire flows to Entra ID or AD DS. Workday and SuccessFactors have prebuilt integrations; arbitrary systems can feed API-driven inbound provisioning. [HR-driven provisioning](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/what-is-hr-driven-provisioning).
12. API-driven `/bulkUpload` uses SCIM-schema payloads with content type `application/scim+json`, but it is not a standard synchronous SCIM endpoint: the Entra provisioning service processes records asynchronously and applies administrator-defined scope, mapping, transformation, and operation semantics. [Inbound provisioning API FAQ](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/inbound-provisioning-api-faqs).
13. The inbound provisioning API allows **40 calls per 5 seconds** and **6,000 calls per 24 hours**, with up to **50 records per call**; optimized payloads therefore support up to **300,000 records per 24 hours** before the call quota. Exceeding either limit returns HTTP 429. [Troubleshoot inbound provisioning API issues](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/inbound-provisioning-api-issues).
14. An inbound API client requires the Microsoft Graph application permission `SynchronizationData-User.Upload`. Configuring cloud-only inbound provisioning requires Application Administrator, while provisioning into on-premises AD also requires Hybrid Identity Administrator and an on-premises provisioning agent. [Configure API-driven inbound provisioning](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/inbound-provisioning-api-configure-app) [Troubleshoot inbound provisioning API issues](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/inbound-provisioning-api-issues).

### Incompatibilities and mutual exclusions

If an application supports SAML or OIDC SSO but exposes no SCIM endpoint, gallery provisioning connector, or other supported provisioning interface, SSO alone cannot create, update, or remove its local accounts; a separate lifecycle integration is required. [Microsoft Entra provisioning overview](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/user-provisioning).

### Edge cases and gotchas

- An OAuth-authorized connector may require the provisioning job to be stopped before on-demand provisioning, whereas long-lived bearer-token and username/password connectors generally do not. [On-demand provisioning](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/provision-on-demand).
- On-demand provisioning cannot restore a previously soft-deleted target user and can create a duplicate if it is used as a restore mechanism. [On-demand provisioning](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/provision-on-demand).
- Restarting a provisioning job causes a full initial cycle and clears watermarks; administrators should not use restart casually as a way to accelerate a normal incremental change. [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).
- The inbound API does not currently process multivalued `addresses`, `emails`, or `phoneNumbers` entries whose `type` is `home` or another non-`work` value. [Troubleshoot inbound provisioning API issues](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/inbound-provisioning-api-issues).

### AZ-305 exam discriminator

Choose HR-driven or API-driven inbound provisioning when an HR or custom system of record must authoritatively create workforce identities; choose outbound application provisioning when Entra ID must create and deprovision downstream app accounts. The direction of authority—not the presence of SSO—selects the flow. [HR-driven provisioning](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/what-is-hr-driven-provisioning) [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).

### Common trap

Do not equate successful authentication with lifecycle management: SSO can authenticate a departed user's lingering target account, while provisioning is the mechanism that disables or deletes that account when source scope changes. [Microsoft Entra provisioning overview](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/user-provisioning) [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).

---

## Microsoft Entra Domain Services and self-managed AD DS

**Classification:** Core  
**Why it matters:** Entra ID is not an LDAP/Kerberos/NTLM domain. Domain Services supplies managed traditional directory protocols for legacy workloads, while self-managed AD DS remains necessary when the application requires full domain administration, schema control, or unsupported topology features. [Compare Microsoft directory-based services](https://learn.microsoft.com/en-us/entra/identity/domain-services/compare-identity-solutions)  
**Primary Microsoft source:** [Microsoft Entra Domain Services overview](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview)  
**Limits and quotas source:** [Domain Services replica sets](https://learn.microsoft.com/en-us/entra/identity/domain-services/concepts-replica-sets) and [Domain Services FAQs](https://learn.microsoft.com/en-us/entra/identity/domain-services/faqs)

### Deep technical facts / requirements

1. A Domain Services managed domain provides domain join, Group Policy, DNS, LDAP, Kerberos, and NTLM without customers deploying or patching domain-controller VMs. It is a compatibility directory, not a replacement for Entra ID's modern application and token services. [Microsoft Entra Domain Services overview](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview) [Compare Microsoft directory-based services](https://learn.microsoft.com/en-us/entra/identity/domain-services/compare-identity-solutions).
2. The first replica set deploys **2 managed domain controllers** in one Azure region. Enterprise and Premium SKUs can add regional replica sets, up to **5 replica sets total**, and every replica set is billed independently at the managed domain's SKU. [Domain Services replica sets](https://learn.microsoft.com/en-us/entra/identity/domain-services/concepts-replica-sets).
3. Additional replica sets share one namespace and directory data; they do not create separate managed domains. Their virtual networks must be mutually peered in a mesh, and all replicas belong to one AD site, so customers cannot define separate AD sites or custom intersite replication schedules. [Domain Services replica sets](https://learn.microsoft.com/en-us/entra/identity/domain-services/concepts-replica-sets).
4. Entra ID synchronizes users, group memberships, and credential hashes one way into Domain Services. Changes made to synchronized identities in the managed domain do not flow back to Entra ID, and synchronized users, passwords, and group memberships are largely read-only inside the managed domain. [How Domain Services synchronization works](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization).
5. A cloud-only user created before Domain Services is enabled cannot use Kerberos or NTLM until the user changes its Entra password, which generates the required legacy credential hashes. In a hybrid tenant, the appropriate NTLM and Kerberos hashes must also be synchronized from AD DS. [How Domain Services synchronization works](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization).
6. Customers do not receive Domain Admin or Enterprise Admin privileges in the managed domain. Members of those groups in the source AD DS forest also do not inherit equivalent rights in Domain Services. [Domain Services FAQs](https://learn.microsoft.com/en-us/entra/identity/domain-services/faqs).
7. Domain Services does not support schema extensions. An application that installs custom schema classes or attributes requires self-managed AD DS or an application redesign. [Domain Services deployment scenarios](https://learn.microsoft.com/en-us/entra/identity/domain-services/scenarios).
8. LDAP traffic is unencrypted by default. Secure LDAP uses TCP **636** and requires a `.PFX` certificate with its private key, a wildcard subject/SAN for the managed domain, digital-signature and key-encipherment usage, and TLS server-authentication purpose. [Configure secure LDAP](https://learn.microsoft.com/en-us/entra/identity/domain-services/tutorial-configure-ldaps).
9. Publishing secure LDAP to the internet exposes TCP **636** and should be restricted by an NSG to explicit source IP ranges. A public CA cannot issue a certificate for the Microsoft-owned `.onmicrosoft.com` suffix, so public-certificate LDAPS requires a custom DNS name. [Configure secure LDAP](https://learn.microsoft.com/en-us/entra/identity/domain-services/tutorial-configure-ldaps).
10. Forest trusts require at least the Enterprise SKU, DNS resolution between forests, stable VPN or ExpressRoute connectivity to the on-premises domain, and a dedicated Domain Services subnet. Domain Services supports forest trusts but not an external trust to an on-premises child domain. [Create a Domain Services forest trust](https://learn.microsoft.com/en-us/entra/identity/domain-services/tutorial-create-forest-trust).
11. One-way outgoing, one-way incoming, and two-way forest-trust directions have different access implications. A one-way outgoing trust lets on-premises users access resources in the managed domain, while a one-way incoming trust lets managed-domain users access on-premises resources. [Create a Domain Services forest trust](https://learn.microsoft.com/en-us/entra/identity/domain-services/tutorial-create-forest-trust).
12. Automated managed-domain backups are expected every **1–14 days** and retained for up to **30 days**. If a managed domain remains suspended for **15 days**, it enters an unrecoverable deleted state along with its backups. [Check Domain Services health](https://learn.microsoft.com/en-us/entra/identity/domain-services/check-health) [Suspended Domain Services domains](https://learn.microsoft.com/en-us/entra/identity/domain-services/suspension).
13. Domain Services places no service quota on the number of machines joined to the managed domain, but every client still requires network reachability and DNS resolution to the managed domain. [Domain Services FAQs](https://learn.microsoft.com/en-us/entra/identity/domain-services/faqs) [Microsoft Entra Domain Services overview](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview).

### Incompatibilities and mutual exclusions

If an application requires LDAP/Kerberos/NTLM and also requires Domain Admin rights or an AD schema extension, Domain Services cannot satisfy both requirements; deploy and operate self-managed AD DS on Azure VMs or retain an appropriate on-premises domain. [Domain Services FAQs](https://learn.microsoft.com/en-us/entra/identity/domain-services/faqs) [Domain Services deployment scenarios](https://learn.microsoft.com/en-us/entra/identity/domain-services/scenarios).

### Edge cases and gotchas

- Objects created in custom OUs inside Domain Services remain local to the managed domain and are not visible through the Entra admin center or Microsoft Graph. [How Domain Services synchronization works](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization).
- Standard SKU cannot host additional replica sets; a design needing regional replica sets must use Enterprise or Premium and pay for each replica. [Domain Services replica sets](https://learn.microsoft.com/en-us/entra/identity/domain-services/concepts-replica-sets).
- Peered virtual networks are not transitive, so every application network and every network containing a replica set must have the required direct peering and routing rather than assuming connectivity will pass through another peering. [Create a Domain Services forest trust](https://learn.microsoft.com/en-us/entra/identity/domain-services/tutorial-create-forest-trust).
- An expired LDAPS certificate interrupts secure LDAP, and the private key must be exported with the supported PFX protection settings before the certificate can be applied to the managed domain. [Configure secure LDAP](https://learn.microsoft.com/en-us/entra/identity/domain-services/tutorial-configure-ldaps).

### AZ-305 exam discriminator

Choose Entra ID for modern cloud identity; add Domain Services when a workload specifically requires managed domain join, Group Policy, LDAP, Kerberos, or NTLM but does not require full domain control; choose self-managed AD DS when schema, Domain Admin, unsupported trust, or complete domain-controller control is a hard requirement. [Compare Microsoft directory-based services](https://learn.microsoft.com/en-us/entra/identity/domain-services/compare-identity-solutions) [Domain Services deployment scenarios](https://learn.microsoft.com/en-us/entra/identity/domain-services/scenarios).

### Common trap

Do not treat Domain Services as a writable replica of Entra ID or on-premises AD DS: synchronization into the managed domain is one-way, customers lack Domain Admin, and locally created managed-domain objects do not write back to Entra ID. [How Domain Services synchronization works](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization) [Domain Services FAQs](https://learn.microsoft.com/en-us/entra/identity/domain-services/faqs).

---

## Microsoft Entra device identities

**Classification:** Supporting  
**Why it matters:** Device registration and join create directory objects with different ownership, sign-in, management, and hybrid dependencies. The device identity can later be consumed by authentication and access controls, but its creation model belongs to identity management. [Microsoft Entra device identity](https://learn.microsoft.com/en-us/entra/identity/devices/overview)  
**Primary Microsoft source:** [Microsoft Entra device identity documentation](https://learn.microsoft.com/en-us/entra/identity/devices/)  
**Limits and quotas source:** [Microsoft Entra service limits and restrictions](https://learn.microsoft.com/en-us/entra/identity/users/directory-service-limits-restrictions)

### Deep technical facts / requirements

1. A Microsoft Entra registered device is registered without changing the local sign-in account and is intended primarily for BYOD and mobile scenarios. Supported platforms include Windows 10 or later, macOS **10.15 or later**, iOS **15 or later**, Android, Ubuntu **22.04/24.04 LTS**, and RHEL **8/9 LTS**. [Microsoft Entra registered devices](https://learn.microsoft.com/en-us/entra/identity/devices/concept-device-registration).
2. A Microsoft Entra joined device uses an organizational Entra account for device sign-in and is organization-owned. Windows join supports Windows 10/11 except Home editions; Entra join does not require an on-premises domain even in a hybrid organization. [Microsoft Entra joined devices](https://learn.microsoft.com/en-us/entra/identity/devices/concept-directory-join).
3. Microsoft Entra joined devices can obtain SSO to on-premises file, print, and application resources when network and identity prerequisites are present, so an on-premises resource requirement does not by itself force hybrid join. [Microsoft Entra joined devices](https://learn.microsoft.com/en-us/entra/identity/devices/concept-directory-join).
4. Hybrid join requires an AD DS computer object plus an Entra device representation. With Connect Sync, the relevant computer OUs and default device attributes must remain in synchronization scope. [Configure Microsoft Entra hybrid join](https://learn.microsoft.com/en-us/entra/identity/devices/how-to-hybrid-join).
5. Hybrid-join registration must reach `enterpriseregistration.windows.net`, `login.microsoftonline.com`, and `device.login.microsoftonline.com`; TLS break-and-inspect on registration endpoints can interfere with client-certificate authentication and device registration. [Manual hybrid-join configuration](https://learn.microsoft.com/en-us/entra/identity/devices/hybrid-join-manual).
6. A physical device can be synchronized to more than one Entra tenant but can be hybrid joined to only one tenant. A design that tries to establish multiple tenant hybrid joins for the same computer is unsupported. [Microsoft Entra Connect supported topologies](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/plan-connect-topologies).
7. A stale-device policy should not treat an activity timestamp younger than **21 days** as conclusive because timestamp update variance can create false positives. Microsoft recommends disabling a suspected stale device for a grace period before deletion. [Manage stale devices](https://learn.microsoft.com/en-us/entra/identity/devices/manage-stale-devices).
8. Device soft deletion is **[Preview]**: deleted device objects remain recoverable for up to **30 days**, cannot authenticate while deleted, retain their `DeviceId`, and continue to consume one-quarter of an active object's directory quota. Portal restore is unavailable during preview; restore uses Microsoft Graph or PowerShell. [Device soft delete overview](https://learn.microsoft.com/en-us/entra/identity/devices/concept-soft-delete-devices).

### Incompatibilities and mutual exclusions

If a device must use an Entra organizational account for OS sign-in, Entra registration alone cannot satisfy the requirement because registration preserves the existing local or personal sign-in; use Entra join or hybrid join. [Microsoft Entra registered devices](https://learn.microsoft.com/en-us/entra/identity/devices/concept-device-registration) [Microsoft Entra joined devices](https://learn.microsoft.com/en-us/entra/identity/devices/concept-directory-join).

### Edge cases and gotchas

- Apple Automated Device Enrollment for Entra join and Microsoft Entra Kerberos-based hybrid join are **[Preview]** and should not be assumed to be general-availability exam defaults. [Microsoft Entra joined devices](https://learn.microsoft.com/en-us/entra/identity/devices/concept-directory-join) [Hybrid join using Entra Kerberos](https://learn.microsoft.com/en-us/entra/identity/devices/how-to-hybrid-join-using-microsoft-entra-kerberos).
- Deleting or disabling a hybrid-joined Windows device should begin in on-premises AD DS and flow through synchronization, while an MDM-managed device should first be retired in the management platform. [Manage stale devices](https://learn.microsoft.com/en-us/entra/identity/devices/manage-stale-devices).
- Soft-deleted devices are hidden from ordinary portal and Graph device lists and return HTTP 404 there even though the reserved `DeviceId` prevents a duplicate registration. [Device soft delete overview](https://learn.microsoft.com/en-us/entra/identity/devices/concept-soft-delete-devices).

### AZ-305 exam discriminator

Use registered for BYOD with an unchanged local sign-in, joined for cloud-managed organization-owned devices, and hybrid joined only when the computer must remain AD DS domain-joined while also having an Entra identity. [Microsoft Entra registered devices](https://learn.microsoft.com/en-us/entra/identity/devices/concept-device-registration) [Microsoft Entra joined devices](https://learn.microsoft.com/en-us/entra/identity/devices/concept-directory-join) [Configure Microsoft Entra hybrid join](https://learn.microsoft.com/en-us/entra/identity/devices/how-to-hybrid-join).

### Common trap

Do not choose hybrid join merely because users access on-premises resources: Entra-joined devices can obtain SSO to on-premises resources, and hybrid join adds AD DS computer-object and synchronization dependencies. [Microsoft Entra joined devices](https://learn.microsoft.com/en-us/entra/identity/devices/concept-directory-join).

---

## Microsoft Entra Backup and Recovery and identity monitoring

**Classification:** Supporting  
**Why it matters:** Identity architecture must distinguish object lifecycle from recoverability and retain enough audit, sign-in, and provisioning evidence to diagnose authoritative-flow failures. [Microsoft Entra Backup and Recovery](https://learn.microsoft.com/en-us/entra/backup/overview) [Microsoft Entra monitoring and health](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/overview-monitoring-health)  
**Primary Microsoft source:** [Microsoft Entra Backup and Recovery overview](https://learn.microsoft.com/en-us/entra/backup/overview)  
**Limits and quotas source:** [Microsoft Entra data retention](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/reference-reports-data-retention)

### Deep technical facts / requirements

1. Microsoft Entra Backup and Recovery automatically backs up supported objects once per day and retains up to **7 days** of backup history. Administrators cannot disable, delete, or modify these Microsoft-managed backups. [Microsoft Entra Backup and Recovery overview](https://learn.microsoft.com/en-us/entra/backup/overview).
2. The service requires a workforce tenant with Entra ID P1 or P2. External ID and Azure AD B2C tenants are unsupported. Backup Reader can view backups and comparisons, while Backup Administrator can create difference reports and start recovery. [Microsoft Entra Backup and Recovery overview](https://learn.microsoft.com/en-us/entra/backup/overview).
3. Supported objects include users, groups, applications, service principals, Conditional Access policies, named locations, authentication methods policy, and selected authorization-policy properties; property and relationship coverage is not complete. [Microsoft Entra Backup and Recovery overview](https://learn.microsoft.com/en-us/entra/backup/overview) [Backup and Recovery troubleshooting](https://learn.microsoft.com/en-us/entra/backup/troubleshooting).
4. Hard-deleted objects cannot be recovered. Soft-deleted users, Microsoft 365 groups, cloud security groups, application registrations, and service principals remain recoverable through their recycle-bin behavior for **30 days**, which complements but is distinct from the **7-day** backup history. [Microsoft Entra Backup and Recovery overview](https://learn.microsoft.com/en-us/entra/backup/overview).
5. Users and groups whose authority remains on-premises AD DS cannot be restored through Entra Backup and Recovery; they must be recovered in AD DS. Difference reports can expose their cloud-side changes, and converted cloud-authoritative groups can become recoverable. [Microsoft Entra Backup and Recovery overview](https://learn.microsoft.com/en-us/entra/backup/overview).
6. Only one difference-report or recovery job can run at a time, and completed recovery-job details are retained for **7 days**. Static group-membership links are recoverable, but group-owner, manager, and sponsor links are not currently supported. [Backup and Recovery troubleshooting](https://learn.microsoft.com/en-us/entra/backup/troubleshooting).
7. Provisioning logs are retained in the admin center for **7 days** with Entra Free and **30 days** with a premium edition. Routing them to Azure Monitor is required for retention beyond those built-in windows. [Analyze provisioning logs](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-analyze-provisioning-logs).
8. External ID Basic retains logs for **7 days**. Risky sign-in retention is **7 days** for Free, **30 days** for P1, and **90 days** for P2; upgrading does not retroactively recover data older than the prior tier's retained window. [Microsoft Entra data retention](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/reference-reports-data-retention).
9. Entra diagnostic settings can route audit, sign-in, provisioning, and risk logs to Azure Monitor, a storage account, or an event hub for longer retention, query, and SIEM integration. Average storage estimates are about **2 KB** per audit event and **11.5 KB** per sign-in event. [Entra activity-log integration options](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-log-monitoring-integration-options-considerations).

### Incompatibilities and mutual exclusions

If a recovery requirement covers hard-deleted objects, external/B2C tenants, or AD DS-authoritative synchronized users and groups, Entra Backup and Recovery cannot satisfy it; maintain source-system backup and configuration recovery for those objects. [Backup and Recovery troubleshooting](https://learn.microsoft.com/en-us/entra/backup/troubleshooting).

### Edge cases and gotchas

- During onboarding or transient backend conditions, the backup list can temporarily show fewer than **7 visible days** or duplicate timestamps even though automatic backups continue. [Backup and Recovery troubleshooting](https://learn.microsoft.com/en-us/entra/backup/troubleshooting).
- Backup and Recovery restores only supported properties and links; a successful job can still finish with warnings and require manual reconstruction of unsupported relationships. [Backup and Recovery troubleshooting](https://learn.microsoft.com/en-us/entra/backup/troubleshooting).
- Entra audit and sign-in logs are separate from the Microsoft 365 Unified Audit Log, so a Microsoft 365 retention design does not automatically define Entra-native retention. [Microsoft Entra data retention](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/reference-reports-data-retention).

### AZ-305 exam discriminator

Use Entra Backup and Recovery for supported cloud-authoritative workforce objects within a **7-day** point-in-time window; use soft-delete restore for supported deleted objects within **30 days**, and recover synchronized objects at their AD DS source of authority. [Microsoft Entra Backup and Recovery overview](https://learn.microsoft.com/en-us/entra/backup/overview).

### Common trap

Do not assume that the existence of daily Entra backups makes every directory object recoverable: external/B2C tenants, hard-deleted objects, AD DS-authoritative users and groups, and several relationship types are excluded. [Backup and Recovery troubleshooting](https://learn.microsoft.com/en-us/entra/backup/troubleshooting).

---

## Tenant-boundary and source-of-authority architecture

**Classification:** Architecture guidance  
**Why it matters:** The durable design decision is not merely a product name; it is the combination of population, authority, representation, lifecycle direction, tenant boundary, and protocol requirements. [Azure identity architecture guidance](https://learn.microsoft.com/en-us/azure/architecture/identity/identity-start-here)  
**Primary Microsoft source:** [Multitenant user management](https://learn.microsoft.com/en-us/entra/architecture/multi-tenant-user-management-introduction)

### Deep technical facts / requirements

1. Microsoft recommends a single Entra tenant when the organization's requirements can be met within one boundary because multiple tenants duplicate directory objects, policy, roles, monitoring, collaboration, and lifecycle operations. [Resource isolation with multiple tenants](https://learn.microsoft.com/en-us/entra/architecture/secure-multiple-tenants).
2. A separate tenant creates an isolation boundary for directory roles, directory objects, Conditional Access policies, Azure management structures, and other tenant-scoped controls; administrative units and ordinary role delegation do not create the same hard boundary. [Resource isolation with multiple tenants](https://learn.microsoft.com/en-us/entra/architecture/secure-multiple-tenants).
3. Microsoft documents isolation, regulatory or sovereignty requirements, merger/acquisition transition, and testing of tenant-wide changes as potential multi-tenant drivers, but warns that the resulting management overhead and complexity must be justified. [Resource isolation with multiple tenants](https://learn.microsoft.com/en-us/entra/architecture/secure-multiple-tenants).
4. Identity source and identity representation are different: HR-driven provisioning can make HR authoritative, AD DS-to-Entra synchronization can preserve AD DS authority, and B2B can create a resource-tenant representation while the partner's home directory remains authoritative. [HR-driven provisioning](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/what-is-hr-driven-provisioning) [Hybrid identity overview](https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity) [What is B2B collaboration?](https://learn.microsoft.com/en-us/entra/external-id/what-is-b2b).
5. Authentication and authorization are downstream decisions: synchronization or provisioning determines what object exists and where its attributes flow, authentication proves control of that identity, and authorization determines resource access. [Microsoft identity fundamentals](https://learn.microsoft.com/en-us/entra/fundamentals/identity-fundamental-concepts).
6. Multiple lifecycle engines can be valid in one architecture only when each has an explicit direction and authority—for example HR to AD DS, AD DS to Entra ID, Entra ID to SaaS, and source workforce tenant to target workforce tenant. Overlapping write authority creates loops, duplicates, or overwritten attributes. [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works) [Cloud Sync supported topologies](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/plan-cloud-sync-topologies) [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview).

### Incompatibilities and mutual exclusions

If a requirement can be met with delegation, administrative units, B2B, or scoped provisioning inside one workforce tenant, creating another tenant is not equivalent: it introduces a separate object, policy, and operational boundary that must be managed independently. [Resource isolation with multiple tenants](https://learn.microsoft.com/en-us/entra/architecture/secure-multiple-tenants).

### Edge cases and gotchas

- A dedicated test tenant can isolate tenant-wide identity changes, but test results still need validation against production licensing, domain ownership, synchronization topology, and external dependencies. [Resource isolation with multiple tenants](https://learn.microsoft.com/en-us/entra/architecture/secure-multiple-tenants).
- A user who appears in several tenants is represented by separate objects; changing one representation does not imply that the source object or other tenant copies change unless an explicit lifecycle flow owns that attribute. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview).
- A single authoritative source reduces conflicting updates, but target applications can still retain local-only attributes; the design must document which attributes are mastered at each stage. [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).

### AZ-305 exam discriminator

Start every identity-management scenario by identifying the population, authoritative system, target representations, lifecycle direction, isolation boundary, and protocol requirement; those clues separate cloud-only Entra ID, hybrid synchronization, B2B, external tenants, cross-tenant sync, provisioning, Domain Services, and self-managed AD DS. [Azure identity architecture guidance](https://learn.microsoft.com/en-us/azure/architecture/identity/identity-start-here).

### Common trap

Do not answer an identity-lifecycle question with Conditional Access, MFA, Azure RBAC, PIM, or Key Vault: those secure or authorize identities after the architecture has decided which objects exist, where they are authoritative, and how they are represented. [Microsoft identity fundamentals](https://learn.microsoft.com/en-us/entra/fundamentals/identity-fundamental-concepts).

---

## Highest-yield exam discriminators

| Scenario clue | Best answer | Why |
|---|---|---|
| New cloud-first workforce with no AD DS or HR authority | Microsoft Entra ID cloud users and groups | A workforce tenant natively holds employees, groups, domains, devices, applications, and licenses without a synchronization dependency. [Microsoft Entra enterprise user management](https://learn.microsoft.com/en-us/entra/identity/users/) |
| Existing AD DS identities must keep one account for on-premises and cloud resources | Hybrid identity synchronization | Hybrid identity creates a common cloud representation while AD DS remains authoritative; MFA or federation alone does not create and maintain the object. [Hybrid identity overview](https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity) |
| Supported greenfield hybrid topology with lightweight, highly available agents | Microsoft Entra Cloud Sync | Configuration is cloud-managed, synchronization runs about every **10–20 minutes**, password hashes every **2–5 minutes**, and Microsoft recommends **3 active agents** for high availability. [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq) [Cloud Sync prerequisites](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites) |
| Existing Connect Sync design must run after September 2026 | Upgrade Connect Sync or migrate to Cloud Sync | Connect Sync below version **2.5.79.0** stops synchronizing on **September 30, 2026**. [Connect Sync security hardening and mandatory upgrade](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/security-updates-pks) |
| Partner users should keep credentials administered by their own employers | External ID B2B collaboration in the resource workforce tenant | B2B creates a resource-tenant representation while authentication normally remains with the partner's home identity provider. [What is B2B collaboration?](https://learn.microsoft.com/en-us/entra/external-id/what-is-b2b) |
| Public consumer app needs self-service registration, branding, and customer profiles | Microsoft Entra External ID external tenant | An external tenant is a separate CIAM directory for customer-facing apps and supports up to **10 user flows**. [External tenant overview](https://learn.microsoft.com/en-us/entra/external-id/customers/overview-customers-ciam) [Plan an external-tenant CIAM deployment](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-planning-your-solution) |
| Greenfield question offers Azure AD B2C as the new CIAM purchase | Reject Azure AD B2C; use External ID | Azure AD B2C stopped new-customer sales on **May 1, 2025** and existing-customer support is committed only until at least **May 2030**. [Azure AD B2C FAQ](https://learn.microsoft.com/en-us/azure/active-directory-b2c/faq) |
| Several retained workforce tenants inside one enterprise need automatic employee representations | Multitenant organization plus cross-tenant synchronization | The service pushes internal members directionally, runs at fixed **40-minute** intervals, and supports up to **100 active tenants** in one multitenant organization. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview) [Multitenant organization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/multi-tenant-organization-overview) |
| Organization wants to permanently migrate authentication authority and OneDrive data to another tenant | Tenant migration tooling and project, not cross-tenant synchronization | Cross-tenant synchronization leaves authentication in the source tenant and does not move SharePoint, OneDrive, or other user data. [Cross-tenant synchronization overview](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-overview) |
| HR must drive employee creation, transfer, termination, and rehire | HR-driven or API-driven inbound provisioning | HR-driven provisioning makes HR the source of authority and can create or update users in Entra ID or AD DS; arbitrary sources can use asynchronous `/bulkUpload`. [HR-driven provisioning](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/what-is-hr-driven-provisioning) [Inbound provisioning API FAQ](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/inbound-provisioning-api-faqs) |
| SaaS SSO works, but departed users retain target accounts | Entra application provisioning | Provisioning—not SSO—creates, maintains, disables, and removes target application accounts as source status and scope change. [Microsoft Entra provisioning overview](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/user-provisioning) |
| Custom HR feed must process more than 300,000 records per day | Redesign batching or request capacity guidance | The inbound API allows **6,000 calls per 24 hours** and **50 records per call**, producing a documented maximum of **300,000 records per 24 hours** at full payload utilization. [Troubleshoot inbound provisioning API issues](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/inbound-provisioning-api-issues) |
| Legacy Azure workload needs domain join, LDAP, Kerberos, NTLM, and Group Policy without customer-managed DCs | Microsoft Entra Domain Services | The managed domain supplies traditional protocols and deploys **2 managed DCs** per replica set without granting customer Domain Admin. [Microsoft Entra Domain Services overview](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview) [Domain Services replica sets](https://learn.microsoft.com/en-us/entra/identity/domain-services/concepts-replica-sets) |
| Legacy application requires custom AD schema and Domain Admin | Self-managed AD DS | Domain Services supports neither schema extensions nor customer Domain Admin/Enterprise Admin privileges. [Domain Services deployment scenarios](https://learn.microsoft.com/en-us/entra/identity/domain-services/scenarios) [Domain Services FAQs](https://learn.microsoft.com/en-us/entra/identity/domain-services/faqs) |
| Managed domain needs regional directory resilience | Additional Domain Services replica sets on Enterprise/Premium | A managed domain supports up to **5 replica sets** total; every replica has the same namespace and is billed independently. [Domain Services replica sets](https://learn.microsoft.com/en-us/entra/identity/domain-services/concepts-replica-sets) |
| Personal device should retain its local sign-in but gain an organizational device identity | Microsoft Entra registration | Registration targets BYOD and does not require the organizational identity to become the OS sign-in account. [Microsoft Entra registered devices](https://learn.microsoft.com/en-us/entra/identity/devices/concept-device-registration) |
| Organization-owned device should use the Entra account for sign-in and no AD DS computer object is required | Microsoft Entra join | Entra join is cloud-native, supports organization-owned devices, and can still provide SSO to on-premises resources. [Microsoft Entra joined devices](https://learn.microsoft.com/en-us/entra/identity/devices/concept-directory-join) |
| Cloud-authoritative workforce objects need point-in-time recovery from a recent bad change | Microsoft Entra Backup and Recovery | It takes automatic daily backups and retains up to **7 days**, but requires a workforce tenant with P1/P2 and cannot recover hard-deleted or AD DS-authoritative objects. [Microsoft Entra Backup and Recovery overview](https://learn.microsoft.com/en-us/entra/backup/overview) |
| Provisioning investigations must be retained longer than the portal window | Route Entra logs through diagnostic settings | Provisioning logs remain **7 days** with Free and **30 days** with premium; Azure Monitor, Storage, or Event Hubs provides longer retention and analysis. [Analyze provisioning logs](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-analyze-provisioning-logs) [Entra activity-log integration options](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-log-monitoring-integration-options-considerations) |

---

_Model used to research and author this fact sheet: GPT5 (reasoning mode not supplied)._
