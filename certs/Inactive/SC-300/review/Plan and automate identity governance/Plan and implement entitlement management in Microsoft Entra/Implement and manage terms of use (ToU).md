### **SC-300 Exam Study Review: Implement and Manage Terms of Use (ToU) - Expanded Edition**

#### **1. Prerequisites and Licensing**

* **Licensing Requirements:**
  * **Minimum:** **Microsoft Entra ID P1** is required to configure and enforce ToU policies.
  * **Supported Bundles:** Fully supported in **Microsoft Entra ID P2** and **Microsoft 365 Business Premium**.
* **Licensing Expiration Behaviors:**
  * ⚠️ **EXAM TRAP:** If a tenant’s P1 or P2 license expires, **all user acceptance records are permanently and immediately deleted**.
  * Conditional Access (CA) policies are **not** deleted; they enter a "graceful state" where they cannot be updated but can be viewed or deleted.
  * Historical proof of compliance is permanently lost unless previously backed up via CSV.
* **Administrative Roles:**
  * **Conditional Access Administrator:** Create, modify, and delete ToU policies.
  * **Security Reader:** View ToU configurations, policies, and aggregate acceptance reports.
  * **Reports Reader:** View detailed consent events in the **Microsoft Entra audit logs**.

#### **2. Document Configuration and Specifications**

* **Tenant Limits:** A hard limit of **40 ToU policies** per Microsoft Entra tenant.
* **Document Formatting:**
  * Must be strictly uploaded in **PDF format**.
  * You cannot alter the file format of an existing policy.
  * **Best Practice:** Microsoft mandates at least a **24-point font** to ensure mobile readability.
* **Hyperlink Behavior & Limitations:**
  * *External Links:* Supported. Links to external sites work during the initial sign-in flow.
  * *Internal Links:* **Unsupported**. "Jump links" or bookmarks navigating within the same PDF will fail.
  * *MyAccount Portal:* **No links function** when a user reviews a previously accepted ToU via the MyAccount portal.

#### **3. Multi-Language Support and Localization**

* **Configuration:** You can upload multiple PDFs to a single policy, tag them with specific languages, and specify a unique **Display name** per language.
* **Language Detection Logic:**
  * **Step 1:** System checks the user's **browser language preferences**.
  * **Step 2 (Fallback):** If no match is found, the system serves the **"default document"** (the very first PDF uploaded to the policy).
* ⚠️ **EXAM TRAP:** **Desktop WAM Apps Exception:**
  * For Windows desktop applications using Web Account Manager (WAM), such as **Microsoft Teams**, the system **ignores browser settings** and uses the **operating system language**.

#### **4. Conditional Access Integration and Enforcement**

* **Enforcement Mechanism:** ToU is applied as a **grant control** within CA policies.
* **Automated Workflow:** Selecting the **"Custom policy"** template when creating a ToU automatically triggers the CA policy creation dialog with the ToU pre-populated under Grant controls.
* **Validation Order:**
  * 1st: **Multifactor Authentication (MFA)**.
  * 2nd: **Device state/compliance**.
  * 3rd: **Terms of Use** (evaluated last).
* **User Experience Controls:**
  * **Mandatory Expansion:** Administrators can require users to scroll through (expand) the document before the "Accept" button enables.
  * **Denial Consequence:** Declining the terms completely blocks access to protected applications until the user signs in and accepts them.

#### **5. Device and Application Scenarios**

* **"Require users to consent on every device" (Per-Device):**
  * Requires the hardware to be **registered in Microsoft Entra ID** to obtain a unique **Device ID**.
  * Mobile devices may require broker apps (**Microsoft Authenticator** or **Company Portal**) to facilitate registration.
* ⚠️ **EXAM TRAP:** **Per-Device Limitations:**
  * **B2B Guests:** Strictly unsupported. External guests do not register devices in the resource tenant, so no Device ID exists. Use standard per-user ToU policies for guests.
  * **Intune Conflict:** The **Microsoft Intune Enrollment app** must be explicitly excluded. Applying per-device ToU here checks for a Device ID *before* enrollment completes, causing a circular authentication loop blocking enrollment.
* 💡 **SCENARIO: SharePoint External Sharing:**
  * ToU is **only** displayed if the recipient has a guest account in the directory (Account-based sharing). Ad-hoc/guestless links (e.g., "Anyone" links) bypass the Entra ID flow and **will not** trigger ToU.

#### **6. Troubleshooting and Identity Exclusions**

* **Interactive Requirement:** ToU requires a human to view and click "Accept".
* **Legacy Protocols:** Basic Auth, IMAP, POP, and legacy PowerShell are strictly incompatible with modern grant controls and are **blocked automatically**.
* **Mandatory Exclusions (To prevent tenant lockouts and automation failures):**
    1. **Service Accounts** (Recommend migrating to Managed Identities/Workload CA policies).
    2. **Emergency Access (Break-Glass) accounts**.
    3. **Microsoft Entra Connect Sync accounts**.
* 💡 **SCENARIO: Edge Browser Loop:**
  * Users constantly prompted on Microsoft Edge need to **sync their work profile**. This establishes a **Primary Refresh Token (PRT)** for SSO, allowing Entra to remember the session's prior acceptance.
* **Network Allow-List for Restricted Networks:**
  * If using strict firewalls, you must allow: `https://tokenprovider.termsofuse.identitygovernance.azure.com`, `https://myaccount.microsoft.com`, and `https://account.activedirectory.windowsazure.com`.

#### **7. Reporting, Auditing, and Data Retention Comparison**

| Feature | Terms of Use Details Overview | Exported CSV Report | Entra Audit Logs |
| :--- | :--- | :--- | :--- |
| **Scope of Data** | Snapshot of the **current version only**. | **Entire history** across all versions. | Granular consent events with correlation IDs. |
| **Update Frequency** | Refreshes typically **once daily**. | Real-time at point of export. | Real-time ingestion. |
| **Data Retention** | **Resets** if updated or expired. | Stored for the **entire life of the policy**. | Retained for **30 days** by default. |
| **Primary Use Case** | Quick daily compliance snapshot. | Audit-ready historical proof. | Deep troubleshooting (e.g., checking "Interrupted" status). |

* **Extending Audit Logs:** Use **Diagnostic Settings** to push 30-day audit logs to an Azure Storage Account, Log Analytics Workspace (for KQL queries), or Event Hubs.

#### **8. Policy Lifecycle, Versioning, and Deletion**

* **Updating Versions ("Require reaccept" toggle):**
  * **Off:** Existing user consents remain valid. Only new users or expired users see the new version.
  * **On:** Existing users are forced to accept the new version, but **only after their current session expires**. To force immediate global evaluation, the ToU must be deleted and recreated.
* **Deletion Governance:**
  * Deleting a ToU object triggers the **immediate, permanent purge** of all associated acceptance records.
  * **Best Practice:** Download the CSV report before deletion. If you want to temporarily stop enforcing but keep records, **disable the Conditional Access policy** rather than deleting the ToU object.
* **End-User Self-Review:**
  * Users navigate to **`https://myaccount.microsoft.com/`** > **Settings & Privacy** > **Privacy** > **Organization's notice**.
  * Users **cannot "unaccept"** or revoke consent once given.
