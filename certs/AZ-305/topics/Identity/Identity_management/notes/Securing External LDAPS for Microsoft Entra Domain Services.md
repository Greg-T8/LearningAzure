# Securing External LDAPS for Microsoft Entra Domain Services

Great job on selecting the correct answer! This question tests your knowledge of how to securely expose legacy directory protocols when an application resides outside of your managed Azure environment.

Here is a detailed breakdown of why this configuration is required, the security risks involved, and what you should remember for your AZ-305 exam designs:

**1. The Risk of Standard LDAP**
By default, standard Lightweight Directory Access Protocol (LDAP) traffic is unencrypted [1, 2]. Because your legacy application is located outside the Azure virtual network, its authentication requests and directory queries would have to travel over the public internet. Transmitting unencrypted identity data over the internet is a severe security vulnerability.

**2. Securing the Traffic (LDAPS and Port 636)**
To safely query the directory from an external network, you must configure **Secure LDAP (LDAPS)**, which encrypts the traffic using Transport Layer Security (TLS) or Secure Sockets Layer (SSL) [2]. Secure LDAP natively operates on **TCP port 636** [1, 3]. 

To enable this feature, you must upload a digital certificate (specifically a `.PFX` file that contains the private key) to your Microsoft Entra Domain Services managed domain so it can decrypt the incoming secure traffic [1, 4]. 

**3. The Critical Security Boundary (NSG Lockdown)**
Simply enabling Secure LDAP is not enough when dealing with external applications. You must explicitly toggle the setting to **Allow secure LDAP access over the internet** [5, 6]. 

However, exposing TCP port 636 to the public internet immediately makes your managed domain susceptible to password brute-force attacks [3, 5]. To mitigate this threat, it is an absolute requirement to configure an inbound **Network Security Group (NSG)** rule [1, 3, 5]. This rule must explicitly restrict access to TCP port 636 so that only the specific, known source IP addresses of your external application can reach the domain [1, 3, 7]. All other internet traffic to that port should be denied by a default lower-priority rule [7].

**Architectural Takeaway for the AZ-305 Exam:**
When designing a solution for legacy applications that need to bind to or read from Microsoft Entra Domain Services, remember these boundaries:
*   **Internal vs. External:** If the application is inside the peered Azure virtual network, standard LDAP might technically function, but LDAPS is still recommended. If the application is *outside* the virtual network, LDAPS over port **636** is mandatory [1, 3].
*   **Certificates:** You cannot use a certificate from a public Certificate Authority (CA) if you kept the default `.onmicrosoft.com` domain name, because Microsoft owns that domain [1, 8, 9]. Public LDAPS requires you to configure a custom, routable DNS domain name [1, 8].
*   **Zero Trust:** Never leave port 636 open to the entire internet (`*`). Always lock it down to explicit source IPs via NSGs [1, 3, 7].