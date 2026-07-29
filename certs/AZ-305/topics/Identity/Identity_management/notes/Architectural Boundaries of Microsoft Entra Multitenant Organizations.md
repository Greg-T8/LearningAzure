# Architectural Boundaries of Microsoft Entra Multitenant Organizations

Great job on selecting the correct answer! This question tests your knowledge of the scale limits and architectural boundaries of a **Multitenant Organization (MTO)**.

Here is a detailed breakdown of the service limits, how MTOs function, and the architectural patterns you should remember for your AZ-305 exam designs:

**1. The 100-Tenant Boundary and Cloud Limits**
An MTO is designed to group multiple Microsoft Entra tenants together, but it has strict scale limits. It can contain a maximum of **100 active tenants**, which includes the owner tenant [1, 2]. While an owner tenant can invite more than 100 *pending* tenants, those extra tenants will be blocked from joining the MTO once the 100-tenant active limit is reached [2]. Additionally, a single tenant can only create or join **one** MTO [1]. 

Furthermore, all tenants in an MTO must reside in the **same cloud**; cross-tenant synchronization is not currently supported across different Microsoft sovereign clouds (such as Microsoft 365 US Government or Office 365 in China) [3, 4].

**2. Why Architect an MTO?**
Microsoft strongly recommends using a single tenant whenever possible, as multiple tenants duplicate directory objects, policies, administrative overhead, and monitoring [5, 6]. However, creating an MTO is the recommended pattern when a single tenant is impossible due to mergers, acquisitions, divestitures, or strict regulatory and sovereignty constraints that demand isolated boundaries [7, 8]. 

**3. Cross-Tenant Synchronization Mechanics**
To automate user lifecycle management across the MTO, administrators use **cross-tenant synchronization**, which is built on the Entra application provisioning engine [1]. 
*   It operates as a **source-initiated push**, running at fixed **40-minute** intervals [1].
*   It synchronizes **internal member users** from the source tenant into the target tenant, creating them as external members or external guests [1]. 
*   It is exclusively for workforce users; it does not synchronize source-tenant guests, contacts, or devices [1].

**4. Common MTO Topologies**
When designing an MTO, you generally choose between two collaboration topologies to dictate how users and resources are shared:
*   **Mesh topology:** Every user in each home tenant synchronizes to *all* other tenants in the MTO [9]. This enables the sharing of applications across all companies and creates a unified Global Address List (GAL) in every tenant [9-11].
*   **Single resource tenant topology:** Users from multiple subsidiary tenants synchronize into one central resource tenant [12]. Shared applications must reside in that single resource tenant, and only that central tenant's GAL will display users from all the connected companies [10-12].

**Architectural Takeaway for the AZ-305 Exam:**
When designing identity solutions, remember that an MTO does **not** merge directories or migrate data [13, 14]. Each tenant retains its own separate objects, policies, roles, and resources [13]. The synchronization simply creates managed external representations of your employees so they can seamlessly collaborate [13].

If an exam scenario asks how to handle collaboration among *unrelated* supplier or partner organizations, do not recommend an MTO or cross-tenant synchronization; you must use standard **B2B collaboration or entitlement management** instead [13, 15]. Use an MTO strictly for related workforce tenants operating within a single enterprise [13, 16].