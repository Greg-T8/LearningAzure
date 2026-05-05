### SC-300 Exhaustive Study Review: External Identity Providers (SAML & WS-Fed)

#### 1. External Tenant User Scenarios & Supported Providers

* **Workforce Tenants (B2B Collaboration / Invited Guests)**
  * Designed for explicitly invited external business partners.
  * Supported primary authentication methods: Microsoft Entra accounts, Microsoft accounts, Emailed one-time passcode, Google federation, and **SAML/WS-Fed federation**.
* **External Tenants (CIAM / Self-Service Sign-Up)**
  * Designed for consumers and business customers using self-service user flows.
  * **Local Accounts:** The system creates a user object (local account) in the directory during registration.
  * **Default Method:** "Email with password" is the default local account identity provider. The system verifies the email via OTP, then the user creates a password and profile attributes.
  * **Alternative Methods:** Email with one-time passcode (OTP every sign-in), Username/alias sign-in, Social IdPs, and custom SAML/WS-Fed/OIDC federations.

**Comparison Table: Supported Identity Providers by Scenario**

| Identity Provider / Method | Invited Guests (Workforce B2B) | Self-Service Users (External / CIAM) |
| :--- | :--- | :--- |
| Microsoft Entra / Microsoft Accounts | Yes | Yes (via user flows) |
| Emailed One-Time Passcode | Yes | Yes |
| Email with Password (Default Local) | No | Yes |
| Google Federation | Yes | Yes |
| Facebook Federation | **No** | Yes |
| SAML / WS-Fed Federation | Yes | Yes |

* **Exam Trap:** The exam will try to trick you into selecting "Facebook federation" for invited B2B guests. Facebook is strictly supported *only* for self-service sign-up users.
* **Exam Trap:** Believing federated users are not stored locally. The first time a user successfully authenticates via a federated SAML provider, Entra **automatically creates a local user object** to store their profile data.
* **Scenario Example:** A retail company uses an external tenant for customer checkout (CIAM). They allow users to sign up via Google, Facebook, or local "Email with password". A partner vendor also accesses a separate supplier portal; the admin configures a SAML IdP for the vendor's domain so the vendor employees can use their existing corporate credentials to log in.

#### 2. Architecture: App Registrations vs. Enterprise Applications

* **Standard "App Registrations" (Optimized for OIDC)**
  * Fundamentally designed and natively optimized for OpenID Connect (OIDC) applications.
  * Automatically handles setup, trust relationship, and provides code values (Client ID, subdomain).
* **"Enterprise Applications" (Required for SAML)**
  * Standard app registration cannot natively handle SAML.
  * Administrators must bypass the "App registrations" menu entirely to register a custom SAML application.

**Comparison Table: Application Registration Menus**

| Feature / Requirement | App Registrations Menu | Enterprise Applications Menu |
| :--- | :--- | :--- |
| Primary Protocol Optimization | OpenID Connect (OIDC) | SAML / WS-Fed |
| App Creation Type | Standard Registration | "Non-gallery" app (Create your own) |
| SAML Single Sign-On Config | Not supported natively | Dedicated SAML SSO menu |

* **Configuration Details (Registering a SAML App):**
    1. Navigate to **Enterprise applications** > **New application** > **Create your own application** (Non-gallery).
    2. Once created, open the **Single sign-on** menu and explicitly select **SAML**.
    3. Upload the Federation Metadata XML file and manage token signing certificates.
* **Configuration Details (Completing Application Trust):**
  * To complete the unidirectional trust relationship, you must insert registration values into your application's source code/configuration files.
  * Required values: Application (client) ID, directory (tenant) subdomain, and a client secret or certificate.
* **Exam Trap:** A question may state that to complete the trust relationship, the source code must be digitally "signed" with a Graph API certificate. This is **false**. You only *update* the source code with the generated connection values.

#### 3. SAML/WS-Fed Federation Setup & Domain Logic

* **"New SAML/WS-Fed IdP" Wizard**
  * **Protocol Selection:** You must explicitly select either **SAML** or **WS-Fed** from the "Identity provider protocol" dropdown menu.
  * **Metadata Parsing:** The best practice is to select **"Parse metadata file"** and upload the XML document provided by the federating IdP. This automatically extracts token signing certificates and bypasses complex manual entry.
* **Domain Matching & Persistence**
  * When a user types an email on the Microsoft discovery page, the system inspects the domain. If it matches a predefined federated domain, they are redirected to that IdP.
  * **Post-Federation:** Once federated, a user's sign-in email address *does not need to strictly match* the predefined domains.
* **Exam Trap:** Updating the federation setup by adding, changing, or removing domains does **not** affect existing users. The identity provider is **not** automatically disabled, and domains do **not** need re-verification for existing users to continue logging in.

#### 4. Domain Acceleration, Routing, and Custom Endpoints

* **Domain Acceleration (`domain_hint`)**
  * Bypasses the standard Microsoft discovery page (where users type their email) and routes the user straight to the external IdP.
* **Exam Trap:** Do not confuse `domain_hint` with `login_hint`. `domain_hint` identifies the *organizational identity provider* for routing; `login_hint` passes the *user's personal email/identifier* to pre-fill their sign-in.

**Comparison Table: `domain_hint` Syntax by Provider Type**

| Identity Provider Type | Derivation of `domain_hint` Value | Syntax Example |
| :--- | :--- | :--- |
| Custom SAML / WS-Fed | Exact string from the "Domain name of federating IdP" field | `domain_hint=fabrikam.com` |
| Social Identity Providers | Fixed, predefined keywords | `domain_hint=facebook` |
| Custom OIDC Providers | Domain portion of the provider's Issuer URI | `domain_hint=www.linkedin.com` |
| Microsoft Entra ID Tenant | Domain name of the federating tenant | `domain_hint=contoso.onmicrosoft.com` |

* **Custom Domain Endpoints:**
  * Format: `https://<custom-url-domain>/<tenant-name>/oauth2/v2.0/authorize`.
  * To completely hide Microsoft infrastructure, replace `<tenant-name>` with `<tenant-ID-GUID>`.
* **Exam Trap:** `domain_hint` is a query parameter appended to the URL (e.g., `?domain_hint=...`), not a core endpoint path like `.ciam.auth/v2/domain_hint`.

#### 5. Troubleshooting Authentication Flows

* **Redirect URI Mismatches**
  * **Issue:** A social sign-in popup (e.g., Google) opens successfully, but the authentication fails to complete, and no token is returned.
  * **Root Cause:** Microsoft Entra strictly verifies the destination. The `redirectUri` in the application source code (e.g., React `PopupRequest`) does not perfectly match the Entra app registration.
  * **Resolution:** Ensure the exact URL string in the developer code perfectly matches the allowed destination in the App Registration portal.
* **Account Creation Prompt Loop**
  * **Issue:** A federated user authenticates successfully but is repeatedly prompted for details.
  * **Root Cause:** The external tenant does not yet have a local user object created for this user, and mandatory profile attributes defined in the user flow are missing from the SAML claims.

#### 6. Programmatic Management & RBAC Roles

* **Microsoft Graph API Endpoints**
  * `GET /availableProviderTypes`: Lists what is *possible* (supported/available to configure).
  * `GET /identityProviders`: Lists what is *currently active* (already configured and enabled).
  * `POST /identityProviders`: Used to create and enable a new provider.
  * **Exam Trap:** If asked how to verify "currently active" providers, you must select `GET /identityProviders`, not `availableProviderTypes`.
* **Role-Based Access Control (RBAC)**
  * **Authentication Policy Administrator:** Configures sign-in identifier policies, manages sign-up user flows, and enables alternate sign-in identifiers (custom usernames, customer IDs).
  * **Security Administrator:** Enforces Conditional Access, MFA, and OTP methods.
  * **Application / Cloud Application Administrator:** Required to register new applications and configure SAML/WS-Fed external identity providers in Enterprise Applications.
  * **Authentication Extensibility Administrator:** Integrates third-party custom authentication extensions (e.g., fraud protection).
  * **Prerequisite/Licensing Note:** Following the principle of least privilege, an administrator managing external sign-in flows cannot natively setup the SAML SSO enterprise app unless they are specifically granted the App Admin role as well.
