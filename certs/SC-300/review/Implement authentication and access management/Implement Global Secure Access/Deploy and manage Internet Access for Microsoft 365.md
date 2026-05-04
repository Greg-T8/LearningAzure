# SC-300 Study Review Sheet: Deploy and Manage Microsoft 365 Access

**I. Licensing, Capacity & Prerequisites**

* **Remote Network (Branch) Licensing Threshold**
  * *Requirement:* A minimum of **50 combined licenses** (Entra ID P1, Entra Internet Access, or Entra Suite) is required to unlock remote network features.
  * *Bandwidth Allocation:* 50–99 licenses grants a baseline pool of **500 Mbps**. This scales up to **35,000 Mbps** for 10,000+ licenses.
  * *Configuration Detail:* Bandwidth is distributed to individual IPsec tunnels in fixed increments of **250, 500, 750, or 1,000 Mbps**.
* **Source IP Restoration Prerequisites**
  * *Requirement:* Requires **Microsoft Entra ID P1**.
  * *Configuration Detail:* Enabled globally via "Enable Global Secure Access signaling in Conditional Access" under Adaptive Access. For tenants enabling GSA after June 2025, this is on by default.

**II. Profile Architecture & Routing Precedence**

* **Strict Evaluation Hierarchy**
  * **1. Microsoft traffic profile (High)**
  * **2. Private access profile (Medium)**
  * **3. Internet access profile (Low)**
* **Workload Separation**
  * *Microsoft Profile:* Exchange Online, SharePoint Online, OneDrive, Teams, Office Online. Uses a dedicated, optimized tunnel gateway.
  * *Exam Trap:* **Azure Portal and Azure APIs** are managed by the Internet Access profile, NOT the Microsoft profile.
  * *Exam Trap:* **Entra ID logins and Graph API** are handled by the system-managed "Microsoft Entra traffic profile".
* **Exclusivity and Fallback Behavior**
  * *Rule:* Microsoft traffic is exclusive to its own profile.
  * *Exam Trap:* If a specific M365 destination is set to "Bypass" in the Microsoft profile, it will **not** fall back to the Internet Access profile. It bypasses GSA entirely and egresses via the local network.

**III. Security Controls & Compliant Networks**

* **Preventing "SSE Bypass"**
  * *Scenario Example:* A user pauses the GSA client to bypass corporate web filtering.
  * *Mitigation:* Create a Conditional Access policy blocking access to M365 from any network *except* a "Compliant Network" (a network verified as originating from your GSA tenant).
  * *Configuration Sequence:* **Include "Any Location"**, **Exclude "All Compliant Network locations"**, and **Grant "Block"**.
  * *Exam Trap:* Always exclude emergency "break-glass" accounts from this policy to prevent total tenant lockouts.
* **Defense Against Token Theft (Replay Attacks)**
  * *Mechanism:* If an attacker steals a valid session token, they will attempt to replay it from their own unmanaged machine.
  * *Result:* Entra ID evaluates the Compliant Network requirement and the Device ID binding. It immediately denies the access request because the attacker is not tunneling through your GSA instance.

**IV. Advanced Routing: BGP & Health Probes**

* **Autonomous System Numbers (ASN) for BGP Peering**
  * *Microsoft Gateway ASN:* Always uses **65476**.
  * *Customer Premises Equipment (CPE) ASN:* Must be a unique 2-byte value (e.g., **65533**).
  * *Exam Trap (The "Swap" Rule):* The ASN configured on your local router must be entered in the **Device ASN** field in the Entra portal, and Microsoft's ASN (65476) must be entered as the **Peer/Remote ASN** on your router.
  * *Configuration Detail:* Avoid reserved ASNs like 12076 or 8075.
* **IP SLA Layer 7 Health Probes**
  * *Purpose:* Verifies the remote network tunnel is actively processing M365 traffic, not just electrically connected (Layer 3).
  * *Endpoint:* Statically route the probe over the IPsec tunnel to **`198.18.1.101`** or `http://m365.remote-network.edgediagnostic.globalsecureaccess.microsoft.com:6544/ping`.
  * *Troubleshooting Detail:* If the Layer 7 probe fails, the router should be configured to automatically reroute traffic locally to preserve user productivity.

**V. Identity Visibility, Auditing & Graph API**

* **Purview Audit Log Enrichment**
  * *Supported Workloads:* Currently enriches **SharePoint Online** and **OneDrive** logs.
  * *Data Added:* Original Source IP, Device ID, OS, and verified Network Path.
  * *Configuration Detail:* Route `NetworkAccessTrafficLogs` and `OfficeActivity` to Log Analytics and visualize using the **Enriched Microsoft 365 Logs workbook**.
* **Microsoft Graph API (Beta)**
  * *Endpoint:* The Network Access API is currently strictly in the `/beta` namespace.
  * *Query:* Use `GET https://graph.microsoft.com/beta/networkaccess/forwardingprofiles` to list profiles.
  * *Exam Trap:* To see the actual rules inside a profile, you must append the **`$expand=policies`** OData parameter.

**VI. Comparison Tables**

**Table 1: Diagnostics Alerts: Inconsistency vs. Connectivity**

| Alert Type | Category | Trigger Cause | Primary Risk |
| :--- | :--- | :--- | :--- |
| **Token & Device Inconsistency** | **Security / Identity** | Session token used on a new/different Device ID. | **Token Theft / Replay Attack** |
| **Unhealthy Remote Network** | **Operational / Health** | BGP drop or broken IPsec tunnel to GSA edge. | **Loss of Connectivity** |

**Table 2: IP Visibility Mechanisms**

| Feature | Primary Purpose | How it Works |
| :--- | :--- | :--- |
| **Source IP Restoration** | Identity Protection & Auditing | Extracts and preserves the user's *original* public IP in Entra logs. |
| **Source IP Anchoring** | B2B / Legacy App Whitelisting | Routes traffic via a private connector so a 3rd-party SaaS app sees a *specific corporate IP*. |

**Table 3: Traffic Routing Profiles**

| Traffic Destination | Matching Profile | Precedence |
| :--- | :--- | :--- |
| **Exchange Online / Teams** | Microsoft Traffic Profile | **High** (Evaluated First) |
| **On-Premises File Share** | Private Access Profile | **Medium** (Evaluated Second) |
| **Azure Portal / General Web** | Internet Access Profile | **Low** (Evaluated Last) |

Would you like to move on to emergency "Break-Glass" account exclusions, or is there another SC-300 topic you'd like to dive into next?
