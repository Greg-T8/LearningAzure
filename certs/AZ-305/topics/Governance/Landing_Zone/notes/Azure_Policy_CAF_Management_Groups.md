Here is the revised response with **Corp, Online, and Sandbox** incorporated as distinct Landing Zone policy archetypes.

# CAF-Aligned Azure Policy Archetypes by Management Group

Azure management groups should represent subscriptions that require the same security, connectivity, compliance, and platform configuration. The value of separate management groups is therefore not simply organizational separation; it is the ability to assign different Azure Policy initiatives and RBAC models through inheritance.

The following structure uses separate management groups for the four platform functions and for the three requested landing-zone workload archetypes:

```text
BART
├── Platform
│   ├── Identity
│   │   └── BART-Identity
│   ├── Management
│   │   └── BART-Management
│   ├── Security
│   │   └── BART-Security
│   └── Connectivity
│       └── BART-Connectivity
│
└── Landing Zones
    ├── Corp
    │   └── Corporate and hybrid-connected subscriptions
    ├── Online
    │   └── Internet-facing and publicly accessible workloads
    └── Sandbox
        └── Isolated experimentation and proof-of-concept subscriptions
```

CAF describes:

* **Corp** as workloads that require connectivity or hybrid connectivity to the corporate network.
* **Online** as workloads that require direct internet connectivity or might not require a virtual network.
* **Sandbox** as isolated subscriptions with less-restrictive policies for testing and exploration. ([Microsoft Learn][1])

This means the effective policy configuration for a workload subscription is cumulative:

```text
Intermediate root policies
        +
Landing Zones parent policies
        +
Corp, Online, or Sandbox policies
        =
Effective landing-zone archetype
```

## 1. Identity management group

Typical resources include domain controller VMs, Microsoft Entra Domain Services, identity virtual networks, NICs, managed disks, and Recovery Services vaults.

| Recommended policy                                                     |                  Effect | Practical purpose                                                                        |
| ---------------------------------------------------------------------- | ----------------------: | ---------------------------------------------------------------------------------------- |
| **Network interfaces should not have public IPs**                      |                    Deny | Prevents direct internet exposure of domain controllers and identity servers.            |
| **Subnets should be associated with a Network Security Group**         |              Audit/Deny | Ensures identity subnets have explicit network controls.                                 |
| **Virtual machines should have Trusted Launch enabled**                |                   Audit | Identifies identity servers that do not use Secure Boot and virtual TPM where supported. |
| **Windows virtual machines should have Azure Monitor Agent installed** |       DeployIfNotExists | Onboards domain controllers to the approved identity monitoring data collection rule.    |
| **Azure Backup should be enabled for Virtual Machines**                | Audit/DeployIfNotExists | Ensures domain controllers and supporting identity servers are protected.                |
| **Virtual machines should have Encryption at Host enabled**            |              Audit/Deny | Protects temporary disks, caches, and data moving between compute and storage.           |

These policies establish a more restrictive VM security baseline than would necessarily be appropriate for every application workload. Relevant built-ins are available in the Azure VM, Backup, Monitor, and networking policy catalogs. ([Microsoft Learn][2])

**Why the separate management group is justified:** identity servers can receive mandatory hardening, backup, monitoring, and network-isolation policies without imposing the same requirements on every workload VM.

---

## 2. Management management group

Typical resources include Log Analytics workspaces, Azure Monitor Private Link Scopes, Automation accounts, data collection rules, action groups, and monitoring support services.

| Recommended policy                                                                        |           Effect | Practical purpose                                                                                     |
| ----------------------------------------------------------------------------------------- | ---------------: | ----------------------------------------------------------------------------------------------------- |
| **Log Analytics workspaces should block log ingestion and querying from public networks** |       Audit/Deny | Restricts the central monitoring workspace to approved private connectivity.                          |
| **Log Analytics Workspaces should block non-Microsoft Entra-based ingestion**             |       Audit/Deny | Prevents legacy or unauthenticated log ingestion methods.                                             |
| **Azure Monitor Private Link Scope should use private link**                              | AuditIfNotExists | Confirms that Azure Monitor is reachable through the approved private monitoring path.                |
| **Automation Account should have Managed Identity**                                       |            Audit | Prevents runbooks from depending on stored service-principal credentials or obsolete Run As accounts. |
| **Azure Automation account should have local authentication method disabled**             |       Audit/Deny | Requires Microsoft Entra authentication instead of Automation account access keys.                    |
| **Automation accounts should disable public network access**                              |       Audit/Deny | Restricts Automation services to private endpoints.                                                   |

Microsoft provides built-in policies for Log Analytics, Azure Monitor Private Link Scope, and Azure Automation, including managed identities, local authentication, and public network access. ([Microsoft Learn][3])

**Why the separate management group is justified:** these policies target centralized operations infrastructure and would have little or no applicability to most workload subscriptions.

---

## 3. Security management group

Typical resources include Microsoft Sentinel, security Log Analytics workspaces, Event Hubs, syslog or CEF collectors, Logic App playbooks, Key Vaults, and security integration services.

| Recommended policy                                                                 |                  Effect | Practical purpose                                                                                               |
| ---------------------------------------------------------------------------------- | ----------------------: | --------------------------------------------------------------------------------------------------------------- |
| **Azure Event Hub namespaces should have local authentication methods disabled**   |              Audit/Deny | Requires security log publishers and consumers to use Microsoft Entra identities instead of shared access keys. |
| **Event Hub Namespaces should disable public network access**                      |              Audit/Deny | Prevents the central security ingestion service from being publicly reachable.                                  |
| **Event Hub namespaces should use private link**                                   |        AuditIfNotExists | Ensures private connectivity for security-event ingestion.                                                      |
| **Azure Key Vault should have purge protection enabled**                           | Audit/DeployIfNotExists | Protects SOC integration secrets and certificates from permanent deletion.                                      |
| **Azure Key Vault should have firewall enabled or public network access disabled** |              Audit/Deny | Restricts access to security secrets and automation credentials.                                                |
| **Deploy Diagnostic Settings for Logic Apps to Log Analytics workspace**           |       DeployIfNotExists | Records executions and failures for Sentinel playbooks and security automation.                                 |

Microsoft provides built-ins covering Event Hubs networking and authentication, Key Vault network and deletion protection, and Logic App diagnostic settings. ([Microsoft Learn][4])

A custom policy can additionally verify that:

* Microsoft Sentinel is enabled on the designated security workspace.
* The security workspace meets the organization’s required retention period.
* Only approved workspaces can be onboarded to Sentinel.

**Why the separate management group is justified:** these policies protect SIEM ingestion, playbooks, forensic data, and security secrets. They also support a separate SecOps RBAC model from the general management and monitoring team.

---

## 4. Connectivity management group

Typical resources include Virtual WAN, virtual hubs, Azure Firewall, Firewall Policy, VPN and ExpressRoute gateways, DDoS plans, Network Watcher, Private DNS zones, and DNS Private Resolver.

| Recommended policy                                                    |            Effect | Practical purpose                                                                     |
| --------------------------------------------------------------------- | ----------------: | ------------------------------------------------------------------------------------- |
| **Azure Firewall Policy should enable Threat Intelligence**           |              Deny | Prevents deployment of firewall policies with threat-intelligence filtering disabled. |
| **Azure Firewall should have DNS Proxy enabled**                      |        Audit/Deny | Supports consistent DNS resolution and FQDN filtering through the central firewall.   |
| **Deploy Azure Firewall across multiple Availability Zones**          |              Deny | Enforces zone-resilient firewall deployment where supported.                          |
| **Azure VPN gateways should not use the Basic SKU**                   |        Audit/Deny | Prevents unsuitable gateway SKUs from being used for production connectivity.         |
| **Deploy Network Watcher when virtual networks are created**          | DeployIfNotExists | Ensures regional network monitoring is available.                                     |
| **Deploy VNet Flow Logs with Traffic Analytics for virtual networks** | DeployIfNotExists | Provides centralized traffic visibility and troubleshooting for platform networks.    |

Microsoft publishes built-in Azure Firewall policies for threat intelligence, DNS proxy, availability-zone deployment, and other network controls. ([Microsoft Learn][5])

**Why the separate management group is justified:** these controls apply specifically to resources operated by the central networking team and should not generally permit workload teams to deploy competing transit, firewall, DNS, or gateway services.

---

# Landing Zones management group

The **Landing Zones** parent should contain policies that apply to both Corp and Online workloads—and potentially Sandbox, depending on how much flexibility Sandbox subscriptions should inherit.

Appropriate parent-level assignments include:

| Shared Landing Zones policy                                                              |    Typical effect |
| ---------------------------------------------------------------------------------------- | ----------------: |
| Configure subscription Activity Logs to stream to the central Log Analytics workspace    | DeployIfNotExists |
| Enable required Microsoft Defender for Cloud plans                                       | DeployIfNotExists |
| Assign the approved Azure security baseline initiative                                   |             Audit |
| Require standard governance tags such as Owner, Application, Environment, and CostCenter |       Modify/Deny |
| Restrict deployments to approved Azure regions                                           |              Deny |
| Deploy required diagnostic settings for supported resources                              | DeployIfNotExists |

CAF recommends keeping policies at the Landing Zones parent workload-agnostic and assigning more specialized connectivity and security controls to its child archetypes. ([Microsoft Learn][1])

Because Sandbox is beneath Landing Zones in this proposed structure, any policy assigned at Landing Zones will also apply to Sandbox. Policies that would interfere with experimentation should therefore be assigned to **Corp and Online**, rather than to their common parent.

---

## 5. Corp management group

Typical workloads include internal business applications, domain-joined servers, Oracle Exadata integrations, AVS-connected services, databases, internal APIs, and applications requiring access to on-premises networks.

The defining characteristic is **private or hybrid connectivity through the centrally managed hub**.

| Recommended policy                                                                 |     Effect | Practical purpose                                                                           |
| ---------------------------------------------------------------------------------- | ---------: | ------------------------------------------------------------------------------------------- |
| **Network interfaces should not have public IPs**                                  |       Deny | Prevents workload VMs from bypassing the corporate ingress and egress architecture.         |
| **App Service apps should disable public network access**                          | Audit/Deny | Requires internal web applications to use private endpoints or controlled private access.   |
| **App Service apps should be injected into a virtual network**                     | Audit/Deny | Ensures application outbound traffic can use corporate DNS, routing, and security controls. |
| **Public network access on Azure SQL Database should be disabled**                 | Audit/Deny | Requires databases to be accessed through private endpoints.                                |
| **Storage accounts should disable public network access**                          | Audit/Deny | Keeps corporate application data on approved private network paths.                         |
| **Azure Key Vault should have firewall enabled or public network access disabled** | Audit/Deny | Prevents corporate application secrets from being exposed through public service endpoints. |

Microsoft provides service-specific built-ins for App Service network integration, App Service public access, Azure SQL public access, Storage networking, and Key Vault networking. ([Microsoft Learn][6])

Additional custom Corp policies could require:

* Virtual networks to connect to an approved virtual hub.
* Virtual machines to connect only to approved corporate virtual networks.
* Private endpoints to use centrally managed Private DNS zones.
* Default routes to point to the approved Azure Firewall or NVA.

**Why the separate management group is justified:** the Corp archetype enforces private network access and corporate transit. These controls would be inappropriate for workloads whose purpose is to receive direct internet traffic.

---

## 6. Online management group

Typical workloads include public websites, customer portals, internet-facing APIs, Application Gateways, Azure Front Door, public load balancers, and externally accessible App Services.

The defining characteristic is that **internet exposure is permitted but must be controlled and monitored**.

| Recommended policy                                                                     |                  Effect | Practical purpose                                                                    |
| -------------------------------------------------------------------------------------- | ----------------------: | ------------------------------------------------------------------------------------ |
| **Azure Web Application Firewall should be enabled for Azure Front Door entry points** | Audit/DeployIfNotExists | Ensures public web applications are protected by WAF at the Azure edge.              |
| **Web Application Firewall should use Prevention mode for Azure Front Door**           |              Audit/Deny | Prevents production WAF policies from remaining indefinitely in detection-only mode. |
| **Bot Protection should be enabled for Azure Front Door WAF**                          |              Audit/Deny | Protects internet-facing applications from known malicious and automated traffic.    |
| **Azure DDoS Protection should be enabled**                                            |        AuditIfNotExists | Protects virtual networks containing public application entry points.                |
| **Public IP addresses should have resource logs enabled for Azure DDoS Protection**    |       DeployIfNotExists | Captures mitigation, attack, and traffic information for public IP resources.        |
| **App Service applications should only be accessible over HTTPS**                      |            Audit/Modify | Prevents unencrypted HTTP access to public applications.                             |

Relevant networking built-ins cover Front Door WAF deployment, WAF configuration, bot protection, DDoS Protection, and public IP logging. App Service includes built-ins for HTTPS and current TLS configuration. ([Microsoft Learn][7])

Other practical Online controls include:

* Require request-body inspection on Application Gateway or Front Door WAF.
* Require resource logs for Front Door and Application Gateway.
* Require App Service minimum TLS versions.
* Disable FTP and SCM local authentication for App Service.
* Restrict direct access to Front Door origins.

**Why the separate management group is justified:** unlike Corp, Online explicitly permits public ingress. Its policies focus on making internet exposure deliberate, protected by WAF and DDoS controls, encrypted, and fully logged.

---

## 7. Sandbox management group

Typical resources can include nearly any Azure service being tested, but the subscription must remain isolated from Corp, Online, platform, and production environments.

Sandbox policies should generally be **less restrictive regarding service selection**, but **more restrictive regarding connectivity, cost, and lifecycle**.

| Recommended policy                                                     |      Effect | Practical purpose                                                                                 |
| ---------------------------------------------------------------------- | ----------: | ------------------------------------------------------------------------------------------------- |
| **Custom: Deny cross-subscription virtual network peering**            |        Deny | Prevents a sandbox virtual network from being connected to production or platform networks.       |
| **Custom: Deny ExpressRoute, VPN Gateway, and Virtual WAN deployment** |        Deny | Prevents users from creating private transit paths out of the isolated sandbox.                   |
| **Allowed locations**                                                  |        Deny | Restricts experiments to approved and cost-supported Azure regions.                               |
| **Allowed virtual machine size SKUs**                                  |        Deny | Prevents accidental deployment of very large or specialized high-cost VM SKUs.                    |
| **Not allowed resource types/Azure service blocklist**                 |        Deny | Blocks services that present unacceptable cost, regulatory, data-handling, or connectivity risks. |
| **Require Owner and ExpirationDate tags**                              | Deny/Modify | Establishes accountability and supports automated sandbox expiration and deletion.                |

Microsoft specifically recommends keeping sandbox networks isolated, denying cross-subscription peering, denying ExpressRoute/VPN/Virtual WAN creation, enabling central audit logging, and assigning expiration dates. CAF also recommends considering a service blocklist rather than restricting all sandboxes to a small allowlist. ([Microsoft Learn][8])

Azure Policy includes built-ins for allowed locations, allowed VM SKUs, allowed or disallowed resource types, and tag governance. ([Microsoft Learn][9])

The following controls should still be inherited by Sandbox:

* Subscription Activity Log export.
* Defender for Cloud visibility.
* Basic audit logging.
* Approved-region restrictions.
* Prohibition against sensitive production data.
* Organizational tagging.

However, Sandbox should normally not inherit blanket policies that require every PaaS service to use private endpoints, because those controls can prevent users from evaluating new Azure services.

**Why the separate management group is justified:** Sandbox requires a unique combination of broad service access, strong network isolation, limited VM sizes, cost governance, and automatic expiration.

---

# Policy placement summary

| Management-group scope | Policy purpose                                                                    |
| ---------------------- | --------------------------------------------------------------------------------- |
| **Intermediate root**  | Tenant-wide security, compliance, audit, and organizational requirements          |
| **Platform**           | Controls common to all platform subscriptions                                     |
| **Identity**           | Domain controller and identity-server hardening                                   |
| **Management**         | Azure Monitor, Log Analytics, Automation, and operational tooling                 |
| **Security**           | Sentinel, Event Hubs, Key Vault, playbooks, and security ingestion                |
| **Connectivity**       | Firewall, Virtual WAN, gateways, DNS, DDoS, and network monitoring                |
| **Landing Zones**      | Workload-independent monitoring, tagging, security, and region controls           |
| **Corp**               | Private endpoints, hybrid connectivity, and prohibition of direct public exposure |
| **Online**             | Controlled public exposure, WAF, DDoS, HTTPS, and internet-edge logging           |
| **Sandbox**            | Experimentation with strict isolation, cost limits, and expiration controls       |

# Key design conclusion

The strongest reason to maintain **Corp, Online, and Sandbox as separate management groups** is that their network policies are intentionally different:

* **Corp:** Public access is generally prohibited.
* **Online:** Public access is permitted but must be protected and monitored.
* **Sandbox:** Broad experimentation is permitted, but connectivity to the rest of the estate is prohibited.

Placing all three directly beneath the same Landing Zones management group allows them to inherit a common security and monitoring baseline while retaining materially different workload-specific guardrails.

This can also be condensed into a policy-assignment matrix showing the recommended **Audit, Deny, Modify, and DeployIfNotExists** rollout order for each management group.

[1]: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups "Management groups - Cloud Adoption Framework | Microsoft Learn"
[2]: https://learn.microsoft.com/en-us/azure/virtual-machines/policy-reference?utm_source=chatgpt.com "Built-in policy definitions for Azure Virtual Machines - Azure Virtual Machines | Microsoft Learn"
[3]: https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/policy-reference?utm_source=chatgpt.com "Azure Policy built-in definitions for Azure Monitor"
[4]: https://learn.microsoft.com/en-us/azure/event-hubs/policy-reference?utm_source=chatgpt.com "Built-in policy definitions for Azure Event Hubs"
[5]: https://learn.microsoft.com/en-us/azure/firewall/firewall-azure-policy?utm_source=chatgpt.com "Use Azure Policy to help secure your Azure Firewall deployments | Microsoft Learn"
[6]: https://learn.microsoft.com/en-us/azure/app-service/policy-reference?utm_source=chatgpt.com "Built-in policy definitions for Azure App Service"
[7]: https://learn.microsoft.com/en-us/azure/networking/policy-reference "Built-in policy definitions for Azure networking services | Microsoft Learn"
[8]: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/sandbox-environments "Landing zone sandbox environments - Cloud Adoption Framework | Microsoft Learn"
[9]: https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-basics?utm_source=chatgpt.com "Details of Azure Policy definition structure basics - Azure Policy | Microsoft Learn"
