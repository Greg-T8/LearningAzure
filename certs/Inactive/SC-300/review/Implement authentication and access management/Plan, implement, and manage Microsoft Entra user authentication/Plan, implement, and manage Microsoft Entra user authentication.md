### **Authentication Methods & Credentials**

* **Temporary Access Pass (TAP)**
  * **Configuration Details:**
    * Passcode length: **8 to 48 characters** (Default is 8).
    * Minimum lifetime: **10 minutes to 30 days** (Default is 1 hour).
    * Maximum lifetime: **10 minutes to 30 days** (Default is 8 hours).
  * **🚨 Exam Traps:**
    * Do not confuse TAP's 48-character limit with the **16-character limit** for the custom banned password list.
    * You **cannot issue a TAP to an external guest user**. They must be issued by the guest's home tenant.
    * Users have a strict **10-minute registration window** to register a passwordless method after signing in with a one-time TAP.
  * **Scenario Example:** A user loses a valid TAP in transit. An administrator creates a new one, which automatically overrides and replaces the existing valid TAP without requiring manual deletion.

* **OATH TOTP Tokens**
  * **Configuration Details:**
    * Hardware tokens must refresh every **30 or 60 seconds**.
    * Supported algorithms: **SHA-1 and SHA-256**.
    * Secret key formatting: **Base32 encoded**, maximum 128 characters.
    * Limit: Maximum of **5 OATH tokens** per user.
  * **📝 Prerequisites & Licensing:** Administrators must use a **CSV upload** containing UPN, serial number, secret key, time interval, manufacturer, and model to assign hardware tokens.
  * **🚨 Exam Traps:** Microsoft Entra ID strictly supports **OATH TOTP (Time-based)**. It explicitly **does not support OATH HOTP**.
  * **🔧 Troubleshooting:** Microsoft Entra ID allows a time drift correction of **+/- 1 minute** for 30-second tokens and **+/- 2 minutes** for 60-second tokens.

* **Certificate-Based Authentication (CBA)**
  * **Configuration Details:**
    * Strict limit of **only one CRL distribution point (CDP)** per trusted CA.
    * CRLs must download within **10 seconds** and are capped at **20 MB** for interactive sign-ins.
  * **📝 Prerequisites & Licensing:** The base feature is **free**, but uploading your PKI in bulk via the trust store container requires a **Microsoft Entra ID P1 or P2** license. You **must bring your own PKI**; Microsoft does not issue the certificates.
  * **🚨 Exam Traps:**
    * CRLs must be distributed over **HTTP** to avoid circular dependencies. **HTTPS, OCSP, and LDAP are explicitly not supported**.
    * Password fallback cannot be hidden on the sign-in screen, even when CBA is enforced.
  * **🔧 Troubleshooting:** If the HTTP CRL endpoint is offline, certificate validation experiences a **hard failure**.

* **Passkeys & Attestation**
  * **Configuration Details:** Passkeys are stored securely in the local Windows Hello container. Tenants are hard-capped at **3 passkey profiles**, which includes the mandatory Default profile.
  * **🚨 Exam Traps:**
    * Enforcing attestation **completely excludes synced passkeys** (like Apple iCloud or Google Password Manager) because they lack verifiable cryptographic device provenance. It strictly requires **device-bound passkeys**.
    * Once a tenant opts into using passkey profiles, **they cannot opt out** and revert to legacy global settings.

**📊 Comparison Table: Shared PC Auth Mechanisms**

| Authentication Method | Target Scenario | Registration Requirement | Device Storage Capacity |
| :--- | :--- | :--- | :--- |
| **Microsoft Entra Passkey on Windows** | Unregistered, personal, or **shared PCs**. | No Entra join/registration required. | **Multiple passkeys** for multiple Entra accounts. |
| **Windows Hello for Business (WHfB)** | Corporate-managed, dedicated PCs. | **Requires** Entra joined or Entra registered. | Bound **only to the specific work/school account** used to register. |

### **Conditional Access, Risk & MFA Management**

* **Migrating from Per-User MFA to Conditional Access**
  * **Configuration Details:** The strict Microsoft order of operations is: **1. Enable Conditional Access policy first** for all users, then **2. Disable per-user MFA** (bulk update to "Disabled").
  * **🚨 Exam Traps:** Never mix the two states. You should never have a user's legacy per-user state set to "Enabled" or "Enforced" while they are targeted by a Conditional Access policy.

* **Authentication Methods Policy Migration**
  * **Configuration Details:** The three migration states are **Pre-migration**, **Migration In Progress**, and **Migration Complete**.
  * **🚨 Exam Traps:**
    * The hard deprecation deadline for legacy MFA/SSPR portals is **September 30, 2025**.
    * In the "Migration Complete" state, legacy policies are completely ignored with one exception: **Security questions** must still be managed in the legacy SSPR portal.

* **Risk-Based Conditional Access (Entra ID Protection)**
  * **Configuration Details:**
    * **Sign-in Risk:** Evaluates the specific authentication request. Policy control: **Require MFA**.
    * **User Risk:** Evaluates if the entire identity is compromised. Policy control: **Require secure password change**.
  * **📝 Prerequisites & Licensing:** Requires a **Microsoft Entra ID P2** license.
  * **🚨 Exam Traps:** To perform self-remediation via MFA, the user **must have already registered for MFA before the risky sign-in occurs**.
  * **Scenario Example:** A user triggers a High Sign-in risk via atypical travel. They successfully complete the MFA prompt. Entra ID Protection automatically self-remediates, changing the Risk state to **"Remediated"** and the Risk detail to **"User passed multifactor authentication"**.

* **Defeating MFA Fatigue (Number Matching)**
  * **Configuration Details:** Number matching requires the user to type a 2-digit code into Authenticator. Admins can configure **Application Name** and **Geographic Location** as additional context.
  * **🚨 Exam Traps:**
    * Number matching is enabled by default and **cannot be opted out of**.
    * It is **not supported** on Apple Watch or Android wearable devices.
    * If using the NPS Extension for VPNs, admins must configure the `OVERRIDE_NUMBER_MATCHING_WITH_OTP = TRUE` registry key.

### **Tokens, Identity Mechanics & Access Revocation**

* **Primary Refresh Token (PRT) Lifecycle**
  * **Configuration Details:** The PRT has a **14-day rolling window**. On joined devices, the CloudAP plugin automatically refreshes the PRT every **four hours** when unlocked.
  * **🚨 Exam Traps:** 14 days is not a hard cutoff; the expiration clock continuously resets upon active use. Administrators can override this rolling window using **Conditional Access Sign-in frequency** session controls.
  * **Scenario Example:** A user authenticates via Windows Hello for Business. The PRT is imprinted with an **MFA claim**. Every time the PRT refreshes in the background, this MFA claim is extended, providing SSO without repeated MFA prompts across apps.

* **Mobile SSO & Authentication Brokers**
  * **Configuration Details:**
    * **Apple iOS:** Microsoft Authenticator app.
    * **Google Android:** Microsoft Authenticator OR Intune Company Portal.
    * **Windows 10/11:** Web Account Manager (WAM).
  * **📝 Prerequisites & Licensing:** Developers must build apps using the **Microsoft Authentication Library (MSAL)**. Brokers are a strict requirement for enforcing **Intune App Protection Policies (MAM)**.
  * **Scenario Example:** A user signs into iOS. The Authenticator app (acting as the broker) acquires the PRT. When the user opens Outlook, the broker silently uses the PRT to fetch access tokens without prompting the user.

* **Access Revocation (Browser vs. Thick Client)**
  * **🚨 Exam Traps:** Thick client application access is revoked when the **access token expires**. Browser-based application access relies on session tokens (cookies), meaning revocation depends entirely on the **frequency of synchronization** between Entra ID and the application (via SCIM provisioning).

**📊 Comparison Table: Authentication Artifacts**

| Artifact | Purpose in Authentication Flow | Lifetime / Validity | Cryptographic Role |
| :--- | :--- | :--- | :--- |
| **Nonce** | Prevents replay attacks by guaranteeing request freshness. | **5 minutes**. | A random number signed by the client's private key. |
| **PRT** | Provides Single Sign-On (SSO) across applications. | **14 days** (rolling window). | Opaque blob issued by Entra ID, encrypted with device's public transport key. |
| **Session Key** | Proof-of-Possession (POP) key for PRT requests. | Bound to PRT lifetime. | Encrypted by Entra ID, decrypted by the TPM. |

### **Kerberos & Application Integrations**

* **Microsoft Entra Kerberos**
  * **Configuration Details:** Microsoft Entra ID issues a **Cloud TGT** exclusively for the **`KERBEROS.MICROSOFTONLINE.COM`** realm. Administrators must configure **Realm Mapping** to direct specific namespaces (like Azure Files) to this realm.
  * **🚨 Exam Traps:**
    * **Cloud-only accounts** rely purely on **Azure RBAC** for authorization, bypassing NTFS ACLs.
    * For hybrid access, Windows uses an **OnPremTgt** (partial TGT) to exchange for a full AD TGT.
  * **🔧 Troubleshooting:**
    * Use the **`klist cloud_debug`** command to verify Cloud TGT presence.
    * If the output shows "Cloud Kerberos enabled by policy: 0", the client lacks the mandatory **`CloudKerberosTicketRetrievalEnabled = 1`** Intune/GPO policy.

* **Microsoft MCP Server (AI Tool Integration)**
  * **Configuration Details:** The MCP bridge strictly uses **OAuth 2.0 delegated permissions (scopes)** via the **On-Behalf-Of (OBO) flow** to restrict AI agents to the signed-in user's access level.
  * **📝 Prerequisites & Licensing:** Requires the **Cloud Application Administrator**, **Application Administrator**, or **Privileged Role Administrator** role. Viewing MCP telemetry in Global Secure Access requires a **Microsoft Entra Internet Access** or **Entra Suite** license.
  * **🚨 Exam Traps:**
    * Adding scopes via PowerShell operates in **additive mode**, preserving existing grants.
    * Running `Revoke-EntraBetaMcpServerPermission` without specifying individual scopes instantly **deletes the entire OAuth2PermissionGrant object**.
    * Omitting the resource identifier in a scope parameter automatically defaults to **Microsoft Graph**.

### **Governance & Administration**

* **Administrative Separation of Duties**
  * **Configuration Details:**
    * **Authentication Policy Administrator:** Enables and scopes authentication policies (e.g., enabling TAP for a pilot group).
    * **Authentication Administrator:** Creates, deletes, and views credentials (like issuing a TAP) for **standard users**.
    * **Privileged Authentication Administrator:** Issues credentials to **highly privileged administrators**.
  * **🚨 Exam Traps:** When a question asks for the "least-privileged" role to issue a credential or configure a policy, selecting "Global Administrator" is always incorrect.

* **Microsoft Entra ID Group Naming Policy**
  * **Configuration Details:** Dynamic prefixes/suffixes can use attributes like `[Department]`, `[Company]`, or `[Office]`. The maximum string length is **63 characters**. Administrators can configure up to **5,000 custom blocked words**.
  * **📝 Prerequisites & Licensing:** Requires a **Microsoft Entra ID P1** license for every unique user who is a member of an applied group.
  * **🚨 Exam Traps:**
    * Applies strictly to **Microsoft 365 groups** (not Security groups).
    * Blocked words require an **exact match** (no substring searches).
    * The **Global Administrator** and **User Administrator** roles are completely exempt from these rules.

* **Microsoft Authenticator Compliance**
  * **Configuration Details:** Satisfies **NIST Authenticator Assurance Level 2 (AAL2)** requirements. Uses **FIPS 140 validated cryptography**. On iOS, it specifically leverages the native Apple CoreCrypto module.
