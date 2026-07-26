# Azure Lighthouse Licensing for Privileged Identity Management

It is completely understandable why you might guess that the customer tenant needs the license. Since the customer owns the resources being protected, it feels logical that their tenant would need the premium licensing to enforce Just-In-Time (JIT) access. However, Azure Lighthouse shifts where that identity management occurs.

Here is a detailed breakdown of why your answer was incorrect and how eligible authorizations are licensed for your AZ-305 exam preparation:

**1. The Role of the Managing Tenant**
When you use Azure Lighthouse, the users, groups, and identities that manage the resources all reside in the **managing tenant** (the service provider or central enterprise IT tenant). To implement JIT elevation for these users, Azure Lighthouse utilizes Microsoft Entra Privileged Identity Management (PIM) [1]. Because the identities and the activation workflows occur within the managing tenant, the managing tenant is the one that must hold the valid PIM-capable license, which is either **Microsoft Entra ID P2 or Microsoft Entra ID Governance** [1-3].

**2. Why the Customer Tenant is Spared**
The customer's tenant is merely delegating access to the resources; it is not processing the PIM activations for the service provider's staff. Because of this architecture, the premium licensing requirement applies **only** to the source (managing) tenant [3]. You do not need to force every single customer to purchase Microsoft Entra ID P2 licenses just so your staff can use JIT access to manage their environments. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing Azure Lighthouse solutions that require JIT elevation (eligible authorizations), remember these specific constraints:
*   **Licensing:** The **managing tenant** must have the Microsoft Entra ID P2 or Governance license [1-3].
*   **Supported Principals:** You can only assign eligible authorizations to users and groups. You **cannot** use eligible authorizations with service principals because a non-interactive service principal cannot perform the PIM activation workflow [2, 4]. 
*   **Cloud Boundaries:** Eligible authorizations are currently not supported in national clouds [1, 2].