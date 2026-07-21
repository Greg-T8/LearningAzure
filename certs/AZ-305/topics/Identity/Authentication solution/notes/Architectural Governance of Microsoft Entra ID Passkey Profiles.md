# Architectural Governance of Microsoft Entra ID Passkey Profiles

While "3" was the correct answer based on the initial release of this feature, it is highly important for your AZ-305 exam preparation to know that Microsoft recently increased this limit. Today, a tenant can have a maximum of **10 passkey profiles** [1, 2]. 

Here is a detailed breakdown of how passkey profiles work, what they control, and why the limit was recently expanded:

**1. What are Passkey Profiles?**
Historically, passkey configurations were applied as a single, tenant-wide setting. Passkey profiles changed this by allowing administrators to define granular, group-based configurations for passkey (FIDO2) authentication [3, 4]. This means you can create different rules for different user populations (for example, applying strict rules for administrators and more relaxed rules for standard users) [3].

**2. What do Profiles Control?**
Within each passkey profile, an architect can define specific requirements for the targeted group:
*   **Passkey types:** You can specify whether users are allowed to register *device-bound* passkeys (like hardware security keys), *synced* passkeys (like Apple iCloud Keychain or Google Password Manager), or both [5, 6].
*   **Enforce attestation:** You can require Microsoft Entra ID to verify the legitimacy and model of the authenticator against trusted metadata during registration [7].
*   **Key restrictions:** You can explicitly allow or block specific authenticator models based on their Authenticator Attestation GUIDs (AAGUIDs) [5, 8].

**3. The Opt-In Behavior and Default Profile**
When a tenant opts into using passkey profiles, all of the organization's existing global passkey settings are automatically transferred into a "Default passkey profile" [3, 9]. It is critical to know that **once a tenant opts into passkey profiles, they cannot opt out** and return to the legacy, single-policy model [10]. 

**4. Why the Limit Increased from 3 to 10**
When the feature was first introduced, tenants were limited to exactly 3 profiles (the default profile plus two custom profiles) [9, 10]. However, as organizations rolled out passkeys to many different departments, they quickly ran into policy size constraints. 

As we discussed in a previous question, Microsoft recently resolved this by giving the passkey (FIDO2) policy its own dedicated **20 KB storage allocation** (separate from the other authentication methods) [11]. With this expanded storage capacity, Microsoft officially increased the maximum number of passkey profiles per tenant from 3 to 10 [1, 2].