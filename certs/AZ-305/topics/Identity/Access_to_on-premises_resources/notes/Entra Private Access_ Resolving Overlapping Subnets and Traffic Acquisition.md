# Entra Private Access: Resolving Overlapping Subnets and Traffic Acquisition

It is easy to get tripped up by this question, as overlapping IP subnets are a classic networking challenge, and "Source IP restoration" sounds like a network routing feature. However, this question tests your knowledge of specific traffic acquisition boundaries within the Global Secure Access client.

Here is a detailed breakdown of why your answer was incorrect and the architectural rules you must remember for the AZ-305 exam:

**1. The Local Subnet Limitation (Why the correct answer is right)**
Microsoft Entra Private Access relies on the Global Secure Access client to acquire network traffic on the user's device and route it to the cloud. However, there is a strict limitation: **IP-based tunneling works only when the destination IP range is outside of the endpoint's local subnet** [1]. 

If an organization's internal server uses the `192.168.1.0/24` subnet, and a remote user's home Wi-Fi network uses that exact same `192.168.1.0/24` subnet, an IP-based application segment will fail. The user's device will assume the traffic is meant for their local home network and will not send it to the Global Secure Access tunnel. 

To overcome this, you must **use Fully Qualified Domain Names (FQDNs)** for your application segments rather than IP addresses [1]. When the user requests the FQDN (e.g., `server.contoso.com`), the Global Secure Access client intercepts the DNS request and routes the traffic through the secure tunnel, completely bypassing the local IP routing conflict.

**2. Why Source IP Restoration is incorrect**
**Source IP restoration** has nothing to do with how traffic is routed from a user's device. When traffic flows through the Microsoft Security Service Edge (SSE), downstream services typically only see the proxy's IP address. Source IP restoration is a feature that extracts the user's original public IP address and securely passes it to Microsoft Entra ID so that sign-in logs and IP-based Conditional Access policies remain accurate [2, 3]. 

Furthermore, the distractor mentions configuring this on a "remote network." This is a double trap, as Microsoft Entra Private Access currently **only supports traffic acquisition via the installed Global Secure Access client**, and cannot acquire traffic from a branch router or remote network [1]. 

**Architectural Takeaways for the AZ-305 Exam:**
When designing Microsoft Entra Private Access, keep these client acquisition boundaries in mind:
*   **The Overlap Rule:** If a private resource's IP overlaps with the end-user's local network, you **must use FQDNs** instead of IP addresses to successfully acquire the traffic [1].
*   **The DNS Requirement:** To successfully use FQDN-based traffic acquisition, the endpoint's browser must have **DNS over HTTPS (Secure DNS) disabled** [1].
*   **The IPv6 Limitation:** The Global Secure Access client only tunnels IPv4 traffic. IPv6 traffic is sent directly and bypasses the tunnel [1].