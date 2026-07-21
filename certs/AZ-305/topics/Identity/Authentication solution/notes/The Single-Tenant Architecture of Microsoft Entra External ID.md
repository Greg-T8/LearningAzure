# The Single-Tenant Architecture of Microsoft Entra External ID

Great job on selecting the correct answer! You have identified a strict architectural boundary for application registrations within Microsoft Entra External ID.

Here is a detailed breakdown of why single-tenant configuration is required for external tenants and how it differs from a standard workforce deployment:

**1. The Single-Tenant Requirement**
When you register an application in a Microsoft Entra external tenant—which is a dedicated Customer Identity and Access Management (CIAM) directory for your consumers and business customers—you must configure it as a single-tenant application [1, 2]. In the Azure portal, this means you must exclusively select the **"Accounts in this organizational directory only"** option [3, 4]. Multitenant application registrations are simply not supported for External ID endpoints [4]. 

**2. Why this restriction exists**
This limitation exists because of how External ID handles authentication routing and custom branding. External-tenant app registrations use a specific, dedicated authorization endpoint utilizing the tenant's `ciamlogin.com` domain (or your configured custom URL domain) [2, 5]. Because this endpoint is specifically designed to route your unique customer sign-up/sign-in flows, local accounts, and social identity providers (like Google or Facebook), the application must be tightly bound to that single directory [2, 6]. 

**3. Contrast with Workforce Tenants**
This behavior is distinctly different from standard workforce tenants. In a workforce tenant, you have the flexibility to create multitenant applications (selecting "Accounts in any organizational directory") [3, 7]. This is typically done by Independent Software Vendors (ISVs) who want to build a SaaS application and allow users from entirely different companies (different Microsoft 365 or Entra tenants) to sign in to it [7, 8]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing an identity solution, remember to match the app registration type to the tenant type. If a scenario asks you to register a customer-facing app in a **Microsoft Entra external tenant**, you must always register it as **single-tenant** [2, 3]. If you need to build a SaaS app intended to be sold to other businesses and used across many different corporate directories, you must register it as a **multitenant** app within a standard **workforce tenant** [7, 8].