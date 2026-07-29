# Credential Prerequisites for Microsoft Entra Domain Services

It is very easy to fall for the "90 days" distractor because you correctly remembered a factual limitation: a Microsoft Entra Domain Services managed domain *does* enforce a default 90-day password lifetime that does not synchronize with your standard Microsoft Entra ID password policies [1, 2]. However, this 90-day expiration is an ongoing operational policy, not the technical prerequisite preventing users from authenticating immediately after the domain is deployed.

Here is a detailed breakdown of why your answer was incorrect and the underlying security architecture you need to know for the AZ-305 exam:

**1. The Core Security Limitation (Why the correct answer is right)**
To authenticate users on a managed domain, Microsoft Entra Domain Services relies on legacy Active Directory protocols and explicitly requires password hashes in **NTLM and Kerberos formats** [3, 4]. 

By default, Microsoft Entra ID does not generate or store password hashes in these legacy formats [3, 4]. Furthermore, because Microsoft Entra ID never stores user passwords in clear-text, it is mathematically impossible for the platform to retroactively generate these NTLM and Kerberos hashes from your users' existing cloud credentials once you turn Domain Services on [3-5]. 

**2. The Fix: Why SSPR or Sync is Required**
Because the managed domain has no legacy hashes to work with upon creation, no one can log in. You must force the system to capture the passwords so it can generate the correct hashes. How you do this depends on the user type:

*   **For Cloud-Only Users (SSPR/Password Change):** Users that existed in the cloud before Domain Services was enabled must change their password or use self-service password reset (SSPR) [6-8]. By forcing the user to type in a new password, Microsoft Entra ID captures the input, generates the required NTLM and Kerberos hashes, and stores them for managed-domain authentication [6-8]. 
*   **For Hybrid Users (Password Hash Synchronization):** If your users originate from an on-premises Active Directory, you do not need to force a password reset. Instead, you must configure Microsoft Entra Connect to explicitly synchronize the legacy NTLM and Kerberos password hashes from your on-premises domain up into Microsoft Entra ID [6, 9, 10].

**Architectural Takeaway for the AZ-305 Exam:**
When designing a lift-and-shift migration that requires Microsoft Entra Domain Services, remember that simply enabling the service does not instantly grant access. You must account for the **credential prerequisite**: you will have to instruct existing cloud-only users to change their passwords, or you must update your Microsoft Entra Connect configuration to sync legacy hashes for hybrid users [11].