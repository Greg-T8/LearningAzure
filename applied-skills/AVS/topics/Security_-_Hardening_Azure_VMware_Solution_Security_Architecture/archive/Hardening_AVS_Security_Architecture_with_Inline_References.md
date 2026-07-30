# Hardening Azure VMware Solution Security Architecture

## Introduction: Replacing the Physical Perimeter with Digital Trust

A traditional data center presents a visible security boundary: concrete walls, controlled doors, locked racks, cameras, and guards. Azure VMware Solution (AVS) replaces that physical certainty with a distributed security model built from identities, permissions, encrypted keys, virtualized hardware, private network paths, inspection points, workload-level controls, and automated detection.

The central architectural problem is therefore not simply how to move VMware workloads into Azure. It is how to preserve control and establish trust when the security perimeter is no longer a geographic location.

* **Traditional assumption:** Assets inside the physical boundary are treated as trusted, while threats are expected to originate outside it.
* **Cloud reality:** The effective perimeter consists of identities, access policies, control-plane applications, network paths, cryptographic boundaries, virtual hardware, and telemetry.
* **Core design principle:** Every component must prove that it is authorized, correctly configured, and untampered with.
* **Architectural consequence:** AVS security must be implemented as multiple mutually reinforcing layers rather than as a single perimeter firewall.
* **Primary layers covered in this guide:**

  * Management-plane identity and shared responsibility.
  * Microsoft Entra ID control-plane applications.
  * NSX administrative separation.
  * Hybrid connectivity through VMware HCX.
  * Perimeter inspection and microsegmentation.
  * Layer 7 application publishing.
  * Guest telemetry, threat detection, and automated response.
  * vSAN encryption and customer-managed keys.
  * Trusted Launch, Secure Boot, virtual Trusted Platform Modules, and Virtualization-Based Security.

> **Transcript-derived analogy:** A physical data center resembles a vault whose walls and locks are visible. AVS requires the architect to understand how a collection of virtual locks interconnects before the vault can be trusted.

---

# 1. Shared Responsibility and Management-Plane Identity

AVS deliberately changes the authority model familiar to administrators of conventional on-premises VMware environments. Customers receive substantial control over their workloads and logical configuration, but Microsoft retains the privileges required to protect the underlying service, hardware lifecycle, and Azure integration.

## 1.1 Traditional VMware Administration Compared with AVS

| Area                  | Traditional on-premises VMware                                                    | Azure VMware Solution                                                                       |
| --------------------- | --------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| Physical hardware     | Customer owns and operates the hosts.                                             | Microsoft owns and operates the hosts. [Azure VMware Solution private cloud and cluster concepts](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds)                                                      |
| Host lifecycle        | Customer replaces failed hosts and manages hardware maintenance.                  | Microsoft detects failures, evacuates workloads, and replaces bare-metal hosts. [Common questions about Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/faq#is-there-a-service-level-agreement-sla-on-disk-replacement-when-failures-occur)             |
| Root ESXi access      | A customer administrator may have direct root-level access.                       | The tenant is intentionally denied unrestricted root-level access. [Common questions about Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/faq#can-i-have-administrator-access-to-esxi-hosts)                          |
| vCenter authority     | The administrator commonly controls the entire vSphere domain.                    | The customer receives a restricted `cloudadmin@vsphere.local` account. [Access and identity architecture for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity)                      |
| Distributed switching | The customer may modify core virtual switching.                                   | Provider-controlled elements are protected from tenant modification.                        |
| NSX Tier-0 gateway    | The customer may own the complete routing stack.                                  | Microsoft controls the Tier-0 gateway that connects AVS to the Azure backbone. [Common questions about Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/faq#what-accounts-and-privileges-do-i-get-with-my-new-azure-vmware-solution-private-cloud)              |
| Service stability     | Customer configuration errors primarily affect the customer-operated environment. | Tenant changes could threaten a Microsoft-operated service and its service-level agreement. |

* **Shared-responsibility rationale:** Microsoft is financially and operationally responsible for the stability and uptime of the AVS platform.
* **Provider responsibility:** Microsoft manages the physical hardware lifecycle, host replacement, initial network bootstrapping, and provider-controlled NSX components.
* **Tenant responsibility:** The customer deploys virtual machines, organizes resource pools, configures permitted network segments, and manages workload-level controls.
* **Restriction rationale:** A tenant with unrestricted access to the distributed virtual switch could sever communication between the Azure management plane and the VMware nodes.
* **Failure consequence:** A single unsupported network change could disconnect or destabilize the entire private cloud.

> **Transcript-derived analogy:** The tenant occupies a luxury apartment. The tenant may arrange the furniture and use the rooms, but Microsoft owns the load-bearing walls, utility systems, and boiler room.

## 1.2 The `cloudadmin@vsphere.local` Account

VMware vCenter Server provisions a built-in local user identified in the transcript as `cloudadmin@vsphere.local`. This account provides broad tenant-level administrative capabilities without granting unrestricted provider-level authority.

* **Purpose:** The account permits administration of customer-owned VMware resources within the boundaries of the AVS service.
* **Limitation:** It does not provide unrestricted ESXi root authority or control over every infrastructure component.
* **Intended use:** The account is described as a break-glass emergency identity rather than as the standard identity for daily operations. [Access and identity architecture for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity#use-separate-accounts-for-connected-services)
* **Operational recommendation:** Integrate the organization’s directory, map administrative permissions to a dedicated directory group, and protect the local account in a secure credential vault.
* **Separation requirement:** Human administration, automated services, and emergency access should use separate identities.
* **Audit objective:** Routine work should be attributable to individual or group-based enterprise identities rather than to a shared local account.

> **Transcript-derived analogy:** The local account should be handled like the emergency hammer mounted next to a fire alarm: available when necessary but not used for routine work.

## 1.3 Directory Integration Through Azure Run Commands

The transcript states that the AVS cloud administrator cannot add an external identity source directly through the usual vCenter interface. Instead, directory integration is performed through Azure run commands. [Configure an external identity source for vCenter Server](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-identity-source-vcenter)

* **Control-plane path:** The requested operation is submitted through Azure Resource Manager and executed through the Azure control plane. [Run commands in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/run-command)
* **Architectural purpose:** Microsoft retains control over provider-sensitive configuration while still allowing the customer to request supported changes.
* **Governance benefit:** The operation can be tracked and audited through Azure.
* **Consistency benefit:** Supported run commands apply identity configuration in a controlled and repeatable manner.
* **Configuration-protection benefit:** The process reduces the likelihood that tenant administrators will place the platform into an unsupported state.

> **Architectural interpretation:** The run-command model is not merely a permissions limitation. It creates a controlled administrative interface through which sensitive changes can be validated, recorded, and applied consistently.

## 1.4 Human and Machine Identity Must Be Separated

Using `cloudadmin@vsphere.local` as a service account creates a serious operational dependency. The transcript illustrates this risk with VMware HCX, vRealize Orchestrator, and VMware Horizon.

* **Unsafe pattern:** Multiple external systems store and reuse the local cloud administrator credential.
* **Trigger condition:** A corporate policy requires the local account password to be changed, such as every 90 days by default. [Configure customer-managed-key encryption at rest in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-customer-managed-keys#accidental-deletion-of-a-key)
* **Immediate behavior:** Integrated systems continue authenticating with the old cached password.
* **Platform reaction:** vCenter observes a high volume of repeated authentication failures.
* **Security reaction:** The account may be treated as the target of a brute-force attack and temporarily locked.
* **Operational impact:**

  * HCX migrations can stop.
  * Automation workflows can fail.
  * Virtual desktop integrations can lose access.
  * Monitoring can become unavailable.
  * Administrators can lose access to the primary tenant management identity.

### Safe Password-Rotation Procedure

1. Identify every service, script, appliance, or automation workflow that references the affected credential.
2. Stop or suspend those integrations before changing the password.
3. Rotate the password through the supported AVS process.
4. Update the stored credential in every dependent system.
5. Restart the integrations in a controlled sequence.
6. Monitor vCenter authentication events for repeated failures.
7. Confirm that migration, automation, desktop, and monitoring functions have recovered.
8. Retire the shared credential from machine integrations by replacing it with dedicated service accounts.

> **Failure condition:** Rotating the shared cloud administrator password while dependent services continue retrying with stale credentials can cause a self-inflicted denial of service.

> **Operational recommendation:** Create an individual service account for each third-party integration. [Access and identity architecture for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-identity#use-separate-accounts-for-connected-services) A machine identity should never depend on the emergency human-administration account.

---

# 2. Generation 2 Control-Plane Applications and Microsoft Entra ID

The transcript describes a Generation 2 AVS control plane that relies on Microsoft Entra ID applications for backend automation. These identities allow Microsoft-operated services to configure, monitor, patch, and scale the private cloud.

## 2.1 Required First-Party Applications

The transcript identifies two first-party applications:

| Application named in transcript | Stated purpose                                                                         | Required role assignment                              |
| ------------------------------- | -------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| [`Avs Fleet Rp`](https://learn.microsoft.com/en-us/azure/azure-vmware/native-role-assignment)                  | Configuration injection, hardware lifecycle management, and vCenter health monitoring. | `AVS orchestrator` at the Azure resource-group level. |
| [`AzS VIS Prod App`](https://learn.microsoft.com/en-us/azure/azure-vmware/native-role-assignment)              | AVS fleet or visibility-related management operations.                                 | `AVS on fleet-vis` at the Azure resource-group level. |

* **Dependency:** Both applications must remain enabled. [Enable first-party application service principal for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/native-first-party-principle-security)
* **RBAC scope:** Their role-based access control assignments are applied at the target Azure resource-group level. [Configure AVS identities role assignments manually](https://learn.microsoft.com/en-us/azure/azure-vmware/native-role-assignment)
* **Provider function:** These applications act as the service identities through which Microsoft manages the customer’s AVS instance.
* **Security implication:** An unfamiliar application name is not sufficient justification for deletion; its service dependency must be verified first.

> **Requires documentation validation:** The transcript gives the `abs-fleet-rp` application identifier as `185E141D70D459484429C46448686`. The formatting, length, and exact value should be checked against current AVS documentation and the tenant’s enterprise-application records.

> **Documentation correction:** Current Microsoft documentation names the enterprise applications **Avs Fleet Rp** and **AzS VIS Prod App**, with the **AVS Orchestrator** and **AVS on Fleet VIS Role** assignments at the target resource-group scope. [Configure AVS identities role assignments manually](https://learn.microsoft.com/en-us/azure/azure-vmware/native-role-assignment)

## 2.2 Failure Scenario: Removing a Required Service Principal

An aggressive tenant-cleanup activity can disable the AVS control plane if a required first-party identity is mistaken for an unused enterprise application.

* **Trigger:** A security administrator disables or deletes one of the required Entra ID applications.
* **Immediate effect:** Microsoft loses the authorized identity needed to operate against that AVS instance.
* **Control-plane impact:** The management service becomes effectively blind and unable to execute supported management actions.
* **Workload behavior:** Existing virtual machines may continue running because the data plane remains active.
* **Management failures can include:**

  * Adding or scaling hosts.
  * Automated patching.
  * Hardware lifecycle operations.
  * Health monitoring.
  * Integration with other Azure services.
* **Recovery implication:** The application and its role assignments must be restored before normal management functions can resume.

The transcript refers to using PowerShell or Azure CLI and a command resembling `setAzureAidServicePrinciple` to restore these identities.

> **Requires documentation validation:** Microsoft documentation uses the supported first-party service-principal enablement and role-assignment procedures; it does not document a command named `setAzureAidServicePrinciple`. [Enable first-party application service principal for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/native-first-party-principle-security)

### Validation Procedure Before Removing an Enterprise Application

1. Identify the application’s object ID, application ID, publisher, and creation source.
2. Review its Azure role assignments and their scopes.
3. Determine whether the identity is referenced by an AVS private cloud or resource provider.
4. Check recent sign-in and audit activity.
5. Confirm the application’s purpose with the AVS operations owner.
6. Remove or disable it only after its platform dependency has been disproved.
7. Monitor AVS health and management operations after the change.

**Operational implication:** Entra ID cleanup procedures must treat first-party AVS applications as infrastructure dependencies, not as ordinary application registrations.

---

# 3. NSX Administrative Boundaries and Network Identity

The same separation of duties used in vCenter is applied to NSX. Customers can manage logical networking needed for their workloads, but Microsoft protects the provider-facing Tier-0 routing layer.

## 3.1 Tenant and Provider Responsibilities in NSX

| NSX capability                     |                 Customer control |                              Microsoft control |
| ---------------------------------- | -------------------------------: | ---------------------------------------------: |
| Workload network segments          |                              Yes |                        Platform oversight only |
| Tier-1 gateways                    | Yes, within supported boundaries |                           Platform integration |
| Distributed firewall policy        |                              Yes | Platform-protected rules may remain restricted |
| Microsegmentation                  |                              Yes |                   No routine tenant dependency |
| Tier-0 gateway                     |                       Restricted |                                            Yes |
| Azure backbone routing             |              Indirectly consumed |                                            Yes |
| Enterprise-wide NSX administration |                       Restricted |                              Provider retained |

* **Tenant capability:** Customers can create workload segments, configure Tier-1 functions, and apply distributed firewall policies within supported boundaries. [Common questions about Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/faq#what-accounts-and-privileges-do-i-get-with-my-new-azure-vmware-solution-private-cloud)
* **Provider boundary:** Microsoft manages the Tier-0 gateway that routes traffic toward the Azure backbone.
* **Risk controlled by the boundary:** Tenant modification of Tier-0 could disconnect the private cloud from Azure-managed infrastructure.
* **Role-integration behavior:** External directory groups can be mapped to supported NSX roles [Set an external identity source for VMware NSX](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-external-identity-source-nsx-t) such as auditor, VPN administrator, or network operator.
* **Rejected roles:** The transcript states that mapping tenant users to NSX Enterprise Administrator or Security Administrator is rejected.
* **Least-privilege pattern:** Customers must clone the available cloud administrator role and create more restricted custom roles.

> **Requires documentation validation:** Validate the exact NSX role names and role-mapping limitations against the AVS and NSX versions deployed in the environment.

**Takeaway:** AVS permits tenant control of workload networking while preventing tenant identities from modifying provider-owned network foundations.

---

# 4. VMware HCX and the Security Impact of Layer 2 Extension

VMware Hybrid Cloud Extension (HCX) is presented as the primary platform for migration and hybrid network extension. Its ability to preserve IP addresses reduces migration complexity, but it also extends the source environment’s security exposure into Azure.

## 4.1 HCX Network Extension Behavior

An HCX network extension provides Layer 2 connectivity between sites and can preserve IP and MAC addresses during migration. [Enable HCX access over the internet](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-hcx-access-over-internet#extend-network)

* **Migration benefit:** A virtual machine can move from an on-premises environment into AVS without changing its IP address. [Create an HCX network extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension)
* **Gateway behavior:** The virtual machine can retain its original default gateway.
* **Application benefit:** Systems that depend on fixed addressing may require fewer post-migration configuration changes.
* **Operational experience:** The migrated guest can behave as though it remains attached to its original subnet.
* **Illustrative scenario:** A virtual machine in a Chicago data center is migrated to AVS while remaining on the subnet stated in the transcript as `10.254.20.024`.

> **Requires documentation validation:** `10.254.20.024` is not presented in standard subnet notation. Determine whether the intended value was a host address such as `10.254.20.24` or a network such as `10.254.20.0/24`.

## 4.2 Extending the Blast Radius

Layer 2 extension changes more than routing. It also carries the security properties and weaknesses of the original broadcast domain into the cloud.

* **Threat propagation:** A compromised on-premises endpoint on the stretched network gains a direct Layer 2 path toward AVS workloads.
* **Routing limitation:** Traffic between peers on the same stretched segment may not pass through a traditional routed inspection point.
* **Lateral-movement risk:** Malware can attempt to reach migrated workloads without crossing a conventional north-south firewall.
* **Security conclusion:** HCX does not merely extend a subnet; it can extend the source network’s blast radius.
* **Design requirement:** A stretched network must be accompanied by inspection and workload-level isolation.
* **Migration consideration:** The convenience of avoiding re-IP work must be weighed against the duration and scope of the extended trust zone.

> **Transcript-derived analogy:** HCX creates a fast private highway between the data center and Azure. Without inspection and segmentation, malware can use the same highway as legitimate migration traffic.

## 4.3 Operational Recommendations for Stretched Networks

* Keep Layer 2 extensions temporary where the migration design permits.
* Define a retirement date for every stretched segment.
* Inventory every on-premises device attached to a segment before extending it.
* Apply distributed firewall policy before moving sensitive workloads onto the segment.
* Restrict east-west access to explicitly required application flows.
* Monitor both sides of the extension for lateral authentication attempts and scanning.
* Re-IP or re-segment workloads after migration when long-term Layer 2 adjacency is unnecessary.
* Test gateway, failover, and rollback behavior before production migration.

**Operational implication:** HCX simplifies migration, but its security must be evaluated as an extension of the original network—not as a clean cloud boundary.

---

# 5. Private Connectivity and Azure Firewall Premium

AVS management components are intended to remain private. Connectivity from on-premises environments should use trusted private network paths, while traffic entering the Azure network should be inspected before reaching sensitive workloads.

## 5.1 Public Network Access

* **Default posture:** The transcript states that internet access is disabled by default for new private clouds. [What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction#connectivity)
* **Protected components:** vCenter Server and NSX Manager should not be exposed directly to the public internet.
* **Access path:** Administration should occur through trusted private connectivity.
* **Configuration flag:** The transcript refers to a setting described as `disabled public network accesses`, with a default value of `True`.

> **Requires documentation validation:** Confirm the exact property name and value syntax for disabling public access. The wording in the transcript may not match the Azure resource schema.

## 5.2 ExpressRoute and Global Reach

* **Private transport:** Azure ExpressRoute provides private connectivity between customer infrastructure and Azure. [ExpressRoute overview](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction)
* **Global Reach function:** ExpressRoute Global Reach connects an on-premises environment to an AVS private cloud through the Microsoft global network. [Connect an on-premises environment to Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-expressroute-global-reach-private-cloud)
* **Routing benefit:** The path can avoid an unnecessary traffic hairpin through another location.
* **Security caveat:** A private path is not automatically a trusted path; compromised systems can still send malicious traffic through it.
* **Architectural requirement:** Private connectivity must be combined with inspection, segmentation, and access control.

## 5.3 Azure Firewall Premium as the Ingress Inspection Layer

The baseline architecture in the transcript specifies Azure Firewall Premium rather than Standard because Premium provides advanced inspection capabilities. [Azure Firewall Premium in the Azure portal](https://learn.microsoft.com/en-us/azure/firewall/premium-portal)

| Capability                                       | Security purpose                                                                   |
| ------------------------------------------------ | ---------------------------------------------------------------------------------- |
| Intrusion Detection and Prevention System (IDPS) | Detects suspicious signatures or behaviors and can deny malicious traffic.         |
| Transport Layer Security inspection              | Decrypts eligible encrypted traffic for payload inspection.                        |
| Threat-intelligence analysis                     | Compares traffic and destinations against known malicious indicators.              |
| Centralized policy                               | Creates a common enforcement point for traffic entering the Azure virtual network. |

### TLS Inspection Flow

1. A client initiates an encrypted connection.
2. Azure Firewall Premium intercepts the TLS handshake.
3. The firewall terminates or proxies the encrypted session using a trusted certificate.
4. It decrypts the traffic within the inspection boundary.
5. It evaluates the payload using threat intelligence and IDPS controls.
6. If the content is allowed, the firewall re-encrypts the traffic.
7. The traffic continues toward the AVS environment.
8. If the payload matches a deny condition, the firewall drops the connection.

* **Why it matters:** Malware commonly uses HTTPS to make malicious communications resemble ordinary encrypted web traffic.
* **Standard-firewall limitation:** A firewall that cannot inspect encrypted payloads sees only encrypted bytes and connection metadata.
* **IDPS mode:** Microsoft's AVS security recommendations specify Azure Firewall Premium IDPS in Alert and Deny mode [Security recommendations for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/security-recommendations) so malicious traffic is blocked rather than merely logged.
* **Performance claim:** The transcript states that decryption, inspection, and re-encryption occur in milliseconds without noticeable latency.

> **Requires documentation validation:** TLS inspection introduces workload, certificate, compatibility, privacy, and latency considerations. The claim that latency is not noticeable should be validated through performance testing for the actual traffic profile.

### TLS Inspection Dependencies

* Client systems must trust the certificate authority used by the firewall. [Azure Firewall Premium certificates](https://learn.microsoft.com/en-us/azure/firewall/premium-certificates)
* Certificate deployment and rotation must be governed.
* Applications using certificate pinning may reject intercepted sessions. [Azure Firewall Premium features](https://learn.microsoft.com/en-us/azure/firewall/premium-features#tls-inspection)
* Privacy-sensitive or regulated traffic may need bypass rules.
* Capacity planning must include decryption and IDPS processing.
* Firewall routing must ensure that intended traffic actually traverses the inspection point.

**Takeaway:** ExpressRoute provides private transport, while Azure Firewall Premium provides inspection. Neither function replaces the other.

---

# 6. NSX Distributed Firewall and Microsegmentation

Perimeter inspection cannot stop threats that originate inside AVS or that arrive through an allowed path. NSX distributed firewalling moves enforcement to each virtual machine’s virtual network interface card.

## 6.1 Distributed Enforcement

* **Traditional firewall position:** A conventional firewall usually inspects traffic as it crosses a network boundary.
* **Distributed firewall position:** NSX distributed firewall policy is enforced at the workload vNIC, enabling east-west filtering independent of routed boundaries. [Security recommendations for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/security-recommendations)
* **East-west protection:** Traffic between two virtual machines on the same subnet can be evaluated before it leaves the hypervisor.
* **Lateral-movement containment:** A compromised workload can be prevented from reaching adjacent workloads even when Layer 2 adjacency exists.
* **Policy granularity:** Rules can be based on workload identity, group membership, application tier, source, destination, protocol, and port.
* **Assume-breach objective:** Every workload should be treated as a potential source of hostile traffic.

> **Transcript-derived analogy:** Instead of protecting a castle with one wall and moat, microsegmentation gives every room its own steel door and guard.

## 6.2 Microperimeter of One

* **Containment goal:** Restrict each workload to only the communications required for its role.
* **Compromise behavior:** An infected workload can continue to exist while being prevented from moving laterally.
* **Layer 2 relevance:** Distributed enforcement remains effective even when communicating workloads share a subnet.
* **Operational requirement:** Application dependencies must be mapped accurately before restrictive rules are enforced.
* **Failure mode:** Overly broad allow rules recreate the flat-network risk that microsegmentation is intended to eliminate.
* **Availability risk:** Overly restrictive policy can interrupt legitimate service-to-service communications.

### Microsegmentation Implementation Sequence

1. Inventory applications, workloads, and network dependencies.
2. Group workloads by function, sensitivity, environment, and ownership.
3. Observe actual traffic before defining final rules.
4. Create explicit rules for required application flows.
5. Add deny or quarantine behavior for unexpected communication.
6. Test policy in a monitoring or non-enforcing mode where available.
7. Enforce rules incrementally.
8. Monitor denied flows and application health.
9. Refine policy as application dependencies change.

## 6.3 Third-Party Security Integrations

The transcript names several independent software vendors that can integrate with NSX:

* Bitdefender.
* Trend Micro Deep Security.
* Check Point.

These products are described as using NSX hypervisor APIs to provide:

* Agentless anti-malware scanning.
* Network introspection.
* Security enforcement without installing a heavy agent in every guest operating system.
* Centralized protection integrated with the virtualization layer.

> **Requires documentation validation:** Product support, specific integration methods, and current certification status vary by AVS, vSphere, NSX, and vendor version. Verify the supported matrix before selection.

---

# 7. Publishing Public Applications with Azure Application Gateway

A secure private cloud eventually needs controlled entry points for public applications. Azure Application Gateway provides Layer 7 routing and Web Application Firewall protection in front of workloads hosted on AVS virtual machines. [Protect web apps on Azure VMware Solution with Azure Application Gateway](https://learn.microsoft.com/en-us/azure/azure-vmware/protect-azure-vmware-solution-with-application-gateway)

## 7.1 Layer 4 and Layer 7 Comparison

| Characteristic                | Layer 4 load balancer                              | Layer 7 Application Gateway                                                        |
| ----------------------------- | -------------------------------------------------- | ---------------------------------------------------------------------------------- |
| Primary awareness             | IP address, protocol, and port                     | HTTP host, URL path, headers, cookies, and application content                     |
| TLS handling                  | May pass through or terminate, depending on design | Can terminate TLS for application-aware inspection                                 |
| Routing decisions             | Usually connection- or transport-based             | Can route by URL path, hostname, cookie, or other HTTP attributes                  |
| Application attack visibility | Limited                                            | Can inspect for web-application attacks                                            |
| Example behavior              | Sends port 443 connections across backend servers  | Sends `/images/` requests to image servers and `/video/` requests to video servers |

* **Layer 4 behavior:** The load balancer distributes transport connections without understanding the application payload.
* **Layer 7 behavior:** Application Gateway reads HTTP information and makes content-aware routing decisions. [Azure Application Gateway URL-based content routing overview](https://learn.microsoft.com/en-us/azure/application-gateway/url-route-overview)
* **Security benefit:** Application-layer inspection can identify attacks that are invisible when only IP addresses and ports are evaluated.
* **Topology benefit:** Clients see a single public hostname while backend services remain on private addresses.

> **Transcript-derived analogy:** A Layer 4 balancer is a door attendant who only counts arrivals. A Layer 7 gateway is a maître d’ who understands each request, directs the guest to the appropriate destination, and performs a security check first.

## 7.2 Web Application Firewall Protection

The transcript refers to the Web Application Firewall as “WEF”; the intended term appears to be WAF.

* **Inspection scope:** The WAF evaluates HTTP requests against managed and custom rules. [Azure Web Application Firewall on Azure Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview)
* **Threat examples:**

  * Cross-site scripting.
  * Directory traversal.
  * SQL injection.
  * Attempts to exploit known web-framework vulnerabilities.
* **Defense-in-depth role:** The WAF reduces exposure but does not eliminate the need for secure code, patching, endpoint protection, and internal monitoring.
* **Assume-breach position:** A zero-day vulnerability or an internal mistake may still bypass perimeter application controls.

> **Requires documentation validation:** Confirm the selected WAF policy version, managed rule set, exclusions, prevention mode, and tuning requirements for the application.

## 7.3 URL-Based Routing Example

The transcript describes three AVS virtual machines:

| Backend        | Function             |
| -------------- | -------------------- |
| `ContosoWeb01` | Main website content |
| `ContosoWeb02` | Image content        |
| `ContosoWeb03` | Video content        |

### Routing Sequence

1. Add the private IP addresses of the AVS virtual machines to Application Gateway backend pools.
2. Configure a listener for the public application hostname.
3. Associate the listener with a WAF policy.
4. Define path-based routing rules.
5. Send general website requests to the `ContosoWeb01` pool.
6. Send requests under `/images/` to the `ContosoWeb02` pool.
7. Send requests under `/video/` to the `ContosoWeb03` pool.
8. Configure a custom backend port, such as `8080`, where the application requires it.
9. Use health probes to ensure that requests reach only healthy backends. [Application Gateway health monitoring overview](https://learn.microsoft.com/en-us/azure/application-gateway/application-gateway-probe-overview)

### Example Paths

* A request resembling `www.contoso.com/images/logo.png` is routed to `ContosoWeb02`.
* A request resembling `www.contoso.com/video/tutorial.mp4` is routed to `ContosoWeb03`.
* The video backend may receive the request on an internal custom port such as `8080`.

> **Requires documentation validation:** The image-file example in the transcript was transcribed as `logo dot PM POG`. It is represented here as `logo.png`, but the original source should be checked if the exact filename matters.

**Operational implication:** Application Gateway can expose one public endpoint while keeping the internal AVS topology and specialized backend services private.

---

# 8. Guest Telemetry, Defender for Cloud, and Microsoft Sentinel

Network and application controls do not reveal everything occurring inside the guest operating system. AVS workloads therefore require host-level telemetry that can be centralized, analyzed, correlated, and used to trigger response actions.

## 8.1 Telemetry Collection

The transcript describes deploying Azure Monitor Agent inside AVS guest operating systems.

* **Windows sources:** Windows event logs, security events, performance counters, and audit data.
* **Linux sources:** Syslog, performance data, and security audit records.
* **Transport:** Azure Monitor Agent collects guest data and delivers it to Azure Monitor for services including Microsoft Sentinel and Defender for Cloud. [Azure Monitor Agent overview](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview)
* **Centralization benefit:** Security operations can analyze VMware-hosted workloads together with other Azure and enterprise resources.
* **Dependency:** Network routing and firewall policy must permit the required agent communications.
* **Lifecycle consideration:** Legacy agents should not be selected without confirming their current support status.

> **Documentation correction:** The legacy Log Analytics agent was retired on August 31, 2024. Use Azure Monitor Agent for new deployments. [Azure Monitor Agent overview](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview)

## 8.2 Microsoft Defender for Cloud

Defender for Cloud provides cloud security posture management and workload protection, and Microsoft documents its integration with AVS. [Integrate Microsoft Defender for Cloud with Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/azure-security-integration)

* **Posture checks can include:**

  * Missing operating-system patches.
  * Disabled or unhealthy endpoint protection.
  * Vulnerability exposure.
  * Configuration weaknesses.
* **Threat detection:** Defender can flag anomalous behaviors such as fileless malware executing in memory.
* **Role in the architecture:** It turns large volumes of raw telemetry into prioritized security findings.
* **Operational benefit:** Analysts do not have to manually inspect millions of individual events to identify common risks.

## 8.3 Microsoft Sentinel

Microsoft Sentinel provides SIEM and security orchestration, automation, and response capabilities that correlates alerts across the enterprise.

* **SIEM function:** Centralizes and correlates events from multiple systems.
* **SOAR function:** Provides Security Orchestration, Automation, and Response.
* **Correlation value:** An alert from an AVS workload can be evaluated alongside identity, firewall, endpoint, and geographic-sign-in signals.
* **Response value:** Automation rules and playbooks can orchestrate response actions. [Automate threat response with playbooks in Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/automate-responses-with-playbooks)

> **Requires documentation validation:** The transcript pronounces SIEM as “SAM” and SOAR as “SOR.” The standard acronyms are used in this guide.

## 8.4 Brute-Force Detection with Kusto Query Language

The transcript presents a Kusto Query Language (KQL) example that searches Windows Security Event ID `4625`, which represents a failed logon. [Audit failure event 4625](https://learn.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4625)

The transcribed query resembles:

```kusto
SecurityEvent
| where Activity startswith "4625"
| summarize count() by IpAddress
| where count_ > 3
```

> **Requires documentation validation:** The transcript states `SecurityEventPipe` and may not preserve the exact field names or valid KQL syntax. The final query must be tested against the actual Sentinel table schema.

### Detection Logic

* **Input:** Windows failed-authentication events.
* **Relevant event:** Event ID `4625`.
* **Grouping key:** Source IP address.
* **Threshold:** More than three failed attempts from the same source.
* **Reason for thresholding:** A single failure can result from an ordinary typing mistake.
* **Alert-fatigue control:** Correlation avoids opening an incident for every isolated failure.
* **Detection interpretation:** Repeated failures from one source may indicate password guessing or brute-force activity.

### Transcript-Derived Threshold Calculation

1. **Inputs:** Failed-login events from one source IP address.
2. **Formula:**
   `Trigger = count(failed login events by source IP) > 3`
3. **Result:**
   The rule triggers beginning with the fourth qualifying failure.
4. **Practical interpretation:**
   One to three failures do not meet the stated condition; four or more do.
5. **Factors affecting the real result:**

   * The query’s time window.
   * Event-ingestion delay.
   * Duplicate or missing events.
   * NAT causing multiple users to share one source IP.
   * Distributed attacks using many IP addresses.
   * Service accounts that legitimately retry authentication.
   * Field names available in the selected Sentinel table.

## 8.5 Automated Response Playbooks

When the detection threshold is met, Sentinel can initiate a playbook.

* **Identity response:** Force a password reset for the affected user through Microsoft Entra ID.
* **Network response:** Add the attacker’s IP address to a firewall block list.
* **Incident response:** Create, enrich, assign, or escalate a Sentinel incident.
* **Containment response:** Isolate an affected workload from the virtual network.
* **Correlation response:** Compare the event with additional identity-risk signals.

### Impossible-Travel Scenario

The transcript illustrates correlation between:

* A failed authentication associated with an AVS server in Chicago.
* A successful authentication from an IP address in Eastern Europe five minutes later.

This pattern may indicate stolen credentials, although location accuracy, VPN use, proxies, cloud-hosted endpoints, and shared accounts must be considered.

> **Transcript-derived scenario:** Sentinel correlates a failed local event with a geographically inconsistent Entra ID sign-in and then triggers automated containment.

> **Requires documentation validation:** Automated password resets and firewall changes require appropriate connectors, permissions, playbook logic, and safeguards. These actions are not inherent outcomes of every Sentinel alert.

**Takeaway:** The telemetry architecture forms a closed loop: guest events are collected, Defender analyzes risk, Sentinel correlates activity, and playbooks initiate response.

---

# 9. Protecting Data at Rest with vSAN Encryption

Identity and network controls cannot protect data if an attacker obtains direct access to the underlying storage. vSAN encryption protects data written to physical media by using a hierarchy of data-encryption and key-encryption keys.

## 9.1 Threats Addressed

* A rogue insider physically removes drives from a host.
* A privileged attacker obtains a storage-level snapshot.
* A retired or failed disk leaves the controlled environment.
* Network and identity controls are bypassed because the attacker targets storage directly.

The objective is to ensure that extracted media contains encrypted data that cannot be interpreted without authorized key operations.

## 9.2 Envelope Encryption

The transcript uses several inconsistent abbreviations for the cryptographic keys. The standard concepts represented are:

* **Data Encryption Key (DEK):** Encrypts and decrypts the actual data.
* **Key Encryption Key (KEK):** Wraps and protects the DEK.

> **Requires documentation validation:** The transcript alternates among `DIC`, `DOC`, `DK`, `DEEK`, and similar terms. This guide uses DEK where the context clearly refers to the data-encryption key.

### Key Hierarchy

1. An ESXi host obtains or generates a highly random DEK.
2. The DEK performs the actual encryption and decryption of data written to and read from storage.
3. The DEK is not stored unprotected beside the encrypted data.
4. A higher-level KEK wraps the DEK.
5. The wrapped DEK can be stored without exposing the plaintext DEK.
6. Authorized cryptographic operations unwrap the DEK when the host needs to access the datastore.

> **Transcript-derived analogy:** The encrypted data is a document inside a locked titanium briefcase. The DEK is the briefcase key. The DEK is then placed in a bank vault protected by the KEK.

## 9.3 Platform-Managed Keys and Customer-Managed Keys

| Model                | Key control                                                  | Operational burden | Typical motivation                                                                  |
| -------------------- | ------------------------------------------------------------ | ------------------ | ----------------------------------------------------------------------------------- |
| Platform-managed key | Microsoft manages KEK generation and rotation.               | Lower              | Simpler operations and sufficient control for many organizations.                   |
| Customer-managed key | The customer creates and governs the customer-managed key in Azure Key Vault. [Configure customer-managed-key encryption at rest in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-customer-managed-keys) | Higher             | Regulatory, contractual, or internal requirements for direct cryptographic control. |

* **Platform-managed behavior:** AVS manages the KEK lifecycle behind the scenes.
* **Customer-managed behavior:** The customer provisions an Azure Key Vault and supplies a customer-controlled KEK.
* **Regulated-use rationale:** Finance, healthcare, and government organizations may require direct control over key lifecycle and revocation.
* **Risk transfer:** Customer-managed keys increase control but also make customer configuration errors capable of denying access to the datastore.

## 9.4 Supported Key Types and Sizes Stated in the Transcript

* RSA keys in Azure Key Vault.
* RSA keys backed by Azure Key Vault Managed HSM when a key URI is supplied.
* Supported key sizes of 2048, 3072, or 4096 bits. [Configure customer-managed-key encryption at rest in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-customer-managed-keys)

> **Requires documentation validation:** The transcript says “DIT key sizes.” The intended unit appears to be bits. Confirm supported key types, sizes, tiers, and HSM requirements for the deployed AVS and Key Vault configuration.

---

# 10. Azure Key Vault Integration for Customer-Managed Keys

Customer-managed-key integration relies on an AVS managed identity and tightly scoped Key Vault permissions. The goal is to let AVS request cryptographic operations without exposing the KEK to the VMware environment.

## 10.1 Managed Identity

* **Identity creation:** Enable a system-assigned managed identity on the AVS private cloud. [Enable CMK with system-assigned identity](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-customer-managed-keys#enable-cmk-with-system-assigned-identity)
* **Entra ID registration:** The private cloud receives an identity object in Microsoft Entra ID.
* **Unique identifier:** The managed identity receives an object ID.
* **Authentication function:** Key Vault uses that identity to determine whether the AVS resource is authorized to perform cryptographic operations.
* **Credential benefit:** No manually managed secret is required for the AVS private cloud to authenticate to Key Vault.

> **Transcript-derived analogy:** The private cloud receives an identity badge that it presents to Key Vault.

## 10.2 Key Vault Permissions

The transcript specifies granting:

* `get`.
* `wrapKey`.
* `unwrapKey`. [Configure customer-managed-key encryption at rest in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-customer-managed-keys)

It explicitly states that AVS should not be granted a permission that retrieves the raw KEK.

* **Least-privilege objective:** AVS is authorized to ask Key Vault to protect or unprotect the DEK.
* **Key-boundary objective:** The KEK remains within the Key Vault cryptographic boundary.
* **Audit benefit:** Key operations can be recorded and attributed to the AVS managed identity.

## 10.3 Unwrap Flow

1. An ESXi host needs to mount or access the encrypted vSAN datastore.
2. The host obtains the wrapped DEK.
3. AVS sends an unwrap request to Azure Key Vault over a protected channel.
4. Key Vault authenticates the AVS managed identity.
5. Key Vault evaluates the identity’s permissions.
6. Key Vault uses the KEK to unwrap the DEK within its protected cryptographic boundary.
7. The usable DEK becomes available to the authorized host process in volatile memory.
8. The host uses the DEK to decrypt storage data.
9. The KEK itself remains inside Key Vault.

> **Requires documentation validation:** The transcript describes the raw decrypted DEK as being returned to the host. Validate the exact VMware and Key Vault key-provider protocol, including whether plaintext key material is returned or handled through a more specialized key-provider exchange.

## 10.4 Critical Dependency

The encrypted datastore depends on all of the following remaining valid:

* The AVS managed identity.
* The identity’s Key Vault authorization.
* The Key Vault.
* The required key.
* The required key version, where version pinning is used.
* Network and service availability for the key operation.
* Supported AVS and Key Vault configuration.

**Operational implication:** The Key Vault configuration becomes part of the storage availability path and must be managed as production infrastructure.

---

# 11. Cryptographic Lockout and Recovery Controls

Customer-managed keys create an intentional kill switch. Revoking authorization or disabling the key can make the encrypted datastore inaccessible, particularly when hosts reboot or new hosts attempt to join.

## 11.1 Lockout Failure Scenarios

| Failure event                            | Result described in transcript                                              |
| ---------------------------------------- | --------------------------------------------------------------------------- |
| AVS access policy is deleted             | Key Vault refuses the required unwrap operation.                            |
| AVS managed identity is deleted          | The private cloud can no longer authenticate as the authorized identity.    |
| KEK is disabled                          | The wrapped DEK cannot be unwrapped.                                        |
| Key is deleted                           | New cryptographic operations fail unless the key is recovered.              |
| Required key version becomes unavailable | Hosts pinned to that version cannot complete the expected operation.        |
| Host reboots after authorization loss    | The host may be unable to mount the encrypted datastore.                    |
| New host joins after authorization loss  | The host may be unable to access the encryption keys needed to participate. |

* **Resulting impact:** The datastore can become inaccessible even though the physical disks remain intact.
* **Security characterization:** Revoking key access performs a form of cryptographic shredding.
* **Benefit:** The organization can rapidly render stored data unreadable when responding to a severe threat or disposal requirement.
* **Risk:** An accidental or unauthorized change can deny access to enterprise data at large scale.
* **Operational principle:** Key administration must be subject to stronger controls than ordinary resource administration.

> **Transcript-derived scenario:** An administrator performing environment cleanup deletes the AVS managed identity or key and unintentionally locks the organization out of petabytes of data.

## 11.2 Soft Delete

* **Behavior:** Deleted keys enter a recoverable state instead of being destroyed immediately.
* **Retention stated in transcript:** 90 days by default. [Configure customer-managed-key encryption at rest in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-customer-managed-keys#accidental-deletion-of-a-key)
* **Recovery purpose:** Administrators can restore a mistakenly deleted key during the retention period.
* **Availability benefit:** Restoring the required key can allow the datastore to mount again.
* **Prerequisite:** The transcript states that soft delete must be enabled before customer-managed keys can be used with AVS.

## 11.3 Purge Protection

* **Behavior:** A soft-deleted key cannot be permanently purged before the retention period expires.
* **Insider-threat protection:** A malicious administrator cannot delete the key and immediately purge the recovery copy.
* **Administrative limitation stated in transcript:** Neither an Azure global administrator nor Microsoft support can bypass the protected retention period.
* **Irreversibility consideration:** Purge protection is designed specifically to prevent early permanent destruction.

> **Requires documentation validation:** Confirm the current Key Vault retention configuration, whether 90 days is mandatory or configurable, and the exact limitations on administrative recovery and purge operations.

## 11.4 Key-Recovery Procedure

1. Confirm that datastore access failed because of a Key Vault or key-authorization event.
2. Identify the exact key, key version, and Key Vault referenced by AVS.
3. Verify whether the key is disabled, deleted, expired, or inaccessible.
4. Restore a soft-deleted key where applicable.
5. Re-enable the correct key version.
6. Restore the AVS managed identity if it was removed through a supported recovery process.
7. Reapply the required `wrapKey` and `unwrapKey` permissions.
8. Validate Key Vault networking and availability.
9. Retry the supported AVS key operation or host recovery process.
10. Confirm that all hosts can access and mount the datastore.
11. Review audit logs to identify the initiating change.
12. Add preventive controls before closing the incident.

## 11.5 Preventive Controls

* Require privileged identity management or just-in-time elevation for key administration.
* Require peer review for key disablement, access-policy removal, and identity deletion.
* Protect Key Vault and AVS resources with deletion controls where supported.
* Alert on changes to keys, key versions, managed identities, and cryptographic permissions.
* Maintain an offline recovery runbook.
* Test recovery using a non-production environment.
* Keep ownership information and escalation contacts current.
* Separate security authority from routine infrastructure administration.

**Takeaway:** Soft delete and purge protection are not optional conveniences in this design. They are safeguards against an otherwise catastrophic and potentially irreversible loss of data access.

---

# 12. Key Rotation and Cryptographic Efficiency

Envelope encryption allows the KEK to rotate without re-encrypting all underlying data. Only the much smaller DEK-wrapping operation must change.

## 12.1 Rotation Options

* **Automatic rotation:** The key can be configured to create or use new versions automatically.
* **Detection timing stated in transcript:** AVS can take up to 10 minutes to detect a new automatically rotated key version. [Customer-managed key version lifecycle](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-customer-managed-keys#customer-managed-key-version-lifecycle)
* **Manual control:** The encryption configuration can be pinned to a specific key-version Uniform Resource Identifier.
* **Operational tradeoff:** Automatic rotation reduces manual effort, while version pinning provides deliberate change control.

> **Requires documentation validation:** Confirm the actual AVS key-version detection interval and the supported procedure for automatic versus version-pinned rotation.

## 12.2 Rotation Calculation

> **Transcript-derived calculation:** The transcript does not provide data-size figures but explains the difference in work between re-encrypting a datastore and rewrapping a key.

1. **Inputs:**

   * Potentially petabytes of encrypted datastore data.
   * One or more small DEKs protecting that data.
   * A new KEK version.
2. **Formula:**

   * Full re-encryption work would scale approximately with total encrypted data size.
   * Envelope-encryption rotation work scales with the number and size of wrapped DEKs.
3. **Result:**

   * Rotating the KEK requires rewrapping the DEK rather than rewriting every encrypted block.
4. **Practical interpretation:**

   * KEK rotation can remain transparent to running virtual machines and avoid a datastore-wide rewrite.
5. **Factors affecting the real operation:**

   * Number of hosts and keys.
   * Key-provider communication.
   * AVS detection interval.
   * Version pinning.
   * Key Vault availability.
   * Host lifecycle events.
   * Product-specific rekey procedures.

---

# 13. Continuous Validation and Compliance

The transcript states that AVS is governed through Microsoft’s Security Development Lifecycle and continuous vulnerability triage.

* **Security Development Lifecycle:** Security activities are integrated into platform design, development, testing, and operations.
* **Vulnerability prioritization:** Microsoft uses vulnerability-management and secure-development processes for Azure services; the transcript's AVS-specific CVSS wording was not confirmed in the reviewed product documentation. [Microsoft Security Development Lifecycle](https://www.microsoft.com/en-us/securityengineering/sdl)
* **Infrastructure scope:** The process covers underlying bare metal, virtualization components, and cryptographic boundaries.
* **Third-party assurance:** The platform is described as being continuously audited against recognized compliance standards.
* **Standards named in the transcript:**

  * Payment Card Industry Data Security Standard. [Azure compliance offerings](https://learn.microsoft.com/en-us/azure/compliance/offerings/)
  * Service Organization Control 1. [Azure compliance offerings](https://learn.microsoft.com/en-us/azure/compliance/offerings/)
  * Service Organization Control 2.
  * Service Organization Control 3.
  * Various International Organization for Standardization certifications. [Azure compliance offerings](https://learn.microsoft.com/en-us/azure/compliance/offerings/)

> **Requires documentation validation:** Compliance eligibility depends on service scope, Azure region, configuration, current audit status, and the customer’s own controls. A platform certification does not automatically make a customer workload compliant.

---

# 14. Trusted Launch and Compute Integrity

Encryption protects dormant data, but the operating system and boot process become exposed when a virtual machine starts. Trusted Launch for AVS combines Secure Boot, vTPM, and VBS-related guest protections. [Trusted Launch for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-virtual-trusted-platform-module)

1. Secure Boot.
2. Virtual Trusted Platform Module.
3. Virtualization-Based Security.

## 14.1 Security Problem Addressed

* The hypervisor decrypts virtual disks when an authorized virtual machine starts.
* The operating system and drivers are loaded into memory.
* Malware already embedded in the boot chain may execute before conventional endpoint protection.
* A bootkit or malicious kernel driver can undermine controls operating later in the startup sequence.
* Disk encryption alone therefore does not prove that the running operating system is trustworthy.

**Architectural objective:** Establish trust from firmware through the bootloader, kernel, drivers, credential services, and protected execution environment.

---

# 15. Secure Boot and the Root of Trust

Secure Boot creates a verified startup chain using UEFI firmware and trusted digital signatures. [Secure Boot and Trusted Boot](https://learn.microsoft.com/en-us/windows/security/operating-system-security/system-security/trusted-boot)

## 15.1 Boot Verification Flow

1. The AVS virtual machine starts using UEFI firmware rather than legacy BIOS.
2. Secure Boot validates the bootloader’s digital signature.
3. The bootloader transfers control only if it is trusted.
4. The operating-system kernel is validated.
5. Kernel-level drivers are checked for trusted signatures.
6. Unsigned, forged, altered, or untrusted components are rejected.
7. The boot process halts rather than executing unauthorized code.

* **Root-of-trust meaning:** Every component is trusted only after the preceding trusted component verifies it.
* **Threat addressed:** A rootkit cannot insert an unsigned or altered driver into the trusted boot sequence without detection.
* **Security advantage:** The unauthorized component is stopped before it can execute in memory.
* **Dependency:** The guest operating system and drivers must support UEFI Secure Boot.
* **Compatibility risk:** Older operating systems, unsigned drivers, or custom boot components may fail to start.

> **Requires documentation validation:** The exact remediation behavior may vary. Secure Boot can reject a component or prevent successful startup, but operational symptoms depend on the guest and boot configuration.

---

# 16. Virtual Trusted Platform Module

A virtual Trusted Platform Module, or vTPM, provides TPM 2.0 capabilities to a virtual machine. [Trusted Launch for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-virtual-trusted-platform-module) It stores and uses cryptographic secrets within a boundary that is logically separated from the guest operating system.

## 16.1 Physical TPM Compared with vTPM

| Characteristic           | Physical TPM                                        | Virtual TPM                                                                   |
| ------------------------ | --------------------------------------------------- | ----------------------------------------------------------------------------- |
| Form                     | Hardware chip attached to a physical system         | Hypervisor-provided virtual device                                            |
| Scope                    | One physical machine                                | One virtual machine                                                           |
| Key storage              | Hardware-protected storage                          | Encrypted virtual TPM state                                                   |
| Cryptographic operations | Performed in the TPM boundary                       | Performed through the virtual TPM boundary                                    |
| Guest access             | Uses TPM interfaces without extracting private keys | Uses TPM interfaces without directly extracting protected private keys        |
| Portability              | Tied to hardware and platform behavior              | Governed by virtual-machine encryption, clone, backup, and migration behavior |

## 16.2 Isolation of Secrets

* **Guest visibility:** The operating system can use the vTPM through supported interfaces.
* **Key isolation:** The guest is not intended to extract the vTPM’s private keys directly.
* **Operation model:** The operating system requests a cryptographic operation, and the vTPM performs it within its protected boundary.
* **Example:** BitLocker can request access to key material protected by the vTPM.
* **State protection:** The vTPM data stored with the virtual machine must itself be encrypted.

> **Transcript-derived analogy:** The vTPM resembles a diplomatic pouch located within the guest environment. The operating system can send authorized requests to it but cannot open the pouch and remove its protected contents.

## 16.3 Native AVS Key-Provider Integration

The transcript states that AVS provides the native key-provider integration required to add a vTPM without a customer-managed external KMS. [Trusted Launch for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-virtual-trusted-platform-module)

* AVS manages the necessary key-provider integration.
* The administrator adds a Trusted Platform Module virtual device to the VM.
* The hypervisor handles the supporting encryption and cryptographic configuration.

### Configuration Procedure Stated in the Transcript

1. Open the virtual machine settings.
2. Select the option to add a new device.
3. Select Trusted Platform Module.
4. Save the configuration.
5. Power on or restart the virtual machine as required.
6. Validate that the guest operating system detects a TPM 2.0 device.
7. Enable dependent guest features such as BitLocker only after validation.

> **Requires documentation validation:** Power-state requirements, VM hardware compatibility, guest support, encryption prerequisites, and UI labels vary by vSphere version.

---

# 17. Measured Boot and Attestation

The vTPM also records measurements of the boot process so an external system can evaluate whether the virtual machine started in an expected state.

## 17.1 Platform Configuration Registers

* **Measurement:** Each boot component is hashed before or as it is loaded.
* **Sequence described in the transcript:**

  * UEFI firmware measures the bootloader.
  * The bootloader measures the operating-system kernel.
  * Additional boot components and drivers are measured.
* **Storage location:** Measurements are extended into Platform Configuration Registers within the TPM. [How Windows uses the TPM](https://learn.microsoft.com/en-us/windows/security/hardware-security/tpm/how-windows-uses-the-tpm)
* **Integrity property:** Changing a measured component produces a different hash and therefore a different attestation state.
* **Purpose:** The measurements create evidence of what was loaded rather than merely asserting that the VM is healthy.

## 17.2 Attestation Flow

1. The virtual machine starts.
2. Firmware, bootloader, kernel, and related components are measured.
3. Measurements are placed into vTPM Platform Configuration Registers.
4. A health-monitoring or attestation service requests evidence.
5. The vTPM signs the measurements with an attestation or endorsement-related key.
6. The external service validates the signature.
7. The service compares the measurements with expected values or policy.
8. A matching state is treated as healthy.
9. A mismatched state can generate an alert or containment action.

* **Outcome:** Attestation provides cryptographic evidence that the boot state matches an expected configuration.
* **Response example:** Microsoft Defender or Sentinel could initiate isolation when a workload fails an integrity check.
* **Design distinction:** Secure Boot blocks unauthorized startup components, while attestation communicates measured state to another system.

> **Requires documentation validation:** Confirm which Azure or VMware service performs guest attestation for the specific AVS design and what automated isolation integrations are natively supported.

---

# 18. vTPM Cloning Behavior in vSphere 7 and vSphere 8

Cloning a vTPM-enabled virtual machine requires careful handling because the vTPM contains identity-specific secrets.

## 18.1 Version Comparison Stated in the Transcript

| Behavior                           | vSphere 7                                                                                 | vSphere 8                                                       |
| ---------------------------------- | ----------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| Default cloning behavior described | The clone may receive an exact copy of the original vTPM state.                           | The clone workflow provides options to copy or replace the TPM. |
| Security concern                   | Multiple clones may share the same cryptographic identity and secrets.                    | A replacement TPM can generate unique secrets for the clone.    |
| Appropriate use of copying         | Exact replication or backup-related scenarios where identity preservation is intentional. | Explicitly selected exact replication.                          |
| Appropriate use of replacement     | Not described as readily available in the transcript.                                     | Independent production clones requiring unique identity.        |

* **Risk:** Ten cloned servers should not share identical endorsement keys or attestation identity when they are intended to operate independently.
* **Attestation problem:** Identical cryptographic state prevents each clone from proving a unique identity.
* **vSphere 8 improvement:** The cloning wizard can replace the TPM state and generate a new vTPM for the cloned virtual machine.
* **Version dependency:** Clone procedures must account for the actual vSphere version used by the AVS private cloud.

> **Requires documentation validation:** Confirm exact vSphere 7 behavior, available clone APIs, backup semantics, and the vSphere 8 options presented by the specific AVS build.

## 18.2 Safe Clone Procedure

1. Determine whether the clone must preserve or replace the original virtual machine’s cryptographic identity.
2. Confirm the vSphere version and supported cloning options.
3. For an independent workload, select TPM replacement or the supported equivalent.
4. Confirm that the clone receives unique TPM state and keys.
5. Validate Secure Boot and vTPM health.
6. Verify BitLocker or other TPM-bound protection.
7. Confirm that the clone can independently attest.
8. Do not deploy multiple production clones until uniqueness has been verified.

**Operational implication:** A VM template containing a vTPM is not an ordinary template. Its cryptographic identity is part of the cloning decision.

---

# 19. BitLocker Enablement

Adding Secure Boot and a vTPM enables the guest operating system to use TPM-dependent protections such as BitLocker.

* **Key-storage function:** BitLocker can protect operating-system volume key material using a TPM protector. [BitLocker planning guide](https://learn.microsoft.com/en-us/windows/security/operating-system-security/data-protection/bitlocker/planning-guide)
* **Physical-equivalent behavior:** The virtual machine gains a trust mechanism similar to a corporate laptop with a physical TPM.
* **Layered-encryption benefit:** vSAN encryption protects the underlying datastore, while BitLocker protects the guest volume within the virtual machine.
* **Scope distinction:** Datastore encryption protects storage media; BitLocker protects the guest’s logical disk and boot relationship.
* **Recovery requirement:** BitLocker recovery keys must be escrowed and governed independently.
* **Migration consideration:** TPM-bound encryption can affect clone, restore, export, and recovery procedures.

---

# 20. Virtualization-Based Security

Virtualization-Based Security, or VBS, uses hardware virtualization and the Windows hypervisor to create an isolated environment [Virtualization-based Security](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-vbs) to protect critical Windows security functions from the normal operating-system kernel.

## 20.1 Privilege Model

* **Traditional model:** The operating-system kernel operates at the highest software privilege and can access system memory.
* **Attack consequence:** A kernel-level compromise can expose credentials, disable endpoint protection, modify security checks, and control the system.
* **Virtualization model:** The hypervisor operates beneath the guest operating system at a conceptually higher privilege level.
* **Transcript terminology:** This hypervisor level is described conceptually as “ring negative one.”
* **VBS advantage:** The hypervisor can deny the normal kernel access to selected memory even when the kernel itself is compromised.

## 20.2 Secure World and Normal World

VBS divides the virtual machine’s execution environment into two logical regions:

| Region       | Purpose                                                                                | Access characteristics                                                |
| ------------ | -------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| Normal world | Runs the primary Windows operating system, applications, and ordinary kernel activity. | A kernel compromise can control this region.                          |
| Secure world | Runs isolated security services and protects sensitive memory.                         | Access is enforced by the hypervisor and denied to the normal kernel. |

* **Memory isolation:** The hypervisor reserves a protected memory enclave.
* **Secondary environment:** A specialized minimal security environment operates within the isolated region.
* **Kernel-compromise resilience:** Ring-zero malware in the normal world cannot directly read secure-world memory.
* **Hardware-enforced boundary:** The hypervisor intercepts disallowed memory access.
* **Security shift:** Protection moves from software policy inside the guest to enforcement beneath the guest.

> **Requires documentation validation:** The transcript characterizes the isolation as “impenetrable.” No control should be treated as absolute; security depends on hardware, firmware, hypervisor, configuration, and implementation correctness.

---

# 21. Credential Guard

Credential Guard uses VBS to isolate authentication secrets [How Credential Guard works](https://learn.microsoft.com/en-us/windows/security/identity-protection/credential-guard/how-it-works) handled by the Local Security Authority.

* **Protected component:** Local Security Authority functions associated with user authentication and credential caching.
* **Threat addressed:** Credential-dumping tools attempt to read NT LAN Manager hashes, Kerberos tickets, or other secrets from memory.
* **Example tool named in the transcript:** Mimikatz.
* **Traditional attack:** An attacker compromises a server, obtains high privilege, scrapes memory, and uses stolen hashes or tickets for lateral movement.
* **VBS behavior:** Protected credential material is moved into secure-world memory.
* **Result:** A kernel-level process in the normal world cannot directly read those secrets.
* **Attack reduced:** Pass-the-hash and related credential-reuse techniques become substantially more difficult.

> **Requires documentation validation:** Credential Guard reduces credential exposure but does not guarantee complete elimination of credential theft or lateral movement. Identity configuration, protocol use, delegated credentials, application compatibility, and attacker technique still matter.

---

# 22. Hypervisor-Protected Code Integrity

Hypervisor-Protected Code Integrity, or HVCI, uses VBS to protect code-integrity decisions. [App Control for Business and virtualization-based code integrity](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/introduction-to-virtualization-based-security-and-appcontrol)

* **Verification location:** Signature validation is moved into the isolated security environment.
* **Kernel limitation:** A compromised normal-world kernel cannot simply disable or alter the protected verification process.
* **Driver control:** New kernel code and drivers must satisfy the enforced integrity policy.
* **Malware constraint:** Unauthorized kernel code cannot execute merely because the normal kernel has been compromised.
* **Security model:** The hypervisor protects the mechanism that decides what code is trusted.
* **Compatibility consideration:** Older drivers or software that depend on unsupported kernel behavior may fail when HVCI is enabled.

### Trusted Launch Validation Sequence

1. Confirm that the guest operating system supports UEFI, Secure Boot, TPM 2.0, VBS, Credential Guard, and HVCI as required.
2. Confirm that installed drivers are signed and compatible.
3. Enable Secure Boot.
4. Add and validate the vTPM.
5. Enable VBS and applicable Windows security features.
6. Restart the workload.
7. Verify boot health and TPM status.
8. Confirm Credential Guard and HVCI state.
9. Test application and driver compatibility.
10. Validate monitoring and attestation signals.
11. Document recovery and rollback procedures.

**Takeaway:** Secure Boot protects the startup chain, the vTPM protects keys and measurements, and VBS protects sensitive execution after startup.

---

# 23. Defense-in-Depth Dependency Map

The security controls described in the transcript address different failure modes and should not be treated as substitutes.

| Control                             | Primary threat addressed                  | Key dependency                                            | What it does not replace           |
| ----------------------------------- | ----------------------------------------- | --------------------------------------------------------- | ---------------------------------- |
| Restricted `cloudadmin` permissions | Tenant damage to provider infrastructure  | AVS shared-responsibility model                           | Enterprise identity governance     |
| Entra ID service principals         | Microsoft control-plane automation        | Correct RBAC and enabled identities                       | Workload administration            |
| HCX secure tunnels                  | Hybrid workload movement                  | Private connectivity and HCX configuration                | Segmentation or malware inspection |
| Azure Firewall Premium              | Malicious north-south traffic             | Correct routing, certificates, policy, and capacity       | East-west microsegmentation        |
| NSX distributed firewall            | Lateral movement                          | Accurate workload grouping and rules                      | Application-layer WAF              |
| Application Gateway WAF             | Web-application attacks                   | TLS, listeners, WAF policy, backend health                | Secure application code            |
| Azure Monitor Agent                 | Guest telemetry collection                | Agent health and egress connectivity                      | Analysis and response              |
| Defender for Cloud                  | Posture and threat analysis               | Telemetry and service enablement                          | SIEM correlation                   |
| Microsoft Sentinel                  | Correlation and orchestration             | Connectors, analytics rules, playbooks, permissions       | Preventive controls                |
| vSAN encryption                     | Physical or storage-level data extraction | Available keys and authorized key operations              | Guest-volume encryption            |
| Key Vault CMK                       | Customer control over KEK lifecycle       | Managed identity, permissions, recoverable keys           | Operational governance             |
| Secure Boot                         | Unauthorized boot components              | UEFI and signed software                                  | Runtime memory isolation           |
| vTPM                                | Protected secrets and measured boot       | VM encryption and key provider                            | Secure Boot or VBS                 |
| VBS                                 | Kernel-resistant memory isolation         | Compatible OS, hardware virtualization, and configuration | Patch management                   |
| Credential Guard                    | Credential dumping                        | VBS                                                       | Strong identity policy             |
| HVCI                                | Unauthorized kernel code                  | VBS and compatible drivers                                | Application security               |

---

# 24. Troubleshooting Guide

## 24.1 Management Account Locks After Password Rotation

**Symptoms**

* `cloudadmin@vsphere.local` cannot authenticate.
* HCX, Horizon, orchestration, or monitoring services fail simultaneously.
* vCenter shows a burst of failed sign-in events.

**Likely cause**

* One or more integrated systems are retrying with cached credentials.

**Troubleshooting sequence**

1. Stop all known services that use the account.
2. Identify the source addresses generating failed authentication events.
3. Wait for or resolve the account lockout through the supported process.
4. Update credentials in every dependent system.
5. Restart integrations individually.
6. Verify that failed-authentication volume returns to normal.
7. Replace the shared account with dedicated service identities.

## 24.2 AVS Management Operations Fail While VMs Continue Running

**Symptoms**

* Existing workloads remain online.
* Host scaling, patching, monitoring, or Azure integrations fail.

**Likely cause**

* A required Entra ID application or RBAC assignment was disabled, deleted, or changed.

**Troubleshooting sequence**

1. Review recent Entra ID audit events.
2. Inspect the required first-party AVS applications.
3. Confirm that the service principals are enabled.
4. Verify resource-group role assignments.
5. Restore deleted identities using supported AVS procedures.
6. Test a non-disruptive management operation.
7. Add protection against unreviewed application cleanup.

## 24.3 Encrypted Datastore Does Not Mount

**Symptoms**

* Hosts fail to access vSAN storage.
* A problem begins after a key, identity, policy, or host-lifecycle change.

**Likely causes**

* The KEK is disabled or deleted.
* The required key version is unavailable.
* The AVS managed identity was deleted.
* `unwrapKey` permission was removed.
* Key Vault communication is unavailable.

**Troubleshooting sequence**

1. Review Key Vault and Azure activity logs.
2. Verify the AVS managed identity.
3. Verify `wrapKey` and `unwrapKey` authorization.
4. Confirm that the correct key and version are enabled.
5. Restore a soft-deleted key where necessary.
6. Confirm Key Vault network accessibility.
7. Retry through the supported AVS recovery workflow.
8. Confirm all hosts mount the datastore.
9. Preserve incident evidence before changing additional controls.

## 24.4 vTPM-Enabled Clone Has Identity Problems

**Symptoms**

* Multiple clones present identical TPM-related identity.
* Attestation cannot distinguish systems.
* TPM-bound security features behave unexpectedly.

**Likely cause**

* The source TPM was copied rather than replaced during cloning.

**Troubleshooting sequence**

1. Confirm the vSphere version.
2. Determine how the clone was created.
3. Inspect whether TPM state was copied.
4. Recreate the clone with TPM replacement where supported.
5. Re-enroll BitLocker, certificates, or attestation identity as required.
6. Validate unique cryptographic state.

## 24.5 Secure Boot or HVCI Prevents Startup

**Symptoms**

* The VM fails to boot after Trusted Launch controls are enabled.
* A driver or kernel component is rejected.
* An application depending on an incompatible driver fails.

**Likely causes**

* An unsigned or unsupported boot component.
* Legacy BIOS configuration.
* Incompatible guest operating system.
* Driver incompatibility with HVCI.

**Troubleshooting sequence**

1. Review the VM firmware and Secure Boot settings.
2. Inspect guest boot and code-integrity logs.
3. Identify unsigned or incompatible drivers.
4. Update or replace the affected component.
5. Test in a non-production clone.
6. Re-enable security controls and validate startup.
7. Avoid permanently weakening the configuration without a documented risk decision.

---

# 25. Operational Recommendations

* **Identity:** Use enterprise directory groups for routine human administration and retain local AVS identities only for controlled emergency access.
* **Service accounts:** Assign a dedicated identity to each integration and document its owner, permissions, credential lifecycle, and dependencies.
* **Entra ID governance:** Exclude required AVS service principals from automated stale-application cleanup unless a platform-aware validation step is performed.
* **RBAC:** Apply least privilege at the narrowest supported scope.
* **Network extension:** Treat every stretched Layer 2 segment as an extension of the on-premises threat domain.
* **Inspection:** Route eligible north-south flows through Azure Firewall Premium and test TLS inspection compatibility.
* **Microsegmentation:** Enforce workload-specific east-west rules through NSX distributed firewalling.
* **Public publishing:** Use Application Gateway and WAF for Layer 7 inspection and private backend routing.
* **Telemetry:** Deploy supported guest agents and centralize logs in Log Analytics.
* **Detection:** Tune Sentinel rules to the environment rather than relying on generic event thresholds.
* **Automation:** Place safeguards, approvals, and rollback logic around response playbooks that modify identities or firewalls.
* **Encryption:** Decide explicitly between platform-managed and customer-managed keys.
* **Key safety:** Enable and verify soft delete and purge protection before customer-managed-key activation.
* **Recovery:** Test restoration of deleted keys and authorization in a non-production environment.
* **Trusted Launch:** Validate guest and driver compatibility before enabling Secure Boot, vTPM, VBS, Credential Guard, and HVCI at scale.
* **Cloning:** Ensure every independent clone receives a unique vTPM identity.
* **Compliance:** Treat provider certifications as platform evidence, not as a substitute for workload-specific compliance controls.

---


# Documentation and Interpretation Notes

* **Material corrections:** Current Gen 2 documentation names the required enterprise applications **Avs Fleet Rp** and **AzS VIS Prod App** and documents their resource-group role assignments. The legacy Log Analytics agent is retired; new deployments should use Azure Monitor Agent. Customer-managed-key access requires `get`, `wrapKey`, and `unwrapKey`, and Key Vault must have soft delete and purge protection enabled.
* **Claims not directly confirmed:** The transcript-provided `abs-fleet-rp` application identifier, the `setAzureAidServicePrinciple` command spelling, the exact NSX role-rejection wording, the stated millisecond/no-noticeable-latency TLS-inspection claim, and an AVS-specific assertion that CVSS is the governing triage mechanism were not directly confirmed in the reviewed official documentation.
* **Architecture distinctions:** Generation 1 AVS commonly uses the Microsoft-managed ExpressRoute circuit and Global Reach for on-premises connectivity, while Generation 2 provides native Azure Virtual Network connectivity and has separate network-design considerations. Security and routing behavior should be applied only to the generation and topology documented by the linked source.
* **Interpretive recommendations:** Treat stretched Layer 2 networks as temporary trust extensions, use separate service identities for integrations, stage microsegmentation incrementally, and govern customer-managed keys as availability-critical infrastructure. These are operational interpretations built on the documented product behaviors, not universal Microsoft mandates.

# Architecture Summary

The end-to-end AVS security architecture replaces the single physical perimeter with a chain of identities, private network paths, inspection controls, cryptographic boundaries, workload isolation, and continuous monitoring. Each layer addresses a different point at which trust could fail.

1. **Administrative access begins with enterprise identity.**

   * Routine administrators use mapped directory groups.
   * `cloudadmin@vsphere.local` remains a protected break-glass account.
   * Dedicated service identities prevent automation from depending on the emergency account.

2. **Azure controls provider-sensitive configuration.**

   * Supported run commands apply sensitive vCenter integration changes.
   * Required Entra ID service principals perform AVS management, monitoring, scaling, and lifecycle functions.
   * Resource-group RBAC authorizes those applications.

3. **Microsoft and the tenant retain distinct infrastructure responsibilities.**

   * Microsoft manages physical hosts, provider networking, and NSX Tier-0.
   * The tenant manages workloads, permitted NSX constructs, Tier-1 functions, and distributed firewall policy.

4. **Hybrid traffic reaches AVS through private connectivity.**

   * ExpressRoute and Global Reach connect on-premises infrastructure with AVS.
   * HCX extends Layer 2 networks and supports migration without immediate IP changes.
   * The stretched network also extends the on-premises blast radius.

5. **North-south traffic is inspected.**

   * Azure Firewall Premium provides IDPS and TLS inspection at the Azure network ingress.
   * Malicious traffic can be detected and dropped before it reaches AVS workloads.

6. **East-west traffic is segmented.**

   * NSX distributed firewall policy is applied at the workload interface.
   * A compromised virtual machine can be contained within a microperimeter rather than moving laterally.

7. **Public applications use an application-aware entry point.**

   * Application Gateway terminates and evaluates Layer 7 traffic.
   * WAF policy blocks web-application attacks.
   * URL rules route requests to private, specialized AVS backend pools.

8. **Guest operating systems emit centralized telemetry.**

   * Azure Monitor Agent collects Windows, Linux, performance, and audit data.
   * Log Analytics stores and exposes the data for analysis.

9. **Defender and Sentinel detect and respond.**

   * Defender for Cloud evaluates workload posture and suspicious behavior.
   * Sentinel correlates identity, endpoint, firewall, and guest events.
   * Playbooks can reset credentials, block source addresses, create incidents, or isolate workloads.

10. **vSAN encryption protects physical storage.**

    * DEKs encrypt data.
    * KEKs wrap the DEKs.
    * Extracted physical media remains unreadable without authorized key operations.

11. **Azure Key Vault enables customer-controlled encryption.**

    * The AVS managed identity requests `wrapKey` and `unwrapKey` operations.
    * The KEK remains within the Key Vault boundary.
    * Soft delete and purge protection reduce the risk of accidental cryptographic lockout.

12. **Trusted Launch protects execution integrity.**

    * Secure Boot verifies the startup chain.
    * The vTPM protects secrets and records boot measurements.
    * Attestation communicates measured state to external security systems.
    * VBS creates a hypervisor-protected memory region.
    * Credential Guard protects authentication material.
    * HVCI protects kernel code-integrity decisions.

The resulting model assumes that no single layer is fully trustworthy. The network may be breached, an administrator may make an error, a key may be mishandled, a web control may be bypassed, or the guest operating system itself may be compromised. AVS security therefore depends on limiting each identity, inspecting each boundary, isolating each workload, protecting each cryptographic dependency, and monitoring each execution layer.

The final architectural shift is that the operating system is no longer treated as the ultimate trust boundary. Secure Boot, vTPM, attestation, VBS, Credential Guard, and HVCI place critical security decisions beneath or outside the ordinary guest kernel. In this model, the application and its supporting controls must remain defensible even when the operating system is treated as potentially hostile territory.
