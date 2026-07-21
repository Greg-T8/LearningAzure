# Architecting Passkey Authentication for Microsoft Entra External ID

Great job on selecting the correct answer! You have successfully identified a specific architectural constraint when designing modern, passwordless authentication for customer-facing applications in Microsoft Entra External ID.

Here is a detailed breakdown of why local accounts are required for passkeys in external tenants, along with other prerequisites you should know for the AZ-305 exam:

**1. The Local Account Requirement**
Currently, within a Microsoft Entra external tenant, **only users with local accounts (email-and-password or username-and-password) can register and use passkeys** [1, 2]. If a customer authenticates using a federated social identity provider (like Google or Facebook) or uses Email One-Time Passcode (OTP) as their primary sign-in method, they are currently prevented from enrolling in a passkey [3-5]. 

**2. Additional Prerequisites for Passkeys in External Tenants**
To successfully implement passkeys for your consumers, having a local account is just the first step. Your architecture must also include:
*   **A Custom URL Domain:** Passkey registration requires your external tenant to have a custom URL domain configured [1]. Because passkeys are cryptographically bound to a specific domain (the relying party), your custom URL acts as that secure anchor [2].
*   **Prior MFA Completion:** Customers cannot register a passkey using just their username and password. They must successfully complete a multifactor authentication (MFA) prompt before they are allowed to register the passkey [1, 2]. 
*   **Compatible Devices:** The customer must be using a WebAuthn-capable browser and device to generate and store the FIDO2 credential [2].

**Architectural Takeaway:**
When designing a Customer Identity and Access Management (CIAM) solution for the AZ-305 exam, remember the cascading dependencies of your authentication choices. If the business requires **phishing-resistant, passwordless sign-in (passkeys)** for consumers, you **cannot** design the primary sign-in flow to use Email OTP or social logins [3, 5]. You must architect the solution to use **local password-based accounts, configure a custom URL domain, and enforce an MFA step** [1, 3].