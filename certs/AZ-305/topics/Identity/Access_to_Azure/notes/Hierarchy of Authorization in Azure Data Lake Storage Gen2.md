# Hierarchy of Authorization in Azure Data Lake Storage Gen2

Great job on selecting the correct answer! This question tests a highly specific and critical concept for the AZ-305 exam: the authorization evaluation order in Azure Data Lake Storage Gen2. 

Here is a detailed breakdown of why the user retains full access despite the restrictive ACL, and what you need to remember about this architecture:

**1. The Evaluation Order**
When a user attempts to access data in a Data Lake Storage Gen2 environment, the system evaluates permissions in a strict sequence: **Azure RBAC and ABAC conditions are evaluated first, and POSIX ACLs are evaluated second** [1]. 

**2. Why the ACL is Bypassed**
Because the user in this scenario was granted the **Storage Blob Data Owner** role at the storage account scope, they inherently have full data-plane access to every container, directory, and file within that entire account [1, 2]. 

When the system performs its authorization check, it sees that the Azure RBAC role already grants sufficient access for the operation. Because the RBAC check succeeds, **the authorization process immediately stops and grants access, completely bypassing the ACL evaluation** [1, 3]. An ACL simply cannot subtract or restrict access that was already granted by a matching RBAC assignment [3].

**Architectural Takeaway for the AZ-305 Exam:**
When designing a fine-grained access control model for Data Lake Storage Gen2, you cannot use POSIX ACLs to override broad Azure RBAC grants [4]. 

If your scenario requires you to use directory-level or file-level ACLs to explicitly restrict users from certain folders, you must **narrow the RBAC grant first** [3, 5]. For example, instead of granting users the broad *Storage Blob Data Contributor* or *Owner* roles at the account or container level, you would rely on ACLs to build out their specific read/write/execute permissions folder-by-folder.