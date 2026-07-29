# Architecting Custom Authentication Strengths in Microsoft Entra ID

Great job on selecting the correct answer! Understanding how to restrict and mandate specific authentication methods is a key part of designing secure access in Azure.

Here is a detailed breakdown of **authentication strengths** and why you would configure custom ones up to that 15-policy limit:

**1. What are Authentication Strengths?**
An authentication strength is a **Microsoft Entra Conditional Access control** that specifies exactly which combinations of authentication methods a user is allowed to use to access a specific resource [1]. Instead of just requiring a generic "MFA" claim—which could be satisfied by weaker methods like an SMS text message—an authentication strength ensures that the user authenticates with an approved, secure method [2]. 

**2. Built-in vs. Custom Strengths**
Microsoft Entra ID provides three pre-defined, built-in authentication strengths: **Multifactor authentication, Passwordless MFA, and Phishing-resistant MFA** [3]. These built-in strengths are always available and cannot be modified [3]. 

However, if these built-in options do not perfectly match your organization's security or compliance needs, an administrator can create up to **15 custom authentication strengths** per tenant to exactly suit their requirements [4].

**3. Why use a Custom Authentication Strength?**
Custom strengths allow you to define highly specific access requirements that go beyond the built-in defaults. Common advanced scenarios include:
*   **Restricting Passkeys (FIDO2) by Manufacturer:** You can use advanced options in a custom strength to restrict passkeys based on their Authenticator Attestation GUIDs (AAGUIDs) [5]. This allows you to mandate that users only use a hardware FIDO2 security key issued by a specific, company-approved manufacturer to access sensitive resources [5].
*   **Certificate-Based Authentication (CBA) Restrictions:** You can require users to authenticate using a certificate from a specific certificate issuer or matching a specific policy Object Identifier (OID) [6]. For example, if your organization issues different smart cards for "secret" versus "top-secret" clearance, a custom strength can enforce that only the "top-secret" certificate can be used to access highly classified applications [6].
*   **Targeted Frontline Worker Scenarios:** You can create a custom strength that explicitly requires a specific single-factor method, such as a **QR code**, for a targeted group of frontline workers [7].

**Architectural Takeaways:**
When designing your identity solutions, remember that using Conditional Access to enforce authentication strengths requires at least a **Microsoft Entra ID P1 license** [8]. Furthermore, an authentication strength does not restrict a user's initial authentication; it is evaluated by Conditional Access *after* the initial sign-in to determine if the methods the user provided actually satisfy the resource's strict requirements [9].