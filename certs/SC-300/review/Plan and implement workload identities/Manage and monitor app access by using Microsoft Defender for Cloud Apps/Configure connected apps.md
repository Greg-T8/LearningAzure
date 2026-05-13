### **Exhaustive Study Review Sheet: Configure Connected Apps (SC-300 Exam)**

**1. Architecture & Core Mechanics of App Connectors**

* **Connection Mechanism:**
  * App Connectors utilize direct, authenticated **API tokens/keys** to deeply manage cloud apps, as opposed to Cloud Discovery which passively parses network traffic logs.
  * Connecting an app via its API unlocks the ability to perform **Data scans** (reading unstructured data) and **Data governance** (taking automated actions like quarantining or overwriting files).
* **The Auto Sanctioned State:**
  * Any application explicitly connected via an App Connector is automatically transitioned to an **Auto Sanctioned** state, bypassing manual review requirements.
* **Data Scan Intervals:**
  * **Real-time scan:** Triggered immediately every single time a change to a file is detected.
  * **Periodic scan:** A comprehensive background scan runs **every 12 hours** to ensure all files are evaluated, even unmodified ones.
  * **API Throttling:** Scanning spreads requests out to respect cloud provider API limits; initial scans may take hours or days.
* **Quarantine Mechanics & Comparison:**

    | Quarantine Type | Mechanism | User Experience & Self-Service |
    | :--- | :--- | :--- |
    | **User Quarantine** | Moves the violating file to a user-controlled quarantine folder. | Allows for user self-service; the user can review the file and potentially restore it. |
    | **Admin Quarantine** | Removes the file entirely from the user's reach and moves it to an admin-controlled drive. | Original file is replaced with a **tombstone file** in its original location containing IT guidelines and a correlation ID. Requires IT approval for release. |

**2. Multi-Instance Governance**

* **The API Requirement:** Defender for Cloud Apps explicitly supports connecting and independently managing multiple instances of the same third-party app (e.g., two distinct Salesforce tenants), but this is **exclusively supported for API-connected apps**.
* **Unsupported Methods:** Administrators absolutely cannot manage multiple instances via **Cloud Discovered apps** or **Proxy connected apps** (Conditional Access App Control).
* **🚨 Exam Trap (The Microsoft Exception):** Even when using API App Connectors, **Microsoft 365 and Azure explicitly do not support multi-instance connections**.

**3. Microsoft 365 App Connector Configuration**

* **Configuration Details & Prerequisites:**
  * Connecting M365 does not automatically start file scanning; an administrator must navigate to **Settings > Cloud Apps > Files** and explicitly check **Enable file monitoring**.
  * The administrator performing this action must hold either the **Application Administrator** or **Cloud Application Administrator** role in Microsoft Entra ID.
  * **Purview Integration:** Administrators can also enable Microsoft Information Protection settings to automatically scan new M365 files for sensitivity labels.
  * **Scanning Dependency:** The engine will explicitly not scan or store files unless information protection policies are actively configured.
* **🚨 Exam Trap (The Auto-Disable Rule):** If an administrator enables file monitoring but fails to create a file policy, or if all file policies are disabled for **7 consecutive days**, Defender for Cloud Apps will **automatically turn the file monitoring feature off**.
* **M365 User Governance Actions Comparison:**

    | Governance Action | Underlying Mechanism | Primary Use Case |
    | :--- | :--- | :--- |
    | **Require user to sign in again** | **Revokes all refresh tokens and session cookies**, forcing a fresh interactive sign-in. | Non-destructive way to stop a potentially hijacked session in its tracks. |
    | **Confirm user compromised** | Elevates the user's risk level to **high** directly within Microsoft Entra ID. | Bridges CASB with Entra ID Protection to trigger risk-based Conditional Access policies (e.g., secure password reset). |
    | **Suspend user** | Outright blocks access by suspending the user account. | Immediate access termination for severe incidents. |
    | **Notify user** | Sends a customized alert via email. | User awareness for lower-severity anomalies. |

* **🚨 Exam Trap (The Hybrid Directory Sync limitation):** If the tenant automatically synchronizes user states from an **on-premises Active Directory**, the AD settings act as the source of truth and will automatically overwrite and revert the **Suspend user** governance action.

**4. Third-Party App Connectors**

* **Google Workspace Connector:**
  * **Prerequisite/Licensing Note:** Configuration requires a **Google Workspace Super Admin** account (lesser accounts fail the API test) and a dedicated project yielding a **Service account ID**, **Project number**, and **P12 Certificate**.
  * **🚨 Exam Trap (The Licensing Checkbox):** Administrators must explicitly check the **Google Workspace Business or Enterprise account** checkbox to enable instant visibility, protection, and governance. Failing to check this box (or lacking the paid Google license) disables near real-time DLP, deep user activity monitoring, and advanced sharing controls.
  * **Scenario Example:** An organization wants to block real-time sharing of credit card data via Google Drive. The administrator must ensure the Business/Enterprise checkbox is selected during connector setup to unlock the required API data controls.
* **Box Connector:**
  * **Configuration Detail:** Box requires a **regional API key** that corresponds directly to the specific Defender for Cloud Apps data center location (e.g., US1 vs EU1).
  * **Troubleshooting Detail:** To find the correct regional data center, navigate to **Settings > Cloud Apps > System > About**.
  * **🚨 Exam Trap (The Privilege Requirement):** Deployment requires a full **Admin account**; using a "Co-Admin" account results in a failed API test and incomplete file scanning.
* **Cisco Webex Connector:**
  * **Configuration Detail:** The connecting account must hold both the **Full Administrator** and **Compliance Officer** roles in Webex.
  * **Best Practice:** Use a **dedicated service account** for the connection so that automated governance actions (like trashing files) clearly appear in the audit logs under the service account rather than a human administrator.
  * **🚨 Exam Trap (Scanning Limitations):** The connector only ingests and scans attachments shared in **Webex chats**; attachments from **Webex meetings** are explicitly excluded.

**5. Advanced Threat Detection & App Governance Integrations**

* **Baseline Learning Periods:**
  * The machine-learning anomaly detection engine requires an **initial learning period of 7 days** to establish a baseline for user behavior, during which **location-based anomaly alerts are explicitly suppressed**.
  * **🚨 Exam Traps (Baseline Exceptions):**
    * Standard anomalies (Impossible travel): **7 days**.
    * Unusual file access (by user): **21 to 45 days**.
    * Unusual ISP for an OAuth App: **30 days**.
* **App Governance (OAuth App Monitoring):**
  * App Governance targets API connections by monitoring **OAuth-enabled apps** to maintain app hygiene.
  * Identifies: **Unused apps** (no activity in 90 days), **Overprivileged apps** (Graph API permissions granted but unused in 90 days), and **Highly privileged apps**.
* **Advanced Hunting Integration (Incident Response):**
  * To investigate OAuth app activities and scope breaches, administrators must query the **CloudAppEvents** table in Microsoft Defender XDR advanced hunting.
  * **Configuration Prerequisite:** The `CloudAppEvents` table will not populate M365 data unless the administrator navigates to the App connectors settings and explicitly selects the **Microsoft 365 activities** checkbox.

**6. Licensing Boundaries for Connected Apps**

* **Comparison: Microsoft Defender for Cloud Apps vs Office 365 Cloud App Security**

    | Feature / Capability | Full Microsoft Defender for Cloud Apps | Office 365 Cloud App Security (CAS) |
    | :--- | :--- | :--- |
    | **App Connectors Support** | **Cross-SaaS:** Supports all third-party App Connectors (Salesforce, Google, AWS, Box, etc.). | **Subset limitation:** Strictly supports **only the Office 365 App Connector**. |
    | **Cloud Discovery Catalog** | Evaluates network traffic against **over 34,000 cloud apps**. | Limited to **750+ cloud apps** with similar functionality to O365. |
    | **Data Loss Prevention (DLP)**| Features a native, cross-SaaS DLP engine. | Relies entirely on existing Office DLP policies (requires Office E3+). |
    | **Threat Detection Scope** | Applies behavioral analytics and SIEM alerts across all connected apps. | Restricts threat detection and alerts exclusively to Office 365 activities. |
