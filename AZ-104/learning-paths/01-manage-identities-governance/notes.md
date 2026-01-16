# Learning Path 1: Manage Identities and Governance

**Learning Path** [AZ-104: Manage identities and governance in Azure](https://learn.microsoft.com/en-us/training/paths/az-104-manage-identities-governance/)

* [📋 Modules](#-modules)
* [🧠 Key Concepts](#-key-concepts)
  * [Entra ID P1 vs P2 Features](#entra-id-p1-vs-p2-features)
  * [Microsoft Entra Domain Services](#microsoft-entra-domain-services)
    * [🎯 What It Is](#-what-it-is)
    * [📌 Critical Exam Highlights](#-critical-exam-highlights)
    * [🔑 Supported Features (Memorize These!)](#-supported-features-memorize-these)
    * [⚡ Key Exam Takeaways](#-key-exam-takeaways)
    * [🚫 What It Does NOT Do](#-what-it-does-not-do)
    * [💡 Exam Tip](#-exam-tip)
  * [Microsoft Entra ID: Restore or Remove Deleted Users](#microsoft-entra-id-restore-or-remove-deleted-users)
  * [Change Group License Assignments (Microsoft Entra ID)](#change-group-license-assignments-microsoft-entra-id)
  * [Azure Physical Infrastructure](#azure-physical-infrastructure)
  * [Azure Management Infrastructure](#azure-management-infrastructure)

---

## 📋 Modules

| # | Module | Status |
|---|--------|--------|
| 1 | [Understand Microsoft Entra ID](https://learn.microsoft.com/en-us/training/modules/understand-azure-active-directory/)| ✅ |
| 2 | [Create, configure, and manage identities](https://learn.microsoft.com/en-us/training/modules/create-configure-manage-identities/) | ✅ |
| 3 | [Describe the core architectural components of Azure](https://learn.microsoft.com/en-us/training/modules/describe-core-architectural-components-of-azure/) | 🚧 |
| 4 | Configure Azure Policy | 🕒 |

**Legend:**  

| Emoji | Meaning     |
| ----- | ----------- |
| 🕒   | Not Started |
| 🚧   | In Progress |
| ✅    | Complete    |

---

## 🧠 Key Concepts

<!-- Add notes as you complete each module -->

### Entra ID P1 vs P2 Features

[Module Reference](https://learn.microsoft.com/en-us/training/modules/understand-azure-active-directory/5-compare-azure-premium-p1-p2-plans)

Here's a simplified table breaking down the Microsoft Entra ID features by edition:

| Feature | P1 | P2 |
|---------|:---:|:--:|
| **Self-service group management** - Users can create/manage groups, request to join others, owners approve requests | ✓ | ✓ |
| **Advanced security reports and alerts** - ML-based logs showing anomalies and inconsistent access patterns | ✓ | ✓ |
| **Multi-factor authentication (MFA)** - Works with on-premises apps (VPN, RADIUS), Azure, Microsoft 365, Dynamics 365, and Entra gallery apps | ✓ | ✓ |
| **Microsoft Identity Manager (MIM) licensing** - Hybrid identity solutions bridging on-premises auth stores with Entra ID | ✓ | ✓ |
| **Enterprise SLA of 99.9%** - Guaranteed availability | ✓ | ✓ |
| **Password reset with writeback** - Self-service reset following on-premises AD password policy | ✓ | ✓ |
| **Cloud App Discovery** - Discovers frequently used cloud-based applications | ✓ | ✓ |
| **Conditional Access** - Based on device, group, or location for critical resources | ✓ | ✓ |
| **Microsoft Entra Connect Health** - Operational insights with alerts, performance counters, and usage patterns | ✓ | ✓ |
| **Microsoft Entra ID Protection** - User risk policies, sign-in policies, behavior monitoring, risk flagging | | ✓ |
| **Microsoft Entra Privileged Identity Management (PIM)** - Permanent/temporary admin roles, policy workflows for privileged access | | ✓ |

**Summary:** P2 includes everything in P1, plus **ID Protection** and **Privileged Identity Management** for enhanced security monitoring and privileged access control.

---

### Microsoft Entra Domain Services

[Module Reference](https://learn.microsoft.com/en-us/training/modules/understand-azure-active-directory/6-examine-azure-domain-services)

#### 🎯 What It Is

**Microsoft Entra Domain Services** (formerly Azure AD Domain Services) is a **Microsoft-managed** domain service that provides traditional Active Directory features in Azure **without deploying or managing domain controllers**.

#### 📌 Critical Exam Highlights

| Concept | Key Points to Remember |
|---------|------------------------|
| **Managed Service** | Microsoft handles all DC management:  patching, backups, availability, monitoring |
| **No Domain Controllers Needed** | You do NOT deploy, manage, or maintain DCs yourself |
| **Core AD Features Provided** | Domain join, Group Policy, LDAP, Kerberos, NTLM authentication |
| **Synchronization** | Automatically syncs users, passwords, and groups from Microsoft Entra ID |
| **Use Case** | Lift-and-shift **legacy applications** that require traditional AD features to Azure |

#### 🔑 Supported Features (Memorize These!)

| Feature | Purpose |
|---------|---------|
| **Domain Join** | Join Azure VMs to the managed domain |
| **Group Policy (GPOs)** | Centralized security/config management |
| **LDAP** | Directory lookups for legacy apps |
| **Kerberos/NTLM** | Authentication protocols for legacy apps |

#### ⚡ Key Exam Takeaways

1. **Primary Purpose**: Run legacy/on-premises apps in Azure that need traditional AD services
2. **Fully Managed**: No infrastructure overhead—Azure handles everything
3. **High Availability**: Multiple DCs deployed automatically in your chosen Azure region
4. **Integration**: Seamlessly integrates with Microsoft Entra ID (cloud identities)
5. **Hybrid Scenarios**:  Bridges on-premises AD and cloud identity management

#### 🚫 What It Does NOT Do

* Does **not** replace on-premises AD DS for complex environments
* Does **not** provide schema extensions or forest trusts (limited customization)
* You **cannot** directly manage the domain controllers

#### 💡 Exam Tip
>
> If a question mentions needing **domain join, LDAP, Kerberos, or NTLM** for Azure VMs or legacy apps **without managing domain controllers**, the answer is **Microsoft Entra Domain Services**.

---

### Microsoft Entra ID: Restore or Remove Deleted Users

[Module Reference](https://learn.microsoft.com/en-us/training/modules/create-configure-manage-identities/3-exercise-assign-licenses-users)

**Deleted user lifecycle**

* When a user is deleted, the account is placed in a **soft-deleted (suspended) state for 30 days**.
* During this **30-day window**, the user **can be restored with all properties**.
* After 30 days, the account is **permanently deleted automatically**.

**Important**

* **Permanently deleted users cannot be restored.**

**Where this is managed**

* Microsoft Entra ID user interface → view restorable users, restore users, or permanently delete users.

**Required roles to restore or permanently delete**

* Global Administrator
* User Administrator
* Partner Tier-1 Support
* Partner Tier-2 Support

---

### Change Group License Assignments (Microsoft Entra ID)

**Group-based licensing overview**

* Assign licenses to a **security group** so all current/future members get licenses automatically; removing a user from the group removes the group-assigned license. ([Microsoft Learn][1])
* Group/user license assignment is managed through the **Microsoft 365 Admin Center**. ([Microsoft Learn][2])

**Where to do it (high level)**

* Microsoft 365 Admin Center → **Billing → Licenses** → select product → **Groups** tab → assign to a group. ([Microsoft Learn][1])

**Status concepts**

* Assignments can be processing or completed; failures are recorded as an **error state on the user** and can be investigated (including via audit logs). ([Microsoft Learn][3])

**Error types you should recognize**
(These show up as licensing assignment error categories, including in Microsoft Graph.)

* **CountViolation** — not enough licenses available (license count exceeded). ([Microsoft Learn][4])
* **MutuallyExclusiveViolation** — conflicting plans can’t coexist. ([Microsoft Learn][4])
* **DependencyViolation** — missing required/dependent service plan. ([Microsoft Learn][4])
* **ProhibitedInUsageLocationViolation** — usage location missing/invalid or service not available in that location (usage location must be set). ([Microsoft Learn][4])
* **UniquenessViolation** — uniqueness constraint failure (commonly surfaced as conflicts like duplicate values). ([Microsoft Learn][4])
* **Other** — miscellaneous licensing interaction/processing failures. ([Microsoft Learn][4])

[1]: https://learn.microsoft.com/en-us/entra/identity/users/licensing-admin-center?utm_source=chatgpt.com "Assign licenses to a group using the Microsoft 365 admin ..."
[2]: https://learn.microsoft.com/en-us/entra/identity/users/licensing-group-advanced?utm_source=chatgpt.com "Scenarios, limitations, and known issues using groups to ..."
[3]: https://learn.microsoft.com/en-us/entra/fundamentals/licensing-groups-resolve-problems?utm_source=chatgpt.com "Resolve group license assignment problems."
[4]: https://learn.microsoft.com/en-us/graph/api/resources/licenseassignmentstate?view=graph-rest-1.0&utm_source=chatgpt.com "licenseAssignmentState resource type - Microsoft Graph v1.0"

---

### Azure Physical Infrastructure

[Module Reference](https://learn.microsoft.com/en-us/training/modules/describe-core-architectural-components-of-azure/5-describe-azure-physical-infrastructure)

**Azure datacenter foundation**

* Azure is built on **global datacenters** that house compute, storage, and networking hardware with redundant power, cooling, and connectivity.

**Regions**

* A **region** is a geographic location with **multiple datacenters** connected by high-speed, low-latency networks.
* Regions are where you **deploy Azure resources**; region choice affects performance, compliance, and availability.

**Availability Zones**

* **Availability Zones** are **physically separate datacenters** within the same region.
* Each zone has independent power, networking, and cooling.
* Zones improve **fault tolerance**: failure in one zone doesn’t affect others.

**Region pairs**

* Regions are paired within the same geography to support **disaster recovery and data residency**.
* Azure places **priority for recovery** across paired regions in major outages.

**Sovereign regions**

* **Sovereign regions** are isolated instances of Azure designed to meet **special regulatory and data-residency requirements**.

**Purpose of physical distribution**

* The combination of **regions, availability zones, and region pairs** provides:

  * **Resiliency** against failures
  * **Low latency** for customers
  * **Compliance boundaries** for data sovereignty and regulations

**Key concepts to remember**

* Region = one or more datacenters in a geography.
* Availability Zones = separate locations within a region for redundancy.
* Region pairs = disaster recovery alignment across regions.
* Sovereign regions = specialized isolated Azure deployments.

---

### Azure Management Infrastructure

[Module Reference](https://learn.microsoft.com/en-us/training/modules/describe-core-architectural-components-of-azure/6-describe-azure-management-infrastructure)

**Overview**

* Azure provides a hierarchical management structure to organize resources, apply governance, and control access at scale.
* Management layers allow consistent policy, RBAC, and compliance enforcement across large environments.

**Management Hierarchy (Top → Bottom)**

* **Management Groups**

  * Used to organize subscriptions.
  * Policies and RBAC assigned at a management group are inherited by all child management groups and subscriptions.
  * A management group tree supports **up to six levels of depth** (excluding the tenant root).
  * The **tenant root management group** is the top-level container and is created automatically.
* **Subscriptions**

  * Logical containers for billing, access control, and quotas.
  * A subscription can belong to only **one** management group.
* **Resource Groups**

  * Containers that hold related Azure resources.
  * Resources can exist in only one resource group at a time.
  * Resource groups are used for lifecycle management (deploy, update, delete as a unit).
* **Resources**

  * Individual Azure services (VMs, storage accounts, VNets, databases, etc.).

**Azure Resource Manager (ARM)**

* The control plane for Azure.
* Handles deployment, updates, and deletion of resources.
* Provides:

  * Declarative infrastructure via templates (ARM templates, Bicep).
  * Consistent management layer across Azure services.
  * Role-based access control (RBAC).
  * Policy enforcement.
  * Tagging support for cost and organization.

**Role-Based Access Control (RBAC)**

* Controls **who** can do **what** at a given scope.
* Scopes include:

  * Management group
  * Subscription
  * Resource group
  * Individual resource
* Access is inherited down the hierarchy.
* Uses built-in roles (Owner, Contributor, Reader) and custom roles.

**Azure Policy**

* Used to enforce standards and assess compliance.
* Can:

  * Deny non-compliant resources.
  * Audit existing resources.
  * Append or modify resource settings.
* Assigned at management group, subscription, or resource group scope.
* Policies are inherited by child scopes.

**Tags**

* Key-value pairs applied to resources or resource groups.
* Used for:

  * Cost management and chargeback.
  * Organization and reporting.
* Tags are **not automatically inherited** from parent scopes.

**Key Exam Takeaways**

* Management groups are for **organization and governance across subscriptions**.
* RBAC controls access; Azure Policy enforces rules and compliance.
* ARM is the unified management layer for Azure.
* Inheritance flows **downward** through the management hierarchy.
* Management group hierarchy depth limit: **6 levels**.



*Last updated: 2026-01-14*
