### **1. Microsoft Entra ID Protection Architecture & Licensing**

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

### **2. Risk Types & Adaptive Self-Remediation**

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

### **3. Common Risk-Based Conditional Access Policies (Implementation)**

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

### **4. Risk Detection Event Types (Categorized by Risk Tier)**

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

### **5. Administrative Risk Management & Log Diagnostics**

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

### **6. Advanced Conditional Access Integrations**

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

### **7. Authentication Methods & Migration**

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

### **8. Securing Workload Identities**

* **Risk Detections for Non-Human Accounts**
  * **Mechanics:** Workload identities (service principals) cannot perform MFA, often have no formal lifecycle, and rely on stored secrets. Because they cannot perform MFA, they **cannot self-remediate**.
  * **🔧 Troubleshooting Details:** To investigate, review the **Risky workload identities** report for suspicious IPs, unauthorized changes to credentials, or unauthorized app role acquisitions.
  * **Remediation & Configuration:** Because self-remediation is impossible, admins must manually remove compromised credentials, rotate Azure KeyVault secrets, or disable the service principal. Administrators *can* use Conditional Access to automatically enforce a **Block access** control for risky workloads.
