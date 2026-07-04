### **SC-300 Study Review: Migrate from AD FS to Cloud Authentication (Expanded)**

#### **1. Comparison Tables**

**Table 1.1: Authentication Methods and Migration Impact Comparison**

| Feature/Requirement | Active Directory Federation Services (AD FS) | Password Hash Synchronization (PHS) | Pass-through Authentication (PTA) |
| :--- | :--- | :--- | :--- |
| **Authentication Authority** | On-premises AD FS Farm | Microsoft Entra ID (Cloud) | On-premises AD via lightweight agents |
| **Failover/Disaster Recovery** | Highly vulnerable to on-prem hardware/network outages | Highly resilient; acts as the primary disaster recovery fallback | Vulnerable to on-prem agent/network outages |
| **Supported Primary Credential** | `UPN` and `sAMAccountName` (`DOMAIN\username`) | `UPN` strictly required | `UPN` strictly required |
| **Leaked Credentials Report** | Not supported natively | Natively supported and strictly required | Requires PHS to be enabled in the background |
| **Multi-Forest Routing** | Managed via complex AD FS claim rules | Handled natively in the cloud via synchronized hashes | Strictly requires Forest Trusts and name suffix routing |
| **Migration Decommission Buffer** | N/A | Wait **3 hours** before decommissioning AD FS | Wait **12 hours** before decommissioning AD FS |
| **3rd Party MFA Integration** | Natively supported on-premises | Requires Conditional Access Custom Controls | Requires Conditional Access Custom Controls |

**Table 1.2: Seamless Sign-On vs. Primary Refresh Token (PRT)**

| Feature | Microsoft Entra Seamless SSO | Primary Refresh Token (PRT) |
| :--- | :--- | :--- |
| **Target OS** | Domain-joined Windows 7 and Windows 8.1 | Windows 10, Windows Server 2016, and later |
| **Underlying Mechanism** | Kerberos tickets sent to `AZUREADSSOACC` | Entra ID device registration / Hybrid Join |
| **Fallback Behavior** | Prompts user to manually type password | N/A (Integrated deeply into Windows 10/11) |

**Table 1.3: Microsoft Entra Connect Sync vs. Microsoft Entra Cloud Sync**

| Feature | Entra Connect Sync | Entra Cloud Sync |
| :--- | :--- | :--- |
| **Architecture** | Heavy on-premises server footprint | Lightweight cloud-managed provisioning agents |
| **High Availability** | Active/Passive standby mode | Active/Active automatic failover via Service Bus |
| **Connection Type** | Complex inbound/outbound | Outbound-only via SCIM 2.0 requests |
| **Mandatory Upgrade** | Version 2.5.79.0 required by Sept 30, 2026 | Automatically patched and updated from the cloud |

#### **2. Prerequisite and Licensing Notes**

* **Mandatory Backup Constraints**
  * Create a full backup of the AD FS environment using the **AD FS Rapid Restore Tool** before any migration.
* **Administrative Role Requirements**
  * **Cloud Credential:** The **Hybrid Identity Administrator** role is explicitly required to manage synchronization tools, execute the "Change user sign-in" task, and reset AD FS federation trusts.
  * **On-Premises Credential:** An **Enterprise Administrator** or **Domain Administrator** (e.g., `contoso\Administrator`) must be provided to connect to the local AD FS farm during trust resets.
* **Licensing Constraints**
  * **Microsoft Entra ID Protection:** To access the **Leaked Credentials Report**, the tenant must possess a **Microsoft Entra ID P2 license**.
* **Source of Authority (SOA) & Exchange Migration Prerequisites**
  * All on-premises Exchange mailboxes *must* be migrated to Exchange Online before transferring user SOA to the cloud.
  * Users must be managed directly in Microsoft 365 before changing their SOA.
  * The SOA for Distribution Lists (DLs) and Mail-Enabled Security Groups (MESGs) must **only** be shifted *after* all Exchange workloads are in the cloud and the on-prem Exchange server is retired.
* **Software Lifecycle Prerequisites**
  * Microsoft Entra Connect Sync installations must be updated to at least **version 2.5.79.0** by **September 30, 2026**. Failing to do so results in total sync failure and health alert disruptions.

#### **3. Configuration Details**

* **Executing the "Change User Sign-in" Task**
  * **Purpose:** Formally converts domains from "Federated" to "Managed" at the tenant level.
  * **Steps:** Open Entra Connect -> **Configure** -> **Change user sign-in** -> Authenticate as Hybrid Identity Admin -> Select primary method (e.g., PHS) -> Complete wizard.
  * **Staged Rollout:** Administrators can test cloud authentication gradually for a pilot group before running the tenant-wide "Change user sign-in" task.
* **Configuring Seamless SSO (`AZUREADSSOACC`)**
  * Creates an on-premises computer account (`AZUREADSSOACC`) whose Kerberos decryption key is securely shared with Entra ID.
  * **Key Rotation:** Must be manually rolled over **at least every 30 days** using the `Update-AzureADSSOForest` PowerShell cmdlet.
  * **Encryption Standard:** Set the computer account's encryption type to `AES256_HMAC_SHA1` (replaces legacy `RC4_HMAC_MD5`).
* **Configuring DNS for Federation Verification**
  * **Extranet Connectivity:** Verifies public DNS via domain registrar.
  * **Intranet Connectivity:** Verifies internal DNS. Must point to the AD FS load balancer IP, not a single server.
  * **Browser Configuration:** The AD FS FQDN (e.g., `sts.contoso.com`) must be pushed to the browser's **Intranet zone** via Group Policy to enable silent pass-through of credentials.

#### **4. Troubleshooting Details**

* **Troubleshooting Password Hash Synchronization (Subset of Users)**
  * **Indicator:** A failure for a subset of users usually points to object-level configuration/filtering, not a global tenant issue.
  * **Wizard Tool:** Run PowerShell as Admin (`RemoteSigned` or `Unrestricted`) -> Open Entra Connect wizard -> **Additional Tasks** -> **Troubleshoot** -> **Troubleshoot password hash synchronization** -> **Password isn't synchronized for a specific user account**.
  * **Diagnostic Checks Performed:** Object State (AD vs Metaverse vs Entra), Rule Application, and Recent Synchronization Attempts.
  * **PowerShell Alternative:** Run the `Invoke-ADSyncDiagnostics -PasswordSync` cmdlet with the user's Distinguished Name.
* **Common PHS Root Causes**
  * **Not Exported:** No corresponding user object successfully provisioned in the Entra tenant yet.
  * **Temporary Passwords:** Users with "User must change password at next logon" will not have their passwords synced unless the administrator explicitly enables the `ForcePasswordChangeOnLogon` feature.
* **Recovering AD FS Trusts**
  * If failing back from PHS to AD FS after an outage, administrators must use Entra Connect -> **Manage federation** -> **Reset Microsoft Entra ID trust**.

#### **5. Exam Traps**

* **🚨 Trap: DNS Record Types.** Microsoft Entra Connect will fail federation connectivity verification if the intranet DNS record is a CNAME. **Windows Integrated Authentication strictly requires an A record (or AAAA)**.
* **🚨 Trap: Multiple Key Rollovers.** Running the `Update-AzureADSSOForest` command more than once per forest during a rollover event completely breaks Seamless SSO until existing Kerberos tickets expire and are reissued.
* **🚨 Trap: Encryption Update Outages.** If an admin changes the Active Directory encryption type to AES256, they **must** roll over the Kerberos key immediately, or Seamless SSO will fail.
* **🚨 Trap: The Decommissioning Wait Times.**
  * Migrating to PHS? You must wait **3 hours** to ensure all background hashes upload (runs every 2 minutes).
  * Migrating to PTA? You must wait **12 hours** to ensure legacy connections like **Exchange ActiveSync** do not experience an abrupt outage.
* **🚨 Trap: The Temporary Toggle.** PHS is a disaster recovery fallback, but you **should not** switch from AD FS to PHS for a temporary/minor network outage due to the 3-hour hash sync window.
* **🚨 Trap: MFA Device Registration.** If using Conditional Access Custom Controls to retain third-party MFA after dropping AD FS, remember that **Custom Controls do not support device registration**.
* **🚨 Trap: Failover is Manual.** Entra ID does not automatically failover to PHS if AD FS goes offline; an administrator must manually switch the sign-in method.

#### **6. Scenario Examples**

* **Scenario (Legacy Credential Formats):** An organization wants to retire AD FS but has an application that strictly requires the `DOMAIN\username` (`sAMAccountName`) format for login.
  * **Solution:** They **must remain on AD FS federation**. Microsoft Entra ID natively requires the `UPN` format (email address) and cannot process `sAMAccountName` natively.
* **Scenario (Multi-Forest Routing):** An enterprise spans three completely isolated Active Directory forests and wants to configure Pass-through Authentication (PTA) instead of syncing password hashes.
  * **Solution:** The administrator must configure **Forest trusts between the AD forests** and correctly set up **name suffix routing**. Without this, the PTA agent cannot route credentials across boundaries to validate against the correct domain controller.
* **Scenario (Minimizing AD with Legacy Apps):** A company wants to migrate entirely to the cloud but has an old network appliance that strictly performs LDAP simple binds to query Active Directory. Rewriting the app is not an option.
  * **Solution:** Deploy **Microsoft Entra Domain Services**. This creates a cloud-managed Active Directory instance that natively provides legacy LDAP endpoints, allowing the app to migrate without code rewrites.
