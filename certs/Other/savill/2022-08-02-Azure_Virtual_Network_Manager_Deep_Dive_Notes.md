# Azure Virtual Network Manager Deep Dive - Exam Notes

**Video:** [https://www.youtube.com/watch?v=qNn83S55WHQ](https://www.youtube.com/watch?v=qNn83S55WHQ)  
**Published:** 2022-08-02  
**Duration:** 1:02:56  

*Generated on 2026-01-30 03:28*

---

## Table of Contents

- [Introduction](#introduction)
- [Virtual network refresher and challenges at scale](#virtual-network-refresher-and-challenges-at-scale)
- [Azure Virtual Network Manager overview and deployment](#azure-virtual-network-manager-overview-and-deployment)
- [Network groups](#network-groups)
- [Configurations](#configurations)
- [Connectivity configurations](#connectivity-configurations)
- [Hub and spoke](#hub-and-spoke)
- [Direct connectivity and connected groups](#direct-connectivity-and-connected-groups)
- [Hub and spoke direct connectivity with multiple network groups](#hub-and-spoke-direct-connectivity-with-multiple-network-groups)
- [Mesh and removing deployments](#mesh-and-removing-deployments)
- [Security admin configurations](#security-admin-configurations)
- [Types of action including Always Allow](#types-of-action-including-always-allow)
- [Demo and viewing rules applied](#demo-and-viewing-rules-applied)
- [Pricing](#pricing)
- [Summary and close](#summary-and-close)

## Introduction

**Timestamp**: 00:00:00 – 00:00:33

**Key Concepts**

- Connectivity between virtual networks
- Managing security rules around virtual networks
- Concept of a virtual network as an isolated network boundary

**Definitions**

- **Virtual Network**: A network defined by CIDR blocks (IPv4 or IPv6 address ranges) that provides an isolated network boundary within a cloud environment.

**Key Facts**

- Virtual networks are defined by CIDRs, which can be IPv4 or IPv6 address ranges.
- A virtual network cannot span multiple regions; it is bound to a single region.

**Examples**

- None mentioned explicitly, but the idea of managing security rules such as NSGs (Network Security Groups) around virtual networks was referenced.

**Key Takeaways 🎯**

- When designing cloud networks, consider how virtual networks connect and how security is managed around them.
- Virtual networks are region-specific and defined by specific IP address ranges.
- Security management typically involves tools like NSGs applied to these virtual networks.

---

## Virtual network refresher and challenges at scale

**Timestamp**: 00:00:33 – 00:03:52

**Key Concepts**

- Virtual networks (VNets) are defined by CIDR blocks (IPv4, IPv6).
- VNets are region-bound and subscription-bound; they cannot span multiple regions or subscriptions.
- Multiple VNets are common when using multiple regions or subscriptions.
- Communication patterns between VNets include hub-and-spoke, mesh, or hybrid models.
- VNet peering enables connectivity but is non-transitive by default.
- Transitive routing can be enabled via a hub with Azure Firewall or Network Virtual Appliance (NVA) and user-defined routes.
- Network Security Groups (NSGs) are used to control traffic within VNets at subnet or NIC level.
- NSGs must exist in the same region and subscription as the VNet.
- Managing multiple VNets and NSGs at scale presents operational challenges.
- Azure Virtual Network Manager is introduced as a solution to simplify and scale VNet management.

**Definitions**

- **Virtual Network (VNet)**: A logically isolated network defined by IP address ranges (CIDRs) within a specific Azure region and subscription.
- **VNet Peering**: A connection between two VNets that allows traffic to flow between them as if they were on the same network.
- **Network Security Group (NSG)**: A set of security rules that control inbound and outbound traffic at the subnet or network interface level.
- **Transitive Peering**: The ability for traffic to flow between peered VNets through an intermediary VNet (not supported natively).
- **Azure Firewall / Network Virtual Appliance (NVA)**: Network devices used to enable transitive routing and enforce security policies in a hub VNet.
- **User-Defined Routes (UDR)**: Custom routing rules to direct traffic through specific network appliances or paths.

**Key Facts**

- VNets cannot span multiple regions or subscriptions.
- Peering connections are not transitive; spokes cannot communicate with each other unless explicitly peered.
- NSGs must be in the same region and subscription as the VNet they protect.
- Managing peering and NSGs across many VNets leads to significant overhead.
- Azure Virtual Network Manager aims to address scale and management complexity.

**Examples**

- Hub-and-spoke model: A central hub VNet with core services and gateways, with multiple spoke VNets connected to the hub.
- Mesh model: All VNets connected to each other to allow full communication.
- Hybrid model: Combination of mesh and hub-and-spoke, e.g., full communication plus centralized gateways.
- Enabling transitivity by placing Azure Firewall or NVA in the hub and using user-defined routes to direct traffic.

**Key Takeaways 🎯**

- VNets are isolated by region and subscription, requiring multiple VNets for multi-region or multi-subscription deployments.
- Peering is essential for VNet connectivity but requires explicit connections between each pair of VNets.
- Transitive routing requires additional infrastructure and configuration, increasing complexity.
- NSGs provide granular traffic control but add to management overhead when scaled.
- Azure Virtual Network Manager is designed to simplify and centralize management of VNets and security at scale.
- Understanding these foundational concepts is critical before leveraging Azure Virtual Network Manager for large-scale network management.

---

## Azure Virtual Network Manager overview and deployment

**Timestamp**: 00:03:52 – 00:11:00

**Key Concepts**

- Azure Virtual Network Manager (AVNM) is designed to simplify and scale the management of virtual networks across regions, subscriptions, and tenants.
- AVNM instances have a defined scope that determines which virtual networks they manage.
- Scope can be set at different levels: management groups, subscriptions, or the entire organization.
- AVNM supports two main feature sets: connectivity management and security administration.
- Network groups are created under an AVNM instance to logically group virtual networks based on dynamic rules.
- Billing is based on the number of subscriptions managed by each AVNM instance; overlapping scopes can lead to double billing.

**Definitions**

- **Azure Virtual Network Manager (AVNM)**: A service to centrally manage virtual networks at scale across multiple regions, subscriptions, and tenants.
- **Scope**: The boundary or extent of management for an AVNM instance, which can include management groups or subscriptions.
- **Management Groups**: Hierarchical containers in Azure used to organize subscriptions for governance, policy, and access control.
- **Network Group**: A collection of virtual networks grouped under an AVNM instance, defined by rules (e.g., name contains, tags).
- **Security Admin**: A feature in AVNM that allows centralized management of security rules, providing benefits beyond traditional Network Security Groups (NSGs).
- **Connectivity**: A feature in AVNM to define and manage connectivity between virtual networks.

**Key Facts**

- AVNM instances are created in a specific Azure region but can manage virtual networks across multiple regions, subscriptions, and tenants.
- Management groups allow organizing subscriptions hierarchically for policy, budget, and RBAC purposes.
- You can create multiple AVNM instances with different scopes and feature sets (e.g., one for security at the org level, another for connectivity at subscription level).
- Billing is subscription-based per AVNM instance; if a subscription is managed by multiple instances, it is billed multiple times.
- Network groups must be within the scope of the AVNM instance and can be defined dynamically using rules such as name or tags.

**Examples**

- Creating an AVNM instance named "AVNM1" scoped at the root management group to manage the entire organization’s virtual networks.
- Having a second AVNM instance "AVNM2" scoped to specific subscriptions focusing on both connectivity and security.
- Using dynamic rules to include virtual networks in a network group based on naming conventions or tags.

**Key Takeaways 🎯**

- AVNM enables centralized, scalable management of virtual networks beyond regional and subscription boundaries.
- Properly defining the scope of AVNM instances is critical to effective management and cost control.
- Separating AVNM instances by feature (security vs connectivity) and scope (org-wide vs subscription-specific) is a common and recommended pattern.
- Be mindful of billing implications when overlapping scopes cause subscriptions to be managed by multiple AVNM instances.
- Network groups provide flexible, rule-based grouping of virtual networks within the AVNM scope, facilitating targeted management and policy application.

---

## Network groups

**Timestamp**: 00:11:00 – 00:16:50

**Key Concepts**

- Network groups are created under an Azure Virtual Network Manager instance and must be within its scope.
- Network groups define membership of virtual networks (VNets) either dynamically or statically.
- Dynamic membership uses rules based on properties like name, tags, subscription, resource group, etc.
- A single virtual network can belong to multiple network groups.
- Network groups are used to organize VNets for applying connectivity and security admin configurations.
- It is possible to create a default network group containing all VNets for broad rule application, with more specific groups for granular control.

**Definitions**

- **Network Group**: A logical grouping of virtual networks within the scope of an Azure Virtual Network Manager instance, defined by static or dynamic membership rules, used to apply connectivity and security configurations.

- **Dynamic Membership**: Membership in a network group determined by rules (e.g., JSON-based) that automatically include VNets matching criteria such as name, tags, subscription, or resource group.

- **Static Membership**: Explicitly specifying which VNets belong to a network group without relying on rules.

**Key Facts**

- Network groups must be created within the scope of a single Azure Virtual Network Manager instance.
- Dynamic membership rules can be based on attributes including:
  - VNet name
  - VNet ID
  - Tags
  - Subscription name and ID
  - Subscription tags
  - Resource group name and ID
- New VNets matching dynamic rules are automatically added to the network group and inherit its configurations.
- Example IP address spaces used in demo:
  - Hub VNet: 10.100.0.0/16
  - Spoke VNets: 10.101.0.0/16, 10.102.0.0/16, 10.103.0.0/16
  - Separate prod/test VNet: 192.168.x.x space

**Examples**

- Demo environment with two network groups:
  - **Spokes**: Includes spoke1, spoke2, spoke3 VNets with IP spaces 10.101, 10.102, 10.103 respectively, plus a hub VNet (10.100).
  - **Prod**: A statically defined group containing a VNet named "test" with a 192.168.x.x IP space.
- Dynamic membership rule example uses JSON-based criteria to automatically include VNets based on tags or naming conventions.
- Static membership example includes manually adding specific VNets to a group.

**Key Takeaways 🎯**

- Network groups enable flexible and scalable management of VNets by grouping them logically.
- Use dynamic membership rules to automate inclusion of VNets and reduce manual overhead.
- Static membership is useful for precise control or exceptions.
- Organizing VNets into network groups facilitates applying consistent connectivity and security policies.
- Consider creating a default network group for all VNets to apply baseline policies, then use additional groups for more granular control.
- Network groups are foundational before creating connectivity or security admin configurations in Azure Virtual Network Manager.

---

## Configurations

**Timestamp**: 00:16:50 – 00:20:25

**Key Concepts**

- Configurations are created after defining network groups.
- There are two types of configurations: **Connectivity** and **Security Admin**.
- Connectivity configurations define network topology (hub and spoke or mesh).
- Security admin configurations consist of rule collections that control traffic flow.
- Security admin rules act as a funnel before Network Security Groups (NSGs) are evaluated.
- Configurations are linked to network groups and deployed to take effect.
- Connectivity configurations can override default communication boundaries, including cross-region communication.

**Definitions**

- **Configuration**: A set of rules or topology definitions applied to network groups to manage connectivity and security.
- **Connectivity Configuration**: Defines how VNets communicate, typically as hub and spoke (central hub with spokes that may or may not communicate with each other) or mesh (any-to-any communication).
- **Security Admin Configuration**: Contains one or more rule collections that specify traffic rules, similar to NSGs but evaluated first, allowing blocking or forcing traffic before NSGs.
- **Rule Collections**: Groups of rules within a security admin configuration, defining allowed or blocked traffic based on IPs, service tags, ports, and protocols.
- **Hub and Spoke**: A network topology where spokes connect to a central hub, which provides shared services; spokes may be isolated from each other.
- **Mesh**: A network topology where every spoke can communicate with every other spoke (any-to-any).

**Key Facts**

- Security admin rules are evaluated before NSGs, effectively overriding NSG rules.
- Protocols used in security admin rules are similar to NSGs but with more flexibility.
- By default, communication boundaries exist per region but can be overridden to allow cross-region communication.
- Configurations can be linked to multiple network groups.
- Hub and spoke example: a configuration with 1 hub and 3 spokes was mentioned.

**Examples**

- Hub and spoke connectivity: spokes connect to a hub network to use its services; spokes may not communicate with each other.
- Mesh connectivity: all spokes can communicate with each other (any-to-any).
- Security admin rules example: ensuring traffic to domain controllers or update infrastructure is always allowed, even if NSGs block it.

**Key Takeaways 🎯**

- Configurations are essential for defining both connectivity topology and security rules at a higher level than NSGs.
- Security admin configurations provide a powerful way to enforce or block traffic before NSGs are applied.
- Choosing between hub and spoke or mesh connectivity depends on desired communication patterns.
- Configurations must be linked and deployed to network groups to take effect.
- Understanding the precedence of security admin rules over NSGs is critical for effective network security management.

---

## Connectivity configurations

**Timestamp**: 00:20:25 – 00:20:50

**Key Concepts**

- Connectivity configurations focus on network topology options.
- Two primary connectivity models: hub and spoke, and mesh.
- The hub and spoke model involves a central hub connected to multiple spokes.

**Definitions**

- **Hub and Spoke Model**: A network topology where a central hub connects to multiple spokes (individual network segments or groups), facilitating communication primarily through the hub.

**Key Facts**

- The example configuration includes a hub with 3 spokes.
- The number of spokes can be extended beyond three (e.g., spoke 1, spoke 2, spoke 3, spoke 4, spoke 5, and more).

**Examples**

- Starting with a hub and spoke configuration with 3 spokes.
- Imagining an expanded hub and spoke model with many spokes connected to a single hub.

**Key Takeaways 🎯**

- Connectivity configurations are essential for defining how network groups communicate.
- Hub and spoke is a common model that scales by adding more spokes to a central hub.
- Understanding these models is foundational before deploying network configurations.

---

## Hub and spoke

**Timestamp**: 00:20:50 – 00:26:30

**Key Concepts**

- Hub and spoke connectivity model in Azure Virtual Network Manager
- Use of peering between hub and spokes to enable communication
- Option to enable gateway functionality in the hub for spokes to use site-to-site VPN or ExpressRoute
- Deployment of connectivity configurations and targeting specific Azure regions
- Ability to test configurations in a single region before global rollout
- Direct connectivity option to allow spoke-to-spoke communication across regions

**Definitions**

- **Hub and Spoke Model**: A network topology where multiple spoke virtual networks connect to a central hub virtual network, typically used to centralize services and connectivity.
- **Peering**: A connection between virtual networks that enables traffic to flow between them.
- **Gateway Functionality**: Network gateway services (like site-to-site VPN or ExpressRoute) configured in the hub that spokes can leverage for external connectivity.
- **Network Group**: A collection of virtual networks grouped together for applying connectivity configurations.

**Key Facts**

- Hub and spoke can scale to many spokes (e.g., spoke 1 through spoke 5 and beyond).
- Peering is automatically created between the hub and each spoke upon deployment.
- Deployment can be scoped to specific Azure regions for controlled rollout.
- Initial creation of the configuration does not deploy or create peerings until explicitly deployed.
- Example showed 4 peerings created because a test virtual network was included alongside spokes.
- Azure Virtual Network Manager can manage connectivity and security rules, so granular deployment is important to avoid misconfiguration.

**Examples**

- Created a hub and spoke configuration with multiple spokes grouped in a network group.
- Deployed the configuration targeting specific regions.
- Observed that after deployment, the hub virtual network had peerings to all spokes (4 peerings due to inclusion of a test VNet).
- Mentioned possibility of spokes being in different regions (e.g., West US and East US).

**Key Takeaways 🎯**

- Hub and spoke is a common and scalable connectivity model in Azure networking.
- Peering between hub and spokes is managed automatically by Azure Virtual Network Manager once deployed.
- Gateway functionality in the hub can be shared with spokes for external connectivity.
- Deployment should be done carefully, possibly starting with a single region to test before full rollout.
- Direct spoke-to-spoke connectivity can be enabled if needed, especially for multi-region scenarios.
- Creating a configuration alone does not apply changes; explicit deployment is required to establish connectivity.

---

## Direct connectivity and connected groups

**Timestamp**: 00:26:30 – 00:36:25

**Key Concepts**

- Direct connectivity enables spokes in a hub-and-spoke network topology to communicate directly with each other without routing traffic through the hub.
- Connectivity groups are a new construct in Azure Virtual Network Manager that group VNets for direct communication.
- By default, connectivity groups are created per region and per network group.
- Global mesh option can be enabled to create a single connectivity group across multiple regions within the same network group, enabling any-to-any communication.
- Direct connectivity does not create additional peering connections between spokes; it leverages software-defined networking (SDN) to enable direct communication.
- Virtual networks can be members of up to two connectivity groups.
- Azure Virtual Network Manager uses Azure Policy to manage and track connectivity group membership and configuration.

**Definitions**

- **Direct Connectivity**: A feature that allows spokes in the same network group and region to communicate directly without routing through the hub or creating additional peerings.
- **Connectivity Group**: A logical grouping of VNets within Azure Virtual Network Manager that enables direct communication between those VNets without additional peering.
- **Global Mesh**: An option that merges connectivity groups across regions into a single connectivity group, enabling cross-region direct connectivity within the same network group.
- **Network Group**: A grouping of VNets that defines boundaries for connectivity groups and direct connectivity.

**Key Facts**

- Direct connectivity creates connectivity groups per region by default.
- Global mesh option merges these regional connectivity groups into one large group.
- Direct connectivity does not add peering connections between spokes; spokes maintain peering only with the hub.
- Connectivity groups are part of the Azure Virtual Network Manager’s software-defined networking stack.
- A virtual network can be part of up to two connectivity groups simultaneously.
- There is a current limit of 250 VNets per connectivity group (subject to change).
- Enabling direct connectivity requires redeployment of the configuration.
- Direct connectivity reduces latency by avoiding additional hops and does not consume peering slots.
- Azure Virtual Network Manager tracks connectivity group membership and updates via Azure Policy.

**Examples**

- A hub-and-spoke model with three spokes in the same region and network group: enabling direct connectivity allows these three spokes to communicate directly.
- A spoke in a different region or network group remains isolated in its own connectivity group unless global mesh is enabled.
- Enabling global mesh after direct connectivity merges connectivity groups across regions, allowing all spokes to communicate any-to-any.
- A VM’s NIC in spoke 2 shows peering only to the hub, but after enabling direct connectivity, it gains a connectivity group connection to spoke 1 and spoke 3 without additional peerings.

**Key Takeaways 🎯**

- Direct connectivity is a powerful feature to enable spoke-to-spoke communication without adding peering overhead or routing through the hub.
- Connectivity groups are a new Azure Virtual Network Manager construct that simplifies managing direct connectivity.
- By default, connectivity groups are regional and network group scoped; global mesh can extend connectivity across regions.
- Direct connectivity improves network efficiency by reducing hops and latency.
- VNets can belong to up to two connectivity groups, allowing flexible network configurations.
- Deployment changes are required to activate direct connectivity settings.
- Azure Virtual Network Manager automates tracking and enforcement of connectivity group membership using Azure Policy.
- Understanding the boundaries of network groups and regions is critical when designing connectivity groups and direct connectivity.

---

## Hub and spoke direct connectivity with multiple network groups

**Timestamp**: 00:36:25 – 00:38:20

**Key Concepts**

- Hub and spoke network topology with virtual networks grouped into connected groups.
- Network groups act as boundaries for connectivity and administrative control.
- Direct connectivity in hub and spoke creates separate connected groups per network group.
- Connectivity and communication are controlled and segmented by network groups even within the same region.
- Importance of separating network groups for different connectivity configurations, security, and administration.

**Definitions**

- **Network Group**: A logical grouping of virtual networks (e.g., production or development) that serves as a boundary for connectivity and administrative policies.
- **Hub and Spoke Configuration**: A network topology where multiple virtual networks (spokes) connect to a central virtual network (hub), enabling controlled communication.
- **Direct Connectivity**: A setting in the hub and spoke model that creates peerings and enables communication within each network group but keeps groups isolated from each other.

**Key Facts**

- Turning on direct connectivity in a hub and spoke model creates separate connected groups for each network group, even if they reside in the same region.
- This separation prevents all virtual networks from communicating indiscriminately, which could be undesirable.
- Different network groups allow for tailored connectivity, security, and administrative rules.

**Examples**

- Virtual networks named: production one, production two, production three, dev one, dev two.
- Network groups defined as "prod" (production networks) and "dev" (development networks).
- Enabling hub and spoke with direct connectivity results in two connected groups: one for prod networks and one for dev networks.

**Key Takeaways 🎯**

- Network groups are essential boundaries that control connectivity and administration in a hub and spoke model.
- Direct connectivity respects these boundaries by creating separate connected groups per network group.
- This design supports different security and administrative policies for production and development environments.
- Planning should consider network groups carefully to ensure proper segmentation and control.

---

## Mesh and removing deployments

**Timestamp**: 00:38:20 – 00:46:24

**Key Concepts**

- Mesh topology enables communication between multiple virtual networks within the same region by creating a connectivity group without using peering.
- Hub and spoke topology uses peering between spokes and hub, with connected groups for spoke-to-spoke communication.
- Removing existing connectivity deployments deletes peerings and connected groups.
- Mesh can be deployed regionally or globally (cross-region).
- Redeployment is required when changing topology or connectivity configurations.
- New virtual networks added to network groups are automatically included in existing connectivity without redeployment.
- Multiple connectivity configurations can coexist and are additive.
- Flexibility to keep or remove existing peerings during deployment.
- Centralized management simplifies connectivity and security admin rules.
- Security admin rules work similarly to network security groups (NSGs) and are enforced at the host virtual filtering platform.

**Definitions**

- **Mesh**: A connectivity topology where all virtual networks in a group can communicate directly with each other without peering, typically bounded by region unless global mesh is enabled.
- **Connectivity Group**: A logical grouping used by Azure Virtual Network Manager to enable communication between virtual networks without creating peering connections.
- **Hub and Spoke**: A network topology where spokes connect to a central hub via peering, with connected groups enabling spoke-to-spoke communication.
- **Global Mesh**: An option to enable mesh connectivity across multiple regions, removing the regional boundary.
- **Redeploy**: The process of applying changes to connectivity or security configurations to make them effective.
- **Security Admin Rules**: Centralized network security configurations similar to NSGs, enforced at the host level.

**Key Facts**

- Mesh does not create any peering connections; hub and spoke uses peering between spokes and hub.
- Mesh connectivity groups include all virtual networks in the group as any-to-any communication.
- Hub and spoke direct connectivity respects network group boundaries; mesh does not.
- Redeployment is necessary when changing topology, connectivity, or security admin rules.
- Adding new VNets to network groups is automatically detected and rolled out without redeployment.
- Deployments can be targeted to specific regions or all regions.
- Existing peerings can be optionally removed or retained during deployment.
- Multiple hubs and connectivity configurations can exist simultaneously and work additively.
- Network security groups are enforced on the host virtual filtering platform, same as security admin rules.

**Examples**

- Removing an existing hub and spoke deployment deletes peerings and connected groups, confirmed by checking spokes and hub routes.
- Creating a mesh connectivity group including multiple network groups (e.g., prod and dev) enables any-to-any communication across those groups.
- Deploying mesh to South Central region with selected network groups and enabling global mesh option.
- Changing topology or enabling global mesh requires redeployment; adding new VNets to network groups does not.
- Multiple hubs can be configured by creating separate connectivity configurations, each with its own hub.

**Key Takeaways 🎯**

- Mesh topology simplifies connectivity by enabling any-to-any communication without peering, but it removes network group boundaries.
- Hub and spoke topology maintains network group boundaries and uses peering for connectivity.
- Removing deployments cleans up peerings and connected groups, ensuring no residual connectivity remains.
- Redeployment is a critical step to apply changes in topology, connectivity, or security configurations.
- New VNets joining network groups are automatically included in connectivity without manual redeployment.
- Azure Virtual Network Manager supports additive connectivity configurations and flexible management of existing peerings.
- Centralized connectivity and security admin rules management enhances network security and operational efficiency.
- Understand the differences between mesh and hub and spoke topologies to choose the right connectivity model for your environment.

---

## Security admin configurations

**Timestamp**: 00:46:24 – 00:49:29

**Key Concepts**

- Security admin configurations provide centralized security rule enforcement at the virtual network (VNet) level.
- These configurations work similarly to network security groups (NSGs) but differ in scope and enforcement level.
- Security admin rules are deployed and enforced on the entire VNet, unlike NSGs which target subnets or individual NICs.
- Rules include typical firewall parameters: destination IP, ports, protocols, direction (inbound/outbound), and priority.
- New action option “always allow” exists, which overrides other rules and NSGs regardless of priority.

**Definitions**

- **Security admin configuration**: A set of security rules applied at the VNet level to control traffic, similar in concept to NSGs but enforced differently.
- **Network Security Group (NSG)**: A security rule set applied to subnets or NICs, enforced on the host’s virtual filtering platform.
- **Rule collection**: A grouping of security rules within a security admin configuration, targeting specific network groups.
- **Priority**: Numeric value (0-99) determining rule precedence; lower number means higher priority.
- **Actions**: Possible outcomes of a rule — allow, deny, or always allow traffic.

**Key Facts**

- Security admin rules are enforced at the VNet level, unlike NSGs which are enforced at subnet or NIC level.
- Rule priority ranges from 0 (highest) to 99 (lowest).
- Protocols supported include common ones plus ESP and AH for IPSec.
- Rule parameters can specify IP addresses or service tags.
- The “always allow” action is unique to security admin configurations and does not exist in NSGs.

**Examples**

- Creating a security admin configuration with a rule collection named “test one” or “allow rules” to permit traffic to domain controllers or update infrastructure.
- Deleting a deployment removes all associated connections, peers, and connectivity groups, demonstrating ease of management and testing.

**Key Takeaways 🎯**

- Security admin configurations centralize and simplify network security management by applying rules at the VNet level.
- They provide similar functionality to NSGs but operate at a different scope, enabling broader control.
- The priority system and rule parameters closely mirror NSGs, easing adoption.
- The new “always allow” action provides a powerful override capability not available in NSGs.
- The system is flexible and user-friendly, allowing easy creation, testing, and removal of configurations without residual impact.

---

## Types of action including Always Allow

**Timestamp**: 00:49:29 – 00:53:10

**Key Concepts**

- Security admin rules operate as a funnel, processed before NSGs (Network Security Groups).
- Actions available on rules include Allow, Deny, and Always Allow.
- The priority of rules is determined by their number: lower number means higher priority.
- Always Allow is a unique action that bypasses all lower priority security admin rules and NSGs.
- Deny stops traffic immediately and prevents it from reaching NSGs or lower rules.
- Allow lets traffic continue through the funnel to NSGs and lower priority rules.

**Definitions**

- **Always Allow**: A rule action that permits traffic to bypass all subsequent security admin rules and NSGs, ensuring the traffic is never blocked by those layers.
- **Security Admin Rules**: Rules configured at a higher level than NSGs, enforced first in the traffic filtering process.
- **NSG (Network Security Group)**: A set of security rules applied at subnet or NIC level, processed after security admin rules.

**Key Facts**

- Security admin rules are enforced at the virtual filtering platform, ensuring high efficiency with no added latency.
- Traffic hits security admin rules first, then NSGs.
- Deny action stops traffic immediately, preventing further processing.
- Always Allow ensures traffic cannot be blocked by any NSG or lower security admin rule.
- Azure firewall or guest OS firewalls can still block traffic even if Always Allow is set.

**Examples**

- Denying inbound traffic from the internet on port 2021 (unencrypted FTP) using a deny rule.
- Always allowing UDP outbound traffic from a VNet to specific IP addresses on port 88 (Kerberos traffic).

**Key Takeaways 🎯**

- Always Allow is a powerful action that overrides all subsequent filtering by NSGs and lower priority rules.
- Use Always Allow when certain traffic (e.g., Kerberos) must never be blocked by network security layers.
- Deny immediately stops traffic and prevents it from reaching other rules.
- Allow lets traffic continue through the security funnel and be subject to further rules.
- Understanding the order and priority of rules is critical for effective network security configuration.

---

## Demo and viewing rules applied

**Timestamp**: 00:53:10 – 00:59:30

**Key Concepts**

- Azure Virtual Network Manager (AVNM) security admin rules can enforce network traffic policies at the host level.
- Rules have scopes and priorities that determine which rules take precedence in case of conflicts.
- Higher scope AVNM instances override lower scope AVNM instances and NSGs (Network Security Groups).
- Rule propagation to hosts can take some time before becoming visible and effective.
- Only one security admin configuration per AVNM per region is allowed to avoid conflicts.
- Pricing is based on the number of subscriptions managed within the AVNM scope.

**Definitions**

- **Azure Virtual Network Manager (AVNM)**: A service that manages network security rules and policies across multiple subscriptions and virtual networks in Azure.
- **Security Admin Rules**: Rules defined within AVNM that can enforce allow or deny policies on network traffic, overriding lower-level controls.
- **Scope**: The hierarchical level (management group, subscription, etc.) at which an AVNM instance applies its rules.
- **Priority**: The order in which rules are applied; lower numbers indicate higher priority, with priority 0 being absolute.

**Key Facts**

- Example rule: Deny inbound unencrypted FTP (port 2021) from the internet.
- Example rule: Always allow UDP outbound traffic from VNet to specific IPs on port 88 (Kerberos).
- Priority 0 rules have absolute precedence.
- Rule propagation to hosts and visualization in the portal can take several minutes.
- Only one security admin configuration per AVNM per region is allowed to prevent conflicts.
- Pricing is per subscription managed by the AVNM instance.

**Examples**

- Created a rule collection with two rules:
  - Deny inbound FTP on port 2021 from the internet.
  - Always allow outbound UDP traffic on port 88 to specific IP addresses (Kerberos traffic).
- Demonstrated deploying the rule collection and viewing the rules applied on the VM’s inbound and outbound port rules.
- Showed that the higher scope AVNM rule (always allow) overrides any deny rules at lower scopes or NSGs.

**Key Takeaways 🎯**

- AVNM security admin rules provide powerful, centralized control over network traffic that cannot be overridden by lower-level firewalls or NSGs.
- Rule scope and priority are critical in determining which rules take effect when conflicts arise.
- Rule deployment and propagation require patience as changes may take time to appear and enforce.
- To avoid conflicts, only one security admin configuration per AVNM per region is supported.
- Understanding the hierarchy and priority of rules is essential for effective network security management in Azure.
- Pricing depends on the number of subscriptions managed by the AVNM instance, emphasizing the value of centralized management.

---

## Pricing

**Timestamp**: 00:59:30 – 01:01:27

**Key Concepts**

- Pricing is based on the number of subscriptions managed within the scope of an Azure Virtual Network Manager (AVNM).
- Costs are incurred per subscription per hour, per AVNM instance.
- Overlapping management of the same subscription by multiple AVNMs results in multiple charges.
- Managing subscriptions efficiently within AVNM scopes can help avoid unnecessary costs.

**Definitions**

- **Azure Virtual Network Manager (AVNM)**: A service that manages network configurations and security policies across multiple subscriptions and virtual networks.
- **Subscription Managed**: An Azure subscription that is under the control or management scope of an AVNM instance.

**Key Facts**

- Pricing is $0.10 per hour per subscription managed by an AVNM.
- If a subscription is managed by more than one AVNM, the cost is multiplied accordingly (e.g., managed by two AVNMs means paying twice for that subscription).
- Only one security admin configuration per AVM per region is allowed to avoid conflicts.
- Overlapping scopes or multiple AVNMs managing the same subscriptions can lead to increased costs.

**Examples**

- If one AVNM manages a subscription, you pay $0.10 per hour.
- If two AVNMs manage the same subscription(s), you pay $0.10 per hour per subscription per AVNM, effectively doubling the cost for those subscriptions.
- Scenario described where one AVNM manages all subscriptions for security admin purposes, and another AVNM manages a subset of subscriptions, resulting in paying for those subscriptions twice.

**Key Takeaways 🎯**

- Be mindful of how subscriptions are assigned to AVNM instances to avoid overlapping management and double billing.
- Limit the number of AVNMs managing the same subscriptions to control costs.
- The pricing model encourages efficient and consolidated management scopes.
- The value proposition includes quick deployment of security rules across VNets without complex peering or manual NSG updates.
- Understanding pricing helps in planning network management at scale while controlling expenses.

---

## Summary and close

**Timestamp**: 01:01:27 – unknown

**Key Concepts**

- Cost implications of managing multiple Azure Virtual Network Managers (AVNMs)
- Managing network connectivity and security at scale
- Simplifying network security rule deployment across multiple VNets
- Centralized management for network governance and administration

**Definitions**

- **AV&M (Azure Virtual Network Manager)**: A service used to manage network connectivity and security policies across multiple virtual networks.
- **NSG (Network Security Group)**: A set of security rules that allow or deny network traffic to resources in an Azure virtual network.

**Key Facts**

- Pricing is $0.10 per hour per subscription managed, charged per AV&M instance.
- Overlapping AVNMs managing the same subscriptions result in paying multiple times for those subscriptions.
- Managing security rules centrally can enable rapid response to threats (e.g., zero-day vulnerabilities) by quickly blocking or allowing traffic across all VNets.

**Examples**

- Instead of manually updating NSGs on each VNet, adding a rule in AV&M and deploying it once applies the change everywhere instantly.
- Use case: Quickly blocking certain traffic types across all VNets in response to a zero-day threat.

**Key Takeaways 🎯**

- Avoid creating too many AVNMs to prevent unnecessary costs due to overlapping subscription management.
- AV&M provides a scalable, centralized way to manage network connectivity and security policies.
- This approach simplifies governance and operational overhead for network admins and core governance teams.
- Enables rapid deployment of security rules across multiple virtual networks, improving security posture and response times.
