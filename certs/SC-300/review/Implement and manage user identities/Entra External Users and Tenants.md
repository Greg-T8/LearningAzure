### **1. Managing External Identities, B2B Collaboration, and Cross-Tenant Access**

* **B2B Collaboration vs. B2B Direct Connect**
  * **Comparison: Architecture and Use Cases**

| Feature | B2B Collaboration | B2B Direct Connect |
| :--- | :--- | :--- |
| **Directory Object** | External user explicitly added as a Guest (or Member) object. | User object is **never created** in the resource tenant. |
| **Primary Use Case** | Broad application and group assignment. | Strictly limited to **Teams Connect shared channels**. |
| **Authentication Flow** | Authenticates, then token is evaluated against resource tenant policies. | Seamlessly authenticates in home tenant; token trusted by resource tenant. |

    *   📝 **Prerequisite/Licensing Note:** To use B2B direct connect, both organizations must explicitly configure a mutual, two-way trust using Cross-tenant access settings.

* **Cross-Tenant Access Settings (CTAS)**
  * **Inbound access:** Controls how external users from other Microsoft Entra organizations collaborate with you.
  * **Outbound access:** Controls how your internal users collaborate with external Microsoft Entra organizations.
  * ⚙️ **Configuration Detail (Trust Settings):** Resource tenants can accept inbound security claims for **Multifactor Authentication (MFA)**, **compliant devices**, and **Microsoft Entra hybrid joined devices** directly from the partner's home tenant to prevent double-prompting.
  * ⚙️ **Configuration Detail (Layered Policies):** Administrators set a **Default Setting** (e.g., block all access) and override it with **Organizational Settings** for specific partner domains.
  * 💡 **Scenario Example:** You partner with "Fabrikam" and want them to access only a specific SharePoint site. You configure CTAS to allow that site and block all other enterprise apps for Fabrikam users.
  * 🚨 **Exam Trap (The Invitation Fallacy):** Inbound CTAS policies do *not* prevent internal users from sending B2B invitations, nor do they prevent guests from redeeming them. CTAS controls token issuance; if app access is blocked, no token is issued regardless of a successful invite redemption.
  * 🚨 **Exam Trap (CTAS Scope):** CTAS applies strictly to collaboration with other **Microsoft Entra organizations**. For non-Microsoft Entra users, you must use standard *External collaboration settings*.

* **Bulk B2B Invitations and Automation**
  * **Portal CSV Method:** You download a template from the admin center, populate email/display names, and upload.
  * ⚙️ **Configuration Detail (CSV Strict Rules):** You **must never modify or delete the first two rows** (version number and column headings), you cannot add custom columns, and the example data row must be removed.
  * **Programmatic Method:** Developers use PowerShell or the Microsoft Graph API (`POST https://graph.microsoft.com/v1.0/invitations`).
  * 🔧 **Troubleshooting Detail (Guest Limitations):** Even if granted administrative roles, **guest users cannot initiate bulk operations** in the portal.
  * 🔧 **Troubleshooting Detail (Failures):** Download the results file from the **Bulk operation results** page to view per-user failure reasons.
  * **Comparison: B2B Invitation Daily Quotas**

| Tenant Type & Licensing | Tenant Age <= 30 Days | Tenant Age > 30 Days |
| :--- | :--- | :--- |
| **Workforce WITHOUT Paid Licenses** | Max **10** invitations per day. | Max **100** invitations per day. |
| **Workforce WITH Paid Licenses** | Max **200** invitations per day. | Standard service quotas apply. |

* **Customizing the B2B Invitation API Flow**
  * **Comparison: Invitation URL Properties**

| Property | Description / Trigger | Modification Rules |
| :--- | :--- | :--- |
| `inviteRedeemUrl` | The unique link returned by the API that the user clicks to **begin** the acceptance process. | Cannot be modified; captured from the API response to inject into custom emails. |
| `inviteRedirectUrl` | The destination where the user lands **after** successfully redeeming and authenticating. | Sent in the JSON body of the API request; defaults to **MyApplications** if not explicitly set. |

    *   ⚙️ **Configuration Detail (Custom Emails):** You can suppress the default Microsoft email via the API, capture the generated `inviteRedeemUrl`, and send your own highly customized branded email to the guest.
    *   🚨 **Exam Trap (Callback Endpoint):** `authCallbackEndpoint` is a distractor property not used in the Graph API for B2B invitations.

### **2. Customer Identity and Access Management (CIAM) & External Tenants**

* **External vs. Workforce Tenant Architecture**
  * **Purpose:** External tenants are specifically built for CIAM (consumers, business customers), whereas workforce tenants are for employees, B2B partners, and line-of-business apps.
  * ⚙️ **Configuration Detail (Neutral Branding Fallback):** External tenants default to neutral branding; if custom logos fail to load due to latency, it safely falls back to a neutral template (not Microsoft branding).

* **Managing Accounts in External Tenants**
  * **Comparison: External Tenant Account Types**

| Account Type | Purpose & Creation | Default Permissions |
| :--- | :--- | :--- |
| **Admin Accounts** | Created using work accounts to manage resources, user flows, and apps. | Standard admin directory roles. |
| **Customer Accounts** | Consumers/business customers created via self-service CIAM user flows. | Explicitly restricted from accessing info about other users, groups, or devices. |

    *   🔧 **Troubleshooting Detail (The Duplicate Account Lockout):** If an admin tests a customer sign-up flow using their admin email address, the system does not merge accounts. It creates a **second, completely separate user account** with restricted customer privileges.
    *   🔧 **Troubleshooting Detail (Least Privilege Precedence):** If an admin with duplicate accounts signs in via a tenant-specific URL (e.g., `<tenantName>.onmicrosoft.com`), the system enforces the lowest privilege, locking them out of admin controls.
    *   💡 **Scenario Example (Recovery):** An admin locked out by duplicate accounts must sign completely out and navigate to the generic `https://entra.microsoft.com` URL to authenticate correctly as an administrator.

* **Administrative Invitations in CIAM**
  * 🚨 **Exam Trap (Customer Invites):** In an external tenant, the "Invite external user (preview)" feature is for **administrative purposes only**. You cannot use it to invite customers; it bypasses CIAM user flows completely. Customers must use self-service sign-up flows.
  * ⚙️ **Configuration Detail (Admin Invites):** Microsoft recommends inviting admins from your primary enterprise workforce directory rather than creating local admins.

* **Custom User Attributes**
  * **Purpose:** Collecting specific business data (e.g., Customer ID) not included in built-in attributes (like City/Surname) during CIAM sign-up.
  * ⚙️ **Configuration Detail (Data Types):** Must be defined globally as a String, Boolean, or Integer.
  * ⚙️ **Configuration Detail (Graph API Syntax):** To interact programmatically, use `extension_{appId-without-hyphens}_{custom-attribute-name}`.
  * 🔧 **Troubleshooting Detail (Storage Architecture):** Custom attributes are stored as directory extensions inside a hidden, auto-generated app called **`b2c-extensions-app`**. **Never delete this app** or you will break the attributes.
  * 💡 **Scenario Example (Token Integration):** You can configure custom attributes to be emitted as SAML/ID **token claims**, allowing your app to receive the exact Customer ID upon sign-in.
  * 🚨 **Exam Trap (Token Claims vs. ABAC):** Custom User Attributes can be configured as token claims for CIAM apps. Do not confuse these with *Custom Security Attributes*, which are strictly for internal Zero Trust/ABAC and cannot be used in token claims.

### **3. Architecture, Customization, and Migrations (B2C & External ID)**

* **Custom URL Domains (White-labeling)**
  * **Purpose:** Masking default endpoints (`ciamlogin.com`) behind your own domain (`login.contoso.com`).
  * ⚙️ **Configuration Detail (Azure Front Door):** Custom URL domains require **Azure Front Door** acting as a reverse proxy, mapped via a **CNAME record** at your DNS registrar. Azure Traffic Manager is invalid because it cannot act as a reverse proxy.
  * 📝 **Prerequisite/Licensing Note:** Premium tier Azure Front Door applies an Azure Web Application Firewall (WAF) to protect the public login pages from DDoS and malicious bot activity.
  * ⚙️ **Configuration Detail (MSAL Code):** In your application's `authConfig.js` file, you must explicitly declare your custom domain in the **`knownAuthorities`** array, or the MSAL library will block the request as a security risk. The authority URL must be structured as `https://<custom-domain>/<tenant-ID>`.

* **Just-In-Time (JIT) Password Migration**
  * **Purpose:** Seamlessly moves users from a legacy system to External ID by capturing and migrating their password in the background during their first sign-in attempt, avoiding forced resets.
  * ⚙️ **Configuration Detail (The API Flow):** Relies on the **`OnPasswordSubmit` custom authentication extension**. Entra encrypts the submitted password, sends it to a custom REST API (e.g., Azure Function) to validate against the legacy system, and if valid, returns a `MigratePassword` response, securely storing the credential.
  * 🚨 **Exam Trap (Fallback):** JIT migration only works for users who sign in during coexistence. Users who never log in will eventually require a forced reset.
  * **Comparison: Custom Authentication Extension Roles**

| Role Name | Capabilities | Limitations |
| :--- | :--- | :--- |
| **Authentication Extensibility Administrator** | Create and manage custom authentication extensions. | Cannot assign extensions to applications. |
| **Authentication Extensibility Password Administrator** | Trigger the password submit event for migrating legacy credentials. | Highly specific scope; does not manage general extensions. |
| **Application Administrator** | Assigns the extension to the app registration and grants admin consent. | Cannot create the core authentication extension itself. |

* **High Scale Compatibility (HSC) Mode**
  * **Purpose:** A specialized migration path for legacy Azure AD B2C tenants with **~5 million or more directory objects**.
  * ⚙️ **Configuration Detail:** Runs B2C and External ID side-by-side in the exact same tenant, sharing users and credentials to allow phased app migration.
  * 🚨 **Exam Trap (Feature Gaps):** HSC mode is missing major features. If enabled, you **cannot use social identity providers (Google/Facebook), passkeys, or age-gating**.

* **External ID Logging and Monitoring**
  * **Comparison: Log Analytics Setup by Tenant Type**

| Feature | Workforce Tenant | External Tenant |
| :--- | :--- | :--- |
| **Subscription Ownership** | Can own Azure subscriptions. | Cannot own Azure subscriptions. |
| **Required Infrastructure** | Standard Diagnostic Settings. | **Azure Lighthouse** is required to bridge the log flow. |
| **Workspace Location** | Resides locally in the same tenant. | Resides externally in the linked workforce tenant. |

    *   📝 **Prerequisite/Licensing Note:** You must authenticate with the **Owner role** (Azure RBAC, not classic admin) on the workforce subscription during setup, and hold **Security/Application Administrator** in the external tenant.
    *   🔧 **Troubleshooting Detail (Diagnostic Wizard):** If Subscription/Resource group fields are read-only, you likely clicked "Review" too early or refreshed. You must remove the "Service Provider" info in the Azure portal and restart the wizard.
    *   🚨 **Exam Trap (Microsoft Sentinel):** Direct setup of Microsoft Sentinel from inside an external tenant is **not supported**. Logs must be routed to the workforce Log Analytics workspace first, and Sentinel is configured exclusively in the workforce tenant.

### **4. Microsoft Entra Users, Roles, and Billing**

* **Monthly Active Users (MAU) Billing Model**
  * **Purpose:** Charges based on the count of unique users who register authentication activity within a calendar month.
  * ⚙️ **Configuration Detail:** Billing is aggregated across all workforce and external tenants linked to an Azure subscription.
  * **Comparison: MAU Billing by Tenant/Service**

| Tenant Type / Service | Who is Counted? | Free Tier Allowance |
| :--- | :--- | :--- |
| **Workforce Tenant** | **Only Guest users** (Member users covered by internal licenses). | First 50,000 MAUs are free. |
| **External Tenant (CIAM)** | **All users** (Consumers, guests, admins). | First 50,000 MAUs are free. |
| **Entra ID Governance / Global Secure Access** | Guest users performing service-specific actions. | **No free tier**; 50k MAU allowance does not apply. |
| **Premium Add-ons** | Varies by add-on. | **No free tier**. |

* **The `UserType` Property**
  * **Purpose:** Determines default directory permissions. Members can read directory info, register apps, and invite guests; Guests are heavily restricted and cannot see full user/group lists.
  * 🚨 **Exam Trap (Internal vs External):** Do not confuse `UserType` with where a user authenticates. Internal/External defines the authentication source, whereas Member/Guest defines directory permissions.
  * 💡 **Scenario Example:** You can manually "flip the bit" and change an external business partner's `UserType` to **Member**, granting them employee-level permissions while they continue to log in via their external IdP.

* **Username Sign-in Identifiers**
  * ⚙️ **Configuration Detail:** You can update existing users to add a username via the Microsoft Entra admin center (Identities section) or Graph API (`identities[]` array). Users can hold both an email and username simultaneously.
  * 📝 **Prerequisite Note:** A username can only be added to external users who currently have an email and password account.
  * 🚨 **Exam Trap (Account Deletion):** You never have to delete and recreate a user just to add a username alias.
  * 🚨 **Exam Trap (Policy Requirement):** Even if you assign a username via Graph API, authentication will fail if the "Username" option is not globally enabled in the tenant's Sign-in identifiers policy.

### **5. Managing Microsoft Entra Identities, Roles, and Administrative Units**

* **Administrative Units (AUs)**
  * **Contents:** AUs strictly contain **users, groups, or devices**.
  * 📝 **Prerequisite/Licensing Note:** Admins assigned a scoped role require **Entra ID P1**. Standard members only need **Entra ID Free** unless dynamic membership rules populate the AU (which then requires P1 for all members).

* **Hybrid Identity & Source of Authority (SOA)**
  * ⚙️ **Configuration Detail:** Core profile updates (name/title) must happen **on-premises**. The portal actively blocks edits.
  * 🚨 **Exam Trap (Cloud Exceptions):** **Usage Location** must be set directly in the cloud before applying M365 licenses. Source of Authority conversion allows transferring synced users entirely to cloud management.

* **Self-Service Password Reset (SSPR)**
  * **Comparison: User vs. Administrator SSPR Policies**

| Feature | Standard Users | Privileged Administrator Accounts |
| :--- | :--- | :--- |
| **Enablement Status** | Must be explicitly enabled (None, Selected, All). | **Always enabled** by default. |
| **Authentication Methods Required** | 1 or 2 (Configured by admin). | **Strictly 2** (Hardcoded "two-gate" policy). |
| **Registration Prerequisite** | Pre-register the minimum number of methods. | Must pre-register 2 methods. |

### **6. Managing Domains, Verification, and Branding**

* **Domain Limits & Verification**
  * **Comparison: Domain Limits**

| Domain Type | Hard Limit | Recommended Limit |
| :--- | :--- | :--- |
| **Managed Domains (Cloud Auth)** | 5,000 | 5,000 |
| **Federated Domains (AD FS)** | 2,500 | 300 |

    *   🔧 **Troubleshooting Detail (TTL Timeout):** Incorrect DNS info at the registrar means you must wait for the internet's **Time to Live (TTL) to time out (typically 60 minutes)** before retrying verification.

* **Domain Administration & Removal**
  * 🚨 **Exam Trap (Federation Setup):** Setting up federation requires **both** the Hybrid Identity Administrator and Domain Name Administrator roles.
  * ⚙️ **Configuration Detail (ForceDelete):** Forcing custom domain removal asynchronously renames UPNs/proxy addresses to the default `.onmicrosoft.com` and **disables the impacted user accounts**. ForceDelete fails if references >1,000, if it is a federated domain, or if it is the primary domain.

### **7. Device Management & Dynamic Groups**

* **Dynamic Device Groups Syntax**
  * **Comparison: Device Trust Types**

| Device State | Required `deviceTrustType` Syntax Match |
| :--- | :--- |
| **Microsoft Entra hybrid joined** (On-prem AD synced) | `"ServerAD"` |
| **Microsoft Entra joined** (Cloud-only) | `"AzureAD"` |
| **Microsoft Entra registered** (BYOD) | `"Workplace"` |

    *   🚨 **Exam Trap:** "OnPremiseJoined" is a fabricated distractor value. You must strictly use **ServerAD**.

* **Group Expiration and Automation**
  * **Scope:** Applies only to **Microsoft 365 groups** (not security groups). Auto-renews based on Teams, SPO, Outlook, or Viva Engage activity.
  * ⚙️ **Configuration Detail (API Authorization):** Non-admin group creation via Graph API requires updating `allowedToCreateSecurityGroups` under `authorizationPolicy` (for security groups) or `EnableGroupCreation` under `groupSettings` (for M365 groups).
