# Conditional Access Limitations in Microsoft Entra External Tenants

Your choice of "Device platform" was a reasonable guess, but this question tests your knowledge of the specific feature limitations that apply to Microsoft Entra **external tenants** (which are used for Customer Identity and Access Management, or CIAM) compared to standard workforce tenants.

Here is a breakdown of why your answer was incorrect and why "Sign-in risk" is the condition you cannot use:

**Why "Sign-in risk" is the correct answer (The unsupported condition):**
In Microsoft Entra, "Sign-in risk" and "User risk" conditions are powered by a feature called **Microsoft Entra ID Protection** [1]. However, Microsoft Entra ID Protection and its underlying risk detections are **not supported in external tenants** [2-4]. Because this underlying risk engine is unavailable, you cannot use sign-in risk or user risk as conditions to evaluate access in an external tenant's Conditional Access policies [3, 5].

**Why "Device platform" is incorrect (The supported condition):**
Your answer was incorrect because you actually *can* use the device platform condition in an external tenant. Microsoft Entra Explicitly supports using both **device platform** and **location** conditions for Conditional Access within external tenants [2, 5]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing a solution using a Microsoft Entra external tenant, remember that you have access to standard Conditional Access controls like device platforms, locations, MFA grants, and session controls (like sign-in frequency) [2]. However, if a scenario requires **risk-based Conditional Access** (like blocking a sign-in based on medium or high risk), it is **incompatible** with an external tenant; you would have to redesign the risk control or use a workforce tenant if the user population fits a B2B collaboration model [3].