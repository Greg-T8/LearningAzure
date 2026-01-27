# Application Gateway

**Channel:** freeCodeCamp.org
**Duration:** 11:16:25
**URL:** https://www.youtube.com/watch?v=10PbGbTUSAg

## App Gateway Intro

**Timestamp**: 06:06:20 – 06:08:47

**Key Concepts**  
- Azure Application Gateway is a load balancer operating at OSI Layer 7 (Application Layer).  
- It performs application-level routing based on HTTP requests.  
- Application Gateway can inspect HTTP request contents such as URL paths, cookies, and apply Web Application Firewall (WAF) policies.  
- Configuration involves setting up a frontend, routing rules, and backend pools.  
- Frontend IP can be either private (internal load balancer) or public (external load balancer).  
- Backend pools are collections of resources (VMs, VM scale sets, IP addresses, domain names, app services, possibly on-premises).  
- Routing rules connect frontend listeners to backend pools and define how traffic is forwarded.  
- Listeners monitor specified ports and IPs for incoming traffic using defined protocols.  
- Routing rules come in two types:  
  - Basic: forwards all requests to a backend pool regardless of domain.  
  - Multi-site: forwards requests to different backend pools based on host headers or host names.  
- Priority/order of routing rules matters; basic rules should be last to avoid capturing all traffic prematurely.

**Definitions**  
- **Application Gateway**: Azure’s Layer 7 load balancer that routes HTTP requests based on application-level information.  
- **Frontend**: The IP configuration (public or private) that receives incoming traffic for the Application Gateway.  
- **Backend Pool**: A group of resources (VMs, scale sets, IPs, etc.) that receive traffic from the Application Gateway.  
- **Listener**: Component that listens on a specific port and IP for incoming traffic using a specified protocol.  
- **Routing Rule**: Logic that connects frontend listeners to backend pools and determines how requests are forwarded.  
- **Basic Routing Rule**: Forwards all requests to a single backend pool.  
- **Multi-site Routing Rule**: Routes requests to different backend pools based on host headers or host names.

**Key Facts**  
- Application Gateway operates at OSI Layer 7 (Application Layer).  
- Frontend IP options:  
  - Private IP → internal load balancer  
  - Public IP → external load balancer  
- Backend pools can include VMs, VM scale sets, IP addresses, domain names, app services, and possibly on-premises resources.  
- Routing rules must be prioritized; basic rules should be last in order.

**Examples**  
- Routing based on URL path:  
  - Requests with path `/payments` routed to payment system VM.  
  - Requests with path `/admin` routed to admin VM.  
- Applying WAF policies to filter malicious HTTP traffic.  
- Backend pools containing various resource types to receive traffic.

**Key Takeaways 🎯**  
- Understand that Application Gateway is a Layer 7 load balancer focused on HTTP traffic inspection and routing.  
- Know the difference between frontend IP types and their impact (internal vs external load balancer).  
- Be able to explain backend pools and what resources they can contain.  
- Remember the two types of routing rules (basic and multi-site) and their use cases.  
- Routing rules order is important—basic rules should be last to avoid capturing all traffic prematurely.  
- Application Gateway can apply advanced routing logic based on URL paths, host headers, cookies, and WAF policies—important for exam scenarios involving application-level traffic management.

---

## Routing Rules

**Timestamp**: 06:08:47 – 06:11:43

**Key Concepts**  
- Routing rules determine how incoming traffic is directed to backend pools or redirections.  
- A listener listens on a specified port, IP address, and protocol to capture traffic.  
- Routing rules are applied when listener criteria are met.  
- Two types of routing rules: Basic and Multi-site.  
- HTTP settings define how requests are handled for backend pools.  

**Definitions**  
- **Listener**: Component that listens on a specified port and IP address for traffic using a specified protocol.  
- **Routing Rule**: Logic that decides where to forward incoming requests based on listener criteria.  
- **Basic Routing Rule**: Forwards all requests for any domain to a single backend pool (catch-all).  
- **Multi-site Routing Rule**: Forwards requests to different backend pools based on host header or hostname.  
- **Backend Pool**: A collection of resources (VMs, IPs, app services, etc.) that receive traffic.  
- **HTTP Settings**: Configuration that controls how HTTP requests are handled when routed to backend pools.  
- **Redirection**: HTTP redirection response (e.g., 403, temporary, permanent) instead of forwarding to backend.  

**Key Facts**  
- Basic routing rules should be placed last in priority because they catch all traffic.  
- Backend port is usually 80 (HTTP) or 443 (HTTPS), depending on where SSL termination occurs.  
- Cookie-based affinity keeps user sessions on the same backend server by persisting cookies.  
- Connection draining gracefully removes backend pool members during updates by waiting for existing connections to close before stopping traffic to them.  
- Request timeout specifies how many seconds the gateway waits for a backend response before timing out.  
- Override backend path allows routing requests for one URL path to a different internal path.  
- Override host name is used to modify the host header, useful for multi-tenant services like App Service or API Management.  

**Examples**  
- Basic rule acts as a catch-all and should be last in priority order.  
- Multi-site routing can forward requests based on host headers to different backend pools.  
- Override backend path example: routing requests for `/bananas` internally to `/oranges` or `/plantains`.  
- Override host name example: changing host headers for multi-tenant services requiring specific host headers.  

**Key Takeaways 🎯**  
- Always place the basic routing rule last to avoid it capturing all traffic prematurely.  
- Understand the difference between basic and multi-site routing rules for domain-based traffic routing.  
- Configure HTTP settings carefully: backend port, cookie affinity, connection draining, timeouts, and path/host overrides are critical for smooth operation.  
- Use connection draining to avoid dropping user connections during backend updates.  
- Use override backend path and host name features to support complex routing scenarios and multi-tenant services.  
- Remember that routing rules are central to how Application Gateway directs traffic at Layer 7 (application layer).  

---

## AGW CheatSheet

**Timestamp**: 06:11:43 – 06:13:20

**Key Concepts**  
- Azure Application Gateway (AGW) operates at OSI Layer 7 (Application Layer) for application-level routing and load balancing.  
- AGW can have a Web Application Firewall (WAF) attached for enhanced security.  
- AGW components include:  
  - **Front-ends**: Choose IP address type (private or public).  
  - **Backend pools**: Collections of resources (VMs, VM scale sets, IP addresses, domain names, or app services) that receive routed traffic.  
  - **Routing rules**: Made up of listeners, backend targets, and HTTP settings.  
- Listeners monitor specific IP/port/protocol combinations and trigger routing rules. Two types: basic and multi-site.  
- Routing rules are processed in order; basic listeners should be added last to avoid capturing all requests prematurely.  
- Backend targets specify where traffic is routed—either to backend pools or redirections.  
- HTTP settings define how requests are handled (cookies, connection draining, ports, timeouts, etc.).

**Definitions**  
- **Azure Application Gateway**: A Layer 7 load balancer and application-level routing service in Azure.  
- **Listener**: A configuration that listens on a specific IP, port, and protocol to match incoming requests.  
- **Backend Pool**: A group of backend resources (VMs, scale sets, IPs, domain names, app services) that receive traffic from the gateway.  
- **HTTP Settings**: Configuration settings that control how the Application Gateway communicates with backend targets (e.g., cookie handling, connection draining, timeouts).  
- **Multi-site Listener**: A listener that can route traffic based on host headers for multiple sites.  
- **Basic Listener**: A simple listener that listens on a single IP and port.

**Key Facts**  
- AGW operates at OSI Layer 7 (application layer).  
- Backend pools can include: VM, VM scale set, IP address, domain name, or app service.  
- Listener types: basic and multi-site; order of rules matters (basic listeners last).  
- HTTP settings control detailed request handling (cookies, draining, ports, timeouts).  

**Examples**  
- None explicitly mentioned in this segment, but a practical note on overriding host names for multi-tenant services like App Service or API Management was referenced just before this section.

**Key Takeaways 🎯**  
- Remember AGW is a Layer 7 load balancer with WAF capabilities.  
- Understand the three main components: front-end IPs, backend pools, and routing rules.  
- Know the difference between basic and multi-site listeners and the importance of rule order.  
- HTTP settings are critical for managing backend communication behavior.  
- Backend pools are flexible and can include various resource types.  
- Overriding host names is important when routing to multi-tenant services (though this was just prior to the section).

---
