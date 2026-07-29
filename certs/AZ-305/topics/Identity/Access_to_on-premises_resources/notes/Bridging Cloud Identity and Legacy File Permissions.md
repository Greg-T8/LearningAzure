# Bridging Cloud Identity and Legacy File Permissions

It is very common to assume that a modern cloud-brokered connection fully translates cloud identity directly into legacy file permissions. However, this question tests a fundamental security concept for the AZ-305 exam: the strict architectural boundary between **network reachability** and **resource authorization**.

Here is a detailed breakdown of why your answer was incorrect and how Windows access control integrates with Zero Trust solutions:

**1. The Limit of Private Access (Why your answer was incorrect)**
Microsoft Entra Private Access establishes identity-aware Zero Trust Network Access (ZTNA) to private TCP and UDP destinations, such as an SMB server on port 445 [1, 2]. However, the private network connector merely authorizes the *network flow* to that destination [2]. It does not perform protocol translation to magically convert Entra claims into SMB permission bits, nor does it alter NTFS ACLs or bypass the target server's native authentication [2]. 

**2. The Final Authorization Decision (Why the correct answer is right)**
Once Private Access successfully routes the user's traffic securely to the on-premises Windows file server, standard Windows Access Control takes over [3, 4]. Windows represents users and groups with Security Identifiers (SIDs) [3]. To determine the final authorization decision, the target Windows server evaluates the authenticated user's SIDs against the file or folder's Access Control List (ACL) [3]. It is these native NTFS and Share ACLs—not the cloud connector—that actually dictate if the user has "Read," "Write," or "Modify" permissions [3, 5].

**Architectural Takeaways for the AZ-305 Exam:**
When designing hybrid access to on-premises resources like SMB shares or legacy applications, always separate the design into two independent security gates:
*   **The Path (Network Admission):** Use **Microsoft Entra Private Access** (or a VPN) to dictate *who is allowed to route traffic* to the server [4, 5].
*   **The Target (Resource Authorization):** Use **AD DS security groups and Windows ACLs** to dictate *what the authenticated user may do* once connected [4, 5]. 

Always remember the golden rule for this scenario: **a private network path is not an authorization boundary for individual files** [4]. Creating a secure connection and passing Entra preauthentication never implies that the user automatically has Read/Write/Modify permissions on the back-end application [3, 6].