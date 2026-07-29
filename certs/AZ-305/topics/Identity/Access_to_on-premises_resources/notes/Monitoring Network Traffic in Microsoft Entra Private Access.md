# Monitoring Network Traffic in Microsoft Entra Private Access

It is very easy to assume that Entra ID sign-in logs are the single source of truth for all access monitoring, as they act as the front door for authentication. However, there is a strict architectural boundary between logging an identity authentication and logging continuous network traffic. 

Here is a detailed breakdown of why your answer was incorrect and the specific logging boundaries you must remember for your AZ-305 exam preparation:

**1. Why "Entra ID sign-in logs" is incorrect for this specific requirement**
**Microsoft Entra sign-in logs** are exclusively designed to capture the initial authentication attempts of your users and client applications [1]. They answer the questions of *who* performed the sign-in, *how* they authenticated, and whether they successfully satisfied your Conditional Access and MFA policies [2]. However, once the user is authenticated, the sign-in logs do not track the ongoing network connections or the specific internal server IPs and ports the user communicates with. 

**2. Why "Global Secure Access traffic logs" is the correct answer**
Microsoft Entra Private Access routes your private network traffic through Microsoft's Security Service Edge (SSE) [3, 4]. To audit the actual network flows to your on-premises resources, you must look at the **Global Secure Access traffic logs** [5]. 

These logs provide transaction-level and connection-level visibility into every network request that flows through the Private Access service [6, 7]. They show exactly who accessed what traffic, from where, to where, and with what result [5]. You can use these logs to see the specific destination FQDNs, IP addresses, ports, bytes sent and received, and whether the traffic was tunneled, bypassed, or blocked by a policy [6-8].

**3. What about "administrative actions"?**
The scenario in your question mentions wanting to ensure *all administrative actions are logged*. While traffic logs track the users' network connections to the private applications, any administrative changes made to the configuration of Microsoft Entra Private Access itself (such as creating application segments, modifying traffic forwarding profiles, or changing connector groups) are recorded in the **Microsoft Entra audit logs** [9, 10]. 

**Architectural Takeaways for the AZ-305 Exam:**
When designing a monitoring and logging solution for Microsoft Entra Private Access, memorize these three distinct log sources:
*   Use **Sign-in logs** to monitor the *authentication phase* (e.g., Did the user successfully pass MFA and Conditional Access?) [1, 2].
*   Use **Global Secure Access traffic logs** to monitor the *network phase* (e.g., Which specific private servers, IPs, or ports did the user actually connect to over the tunnel?) [5, 7].
*   Use **Audit logs** to monitor the *control-plane phase* (e.g., Which administrator modified the Private Access application segments or forwarding policies?) [9].