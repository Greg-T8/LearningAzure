# Architecting Group Access for Azure External Tenants

Great job on selecting the correct answer! Your choice correctly identifies an important architectural constraint when managing customer identities and their access to applications.

Here is a detailed breakdown of what this limitation means, how it impacts your design, and related concepts you should know for the AZ-305 exam:

**1. The Nested Group Limitation**
When designing an authorization strategy, you might want to use groups to manage access to your applications. However, nested groups (placing one group inside another group) are unsupported in external tenants [1]. Because of this limitation, your group-based application assignment design must be adjusted to accommodate a flat structure rather than a hierarchical one [1]. 

**2. Impact on Application Assignment**
When you assign a group to an enterprise application to grant access, that assignment applies **only to the direct members of the group** and does not cascade down to nested groups [2]. This means if you place "Group B" inside "Group A", and assign "Group A" to your application, the users inside "Group B" will not successfully inherit access to the app [2]. It is also worth noting that this specific limitation regarding nested groups and application assignment applies to standard workforce tenants as well [3, 4]. 

**3. The CIAM Context**
External tenants are specialized directories designed exclusively for Customer Identity and Access Management (CIAM) scenarios (consumers and business customers) [5]. Because they are tailored for external-facing apps, support for traditional Microsoft Entra groups and application roles is actively being phased into these customer tenants [6]. This means you must design your access control mechanisms using the currently supported, simplified capabilities rather than relying on deep, complex group hierarchies.

**4. App Roles as a Design Alternative**
Because of the limitations associated with groups (including lack of nesting and potential token size limits if a user belongs to too many groups), Microsoft often recommends using **App Roles** as the preferred authorization solution [7]. 
*   **Groups** are tenant-wide and can be used across multiple applications, but they require flat assignments to work correctly for app access [2, 8]. 
*   **App Roles** are specific to a single application and are defined directly in the app's registration [8, 9]. They provide the simplest programming model for Role-Based Access Control (RBAC), move seamlessly with the application, and avoid the complexities of group management [9]. 

**Architectural Takeaway for the Exam:**
When designing an application access strategy for an external tenant, you cannot rely on nested group hierarchies to inherit permissions [1]. You must either design a **flat security group structure** where users are directly assigned to the group mapped to the application [2], or implement **App Roles** to manage access directly within the application's definition [7].