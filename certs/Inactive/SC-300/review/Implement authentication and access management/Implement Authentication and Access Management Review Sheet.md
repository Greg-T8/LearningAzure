<!--
File: Implement Authentication and Access Management Review Sheet.md
Description: Combined markdown content merged from 'Implement authentication and access management'
Generated: 2026-05-25
Author: Greg Tate
-->

# Implement Authentication and Access Management Review Sheet

## Manage risk by using Microsoft Entra ID Protection

##### **1. Microsoft Entra ID Protection Architecture & Licensing**

* **Licensing Boundaries (P1 vs. P2)**
  * **📝 Prerequisites & Licensing (Entra ID P1):** Grants a basic, limited view. Administrators can only see users flagged with "Medium" or "High" risk.
    * **Limitations:** No details drawer, no historical risk timeline, and no ability to create risk-based Conditional Access policies or allow automated self-remediation.
    * **🚨 Exam Trap (The Generic Risk Mask):** P1 masks specific threat names. If an exam scenario states an administrator sees a generic **"Additional risk detected"** tag instead of a specific threat like "Atypical Travel," the only solution is to upgrade the tenant to Microsoft Entra ID P2.
  * **📝 Prerequisites & Licensing (Entra ID P2):** Unlocks full reporting, complete risk histories, low-risk visibility, and exact MITRE ATT&CK risk detection names. Unlocks risk-based Conditional Access, automated self-remediation, and automated alert emails ("Users at risk detected" / "Weekly digest").
  * **📝 Prerequisites & Licensing (Workload Identities Premium):** A completely separate license strictly required to view full risk details or create risk-based Conditional Access policies for service principals and applications.

* **Risk Evaluation Engines**
  * **Real-time Detections:**
    * **Mechanics:** Evaluated *during* the actual sign-in process.
    * **Latency:** Surfaces in reports within **5 to 10 minutes**.
    * **Scenario Example:** A user signs in from an Anonymous IP address (Tor Browser). Because this is real-time, risk-based Conditional Access policies can immediately block the bad actor or prompt for MFA before access is granted.
  * **Offline Detections:**
    * **Mechanics:** Evaluated *after* authentication completes by analyzing broader patterns and post-authentication behavior.
    * **Latency:** Can take **up to 48 hours** to surface in reports.
    * **Scenario Examples:** Atypical travel, Leaked credentials, and Suspicious API Traffic.
    * **🚨 Exam Trap (Risk Fluctuations & Delayed Notifications):** Because offline detections take up to 48 hours, a user's risk level can dynamically elevate to High long after their initial successful sign-in. If you configure alert emails, this causes delayed notifications that arrive hours after the actual sign-in occurred.

**📊 Comparison Table: Entra ID Licensing Capabilities**

| Feature | Entra ID P1 | Entra ID P2 | Workload Identities Premium |
| :--- | :--- | :--- | :--- |
| **Risk Visibility** | Medium/High only | Low/Medium/High | Non-human accounts |
| **Risk Details** | Masked ("Additional risk detected") | Full MITRE ATT&CK names | Full MITRE ATT&CK names |
| **Risk-Based Conditional Access** | ❌ Not available | ✅ Yes (Sign-in & User risk) | ✅ Yes (Workload risk) |
| **Automated Self-Remediation** | ❌ Manual admin action required | ✅ Yes | ❌ Manual admin action required |

##### **2. Risk Types & Adaptive Self-Remediation**

* **Sign-in Risk vs. User Risk**
  * **Sign-in Risk:** The probability that a specific authentication request is suspicious.
    * **Configuration Detail:** To self-remediate, configure a policy requiring the user to pass a standard **MFA challenge**.
  * **User Risk:** The probability that the overall identity is compromised.
    * **Scenario Example:** Microsoft's credential scanning pipeline discovers a password on the dark web and validates it against tenant hashes. This "Leaked Credentials" detection is *always* flagged as High User Risk.
    * **Configuration Detail:** To self-remediate, configure a policy requiring a **secure password change** (the user must pass MFA, then choose a new password).

* **The 14-Day MFA Registration Policy**
  * **Mechanics:** Designed to ensure users pre-register security info (like the Authenticator app). Grants a **14-day grace period** to skip registration before permanently forcing it at sign-in.
  * **Configuration Detail:** Interrupts users with the "Combined security information registration" experience, registering MFA and Self-Service Password Reset (SSPR) simultaneously.
  * **📝 Prerequisites:** Strictly requires an Entra ID P2 or Entra Suite license. Minimum administrative role is **Security Administrator**.
  * **🚨 Exam Traps:**
    * **The Remediation Prerequisite:** Users **must** be pre-registered for MFA *before* a risk event occurs to utilize automated self-remediation. If unregistered, they are completely blocked and require manual IT helpdesk intervention.
    * **The Security Defaults Trap:** Security defaults no longer offer a 14-day grace period. The 14-day grace period *only* applies to this specific ID Protection registration policy.

* **Adaptive Risk Remediation (Conditional Access)**
  * **Mechanics:** Configuring a policy to **Require risk remediation** creates a **dedicated, secure flow** that allows users to fix their compromised account without being impacted or blocked by other overlapping Conditional Access policies.
  * **Configuration Detail:** The system automatically hardcodes and applies two additional controls: **Require authentication strength** and **Sign-in frequency - Every time** to ensure immediate and secure reauthentication.
  * **Scenario Examples:**
    * **Password Users:** Forces a secure password change and instantly revokes previous compromised sessions.
    * **Passwordless Users:** Instantly revokes current active sessions and forces them to sign in and reauthenticate.
  * **🚨 Exam Traps:**
    * **Scope:** Explicitly remediates *User Risk*, not Sign-in Risk.
    * **Guest Limitations:** Cannot be used for external B2B guest users because Entra ID does not support session revocation for guests in a resource tenant. B2B users must perform remediation in their home directory.

##### **3. Common Risk-Based Conditional Access Policies (Implementation)**

* **Common User Risk Policies**
  * **High Risk Remediation (Microsoft Recommended):**
    * **Condition:** User risk level = High.
    * **Grant Control:** Require risk remediation.
    * **Session Control:** Sign-in frequency - Every time.
    * **Behavior:** Allows users to self-remediate. Password users must pass MFA and change passwords; passwordless users have sessions revoked and must reauthenticate.
  * **High Risk Block:**
    * **Condition:** User risk level = High.
    * **Grant Control:** Block access.
    * **Behavior:** Immediately stops access. User relies completely on IT intervention to regain access.
  * **Legacy "Require Password Change":**
    * **Condition:** User risk level = High.
    * **Grant Control:** Require password change.
    * **Behavior:** Forces the user to pass MFA and update their password. If "Require risk remediation" is also applied elsewhere, it takes precedence.

* **Common User Sign-In Risk Policies**
  * **Medium/High Risk MFA (Microsoft Recommended):**
    * **Condition:** Sign-in risk level = High and Medium.
    * **Grant Control:** Require authentication strength -> Multifactor authentication.
    * **Session Control:** Sign-in frequency - Every time.
    * **Behavior:** Challenges anomalous sign-ins with MFA. Automatically remediates the sign-in risk upon success, preventing it from aggregating into User Risk.
  * **Passwordless Sign-in Risk MFA:**
    * **Condition:** Sign-in risk level = High and Medium.
    * **Grant Control:** Require authentication strength -> Passwordless MFA or Phishing-resistant MFA.
    * **Behavior:** Tailored specifically for users who rely on FIDO2 or Windows Hello, ensuring the challenge meets modern passwordless standards.

* **🚨 Exam Traps & Configuration Prerequisites**
  * **The Combined Policy Trap:** You should **never** combine user risk and sign-in risk conditions into the exact same Conditional Access policy. Microsoft explicitly warns to create separate, dedicated policies for each risk type.
  * **Policy Exclusions (Major Trap):** You **must** manually exclude Emergency Access (break-glass) accounts and Service Accounts (e.g., Entra Connect Sync) from all risk-based policies to prevent tenant-wide lockouts.
  * **The Legacy Retirement Trap:** Legacy risk policies configured directly in the ID Protection blade are retiring on **October 1, 2026**. You must migrate all risk enforcement entirely to Conditional Access.
  * **Hybrid Remediation Prerequisite:** For on-premises synced users to successfully self-remediate User Risk, you must enable **Password Hash Synchronization (PHS)** and actively toggle the **"Allow on-premises password change to reset user risk"** setting.

##### **4. Risk Detection Event Types (Categorized by Risk Tier)**

Microsoft Entra ID Protection categorizes events into Sign-In Risk (probability the auth attempt is malicious), User Risk (probability the identity itself is compromised), and Workload Identity Risk (for non-human accounts).

* **Sign-In Risk Detections (Evaluates the specific authentication request)**
  * **Anonymous IP address:** Triggers on sign-ins from Tor browsers or anonymous VPNs. (*Real-time | Nonpremium*).
  * **Activity from anonymous IP address:** Discovered by Defender for Cloud Apps; users active from an IP identified as an anonymous proxy. (*Offline | Premium*).
  * **Unfamiliar sign-in properties:** Triggers on anomalous properties (IP, ASN, location, browser) compared to the user's past 30-day baseline. Drops users into a 5-day minimum "learning mode." (*Real-time | Premium*).
  * **Atypical travel:** Two sign-ins from geographically distant locations faster than physical travel allows. (*Offline | Premium*).
  * **Impossible travel:** Similar to atypical travel, but explicitly discovered via Microsoft Defender for Cloud Apps. (*Offline | Premium*).
  * **Password spray:** Attacker successfully validates a user's password using common passwords against multiple identities. (*Real-time or Offline | Premium*).
  * **Malicious IP address:** Sign-in from an IP with high failure rates due to invalid credentials. (*Offline | Premium*).
  * **Mass Access to Sensitive Files:** User accesses an uncommon number of files from SharePoint/OneDrive containing sensitive info. (*Offline | Premium*).
  * **Suspicious MFA authentication approval:** Anomalous MFA prompt approvals indicative of phishing, analyzing proximity of the requesting vs. approving device. (*Real-time | Premium*).
  * **Token issuer anomaly:** SAML token claims are unusual or match known attacker patterns indicating a compromised SAML token issuer. (*Offline | Premium*).

* **User Risk Detections (Evaluates the probability the overall identity is compromised)**
  * **Leaked credentials:** User's valid credentials appear in dark web forums, paste sites, or breach dumps. This is verified against current password hashes and is *always* High risk. (*Offline | Nonpremium*).
  * **User reported suspicious activity:** User denies an unprompted MFA challenge in the Authenticator app and explicitly clicks "Report suspicious activity." (*Offline | Premium*).
  * **Attacker in the Middle (AitM):** Authentication session is linked to a malicious reverse proxy intercepting credentials/tokens. (*Offline | Premium*).
  * **Possible attempt to access Primary Refresh Token (PRT):** Triggered via Defender for Endpoint when an attacker attempts to access the PRT JSON Web Token to move laterally. (*Offline | Premium*).
  * **Anomalous user activity:** Anomalous patterns of behavior, like suspicious changes to the directory by an administrative user. (*Offline | Premium*).
  * **Suspicious API Traffic:** Abnormal GraphAPI traffic or directory enumeration suggesting reconnaissance. (*Offline | Premium*).

* **Workload Identity Risk Detections (Service Principals / Applications)**
  * **Suspicious Sign-ins:** Sign-in properties unusual for the specific service principal (e.g., unfamiliar IP/ASN or target resource). (*Offline | Premium*).
  * **Leaked Credentials:** Valid app credentials (secrets) found checked into public GitHub repositories or breach dumps. (*Offline | Premium*).
  * **Suspicious API Traffic:** Abnormal GraphAPI traffic/reconnaissance by a service principal. (*Offline | Premium*).
  * **Malicious application:** App is disabled by Microsoft for violating Terms of Service. (*Offline | Premium*).
  * **Anomalous service principal activity:** Suspicious directory changes made by an administrative service principal. (*Offline | Premium*).

**📊 Comparison Table: Risk Detections Reference**

| Risk Type | Detection Example | Processing Latency | Primary Remediation |
| :--- | :--- | :--- | :--- |
| **Sign-in Risk** | Anonymous IP, Unfamiliar Properties | Real-time (5-10 min) | Standard MFA challenge |
| **Sign-in Risk** | Atypical Travel, Malicious IP | Offline (Up to 48 hours) | Standard MFA challenge |
| **User Risk** | Leaked Credentials, AitM | Offline (Up to 48 hours) | Secure Password Change (MFA + Reset) |
| **Workload Risk** | Suspicious API Traffic, Leaked Secrets | Offline (Up to 48 hours) | Manually rotate secrets, block CA policy |

##### **5. Administrative Risk Management & Log Diagnostics**

* **Manual Administrator Actions & Feedback Loops**
  * **Confirm user compromised:**
    * **Mechanics:** Elevates user risk to High, updates state to "Confirmed compromised", and adds an **"Admin confirmed user compromised"** detection to lock the user into the High risk bucket. Trains the ML algorithms and triggers automated User risk-based CA policies.
    * **📝 Prerequisites:** Administrator must be assigned at least the **Security Operator** role (Security Reader/Global Reader will see greyed-out buttons).
    * **🚨 Exam Trap:** Clicking this button does *not* automatically secure the account. You must manually reset the password or rely on a risk-based policy to enforce the block/reset.
  * **Dismiss sign-in risk (Benign True Positive):**
    * **Mechanics:** Acknowledges the risk was real but not malicious. Ensures similar sign-ins will continue being evaluated for risk.
    * **Scenario Example:** An analyst confirms a Tor browser alert was generated by an authorized penetration test.
  * **Confirm sign-in safe (False Positive):**
    * **Mechanics:** Tells the system it made a mistake (e.g., flagging a corporate VPN as an anonymous IP).
    * **🚨 Exam Trap:** Do not use this for penetration tests. It places the user in learning mode and teaches the algorithm that malicious traffic shouldn't be considered risky, degrading security.

* **System Log Terminology & States**
  * **"AI confirmed sign-in safe":** The system's machine learning automatically cleared the risk because the user successfully self-remediated (passed MFA/password reset) OR the system detected a false positive offline.
  * **"Admin dismissed..." / "Admin confirmed...":** A human manually intervened in the portal.
  * **"Remediated":** The *user* successfully cleared the risk themselves by satisfying a policy.
  * **"Dismissed":** An *administrator* manually intervened or the AI determined it was a false positive.

* **Data Retention & Age-Out Rules**
  * **Low Risk:** Automatically ages out and resolves after **six months** of no new risk elevations.
  * **Medium/High Risk:** Persists indefinitely until remediated by the user or manually dismissed by an admin.
  * **🚨 Exam Trap (Risk State vs. Log Retention):** The *Risk State* persists, but the raw *Log Data* does not. Default log retention for risky sign-ins is only **30 days** (P1) or **90 days** (P2). To keep data longer, export to an Azure storage account, Event Hub, or Log Analytics workspace.
  * **🔧 Troubleshooting Detail:** If a user account is deleted while having an active risk flag, they remain visible in the report as "At risk." Admins must open a Microsoft support case to remove them.

##### **6. Advanced Conditional Access Integrations**

* **Trusted Network Locations**
  * **Mechanics:** Administrators configure named locations (like corporate HQ or VPN IPs) and mark them as trusted.
  * **🚨 Exam Trap (Enforcement vs. Detection):**
    * **Conditional Access:** Uses trusted locations to aggressively **grant, bypass, or block** access.
    * **Entra ID Protection:** Uses trusted locations to tune machine learning algorithms, lower sign-in risk, and **reduce false positives**.
  * **Scenario Example:** An employee travels from New York to London but uses a corporate VPN. Entra ID Protection recognizes the trusted IP and actively suppresses the "Atypical travel" alert to prevent a false positive.

* **Suspicious Activity Reporting**
  * **Mechanics:** Replaces the legacy "MFA Fraud Alert". When a user clicks "Report suspicious activity" on an unprompted MFA push, it generates a `userReportedSuspiciousActivity` detection.
  * **📝 Licensing:** Requires Entra ID P2 to automatically enforce blocks or password resets via risk-based CA policies.
  * **🚨 Exam Traps:**
    * Reporting an MFA prompt elevates **User Risk** to High, not Sign-in Risk.
    * It does *not* automatically block the user unless an administrator has actively configured a CA policy to block or require remediation.

* **Emergency Access (Break-Glass) Accounts**
  * **Configuration Details:** Create at least two cloud-only `.onmicrosoft.com` accounts assigned the Global Administrator role. Credentials must never expire and must not be assigned to specific individuals.
  * **📝 Security Prerequisites:** Because they bypass policies, they must use passwordless **FIDO2 security keys** stored in fireproof safes. Configure Azure Monitor or Microsoft Sentinel to send immediate, high-priority alerts upon sign-in.
  * **🚨 Exam Traps:** They **must** be explicitly excluded from all risk-based and MFA Conditional Access policies to prevent accidental tenant-wide lockouts caused by misconfigurations or widespread cell-network outages. Even for automated "Microsoft-managed Conditional Access policies", admins must manually edit the policy to exclude them.

* **Simulating Risk for Testing**
  * **Anonymous IP (Easy):** Explicitly requires using the **Tor Browser** to navigate to the MyApps portal with a test account that is *not* yet registered for MFA.
  * **Unfamiliar sign-in properties (Moderate):** Requires a test account with **at least 30 days of sign-in history**. Change the OS/IP, navigate to MyApps, and intentionally **fail the MFA challenge**.
  * **Atypical travel (Difficult):** Requires a history of 14 days or 10 logins. Change user agent/IP, sign in, and repeat from a different location within minutes.
  * **Leaked Credentials (Workload):** Commit a valid App Registration secret string into a public `.txt` file on GitHub.
  * **Configuration Detail (Testing Workflow):** Configure the CA policy -> Simulate risk -> Wait 10-15 minutes for reports -> Turn CA policy to **On** to verify the block.

**📊 Comparison Table: Selecting the Right Investigation Tool**

| Diagnostic Tool | Primary Purpose | Key Visualizations |
| :--- | :--- | :--- |
| **Sign-in diagnostic tool** | Troubleshooting access blocks (MFA/CA interruptions) | ❌ No geographical maps |
| **Risky user details (Agent view)** | Investigating an individual user's identity risk | ✅ Map for a *specific user* (7-day trend) |
| **Dashboard Risk Map** | Investigating tenant-wide risk distribution | ✅ Map for the *entire organization* |

##### **7. Authentication Methods & Migration**

* **Unified Authentication Methods Policy Migration**
  * **Mechanics:** Moving management from legacy MFA and SSPR menus to a single unified policy.
  * **Migration States:**
    * *Pre-migration:* New policy used for auth; legacy respected.
    * *Migration In Progress:* New policy used for auth/SSPR; legacy respected.
    * *Migration Complete:* Entra ID completely ignores legacy settings and strictly follows the unified policy.
  * **🚨 Exam Traps:**
    * Selecting "Migration Complete" manages the *methods* (like SMS/FIDO2); it does *not* mean deleting your Conditional Access enforcement policies.
    * Security Questions are not yet in the unified policy and temporarily remain in the legacy SSPR menu.

* **External Multifactor Authentication (EAM)**
  * **Mechanics:** Replaces legacy "Custom Controls". Integrates third-party MFA providers via OIDC. Managed under Authentication methods > Policies.
  * **The Benefit:** EAM perfectly satisfies Entra ID's native MFA claims, allowing users to **automatically remediate sign-in risk** using a third-party provider (which Custom Controls could never do).
  * **🚨 Exam Trap (Incompatibility):** EAM satisfies the standard "Require multifactor authentication" grant, but it is currently **incompatible with Authentication Strengths**. You cannot use an external MFA method to satisfy a strict "Phishing-resistant MFA" requirement.

##### **8. Securing Workload Identities**

* **Risk Detections for Non-Human Accounts**
  * **Mechanics:** Workload identities (service principals) cannot perform MFA, often have no formal lifecycle, and rely on stored secrets. Because they cannot perform MFA, they **cannot self-remediate**.
  * **🔧 Troubleshooting Details:** To investigate, review the **Risky workload identities** report for suspicious IPs, unauthorized changes to credentials, or unauthorized app role acquisitions.
  * **Remediation & Configuration:** Because self-remediation is impossible, admins must manually remove compromised credentials, rotate Azure KeyVault secrets, or disable the service principal. Administrators *can* use Conditional Access to automatically enforce a **Block access** control for risky workloads.

## Plan, implement, and manage Microsoft Entra Conditional Access

##### **1. Conditional Access (CA) Architecture & Evaluation Engine**

* **The Two-Phase Evaluation Engine**
  * **Phase 1: Collect Session Details (The Setup)**
    * **Mechanics:** Gathers network location, device identity, and risk levels before taking action.
    * **Scope:** Evaluates **both enabled policies and policies in report-only mode**.
    * **Scenario Example:** An admin places a strict device compliance policy in report-only mode. During Phase 1, Entra ID evaluates an unmanaged iPad sign-in and logs that it *would* have failed, without actually blocking the user.
  * **Phase 2: Enforcement (The Mechanics)**
    * **Mechanics:** Identifies requirements the user has not yet met based on Phase 1 data.
    * **Scope:** Runs **only for enabled policies**.
    * **The "Block" Override:** If any applicable policy is configured with a **Block access** grant control, Phase 2 evaluation stops immediately, and the user is instantly blocked.
    * **🚨 Exam Traps (Report-Only):** Report-only mode bypasses Phase 2 enforcement completely. Therefore, interactive grant controls (like an MFA prompt or a Terms of Use agreement) are *never* presented to the user during a report-only evaluation. The sign-in log simply reads "Report-only: User action required".
  * **The Hardcoded Prompt Order**
    * **Configuration Detail:** Users are prompted for missing requirements in a strict, unchangeable sequence. Entra ID will not randomly prompt for a Terms of Use before MFA.
    * **Order:**
            1. Multifactor authentication
            2. Device to be marked as compliant
            3. Microsoft Entra hybrid joined device
            4. Approved client app
            5. App protection policy
            6. Password change
            7. Terms of use
            8. Custom controls
    * **🚨 Exam Traps (Session Controls):** Session controls (like Persistent Browser Sessions or Defender for Cloud Apps) are evaluated **last**, only *after* all Phase 2 grant controls are satisfied. If a user fails the initial MFA prompt, they will never reach the session control evaluation.

* **Policy Aggregation & Boolean Logic**
  * **Across Multiple Policies (The AND Logic):**
    * If multiple Conditional Access policies apply to a single sign-in, **all applicable policies must be satisfied**. They are combined using a strict **Logical AND** operation.
    * **Scenario Example:** Policy A requires MFA. Policy B requires a Compliant Device. The user is forced to satisfy *both*.
    * **Conflict Resolution:** If policies conflict, the **most restrictive** policy always wins (e.g., if one policy audits a download and another blocks it, the download is blocked).
  * **Within a Single Policy:**
    * **Require all the selected controls:** Establishes a strict **AND** relationship (This is the default setting).
    * **Require one of the selected controls:** Establishes an **OR** relationship.
    * **Scenario Example (The Device Fallback):** An admin selects "Require Compliant Device" and "Require MFA", then sets the toggle to "Require one". A user on a secure corporate laptop gains seamless access without an MFA prompt. If that same user signs in from a personal iPad, the policy dynamically prompts them for MFA instead.

* **Policy Optimization & Tenant Limits**
  * **📝 Prerequisites & Limits:** Microsoft Entra ID enforces a hard limit of **195 Conditional Access policies per tenant**. This limit includes policies in *all* states (Report-only, On, or Off).
  * **Application Limits:** A single policy can explicitly target a maximum of **250 applications**.
  * **Configuration Details (Scaling):**
    * Group applications with identical requirements into a single policy under the **Target resources** assignment.
    * To bypass the 250-app limit, use **Custom security attributes** (e.g., `policyRequirement = requireMFA`) as a "Filter for applications".
    * Use the **All resources** (formerly 'All cloud apps') baseline target to ensure no newly onboarded application is ever left unprotected.

**📊 Comparison Table: Aggregation Logic & Overrides**

| Configuration Type | Logic Applied | Outcome if User Fails One Requirement | Override Rule |
| :--- | :--- | :--- | :--- |
| **Multiple overlapping policies** | Strict **AND** | Access is **Denied**. | A single "Block" in *any* policy overrides all grants. |
| **Single policy ("Require all")** | Strict **AND** | Access is **Denied**. | Default setting when multiple boxes are checked. |
| **Single policy ("Require one")** | **OR** | Access is **Granted** (remaining controls skipped). | Highly recommended for Mobile App Protection (MAM). |

##### **2. Advanced Conditional Access Conditions & Controls**

* **Persistent Browser Sessions**
  * **Mechanics:** Drops a persistent cookie into the browser, maintaining the session even after the application window is closed.
  * **Configuration Details:** Overrides and automatically hides the default Microsoft Entra "Stay signed in?" prompt, making persistence seamless.
  * **📝 Licensing:** Strictly requires **Microsoft Entra ID P1 or P2**. Tenants with basic Microsoft 365 Apps licenses must rely on the manual "Show option to remain signed in" branding setting.
  * **🚨 Exam Traps:**
    * **The Target Prerequisite:** You **must** target **"All Cloud Apps"** (All resources). Targeting individual apps (like Exchange Online) will fail because browser persistence is tied to a single authentication session token shared across all tabs.
    * **Unmanaged Device Strategy:** Setting this to **"Never persistent"** is the recommended strategy for protecting personal/unmanaged devices.
    * **AD FS Interaction:** Microsoft Entra ID will honor and persist sessions if persistence is configured within AD FS single sign-on settings.

* **Filter for Devices (Securing Admin Workstations)**
  * **Mechanics:** Uses extension attributes (`extensionAttribute1` - `15`) to target or exclude specific hardware.
  * **Scenario Example (SAWs):** IT tags physical Secure Admin Workstations with `extensionAttribute1 -eq "SAW"`. A CA policy targeting the Azure Management API is set to **Block** access, but **Excludes** filtered devices where `extensionAttribute1` matches "SAW".
  * **📝 Prerequisites:** For the filter to evaluate properly, the device **must** be Microsoft Intune managed, compliant, or Microsoft Entra hybrid joined.
  * **🚨 Exam Traps:**
    * **Mutually Exclusive:** Cannot be used together with the legacy "Device state" condition in the same policy.
    * **Unregistered Device Trap:** Unregistered devices evaluate all properties as **null**. Always use negative operators (`-ne`, `-notIn`) when attempting to target unregistered devices.
    * **Rule Limits:** The absolute maximum length for the filter rule is **3072 characters**.

* **Authentication Context (Step-Up Authentication)**
  * **Mechanics:** Triggers a mid-session Conditional Access evaluation for sensitive actions/data, rather than at the initial sign-in "front door".
  * **Supported Integrations:** SharePoint site collections, Microsoft Defender for Cloud Apps, custom LOB apps, and **Privileged Identity Management (PIM)**.
  * **Configuration Details (PIM):** Forces an admin to satisfy a strict policy (e.g., Phishing-resistant MFA) *during* the role activation process.
  * **🚨 Exam Traps:**
    * **Setup Order:** You **must** create and enable the Conditional Access policy for the auth context *before* configuring it inside the PIM role settings. If PIM is configured first, a backup protection mechanism defaults to standard Azure MFA.
    * **Reauthentication Windows:** Using the session control **Require reauthentication every time** forces the admin to fully reauthenticate to activate the role, which then grants a **10-minute window** to activate subsequent eligible roles without another prompt.

* **Conditional Access Templates**
  * **Configuration Details:** Templates automatically default to **Report-only** mode.
  * **The Safety Mechanism:** The template wizard automatically hardcodes the "Current user" (the admin creating the policy) into the **Excluded users** list.
  * **🚨 Exam Traps:** You cannot modify or remove this exclusion during the initial creation wizard. You must open the policy *after* creation to manually add your Emergency Access (Break-Glass) accounts to the exclusion list, and manually remove your own account if the policy should apply to you.

##### **3. Risk Management & Identity Protection (P2 Features)**

* **Risk Types & Self-Remediation**
  * **📝 Licensing:** Using "User risk" or "Sign-in risk" as Conditional Access conditions strictly requires a **Microsoft Entra ID P2** or Entra Suite license.
  * **Sign-in Risk:** The probability that a specific authentication request is illegitimate (e.g., Tor browser, atypical location).
    * **Self-Remediation:** Configure the policy to prompt the user for **multifactor authentication (MFA)**.
  * **User Risk:** The probability that the overall identity is compromised (e.g., leaked credentials found on the dark web).
    * **Self-Remediation:** Configure the policy to force a **secure password change** (User passes MFA, then resets password).
  * **🚨 Exam Traps:**
    * **The Combined Policy Trap:** Never combine Sign-in risk and User risk into the exact same Conditional Access policy. Microsoft explicitly requires separate, dedicated policies for each.
    * **The MFA Prerequisite:** Users **must** be pre-registered for MFA before the risk event occurs. If they trigger a risk policy without prior MFA registration, they are completely blocked and require manual IT intervention.
    * **Guest User Limitations:** Risk policies evaluate B2B guests in their *home* directory. You cannot force a secure password reset for a guest in your resource tenant. Microsoft recommends explicitly excluding guests from risk-based policies.

* **Resilience Defaults & Backup Authentication Service**
  * **Mechanics:** The Backup Authentication Service kicks in automatically during primary cloud outages, reissuing tokens strictly for **existing sessions**.
  * **The Vulnerability:** During an outage, the backup service cannot cryptographically evaluate real-time auth strengths (like FIDO2) or group/role memberships.
  * **Resilience Defaults ENABLED (Availability):** Uses previous session data. If the user previously used SMS, they will not be prompted for their FIDO2 key during an outage.
  * **Resilience Defaults DISABLED (Security):** If real-time conditions cannot be evaluated, access is strictly denied. Must be used to secure highly privileged portals.
  * **🚨 Exam Traps:**
    * **The Group Assignment Trap:** Disabling resilience defaults for a policy applied to a *group or role* reduces resilience for **all users in the tenant**, because group membership evaluation fails entirely during outages. Always apply strict "disabled resilience" to individual users.
    * **Mutually Exclusive Controls:** You cannot check both "Require multifactor authentication" and "Require authentication strength" in the same policy.
    * **Unsupported Scenarios:** Does not support new sessions or authentications by Guest users.

**📊 Comparison Table: Microsoft Entra Risk Types**

| Risk Type | Evaluates | Triggers | Required Self-Remediation |
| :--- | :--- | :--- | :--- |
| **Sign-in Risk** | The specific authentication request | Atypical location, anonymous IP, Tor browser | **Multifactor Authentication (MFA)** |
| **User Risk** | The overall identity compromise | Leaked credentials found on the dark web | **Secure Password Change (MFA + Reset)** |

##### **4. Continuous Access Evaluation (CAE) & Network Enforcement**

* **CAE Mechanics & Token Lifetimes**
  * **Mechanics:** Upgrades static 1-hour access tokens to **28-hour** tokens, relying on a near real-time pub/sub "conversation" between Entra ID and resource providers.
  * **The 401+ Claim Challenge:** If a user triggers a violation (e.g., flies to London and changes IP), the resource provider rejects the 28-hour token and sends a **`401+` claim challenge**. The CAE-capable client sends this challenge back to Entra ID, which reevaluates the policy and officially blocks the session.
  * **Supported Revocation Events:** User deleted/disabled, password changed/reset, MFA enabled, high user risk detected, or manual token revocation.
  * **🚨 Exam Traps:** Requires a CAE-capable client application. Non-capable legacy apps fall back to traditional 1-hour access tokens. CAE does **not** support Guest users.

* **IP Mismatches & Strict Location Policies**
  * **Mechanics:** Cloud proxies, SSEs, and split tunneling often cause the egress IP seen by Entra ID to differ from the IP seen by the resource provider.
  * **The XFF Header Trap:** Microsoft Entra ID intentionally **ignores the X-Forwarded-For (XFF) header** during policy evaluation because it can be easily spoofed by attackers.
  * **🔧 Troubleshooting Details:** To find routing discrepancies, check the sign-in log for **"IP address (seen by resource)"**. If blank, the IPs match. If populated, a mismatch occurred.
  * **Configuration Details (The Solution):** Deploy **Global Secure Access** and enable **Source IP restoration** to securely pass the original egress IP to Entra ID and Graph.
  * **🚨 Exam Traps (Strict Location Enforcement):** To override CAE's default fallback behavior (which suppresses real-time IP checks during a mismatch), admins can enable the **Strictly enforce location policies** session control. *Trap:* If you enable this control before fixing IP mismatches or adding proxy IPs to named locations, users will be catastrophically locked out.

##### **5. Securing AI Workloads (Agent Identities)**

* **Microsoft Entra Agent ID Architecture**
  * **Agent blueprint:** A logical definition/template of the agent type.
  * **Agent identity blueprint principal:** The service principal that executes the creation of the identities.
  * **Agent identity:** The instantiated AI agent that actually performs tasks, requests tokens, and accesses resources.
  * **Agent user:** A nonhuman identity used when the agent requires a mailbox or Teams presence.

* **Agent-to-Agent (A2A) Flows & Conditional Access**
  * **Mechanics:** Autonomous agents operate without a human user, utilizing the **client credentials flow**. The issued access token's subject is strictly the agent identity.
  * **Configuration Details:** To protect an agent acting as a destination resource, select **All agent resources (Preview)** in the Target resources assignment.
  * **Configuration Details (Custom Security Attributes):** To block all agents except approved ones:
        1. Create a custom attribute (`AgentApprovalStatus = HR_Approved`) and assign it to approved agents.
        2. Target **All agent identities** in the CA policy.
        3. Exclude **Select agent identities based on attributes** where `AgentApprovalStatus` contains `HR_Approved`.
        4. Set Grant Control to **Block**.
  * **📝 Prerequisites & Licensing:** Agents do not require standalone licenses; they are covered under the human user's Microsoft 365 E7 / Agent 365 license. Enforcing Conditional Access on them requires Entra ID P1.
  * **🚨 Exam Traps:**
    * **Blueprint Trap:** Agent blueprints *cannot* access resources; only the agent identity can. However, targeting a blueprint in a policy automatically covers all identities created by it.
    * **RBAC Trap:** Global Administrators do *not* have permissions to manage custom security attributes by default. A user must be explicitly assigned the **Attribute Definition Administrator** and **Attribute Assignment Administrator** roles.
    * **Data Type Trap:** Conditional Access filters strictly require custom security attributes of type **String** (Boolean is not supported).

##### **6. Application Management & Registration Policies**

* **Mobile Application Management (MAM) vs MDM**
  * **Mechanics:** App protection policies secure corporate data within specific applications (preventing copy/paste, requiring a PIN) without requiring full Mobile Device Management (MDM) enrollment.
  * **Broker App Requirements:** To enforce MAM, the device must be **registered** in Entra ID using an authentication broker app.
    * **Android Brokers:** Company Portal app OR Microsoft Authenticator app.
    * **iOS/iPadOS Brokers:** Strictly the Microsoft Authenticator app.
  * **User Experience:** If the broker is missing when accessing a protected app, the user is redirected to the app store to install it.
  * **🚨 Exam Traps:** Do not confuse registration with enrollment. App Protection requires device *registration* via the broker, not full *enrollment* into Intune MDM.

* **Security Information Registration**
  * **Configuration Details:** Target the **"Register security information"** User action to treat the MFA/SSPR portal as a highly sensitive application. Set locations to **Include** *Any location* and **Exclude** *All trusted locations*.
  * **Scenario Example:** Issue a **Temporary Access Pass (TAP)** to allow remote users to securely bypass the location requirement and register passwordless credentials from home.
  * **🚨 Exam Traps:**
    * **The Guest Trap:** Exclude **'All guest and external users'** from primary registration policies, as guests will never connect from your internal trusted network. TAPs do **not** work for guest users.
    * **The MSA vs Google Trap:** If you apply a registration policy to guests, guests with Microsoft personal accounts (MSA) will be forced to register. Guests with Google accounts will simply be blocked.
    * **Emergency Accounts:** Always exclude your Break-Glass emergency accounts to prevent accidental lockout.

##### **7. Administrative Security & B2B Collaboration**

* **Windows Azure Service Management API**
  * **Mechanics:** An umbrella cloud application that enforces policies for tokens issued to the Azure Resource Manager (ARM) backend.
  * **Coverage:** Protects the Azure portal, Microsoft Entra admin center, Azure CLI, Azure PowerShell, Azure Data Factory, and Azure SQL Database.
  * **Configuration Details:** Highly recommended to target this app and require MFA to prevent attackers from manipulating tenant-wide configurations or subscription billing. Always exclude emergency (break-glass) accounts.
  * **🚨 Exam Traps:**
    * **PowerShell Trap:** Protects Azure PowerShell, but explicitly **does not apply to Microsoft Graph PowerShell**.
    * **DevOps Trap:** No longer covers Azure DevOps.
    * **Sovereign Clouds Trap:** For Azure Government environments, target the **Azure Government Cloud Management API** app instead.

* **Cross-Tenant MFA Trust (B2B Collaboration)**
  * **The Problem:** Default policies force external users to redundantly register for MFA in your resource tenant, causing MFA fatigue.
  * **Configuration Details:** Use **Cross-tenant access settings** to explicitly trust MFA claims originating from the external partner's home Microsoft Entra organization.
  * **Mechanics:** Entra ID checks the incoming authentication session for a specific claim proving MFA was fulfilled in the home tenant, granting seamless access.
  * **🚨 Exam Traps:**
    * **Trusting Devices:** You can also configure Cross-tenant access settings to trust **compliant device claims** and **Microsoft Entra hybrid joined claims** from partners. This is the *only* way a guest can satisfy a device compliance policy.
    * **Cross-Tenant vs. External Collaboration:** Cross-tenant settings control authentication trusts and app access. **External collaboration settings** strictly control *who* in your organization is allowed to send B2B invitations.
    * **Auth Strengths:** Cross-tenant MFA trust works in tandem with Conditional Access Authentication Strengths to dictate exactly which external authentication methods are accepted.

* **Role-Based Access Control (RBAC) Least Privilege**
  * **Security Reader:** The absolute minimum, least privileged role required to view the Conditional Access Overview page and Entra ID Protection risk reports.
  * **Conditional Access Administrator:** The least privileged role required to actively create, modify, delete, or manage CA policies, named locations, and custom controls.
  * **🚨 Exam Traps:** "Global Administrator" and "Global Reader" are frequent distractor answers. While they have access, they violate the principle of least privilege due to their massive scope across all M365 services. Always select the service-specific or security-specific role.

## Plan, implement, and manage Microsoft Entra user authentication

##### **Authentication Methods & Credentials**

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

##### **Conditional Access, Risk & MFA Management**

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

##### **Tokens, Identity Mechanics & Access Revocation**

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

##### **Kerberos & Application Integrations**

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

##### **Governance & Administration**

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

## Implement Global Secure Access

### Deploy and manage Internet Access for Microsoft 365

#### SC-300 Study Review Sheet: Deploy and Manage Microsoft 365 Access

**I. Licensing, Capacity & Prerequisites**

* **Remote Network (Branch) Licensing Threshold**
  * *Requirement:* A minimum of **50 combined licenses** (Entra ID P1, Entra Internet Access, or Entra Suite) is required to unlock remote network features.
  * *Bandwidth Allocation:* 50–99 licenses grants a baseline pool of **500 Mbps**. This scales up to **35,000 Mbps** for 10,000+ licenses.
  * *Configuration Detail:* Bandwidth is distributed to individual IPsec tunnels in fixed increments of **250, 500, 750, or 1,000 Mbps**.
* **Source IP Restoration Prerequisites**
  * *Requirement:* Requires **Microsoft Entra ID P1**.
  * *Configuration Detail:* Enabled globally via "Enable Global Secure Access signaling in Conditional Access" under Adaptive Access. For tenants enabling GSA after June 2025, this is on by default.

**II. Profile Architecture & Routing Precedence**

* **Strict Evaluation Hierarchy**
  * **1. Microsoft traffic profile (High)**
  * **2. Private access profile (Medium)**
  * **3. Internet access profile (Low)**
* **Workload Separation**
  * *Microsoft Profile:* Exchange Online, SharePoint Online, OneDrive, Teams, Office Online. Uses a dedicated, optimized tunnel gateway.
  * *Exam Trap:* **Azure Portal and Azure APIs** are managed by the Internet Access profile, NOT the Microsoft profile.
  * *Exam Trap:* **Entra ID logins and Graph API** are handled by the system-managed "Microsoft Entra traffic profile".
* **Exclusivity and Fallback Behavior**
  * *Rule:* Microsoft traffic is exclusive to its own profile.
  * *Exam Trap:* If a specific M365 destination is set to "Bypass" in the Microsoft profile, it will **not** fall back to the Internet Access profile. It bypasses GSA entirely and egresses via the local network.

**III. Security Controls & Compliant Networks**

* **Preventing "SSE Bypass"**
  * *Scenario Example:* A user pauses the GSA client to bypass corporate web filtering.
  * *Mitigation:* Create a Conditional Access policy blocking access to M365 from any network *except* a "Compliant Network" (a network verified as originating from your GSA tenant).
  * *Configuration Sequence:* **Include "Any Location"**, **Exclude "All Compliant Network locations"**, and **Grant "Block"**.
  * *Exam Trap:* Always exclude emergency "break-glass" accounts from this policy to prevent total tenant lockouts.
* **Defense Against Token Theft (Replay Attacks)**
  * *Mechanism:* If an attacker steals a valid session token, they will attempt to replay it from their own unmanaged machine.
  * *Result:* Entra ID evaluates the Compliant Network requirement and the Device ID binding. It immediately denies the access request because the attacker is not tunneling through your GSA instance.

**IV. Advanced Routing: BGP & Health Probes**

* **Autonomous System Numbers (ASN) for BGP Peering**
  * *Microsoft Gateway ASN:* Always uses **65476**.
  * *Customer Premises Equipment (CPE) ASN:* Must be a unique 2-byte value (e.g., **65533**).
  * *Exam Trap (The "Swap" Rule):* The ASN configured on your local router must be entered in the **Device ASN** field in the Entra portal, and Microsoft's ASN (65476) must be entered as the **Peer/Remote ASN** on your router.
  * *Configuration Detail:* Avoid reserved ASNs like 12076 or 8075.
* **IP SLA Layer 7 Health Probes**
  * *Purpose:* Verifies the remote network tunnel is actively processing M365 traffic, not just electrically connected (Layer 3).
  * *Endpoint:* Statically route the probe over the IPsec tunnel to **`198.18.1.101`** or `http://m365.remote-network.edgediagnostic.globalsecureaccess.microsoft.com:6544/ping`.
  * *Troubleshooting Detail:* If the Layer 7 probe fails, the router should be configured to automatically reroute traffic locally to preserve user productivity.

**V. Identity Visibility, Auditing & Graph API**

* **Purview Audit Log Enrichment**
  * *Supported Workloads:* Currently enriches **SharePoint Online** and **OneDrive** logs.
  * *Data Added:* Original Source IP, Device ID, OS, and verified Network Path.
  * *Configuration Detail:* Route `NetworkAccessTrafficLogs` and `OfficeActivity` to Log Analytics and visualize using the **Enriched Microsoft 365 Logs workbook**.
* **Microsoft Graph API (Beta)**
  * *Endpoint:* The Network Access API is currently strictly in the `/beta` namespace.
  * *Query:* Use `GET https://graph.microsoft.com/beta/networkaccess/forwardingprofiles` to list profiles.
  * *Exam Trap:* To see the actual rules inside a profile, you must append the **`$expand=policies`** OData parameter.

**VI. Comparison Tables**

**Table 1: Diagnostics Alerts: Inconsistency vs. Connectivity**

| Alert Type | Category | Trigger Cause | Primary Risk |
| :--- | :--- | :--- | :--- |
| **Token & Device Inconsistency** | **Security / Identity** | Session token used on a new/different Device ID. | **Token Theft / Replay Attack** |
| **Unhealthy Remote Network** | **Operational / Health** | BGP drop or broken IPsec tunnel to GSA edge. | **Loss of Connectivity** |

**Table 2: IP Visibility Mechanisms**

| Feature | Primary Purpose | How it Works |
| :--- | :--- | :--- |
| **Source IP Restoration** | Identity Protection & Auditing | Extracts and preserves the user's *original* public IP in Entra logs. |
| **Source IP Anchoring** | B2B / Legacy App Whitelisting | Routes traffic via a private connector so a 3rd-party SaaS app sees a *specific corporate IP*. |

**Table 3: Traffic Routing Profiles**

| Traffic Destination | Matching Profile | Precedence |
| :--- | :--- | :--- |
| **Exchange Online / Teams** | Microsoft Traffic Profile | **High** (Evaluated First) |
| **On-Premises File Share** | Private Access Profile | **Medium** (Evaluated Second) |
| **Azure Portal / General Web** | Internet Access Profile | **Low** (Evaluated Last) |

Would you like to move on to emergency "Break-Glass" account exclusions, or is there another SC-300 topic you'd like to dive into next?

### Deploy and manage Internet Access

#### SC-300 Study Review Sheet: Deploy and Manage Internet Access

**I. Infrastructure Prerequisites & Device Governance**

* **Device Join State (Windows)**
  * *Prerequisite:* Devices must be **Microsoft Entra Joined** or **Microsoft Entra Hybrid Joined** to support the Internet Access and Microsoft 365 traffic forwarding profiles.
  * *Reasoning:* The Internet Access tunnel requires specific device tokens tied to a managed tenant, and advanced features like DLP require this managed state. On Windows, Joined devices are hard-locked to the joined tenant to prevent circumvention.
  * *Exam Trap:* Microsoft Entra Registered (BYOD) Windows devices do **not** support Internet Access; they only support Private Access.
  * *Troubleshooting Detail:* Use the Advanced Diagnostics tool's Health Check tab. If "Device is Microsoft Entra joined" fails, the Internet tunnel will not establish.
* **Role-Based Access Control (RBAC) Separation**
  * *Global Secure Access Administrator:* Configures traffic forwarding profiles and defines the rules within Security Profiles.
  * *Conditional Access Administrator:* Creates Conditional Access (CA) policies to link/enforce the Security Profiles onto users.
  * *Exam Trap:* A Global Secure Access Admin cannot link a security profile to a user because they lack access to the Conditional Access blade.

**II. Traffic Prioritization & Protocol Handling**

* **Hardcoded Evaluation Hierarchy**
  * **1. Microsoft access profile:** Evaluated first (optimizes M365/identity traffic).
  * **2. Private access profile:** Evaluated second (captures internal corporate FQDNs/IPs).
  * **3. Internet access profile:** Evaluated last.
  * *Scenario Example:* If the Internet profile were evaluated first, it would accidentally "steal" traffic destined for optimized Private Access routes because Internet Access captures all broad port 80/443 traffic.
* **QUIC (UDP 443) Unsupported**
  * *Limitation:* GSA Internet Access does not support QUIC.
  * *Exam Trap:* The GSA client does not proxy or "convert" QUIC to TCP automatically.
  * *Configuration Detail:* Administrators must actively block outbound UDP 443 via Windows Firewall or browser registry (e.g., `QuicAllowed = 0`) to force browsers to automatically fall back to supported HTTPS over TCP.

**III. Security Profiles & CA Integration**

* **The Delivery Mechanism**
  * Security profiles hold the filtering rules but only execute when linked to the **Session** controls of a Conditional Access policy.
* **Evaluation Priority Logic ("First Match Wins")**
  * *Custom Security Profiles (Priority 100 - 64,999):* Linked via CA policies and evaluated first.
  * *Baseline Profile (Priority 65,000):* A tenant-wide catch-all evaluated last. It applies to all traffic automatically.
  * *Configuration Detail:* Maintain a priority gap of 100 (100, 200, 300) when numbering custom profiles so you can insert new rules later.
  * *Scenario Example:* You have a Baseline Profile blocking the "Gambling" category (Priority 65,000). You create a Custom Profile allowing specific gambling research sites for the Legal Team (Priority 100). The Custom Profile matches first, allows the traffic, and stops evaluation before hitting the baseline block.

**IV. Advanced TLS Inspection & SNI Filtering**

* **Server Name Indication (SNI)**
  * *Mechanism:* The default mechanism for HTTPS filtering. SNI is visible during the cleartext TLS handshake.
  * *Capability:* Exposes the FQDN (e.g., `youtube.com`) allowing immediate blocks without decryption.
  * *Exam Trap:* The Host header and full URL path (e.g., `youtube.com/shorts`) are hidden inside the encrypted HTTP payload and require TLS inspection to view.
* **TLS Inspection Architecture & Certificates**
  * *Architecture:* GSA uses a two-tier model. You provide a Customer-Signed Intermediate CA, and GSA dynamically generates short-lived leaf certificates for accessed websites.
  * *Certificate Requirements:* The uploaded intermediate certificate must include **Server Auth** (EKU), **critical** and **CA:TRUE** (Basic Constraints), and **keyCertSign/cRLSign** (Key Usage).
  * *Crucial Prerequisite:* The Root CA certificate used to sign the intermediate must be distributed to all client devices' Trusted Root Certification Authorities store via Intune to prevent browser warnings.

**V. Microsoft Entra AI Gateway & Coexistence**

* **Shadow AI Governance**
  * *Function:* Identifies unsanctioned generative AI tools and applies risk scores.
  * *Prerequisite Note:* **TLS inspection must be enabled** to perform advanced controls like blocking specific file type uploads (e.g., .pdf), Data Loss Prevention (DLP) scanning on prompts, and prompt injection protection.
* **Resolving SSE Routing Conflicts (Tunnel-in-Tunnel)**
  * *Issue:* Running the GSA Lightweight Filter (LWF) driver alongside 3rd-party SSEs (like Zscaler) causes a routing loop.
  * *Configuration Detail:* Implement two-way Custom Bypasses. Add 3rd-party SSE gateways to the GSA bypass list, and add GSA Anycast/`6.6.0.0/16` IPs to the 3rd-party bypass list.
* **Intune Circular Dependency**
  * *Scenario Example:* A CA policy blocks non-compliant devices. A non-compliant device needs GSA Internet access to reach Intune to become compliant, creating a loop.
  * *Configuration Detail:* Add a Custom Bypass for Intune endpoints (e.g., `*.manage.microsoft.com`) so compliance traffic always egresses locally.

**VI. Comparison Tables**

**Table 1: Windows Device State Support**

| Feature | Entra Joined / Hybrid Joined | Entra Registered (BYOD) |
| :--- | :--- | :--- |
| **Internet Access** | **Supported** | **Not Supported** |
| **M365 Access** | **Supported** | **Not Supported** |
| **Private Access** | Supported | Supported |

**Table 2: RBAC Role Duties**

| Task | Global Secure Access Admin | Conditional Access Admin |
| :--- | :--- | :--- |
| **Manage traffic forwarding profiles** | **Yes** | No |
| **Configure security profiles** | **Yes** | No |
| **Create CA policies to link profiles** | No | **Yes** |

**Table 3: Dashboard Reporting Widgets**

| Feature | Usage Profiling | Web Category Filtering |
| :--- | :--- | :--- |
| **Primary Goal** | Monitor volume/patterns. | Identify content types accessed. |
| **Data Shown** | Bytes, User counts. | Categories (e.g., Gambling). |

**Table 4: SNI vs TLS Inspection Visibility**

| Metric | SNI (Default) | TLS Inspection Enabled |
| :--- | :--- | :--- |
| **Location** | TLS Handshake (Cleartext) | HTTP Request Payload |
| **Visible Data** | FQDN (e.g., `bing.com`) | Full URL, Host Header, Files |

I can compile this sheet into a standalone Tailored Report artifact for your Notebook, or we can move on to the next topic like Remote Network (Branch) routing and BGP configurations.

### Deploy and manage Private Access

#### SC-300 Study Review Sheet: Deploy and Manage Private Access

**I. Infrastructure Prerequisites & Licensing Configuration**

* **Microsoft Entra Private Network Connectors**
  * **Architectural Baseline:** Version 1.5.3417.0 is the minimum required. It acts as a stateless, outbound bridge.
  * **OS & Software:** Requires Windows Server 2016+. As of version 1.5.3437.0, .NET 4.7.1+ is mandatory, but .NET 4.7.2+ is recommended.
  * **Network Requirements:** Must reach Microsoft endpoints (`*.msappproxy.net`, `*.servicebus.windows.net`) outbound over TCP ports 80 and 443.
  * **TLS Configuration:** TLS 1.2 is mandatory.
    * *Configuration Detail:* Disable inline SSL inspection or termination for these outbound connections, as it breaks the required certificate-based authentication.
  * **High Availability:** Always deploy at least two connectors per connector group. The "updater service" automatically applies patches, and having two prevents traffic drops during updates.
* **External Tenant Access (B2B/Guest Access)**
  * **Client Configuration:** Enable via the `GuestAccessEnabled` registry key (`REG_DWORD` = `0x1`) at `HKEY_LOCAL_MACHINE\Software\Microsoft\Global Secure Access Client`.
  * **Context Switching:** When a user switches to a partner tenant, all tunnels to their home tenant (M365, Internet, Private) immediately disconnect, and a dedicated Private Access tunnel opens to the resource tenant.
  * *Exam Trap (Licensing):* The user's *home* organization does NOT need a Global Secure Access license (Entra Free is sufficient).
  * *Prerequisite Note:* The *resource* tenant must have Private Access enabled, explicitly assign the guest user to an app/profile, and link an Azure subscription. The standard 50k free P1/P2 MAU allowance does not apply to GSA guests.

**II. Application Segments & Network Traffic Routing**

* **Defining Application Segments**
  * **Required Fields:** Destination (FQDN, IP address, or CIDR range), Port, and Protocol (TCP, UDP, or Both).
  * **Limits:** An Enterprise application supports a maximum of 500 individual application segments.
* **Overlapping Segments & Precedence Logic**
  * **General Rule:** Overlapping segments (exact same destination, port, and protocol) are generally blocked within or between Enterprise Apps.
  * **The Quick Access Exception:** Quick Access uses broad network ranges (e.g., `10.0.0.0/16`) to act as a VPN replacement.
  * **Precedence Hierarchy:** If an Enterprise App (e.g., `10.1.1.5:22`) overlaps with a Quick Access subnet (`10.1.1.0/24`), the **Enterprise application ALWAYS takes priority**. Traffic is evaluated against the Enterprise App's CA policies and never hits Quick Access.
* **Application Discovery Integration**
  * **Mechanism:** Monitors broad Quick Access traffic to discover specific 5-tuples (Destination, Protocol, Port, User, Device).
  * *Prerequisite Note:* Requires 10–15 minutes of active usage through Quick Access before telemetry populates the 30-day historical window.
  * *Exam Trap (Migration):* Moving a discovered segment from Quick Access to an Enterprise App does NOT automatically migrate user assignments. Users will be blocked until explicitly assigned to the new granular app.
  * *Configuration Detail:* Allow 15 minutes for routing/segment changes to synchronize with GSA clients.

**III. Advanced DNS Mechanics & Synthetic IP Addressing**

* **FQDN Interception and DNS Rewriting**
  * **The Process:** The GSA client intercepts a local DNS query for an FQDN, sends it to the GSA edge DNS proxy, which resolves the internal IP via the on-premises connector.
  * **The "Magic IP":** The client rewrites the DNS response, handing the calling application a **Synthetic IP** from the `6.6.0.0/16` range.
  * **Traffic Steering:** When the app connects to the `6.6.x.x` address, the LWF driver steers it into the tunnel.
  * *Scenario Example:* Essential for Azure PaaS (like Storage Accounts) behind Private Link, where dynamic IPs change but FQDNs remain static.
* **Single-Label Domains (SLD)**
  * **Resolution:** For short names (e.g., `benefits`), an NRPT entry directs queries ending in `globalsecureaccess.local` to the GSA DNS proxy to ensure successful resolution.

**IV. Active Directory Protection & Intelligent Local Access (ILA)**

* **Private Access Sensors (Kerberos Protection)**
  * **Purpose:** Enforces Conditional Access and MFA on legacy Kerberos authentications.
  * **Installation:** Installed directly on Active Directory Domain Controllers.
  * **Identity Flow:** The Private Network Connector acts as a bridge, verifying identity by communicating with the Sensor over **inbound TCP port 1337** on the DC.
  * *Configuration Detail:* Administrators must manually add the connector IPs to the `SourceIPAllowList` in the DC's `localpolicy.json`.
  * *Exam Trap:* Do not confuse the Sensor (identity verification on a DC) with an IPSec tunnel/CPE router (network transit for a branch office).
* **Intelligent Local Access (ILA)**
  * **Mechanism:** Uses a **DNS probe** targeting a specific FQDN.
  * **Behavior:** If the query resolves to a predefined internal IP range, the client knows it is on the corporate network and **bypasses the cloud backend**, routing traffic locally.
  * *Exam Trap:* ILA does NOT use GPS or geofencing. Furthermore, even when traffic routes locally, Conditional Access policies still apply.

**V. Migration & Client Coexistence**

* **LWF Driver Architecture**
  * **Mechanism:** Uses a Lightweight Filter (LWF) driver rather than a virtual VPN adapter. This allows side-by-side coexistence with third-party VPNs without "tunnel wars".
  * *Configuration Detail (Bypasses):* To coexist with a 3rd-party VPN, you must configure the legacy VPN to **bypass the 6.6.0.0/16 synthetic IP range**.
* **DirectAccess Migration Blocking**
  * *Exam Trap:* DirectAccess and Private Access **cannot be active simultaneously**. DirectAccess device tunnels establish at boot and take precedence, blocking GSA.
  * *Troubleshooting Detail:* You must fully clear the DA state—often requiring **two system reboots** after removing the computer from the DA security group—before enabling the Private Access forwarding profile.

**VI. Troubleshooting via Advanced Diagnostics**

* **Launch:** Right-click the GSA system tray icon -> Advanced Diagnostics.
* **Hostname Acquisition Tab:** Shows the requested FQDN, the Generated Synthetic IP (`6.6.x.x`), and the Original Internal IP. Crucial for troubleshooting FQDN tunneling.
* **Traffic Tab:** Displays live captures. Verify the *Action* (Tunnel, Bypass, Block) and the *Protocol* (TCP/UDP).
* **Forwarding Profile Tab:** Contains a **Policy tester** to check which rule applies to a destination and shows rule Priority.

**VII. Comparison Tables**

**Table 1: Port and Protocol Requirements**

| Component | Port | Protocol | Direction | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Private Access Sensor** | 1337 | TCP | Inbound | Receives identity validation requests from the Connector. |
| **Private Access Sensor** | 443 | TCP | Outbound | Registers the sensor and fetches cloud policies. |
| **Private Network Connector**| 80/443 | TCP | Outbound | Bridges internal resources to the GSA service edge. |
| **App Segment (SSH)** | 22 | TCP | N/A | Defined in Entra to capture secure shell traffic. |
| **App Segment (Kerberos)** | 88 | UDP/TCP | N/A | Defined in Entra for DC locator services. |

**Table 2: Protocol Support by Profile**

| Service Profile | Supported Protocols | Key Details |
| :--- | :--- | :--- |
| **Private Access** | TCP and UDP | Essential for legacy apps, RDP, SMB, and UDP-based Kerberos. |
| **Internet Access** | Primarily TCP | Does not support QUIC (UDP 443). Firewalls must block UDP 443 to force fallback to HTTPS/TCP. |

**Table 3: Overlap & Routing Precedence**

| Segment Type | Routing Priority | CA Policy Applied | Migration Impact |
| :--- | :--- | :--- | :--- |
| **Quick Access (e.g., 10.1.1.0/24)** | Low | Broad VPN-replacement policy. | Feeds telemetry to App Discovery. |
| **Enterprise App (e.g., 10.1.1.5:3389)** | High | Specific per-app policy. | Requires explicit user assignment. |

Would you like to review the specific Conditional Access "Compliant Network" break-glass procedures next, or focus on Microsoft 365 traffic routing?

### Deploy Global Secure Access clients

#### SC-300 Study Review Sheet: Deploy Global Secure Access clients

**I. Prerequisites, Licensing, & Device Identity States**

* **Windows Hardware & OS Requirements**
  * *Supported Versions:* 64-bit Windows 10 LTSC 2021 or newer, Windows 11 (64-bit), or Windows 11 on Arm64.
  * *Virtualization Trap:* Azure Virtual Desktop (AVD) supports single-session only; multi-session is explicitly unsupported.
  * *Hardware Restriction:* The client cannot be installed on a physical host currently hosting VMs through a Hyper-V external virtual switch.
* **macOS Requirements**
  * *Supported Versions:* macOS 14 (Sonoma) or later.
  * *Hardware:* Intel or Apple Silicon (M1–M4).
  * *Identity Prerequisite:* The device must be registered to an Entra tenant via the Company Portal app before installation.
* **Device Identity States & Traffic Support**
  * *Entra Joined / Hybrid Joined:* Supports all traffic forwarding profiles (Microsoft 365, Internet Access, Private Access). The client strictly connects to the tenant the device is joined to.
  * *Entra Registered (BYOD / Unmanaged):* Unmanaged Windows devices automatically register upon the first user sign-in to the GSA client. If the user has multiple registered tenants, they will be prompted to select one.
  * *Exam Trap:* Registered (BYOD) devices currently **only support Private Access traffic**. They will not tunnel general internet or M365 traffic.

**II. Windows Client Deployment & Intune Configuration**

* **Intune Win32 App Packaging**
  * *Deployment Type:* Must be packaged as an `.intunewin` file and deployed as a Windows app (Win32).
  * *Installation Command:* `powershell.exe -ExecutionPolicy Bypass -File [YourScriptName].ps1`.
* **Mandatory Detection Rules**
  * *Path:* `C:\Program Files\Global Secure Access Client\TrayApp`.
  * *File:* `GlobalSecureAccessClient.exe`.
  * *Rule Type & Operator:* File type, String (version), Operator: Greater than or equal to.
  * *Exam Trap:* Intune checks the UI tray application to verify installation, not the background tunneling services.
  * *Troubleshooting Detail:* When deploying an update, you must manually update the version number in the detection rule, or older clients will not be recognized as needing the upgrade.

**III. macOS Client Deployment & MDM**

* **Command Line Installation**
  * *Silent Install Command:* `sudo installer -pkg [Path] -target / -verboseR`. The `-verboseR` flag is critical for generating real-time logs during deployment.
  * *Exam Trap:* The CLI command installs the files silently, but the user will still see security prompts unless an MDM is used.
* **MDM Profile Configuration (Intune)**
  * *System Extensions:* To achieve a truly silent install, an MDM must auto-approve the macOS network extensions (`com.microsoft.globalsecureaccess.tunnel`) and the transparent proxy.
  * *Preference Domain:* Must use `com.microsoft.globalsecureaccess` to target settings.
  * *Exam Trap / Migration:* In June 2025, the identifier changed. Older policies using `com.microsoft.naas.globalsecure-df` will fail on current versions and must be updated.
  * *Best Practice:* Deploy the Microsoft Enterprise SSO plug-in alongside the client for seamless authentication without redundant prompts.

**IV. Mobile Deployment Architecture (iOS & Android)**

* **iOS Architecture & Configuration**
  * *Mechanism:* Uses a local/self-looping VPN (`127.0.0.1`) that feeds traffic into Microsoft Defender to evaluate forwarding profiles directly on the device.
  * *Intune Profile Type:* Custom VPN profile.
  * *Required Keys:* `EnableGSA` (to start the service) and `EnableGSAPrivateChannel` (optional).
* **Android Architecture & Configuration**
  * *Intune Profile Type:* App Configuration Policy.
  * *Required Keys:* `Global Secure Access` (value `3` enables and hides the disable option) and `GlobalSecureAccessPrivateChannel`.
  * *Exam Trap:* Never mix the iOS and Android key names (e.g., deploying `EnableGSA` to Android). The Defender app will simply ignore it, and the client will fail to start.

**V. Advanced Traffic Interception & Registry Optimizations**

* **DNS Over HTTPS (DoH) Dependency**
  * *Mechanism:* GSA relies on intercepting local DNS FQDN queries and rewriting the response with a synthetic `6.6.x.x` IP to steer traffic into the tunnel.
  * *Configuration Detail:* Administrators must explicitly disable DoH in Windows OS settings and browsers (Edge, Chrome, Firefox), because encrypted DNS queries bypass the client's interception engine, resulting in traffic routing locally.
* **Intelligent Local Access (ILA)**
  * *Mechanism:* Uses a DNS probe looking for a specific internal FQDN. If the FQDN resolves to your specified corporate IP range, the client knows it is on-premises and bypasses the cloud tunnel.
  * *Troubleshooting Detail:* Check Windows Event IDs 217 and 218 to verify when the client detects moving on or off the corporate network.
* **Kerberos Negative Caching Mitigation**
  * *Issue:* If a Domain Controller is unreachable upon boot, Windows caches the failure and waits 10 minutes before retrying.
  * *Registry Fix:* Set `FarKdcTimeout` to `0` (REG_DWORD) at `HKLM\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters`.
  * *Manual Troubleshooting Fix:* Run `KLIST PURGE_BIND` from an admin command prompt to instantly clear the negative cache.
* **RDP MFA Timeout Mitigation**
  * *Issue:* RDP sessions time out too quickly when waiting for a user to approve an Entra MFA prompt for a Private Access resource.
  * *Registry Fix:* Modify `TimeoutTcpDirectConnection` to `60` (decimal) at `HKLM\Software\Microsoft\Terminal Server Client`.

**VI. Security, Disablement, & UI Restrictions**

* **Windows UI Controls**
  * `HideDisableButton` (0x1): Completely hides the "Disable" option from the system tray.
  * `RestrictNonPrivilegedUsers` (0x1): Allows the disable button to be visible but triggers a UAC prompt requiring local admin credentials if clicked.
  * `HideSignOutButton` (0x1): Prevents the user from signing out and unbinding their identity from the tunnel.
* **macOS Disablement Workflow**
  * *Auditing Differences:* Unlike Windows, if a macOS user selects "Disable", they are forced to provide a **Business Justification** (which logs to Entra) and re-authenticate via Entra ID.
  * *Persistence:* The macOS disabled state is temporary; the client automatically re-enables on the next system restart.
  * *MDM Keys:* macOS UI is restricted via MDM settings: `HideDisableButton`, `HideQuitButton`, and `HidePauseButton`.

**VII. Comparison Tables**

**Table 1: Mobile Configuration Keys by Platform**

| Feature | Android (App Config Policy) | iOS (Custom VPN Profile) |
| :--- | :--- | :--- |
| **Enable Service** | `Global Secure Access` | `EnableGSA` |
| **Enable Private Access** | `GlobalSecureAccessPrivateChannel` | `EnableGSAPrivateChannel` |

**Table 2: Device State and Tunnel Support**

| Device State | M365 Traffic | Internet Access | Private Access | Tenant Selection |
| :--- | :--- | :--- | :--- | :--- |
| **Entra/Hybrid Joined** | Supported | Supported | Supported | Hard-locked to joined tenant |
| **Registered (BYOD)** | **Not Supported** | **Not Supported** | Supported | User prompts to select tenant |

**Table 3: Client Disablement & UI Controls**

| Feature | Windows Client | macOS Client |
| :--- | :--- | :--- |
| **Business Justification Required** | No | Yes |
| **Entra Re-authentication Required** | No | Yes |
| **Persists after Reboot** | Yes | No (Auto-enables) |
| **Configuration Method** | Registry (`HideDisableButton`) | MDM Preference Domain |

Would you like me to generate a Tailored Report artifact of this study sheet so you can easily save it to your Notebook, or shall we move on to exploring the log visualization workbooks in Microsoft Sentinel next?

## Manage risk by using Microsoft Entra ID Protection

### Monitor, investigate, and remediate risky workload identities

**SC-300 Study Review Sheet: Monitor, Investigate, and Remediate Risky Workload Identities**

**1. Foundational Concepts: Humans vs. Workload Identities**
To master workload identity security, you must understand how non-human machine identities fundamentally differ from human users:

* **Programmatic Operation:** Workload identities (applications, service principals, scripts, and managed identities) authenticate autonomously at machine speeds. Because of this, they generate a massive volume of authentication traffic.
* **No Multifactor Authentication (MFA):** Workload identities cannot answer a phone call or type in a text message, meaning they **cannot perform MFA**.
* **Stored Credentials:** Without interactive authentication, applications must prove their identity using stored credentials, typically a client secret or an X.509 certificate. These secrets must be stored somewhere accessible to the application's code, such as in a configuration file or a secure key vault.
* **Lack of Self-Remediation:** Because they cannot perform MFA or interactive password resets, workload identities **cannot self-remediate** when compromised. Manual administrative intervention is always required to restore safe access.

**2. Scope and Licensing**
Microsoft sets strict boundaries on which identities are monitored by ID Protection and what licenses are required.

* **In Scope:** Microsoft Entra ID Protection monitors and detects risk on **single-tenant service principals** registered directly in your tenant.
* **Out of Scope:** **Managed identities, multi-tenant apps, and non-Microsoft SaaS apps** are currently excluded from ID Protection risk detections and workload identity Conditional Access policies. Managed identities are excluded because Microsoft Azure automatically manages, rotates, and protects their underlying credentials, completely removing the threat vector of developer-managed stored secrets.
* **The Licensing Split:** Entra ID P2 unlocks ID Protection and risk-based Conditional Access exclusively for human users. To view full risk details for applications and to configure risk-based Conditional Access policies for them, you strictly require the **Workload Identities Premium** license. Without it, you will see that a workload is at risk, but the deep investigative details will appear as "hidden" and automated policy enforcement will be disabled.

**3. Specific Risk Detections**
You must be able to identify the exact triggers and behaviors of the following offline risk detections:

* **Leaked Credentials:** Triggers when Microsoft's scanning engine finds a valid client secret or certificate exposed on **GitHub, paste sites, or dark web forums**. Because an attacker gains immediate, unchecked access, this is always a **High Risk** event. To simulate this for testing, administrators must safely disable user sign-in for a test app and intentionally commit its secret to a public GitHub repository, which takes about **8 hours** to trigger the offline detection.
* **Suspicious API Traffic:** Triggers when **abnormal Graph API traffic** or **directory enumeration** is observed. This behavior is a primary indicator of an attacker conducting **reconnaissance** or attempting **data exfiltration**.
* **Anomalous Service Principal Activity:** Designed to monitor administrative service principals. It triggers when it spots anomalous patterns of **suspicious changes to the directory** (e.g., privilege escalation, assigning Global Admin roles, modifying Conditional Access). The detection targets the service principal making the change or the object that was changed.
* **Suspicious Sign-ins:** Takes between **2 and 60 days** to learn the baseline behavior for workload identities. Once baselined, it triggers on unfamiliar properties like a new IP/ASN, target resource, user agent, or credential type. Because workload authentications are highly programmatic and frequent, this detection logs a **timestamp for the suspicious activity** instead of flagging a single sign-in event.
* **Malicious Application:** Triggers when an app is actively disabled by Microsoft for violating terms of service, powered by the combination of **ID Protection and Microsoft Defender for Cloud Apps**. The Graph API property `disabledByMicrosoftStatus` will read `DisabledDueToViolationOfServicesAgreement`. **Never delete these apps**, as leaving the disabled object in place acts as a permanent barricade against re-instantiation. The "Suspicious application" detection is its sibling, flagging an app that *might* be violating terms.

**4. Investigation and Reporting**

* **Report Distinction:** The **Risky workload identities** report tells you *who* is compromised (the overall state), while the **Workload identity detections** tab (within the Risk detections report) tells you *what* happened (the granular alerts).
* **Data Retention:** Individual alerts in the Risk detections report are retained for **90 days**. The overall risk state in the Risky workload identities report has **no time limit**; it remains flagged until an administrator remediates or dismisses it. For longer retention, export data using **Diagnostic settings** to Azure Storage, Log Analytics, or an Event Hub.
* **RBAC Roles (Least Privilege):**
  * **Security Reader:** Can **view** reports and risk levels, but cannot change policies or dismiss/confirm risk.
  * **Security Operator:** Can view reports and **take manual remediation actions** (Dismiss/Confirm risk), but cannot configure Conditional Access.
  * **Security Administrator:** Can view, remediate, and **configure risk-based Conditional Access policies**.

**5. Incident Response and Remediation**
Because workload identities cannot perform MFA, Conditional Access for risky workloads can only be configured to **Block access**. Manual administrative intervention is required.

* **False Positives:** If an alert is a false alarm, select **Dismiss service principal risk**. This updates the `riskState` to `dismissed`, clears the risk level, and instantly restores the application's access by removing the Conditional Access block.
* **True Positives (Confirming Risk):** Clicking **Confirm service principal compromised** immediately elevates the risk to **High**, adds an `adminConfirmedServicePrincipalCompromised` detection record, and triggers your Conditional Access block policies. *Note: Confirming risk does not alter the directory object itself.* To manually and explicitly block a workload from all future sign-ins without Conditional Access, you must select **Disable service principal**.
* **Manual Remediation Steps:** When compromised (e.g., via Leaked Credentials), administrators must follow a strict manual workflow: 1. **Inventory and remove** the compromised credentials. 2. **Rotate any Azure Key Vault secrets** the service principal had access to, as the attacker likely copied them.
* **Remediation Tooling:** To assist with complex credential removal and Key Vault rotation tasks, Microsoft officially recommends using the **Microsoft Entra Toolkit** (a specialized PowerShell module) rather than writing raw Graph API calls.

**6. Microsoft Graph API Management**
For Security Orchestration, Automation, and Response (SOAR), you must know the corresponding API endpoints and properties.

* **Endpoints:** `riskyServicePrincipals` represents the overall identity (*who* is at risk), while `servicePrincipalRiskDetections` represents the specific alerts (*what* happened).
* **Crucial API Properties:**
  * **`riskLevel`:** Indicates the severity (e.g., low, medium, high, hidden, none).
  * **`riskDetail`:** Provides the specific reasons for the risk, but will return as `hidden` if you lack the Workload Identities Premium license.
  * **`isProcessing`:** A true/false value indicating whether Microsoft Entra ID is actively evaluating the identity's risk state. Because many detections are offline, this tells SOAR scripts to wait for the evaluation to finish.
  * **`riskState`:** Indicates the administrative processing status of the alert. Available values are `atRisk`, `dismissed`, `confirmedCompromised`, and `none`.
* **Missing API States:** Unlike human users who can have a `riskState` of `remediated` or `confirmedSafe`, these states are missing for workload identities because workloads cannot self-remediate via MFA or password resets.

## Plan, implement, and manage Microsoft Entra Conditional Access

### Configure authentication context

**SC-300 Study Review Sheet: Configure Authentication Context**

**1. Core Architecture & Zero Trust Principles**

* **The Concept:** Conditional Access authentication context is a Zero Trust feature designed to apply granular security policies directly to **sensitive data and actions within an application**, rather than broadly securing the entire application at the front door.
* **Least Privilege:** By keeping routine access frictionless and only demanding step-up authentication (like multifactor authentication or compliant devices) during critical operations, the feature tightly aligns with the Zero Trust principle of least privilege.
* **Underlying Protocols:** The authentication context feature is fundamentally an authentication action built on protocol extensions provided by the **OpenID Connect (OIDC)** standard, not OAuth 2.0.

**2. Licensing & App Prerequisites**

* **Minimum Licensing:** Utilizing the Conditional Access authentication context feature requires a **Microsoft Entra ID P1** license. It is entirely unavailable in the Microsoft Entra ID Free edition, which must rely on Security Defaults instead.
* **Application Constraints:** The application consuming the authentication context must be integrated with the Microsoft identity platform using OpenID Connect or OAuth 2.0. Currently, the feature only supports applications that sign-in users (delegated access); apps authenticating as themselves using workload identities are not supported.

**3. Configuration in the Microsoft Entra Admin Center**

* **UI Location:** Administrators navigate to **Protection > Conditional Access > Authentication context** to create and manage these definitions.
* **Identifier Limits:** An organization can create a maximum of **99 custom authentication context definitions** per tenant. The system automatically assigns a read-only identifier ranging from **`c1` through `c99`**.
* **Mandatory Attributes:**
  * **ID (`c1-c99`):** The exact machine-readable, read-only value embedded in tokens and Web API claims challenges to enforce request-specific policies.
  * **Display name:** The friendly name used to identify the context across the tenant and within consuming apps. **Best Practice:** Use generic, reusable names (e.g., "Require trusted devices") to create a **reduced set** of contexts, which limits browser redirects and improves the end-user experience.
  * **Description:** A text field used strictly by IT admins to understand the scope of the underlying policy.
  * **Publish to apps:** A critical Boolean checkbox that officially advertises the context to downstream applications, making it visible for developers to query and assign. If left unchecked, the context remains a hidden draft.

**4. Building the Conditional Access Policy**

* **Policy Logic:** An authentication context is essentially just a tag and relies entirely on an active Conditional Access policy to enforce security rules.
* **Targeting:** In the Conditional Access policy builder, you must configure the policy by navigating to **Target resources** (formerly "Cloud apps or actions"), changing the dropdown to **Authentication context**, and selecting the published definition.

**5. Developer Integration & Token Mechanics**

* **The Trigger Mechanism:** Developers give apps a way to trigger and satisfy the policy by using the authentication context reference value alongside the OpenID Connect **Claims Request parameter**. To handle this complexity, developers should utilize the **Microsoft Authentication Library (MSAL)**.
* **The Web API Gatekeeper:** When a user attempts a sensitive action, the Web API inspects the access token for the **`acrs` (Authentication Context Class Reference)** claim.
* **The Claims Challenge:** If the required `c1` tag is missing, the API throws an **HTTP 401 Unauthorized** response containing a **`WWW-Authenticate`** header. This header delivers a base64-encoded claims challenge specifying an **`insufficient_claims`** error and the exact context ID required. The client intercepts this challenge, redirects to Entra ID, forces the user to complete the step-up prompt, and receives a new token with the `acrs` claim.
* **Opportunistic Evaluation:** To avoid unnecessary round trips to Entra ID, apps can opt into the **optional `acrs` claim**. If the user's current session already satisfies the policy protecting the ID, Entra ID proactively and implicitly adds the `acrs` claim to the token without explicit prompting.
* **Dynamic Mapping via Graph API:** Developers must **never hard-code** `c1-c99` IDs into multi-tenant application source code because these values differ across tenants. Instead, apps must dynamically query the Microsoft Graph API endpoint **`/identity/conditionalAccess/authenticationContextClassReferences`**. This query requires the **`Policy.Read.ConditionalAccess`** minimum API permission.

**6. Advanced Use Cases & Scenarios**

* **SharePoint Online Site Security:** You cannot natively select a SharePoint Site Collection ID in a Conditional Access policy. To apply an authentication context to a specific site, you must use **Sensitivity labels** (created in Microsoft Purview) as the connective bridge. The Sensitivity label is assigned the auth context, and the label is then applied to the SharePoint site container.
* **Protected Actions in Entra ID:** Highly privileged administrative tasks (like updating CA policies) can be protected by an authentication context. Microsoft Graph determines if an action supports this via the Boolean **`isAuthenticationContextSettable`** property, and stores the assigned context in the **`authenticationContextId`** property.
* **External ID / Native Authentication:** When building native apps for external customers using a WAF for account takeover (ATO) protection, the WAF coordinates risk evaluations with third-party providers and injects the authentication context. Crucially, risk-based MFA via authentication context for Native Authentication is strictly limited to the **"Email with Password"** sign-in flow. Hardware FIDO2 keys are completely unsupported in this tenant type.
* **Privileged Identity Management (PIM):** Authentication contexts can be utilized by PIM to enforce step-up authentication prior to a highly privileged role becoming active.

**7. Management, Troubleshooting, & Roles**

* **RBAC Requirements:** The Zero Trust principle of least privilege dictates that the **Conditional Access Administrator** is the minimum built-in role required to manage, create, or update authentication contexts. If that role is unavailable, **Security Administrator** is the next least-privileged alternative.
* **Deletion Safety Mechanisms:** To prevent accidental security gaps, you **cannot delete** an authentication context if it is actively tied to a Conditional Access policy or if the **Publish to apps** checkbox is currently selected. You must verify in the sign-in logs that it is no longer in use before cleanly severing these connections.
* **Report-Only Mode Evaluation:** When deploying a new context policy, it should initially be placed in **Report-only** mode. Because the interactive MFA prompt is suppressed during testing, the sign-in logs will report the evaluation status as **"User action required"**. This telemetry can be viewed per-user in the Sign-in logs or aggregated tenant-wide using the **Conditional Access insights and reporting workbook**.
* **Implicit Satisfaction Risk:** If an app requests an `acrs` claim, but the administrator failed to assign any Conditional Access policies to that specific context definition, the system automatically considers the request satisfied and issues the token freely, bypassing all security intent.

**8. 🚨 SC-300 Exam Traps to Remember**

* **The "P2" Distractor:** Do not select Microsoft Entra ID P2 as the requirement for authentication contexts; the feature only requires a baseline **P1** license.
* **The Hard-Coding Trap:** Multi-tenant apps must dynamically read contexts via Graph API; any exam option suggesting hard-coding a `c1` or `c2` value is incorrect.
* **The Broad Application Trap:** Do not use an authentication context if the broad target of the Conditional Access policy is the entire application itself. Contexts are meant for granular, targeted parts of an application.
* **The Protected Actions Sequence:** To prevent unexpected lockouts, you must configure and toggle the Conditional Access policy to **"On"** *before* you map the context to a highly privileged Entra ID permission.

### Implement continuous access evaluation

###### **SC-300 Study Review Sheet: Implement Continuous Access Evaluation (CAE)**

###### **1. CAE Architecture & Core Mechanics**

* **The Background Dialogue Mechanism**
  * Continuous Access Evaluation (CAE) operates through a continuous background dialogue directly between Microsoft Entra ID and the specific resource provider (such as Exchange Online or SharePoint).
  * CAE does not rely on a reverse proxy to actively route sessions or verify egress IP addresses.
* **Comparison Table: Architectural Mechanisms**

| Feature | Architectural Mechanism | Primary Use Case |
| :--- | :--- | :--- |
| **Continuous Access Evaluation (CAE)** | Background dialogue between Entra ID and Resource Provider. | Enforcing location policies, IP verification, and instant token revocation. |
| **Conditional Access App Control (CAAC)** | Reverse proxy architecture ("man-in-the-middle"). | Actively monitoring sessions, blocking real-time actions like sensitive file downloads or copy/paste. |

* **🚨 SC-300 Exam Traps**
  * **The Reverse Proxy Trap:** If an exam scenario involves verifying an egress IP address or enforcing strict location policies, you must choose CAE, which does *not* use a reverse proxy. Reverse proxies are exclusively utilized for CAAC.

###### **2. The IP Address Mismatch Problem & Enforcement Modes**

* **The Root Cause of Mismatches**
  * In complex network architectures utilizing split-tunnel VPNs, network traffic routing diverges depending on its final destination.
  * This split routing causes the IP address that Microsoft Entra ID sees during initial authentication to differ completely from the egress IP address that the resource provider (e.g., Exchange Online) sees when the user accesses data.
* **Comparison Table: CAE Location Enforcement Modes**

| Mode | System Assumption | Resulting Action |
| :--- | :--- | :--- |
| **Standard Mode (Default)** | Assumes the mismatch is a benign network routing quirk to protect user productivity. | Grants a safe exception by issuing a short-lived **1-hour token**. |
| **Strict Mode** | Intentionally removes the 1-hour safety net and strictly enforces the resource provider's perspective. | Access is **immediately blocked** if the egress IP detected by the resource provider is not explicitly on the allowed list. |

* **Scenario Example**
  * A user logs into Entra ID from their home network (IP trusted by Entra), but their split-tunnel VPN routes their Exchange Online traffic through a corporate gateway (Egress IP unknown to Entra policies). Under Standard Mode, they get a 1-hour token. Under Strict Mode, they are instantly blocked.

###### **3. The Strict Location Enforcement Deployment Sequence**

* **Prerequisites & Configuration Details**
  * Because Strict Mode drops the standard 1-hour token exception, enabling it blindly carries a high risk of instantly locking legitimate users out of their resources.
  * Administrators are strictly required to thoroughly test their network topology before enforcement.
* **The 3-Step Remediation Sequence**
    1. **Identify:** You must run the **Continuous Access Evaluation Insights workbook** to find, map out, and discover hidden IP mismatches caused by your network topology actively occurring in your environment.
    2. **Remediate:** Administrators must manually map and explicitly add those newly discovered egress IP addresses to the organization's allowed IP list (Named Locations).
    3. **Enforce:** Only after the hidden IPs are mapped and added to the allowed IP list should the administrator enable the **Strictly enforce location policies** feature to begin immediate blocking.
* **🛠️ Troubleshooting Details**
  * If users report sudden, widespread access blocks to SharePoint or Exchange immediately after modifying a CAE policy, verify that the CAE Insights workbook was executed and all identified egress IPs were added to Named Locations.

###### **4. CAE Integration with Global Secure Access (SSE)**

* **Bridging Identity and Network Security**
  * Microsoft Global Secure Access (Security Service Edge) bridges separated network security silos (web filtering) with identity security silos (device compliance/MFA).
  * Administrators build **security profiles** in the Global Secure Access portal, which group various network security policies (e.g., blocking malicious websites or unsanctioned cloud storage).
* **Configuration Details**
  * The integration relies on the **"Use Global Secure Access security profile"** setting.
  * This setting allows network security rules to dynamically adapt based on real-time identity signals (like Entra ID Protection sign-in risk or device compliance) evaluated continuously during the user's active session.
* **🚨 SC-300 Exam Traps**
  * **The Category Trap:** Do not confuse this integration point with a *Grant* control or a *Condition*. Because it actively manages routing during the ongoing session, it is exclusively located under the **Session controls** menu within the Conditional Access policy builder.

###### **5. CAE Evaluation for AI Agents & Complex Workflows**

* **AI Agent Evaluation Logic**
  * **Agent Blueprints:** An agent blueprint is simply a logical template whose only job is to instantiate active agent identities. Conditional Access does not apply to blueprints when they are just acquiring a token to create a new agent.
* **Comparison Table: AI Agent Flow Evaluation**

| AI Agent Flow Type | Description | Target Evaluated by Conditional Access |
| :--- | :--- | :--- |
| **On-Behalf-Of (OBO) Flow** | An agent acting on behalf of a signed-in human user (e.g., summarizing a secure document). | The policy is evaluated against the **human user**, not the agent identity. |
| **Autonomous Flow** | An agent running independently on a schedule using its own credentials via Client Credentials flow. | The policy applies strictly to the **agent identity**. |

* **Prerequisites for Autonomous AI Agent Filtering**
  * To filter access for autonomous AI agents, the best practice is to assign Custom Security Attributes (e.g., `AgentApprovalStatus`) directly to the agent's identity object.
  * To *assign* the attribute, the **Attribute Assignment Administrator** role is required.
  * To *use* the attribute in the "Filter for applications/agents" condition of a CA policy, the administrator must possess both the **Conditional Access Administrator** and the **Attribute Assignment Reader** roles.
* **🚨 SC-300 Exam Traps**
  * **The OBO Trap:** If a scenario explicitly mentions the On-Behalf-Of flow or an AI agent acting on behalf of a human, memorize that the policy evaluation is *always* executed against the human user.

###### **6. Session State Limitations: Private Browsing & Authentication Transfer**

* **Private Browsing (Incognito / InPrivate) Conflicts**
  * Browsers running in private modes (Google Chrome Incognito, Microsoft Edge InPrivate) intentionally isolate the session and actively suppress the cookies and Primary Refresh Tokens (PRT) needed for SSO flows.
  * **Troubleshooting Details:** Because private sessions refuse to pass device identity artifacts, the system explicitly considers the session as coming from an unregistered, noncompliant device.
  * **Configuration Impact:** Incognito/InPrivate sessions will permanently fail the "Require device to be marked as compliant" grant control and are explicitly not considered an "approved client app".
* **Authentication Transfer & Protocol Tracking**
  * Authentication Transfer allows passing authentication state (like MFA claims) from a PC to a mobile device via QR code.
  * When utilized, the resulting session becomes **protocol tracked**, meaning the system remembers the session's history and may subject later sign-in attempts to original authentication flow policies.
  * **🚨 Exam Trap (MDM Bypass):** Device compliance and managed states *never transfer* during this flow. Because the flow inherently bypasses third-party mobile device management (MDM) solutions, Microsoft strongly recommends using Conditional Access to completely block authentication transfer if an organization relies on a non-Microsoft MDM.

### Implement device enforced restrictions

###### **1. Mastering Device Filters (`Filter for devices`)**

* **Configuration Details & Syntax Limits:**
  * **Character Limit:** There is a strict **3072-character limit** for rule expressions. Avoid pasting exhaustively long lists of individual `deviceId`s.
  * **Targeting Multiple Devices:** The `Contains` operator is explicitly **not supported** for the `deviceId` attribute.
    * *Configuration Detail:* To match multiple device IDs, you must use the `In` or `NotIn` operator alongside an array (e.g., `device.deviceId -in ["id1", "id2"]`).
  * **Collection Matching:** For multi-valued attributes (`systemLabels`, `extensionAttributes1-15`, `physicalIds`), the `Contains` operator evaluates if the string matches *one of the whole strings* in the collection, rather than performing a simple substring search.

* **Targeting Unregistered vs. Registered Devices:**
  * Unregistered devices evaluate all properties as "null" because they do not exist in the directory.

| Operator Type | Supported Operators | Behavior on Unregistered Devices |
| :--- | :--- | :--- |
| **Positive** | `Equals`, `StartsWith`, `Contains`, `In` | **Bypassed.** Rule evaluates as false because "null" cannot match a specified string. |
| **Negative** | `NotEquals` (`-ne`), `NotStartsWith`, `NotContains`, `NotIn` | **Applied.** Rule successfully catches unregistered devices because "null" does not equal the specified string. |

* **Custom Extension Attributes (`extensionAttributes1-15`):**
  * *Scenario Example:* Blocking access to the Windows Azure Service Management API unless the device is tagged with a "SAW" (Secure Admin Workstation) extension attribute using `(device.extensionAttribute1 -ne "SAW")`.
  * *Prerequisite Note:* To evaluate custom attributes during sign-in, the device must be **Intune managed, Compliant, or Microsoft Entra hybrid joined**. Registered-only BYOD devices will not evaluate these attributes, and their values will be treated as null.

* **Excluding Virtual Endpoints:**
  * *Configuration Detail:* Virtual machines do not support hardware-backed token binding. Use the `systemLabels` attribute to exclude them:
    * Windows 365 Cloud PCs: `systemLabels -eq "CloudPC"`.
    * Azure Virtual Desktops: `systemLabels -eq "AzureVirtualDesktop"`.
    * Power Automate machines: `systemLabels -eq "MicrosoftPowerAutomate"`.

###### **2. Token Protection Enforcement**

* **Hardware Anchors by Platform:**
  * **Windows:** Relies on the physical **Trusted Platform Module (TPM)**.
  * **Apple (Modern):** Relies on the **Apple Secure Enclave**.
  * **Apple (Legacy Fallback):** For older macOS devices lacking a Secure Enclave, relies on the **Data Protection Keychain**.
  * *Prerequisite Note:* Token Protection on Apple hardware requires the device to be MDM-managed (Intune) and have the **Microsoft Enterprise SSO plug-in** deployed.
  * *Exam Trap:* The Microsoft Authenticator app acts as the *broker* on Apple devices, but the keys are stored in the hardware vault, not in the app's storage.

* **Troubleshooting Token Protection Log Errors:**
  * Found in the Sign-In Logs under **Basic Info > Token Protection - Sign In Session**.

| Status Code | Root Cause | Example Scenario / Affected Devices |
| :--- | :--- | :--- |
| **`1003`** | **Unsupported registration type** or legacy registration. | Fails on Windows 365 Cloud PCs, AVD hosts, or bulk-enrolled devices because they inherently lack a physical TPM. |
| **`1004`** | **Not hardware-backed**. | Fails because a supported physical device was registered via a non-hardware-backed method. |

###### **3. Device Registration & Terms of Use Constraints**

* **The "Register or Join Devices" User Action:**
  * *Configuration Detail:* This action intentionally disables `Client apps`, `Filters for devices`, `Device state`, `Require device to be marked as compliant`, and `Require Microsoft Entra hybrid joined device` conditions/controls to prevent "chicken-and-egg" logical conflicts.
  * *Supported Controls:* Only **Require multifactor authentication** and **Require authentication strength** are permitted.
  * *Exam Trap (Authentication Methods):* You **cannot** use **Windows Hello for Business** or **device-bound passkeys** to fulfill the MFA requirement during registration, as both methods require the device to already be registered.
  * *Exam Trap (Tenant-Wide Conflict):* To successfully enforce this Conditional Access policy, you **must** set the legacy tenant-wide setting *"Require Multifactor Authentication to register or join devices with Microsoft Entra"* (found in Device Settings) to **"No"**.

* **Per-Device Terms of Use:**
  * *Prerequisite Note:* Enforcing "Require users to consent on every device" tracks compliance using the registered **device ID**.
  * *Exam Trap (App Exclusion):* You must explicitly exclude the **Microsoft Intune Enrollment app** (App ID: `d4ebce55-015a-49b5-a083-c84d1797ae8c`) from per-device Terms of Use policies. Failing to do so creates an infinite loop where device enrollments fail because the device is not yet registered to record the consent.
  * *Licensing/B2B Note:* Per-device Terms of Use are explicitly **not supported** for B2B guest users.

###### **4. Mobile Devices & Broker Apps**

* **Broker App Architecture:**
  * *Prerequisite Note:* To apply **Require app protection policy** (MAM) or **Require approved client app** controls, the mobile device must be registered. A broker app is required to register the device and pass compliance state to Entra ID.

| Operating System | Supported Broker App(s) |
| :--- | :--- |
| **iOS** | Microsoft Authenticator |
| **Android** | Microsoft Authenticator OR Microsoft Intune Company Portal |

* *Exam Trap:* While Microsoft Authenticator acts as the broker to enforce MAM, the Authenticator app itself cannot be targeted as an "approved client app" in the policy.

###### **5. Browser Identity & Session Security**

* **Browser Device Verification:**
  * *Mechanism:* Entra ID uses the User-Agent string *only* to identify the device platform (OS). Because plain text can be spoofed, it relies on cryptographic **Client Certificates** provisioned during registration to prove device identity.
  * *Configuration Detail (Chrome):* Google Chrome on Windows requires the explicit installation of the **Microsoft Single Sign On extension** or enabling the `CloudAPAuthEnabled` policy to pass device identity artifacts.

* **Private Browsing Limitations:**
  * *Behavior:* Edge InPrivate and Chrome Incognito suppress cookies/tokens, failing to pass identity artifacts.
  * *Exam Trap:* Conditional Access treats private browsing sessions as **noncompliant devices**. Private browsers are also explicitly **not considered approved client apps**.

* **Persistent Browser Sessions:**
  * *Configuration Detail:* Must be scoped strictly to **All resources** (All Cloud Apps). It cannot target individual apps because browser tabs share a single token.
  * *Behavior:* Overrides the legacy tenant-wide "Stay signed in?" prompt.
  * *Security Note:* Leaves a persistent cookie on the device. For unmanaged devices, this is a risk. Microsoft recommends pairing this setting with strict **Sign-in frequency** session controls.

###### **6. Specialized Flows & Restrictions**

* **Authentication Transfer (Cross-Device Sign-in):**
  * *Behavior:* Transfers **authentication claims only** (via QR code scan).
  * *Exam Trap (Device State):* Device compliance and management state **do not transfer**.
  * *Exam Trap (MDM Bypass):* Auth transfer naturally bypasses 3rd-party non-Microsoft MDM solutions. Microsoft strongly recommends blocking this flow if your organization relies on 3rd-party MDM.
  * *Session State:* The resulting session becomes **protocol tracked**, subjecting future token refreshes to auth flow policies. Only supports Microsoft apps.

* **Device Code Flow Limitations:**
  * *Architecture:* Split between the requesting device (e.g., smart TV) and authenticating device (e.g., smartphone).
  * *Exam Trap:* Because authentication occurs on the smartphone, Entra ID cannot see the state of the smart TV. Therefore, **device-state grant controls (Require compliant device, Require hybrid joined) are entirely unsupported**.
  * *Security Recommendation:* Require MFA instead. Due to high phishing risk, use the **Authentication flows** condition to block device code flow universally, allowing it only as a strict exception for specific network locations.

* **Continuous Access Evaluation (CAE) - Strict Location Enforcement:**
  * *Behavior:* Evaluates mismatch between IP seen by Entra ID and IP seen by resource provider. Standard mode falls back to a 1-hour token exception.
  * *Strict Mode:* Immediately blocks access if the resource provider's IP is not on the allowed list, even if Entra initially authorized the IP.
  * *Prerequisite Note:* Must use the **Continuous Access Evaluation Insights workbook** to test and map topologies before enabling Strict mode to prevent lockouts.

###### **7. AI Agents & Custom Security Attributes**

* **Agent Identity Types:**
  * **Agent Blueprint:** The template. Policies scoped to a blueprint automatically cover all spawned agent identities. *Exam Trap:* Conditional Access does not evaluate when a blueprint acquires a token just to create an agent.
  * **Agent Identity:** The active autonomous agent. Evaluated by Conditional Access during Client Credentials flow.
  * **Agent User:** Nonhuman user account for "digital worker" licensing (Exchange, Teams).
  * *Exam Trap (OBO Flow):* If an agent uses On-Behalf-Of flow for a human user, the Conditional Access policy evaluates the **human user**, not the agent.

* **Custom Security Attribute Role Requirements:**
  * *Configuration Detail:* Used to tag approved agents (e.g., `HR_Approved`).
  * *Exam Trap (Role Delegation):* Global Administrators **do not** have permission to use or assign custom attributes by default.

| Task | Minimum Required Microsoft Entra Roles |
| :--- | :--- |
| **Create/Define the Custom Attribute** | Attribute Definition Administrator |
| **Assign/Stamp the Attribute onto an Agent Identity** | Attribute Assignment Administrator |
| **Use/Target the Attribute inside a Conditional Access Policy Builder** | Conditional Access Administrator **AND** Attribute Assignment Reader |

###### **8. Global Secure Access (SSE Integration)**

* *Configuration Detail:* Use the **Use Global Secure Access security profile** setting located under **Session controls**.
* *Behavior:* This control bridges Conditional Access identity context (like risk or compliance) directly into Microsoft's Security Service Edge (SSE) network security rules, allowing web content filtering to dynamically adapt based on the user's real-time identity signals.

### Implement protected actions

#### SC-300 Study Review Sheet: Implement Protected Actions

**I. Prerequisites & Licensing Notes**

* **Licensing Dependencies**
  * **Minimum Requirement:** Microsoft Entra ID P1.
    * *Reasoning:* Protected actions rely directly on the core Conditional Access (CA) engine.
  * **Defense-in-Depth Synergy:** Microsoft Entra ID P2.
    * *Reasoning:* P2 allows combining Protected Actions with Privileged Identity Management (PIM) for a multi-layered security approach.
* **Administrative Roles**
  * **To Manage Protected Actions:** Conditional Access Administrator or Security Administrator.
  * **To Manage Role Assignments:** Privileged Role Administrator.
  * *Exam Trap:* A Global Administrator is NOT exempt from protected action policies. If they attempt a protected task, they must pass the step-up challenge.

**II. Architectural Logic & Configuration Details**

* **Just-in-Time Enforcement:** The policy triggers exactly at the moment a protected operation is attempted, rather than during initial user sign-in.
* **Authentication Context:** The mandatory "bridge" object linking a specific directory permission to a Conditional Access policy.
* **Mandatory Configuration Sequence (Order Matters):**
    1. **Configure Authentication Context:** (Navigate to Protection > Conditional Access > Authentication context).
        * *Exam Trap:* You MUST select the **Publish to apps** checkbox. If left unchecked, the context will not be selectable in the following steps.
    2. **Assign to CA Policy:** Select the Authentication Context (instead of a cloud app) and configure Grant controls (e.g., Phishing-resistant MFA).
        * *Exam Trap:* Always exclude an emergency "break-glass" account to prevent total tenant lockouts during an MFA outage.
    3. **Add Protected Action:** (Navigate to Identity > Roles & admins > Protected actions). Link the context to the target directory permissions.
        * *Troubleshooting Detail:* Configuring these out of order results in infinite re-authentication loops where users cannot satisfy the missing policy bridge.

**III. Comparison Tables**

**Table 1: PIM vs. Protected Actions**

| Feature | Trigger Point | Evaluation Target | Licensing Requirement |
| :--- | :--- | :--- | :--- |
| **PIM** | Role activation | Administrative Role | Entra ID P2 |
| **Protected Actions** | Specific operation attempt | Directory Permission | Entra ID P1 (or P2) |

* *Scenario Example:* Using both together. An admin uses MFA to activate their CA Administrator role via PIM. Later in the session, they attempt to delete a CA policy and must satisfy a second, distinct FIDO2 key challenge triggered by the Protected Action.

**Table 2: Supported Tooling for Claims Challenges (Step-Up Authentication)**

| Tool | Supported? | Behavior upon triggering a Protected Action |
| :--- | :--- | :--- |
| **Entra Admin Center** | Yes | Prompts the user seamlessly for step-up MFA. |
| **MS Graph PowerShell** | Yes | Redirects the script user to satisfy the MFA prompt. |
| **Graph Explorer** | Yes | Supports context prompts natively for developers. |
| **Azure PowerShell** | **No** | Fails and returns an error (cannot process claims challenge). |
| **Azure CLI** | **No** | Fails (unsupported for role/action management). |

**Table 3: Entra ID Deletion States**

| Deletion Type | Status | Recoverable? |
| :--- | :--- | :--- |
| **Soft Deletion** | Moved to recycle bin for 30 days. | Yes. |
| **Hard Deletion** | Permanently purged manually or post-30 days. | **No.** Cannot be recreated with same Object ID. |

**IV. Key Protected Permissions & Scenarios**

* **Conditional Access Management**.
  * *Permissions:* `.../create`, `.../basic/update`, `.../delete`.
  * *Exam Trap / Limitation:* Protecting these permissions inherently blocks the creation of new **Terms of Use pages** or **Custom Controls**. You must temporarily remove the protected action to create them.
* **Hard Deletions**.
  * *Permission:* `microsoft.directory/deletedItems/delete`.
  * *Affected Objects:* Users, Microsoft 365 groups, Cloud security groups, Applications.
  * *Scenario Example:* A compromised admin attempts to permanently purge a critical cloud security group from the recycle bin to cover their tracks. The protected action forces a step-up FIDO2 prompt, successfully blocking the irreversible deletion.
* **Cross-Tenant Access Settings:** Secures modifications to external B2B collaboration.

**V. Troubleshooting Details**

* **Issue:** The "Add protected actions" button is greyed out in the Entra portal.
  * *Resolution:* Verify the user holds the Conditional Access Admin or Security Admin role. If utilizing PIM, verify the role is currently **active**, not just eligible.
* **Issue:** A PowerShell script fails unexpectedly when executing a `Remove-MgDeviceManagement...` or similar command.
  * *Resolution:* Verify the script is using the Microsoft Graph PowerShell SDK, not Azure PowerShell. Ensure the executing user is interacting with the script interactively to satisfy the prompt.

Would you like to shift focus to another SC-300 topic like Entra ID Protection or Application Proxy?

### Implement session management

###### SC-300 Study Review Sheet: Implement Session Management (Expanded)

###### 1. Sign-in Frequency

* **Core Mechanics & Philosophy**
  * **The 90-Day Rolling Window (Default):** Designed specifically to mitigate "prompt fatigue" and reduce the risk of users blindly approving malicious MFA requests.
  * **Dynamic Security:** Active sessions within the 90-day window are instantly revoked upon IT policy violations, including password changes, device noncompliance, account disablement, or explicit administrator revocation via Microsoft Graph PowerShell.
  * **Token Refresh:** On Entra joined and hybrid joined devices, the underlying Primary Refresh Token (PRT) refreshes silently every four hours upon interactive device use.
* **The "Every Time" Configuration**
  * Forces full reauthentication at every session evaluation, requiring the target app to have internal logic to redirect the user to Microsoft Entra ID.
  * **Built-in Safety Net:** Implements a strict **5-minute clock skew** to suppress duplicate back-to-back MFA prompts within a five-minute window.
* **Background Process Deferral Mechanics**
  * **Browsers:** Sign-in frequency enforcement on background services (e.g., massive SharePoint uploads) is deferred until the next active **user interaction** with the browser.
  * **Confidential Clients:** Enforcement on non-interactive automated sign-ins is deferred until the next **interactive sign-in**.
* **Configuration Details & Prerequisites**
  * Must explicitly disable the legacy **"Remember MFA on trusted devices"** setting tenant-wide before deployment to prevent overlapping timer conflicts and unpredictable prompts.
* **🚨 Exam Traps**
  * **Infinite Loop Trap:** Configuring "Every time" without enforcing an MFA requirement in the same policy can permanently trap users in an endless authentication loop.
  * **Unsupported Scenarios:** The "Every time" setting is explicitly unsupported for Microsoft Entra Private Access.
  * **MFA Fatigue Risk:** Using "Every time" on standard Microsoft 365 desktop apps creates severe security friction; Microsoft recommends it only for critical actions.
* **Scenario Examples**
  * *Scenario:* Securing Privileged Identity Management (PIM) role elevation, managing high-risk sign-ins flagged by Entra ID Protection, or securing Microsoft Intune device enrollment. *Solution:* Configure Sign-in frequency to "Every time".
  * *Scenario:* A user locks their PC while uploading a file via a browser; the session timer expires while locked. *Solution:* The upload finishes successfully; the user is prompted for credentials only upon unlocking the PC and interacting with the browser window.

###### 2. Persistent Browser Sessions

* **Core Mechanics**
  * Dictates whether cookies accessing Entra artifacts remain stored on the device after the browser is closed.
  * **Hierarchy of Control:** Configuring this session control in Conditional Access explicitly **overrides** the default "Stay signed in?" user prompt managed in the tenant's company branding pane.
* **🚨 Exam Traps**
  * **The "All Cloud Apps" Requirement:** Because all tabs within a single browser session share the exact same authentication session token, persistence cannot be divided among individual tabs. You **must** select **"All Cloud Apps" (All resources)**. Targeting a single app like Exchange Online is an invalid configuration.

###### 3. Continuous Access Evaluation (CAE)

* **Underlying Architecture**
  * Based on the **Open ID Continuous Access Evaluation Profile (CAEP)** standard, establishing a real-time, two-way conversation between Entra ID (issuer) and the resource provider (relying party).
  * **The 401+ Claim Challenge:** When a token is rejected, the resource provider returns a 401 Unauthorized response with a claims challenge. A CAE-capable client natively understands this, bypasses its local cache, and redirects the refresh token back to Entra ID.
* **Token Lifetimes Table**

| Identity Type | Client Type | Token Lifetime |
| :--- | :--- | :--- |
| **Human User** | Non-CAE Capable | 1 hour (Default) |
| **Human User** | CAE-Capable (Teams, Outlook, Edge) | **Up to 28 hours** |
| **Workload Identity** | Explicitly opts in via `cp1` claim | **Up to 24 hours** |
| **Any Identity** | Exceeds 5,000 IP limit / IP mismatch | Safely reduced to 1 hour |

* **Critical Events Evaluation (Near Real-Time)**
  * **Latency:** Up to **15 minutes** due to network propagation delay from Entra ID to the resource provider.
  * **Supported Events:** Password change/reset, user account deleted/disabled, refresh tokens explicitly revoked, high user risk detected, MFA enabled.
  * **Limitations:** SharePoint Online currently does **not** support user risk events.
* **Location Policy Evaluation (Instant)**
  * Enforced instantly, bypassing the 15-minute propagation delay.
* **Configuration Details: Workload Identity Opt-In**
  * Custom service principals must explicitly declare the **`cp1` client capability** via the JSON claim parameter: `{"access_token":{"xms_cc":{"values":["cp1"]}}}`.
  * *Prerequisites:* Only supports **single-tenant service principals** registered in the home tenant requesting access to **Microsoft Graph**. Managed identities and multi-tenant SaaS apps are unsupported.
* **🚨 Exam Traps**
  * **Directory Attribute Traps:** Routine directory changes like a modified "Department", "Job Title", or "Manager" attribute **do not** trigger critical events.
  * **Location Type Limitations:** CAE **only** has insight into **IP-based named locations**. It completely ignores country/region configurations and legacy "MFA trusted IPs".
  * **The 5,000 Threshold:** If an organization's location policies exceed **5,000 IP ranges**, CAE location enforcement becomes computationally impossible. It safely degrades to a 1-hour token for location checks, but *critical events* continue to be evaluated in near real-time.
* **Strict Location Enforcement vs. Standard Mode Table**

| Feature | Standard Location Enforcement (Default) | Strict Location Enforcement |
| :--- | :--- | :--- |
| **IP Mismatch Behavior** | Grants exception; safely falls back to a 1-hour token to prevent infinite loops. | **Immediately blocks access** if the resource IP isn't on the trusted list. |
| **Primary Use Case** | Modern networks with split-tunnel VPNs or mixed IPv4/IPv6. | Highly controlled environments with dedicated, static egress IPs. |
| **Prerequisite Troubleshooting** | N/A | Must map mismatches using the **CAE Insights workbook** prior to enabling to prevent tenant lockouts. |

###### 4. CAAC vs. App Enforced Restrictions

* **Comparison Table: Advanced Data Controls**

| Feature | Conditional Access App Control (CAAC) | App Enforced Restrictions |
| :--- | :--- | :--- |
| **Supported Applications** | Any cloud app (via Defender proxy) or **Microsoft Edge for Business** natively. | **Only** Exchange Online and SharePoint Online. |
| **Underlying Architecture** | Reverse proxy integration with **Microsoft Defender for Cloud Apps**. | Passes unmanaged device state directly to the app during sign-in. |
| **DLP Integration** | Natively integrates with **Microsoft Purview DLP** via the **Custom** setting. | Relies purely on the target app's internal logic to build a limited UI. |

* **Scenario Examples**
  * *Scenario:* Prevent users from downloading email attachments in Outlook on the web on a personal laptop. *Solution:* Use **App enforced restrictions** targeting the "Office 365" application group.
  * *Scenario:* Prevent data exfiltration (cut/copy/print) natively within the Microsoft Edge for Business browser. *Solution:* Use **Conditional Access App Control**, explicitly selecting the **Custom** dropdown to invoke Microsoft Purview DLP.
  * *Scenario:* Block sensitive downloads from a third-party application like Salesforce. *Solution:* Use **Conditional Access App Control** with Microsoft Defender for Cloud Apps.
* **🚨 Exam Traps**
  * Attempting to apply App Enforced Restrictions to custom line-of-business apps or third-party SaaS is an invalid configuration.

###### 5. Token Protection (Token Binding)

* **Core Mechanics**
  * Cryptographically binds sign-in session tokens (PRTs) specifically to device hardware to prevent adversary-in-the-middle token theft and replay attacks.
* **Prerequisite OS Details**
  * **Windows:** Utilizes the Trusted Platform Module (TPM).
  * **macOS/iOS (Apple):** Utilizes the Apple Secure Enclave. The device **must be MDM-managed** and require the **Microsoft Enterprise SSO plug-in** to be installed.
* **Troubleshooting Details**
  * Investigate via **Entra ID Sign-in logs -> Basic Info tab -> "Token Protection - Sign In Session"**.
  * A status of **1003** (legacy registration) or **1004** (non-hardware-backed registration) indicates the request is **Unbound**. The user must perform a one-time registration upgrade.
* **🚨 Exam Traps**
  * **Client Limitation:** Explicitly **does not support web browsers**. It only applies to **native desktop applications**.
  * **Resource Limitation:** Limited to protecting Exchange Online, SharePoint Online, Teams, Azure Virtual Desktop, and Windows 365.

###### 6. Resilience Defaults & Backup Authentication

* **Core Mechanics**
  * The **Microsoft Entra Backup Authentication Service** automatically issues tokens to keep *existing* active sessions alive during a primary service outage.
  * **Missing Outage Data:** The backup service loses real-time connection to evaluate: Group/role memberships, User/sign-in risk, GPS/new IP locations, and Authentication strengths.
* **Configuration Details**
  * **Resilience Defaults ENABLED (Default):** Evaluates security data collected at the *beginning* of the user's session. If MFA was satisfied initially, a new token is issued. This overrides and explicitly extends sessions past sign-in frequency timeouts during the outage.
  * **Resilience Defaults DISABLED:** Fails closed. If the service cannot evaluate a condition in real-time, access is denied.
* **Troubleshooting Details**
  * CAE critical revocation events are successfully subscribed to and honored during outages.
  * Monthly background tests appear in Entra Sign-in logs under the filter: **"Token issuer type == Microsoft Entra Backup Auth"**.
* **🚨 Exam Traps**
  * **Tenant Lockout Trap:** If you disable resilience defaults on a policy assigned to a **group or directory role**, the system cannot check group membership during an outage and will lock out **all users** targeted for that app. Disabled resilience policies must be assigned exclusively to **individual users**.
  * **Guest Limitations:** The backup service **does not** process new sign-in sessions or authentications by guest users.

###### 7. Protocol Tracking & Authentication Flows

* **Core Mechanics**
  * Monitors specific authorization pathways, notably **device code flow** and **authentication transfer** (e.g., scanning a PC QR code to transfer authentication to a mobile device).
  * **Session Persistence:** Once initiated, the protocol tracked state **is sustained through subsequent token refreshes** within the session.
* **Scenario Examples**
  * *Scenario:* An admin blocks device code flow for Exchange Online, but allows it for SharePoint. A user authenticates to SharePoint using device code flow (session becomes protocol tracked). Later, the user clicks an Exchange Online link in the same browser. *Solution:* The user is immediately blocked from Exchange Online because the device code flow origin persists on the session state.
* **🚨 Exam Traps**
  * Do not confuse "Protocol Tracking" with "Conditional Access App Control" (Defender for Cloud Apps session monitoring). Connect Protocol Tracking strictly to **Authentication flows** conditions.

###### 8. Intune Device Enrollment App Quirks

* **Configuration & Troubleshooting Details**
  * **New Tenant Bug:** The **Microsoft Intune Enrollment** cloud app is not generated automatically in new Entra ID tenants.
  * **Resolution:** Admins must manually create the service principal using Graph/PowerShell targeting App ID **`d4ebce55-015a-49b5-a083-c84d1797ae8c`** to make it appear in the Conditional Access picker.
* **🚨 Exam Traps**
  * **Targeting Distinction:** Target *Microsoft Intune Enrollment* for a one-time MFA prompt during the initial Setup Assistant phase. Target *Microsoft Intune* for MFA prompts upon every subsequent Company Portal app sign-in.
  * **Device Rules:** Do **not** configure "Device based access rules" for Microsoft Intune enrollment.

###### 9. Microsoft Entra External ID Limitations

* **🚨 Exam Traps**
  * If an exam scenario specifically mentions an **External ID external tenant** (B2C/customer-facing), you are strictly limited to configuring only two session controls:
        1. **Sign-in frequency** (including "Every time" for OAuth 2.0/OIDC apps).
        2. **Persistent browser session**.
  * All other controls (CAE configuration, CAAC, Token Protection, App Enforced Restrictions, Resilience Defaults) are unsupported and invalid for external tenants.

### Test and troubleshoot Conditional Access policies

**Core Troubleshooting Tools and Logs**

* **Sign-in Logs vs. Audit Logs**
  * **Sign-in Logs:** Used to track *how* a policy affected a specific user or authentication attempt. Includes the **Conditional Access tab**, which shows outcomes: Success, Failure, or Not Applied.
  * **Service Principal Sign-ins:** Dedicated tab for workload identities.
  * **Audit Logs:** Used to track *who* made administrative changes to the Conditional Access policy itself (e.g., changes made by an admin or the Optimization Agent).
  * **🚨 Exam Trap:** Do not use Audit Logs to see why a user was blocked; use Sign-in Logs. Conversely, do not use Sign-in Logs to see who edited a policy's target group; use Audit Logs.
* **The Conditional Access Tab (Deep Dive)**
  * Clicking the **ellipsis (...)** next to a policy provides a split-screen view.
  * **Left side:** Specific details collected during the sign-in (location, device state, client app).
  * **Right side:** Exact policy configuration requirements.
  * **"Not Applied" State:** Normal behavior indicating the sign-in did not match the baseline "If" conditions (e.g., user is explicitly excluded, accessing a different app, or signing in from a trusted IP).
* **Sign-in Diagnostic Tool**
  * Found under the **Basic info** tab of a sign-in event.
  * Automates analysis and provides suggested fixes when the Conditional Access tab lacks clarity.

**Report-Only Mode & Insights Workbooks**

* **Report-Only Mode Constraints**
  * **Cannot Evaluate User Actions:** Cannot be used to test policies scoped to "Register security information" or joining devices. Must be tested in the "On" state with a pilot group.
  * **Device Compliance Loops:** Users on macOS, iOS, and Android may get stuck in infinite device certificate prompt loops during evaluation.
  * **📋 Configuration Detail:** Explicitly exclude macOS, iOS, and Android platforms from report-only policies testing device compliance to prevent looping.
  * **JSON Downloads:** Must export logs in JSON format for offline report-only analysis; CSV downloads strip out the report-only result data.
* **Conditional Access Insights & Reporting Workbook**
  * **🔑 Prerequisite/Licensing Notes:** Requires a Log Analytics workspace, Azure Monitor subscription, Entra ID P1 licenses, and the admin must hold both **Security Reader** and **Log Analytics workspace Contributor** roles.
  * Aggregates policy impact over a period of up to 90 days.
  * **🛠️ Troubleshooting Detail - Empty Parameters:** If the "Conditional Access policies" parameter is empty in the workbook, ensure the selected time range contains active sign-ins. If the query fails, ensure the Log Analytics workspace schema is up to date and that `ConditionalAccessPolicies` JSON extraction is functioning properly.

**Testing with the "What If" Tool**

* **Core Requirements**
  * To initiate a simulation, you **must** define four parameters: **Identity, Target resource, Device platform, and Client app**.
  * **🚨 Exam Trap:** The What If tool evaluates single application targets but explicitly **does not test for Conditional Access service dependencies**.
* **Application Specification**
  * **📋 Configuration Detail:** You must provide the exact App ID. Selecting groups of apps, such as "Office 365" or "Microsoft Admin Portals", will not result in a match during a What If simulation.

**Service Dependencies (Early-Bound vs. Late-Bound)**

* **The Concept:** If a Conditional Access policy blocks access to a downstream resource (e.g., Exchange Online), the user will be blocked from the calling application (e.g., Microsoft Teams).
* **Enforcement Types:**
  * **Early-bound:** User must satisfy the downstream policy *before* signing into the calling app.
  * **Late-bound:** Enforcement is deferred until the app actively requests a token for the downstream service.
* **Comparison Table: Common Service Dependencies**

| Calling Application | Downstream Resource | Enforcement Type |
| :--- | :--- | :--- |
| Microsoft Teams | Exchange Online | Early-bound |
| Microsoft Teams | SharePoint Online | Early-bound |
| Microsoft Stream | Exchange Online | Late-bound |
| Microsoft Stream | SharePoint Online | Early-bound |
| Power Apps | Windows Azure Service Management API | Early-bound |

* **🛠️ Troubleshooting Detail:** Check the sign-in logs to see if the **Application** field differs from the **Resource** field. Use **Audience Reporting** under the Resource details to see all downstream services requested.
* **💡 Scenario Example:** A user signs into Azure Portal (Calling App) but is blocked. Log shows Resource = Azure Resource Manager. Resolution: Ensure policies target the "Windows Azure Service Management API" suite to unify controls across both apps.

**Continuous Access Evaluation (CAE) & IP Mismatches**

* **Propagation Latency:**
  * **IP/Location changes:** Enforced instantly.
  * **Critical Events (Password reset, risk detection, user deletion):** Up to **15 minutes** of propagation latency.
* **IP Address Mismatches (Split Tunneling & IPv4/IPv6)**
  * Occurs when Microsoft Entra ID and the downstream resource provider detect different IP addresses for the exact same client.
  * **Default Behavior:** Entra issues a **1-hour token** and suspends location checks to prevent infinite authentication loops.
  * **Strict Location Enforcement:** If configured in Session Controls to "Strictly enforce location policies", the mismatch causes an immediate block.
  * **🛠️ Troubleshooting Detail:** Expose the **"IP address (seen by resource)"** column in the Sign-in logs. It is normally blank, but populates during a mismatch. Identify the mismatched IP and add it to trusted **named locations**.
* **CAE for Workload Identities**
  * **🔑 Prerequisite/Licensing Notes:** Requires Workload Identities Premium.
  * **🚨 Exam Trap Constraints:** Only supports **single-tenant service principals** targeting **Microsoft Graph**. Application must declare the **`cp1` client capability**. Group assignments are ignored; policy must be assigned directly to the service principal.

**Token Protection Troubleshooting**

* **Supported Resources:** Exchange Online, SharePoint Online.
* **🚨 Exam Trap Constraints:**
  * Browser-based apps are not supported; only native apps are supported.
  * Windows client devices like Surface Hub and Microsoft Teams Rooms (MTR) are not supported.
  * Apple devices without Secure Enclave (e.g., older Mac minis) fall back to the Data Protection Keychain.
* **🛠️ Troubleshooting Error Codes (Sign-in Logs -> `signInSessionStatusCode`)**
  * **Code 1003:** Legacy registration — user can self-remediate with a one-time upgrade.
  * **Code 1004:** Not hardware-backed — user can self-remediate with a one-time upgrade.
  * **💡 Scenario Example:** Token protection blocks Azure Virtual Desktops or Cloud PCs because they use unsupported registration methods. Resolution: Add a device filter condition: `systemLabels -eq "CloudPC"` and `trustType -eq "AzureAD"` to exclude them.

**Device Filters and Complex Conditions**

* **Operators and Constraints:**
  * Max length for a filter rule is **3072 characters**.
  * Available dynamic attributes: `deviceOwnership` (Company/Personal), `systemLabels` (AzureResource/M365Managed/MultiUser), `trustType` (AzureAD/ServerAD/Workplace).
  * Administrators can map custom values using `extensionAttributes1-15`.
* **🚨 Exam Trap:** For `extensionAttributes1-15` to be evaluated during Conditional Access, the device *must* be Intune managed, compliant, or Entra hybrid joined.

**Conditional Access Optimization Agent (Microsoft Security Copilot)**

* **🔑 Prerequisite/Licensing Notes:** Requires at least Entra ID P1 and **Security Compute Units (SCUs)**.
  * SCUs are billed monthly based on provisioned capacity. Disabling the agent stops consumption but does not stop billing. Average run consumes < 1 SCU.
  * **Security Administrator:** Required to *activate* or set up the agent.
  * **Conditional Access Administrator:** Can view and approve agent suggestions.
* **Deep Analysis & MFA Gaps:**
  * Scans the *entire* tenant configuration, not just the last 24 hours.
  * **Zero Exceptions:** Flags strict policies with no exceptions and recommends the explicit exclusion of break-glass accounts to prevent tenant-wide lockouts.
  * **MFA Gap Limitations:** Only evaluates MFA gaps (not device compliance) and ignores policies deployed in Report-only mode. Caps display at 100 uncovered users.
* **Policy Consolidation:**
  * Merges policies with overlapping grant controls if they differ by **no more than two conditions or controls**. Evaluates up to 40 policy pairs per run.
* **Reviewing and Applying Changes:**
  * Agent suggestions default to **report-only mode**.
  * **🚨 Exam Trap:** Suggestions **cannot be customized or overridden** directly in the UI before creation; however, admins can use the **Review policy changes** tab to see a highlighted JSON view of the exact code changes and download affected users/apps before clicking apply.
  * *Exception via Chat:* You *can* use the Copilot Chat interface to prompt exclusions before applying (e.g., "Exclude user1 from this policy").
* **Logs and Monitoring:**
  * **Microsoft Purview Logs:** Tracks tenant-level admin interactions with the Copilot platform.
  * **Microsoft Entra Audit Logs:** Tracks the actual creation/modification of Conditional Access policies by the agent.
* **Comparison Table: Optimization Agent vs. Copilot Chat**

| Capability | Optimization Agent | Copilot Chat |
| :--- | :--- | :--- |
| Automated improvement suggestions | ✅ | ❌ |
| Continuous policy assessment | ✅ | ❌ |
| One-click policy changes | ✅ | ❌ |
| Identify unprotected users/apps proactively | ✅ | ❌ |
| Interactive troubleshooting / On-demand insights | ❌ | ✅ |
| Advanced reasoning (e.g., "Does this policy apply to Alice?") | ❌ | ✅ |

**Microsoft Entra Outages & Resilience Defaults**

* **Backup Authentication Service:** Automatically issues access tokens for *existing* sessions during an outage. Cannot process new sign-ins or guest authentications.
* **Resilience Defaults:** Allows the Backup Auth Service to rely on data collected at the start of a user's session because it cannot evaluate real-time conditions (role/group membership, GPS) during an outage.
* **🚨 Exam Trap (Disabling Defaults):** If you disable resilience defaults on a sensitive policy and assign it to a **group or role**, Microsoft Entra cannot evaluate the membership during the outage and will fail closed, causing a **tenant-wide lockout**. Only disable resilience defaults for policies assigned to *individual users*.
* **🛠️ Troubleshooting Detail:** You cannot simulate an outage. To monitor background tests, filter Sign-in logs for **"Token issuer type == Microsoft Entra Backup Auth"**.

**Protected Actions and Emergency Access (Break-Glass)**

* **Reauthentication Loop Trap:** If an admin assigns a protected action to a Conditional Access policy that is set to "Off" or "Report-only", the policy can never be satisfied, trapping the admin in a reauthentication loop.
* **🛠️ Troubleshooting Detail:** Use the bypass URL **`https://aka.ms/MSALProtectedActions`** to force open the Conditional Access page and fix the state.
* **Emergency Access Naming Standards:**
  * **📋 Configuration Detail:** Create contingency policies disabled by default. Use a strict naming convention: `ENABLE IN EMERGENCY: [Disruption][i/n] - [Apps] - [Controls]`. Example: `EM01 - ENABLE IN EMERGENCY: MFA Disruption [1/4] - Exchange SharePoint: Require Microsoft Entra hybrid join`.

## Plan, implement, and manage Microsoft Entra user authentication

### Enable Microsoft Entra Kerberos authentication for hybrid identities

###### **1. Architecture, Prerequisites, and Synchronization Requirements**

* **Identity and Operating System Prerequisites**
  * **OS Minimum Baseline:** Devices must run **Windows 10 version 2004 or later** (includes Windows 11) to recognize Microsoft Entra ID as a Key Distribution Center (KDC) and cache the Cloud Ticket Granting Ticket (TGT).
  * **Baseline AD Group Requirement:** Hybrid users are strictly required to be members of the standard **Domain Users** group.
  * **Trust Model Priority:** Cloud Kerberos Trust and Windows Hello for Business (WHfB) certificate trust cannot coexist. Certificate trust policies take absolute precedence; if present, cloud trust will not function.
* **Essential Entra Connect Synchronization Attributes**
  * **`onPremisesSamAccountName`**: Critical identity link formatting the Kerberos ticket for the local account (maps to `accountName`).
  * **`onPremisesDomainName`**: Maps to `domainFQDN`.
  * **`onPremisesUserPrincipalName`**: Required for hybrid authentication.
  * **`onPremisesSecurityIdentifier`**: Maps to `objectSID`.

###### **2. Ticket Types and Authentication Flows**

**Table 2.1: Kerberos Ticket Types Comparison**

| Feature | Cloud TGT | OnPremTgt (Partial TGT) |
| :--- | :--- | :--- |
| **Issuer** | Microsoft Entra ID | Microsoft Entra ID |
| **Realm** | `KERBEROS.MICROSOFTONLINE.COM` | Local On-Premises AD Domain |
| **Contents** | Fully formed for cloud (RBAC authorization data) | Contains user SID only (no PAC / group claims) |
| **Dependency** | No on-premises DC dependency | Must be presented to local DC for ticket exchange |
| **Resource Access** | Cloud resources (e.g., Azure Files) | Legacy on-premises resources (SMB shares, SQL) |
| **Citation** | | |

* **Scenario Example (Hybrid Access Flow):**
    1. User logs in via WHfB passwordless credential.
    2. Entra ID issues an `OnPremTgt` holding only the user's SID.
    3. Client contacts on-premises DC; DC evaluates the `AzureADKerberos` Read-Only Domain Controller (RODC) Password Replication Policy (PRP).
    4. If authorized via PRP Allowlist, DC injects the full Privilege Attribute Certificate (PAC) with group claims, converting it to a full Active Directory TGT for local access.
* **Scenario Example (Cloud-Only Access Flow):**
    1. User (existing only in Entra ID) signs in.
    2. Entra ID issues a `Cloud TGT`.
    3. Client requests Azure Files service ticket directly from Entra ID via KDC Proxy.
    4. Authorization relies entirely on Azure RBAC; no on-premises RODC object or ticket exchange is needed.

###### **3. On-Premises Server Objects and Security Boundaries**

* **Setup Cmdlet Configuration Details**
  * **Cmdlet:** `Set-AzureADKerberosServer` automates logical Kerberos server object creation.
  * **Module:** Requires the `AzureADHybridAuthenticationManagement` PowerShell module.
  * **Credentials Needed:** Requires simultaneous use of an on-premises **Domain Administrator** and a cloud-based **Hybrid Identity Administrator**.
  * **Object 1 (`CN=AzureADKerberos`):** Computer object acting as a logical RODC.
  * **Object 2 (`CN=krbtgt_AzureAD`):** Disabled user object holding the TGT encryption key.
  * **Object 3 (SCP):** ServiceConnectionPoint at `CN=900274c4-b7d2-43c8-90ee-00a9f650e335,CN=AzureAD,CN=System...` used by administrative tools to locate the server objects.
* **Password Replication Policy (PRP) Security**
  * **Configuration Detail:** The RODC object's PRP default should be set to **Deny**, with explicit **Allow** permissions only granted to authorized groups.
  * **🚨 Exam Trap (High Privilege):** Microsoft explicitly recommends against relaxing the PRP to allow high-privilege accounts (like Domain Admins) to sign in to on-premises resources via Entra Kerberos due to attack vector risks.

###### **4. Client Configurations and Network Routing**

* **Client Policy Configuration Details**
  * **Setting:** Clients must be configured with `CloudKerberosTicketRetrievalEnabled = 1` via Intune CSP or Group Policy.
  * **Application:** Requires a policy refresh or a full device reboot to take effect; without it, the Cloud TGT is not fetched.
  * **Under the Hood HTTP Claim:** When requesting a Primary Refresh Token (PRT), the client explicitly signals the need for a Kerberos ticket by injecting the exact HTTP claim **`tgt = true`**.
  * **Return Payload:** Entra ID returns an encrypted payload containing `tgt_client_key`, `tgt_key_type`, and `tgt_message_buffer`.
* **Realm Mapping and KDC Proxy Details**
  * **Realm Mapping:** Tells Windows to route specific namespaces (e.g., `*.file.core.windows.net`) to the cloud realm (`KERBEROS.MICROSOFTONLINE.COM`) instead of local AD. Deployed via GPO or Intune `Kerberos/HostToRealm` CSP.
  * **KDC Proxy:** Encapsulates Kerberos TGS-REQ inside HTTPS for users on the internet. Requires the Windows **`WinHttpAutoProxySvc`** service to be running. Configured via the `"Specify KDC proxy servers for Kerberos clients"` GPO over port 443.

###### **5. Azure Files Storage and Access Scenarios**

* **Scenario Example (SMB Conditional Access Conflict):**
  * An admin enforces an "All cloud apps" Conditional Access MFA policy.
  * A user maps an Azure file share. Because SMB cannot process interactive MFA prompts, the user receives **"System error 1327: Account restrictions are preventing this user from signing in"**.
  * **Resolution:** Admin must exclude the auto-generated enterprise app format **`[Storage Account] <name>.file.core.windows.net`** from CA MFA policies.
  * **Note:** WHfB resolves this securely by generating a PRT stamped with an "MFA claim" at device lock screen sign-in, allowing silent background ticket issuance.
* **🚨 Exam Trap (Line-of-Sight Constraint):** End-users can securely *access* Azure file shares over the internet without line-of-sight to a DC. However, administrators attempting to *configure or edit* Windows NTFS ACLs using File Explorer **strictly require** unimpeded network connectivity to the on-premises domain controllers.
* **🚨 Exam Trap (Service Principal Expiration):** The auto-generated Microsoft Entra service principal password representing an Azure storage account automatically expires every **six months**. It must be manually rotated twice a year to prevent widespread Kerberos access failures.

###### **6. Scaling Constraints, Load Distribution, and Maintenance**

* **The 1,010 SID Limitation**
  * **Constraint:** Windows Kerberos caps ticket sizes at 1,010 Security Identifiers (SIDs).
  * **Impact:** If combined hybrid group memberships exceed this, SIDs are truncated, the ticket fails to issue, and SMB access fails.
  * **Troubleshooting Detail:** Triggers error **`140011 – KerberosUsersGroupNumberExceeded`** in Entra sign-in logs.
  * **Configuration Detail (Workaround):** For cloud-only identities, admins can add the `kdc_enable_cloud_group_sids` tag in the application manifest to allow PRT issuance, though permanent resolution requires group consolidation.
* **Performance Optimization**
  * To handle extreme evaluation load (e.g., Azure Virtual Desktop environments), processing is optimized via **automatic load distribution across all domain controllers within a site**.
* **Key Rotation Maintenance**
  * **🚨 Exam Trap (Tooling):** You must exclusively use `Set-AzureADKerberosServer -RotateServerKey` to rotate keys. Standard AD tools will update the local key but not the cloud key, causing an immediate authentication break.
  * **Verification:** `KeyVersion` (on-premises) must identically match `CloudKeyVersion` (Entra ID) via `Get-AzureADKerberosServer`.

###### **7. Troubleshooting Verification and Logs**

**Table 7.1: Troubleshooting Commands and Log Locations**

| Tool / Path | Primary Function / Inspection Target | Notes |
| :--- | :--- | :--- |
| **`dsregcmd /status`** | High-level PRT & SSO state check | Shows `CloudTgt : YES` boolean flag, but does *not* inspect local cache. |
| **`klist cloud_debug`** | Explicit Kerberos cache inspection | Primary tool to verify a Cloud TGT is successfully sitting in the Windows cache. |
| **`tgt_cloud`** | MacOS cache inspection | Equivalent verification tool for MacOS devices using Platform SSO. |
| **`C:\ProgramData\AADConnect\`** | Setup trace logs | Hidden folder. Look for `trace-*.log` to troubleshoot `Set-AzureADKerberosServer` failures. |
| **Kerberos.NET Fiddler** | Deep HTTPS network diagnostics | Decrypts and inspects HTTPS KDC Proxy traffic traveling between the client and Entra ID. |
| **Citation** | | |

### Implement and manage Windows Hello for Business

###### **Device Encryption & Data Protection**

* **Personal Data Encryption (PDE)**
  * **Configuration Details:**
    * Encrypts **individual files** using AES-CBC with a 256-bit key.
    * Decryption keys are released *only* at the time of user sign-in via Windows Hello.
    * Keys are immediately discarded upon sign-out.
    * **Known Folders:** In Windows 11 24H2+, administrators can auto-encrypt the **Desktop, Documents, and Pictures** folders.
  * **📝 Prerequisites & Licensing:**
    * Strictly requires **Microsoft Entra joined** or **Microsoft Entra hybrid joined** devices (traditional on-premises domain-joined is not supported).
    * Mutually exclusive with legacy Encrypting File System (EFS).
  * **🚨 Exam Traps:**
    * **Authentication Exclusions:** Access is explicitly denied if the user signs in with a password or a FIDO2 security key.
    * **Remote Access:** Content cannot be accessed remotely via Remote Desktop (RDP) sessions or UNC network paths.
    * **Other Users:** Other users signed into the same device cannot access the content, even with NTFS permissions.
  * **🔧 Troubleshooting & Recovery:**
    * A **destructive PIN reset** permanently destroys the cryptographic material tied to the PIN, permanently bricking access to the local PDE files.
    * There is absolutely **no backdoor or administrator override** to decrypt the files if keys are lost.
  * **Scenario Example:** A user forgets their PIN. To prevent data loss, the administrator should instruct them to use the **Windows Hello for Business PIN reset service** for a *nondestructive* reset. If they perform a destructive reset, they must recover cleartext files synced from **OneDrive in Microsoft 365**. If PDE "Level 2" protection is enabled, files become inaccessible exactly **one minute** after the Windows lock screen engages.

**📊 Comparison Table: Encryption Boundaries (PDE vs. BitLocker)**

| Feature | Scope of Encryption | Key Release Trigger | Authorized Fallback Methods | Data Loss Risk |
| :--- | :--- | :--- | :--- | :--- |
| **BitLocker** | Entire Volume / Drive at rest. | System boot. | Recovery Password, USB Key. | Low (Admin can use Recovery Key). |
| **Personal Data Encryption (PDE)** | Individual Files (AES-CBC 256). | User sign-in (WHfB only). | **None** (FIDO2 & Passwords blocked). | High (Destructive PIN reset destroys keys). |

###### **Windows Passwordless Experience & User Deconditioning**

* **Step 2: "Journey to Password Freedom"**
  * **Configuration Details:** The goal is reducing the user-visible password surface area to decondition users from typing passwords (mitigating phishing).
  * **App Mitigation Strategies (Ideal SSO):**
    * *Cloud/Modern Apps:* Integrate natively with **Microsoft Entra ID**.
    * *On-Premises Apps:* Update to use **Windows integrated authentication**.
    * *Standalone Databases:* Integrate with the centralized directory instead of relying on isolated SQL credentials.
* **Password Surface Reduction Policies**
  * **🚨 Exam Traps & Policy Distinctions:**
    * **Windows Passwordless experience:** The recommended option. Completely **hides the password option** on the lock screen (Entra-joined only).
    * **Require Windows Hello for Business or a smart card:** Blocks password use but **leaves the password prompt visible**. Users attempting to use it get an error message.
    * **Exclude credential providers:** The "Nuclear" option. Disables password usage for **all accounts**, including local administrators, completely breaking RDP and "Run as" scenarios.

###### **Windows Hello Hardware Security & Attestation**

* **Enhanced Sign-in Security (ESS)**
  * **Configuration Details:** Creates a secure, hardware-isolated boundary between biometric sensors and the Windows OS using Virtualization-based Security (VBS).
  * **📝 Prerequisites:** Requires **specialized biometric sensors** and explicit **BIOS support** to establish trusted pathways. It is enabled by default on **Copilot+ PCs** and supported on Windows Pro, Enterprise (E3/E5), and Education (A3/A5).
  * **🔧 Troubleshooting:** Use the **`sktool.exe /lkey`** command-line utility to view VSM master key provisioning status.
  * **Scenario Example:** An administrator disables Secure Boot in the BIOS. The Virtual Secure Mode (VSM) master key fails to unseal. ESS will actively **refuse to accept the user's PIN or Face identification** to protect the credential.
* **Biometric Privacy Architecture**
  * **🚨 Exam Traps:** Biometric data **never** syncs to Microsoft Intune, Microsoft Entra ID, or the cloud. The biometric scan is only a local "trigger" to access the provisioned cryptographic key.
* **TPM Hardware Attestation (EK vs. AIK)**
  * **Configuration Details:** Prevents malware from mimicking a physical TPM during credential provisioning.
  * **Endorsement Key (EK):** Proves **hardware authenticity** (the TPM is a genuine chip from a trusted manufacturer).
  * **Attestation Identity Key (AIK):** Protects **privacy** by acting as a proxy for the EK, ensuring the device isn't permanently tracked across services. Microsoft acts as the identity CA to issue AIK certificates.

###### **TPM Anti-Hammering & Lockout Defense**

* **TPM Anti-Hammering Logic**
  * **Configuration Details:** TPM 2.0 has built-in dictionary attack protection that mathematically standardizes the "32/10 Rule".
  * **The Threshold:** The TPM completely locks down after **32 failed authorization attempts**.
  * **The Cooldown:** The TPM "forgets" one failure every **10 minutes**, provided the system is **powered on and running**.
  * **🔧 Troubleshooting:** A lockout generates **Event ID 1026**. The best administrative action is to **wait for the cooldown period to expire**.
  * **🚨 Exam Traps:**
    * **Global Lockout:** This is a global hardware lockout. It affects all users on the device and halts all TPM-dependent features, including BitLocker and virtual smart cards.
    * **Destructive Overrides:** Clearing the TPM factory resets the failure counter, but **destroys all existing keys**, causing catastrophic data loss for WHfB, PDE, and BitLocker. An immediate override without clearing requires the **TPM owner password**, which is randomly generated and discarded by default in modern Windows.

**📊 Comparison Table: Passwordless Lockout Behaviors**

| Lockout Component | Threshold | Recovery / Mitigation | Impact Scope |
| :--- | :--- | :--- | :--- |
| **Entra ID Smart Lockout** | Cloud-configured (default 10). | Wait for cloud timer (default 1 minute). | Single user cloud identity. |
| **TPM 2.0 Anti-Hammering** | **32 failed attempts**. | Wait **10 minutes** (powered on). | **Global** (All users + BitLocker). |

###### **Seamless Remote Access Integration**

* **Always On VPN & Passwordless SSO**
  * **Configuration Details:** Always On VPN natively supports WHfB to provide seamless SSO when auto-triggering on network changes.
  * **📝 Prerequisites:** The VPN profile must use **EAP-TLS** in **certificate-based authentication mode**. (Legacy EAP-MSCHAPv2 relies on passwords and breaks SSO).
  * **🚨 Exam Traps:**
    * **User Tunnel vs. Device Tunnel:** **User Tunnel** connects *after* logon (utilizing the WHfB certificate). **Device Tunnel** connects *before* logon strictly utilizing IKEv2 and machine certificates.
    * **Trusted Network Detection:** Administrators should configure DNS suffixes to prevent the VPN from auto-triggering if the user is physically inside the corporate network.
  * **Scenario Example:** A device falls out of Intune compliance. Because Always On VPN integrates with Microsoft Entra Conditional Access, Entra ID will **block the VPN connection** by refusing to issue the required short-lived IPsec authentication certificate.

