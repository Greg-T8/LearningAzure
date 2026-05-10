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
