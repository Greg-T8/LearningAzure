**SC-300 Study Review Sheet: Configure Authentication Context**

**1. Core Architecture & Zero Trust Principles**

* **The Concept:** Conditional Access authentication context is a Zero Trust feature designed to apply granular security policies directly to **sensitive data and actions within an application**, rather than broadly securing the entire application at the front door.
* **Least Privilege:** By keeping routine access frictionless and only demanding step-up authentication (like multifactor authentication or compliant devices) during critical operations, the feature tightly aligns with the Zero Trust principle of least privilege.
* **Underlying Protocols:** The authentication context feature is fundamentally an authentication action built on protocol extensions provided by the **OpenID Connect (OIDC)** standard, not OAuth 2.0.

**2. Licensing & App Prerequisites**

* **Minimum Licensing:** Utilizing the Conditional Access authentication context feature requires a **Microsoft Entra ID P1** license. It is entirely unavailable in the Microsoft Entra ID Free edition, which must rely on Security Defaults instead.
* **Application Constraints:** The application consuming the authentication context must be integrated with the Microsoft identity platform using OpenID Connect or OAuth 2.0. Currently, the feature only supports applications that sign-in users (delegated access); apps authenticating as themselves using workload identities are not supported.

**3. Configuration in the Microsoft Entra Admin Center**

* **UI Location:** Administrators navigate to **Protection > Conditional Access > Authentication context** to create and manage these definitions.
* **Identifier Limits:** An organization can create a maximum of **99 custom authentication context definitions** per tenant. The system automatically assigns a read-only identifier ranging from **`c1` through `c99`**.
* **Mandatory Attributes:**
  * **ID (`c1-c99`):** The exact machine-readable, read-only value embedded in tokens and Web API claims challenges to enforce request-specific policies.
  * **Display name:** The friendly name used to identify the context across the tenant and within consuming apps. **Best Practice:** Use generic, reusable names (e.g., "Require trusted devices") to create a **reduced set** of contexts, which limits browser redirects and improves the end-user experience.
  * **Description:** A text field used strictly by IT admins to understand the scope of the underlying policy.
  * **Publish to apps:** A critical Boolean checkbox that officially advertises the context to downstream applications, making it visible for developers to query and assign. If left unchecked, the context remains a hidden draft.

**4. Building the Conditional Access Policy**

* **Policy Logic:** An authentication context is essentially just a tag and relies entirely on an active Conditional Access policy to enforce security rules.
* **Targeting:** In the Conditional Access policy builder, you must configure the policy by navigating to **Target resources** (formerly "Cloud apps or actions"), changing the dropdown to **Authentication context**, and selecting the published definition.

**5. Developer Integration & Token Mechanics**

* **The Trigger Mechanism:** Developers give apps a way to trigger and satisfy the policy by using the authentication context reference value alongside the OpenID Connect **Claims Request parameter**. To handle this complexity, developers should utilize the **Microsoft Authentication Library (MSAL)**.
* **The Web API Gatekeeper:** When a user attempts a sensitive action, the Web API inspects the access token for the **`acrs` (Authentication Context Class Reference)** claim.
* **The Claims Challenge:** If the required `c1` tag is missing, the API throws an **HTTP 401 Unauthorized** response containing a **`WWW-Authenticate`** header. This header delivers a base64-encoded claims challenge specifying an **`insufficient_claims`** error and the exact context ID required. The client intercepts this challenge, redirects to Entra ID, forces the user to complete the step-up prompt, and receives a new token with the `acrs` claim.
* **Opportunistic Evaluation:** To avoid unnecessary round trips to Entra ID, apps can opt into the **optional `acrs` claim**. If the user's current session already satisfies the policy protecting the ID, Entra ID proactively and implicitly adds the `acrs` claim to the token without explicit prompting.
* **Dynamic Mapping via Graph API:** Developers must **never hard-code** `c1-c99` IDs into multi-tenant application source code because these values differ across tenants. Instead, apps must dynamically query the Microsoft Graph API endpoint **`/identity/conditionalAccess/authenticationContextClassReferences`**. This query requires the **`Policy.Read.ConditionalAccess`** minimum API permission.

**6. Advanced Use Cases & Scenarios**

* **SharePoint Online Site Security:** You cannot natively select a SharePoint Site Collection ID in a Conditional Access policy. To apply an authentication context to a specific site, you must use **Sensitivity labels** (created in Microsoft Purview) as the connective bridge. The Sensitivity label is assigned the auth context, and the label is then applied to the SharePoint site container.
* **Protected Actions in Entra ID:** Highly privileged administrative tasks (like updating CA policies) can be protected by an authentication context. Microsoft Graph determines if an action supports this via the Boolean **`isAuthenticationContextSettable`** property, and stores the assigned context in the **`authenticationContextId`** property.
* **External ID / Native Authentication:** When building native apps for external customers using a WAF for account takeover (ATO) protection, the WAF coordinates risk evaluations with third-party providers and injects the authentication context. Crucially, risk-based MFA via authentication context for Native Authentication is strictly limited to the **"Email with Password"** sign-in flow. Hardware FIDO2 keys are completely unsupported in this tenant type.
* **Privileged Identity Management (PIM):** Authentication contexts can be utilized by PIM to enforce step-up authentication prior to a highly privileged role becoming active.

**7. Management, Troubleshooting, & Roles**

* **RBAC Requirements:** The Zero Trust principle of least privilege dictates that the **Conditional Access Administrator** is the minimum built-in role required to manage, create, or update authentication contexts. If that role is unavailable, **Security Administrator** is the next least-privileged alternative.
* **Deletion Safety Mechanisms:** To prevent accidental security gaps, you **cannot delete** an authentication context if it is actively tied to a Conditional Access policy or if the **Publish to apps** checkbox is currently selected. You must verify in the sign-in logs that it is no longer in use before cleanly severing these connections.
* **Report-Only Mode Evaluation:** When deploying a new context policy, it should initially be placed in **Report-only** mode. Because the interactive MFA prompt is suppressed during testing, the sign-in logs will report the evaluation status as **"User action required"**. This telemetry can be viewed per-user in the Sign-in logs or aggregated tenant-wide using the **Conditional Access insights and reporting workbook**.
* **Implicit Satisfaction Risk:** If an app requests an `acrs` claim, but the administrator failed to assign any Conditional Access policies to that specific context definition, the system automatically considers the request satisfied and issues the token freely, bypassing all security intent.

**8. 🚨 SC-300 Exam Traps to Remember**

* **The "P2" Distractor:** Do not select Microsoft Entra ID P2 as the requirement for authentication contexts; the feature only requires a baseline **P1** license.
* **The Hard-Coding Trap:** Multi-tenant apps must dynamically read contexts via Graph API; any exam option suggesting hard-coding a `c1` or `c2` value is incorrect.
* **The Broad Application Trap:** Do not use an authentication context if the broad target of the Conditional Access policy is the entire application itself. Contexts are meant for granular, targeted parts of an application.
* **The Protected Actions Sequence:** To prevent unexpected lockouts, you must configure and toggle the Conditional Access policy to **"On"** *before* you map the context to a highly privileged Entra ID permission.
