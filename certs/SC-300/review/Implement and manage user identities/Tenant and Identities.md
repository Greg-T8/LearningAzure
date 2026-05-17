**Exhaustive SC-300 Study Review Sheet: Identity, Access, and Environment Management**

### **1. Managing Microsoft Entra Identities, Roles, and Administrative Units**

* **Administrative Units (AUs)**
  * **Purpose:** Restrict role permissions to a specific portion of the organization.
  * **Contents:** AUs can strictly contain only **users, groups, or devices**.
  * 📝 **Prerequisite/Licensing Note:**
    * Administrators assigned a scoped role over an AU require a **Microsoft Entra ID P1** license.
    * Standard AU members only require **Microsoft Entra ID Free**.
    * *Exception:* If dynamic membership rules are used to populate the AU, all members then require a P1 license.
  * 💡 **Scenario Example:** A central IT admin for a university creates a "School of Business" AU, adds business students/devices, and assigns the User Administrator role scoped strictly to that AU for the business school's local IT desk.
* **Bulk Operations (CSV Uploads)**
  * ⚙️ **Configuration Detail (CSV Formatting):**
    * **Row 1 (Version):** Must be preserved exactly as-is.
    * **Row 2 (Headings):** Must be preserved. You **cannot add additional columns**.
    * **Row 3 (Examples):** Must be deleted and replaced with actual entries (using Object ID or UPN).
  * 🔧 **Troubleshooting Detail (Validation Errors):**
    * A "Failed" bulk operation status indicates *partial success* (valid rows were processed successfully, while others failed).
    * If the results CSV lists *"The request was malformed or contains invalid parameters,"* the user was **already assigned** to the AU prior to the operation, or the provided Object ID was invalid.
  * 🔧 **Troubleshooting Detail (Scale Timeouts):** Bulk operations on massive tenants can timeout if they take >1 hour. The traditional portal workaround is to **split the records into smaller batches**.
  * 🚨 **Exam Trap:** If a question states a bulk operation timed out, do not select "split into segments of 10 users." The 10-user limit is a fabricated distractor. For large tenant scaling limits, the official workaround is to bypass the portal and use **PowerShell and Microsoft Graph API**. *(Note: A new preview experience natively removes these portal limits)*
* **Hybrid Identity & Source of Authority (SOA)**
  * **Concept:** For synchronized accounts, the on-premises Windows Server Active Directory is the "master" copy.
  * ⚙️ **Configuration Detail:** Core profile updates (name, title) must happen **on-premises** and sync to the cloud. The cloud portal will actively block edits for synced core attributes.
  * 🚨 **Exam Trap (Cloud Exceptions):** You cannot edit a synced user's core profile in the cloud, but you **must** edit cloud-specific attributes directly in the Microsoft Entra admin center. The primary example is the **Usage Location** attribute, which must be set in the cloud before applying M365 licenses.
  * ⚙️ **Configuration Detail:** A new preview feature called **Source of Authority conversion** allows admins to transfer the SOA of synced users directly to Entra ID, converting them into cloud-editable objects.
* **Self-Service Password Reset (SSPR)**
  * **Comparison: User vs. Administrator SSPR Policies**

| Feature | Standard Users | Privileged Administrator Accounts |
| :--- | :--- | :--- |
| **Enablement Status** | Must be explicitly enabled by admin (None, Selected, All). | **Always enabled** by default. |
| **Authentication Methods Required** | 1 or 2 (Configured by admin). | **Strictly 2** (Hardcoded "two-gate" policy). |
| **Registration Prerequisite** | Must pre-register the minimum number of methods. | Must pre-register 2 methods. |

* 📝 **Prerequisite/Licensing Note (Hybrid SSPR):** For users synced from on-premises AD, SSPR requires **Password Writeback** (via Entra Connect/Cloud Sync) and a **Microsoft Entra ID P1 or P2** license. Without writeback, hybrid users are locked out of SSPR.

### **2. Managing Domains, Verification, and Branding**

* **Domain Name Limits**
  * **Comparison: Domain Capacity Limitations**

| Domain Type | Hard Maximum Limit | Microsoft Recommended Limit |
| :--- | :--- | :--- |
| **Managed Domains** (Cloud auth) | 5,000 | N/A |
| **Federated Domains** (AD FS auth) | 2,500 | 300 (For optimal performance) |

* **Domain Verification & DNS**
  * ⚙️ **Configuration Detail:** Verification requires a **TXT or MX record** added at your registrar. Verifying a root domain (contoso.com) automatically verifies subdomains (europe.contoso.com).
  * 🔧 **Troubleshooting Detail (TTL Timeout):** If you enter incorrect or duplicate DNS info at the registrar, you cannot instantly verify the correction. You must wait for the internet's **Time to Live (TTL) to time out (typically 60 minutes)** before retrying verification due to global DNS caching.
* **The Domain Name Administrator Role**
  * **Capabilities:** The **least privileged role** required to read, add, verify, update, and delete custom domains.
  * ⚙️ **Configuration Detail (Directory Read):** Because users, groups, and apps rely on domains for their UPNs/URIs, this role is automatically granted **read access to directory information**.
  * 🚨 **Exam Trap (Federation Setup):** To configure domain federation (e.g., AD FS), the Hybrid Identity Administrator role is *not* enough. You must use an account possessing **both** the Hybrid Identity Administrator role **AND** the Domain Name Administrator role.
* **The ForceDelete Operation**
  * **Purpose:** Asynchronously forces the removal of a custom domain over 24 hours.
  * ⚙️ **Configuration Detail (Fallback):** Automatically renames all dependent UPNs, proxy addresses, group emails, and app URIs to the tenant's **initial default `.onmicrosoft.com` domain**.
  * 🚨 **Exam Trap (Disablement):** ForceDelete modifies user identifiers, so the system automatically **disables the impacted user accounts** to prevent authentication errors.
  * 🚨 **Exam Trap (Limitations):** ForceDelete will fail if:
        1. The domain has **>1,000 references**.
        2. It is a **federated domain** (must be removed via on-prem AD first).
        3. It is set as the **primary domain**.

### **3. External Identities & Multi-Tenant Collaboration**

* **Tenant Architectures**
  * **Comparison: Workforce vs. External Tenants**

| Feature | Workforce Tenant | External Tenant |
| :--- | :--- | :--- |
| **Target Audience** | Internal employees, B2B partners, Line-of-Business apps. | CIAM (Consumers, Retail Customers, Business Customers). |
| **Data Isolation** | Mixed employee/guest directory. | Total isolation from employee directory. |
| **Default Branding** | Standard Microsoft 365 colors/logos. | **Neutral baseline** (no Microsoft branding). |
| **Sign-in Methods** | Corporate credentials, B2B invitations. | Social accounts (Google, Facebook), OTP, custom user flows. |

* ⚙️ **Configuration Detail (Neutral Branding Fallback):** External tenants default to neutral branding. If an admin uploads custom company logos/backgrounds and they fail to load due to latency, the system safely falls back to the neutral template to prevent the customer from seeing confusing Microsoft logos.
* **Cross-Tenant Access Settings (CTAS)**
  * **Purpose:** Allows your resource tenant to explicitly trust security claims from an external B2B user's home tenant, enabling seamless SSO and preventing redundant Conditional Access registrations.
  * ⚙️ **Configuration Detail:** You can configure CTAS to trust exactly three claims:
        1. **Multifactor Authentication (MFA)**.
        2. **Compliant devices**.
        3. **Microsoft Entra hybrid joined devices**.
* **External User Leave Settings**
  * **Purpose:** An `externalIdentitiesPolicy` that allows B2B users to use the **My Account / My Apps** portal to self-service remove themselves from your directory.
  * 🚨 **Exam Trap (The Sync Loop):** If you are managing users via **Cross-tenant synchronization**, you **must set this policy to "No"**. If you leave self-service enabled, synced users who leave will be trapped in an infinite loop where the sync engine instantly reprovisions them.

### **4. Device Management, Groups, and Graph API**

* **Dynamic Device Groups**
  * **Comparison: Device Trust Types**

| Device State | Required `deviceTrustType` Syntax Match |
| :--- | :--- |
| **Microsoft Entra hybrid joined** (On-prem AD synced) | `"ServerAD"` |
| **Microsoft Entra joined** (Cloud-only) | `"AzureAD"` |
| **Microsoft Entra registered** (BYOD) | `"Workplace"` |

* 🚨 **Exam Trap:** "OnPremiseJoined" is a fabricated distractor value. You must use **ServerAD**.
* **Group Expiration and Auto-Renewal**
  * **Purpose:** Automatically deletes inactive **Microsoft 365 groups** (does not apply to security groups).
  * 📝 **Prerequisite/Licensing Note:** Requires a **Microsoft Entra ID P1 or P2** license for all group members.
  * ⚙️ **Configuration Detail (Auto-Renewal Triggers):** Entra automatically renews groups ~35 days before expiration (suppressing warning emails) if user activity is detected natively across: **Teams** (visiting channels), **SharePoint** (viewing/editing files), **Outlook** (reading/writing group messages), or **Viva Engage**.
* **Microsoft Graph API Authorization Policies**
  * **Comparison: Non-Admin Group Creation Permissions**

| Group Type | Required API Object | Required Nested Property |
| :--- | :--- | :--- |
| **Security Groups** | `authorizationPolicy` | `defaultUserRolePermissions` -> `allowedToCreateSecurityGroups` |
| **Microsoft 365 Groups** | `groupSettings` | `EnableGroupCreation` |

* 🚨 **Exam Trap:** `allowedToCreateUnifiedGroups` is a fabricated distractor. M365 groups are managed entirely outside of the `authorizationPolicy` object.
