### **SC-300 Exam: Comprehensive Identity and Access Study Guide (Expanded)**

#### **1. Core Architecture: Application Objects vs. Service Principals**

**Comparison Table: Architecture Blueprint vs. Instance**

| Feature | Application Object (Blueprint) | Service Principal (Instance) |
| :--- | :--- | :--- |
| **Location** | Exists only in the "home" tenant. | Exists in every tenant where the app is used. |
| **Identifier** | Globally unique Application ID (Client ID). | Locally unique Object ID. |
| **Admin Center Blade** | App registrations. | Enterprise applications. |
| **Primary Function** | Defines configuration, exposed APIs, and required resources. | Governs local tenant access, user assignment, and Conditional Access. |
| **Permissions Audit** | Shows "Requested" (static wish list) permissions. | Shows "Granted" (effective/consented) permissions. |

* **Troubleshooting & Lifecycle Management**
  * **The Deletion Trap:** Deleting an Application Object automatically deletes its home Service Principal.
  * **The Restoration Trap:** Restoring a soft-deleted Application Object through the UI **does not automatically restore its corresponding service principal**.
  * **Managed Identity Exception:** Managed Identities for Azure resources do not have an Application Object; they exist strictly as a local Service Principal object.
* **Scenario Example:** You are writing a PowerShell script to assign local users to an application. You must use the local **Object ID** of the Service Principal, not the Application ID of the App Object.

#### **2. Application Credential Security & Managed Identities**

**Comparison Table: Credential Security Hierarchy**

| Credential Type | Security Level | Use Case / Considerations |
| :--- | :--- | :--- |
| **Client Secrets (Passwords)** | Low (Vulnerable) | Strings easily leaked in plaintext configs or code repositories. |
| **Self-Signed Certificates** | Medium (Preferred over secrets) | Uses asymmetric cryptography. Private key never transmitted. |
| **CA-Signed Certificates** | High | Recommended for production when Managed Identities are not possible. |
| **Managed Identities** | Ultimate (Secretless) | Zero credential management; Azure automatically rotates keys. |

* **Configuration Details & Prerequisite Notes**
  * **Hosting Boundary:** Managed identities are strictly for workloads hosted *inside* Azure. If an app runs on-premises or in AWS, use certificates or workload identity federation.
  * **System-Assigned vs. User-Assigned Lifecycle:** System-assigned identities are deleted when the Azure resource (e.g., VM) is deleted. User-assigned identities are standalone and must be manually deleted.
* **Exam Traps & Troubleshooting**
  * **The 180-Day Trap:** Tenant administrators should use Application Management Policies to block new client secrets and enforce a maximum certificate lifetime of **180 days**.
  * **The Config File Trap:** Never store client secrets in plaintext configuration files. For legacy apps, secrets must be stored in **Azure Key Vault**.
  * **The Managed Identity Caching Delay:** When assigning an app role to a managed identity, Azure caches the tokens for up to 24 hours. Changes can take several hours to take effect, causing temporary "Access Denied" errors.

#### **3. Authorization: Scopes vs. App Roles**

**Comparison Table: Authorization Models**

| Property | Scopes | App Roles |
| :--- | :--- | :--- |
| **Permission Type** | Delegated Permissions. | Application Permissions. |
| **Context** | Signed-in user is present. | No user present (Daemon/Background) or Elevated user privileges. |
| **Access Level** | Baseline access (e.g., read own email). | Elevated access (e.g., admin read all emails). |
| **Token Claim** | `scp` claim. | `roles` claim. |
| **Manifest Property** | `oauth2PermissionScopes`. | `appRoles`. |
| **Consent Requirement** | Users can often self-consent. | Strictly requires Tenant Administrator consent. |

* **Configuration Details**
  * When creating an App Role for daemon app-only access, configure `Allowed member types` strictly to **Applications**.
* **Exam Traps**
  * **The Token Verification Trap:** Setting `Allowed member types` to "Both" creates a security risk where the API cannot distinguish if a human or an app made the request via the `roles` claim, requiring complex custom validation (e.g., checking the `idtyp` claim).
  * **The Group Overage Trap:** For multitenant apps, use App Roles instead of Security Groups. If a user is in over 200 groups, Microsoft Entra ID drops the groups from the token and replaces them with an **overage claim**, breaking authorization logic and forcing manual Graph API calls.

#### **4. Public vs. Confidential Clients & Redirect URIs**

* **Public Clients:** Mobile apps, Desktop apps, and SPAs. They run on user devices, **cannot hold secrets**, and can only request **Delegated permissions**.
  * **Exam Trap:** UWP and compiled mobile apps are still public clients. Never configure credentials on their app objects.
* **Confidential Clients:** Web APIs and daemon services running on secure servers. They can securely hold secrets/certificates and request both Delegated and Application permissions.
* **Redirect URI Security (Domain Takeovers)**
  * **The Threat:** Unmaintained ("dangling") Redirect URIs tied to expired domains can be purchased by attackers to intercept OAuth 2.0 authorization codes and access tokens.
  * **Configuration Rules:** Must use **HTTPS** (no HTTP), no wildcards (`*`), and no URL shorteners.
  * **Audit Traps:** Audit logs showing "Update Application" with unknown domains indicate a risk.
  * **Native Client Exception:** Public clients acting as isolated web agents can use the default endpoint `https://login.microsoftonline.com/common/oauth2/nativeclient`.

#### **5. Programmatic Permissions & The Application Manifest**

* **`oauth2PermissionScopes` vs. `requiredResourceAccess`**
  * Use `oauth2PermissionScopes` when your app acts as an API **exposing** delegated permissions to others.
  * Use `requiredResourceAccess` when your app acts as a client **requesting** permissions for itself.
* **Configuring `requiredResourceAccess`**
  * Requires `resourceAppId` (the target API's GUID).
  * Requires a `resourceAccess` array defining each permission's **`id` (GUID)** and **`type` (Scope or Role)**.
  * **The Overwrite Trap:** Updating this array via API/PowerShell replaces the entire list. You must include all existing permissions in your payload, or Entra ID will delete the omitted ones.
  * **The Request vs. Grant Trap:** Editing the manifest only statically requests permissions; a tenant admin must still perform a separate action to grant consent.

#### **6. Daemon Applications & The Client Credentials Flow**

* **Configuration Details**
  * Daemons use the OAuth 2.0 client credentials flow, authenticating as themselves.
  * They strictly use Application permissions (App Roles).
* **Exam Traps**
  * **The `.default` Scope Trap:** Daemons cannot dynamically request individual permissions. They must statically request the `{resource}/.default` scope (e.g., `https://graph.microsoft.com/.default`), telling Entra ID to bundle all previously admin-consented roles into the token's `roles` claim.
  * **PowerShell Cmdlet Distinction:** To assign an app role to a managed identity for a daemon, you cannot use the Azure Portal UI. You must use `New-MgServicePrincipalAppRoleAssignment` (not `User` or `Group` cmdlets) and provide the `-PrincipalId`, `-ResourceId`, and `-AppRoleId`.

#### **7. Multitenant Architecture, Consent, & Identifier URIs**

* **Application ID URIs (Identifier URIs)**
  * Acts as a prefix for custom delegated scopes and serves as the **audience (`aud`) claim**.
  * **Formatting Traps:** Default is `api://{clientId}`. Must use a verified custom domain if not using the default. **Must not end with a trailing slash ("/")**.
  * **Multitenant Boundary:** Single-tenant URIs must be unique per tenant. Multitenant URIs must be **globally unique** across the entire Microsoft Entra ecosystem.
* **Admin Consent Mechanisms**
  * **Developer-Initiated:** Because multitenant apps lack a blueprint in the customer's tenant, developers must trigger a sign-in request using `prompt=consent` or direct the customer to the `/adminconsent` endpoint.
  * **Checkbox Visibility Trap:** Only highly privileged roles (e.g., Global Admin, Privileged Role Admin) see the "Consent on behalf of your organization" checkbox.
* **Preauthorization vs. Security Restrictions**
  * **Preauthorization (`preAuthorizedApplications`):** Purely a user-experience feature. Bypasses the user consent prompt for specific delegated scopes (useful for frontend SPA to backend API logins).
  * **Access Restriction:** To actively block an unauthorized app from getting tokens, assign app roles and set the Enterprise Application property **"Assignment required?" to Yes**.

#### **8. The Principle of Least Privilege**

* **`.All` vs. `.OwnedBy` Privileges**
  * **The `.All` Trap:** Permissions like `Application.ReadWrite.All` grant highly privileged, tenant-wide access. Eliminate these on exams asking for "granular management."
  * **The `.OwnedBy` Solution:** `Application.ReadWrite.OwnedBy` dynamically scopes access so the app can only modify service principals it inherently owns, reducing the blast radius.
* **Exam Traps**
  * **Reducible Permissions:** Granting `.All` when `.OwnedBy` suffices creates a "reducible permission," posing a severe vertical privilege escalation risk.
  * **Application Impersonation Risk:** Apps with broad write permissions can modify credentials of other applications, impersonating their identities and elevating privileges across the tenant.

#### **9. Customer Identity: Native Authentication Limitations**

* **Prerequisite Notes:** Native authentication is strictly limited to **Microsoft Entra External ID tenants** (customer configurations).
* **Configuration & Trade-offs:**
  * Provides pixel-perfect UI control directly in the app without a browser redirect.
  * **SSO Trap:** Breaks cross-app Single Sign-On (SSO) via the system browser.
  * **IdP Support Trap:** Only supports local accounts (Email/password, OTP). Does not natively support federated social IdPs (Google, Apple, Facebook).
  * **Security Shift:** Transfers shared security responsibility for the login UI to the application developer.

#### **10. PowerShell SDK Command Mapping**

| Objective | Cmdlet / Parameter | Usage / Exam Trap |
| :--- | :--- | :--- |
| **Create global blueprint** | `New-MgApplication` | Generates App Object and globally unique Client ID. |
| **Create local instance** | `New-MgServicePrincipal` | Follows `New-MgApplication` to create the local Enterprise App execution instance. |
| **Single-tenant boundary** | `-SignInAudience 'AzureADMyOrg'` | Restricts sign-in strictly to the home tenant. Distractors like `SingleTenant` are false. |
| **Multitenant boundary** | `-SignInAudience 'AzureADMultipleOrgs'` | Allows users from any Entra directory. |
| **Assign Managed Identity Role** | `New-MgServicePrincipalAppRoleAssignment` | Only way to grant API permissions to a managed identity. |
