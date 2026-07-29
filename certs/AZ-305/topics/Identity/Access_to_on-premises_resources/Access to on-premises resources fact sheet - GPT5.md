# Deep Technical Facts and Requirements for Recommend a solution for authorizing access to on-premises resources

## Scope

- Exam: AZ-305: Designing Microsoft Azure Infrastructure Solutions
- Task: Recommend a solution for authorizing access to on-premises resources
- Source guide: `Access to on-premises resources study guide.md` and its companion task map
- Research date: July 2026
- Product selection method: Products and major topics were extracted from the provided guide, then validated against current official Microsoft documentation.

## Product coverage summary

| Product / topic | Classification | Why it matters for this task |
|---|---|---|
| Microsoft Entra application proxy | Core | Publishes private web applications through outbound connectors and adds Entra preauthentication, assignment, Conditional Access, and supported back-end SSO. |
| Microsoft Entra Private Access and Global Secure Access client | Core | Supplies identity-aware, per-application access to private TCP and UDP destinations rather than broad network-level VPN access. |
| Enterprise applications and Conditional Access | Supporting | Define the cloud admission gate: which users are assigned and which identity, device, location, authentication, or risk conditions they must satisfy. |
| AD DS security groups and Windows ACLs | Core | Remain the resource-side authorization mechanism for Windows, SMB, Kerberos, LDAP, and many legacy applications. |
| Microsoft Entra Cloud Sync group provisioning to AD DS | Core | Carries a cloud-governed entitlement into the AD group membership an unchanged on-premises application already evaluates. |
| Microsoft Entra application provisioning | Supporting | Creates, updates, disables, and removes accounts or entitlements in an application's own LDAP, SQL, SCIM, REST, SOAP, PowerShell, or ECMA repository. |
| Microsoft Entra ID Governance | Supporting | Adds request, approval, expiration, recertification, and revocation workflows around group and enterprise-application assignments. |
| Microsoft Entra Domain Services | Adjacent | Provides managed legacy directory protocols for Azure-hosted lift-and-shift workloads, but is not an extension of the on-premises forest. |
| Azure Arc-enabled servers SSH | Adjacent | Provides an Azure-mediated administrative path to on-premises servers while keeping connection authorization separate from operating-system login. |
| VPN, ExpressRoute, and Zero Trust access design | Architecture guidance | Distinguishes network reachability from cloud admission and resource authorization and prevents a connectivity service from being mistaken for an ACL. |

---

## Microsoft Entra application proxy

**Classification:** Core  
**Why it matters:** Application proxy is the primary answer for publishing an on-premises HTTP/HTTPS application without an inbound internet listener while applying Entra controls before traffic reaches the private network.  
**Primary Microsoft source:** [Microsoft Entra application proxy overview](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy)  
**Limits and quotas source:** [Application proxy deployment planning](https://learn.microsoft.com/en-us/entra/identity/app-proxy/conceptual-deployment-plan)

### Deep technical facts / requirements

1. **[Networking and security boundary]** A private network connector runs on Windows Server and opens only outbound connections to the cloud service over ports `80` and `443`; port `80` is used to retrieve certificate revocation lists and port `443` carries service communication. The published back end therefore needs no inbound internet-facing firewall rule. [Application proxy overview](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy) [Configure private network connectors](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-configure-connectors).
2. **[Scope]** Application proxy is a remote-access reverse proxy for on-premises web applications, not a general tunnel for arbitrary private TCP or UDP traffic; Microsoft also warns that routing internal corporate users through it unnecessarily can cause performance problems. [Application proxy overview](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy).
3. **[Defaults versus maximums]** The normal back-end application timeout is `75` seconds; setting **Backend Application Timeout** to Long raises it to `180` seconds for slow transactions. A request that needs more than `180` seconds cannot be made reliable merely by changing this setting. [Plan an application proxy deployment](https://learn.microsoft.com/en-us/entra/identity/app-proxy/conceptual-deployment-plan).
4. **[Limits and resiliency]** Each connector is limited by default to `200` concurrent outbound connections. Microsoft requires at least `2` connectors in a production connector group and prefers `3` so that maintenance or failure leaves spare capacity; connector traffic is broadly distributed but has no guaranteed even distribution or connector-level session affinity. [Application proxy high availability and load balancing](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-high-availability-load-balancing).
5. **[Capacity]** Microsoft recommends at least `4` CPU cores and `8 GiB` memory per private network connector, keeping sustained CPU and memory under `70%`; a lab-tested `4`-vCPU, `8-GiB` Azure VM achieved up to approximately `1.5 Gbps` aggregate TCP throughput, but real throughput depends on TLS, latency, loss, protocol mix, and the back end. [Private network connector specifications](https://learn.microsoft.com/en-us/entra/global-secure-access/concept-connectors).
6. **[Authentication and SSO]** Application proxy supports four back-end SSO patterns after Entra preauthentication: password-based, Integrated Windows Authentication through Kerberos constrained delegation (KCD), header-based, and SAML. SSO configuration requires the published app to use Entra preauthentication; passthrough does not create an Entra-authenticated identity for these SSO bridges. [Configure application proxy SSO](https://learn.microsoft.com/en-us/entra/identity/app-proxy/how-to-configure-sso).
7. **[KCD prerequisites]** For IWA SSO, the connector host and application server must be domain joined in the same domain or trusting domains, the application's SPN must be correct, and the connector's computer account must be delegated to that SPN. KCD converts the Entra-authenticated identity into a Kerberos service ticket; it does not grant the user an application role. [Application proxy KCD configuration](https://learn.microsoft.com/en-us/entra/identity/app-proxy/how-to-configure-sso-with-kcd).
8. **[Identity and authorization]** Entra assignment, preauthentication, and Conditional Access govern whether the request crosses the cloud front door; the back-end application can still deny the request because the user lacks an on-premises account, AD group, role, or ACL. Microsoft troubleshooting explicitly distinguishes a successful cloud sign-in from authorization in on-premises AD. [Troubleshoot application proxy](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-troubleshoot).
9. **[Security default choice]** Entra preauthentication blocks anonymous requests at the cloud service and permits Conditional Access before a private-network connection is established. Passthrough sends the initial unauthenticated request to the back end and cannot enforce Conditional Access because it does not trigger Entra authentication. [Application proxy security](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-security) [Application proxy FAQ](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-faq).
10. **[SKU and licensing]** Every user of application proxy requires Microsoft Entra ID P1 or P2. If the qualifying license expires, application proxy is disabled automatically, although Microsoft retains the application configuration for up to `1` year. [Application proxy FAQ](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-faq).
11. **[Custom domains and certificates]** A custom external URL requires a verified Entra custom domain, a PFX certificate, and a DNS CNAME pointing to the `msappproxy.net` endpoint—not a service IP or server name, because those are not static. Uploading a custom-domain certificate once makes it available to new apps using that domain, but existing apps must be updated separately. [Configure application proxy custom domains](https://learn.microsoft.com/en-us/entra/identity/app-proxy/how-to-configure-custom-domain).
12. **[Wildcard gating]** Wildcard publishing is supported only with a custom external domain and accepts `http(s)://*.<domain>` internally and `https://*.<custom-domain>` externally; multiple wildcards, arbitrary regular expressions, and wildcards in other positions are unsupported. A more specific published application takes precedence over a wildcard application. [Application proxy wildcard applications](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-wildcard).
13. **[Connector hardening]** The connector can run on a nondomain-joined server unless IWA/KCD SSO is required. TLS inspection or termination between connectors and the cloud service is unsupported because it breaks mutual certificate authentication. [Private network connector requirements](https://learn.microsoft.com/en-us/entra/global-secure-access/concept-connectors) [Configure private network connectors](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-configure-connectors).
14. **[Current implementation change]** As of the current documentation in July 2026, preauthenticated application proxy apps use non-expiring federated identity credentials rather than the older `CWAP_AuthSecret`; expired legacy CWAP secrets can be ignored or removed. [Application proxy FAQ](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-faq).

### Incompatibilities and mutual exclusions

If a design requires arbitrary private TCP/UDP access and Entra-aware per-application network segmentation, application proxy cannot be used as the access tunnel because it publishes web applications; use Private Access or an appropriate network-access solution while retaining target authorization. [Application proxy overview](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy) [Microsoft Entra Private Access overview](https://learn.microsoft.com/en-us/entra/global-secure-access/concept-private-access).

If the back-end web application requires client-certificate authentication end to end, application proxy cannot publish it in that mode because the cloud service terminates TLS. [Application proxy FAQ](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-faq).

### Edge cases and gotchas

- NTLM cannot be an application proxy preauthentication or SSO method; it works only when NTLM is negotiated directly between the client and the published application, usually producing a browser credential prompt. [Application proxy FAQ](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-faq).
- In a B2B IWA scenario, guest users do not have the on-premises UPN or SAM account-name attributes required by those KCD sign-in mappings; fallback to UPN does not manufacture an AD account or grant back-end access. [Application proxy FAQ](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-faq).
- For RDS publication, RD Web and RD Gateway must be on the same machine with a common root; the RD Web client requires the same internal and external FQDN or WebSocket connections fail. [Publish Remote Desktop with application proxy](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-integrate-with-remote-desktop-services).
- Connector-group availability does not make the application tier highly available. If the back end requires session persistence, a separate back-end load-balancing design is still required because connector selection itself supplies no session affinity. [Application proxy high availability and load balancing](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-high-availability-load-balancing).

### AZ-305 exam discriminator

Choose application proxy when the hard clues are **on-premises web app**, **remote users**, **no inbound firewall ports**, and **Entra preauthentication/Conditional Access**. Reject it when the required resource is SMB, SSH, LDAP, a raw database port, or another nonweb private protocol. [Application proxy overview](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy) [Microsoft Entra Private Access overview](https://learn.microsoft.com/en-us/entra/global-secure-access/concept-private-access).

### Common trap

Passing Entra preauthentication and being assigned to the enterprise app does not prove that the user is authorized by the back-end app; the on-premises account, group, role, and ACL decision is a separate gate. [Troubleshoot application proxy](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-troubleshoot).

---

## Microsoft Entra Private Access and Global Secure Access client

**Classification:** Core  
**Why it matters:** Private Access is the identity-centric ZTNA choice for private destinations identified by FQDN/IP, port, and TCP/UDP protocol, including VPN-reduction scenarios and nonweb resources.  
**Primary Microsoft source:** [Microsoft Entra Private Access concept](https://learn.microsoft.com/en-us/entra/global-secure-access/concept-private-access)  
**Limits and quotas source:** [Configure per-app access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-configure-per-app-access)

### Deep technical facts / requirements

1. **[Protocol and segmentation]** A Private Access application segment is the combination of destination, port, and protocol. Destinations can be IPv4 addresses, CIDR ranges, IP-to-IP ranges, exact FQDNs, or wildcard FQDNs, and Private Access carries TCP and UDP traffic. NetBIOS names are unsupported, so the design must use FQDNs rather than short names. [Configure per-app access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-configure-per-app-access) [Application discovery](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-application-discovery).
2. **[Limits and quotas]** Each Private Access enterprise application supports up to `500` application segments. Segments cannot overlap in FQDN, IP, or IP range within or between per-app Private Access applications; the documented exception permits overlap with Quick Access during migration. [Configure per-app access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-configure-per-app-access).
3. **[Priority behavior]** When a per-app segment overlaps Quick Access, the per-app enterprise application always takes priority. Users who were allowed through broad Quick Access but are not assigned to the per-app application are denied; Quick Access does not act as a fallback. [Configure per-app access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-configure-per-app-access) [Per-app segmentation tutorial](https://learn.microsoft.com/en-us/entra/global-secure-access/tutorial-private-access-app-segmentation).
4. **[Assignment and propagation]** Users must be assigned directly or be direct members of an assigned group; nested groups are unsupported. Allow approximately `15` minutes for an assignment or configuration change to synchronize to Global Secure Access clients. [Configure per-app access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-configure-per-app-access).
5. **[Client dependency]** Private Access traffic currently can be acquired only by the Global Secure Access client and cannot be acquired from Global Secure Access remote networks. A branch-only or clientless private-access requirement therefore needs another connectivity design. [Current Global Secure Access limitations](https://learn.microsoft.com/en-us/entra/global-secure-access/reference-current-known-limitations).
6. **[Client platforms]** Clients are generally available for Windows, macOS, Android, and iOS. The Windows client requires 64-bit Windows 10 LTSC 2021 or later, Windows 11, or Windows 11 Arm64; Azure Virtual Desktop single-session and Windows 365 are supported, but AVD multi-session is not. [Global Secure Access client overview](https://learn.microsoft.com/en-us/entra/global-secure-access/concept-clients) [Install the Windows client](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-install-windows-client).
7. **[DNS constraint]** FQDN-based traffic acquisition requires DNS over HTTPS/Secure DNS to be disabled. IP-based tunneling works only when the destination range is outside the endpoint's local subnet. [Current Global Secure Access limitations](https://learn.microsoft.com/en-us/entra/global-secure-access/reference-current-known-limitations).
8. **[IPv4 constraint]** The Global Secure Access client does not tunnel IPv6 traffic; it tunnels IPv4 and sends IPv6 directly. A design that requires all private traffic to remain inside the access plane must prefer or enforce IPv4 until the documented limitation changes. [Current Global Secure Access limitations](https://learn.microsoft.com/en-us/entra/global-secure-access/reference-current-known-limitations).
9. **[Prerequisites and roles]** Creating per-app access requires Global Secure Access Administrator and Application Administrator roles, a connector group with at least `1` active connector, the Private Access traffic profile, and an installed client. Connector version `1.5.3417.0` is the documented minimum for Private Access. [Configure per-app access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-configure-per-app-access).
10. **[Resiliency and capacity]** Although `1` active connector is sufficient to configure an app, Microsoft recommends at least `2` healthy connectors for resilience. Recommended connector sizing is at least `4` cores and `8 GiB` RAM with sustained utilization below `70%`; scale out the connector group or scale up hosts above that threshold. [Private network connector specifications](https://learn.microsoft.com/en-us/entra/global-secure-access/concept-connectors).
11. **[Defaults]** The default connector-routing method for a Global Secure Access application is Random. Session persistence can be enabled when requests from the same user and device must stay on the same connector for the session. [Configure per-app access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-configure-per-app-access).
12. **[Conditional Access behavior]** Private Access policy is modeled by targeting the Quick Access or per-app enterprise application; the access-control decision applies at the application level rather than as an arbitrary packet-level Conditional Access policy. [Current Global Secure Access limitations](https://learn.microsoft.com/en-us/entra/global-secure-access/reference-current-known-limitations) [Target Private Access apps with Conditional Access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-target-resource-private-access-apps).
13. **[Licensing]** The Private Access profile requires Microsoft Entra ID P1 or P2 as a prerequisite plus either the standalone Microsoft Entra Private Access license or Microsoft Entra Suite; Private Access is also included in Microsoft 365 E7. [Global Secure Access licensing overview](https://learn.microsoft.com/en-us/entra/global-secure-access/overview-what-is-global-secure-access) [Traffic-forwarding profile licensing](https://learn.microsoft.com/en-us/entra/global-secure-access/concept-traffic-forwarding).
14. **[Revocation timing]** Universal CAE requires Windows client version `1.8.239.0` or later; Universal CAE tokens last `60–90` minutes. A revocation signal typically reaches the client in `2–5` minutes, after which three `2`-minute authentication grace periods can make effective disconnection approximately `10` minutes. Other client platforms currently use regular access tokens. [Current Global Secure Access limitations](https://learn.microsoft.com/en-us/entra/global-secure-access/reference-current-known-limitations).
15. **[Security boundary]** Every flow received by a connector must carry a valid token for the relevant third-party enterprise application and can target only a configured app segment; the connector-to-cloud tunnel is mutually authenticated and encrypted with TLS. The target server nevertheless performs its own authentication and authorization. [Global Secure Access FAQ](https://learn.microsoft.com/en-us/entra/global-secure-access/resource-faq).

### Incompatibilities and mutual exclusions

If private traffic must be acquired from a branch remote network without endpoint clients, Private Access cannot meet the requirement because the Private Access forwarding profile currently supports client acquisition only; retain VPN/SD-WAN/another ZTNA path or deploy supported clients. [Current Global Secure Access limitations](https://learn.microsoft.com/en-us/entra/global-secure-access/reference-current-known-limitations).

If the target is addressed only by NetBIOS short name or IPv6 and cannot be exposed by an IPv4 address or FQDN, the current Private Access client path cannot be specified because NetBIOS segments and IPv6 tunneling are unsupported. [Configure per-app access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-configure-per-app-access) [Current Global Secure Access limitations](https://learn.microsoft.com/en-us/entra/global-secure-access/reference-current-known-limitations).

### Edge cases and gotchas

- Creating or editing a segment without first assigning a user or group can cause immediate denial as soon as client policy is delivered; Microsoft recommends verifying assignments before the segment is created. [Operate Microsoft Entra Private Access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-operate-private-access).
- Quick Access is intentionally broad and useful for discovery or VPN migration; Application Discovery needs roughly `10–15` minutes of Quick Access activity before traffic appears for conversion to per-app segments. [Per-app segmentation tutorial](https://learn.microsoft.com/en-us/entra/global-secure-access/tutorial-private-access-app-segmentation).
- The Windows client cannot run on a host with a Hyper-V external virtual switch, and a host-installed client does not acquire Windows Subsystem for Linux or guest-VM traffic. Installing the client inside a supported VM is the documented alternative. [Current Global Secure Access limitations](https://learn.microsoft.com/en-us/entra/global-secure-access/reference-current-known-limitations).
- If an outbound proxy is used, the PAC file must bypass the FQDNs and IPs that Global Secure Access is expected to tunnel; otherwise the proxy can capture the traffic before the client does. [Current Global Secure Access limitations](https://learn.microsoft.com/en-us/entra/global-secure-access/reference-current-known-limitations).

### AZ-305 exam discriminator

Choose Private Access instead of application proxy when the clue specifies an FQDN/IP plus a TCP or UDP port—such as `22` SSH, `445` SMB, or `3389` RDP—and requires user/group assignment or application-specific Conditional Access. Validate the client, DNS, local-subnet, IPv4, and remote-network limits before calling it a VPN replacement. [Configure per-app access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-configure-per-app-access) [Current Global Secure Access limitations](https://learn.microsoft.com/en-us/entra/global-secure-access/reference-current-known-limitations).

### Common trap

Private Access authorizes a network flow to a narrowly defined private destination; it does not add the user to an AD group, change an NTFS ACL, grant a database role, or bypass target-side authentication. [Microsoft Entra Private Access concept](https://learn.microsoft.com/en-us/entra/global-secure-access/concept-private-access) [Windows access control overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control).

---

## Enterprise applications and Conditional Access

**Classification:** Supporting  
**Why it matters:** Enterprise-app assignment answers who may cross the Entra front door; Conditional Access answers under which identity, device, location, authentication, and risk conditions that admission is permitted.  
**Primary Microsoft source:** [Application management in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/what-is-application-management)

### Deep technical facts / requirements

1. **[Default versus configured behavior]** Enterprise applications are accessible to authenticated tenant users by default. Setting **Assignment required?** to Yes restricts supported SAML apps, preauthenticated application proxy apps, and consented OAuth/OIDC apps to explicitly assigned users, groups, or services. [Restrict an Entra app to assigned users](https://learn.microsoft.com/en-us/entra/identity-platform/howto-restrict-your-app-to-a-set-of-users).
2. **[Exception]** The assignment requirement does not apply to Global Administrators. It also prevents user consent for that application, so an administrator must grant the necessary tenant-wide consent. [Restrict an Entra app to assigned users](https://learn.microsoft.com/en-us/entra/identity-platform/howto-restrict-your-app-to-a-set-of-users).
3. **[Group assignment]** Group-based enterprise-application assignment requires Entra ID P1 or P2 and supports security groups, synchronized groups, dynamic security groups, Microsoft 365 groups, and All Users, but nested group memberships are not honored. [Use groups to manage SaaS application access](https://learn.microsoft.com/en-us/entra/identity/users/groups-saasapps) [Ways users are assigned to applications](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/ways-users-get-assigned-to-applications).
4. **[Ownership]** Enterprise-application owners can manage organization-specific SSO, provisioning, and assignment configuration; groups cannot be assigned as enterprise-application owners. Ownership is not automatically populated in every app-creation path, so ownerless apps must be detected and remediated. [Enterprise application ownership](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/overview-assign-app-owners).
5. **[Conditional Access limits]** A tenant supports up to `240` Conditional Access policies across all states—On, Off, and Report-only. Microsoft recommends consolidating common targeting and using groups or app filters rather than long lists of object GUIDs. [Plan a Conditional Access deployment](https://learn.microsoft.com/en-us/entra/identity/conditional-access/plan-conditional-access).
6. **[Safe rollout]** Report-only policies are evaluated and logged but do not enforce block, grant, or session controls and do not prompt users for MFA or terms of use. Policies created from Microsoft templates default to report-only, and Microsoft recommends a pilot plus excluded emergency-access accounts before enforcement. [Conditional Access report-only mode](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-report-only) [Plan a Conditional Access deployment](https://learn.microsoft.com/en-us/entra/identity/conditional-access/plan-conditional-access).
7. **[Recovery]** Deleted Conditional Access policies and named locations have a `30`-day soft-delete recovery window. That recovery feature does not replace excluding and monitoring emergency-access accounts because a bad active policy can lock administrators out immediately. [Plan a Conditional Access deployment](https://learn.microsoft.com/en-us/entra/identity/conditional-access/plan-conditional-access).
8. **[SKU gating]** Common Conditional Access controls require Entra ID P1; user-risk and sign-in-risk policies require Entra ID P2. Security defaults provide a basic baseline for tenants without P1/P2 but are not a substitute for application-specific Conditional Access design. [Conditional Access documentation](https://learn.microsoft.com/en-us/entra/identity/conditional-access/) [Plan a Conditional Access deployment](https://learn.microsoft.com/en-us/entra/identity/conditional-access/plan-conditional-access).

### Incompatibilities and mutual exclusions

If application proxy is configured for passthrough, app-targeted Conditional Access cannot be the front-door control because passthrough does not authenticate the request with Entra ID; use Entra preauthentication or enforce the requirement elsewhere. [Application proxy FAQ](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-faq).

### Edge cases and gotchas

- An enterprise-app assignment can grant admission yet convey no useful back-end role; app roles, token claims, KCD identity mapping, AD groups, or application-local permissions must still be designed. [Plan an SSO deployment](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/plan-sso-deployment).
- A service principal placed in a group does not receive the `roles` claim merely because that group was assigned an app role; assign the app role directly to the service principal when application-to-application authorization depends on it. [Add app roles and receive them in tokens](https://learn.microsoft.com/en-us/entra/identity-platform/howto-add-app-roles-in-apps).
- A report-only policy scoped to User Actions is not evaluated like normal report-only cloud-app policies, so test the exact policy scope rather than assuming every setting is simulated. [Conditional Access report-only mode](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-report-only).

### AZ-305 exam discriminator

When a scenario says “only assigned users may reach the internal app,” set the enterprise application to require assignment and use direct group assignment; add Conditional Access for MFA/device/risk conditions, but keep the target's role or ACL as a separate authorization layer. [Restrict an Entra app to assigned users](https://learn.microsoft.com/en-us/entra/identity-platform/howto-restrict-your-app-to-a-set-of-users) [Conditional Access overview](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview).

### Common trap

“All users can sign in” is the default for many enterprise apps, so merely creating an app registration or publishing an application does not establish least privilege; **Assignment required?** must be intentionally enabled where supported. [Application management in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/what-is-application-management).

---

## AD DS security groups and Windows ACLs

**Classification:** Core  
**Why it matters:** These controls are the final authorization language for many on-premises files, folders, servers, printers, AD objects, and applications after any proxy, Private Access, VPN, or SSO layer succeeds.  
**Primary Microsoft source:** [Active Directory security groups](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups)  
**Limits and quotas source:** [Active Directory security groups and scopes](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups)

### Deep technical facts / requirements

1. **[Principal model]** Windows represents users, computers, and groups with SIDs and evaluates those SIDs against an object's ACL after authentication. Permissions such as Read, Write, Modify, and Full Control are authorization decisions; authentication alone never implies them. [Windows access control overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control).
2. **[Group types]** Only security groups can be placed in DACLs and used to grant permissions; distribution groups are for email distribution and are not security enabled. [Active Directory security groups](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups).
3. **[Group-scope constraint]** Global groups can contain accounts and global groups only from their own domain but can receive permissions in the same forest or trusting domains/forests. Domain Local groups can contain accounts and groups from trusted domains but grant permissions only in their own domain. Universal groups can contain accounts, global groups, and universal groups from any domain in the forest and can grant permissions throughout the forest or trusting forests. [Active Directory group-scope rules](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups).
4. **[Nesting and conversion]** A Global group can be converted to Universal only if it is not a member of another Global group; a Domain Local group can be converted to Universal only if it contains no other Domain Local group. Group nesting therefore affects later scope changes and cross-domain authorization design. [Active Directory group-scope rules](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups).
5. **[Inheritance]** Child files and folders inherit only access-control entries marked inheritable from their parent container. Ownership is distinct from a granted permission: the owner can change an object's permissions even when other ACL entries are restrictive. [Windows access control overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control).
6. **[SMB transport versus authorization]** Requiring SMB Encryption permits only SMB `3.0`, `3.02`, and `3.1.1` clients by default; older clients are rejected. SMB Encryption protects the transport and is unrelated to EFS, while share and NTFS permissions still determine resource access. [SMB security enhancements](https://learn.microsoft.com/en-us/windows-server/storage/file-server/smb-security).
7. **[Least-privilege operations]** Microsoft recommends placing permissions on security groups instead of individual users so membership changes grant or revoke the existing rights consistently. User rights, resource permissions, and group membership are separate objects and must all be considered in a legacy authorization design. [Active Directory security groups](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups).
8. **[Resiliency dependency]** Kerberos/group authorization depends on reachable domain controllers, working DNS, valid trust paths, and time synchronization; making a proxy connector redundant does not remove those AD dependencies. [Application proxy KCD configuration](https://learn.microsoft.com/en-us/entra/identity/app-proxy/how-to-configure-sso-with-kcd).
9. **[Defaults]** A null DACL grants full access because Windows performs no normal DACL check, whereas an allocated but empty DACL grants no access because it contains no allow ACEs. Confusing the two produces opposite authorization outcomes. [Null and empty DACL behavior](https://learn.microsoft.com/en-us/windows/win32/secauthz/null-dacls-and-empty-dacls).
10. **[Networking and version gating]** Traditional direct-hosted SMB uses TCP `445`; Windows Server 2025 and Windows 11 add SMB `3.1.1` alternative-port support. Windows 11 24H2 and Windows Server 2025 also require inbound and outbound SMB signing by default, so legacy unsigned clients can be rejected even when their ACL permissions are correct. [SMB feature descriptions](https://learn.microsoft.com/en-us/windows-server/storage/file-server/smb-feature-descriptions) [SMB security hardening](https://learn.microsoft.com/en-us/windows-server/storage/file-server/smb-security-hardening).

### Incompatibilities and mutual exclusions

If a group is a distribution group and the target enforces a Windows DACL, that group cannot grant access because distribution groups are not security enabled; use an appropriately scoped security group. [Active Directory security groups](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups).

### Edge cases and gotchas

- A user's effective authorization can remain stale until the relevant sign-in token, Kerberos ticket, SMB session, or application session is renewed; changing group membership does not necessarily terminate an existing resource session immediately. [Windows access control overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control).
- A VPN, ExpressRoute circuit, application proxy assignment, or Private Access segment can make the server reachable while its DACL correctly returns Access Denied. [Windows access control overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control).
- Domain Admins is a service-administrator group with broad control and is a member of Administrators on domain-joined computers by default; it is not an acceptable routine resource-access group. [Active Directory security groups](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups).

### AZ-305 exam discriminator

For an on-premises SMB share or Windows-integrated legacy app, recommend an identity-aware access path plus an AD security-group/ACL model. The path answers who may connect; the DACL or application role answers what the authenticated SID may do. [Windows access control overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control) [Active Directory security groups](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups).

### Common trap

A private network is not an authorization boundary for individual files or application operations; network admission and DACL evaluation are independent controls. [Windows access control overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control).

---

## Microsoft Entra Cloud Sync group provisioning to AD DS

**Classification:** Core  
**Why it matters:** Cloud Sync group provisioning lets approvals and cloud group membership drive the AD security-group membership that an unchanged Kerberos/LDAP application already trusts.  
**Primary Microsoft source:** [Govern on-premises applications with Cloud Sync](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/govern-on-premises-groups)  
**Limits and quotas source:** [Cloud Sync prerequisites and group-provisioning limits](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites)

### Deep technical facts / requirements

1. **[Limits]** A group provisioned from Entra ID to AD DS cannot exceed `50,000` members. In Selected security groups mode, a job supports up to `10,000` in-scope groups and `250,000` total direct membership links; All security groups mode with an attribute filter supports up to `20,000` groups and `500,000` direct membership links. [Cloud Sync group-provisioning scale limits](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites).
2. **[Portal versus API limit]** The Cloud Sync portal can select and display only `999` groups. To scope `1,000` or more—up to the job's documented scale guidance—assign groups to the job's service principal through Microsoft Graph. [Cloud Sync expanded group selection](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites).
3. **[Unsupported scope]** “All security groups” without an attribute scoping filter is unsupported. Microsoft directs tenants above `200,000` users, `40,000` groups, or `1,000,000` memberships to Selected security groups mode; exceeding the guidance can slow initial and delta sync or cause errors. [Cloud Sync group-provisioning scale limits](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites).
4. **[Membership identity requirement]** Provisioned groups can contain on-premises-synchronized users or other cloud-created security groups. A synchronized user must have `onPremisesObjectIdentifier` matching `objectGUID` in the target AD DS environment, so an unrelated cloud-only identity cannot simply be written into an existing AD authorization model as an AD user. [Cloud Sync group-provisioning prerequisites](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites).
5. **[Tenant and topology constraint]** Only global workforce Entra tenants can provision groups to AD DS; B2C tenants are unsupported. Cloud Sync over NAT between AD forests is also unsupported because the underlying AD topology does not support that dependency. [Cloud Sync group-provisioning prerequisites](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites) [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).
6. **[Schedule and revocation]** The Entra-to-AD group-provisioning job is scheduled every `20` minutes; general cloud provisioning for users and groups runs approximately every `10–20` minutes depending on pending volume. Removal from a cloud entitlement therefore is not an immediate AD or application-session revocation. [Cloud Sync group-provisioning prerequisites](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites) [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).
7. **[Agent requirements]** The provisioning-agent server must be domain joined, have TLS `1.2` enabled and at least .NET Framework `4.7.1`, and reach the cloud over outbound ports `80` and `443`; optional port `8080` reports agent health every `10` minutes when `443` is unavailable for that status path. [Cloud Sync prerequisites](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites).
8. **[Resiliency]** Installing multiple provisioning agents does not load-balance synchronization; only `1` agent is active. Multiple agents provide failover, so capacity planning must size an individual active agent for the full job and test failover rather than assuming active/active throughput. [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).
9. **[Version lifecycle]** Provisioning agents are automatically upgraded by Microsoft and there is no supported way to disable automatic upgrades. Host-change control must accommodate that servicing model. [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).
10. **[Nested groups]** Scale accounting and provisioning guidance are based on direct memberships. Nested objects beyond the first level are not included when security-group scoping is used, so a design must test both which groups are in scope and which membership links the target receives. [Cloud Sync configuration and group scoping](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-configure) [Cloud Sync prerequisites](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites).
11. **[Architecture boundary]** Cloud Sync is appropriate only when the target authorizes through AD group membership. If the application instead stores accounts or roles in SQL, LDAP, REST, SOAP, or another private repository, use application provisioning and the appropriate SCIM/ECMA connector. [Cloud Sync overview](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync) [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).

### Incompatibilities and mutual exclusions

If a required group contains more than `50,000` members, a single Cloud Sync group-provisioning object cannot be used; split the entitlement into smaller groups or change the authorization/provisioning design. [Cloud Sync group-provisioning scale limits](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites).

If the legacy application does not evaluate AD group membership, Cloud Sync group provisioning cannot grant its application-local role; use Entra application provisioning with a connector the repository supports. [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).

### Edge cases and gotchas

- The portal's `999`-group selection ceiling is not the service's `10,000`-group Selected mode ceiling; Microsoft Graph is required beyond the portal boundary. [Cloud Sync expanded group selection](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites).
- A group membership removed in Entra can remain effective through the next provisioning cycle and any existing Kerberos or application session; measure end-to-end revocation, not only job completion. [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).
- A preferred domain-controller list is optional. Without one, the active agent can use any available DC in the domain, which changes the failure-domain and firewall assumptions. [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).
- Selecting every security group without an attribute filter is unsupported even if the current group count appears small. [Cloud Sync group-provisioning scale limits](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites).

### AZ-305 exam discriminator

Choose Cloud Sync group provisioning when the unchanged on-premises application already authorizes an AD security group and the organization wants Entra entitlement governance to control that membership. Choose application provisioning when the target has a different account or role repository. [Govern on-premises applications with Cloud Sync](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/govern-on-premises-groups) [On-premises application provisioning architecture](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/on-premises-application-provisioning-architecture).

### Common trap

Cloud Sync's scheduled provisioning is neither instantaneous revocation nor a remote-access path; connectors/Private Access/VPN supply reachability, and the target continues to enforce AD membership and its own sessions. [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq) [Microsoft Entra Private Access concept](https://learn.microsoft.com/en-us/entra/global-secure-access/concept-private-access).

---

## Microsoft Entra application provisioning

**Classification:** Supporting  
**Why it matters:** Application provisioning is the lifecycle bridge when an on-premises application uses its own identity repository instead of AD group membership.  
**Primary Microsoft source:** [On-premises application provisioning architecture](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/on-premises-application-provisioning-architecture)

### Deep technical facts / requirements

1. **[Protocols]** The Entra provisioning service acts as a SCIM `2.0` client and uses HTTPS with TLS `1.2`. For private targets, the provisioning agent can translate the operations through an ECMA host to LDAP, SQL, REST, SOAP, PowerShell, or a custom/partner connector. [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).
2. **[Dependency]** The ECMA Connector Host is not required when the application exposes a SCIM endpoint or a SCIM gateway; Microsoft Identity Manager Synchronization is also not a prerequisite for this architecture. [On-premises application provisioning architecture](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/on-premises-application-provisioning-architecture).
3. **[Cycle timing]** After the initial full evaluation, a standard outbound application-provisioning job automatically performs incremental cycles on an approximately `40`-minute interval. Changing attribute mappings or scoping filters triggers a new initial cycle. [Configure automatic user provisioning](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/configure-automatic-user-provisioning-portal) [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).
4. **[Deprovisioning defaults]** When a previously managed user becomes unassigned, disabled, soft-deleted, or out of scope, the default action is to disable/soft-delete the target account. In SCIM this normally sets `active=false`; a permanent Entra deletion occurs after the `30`-day soft-delete window and can cause a target DELETE when configured and supported. [Application provisioning deprovisioning behavior](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).
5. **[Management boundary]** The service caches which target accounts it manages so that an initial cycle does not deprovision unrelated pre-existing accounts that were never in scope. Removing an assignment sends a disable request, after which the object is no longer managed and a later Entra deletion does not automatically send another delete. [Configure automatic user provisioning](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/configure-automatic-user-provisioning-portal) [Application provisioning deprovisioning behavior](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).
6. **[Quarantine limits]** A job can enter quarantine when more than `40%` of events fail after at least `5,000` failures, when nonreference failures exceed `40,000`, or when total reference plus nonreference failures exceed `60,000`. In quarantine, incremental cycles taper to once daily; after more than `4` weeks the job is disabled. [Application provisioning quarantine](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/application-provisioning-quarantine-status).
7. **[Retry behavior]** General quarantine retries occur after `6`, `12`, and `24` hours, then every `24` hours for up to `28` days. Fixing the error and completing the next successful cycle releases the job from quarantine. [Application provisioning quarantine](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/application-provisioning-quarantine-status).
8. **[Resiliency]** For an ECMA-based private app, Microsoft recommends `1` active agent plus `1` configured but stopped passive agent per datacenter rather than two simultaneously assigned active agents. [On-premises application provisioning architecture](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/on-premises-application-provisioning-architecture).

### Incompatibilities and mutual exclusions

If an application has no supported SCIM endpoint, ECMA/partner connector, or writable target API/repository, Entra application provisioning cannot create its local accounts; use the application's supported lifecycle mechanism or modernize the app. [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).

### Edge cases and gotchas

- A disabled Entra user cannot be newly provisioned; the source user must be active before the service provisions it. [Application provisioning deprovisioning behavior](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).
- Restoring a soft-deleted user reactivates the target account but does not automatically restore dynamic target-group membership; a provisioning restart or target-side handling might be required. [Application provisioning edge cases](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).
- Turning Provisioning Status Off pauses create, update, and remove operations; turning it On resumes from the existing state rather than proving that stale access was removed while paused. [Configure automatic user provisioning](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/configure-automatic-user-provisioning-portal).

### AZ-305 exam discriminator

Use application provisioning—not Cloud Sync group provisioning—when the on-premises application authorizes accounts or entitlements in LDAP, SQL, REST, SOAP, PowerShell, SCIM, or an ECMA-compatible repository. [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).

### Common trap

Provisioning an account or role does not publish the application or authenticate its sessions; it must be paired with the correct access path and SSO/authentication method. [On-premises application provisioning architecture](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/on-premises-application-provisioning-architecture) [Application proxy SSO](https://learn.microsoft.com/en-us/entra/identity/app-proxy/how-to-configure-sso).

---

## Microsoft Entra ID Governance: entitlement management and access reviews

**Classification:** Supporting  
**Why it matters:** Governance controls who may request an entitlement, who approves it, how long it lasts, and whether continuing access is recertified; it delegates enforcement to the resulting group or app assignment.  
**Primary Microsoft source:** [Microsoft Entra ID Governance overview](https://learn.microsoft.com/en-us/entra/id-governance/identity-governance-overview)

### Deep technical facts / requirements

1. **[Access-package structure]** Every access package belongs to a catalog and can grant roles across multiple catalog resources, including groups and enterprise applications. An existing access package cannot be moved to another catalog. [Create an access package](https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-access-package-create).
2. **[Policy behavior]** Request visibility and eligibility are controlled independently by catalog state, external-user enablement, the access package's Hidden setting, and enabled policies whose requester scope matches the user. A hidden package can still be requested through its direct link when policy permits. [Access-package visibility](https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-access-package-visibility) [Entitlement request process](https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-process).
3. **[Lifecycle]** An approved access-package request starts assignment to each packaged resource; expiration or removal withdraws those assignments, but downstream Cloud Sync/provisioning cycles and existing application sessions determine when the on-premises resource stops honoring access. [Entitlement request process](https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-process) [Private Access governance scenario](https://learn.microsoft.com/en-us/entra/id-governance/scenarios/entitlement-management-private-access).
4. **[Reviews]** Access reviews can recertify group or application access and can use self-review or designated reviewers. A review captures a snapshot at the beginning of each review instance; membership changes during the review appear in the next review cycle rather than rewriting the current snapshot. [Create an access review](https://learn.microsoft.com/en-us/entra/id-governance/create-access-review).
5. **[Reminders]** By default, Entra sends reviewers an email when a review starts and automatically sends a reminder halfway to the review end date to reviewers who have not responded. Applying review decisions is a separate completion action unless automatic application is configured. [Manage access reviews](https://learn.microsoft.com/en-us/entra/id-governance/manage-access-review).
6. **[Roles]** Creating/managing normal group or application reviews requires User Administrator or Identity Governance Administrator; reviews of role-assignable groups require Privileged Role Administrator. **[Preview]** Group-owner review creation is available only when enabled by an Identity Governance Administrator. [Manage access reviews](https://learn.microsoft.com/en-us/entra/id-governance/manage-access-review).
7. **[Licensing]** Current access-review and entitlement capabilities require Microsoft Entra ID Governance or Microsoft Entra Suite licensing, with some legacy capabilities also operating under Entra ID P2. Licensing applies both to users whose access is reviewed and reviewers; for example, `75` reviewed members plus `1` separate reviewer require `76` licenses. [Microsoft Entra ID Governance licensing](https://learn.microsoft.com/en-us/entra/id-governance/licensing-fundamentals).

### Incompatibilities and mutual exclusions

If the target resource is not represented by a group, enterprise-app role, SharePoint role, or another supported catalog resource—and no provisioning bridge writes to its repository—an access package cannot directly enforce permission in that target. [Create an access package](https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-access-package-create) [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).

### Edge cases and gotchas

- Entitlement management governs the assignment lifecycle; it does not create a guest's corresponding AD account for KCD or add a target-local role unless the packaged group/app assignment and provisioning design explicitly do so. [Private Access governance scenario](https://learn.microsoft.com/en-us/entra/id-governance/scenarios/entitlement-management-private-access).
- Access review suggestions assist reviewers but do not replace the configured decision and apply-results behavior. A completed review must actually remove the underlying assignment to revoke access. [Manage access reviews](https://learn.microsoft.com/en-us/entra/id-governance/manage-access-review).
- The July 2025 announcement to change visibility for packages scoped to Specific users and groups was cancelled; current visibility still follows catalog, hidden, and matching-policy checks. [Access-package visibility](https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-access-package-visibility).

### AZ-305 exam discriminator

When clues say **request**, **approval**, **justification**, **expiration**, or **periodic recertification**, wrap the group or enterprise-app assignment in an access package and add access reviews; do not replace the resource's group, role, or ACL with governance terminology. [Create an access package](https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-access-package-create) [Access reviews overview](https://learn.microsoft.com/en-us/entra/id-governance/access-reviews-overview).

### Common trap

An expired access-package assignment is not proof of instant resource revocation; synchronization, token, Kerberos-ticket, and target-session lifetimes can extend effective access and must be tested end to end. [Private Access governance scenario](https://learn.microsoft.com/en-us/entra/id-governance/scenarios/entitlement-management-private-access) [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq).

---

## Microsoft Entra Domain Services

**Classification:** Adjacent  
**Why it matters:** Domain Services is relevant when an AD-dependent application is lifted into Azure and needs managed LDAP, Kerberos, NTLM, domain join, or Group Policy without customer-managed domain controllers; it is not normally the authorization service for a resource that remains on-premises.  
**Primary Microsoft source:** [Microsoft Entra Domain Services overview](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview)

### Deep technical facts / requirements

1. **[Directory boundary]** A managed domain is a standalone domain, not a replica or extension of the on-premises forest. Users, groups, memberships, and credential hashes synchronize one way from Entra ID; changes made in the managed domain do not synchronize back. [Domain Services overview](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview) [Domain Services synchronization](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization).
2. **[Credential prerequisite]** Existing cloud-only users must change their password after Domain Services is enabled so Entra can generate the NTLM- and Kerberos-compatible hashes. Hybrid identities require the configured password-hash synchronization path for those legacy hashes. [Domain Services synchronization](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization).
3. **[Administration limits]** Domain Services provides no Domain Admin or Enterprise Admin privileges and does not support schema extensions. It supports only resource-based KCD, while self-managed AD DS supports both resource-based and account-based KCD. [Compare Microsoft directory services](https://learn.microsoft.com/en-us/entra/identity/domain-services/compare-identity-solutions).
4. **[KCD constraint]** Resource-based KCD cannot be configured on computer accounts in the built-in Microsoft Entra DC Computers container. The relevant computers/service accounts must be in a custom OU where permissions can be delegated; synchronized Entra user accounts cannot serve as the custom service accounts for that configuration. [Configure KCD in Domain Services](https://learn.microsoft.com/en-us/entra/identity/domain-services/deploy-kcd).
5. **[SKU guidance]** Current recommended capacity is Standard up to `25,000` objects and `3,000` authentications/hour, Enterprise `25,001–100,000` objects and `3,001–10,000` authentications/hour, and Premium `100,001–500,000` objects and `10,001–70,000` authentications/hour. Microsoft labels these as capacity guidance rather than hard enforced limits. [Domain Services management and SKU concepts](https://learn.microsoft.com/en-us/entra/identity/domain-services/administration-concepts).
6. **[Backup gating]** Standard is backed up every `5` days, Enterprise every `3` days, and Premium daily; Premium backups are retained `7` days, with every third backup retained `30` days. [Domain Services management and SKU concepts](https://learn.microsoft.com/en-us/entra/identity/domain-services/administration-concepts).
7. **[Replica-set limits]** A managed domain supports up to `5` replica sets total—the initial set plus `4` additional sets. Additional sets require Enterprise or Premium, must be in the same subscription, and each set is billed independently at the domain's SKU. [Domain Services replica sets](https://learn.microsoft.com/en-us/entra/identity/domain-services/concepts-replica-sets).
8. **[Trust gating]** Forest trusts require Enterprise or Premium; Enterprise supports up to `5` trusts, and a domain cannot be downgraded to a SKU whose trust limit is below the number already configured. [Change a Domain Services SKU](https://learn.microsoft.com/en-us/entra/identity/domain-services/change-sku) [Compare Microsoft directory services](https://learn.microsoft.com/en-us/entra/identity/domain-services/compare-identity-solutions).
9. **[LDAPS]** Secure LDAP uses TCP `636` and requires a trusted TLS server-authentication certificate with a wildcard subject/SAN for the managed domain, digital-signature and key-encipherment usage, and at least `3–6` months remaining validity. Internet exposure should be restricted to known source IPs with an NSG. [Configure secure LDAP for Domain Services](https://learn.microsoft.com/en-us/entra/identity/domain-services/tutorial-configure-ldaps).
10. **[Built-in resiliency]** Each replica set contains managed domain controllers and uses availability zones where the region supports them, but directory redundancy does not make a single application server or database redundant. [Domain Services overview](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview) [Domain Services replica sets](https://learn.microsoft.com/en-us/entra/identity/domain-services/concepts-replica-sets).

### Incompatibilities and mutual exclusions

If the migrated application requires schema extension, Domain/Enterprise Admin, or account-based KCD, Domain Services cannot satisfy it; deploy and operate self-managed AD DS instead. [Compare Microsoft directory services](https://learn.microsoft.com/en-us/entra/identity/domain-services/compare-identity-solutions).

### Edge cases and gotchas

- Secure LDAP simple binds fail when NTLM password-hash synchronization is disabled because the bind needs the compatible password material. [Configure secure LDAP for Domain Services](https://learn.microsoft.com/en-us/entra/identity/domain-services/tutorial-configure-ldaps).
- The default managed-domain password lifetime is `90` days and is not synchronized from the Entra ID password-lifetime setting. [Domain Services FAQ](https://learn.microsoft.com/en-us/entra/identity/domain-services/faqs).
- A misconfigured NSG or user-defined route on the managed-domain subnet can break management, patching, and Entra-to-domain synchronization; the required service rules must remain intact. [Domain Services network planning](https://learn.microsoft.com/en-us/entra/identity/domain-services/network-considerations).

### AZ-305 exam discriminator

Choose Domain Services for an Azure-hosted lift-and-shift workload needing managed LDAP/Kerberos/NTLM/GPO and no full-domain administrative control. Keep existing AD DS or deploy self-managed AD DS when the workload remains on-premises or needs unrestricted schema, trust, or administrator features. [Compare Microsoft directory services](https://learn.microsoft.com/en-us/entra/identity/domain-services/compare-identity-solutions).

### Common trap

Domain Services is not a managed replica of the on-premises forest; one-way synchronization does not copy on-premises OUs, GPOs, computer objects, or arbitrary domain configuration into it. [Domain Services synchronization](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization).

---

## Azure Arc-enabled servers SSH

**Classification:** Adjacent  
**Why it matters:** Arc SSH is the specialized answer for Azure-mediated administration of an on-premises server, not for publishing an end-user business application.  
**Primary Microsoft source:** [SSH access to Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/azure-arc/servers/ssh-arc-overview)

### Deep technical facts / requirements

1. **[Network requirement]** Arc SSH reaches Windows or Linux Arc-enabled servers without a public IP address, inbound SSH firewall rule, or VPN; the server's Connected Machine agent maintains the outbound Azure connection. [SSH access to Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/azure-arc/servers/ssh-arc-overview).
2. **[Version requirement]** The server needs Connected Machine agent version `1.31.x` or later and a running OpenSSH `sshd` service. Windows Server 2025 includes OpenSSH by default; earlier supported Windows servers might need it installed and enabled. [SSH access to Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/azure-arc/servers/ssh-arc-overview).
3. **[Two authorization gates]** Owner or Contributor on the Arc server authorizes creation of the SSH connection but does not grant Entra operating-system login. Linux Entra login separately requires Virtual Machine Administrator Login or Virtual Machine User Login. [SSH access to Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/azure-arc/servers/ssh-arc-overview).
4. **[OS constraint]** Entra user authentication over Arc SSH is Linux-only and requires the `AADSSHLoginForLinux` extension packages; Windows Arc SSH supports local-user authentication. [SSH access to Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/azure-arc/servers/ssh-arc-overview).
5. **[Role scope]** The two VM login roles contain `dataActions` and can be assigned at management-group, subscription, resource-group, or resource scope. Microsoft recommends management-group, subscription, or resource scope rather than many individual-VM assignments to reduce pressure on role-assignment limits. [SSH access to Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/azure-arc/servers/ssh-arc-overview).
6. **[Availability]** Arc SSH is documented as available in all cloud regions supported by Arc-enabled servers, so the main design dependencies are agent health, outbound connectivity, `sshd`, and the chosen OS authentication method rather than a separate Arc SSH regional list. [SSH access to Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/azure-arc/servers/ssh-arc-overview).

### Incompatibilities and mutual exclusions

If the requirement is Entra-authenticated administrative login to a Windows server, the current Arc SSH path cannot provide that identity method because Entra login is Linux-only; use local-user authentication through Arc SSH or another Windows administration design. [SSH access to Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/azure-arc/servers/ssh-arc-overview).

### Edge cases and gotchas

- Granting Owner solely to permit Arc SSH is broader than the OS-login requirement; connection permission and the two VM Login roles should be scoped separately and activated just in time where possible. [SSH access to Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/azure-arc/servers/ssh-arc-overview).
- Arc SSH depends on the Connected Machine agent and outbound Azure connectivity, so a local emergency-access procedure is still required for extended disconnection. [Troubleshoot Arc-enabled server connectivity](https://learn.microsoft.com/en-us/azure/azure-arc/servers/troubleshoot-connectivity).
- Arc SSH is an administrative channel for SSH/PowerShell tooling, not a general-purpose path for users to browse an on-premises web application or connect to arbitrary business ports. [SSH access to Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/azure-arc/servers/ssh-arc-overview).

### AZ-305 exam discriminator

Choose Arc SSH when the target is the server itself and the clues are **administrative SSH**, **no public IP**, and **no open inbound port**. Choose application proxy or Private Access when the target is an application/resource rather than server administration. [SSH access to Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/azure-arc/servers/ssh-arc-overview) [Application proxy overview](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy) [Private Access concept](https://learn.microsoft.com/en-us/entra/global-secure-access/concept-private-access).

### Common trap

Azure Owner/Contributor permits the Arc connection operation but does not automatically authorize Linux sign-in; an applicable VM Login role is still required for Entra OS login. [SSH access to Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/azure-arc/servers/ssh-arc-overview).

---

## VPN, ExpressRoute, and Zero Trust authorization architecture

**Classification:** Architecture guidance  
**Why it matters:** These concepts enforce the task boundary: connectivity delivers a request to an enforcement point, but authorization decides whether the authenticated principal may perform the requested operation.  
**Primary Microsoft source:** [Azure Well-Architected identity and access guidance](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access)

### Deep technical facts / requirements

1. **[Control separation]** A complete hybrid design contains at least four independently testable gates: identity authentication, cloud admission/Conditional Access, connectivity through the publishing or private-access plane, and target-side authorization. Centralized identity and explicit least privilege do not remove resource-specific enforcement. [Well-Architected identity and access guidance](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access) [Windows access control overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control).
2. **[Connectivity boundary]** VPN Gateway connects an Azure virtual network to on-premises sites or individual clients through encrypted tunnels; it supplies network connectivity, while the destination's AD/app/database authorization still decides permitted operations. [About Azure VPN Gateway](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways) [Windows access control overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control).
3. **[Segmentation]** Quick Access can publish broad ranges during VPN migration, but per-app Private Access segments bind assignments and Conditional Access to exact destinations, ports, and protocols and should replace broad scopes after discovery. [Per-app Private Access segmentation](https://learn.microsoft.com/en-us/entra/global-secure-access/tutorial-private-access-app-segmentation).
4. **[Least privilege]** Microsoft recommends group-based assignment, separation of duties, avoiding permanent access, recurring access reviews, and explicit emergency-access procedures. Those governance controls must be connected to the actual group, application role, or ACL that the resource enforces. [Well-Architected identity and access guidance](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access).
5. **[End-to-end resilience]** Redundant access connectors do not cover failures in DNS, domain controllers/Kerberos, certificates, the application, its data tier, or governance processes; Microsoft resilience guidance requires those downstream dependencies to be designed and tested separately. [Resilience for on-premises application access](https://learn.microsoft.com/en-us/entra/architecture/resilience-on-premises-access).

### Incompatibilities and mutual exclusions

If the requirement is per-user, per-application authorization to a file, database operation, or application role, VPN or ExpressRoute alone cannot satisfy it because network reachability does not modify the target permission model. [Windows access control overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control) [Azure VPN Gateway overview](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways).

### Edge cases and gotchas

- A “private” IP path can still expose a broad lateral-movement surface; the narrowest supported app segment and explicit resource authorization remain necessary. [Per-app Private Access segmentation](https://learn.microsoft.com/en-us/entra/global-secure-access/tutorial-private-access-app-segmentation).
- Revocation time is determined by the slowest assignment, provisioning, group synchronization, token, Kerberos ticket, session, and target cache—not by the governance portal's displayed state alone. [Cloud Sync FAQ](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/reference-cloud-sync-faq) [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works).
- Break-glass access should bypass a failed cloud dependency without creating a permanent broad authorization exception; Conditional Access guidance requires emergency accounts to be excluded and monitored. [Plan a Conditional Access deployment](https://learn.microsoft.com/en-us/entra/identity/conditional-access/plan-conditional-access).

### AZ-305 exam discriminator

When both connectivity and authorization appear in a scenario, answer both: select the narrowest supported route (application proxy, Private Access, Arc SSH, or VPN) and state the target enforcement mechanism (enterprise-app assignment, AD group/ACL, database role, or application-local role). [Application proxy overview](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy) [Private Access concept](https://learn.microsoft.com/en-us/entra/global-secure-access/concept-private-access) [Windows access control overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control).

### Common trap

“The network is private” does not mean “the user is authorized”; it states only that a private route exists. [Windows access control overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control).

---

## Highest-yield exam discriminators

| Scenario clue | Best answer | Why |
|---|---|---|
| Publish one on-premises web app to remote users with MFA and no inbound firewall rule | Application proxy with Entra preauthentication | It publishes HTTP/HTTPS through connector-initiated outbound `80/443` connections and evaluates Conditional Access before the request reaches the private network. [Application proxy overview](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy) [Application proxy security](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-security). |
| Back-end web app uses IWA and users need seamless SSO | Application proxy with KCD | The connector and app must be in the same or trusting domains with a correct SPN and delegation; KCD supplies the Kerberos ticket but not the user's app role. [Application proxy KCD configuration](https://learn.microsoft.com/en-us/entra/identity/app-proxy/how-to-configure-sso-with-kcd). |
| Publish an app but allow the back end to perform the initial authentication | Application proxy passthrough only when unavoidable | Passthrough cannot enforce Entra Conditional Access and allows unauthenticated requests to reach the private app, whereas preauthentication blocks them in the cloud. [Application proxy FAQ](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-faq) [Application proxy security](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-security). |
| Slow web transaction takes `120` seconds | Application proxy with Long back-end timeout | The default is `75` seconds and Long permits up to `180` seconds. [Application proxy deployment planning](https://learn.microsoft.com/en-us/entra/identity/app-proxy/conceptual-deployment-plan). |
| Users need RDP, SSH, SMB, LDAP, or a database port with per-app assignment | Microsoft Entra Private Access | Per-app segments accept FQDN/IPv4 destinations, ports, and TCP/UDP; application proxy is web-specific. [Configure per-app access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-configure-per-app-access) [Application proxy overview](https://learn.microsoft.com/en-us/entra/identity/app-proxy/overview-what-is-app-proxy). |
| A branch must reach private apps without endpoint clients | VPN/SD-WAN/another supported access path, not current Private Access acquisition | Private Access traffic currently requires the Global Secure Access client and cannot be acquired from a remote network. [Current Global Secure Access limitations](https://learn.microsoft.com/en-us/entra/global-secure-access/reference-current-known-limitations). |
| Per-app Private Access design needs `600` distinct segments in one enterprise app | Split the design across nonoverlapping apps or simplify segments | A Private Access enterprise app supports at most `500` segments, and per-app segments cannot overlap each other. [Configure per-app access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-configure-per-app-access). |
| Quick Access covers a subnet but a more specific per-app segment is created | Assign the required users directly to the per-app app before rollout | The per-app segment takes priority; unassigned users are denied and Quick Access is not fallback. Allow about `15` minutes for client propagation. [Configure per-app access](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-configure-per-app-access). |
| Only members of a department may cross the Entra app gate | Require enterprise-app assignment and directly assign a group | Apps are broadly available by default; requiring assignment restricts sign-in, while nested group membership is unsupported for group-based application assignment. [Restrict an Entra app to assigned users](https://learn.microsoft.com/en-us/entra/identity-platform/howto-restrict-your-app-to-a-set-of-users) [Use groups to manage application access](https://learn.microsoft.com/en-us/entra/identity/users/groups-saasapps). |
| Assigned user passes MFA but receives Access Denied from the internal app | Fix back-end identity/role/group/ACL mapping | Entra admission and the target's authorization decision are independent gates. [Troubleshoot application proxy](https://learn.microsoft.com/en-us/entra/identity/app-proxy/application-proxy-troubleshoot). |
| On-premises app authorizes through an AD security group and membership should be cloud governed | Entitlement/access package → Entra security group → Cloud Sync group provisioning → AD group/ACL | Cloud Sync writes the membership the unchanged app understands; jobs run about every `20` minutes and groups above `50,000` members are unsupported. [Cloud Sync group-provisioning prerequisites](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites). |
| Cloud Sync job must scope `1,500` selected groups | Use Microsoft Graph for expanded group selection | The portal selects/displays only `999`, while Selected security groups mode supports up to `10,000` groups and `250,000` direct membership links. [Cloud Sync expanded group selection](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-prerequisites). |
| Private application stores users and roles in SQL rather than AD groups | Entra application provisioning with an ECMA/SQL connector | The provisioning agent translates SCIM operations to SQL/LDAP/REST/SOAP/PowerShell; Cloud Sync group provisioning targets AD-based authorization instead. [How application provisioning works](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/how-provisioning-works). |
| Project access must be requested, approved, expire automatically, and be recertified | Entitlement management plus access reviews | Access packages govern request/approval/expiration across group and app roles, while access reviews recertify continuing assignment; enforcement still occurs in the packaged resource and downstream target. [Create an access package](https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-access-package-create) [Create an access review](https://learn.microsoft.com/en-us/entra/id-governance/create-access-review). |
| Azure-migrated legacy workload needs LDAP, Kerberos, domain join, and GPO without DC operations | Microsoft Entra Domain Services | It supplies managed legacy directory protocols, built-in domain-controller HA, and one-way Entra synchronization. [Domain Services overview](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview) [Domain Services synchronization](https://learn.microsoft.com/en-us/entra/identity/domain-services/synchronization). |
| Same migrated app needs schema extension, Domain Admin, or account-based KCD | Self-managed AD DS on Azure VMs | Domain Services supports none of those requirements and permits only resource-based KCD. [Compare Microsoft directory services](https://learn.microsoft.com/en-us/entra/identity/domain-services/compare-identity-solutions). |
| Domain Services needs regional replica sets for disaster recovery | Enterprise or Premium Domain Services | A managed domain supports up to `5` replica sets; additional sets are unavailable on Standard and each set is billed separately. [Domain Services replica sets](https://learn.microsoft.com/en-us/entra/identity/domain-services/concepts-replica-sets). |
| Administrators need SSH to an isolated on-premises Linux server without public IP/inbound SSH | Arc-enabled servers SSH plus the correct VM Login role | Agent `1.31.x` or later and `sshd` are required; Owner/Contributor permits connection but does not grant Entra OS login. [SSH access to Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/azure-arc/servers/ssh-arc-overview). |
| Same Arc requirement targets Windows and mandates Entra user OS login | Use another Windows authentication path or local-user Arc SSH | Arc SSH supports Windows connectivity but its Entra user login is currently Linux-only. [SSH access to Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/azure-arc/servers/ssh-arc-overview). |
| A question proposes VPN as the authorization solution for an SMB share | VPN plus AD security groups/share and NTFS ACLs, or Private Access plus the same resource permissions | VPN/Private Access supplies reachability; Windows evaluates authenticated SIDs against the resource ACL for Read/Write/Modify/Full Control. [Windows access control overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control) [Active Directory security groups](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups). |

---

_Model used to research and author this fact sheet: GPT-5 Codex._
