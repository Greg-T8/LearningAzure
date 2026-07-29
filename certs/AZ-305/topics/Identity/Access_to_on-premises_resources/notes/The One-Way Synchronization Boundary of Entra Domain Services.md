# The One-Way Synchronization Boundary of Entra Domain Services

It is very easy to select your answer because it actually contains a technically true statement regarding LDAP capabilities, but it does not address the fundamental architectural reason *why* the specific objects in the question cannot be modified. 

Here is a detailed breakdown of why your answer was incorrect, the underlying architecture of the managed domain, and what you must remember for the AZ-305 exam:

**1. The Core Architecture (Why the correct answer is right)**
When you deploy Microsoft Entra Domain Services, it performs a **one-way synchronization** from your Microsoft Entra tenant down into the managed domain [1-3]. Because the system is not designed to synchronize changes back up to Microsoft Entra ID, it enforces a strict rule: all synchronized users, passwords, attributes, and group memberships are strictly **read-only** inside the managed domain [2-4]. 

If you attempt to modify the `MemberOf` attribute (or reset a password) for a synchronized user using traditional Active Directory tools connected to Domain Services, the operation will fail because the managed domain recognizes that Microsoft Entra ID is the authoritative source for that object [3, 5].

**2. Why your answer was incorrect (The Distractor)**
Your answer—"LDAP write operations are only supported for objects created natively in the managed domain"—is a factual statement about Domain Services [6]. You *can* create custom Organizational Units (OUs) and natively create service accounts or groups inside them, and you are allowed to perform LDAP writes against those specific local objects [3]. 

However, this is a secondary characteristic of the service rather than the root cause. The direct reason you cannot modify the synchronized user is because the object itself is locked as read-only due to the one-way synchronization boundary [2, 3].

**Architectural Takeaways for the AZ-305 Exam:**
When designing identity management with Microsoft Entra Domain Services, memorize these strict boundaries:
*   **The One-Way Street:** Synchronization is strictly one-way from Microsoft Entra ID to Domain Services [3]. There is no write-back from Domain Services to Microsoft Entra ID [3, 5].
*   **The Read-Only Rule:** You cannot use Domain Services to change passwords, attributes, or group memberships for any user that was synchronized from Microsoft Entra ID [3, 5]. Those changes must be made at the source (in Microsoft Entra ID, or in your on-premises Active Directory if it is a hybrid environment) [7]. 
*   **Local Exceptions:** You can only perform LDAP writes or edit objects if you manually created those objects directly inside a custom OU within the managed domain [3, 6].