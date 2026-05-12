### **1. Data Ingestion and Reporting Architecture**

| Feature | Snapshot Reports | Continuous Reports |
| :--- | :--- | :--- |
| **Visibility Type** | Ad-Hoc / Point-in-Time. | Automated / Ongoing. |
| **Data Ingestion** | Manual upload of up to 20 log files (compressed/zipped supported). | Automated streaming via MDE, Log Collectors, or SWG. |
| **Primary Use Case** | Proof of Concept (PoC) or initial security audits. | Real-time tracking, anomaly detection, and custom alerting. |
| **Automated Policies** | **Cannot** trigger app discovery policies or automated governance actions. | Feeds Machine Learning anomaly detection and triggers custom app discovery policies. |

* **Log Collector Operations:**
  * **Deployment:** Deployed as a Docker/Podman container on a Windows or Linux server.
  * **Supported Protocols:** Natively receives logs via **FTP/FTPS** or **Syslog (UDP/TCP/TLS)**.
  * **FTP Ingestion Mechanism:** Waits until the file transfer is completely finished before processing.
  * **Syslog Ingestion Mechanism:** Listens to live streams. Waits until its local file reaches a **40 KB threshold** before bundling and uploading.
  * **Bandwidth Efficiency Configuration:** Aggressively compresses data so the outbound payload is only **10%** of the original log size.
  * **Network Prerequisites:** Requires outbound communication over **TCP port 443** to reach the portal.
* **Custom Log Formats (For Unsupported Appliances):**
  * **Configuration:** Select **Custom log format...** to build a CSV or key-value parser.
  * **Formatting Constraints:** Required fields are explicitly **case-sensitive** and must be defined in the **exact same sequence** as they appear in the dialog box. Extra fields in the log are discarded.
  * **The "Other" Option:** Selecting **Other** sends the unsupported log directly to Microsoft’s cloud analyst team for review and potential future support.
  * **Scenario Tip:** **Destination URLs are highly recommended over Destination IP addresses** because URLs provide much higher accuracy for identifying cloud apps.

### **2. Cloud App Catalog & Risk Scoring**

| Risk Category | What it Evaluates | Examples of Metrics Assessed |
| :--- | :--- | :--- |
| **General** | Company stability and reliability. | Domain age, consumer popularity, **App Headquarters location**. |
| **Security** | Technical data protections. | Encryption-at-rest, MFA support, **Requires user authentication**. |
| **Compliance** | Industry standards and certifications. | SOC 2, HIPAA, PCI-DSS, ISO 27001. |
| **Legal** | Privacy and data retention policies. | GDPR readiness, DMCA. |

* **Catalog Capabilities:** Tracks over **31,000 discoverable cloud apps**, evaluating them against **90+ risk factors** to assign a 1-10 risk score. Includes specialized functional groupings like the **Generative AI** category.
* **Risk Scoring Configuration & Traps:**
  * **Score Metrics:** Adjusts the weight of risk categories (Ignored to Very High) for **all** apps in the environment.
  * **Override App Score:** Modifies the score for a **single, specific app** without affecting the catalog.
  * **N/A Values Checkbox:** If checked, apps lacking transparent documentation for a specific property receive a penalty to their calculated score.
* **Vulnerability Hunting: Anonymous Use:**
  * **The Risk:** Apps permitting anonymous use are flagged because they **allow users to upload data without authentication**, bypassing Zero Trust.
  * **Evaluation:** This is penalized under the **Security** category metric "Requires user authentication".
  * **Hunting Configuration:** Use the built-in query **"Cloud apps that allow anonymous use"** to instantly filter for these risks.
* **Custom LOB Apps Configuration:**
  * **Purpose:** Gain visibility into internal, custom-developed apps missing from the public catalog. Automatically tagged as a **Custom app**.
  * **Scenario Fallback Trap:** If your network appliance (like certain firewalls) does not record URL information, you **must explicitly define the IPv4 and IPv6 addresses** when configuring the app so the engine can match the traffic.

### **3. App Governance, Classification, and Enforcement**

* **Classification Strategy:**
  * **Sanctioning:** Approves an app. This allows admins to filter dashboards for non-sanctioned alternatives of the same type to encourage user migration to the approved platform.
* **Enforcement Mechanics (Blocking Apps):**
  * **🚨 EXAM TRAP:** Tagging an app as **Unsanctioned** does **not** block it automatically.
  * **The Mechanism:** To block the app, Unsanctioned domains must be synced to Microsoft Defender for Endpoint as **custom URL indicators**, or you must export a block script to your on-premises network appliances.
* **Defender for Endpoint Prerequisites & Configurations:**
  * **Tenant Setting:** **Custom network indicators** must be toggled **ON** in Defender XDR Advanced features.
  * **Endpoint Agent Settings:** Devices must have Microsoft Defender Antivirus running with **Real-time protection**, **Cloud-delivered protection**, and **Network protection explicitly set to block mode** (audit mode will only log, not sever the connection).
  * **Scoped Profiles:** You can restrict blocking to specific device groups using **Include** (block only for this group) or **Exclude** (block globally except for this group) rules.
  * **User Education:** Configure a **Notification URL for blocked apps** to redirect intercepted users to an internal IT support page.
* **The Latency SLA Trap:**
  * It can take **up to 3 hours** for an unsanctioned app to be fully blocked on the endpoint (1 hour to sync indicators + 2 hours to push to devices).

### **4. Discovery Policies and Anomaly Detection**

* **Cloud Discovery Anomaly Detection Policy:**
  * **Status:** **Enabled by default**.
  * **Functionality:** Uses UEBA to build a "normal" baseline. *Scenario Example:* Automatically alerts if a user suddenly uploads 600 GB of data to a previously unused cloud app.
  * **Configuration:** Can be scoped to specific continuous reports or filtered by Users/IP addresses.
  * **Sensitivity Tuning:** Admins can adjust the **anomaly detection sensitivity** slider. Lowering sensitivity means the system requires a larger variance from the baseline before triggering, reducing false positives.
* **App Discovery Policies:**
  * **🚨 EXAM TRAP (Daily Alert Limits):** You can set a daily alert limit (e.g., 5/day) to prevent alert fatigue. However, **governance actions are never impacted by the daily alert limit**; if a policy triggers 100 times, the automated action (like tagging) will execute all 100 times, even though only 5 emails are sent.
  * **Frequency Limit:** To further reduce noise, these policies only trigger an alert **once in 90 days per app per continuous report**.

### **5. Privacy, Scoping, and Data Refinement**

* **Data Anonymization:**
  * **Mechanism:** Protects privacy by replacing usernames with **AES-128** encrypted identifiers.
  * **Configuration Methods:** Can be set Ad-Hoc (on specific snapshot uploads), Per Source (on specific continuous streams), or globally as a Tenant Default.
  * **Deanonymization Requirements:** To resolve an encrypted identifier, the admin **must** have the **Cloud Discovery global admin** role, and they must provide a **business justification**.
  * **Auditing Trap:** Resolving a username is heavily audited in the **Activity log** (migrating away from the Governance log in October 2025).
  * **Limitation:** Anonymization is **not supported** on the Defender for Cloud Apps Proxy stream pipeline.
* **Scoped Deployment:**
  * **Purpose:** Restricts activity monitoring to specific user groups to meet compliance or licensing rules.
  * **Prerequisite:** You must first **import user groups** (e.g., from Entra ID).
  * **Configuration Logic:** Implicit exclude applies to anything not explicitly included. If a user is in multiple conflicting groups, **Excluded groups always override Included groups**.
  * **🚨 EXAM TRAP (Architectural Limitation):** Scoping **only stops user activity monitoring**; it explicitly does **not** stop the system from scanning the excluded user's files, accounts, or OAuth applications.
* **Entity Exclusions ("Noisy Data"):**
  * **Purpose:** Exclude system accounts, local hosts, or scanners from skewing Shadow IT reports.
  * **Stream Exception Trap:** Exclusions are only supported on the **Global report stream**. You **cannot** exclude entities from MDE or proxy data streams.
  * **Historical Data Trap:** Exclusions apply **only to newly received data**. Historical data generated by the excluded IP will remain visible until it ages out at 90 days.

### **6. Metrics and Specialized Reporting**

| Usage Metric | Technical Definition | Use Case |
| :--- | :--- | :--- |
| **Transactions** | **One log line of usage** between two devices. | Gauges the *intensity* or volume of interactions (e.g., API polling vs. human use). |
| **IP addresses** | The number of unique source IPs connected to the app. | Identifying network spread. |
| **Users** | The number of active identities accessing the app. | Tracking human adoption. |
| **Traffic** | Total data volume (uploaded and downloaded). | Identifying massive data exfiltration or bandwidth hogs. |

* **Custom Continuous Reports:**
  * **Purpose:** Granular visibility for specific business units or networks, whereas the standard Global report is tenant-wide.
  * **Configuration:** Typically built by importing Entra ID user groups or specifying IP address tags/ranges.
  * **Inclusion Logic:** Applying a filter is an **inclusion** action; the report only shows data for that specific group and ignores all others.
  * **Data Limit:** Custom reports are strictly capped at a maximum of **1 GB of uncompressed data**.
* **Cloud Discovery Executive Report:**
  * **Format:** A concise, **six-page overview** designed for C-level management to highlight top potential risks.
  * **Prerequisite:** Because it is purely an analytical summary, **existing Cloud Discovery data must be present** in the portal to generate it.

### **7. Essential Timeframes and Deprecation Dates Cheat Sheet**

* **1 Hour:** SLA for imported user group memberships to automatically synchronize.
* **12 Hours:** Interval for the periodic background scan of unstructured data files.
* **7 Days:** Standard initial learning period required for Anomaly Detection to establish a baseline. **Alerts are suppressed during this window**.
* **30 Days:** Extended learning period required for the specific "Unusual ISP for an OAuth app" anomaly detection.
* **90 Days:** Timeframe limit where App Discovery policies will only alert *once* per app. Also the retention period for historical data before natural age-out.
* **Up to 3 Hours:** Latency for an unsanctioned app domain to fully sync to Defender for Endpoint and actively block traffic on the device.
* **September 1, 2025:** Cloud Discovery Alerts data point removed from the Executive Summary Report.
* **October 2025:** "Resolve Anonymization" auditing migrates from Governance logs to the Activity log.
* **December 31, 2025:** "Discovered Subdomains" feature fully deprecated.
