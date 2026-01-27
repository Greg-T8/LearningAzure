## Networking

### DNS

**Timestamp**: 09:13:36 – 09:30:07

**Key Concepts**  
- DNS (Domain Name System) resolves domain names to IP addresses.  
- Azure DNS is a hosting service for DNS domains using Microsoft Azure infrastructure.  
- Two types of Azure DNS zones: Public DNS (internet-facing) and Private DNS (internal-facing).  
- DNS Zone: container for all DNS records of a specific domain.  
- DNS Record: a rule that directs where to send a domain name; composed of name, type, and value.  
- Record Sets: groupings of DNS records; Azure DNS always uses record sets even if only one record exists.  
- Time To Live (TTL): duration other servers cache DNS records before querying again.  
- Azure Alias record type: special record that points directly to Azure resources, preventing dangling domains.  

**Definitions**  
- **Domain Name**: A service that translates and resolves a service name to its IP address.  
- **Azure DNS**: A Microsoft Azure service that hosts DNS domains and provides name resolution.  
- **DNS Zone**: A container holding all DNS records for a specific domain.  
- **DNS Record**: A rule with a name, type, and value that directs domain traffic.  
- **Record Set**: A collection of DNS records grouped together; Azure DNS creates record sets rather than individual records.  
- **TTL (Time To Live)**: The time period DNS records are cached by other servers before refreshing.  
- **Alias Record**: Azure-specific DNS record type that points directly to Azure resources (e.g., VMs, load balancers), automatically updating if the resource changes.  
- **Public DNS**: DNS zone accessible over the internet for managing internet-facing domains.  
- **Private DNS**: DNS zone used internally within Azure for custom domains instead of Azure provider domains.  

**Key Facts**  
- Azure DNS does **not** provide domain registration services; domains must be purchased elsewhere (e.g., GoDaddy, Namecheap) and then managed via Azure DNS.  
- Common DNS record types to know:  
  - **A**: Points domain to IPv4 address.  
  - **AAAA**: Points domain to IPv6 address.  
  - **CNAME**: Canonical name alias from one domain to another.  
  - **MX**: Mail exchange records for email routing.  
  - **NS**: Name server records for DNS delegation and redundancy.  
  - **PTR**: Pointer record for reverse DNS lookup.  
  - **SRV**: Service locator records (e.g., for Active Directory).  
  - **TXT**: Text records used for verification and documentation (e.g., domain ownership verification).  
  - **SOA**: Start of Authority record containing administrative info about the domain.  
- TTL should be set low for records that change frequently or require failover to reduce caching delays.  
- Wildcard records (e.g., `*`) can be used to catch all subdomains; Azure supports wildcard subdomain matching like `*.subdomain`.  
- The `@` symbol in DNS records is shorthand for the root (naked/apex) domain.  
- Azure Alias records work with A, AAAA, and CNAME types and should be used whenever possible to avoid manual updates when Azure resource IPs or hostnames change.  

**Examples**  
- Creating a public DNS zone named `wharf.com` in Azure DNS.  
- Setting an A record pointing `site.wharf.com` to a VM’s public IP address.  
- Using an alias record to point `site2.wharf.com` directly to the Azure VM resource, avoiding dangling IP issues if the VM’s IP changes.  
- Creating a CNAME record to alias `google.warf.com` to `google.com`.  
- Creating child DNS zones for subdomains like `app.wharf.com` or multi-tenant subdomains like `mytenant1.app.wharf.com`.  
- TXT record example: used by Gmail to verify domain ownership by adding a specific TXT value.  

**Key Takeaways 🎯**  
- Remember Azure DNS is for managing DNS records, **not** for purchasing domains.  
- Know the difference between public and private DNS zones in Azure.  
- Understand DNS zones, records, and record sets — Azure always uses record sets.  
- Be familiar with common DNS record types (A, AAAA, CNAME, MX, NS, PTR, SRV, TXT, SOA).  
- Use TTL wisely: low TTL for frequently changing records or failover scenarios; longer TTL reduces DNS query load.  
- Always prefer Azure Alias records when pointing to Azure resources to avoid stale or dangling DNS entries.  
- Know the meaning of special DNS record naming conventions: `@` for apex domain, `*` for wildcard subdomains.  
- Practical knowledge of creating DNS zones, records, and alias records in Azure is useful but exam focus is on concepts and record types.  

---

### Networking

**Timestamp**: 09:30:07 – 10:53:41

**Key Concepts**  
- Azure Virtual Network (VNet) as a logically isolated network segment for Azure resources  
- Azure DNS and record sets for domain management  
- Network Security Groups (NSGs) as virtual firewalls at subnet or NIC level  
- ExpressRoute for private, high-speed connections between on-premises and Azure  
- Virtual WAN for centralized network routing  
- Virtual Network Gateway for site-to-site VPN connections  
- Network Interfaces (NICs) as virtual network adapters attached to VMs  
- Load balancers and other networking components  
- VNet Peering: connecting multiple VNets to act as one network (regional and global)  
- Route Tables and User-Defined Routes to control traffic flow  
- Address Spaces and CIDR notation for IP allocation in VNets  
- Subnets as logical divisions of address spaces, with public/private distinction based on routing  
- Azure Private Link for secure, private connectivity within Azure network  
- Azure Firewall as a managed, stateful firewall service with high availability and scalability  
- Network Watcher for monitoring, diagnostics, and troubleshooting network resources  
- Network Performance Monitor (NPM) for hybrid network performance monitoring  
- NSG flow logs and packet capture for traffic analysis  

**Definitions**  
- **Virtual Network (VNet)**: A logically isolated section of the Azure network where resources are launched.  
- **Network Interface (NIC)**: A virtual network adapter attached to an Azure VM enabling network communication.  
- **Route Table**: A set of routes that define how traffic is directed within a network or subnet.  
- **User-Defined Route (UDR)**: Custom routes created to override Azure’s default system routes.  
- **Address Space**: The range of IP addresses allocated to a VNet, defined using CIDR notation.  
- **Subnet**: A logical subdivision of an address space within a VNet, used to isolate workloads.  
- **Network Security Group (NSG)**: A set of security rules filtering inbound and outbound traffic at subnet or NIC level.  
- **Azure Private Link**: A service that enables private connectivity to Azure services over a private IP in your VNet.  
- **ExpressRoute**: A private, dedicated connection between on-premises infrastructure and Azure datacenters, bypassing the public internet.  
- **Azure Firewall**: A fully stateful, managed firewall service protecting VNets with centralized policy and logging.  
- **Network Watcher**: Azure service providing tools for monitoring, diagnosing, and viewing network metrics and logs.  
- **Network Performance Monitor (NPM)**: A cloud-based solution to monitor network performance and detect issues like traffic blackholing and routing errors.  

**Key Facts**  
- Azure VNets can have multiple address spaces (unlike AWS VPCs which have one).  
- Each subnet requires a route table; Azure provides default system routes including internet access.  
- User-defined routes can override default routes, e.g., setting internet route hop to "None" to create private subnets.  
- There are four hop types for routes: Virtual Network Gateway, Virtual Network Internet, Virtual Appliance (e.g., firewall VM), and None.  
- Five IP addresses are reserved per subnet: network address, Azure default gateway, two for Azure DNS and VNet space, and broadcast address.  
- VNet peering types:  
  - Regional Peering: between VNets in the same Azure region  
  - Global Peering: between VNets in different Azure regions  
- Azure Firewall uses a static public IP for outbound traffic identification and integrates with Azure Monitor.  
- ExpressRoute Direct supports bandwidth from 50 Mbps up to 10 Gbps for hybrid scenarios requiring high throughput and low latency.  
- Network Watcher is disabled by default per region and must be enabled manually.  
- NSG security rules have properties: name, source/destination (IP, CIDR, service tag), port range, protocol (TCP/UDP/ICMP), action (allow/deny), and priority (100-4096).  

**Examples**  
- Creating a private subnet by overriding the default internet route with hop type "None" in a user-defined route table.  
- Attaching multiple NICs to an Azure VM for network communication.  
- Using Private Link endpoints with private IPs to connect securely to Azure services or third-party marketplace services.  
- Setting up Azure Firewall in its own subnet and routing subnet traffic through it using a user-defined route with hop type "Virtual Appliance" pointing to the firewall’s private IP.  
- Testing VNet peering connectivity using PowerShell’s `Test-NetConnection` cmdlet between VMs in peered VNets (regional and global).  
- Using Network Watcher tools like IP Flow Verify, NSG Diagnostic, Packet Capture, and NSG Flow Logs for network troubleshooting and monitoring.  

**Key Takeaways 🎯**  
- Understand the components and purpose of Azure networking: VNets, subnets, NICs, NSGs, route tables, and peering.  
- Know how to create and apply user-defined routes to control traffic flow, including blocking internet access for private subnets.  
- Be familiar with VNet peering types and benefits, and how to test connectivity between peered VNets.  
- Azure Firewall is a managed, scalable, stateful firewall that requires routing subnet traffic through it via route tables.  
- ExpressRoute provides private, high-speed connections bypassing the internet, with ExpressRoute Direct offering up to 10 Gbps bandwidth.  
- Azure Private Link enables private connectivity to Azure services using private IPs within your VNet.  
- Network Watcher is essential for monitoring and troubleshooting Azure network resources but must be enabled per region.  
- NSG rules are fundamental for filtering traffic; know their key properties and how to diagnose issues using Network Watcher tools.  
- Remember reserved IP addresses in subnets reduce the number of usable IPs by 5.  
- Azure allows multiple address spaces per VNet, unlike AWS VPCs.  
- For exams, focus on concepts of routing, peering, firewall setup, and monitoring tools rather than deep configuration steps.  

---

### NSG

**Timestamp**: 10:53:41 – 11:00:44

**Key Concepts**  
- Network Security Groups (NSGs) filter network traffic to and from Azure resources within a Virtual Network (VNet).  
- NSGs consist of multiple security rules that control inbound and outbound traffic.  
- Rules specify source, destination, port range, protocol, action (allow/deny), and priority.  
- NSGs are stateful, meaning return traffic is automatically allowed without explicit rules.  
- NSGs can be applied at the subnet level and/or the Network Interface Card (NIC) level.  
- When NSGs are applied at both subnet and NIC levels, rules are evaluated first at the subnet, then at the NIC. Both must allow traffic for it to pass.  

**Definitions**  
- **Network Security Group (NSG)**: A set of security rules that filter network traffic to and from Azure resources in a VNet.  
- **Security Rule**: A rule within an NSG that defines traffic filtering based on source, destination, port, protocol, action, and priority.  
- **Stateful**: NSGs track active connections (flow records), allowing return traffic automatically without needing explicit inbound/outbound rules for the response.  
- **Flow Record**: A record created for existing connections that helps NSGs maintain statefulness by tracking connection states.  

**Key Facts**  
- Each security rule has:  
  - Unique name  
  - Source and destination (IP address, CIDR block, service tag, application group)  
  - Port range (single port, range, or all ports with *)  
  - Protocol (TCP, UDP, ICMP)  
  - Action (Allow or Deny)  
  - Priority (number between 100 and 4096; lower numbers processed first)  
- Two types of rules: inbound (traffic entering NSG) and outbound (traffic leaving NSG).  
- Default NSG rules:  
  - Inbound: Allow traffic from any virtual network, allow Azure Load Balancer, deny all else.  
  - Outbound: Allow traffic to any virtual network and internet, deny all else.  
- Limits:  
  - Up to 5,000 NSGs per subscription.  
  - Up to 1,000 security rules per NSG.  
- You cannot create two rules with the same priority and direction.  
- NSG rules are processed in priority order, from lowest number to highest.  
- NSGs are stateful: specifying an outbound rule automatically allows the inbound response, and vice versa.  
- Removing a security rule does not immediately interrupt existing connections; flows are interrupted only after no traffic flows for a few minutes.  
- If no NSG is assigned to subnet or NIC, all traffic is allowed (not recommended).  
- When NSG is applied only to NIC, rules behave predictably based on allow/deny.  
- When NSGs are applied to both subnet and NIC, both must allow traffic for it to pass (e.g., port 80 must be open on both).  

**Examples**  
- Scenario: Virtual machine with NIC but no NSG assigned → all traffic allowed.  
- Scenario: NSG assigned to NIC only → traffic filtered according to NSG rules on NIC.  
- Scenario: NSG assigned to subnet and NIC → traffic must be allowed by both NSGs; if subnet blocks port 80 but NIC allows it, traffic is blocked.  

**Key Takeaways 🎯**  
- Understand the components of an NSG rule: name, source/destination, port range, protocol, action, priority.  
- Remember NSGs are stateful; you don’t need to create both inbound and outbound rules for response traffic.  
- Know default inbound and outbound rules created by Azure NSGs.  
- Priority numbers matter: lower numbers are processed first. No duplicate priority numbers allowed in same direction.  
- NSGs can be applied at subnet and NIC levels; both sets of rules are evaluated, and both must allow traffic.  
- Always have NSGs applied to at least subnet or NIC to avoid unrestricted traffic.  
- Be familiar with limits on NSGs per subscription and rules per NSG for exam context.  
- Review diagrams/slides on NSG application scenarios (subnet vs NIC) as they are important for exam understanding.

---

### Virtual WAN

**Timestamp**: 11:00:44 – 11:12:38

**Key Concepts**  
- Azure Virtual WAN is a consolidated networking service combining networking, security, and routing functionalities into a single operational interface.  
- It supports branch connectivity, site-to-site VPN, remote user VPN (point-to-site), intra-cloud connectivity, ExpressRoute, internet routing, and Azure Firewall encryption for private connectivity.  
- Virtual WAN is essentially Azure’s implementation of Software-Defined WAN (SD-WAN).  
- SD-WAN decouples CPU-intensive router tasks (management, operation, control plane) from physical devices and centralizes control virtually.  
- SD-WAN enables more efficient, cost-effective routing over the internet compared to traditional MPLS networks.  
- Points of Presence (POPs) are network edge entry points, typically ISP data centers, used to connect to networks.  
- A "hop" refers to moving from one POP/network to another during data transit.  
- MPLS (Multi-Protocol Label Switching) is a private network routing method using labels instead of IP addresses to forward packets efficiently.  
- MPLS is outsourced to service providers, uses specialized hardware (Label Switch Routers - LSRs), and offers guaranteed performance but is expensive and lacks inherent encryption.  
- SD-WAN can replace MPLS by routing over the internet with HTTPS security, offering cost savings and easier configuration at scale.  
- Azure Virtual WAN hubs are VNets with service endpoints at region edges that connect on-premises networks to Azure cloud resources via virtual devices.  

**Definitions**  
- **Azure Virtual WAN**: A unified networking service that integrates multiple networking, security, and routing features into a single interface, enabling efficient cloud and branch connectivity.  
- **Software-Defined WAN (SD-WAN)**: A WAN architecture that centralizes control of network traffic routing by decoupling management and control functions from physical routers, enabling optimized and secure internet-based connectivity.  
- **Point of Presence (POP)**: An entry point at the edge of a network, such as an ISP data center, where devices connect to the network.  
- **Hop**: The act of moving data packets from one POP or network to another during transmission.  
- **MPLS (Multi-Protocol Label Switching)**: A packet forwarding technique using labels to determine the shortest path through a private network, managed by service providers using specialized hardware (LSRs).  
- **Label Switch Router (LSR)**: A network device in MPLS that reads labels on packets to forward them along predetermined paths.  
- **Virtual Network Gateway**: A software VPN device deployed in Azure VNets that enables secure connectivity between Azure and on-premises or other networks.  

**Key Facts**  
- Azure Virtual WAN supports multiple connectivity types: branch, site-to-site VPN, point-to-site VPN, ExpressRoute, intra-cloud, internet routing, and Azure Firewall encryption.  
- MPLS is considered OSI Layer 2.5 because it inserts a label (shim) between Layer 2 and Layer 3 in packets.  
- MPLS offers traffic engineering and quality assurance but is costly and lacks encryption.  
- SD-WAN uses HTTPS for secure communication over the internet.  
- SD-WAN offers cost-effectiveness and simpler configuration compared to MPLS, especially at scale.  
- Azure has many POPs globally, enabling fast and efficient routing to Microsoft services like Office 365.  
- Virtual WAN hubs are VNets with service endpoints configured at region edges to optimize connectivity.  

**Examples**  
- Connecting an office to another branch or data center over the internet involves multiple POP hops through different ISPs (e.g., Bell, Rogers, Vodafone, AT&T, NTT).  
- MPLS example: Using a private network with Label Switch Routers to forward packets efficiently between office and branch.  
- Office 365 access example: Instead of routing through MPLS and partner data centers, SD-WAN routes traffic directly to the nearest Microsoft POP for faster and cheaper access.  

**Key Takeaways 🎯**  
- Understand that Azure Virtual WAN is a comprehensive SD-WAN solution integrating multiple networking features for cloud and branch connectivity.  
- Know the difference between MPLS and SD-WAN: MPLS is private, expensive, and hardware-dependent; SD-WAN is internet-based, cost-effective, and centrally managed.  
- Remember that POPs and hops are fundamental concepts in network routing and are critical to understanding WAN traffic flow.  
- SD-WAN improves performance and reduces costs by routing traffic over the internet using HTTPS and leveraging Azure’s global POPs.  
- Virtual WAN hubs (VNets with service endpoints) are key components for connecting on-premises networks to Azure efficiently.  
- For exam scenarios, be prepared to explain why SD-WAN is preferred over MPLS in modern cloud architectures.  
- Virtual Network Gateways are essential for VPN connectivity in Azure and involve deploying specialized VMs in a gateway subnet.

---

### VNGs

**Timestamp**: 11:12:38 – unknown

**Key Concepts**  
- Virtual Network Gateway (VNG) is the software VPN device for Azure Virtual Networks (VNets).  
- VNGs enable secure connections between Azure VNets and on-premises networks or individual devices.  
- VNG deployment involves creating a gateway subnet and deploying two or more specialized VMs running routing tables and gateway services.  
- Gateway types determine whether the gateway is a VPN gateway or an ExpressRoute gateway.  
- VPN gateways support multiple connection topologies: site-to-site, multi-site, point-to-site, and VNet-to-VNet.  
- VPN gateways use IPsec tunnels for secure connections over the internet.  
- ExpressRoute is an alternative to VPN gateways but requires more complex setup and uses edge partners instead of the public internet.

**Definitions**  
- **Virtual Network Gateway (VNG)**: The software VPN device deployed in Azure VNets that manages VPN connections by deploying specialized VMs in a gateway subnet.  
- **VPN Gateway**: A type of virtual network gateway that establishes secure IPsec tunnels over the internet to connect Azure VNets to on-premises networks or individual clients.  
- **ExpressRoute Gateway**: A gateway type used for private, dedicated connections between Azure and on-premises networks via edge partners, not over the public internet.  
- **Gateway Subnet**: A specific subnet within a VNet where the virtual network gateway VMs are deployed.

**Key Facts**  
- Deploying a VNG requires creating a gateway subnet in the VNet.  
- The VNG deployment includes two or more specialized VMs.  
- VPN gateways traverse the public internet using IPsec tunnels for encryption and security.  
- ExpressRoute connections do not traverse the internet but require more setup and use edge partners.  
- VPN gateway topologies include:  
  - Site-to-site (Azure to on-premises data center)  
  - Multi-site (Azure to multiple on-premises data centers)  
  - Point-to-site (Azure to individual client devices)  
  - VNet-to-VNet (connecting two Azure VNets across regions or subscriptions)

**Examples**  
- Site-to-site VPN: Connecting an Azure VNet to an on-premises data center via an IPsec tunnel.  
- Multi-site VPN: Connecting Azure to multiple on-premises sites with multiple tunnels.  
- Point-to-site VPN: Employees connecting securely from laptops worldwide to an Azure VNet.  
- VNet-to-VNet VPN: Connecting two VNets in different Azure regions or subscriptions.

**Key Takeaways 🎯**  
- Remember that a Virtual Network Gateway is essential for enabling VPN connections in Azure VNets.  
- Always create a gateway subnet before deploying a VNG.  
- Understand the difference between VPN gateways (internet-based, IPsec tunnels) and ExpressRoute gateways (private, dedicated connections).  
- Know the four main VPN gateway topologies and their use cases: site-to-site, multi-site, point-to-site, and VNet-to-VNet.  
- VPN gateways provide a cost-effective and simpler alternative to ExpressRoute for connecting Azure to on-premises or remote clients.  
- ExpressRoute may still require VPN gateways for certain configurations.  
- For exam scenarios, be prepared to identify appropriate gateway types and topologies based on connectivity requirements.