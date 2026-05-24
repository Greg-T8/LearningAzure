**SC-300 Exam: Microsoft Entra Access Reviews Advanced Study Review Sheet**

### **1. Architecture & Microsoft Graph API Hierarchy**

* **The Three-Tier Hierarchy:** Access reviews operate on a strict structure of **Definitions > Instances > Decisions**.
  * **Definitions (`/identityGovernance/accessReviews/definitions`):**
    * The overarching "blueprint" or schedule.
    * Created via `POST`.
    * JSON payload must configure: `scope` (target resource/users), `reviewers`, `settings` (compliance rules like `autoApplyDecisionsEnabled`), and `recurrence` (e.g., weekly, quarterly).
  * **Instances (`/instances/{instanceId}`):**
    * Active occurrences spawned automatically by the definition's schedule.
  * **Decisions (`/instances/{instanceId}/decisions`):**
    * Individual review items for identities.
    * Returns `accessReviewInstanceDecisionItem` objects containing the `decision`, AI `recommendation`, reviewer `justification`, and current `applyResult` state.
* **API / PowerShell Execution Exam Traps:**
  * **The Instance Creation Trap:** You never manually create an instance via a `POST /instances` call; they are spawned automatically.
  * **The Multiple Resources Trap:** A definition can only target **one single resource** at a time. Scripting 50 applications requires 50 separate `POST` requests.
  * **The API Default Trap:** When using the Graph API, `autoApplyDecisionsEnabled` defaults to `false` if omitted from the payload, requiring manual enforcement.
* **Prerequisites & Licensing Notes:**
  * **API Permissions:** Scripts require the **`AccessReview.ReadWrite.All`** delegated or application permission.
  * **Role Requirements:** Generally requires the **Identity Governance Administrator** role.
  * **Privileged Role Exception:** If creating a review for a group where `isAssignableToRole = true`, the script strictly requires the **Privileged Role Administrator** role.
  * **PowerShell Module:** Requires the `Microsoft.Graph.Identity.Governance` module.

### **2. Multi-Stage Access Reviews & Escalation Workflows**

* **Architecture Details:** Supports up to three sequential stages.
* **The Final Say Rule:** The **last decision recorded for a reviewee is the one permanently applied** at the end of the overall review. Later-stage reviewers silently overwrite earlier decisions.
* **Stage Progression Configuration (The Funnel Method):**
  * **Filter Scenario (Reduce Auditor Workload):** Set Stage 1 to "Self-review" and "Reviewees going to the next stage" to **"Approved reviewees"**. Stage 2 managers only evaluate users who explicitly requested to keep access.
  * **Escalation Scenario (Handle Ambiguity):** Set "Reviewees going to the next stage" to **"Not reviewed reviewees"** and **"Reviewees marked as 'Don't know'"**. This guarantees undecided/ignored users are escalated to a final authority.
  * **Dead End Trap:** If a "Don't know" user is not configured to progress, their review ends and falls back to the "If reviewers don't respond" setting.
* **Conflict of Interest Scenario:**
  * If a group owner is a member being reviewed, assigning "Group owner(s)" allows them to rubber-stamp their own access.
  * **Solution:** Create a multi-stage review. Stage 1: "Self-review". Stage 2: "Selected users" (Auditor).
* **Visibility Exam Traps:**
  * **The Blind Review Trap:** For strict, unbiased, independent compliance audits, disable the **"Show previous stage(s) decisions to later stage reviewers"** setting.

### **3. Automated Decision Helpers & Machine Learning**

* **Inactive Users Recommendation:**
  * **Tenant-Level vs. App-Level:** Reviewing a Microsoft 365 Group checks tenant-wide sign-ins; reviewing an Enterprise Application specifically evaluates activity within that app.
  * **The Snapshot Trap:** The system captures a snapshot of sign-in data exactly when the review begins. It **is not updated while the review is in progress**, even if the user subsequently logs in.
  * **Grace Period Trap:** Guests created within the inactivity window (e.g., created 10 days ago for a 30-day review) are **not in scope**, ensuring new users have time to authenticate. Maximum lookback is 730 days.
* **User-to-Group Affiliation Helper:**
  * Analyzes organizational reporting structure/org chart to flag users with "low affiliation" to group peers.
  * **Prerequisites Trap:** **Requires a populated `manager` attribute**. Works only for **internal users** (not B2B guests).
  * **Computation Limit Trap:** Instantly fails for **groups with more than 600 users**.
* **Access Review Agent (Microsoft Teams):**
  * Takes reviews out of the My Access portal and into Microsoft Teams using natural language summaries. It only proposes decisions; humans must finalize them.
* **Licensing Prerequisites:**
  * All advanced helpers (Affiliation, Inactive Users, Teams Agent) strictly require the premium **Microsoft Entra ID Governance** or **Microsoft Entra Suite** license, not just P2.

### **4. Reviewer Assignments & PIM Intersections**

* **PIM for Groups Reviewer Rules:**
  * **Active vs. Eligible Trap:** Access reviews assigned to "Group owner(s)" for PIM-governed groups will **only route to active owners, completely ignoring eligible owners**.
* **Fallback Reviewer Configuration:**
  * **Triggers:** Required for PIM groups (which often have zero permanent active owners). Also triggered if reviewer is set to "Manager" but the reviewee has a blank manager attribute.
  * **Immutability Trap:** Once a fallback reviewer is added to a definition, **they cannot be removed**.

### **5. Enforcement, Lifecycle States, & Troubleshooting**

* **Decision Enforcement Timing:**
  * **Active Status:** No access rights are changed while the review is "InProgress". The API `applyResult` shows as `New`.
  * **Completed Status:** If "Auto apply results to resource" is enabled, status progresses automatically: `Completed` -> `Applying` -> `Applied`. If disabled, an administrator must manually click "Apply".
* **Review Termination Traps:**
  * **Stop Current Stage:** Advances the workflow to the next multi-stage phase.
  * **Stop:** Terminates the *entire* access review instance early and executes decisions immediately.
  * **Reset:** Wipes out all current decisions and reverts everyone back to `NotReviewed`.
* **Fallback Enforcement ("If reviewers don't respond"):**
  * To establish a strict default-deny compliance posture for non-responders, set this to **"Remove access"**.
  * **System Actor Trap:** Decisions applied by this fallback are attributed to the system actor **"AAD Access Reviews"** in audit logs.
* **Guest Offboarding Mechanics ("Block and Delete"):**
  * Setting "Action to apply on denied guest users" to block for 30 days then remove from tenant executes a global offboarding.
  * **Phase 1 Trap:** The user is blocked from sign-in, but resource access/group memberships are intentionally *not* revoked as a safety net.
  * **The "Applying" UI Trap:** The review remains stuck in the `Applying` state for 30 days; settings, reviewers, and audit logs cannot be viewed during this window.
  * **Universal Deletion Trap:** Deletes the user from the tenant irrespective of other legitimate group access. Cannot be used for Entra ID role reviews.
* **Troubleshooting Unsupported Removals:**
  * Microsoft Entra cannot automatically apply access removals if the user gained access via a **nested group** or a **Windows Active Directory synced group**.

### **6. Auditing, Notifications, & Log Retention**

* **Notification Reminders Configuration:**
  * **Midpoint Schedule:** Enabling reminders automatically triggers an email at the **exact mathematical midpoint** of the review. Custom schedules (e.g., every 3 days) are not supported.
  * **Targeted Audience Trap:** By default, it sends only to uncompleted reviewers. However, if toggled on *mid-flight* during an active review, **all reviewers receive the email**, regardless of completion status.
* **Access Review History (Static Reporting):**
  * Used to bypass the 30-day standard audit log limit by generating historical CSV/Excel reports.
  * **The URI Link Trap:** If scripting via Graph API, the generated `downloadUri` **is only active for 24 hours**.
  * **Enforcement Limitation:** Cannot be used for real-time automated access removal.
* **Diagnostic Settings (Dynamic Reporting):**
  * **The Retroactive Trap:** Exporting to Azure Monitor only captures logs *from the moment enabled forward*; it cannot retrieve purged historical data.
  * **KQL Auditing Trap:** To audit actual human reviewer engagement, KQL queries must filter out system actions: `where ReviewedBy_DisplayName != "AAD Access Reviews"`.

### **7. Comparison Tables**

**Table 1: Graph API Hierarchy vs. PowerShell Cmdlets**

| Tier | API Endpoint Concept | HTTP Action | PowerShell Cmdlet | Description |
| :--- | :--- | :--- | :--- | :--- |
| **Definition** | `/definitions` | `POST` | `New-MgIdentityGovernanceAccessReviewDefinition` | Creates the central blueprint, scope, settings, and recurrence pattern. |
| **Instance** | `/instances` | System Auto | N/A (System Generated) | An active, scheduled occurrence spawned automatically. |
| **Decision** | `/instances/{id}/decisions` | `GET` | `Get-MgIdentityGovernanceAccessReviewDefinitionInstanceDecision` | Retrieves the real-time decisions, justifications, and application states for users. |
| **Manual Apply** | `/instances/{id}/applyDecisions` | `POST` | `Add-MgIdentityGovernanceAccessReviewDefinitionInstanceDecision` | Manually forces decisions to apply if auto-apply was disabled. |

**Table 2: Log Retention & Diagnostic Destinations**

| Destination Type | Best Use Case | Retention / Limits |
| :--- | :--- | :--- |
| **Default Entra Audit Logs** | Immediate portal viewing. | **30 days** (P1/P2 Premium) / 7 days (Free tier). |
| **Access Review History** | Point-in-time auditor compliance files. | Data retained >30 days. Report download URI expires in **24 hours**. |
| **Azure Log Analytics Workspace** | Active KQL querying, Workbooks, real-time custom reports. | Up to 2 years (customizable). |
| **Azure Storage Account** | Cheap, long-term compliance archival without frequent querying. | Indefinite/Custom lifecycle. |
| **Azure Event Hub** | Streaming to 3rd-party SIEMs (Splunk, SumoLogic). | N/A (acts as a bridge). |
