# Architecting Microsoft Entra External ID Scaling and Quotas

Great job on selecting the correct answer! You correctly identified a specific scaling boundary for Microsoft Entra External ID.

Here is a breakdown of why this limit exists, how external tenants work, and related concepts you should know for the exam:

**1. The 300,000 Object Default Limit**
When you create an external tenant for Customer Identity and Access Management (CIAM), Microsoft applies a default service limit of **300,000 total objects**, which includes both customer user accounts and application registrations [1]. This is a platform safeguard. If your consumer-facing application grows and requires more than 300,000 objects, your architecture is not blocked from scaling; you simply must engage Microsoft Support to have this quota increased [1].

**2. External Tenants vs. Workforce Tenants**
It is important to understand *why* this directory is separate. An external tenant is a distinct architecture explicitly built for consumers and business customers [1, 2]. It allows you to create customized sign-up and sign-in journeys for your customers while keeping them completely segregated from your standard workforce tenant (which contains your employees, internal apps, and B2B guests) [1]. 

**3. Object Limits vs. Billing (The MAU Model)**
For the AZ-305 exam, you must distinguish between the physical *object* limit (300,000) and how the service is actually billed. 
*   **Monthly Active Users (MAU):** External tenants do not charge per user object; they charge based on Monthly Active Users. All active users in an external tenant count toward this MAU, and the **first 50,000 MAU are completely free** [1].
*   **Subscription Linking:** Because external tenants are isolated and configured specifically for consumer scenarios, they cannot natively own Azure subscriptions [1]. To pay for usage beyond the free 50,000 MAU (or for premium add-ons like SMS authentication), an architect must link the external tenant's billing back to an Azure subscription owned by their primary workforce tenant [1]. 

**Architectural Takeaway:**
When designing a CIAM solution for a new customer-facing application today, **Microsoft Entra External ID (using an external tenant)** is the correct architectural choice, rather than the legacy Azure AD B2C (which is no longer available to new customers) [3]. When planning for scale, simply keep the 300,000 default object limit and the MAU billing model in mind [1].