### **Domain 1: Microsoft Entra Applications & Service Principals**

**1. Architectural Entities & Identifiers**

| Feature | Application Object (App Registration) | Service Principal (Enterprise Application) |
| :--- | :--- | :--- |
| **Location** | Resides strictly in the "home" tenant. | Instantiated locally in every tenant where the app is used. |
| **Purpose** | The global blueprint/template (defines protocols, exposed API scopes). | The local instance (governs local access, Conditional Access, role assignments). |
| **Identifier** | **Application ID (Client ID)** (Identical globally across all tenants). | **Object ID** (Unique to your specific directory). |
| **API Namespace** | `applications`. | `servicePrincipals`. |

* **Configuration Details:**
  * To target single-tenant applications via custom roles, use the `.myOrganization` subtype. The underlying Microsoft Graph property verified for this is `signInAudience` set to `AzureADMyOrg`.
* **Scenario Example (Automation):** An administrator writes a script to assign users to an application. The script strictly requires passing the **Object ID of the Service Principal**. Passing the Application ID will cause the script to fail.
* **🚨 Exam Traps:**
  * *The Tenancy Creation Trap:* A single-tenant application has 1 App Object and 1 SP Object (both in the home tenant). A multi-tenant application has 1 App Object (home tenant) but creates a unique SP Object in *every* customer's tenant that consents to it.
  * *The PowerShell Update Trap:* The `AzureAD` module is deprecated. Use `Get-MgBetaServicePrincipal` to retrieve the local application. Using `Get-MgBetaApplication` retrieves the blueprint and cannot be used to modify local user access.

**2. Application Manifests & API Permissions**

| `allowedMemberTypes` Value | Permission Type | Target Persona | Consent Requirement |
| :--- | :--- | :--- | :--- |
| **"User"** | Delegated Permission. | Acts on behalf of a signed-in human. | User or Admin (depending on scope sensitivity). |
| **"Application"** | Application Permission. | App-only access for automated workloads (daemons/scripts). | **Strictly Administrator Consent**. |

* **Configuration Details:** The manifest schema does not contain a "ServicePrincipal" value. To assign a role to a Service Principal, you must set `allowedMemberTypes` to `"Application"`.
* **🚨 Exam Trap (The Schema Property):** The property defining this is strictly named `allowedMemberTypes`, not `memberTypes`.

**3. Application Ownership & Object Lifecycle**

| State | Duration/Limit | Status |
| :--- | :--- | :--- |
| **Soft Delete** | Retained for 30 days. | Suspended. Consumes a slot in the user's 250-object quota. |
| **Hard Delete** | Permanent. | Cannot be recovered. Instantly frees up the creation quota. |

* **Prerequisites/Licensing:**
  * Users are limited to creating a maximum of 250 Microsoft Entra resources.
* **Troubleshooting Details:**
  * If a restored application continues to fail policy checks, verify Conditional Access. Restoring a soft-deleted App Registration restores the Service Principal, but previous Conditional Access policies tied to it are lost and must be manually rebuilt.
* **🚨 Exam Traps:**
  * *The Owner Deletion Trap:* Application "Owners" only have the `microsoft.directory/applications/delete` permission (soft-delete). They lack the `deletedItems.applications/delete` permission and **cannot hard delete** an app to free up their quota.
  * *The Hard Delete Requirement:* Hard deletions strictly require the Application Administrator, Cloud Application Administrator, or Global Administrator role.
  * *The Admin Consent Trap:* Being an App Owner does not bypass security. An Owner cannot grant tenant-wide admin consent for their own app; a highly privileged role is required.

### **Domain 2: Managing Application Access & Assignments**

**1. Assignment Modes & Group Enforcement**

| Feature | Individual Assignment | Group-Based Assignment |
| :--- | :--- | :--- |
| **Licensing Required** | Microsoft Entra ID Free. | **Microsoft Entra ID P1 or P2**. |
| **Management Scale** | Manual, unscalable. | Dynamic, attribute-based, allows delegated ownership. |

* **Prerequisites/Licensing:**
  * Using dynamic membership groups for app assignments requires a P1 license for *every unique user* who is a member of the dynamic group.
* **Configuration Details:**
  * Assigned groups (Security, M365, or Distribution) must have their `SecurityEnabled` property set to `True`.
* **🚨 Exam Traps:**
  * *The Nested Groups Trap (Major):* Group-based assignment to Enterprise Apps **strictly does not cascade to nested groups**. If Group B is inside Group A, members of Group B receive no access.
  * *The Enforcement Trap:* For assignments to be evaluated, the Enterprise App's **"User assignment required?"** toggle must be set to **Yes**. If set to No, the assignments are bypassed, and the app is open to the entire directory.

**2. PowerShell Automation for Assignments**

* **Configuration Details (Required Parameters):**
  * `-UserId` / `-PrincipalId` (The human/identity receiving access).
  * `-ResourceId` (The Object ID of the Enterprise App Service Principal).
  * `-AppRoleId` (The specific ID of the application role).
* **Scenario Example (Default Access):** You must script user assignment for a legacy application that has no custom app roles defined. You must fulfill the API requirement by passing the explicit default "empty" GUID: `00000000-0000-0000-0000-000000000000`.
* **🚨 Exam Traps:**
  * *The Cmdlet Verb Trap:* You are not updating a user property; you are creating a new bridge object (AppRoleAssignment). Therefore, you must use the **`New-`** verb (`New-MgBetaUserAppRoleAssignment`), not `Set-`.
  * *The Target Identity Cmdlet Trap:* If assigning a group, use `New-MgBetaGroupAppRoleAssignment`. If assigning a Managed Identity, use `New-MgServicePrincipalAppRoleAssignment`.

**3. Auditing Access**

* **Configuration Details:** To audit all users/groups with access to an app via PowerShell, execute `Get-MgBetaServicePrincipalAppRoleAssignedTo` against the Service Principal Object ID.
* **🚨 Exam Trap:** Do not select cmdlets targeting the Application (App Registration) object. Assignments live strictly on the Service Principal.

### **Domain 3: Role-Based Access Control (RBAC) & Governance**

**1. Container Scopes vs. Resource Scopes**

| Scope Type | Target Example | Boundary Mechanics |
| :--- | :--- | :--- |
| **Container** | Administrative Unit (AU), Tenant | Grants permissions over objects *inside* the container, but **not on the container itself**. |
| **Resource** | Enterprise App, Security Group | Grants permissions over the resource itself, but **not on the members inside it**. |

* **Scenario Example (AU Boundaries):** A Helpdesk Admin scoped to a "Sales" Administrative Unit can reset passwords for users inside it, but they explicitly cannot delete the AU or rename the AU.
* **🚨 Exam Traps:**
  * *The Group Member Trap:* If you add a Security Group to an AU, the AU admin can rename the group, but they **cannot manage the users inside the group** unless those users are also explicitly direct members of the AU.
  * *Restricted Management AUs:* Tenant-wide Global Admins are strictly locked out of modifying objects placed in a Restricted AU unless they are explicitly granted a role scoped directly to that specific Restricted AU.

**2. Custom Roles vs. Built-in Roles**

| Feature | Built-in Roles | Custom Roles |
| :--- | :--- | :--- |
| **Cost** | Free. | **Microsoft Entra ID P1 per assigned user**. |
| **Modifiability** | Fixed (cannot be altered). | Highly granular, scoped via specific namespaces. |
| **Blast Radius** | High (e.g., Application Admin manages all apps). | Low (can be scoped to a single object/app). |

* **Prerequisites/Licensing:** If assigning a custom role to a "role-assignable group", you must possess P1 licenses for the group structure.
* **Configuration Details:**
  * `microsoft.directory/applications/*` = Manages App Registrations.
  * `microsoft.directory/servicePrincipals/*` = Manages Enterprise Apps (SSO, provisioning, user assignments).
* **🚨 Exam Traps:**
  * *The Privilege Escalation Risk:* Assigning the built-in Application Administrator role allows the user to add credentials to any app and impersonate it, potentially escalating their privileges if the app holds powerful Graph API access.

**3. Token Claims Architecture (`wids` vs. `roles`)**

| Claim Type | Content | Evaluation |
| :--- | :--- | :--- |
| **`wids`** | Object IDs of **tenant-wide built-in Entra roles** (e.g., Global Admin). | Used by Graph API to instantly authorize admin actions without querying the directory. |
| **`roles`** | Names of **custom app roles** defined by developers (e.g., "Standard User"). | Used by the specific application to determine user access level. |

* **Troubleshooting Details:** You can view the `Wids` property in Microsoft Entra sign-in logs to audit exact administrative power during a session.
* **🚨 Exam Traps:**
  * *The Implicit Flow Trap:* Tokens issued via the older implicit flow strictly omit `wids` and `groups` claims to prevent HTTP URL length limit crashes.
  * *Token Bloat:* Exceeding role/group limits (e.g., >200 groups) forces the app to manually query the Graph API to resolve access.

**4. The AI Administrator Role**

* **Configuration Details:** Can manage Microsoft 365 Copilot, publish/block agents, view usage reports, and grant standard tenant-wide consent.
* **🚨 Exam Traps:**
  * *The Graph Consent Trap:* AI Administrators **cannot grant consent for Microsoft Graph application permissions**. This strictly requires a Global or Privileged Role Admin.
  * *The User Management Trap:* AI Administrators strictly cannot manage human user licensing, passwords, or sign-in sessions.

### **Domain 4: Microsoft Entra Application Proxy & Networking**

**1. Application Proxy Authentication Flows**

| Mode | Mechanism | Security Features |
| :--- | :--- | :--- |
| **Passthrough** | "Dumb pipe"; no cloud interception. | None. **Cannot enforce Conditional Access, MFA, or SSO**. |
| **Entra ID Pre-Authentication** | User must authenticate to cloud *before* reaching the internal network. | Terminates traffic in cloud (DoS protection), enforces MFA, enables SSO. |

* **Configuration Details:**
  * Connectors strictly require **outbound connections** over ports 80 and 443.
  * You do not need to open inbound firewall ports or deploy the connector in a DMZ.
* **Troubleshooting Details:** If SSO is disabled but Pre-Authentication is enabled, users experience "Double Sign-In" (once to Entra ID, once to the local server).
* **🚨 Exam Traps:**
  * *SAML Custom Domain Trap:* SAML-based applications must strictly use Custom Domains. Relying on the default `.msappproxy.net` domain causes audience mismatches.
  * *SAML Order of Operations:* You must set pre-authentication to Entra ID first, generate the External URL, and *then* copy that exact External URL into the backend SAML Identifier/Reply fields.

**2. Kerberos Constrained Delegation (KCD) & Translating Identities**

* **Configuration Details:** The cloud proxy service extracts the **UPN and SPN** from the token, passing them via secure channel to the on-prem connector, which impersonates the user to request a Kerberos ticket.
* **Scenario Example (Identity Mismatch):** The cloud domain is `joe@contoso.com` but the internal legacy app requires the SAM account name format `CONTOSO\joe`. The administrator configures **Delegated Login Identity** on the Enterprise App to extract only the "On-premises SAM account name" to resolve the mismatch.
* **Troubleshooting Details:** Check **Event 24029** on the connector server to audit the exact identity string the connector attempted to delegate.
* **🚨 Exam Traps:**
  * *The SSO Mode Prerequisite:* The "Delegated Login Identity" translation setting is strictly only available when the SSO mode is set to **Integrated Windows Authentication**.
  * *The Cross-Domain Trap:* If users reside in a different Active Directory domain than the connector/app, you must use the "On-premises user principal name" format for the Delegated Login Identity.

**3. Infrastructure Limitations (Managed Domains)**

* **Scenario Example (Domain Services):** A company uses Microsoft Entra Domain Services. Because they lack full Domain Admin rights, they cannot configure traditional account-level KCD. They must use **Resource-based KCD**.
* **🚨 Exam Traps:**
  * *The Default Container Trap:* VMs placed in the default `Microsoft Entra DC Computers` OU cannot be configured for Resource-based KCD due to locked permissions. You must create a **custom OU**.
  * *The PowerShell Requirement:* Resource-based KCD across domains or custom OUs requires using PowerShell (`Set-ADComputer`).

**4. Connector Group Delegation & Management**

* **Configuration Details:** To delegate proxy server management (Create/Read/Update/Delete) without granting Application Admin rights, use a custom role targeting `microsoft.directory/connectorGroups/*` and `connectors/*`.
* **🚨 Exam Traps:**
  * *The Cloud App Admin Trap:* The Cloud Application Administrator role explicitly **cannot manage Application Proxy settings**.
  * *The Infrastructure Boundary:* The `connectors/*` permission only manages the physical proxy servers. It does not allow the admin to modify the External/Internal URL routing settings on the Enterprise App.
  * *The Bulk Move PowerShell Trap:* Assigning an app to a new connector group updates an object relationship link. You must use `Set-MgBetaApplicationConnectorGroupByRef` (note the `ByRef` suffix) in a `foreach` loop. Ensure you query the `Beta` endpoint.
