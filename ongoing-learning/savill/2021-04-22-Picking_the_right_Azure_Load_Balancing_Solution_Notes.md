# Picking the right Azure Load Balancing Solution - Exam Notes

**Video:** [https://www.youtube.com/watch?v=s1H2HpSJ-cg](https://www.youtube.com/watch?v=s1H2HpSJ-cg)  
**Published:** 2021-04-22  
**Duration:** 42:27  

*Generated on 2026-01-31 03:41*

---

## Table of Contents

- [Introduction](#introduction)
- [Why we have multiple resources](#why-we-have-multiple-resources)
- [Understanding the requirements](#understanding-the-requirements)
- [Traffic layers](#traffic-layers)
- [Understanding the type of traffic](#understanding-the-type-of-traffic)
- [Azure Load Balancer](#azure-load-balancer)
- [Azure App Gateway](#azure-app-gateway)
- [Global balancing](#global-balancing)
- [Azure Front Door](#azure-front-door)
- [Azure Global Load Balancer](#azure-global-load-balancer)
- [Azure Traffic Manager](#azure-traffic-manager)
- [Internal NVA global balancing](#internal-nva-global-balancing)
- [Summary of solutions](#summary-of-solutions)
- [Azure Portal Load balancing help me choose](#azure-portal-load-balancing-help-me-choose)
- [End](#end)

## Introduction

**Timestamp**: 00:00:00 – 00:00:30

**Key Concepts**

- Importance of setting up notifications for new content (e.g., hitting the bell icon)
- Creating a single resource (such as a website) to serve users
- Challenges related to relying on a single resource, particularly around resiliency

**Definitions**

- **Resiliency**: The ability of a system or resource to remain available and functional despite failures or disruptions.

**Key Facts**

- Single resources can face availability issues due to:
  - Planned maintenance or upgrades (app or OS)
  - Unplanned problems like app crashes, OS crashes, or hardware failures
- Geographic distribution of users may require spreading instances to improve availability

**Examples**

- Creating a website as a resource
- Potential problems like app or OS crashes, hardware failures, and maintenance impacting availability

**Key Takeaways 🎯**

- Simply having one resource is not enough due to potential downtime and failures
- Resiliency is critical to ensure continuous availability
- Consider geographic distribution and multiple instances to mitigate risks of unavailability

---

## Why we have multiple resources

**Timestamp**: 00:00:30 – 00:02:25

**Key Concepts**

- Resiliency issues with having only one resource
- Causes of resource unavailability (planned maintenance, app/OS crashes, hardware failure)
- Geographic distribution of users requiring multiple instances
- Use of multiple instances for scalability and resiliency
- Centralized endpoint/load balancer to abstract multiple backend instances from users
- Health probing to detect availability of backend instances
- Alternative approach: clients trying multiple instances via DNS entries (e.g., Active Directory)
- Importance of understanding application architecture when implementing load balancing (multiple tiers: database, middle tier, front end)

**Definitions**

- **Resiliency**: The ability of a system to continue operating properly in the event of failure of some of its components.
- **Load Balancer**: A solution that provides a single endpoint for users and distributes incoming requests to multiple backend instances based on availability and health.
- **Health Probing**: Mechanism used by load balancers to check if backend instances are available and healthy before routing traffic to them.

**Key Facts**

- Single resource setups face problems like downtime due to maintenance or unexpected failures.
- Multiple instances allow dynamic scaling based on load.
- Load balancers provide a central endpoint to simplify user access.
- Some systems (e.g., Active Directory) rely on clients trying multiple DNS entries rather than a load balancer.
- Applications often have multiple tiers (database, middle tier, front end) which may require different load balancing strategies.

**Examples**

- Users geographically distributed, requiring instances spread around different locations.
- Active Directory clients use DNS entries with multiple results and try instances sequentially if one fails.

**Key Takeaways 🎯**

- Having multiple resources improves system resiliency and scalability.
- A load balancer simplifies client interaction by providing a single endpoint and managing backend availability.
- Understanding the application’s architecture is critical before implementing load balancing solutions.
- Not all systems use load balancers; some rely on client-side logic to handle multiple instances.

---

## Understanding the requirements

**Timestamp**: 00:02:25 – 00:05:20

**Key Concepts**

- Importance of understanding the application architecture before implementing load balancing.
- Multi-tier application structure: database tier, middle tier, front end.
- Different tiers may require different load balancing approaches.
- Consideration of network scope: private/internal vs. public/internet-facing.
- Geographical distribution of components and its impact on load balancing.
- Layer 4 vs. Layer 7 load balancing based on OSI model relevance.
- Layer 7 focuses on application-level protocols like HTTP, HTTPS, HTTP/2.

**Definitions**

- **Load Balancer**: A solution that provides a central endpoint to distribute client requests across multiple backend instances, often with health probing to detect availability.
- **Layer 4 Load Balancing**: Load balancing based on transport layer information (e.g., TCP/UDP).
- **Layer 7 Load Balancing**: Load balancing based on application layer protocols (e.g., HTTP, HTTPS).

**Key Facts**

- Applications often have multiple tiers: database (active/passive), middle tier, front end.
- Databases may have different listeners or addresses for active/passive roles.
- Load balancing needs to consider whether traffic is internal (private network) or external (internet).
- Multi-region deployments introduce complexity with asynchronous replication and read/write distribution.
- HTTP-based traffic includes HTTP 1.1, HTTPS, and HTTP/2 protocols.

**Examples**

- Active Directory DNS entries provide multiple IPs and clients try them sequentially, but this is generally not preferred for most applications.
- Database tier with active and passive nodes.
- Front ends communicating with middle tiers via load balancers.
- Multi-region setup with asynchronous replication and read/write separation.

**Key Takeaways 🎯**

- Thoroughly understand your application’s architecture and communication patterns before choosing a load balancing solution.
- Identify the tiers involved and their roles (active/passive, front end, middle tier).
- Determine the network context (private vs. public) and geographic distribution of components.
- Recognize the type of traffic (Layer 4 vs. Layer 7) to select appropriate load balancing technology.
- Consider protocol specifics, especially for application-layer load balancing (HTTP, HTTPS, HTTP/2).

---

## Traffic layers

**Timestamp**: 00:05:20 – 00:07:15

**Key Concepts**

- Understanding the type of traffic is crucial for choosing the right load balancing solution.
- Load balancing decisions often revolve around OSI model layers 4 (transport) and 7 (application).
- Layer 7 traffic typically involves HTTP-based protocols (HTTP, HTTPS, HTTP/2).
- Layer 4 traffic involves transport protocols such as TCP and UDP.
- Azure load balancers support TCP and UDP but not other transport protocols like SCTP.
- Azure virtual networks operate primarily at layer 3 (network layer) with IP addressing (IPv4 or IPv6).
- Load balancing solutions differ based on whether traffic is intra-region or inter-region.

**Definitions**

- **Layer 7 (Application Layer)**: The top layer in the OSI model dealing with application protocols, e.g., HTTP, HTTPS, HTTP/2.
- **Layer 4 (Transport Layer)**: The OSI layer responsible for transport protocols like TCP and UDP.
- **Layer 3 (Network Layer)**: The OSI layer handling IP addressing and routing (IPv4 or IPv6).
- **TCP (Transmission Control Protocol)**: A connection-oriented transport protocol.
- **UDP (User Datagram Protocol)**: A connectionless transport protocol.
- **SCTP (Stream Control Transmission Protocol)**: Another transport protocol not supported by Azure load balancers.

**Key Facts**

- Load balancers typically focus on layer 4 or layer 7 traffic.
- Azure load balancers support TCP and UDP traffic but not SCTP.
- Azure virtual networks provide IP space at layer 3.
- HTTP traffic can be HTTP 1.1, HTTPS, or HTTP/2.
- Load balancing solutions differ for intra-region (within one region) and inter-region (across multiple regions) traffic.

**Examples**

- HTTP-based traffic (HTTP, HTTPS, HTTP/2) is handled at layer 7.
- Non-HTTP traffic using TCP or UDP is handled at layer 4.
- SCTP is mentioned as a transport protocol that exists but is not supported by Azure load balancers.

**Key Takeaways 🎯**

- Identify whether your application traffic is HTTP-based (layer 7) or TCP/UDP-based (layer 4) to select the appropriate load balancing solution.
- Azure load balancers do not support all transport protocols; focus on TCP and UDP.
- Understand whether your traffic is intra-region or inter-region to choose the correct balancing approach.
- The OSI model layers 4 and 7 are the primary focus when considering load balancing in Azure environments.

---

## Understanding the type of traffic

**Timestamp**: 00:07:15 – 00:08:50

**Key Concepts**

- Differentiating traffic types based on protocol layers (Layer 4 vs Layer 7)
- Importance of understanding whether traffic is HTTP (Layer 7) or other TCP/UDP (Layer 4)
- Consideration of traffic scope: intra-region vs inter-region
- Azure native solutions for load balancing and traffic management within a region

**Definitions**

- **Layer 4 Solution**: Network traffic management based on transport layer protocols such as TCP and UDP.
- **Layer 7 Solution**: Application layer traffic management, typically HTTP or HTTPS traffic.
- **Intra-region**: Traffic and solutions that operate within a single Azure region.
- **Inter-region**: Traffic and solutions that operate across multiple Azure regions.
- **Azure Load Balancer**: A Layer 4 load balancing service in Azure that supports TCP and UDP traffic.
- **Azure Application Gateway**: A Layer 7 load balancing service in Azure, typically used for HTTP traffic.
- **Network Virtual Appliances (NVAs)**: Pre-configured virtual machines that provide network functions, often used historically with Azure Load Balancer for resilience and scaling.
- **Equal Cost Multi-Pathing (ECMP)**: A routing strategy that allows multiple paths for traffic, used with Azure Route Server to update route tables without needing a load balancer.

**Key Facts**

- Azure virtual networks operate primarily at Layer 3 (IP layer).
- Traffic types to consider: HTTP (Layer 7) vs TCP/UDP (Layer 4).
- Different solutions apply depending on whether traffic is within a single region or across multiple regions.
- Azure Load Balancer is a Layer 4 solution supporting both TCP and UDP.
- Azure Application Gateway is a Layer 7 solution focused on HTTP traffic.
- NVAs historically required Azure Load Balancer for resilience and scaling.
- Azure Route Server with ECMP can potentially replace the need for a load balancer in some scenarios.

**Examples**

- Using Azure Load Balancer for TCP/UDP traffic within a region.
- Considering Azure Application Gateway for HTTP traffic.
- NVAs combined with Azure Load Balancer for scaling and resilience.
- Azure Route Server enabling ECMP to update route tables without a load balancer.

**Key Takeaways 🎯**

- Identify the type of traffic (HTTP vs TCP/UDP) to choose the appropriate Azure solution (Layer 7 vs Layer 4).
- Understand whether traffic is intra-region or inter-region to select suitable load balancing strategies.
- Azure Load Balancer is the primary Layer 4 solution supporting TCP and UDP.
- Azure Application Gateway is suited for Layer 7 HTTP traffic.
- Be aware of alternative solutions like NVAs and Azure Route Server with ECMP, but focus primarily on Azure native load balancing services.

---

## Azure Load Balancer

**Timestamp**: 00:08:50 – 00:17:05

**Key Concepts**

- Azure Load Balancer is a Layer 4 load balancing solution supporting TCP and UDP protocols.
- It comes in two SKUs: Basic (free) and Standard (paid).
- Load balancer can be deployed as zonal (specific availability zone) or zone redundant (spanning multiple zones).
- Front-end IP can be either private (internal) or public, but not both simultaneously.
- Back-end pools can consist of VM NICs or IP addresses (including containers).
- Traffic distribution uses hashing based on five tuples (source IP, destination IP, protocol, source port, destination port).
- Health probes monitor backend availability and only route traffic to healthy instances.
- Load balancer handles outbound traffic for backend resources.
- Standard SKU supports multiple front-end configurations and multiple backend pools.

**Definitions**

- **Layer 4 Load Balancer**: A load balancer operating at the transport layer, understanding TCP and UDP protocols but not higher-level protocols like HTTP.
- **Basic SKU**: Free Azure Load Balancer with limited features, supports up to 300 backend instances in a single availability set or VM scale set, no SLA, no outbound rules.
- **Standard SKU**: Paid Azure Load Balancer with enhanced features including zonal or zone redundant deployment, support for multiple backend types, SLA, and outbound rules.
- **Zonal Deployment**: Load balancer deployed to a specific availability zone within an Azure region.
- **Zone Redundant Deployment**: Load balancer spans multiple availability zones for higher availability.
- **Five Tuple Hashing**: Traffic distribution method using source IP, destination IP, protocol, source port, and destination port to consistently route traffic to the same backend instance.

**Key Facts**

- Basic SKU supports up to 300 backend instances.
- Basic SKU requires all backend VMs to be in a single availability set or VM scale set.
- Basic SKU is open by default with no outbound rules and no SLA.
- Standard SKU supports zonal or zone redundant deployment.
- Azure regions consist of multiple physical facilities called availability zones.
- Standard SKU supports backend pools made of VM NICs or IP addresses (including containers).
- Load balancer can only have either a private or a public front-end IP, not both.
- Traffic hashing defaults to 5-tuple but can be configured to 3-tuple or 2-tuple for different session affinity needs.
- Load balancer and backend resources must reside in the same virtual network and region.
- Health probes ensure only healthy backend instances receive traffic.
- Outbound traffic from backend instances uses the load balancer’s IP.
- Standard SKU supports multiple front-end IP configurations and multiple backend pools.

**Examples**

- Using VM NICs as backend pool members.
- Using IP addresses for backend pools to include containers which do not have NICs but have IPs.
- Deploying load balancer zonally to a specific availability zone or zone redundantly across zones 1, 2, and 3.
- Choosing internal load balancer for front-end communication within a VNet (e.g., front-end to middle-tier communication).
- Choosing public load balancer for front-end communication exposed to the Internet.

**Key Takeaways 🎯**

- Azure Load Balancer is a robust Layer 4 solution for TCP/UDP traffic distribution.
- Choose Basic SKU for simple, cost-free scenarios with limited scale and features.
- Choose Standard SKU for production workloads needing high availability, zone redundancy, and advanced features.
- Decide between private (internal) or public front-end IP based on workload requirements; cannot mix both on the same load balancer.
- Backend pools can be flexible, supporting both VM NICs and IP addresses (including containers).
- Traffic distribution relies on hashing five tuples to maintain session affinity.
- Health probes are critical to ensure traffic is only sent to healthy backend instances.
- Load balancer also manages outbound traffic for backend resources, which requires consideration especially for internal load balancers.
- For HTTP/HTTPS workloads requiring Layer 7 features (like path-based routing, SSL offload), Azure App Gateway is the preferred solution instead of Azure Load Balancer.

---

## Azure App Gateway

**Timestamp**: 00:17:05 – 00:23:00

**Key Concepts**

- Azure App Gateway is a Layer 7 load balancer focused on HTTP, HTTPS, and HTTP/2 traffic.
- Supports advanced routing features such as path-based routing, URL rewrites, and HTTP to HTTPS redirection.
- Offers SSL termination (decrypting incoming SSL traffic) and can re-encrypt traffic for end-to-end encryption.
- Can integrate with a Web Application Firewall (WAF) to protect against common web attacks.
- Supports multiple SKUs (Basic, Standard, Standard V2) with varying features and pricing.
- Standard V2 SKU adds features like autoscaling and zone-redundant deployments.
- Backend pools can include virtual machines, VM scale sets, app services, IP addresses, FQDNs, on-premises endpoints via VPN or ExpressRoute, and AKS pods (via ingress controller).
- Azure App Gateway is region-specific and does not support private-only frontends.
- Typically used for public-facing Layer 7 traffic requiring advanced HTTP features.
- Azure Load Balancer is preferred for non-HTTP or internal traffic without the need for Layer 7 features.
- Azure DDoS protection can be layered on top for public endpoints.

**Definitions**

- **Azure App Gateway**: A Layer 7 (application layer) load balancer in Azure designed to manage HTTP/HTTPS traffic with advanced routing, SSL termination, and security features.
- **Web Application Firewall (WAF)**: A security feature integrated with App Gateway that uses OWASP core rule sets to detect and block web attacks like SQL injection and cross-site scripting.
- **SKU (Stock Keeping Unit)**: Different versions of Azure App Gateway (Basic, Standard, Standard V2) that determine available features and pricing.
- **Backend Pool**: The set of resources (VMs, app services, IPs, etc.) that App Gateway routes traffic to.
- **SSL Termination**: The process where the gateway decrypts incoming SSL traffic to inspect or modify it before forwarding it.
- **Zone Redundant Deployment**: Deployment across multiple availability zones within a region for higher availability.

**Key Facts**

- Standard V2 SKU supports autoscaling and zone-redundant deployments.
- App Gateway supports HTTP, HTTPS, and HTTP/2 protocols.
- Backend pools can include on-premises resources connected via VPN or ExpressRoute.
- App Gateway cannot be deployed as private-only; it must have a public frontend or public + private.
- Traffic distribution within App Gateway uses round-robin.
- Works within a single Azure region.
- Supports integration with AKS pods through an ingress controller.

**Examples**

- Routing traffic to virtual machines, VM scale sets, app services, IP addresses, or fully qualified domain names.
- Using SSL termination to inspect incoming HTTPS traffic and then re-encrypt it for backend communication.
- Protecting web applications from SQL injection and cross-site scripting attacks using WAF.
- Deploying App Gateway in a zone-redundant manner for higher availability.

**Key Takeaways 🎯**

- Use Azure App Gateway when you need advanced Layer 7 HTTP/HTTPS routing features such as path-based routing, URL rewrites, and SSL termination.
- The Web Application Firewall is a critical feature for protecting web applications from common vulnerabilities.
- Standard V2 SKU is recommended for production workloads due to autoscaling and zone redundancy.
- App Gateway is region-bound and cannot be deployed as private-only.
- For internal or non-HTTP workloads, Azure Load Balancer may be more appropriate.
- Always consider layering Azure DDoS protection for public-facing endpoints.
- App Gateway supports a wide variety of backend targets, including on-premises and Kubernetes pods, making it flexible for hybrid and containerized environments.

---

## Global balancing

**Timestamp**: 00:23:00 – 00:23:15

**Key Concepts**

- Global load balancing across multiple Azure regions
- Layer 7 (application layer) load balancing for web-based services
- Using Azure Front Door for global traffic management

**Definitions**

- **Layer 7**: The application layer in the OSI model, responsible for handling web-based traffic such as HTTP/HTTPS.
- **Azure Front Door**: A global, layer 7 load balancing solution provided by Azure that routes web traffic across multiple regions.

**Key Facts**

- Azure Front Door operates at layer 7 to balance traffic globally.
- It leverages Microsoft’s extensive global backbone network connecting multiple Azure regions.

**Examples**

- Balancing multiple web services deployed in different Azure regions using Azure Front Door.

**Key Takeaways 🎯**

- For global balancing of web-based services, layer 7 solutions like Azure Front Door are used.
- Azure Front Door enables efficient routing of HTTP/S traffic across regions using Microsoft’s global network.
- There are multiple solutions for global balancing, but Azure Front Door is a primary option at the application layer.

---

## Azure Front Door

**Timestamp**: 00:23:15 – 00:28:00

**Key Concepts**

- Azure Front Door operates at Layer 7 (HTTP/HTTPS/HTTP2) for global load balancing.
- Utilizes Microsoft's global backbone network and edge locations (points of presence).
- Provides an anycast IP address available at multiple edge locations worldwide.
- Implements split TCP connections to optimize performance and reduce latency.
- Supports features like caching, SSL/TLS offload, web application firewall (WAF), URL rewrite/redirect, and cookie-based affinity.
- Backends can be Azure services or public-facing on-premises services.
- Azure Front Door has evolved into V2 with Standard and Premium tiers combining CDN, Front Door, and WAF capabilities.

**Definitions**

- **Azure Front Door**: A Layer 7 global load balancing solution that routes HTTP/HTTPS traffic via Microsoft's global network and edge locations to optimize performance, security, and availability.
- **Anycast IP**: A single IP address advertised from multiple locations (edge points of presence), allowing users to connect to the nearest location.
- **Split TCP**: A technique where the TCP connection is established between the client and the nearest edge location, and separately between the edge and backend, improving speed and reducing latency.
- **Web Application Firewall (WAF)**: A security feature that protects web applications by filtering and monitoring HTTP traffic.

**Key Facts**

- Azure Front Door uses Microsoft’s global backbone and edge points of presence (same as Microsoft CDN).
- The anycast IP is available at all edge locations, enabling users to connect to the closest point.
- Split TCP allows fast TCP and TLS/SSL handshake at the edge location.
- Supports HTTP, HTTPS, and HTTP/2 protocols.
- Backends can be Azure services or public-facing on-premises services.
- Azure Front Door V2 offers Standard and Premium tiers:
  - Standard combines CDN and Front Door for static and dynamic content.
  - Premium adds advanced features like WAF and enhanced security reporting.
- Features include caching, SSL offload, URL rewrite/redirect, cookie-based affinity.
- Azure Front Door is optimized for HTTP workloads only; non-HTTP workloads require other solutions like Azure Global Load Balancer (Layer 4).

**Examples**

- Backend services can be app gateways or load balancers deployed in Azure regions.
- On-premises public-facing services can also be targeted by Azure Front Door.
- The anycast IP allows a user to connect to the nearest edge location for faster response.

**Key Takeaways 🎯**

- Azure Front Door is a powerful Layer 7 global load balancer optimized for HTTP/HTTPS traffic.
- It leverages Microsoft’s global network and edge locations to reduce latency and improve performance.
- Split TCP and anycast IP are key technologies enabling fast and reliable connections.
- Supports advanced features like WAF, SSL offload, URL manipulation, and cookie affinity.
- Suitable for both Azure-hosted and public-facing on-premises backend services.
- The V2 Standard and Premium tiers integrate CDN, Front Door, and WAF capabilities.
- For non-HTTP workloads, consider Azure Global Load Balancer (Layer 4) instead.

---

## Azure Global Load Balancer

**Timestamp**: 00:28:00 – 00:33:30

**Key Concepts**

- Azure Global Load Balancer is a Layer 4 load balancing solution focusing on TCP and UDP traffic.
- It operates on a global scale by leveraging Azure’s global network and multiple regions.
- The backend of the global load balancer consists of regional standard Azure Load Balancers with public endpoints.
- It uses a global standard public IP address that is anycast across participating Azure regions.
- Traffic is routed to the closest regional load balancer based on user location.
- The global public IP is owned by the user’s subscription, allowing client IP preservation.
- Both Azure Front Door and Azure Global Load Balancer are public-facing solutions; internal/private scenarios are not supported.
- Azure Traffic Manager is mentioned as a DNS-based routing alternative but is not part of the core global load balancer discussion.

**Definitions**

- **Azure Global Load Balancer**: A global Layer 4 load balancing service that routes TCP/UDP traffic to regional standard load balancers using a global anycast public IP.
- **Standard Load Balancer (Regional)**: A regional Azure load balancer with a public endpoint that serves as the backend for the global load balancer.
- **Anycast IP**: A single IP address advertised from multiple locations, allowing traffic to be routed to the nearest endpoint.

**Key Facts**

- The global load balancer requires regional standard load balancers with public IPs as backends.
- The global public IP must reside in a specific home region but continues to function if that region is unavailable.
- Only certain Azure regions currently support creating global load balancers and global public IPs.
- Traffic passing through the global load balancer preserves the original client IP, which is visible to backend services.
- The global load balancer is designed for public-facing workloads only.
- Azure Traffic Manager is a DNS-based routing solution currently in preview and is a different approach from the global load balancer.

**Examples**

- A setup with two regional standard load balancers, each with public endpoints in different regions.
- Accessing the global public IP routes the user to the closest regional load balancer (e.g., South Central US region).
- The global load balancer frontend is a global standard public IP that anycasts across multiple regions.

**Key Takeaways 🎯**

- Azure Global Load Balancer is ideal for global TCP/UDP traffic distribution at Layer 4.
- It relies on regional standard load balancers as backend pools.
- The anycast global public IP ensures low latency by routing users to the nearest region.
- Client IP preservation is a significant advantage over some other global routing solutions.
- The service is currently limited to specific Azure regions and public-facing workloads.
- For HTTP/HTTPS workloads, Azure Front Door is preferred; for DNS-based routing, Azure Traffic Manager is an alternative.
- Understanding the distinction between Layer 4 (Global Load Balancer) and Layer 7 (Front Door) is crucial for choosing the right service.

---

## Azure Traffic Manager

**Timestamp**: 00:33:30 – 00:37:45

**Key Concepts**

- Azure Traffic Manager is a DNS-based traffic routing solution.
- It resolves a DNS name to different endpoints based on routing criteria.
- It supports routing traffic across multiple Azure regions or even to on-premises public endpoints.
- Traffic Manager requires public-facing endpoints (public IPs or public DNS names).
- Uses DNS CNAME alias records to integrate with custom domain names.
- Routing methods include performance-based (latency), weighted, priority, geographic, and subnet-based routing.
- Endpoints can be Azure endpoints, external endpoints, or nested Traffic Manager profiles.
- Traffic Manager is currently in preview (at the time of the transcript).
- DNS record TTL affects failover speed; clients may continue to use a failed endpoint until TTL expires.
- No native Azure solution exists for internal cross-region load balancing; third-party NVAs are needed for that.

**Definitions**

- **Azure Traffic Manager**: A DNS-based traffic load balancer that directs client requests to the most appropriate service endpoint based on configured routing methods.
- **CNAME Record (Alias)**: A DNS record that maps an alias name (e.g., www.saviletech.net) to another DNS name (e.g., saviletm.trafficmanager.net), enabling Traffic Manager integration with custom domains.
- **TTL (Time To Live)**: The duration DNS records are cached by clients or DNS servers before a new lookup is performed.

**Key Facts**

- Traffic Manager instance names follow the pattern: `<name>.trafficmanager.net`.
- Traffic Manager only works with public-facing endpoints.
- DNS TTL impacts how quickly traffic switches after an endpoint failure; shorter TTLs reduce failover delay but increase DNS query load.
- Example Traffic Manager profile name used: Saviletm.trafficmanager.net.
- Alias example: www.tm.saviletech.net as a CNAME to the Traffic Manager DNS name.
- Routing method example used: Performance (based on DNS latency).
- Endpoints in the example were public Azure load balancers in different regions.

**Examples**

- Created a Traffic Manager profile named Saviletm.trafficmanager.net pointing to multiple backends.
- Created a DNS alias www.tm.saviletech.net as a CNAME pointing to Saviletm.trafficmanager.net.
- DNS lookup chain: www.tm.saviletech.net → Saviletm.trafficmanager.net → public endpoint (e.g., Azure load balancer in South Central region).
- Used performance routing to direct users to the closest endpoint based on DNS latency.

**Key Takeaways 🎯**

- Azure Traffic Manager provides global DNS-based traffic distribution for public endpoints.
- It requires setting up a Traffic Manager profile and using DNS CNAME records to integrate with custom domains.
- DNS TTL settings are critical for balancing failover responsiveness and DNS query volume.
- Traffic Manager supports multiple routing methods for flexible traffic control.
- It cannot be used for internal/private cross-region load balancing; third-party NVAs are needed for internal scenarios.
- Understanding the DNS resolution chain is important to troubleshoot and configure Traffic Manager effectively.

---

## Internal NVA global balancing

**Timestamp**: 00:37:45 – 00:38:00

**Key Concepts**

- Internal global load balancing between Azure regions is not natively supported by Azure.
- Third-party Network Virtual Appliances (NVAs) can provide internal global balancing across regions.
- Azure’s native global load balancing solutions are primarily designed for public endpoints.

**Definitions**

- **Internal NVA global balancing**: The process of distributing internal network traffic across multiple Azure regions using third-party NVAs, since Azure does not offer a native solution for this scenario.

**Key Facts**

- No native Azure solution exists for internal load balancing across different Azure regions.
- Existing Azure global load balancing solutions work only with public endpoints.
- Third-party NVAs are required for internal cross-region load balancing.

**Examples**

- None mentioned specifically for internal NVA global balancing.

**Key Takeaways 🎯**

- When needing internal load balancing across Azure regions, rely on third-party NVAs.
- Azure’s built-in global load balancing features do not support internal endpoints across regions.
- Plan accordingly when designing multi-region internal network architectures in Azure.

---

## Summary of solutions

**Timestamp**: 00:38:00 – 00:38:39

**Key Concepts**

- Load balancing solutions vary depending on scope: within a region vs. between regions.
- Different Azure services are suited for different protocols (HTTP vs. non-HTTP).
- Native Azure solutions currently do not support internal load balancing across regions.
- Third-party NVAs (Network Virtual Appliances) can provide internal cross-region balancing.
- Azure offers multiple load balancing options with different features and capabilities.

**Definitions**

- **Azure Load Balancer**: A service that provides load balancing within a region, available in public or private modes.
- **Azure Application Gateway**: An HTTP-based load balancer that supports advanced features like offloads and URL rewrites.
- **Azure Front Door**: A global HTTP load balancing service used for cross-region traffic.
- **Azure Global Load Balancer**: A preview service for non-HTTP cross-region load balancing (not yet generally available).

**Key Facts**

- All global load balancing solutions mentioned are based on public endpoints.
- No native Azure solution exists today for internal load balancing between different Azure regions.
- For HTTP traffic between regions, Azure Front Door is the recommended solution.
- For non-HTTP traffic between regions, Azure Global Load Balancer (in preview) or DNS-based solutions may be used.
- Within a region, Azure Load Balancer (public or private) or Application Gateway (HTTP-based) can be used.

**Examples**

- Using Azure Load Balancer for regional load balancing (public or private).
- Using Azure Application Gateway for HTTP traffic within a region, leveraging HTTP-specific features.
- Using Azure Front Door for HTTP traffic load balancing between regions.
- Considering third-party NVAs for internal cross-region load balancing.

**Key Takeaways 🎯**

- Choose load balancing solutions based on traffic type (HTTP vs. non-HTTP) and scope (regional vs. global).
- Native Azure solutions for internal cross-region load balancing do not currently exist; third-party NVAs are an alternative.
- Azure Application Gateway adds advanced HTTP features beyond basic load balancing.
- Azure Front Door is the primary choice for global HTTP load balancing.
- Azure Global Load Balancer is in preview and may become a native option for non-HTTP global load balancing in the future.

---

## Azure Portal Load balancing help me choose

**Timestamp**: 00:38:39 – 00:41:32

**Key Concepts**

- Azure Portal includes a "Load balancing help me choose" tool to assist in selecting the appropriate load balancing solution.
- The tool provides a service comparison among Azure load balancing options (App Gateway, Front Door, Load Balancer, Traffic Manager).
- Load balancing solutions differ by protocol support, scope (regional vs global), routing methods, and security features.
- The tool guides users through a question-based wizard to narrow down the best load balancing option based on application needs.
- Multi-region and public-facing applications often require layering of load balancing solutions (regional + global).

**Definitions**

- **App Gateway**: An Azure load balancing service supporting HTTP, HTTPS, HTTP2 with features like connection draining, session affinity, and Web Application Firewall (WAF).
- **Front Door**: A global, HTTP/HTTPS load balancing service with performance acceleration features such as split TCP and caching, also supports WAF.
- **Load Balancer**: Supports TCP and UDP protocols, can be private or public, regional scope, supports network security groups.
- **Traffic Manager**: A DNS-based global load balancing solution without direct security features, used for routing traffic across regions.
- **Connection Draining**: A feature allowing graceful removal of backend instances from traffic to perform maintenance without dropping active sessions.
- **SSL Offload**: The process of terminating SSL/TLS connections at the load balancer to reduce backend server load.

**Key Facts**

- The "Load balancing help me choose" tool currently does not include Azure Global Load Balancer (still in preview).
- App Gateway and Front Door support HTTP, HTTPS, HTTP2 protocols.
- Load Balancer supports TCP and UDP protocols and can be used for private load balancing.
- Front Door and Traffic Manager provide global load balancing; Load Balancer is regional (Azure only).
- WAF is available on Front Door and App Gateway; Network Security Groups apply to Load Balancer.
- Traffic Manager does not provide security features as it is DNS-based.
- The tool filters options based on answers such as protocol type, public facing, multi-region deployment, performance acceleration needs, and SSL offload.

**Examples**

- Using the tool, if the application uses HTTP/HTTPS, is public facing, deployed in multiple regions, and requires performance acceleration and SSL offload, the recommended solutions are Front Door and App Gateway.
- If SSL offload is not required, Traffic Manager might be suggested instead.
- For internal, RESTful middle-tier balancing, an internal Azure Load Balancer may be preferred over App Gateway.

**Key Takeaways 🎯**

- The Azure Portal’s "Load balancing help me choose" tool simplifies the complex decision-making process by comparing features and guiding through scenario-based questions.
- Understanding your application’s protocol, deployment scope (regional vs global), and security/performance needs is critical to selecting the right load balancing solution.
- Multi-region public-facing applications often require layering load balancers: one for intra-region traffic and another for global traffic distribution.
- Features like connection draining, session affinity, and WAF support vary across load balancing options and should influence your choice.
- The tool is continuously improving and will include more options like Azure Global Load Balancer once out of preview.

---

## End

**Timestamp**: 00:41:32 – unknown

**Key Concepts**

- Using guided question-based tools to determine the best solution for application architecture.
- Importance of understanding your application’s structure and requirements.
- Differentiating between internal and public-facing application load balancing solutions.
- Layering load balancing solutions for multi-region deployments.

**Definitions**

- **App Gateway**: An Azure service typically used for public-facing applications to manage traffic.
- **Internal Azure Load Balancer**: A load balancer used within a private/internal network, often for internal applications or tiers.

**Key Facts**

- Multi-region applications often require layering load balancing solutions: one within the region and another for global balancing.
- For internal applications, especially RESTful middle tiers, an internal load balancer may be preferred over App Gateway.

**Examples**

- For an internal RESTful middle tier, using an internal Azure load balancer instead of App Gateway.
- Using one load balancer within a region and another on top for global balancing in public-facing multi-region scenarios.

**Key Takeaways 🎯**

- Utilize question-driven tools to identify the best architectural solutions.
- Understand your application’s deployment context (internal vs. public-facing) to choose appropriate load balancing.
- Consider layering load balancers in multi-region setups for optimal traffic management.
- Simplify environment management by consolidating visibility of all components in one interface.
