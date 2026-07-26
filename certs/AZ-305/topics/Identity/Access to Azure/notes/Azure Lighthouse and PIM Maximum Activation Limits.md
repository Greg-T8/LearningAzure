# Azure Lighthouse and PIM Maximum Activation Limits

It is very easy to confuse these limits because your guess of 24 hours is actually the correct maximum for *standard* Microsoft Entra Privileged Identity Management (PIM) role activations [1]. However, cross-tenant management with Azure Lighthouse enforces a stricter boundary.

Here is a detailed breakdown of why your answer was incorrect and the specific limits you need to know for Azure Lighthouse:

**1. The Azure Lighthouse Activation Limit**
When a service provider onboards a customer to Azure Lighthouse using eligible authorizations (Just-In-Time access), they must define an access policy that governs how long a user can hold the elevated privileges. For Azure Lighthouse specifically, this activation duration must be set between a minimum of **30 minutes** and a strict maximum of **8 hours** [2-4]. You simply cannot request or configure a 24-hour activation window for a cross-tenant Lighthouse delegation [4].

**2. Why 24 Hours is a Common Trap**
If you are managing resources natively within your *own* tenant using standard PIM for Azure resources, the activation maximum duration is configurable from 1 to 24 hours [1]. The exam deliberately tests your ability to distinguish between standard internal PIM limits and the specialized, more restrictive limits applied to service providers via Azure Lighthouse.

**Architectural Takeaway for the AZ-305 Exam:**
When designing a Just-In-Time (JIT) access solution, pay close attention to whether the scenario involves internal resources or cross-tenant service provider access:
*   For standard internal PIM for Azure resource roles, the maximum activation duration is **24 hours** [1].
*   For **Azure Lighthouse eligible authorizations**, the maximum activation duration is strictly capped at **8 hours** [2, 3].