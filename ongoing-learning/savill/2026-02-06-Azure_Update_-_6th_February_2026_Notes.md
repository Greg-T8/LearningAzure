# Azure Update - 6th February 2026 - Exam Notes

**Video:** [https://www.youtube.com/watch?v=edJujekFU58](https://www.youtube.com/watch?v=edJujekFU58)  
**Published:** 2026-02-06  
**Duration:** 10:36  

*Generated on 2026-02-06 11:18*

---

## Table of Contents

- [Introduction](#introduction)
- [New videos](#new-videos)
- [AMA data to Event Hub and Storage retire](#ama-data-to-event-hub-and-storage-retire)
- [Fleet manager namespace scope placement](#fleet-manager-namespace-scope-placement)
- [AMD v6 confidential VM new regions](#amd-v6-confidential-vm-new-regions)
- [App GW DRS 2.2](#app-gw-drs-22)
- [App GW v2 XFF rate limiting](#app-gw-v2-xff-rate-limiting)
- [AFD and CDN weak cipher retire](#afd-and-cdn-weak-cipher-retire)
- [VNet routing appliance](#vnet-routing-appliance)
- [ACS v2.1.0](#acs-v210)
- [ANF elastic ZRS](#anf-elastic-zrs)
- [Serverless workspaces in Azure Databricks](#serverless-workspaces-in-azure-databricks)
- [Claude Opus 4.6 in Foundry and more](#claude-opus-46-in-foundry-and-more)
- [Close](#close)

## Introduction

**Timestamp**: 00:00:00 – 00:00:10

**Key Concepts**

- The importance of learning AI across different organizational levels
- Consideration of pros and cons of learning AI

**Definitions**

- None mentioned

**Key Facts**

- The speaker believes AI is already very real and impactful today

**Examples**

- None mentioned

**Key Takeaways 🎯**

- Regardless of role—from C-level executives to individual contributors—learning AI is recommended
- The speaker’s summarized viewpoint is affirmative: yes, you should learn AI because it is relevant now and will continue to be important in the future

---

## New videos

**Timestamp**: 00:00:10 – 00:01:03

**Key Concepts**

- Importance of learning AI for professionals at all levels
- Changes in Azure Monitor agent data collection methods
- Transition from preview features to retired features in Azure Monitor
- Alternative low-cost options for data collection and storage in Azure

**Definitions**

- **Azure Monitor agent**: A tool used to collect monitoring data from virtual machines and send it to various destinations such as storage accounts or event hubs.
- **Custom tabling log analytics (using auxiliary plan)**: A low-cost tier option in Azure Log Analytics for storing monitoring data.
- **Event Hub**: A service used to ingest large amounts of data and send it to other destinations or products.

**Key Facts**

- The Azure Monitor agent preview feature that collected data from virtual machines and sent it to storage accounts or event hubs is being retired.
- For low-cost data storage, the auxiliary plan in custom tabling log analytics is recommended.
- Event hubs are often used to forward data to other final destinations or products.
- There is an increase in native support for data destinations in Azure Monitor.

**Examples**

- Using the auxiliary plan in custom tabling log analytics as a low-cost alternative to storing VM data.
- Using event hubs to send monitoring data to other products or final destinations.

**Key Takeaways 🎯**

- Learning AI is essential for all professional levels due to its growing and accelerating impact.
- The Azure Monitor agent’s preview feature for sending VM data to storage or event hubs is being retired; users should transition to supported alternatives.
- Consider using the auxiliary plan in log analytics for cost-effective data storage.
- Explore native support options in Azure Monitor for sending data to various destinations.

---

## AMA data to Event Hub and Storage retire

**Timestamp**: 00:01:03 – 00:01:42

**Key Concepts**

- Retirement of the Azure Monitor Agent (AMA) feature that sends data to storage accounts or Event Hubs.
- Alternative low-cost data collection options using Log Analytics with the auxiliary plan.
- Increased native support for sending data to other destinations, reducing the need for Event Hub forwarding.

**Definitions**

- **Azure Monitor Agent (AMA)**: An agent used to collect monitoring data from virtual machines.
- **Event Hub**: A data streaming platform and event ingestion service.
- **Storage Account**: Azure service for storing large amounts of unstructured data.
- **Auxiliary Plan**: A very low-cost tier option for Log Analytics.

**Key Facts**

- The preview feature of AMA that collected data from VMs and sent it to storage or Event Hub is being retired.
- For low-cost data collection, using custom tabling in Log Analytics with the auxiliary plan is recommended.
- Event Hubs were often used to forward data to other final destinations or products.
- Native support for sending data directly to many destinations has increased, providing alternatives to Event Hub usage.

**Examples**

- Using custom tabling in Log Analytics with the auxiliary plan as a low-cost alternative to sending data to storage.
- Event Hubs used as a forwarding mechanism to other products or destinations.

**Key Takeaways 🎯**

- The AMA feature sending data to storage accounts or Event Hubs is no longer supported and is being retired.
- Users should consider switching to Log Analytics auxiliary plan for low-cost data collection.
- Evaluate native destination support options before relying on Event Hubs for data forwarding.
- Plan migration accordingly to avoid disruption in data collection workflows.

---

## Fleet manager namespace scope placement

**Timestamp**: 00:01:42 – 00:02:49

**Key Concepts**

- Azure Kubernetes Fleet Manager supports namespace scoped placement capabilities.
- Fleet Manager enables at-scale management of AKS clusters and Arc-enabled Kubernetes clusters.
- Namespace scoped placement allows more granular control over workload deployment across multiple clusters.
- Targeting can be done based on resource name, type, or label within a namespace.
- This feature is useful when many workloads share a single namespace, avoiding broad impacts.

**Definitions**

- **Azure Kubernetes Fleet Manager**: A tool for managing multiple Kubernetes clusters at scale, including AKS and Arc-enabled Kubernetes clusters.
- **Namespace scoped placement**: The ability to deploy and manage resources specifically within a namespace across multiple clusters, rather than at the entire cluster level.

**Key Facts**

- Namespace scoped placement is a new capability in Azure Kubernetes Fleet Manager.
- It allows deployment targeting by resource name, type, or label within namespaces.
- This granular control helps avoid issues when multiple workloads share a single namespace.

**Examples**

- Targeting specific resources within a namespace by their name, type, or label to update workloads without affecting the entire namespace or cluster.

**Key Takeaways 🎯**

- Namespace scoped placement enhances control and precision in managing workloads across multiple Kubernetes clusters.
- It is particularly beneficial in scenarios where many workloads coexist in a single namespace.
- This feature helps reduce the risk of unintended impacts on unrelated resources during updates or deployments.

---

## AMD v6 confidential VM new regions

**Timestamp**: 00:02:49 – 00:03:27

**Key Concepts**

- Confidential VMs provide encryption of data in use, complementing encryption at rest and in transit.
- AMD v6 SKUs focus on encrypting the entire VM, including CPU and memory.
- No application changes are required to benefit from this VM-level encryption.
- Expansion of AMD v6 confidential VMs availability with 11 new regions added to the existing 6.

**Definitions**

- **Confidential VM**: A virtual machine that encrypts data while it is being processed (in use), protecting memory and CPU from unauthorized access.
- **Encryption in use**: Security measure that encrypts data during processing, not just at rest or in transit.

**Key Facts**

- AMD v6 confidential VMs now available in 17 regions total (6 existing + 11 new).
- Encryption covers both compute and memory within the VM.
- Encryption in use is distinct from encryption at rest and encryption in transit (e.g., TLS).

**Examples**

- None mentioned.

**Key Takeaways 🎯**

- Confidential VMs enhance security by encrypting data during processing without requiring application modifications.
- The geographic availability of AMD v6 confidential VMs has significantly expanded, offering broader access.
- This technology complements existing encryption methods to provide comprehensive data protection.

---

## App GW DRS 2.2

**Timestamp**: 00:03:27 – 00:04:12

**Key Concepts**

- App Gateway (Application Gateway) is a regional Layer 7 load balancer and web application firewall (WAF) solution.
- DRS 2.2 is a new rule set available in GA (General Availability) for App Gateway.
- DRS 2.2 is a superset of the OWASP Core Rule Set (CRS) version 3.3.4.
- Microsoft adds its own Threat Intelligence rules on top of the OWASP CRS to enhance protection.
- The rule set includes a configurable "paranoia level" to balance security and false positives.

**Definitions**

- **App Gateway**: A regional Layer 7 solution for load balancing and web application firewall capabilities.
- **DRS 2.2 (Default Rule Set 2.2)**: An enhanced WAF rule set for App Gateway that builds on OWASP CRS 3.3.4 with additional Microsoft Threat Intelligence rules.
- **Paranoia Level**: A setting in the WAF rule set that adjusts the strictness of blocking to reduce false positives and avoid blocking legitimate traffic.

**Key Facts**

- DRS 2.2 is now generally available (GA).
- OWASP Core Rule Set version referenced is 3.3.4.
- Microsoft adds additional threat intelligence rules beyond the OWASP CRS.
- Paranoia level allows tuning of the rule set sensitivity.

**Examples**

- None explicitly mentioned in this time range.

**Key Takeaways 🎯**

- App Gateway’s DRS 2.2 provides enhanced security by combining OWASP CRS 3.3.4 with Microsoft’s threat intelligence.
- The paranoia level feature is important for tuning WAF behavior to minimize false positives.
- Using App Gateway with DRS 2.2 helps protect applications at the Layer 7 level with up-to-date and comprehensive rule sets.

---

## App GW v2 XFF rate limiting

**Timestamp**: 00:04:12 – 00:04:53

**Key Concepts**

- App Gateway V2 supports XFF (X-Forwarded-For) rate limiting in preview.
- XFF header reveals the original client IP address even when proxies or CDNs are involved.
- Rate limiting can be applied based on the originating client IP.
- Grouping traffic by client IP or geolocation helps mitigate high volume or potentially malicious traffic.

**Definitions**

- **XFF (X-Forwarded-For)**: An HTTP header that shows the original client’s IP address, rather than the IP of an intermediate proxy or content delivery network.

**Key Facts**

- App Gateway V2’s XFF rate limiting is currently in preview.
- Using XFF allows more accurate identification of the true client IP behind proxies or CDNs.

**Examples**

- If a proxy or CDN is between the client and the gateway, the IP seen normally would be that of the proxy/CDN.
- With XFF, the gateway can see the original client IP and apply rate limiting or grouping based on that IP or its geolocation.

**Key Takeaways 🎯**

- XFF rate limiting enhances the ability to control traffic by identifying the true client IP.
- This feature helps prevent blocking legitimate traffic by allowing more granular control.
- Useful for mitigating high volume traffic or attacks originating from specific IPs or regions.

---

## AFD and CDN weak cipher retire

**Timestamp**: 00:04:53 – 00:06:09

**Key Concepts**

- TLS cipher suites consist of multiple components including key sharing, identity validation, symmetric encryption/decryption, integrity validation, and hashing.
- Some cipher suites are considered weak and are being retired.
- Azure Front Door (AFD) and Azure Content Delivery Network (CDN) are retiring weak cipher suites starting early April.
- Specifically, weak Diffie-Hellman ephemeral (DHE) cipher suites are being dropped.
- Elliptic Curve Diffie-Hellman ephemeral (ECDHE) cipher suites are preferred due to smaller keys, equivalent security, and better performance.
- Cipher suites are negotiated during connection setup, selecting the strongest mutually supported suite.
- If backend origins only support deprecated DHE cipher suites, configuration changes will be necessary.

**Definitions**

- **TLS (Transport Layer Security)**: A protocol that provides privacy and data integrity between two communicating applications.
- **Cipher Suite**: A set of algorithms that help secure a network connection, including key exchange, encryption, and hashing methods.
- **DHE (Diffie-Hellman Ephemeral)**: A key exchange method using temporary keys, considered weaker and less efficient.
- **ECDHE (Elliptic Curve Diffie-Hellman Ephemeral)**: A more efficient and secure variant of DHE using elliptic curve cryptography.

**Key Facts**

- Retirement of weak cipher suites by AFD and CDN begins early April.
- DHE cipher suites are typically not used today.
- ECDHE cipher suites use smaller keys but provide equivalent security.
- Cipher suite negotiation happens dynamically between client and server to select the best supported option.

**Examples**

- None mentioned explicitly, but the scenario of origins behind AFD/CDN only supporting DHE cipher suites requiring updates was discussed.

**Key Takeaways 🎯**

- Azure Front Door and CDN will no longer support weak DHE cipher suites starting early April.
- Most modern systems use ECDHE cipher suites, which are faster and more secure.
- No action may be needed if origins already support modern cipher suites.
- If origins only support deprecated DHE cipher suites, updates to those origins will be required to maintain compatibility.
- Understanding cipher suite negotiation helps anticipate impact and necessary changes.

---

## VNet routing appliance

**Timestamp**: 00:06:09 – 00:06:55

**Key Concepts**

- Managing routing in Azure virtual networks (VNets) traditionally involved using VMs as routing appliances.
- The new VNet routing appliance is a native Azure resource designed to replace VM-based routing solutions.
- It runs in a dedicated subnet within the VNet.
- Provides high performance and horizontal scaling.
- Optimized for fast east-west traffic within and between VNets.
- Currently supports IPv4 only.
- Available in preview for testing.

**Definitions**

- **VNet routing appliance**: A native Azure resource that handles routing within VNets, providing a scalable, high-performance alternative to VM-based routing appliances.

**Key Facts**

- Traditional routing appliances were VMs used as next hops in user-defined routes.
- VM-based routing appliances can become bottlenecks.
- The new appliance is dedicated, scalable, and designed for high throughput.
- Runs in its own subnet inside the VNet.
- Supports only IPv4 at this time.
- Available now in preview.

**Examples**

- Previously, a VM in a hub-spoke network was used as a routing appliance by setting it as the next hop in user-defined routes.
- The new appliance replaces this VM with a native Azure resource.

**Key Takeaways 🎯**

- The VNet routing appliance improves routing performance and scalability compared to VM-based solutions.
- It reduces bottlenecks caused by VM routing appliances.
- Being a native Azure resource, it simplifies management and deployment.
- Currently IPv4 only, so plan accordingly.
- Available in preview, so users can start testing and providing feedback.

---

## ACS v2.1.0

**Timestamp**: 00:06:55 – 00:08:17

**Key Concepts**

- Azure Container Storage (ACS) v2.1.0 is now generally available (GA).
- ACS is designed specifically to provide storage solutions optimized for Kubernetes environments.
- Kubernetes typically uses Container Storage Interface (CSI) drivers for storage access.
- ACS leverages a backend called AC store, enabling more advanced storage options than typical CSI drivers.
- ACS v2 introduced ephemeral disk support using local storage on AKS nodes.
- The new GA feature in ACS v2.1.0 is support for Azure Elastic SAN for stateful workloads.
- Modular installation in ACS v2.1.0 allows installing only necessary components, reducing cluster footprint.

**Definitions**

- **Azure Container Storage (ACS)**: A storage solution tailored for Kubernetes workloads on Azure, providing optimized storage access and management.
- **Container Storage Interface (CSI) drivers**: Standardized drivers that allow Kubernetes to interact with various storage systems across different cloud providers.
- **Ephemeral disks**: Temporary local storage on AKS nodes, suitable for non-persistent data.
- **Azure Elastic SAN**: A high-throughput, managed storage service designed for stateful workloads, now supported by ACS.
- **Modular installation**: An installation approach where only required components are deployed based on selected options, minimizing resource usage.

**Key Facts**

- ACS v2.1.0 is now generally available.
- Initial ACS v2 supported ephemeral disks (local storage on AKS nodes).
- Azure Elastic SAN support in ACS is now GA, enabling high throughput and reduced management for stateful workloads.
- Modular installation reduces cluster footprint by installing only needed components.

**Examples**

- Using ephemeral disks for ephemeral (non-stateful) workloads on AKS nodes.
- Transitioning to Azure Elastic SAN for stateful workloads requiring persistent storage.

**Key Takeaways 🎯**

- ACS v2.1.0 enhances Kubernetes storage on Azure by adding support for Azure Elastic SAN, enabling stateful workloads with high throughput.
- Modular installation improves efficiency by deploying only necessary components.
- ACS provides a more advanced backend storage option compared to standard CSI drivers, offering better performance and scalability.
- Understanding the difference between ephemeral disk usage and Elastic SAN is important for selecting appropriate storage for workloads.

---

## ANF elastic ZRS

**Timestamp**: 00:08:17 – 00:08:59

**Key Concepts**

- Azure NetApp Files (ANF) now offers Elastic Zone Redundant Storage (ZRS) as a service in preview.
- Zone Redundant Storage provides resiliency and zero data loss during an Availability Zone (AZ) outage.
- Elastic ZRS supports multiple availability zones within a region.
- It maintains all features of regular ANF service levels (NFSv3, NFSv4.1, SMB, snapshots, encryption).
- Synchronous replication within a region ensures no data loss during unplanned AZ outages.
- Automatic transparent failover is provided if an AZ experiences problems.

**Definitions**

- **Elastic ZRS (Zone Redundant Storage)**: A storage service that replicates data synchronously across multiple availability zones within a region to provide high availability and zero data loss in case of an AZ outage.

**Key Facts**

- Elastic ZRS is currently in preview.
- Supports all regular ANF protocols and features (NFSv3, NFSv4.1, SMB, snapshots, encryption).
- Uses synchronous replication within a region.
- Provides automatic transparent failover on AZ failure.

**Examples**

- None mentioned specifically for Elastic ZRS in this segment.

**Key Takeaways 🎯**

- Elastic ZRS enhances ANF by adding zone redundancy with zero data loss guarantees.
- It operates transparently behind the scenes, simplifying resiliency.
- Ideal for stateful workloads requiring high availability across AZs.
- Maintains full compatibility with existing ANF features and protocols.

---

## Serverless workspaces in Azure Databricks

**Timestamp**: 00:08:59 – 00:09:40

**Key Concepts**

- Serverless workspaces provide a scalable, on-demand compute environment in Azure Databricks.
- Pay-as-you-go model based on actual compute usage.
- Includes default storage as part of the service.
- Offers a SaaS-like experience simplifying infrastructure management.
- Useful for both production workloads and short-lived tasks like testing or training.
- Integration with Unity Catalog for centralized governance and metadata management.

**Definitions**

- **Serverless workspaces**: Azure Databricks environments that can be spun up as needed without managing underlying infrastructure, charging only for compute used.

**Key Facts**

- Serverless workspaces are generally available (GA) in Azure Databricks.
- Default storage is included with the service.
- Unity Catalog is still used, ensuring centralized governance and metadata control.

**Examples**

- Using serverless workspaces for short-lived testing or training workloads.
- Using serverless workspaces for serverless production requirements.

**Key Takeaways 🎯**

- Serverless workspaces simplify Databricks usage by removing infrastructure concerns.
- Cost efficiency is achieved by paying only for compute resources actually consumed.
- Centralized governance remains intact through Unity Catalog integration.
- Ideal for flexible workloads, including ephemeral testing/training and production use cases.

---

## Claude Opus 4.6 in Foundry and more

**Timestamp**: 00:09:40 – 00:10:14

**Key Concepts**

- Claude Opus 4.6 is Anthropic’s most advanced reasoning model.
- It is integrated into Foundry and Copilot Studio, with plans for GitHub Copilot.
- The model is optimized for very long-running tasks and large codebases.
- Supports extremely large context windows for complex coding and knowledge work.

**Definitions**

- **Claude Opus 4.6**: An advanced AI reasoning model by Anthropic designed for complex coding, knowledge work, and tasks requiring large context windows.

**Key Facts**

- Claude Opus 4.6 has a context window in beta of approximately 1 million tokens.
- It supports output lengths of about 128,000 tokens.
- Available now in Foundry and Copilot Studio; coming soon to GitHub Copilot.

**Examples**

- Use cases include very complex coding and advanced reasoning tasks involving large codebases.

**Key Takeaways 🎯**

- Claude Opus 4.6 enables handling of extremely large inputs and outputs, making it suitable for advanced, long-duration coding and reasoning workflows.
- Its availability in multiple platforms (Foundry, Copilot Studio, GitHub Copilot) broadens access for developers and knowledge workers.
- The model’s large token capacity is a significant advancement for AI-assisted development and knowledge tasks.

---

## Close

**Timestamp**: 00:10:14 – unknown

**Key Concepts**

- Introduction and availability of Claude Opus 46 model
- Advanced reasoning capabilities for complex coding and knowledge work
- Support for very large context windows and long-running tasks

**Definitions**

- **Claude Opus 46**: Anthropic’s most advanced reasoning AI model designed for complex coding, knowledge work, and handling very large context windows.

**Key Facts**

- Claude Opus 46 is available in Foundry and Copilot Studio, with plans for GitHub Copilot integration.
- The model supports a context window of approximately 1 million tokens (in beta).
- It can output up to 128,000 tokens.
- Optimized for very long-running tasks and very large codebases.

**Examples**

- None mentioned

**Key Takeaways 🎯**

- Claude Opus 46 represents a significant advancement in AI reasoning models, particularly suited for complex and large-scale coding projects.
- Its extremely large token context window enables handling of extensive documents or codebases in a single session.
- Availability across multiple platforms (Foundry, Copilot Studio, GitHub Copilot) increases accessibility for developers and knowledge workers.
- This model is ideal for users needing advanced reasoning over long and complex tasks.
