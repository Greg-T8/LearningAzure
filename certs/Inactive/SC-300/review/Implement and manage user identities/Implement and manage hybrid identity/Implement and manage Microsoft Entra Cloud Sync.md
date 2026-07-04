### **Microsoft Entra Cloud Sync vs. Microsoft Entra Connect Sync**

| Feature | Microsoft Entra Cloud Sync | Legacy Microsoft Entra Connect Sync |
| :--- | :--- | :--- |
| **Orchestration Location** | Cloud-based (Microsoft Entra provisioning service) | On-premises sync server |
| **Configuration Storage** | Centralized in Microsoft Entra ID, eliminating drift | Stored locally on the sync server |
| **Sync Interval** | Every 2 minutes (Continuous scheduler) | Every 30 minutes by default |
| **Architecture** | Lightweight agents, outbound-only via Azure Service Bus | Heavy on-premises footprint, SQL database |
| **High Availability** | Active-Active multi-agent deployment with automatic failover | Active-Passive standby server (Single point of failure) |
| **Disconnected Forests** | Supported out-of-the-box via parallel agent deployment | Requires complex network VPNs or forest trusts |
| **Testing Features** | On-demand provisioning for real-time diagnostics | Not available |

### **1. Architecture, Mechanics, & Prerequisites**

* **System and Operating Requirements**
  * **Recommended OS:** Windows Server 2022.
  * **Server 2025 Prerequisite:** Requires patching with KB5070773 to function natively.
  * **Security Posture:** Host servers must be treated as highly secure **Tier 0 (Control Plane)** assets, installable on domain controllers.
* **Protocol & Communications**
  * Communication utilizes **System for Cross-domain Identity Management (SCIM) 2.0**.
  * Agents pull **SCIM requests** from the Azure Service Bus, process them locally, and return **SCIM responses**.
  * **Watermarks (Cookies):** To achieve the 2-minute interval without overloading AD, Cloud Sync uses "watermarks" to run delta syncs. The system saves the state of the last cycle and queries *only* for changes since that watermark.
* **Identity & Access Prerequisites**
  * **Cloud Role:** **Hybrid Identity Administrator** is required to configure the agent and register it to Entra ID.
  * **API Consent Role:** **Application Administrator** or **Cloud Application Administrator** is required to grant admin consent for programmatic API tasks (like transferring SOA).
  * **Local Role:** **Domain Administrator or Enterprise Administrator** is needed for local server installation and gMSA creation.
  * **Service Account:** Microsoft highly recommends an auto-created or custom **group Managed Service Account (gMSA)** (e.g., `provAgentgMSA$`). This provides **automatic password management** and **simplified SPN management** seamlessly across a multi-agent high-availability setup.

> **🚨 EXAM TRAPS 🚨**
>
> * **The Server Core Trap:** Installing the agent on Windows Server Core is **explicitly not supported**; a full GUI is strictly required.
> * **The Guest Account Trap:** The Hybrid Identity Administrator account used during installation **cannot be a guest account**; it must be native to the tenant.
> * **The iNetOrgPerson Trap:** While `iNetOrgPerson` objects sync perfectly, **Password hash synchronization (PHS)** is explicitly **not supported** for this object class.

### **2. Configuration Details: Scoping, Filtering, and Mapping**

* **Scoping Filter Logic Rules**
  * **Single Filter Logic:** Multiple clauses within a *single* filter apply **"AND"** logic (all must be true).
  * **Multiple Filters Logic:** The first filter applies **"AND"**, but any subsequent distinct filters apply **"OR"** logic.
  * **Underlying Default:** A default security grouping (`securityEnabled IS True`, `dirSyncEnabled IS FALSE`, `mailEnabled IS FALSE`) is always applied first using **"AND"** logic.
* **Attribute Mapping Types**
  * **Direct:** Passes the source value as-is. Can include a "Default value if null" that only applies upon object creation. Controlled via "Always" or "Only during creation" settings.
  * **Constant:** Hardcodes a specific manual string onto the target attribute, ignoring source data entirely.
  * **Expression:** Uses a script-like language to concatenate, strip, or calculate source values before reaching the target.

> **🛠️ SCENARIO EXAMPLES 🛠️**
>
> * **Scenario:** You need to pilot configuration changes without impacting the whole directory.
> * **Action:** Use **On-demand provisioning** to trace attribute transformations. The console displays four diagnostic steps: **Import user, Determine if in scope, Match user, and Perform action**.
> * **Scenario Constraint:** When running on-demand provisioning against a group, members are not automatically processed. You must manually select up to a **maximum of 5 members** to evaluate.

### **3. Advanced Capabilities & Administration**

* **Cloud to AD Security Group Provisioning**
  * Replaces legacy "Group Writeback v2".
  * Requires provisioning agent version **1.1.1370.0** or later.
  * Provisions cloud security groups down to AD DS with a **Universal group scope**.
  * **Membership Rule:** On-premises groups can *only* contain users that were originally synced from AD, or other cloud-created groups.
  * **Use Case:** Allows Entra ID Governance (entitlement management/access packages) to manage access to legacy on-premises apps utilizing Kerberos or LDAP.
* **Source of Authority (SOA) Conversion**
  * Requires provisioning agent build **1.1.1370.0+**.
  * Transitions management of individual objects from AD to Entra ID (cloud-native).
  * **How it works:** An admin updates the `isCloudManaged` property to `true` via Graph API. The agent reads this flag and permanently blocks AD updates from syncing to that object in the cloud.

> **🔧 TROUBLESHOOTING DETAILS 🔧**
>
> * **Triggering Accidental Deletion Prevention:** If an admin moves a synced AD OU out of scope, Cloud Sync reads this as a mass deletion. Users are **soft-deleted**, groups are **hard-deleted**.
> * **Clearing Quarantines:** If mass deletions exceed the threshold (default 500), the job quarantines. To clear the quarantine after fixing the scope, you must manually click **Restart sync**. Alternatively, if the deletions were intentional, use Restart Sync scoped to **"ForceDeletes"**.

### **4. Migrating from Connect Sync to Cloud Sync**

* **Step 1: Halt the Legacy Scheduler**
  * You must stop the legacy scheduler to prevent incomplete sync rules from pushing mass deletions during configuration.
  * PowerShell Commands: `Stop-ADSyncSyncCycle` followed by `Set-ADSyncScheduler -SyncCycleEnabled $false`.
* **Step 2: Configure the Inbound Sync Rule**
  * Open Synchronization Rules Editor and target the pilot OU.
  * Create a **Constant** transformation type.
  * Set the target attribute **`cloudNoFlow`** to the value **`True`**.
* **Step 3: Configure the Outbound Sync Rule**
  * Scope the rule to objects where `cloudNoFlow` equals `True`.
  * Set the link type to **`JoinNoFlow`**.
  * **Mechanic:** This forces Entra Connect to maintain the object "join" (preventing deletion) but completely stops the flow of attribute updates.

> **🚨 EXAM TRAPS 🚨**
>
> * **The Reference Attribute Exception:** If an AD reference attribute (like a user's `manager`) is updated, Microsoft Entra Connect **ignores the `cloudNoFlow` flag** and unexpectedly exports all updates for that object to the cloud anyway.
> * **The Rollback Trap:** If a pilot fails, do **not** manually set `cloudNoFlow` to 'False' on users, as the inbound rule will instantly revert it to 'True'.
> * **Proper Rollback Procedure:** Disable the Cloud Sync profile in the cloud portal, then **disable the custom sync rules** in the on-premises Sync Rule Editor. Disabling the rule automatically triggers a full sync cycle that clears the `cloudNoFlow` restrictions and returns users to legacy management.
