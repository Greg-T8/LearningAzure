# Architecting Passwordless Authentication for macOS Platform SSO

Great job on selecting the correct answer! This question tests your knowledge of **macOS Platform Single Sign-On (PSSO)** and its supported passwordless authentication methods.

Here is a detailed breakdown of why "Secure Enclave" is the correct architectural choice and how this technology works for macOS devices:

**1. The Role of Platform Single Sign-On (PSSO)**
macOS PSSO is a capability powered by the Microsoft Enterprise Single Sign-On plug-in for Apple devices [1, 2]. It allows users to sign in to their Mac devices using their Microsoft Entra ID credentials, reducing password fatigue and simplifying the overall sign-in experience [2]. To deploy PSSO, Microsoft strongly recommends a minimum operating system version of macOS 14 Sonoma for the best experience [3, 4]. 

**2. Why "Secure Enclave" is the correct method**
When configuring PSSO, you can choose from three distinct authentication methods: Secure Enclave, Smart Card, or Password [5, 6]. 
*   **Secure Enclave (Platform Credential for macOS):** This is the correct choice because it provisions a hardware-bound cryptographic key that is backed directly by the Mac's secure enclave [5, 6]. It is used for SSO across applications that use Microsoft Entra ID and allows users to go passwordless using Touch ID [6, 7]. 
*   **Smart Card:** While this is also a hardware-bound passwordless method, it relies on an *external* hardware token (such as a YubiKey or physical smart card) rather than the local device's built-in hardware [5, 6]. 
*   **Password:** This method simply syncs the user's Microsoft Entra ID password with their local Mac account, meaning it is not passwordless and does not utilize a hardware-bound key [6].

**3. Security and Zero Trust Benefits**
From an architectural perspective, leveraging the Secure Enclave advances Zero Trust objectives by tightly integrating the credential with the device's hardware [7]. Because it is based on the same technology as Windows Hello for Business, it serves as a highly secure, phishing-resistant credential [7]. Furthermore, relying on the built-in Secure Enclave saves organizational costs by removing the need to purchase and manage external physical security keys [7]. 

To lock this down even further, administrators can enable the `UserSecureEnclaveKeyBiometricPolicy` option, which requires users to authenticate with Touch ID every single time the Secure Enclave key is accessed to obtain a token [8, 9]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing identity and access solutions for Apple devices, remember that **Platform Credential for macOS (Secure Enclave)** is the native, passwordless, hardware-bound method for Macs [5, 6]. It provides a seamless, phishing-resistant SSO experience to Microsoft Entra resources without the dependency on external tokens [7].