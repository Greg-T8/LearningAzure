# Architectural Guide to Microsoft Entra Backup and Recovery

Great job on selecting the correct answer! You correctly identified the retention boundary for the built-in Microsoft Entra Backup and Recovery service.

Here is a detailed breakdown of how this service works, what it covers, and the architectural boundaries you should keep in mind for your designs:

**1. How Entra Backup and Recovery Works**
Microsoft Entra Backup and Recovery is an always-on feature that **automatically backs up supported directory objects once per day and retains that history for up to 7 days** [1, 2]. Administrators cannot disable, modify, or delete these Microsoft-managed backups [1]. If an accidental change, deletion, or misconfiguration occurs, administrators can generate "difference reports" to see exactly what changed (such as attribute edits or link changes) and quickly run a recovery job to restore the object to its prior point-in-time state [1-3]. 

**2. The 7-Day Backup vs. The 30-Day Soft Delete**
For the AZ-305 exam, it is highly important to understand the difference between the 7-day backup and the 30-day soft-delete cycle. 
*   **The 7-day backup** provides point-in-time recovery for rolling back configuration changes and recovering supported items to their exact prior state within that short window [4, 5].
*   **The 30-day soft delete** acts as a recycle bin specifically for certain deleted objects, such as users, Microsoft 365 groups, cloud security groups, service principals, and application registrations [1, 6]. If a user is deleted, they remain in this suspended state for 30 days before being permanently (hard) deleted [1, 7]. 

These two systems complement each other, but the 7-day backup history does not extend the 30-day soft-delete limit [1].

**3. Architectural Requirements and Limitations (The Gotchas)**
Do not assume that the existence of daily Entra backups makes every directory object perfectly recoverable [4]. When designing a recovery strategy, you must account for these strict limitations:
*   **Licensing and Tenant Type:** The service **requires a workforce tenant with Microsoft Entra ID P1 or P2 licenses** [1]. It explicitly does not support External ID or Azure AD B2C tenants [1, 8].
*   **Hard-Deleted Objects:** Once an object is permanently hard-deleted (either manually by an admin or automatically after the 30-day soft-delete window), it **cannot be recovered** by the Backup and Recovery service [1, 9]. It must be fully recreated from scratch [10].
*   **Source of Authority:** The service can only restore cloud-authoritative objects [4]. If a user or group is synchronized from an on-premises Active Directory Domain Services (AD DS) environment, **they cannot be restored through Entra Backup and Recovery** [1, 8]. You must recover those objects directly from your on-premises AD DS backups or Active Directory recycle bin [1, 4, 8]. 
*   **Unsupported Links:** While static group memberships can be successfully recovered, the service does not currently support recovering group-owner, manager, or sponsor links [1].