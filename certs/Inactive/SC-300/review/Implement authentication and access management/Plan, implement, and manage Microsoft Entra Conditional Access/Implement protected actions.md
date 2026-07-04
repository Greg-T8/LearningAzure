# SC-300 Study Review Sheet: Implement Protected Actions

**I. Prerequisites & Licensing Notes**

* **Licensing Dependencies**
  * **Minimum Requirement:** Microsoft Entra ID P1.
    * *Reasoning:* Protected actions rely directly on the core Conditional Access (CA) engine.
  * **Defense-in-Depth Synergy:** Microsoft Entra ID P2.
    * *Reasoning:* P2 allows combining Protected Actions with Privileged Identity Management (PIM) for a multi-layered security approach.
* **Administrative Roles**
  * **To Manage Protected Actions:** Conditional Access Administrator or Security Administrator.
  * **To Manage Role Assignments:** Privileged Role Administrator.
  * *Exam Trap:* A Global Administrator is NOT exempt from protected action policies. If they attempt a protected task, they must pass the step-up challenge.

**II. Architectural Logic & Configuration Details**

* **Just-in-Time Enforcement:** The policy triggers exactly at the moment a protected operation is attempted, rather than during initial user sign-in.
* **Authentication Context:** The mandatory "bridge" object linking a specific directory permission to a Conditional Access policy.
* **Mandatory Configuration Sequence (Order Matters):**
    1. **Configure Authentication Context:** (Navigate to Protection > Conditional Access > Authentication context).
        * *Exam Trap:* You MUST select the **Publish to apps** checkbox. If left unchecked, the context will not be selectable in the following steps.
    2. **Assign to CA Policy:** Select the Authentication Context (instead of a cloud app) and configure Grant controls (e.g., Phishing-resistant MFA).
        * *Exam Trap:* Always exclude an emergency "break-glass" account to prevent total tenant lockouts during an MFA outage.
    3. **Add Protected Action:** (Navigate to Identity > Roles & admins > Protected actions). Link the context to the target directory permissions.
        * *Troubleshooting Detail:* Configuring these out of order results in infinite re-authentication loops where users cannot satisfy the missing policy bridge.

**III. Comparison Tables**

**Table 1: PIM vs. Protected Actions**

| Feature | Trigger Point | Evaluation Target | Licensing Requirement |
| :--- | :--- | :--- | :--- |
| **PIM** | Role activation | Administrative Role | Entra ID P2 |
| **Protected Actions** | Specific operation attempt | Directory Permission | Entra ID P1 (or P2) |

* *Scenario Example:* Using both together. An admin uses MFA to activate their CA Administrator role via PIM. Later in the session, they attempt to delete a CA policy and must satisfy a second, distinct FIDO2 key challenge triggered by the Protected Action.

**Table 2: Supported Tooling for Claims Challenges (Step-Up Authentication)**

| Tool | Supported? | Behavior upon triggering a Protected Action |
| :--- | :--- | :--- |
| **Entra Admin Center** | Yes | Prompts the user seamlessly for step-up MFA. |
| **MS Graph PowerShell** | Yes | Redirects the script user to satisfy the MFA prompt. |
| **Graph Explorer** | Yes | Supports context prompts natively for developers. |
| **Azure PowerShell** | **No** | Fails and returns an error (cannot process claims challenge). |
| **Azure CLI** | **No** | Fails (unsupported for role/action management). |

**Table 3: Entra ID Deletion States**

| Deletion Type | Status | Recoverable? |
| :--- | :--- | :--- |
| **Soft Deletion** | Moved to recycle bin for 30 days. | Yes. |
| **Hard Deletion** | Permanently purged manually or post-30 days. | **No.** Cannot be recreated with same Object ID. |

**IV. Key Protected Permissions & Scenarios**

* **Conditional Access Management**.
  * *Permissions:* `.../create`, `.../basic/update`, `.../delete`.
  * *Exam Trap / Limitation:* Protecting these permissions inherently blocks the creation of new **Terms of Use pages** or **Custom Controls**. You must temporarily remove the protected action to create them.
* **Hard Deletions**.
  * *Permission:* `microsoft.directory/deletedItems/delete`.
  * *Affected Objects:* Users, Microsoft 365 groups, Cloud security groups, Applications.
  * *Scenario Example:* A compromised admin attempts to permanently purge a critical cloud security group from the recycle bin to cover their tracks. The protected action forces a step-up FIDO2 prompt, successfully blocking the irreversible deletion.
* **Cross-Tenant Access Settings:** Secures modifications to external B2B collaboration.

**V. Troubleshooting Details**

* **Issue:** The "Add protected actions" button is greyed out in the Entra portal.
  * *Resolution:* Verify the user holds the Conditional Access Admin or Security Admin role. If utilizing PIM, verify the role is currently **active**, not just eligible.
* **Issue:** A PowerShell script fails unexpectedly when executing a `Remove-MgDeviceManagement...` or similar command.
  * *Resolution:* Verify the script is using the Microsoft Graph PowerShell SDK, not Azure PowerShell. Ensure the executing user is interacting with the script interactively to satisfy the prompt.

Would you like to shift focus to another SC-300 topic like Entra ID Protection or Application Proxy?
