# Deep Technical Facts and Requirements for Recommend an Authentication Solution

## Scope

- Exam: AZ-305: Designing Microsoft Azure Infrastructure Solutions
- Task: Recommend an authentication solution
- Source guide: *Authentication Solution study guide - Sol 5.6.md*, validated against the task map and the AZ-305 skill hierarchy
- Research date: July 2026
- Product selection method: Products and major topics were extracted from the provided guide, then validated against current official Microsoft documentation.

## Product coverage summary

| Product / topic | Classification | Why it matters for this task |
|---|---|---|
| Microsoft Entra workforce authentication methods | Core | Provides MFA, passwordless, phishing-resistant, bootstrap, and recovery methods governed by the authentication methods policy. [Authentication methods overview](https://learn.microsoft.com/en-us/entra/identity/authentication/overview-authentication) |
| Conditional Access, authentication strengths, ID Protection, and CAE | Core | Combines identity, device, network, application, and risk signals to impose adaptive authentication and session controls. [Conditional Access overview](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview) |
| Hybrid authentication | Core | Determines whether Microsoft Entra ID, on-premises agents, or a federation service validates a synchronized user's credential. [Choose the right authentication method](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn) |
| Enterprise SSO and Microsoft identity platform flows | Core | Determines the protocol and OAuth/OIDC flow used by SaaS, web, native, API, and daemon applications. [Authentication flows and application scenarios](https://learn.microsoft.com/en-us/entra/identity-platform/authentication-flows-app-scenarios) |
| Managed identities for Azure resources | Core | Gives supported Azure resources a Microsoft Entra identity without application-managed credentials. [Managed identities overview](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) |
| Microsoft Entra Workload ID and workload identity federation | Core | Replaces secrets and certificates for external, CI/CD, and Kubernetes workloads by exchanging trusted OIDC tokens. [Workload identity federation](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation) |
| Microsoft Entra External ID | Core | Separates partner B2B collaboration in workforce tenants from customer identity and access management in external tenants. [External ID tenant configurations](https://learn.microsoft.com/en-us/entra/external-id/tenant-configurations) |
| Microsoft Entra Domain Services | Supporting | Supplies managed Kerberos, NTLM, LDAP, domain join, DNS, and Group Policy compatibility for legacy workloads. [Domain Services overview](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview) |
| Application Proxy and Microsoft Entra Private Access | Supporting | Publishes private web apps with Entra preauthentication or provides identity-aware access to private TCP/UDP resources. [Application Proxy overview](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy) [Global Secure Access overview](https://learn.microsoft.com/en-us/entra/global-secure-access/overview-what-is-global-secure-access) |
| Microsoft Entra Verified ID | Adjacent | Adds standards-based presentation of verifiable claims and optional Face Check to onboarding or recovery, but does not replace ordinary sign-in. [Verified ID planning](https://learn.microsoft.com/en-us/entra/verified-id/plan-verification-solution) |
| Identity architecture, Zero Trust, and Well-Architected guidance | Architecture guidance | Supplies the design principles used to evaluate trust boundaries, phishing resistance, secretless access, least privilege, and recovery. [Well-Architected identity and access recommendations](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access) |

---

## Microsoft Entra workforce authentication methods

**Classification:** Core  
**Why it matters:** The selected method determines phishing resistance, device dependency, bootstrap and recovery behavior, licensing, and whether Conditional Access can require a specific assurance level.  
**Primary Microsoft source:** [Microsoft Entra authentication overview](https://learn.microsoft.com/en-us/entra/identity/authentication/overview-authentication)  
**Limits and quotas source:** [Manage authentication methods](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-methods-manage)

### Deep technical facts / requirements

1. The authentication methods policy is the recommended control plane for enabling methods; an administrator needs at least the Authentication Policy Administrator role, and a method can remain usable if it is still enabled in either a legacy MFA policy or the legacy SSPR policy during migration. [Manage authentication methods](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-methods-manage).
2. The authentication methods policy has a maximum size of **20 KB**. Large numbers of separately targeted groups can exhaust the policy, so Microsoft recommends consolidating targeting into fewer groups. [Manage authentication methods](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-methods-manage).
3. Microsoft classifies Windows Hello for Business, FIDO2/passkeys, and Microsoft Entra certificate-based authentication as phishing-resistant methods; SMS, voice, and push-based approvals do not provide the same origin binding. [Authentication methods and features](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-methods).
4. A user registering a FIDO2 security key must have completed MFA within the previous **5 minutes**. A Temporary Access Pass can satisfy the bootstrap need when the user has no other strong method. [Enable passkeys in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/authentication/how-to-authentication-passkeys-fido2).
5. A passkey policy can contain at most **3 passkey profiles**, including the default profile. After a tenant opts into passkey profiles, it cannot opt out and return to the earlier policy model. [Enable passkeys in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/authentication/how-to-authentication-passkeys-fido2).
6. FIDO2 attestation is evaluated at registration time. Enabling attestation later does not invalidate already registered unattested keys, but removing an authenticator AAGUID from an allow list makes an already registered key with that AAGUID unusable for sign-in. [Enable passkeys in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/authentication/how-to-authentication-passkeys-fido2).
7. Synced passkeys do not provide attestation. In authentication-method targeting, exclusion takes precedence over inclusion, so a user who is in both an included group and an excluded group is excluded. [Synced passkeys in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/authentication/how-to-synced-passkeys).
8. Temporary Access Pass defaults to a **1-hour** lifetime and an **8-character** code. Administrators can configure **10 to 43,200 minutes** (up to **30 days**) and **8 to 48 characters**, and can make a pass one-time-use; one-time use is off by default. [Configure Temporary Access Pass](https://learn.microsoft.com/en-us/entra/identity/authentication/howto-authentication-temporary-access-pass).
9. SSPR licensing is capability-specific: Microsoft Entra ID Free supports password change for cloud-only users, while on-premises password writeback requires Microsoft Entra ID P1/P2 or Microsoft 365 Business Premium; standalone Microsoft 365 Business Basic and Business Standard do not license writeback. [SSPR licensing requirements](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-sspr-licensing).
10. Password writeback encrypts a reset with a tenant-specific **2,048-bit RSA** key, wraps the payload using **256-bit AES-GCM**, sends it over TLS, and automatically rolls the key every **6 months** or when writeback is disabled and re-enabled. [How SSPR password writeback works](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-sspr-writeback).
11. Windows Hello for Business uses a device-bound asymmetric key or certificate rather than transmitting a password; the user's gesture unlocks the local key and is not sent to the identity provider. [Windows Hello for Business overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/hello-for-business/).
12. Microsoft Entra certificate-based authentication can be used as a single-factor or multifactor method and can be bound to an authentication strength, but its trust configuration, certificate authorities, and username bindings must be configured in the tenant before certificates authenticate users. [Microsoft Entra certificate-based authentication overview](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-certificate-based-authentication).

### Incompatibilities and mutual exclusions

If a design requires passkeys synchronized through a platform credential manager **and** attestation at registration, synced passkeys cannot satisfy both because synced passkeys do not support attestation; use device-bound passkeys/security keys or another phishing-resistant method. [Synced passkeys in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/authentication/how-to-synced-passkeys).

### Edge cases and gotchas

- A method is not fully disabled until it is disabled in every policy that can enable it; changing only the authentication methods policy can leave a legacy MFA or SSPR enablement path active. [Manage authentication methods](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-methods-manage).
- Cross-device registration for passkeys in Microsoft Authenticator is unavailable when attestation enforcement is enabled. [Enable passkeys in Microsoft Authenticator](https://learn.microsoft.com/en-us/entra/identity/authentication/how-to-enable-authenticator-passkey).
- Passkey targeting supports security groups; relying on unsupported group types can silently undermine the intended rollout scope. [Enable passkeys in Microsoft Authenticator](https://learn.microsoft.com/en-us/entra/identity/authentication/how-to-enable-authenticator-passkey).
- Security questions are being retired as an SSPR method in **March 2027**, so a new architecture should not depend on them for recovery. [Security questions authentication method](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-security-questions).
- A TAP can bootstrap passwordless enrollment but is itself a time-limited credential; making it one-time-use changes recovery and repeated-enrollment behavior. [Configure Temporary Access Pass](https://learn.microsoft.com/en-us/entra/identity/authentication/howto-authentication-temporary-access-pass).

### AZ-305 exam discriminator

When a scenario explicitly requires phishing resistance, requiring generic MFA is insufficient: use a Conditional Access authentication strength that permits Windows Hello for Business, FIDO2/passkeys, or certificate-based authentication, and use TAP only to bootstrap registration. [Authentication strengths overview](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strengths) [Authentication methods and features](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-methods).

### Common trap

Do not equate every two-step method with phishing-resistant MFA; SMS, voice, and approve/deny push can meet an MFA claim but do not provide the phishing resistance of FIDO2/passkeys, Windows Hello for Business, or certificate-based authentication. [Authentication methods and features](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-methods).

---

## Conditional Access, authentication strengths, ID Protection, and Continuous Access Evaluation

**Classification:** Core  
**Why it matters:** This is the adaptive policy layer that turns identity, risk, network, device, and application context into authentication and session requirements.  
**Primary Microsoft source:** [Conditional Access overview](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview)  
**Limits and quotas source:** [Plan a Conditional Access deployment](https://learn.microsoft.com/en-us/entra/identity/conditional-access/plan-conditional-access)

### Deep technical facts / requirements

1. Conditional Access is evaluated after first-factor authentication; it is not the component that performs the initial username/password validation. [Conditional Access overview](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview).
2. A tenant can have at most **240** Conditional Access policies, counting policies that are on, off, or in report-only mode. Conditional Access requires Microsoft Entra ID P1; risk conditions driven by ID Protection require P2. [Plan a Conditional Access deployment](https://learn.microsoft.com/en-us/entra/identity/conditional-access/plan-conditional-access).
3. Microsoft recommends excluding emergency access accounts and initially validating policies with report-only mode and the What If tool, because a broadly scoped blocking policy can lock out administrators. [Plan a Conditional Access deployment](https://learn.microsoft.com/en-us/entra/identity/conditional-access/plan-conditional-access).
4. A tenant can define at most **15 custom authentication strengths** in addition to built-in strengths; a custom strength selects allowable method combinations rather than merely asserting that “MFA” occurred. [Advanced authentication strength options](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strength-advanced-options).
5. Conditional Access user/group evaluation can fail closed when a token contains group overage and the user has more than **2,048 direct and nested group memberships**; Microsoft advises direct user assignment for accounts that can reach this condition. [Conditional Access users and groups](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-users-groups).
6. A tenant supports up to **195 named locations**. CAE real-time location enforcement accepts IP-based named locations, not country/region locations or legacy MFA trusted IPs. [Conditional Access network assignments](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-assignment-network) [Continuous Access Evaluation](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-continuous-access-evaluation).
7. CAE-capable applications can receive long-lived access tokens valid for up to **28 hours** because critical events and policy changes can revoke access in near real time; a non-CAE access token normally lasts around **1 hour**. [Continuous Access Evaluation](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-continuous-access-evaluation).
8. If CAE network policies contain more than **5,000 IP ranges**, Microsoft Entra issues a **1-hour** CAE token and disables real-time location-change enforcement for that request. [Continuous Access Evaluation](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-continuous-access-evaluation).
9. Some Conditional Access policy and group-membership changes can take up to **1 day** to propagate, although optimizations reduce many changes to about **2 hours**; this is distinct from CAE critical-event revocation. [Continuous Access Evaluation](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-continuous-access-evaluation).
10. ID Protection exposes detailed risk detections and risk-based remediation with Microsoft Entra ID P2. Without P2, some detections appear only as a generic “Additional risk detected” event without underlying detail. [Identity Protection risk detections](https://learn.microsoft.com/en-us/entra/id-protection/concept-identity-protection-risks).
11. Microsoft advises separate policies for user risk and sign-in risk instead of combining both conditions into a single policy; self-remediation through MFA also requires the user to have registered an MFA method beforehand. [Configure risk policies](https://learn.microsoft.com/en-us/entra/id-protection/howto-identity-protection-configure-risk-policies).
12. CAE for workload identities is limited to Microsoft Graph requests from tenant-owned, single-tenant service principals and requires Workload ID Premium; it does not support managed identities. [CAE for workload identities](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-continuous-access-evaluation-workload).

### Incompatibilities and mutual exclusions

If a scenario requires real-time CAE enforcement for a country/region named location or a configuration with more than **5,000 IP ranges**, CAE cannot provide that enforcement because only IP-based locations qualify and the range overflow falls back to a **1-hour** token. [Continuous Access Evaluation](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-continuous-access-evaluation).

### Edge cases and gotchas

- Conditional Access scoped to directory roles does not support roles scoped to administrative units or individual objects. [Conditional Access users and groups](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-users-groups).
- Guest users are not supported for CAE session revocation in the same way as tenant members. [Continuous Access Evaluation](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-continuous-access-evaluation).
- After a qualifying Entra license expires, existing Conditional Access policies are not automatically deleted or disabled; administrators can view and delete them but cannot update them. [Microsoft Entra licensing](https://learn.microsoft.com/en-us/entra/fundamentals/licensing).
- Authentication strength changes the acceptable method set; the plain “require multifactor authentication” grant does not guarantee a phishing-resistant method. [Authentication strengths overview](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strengths).
- CAE does not make every configuration change instantaneous; distinguish critical event revocation from group and policy propagation. [Continuous Access Evaluation](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-continuous-access-evaluation).

### AZ-305 exam discriminator

Choose Conditional Access plus an authentication strength when access must adapt to application, device, location, or risk **and** the method must have a defined assurance level; add ID Protection P2 when user/sign-in risk is the input, and CAE when supported applications must react before normal token expiry. [Conditional Access overview](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview) [Authentication strengths overview](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strengths).

### Common trap

Do not describe Conditional Access as the first-factor identity provider or assume it continuously reevaluates every application: it runs after first factor, and CAE behavior depends on client/resource support. [Conditional Access overview](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview) [Continuous Access Evaluation](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-continuous-access-evaluation).

---

## Hybrid authentication: password hash synchronization, pass-through authentication, federation, and seamless SSO

**Classification:** Core  
**Why it matters:** The choice determines where credentials are validated, which on-premises dependencies remain in the sign-in path, how outages are handled, and which risk detections are available.  
**Primary Microsoft source:** [Choose the right authentication method](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn)  
**Limits and quotas source:** [Pass-through Authentication quickstart](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-pta-quick-start)

### Deep technical facts / requirements

1. Directory synchronization and authentication are separate choices: synchronizing identities with Microsoft Entra Connect or Cloud Sync does not require the same component to validate the user's sign-in. [Choose the right authentication method](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn).
2. With password hash synchronization (PHS), Microsoft Entra ID validates the cloud sign-in. The original on-premises MD4 password hash is never sent; Connect transforms it with per-user salt and **1,000 iterations** of PBKDF2-HMAC-SHA256 before transmission. [How password hash synchronization works](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-password-hash-synchronization).
3. PHS normally processes password changes every **2 minutes**, and that schedule is not configurable. It synchronizes password hashes for the `user` object type, not `iNetOrgPerson`. [How password hash synchronization works](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-password-hash-synchronization).
4. PHS supports leaked-credential detection in ID Protection and supplies the NTLM/Kerberos-compatible hash material needed by Microsoft Entra Domain Services; Microsoft recommends enabling it as a backup even when PTA or federation is primary. [Choose the right authentication method](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn).
5. Pass-through Authentication (PTA) validates the password against on-premises Active Directory through outbound-only agents; Microsoft recommends at least **3 agents** in production, and a tenant supports at most **40 agents**. [Pass-through Authentication quickstart](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-pta-quick-start).
6. PTA agents require outbound TCP **443** for authentication traffic and TCP **80** for certificate revocation list retrieval; TCP **8080** is optional for health reporting when **443** is unavailable and is not used to process sign-ins. Agents report health every **10 minutes**. [Pass-through Authentication quickstart](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-pta-quick-start).
7. A PTA outage does not automatically fail over to PHS. If PHS was enabled as a backup, an administrator must change the tenant authentication method to invoke it. [Choose the right authentication method](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn).
8. Federation keeps an external federation service such as AD FS in the interactive authentication path and should be selected only when a requirement cannot be met natively by managed authentication, because it adds servers, certificates, network endpoints, and availability responsibilities. [Choose the right authentication method](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn).
9. Seamless SSO uses the `AZUREADSSOACC` computer account and Kerberos for users on corporate devices; Microsoft recommends rolling its Kerberos decryption key at least every **30 days**. [Seamless SSO quickstart](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-sso-quick-start).
10. Seamless SSO activation can take about **30 minutes**, while cached user Kerberos tickets commonly remain valid for **10 hours**, so a configuration or troubleshooting change may not be visible immediately. [Troubleshoot Seamless SSO](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/tshoot-connect-sso).
11. Staged rollout allows test groups to use PHS or PTA before domain conversion, but supports at most **10 groups per feature**; Microsoft recommends splitting groups larger than **50,000 users**. It is a validation mechanism, not the final domain cutover. [Staged rollout of cloud authentication](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-staged-rollout).
12. Seamless SSO cannot be enabled through Microsoft Entra Connect when the topology contains **30 or more forests**. Its browser Kerberos header must also remain within the **50-KB** HTTP request-header limit. [Troubleshoot Seamless SSO](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/tshoot-connect-sso).

### Incompatibilities and mutual exclusions

If the requirement says sign-in must continue when on-premises identity infrastructure or WAN connectivity is unavailable, PTA and federation cannot be the only authentication path because both depend on on-premises processing; use PHS as the primary method or preconfigure it and plan a manual failover. [Choose the right authentication method](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn).

### Edge cases and gotchas

- PHS does not instantly reflect every on-premises account state; Microsoft documents differences and delays for states such as expiration, so Conditional Access and identity lifecycle controls still matter. [Choose the right authentication method](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn).
- Installing multiple PTA agents supplies availability but does not make Entra automatically switch from PTA to PHS. [Pass-through Authentication quickstart](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-pta-quick-start).
- Seamless SSO is not supported in mobile browsers, and private browsing in Firefox does not provide the expected seamless behavior. [Troubleshoot Seamless SSO](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/tshoot-connect-sso).
- A large Kerberos token caused by group membership can exceed the browser header limit and break Seamless SSO even when Kerberos itself works. [Troubleshoot Seamless SSO](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/tshoot-connect-sso).
- Federation is not required merely because identities originate in AD DS; PHS and PTA are managed authentication choices for synchronized identities. [Choose the right authentication method](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn).

### AZ-305 exam discriminator

PHS is the default architecture answer when simplicity, cloud resilience, leaked-credential detection, or Domain Services is required; PTA is the discriminator when password validation and immediate on-premises account enforcement must remain in AD DS; federation is reserved for a protocol or policy requirement that managed authentication cannot satisfy. [Choose the right authentication method](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn).

### Common trap

Do not assume PTA keeps passwords “off Azure” while PHS sends a reusable AD DS password hash: PHS sends a further-derived, salted hash that cannot be used for an on-premises pass-the-hash attack. [How password hash synchronization works](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-password-hash-synchronization).

---

## Enterprise SSO and Microsoft identity platform application flows

**Classification:** Core  
**Why it matters:** Application type, trust boundary, user presence, and legacy protocol support determine the valid SSO protocol and OAuth 2.0/OIDC flow.  
**Primary Microsoft source:** [Authentication flows and application scenarios](https://learn.microsoft.com/en-us/entra/identity-platform/authentication-flows-app-scenarios)  
**Limits and quotas source:** [Redirect URI restrictions and limitations](https://learn.microsoft.com/en-us/entra/identity-platform/reply-url)

### Deep technical facts / requirements

1. OpenID Connect is the modern interactive sign-in protocol for applications built on OAuth 2.0, while SAML is commonly used for established enterprise SaaS applications. Password-based SSO replays a stored application credential, and linked SSO only launches a target URL and is not token-based SSO. [Single sign-on options in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/what-is-single-sign-on).
2. Microsoft Entra access tokens normally have a randomized lifetime of **60 to 90 minutes**, averaging **75 minutes**; the resource API, not the client, owns validation of the token and its audience. [Microsoft identity platform access tokens](https://learn.microsoft.com/en-us/entra/identity-platform/access-tokens).
3. Refresh tokens issued to browser-based single-page applications and email one-time-passcode users last **24 hours**; refresh tokens for most other scenarios default to **90 days**. Redeeming one refresh token does not automatically revoke the old token, so clients must securely replace and discard it. [Refresh tokens in the Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/refresh-tokens).
4. An app configured for organizational accounts can register up to **256 redirect URIs**; an app also supporting personal Microsoft accounts is limited to **100**. Each redirect URI is limited to **256 characters**. [Redirect URI restrictions and limitations](https://learn.microsoft.com/en-us/entra/identity-platform/reply-url).
5. Redirect URIs do not support internationalized domain names, and app registrations that support personal Microsoft accounts cannot use query-string parameters in a redirect URI. Exact URI matching is a security boundary. [Redirect URI restrictions and limitations](https://learn.microsoft.com/en-us/entra/identity-platform/reply-url).
6. Authorization code flow with PKCE is required for SPAs and recommended for native/public clients; a SPA or public client cannot safely store a client secret. [OAuth 2.0 authorization code flow](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow).
7. Client credentials flow represents the application rather than a user and is appropriate for daemons and service-to-service calls; production designs should prefer a certificate or federated credential over a client secret. [OAuth 2.0 client credentials flow](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-client-creds-grant-flow).
8. On-behalf-of flow lets a middle-tier API exchange a user token for another token to a downstream API; it is a delegated-user chain and is not a substitute for client credentials when no user exists. [OAuth 2.0 on-behalf-of flow](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-on-behalf-of-flow).
9. Resource owner password credentials (ROPC) does not support personal Microsoft accounts and is incompatible with MFA and many modern authentication controls; Microsoft recommends migration to interactive MSAL flows. [MSAL authentication flows](https://learn.microsoft.com/en-us/entra/msal/msal-authentication-flows).
10. A SAML signing certificate created by Microsoft Entra ID has a default lifetime of **3 years**. Its expiration date cannot be edited after save; create a replacement certificate and coordinate rollover with the service provider. [SAML certificate FAQ](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/application-management-certs-faq).
11. SAML token encryption is a Microsoft Entra ID P1/P2 feature and depends on the service provider supplying a public encryption certificate; signing proves issuer/integrity, whereas encryption protects assertion contents. [Configure SAML token encryption](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/howto-saml-token-encryption).
12. MSAL handles protocol details, token caching, and silent token acquisition; applications should request tokens for the resource's scopes instead of parsing or depending on access-token contents intended for the API. [Microsoft Authentication Library overview](https://learn.microsoft.com/en-us/entra/identity-platform/msal-overview) [Microsoft identity platform access tokens](https://learn.microsoft.com/en-us/entra/identity-platform/access-tokens).

### Incompatibilities and mutual exclusions

If an application must enforce MFA or Conditional Access and is a SPA/public client that cannot protect a secret, ROPC and client-secret authentication cannot satisfy the design; use authorization code with PKCE and MSAL. [MSAL authentication flows](https://learn.microsoft.com/en-us/entra/msal/msal-authentication-flows) [OAuth 2.0 authorization code flow](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow).

### Edge cases and gotchas

- A client must not validate or interpret an access token for a different resource; the audience API is the party that validates it. [Microsoft identity platform access tokens](https://learn.microsoft.com/en-us/entra/identity-platform/access-tokens).
- Revoking a B2B guest's refresh tokens in the guest's home tenant does not revoke refresh tokens issued by the resource tenant. [Refresh tokens in the Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/refresh-tokens).
- “Linked SSO” creates a launcher link and does not make the target application trust Microsoft Entra tokens. [Single sign-on options in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/what-is-single-sign-on).
- An OBO middle tier must not relay its incoming token unchanged to another API; it exchanges the token for the downstream audience. [OAuth 2.0 on-behalf-of flow](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-on-behalf-of-flow).
- Certificate rollover for SAML requires coordination because the service provider must trust the new signing certificate before the old one expires. [SAML certificate FAQ](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/application-management-certs-faq).

### AZ-305 exam discriminator

Match the flow to the execution context: authorization code plus PKCE for interactive SPA/mobile/desktop clients, authorization code for server-side web apps, OBO for a user-delegated API chain, and client credentials or managed identity for a daemon with no user. [Authentication flows and application scenarios](https://learn.microsoft.com/en-us/entra/identity-platform/authentication-flows-app-scenarios).

### Common trap

Do not select implicit flow or ROPC simply because it appears to reduce redirects; PKCE solves the public-client code interception problem while preserving MFA and Conditional Access compatibility. [OAuth 2.0 authorization code flow](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow).

---

## Managed identities for Azure resources

**Classification:** Core  
**Why it matters:** Managed identities remove credential provisioning and rotation from supported Azure workloads, but system-assigned and user-assigned identities have different lifecycle, sharing, isolation, and deployment characteristics.  
**Primary Microsoft source:** [Managed identities overview](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview)  
**Limits and quotas source:** [Azure managed identity limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-managed-identity-limits)

### Deep technical facts / requirements

1. A system-assigned managed identity is created on one Azure resource and deleted with that resource; a user-assigned managed identity is a standalone regional Azure resource whose lifecycle is independent and that can be assigned to multiple supported resources. [Managed identities overview](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview).
2. User-assigned identities reduce identity-object and role-assignment churn when many resources need identical permissions and can be preauthorized before compute deployment; system-assigned identities provide a unique identity and clearer per-resource audit boundary. [Managed identity best practices](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations).
3. Creating managed identities is throttled to **400 operations per 20 seconds** per tenant per region and **80 per 20 seconds** per subscription per region. Assigning a user-assigned identity is throttled to **400 per 20 seconds** per tenant per region and **300 per 20 seconds** per subscription per region. [Azure managed identity limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-managed-identity-limits).
4. Deleting a system-assigned identity with its resource does not delete Azure RBAC role assignments that referred to its service principal; those assignments must be cleaned up separately. [Managed identity best practices](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations).
5. Managed identity authorization data can be cached by a resource provider for around **24 hours**, so group or role membership changes can take hours to affect tokens and there is no supported way to force that backend cache to refresh. [Managed identity best practices](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations).
6. Assigning a managed identity to a compute resource gives any code able to invoke that resource's local managed-identity endpoint the identity's effective permissions; broad user-assigned identity reuse therefore increases blast radius. [Managed identity best practices](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations).
7. A user-assigned managed identity cannot be moved between Azure regions; recreate it in the target region, reproduce role assignments, and update consuming resources during a regional move. [Move a user-assigned managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-to-managed-identity-regional-move).
8. Managed identity token endpoints can return HTTP **410 Gone** during transient updates and are expected to recover within **70 seconds**; HTTP **429** requires retry with backoff. Applications should cache tokens rather than request one for every operation. [Acquire a token from an Azure VM](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-to-use-vm-token).
9. The platform manages the identity credential, but access still requires a separate data-plane or control-plane authorization assignment such as an Azure RBAC role on the target resource. Enabling the identity alone grants no target permissions. [Managed identities overview](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview).
10. Managed identities are Microsoft Entra service principals for Azure resources, yet Conditional Access for workload identities explicitly excludes managed identities and applies only to selected service principals. [Conditional Access for workload identities](https://learn.microsoft.com/en-us/entra/identity/conditional-access/workload-identity).
11. A user-assigned identity has an Azure resource identity (`resourceId`), a Microsoft Entra application/client ID, and a service-principal object ID; APIs and assignments require the correct identifier and they are not interchangeable. [Managed identities overview](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview).
12. [Preview] Managed identity assignment restrictions can constrain which identities may be assigned to resources, but preview controls must be flagged and validated before being used as a production or exam-critical requirement. [Managed identities assignment restriction](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identities-assignment-restriction).

### Incompatibilities and mutual exclusions

If a workload must keep the same identity while its user-assigned identity resource is moved to another region, an in-place move cannot meet both requirements because user-assigned managed identities are not region-movable; create a new identity and reauthorize it, or design the regional identity boundary in advance. [Move a user-assigned managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-to-managed-identity-regional-move).

### Edge cases and gotchas

- Immediate revocation cannot be assumed after removing a managed identity from a group or changing a role because resource-provider caches can persist for around **24 hours**. [Managed identity best practices](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations).
- A shared user-assigned identity simplifies deployment but makes resource-level attribution and least-privilege isolation coarser. [Managed identity best practices](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations).
- Removing a resource can leave orphaned role assignments even though its system-assigned service principal is gone. [Managed identity best practices](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations).
- Managed identity removes credential management, not authorization design; the target still needs the least-privilege role or access policy. [Managed identities overview](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview).
- Client ID selects a user-assigned identity at runtime, while object ID is commonly used for role assignment; using the wrong ID is a frequent deployment error. [Managed identities overview](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview).

### AZ-305 exam discriminator

Prefer a system-assigned identity for a one-resource/one-lifecycle trust boundary and a user-assigned identity when permissions must be provisioned before compute, reused consistently by multiple resources, or survive replacement of the compute resource. [Managed identity best practices](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations).

### Common trap

Do not assume a user-assigned identity is inherently more secure because it is reusable; sharing one identity also shares its permissions and expands the set of workloads capable of obtaining its tokens. [Managed identity best practices](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations).

---

## Microsoft Entra Workload ID and workload identity federation

**Classification:** Core  
**Why it matters:** Workload identity federation lets workloads outside the Azure managed-identity boundary authenticate without persistent secrets by exchanging an external OIDC assertion for a Microsoft Entra token.  
**Primary Microsoft source:** [Workload identity federation](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation)  
**Limits and quotas source:** [Workload identity federation considerations](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-considerations)

### Deep technical facts / requirements

1. A federated identity credential (FIC) establishes trust in an external OIDC issuer, subject, and audience; Microsoft Entra exchanges a matching external assertion for an access token without storing an external platform secret in Entra. [Workload identity federation](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation).
2. Workload identity federation can be configured on an app registration or a user-assigned managed identity, but each app or user-assigned identity supports at most **20 federated identity credentials**. [Workload identity federation considerations](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-considerations).
3. FIC token exchange supports a single audience, `api://AzureADTokenExchange`, and Microsoft documents **RS256** as the tested and supported signing algorithm. [Workload identity federation considerations](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-considerations).
4. A FIC name is immutable after creation, must be **3 to 120 characters**, and is restricted to URL-friendly characters; its description can be at most **600 characters**. [Configure an app to trust a managed identity](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-config-app-trust-managed-identity).
5. Issuer, subject, and audience matching is exact, the subject is case-sensitive, and wildcards are not accepted in a standard FIC. A syntactically valid but mismatched credential can be created successfully and fail only at token exchange. [Configure an app to trust a managed identity](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-config-app-trust-managed-identity).
6. New and updated FICs can have a propagation delay; workloads should retry token exchange rather than interpreting an immediate failure as proof that the trust is permanently invalid. [Workload identity federation considerations](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-considerations).
7. When an app registration trusts a user-assigned managed identity, both objects must be in the same tenant. A multitenant application can later access resources in another tenant, but the trust does not cross Microsoft cloud boundaries. [Configure an app to trust a managed identity](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-config-app-trust-managed-identity).
8. AKS Workload ID uses the cluster's OIDC issuer and a Kubernetes service-account subject to obtain Microsoft Entra tokens; applications request v2 tokens with a scope formatted as `<resource>/.default`. [AKS Workload ID overview](https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview).
9. AKS Workload ID has the same **20-FIC** limit per managed identity and can take a few seconds to propagate a new FIC. AKS virtual nodes are not supported. [AKS Workload ID overview](https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview).
10. [Limited regions — verify before specifying] Creating FICs on user-assigned managed identities has documented regional exceptions, including Malaysia South; region support must be checked before fixing the identity resource's location. [Workload identity federation considerations](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-considerations).
11. [Preview] Flexible federated identity credentials add claim-matching expressions and custom claims to reduce one-FIC-per-subject pressure, but they must not be treated as the GA answer to the standard **20-FIC** limit. [Flexible federated identity credentials](https://learn.microsoft.com/en-us/entra/workload-id/workload-identities-flexible-federated-identity-credentials).
12. Conditional Access for workload identities requires Workload ID Premium and can directly target tenant-owned service principals; it cannot target service-principal groups, Microsoft-owned service principals, multitenant applications, or managed identities. [Conditional Access for workload identities](https://learn.microsoft.com/en-us/entra/identity/conditional-access/workload-identity).

### Incompatibilities and mutual exclusions

If a standard FIC design needs more than **20 distinct issuer/subject trust tuples** on one app or user-assigned identity, that identity cannot satisfy the requirement with GA standard FICs; partition across identities or explicitly accept the status and constraints of flexible FICs [Preview]. [Workload identity federation considerations](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-considerations) [Flexible federated identity credentials](https://learn.microsoft.com/en-us/entra/workload-id/workload-identities-flexible-federated-identity-credentials).

### Edge cases and gotchas

- Standard FICs accept no wildcard subject matching, so branch-, repository-, environment-, or service-account-specific subject design affects quota consumption. [Configure an app to trust a managed identity](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-config-app-trust-managed-identity).
- A raw resource URI can fail in AKS libraries that expect the v2 scope form ending in `/.default`. [AKS Workload ID overview](https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview).
- FIC configuration success does not prove runtime matching; case or issuer-path differences appear during token exchange. [Configure an app to trust a managed identity](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-config-app-trust-managed-identity).
- Workload federation removes the stored credential but does not assign access; the app or managed identity still needs permissions on the target. [Workload identity federation](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation).
- Workload Conditional Access and workload identity federation solve different problems: the former constrains sign-in conditions, while the latter establishes a credentialless trust. [Conditional Access for workload identities](https://learn.microsoft.com/en-us/entra/identity/conditional-access/workload-identity) [Workload identity federation](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation).

### AZ-305 exam discriminator

Use managed identity when the Azure host natively supports it; use workload identity federation when the workload runs in GitHub Actions, Kubernetes, another cloud, or another external OIDC environment and therefore cannot obtain a platform-managed Azure identity directly. [Workload identity federation](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation).

### Common trap

Do not replace a client secret with a long-lived external “federation secret”; federation relies on a short-lived signed OIDC assertion whose issuer, subject, and audience exactly match the FIC. [Workload identity federation](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation).

---

## Microsoft Entra External ID: B2B collaboration and external tenants

**Classification:** Core  
**Why it matters:** External ID contains two distinct architectures: B2B collaboration adds partner identities to a workforce tenant, while an external tenant is a separate CIAM directory for customer applications.  
**Primary Microsoft source:** [External ID tenant configurations](https://learn.microsoft.com/en-us/entra/external-id/tenant-configurations)  
**Limits and quotas source:** [External tenant service limits](https://learn.microsoft.com/en-us/entra/external-id/customers/reference-service-limits)

### Deep technical facts / requirements

1. A workforce tenant is intended for employees, internal applications, and B2B guests; an external tenant is a separate CIAM configuration for consumers and business customers. External tenants are created in the Microsoft Entra admin center, not the Azure portal. [External ID tenant configurations](https://learn.microsoft.com/en-us/entra/external-id/tenant-configurations).
2. External ID core features include the first **50,000 monthly active users (MAU)** at no charge. In an external tenant, all active users count toward MAU regardless of `UserType`; in workforce B2B pricing, only `Guest` users count as External ID MAU. [Microsoft Entra licensing](https://learn.microsoft.com/en-us/entra/fundamentals/licensing) [External ID pricing](https://learn.microsoft.com/en-us/entra/external-id/external-identities-pricing).
3. An external tenant supports up to **300,000 total user and application objects** by default; a higher requirement requires engagement with Microsoft Support. [External tenant service limits](https://learn.microsoft.com/en-us/entra/external-id/customers/reference-service-limits).
4. External-tenant app registrations are single-tenant only. Their authorization endpoint uses the tenant's `ciamlogin.com` domain, and all applications that need shared SSO should consistently use the same URL domain. [Supported features in external tenants](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-supported-features-customers).
5. External tenants support authorization code with PKCE, device code, OBO, and selected OIDC/OAuth flows, but do not support ROPC. They also restrict Microsoft Graph permissions to a documented subset. [Supported features in external tenants](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-supported-features-customers).
6. External-tenant Conditional Access supports device platform and location conditions, block/MFA/password-reset grants, and sign-in-frequency or persistent-browser session controls; ID Protection risk conditions are unavailable because ID Protection is not supported in external tenants. [Supported features in external tenants](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-supported-features-customers).
7. External-tenant MFA can use email OTP, an SMS add-on, and passkeys under documented conditions. An email OTP must be completed within **10 minutes**, and SMS cannot be used as the first authentication factor. [MFA for customers](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-multifactor-authentication-customers).
8. If email OTP is the customer's primary sign-in method, it cannot also serve as the secondary MFA factor, and passkeys are unavailable. Customer passkeys require email-and-password or username-and-password local accounts, a custom URL domain, and prior MFA. [MFA for customers](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-multifactor-authentication-customers).
9. Activity and audit logs in external tenants are retained for **7 days** by default. Deleted external-tenant users can be restored for **30 days**. [Supported features in external tenants](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-supported-features-customers).
10. External tenants cannot own Azure subscriptions; billing must be linked to a subscription in an associated workforce tenant. SMS and machine-to-machine usage are separately billed add-ons, and Go-Local data residency is limited to Australia and Japan. [External ID pricing](https://learn.microsoft.com/en-us/entra/external-id/external-identities-pricing).
11. B2B collaboration creates or redeems a guest representation in the resource workforce tenant. By default, members and guests can invite guests and guest directory visibility is restricted, but administrators can tighten invitation settings and cross-tenant access. [B2B collaboration overview](https://learn.microsoft.com/en-us/entra/external-id/b2b-fundamentals).
12. Automatic redemption of B2B invitations through cross-tenant access settings requires both organizations to enable the corresponding trust; enabling it on only one side is insufficient. [Configure B2B cross-tenant access](https://learn.microsoft.com/en-us/entra/external-id/cross-tenant-access-settings-b2b-collaboration).
13. Azure AD B2C has been unavailable to new customers since **May 1, 2025** and Microsoft states support for existing customers continues until at least **May 2030**. B2C P2 was discontinued on **March 15, 2026**, with P2 capabilities no longer available. [Azure AD B2C FAQ](https://learn.microsoft.com/en-us/azure/active-directory-b2c/faq).

### Incompatibilities and mutual exclusions

If a customer identity design requires ID Protection risk-based Conditional Access **and** an External ID external tenant, those requirements are incompatible because ID Protection and its risk conditions are not supported there; redesign the risk control or use a workforce-tenant pattern only when the population and governance model truly fit workforce/B2B identity. [Supported features in external tenants](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-supported-features-customers).

### Edge cases and gotchas

- A customer who signs in with email OTP cannot use the same email OTP as MFA, and that primary method also prevents passkey enrollment. [MFA for customers](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-multifactor-authentication-customers).
- Customers federated from an external identity provider cannot use external-tenant passkeys. [MFA for customers](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-multifactor-authentication-customers).
- Nested groups are unsupported in external tenants, which changes group-based application assignment design. [Supported features in external tenants](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-supported-features-customers).
- Application Proxy and the enterprise application gallery are unavailable in external tenants. [Supported features in external tenants](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-supported-features-customers).
- [Preview] Exporting external-tenant activity logs must be identified as preview, and the built-in **7-day** retention should not be confused with a production archival design. [Supported features in external tenants](https://learn.microsoft.com/en-us/entra/external-id/customers/concept-supported-features-customers).

### AZ-305 exam discriminator

Select B2B collaboration when partners need governed access to workforce-tenant resources and should use their home credentials; select an external tenant when the organization owns a branded customer sign-up/sign-in journey and MAU-based CIAM lifecycle. [External ID tenant configurations](https://learn.microsoft.com/en-us/entra/external-id/tenant-configurations).

### Common trap

Do not recommend Azure AD B2C for a new 2026 customer solution; new purchases stopped on **May 1, 2025**, so current designs should start with Microsoft Entra External ID external tenants. [Azure AD B2C FAQ](https://learn.microsoft.com/en-us/azure/active-directory-b2c/faq).

---

## Microsoft Entra Domain Services

**Classification:** Supporting  
**Why it matters:** Domain Services provides AD DS protocol compatibility without customer-managed domain controllers when a legacy workload cannot authenticate directly with modern Microsoft Entra protocols.  
**Primary Microsoft source:** [Microsoft Entra Domain Services overview](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview)  
**Limits and quotas source:** [Domain Services replica-set limits](https://learn.microsoft.com/en-us/entra/identity/domain-services/concepts-replica-sets)

### Deep technical facts / requirements

1. Domain Services supplies managed domain join, Group Policy, LDAP, Kerberos, and NTLM, while Microsoft operates the domain controllers; customers do not receive Domain Admin or Enterprise Admin privileges. [Microsoft Entra Domain Services overview](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview).
2. Creating a managed domain deploys **2 domain controllers** as the first replica set in the chosen region. Replica sets replicate the same namespace and data; they do not create multiple independent managed domains in one tenant. [Domain Services replica sets](https://learn.microsoft.com/en-us/entra/identity/domain-services/concepts-replica-sets).
3. Enterprise is the default SKU and the minimum SKU for additional replica sets. A managed domain supports at most **5 replica sets**—the initial set plus **4** additional sets—and each replica set is billed hourly at the managed domain's SKU. [Domain Services replica sets](https://learn.microsoft.com/en-us/entra/identity/domain-services/concepts-replica-sets).
4. Virtual networks containing replica sets must be fully meshed with peering because VNet peering is not transitive. All replica sets are placed in one AD DS site, and customers cannot define separate sites or tune intersite replication. [Domain Services replica sets](https://learn.microsoft.com/en-us/entra/identity/domain-services/concepts-replica-sets).
5. Microsoft Entra ID synchronizes accounts, groups, attributes, and credential hashes one way into the managed domain; edits in Domain Services do not synchronize back to Entra ID, and synchronized user attributes/passwords/group memberships are read-only in the managed domain. [How Domain Services synchronization works](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization).
6. A cloud-only user that existed before Domain Services was enabled must change or reset the password so Entra can generate the NTLM- and Kerberos-compatible hashes needed for managed-domain authentication. [How Domain Services synchronization works](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization).
7. In hybrid environments, Microsoft Entra Connect must explicitly synchronize the legacy NTLM/Kerberos hashes; that capability requires Connect version **1.1.614.0 or later** and is not provided by legacy DirSync. [Enable password-hash synchronization for Domain Services](https://learn.microsoft.com/en-us/entra/identity/domain-services/tutorial-configure-password-hash-sync).
8. The first directory synchronization can take from a few hours to a couple of days, depending on directory size; replica sets protect authentication only where deployed and do not make the dependent application tier regionally resilient. [How Domain Services synchronization works](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization) [Domain Services replica sets](https://learn.microsoft.com/en-us/entra/identity/domain-services/concepts-replica-sets).

### Incompatibilities and mutual exclusions

If an application requires schema extensions, forest/domain administrator control, trust customization beyond the managed service, or authoritative write-back from the domain to Entra ID, Domain Services cannot satisfy it because the managed domain is restricted and synchronization is one way; deploy customer-managed AD DS instead. [Compare identity solutions](https://learn.microsoft.com/en-us/entra/identity/domain-services/compare-identity-solutions) [How Domain Services synchronization works](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization).

### Edge cases and gotchas

- Installing Microsoft Entra Connect inside the managed domain to synchronize changes back to Entra ID is unsupported. [How Domain Services synchronization works](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization).
- `sAMAccountName` can be generated when `mailNickname` duplicates another value or exceeds the AD DS **20-character** limit; UPN is therefore the most reliable sign-in form. [How Domain Services synchronization works](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization).
- The managed domain generates a different primary SID namespace from on-premises AD DS, although `sIDHistory` helps preserve migrated ACL behavior. [How Domain Services synchronization works](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization).
- The initial replica set and the last remaining replica set cannot be deleted. [Create a Domain Services replica set](https://learn.microsoft.com/en-us/entra/identity/domain-services/tutorial-create-replica-set).
- Domain Services retains legacy credential hashes by design to support NTLM and Kerberos; it is a compatibility solution, not a way to modernize the application protocol. [How Domain Services synchronization works](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization).

### AZ-305 exam discriminator

Select Domain Services when a lift-and-shift workload in Azure needs domain join, LDAP, Kerberos, NTLM, or Group Policy but the organization does not want to operate domain controllers; select self-managed AD DS when forest-level control, custom schema, complex trusts, or unrestricted administration is mandatory. [Compare identity solutions](https://learn.microsoft.com/en-us/entra/identity/domain-services/compare-identity-solutions).

### Common trap

Do not treat Domain Services as another writable copy of on-premises AD DS: Entra-to-managed-domain synchronization is one way and most synchronized identity attributes must be changed at their source. [How Domain Services synchronization works](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization).

---

## Microsoft Entra Application Proxy and Microsoft Entra Private Access

**Classification:** Supporting  
**Why it matters:** Both use private network connectors, but Application Proxy publishes private web applications through an external URL while Private Access supplies identity-aware access to private TCP/UDP destinations and can replace broad VPN reachability.  
**Primary Microsoft source:** [Application Proxy overview](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy) and [Global Secure Access overview](https://learn.microsoft.com/en-us/entra/global-secure-access/overview-what-is-global-secure-access)  
**Limits and quotas source:** [Application Proxy high availability and connection limits](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-high-availability-load-balancing)

### Deep technical facts / requirements

1. Application Proxy supports remote access to private web applications using outbound connector connections and can apply Microsoft Entra preauthentication, Conditional Access, and SSO without opening inbound firewall ports to the application. [Application Proxy overview](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy).
2. Application Proxy requires Microsoft Entra ID P1 or P2. If the license expires, Application Proxy is disabled automatically and configuration information is retained for at most **1 year**. [Application Proxy FAQ](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-faq).
3. Connector servers need TLS **1.2** and outbound TCP **443** and **80**. Terminating or inline-inspecting outbound TLS between connectors and Microsoft is unsupported and can prevent the secure channel from forming. [Plan an Application Proxy deployment](https://learn.microsoft.com/en-us/entra/identity/app-proxy/conceptual-deployment-plan).
4. Each Application Proxy connector is limited by default to **200 concurrent outbound connections**. A connector group should contain at least **2 connectors** for availability; Microsoft prefers **3** to preserve capacity during maintenance. [Application Proxy high availability and load balancing](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-high-availability-load-balancing).
5. Application Proxy provides no session affinity across connectors. Back-end applications requiring stickiness should use a layer-7 load balancer with a session cookie or the `X-Forwarded-For` header rather than connector source-IP affinity. [Application Proxy high availability and load balancing](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-high-availability-load-balancing).
6. The Application Proxy back-end request timeout defaults to **85 seconds** and can be set to Long for **180 seconds**; **180 seconds** is the ceiling. [Application Proxy FAQ](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-faq).
7. Microsoft Entra Private Access extends the connector architecture beyond HTTP web publishing to private resources addressed by FQDN, IP address/range, port, and TCP or UDP protocol; per-app enterprise applications can receive independent user assignments and Conditional Access policies. [Global Secure Access overview](https://learn.microsoft.com/en-us/entra/global-secure-access/overview-what-is-global-secure-access).
8. Private Access requires Microsoft Entra ID P1 plus a Private Access or Microsoft Entra Suite license. Current deployment guidance uses Windows Server **2016 or later** for the connector and a Windows **11** Entra-joined, hybrid-joined, or registered client. [Private Access introduction](https://learn.microsoft.com/en-us/entra/global-secure-access/tutorial-private-access-introduction).
9. A Private Access application requires at least **1 active** connector, and per-app access requires connector version **1.5.3417.0 or later**. An application segment is the exact combination of destination, port, and protocol. [Configure per-app Private Access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-configure-per-app-access).
10. When a per-app enterprise application segment overlaps a Quick Access segment, the per-app segment takes precedence, allowing the explicit assignment and Conditional Access policy to narrow broad VPN-style access. [Private Access app segmentation](https://learn.microsoft.com/en-us/entra/global-secure-access/tutorial-private-access-app-segmentation).
11. Application Discovery reports Quick Access destinations used during the preceding **30 days** and can require **10 to 15 minutes** of traffic before a newly used segment appears. [Private Access app segmentation](https://learn.microsoft.com/en-us/entra/global-secure-access/tutorial-private-access-app-segmentation).
12. Private Access currently acquires traffic only from the Global Secure Access client, not remote networks; IP-address tunneling works only for destination ranges outside the end-user device's local subnet, and FQDN-based acquisition requires DNS over HTTPS to be disabled. [Global Secure Access known limitations](https://learn.microsoft.com/en-us/entra/global-secure-access/reference-current-known-limitations).

### Incompatibilities and mutual exclusions

If a design must publish a non-HTTP TCP/UDP workload to devices without the Global Secure Access client, Application Proxy cannot carry the protocol and current Private Access cannot acquire that traffic; change the client/connectivity model or use another network-access solution. [Global Secure Access overview](https://learn.microsoft.com/en-us/entra/global-secure-access/overview-what-is-global-secure-access) [Global Secure Access known limitations](https://learn.microsoft.com/en-us/entra/global-secure-access/reference-current-known-limitations).

### Edge cases and gotchas

- A **504/gateway timeout** means the service cannot reach a connector; **502/bad gateway** means the connector cannot reach the back end; **403/forbidden** commonly indicates missing Entra or back-end authorization. [Troubleshoot Application Proxy gateway errors](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-sign-in-bad-gateway-timeout-error).
- Overlapping segments across different Private Access applications should be avoided, even though a per-app segment has documented precedence over Quick Access. [Global Secure Access known limitations](https://learn.microsoft.com/en-us/entra/global-secure-access/reference-current-known-limitations).
- A Private Access segment begins matching when policy reaches clients; if its parent enterprise app has no user/group assignment, matching sessions are denied. [Operate Microsoft Entra Private Access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-operate-private-access).
- Quick Access is broad and migration-friendly; per-app segmentation is the least-privilege end state because it isolates destination/port/protocol and policy. [Private Access app segmentation](https://learn.microsoft.com/en-us/entra/global-secure-access/tutorial-private-access-app-segmentation).
- Connector load is approximately distributed but not guaranteed equal, and there is no connector affinity. [Application Proxy high availability and load balancing](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-high-availability-load-balancing).

### AZ-305 exam discriminator

Use Application Proxy for a private **web** app that needs an internet-facing Entra-preauthenticated URL and web SSO; use Private Access when the resource uses arbitrary TCP/UDP ports or the design calls for per-app ZTNA/VPN replacement through the Global Secure Access client. [Application Proxy overview](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy) [Global Secure Access overview](https://learn.microsoft.com/en-us/entra/global-secure-access/overview-what-is-global-secure-access).

### Common trap

Do not assume connector installation makes the private app publicly reachable or opens inbound firewall ports; connectors initiate outbound connections, while user assignment, preauthentication/traffic profiles, and the application definition determine access. [Application Proxy overview](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy).

---

## Microsoft Entra Verified ID

**Classification:** Adjacent  
**Why it matters:** Verified ID can prove a claim during onboarding, entitlement requests, help-desk recovery, or other high-assurance processes, but a presented credential is evidence consumed by an application—not a replacement for its Entra authentication session.  
**Primary Microsoft source:** [Plan a Verified ID verification solution](https://learn.microsoft.com/en-us/entra/verified-id/plan-verification-solution)  
**Limits and quotas source:** [Quick Verified ID setup](https://learn.microsoft.com/en-us/entra/verified-id/verifiable-credentials-configure-tenant-quick)

### Deep technical facts / requirements

1. Verified ID lets an issuer sign verifiable claims, a holder retain a credential in a wallet, and a verifier request only needed claims; verification establishes trust in presented evidence but the application still creates an account or federates/authenticates the user separately. [Plan a Verified ID verification solution](https://learn.microsoft.com/en-us/entra/verified-id/plan-verification-solution).
2. Verified ID core issuance and verification are included with Microsoft Entra ID, including Free; Face Check is a premium add-on and is included with Microsoft Entra Suite. [Microsoft Entra licensing](https://learn.microsoft.com/en-us/entra/fundamentals/licensing).
3. Quick setup uses a Microsoft-managed shared signing key, has a limit of **2 issuance or verification requests per second per tenant**, and limits issued credential validity to **6 months**. It requires a custom domain registered in the tenant and is unavailable in EDU tenants. [Quick Verified ID setup](https://learn.microsoft.com/en-us/entra/verified-id/verifiable-credentials-configure-tenant-quick).
4. Advanced setup uses Azure Key Vault for issuer keys and currently requires the vault's permission model to be **Key Vault access policy**, not Azure RBAC. It also requires DID and linked-domain configuration. [Advanced Verified ID setup](https://learn.microsoft.com/en-us/entra/verified-id/verifiable-credentials-configure-tenant).
5. Face Check compares a live selfie with the photo claim in a presented credential and returns a confidence result without sharing the selfie with the verifier. The configurable acceptance threshold is **50 to 100**, with a default of **70**. [Use Face Check with Verified ID](https://learn.microsoft.com/en-us/entra/verified-id/using-facecheck).
6. Face Check requires Microsoft Authenticator; Android requires API level **26 or later** plus a `MEETS_STRONG_INTEGRITY` result, while iOS requires iOS **11 or later**. A credential photo can be at most **1 MB** and should be at least **200 × 200 pixels**. [Use Face Check with Verified ID](https://learn.microsoft.com/en-us/entra/verified-id/using-facecheck).

### Incompatibilities and mutual exclusions

If a design requires Verified ID advanced setup **and** a Key Vault configured only for Azure RBAC, that configuration is unsupported because advanced setup currently requires the Key Vault access-policy permission model. [Advanced Verified ID setup](https://learn.microsoft.com/en-us/entra/verified-id/verifiable-credentials-configure-tenant).

### Edge cases and gotchas

- Quick setup cannot be used without a registered custom tenant domain and is not supported in EDU tenants. [Quick Verified ID setup](https://learn.microsoft.com/en-us/entra/verified-id/verifiable-credentials-configure-tenant-quick).
- Face Check verifies that the presenter matches a photo claim; it does not by itself establish an application session or grant authorization. [Use Face Check with Verified ID](https://learn.microsoft.com/en-us/entra/verified-id/using-facecheck).
- [Preview] The ARM REST API used to enable the Face Check add-on is preview even though Face Check itself is a premium capability. [Use Face Check with Verified ID](https://learn.microsoft.com/en-us/entra/verified-id/using-facecheck).
- Quick setup's shared key and **6-month** credential ceiling differ from advanced setup's customer-controlled Key Vault model. [Quick Verified ID setup](https://learn.microsoft.com/en-us/entra/verified-id/verifiable-credentials-configure-tenant-quick).

### AZ-305 exam discriminator

Select Verified ID only when a workflow must verify portable evidence—such as employment, a qualification, or a photo-backed identity claim—during onboarding, governance, or recovery; use Entra authentication methods and Conditional Access for routine sign-in and session enforcement. [Plan a Verified ID verification solution](https://learn.microsoft.com/en-us/entra/verified-id/plan-verification-solution).

### Common trap

Do not call a verifiable credential an access token: the credential proves claims from an issuer, while an OAuth access token authorizes a client to call a specific resource audience. [Plan a Verified ID verification solution](https://learn.microsoft.com/en-us/entra/verified-id/plan-verification-solution) [Microsoft identity platform access tokens](https://learn.microsoft.com/en-us/entra/identity-platform/access-tokens).

---

## Identity architecture, Zero Trust, and Well-Architected guidance

**Classification:** Architecture guidance  
**Why it matters:** These principles determine how an architect compares authentication mechanisms rather than treating identity as a feature added after workload design.  
**Primary Microsoft source:** [Well-Architected identity and access recommendations](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access)  
**Limits and quotas source:** Not applicable; this section is design guidance rather than a metered Azure service.

### Deep technical facts / requirements

1. The Well-Architected Framework recommends treating identity as the primary security perimeter, using a single identity provider, strong authentication, least privilege, and explicit authorization at each trust boundary. [Well-Architected identity and access recommendations](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access).
2. Zero Trust replaces implicit trust based on network location with “verify explicitly,” “use least privilege,” and “assume breach”; authentication therefore consumes all available signals and access is limited in scope and duration. [Zero Trust guidance center](https://learn.microsoft.com/en-us/security/zero-trust/zero-trust-overview).
3. Workload code should use managed identities or workload identity federation instead of embedded credentials, and human administration should use separate privileged identities protected by phishing-resistant authentication. [Well-Architected identity and access recommendations](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access).
4. An authentication architecture must include recovery paths—emergency access accounts, method-registration bootstrap, credential recovery, and monitoring—because stronger primary authentication without recoverability can create an availability failure. [Manage emergency access accounts](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/security-emergency-access) [Plan passwordless authentication](https://learn.microsoft.com/en-us/entra/identity/authentication/howto-authentication-passwordless-deployment).
5. Azure Architecture Center separates employee/workforce, consumer, business-to-business, hybrid, and application identity scenarios because their tenant boundary, protocol, lifecycle, and assurance requirements differ. [Azure identity architecture](https://learn.microsoft.com/en-us/azure/architecture/identity/identity-start-here).

### Incompatibilities and mutual exclusions

If an architecture grants trust solely because a request originates on a corporate network while also claiming Zero Trust, the requirements conflict because Zero Trust requires explicit identity/device/context verification and assumes the network can be breached. [Zero Trust guidance center](https://learn.microsoft.com/en-us/security/zero-trust/zero-trust-overview).

### Edge cases and gotchas

- “Passwordless” does not automatically mean phishing-resistant; the exact allowed authentication method and strength remain material. [Authentication strengths overview](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strengths).
- Least privilege applies to workload identities as well as users; a credentialless identity with Owner access is still overprivileged. [Well-Architected identity and access recommendations](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access).
- Network segmentation complements identity controls but does not replace application authorization. [Zero Trust guidance center](https://learn.microsoft.com/en-us/security/zero-trust/zero-trust-overview).
- Emergency access accounts should be deliberately excluded from ordinary Conditional Access dependencies and separately monitored. [Manage emergency access accounts](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/security-emergency-access).

### AZ-305 exam discriminator

When several technologies can authenticate, prefer the design that centralizes trust in Microsoft Entra ID, requires the strongest usable phishing-resistant method, removes stored workload credentials, enforces least privilege, and retains an independently tested recovery path. [Well-Architected identity and access recommendations](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access).

### Common trap

Do not choose an authentication product only from the user's location; identify the principal type, tenant boundary, protocol, trust authority, assurance level, token audience, authorization plane, and outage behavior first. [Azure identity architecture](https://learn.microsoft.com/en-us/azure/architecture/identity/identity-start-here).

---

## Highest-yield exam discriminators

| Scenario requirement | Best-fit answer | Why |
|---|---|---|
| Workforce sign-in must resist phishing | Conditional Access authentication strength plus passkey/FIDO2, Windows Hello for Business, or CBA | Generic MFA permits methods without origin binding; authentication strength constrains the accepted method combinations. [Authentication strengths overview](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strengths) |
| New user has no password or registered MFA method | Temporary Access Pass | TAP is a time-limited bootstrap credential that can register passwordless methods; its configurable lifetime is **10 to 43,200 minutes**. [Configure Temporary Access Pass](https://learn.microsoft.com/en-us/entra/identity/authentication/howto-authentication-temporary-access-pass) |
| Cloud authentication must survive loss of on-premises identity infrastructure | Password hash synchronization | Microsoft Entra validates PHS sign-ins in the cloud; PTA and federation retain on-premises dependencies, and PTA-to-PHS failover is manual. [Choose the right authentication method](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn) |
| Password validation must occur against current on-premises AD DS state | Pass-through Authentication | PTA agents validate each password through on-premises AD DS; production design should deploy at least **3 agents**. [Pass-through Authentication quickstart](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-pta-quick-start) |
| A native Entra capability cannot meet a required third-party protocol or policy | Federation | Federation retains the external identity provider in the sign-in path and is justified only for requirements managed authentication cannot meet. [Choose the right authentication method](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn) |
| Risk-based MFA or secure-password-change remediation | ID Protection P2 plus Conditional Access | P2 supplies user/sign-in risk details and risk policy conditions; plain P1 Conditional Access does not provide that risk capability. [Configure risk policies](https://learn.microsoft.com/en-us/entra/id-protection/howto-identity-protection-configure-risk-policies) |
| Interactive browser/mobile/desktop app without a secure secret store | Authorization code with PKCE and MSAL | PKCE is required for SPAs and protects public clients without relying on a client secret. [OAuth 2.0 authorization code flow](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow) |
| Middle-tier API calls a downstream API as the signed-in user | OAuth 2.0 on-behalf-of flow | OBO exchanges the incoming user assertion for a token whose audience is the downstream API. [OAuth 2.0 on-behalf-of flow](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-on-behalf-of-flow) |
| Azure-hosted workload needs secretless service authentication | Managed identity | The Azure platform provisions and rotates the credential; system-assigned and user-assigned identity selection depends on lifecycle and sharing. [Managed identities overview](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) |
| GitHub Actions, Kubernetes, or another OIDC workload needs secretless Entra tokens | Workload identity federation | A FIC trusts the external issuer/subject/audience and avoids a stored client secret; standard FICs are limited to **20 per identity**. [Workload identity federation considerations](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-considerations) |
| Partners use home credentials to access internal workforce resources | External ID B2B collaboration | B2B creates a guest representation in the resource workforce tenant while authentication normally remains with the partner's home identity. [B2B collaboration overview](https://learn.microsoft.com/en-us/entra/external-id/b2b-fundamentals) |
| Branded customer registration and CIAM lifecycle for a new solution | External ID external tenant | External tenants are customer directories with MAU pricing; Azure AD B2C stopped new-customer purchases on **May 1, 2025**. [External ID tenant configurations](https://learn.microsoft.com/en-us/entra/external-id/tenant-configurations) [Azure AD B2C FAQ](https://learn.microsoft.com/en-us/azure/active-directory-b2c/faq) |
| Lift-and-shift app requires LDAP, NTLM, Kerberos, domain join, or Group Policy without managed DC operations | Microsoft Entra Domain Services | Domain Services supplies managed legacy domain protocols but not unrestricted forest administration or two-way identity synchronization. [Compare identity solutions](https://learn.microsoft.com/en-us/entra/identity/domain-services/compare-identity-solutions) |
| Private on-premises web app needs an Entra-preauthenticated external URL | Microsoft Entra Application Proxy | Application Proxy uses outbound connectors, Entra preauthentication, Conditional Access, and web SSO without inbound firewall publication. [Application Proxy overview](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy) |
| Private TCP/UDP applications need per-app ZTNA or VPN replacement | Microsoft Entra Private Access | Private Access routes FQDN/IP/port/protocol segments through the Global Secure Access client and supports per-app assignment and Conditional Access. [Global Secure Access overview](https://learn.microsoft.com/en-us/entra/global-secure-access/overview-what-is-global-secure-access) |
| Token/session access must stop before normal token expiry after critical events | Continuous Access Evaluation, for supported clients and resources | CAE-capable sessions can use tokens valid up to **28 hours** because supported resources react to critical events, but it is not universal across apps or guests. [Continuous Access Evaluation](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-continuous-access-evaluation) |

---

_Model used to research and author this fact sheet: GPT-5 (reasoning mode was not supplied)._
