# Legacy Authentication Bridging in Hybrid Entra Environments

Great job on selecting the correct answer! This question tests your understanding of how legacy authentication protocols operate within Azure's modern cloud identity boundaries. 

Here is a detailed breakdown of why configuring password hash synchronization in Microsoft Entra Connect is mandatory for this hybrid scenario:

**1. The Requirement for Legacy Hashes**
Microsoft Entra Domain Services is designed to support legacy application workloads that rely on traditional **NTLM and Kerberos authentication** [1, 2]. In order to authenticate users using these protocols, Domain Services requires password hashes in a very specific, legacy format [3, 4].

**2. The Missing Hashes in Entra ID**
For security reasons, Microsoft Entra ID never stores user passwords in clear-text, and by default, it does not automatically generate or store password hashes in the format required for NTLM or Kerberos [3, 5]. Therefore, if you simply synchronize an on-premises Active Directory environment without extra configuration, Microsoft Entra Connect will not synchronize these legacy hashes, and Microsoft Entra ID will not possess the necessary credential data to pass down to the Domain Services managed domain [6].

**3. The Role of Microsoft Entra Connect**
To bridge this gap in a hybrid environment, you must explicitly configure **Microsoft Entra Connect** to perform password hash synchronization for these legacy hashes [6]. Once enabled, Entra Connect securely extracts the NTLM and Kerberos hashes from your on-premises domain controllers, encrypts them, and transmits them to the cloud [7-9]. Microsoft Entra ID then pushes this data down to your Domain Services domain controllers so that your users can authenticate successfully [10, 11].

**Architectural Takeaways for the AZ-305 Exam:**
*   **Tool Limitation:** This legacy password hash synchronization is only supported by the traditional **Microsoft Entra Connect Sync** client (specifically version 1.1.614.0 or later) [12, 13]. You explicitly **cannot** use the newer Microsoft Entra Cloud Sync or the legacy DirSync tool to synchronize accounts for use with Domain Services [12, 14].
*   **Cloud-Only Users:** If the exam presents a scenario with *cloud-only* users (users created directly in Entra ID rather than synchronized from on-premises), password hash synchronization via Entra Connect does not apply. Instead, those cloud-only users must explicitly **change or reset their passwords** so that Entra ID can generate and store the NTLM and Kerberos hashes required for Domain Services authentication [12, 15, 16].