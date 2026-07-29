# Architecting Entra Private Access and Client Requirements

Great job on selecting the correct answer! This question tests your understanding of traffic acquisition methods within the Global Secure Access platform and the specific limitations of the Microsoft Entra Private Access profile.

Here is a detailed breakdown of why Private Access requires the client, why branch-level network routing cannot solve this, and what you need to remember for the AZ-305 exam:

**1. The Strict Client Dependency**
To route traffic to your private, on-premises resources using Microsoft Entra Private Access, the network traffic must be acquired by the **Global Secure Access client** running on the user's endpoint device [1]. Currently, the Private Access traffic forwarding profile *only* supports client-based acquisition [2]. Furthermore, installing the Global Secure Access client on Windows strictly requires local administrator permissions [1, 3]. Because the branch users in this scenario lack the necessary rights to install the client, they cannot use the service.

**2. Why "Remote Networks" Cannot Bypass This Limitation**
Global Secure Access does offer a feature called "remote networks," which allows an organization to build an IPsec or GRE tunnel from a branch office router directly to Microsoft's Security Service Edge (SSE) [4, 5]. This allows for "clientless" traffic acquisition for any device sitting on that branch network [6]. 

However, there is a hard boundary: **the Private Access traffic forwarding profile is not supported on remote networks** [7]. While you can assign the *Microsoft traffic* and *Internet Access* profiles to a branch remote network to secure internet-bound traffic, *Private Access* strictly requires the Global Secure Access client to be installed on the end-user's device [8]. 

**Architectural Takeaways for the AZ-305 Exam:**
When designing a Zero Trust Network Access (ZTNA) or VPN replacement solution, pay close attention to the endpoint constraints:
*   **The Client Rule:** Microsoft Entra Private Access traffic currently requires the Global Secure Access client [1, 9]. If an exam scenario explicitly states that devices cannot have agents installed (such as IoT devices, printers, or locked-down contractor laptops), Private Access cannot be used to reach those non-web private resources.
*   **Branch-Only Access:** If a scenario requires providing access to private corporate resources from a branch location *without* endpoint clients, you must retain a traditional VPN, SD-WAN, or another supported access path, as Global Secure Access remote networks do not currently support the Private Access profile [2, 9].
*   **The Web App Alternative:** If you must securely publish an HTTP/HTTPS web application to users who cannot install a client, you should recommend **Microsoft Entra application proxy** instead, which provides clientless, browser-based remote access [10, 11].