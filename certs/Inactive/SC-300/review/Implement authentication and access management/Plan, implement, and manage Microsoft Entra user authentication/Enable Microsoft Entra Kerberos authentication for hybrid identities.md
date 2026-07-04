### **1. Architecture, Prerequisites, and Synchronization Requirements**

* **Identity and Operating System Prerequisites**
  * **OS Minimum Baseline:** Devices must run **Windows 10 version 2004 or later** (includes Windows 11) to recognize Microsoft Entra ID as a Key Distribution Center (KDC) and cache the Cloud Ticket Granting Ticket (TGT).
  * **Baseline AD Group Requirement:** Hybrid users are strictly required to be members of the standard **Domain Users** group.
  * **Trust Model Priority:** Cloud Kerberos Trust and Windows Hello for Business (WHfB) certificate trust cannot coexist. Certificate trust policies take absolute precedence; if present, cloud trust will not function.
* **Essential Entra Connect Synchronization Attributes**
  * **`onPremisesSamAccountName`**: Critical identity link formatting the Kerberos ticket for the local account (maps to `accountName`).
  * **`onPremisesDomainName`**: Maps to `domainFQDN`.
  * **`onPremisesUserPrincipalName`**: Required for hybrid authentication.
  * **`onPremisesSecurityIdentifier`**: Maps to `objectSID`.

### **2. Ticket Types and Authentication Flows**

**Table 2.1: Kerberos Ticket Types Comparison**

| Feature | Cloud TGT | OnPremTgt (Partial TGT) |
| :--- | :--- | :--- |
| **Issuer** | Microsoft Entra ID | Microsoft Entra ID |
| **Realm** | `KERBEROS.MICROSOFTONLINE.COM` | Local On-Premises AD Domain |
| **Contents** | Fully formed for cloud (RBAC authorization data) | Contains user SID only (no PAC / group claims) |
| **Dependency** | No on-premises DC dependency | Must be presented to local DC for ticket exchange |
| **Resource Access** | Cloud resources (e.g., Azure Files) | Legacy on-premises resources (SMB shares, SQL) |
| **Citation** | | |

* **Scenario Example (Hybrid Access Flow):**
    1. User logs in via WHfB passwordless credential.
    2. Entra ID issues an `OnPremTgt` holding only the user's SID.
    3. Client contacts on-premises DC; DC evaluates the `AzureADKerberos` Read-Only Domain Controller (RODC) Password Replication Policy (PRP).
    4. If authorized via PRP Allowlist, DC injects the full Privilege Attribute Certificate (PAC) with group claims, converting it to a full Active Directory TGT for local access.
* **Scenario Example (Cloud-Only Access Flow):**
    1. User (existing only in Entra ID) signs in.
    2. Entra ID issues a `Cloud TGT`.
    3. Client requests Azure Files service ticket directly from Entra ID via KDC Proxy.
    4. Authorization relies entirely on Azure RBAC; no on-premises RODC object or ticket exchange is needed.

### **3. On-Premises Server Objects and Security Boundaries**

* **Setup Cmdlet Configuration Details**
  * **Cmdlet:** `Set-AzureADKerberosServer` automates logical Kerberos server object creation.
  * **Module:** Requires the `AzureADHybridAuthenticationManagement` PowerShell module.
  * **Credentials Needed:** Requires simultaneous use of an on-premises **Domain Administrator** and a cloud-based **Hybrid Identity Administrator**.
  * **Object 1 (`CN=AzureADKerberos`):** Computer object acting as a logical RODC.
  * **Object 2 (`CN=krbtgt_AzureAD`):** Disabled user object holding the TGT encryption key.
  * **Object 3 (SCP):** ServiceConnectionPoint at `CN=900274c4-b7d2-43c8-90ee-00a9f650e335,CN=AzureAD,CN=System...` used by administrative tools to locate the server objects.
* **Password Replication Policy (PRP) Security**
  * **Configuration Detail:** The RODC object's PRP default should be set to **Deny**, with explicit **Allow** permissions only granted to authorized groups.
  * **🚨 Exam Trap (High Privilege):** Microsoft explicitly recommends against relaxing the PRP to allow high-privilege accounts (like Domain Admins) to sign in to on-premises resources via Entra Kerberos due to attack vector risks.

### **4. Client Configurations and Network Routing**

* **Client Policy Configuration Details**
  * **Setting:** Clients must be configured with `CloudKerberosTicketRetrievalEnabled = 1` via Intune CSP or Group Policy.
  * **Application:** Requires a policy refresh or a full device reboot to take effect; without it, the Cloud TGT is not fetched.
  * **Under the Hood HTTP Claim:** When requesting a Primary Refresh Token (PRT), the client explicitly signals the need for a Kerberos ticket by injecting the exact HTTP claim **`tgt = true`**.
  * **Return Payload:** Entra ID returns an encrypted payload containing `tgt_client_key`, `tgt_key_type`, and `tgt_message_buffer`.
* **Realm Mapping and KDC Proxy Details**
  * **Realm Mapping:** Tells Windows to route specific namespaces (e.g., `*.file.core.windows.net`) to the cloud realm (`KERBEROS.MICROSOFTONLINE.COM`) instead of local AD. Deployed via GPO or Intune `Kerberos/HostToRealm` CSP.
  * **KDC Proxy:** Encapsulates Kerberos TGS-REQ inside HTTPS for users on the internet. Requires the Windows **`WinHttpAutoProxySvc`** service to be running. Configured via the `"Specify KDC proxy servers for Kerberos clients"` GPO over port 443.

### **5. Azure Files Storage and Access Scenarios**

* **Scenario Example (SMB Conditional Access Conflict):**
  * An admin enforces an "All cloud apps" Conditional Access MFA policy.
  * A user maps an Azure file share. Because SMB cannot process interactive MFA prompts, the user receives **"System error 1327: Account restrictions are preventing this user from signing in"**.
  * **Resolution:** Admin must exclude the auto-generated enterprise app format **`[Storage Account] <name>.file.core.windows.net`** from CA MFA policies.
  * **Note:** WHfB resolves this securely by generating a PRT stamped with an "MFA claim" at device lock screen sign-in, allowing silent background ticket issuance.
* **🚨 Exam Trap (Line-of-Sight Constraint):** End-users can securely *access* Azure file shares over the internet without line-of-sight to a DC. However, administrators attempting to *configure or edit* Windows NTFS ACLs using File Explorer **strictly require** unimpeded network connectivity to the on-premises domain controllers.
* **🚨 Exam Trap (Service Principal Expiration):** The auto-generated Microsoft Entra service principal password representing an Azure storage account automatically expires every **six months**. It must be manually rotated twice a year to prevent widespread Kerberos access failures.

### **6. Scaling Constraints, Load Distribution, and Maintenance**

* **The 1,010 SID Limitation**
  * **Constraint:** Windows Kerberos caps ticket sizes at 1,010 Security Identifiers (SIDs).
  * **Impact:** If combined hybrid group memberships exceed this, SIDs are truncated, the ticket fails to issue, and SMB access fails.
  * **Troubleshooting Detail:** Triggers error **`140011 – KerberosUsersGroupNumberExceeded`** in Entra sign-in logs.
  * **Configuration Detail (Workaround):** For cloud-only identities, admins can add the `kdc_enable_cloud_group_sids` tag in the application manifest to allow PRT issuance, though permanent resolution requires group consolidation.
* **Performance Optimization**
  * To handle extreme evaluation load (e.g., Azure Virtual Desktop environments), processing is optimized via **automatic load distribution across all domain controllers within a site**.
* **Key Rotation Maintenance**
  * **🚨 Exam Trap (Tooling):** You must exclusively use `Set-AzureADKerberosServer -RotateServerKey` to rotate keys. Standard AD tools will update the local key but not the cloud key, causing an immediate authentication break.
  * **Verification:** `KeyVersion` (on-premises) must identically match `CloudKeyVersion` (Entra ID) via `Get-AzureADKerberosServer`.

### **7. Troubleshooting Verification and Logs**

**Table 7.1: Troubleshooting Commands and Log Locations**

| Tool / Path | Primary Function / Inspection Target | Notes |
| :--- | :--- | :--- |
| **`dsregcmd /status`** | High-level PRT & SSO state check | Shows `CloudTgt : YES` boolean flag, but does *not* inspect local cache. |
| **`klist cloud_debug`** | Explicit Kerberos cache inspection | Primary tool to verify a Cloud TGT is successfully sitting in the Windows cache. |
| **`tgt_cloud`** | MacOS cache inspection | Equivalent verification tool for MacOS devices using Platform SSO. |
| **`C:\ProgramData\AADConnect\`** | Setup trace logs | Hidden folder. Look for `trace-*.log` to troubleshoot `Set-AzureADKerberosServer` failures. |
| **Kerberos.NET Fiddler** | Deep HTTPS network diagnostics | Decrypts and inspects HTTPS KDC Proxy traffic traveling between the client and Entra ID. |
| **Citation** | | |
