# SC-300 Study Review Sheet: Deploy and Manage Internet Access

**I. Infrastructure Prerequisites & Device Governance**

* **Device Join State (Windows)**
  * *Prerequisite:* Devices must be **Microsoft Entra Joined** or **Microsoft Entra Hybrid Joined** to support the Internet Access and Microsoft 365 traffic forwarding profiles.
  * *Reasoning:* The Internet Access tunnel requires specific device tokens tied to a managed tenant, and advanced features like DLP require this managed state. On Windows, Joined devices are hard-locked to the joined tenant to prevent circumvention.
  * *Exam Trap:* Microsoft Entra Registered (BYOD) Windows devices do **not** support Internet Access; they only support Private Access.
  * *Troubleshooting Detail:* Use the Advanced Diagnostics tool's Health Check tab. If "Device is Microsoft Entra joined" fails, the Internet tunnel will not establish.
* **Role-Based Access Control (RBAC) Separation**
  * *Global Secure Access Administrator:* Configures traffic forwarding profiles and defines the rules within Security Profiles.
  * *Conditional Access Administrator:* Creates Conditional Access (CA) policies to link/enforce the Security Profiles onto users.
  * *Exam Trap:* A Global Secure Access Admin cannot link a security profile to a user because they lack access to the Conditional Access blade.

**II. Traffic Prioritization & Protocol Handling**

* **Hardcoded Evaluation Hierarchy**
  * **1. Microsoft access profile:** Evaluated first (optimizes M365/identity traffic).
  * **2. Private access profile:** Evaluated second (captures internal corporate FQDNs/IPs).
  * **3. Internet access profile:** Evaluated last.
  * *Scenario Example:* If the Internet profile were evaluated first, it would accidentally "steal" traffic destined for optimized Private Access routes because Internet Access captures all broad port 80/443 traffic.
* **QUIC (UDP 443) Unsupported**
  * *Limitation:* GSA Internet Access does not support QUIC.
  * *Exam Trap:* The GSA client does not proxy or "convert" QUIC to TCP automatically.
  * *Configuration Detail:* Administrators must actively block outbound UDP 443 via Windows Firewall or browser registry (e.g., `QuicAllowed = 0`) to force browsers to automatically fall back to supported HTTPS over TCP.

**III. Security Profiles & CA Integration**

* **The Delivery Mechanism**
  * Security profiles hold the filtering rules but only execute when linked to the **Session** controls of a Conditional Access policy.
* **Evaluation Priority Logic ("First Match Wins")**
  * *Custom Security Profiles (Priority 100 - 64,999):* Linked via CA policies and evaluated first.
  * *Baseline Profile (Priority 65,000):* A tenant-wide catch-all evaluated last. It applies to all traffic automatically.
  * *Configuration Detail:* Maintain a priority gap of 100 (100, 200, 300) when numbering custom profiles so you can insert new rules later.
  * *Scenario Example:* You have a Baseline Profile blocking the "Gambling" category (Priority 65,000). You create a Custom Profile allowing specific gambling research sites for the Legal Team (Priority 100). The Custom Profile matches first, allows the traffic, and stops evaluation before hitting the baseline block.

**IV. Advanced TLS Inspection & SNI Filtering**

* **Server Name Indication (SNI)**
  * *Mechanism:* The default mechanism for HTTPS filtering. SNI is visible during the cleartext TLS handshake.
  * *Capability:* Exposes the FQDN (e.g., `youtube.com`) allowing immediate blocks without decryption.
  * *Exam Trap:* The Host header and full URL path (e.g., `youtube.com/shorts`) are hidden inside the encrypted HTTP payload and require TLS inspection to view.
* **TLS Inspection Architecture & Certificates**
  * *Architecture:* GSA uses a two-tier model. You provide a Customer-Signed Intermediate CA, and GSA dynamically generates short-lived leaf certificates for accessed websites.
  * *Certificate Requirements:* The uploaded intermediate certificate must include **Server Auth** (EKU), **critical** and **CA:TRUE** (Basic Constraints), and **keyCertSign/cRLSign** (Key Usage).
  * *Crucial Prerequisite:* The Root CA certificate used to sign the intermediate must be distributed to all client devices' Trusted Root Certification Authorities store via Intune to prevent browser warnings.

**V. Microsoft Entra AI Gateway & Coexistence**

* **Shadow AI Governance**
  * *Function:* Identifies unsanctioned generative AI tools and applies risk scores.
  * *Prerequisite Note:* **TLS inspection must be enabled** to perform advanced controls like blocking specific file type uploads (e.g., .pdf), Data Loss Prevention (DLP) scanning on prompts, and prompt injection protection.
* **Resolving SSE Routing Conflicts (Tunnel-in-Tunnel)**
  * *Issue:* Running the GSA Lightweight Filter (LWF) driver alongside 3rd-party SSEs (like Zscaler) causes a routing loop.
  * *Configuration Detail:* Implement two-way Custom Bypasses. Add 3rd-party SSE gateways to the GSA bypass list, and add GSA Anycast/`6.6.0.0/16` IPs to the 3rd-party bypass list.
* **Intune Circular Dependency**
  * *Scenario Example:* A CA policy blocks non-compliant devices. A non-compliant device needs GSA Internet access to reach Intune to become compliant, creating a loop.
  * *Configuration Detail:* Add a Custom Bypass for Intune endpoints (e.g., `*.manage.microsoft.com`) so compliance traffic always egresses locally.

**VI. Comparison Tables**

**Table 1: Windows Device State Support**

| Feature | Entra Joined / Hybrid Joined | Entra Registered (BYOD) |
| :--- | :--- | :--- |
| **Internet Access** | **Supported** | **Not Supported** |
| **M365 Access** | **Supported** | **Not Supported** |
| **Private Access** | Supported | Supported |

**Table 2: RBAC Role Duties**

| Task | Global Secure Access Admin | Conditional Access Admin |
| :--- | :--- | :--- |
| **Manage traffic forwarding profiles** | **Yes** | No |
| **Configure security profiles** | **Yes** | No |
| **Create CA policies to link profiles** | No | **Yes** |

**Table 3: Dashboard Reporting Widgets**

| Feature | Usage Profiling | Web Category Filtering |
| :--- | :--- | :--- |
| **Primary Goal** | Monitor volume/patterns. | Identify content types accessed. |
| **Data Shown** | Bytes, User counts. | Categories (e.g., Gambling). |

**Table 4: SNI vs TLS Inspection Visibility**

| Metric | SNI (Default) | TLS Inspection Enabled |
| :--- | :--- | :--- |
| **Location** | TLS Handshake (Cleartext) | HTTP Request Payload |
| **Visible Data** | FQDN (e.g., `bing.com`) | Full URL, Host Header, Files |

I can compile this sheet into a standalone Tailored Report artifact for your Notebook, or we can move on to the next topic like Remote Network (Branch) routing and BGP configurations.
