**SC-300 Exam Master Review Sheet: Implement and Manage Policies for OAuth Apps**

### **1. Core Architecture & Prerequisites**

* **App-to-App Protection Fundamentals**
  * Secures non-human identities (third-party OAuth apps) by governing inter-app data exchanges to prevent unauthorized access via token-based illicit consent grant attacks.
  * **App Governance Pillars:** Insights (visibility), Governance (policies), Detection (anomalies), and Remediation (automated blocking).
* **Prerequisites & Licensing Notes**
  * **Microsoft 365 Connector:** Required to view the exact files, folders, or mailboxes an OAuth app interacts with.
    * Must select the "Microsoft 365 activities" checkbox during setup to populate the `CloudAppEvents` advanced hunting table.
  * **Unified RBAC (Dec 2025 Update):** To manage Defender for Cloud Apps permissions, you must activate the Defender for Cloud Apps workload within Microsoft Defender unified RBAC.
    * *Configuration Detail:* Activating this workload permanently disables legacy, individual Defender solution roles.

### **2. Visibility, Dashboards, & Navigation**

* **Dashboard Navigation rules (Based on App Governance status)**
  * *Without App Governance enabled:* Use the **OAuth apps** page and the standard **Policy management** page to view app metrics.
  * *With App Governance enabled:* Functionality shifts; you must use the **App governance** page (under Microsoft Defender XDR) for visibility and policy creation.
* **Policy Creation Paths (App Governance)**
  * *Microsoft 365 policies:* Navigate to `App governance > Policies > Microsoft 365`.
  * *Salesforce & Google Workspace policies:* Navigate to `App governance > Policies > Other apps`.
  * *Exam Trap:* Do not navigate to SaaS Security Posture Management (SSPM) to create OAuth behavioral policies; SSPM handles overarching configuration assessments via Microsoft Security Exposure Management.
* **Key Visibility Metrics**
  * **Authorized by:** Displays the specific list of user emails who granted the app access.
  * **Permissions Level:** Lists specific permissions (e.g., read mail) and classifies them as High, Medium, or Low.

### **3. Remediation Actions: Ban vs. Revoke**

When an app is deemed malicious, remediation actions behave differently depending on the cloud ecosystem.

| Remediation Action | Target Environment | Technical Result | Blocks Future Consent? |
| :--- | :--- | :--- | :--- |
| **Ban App** | Microsoft 365 | Disables the Enterprise Application in Microsoft Entra ID. | Yes, but **leaves existing permissions intact** in the directory. |
| **Ban App** | Google / Salesforce | Completely revokes existing permissions. | Yes, explicitly bans future consent. |
| **Revoke App** | Google / Salesforce | One-time removal of all previously granted permissions. | No, does not block future consent if requested again. |

* *Scenario Example:* An administrator clicks "Ban" on an M365 app. The user immediately loses access because the Entra ID Enterprise App is disabled, but if the admin investigates the directory, the app's granted permissions are still visible for auditing.
* *Configuration Detail:* Pairing a ban/revoke action with the **Notify user** governance action sends a customizable email to the user explaining the security conflict.

### **4. Policy Configuration & Filter Logic**

* **Consenting Users vs. App Owners**
  * *Exam Trap:* Never use the "App owner group" filter to govern app usage; it only targets the developers/managers of the app.
  * *Configuration Detail:* Use the **Group memberships** filter to target the end-users who authorized the app. This allows you to apply strict automated revocation *only* when highly privileged users (e.g., Administrators) grant access.
* **Hunting Malicious Grants (Community Use Filter)**
  * Identifies how popular an app is globally (Common, Uncommon, Rare).
  * *Scenario Example:* An attacker creates a bespoke phishing app requesting full mailbox access.
  * *Microsoft Best Practice Configuration:* Create a custom policy where **Permission level equals High** AND **Community use equals Rare** or **Uncommon**. Configure the governance action to automatically revoke the app.

### **5. App Hygiene, Data Usage, & Privilege Management**

* **Total Graph API Data Access**
  * Tracks email, file, and Teams chat data accessed via Microsoft Graph and EWS APIs.
  * *Configuration Detail:* Automate defenses by triggering policies based on **Data usage** (hard volume limits) or **Data usage trends** (percentage spikes compared to previous day).
* **App Hygiene & Privilege Classifications**
  * Hygiene relies on monitoring unused apps and checking both current and expired credentials.

| Classification | Definition | Security Risk |
| :--- | :--- | :--- |
| **Unused App** | The *entire application* has not requested a token/been used in 90 days. | Abandoned backdoors / credential theft. |
| **Overprivileged App** | The app is active, but specific *permissions* granted have not been used in 90 days. | **Horizontal privilege escalation** (attacker hijacks unused scopes). |
| **Reducible Permissions** | App uses a permission, but a lower-tier version would suffice (e.g., uses `ReadWrite.All` but only reads). | **Vertical privilege escalation**. |

* *Troubleshooting Detail:* If a dormant multitenant app suddenly activates and makes massive API calls to Azure Resource Manager or Graph, it triggers an `"Unused app newly accessing APIs"` threat alert, indicating compromise.

### **6. Built-In Anomaly Detection Policies**

* *Prerequisite Note:* All built-in anomaly detection policies only scan apps *actively authorized* in Entra ID.
* *Exam Trap:* The **severity level cannot be modified** by administrators for these policies.
* **Specific Threat Policies:**
  * **Malicious OAuth app consent:** Uses Microsoft threat intelligence to stop illicit consent grant attacks (phishing).
  * **Misleading OAuth app name:** Detects visual spoofing/homoglyphs (e.g., Cyrillic characters) in the app name.
  * **Misleading publisher name for an OAuth app:** Detects identical visual spoofing tactics but exclusively scans the publisher's name field.
  * **OAuth application activity from an unknown ISP:** Dynamically monitors legitimate apps and alerts if connection originates from an uncommon ISP. *(Note: Previously named "Unusual ISP for an OAuth App" prior to dynamic model upgrade)*.

### **7. Troubleshooting & Policy System Limits**

* **Policy Overload Limits**
  * *Troubleshooting Detail:* If an activity or app policy triggers more than **200,000 matches per day** (or 100,000 per 3 hours), it is **automatically disabled** to prevent system fatigue.
  * *Resolution:* Refine the policy by adding strict filters. If tracking bulk events is required for auditing, save the criteria as an Advanced Hunting query instead.
* **Policy Conflict Resolution Rules**
  * If multiple policies trigger simultaneously on the same event, the system processes overlapping actions via strict logic:
    * **Unrelated Actions:** Both actions execute (e.g., *Notify owner* + *Make private*).
    * **Contained Actions:** Only the stronger action executes (e.g., *Remove external shares* + *Make private* -> enforces Make private).
    * **Direct Conflicts:** Causes unpredictable results; must be avoided (e.g., *Change owner to User A* + *Change owner to User B*).

### **8. Shadow IT & MDE Endpoint Blocking**

* **App Discovery Policy Configuration**
  * To monitor Shadow IT, use the **New risky app** policy template.
  * *Configuration Detail:* Baseline thresholds for this template are: Risk score < 6, > 50 users, and > 50 MB of daily traffic.
* **Enforcement via Microsoft Defender for Endpoint (MDE)**
  * Set the policy governance action to **Tag app as unsanctioned**.
  * *Exam Trap:* Unsanctioned domains sync as Custom Network Indicators to MDE. These indicators **do not support full URLs**, only subdomains (e.g., unsanctioning `google.com/drive` fails; you must unsanction `drive.google.com`).
  * *Prerequisites:* Requires Microsoft Defender XDR Custom network indicators enabled, Antivirus Real-time protection enabled, and Network Protection in Block mode.

### **9. Critical Exam Timeframes & Latencies**

* **< 15 Minutes:** Time required to deploy a newly created threat detection or activity policy. *(Note: Policies do not retroactively alert on past events)*.
* **< 2 Hours:** Time required for discovery data to initially sync after enabling the MDE integration.
* **< 3 Hours:** Total latency for an app to be physically blocked on an endpoint device after being tagged "Unsanctioned" (1 hour MDE sync + 2 hours endpoint push).
* **90 Days:** The timeframe required for App Governance to calculate baselines and classify an app/permission as "Unused".
* **1 Year:** Strict validity period for the SAML certificate used by Defender for Cloud Apps for manual Conditional Access App Control routing. *Exam Trap:* This certificate **does not auto-renew**.

### **10. Adjacent Concepts: Attack Paths, AI Agents, & Secure Score**

* **Microsoft Attack Paths:**
  * OAuth apps holding "critical privilege OAuth permissions" are mapped as **target goals** and **high-value assets** because they allow lateral movement to SaaS data.
  * *Troubleshooting Detail:* Filter attack paths by Target Type: `AAD Service principal`.
* **AI Agent Protection (Nov 2025 Update):**
  * *Copilot Studio:* Provides **real-time runtime blocking** to stop prompt injection attacks.
  * *Azure AI Foundry:* Provides **posture management** by monitoring for underlying misconfigurations and vulnerabilities.
* **Microsoft Secure Score (March 2026 Update):**
  * To improve accuracy, several *Cloud apps recommendations* were re-categorized and moved to the **Identity category**.
  * *Exam Trap:* This shift alters individual category metrics, but the **total Secure Score remains unchanged**.
