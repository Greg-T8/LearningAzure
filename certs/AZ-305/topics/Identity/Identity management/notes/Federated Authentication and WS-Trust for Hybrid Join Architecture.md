# Federated Authentication and WS-Trust for Hybrid Join Architecture

Great job on selecting the correct answer! This question tests your knowledge of how device identities interact with on-premises federation infrastructure during the hybrid join process.

Here is a detailed breakdown of why this endpoint is necessary, the strict security boundaries surrounding it, and what you should remember for your AZ-305 exam designs:

**1. The Role of WS-Trust and `windowstransport`**
In a federated Microsoft Entra configuration, Windows 10 and Windows 11 devices rely on AD FS (or a compatible third-party federation service) to authenticate to Microsoft Entra ID [1, 2]. To accomplish this, Windows devices authenticate by using Integrated Windows Authentication (IWA) against an active WS-Trust endpoint hosted by your on-premises federation service [3]. The `/adfs/services/trust/2005/windowstransport` endpoint (along with its `13/windowstransport` counterpart) is explicitly required to handle this native, seamless device authentication [4, 5].

**2. The Critical Security Boundary (The Extranet Gotcha)**
While enabling this endpoint is mandatory for hybrid join in an AD FS environment, there is a strict security limitation you must know. The `windowstransport` WS-Trust endpoints must be enabled as **intranet-facing endpoints only** [6-9]. You must **never expose these specific endpoints to the external internet** (extranet-facing) through the Web Application Proxy (WAP) [6-9]. 

**3. Other Required WS-Trust Endpoints**
Beyond just `windowstransport`, a fully functional AD FS hybrid join deployment also requires you to enable the `usernamemixed` and `certificatemixed` WS-Trust endpoints (for both the 2005 and 1.3 protocol versions) [4, 5]. If your identity provider does not support WS-Trust protocols, Microsoft Entra join will not work natively [10, 11]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing a Microsoft Entra Hybrid Join solution, remember that managed domains (which use Password Hash Sync or Pass-through Authentication with seamless single sign-on) do not require you to configure WS-Trust endpoints because they bypass the need for an on-premises federation server [10, 12, 13]. However, if the business architecture strictly dictates a **federated environment** (like AD FS), WS-Trust is an absolute prerequisite for Windows devices to authenticate and successfully register with Microsoft Entra ID [10, 14].