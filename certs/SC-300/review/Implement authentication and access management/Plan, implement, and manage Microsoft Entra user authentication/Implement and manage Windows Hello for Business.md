### **Device Encryption & Data Protection**

* **Personal Data Encryption (PDE)**
  * **Configuration Details:**
    * Encrypts **individual files** using AES-CBC with a 256-bit key.
    * Decryption keys are released *only* at the time of user sign-in via Windows Hello.
    * Keys are immediately discarded upon sign-out.
    * **Known Folders:** In Windows 11 24H2+, administrators can auto-encrypt the **Desktop, Documents, and Pictures** folders.
  * **📝 Prerequisites & Licensing:**
    * Strictly requires **Microsoft Entra joined** or **Microsoft Entra hybrid joined** devices (traditional on-premises domain-joined is not supported).
    * Mutually exclusive with legacy Encrypting File System (EFS).
  * **🚨 Exam Traps:**
    * **Authentication Exclusions:** Access is explicitly denied if the user signs in with a password or a FIDO2 security key.
    * **Remote Access:** Content cannot be accessed remotely via Remote Desktop (RDP) sessions or UNC network paths.
    * **Other Users:** Other users signed into the same device cannot access the content, even with NTFS permissions.
  * **🔧 Troubleshooting & Recovery:**
    * A **destructive PIN reset** permanently destroys the cryptographic material tied to the PIN, permanently bricking access to the local PDE files.
    * There is absolutely **no backdoor or administrator override** to decrypt the files if keys are lost.
  * **Scenario Example:** A user forgets their PIN. To prevent data loss, the administrator should instruct them to use the **Windows Hello for Business PIN reset service** for a *nondestructive* reset. If they perform a destructive reset, they must recover cleartext files synced from **OneDrive in Microsoft 365**. If PDE "Level 2" protection is enabled, files become inaccessible exactly **one minute** after the Windows lock screen engages.

**📊 Comparison Table: Encryption Boundaries (PDE vs. BitLocker)**

| Feature | Scope of Encryption | Key Release Trigger | Authorized Fallback Methods | Data Loss Risk |
| :--- | :--- | :--- | :--- | :--- |
| **BitLocker** | Entire Volume / Drive at rest. | System boot. | Recovery Password, USB Key. | Low (Admin can use Recovery Key). |
| **Personal Data Encryption (PDE)** | Individual Files (AES-CBC 256). | User sign-in (WHfB only). | **None** (FIDO2 & Passwords blocked). | High (Destructive PIN reset destroys keys). |

### **Windows Passwordless Experience & User Deconditioning**

* **Step 2: "Journey to Password Freedom"**
  * **Configuration Details:** The goal is reducing the user-visible password surface area to decondition users from typing passwords (mitigating phishing).
  * **App Mitigation Strategies (Ideal SSO):**
    * *Cloud/Modern Apps:* Integrate natively with **Microsoft Entra ID**.
    * *On-Premises Apps:* Update to use **Windows integrated authentication**.
    * *Standalone Databases:* Integrate with the centralized directory instead of relying on isolated SQL credentials.
* **Password Surface Reduction Policies**
  * **🚨 Exam Traps & Policy Distinctions:**
    * **Windows Passwordless experience:** The recommended option. Completely **hides the password option** on the lock screen (Entra-joined only).
    * **Require Windows Hello for Business or a smart card:** Blocks password use but **leaves the password prompt visible**. Users attempting to use it get an error message.
    * **Exclude credential providers:** The "Nuclear" option. Disables password usage for **all accounts**, including local administrators, completely breaking RDP and "Run as" scenarios.

### **Windows Hello Hardware Security & Attestation**

* **Enhanced Sign-in Security (ESS)**
  * **Configuration Details:** Creates a secure, hardware-isolated boundary between biometric sensors and the Windows OS using Virtualization-based Security (VBS).
  * **📝 Prerequisites:** Requires **specialized biometric sensors** and explicit **BIOS support** to establish trusted pathways. It is enabled by default on **Copilot+ PCs** and supported on Windows Pro, Enterprise (E3/E5), and Education (A3/A5).
  * **🔧 Troubleshooting:** Use the **`sktool.exe /lkey`** command-line utility to view VSM master key provisioning status.
  * **Scenario Example:** An administrator disables Secure Boot in the BIOS. The Virtual Secure Mode (VSM) master key fails to unseal. ESS will actively **refuse to accept the user's PIN or Face identification** to protect the credential.
* **Biometric Privacy Architecture**
  * **🚨 Exam Traps:** Biometric data **never** syncs to Microsoft Intune, Microsoft Entra ID, or the cloud. The biometric scan is only a local "trigger" to access the provisioned cryptographic key.
* **TPM Hardware Attestation (EK vs. AIK)**
  * **Configuration Details:** Prevents malware from mimicking a physical TPM during credential provisioning.
  * **Endorsement Key (EK):** Proves **hardware authenticity** (the TPM is a genuine chip from a trusted manufacturer).
  * **Attestation Identity Key (AIK):** Protects **privacy** by acting as a proxy for the EK, ensuring the device isn't permanently tracked across services. Microsoft acts as the identity CA to issue AIK certificates.

### **TPM Anti-Hammering & Lockout Defense**

* **TPM Anti-Hammering Logic**
  * **Configuration Details:** TPM 2.0 has built-in dictionary attack protection that mathematically standardizes the "32/10 Rule".
  * **The Threshold:** The TPM completely locks down after **32 failed authorization attempts**.
  * **The Cooldown:** The TPM "forgets" one failure every **10 minutes**, provided the system is **powered on and running**.
  * **🔧 Troubleshooting:** A lockout generates **Event ID 1026**. The best administrative action is to **wait for the cooldown period to expire**.
  * **🚨 Exam Traps:**
    * **Global Lockout:** This is a global hardware lockout. It affects all users on the device and halts all TPM-dependent features, including BitLocker and virtual smart cards.
    * **Destructive Overrides:** Clearing the TPM factory resets the failure counter, but **destroys all existing keys**, causing catastrophic data loss for WHfB, PDE, and BitLocker. An immediate override without clearing requires the **TPM owner password**, which is randomly generated and discarded by default in modern Windows.

**📊 Comparison Table: Passwordless Lockout Behaviors**

| Lockout Component | Threshold | Recovery / Mitigation | Impact Scope |
| :--- | :--- | :--- | :--- |
| **Entra ID Smart Lockout** | Cloud-configured (default 10). | Wait for cloud timer (default 1 minute). | Single user cloud identity. |
| **TPM 2.0 Anti-Hammering** | **32 failed attempts**. | Wait **10 minutes** (powered on). | **Global** (All users + BitLocker). |

### **Seamless Remote Access Integration**

* **Always On VPN & Passwordless SSO**
  * **Configuration Details:** Always On VPN natively supports WHfB to provide seamless SSO when auto-triggering on network changes.
  * **📝 Prerequisites:** The VPN profile must use **EAP-TLS** in **certificate-based authentication mode**. (Legacy EAP-MSCHAPv2 relies on passwords and breaks SSO).
  * **🚨 Exam Traps:**
    * **User Tunnel vs. Device Tunnel:** **User Tunnel** connects *after* logon (utilizing the WHfB certificate). **Device Tunnel** connects *before* logon strictly utilizing IKEv2 and machine certificates.
    * **Trusted Network Detection:** Administrators should configure DNS suffixes to prevent the VPN from auto-triggering if the user is physically inside the corporate network.
  * **Scenario Example:** A device falls out of Intune compliance. Because Always On VPN integrates with Microsoft Entra Conditional Access, Entra ID will **block the VPN connection** by refusing to issue the required short-lived IPsec authentication certificate.
