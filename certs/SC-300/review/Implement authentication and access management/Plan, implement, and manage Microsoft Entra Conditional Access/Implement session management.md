### SC-300 Study Review Sheet: Implement Session Management (Expanded)

#### 1. Sign-in Frequency

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

#### 2. Persistent Browser Sessions

* **Core Mechanics**
  * Dictates whether cookies accessing Entra artifacts remain stored on the device after the browser is closed.
  * **Hierarchy of Control:** Configuring this session control in Conditional Access explicitly **overrides** the default "Stay signed in?" user prompt managed in the tenant's company branding pane.
* **🚨 Exam Traps**
  * **The "All Cloud Apps" Requirement:** Because all tabs within a single browser session share the exact same authentication session token, persistence cannot be divided among individual tabs. You **must** select **"All Cloud Apps" (All resources)**. Targeting a single app like Exchange Online is an invalid configuration.

#### 3. Continuous Access Evaluation (CAE)

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

#### 4. CAAC vs. App Enforced Restrictions

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

#### 5. Token Protection (Token Binding)

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

#### 6. Resilience Defaults & Backup Authentication

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

#### 7. Protocol Tracking & Authentication Flows

* **Core Mechanics**
  * Monitors specific authorization pathways, notably **device code flow** and **authentication transfer** (e.g., scanning a PC QR code to transfer authentication to a mobile device).
  * **Session Persistence:** Once initiated, the protocol tracked state **is sustained through subsequent token refreshes** within the session.
* **Scenario Examples**
  * *Scenario:* An admin blocks device code flow for Exchange Online, but allows it for SharePoint. A user authenticates to SharePoint using device code flow (session becomes protocol tracked). Later, the user clicks an Exchange Online link in the same browser. *Solution:* The user is immediately blocked from Exchange Online because the device code flow origin persists on the session state.
* **🚨 Exam Traps**
  * Do not confuse "Protocol Tracking" with "Conditional Access App Control" (Defender for Cloud Apps session monitoring). Connect Protocol Tracking strictly to **Authentication flows** conditions.

#### 8. Intune Device Enrollment App Quirks

* **Configuration & Troubleshooting Details**
  * **New Tenant Bug:** The **Microsoft Intune Enrollment** cloud app is not generated automatically in new Entra ID tenants.
  * **Resolution:** Admins must manually create the service principal using Graph/PowerShell targeting App ID **`d4ebce55-015a-49b5-a083-c84d1797ae8c`** to make it appear in the Conditional Access picker.
* **🚨 Exam Traps**
  * **Targeting Distinction:** Target *Microsoft Intune Enrollment* for a one-time MFA prompt during the initial Setup Assistant phase. Target *Microsoft Intune* for MFA prompts upon every subsequent Company Portal app sign-in.
  * **Device Rules:** Do **not** configure "Device based access rules" for Microsoft Intune enrollment.

#### 9. Microsoft Entra External ID Limitations

* **🚨 Exam Traps**
  * If an exam scenario specifically mentions an **External ID external tenant** (B2C/customer-facing), you are strictly limited to configuring only two session controls:
        1. **Sign-in frequency** (including "Every time" for OAuth 2.0/OIDC apps).
        2. **Persistent browser session**.
  * All other controls (CAE configuration, CAAC, Token Protection, App Enforced Restrictions, Resilience Defaults) are unsupported and invalid for external tenants.
