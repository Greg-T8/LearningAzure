### **SC-300 Comprehensive Study Sheet: Application-Enforced Restrictions**

#### **1. Core Architectural Concepts & Prerequisites**

* **The "Messenger" Mechanism:**
  * Microsoft Entra ID acts strictly as a messenger. When a Conditional Access policy is set to **Use app enforced restrictions**, Entra ID embeds the user's device management state (e.g., "unmanaged device") into the authentication token as a specific claim.
  * **Delegation of Authority:** Entra ID *does not* actively enforce the restriction or block the connection. It hands the token to the application and steps out of the way.
* **Device Trust Evaluation:**
  * **Managed/Compliant Device:** If the device is enrolled in Intune (marked compliant) or Microsoft Entra hybrid joined, the app natively grants **full, unrestricted access** (e.g., downloading, printing, desktop syncing).
  * **Unmanaged/Personal Device:** The app natively reads the unmanaged signal and drops the user into a **limited access** (read-only, web-only) state.
* **Supported Workloads (Prerequisites):**
  * *Note: Licensing specifics (like Entra ID P1/P2) are outside the provided sources, but required for Conditional Access.*
  * Native app-enforced restrictions require apps programmed to understand Microsoft's internal device claims. This is strictly limited to **Exchange Online (OWA)** and **SharePoint Online / OneDrive**.

#### **2. Entra ID Conditional Access Configuration Details**

* **Target Resources:**
  * **Best Practice:** Target the **"Office 365" cloud app bundle**.
  * **Why:** Policies created for a "host app" (e.g., Teams) do not automatically connect to "resource apps" (e.g., SharePoint). The bundle blankets the interdependent ecosystem to prevent security gaps and authentication loops.
* **Conditions:**
  * **Client Apps:** Must be set exclusively to **Browser**. Native thick clients (desktop/mobile apps) inherently cache data locally and cannot render a restricted read-only web state without breaking.
* **Grant Controls:**
  * **Required Configuration:** Pair the session restriction with **Require multifactor authentication (MFA)**. This rigorously verifies the user's identity before the app limits their session on an untrusted device.
* **Session Controls:**
  * Select **Use app enforced restrictions** to hand off control natively.

#### **3. Workload-Specific Backend Configurations**

* **SharePoint Online & OneDrive:**
  * **Tenant-Level Setting:** Run `Set-SPOTenant -ConditionalAccessPolicy AllowLimitedAccess` to globally enforce web-only access for unmanaged devices across all sites.
  * **Site-Level Setting:** Use the SharePoint Admin Center or run `Set-SPOSite` with the `-ConditionalAccessPolicy AllowLimitedAccess` parameter for granular enforcement on specific sensitive sites.
* **Exchange Online (Outlook on the Web):**
  * **Backend Policy:** Governed by OWA Mailbox Policies via the `Set-OwaMailboxPolicy` cmdlet.
  * **Parameters:** Set `-DirectFileAccessOnPrivateComputersEnabled` and `-DirectFileAccessOnPublicComputersEnabled` to `$false`.
  * **Outcome:** Allows secure in-browser attachment previews but blocks saving attachments to the local hard drive natively.

#### **4. Exam Traps & Common Pitfalls**

* **🚨 Trap: Targeting "All Resources"**
  * *The Trap:* An administrator applies "Use app enforced restrictions" to "All cloud apps."
  * *The Result:* Third-party apps (Salesforce, ServiceNow) cannot read the internal Entra claim. They ignore it and **fail open**, granting the unmanaged device full, unrestricted access (massive data leak risk).
* **🚨 Trap: Device Compliance as a Grant Control**
  * *The Trap:* Selecting "Require device to be marked as compliant" under Grant Controls to manage personal laptops.
  * *The Result:* Acts as a hard stop. The user is entirely blocked at the front door. The session control is never reached, preventing the desired limited-access web session.
* **🚨 Trap: Overlapping "Block" Policies**
  * *The Trap:* Applying a "Block Access" Grant control in the same policy (or an overlapping one) as a Session control.
  * *The Result:* The "Block" takes absolute precedence. The session is terminated before app-enforced restrictions or proxy monitoring can apply.
* **🚨 Trap: The Backend Application Loophole**
  * *The Trap:* Creating a broad "Block" policy for All Cloud Apps without exclusions.
  * *The Result:* Unintentionally blocks the internal **"Microsoft Defender for Cloud Apps - Session Controls"** enterprise application, completely breaking session restrictions across the tenant.

#### **5. Scenario Examples**

* **Scenario A: OneDrive Sync Client on a Personal Laptop**
  * *Action:* User installs the OneDrive desktop app on a home PC and attempts to log in.
  * *Result:* The native block triggers. Because thick clients must download data to function, the sync client is outright denied access. The system prompts the user to access OneDrive via the web browser instead, where the "Download" and "Sync" buttons are disabled.
* **Scenario B: Simultaneous Monitoring and Native Restrictions**
  * *Action:* Administrator selects both "Use app enforced restrictions" and "Monitor" in Entra ID to track user activity while relying on SharePoint's native block.
  * *Result:* Invalid configuration. Native restrictions bypass the Defender proxy entirely. To get real-time monitoring, the admin *must* switch to "Use Conditional Access App Control" (CAAC) -> "Use custom policy".
* **Scenario C: Public Kiosk Screen Abandonment**
  * *Action:* User opens a sensitive HR document in OWA on a hotel lobby PC, cannot download it due to restrictions, but leaves the browser open and walks away.
  * *Result:* Data is exposed to the next user.
  * *Fix:* Must pair session restrictions with the **Idle Session Timeout** feature (configured in M365 Admin Center) to forcefully expire inactive web sessions.

#### **6. Troubleshooting Details**

* **Issue:** App-enforced restrictions are completely failing on one specific highly sensitive SharePoint site, but working everywhere else.
  * *Resolution:* Check the backend configuration. The site's specific **`ConditionalAccessPolicy`** property is likely missing or misconfigured. Use `Set-SPOSite` to ensure it is set to **`AllowLimitedAccess`** or **`BlockAccess`**.
* **Issue:** Users complain they receive a "Download blocked" error just trying to *preview* a PDF in OWA when routed through CAAC.
  * *Resolution:* The CAAC proxy is killing the background download OWA uses to render the preview. Fix this by bypassing the proxy for OWA and utilizing the native `Set-OwaMailboxPolicy` instead, which safely separates previews from direct downloads.

#### **7. Comparison Table: Native Restrictions vs. CAAC (Proxy)**

| Feature / Attribute | Application-Enforced Restrictions (Native) | Conditional Access App Control (CAAC Proxy) |
| :--- | :--- | :--- |
| **Enforcement Mechanism** | App's native backend code. | Defender for Cloud Apps reverse proxy (or Edge in-browser protection). |
| **Supported Applications** | Only Exchange Online & SharePoint Online. | Any SAML 2.0 or OpenID Connect app (Salesforce, Box, Custom Line of Business). |
| **Network Latency** | Zero added latency (seamless direct connection). | Slight latency added due to proxy routing (though mitigated by Azure datacenters). |
| **URL User Experience** | Normal URL (e.g., `sharepoint.com`). | Visibly rewritten URL adding an **`.mcas.ms`** suffix (e.g., `sharepoint.com.mcas.ms`) on standard browsers. |
| **Level of Granularity** | Blunt instrument. Blocks *all* downloads universally. | High. Data-level inspection. Can block based on specific sensitive content, scan for malware, or encrypt on download. |
| **Monitoring Capabilities** | None. Bypasses the proxy. | Full real-time session logging and activity monitoring. |
| **Entra ID Selection** | *Session > Use app enforced restrictions*. | *Session > Use Conditional Access App Control > Use custom policy*. |

#### **8. Defense-in-Depth Checklist**

To achieve comprehensive security on unmanaged devices without loopholes, ensure these three layered policies are in place:

1. **The Web Restriction:** Entra CA Policy targeting "Browser" clients applying "Use app enforced restrictions".
2. **The Native App Block:** Entra CA Companion Policy targeting "Mobile apps and desktop clients" on unmanaged devices with the Grant Control set to **Block Access** (prevents bypass via thick clients).
3. **The Time Barrier:** Enable **Idle Session Timeout** to prevent screen abandonment exposure.
