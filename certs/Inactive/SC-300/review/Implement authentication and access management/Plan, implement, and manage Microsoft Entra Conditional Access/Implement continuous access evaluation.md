### **SC-300 Study Review Sheet: Implement Continuous Access Evaluation (CAE)**

#### **1. CAE Architecture & Core Mechanics**

* **The Background Dialogue Mechanism**
  * Continuous Access Evaluation (CAE) operates through a continuous background dialogue directly between Microsoft Entra ID and the specific resource provider (such as Exchange Online or SharePoint).
  * CAE does not rely on a reverse proxy to actively route sessions or verify egress IP addresses.
* **Comparison Table: Architectural Mechanisms**

| Feature | Architectural Mechanism | Primary Use Case |
| :--- | :--- | :--- |
| **Continuous Access Evaluation (CAE)** | Background dialogue between Entra ID and Resource Provider. | Enforcing location policies, IP verification, and instant token revocation. |
| **Conditional Access App Control (CAAC)** | Reverse proxy architecture ("man-in-the-middle"). | Actively monitoring sessions, blocking real-time actions like sensitive file downloads or copy/paste. |

* **🚨 SC-300 Exam Traps**
  * **The Reverse Proxy Trap:** If an exam scenario involves verifying an egress IP address or enforcing strict location policies, you must choose CAE, which does *not* use a reverse proxy. Reverse proxies are exclusively utilized for CAAC.

#### **2. The IP Address Mismatch Problem & Enforcement Modes**

* **The Root Cause of Mismatches**
  * In complex network architectures utilizing split-tunnel VPNs, network traffic routing diverges depending on its final destination.
  * This split routing causes the IP address that Microsoft Entra ID sees during initial authentication to differ completely from the egress IP address that the resource provider (e.g., Exchange Online) sees when the user accesses data.
* **Comparison Table: CAE Location Enforcement Modes**

| Mode | System Assumption | Resulting Action |
| :--- | :--- | :--- |
| **Standard Mode (Default)** | Assumes the mismatch is a benign network routing quirk to protect user productivity. | Grants a safe exception by issuing a short-lived **1-hour token**. |
| **Strict Mode** | Intentionally removes the 1-hour safety net and strictly enforces the resource provider's perspective. | Access is **immediately blocked** if the egress IP detected by the resource provider is not explicitly on the allowed list. |

* **Scenario Example**
  * A user logs into Entra ID from their home network (IP trusted by Entra), but their split-tunnel VPN routes their Exchange Online traffic through a corporate gateway (Egress IP unknown to Entra policies). Under Standard Mode, they get a 1-hour token. Under Strict Mode, they are instantly blocked.

#### **3. The Strict Location Enforcement Deployment Sequence**

* **Prerequisites & Configuration Details**
  * Because Strict Mode drops the standard 1-hour token exception, enabling it blindly carries a high risk of instantly locking legitimate users out of their resources.
  * Administrators are strictly required to thoroughly test their network topology before enforcement.
* **The 3-Step Remediation Sequence**
    1. **Identify:** You must run the **Continuous Access Evaluation Insights workbook** to find, map out, and discover hidden IP mismatches caused by your network topology actively occurring in your environment.
    2. **Remediate:** Administrators must manually map and explicitly add those newly discovered egress IP addresses to the organization's allowed IP list (Named Locations).
    3. **Enforce:** Only after the hidden IPs are mapped and added to the allowed IP list should the administrator enable the **Strictly enforce location policies** feature to begin immediate blocking.
* **🛠️ Troubleshooting Details**
  * If users report sudden, widespread access blocks to SharePoint or Exchange immediately after modifying a CAE policy, verify that the CAE Insights workbook was executed and all identified egress IPs were added to Named Locations.

#### **4. CAE Integration with Global Secure Access (SSE)**

* **Bridging Identity and Network Security**
  * Microsoft Global Secure Access (Security Service Edge) bridges separated network security silos (web filtering) with identity security silos (device compliance/MFA).
  * Administrators build **security profiles** in the Global Secure Access portal, which group various network security policies (e.g., blocking malicious websites or unsanctioned cloud storage).
* **Configuration Details**
  * The integration relies on the **"Use Global Secure Access security profile"** setting.
  * This setting allows network security rules to dynamically adapt based on real-time identity signals (like Entra ID Protection sign-in risk or device compliance) evaluated continuously during the user's active session.
* **🚨 SC-300 Exam Traps**
  * **The Category Trap:** Do not confuse this integration point with a *Grant* control or a *Condition*. Because it actively manages routing during the ongoing session, it is exclusively located under the **Session controls** menu within the Conditional Access policy builder.

#### **5. CAE Evaluation for AI Agents & Complex Workflows**

* **AI Agent Evaluation Logic**
  * **Agent Blueprints:** An agent blueprint is simply a logical template whose only job is to instantiate active agent identities. Conditional Access does not apply to blueprints when they are just acquiring a token to create a new agent.
* **Comparison Table: AI Agent Flow Evaluation**

| AI Agent Flow Type | Description | Target Evaluated by Conditional Access |
| :--- | :--- | :--- |
| **On-Behalf-Of (OBO) Flow** | An agent acting on behalf of a signed-in human user (e.g., summarizing a secure document). | The policy is evaluated against the **human user**, not the agent identity. |
| **Autonomous Flow** | An agent running independently on a schedule using its own credentials via Client Credentials flow. | The policy applies strictly to the **agent identity**. |

* **Prerequisites for Autonomous AI Agent Filtering**
  * To filter access for autonomous AI agents, the best practice is to assign Custom Security Attributes (e.g., `AgentApprovalStatus`) directly to the agent's identity object.
  * To *assign* the attribute, the **Attribute Assignment Administrator** role is required.
  * To *use* the attribute in the "Filter for applications/agents" condition of a CA policy, the administrator must possess both the **Conditional Access Administrator** and the **Attribute Assignment Reader** roles.
* **🚨 SC-300 Exam Traps**
  * **The OBO Trap:** If a scenario explicitly mentions the On-Behalf-Of flow or an AI agent acting on behalf of a human, memorize that the policy evaluation is *always* executed against the human user.

#### **6. Session State Limitations: Private Browsing & Authentication Transfer**

* **Private Browsing (Incognito / InPrivate) Conflicts**
  * Browsers running in private modes (Google Chrome Incognito, Microsoft Edge InPrivate) intentionally isolate the session and actively suppress the cookies and Primary Refresh Tokens (PRT) needed for SSO flows.
  * **Troubleshooting Details:** Because private sessions refuse to pass device identity artifacts, the system explicitly considers the session as coming from an unregistered, noncompliant device.
  * **Configuration Impact:** Incognito/InPrivate sessions will permanently fail the "Require device to be marked as compliant" grant control and are explicitly not considered an "approved client app".
* **Authentication Transfer & Protocol Tracking**
  * Authentication Transfer allows passing authentication state (like MFA claims) from a PC to a mobile device via QR code.
  * When utilized, the resulting session becomes **protocol tracked**, meaning the system remembers the session's history and may subject later sign-in attempts to original authentication flow policies.
  * **🚨 Exam Trap (MDM Bypass):** Device compliance and managed states *never transfer* during this flow. Because the flow inherently bypasses third-party mobile device management (MDM) solutions, Microsoft strongly recommends using Conditional Access to completely block authentication transfer if an organization relies on a non-Microsoft MDM.
