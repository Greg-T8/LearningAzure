### **1. Microsoft Entra Password Hash Synchronization (PHS)**

**Architecture & Deep Cryptography**

* **The "Hash of a Hash" Security Pipeline:**
  * Active Directory stores passwords as an **MD4 hash** in the `unicodePwd` attribute.
  * The sync agent requests the MD4 hash via the **MS-DRSR replication protocol**. **The plain-text password is never exposed or transmitted**.
  * The 16-byte MD4 hash is expanded to **64 bytes** (converted to a 32-byte hexadecimal string, then to binary with UTF-16 encoding).
  * A unique **10-byte per-user salt** is appended to the binary.
  * The combined hash and salt are fed into the **PBKDF2** (Password Key Derivation Function 2).
  * The algorithm strictly applies **1,000 iterations of HMAC-SHA256** to deliberately make decryption computationally expensive.
  * The final 32-byte hash, salt, and iteration count are transmitted over TLS to Microsoft Entra ID.
* **Protection Against Pass-the-Hash:** Because the original MD4 hash never leaves the local network, if the cloud database is compromised, the stolen SHA256 hashes are completely useless to an attacker trying to pivot back to the on-premises AD environment.

**⚙️ Configuration Details & Selective Synchronization**

* **Selective PHS Execution:**
  * Target the **`adminDescription`** attribute in AD.
  * Exact value must be **`PHSFiltered`** (to exclude) or **`PHSIncluded`** (to include).
  * You **must** disable the synchronization scheduler (`Set-ADSyncScheduler -SyncCycleEnabled $false`) before building the custom scoping filter rules.
* **Password Policies (Source of Authority):**
  * **Complexity:** On-premises AD complexity policies **always override** cloud policies for synced users.
  * **Expiration:** PHS sets the cloud password state to **"Never Expire"**. To enforce expiration for cloud logons, you must enable **`CloudPasswordPolicyForPasswordSyncedUsersEnabled`** via Microsoft Graph PowerShell.

**🚨 Exam Traps & Dependencies**

* **The `iNetOrgPerson` Trap:** Standard attribute synchronization supports `iNetOrgPerson` objects, but **PHS explicitly does NOT support them**. They must be converted to standard `User` objects.
* **The AD FS Failover Trap:** While PHS acts as the ultimate backup for a failed AD FS infrastructure, the failover process is **not automatic**; an administrator must manually switch the primary sign-in method via the Connect wizard.
* **The Selective Sync Writeback Trap:** If a user is excluded from PHS via `adminDescription`, any cloud SSPR changes **will not write back** to on-premises AD.

**🔧 Troubleshooting & Event Logging**

* **Event ID 601:** Password hash sync manager is starting.
* **Event ID 607:** Sync is not able to start.
* **Event ID 602:** Sync is stopping.
* **Event ID 611:** Error during sync for a domain.
* **Event IDs 650/651:** Start/End of a sync batch.
* *Actionable Step:* Administrators must manually **increase the size of the Windows Application log** to prevent high-volume 2-minute cycle PHS events from overwriting critical troubleshooting data.

| Scheduler Type | Sync Frequency | Configurable? | Dependencies / Notes |
| :--- | :--- | :--- | :--- |
| **Password Hash Sync Scheduler** | **Every 2 minutes** | **No** | Uses MS-DRSR protocol. Requires user object to exist in Entra ID first. |
| **Object / Attribute Scheduler** | **Every 30 minutes** (Default) | **Yes** | Modified using `Set-ADSyncScheduler -CustomizedSyncCycleInterval`. |

---

### **2. Microsoft Entra Pass-through Authentication (PTA)**

**Architecture & Flow**

* **The Win32 API Mechanism:** PTA agents use the **Win32 `LogonUser` API** with the `dwLogonType` parameter set to **`LOGON32_LOGON_NETWORK`**. This is the exact same underlying mechanism used by AD FS.
* **Authentication Flow:** User enters password in Entra -> Entra encrypts and places in tenant-specific **Azure Service Bus queue** -> On-prem PTA agent retrieves via outbound connection -> Agent decrypts with private key -> Agent passes to `LogonUser` API -> DC returns explicit result -> Agent forwards to Entra over mutual HTTPS.

**⚙️ Configuration Details & Security Posture**

* **Tier 0 Classification:** PTA agents have unconstrained access to Domain Controllers to validate passwords. Therefore, the server hosting the agent must be treated as a **Tier 0 system / Domain Controller**.
* **Network Boundaries:** Agents establish **outbound-only connections** (Ports 443, and 80 for CRLs).
* **High Availability:** Install a **minimum of 3 agents** (system maximum is 40). The first agent installs on the Connect server; subsequent agents must be standalone servers.

**🚨 Exam Traps**

* **The DMZ Trap:** You must **never** place a PTA agent in a perimeter network/DMZ. It requires unconstrained internal network access to function securely.

**🔧 Troubleshooting**

* Because PTA uses native Windows APIs, you must correlate the `LogonUserA` function calls in the **Domain Controller's Security Log** with **Event ID 4624** (Success) or **Event ID 4625** (Failure).

---

### **3. Single Sign-On: Seamless SSO vs. Primary Refresh Token (PRT)**

**Seamless SSO Mechanics & Administration**

* **Identity Matching via SID:** Seamless SSO decrypts the Kerberos ticket and extracts the **`securityIdentifier` (SID) claim**, matching it against the cloud **`objectSID`**. This provides seamless support for **Alternate IDs** (like email addresses) since it does not rely on matching UPN text strings.
* **The `AZUREADSSOACC` Account:**
  * Created per synchronized AD forest.
  * Must be stored in a secure OU restricted to Domain Admins.
  * **Kerberos delegation must be explicitly disabled**.
  * Microsoft recommends enforcing **AES256_HMAC_SHA1** on the `msDS-SupportedEncryptionTypes` attribute rather than relying on RC4.
* **PowerShell Administration:**
  * Import local module: `Import-Module .\AzureADSSO.psd1`.
  * Authenticate: `New-AzureADSSOAuthenticationContext`.
  * Check status: **`Get-AzureADSSOStatus | ConvertFrom-Json`**.

**🚨 Exam Traps & Troubleshooting (Seamless SSO)**

* **The Key Rotation Trap:** Entra ID does *not* auto-rotate the decryption key. Admins must manually run **`Update-AzureADSSOForest` every 30 days**.
* **Rotation Failures:** The key rollover will systematically fail if the Domain Admin account used is part of the Active Directory **Protected Users** group. Credentials must use the SAM account name format (e.g., `contoso\johndoe`).
* **The Fallback Trap:** Seamless SSO is an **opportunistic feature**. Failure to validate the Kerberos ticket (e.g., no VPN line-of-sight to a DC, or InPrivate browsing) results in a graceful fallback to a password prompt, not a blocking error.

| Feature | Primary OS Target | Mechanism | Hardware Protection | Precedence |
| :--- | :--- | :--- | :--- | :--- |
| **Seamless SSO** | Legacy (Windows 7 / 8.1) | `AZUREADSSOACC` Kerberos tickets off local DCs | None | Overridden if PRT is present. |
| **Primary Refresh Token (PRT)** | Modern (Windows 10 / 11) | JSON Web Token (JWT) via Web Account Manager | Cryptographically bound to the device's hardware **TPM**. | **Takes ultimate precedence**. |

**💡 Scenario Example (PRT & MFA):** A user signs into their Windows 11 machine using **Windows Hello for Business**. The PRT issued by the CloudAP plugin is instantly imprinted with an **MFA claim**. When accessing SharePoint later, the PRT satisfies Conditional Access MFA requirements automatically, preventing MFA fatigue.

---

### **4. Password Writeback & Self-Service Password Reset (SSPR)**

**Architecture & Flow**

* **Zero-Delay Feedback:** Writeback evaluates new passwords against **both** cloud banned password lists and on-premises AD DS policies (complexity, age, history, custom filters) *before* committing the change. If the AD policy is failed, the cloud UI immediately prompts the user to try again.
* **Security:** Requires **no inbound ports**. Relies strictly on outbound port 443 via a tenant-specific Azure Service Bus relay with end-to-end public/private key encryption.

**📝 Prerequisites & Licensing Notes**

* Requires a **Microsoft Entra ID P1 or P2** license (or M365 Business Premium).
* **Two-Step Configuration:** (1) Enable in Microsoft Entra Connect wizard, (2) Check "Write back passwords to your on-premises directory" in the Microsoft Entra admin center.

**🚨 Exam Traps**

* Writeback supports end-user SSPR and admin resets initiated strictly from the **Microsoft Entra admin center**.
* Writeback **does not support** admin resets performed from the Microsoft 365 admin center or legacy PowerShell v1/v2 modules.

---

### **5. Migration & Sync Evolution: Staged Rollout & Cloud Sync**

**Staged Rollout (Federation to Cloud Migration)**

* **Purpose:** The Microsoft-recommended testing path to migrate specific pilot users from federated authentication (AD FS) to managed cloud authentication (PHS/PTA). Tests MFA, Conditional Access, Identity Protection, and Governance.
* **⚙️ Configuration Limitations:**
  * Pilot groups are strictly limited to **200 users initially** to avoid UX timeouts.
  * **No nested groups or dynamic membership groups** are supported.
  * *Prerequisite:* If testing Certificate-Based Authentication (CBA), PHS must be enabled for pilot password auth to function.
* **🚨 Exam Trap:** Staged rollout is **strictly temporary** and must never be used for long-term coexistence.

**Microsoft Entra Cloud Sync**

* **Architecture Shift:** Moves orchestration logic to the **Microsoft Entra provisioning service** in the cloud. Relies on lightweight, outbound-only **provisioning agents**.
* **Active-Active High Availability:** Multiple agents run concurrently, providing automatic failover and completely eliminating the need for Connect Sync's complex "Staging Mode" server architecture.
* **M&A Scenario:** Natively handles synchronization from **disconnected AD forests** because each forest simply requires its own lightweight agent to talk back to the central cloud orchestrator.

---

### **6. Microsoft Entra Connect Health**

**📝 Prerequisites & Licensing Notes**

* Requires a **Microsoft Entra ID P1 or P2** license to access the portal and analytics.
* Requires a hard upgrade to **Microsoft Entra Connect V2**. V1 is retired due to ADAL deprecation, and V2 strictly enforces **TLS 1.2** and utilizes **SQL Server 2019** and SHA-2 binary signing.

**Architecture & Access Management**

* **Health Agents:** Automatically installed on the Connect Sync server, but must be **manually installed** on targeted AD FS and AD DS servers. Requires outbound port 443.
* **Delegation:** Uses **Azure RBAC roles** (not Entra directory roles).
  * **Owner:** Manage access, change settings, view all.
  * **Contributor:** Change settings, view all.
  * **Reader:** View sync errors/alerts only (Least-privilege ideal for Helpdesk).
  * *Exam Trap:* **Global Administrators** inherently possess full access, even if not explicitly listed in the Connect Health RBAC assignments.

| Monitored Service | Key Telemetry / Dashboards Provided |
| :--- | :--- |
| **Microsoft Entra Connect (Sync)** | Sync errors, PHS failures, export issues |
| **AD FS** | Extranet lockout trends, token requests, failed sign-ins |
| **AD DS** | Replication status, domain controller health |
