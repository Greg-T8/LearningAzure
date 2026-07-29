# Identity Governance Constraints in Entra External Tenants

Great job on selecting the correct answer! This question tests your knowledge of the strict feature boundaries and limitations of Microsoft Entra external tenants compared to standard workforce tenants.

Here is a detailed breakdown of why your answer is correct and how you should think about governance in external tenants for your exam designs:

**1. The Role of PIM and Just-In-Time (JIT) Access**
In the Microsoft Entra ecosystem, Just-In-Time (JIT) access—which grants users elevated, time-bound permissions only when they need them—is provided by **Privileged Identity Management (PIM)** [1, 2]. PIM is a core component of the broader **Microsoft Entra ID Governance** suite [3]. 

**2. The External Tenant Limitation**
While standard workforce tenants support full enterprise governance, an external tenant is a specialized directory built exclusively for Customer Identity and Access Management (CIAM) scenarios (meaning consumers and business customers using your applications) [4]. Because it is streamlined for consumer apps, it lacks many advanced enterprise administrative features. 

The source material explicitly outlines that **Microsoft Entra ID Governance is not available in external tenants** [5, 6]. Therefore, you cannot use PIM to enforce JIT access, approval workflows, or time-bound access for users in these directories. In an external tenant, all users simply possess default permissions unless they are statically assigned an admin role [5, 6].

**3. Licensing Add-on Distinctions**
To further emphasize this separation, Microsoft offers an "ID Governance" premium add-on, but it is exclusively applicable to **workforce tenants** [7]. It is used to govern B2B guest users (like partner organizations or vendors) who are collaborating in your internal directory, rather than consumers in an external tenant [7]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing an identity architecture, you must match the required security features to the tenant type. 
*   If a scenario involves a branded, consumer-facing application and does not require complex internal enterprise governance, an **external tenant** is the right choice [8].
*   However, if the business requirements explicitly demand advanced enterprise capabilities like **Just-In-Time access (PIM)**, **Access Reviews**, or **risk-based ID Protection**, those features are incompatible with an external tenant [5, 6, 9]. For those requirements, you must use a **workforce tenant** and leverage B2B collaboration for your external users [8, 9].