# Entra Private Network Connector Port Requirements for CRL Validation

It is very easy to assume that TCP 443 is the correct answer because it is the standard port for secure HTTPS traffic, and it handles almost all of the primary data flowing through the connector. However, certificate validation introduces a specific exception to this rule.

Here is a detailed breakdown of why your answer was incorrect and the specific port requirements you must remember for the AZ-305 exam:

**1. Why TCP 443 is incorrect for this specific action**
TCP port 443 (HTTPS) is indeed the primary port used by the Microsoft Entra private network connector. However, port 443 is dedicated to handling **all primary outbound communication** between the on-premises connector and the Microsoft Entra cloud services (such as the Application Proxy or Private Access services) [1, 2]. 

**2. Why TCP 80 is the correct answer**
To establish secure, trusted connections, the connector must constantly verify that the digital certificates used by Microsoft's cloud services have not been revoked. To perform this check, the connector must reach out to specific certificate authority URLs (such as `crl.microsoft.com` or `crl3.digicert.com`) to download Certificate Revocation Lists (CRLs) [3-5]. 

By industry standard design, these CRL downloads are performed over unencrypted HTTP. Therefore, the connector strictly requires **outbound TCP port 80** to be open specifically so it can successfully download these CRLs while validating the TLS/SSL certificates [1, 6]. If port 80 is blocked, the connector cannot verify the certificates, and trust establishment will fail.

**Architectural Takeaways for the AZ-305 Exam:**
When designing secure remote access using Microsoft Entra private network connectors (or Pass-through Authentication agents), memorize these network firewall boundaries:
*   **Outbound Only:** The connector functions entirely on outbound connections. You **never** need to open any inbound ports or deploy components in a perimeter network (DMZ) [7, 8]. 
*   **Port 443 (HTTPS):** Required for all outbound communication, authentication, and data tunneling with the Microsoft Entra service [1, 2].
*   **Port 80 (HTTP):** Exclusively required to download CRLs for certificate validation [1, 6].
*   **Inline Inspection:** You must avoid all forms of inline inspection or TLS termination on the outbound traffic between the connector and Azure, as this will break the certificate-based mutual authentication [9-11].