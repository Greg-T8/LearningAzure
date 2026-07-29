# Architecting Entra Private Access and Entitlement Governance

It is very easy to confuse Privileged Identity Management (PIM) with Entitlement Management, as both deal with approvals and time-bound access. However, this question tests your ability to choose the correct governance tool for standard end-user application access versus privileged administrative access.

Here is a detailed breakdown of why your answer was incorrect and why the combination of **Microsoft Entra Private Access** and **Entitlement Management** is the perfect fit:

**1. Connecting to On-Premises Resources (Private Access)**
While "Global Secure Access" is the overarching umbrella term, it actually encompasses two distinct services: Internet Access and Private Access [1]. **Microsoft Entra Private Access** is the specific Zero Trust Network Access (ZTNA) solution designed to broker secure, per-app connections to your internal, on-premises corporate resources without requiring a legacy VPN [2-5]. 

**2. Managing the Access Lifecycle (Entitlement Management)**
The core of your requirement is that access must be "requestable, time-bound, and require recurring manager approval." This is the exact definition of **Microsoft Entra Entitlement Management** [5].
*   **Requestable & Time-bound:** Entitlement Management allows you to bundle resources (like the Private Access enterprise application) into an **"access package"** [6, 7]. Users can browse a portal and request this package, and their access will automatically expire after a set time limit [8, 9]. 
*   **Recurring Approvals:** You can configure these access packages with multi-stage approval workflows (such as requiring a manager's approval) and enforce **access reviews** so that managers must regularly recertify if the user still needs access to the on-premises application [8, 10, 11]. 

Combining Private Access with Entitlement Management access packages specifically satisfies the design requirement to make on-premises applications requestable, time-bound, and revocable [12].

**3. Why PIM for Groups is Incorrect**
**Privileged Identity Management (PIM)** is designed for Just-In-Time (JIT) elevation of *administrative or privileged* roles, rather than governing day-to-day access to standard applications [13, 14]. While PIM does offer time-bound activation and approvals, it does not use the "access package" catalog system meant for broad self-service resource requests by standard employees [6, 10]. If you need to bundle standard application access and subject it to lifecycle workflows, Entitlement Management is the correct architectural choice. 

**Architectural Takeaways for the AZ-305 Exam:**
When designing governance and access solutions, memorize this boundary:
*   Use **Privileged Identity Management (PIM)** when the scenario involves highly privileged administrative accounts (like Global Administrators or Azure Resource Owners) that need temporary, Just-In-Time elevation to perform high-impact tasks [13, 14].
*   Use **Entitlement Management** when the scenario involves standard employees or external guests who need to browse a catalog, request a bundle of resources (access packages) for a project, and have their manager approve and regularly review that access [8, 15, 16].