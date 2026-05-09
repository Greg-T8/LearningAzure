### **1. Mastering Device Filters (`Filter for devices`)**

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

### **2. Token Protection Enforcement**

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

### **3. Device Registration & Terms of Use Constraints**

* **The "Register or Join Devices" User Action:**
  * *Configuration Detail:* This action intentionally disables `Client apps`, `Filters for devices`, `Device state`, `Require device to be marked as compliant`, and `Require Microsoft Entra hybrid joined device` conditions/controls to prevent "chicken-and-egg" logical conflicts.
  * *Supported Controls:* Only **Require multifactor authentication** and **Require authentication strength** are permitted.
  * *Exam Trap (Authentication Methods):* You **cannot** use **Windows Hello for Business** or **device-bound passkeys** to fulfill the MFA requirement during registration, as both methods require the device to already be registered.
  * *Exam Trap (Tenant-Wide Conflict):* To successfully enforce this Conditional Access policy, you **must** set the legacy tenant-wide setting *"Require Multifactor Authentication to register or join devices with Microsoft Entra"* (found in Device Settings) to **"No"**.

* **Per-Device Terms of Use:**
  * *Prerequisite Note:* Enforcing "Require users to consent on every device" tracks compliance using the registered **device ID**.
  * *Exam Trap (App Exclusion):* You must explicitly exclude the **Microsoft Intune Enrollment app** (App ID: `d4ebce55-015a-49b5-a083-c84d1797ae8c`) from per-device Terms of Use policies. Failing to do so creates an infinite loop where device enrollments fail because the device is not yet registered to record the consent.
  * *Licensing/B2B Note:* Per-device Terms of Use are explicitly **not supported** for B2B guest users.

### **4. Mobile Devices & Broker Apps**

* **Broker App Architecture:**
  * *Prerequisite Note:* To apply **Require app protection policy** (MAM) or **Require approved client app** controls, the mobile device must be registered. A broker app is required to register the device and pass compliance state to Entra ID.

| Operating System | Supported Broker App(s) |
| :--- | :--- |
| **iOS** | Microsoft Authenticator |
| **Android** | Microsoft Authenticator OR Microsoft Intune Company Portal |

* *Exam Trap:* While Microsoft Authenticator acts as the broker to enforce MAM, the Authenticator app itself cannot be targeted as an "approved client app" in the policy.

### **5. Browser Identity & Session Security**

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

### **6. Specialized Flows & Restrictions**

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

### **7. AI Agents & Custom Security Attributes**

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

### **8. Global Secure Access (SSE Integration)**

* *Configuration Detail:* Use the **Use Global Secure Access security profile** setting located under **Session controls**.
* *Behavior:* This control bridges Conditional Access identity context (like risk or compliance) directly into Microsoft's Security Service Edge (SSE) network security rules, allowing web content filtering to dynamically adapt based on the user's real-time identity signals.
