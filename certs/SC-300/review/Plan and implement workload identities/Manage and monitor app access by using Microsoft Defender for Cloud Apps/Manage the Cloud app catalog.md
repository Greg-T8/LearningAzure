**Exhaustive SC-300 Study Review Sheet: Manage the Cloud App Catalog**

### **1. The Cloud App Catalog & Risk Framework**

* **Scale and Scope:**
  * Evaluates **over 31,000 publicly available cloud apps**.
  * Ranks apps from 1-10 (10 being most secure) based on **more than 90 different risk factors**.
* **The Four Risk Categories:**
  * **General:** Evaluates company stability, consumer popularity, domain age, and headquarters location.
  * **Security:** Evaluates technical defenses (MFA support, data-at-rest encryption, audit trails).
  * **Compliance:** Evaluates industry standards (SOC 2, HIPAA, ISO 27001, PCI-DSS, CSA STAR).
    * *CSA STAR Detail:* Based on ISO 27001 and Cloud Controls Matrix. Tracked levels include self-assessment, certification, attestation, C-STAR assessment, and continuous monitoring. You can filter using the built-in query: **"Cloud apps that are CSA STAR certified"**.
  * **Legal:** Evaluates data protection and privacy (GDPR readiness, data retention, data ownership, DMCA).
    * *DMCA Detail:* Digital Millennium Copyright Act compliance criminalizes unlawful access to copyrighted material.
* **Configuration Details (Customizing Risk):**
  * **Score Weighting:** Administrators can change default equal weights to emphasize specific factors.
  * **Overriding Scores:** Admins can manually override a catalog app's score to a '10' specifically for their tenant if officially approved internally.
* **Scenario Example:** A healthcare organization prioritizes patient data protection. The administrator configures the "HIPAA compliance" metric to "Very High" importance, which automatically degrades the risk score of all non-compliant apps across the entire catalog.
* **🚨 Exam Trap:** Do not mix up the **Compliance** and **Legal** categories. GDPR and DMCA fall under *Legal* (privacy/protection), while SOC 2 and CSA STAR fall under *Compliance* (industry standards).

### **2. Adding Apps & Updating the Catalog**

* **Comparison: Public SaaS Apps vs. Internal Custom Apps**

| Feature | Public SaaS Apps (Catalog Update) | Internal LOB Apps (Custom Apps) |
| :--- | :--- | :--- |
| **Visibility** | Global database (all Microsoft customers). | Local tenant only. |
| **Submission Method** | Complete the **Self-Attestation Questionnaire** (or submit score update request). | Manually define as a **Custom App** in the portal. |
| **Acceptance Criteria** | Must map to known domain, be a SaaS product, have verifiable info. | Relies on domains/URLs or explicit IP addresses. |
| **Required Privilege** | Any user/vendor (Global Admin **NOT** required). | Defender for Cloud Apps Administrator. |

* **Configuration Details (The Missing URL Problem):**
  * Cloud Discovery matches traffic using **target URLs/domains**.
  * If firewall/proxy logs (e.g., Cisco ASA) only record target IP addresses, you **must explicitly fill in IPv4 and IPv6 address fields** when creating the custom app to ensure traffic routing matches.
* **Troubleshooting Details (Custom App Tagging):**
  * Custom apps are automatically tagged with the "Custom app" tag upon creation for filtering.
  * **Issue:** Internal apps disappear from filtered views.
  * **Root Cause:** An administrator used the **"Remove all tags"** bulk feature, which dangerously deletes the identifying "Custom app" tag. Avoid using this feature on custom apps.
* **🚨 Exam Trap:** Uploading a "snapshot discovery report" does *not* update an app's global security details; it only analyzes local network traffic. You must complete the Self-Attestation Questionnaire to update catalog metadata.

### **3. App Tagging & Endpoint Enforcement**

* **Comparison: Application Tag Behaviors**

| Tag State | Access Level | Endpoint Enforcement Behavior | Scoped Profile Availability |
| :--- | :--- | :--- | :--- |
| **Sanctioned** | Full Access | None. | N/A |
| **Monitored** | Warn & Educate | Triggers warning prompt. Natively allows user to **bypass the warning** for a set duration (e.g., 1 hour). | **Hidden** (unless Win10 Endpoint Users data has 30 days of consistent telemetry). |
| **Unsanctioned** | Hard Block | Drops connection via Microsoft Defender Antivirus Network Protection. | **Prompts immediately** to apply blocks to specific device groups (Include/Exclude). |

* **Prerequisite/Licensing Notes for Blocking:**
  * Requires integration with Microsoft Defender for Endpoint.
  * You must explicitly enable **Custom network indicators** in Microsoft Defender portal (*Settings > Endpoints > Advanced features*).
* **Configuration Details (Auto-Sanctioning & SSO Handoff):**
  * Apps connected via **App Connector** or onboarded to an **Inline proxy** are **automatically transitioned to Sanctioned**.
  * To enforce Single Sign-On (SSO) on a discovered app, use the **Manage app with Microsoft Entra ID** shortcut to natively deploy it from the Entra application gallery.
* **🚨 Exam Trap:** The SLA for unsanctioned app blocking is **NOT "exactly 2 hours"** or via "EDR in block mode". It happens **within the Network Protection SLA**. Total latency is **up to 3 hours** (1 hour portal sync + 2 hours push to endpoints).

### **4. Cloud Discovery Deep Dives & Policies**

* **Configuration Details (Usage Baselines):**
  * To filter for "commonly used" apps with genuine organizational traction, apply these baselines: **> 50 users** AND **> 100 transactions**.
* **Scenario Example:** To perform a bulk remediation on dangerous Shadow IT, filter your Discovered Apps by: Usage (>50 users, >100 transactions) + Risk Score (<=6) + specific Compliance risk (SOC 2 = No). Select the results using the **bulk selection checkbox** and tag as Unsanctioned.
* **Configuration Details (App Discovery Policies):**
  * **New risky app template:** Automatically alerts (or tags as unsanctioned) when a new app meets three exact thresholds: **Risk score < 6**, **> 50 users**, and **> 50 MB of traffic** (Note: Unscored apps trigger this policy).
* **🚨 Exam Trap:** Do not confuse general App Discovery policies with App Governance policies. If asked to monitor **OAuth apps** lacking publisher attestation, use the **New uncertified app** template, *not* the New risky app template.

### **5. SaaS Security Posture Management (SSPM)**

* **Prerequisite Notes:** You must successfully configure an **App Connector** to the third-party app (e.g., Salesforce, GitHub) before SSPM evaluations occur.
* **Troubleshooting Details (Locating Recommendations):**
  * **Issue:** Cannot find posture recommendations in the Defender for Cloud Apps dashboard.
  * **Root Cause:** Defender for Cloud Apps performs the scanning, but recommendations are exclusively centralized in **Microsoft Secure Score** (or Security Exposure Management) under the "Recommended actions" tab.
* **🚨 Exam Trap:** Following the March 2026 update, cloud app recommendations were regrouped into the **Identity** category within Secure Score. Remember that the **total Secure Score remains unchanged**, but individual app and identity scores fluctuate to reflect the transfer.

### **6. Data Retention, Privacy, Auditing & Proxies**

* **Configuration Details (Data Lifecycle):**
  * **Active Retention:** All portal telemetry (network data, OAuth config, audit logs) is retained for **up to 180 days**.
  * **Contract Expiration:** Data is permanently erased and unrecoverable **no later than 180 days** after termination/expiration.
  * **Data Residency:** Stored based on the original Entra tenant location. **The tenant isn't movable after having been created**.
* **Troubleshooting Details (Unmapped Proxy Domains):**
  * If an admin browses an app via Conditional Access App Control (inline proxy) and hits an unknown backend domain, the system prompts with an **"Unrecognized domain" message**.
  * **Issue:** File downloads are bypassing session blocks and not appearing in audit logs.
  * **Root Cause:** The admin ignored the prompt. Actions performed on unassociated domains bypass policies.
  * **Resolution:** Navigate to **Admin View toolbar > Discovered domains** and add the FQDN to the "User-defined domains" field.
* **🚨 Exam Trap:** "Resolve Anonymization" actions (deanonymizing usernames for investigation) are **NO LONGER** tracked in the Governance log. As of October 2025, they are audited exclusively in the **Activity log**.
