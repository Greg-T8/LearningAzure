### **1. Licensing, Prerequisites, and Capacity Planning**

* **Prerequisite Licensing Combinations:** Microsoft Entra ID Governance is an add-on requiring a specific base license.
  * Microsoft Entra ID Governance + **Microsoft Entra ID P1**.
  * Microsoft Entra ID Governance Step Up + **Microsoft Entra ID P2** (or EMS E5).
  * **Microsoft Entra Suite** (includes governance natively).
* **Capacity Limits:**
  * Organizations with the appropriate license combination can govern access to a maximum of **1500 applications per user**.
* **Per-User vs. Guest Billing:**
  * **Internal Users:** The tenant must have sufficient Governance licenses for all internal members governed (requestors, approvers, reviewers).
  * **External Users (Guests):** Governed via **Monthly Active User (MAU)** billing linked to an Azure subscription.
* **Feature-Specific Licensing Requirements:**
  * Basic access review features exist in Entra ID P2, but **intelligent features** (Access Review Agent, inactive user reviews, machine learning recommendations) **explicitly require the Microsoft Entra ID Governance license**.

> **🚨 EXAM TRAP:** Do not assume Entra ID P2 covers all entitlement management features. If a question asks about AI-driven recommendations or reviewing inactive users, the answer requires the **Governance add-on**.

---

### **2. Architecting Catalogs and Delegated Administration**

* **Catalog Architecture:** The mandatory parent container for resources (groups, apps, SharePoint sites) and access packages.
  * **Default State:** A "General" catalog exists by default for non-delegated, centralized IT management.
  * **Privileged Catalogs:** Automatically flagged if the catalog contains high-privilege resources, specifically **directory roles** or **OAuth API permissions**.
* **Delegating Administration (Least Privilege):**
  * **Catalog Creator:** Delegated to business leads. They can create/manage their own catalogs but **cannot see or manage catalogs they do not own**.
  * **Auto-Assignment:** Creating a catalog automatically makes the creator the **Catalog owner**.
* **Resource Onboarding Guardrails (Two-Pronged Check):**
  * Non-administrators must possess **both** the Catalog Owner role **AND** the technical resource ownership permission.
  * *Security Groups:* Requires `microsoft.directory/groups/members/update` and `microsoft.directory/groups/owners/update`.
  * *Enterprise Apps:* Requires `microsoft.directory/servicePrincipals/appRoleAssignedTo/update` [Conversation History].
  * *Bypass:* Global Administrators and Identity Governance Administrators bypass this and can add any resource to any catalog.

> **🚨 EXAM TRAP:** If a scenario asks for the "least privileged role" to allow a department manager to create packages for their own team, choose **Catalog creator**, not Identity Governance Administrator.

**Table 1: Entitlement Management Administrative Roles**

| Role | Can Create Catalogs? | Can Create Access Packages? | Can Edit Package Policies? | Can Edit Resource Roles? |
| :--- | :--- | :--- | :--- | :--- |
| **Identity Governance Admin** | Yes (Tenant-wide) | Yes (Tenant-wide) | Yes | Yes |
| **Catalog Owner** | No (Manages owned catalog) | Yes (In owned catalog) | Yes | Yes |
| **Access Package Manager** | No | No | Yes | Yes |
| **Access Pkg Assignment Manager**| No | No | No | No |

**🛠️ Troubleshooting Scenario:**

* **Issue:** A Catalog owner attempts to add a sensitive HR security group to their catalog but receives an error.
* **Root Cause:** The Catalog owner is not listed as an *owner* on the Azure AD security group object.
* **Fix:** An IT administrator or current group owner must add the Catalog owner as a technical owner of the HR group.

---

### **3. Designing Access Packages and Resource Roles**

* **Resource Roles:** Access packages bundle specific collections of permissions (Resource Roles).
  * *Groups:* Member or Owner.
  * *SharePoint:* Site Visitor, Site Member, Site Owner.
  * *Applications:* Custom roles defined in the application manifest (e.g., "Salesperson").
* **Separation of Duties (SoD):** Enforced via **Incompatible access packages**.
  * **Configuration:** Administrator marks two packages as incompatible.
  * **Behavior:** If User A holds Package 1, the system actively **blocks the assignment** of Package 2 and prevents User A from requesting it.

> **🚨 EXAM TRAP:** Do not confuse "Incompatible access packages" with "Catalog resource scoping". Scoping organizes resources into folders; Incompatible packages logically block conflicting user assignments.

**Table 2: Supported Resources by Identity Type**

| Resource Type | Standard Human User | AI Agent / Service Principal (Preview) |
| :--- | :--- | :--- |
| **Security Groups** | Supported | Supported |
| **Directory Roles** | Supported | Supported |
| **API Permissions (OAuth)** | Not standard for end-users | **Supported** |
| **SharePoint Online Sites** | Supported | **NOT Supported** |
| **Application Manifest Roles** | Supported | **NOT Supported** |
| **SAP Business Roles** | Supported | **NOT Supported** |

* **AI Agent Governance (Preview):**
  * Governed via the **"All agents (preview)"** assignment policy.
  * Must have a **human sponsor** accountable for approving requests and extending time-bound access.

---

### **4. Planning Access Lifecycles and Automation Strategies**

* **Automatic Assignment Policies:**
  * **Trigger:** Attribute-based rules (e.g., `user.department -eq "Marketing"`).
  * **Source of Truth:** Often driven by inbound provisioning from an HCM system (Workday, SuccessFactors).
  * **Constraint:** An access package can have a maximum of **ONE** automatic assignment policy. (You can add request-based policies alongside it).
* **Direct Assignment Policies:**
  * Used when administrators manually push access (bypassing requests).
  * **Governance Requirement:** Manual access **must** be tied to a policy to inherit expiration rules (e.g., expires in 90 days), preventing permanent backdoor access.

**Table 3: Lifecycle Automation Comparison**

| Feature | Primary Trigger | Primary Outcome | Use Case |
| :--- | :--- | :--- | :--- |
| **Automatic Assignment Policy** | Entra ID User Attribute Match | Adds/Removes access to groups/apps/sites | User moves from Sales to Marketing |
| **Lifecycle Workflows** | Joiner/Mover/Leaver event | Executes process tasks (Emails, TAPs) | Sending a welcome email to a new hire's manager |
| **Direct Assignment** | Manual Admin Action | Grants access governed by policy expiration | Bulk onboarding or helpdesk override |

---

### **5. Planning External Identity Governance (B2B)**

* **Connected Organizations:**
  * Defines authorized partner domains.
  * Enables **scoping**: Access package policies can be restricted so only users from a specific partner domain can see/request the package.
  * **Sponsorship:** Allows defining **Internal Sponsors** (your project managers) and **External Sponsors** (partner contacts) for approval flows.
  * **Auto-Discovery:** If a user from an unknown domain requests access via an "All users" policy, the system creates a **"proposed" connected organization** for admin review.
* **Just-in-Time Provisioning:**
  * When an external user requests access and is approved, the system **automatically creates a B2B guest account**.
* **External User Lifecycle Settings:**
  * **Trigger:** Evaluated when the guest's **last access package assignment expires** (or is revoked).
  * **Actions:** "Block sign-in only", "Delete user", or implement a "Waiting period" (e.g., 30 days before deletion).

**🛠️ Troubleshooting Scenario:**

* **Issue:** An external user from a trusted Connected Organization is given the My Access portal link but cannot see the access package.
* **Root Cause:** The parent Catalog housing the package is not configured for external visibility.
* **Fix:** Navigate to Catalog settings and change **"Enabled for external users"** to **Yes**.

---

### **6. Custom Extensibility (Azure Logic Apps)**

* **Prerequisites:**
  * Requires **Microsoft Entra ID Governance** or Microsoft Entra Suite.
  * Requires an Azure subscription for Consumption-based Logic Apps.
* **Role Requirement:**
  * Must hold the **Identity Governance Administrator** role (the least privileged role capable of managing custom extensibility/catalogs globally).
* **Triggers:**
  * Logic apps can fire during three stages: **Request processing**, **Assignment granting**, or **Assignment removal**.

**Table 4: Logic App Execution Behaviors**

| Behavior | Mechanism | Best For... |
| :--- | :--- | :--- |
| **Launch and Continue** | Triggers Logic App and moves to next Entra ID provisioning step immediately. | Sending a Teams notification; logging an event. |
| **Launch and Wait** | Triggers Logic App and **pauses** Entra ID provisioning. Waits for a "resume" signal from the external system. | Creating a ServiceNow ticket; waiting for legacy DB provisioning. |

> **🚨 EXAM TRAP:** If a scenario asks how to provision access to a legacy system that lacks native Entra provisioning, and the system must be ready *before* the access package is marked "Delivered", choose **Launch and Wait**.

---

### **7. Access Review Agent (AI Insights)**

* **Platform:** Interacts with reviewers entirely within **Microsoft Teams** using natural language.
* **Capabilities:**
  * Identifies **"inactive users"** (e.g., no sign-in for 30 days).
  * Identifies **"low affiliation"** based on org reporting structure.
  * Provides actionable **recommendations** ("Approve" or "Deny") to reduce attestation fatigue.
