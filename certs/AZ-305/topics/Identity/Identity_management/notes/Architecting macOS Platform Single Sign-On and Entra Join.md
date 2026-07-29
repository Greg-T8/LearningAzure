# Architecting macOS Platform Single Sign-On and Entra Join

Great job on selecting the correct answer! This question tests your knowledge of how macOS device management has evolved with the introduction of **Platform Single Sign-On (PSSO)**.

Here is a detailed breakdown of why this architectural setup is required for macOS devices and how it changes the trust model:

**1. The Shift from 'Registered' to 'Joined'**
Historically, Apple devices (macOS and iOS) were generally limited to being **Microsoft Entra registered** [1]. However, PSSO introduces the capability for macOS devices (running macOS 13 Ventura or newer) to achieve a full **Microsoft Entra join** [2, 3]. This elevates the device to a deeper level of trust and allows the device to receive a PSSO Primary Refresh Token (PRT), which is a fundamental requirement for advanced single sign-on capabilities [2].

**2. Why Intune and the SSO Extension are Prerequisites**
To support this "Join" trust type with PSSO, the architecture must include specific management components:
*   **Mobile Device Management (MDM):** The Mac device must be enrolled in an MDM platform, such as Microsoft Intune [4].
*   **The Enterprise SSO Extension:** The MDM must be used to deploy a configuration profile that enables the **Microsoft Enterprise Single Sign-On (SSO) plug-in for Apple devices** [5, 6]. This payload contains the specific PSSO settings, extension identifiers, and allowed authentication methods (like Secure Enclave, Smart Card, or Password) required by the organization [7, 8].

**3. How it Works Together**
Once the Mac is MDM-enrolled and receives the SSO extension profile, the user is prompted with a "Registration Required" notification [9]. The Intune Company Portal app (which must be version 5.2404.0 or later) facilitates this flow, completing the device registration and elevating the device to a fully Microsoft Entra joined state [4, 10, 11]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing device identity solutions for Apple fleets, remember that macOS PSSO is strictly supported in **Microsoft Entra join** deployments, and Microsoft has no plans to support hybrid-join deployments for Macs [12]. By utilizing an MDM (like Intune) and the Enterprise SSO plug-in, you can enable a true passwordless, phishing-resistant experience where users unlock their Mac's local desktop using Touch ID (Secure Enclave) and gain seamless SSO to all Microsoft Entra resources [5, 13].