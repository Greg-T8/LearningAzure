# Azure Tenant Root Management Group Governance Policy

Your answer was incorrect because **Azure Policy definitions and assignments are fully supported at the Tenant Root Group level** [1, 2]. The platform does not restrict the root scope to RBAC alone, nor does it enforce a strict rule that policies must begin at a specific depth [1].

Here is a detailed breakdown of why your selection was inaccurate and why limiting root assignments to **"must-have" global items** is the documented Microsoft best practice:

---

### 1. Why "The root group is only for RBAC..." is Incorrect
* **Policy Assignments are Supported at Root:** Microsoft documentation explicitly states that the Tenant Root Management Group allows both global policies and Azure role assignments to be applied at the directory level [1, 2]. 
* **Policy Definitions vs. Assignments:** Creating custom policy *definitions* at the Tenant Root Group is actually recommended so they can be inherited and assigned across any scope in the entire hierarchy [3]. 
* **No Artificial Depth Restriction:** While the Azure Landing Zone reference architecture uses an **Intermediate Root Management Group** (e.g., `Contoso`) directly below the Tenant Root Group to avoid altering the root group directly for general workload governance [4, 5], there is no platform constraint that forbids policy assignments at the root level [1, 2].

---

### 2. Why "Limit assignments to 'must-have' global items" is Correct

#### A. Directory-Wide Blast Radius
Because lower levels inherit all settings from higher levels, any policy assigned at the Tenant Root Group automatically cascades down to **every management group, subscription, resource group, and resource in that entire Microsoft Entra tenant** [2, 6]. If a restrictive policy (such as a `Deny` effect) is assigned at the root with a configuration mistake, it can immediately block deployments across every team, subscription, and sandbox in the organization [2, 7].

#### B. Direct Microsoft Guidance
Official Azure documentation explicitly mandates:
> *"Any assignment of user access or policy on the root management group applies to all resources within the directory. Because of this access level, all customers should evaluate the need to have items defined on this scope. User access and policy assignments should be 'must have' only at this scope."* [2]

#### C. Minimizing Exclusion Overhead
Assigning policies at the Tenant Root Group scope forces you to create and manage complex policy exclusions for subscopes (such as sandbox or dev/test subscriptions) that require exceptions [3, 8]. Limiting root-level assignments keeps governance management clean and avoids debugging inherited policy conflicts across lower-level management groups [3, 8].

#### D. What Belongs at the Tenant Root Scope?
Only items that have a clear enterprise-wide business requirement and near-zero risk of disrupting day-to-day operations should be assigned at the root [7, 9]:
* **Data Sovereignty Constraints:** High-level regulatory restrictions (e.g., restricting resource locations globally) [7].
* **Audit-Only Policies:** Enterprise-wide monitoring or compliance auditing policies (`Audit` or `AuditIfNotExists`) that report status without blocking deployments [7, 10].

---

### 🎯 AZ-305 Governance Summary:
* **Tenant Root Group:** Limit assignments to **"must-have" global items only** to prevent directory-wide operational risk and exclusion sprawl [2, 8].
* **Intermediate Root Management Group:** The primary scope where baseline Azure Landing Zone policies and initiatives should be assigned for platform and workload governance [3, 4].

***

📐 Would you like to review how policy enforcement modes (like `DoNotEnforce`) and resource selectors allow platform teams to safely test and roll out new policy assignments before enforcing them broadly across landing zones?