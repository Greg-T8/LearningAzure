# SC-300 Study Review Sheet: Deploy and Manage Private Access

**I. Infrastructure Prerequisites & Licensing Configuration**

* **Microsoft Entra Private Network Connectors**
  * **Architectural Baseline:** Version 1.5.3417.0 is the minimum required. It acts as a stateless, outbound bridge.
  * **OS & Software:** Requires Windows Server 2016+. As of version 1.5.3437.0, .NET 4.7.1+ is mandatory, but .NET 4.7.2+ is recommended.
  * **Network Requirements:** Must reach Microsoft endpoints (`*.msappproxy.net`, `*.servicebus.windows.net`) outbound over TCP ports 80 and 443.
  * **TLS Configuration:** TLS 1.2 is mandatory.
    * *Configuration Detail:* Disable inline SSL inspection or termination for these outbound connections, as it breaks the required certificate-based authentication.
  * **High Availability:** Always deploy at least two connectors per connector group. The "updater service" automatically applies patches, and having two prevents traffic drops during updates.
* **External Tenant Access (B2B/Guest Access)**
  * **Client Configuration:** Enable via the `GuestAccessEnabled` registry key (`REG_DWORD` = `0x1`) at `HKEY_LOCAL_MACHINE\Software\Microsoft\Global Secure Access Client`.
  * **Context Switching:** When a user switches to a partner tenant, all tunnels to their home tenant (M365, Internet, Private) immediately disconnect, and a dedicated Private Access tunnel opens to the resource tenant.
  * *Exam Trap (Licensing):* The user's *home* organization does NOT need a Global Secure Access license (Entra Free is sufficient).
  * *Prerequisite Note:* The *resource* tenant must have Private Access enabled, explicitly assign the guest user to an app/profile, and link an Azure subscription. The standard 50k free P1/P2 MAU allowance does not apply to GSA guests.

**II. Application Segments & Network Traffic Routing**

* **Defining Application Segments**
  * **Required Fields:** Destination (FQDN, IP address, or CIDR range), Port, and Protocol (TCP, UDP, or Both).
  * **Limits:** An Enterprise application supports a maximum of 500 individual application segments.
* **Overlapping Segments & Precedence Logic**
  * **General Rule:** Overlapping segments (exact same destination, port, and protocol) are generally blocked within or between Enterprise Apps.
  * **The Quick Access Exception:** Quick Access uses broad network ranges (e.g., `10.0.0.0/16`) to act as a VPN replacement.
  * **Precedence Hierarchy:** If an Enterprise App (e.g., `10.1.1.5:22`) overlaps with a Quick Access subnet (`10.1.1.0/24`), the **Enterprise application ALWAYS takes priority**. Traffic is evaluated against the Enterprise App's CA policies and never hits Quick Access.
* **Application Discovery Integration**
  * **Mechanism:** Monitors broad Quick Access traffic to discover specific 5-tuples (Destination, Protocol, Port, User, Device).
  * *Prerequisite Note:* Requires 10–15 minutes of active usage through Quick Access before telemetry populates the 30-day historical window.
  * *Exam Trap (Migration):* Moving a discovered segment from Quick Access to an Enterprise App does NOT automatically migrate user assignments. Users will be blocked until explicitly assigned to the new granular app.
  * *Configuration Detail:* Allow 15 minutes for routing/segment changes to synchronize with GSA clients.

**III. Advanced DNS Mechanics & Synthetic IP Addressing**

* **FQDN Interception and DNS Rewriting**
  * **The Process:** The GSA client intercepts a local DNS query for an FQDN, sends it to the GSA edge DNS proxy, which resolves the internal IP via the on-premises connector.
  * **The "Magic IP":** The client rewrites the DNS response, handing the calling application a **Synthetic IP** from the `6.6.0.0/16` range.
  * **Traffic Steering:** When the app connects to the `6.6.x.x` address, the LWF driver steers it into the tunnel.
  * *Scenario Example:* Essential for Azure PaaS (like Storage Accounts) behind Private Link, where dynamic IPs change but FQDNs remain static.
* **Single-Label Domains (SLD)**
  * **Resolution:** For short names (e.g., `benefits`), an NRPT entry directs queries ending in `globalsecureaccess.local` to the GSA DNS proxy to ensure successful resolution.

**IV. Active Directory Protection & Intelligent Local Access (ILA)**

* **Private Access Sensors (Kerberos Protection)**
  * **Purpose:** Enforces Conditional Access and MFA on legacy Kerberos authentications.
  * **Installation:** Installed directly on Active Directory Domain Controllers.
  * **Identity Flow:** The Private Network Connector acts as a bridge, verifying identity by communicating with the Sensor over **inbound TCP port 1337** on the DC.
  * *Configuration Detail:* Administrators must manually add the connector IPs to the `SourceIPAllowList` in the DC's `localpolicy.json`.
  * *Exam Trap:* Do not confuse the Sensor (identity verification on a DC) with an IPSec tunnel/CPE router (network transit for a branch office).
* **Intelligent Local Access (ILA)**
  * **Mechanism:** Uses a **DNS probe** targeting a specific FQDN.
  * **Behavior:** If the query resolves to a predefined internal IP range, the client knows it is on the corporate network and **bypasses the cloud backend**, routing traffic locally.
  * *Exam Trap:* ILA does NOT use GPS or geofencing. Furthermore, even when traffic routes locally, Conditional Access policies still apply.

**V. Migration & Client Coexistence**

* **LWF Driver Architecture**
  * **Mechanism:** Uses a Lightweight Filter (LWF) driver rather than a virtual VPN adapter. This allows side-by-side coexistence with third-party VPNs without "tunnel wars".
  * *Configuration Detail (Bypasses):* To coexist with a 3rd-party VPN, you must configure the legacy VPN to **bypass the 6.6.0.0/16 synthetic IP range**.
* **DirectAccess Migration Blocking**
  * *Exam Trap:* DirectAccess and Private Access **cannot be active simultaneously**. DirectAccess device tunnels establish at boot and take precedence, blocking GSA.
  * *Troubleshooting Detail:* You must fully clear the DA state—often requiring **two system reboots** after removing the computer from the DA security group—before enabling the Private Access forwarding profile.

**VI. Troubleshooting via Advanced Diagnostics**

* **Launch:** Right-click the GSA system tray icon -> Advanced Diagnostics.
* **Hostname Acquisition Tab:** Shows the requested FQDN, the Generated Synthetic IP (`6.6.x.x`), and the Original Internal IP. Crucial for troubleshooting FQDN tunneling.
* **Traffic Tab:** Displays live captures. Verify the *Action* (Tunnel, Bypass, Block) and the *Protocol* (TCP/UDP).
* **Forwarding Profile Tab:** Contains a **Policy tester** to check which rule applies to a destination and shows rule Priority.

**VII. Comparison Tables**

**Table 1: Port and Protocol Requirements**

| Component | Port | Protocol | Direction | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Private Access Sensor** | 1337 | TCP | Inbound | Receives identity validation requests from the Connector. |
| **Private Access Sensor** | 443 | TCP | Outbound | Registers the sensor and fetches cloud policies. |
| **Private Network Connector**| 80/443 | TCP | Outbound | Bridges internal resources to the GSA service edge. |
| **App Segment (SSH)** | 22 | TCP | N/A | Defined in Entra to capture secure shell traffic. |
| **App Segment (Kerberos)** | 88 | UDP/TCP | N/A | Defined in Entra for DC locator services. |

**Table 2: Protocol Support by Profile**

| Service Profile | Supported Protocols | Key Details |
| :--- | :--- | :--- |
| **Private Access** | TCP and UDP | Essential for legacy apps, RDP, SMB, and UDP-based Kerberos. |
| **Internet Access** | Primarily TCP | Does not support QUIC (UDP 443). Firewalls must block UDP 443 to force fallback to HTTPS/TCP. |

**Table 3: Overlap & Routing Precedence**

| Segment Type | Routing Priority | CA Policy Applied | Migration Impact |
| :--- | :--- | :--- | :--- |
| **Quick Access (e.g., 10.1.1.0/24)** | Low | Broad VPN-replacement policy. | Feeds telemetry to App Discovery. |
| **Enterprise App (e.g., 10.1.1.5:3389)** | High | Specific per-app policy. | Requires explicit user assignment. |

Would you like to review the specific Conditional Access "Compliant Network" break-glass procedures next, or focus on Microsoft 365 traffic routing?
