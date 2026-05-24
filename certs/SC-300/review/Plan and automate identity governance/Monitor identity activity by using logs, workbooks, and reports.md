### **Log Analytics & KQL Fundamentals**

* **Validating Log Streams**
  * **Configuration Detail:** Use `SigninLogs | take 10` or `SigninLogs | limit 10` to extract a random sample of 10 records and verify the pipeline is working.
  * **Prerequisite:** A Log Analytics Workspace must be integrated via Diagnostic Settings.
  * **Troubleshooting:** It can take up to **15 minutes** for data to populate after the initial setup.
  * **Exam Trap (Random vs. Recent):** `take 10` does not guarantee chronological order. To get the most recent logs, you must use `top 10 by TimeGenerated desc` or `sort by TimeGenerated desc | take 10`.
* **Timestamp Accuracy**
  * `TimeGenerated`: The exact time the log was ingested and published by Log Analytics.
  * `CreatedDateTime`: The exact time the user actually authenticated.
  * **Exam Trap (Exported Logs):** Downloaded CSV/JSON files from the portal always display timestamps in **UTC**, regardless of the "Local" time UI toggle.
* **Aggregating Data (Summarize Operator)**
  * **List and Count:** `summarize count() by UserDisplayName` returns a list of unique users alongside their individual failure counts.
  * **Grand Total:** `summarize dcount(UserPrincipalName)` returns a single number (distinct count) of total unique users.
  * **Time Binning:** To summarize failures per day, add the `bin()` function: `summarize count() by UserDisplayName, bin(TimeGenerated, 1d)`.
  * **Exam Trap (UPN vs. Display Name):** `UserPrincipalName` is strictly unique; `UserDisplayName` is not. Microsoft recommends grouping by UPN for accuracy.
  * **Exam Trap (Inflated Counts):** A complex sign-in generates a separate log row for every step (password, MFA fail, MFA retry). To count actual *sessions*, group by `CorrelationId` first.
* **Understanding Sign-In Log Tables & Statuses**
  * `SigninLogs`: Contains interactive sign-ins where a human provided a factor.
  * `AADNonInteractiveUserSignInLogs`: Contains background token refreshes.
  * **Conditional Access Statuses:**
    * **Success:** Policy applied and grant controls were satisfied.
    * **Failure:** Policy applied but user failed controls or was blocked.
    * **Not Applied:** User/app did not match policy assignments, OR the user signed into a local Windows device using Windows Hello for Business (policies apply to cloud resources, not local device logins).

### **Diagnostic Settings & Exporting Boundaries**

* **Export Limits and Behavior**
  * **Portal Downloads:** The browser interface limits downloads to **250,000 audit logs** or **100,000 sign-in/provisioning logs** per file.
  * **Custom Visual Columns:** Clicking "Download" exports the complete schema with all properties; it ignores any columns you visually hid in the UI.
  * **Filters:** Downloaded files *will* strictly honor active filters (e.g., Date Range, UPN).
  * **Circumventing Limits:** Use the **Microsoft Graph reporting APIs** or **Diagnostic Settings** to retrieve larger datasets.
* **SIEM Integration (Third-Party)**
  * **Architecture:** To send logs to Splunk or ArcSight, you must route them through an **Azure Event Hub**.
  * **Exam Trap (Security Boundary):** Both the Azure subscription and the Event Hubs namespace must reside in the **exact same Microsoft Entra tenant** from which the logs are streamed.
* **Custom Security Attributes (Strict Isolation)**
  * **Configuration Detail:** Audit logs for these attributes (`CustomSecurityAttributeAuditLogs`) are isolated from standard directory logs. They are configured in a completely separate "Custom security attributes" section within the Diagnostic Settings blade.
  * **Prerequisite/Licensing:** Standard Global or Security Administrators *cannot* configure this export. The user must explicitly be assigned the **Attribute Log Administrator** role.
  * **Exam Trap:** In Conditional Access, custom security attributes only support the **String** data type.

### **Auditing, Provisioning, & Threat Hunting**

* **Microsoft Graph Activity Logs (`MicrosoftGraphActivityLogs`)**
  * **Use Case:** Provides a raw audit trail of all HTTP API requests. Used to investigate deep programmatic threats, like suspicious privileged assignments or anomalous API volume.
  * **Prerequisite:** Requires a **P1 or P2 license** and the **Security Administrator** role.
  * **Exam Trap (Data Volume Filtering):** You **cannot** filter these logs through Diagnostic Settings prior to sending them. To reduce Log Analytics costs, you must apply a workspace transformation.
  * **KQL Join Scenario:** To track compromised users, use `MicrosoftGraphActivityLogs | join AADRiskyUsers on $left.UserId == $right.Id`. To map a token to a sign-in event, join `SignInActivityId` (Graph logs) to `UniqueTokenIdentifier` (Sign-in logs).
  * **Exam Trap (Missing Correlations):** First-party app-only sign-ins (Microsoft background jobs) are intentionally excluded from service principal sign-in logs, so some Graph activity will not have a matching sign-in record.
* **Retrieving Sign-in Logs via PowerShell**
  * **Command:** `Get-MgAuditLogSignIn`.
  * **Prerequisite:** P1/P2 license and either `AuditLog.Read.All` or `Directory.Read.All` permissions.
  * **Exam Trap (`signInActivity`):** The `signInActivity` user property does *not* retrieve logs. It only stores a high-level timestamp of the last authentication, and it can take **up to 24 hours to update**.
* **Auditing Directory vs. Policy Changes**
  * **Group Modifications:** To investigate a user added to an administrative group, query `AuditLogs` under the **GroupManagement** category (activity: "Add member to group"). Check the `Initiated by (actor)` field to see who executed the change. If it says "Microsoft Substrate Management", it was an automated Exchange sync.
  * **Role Modifications:** To investigate direct privileged role assignments, query `RoleManagement` (activity: "Add member to role").
  * **Conditional Access Auditing:** To track policy changes, filter `AuditLogs` for `OperationName == "Update conditional access policy"`. Look under `TargetResources > modifiedProperties` to compare the `oldValue` and `newValue` JSON. Requires **Security Reader** role.
* **Provisioning Logs (SaaS Lifecycle)**
  * **Use Case:** Investigating if a user deleted in Entra ID was successfully removed from Adobe or ServiceNow.
  * **Troubleshooting Statuses:** "Skipped" indicates the user fell outside defined scoping filters or lacked a mandatory attribute.
  * **Exam Trap (Accidental Deletions):** If a sync job exceeds the deletion threshold (e.g., >500 users), the job enters **quarantine**. Removals are blocked until an admin manually clicks "Allow deletes".

### **Azure Workbooks & Governance Tools**

* **Universal Workbook Prerequisites**
  * All workbooks natively require a **Premium P1 license** and a configured **Log Analytics Workspace**.
* **Conditional Access Gap Analyzer**
  * **Use Case:** Highlights user sign-ins bypassing modern controls (e.g., legacy authentication, unmonitored locations, skipped apps).
  * **Exam Trap:** Do not confuse this with the *Conditional Access insights and reporting* workbook, which measures the success/failure rate of *active* policies. Gap Analyzer finds the blind spots.
* **Cross-Tenant Access Activity Workbook**
  * **Use Case:** Combines B2B inbound (guests accessing your apps) and outbound (your users accessing partner apps) traffic.
  * **Exam Trap (Unconfigured State):** By default, new partner access is "unconfigured" and passes through your default settings.
  * **Exam Trap (Dynamic UI):** The user/app tables change based on whether you select the Inbound or Outbound tab. Editing these policies requires the **Security Administrator** role.
* **Usage and Insights Dashboard**
  * **Microsoft Entra application activity:** Pivots data to an app-centric view to find success/failure rates per application.
  * **Authentication methods activity:** Tracks tenant-wide MFA registration vs. actual usage to drive passwordless adoption.
  * **Exam Traps:**
    * If an app was deleted yesterday, it still appears if sign-ins occurred during the date range.
    * "Not found" apps are Microsoft service-to-service instantiations.
    * **AD FS application activity** intentionally hides any on-premises app that hasn't had a sign-in in 30 days.
    * If users complain about "too many MFA prompts", use the **Authentication Prompts Analysis** workbook, *not* Usage and Insights.
* **Identity Protection Risk Analysis Workbook**
  * **Use Case:** Visual heatmap and real-time vs. offline risk detection trends.
  * **Prerequisite/Licensing Trap:** The absolute minimum to *use the workbook* is **P1**, but to fully utilize the underlying Identity Protection data, **P2** is required.
  * **Roles:** Viewing requires Reports Reader, Security Reader, or Global Reader. Editing requires Security Administrator.

### **Identity Secure Score Dashboard**

* **Scoring Mechanics & Math**
  * **Refresh Cycle:** Evaluates every 24 hours. Sync delays can take up to 72 hours.
  * **Partial Completion:** Actions like MFA rollout calculate a percentage score based on coverage (e.g., 5 of 100 users = 0.53% of the max available 10.71% score).
  * **[Not Scored] Label:** Actions that improve security but currently award 0 points.
* **Least Privilege Roles**
  * **View Only:** `Service Support Administrator`.
  * **Update Statuses:** `SharePoint Administrator`.
  * **Exam Trap:** Never select Global Administrator if the question specifies the "principle of least privilege".
* **Administrator Status Actions**
  * **Risk accepted:** No points awarded; item hidden.
  * **Resolved through third party / alternate mitigation:** Use this for non-Microsoft MFA (Duo/Okta). Awards the maximum score points manually.

### **Service Health & SLA Attainment**

* **SLA Attainment Dashboard**
  * **Use Case:** Provides a monthly look-back at core authentication availability.
  * **Calculation:** Total successful user minutes divided by (successful + failed user minutes).
  * **Exam Traps:**
    * Requires a minimum of **5,000 Monthly Active Users (MAU)** to view.
    * Measures token issuance and authentication success, *not* network ping or system uptime.
    * Successful authentications routed through the backup resilient authentication system are counted as successes.

---

### **Comparison Tables**

#### **1. Differentiating Unique Identifiers**

| Identifier | Definition & Troubleshooting Use Case |
| :--- | :--- |
| **Correlation ID** | Groups multiple logs from the **same sign-in session** (e.g., tracking a user failing and retrying MFA). |
| **Request ID** | Corresponds specifically to a single **issued token**. Use this when a developer provides an exact token. |
| **Unique Token Identifier** | Correlates a sign-in event specifically with the initial **token request**. |

#### **2. Identity Secure Score Status Options**

| Manual Status | Impact on Dashboard | Point Award |
| :--- | :--- | :--- |
| **To Address** | Active on the improvement list. | Partial or Zero. |
| **Planned** | Concrete plans are made; active on list. | Zero. |
| **Risk Accepted** | Hidden from the active list. | Zero Points. |
| **Resolved through third party** | Used when Entra lacks native visibility (e.g., Okta). | Maximum Points. |

#### **3. Microsoft Entra vs. Graph API Log Types**

| Log Source | Primary Data Captured | Prerequisite Limitations |
| :--- | :--- | :--- |
| **SigninLogs** | Interactive user authentication events. | Basic available; P1/P2 for export. |
| **AuditLogs** | Directory/configuration changes (groups, policies). | 30-day retention natively. |
| **ProvisioningLogs** | Sync actions to third-party SaaS apps. | 30-day retention natively. |
| **MicrosoftGraphActivityLogs** | Raw HTTP API requests (deep threat hunting). | P1/P2. Cannot filter before ingestion. |
