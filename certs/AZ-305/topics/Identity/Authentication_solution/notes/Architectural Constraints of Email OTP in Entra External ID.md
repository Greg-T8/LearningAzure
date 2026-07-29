# Architectural Constraints of Email OTP in Entra External ID

Your choice of "The email OTP will expire after 30 minutes" is factually incorrect because **an email OTP in Microsoft Entra External ID actually expires after 10 minutes**, not 30 minutes [1, 2]. 

Here is a breakdown of why the correct answer is "The user cannot use email OTP as a secondary MFA factor" and how this limitation affects your architectural design:

**1. The Mutual Exclusion of Email OTP**
Microsoft Entra External ID supports email one-time passcodes as both a primary first-factor sign-in method and a secondary multifactor authentication (MFA) method [3]. However, **if you configure "Email with one-time passcode" as the primary sign-in method, customers cannot use that same method for their secondary MFA verification** [3, 4]. 

**2. The Impact on MFA Options**
This mutual exclusion creates a strict architectural limitation. If email OTP is used for the primary sign-in, **the only remaining second-factor method available for those users is SMS-based authentication**, which requires an active Azure subscription and incurs extra add-on transaction costs [1, 3, 5]. To allow customers to use email OTP as their second-factor MFA, you must configure their primary local account authentication method to "Email with password" or "Username with password" [3, 4, 6].

**3. The Impact on Passkeys**
Choosing email OTP as the primary sign-in method creates another major downstream limitation: **it completely prevents users from enrolling in passkeys** [1, 7]. To support passkeys for your customers in an external tenant, they must use an email-and-password or username-and-password local account, and they must successfully complete an MFA prompt prior to registering the passkey [1].