## Domain: Design identity, governance, and monitoring solutions

### Skill: Design authentication and authorization solutions

#### Task: Recommend an authentication solution

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/identity/identity-start-here) | <https://learn.microsoft.com/en-us/azure/architecture/identity/identity-start-here> | Provides an architecture-focused starting point for comparing workforce, application, workload, hybrid, and external identity solutions. |
| [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access) | <https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access> | Covers design principles for strong authentication, trusted identity providers, workload identities, conditional access, and secretless authentication. |
| [Authentication](https://learn.microsoft.com/en-us/entra/identity/authentication/overview-authentication) | <https://learn.microsoft.com/en-us/entra/identity/authentication/overview-authentication> | Compares supported primary, multifactor, passwordless, certificate-based, recovery, and external authentication methods. |
| [Hybrid identity](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn) | <https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/choose-ad-authn> | Provides the central decision guide for password hash synchronization, pass-through authentication, and federated authentication, including complexity and availability tradeoffs. |
| [Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview) | <https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview> | Supports adaptive authentication designs that require MFA or specific authentication strengths based on user, device, location, application, and risk signals. |
| [Microsoft Entra ID Protection](https://learn.microsoft.com/en-us/entra/id-protection/overview-identity-protection) | <https://learn.microsoft.com/en-us/entra/id-protection/overview-identity-protection> | Supports risk-based authentication and automated remediation for risky users, compromised credentials, and suspicious sign-ins. |
| [Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/authentication-flows-app-scenarios) | <https://learn.microsoft.com/en-us/entra/identity-platform/authentication-flows-app-scenarios> | Maps application types to appropriate OAuth 2.0 and OpenID Connect flows for SPAs, web apps, APIs, mobile apps, devices, and daemon applications. |
| [Managed identities for Azure resources](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) | <https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview> | Supports credential-free service-to-service authentication and comparison of system-assigned and user-assigned managed identities. |
| [Microsoft Entra Workload ID](https://learn.microsoft.com/en-us/entra/workload-id/workload-identities-overview) | <https://learn.microsoft.com/en-us/entra/workload-id/workload-identities-overview> | Covers authentication for applications, service principals, containers, automation, and external workloads through workload identity federation. |
| [Microsoft Entra External ID](https://learn.microsoft.com/en-us/entra/external-id/) | <https://learn.microsoft.com/en-us/entra/external-id/> | Supports authentication design for business guests, partner collaboration, and customer-facing CIAM applications. |
| [Microsoft Entra Domain Services](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview) | <https://learn.microsoft.com/en-us/entra/identity/domain-services/overview> | Supports legacy applications requiring managed domain authentication such as Kerberos, NTLM, and LDAP without operating domain controllers. |
| [Application proxy](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy) | <https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy> | Supports Microsoft Entra preauthentication, Conditional Access, and single sign-on for privately hosted web applications. |

Potentially relevant products considered: Microsoft Entra ID, Microsoft Entra authentication methods, multifactor authentication, passwordless authentication, passkeys and FIDO2 security keys, Windows Hello for Business, certificate-based authentication, Conditional Access, authentication strengths, Microsoft Entra ID Protection, hybrid identity, password hash synchronization, pass-through authentication, AD FS federation, Microsoft identity platform, MSAL, Microsoft Entra External ID, managed identities, Microsoft Entra Workload ID, workload identity federation, Microsoft Entra Domain Services, and Application Proxy.

Forum-discovery note: Public candidate discussions commonly characterize identity as a core AZ-305 area and emphasize scenario-based service selection, security tradeoffs, and hybrid or domain-controller requirements. These discussions were used only as discovery signals; all included topics were validated against official Microsoft documentation.

Coverage notes:

- Authentication recommendations are fragmented across several documentation sets because workforce, hybrid, application, workload, external, and legacy authentication have different decision models.
- Azure Architecture Center and Well-Architected Framework guidance provide the best initial design perspective; the product documentation supplies the detailed comparisons.
- Download Azure Architecture Center, Authentication, Hybrid identity, Conditional Access, Microsoft identity platform, and Managed identities for Azure resources first.
- Microsoft Entra External ID, Workload ID, Domain Services, and Application Proxy become especially important when a scenario mentions customers, non-Azure workloads, legacy protocols, or private applications.
- Windows Hello for Business, passkeys, FIDO2, certificate-based authentication, and Temporary Access Pass are primarily covered within the Authentication documentation set.
- AD FS is still a possible federated solution, but password hash synchronization generally provides lower operational complexity and better cloud resilience unless requirements demand federation.
