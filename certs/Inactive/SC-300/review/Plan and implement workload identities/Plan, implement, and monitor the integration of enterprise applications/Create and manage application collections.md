### **SC-300 Expanded Study Review Sheet: Create and Manage Application Collections**

#### **1. Prerequisite and Licensing Notes**

* **Licensing Tier Restrictions:**
  * Creating and delegating custom collections strictly requires **Microsoft Entra ID P1 or P2**.
  * The Azure AD Free tier limits users to a default, uncustomizable single-page view of all assigned apps.
* **Administrative Role Requirements:**
  * **Cloud Application Administrator:** Minimum required built-in role to configure collections tenant-wide.
  * **Application Administrator:** Possesses full rights for collections, plus broader permissions for on-premises app proxies.
  * **Service Principal Owner:** Individual owners can manage their specific app's presence within an existing collection, but generally cannot create new collections.
* **Navigation Path:**
  * Admin Center: **Identity > Applications > Enterprise applications > App launchers > Collections**.

#### **2. Configuration Details: The "New Collection" Pane**

* **Basics Tab (Metadata Configuration)**
  * **Name:** The user-facing UI label on the portal tab. Microsoft recommends avoiding the word "collection" to reduce UI redundancy.
  * **Description:** An internal, admin-facing governance field. It documents the intent/audience, helps team coordination, and acts as a "source of truth" if administrative roles change. It never appears to end-users.
* **Applications Tab (Content and Layout)**
  * **Adding Content:** Used to select specific enterprise applications to group.
  * **Manual Sequencing:** Collections do **not** automatically sort alphabetically. Administrators must use visual **arrow controls** to dictate the exact order, prioritizing high-use tools at the top.
* **Owners Tab (Delegated Management)**
  * **Delegated Interface:** Assigned owners manage the collection strictly through the Microsoft Entra admin center, not the My Apps portal.
  * **Scoping:** Owner authority is restricted solely to the specific collection tab they are assigned to.
* **Users and groups Tab (Audience Selection)**
  * **Visibility Control:** Determines who sees the collection tab in their portal.
  * **Scalability:** Assigning groups instead of individual users is the Microsoft recommended best practice.

**Comparison Table: Object Ownership Rules**

| Entity Type | Can a Group be assigned as an Owner? | Admin Center Visibility Scope |
| :--- | :--- | :--- |
| **Application Collection** | **Yes** | Scoped to the specific collection tab configuration |
| **Enterprise Application** | **No** (Individual users only) | Scoped to the service principal object |

* **⚠️ EXAM TRAP:** Do not assume groups are blocked from owning collections just because they are blocked from owning enterprise applications. Application collections explicitly **allow groups** to be assigned as owners for flexible delegated administration.

#### **3. My Apps Portal Logic and Visibility Rules**

* **Collections as Dynamic Filters**
  * Collections do **not** act as physical folders or grant access permissions; they act as dynamic filters over apps a user is already authorized to access.
* **The Two-Step Visibility Rule**
  * For a tile to render, the user must be **assigned to the app** (directly or via group) AND the app's **"Visible to users?"** property must be set to **Yes**.
* **Scenario Example: The Empty Tab**
  * *Scenario:* An intern is added to the "Finance Department" group, which is assigned to the "Finance Tools" collection. However, the intern has not been granted app role assignments to any individual financial software yet.
  * *Result:* The intern will see the "Finance Tools" tab in their portal, but it will be completely **empty**.
* **The Default "Apps" Collection Behavior**
  * *Master Directory:* Every assigned app appears here by default, even if it is also placed into custom collections.
  * *Self-Service Control:* End-users can manually remove apps from this default view to reduce clutter.

#### **4. Technical Limits and Constraints**

* **The 950 Access Limit (Display Threshold)**
  * Users can only access a maximum of **950 applications** via the portal UI. Surplus apps remain accessible via direct URLs.
* **The 999 App Role Assignment Constraint (Governance Threshold)**
  * The portal engine is hard-coded to read a maximum of **999 app role assignments** per user.
  * *Consequence:* Exceeding this causes the portal to "clip" the data, making it impossible for admins to predictably control which apps render on the dashboard.
* **Troubleshooting Detail: Verifying the 999 Limit**
  * Because users cannot see their own assignment count, administrators must run a specific command using **Microsoft Graph PowerShell** to count the user's app role assignments against the 999 limit.

**Comparison Table: Application Display Limits**

| Limit | Threshold Type | Consequence of Exceeding |
| :--- | :--- | :--- |
| **950 Apps** | Access / Display Limit | Surplus apps are hidden from the portal but functional via URL. |
| **999 Apps** | Processing / Governance Constraint | The display logic breaks; admins lose control over the user's view. |

#### **5. Auditing, Monitoring, and Governance**

* **Audit Log Configuration**
  * Path: **Identity > Applications > Enterprise applications > Audit logs**.
  * Service Filter: Must be set to **"My Apps"** to isolate collection activity.
* **Tracked Events**
  * *Admin Events:* Create admin collection, Edit admin collection, Delete admin collection.
  * *End-User Events:* Self-service application adding (end user), Self-service application deletion (end user).

**Comparison Table: Audit Category Context**

| Audit Category | Use Case | Collection Relevancy |
| :--- | :--- | :--- |
| **ApplicationManagement** | Lifecycle, config, and structure of applications | **Correct category** for creating, editing, and deleting collections. |
| **UserManagement** | User accounts, password resets, governance policies | Incorrect for collections. |
| **DirectoryManagement** | Core directory changes (domains, tenant properties) | Incorrect for collections. |

* **⚠️ EXAM TRAP:** Do not select "Core Directory" or "UserManagement" for tracking collection creations. The system files collection edits strictly under **ApplicationManagement**, as it modifies the organizational state of the apps.

#### **6. Troubleshooting Details and Edge Cases**

* **Troubleshooting Detail: Office 365 App Updates Bug**
  * *The Issue:* Standard updates fail if the collection already contains Office 365 apps.
  * *The Workaround Sequence:* Go to the Applications tab -> **Remove all** existing Office apps -> **Re-add all** desired Office apps (old and new) in a single batch -> **Save**.
* **Troubleshooting Detail: My Apps Secure Sign-in Extension Prompts**
  * *Trigger:* Users are prompted to install the extension when launching **Password-based SSO** (credential replay) or **Application Proxy** (on-premises) applications.
  * *Constraint: Private Browsing:* The extension will **not function** in incognito, InPrivate, or Private browsing modes.
  * *Constraint: Mobile:* Requires the use of **Microsoft Edge mobile**; other mobile browsers are unsupported.
  * *Admin Fix:* To prevent the installation prompt, deploy the extension at scale using **Microsoft Intune** or Group Policy.
