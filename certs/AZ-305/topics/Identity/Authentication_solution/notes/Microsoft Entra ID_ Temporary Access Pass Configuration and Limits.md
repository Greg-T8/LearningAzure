# Microsoft Entra ID: Temporary Access Pass Configuration and Limits

Your choice of 7 days was a very reasonable guess because 7 days is a common expiration and retention boundary across many other Azure and Entra services (such as the default audit log retention for Entra ID Free). However, this question tests your knowledge of the specific configuration limits for identity recovery mechanisms. 

Here is a breakdown of why your answer was incorrect and how Temporary Access Pass (TAP) lifetimes actually work:

**1. The 43,200-Minute Maximum**
In Microsoft Entra ID, the absolute maximum lifetime you can configure for a single Temporary Access Pass is **43,200 minutes**, which equates to exactly **30 days** [1, 2]. 

**2. Understanding TAP's Configurable Boundaries**
When an administrator configures the TAP policy for their tenant, they can set the following boundaries:
*   **Minimum lifetime:** Can be set as low as **10 minutes** [1, 2].
*   **Maximum lifetime:** Can be set up to **43,200 minutes (30 days)** [1, 2].
*   **Default lifetime:** Out of the box, a TAP defaults to a **1-hour** lifetime and an 8-character code [1].
*   **Reusability:** By default, a TAP can be used multiple times within its validity window, but administrators can restrict it to a **one-time use** passcode [1, 2]. 

**3. The Architectural Purpose of TAP**
A Temporary Access Pass is specifically designed to be a time-limited bootstrap and recovery credential [3]. If a new user joins the company and needs to register a phishing-resistant, passwordless authentication method (like a FIDO2 security key or Windows Hello for Business), they can use a TAP to sign in and securely register that device without ever knowing or needing a traditional password [3, 4]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing authentication solutions for the exam, remember that **a TAP must never be used as a permanent, steady-state credential** [5]. It is strictly an onboarding or "break-glass" recovery tool. If a scenario asks how to securely onboard a user who currently lacks a password or an MFA method, deploying a Temporary Access Pass (configured within that 10 to 43,200-minute window) is the correct architectural choice [6].