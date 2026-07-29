# Architecting Identity Solutions: Entra Domain Services vs. Self-Managed AD

Your choice of Microsoft Entra Domain Services is a great guess because it is the standard recommendation for lifting and shifting legacy applications that require traditional protocols like Kerberos, NTLM, or LDAP into Azure without the burden of managing virtual machines [1, 2]. However, this managed service has strict administrative boundaries.

Here is a detailed breakdown of why your answer was incorrect and the specific architectural limitations you must remember:

**1. No Schema Extensions**
Microsoft Entra Domain Services provides a managed Active Directory environment, which means the underlying directory schema is administered entirely by Microsoft [3]. **The service does not support custom schema extensions** [2, 3]. If your legacy application installs custom schema classes or attributes, Microsoft Entra Domain Services cannot support it [2]. 

**2. No Domain Admin Privileges**
Because Microsoft deploys, patches, and manages the domain controllers to guarantee service uptime, the managed domain is strictly locked down [4, 5]. **You are never granted Domain Administrator or Enterprise Administrator privileges** in a Microsoft Entra Domain Services environment, nor do those privileges inherit from your on-premises environment [2, 5, 6]. Instead, administrators are placed in an "AAD DC Administrators" group, which only grants delegated privileges to perform specific tasks like configuring Group Policy and managing custom Organizational Units (OUs) [7, 8].

**Architectural Takeaway for the AZ-305 Exam:**
When designing identity solutions for legacy applications, look out for these specific keywords to differentiate between the two services:
*   If a scenario requires "no domain controllers to manage" alongside legacy protocols (LDAP/Kerberos/NTLM), **Microsoft Entra Domain Services** is the correct choice [9]. 
*   If the business requirements explicitly demand **custom AD schema extensions, full Domain Admin/Enterprise Admin control, or unsupported trust behaviors, you must architect the solution using Self-managed AD DS on Azure Virtual Machines** (or extend an existing on-premises domain) [9-11]. 

This self-managed approach provides full traditional domain capability and complete administrative control, but you must accept the operational tradeoffs of deploying, patching, securing, and backing up those domain controllers yourself [11, 12].