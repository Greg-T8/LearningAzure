# SC-300 Study Review Sheet: Deploy Global Secure Access clients

**I. Prerequisites, Licensing, & Device Identity States**

* **Windows Hardware & OS Requirements**
  * *Supported Versions:* 64-bit Windows 10 LTSC 2021 or newer, Windows 11 (64-bit), or Windows 11 on Arm64.
  * *Virtualization Trap:* Azure Virtual Desktop (AVD) supports single-session only; multi-session is explicitly unsupported.
  * *Hardware Restriction:* The client cannot be installed on a physical host currently hosting VMs through a Hyper-V external virtual switch.
* **macOS Requirements**
  * *Supported Versions:* macOS 14 (Sonoma) or later.
  * *Hardware:* Intel or Apple Silicon (M1–M4).
  * *Identity Prerequisite:* The device must be registered to an Entra tenant via the Company Portal app before installation.
* **Device Identity States & Traffic Support**
  * *Entra Joined / Hybrid Joined:* Supports all traffic forwarding profiles (Microsoft 365, Internet Access, Private Access). The client strictly connects to the tenant the device is joined to.
  * *Entra Registered (BYOD / Unmanaged):* Unmanaged Windows devices automatically register upon the first user sign-in to the GSA client. If the user has multiple registered tenants, they will be prompted to select one.
  * *Exam Trap:* Registered (BYOD) devices currently **only support Private Access traffic**. They will not tunnel general internet or M365 traffic.

**II. Windows Client Deployment & Intune Configuration**

* **Intune Win32 App Packaging**
  * *Deployment Type:* Must be packaged as an `.intunewin` file and deployed as a Windows app (Win32).
  * *Installation Command:* `powershell.exe -ExecutionPolicy Bypass -File [YourScriptName].ps1`.
* **Mandatory Detection Rules**
  * *Path:* `C:\Program Files\Global Secure Access Client\TrayApp`.
  * *File:* `GlobalSecureAccessClient.exe`.
  * *Rule Type & Operator:* File type, String (version), Operator: Greater than or equal to.
  * *Exam Trap:* Intune checks the UI tray application to verify installation, not the background tunneling services.
  * *Troubleshooting Detail:* When deploying an update, you must manually update the version number in the detection rule, or older clients will not be recognized as needing the upgrade.

**III. macOS Client Deployment & MDM**

* **Command Line Installation**
  * *Silent Install Command:* `sudo installer -pkg [Path] -target / -verboseR`. The `-verboseR` flag is critical for generating real-time logs during deployment.
  * *Exam Trap:* The CLI command installs the files silently, but the user will still see security prompts unless an MDM is used.
* **MDM Profile Configuration (Intune)**
  * *System Extensions:* To achieve a truly silent install, an MDM must auto-approve the macOS network extensions (`com.microsoft.globalsecureaccess.tunnel`) and the transparent proxy.
  * *Preference Domain:* Must use `com.microsoft.globalsecureaccess` to target settings.
  * *Exam Trap / Migration:* In June 2025, the identifier changed. Older policies using `com.microsoft.naas.globalsecure-df` will fail on current versions and must be updated.
  * *Best Practice:* Deploy the Microsoft Enterprise SSO plug-in alongside the client for seamless authentication without redundant prompts.

**IV. Mobile Deployment Architecture (iOS & Android)**

* **iOS Architecture & Configuration**
  * *Mechanism:* Uses a local/self-looping VPN (`127.0.0.1`) that feeds traffic into Microsoft Defender to evaluate forwarding profiles directly on the device.
  * *Intune Profile Type:* Custom VPN profile.
  * *Required Keys:* `EnableGSA` (to start the service) and `EnableGSAPrivateChannel` (optional).
* **Android Architecture & Configuration**
  * *Intune Profile Type:* App Configuration Policy.
  * *Required Keys:* `Global Secure Access` (value `3` enables and hides the disable option) and `GlobalSecureAccessPrivateChannel`.
  * *Exam Trap:* Never mix the iOS and Android key names (e.g., deploying `EnableGSA` to Android). The Defender app will simply ignore it, and the client will fail to start.

**V. Advanced Traffic Interception & Registry Optimizations**

* **DNS Over HTTPS (DoH) Dependency**
  * *Mechanism:* GSA relies on intercepting local DNS FQDN queries and rewriting the response with a synthetic `6.6.x.x` IP to steer traffic into the tunnel.
  * *Configuration Detail:* Administrators must explicitly disable DoH in Windows OS settings and browsers (Edge, Chrome, Firefox), because encrypted DNS queries bypass the client's interception engine, resulting in traffic routing locally.
* **Intelligent Local Access (ILA)**
  * *Mechanism:* Uses a DNS probe looking for a specific internal FQDN. If the FQDN resolves to your specified corporate IP range, the client knows it is on-premises and bypasses the cloud tunnel.
  * *Troubleshooting Detail:* Check Windows Event IDs 217 and 218 to verify when the client detects moving on or off the corporate network.
* **Kerberos Negative Caching Mitigation**
  * *Issue:* If a Domain Controller is unreachable upon boot, Windows caches the failure and waits 10 minutes before retrying.
  * *Registry Fix:* Set `FarKdcTimeout` to `0` (REG_DWORD) at `HKLM\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters`.
  * *Manual Troubleshooting Fix:* Run `KLIST PURGE_BIND` from an admin command prompt to instantly clear the negative cache.
* **RDP MFA Timeout Mitigation**
  * *Issue:* RDP sessions time out too quickly when waiting for a user to approve an Entra MFA prompt for a Private Access resource.
  * *Registry Fix:* Modify `TimeoutTcpDirectConnection` to `60` (decimal) at `HKLM\Software\Microsoft\Terminal Server Client`.

**VI. Security, Disablement, & UI Restrictions**

* **Windows UI Controls**
  * `HideDisableButton` (0x1): Completely hides the "Disable" option from the system tray.
  * `RestrictNonPrivilegedUsers` (0x1): Allows the disable button to be visible but triggers a UAC prompt requiring local admin credentials if clicked.
  * `HideSignOutButton` (0x1): Prevents the user from signing out and unbinding their identity from the tunnel.
* **macOS Disablement Workflow**
  * *Auditing Differences:* Unlike Windows, if a macOS user selects "Disable", they are forced to provide a **Business Justification** (which logs to Entra) and re-authenticate via Entra ID.
  * *Persistence:* The macOS disabled state is temporary; the client automatically re-enables on the next system restart.
  * *MDM Keys:* macOS UI is restricted via MDM settings: `HideDisableButton`, `HideQuitButton`, and `HidePauseButton`.

**VII. Comparison Tables**

**Table 1: Mobile Configuration Keys by Platform**

| Feature | Android (App Config Policy) | iOS (Custom VPN Profile) |
| :--- | :--- | :--- |
| **Enable Service** | `Global Secure Access` | `EnableGSA` |
| **Enable Private Access** | `GlobalSecureAccessPrivateChannel` | `EnableGSAPrivateChannel` |

**Table 2: Device State and Tunnel Support**

| Device State | M365 Traffic | Internet Access | Private Access | Tenant Selection |
| :--- | :--- | :--- | :--- | :--- |
| **Entra/Hybrid Joined** | Supported | Supported | Supported | Hard-locked to joined tenant |
| **Registered (BYOD)** | **Not Supported** | **Not Supported** | Supported | User prompts to select tenant |

**Table 3: Client Disablement & UI Controls**

| Feature | Windows Client | macOS Client |
| :--- | :--- | :--- |
| **Business Justification Required** | No | Yes |
| **Entra Re-authentication Required** | No | Yes |
| **Persists after Reboot** | Yes | No (Auto-enables) |
| **Configuration Method** | Registry (`HideDisableButton`) | MDM Preference Domain |

Would you like me to generate a Tailored Report artifact of this study sheet so you can easily save it to your Notebook, or shall we move on to exploring the log visualization workbooks in Microsoft Sentinel next?
