# Configuring macOS Platform SSO with Secure Enclave Passkeys

Your choice of exporting a certificate from the Keychain is a very logical guess if you are thinking about traditional Certificate-Based Authentication (CBA), where certificates must be trusted by the browser. However, macOS Platform Single Sign-On (PSSO) using the Secure Enclave relies on modern passkey (FIDO2) architecture rather than traditional exportable certificates. 

Here is a detailed breakdown of why your answer was incorrect and how you actually configure this feature on macOS:

**1. Why exporting a certificate is incorrect**
When you register a Mac using the **Secure Enclave** authentication method, Microsoft Entra provisions a hardware-bound cryptographic key that is backed directly by the Mac's secure enclave chip [1]. Because this credential is intentionally hardware-bound to protect it from theft and phishing, the private key material cannot be exported from the device [1]. Furthermore, modern browsers like Safari rely on the operating system's native credential provider extensions to handle passkeys, rather than manually importing files into a standalone certificate store.

**2. Why enabling "Company Portal" is the correct answer**
To use that hardware-bound Secure Enclave key as a passkey in your web browsers (like Safari), you must tell the macOS operating system which application is allowed to supply passkeys to the browser. 

In a PSSO deployment, the Microsoft Intune **Company Portal** acts as the credential provider extension. Therefore, the final required configuration step is to open the macOS Settings app (typically under **Passwords > Password options** or **General > AutoFill & Passwords**, depending on the macOS version) and toggle the switch to enable **Company Portal** as an active passkey/autofill provider [2, 3]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing a passwordless experience for macOS users, remember that Platform SSO natively integrates with Apple's credential provider framework. By enabling the Company Portal to provide passkeys, you allow users to seamlessly authenticate to Microsoft Entra web applications in Safari using Touch ID, completely fulfilling Zero Trust, phishing-resistant requirements without requiring users to manage physical security keys [1, 2].