# Securing Single Page Applications with OAuth PKCE

Great job on selecting the correct answer! Your choice demonstrates a strong understanding of how different OAuth 2.0 flows map to specific application architectures and their security constraints.

Here is a detailed breakdown of why the Authorization code flow with PKCE is the exact right design choice for a Single Page Application (SPA):

**1. The Public Client Problem**
Single-page web applications are downloaded from a server and execute entirely within the user's web browser [1]. Because this client-side code can be easily inspected by anyone using the browser, SPAs cannot safely conceal or protect a client secret [1, 2]. In the Microsoft identity platform, applications that cannot protect secrets are classified as **public clients** [2]. You must never embed a confidential credential directly into browser or native-client code [3].

**2. Why PKCE is the Solution**
Because a SPA cannot use a static client secret to prove its identity to the authorization server, it must use the **Authorization code flow with Proof Key for Code Exchange (PKCE)** [4, 5]. PKCE solves the public-client interception problem by using a dynamic verifier to protect the code redemption process, entirely removing the need for a stored secret [3, 5, 6]. This approach ensures the interactive exchange is secure while also preserving compatibility with advanced security features like MFA and Conditional Access [6].

**3. Flows to Avoid**
Historically, SPAs often defaulted to using the "implicit grant flow" to get access tokens efficiently [1]. However, this flow is no longer recommended for new applications due to security vulnerabilities, such as token leakage in browser history [7, 8]. You should also avoid the Resource Owner Password Credentials (ROPC) flow or attempting to embed a client secret directly into the SPA [5, 6].

**Architectural Takeaway:**
When designing an authentication solution for the AZ-305 exam, always match the OAuth flow to the application's execution context [6]. Any time a scenario involves an interactive **Single Page Application (SPA), mobile app, or desktop app** that lacks a secure secret store, the correct architectural choice is always the **Authorization code with PKCE** flow [5, 6, 9].