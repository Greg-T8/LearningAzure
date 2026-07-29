# Continuous Access Evaluation and Token Lifetime Dynamics

Your choice of **90 days** is a very reasonable guess because that time frame is a prominent limit within Microsoft Entra ID. However, your answer confused the default lifetime of a *refresh token* with the lifespan of an *access token* managed by Continuous Access Evaluation (CAE).

Here is a detailed breakdown of why your answer was incorrect and how CAE token lifetimes actually work:

**1. Why "90 days" is incorrect:**
In the Microsoft identity platform, **90 days** is the default lifetime for a standard **refresh token** in most authentication scenarios [1]. Refresh tokens are used in the background to fetch new access tokens when the old ones expire [1]. However, this question is specifically asking about the access tokens used during an active CAE session.

**2. Why "28 hours" is the correct answer:**
Normally, a standard (non-CAE) access token is short-lived, lasting for an average of **1 hour** [1-3]. This short lifespan is a traditional security measure designed to limit the window of unauthorized access if a user's conditions change or a token is compromised [4, 5]. 

However, when you implement CAE, supported clients and resource providers can receive long-lived access tokens that remain valid for up to **28 hours** [2, 3, 6].

**3. The Architectural Reason for the 28-Hour Extension:**
CAE completely changes how token revocation works. It establishes a continuous two-way "conversation" between the token issuer (Microsoft Entra ID) and the relying party (like Exchange Online or SharePoint) [7]. 

Because CAE-capable applications subscribe to critical events—such as a password reset, an account disablement, a high user risk detection, or a network location change—they can revoke a user's access in near real-time [2, 3, 8]. Since access can be instantly cut off the moment a threat or policy change is detected, the platform no longer has to rely on an arbitrarily short 1-hour token expiration to protect the resource [3]. Extending the token lifetime up to 28 hours drastically increases the stability and performance of your applications without weakening your security posture [3]. 

**Architectural Takeaway:**
When evaluating token lifetimes for the AZ-305 exam, remember this separation:
*   **1 hour:** The default lifespan of a standard access token [2, 3].
*   **28 hours:** The maximum lifespan of a **CAE-capable access token**, made possible by near real-time event revocation [2, 3, 6].
*   **90 days:** The default lifespan of a standard **refresh token** [1, 9].