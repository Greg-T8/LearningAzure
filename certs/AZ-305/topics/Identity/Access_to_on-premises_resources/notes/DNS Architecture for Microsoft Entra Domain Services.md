# DNS Architecture for Microsoft Entra Domain Services

It is completely understandable why you might guess the default `.onmicrosoft.com` domain, as it is automatically provided and requires no upfront DNS registration to deploy. However, for real-world and production workloads, relying on this default choice introduces a hard architectural limitation regarding security.

Here is a detailed breakdown of why your answer was incorrect and the DNS naming rules you must remember for the AZ-305 exam:

**1. Why the ".onmicrosoft.com" default is incorrect**
The primary issue with the default built-in domain is certificate validation for **Secure LDAP (LDAPS)**. If you ever need to enable secure LDAP access to your managed domain over the internet, you must secure that connection with a digital certificate [1]. Because Microsoft owns the `.onmicrosoft.com` domain, a public Certificate Authority (CA) will never issue a certificate for it [1, 2]. Without a trusted certificate, you cannot implement public-facing secure LDAP. 

**2. Why a "custom, routable domain" is correct**
Specifying a custom domain name that you already own is the most common and Microsoft-recommended approach [1]. Because your organization officially owns the domain, you can easily obtain a valid TLS/SSL certificate from a public CA to secure your LDAP traffic [2, 3]. Furthermore, using a routable custom domain ensures that network traffic can correctly flow and resolve as needed to support your integrated applications [1].

**3. The danger of non-routable suffixes**
You might also see exam options suggesting a non-routable suffix, such as `contoso.local`. Microsoft strongly recommends avoiding `.local` domains [1]. Because they are not routable across the public internet, they frequently cause severe issues with DNS resolution and hybrid routing [1].

**Architectural Takeaways for the AZ-305 Exam:**
When designing the DNS namespace for a Microsoft Entra Domain Services managed domain, remember these strict boundaries:
*   **The Certificate Boundary:** Avoid the default `.onmicrosoft.com` domain if you will ever need public Secure LDAP, because you cannot obtain a trusted public certificate for a domain you do not own [1, 2].
*   **The Routability Boundary:** Always use a custom, routable domain name that your organization owns [1]. Avoid `.local` suffixes [1].
*   **The Length Limit:** You cannot create a managed domain with a prefix longer than **15 characters** [4]. For example, if your domain is `thisisareallylongname.com`, it will fail because the prefix exceeds the legacy NetBIOS 15-character limit [4].
*   **The Conflict Boundary:** Ensure the DNS domain name you choose doesn't already exist on the Azure virtual network or on a connected on-premises network via VPN/ExpressRoute, as this will cause a name conflict [4, 5].