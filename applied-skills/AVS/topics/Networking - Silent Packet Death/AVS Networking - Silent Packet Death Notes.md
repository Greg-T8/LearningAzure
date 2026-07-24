# Detailed Outline: Silent Packet Death in Azure VMware Solution

> Documentation links reference Microsoft Learn pages only where the point is directly or substantially supported. Transcript-specific examples, analogies, inferred failure symptoms, and unsupported implementation details remain unlinked.

## I. Introduction: The Hidden Risks of AVS Networking

### A. The migration-success scenario

1. An organization migrates approximately 1,000 virtual machines into Azure over a weekend.
2. The migration team:

   * Completes preparation.
   * Executes the cutover.
   * Verifies application connectivity.
   * Declares the migration successful.
3. Problems appear only when production demand increases on Monday morning.
4. The hybrid environment suddenly loses connectivity.
5. Monitoring systems show:

   * No obvious warnings.
   * No useful error codes.
   * No clear indication that routing capacity has been exceeded.

### B. The central problem

1. The environment has reached a hidden mathematical limit in the software-defined networking fabric. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
2. The limit is obscure because it is tied to:

   * Route-prefix processing. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * Internal IP-block fragmentation. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * Hardware forwarding-table capacity. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
3. The resulting failure is described as **silent packet death**:

   * Packets disappear.
   * Applications time out.
   * Routers may not return ICMP errors.
   * Engineers initially investigate firewalls and application settings instead of route capacity.

### C. Purpose and audience

1. The discussion examines the Azure VMware Solution networking architecture. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))
2. It focuses on the interaction between: ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))

   * Traditional VMware networking. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))
   * Azure’s hyperscale physical infrastructure.
   * NSX-T overlay networking. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))
   * Azure’s software-defined underlay. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))
3. Intended audience:

   * Enterprise network architects.
   * Cloud engineers.
   * Infrastructure directors.
4. Core themes: ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))

   * BGP routing. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))
   * IP-address planning. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))
   * Firewall placement. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))
   * Hybrid connectivity. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))
   * Capacity planning. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))
   * Generation 1 versus Generation 2 AVS architecture. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))

---

## II. Foundational IP-Address Planning

### A. The minimum AVS address block

1. AVS requires a minimum contiguous **/22 CIDR block**. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
2. A /22 contains 1,024 IP addresses. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
3. The requirement may seem excessive when the initial deployment includes only three ESXi hosts. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
4. Traditional data-center designs might use:

   * A /27 for a storage network.
   * A /28 for a small vMotion network.
5. AVS reserves much more space because the deployment represents an entire software-defined data center rather than a few isolated hosts. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))

### B. Why the address block must be contiguous

1. Azure Resource Manager automatically divides the /22 into predefined infrastructure networks. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
2. Examples described in the transcript include: ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))

   * A /26 for vCenter and NSX Manager. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
   * A /25 for vMotion. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
   * A /25 for ESXi management. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
3. Customers do not control the sizes of these internal subnets. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
4. The design prioritizes:

   * Automation.
   * Predictable lifecycle management.
   * Host replacement.
   * Cluster expansion.
   * Elimination of human subnetting errors.

### C. Lifecycle-management justification

1. Azure must be able to: ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))

   * Add hosts. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
   * Replace failed physical hosts. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
   * Evacuate workloads.
   * Patch ESXi hosts. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
   * Expand clusters without readdressing the management plane. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
2. A customer-defined subnet that is too small could prevent future scale-out. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
3. The /22 protects the environment from future IP exhaustion. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
4. The trade-off is that enterprises must locate a large, unused, contiguous address range. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))

### D. Day-zero planning implications

1. The management CIDR cannot be treated like a normal workload subnet. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
2. Address overlap must be identified before deployment. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
3. Correcting an addressing mistake later may require rebuilding the private cloud. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
4. AVS requires deterministic planning rather than incremental subnet allocation.

---

## III. Restricted and Reserved Address Spaces

### A. General private-address requirement

1. AVS uses RFC 1918 private addressing. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
2. Not every private or nonpublic range can be used safely. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
3. Several ranges conflict with Azure or NSX-T internal infrastructure. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))

### B. The 172.17.0.0/16 conflict

1. The transcript identifies **172.17.0.0/16** as prohibited. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
2. The stated reason is its use by:

   * Docker networking.
   * Azure’s internal containerized management services.
   * Hardware telemetry and health-management components.
3. These internal services are invisible to the VMware tenant.
4. Advertising the same prefix from the enterprise environment creates an underlay conflict.

### C. Consequences of using a conflicting range

1. The hypervisor may not know whether traffic is intended for:

   * An enterprise workload.
   * An internal Azure management component.
2. The managed underlay takes precedence.
3. Workload packets may disappear inside the virtual switching layer.
4. Symptoms may include:

   * TCP retransmissions.
   * Application timeouts.
   * No ICMP unreachable response.
5. This behavior illustrates the transcript’s concept of silent packet death.

### D. NSX-T internal ranges

1. The transcript also identifies restrictions involving: ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))

   * 169.254.0.0/24. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
   * 169.254.2.0/23. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
   * 100.64.0.0/16. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
2. NSX-T uses these ranges for internal overlay functions. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
3. They support peering and transit communication between: ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))

   * Tier-0 gateways. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
   * Tier-1 gateways. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
   * Distributed logical routing components.
4. Advertising overlapping corporate routes could:

   * Poison internal NSX routing.
   * Break BGP peering.
   * Disrupt communication between the NSX overlay and Azure underlay.

### E. Architectural lesson

1. Address exclusions are not arbitrary.
2. They protect invisible infrastructure services and logical transit networks.
3. Address conflicts must be eliminated before deployment. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
4. Traditional enterprise address plans cannot be carried into AVS without validation. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))

---

## IV. Firewall Ports and HCX Migration Traffic

### A. Core ports identified in the transcript

1. TCP 443: ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))

   * vCenter and management access. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
2. TCP 8000: ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))

   * vMotion traffic. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
3. UDP 4500: ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))

   * IPsec/IKEv2 encapsulation. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
4. TCP and UDP 5201: ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))

   * HCX service-mesh diagnostics and throughput testing. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))

### B. HCX live-migration challenge

1. HCX can move active workloads across a WAN. ([Microsoft Learn: Install VMware HCX](https://learn.microsoft.com/en-us/azure/azure-vmware/install-vmware-hcx))
2. A live migration must transfer:

   * Virtual disks.
   * Active memory.
   * Continuously changing memory pages.
3. High-write workloads, such as SQL Server, continually dirty memory pages.
4. The migration must transfer memory changes faster than the workload generates them.
5. Otherwise, the migration cannot converge.

### C. Role of TCP 8000

1. TCP provides reliable delivery for vMotion.
2. Missing memory data could destabilize or crash the guest operating system.
3. TCP maintains the migration’s state machine.
4. Its weakness is reduced throughput over high-latency WAN links because of:

   * Acknowledgments.
   * Windowing.
   * Retransmission behavior.

### D. Role of UDP 4500

1. HCX uses an IPsec tunnel carried over UDP 4500. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
2. UDP avoids standard TCP acknowledgment delays.
3. HCX applies its own transport optimizations inside the tunnel, including:

   * Compression.
   * Deduplication.
   * Error handling.
   * WAN optimization.
4. The design separates:

   * Reliable migration-state handling.
   * High-throughput WAN transport.

### E. Role of port 5201

1. Used for service-mesh diagnostics. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
2. Helps validate available throughput before migration. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
3. Allows engineers to identify transport problems before attempting live workload movement. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))

---

## V. ExpressRoute and Four-Byte BGP ASNs

### A. Purpose of an autonomous system number

1. An ASN identifies a routing domain in BGP. ([Microsoft Learn: ExpressRoute routing requirements](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-routing))
2. Traditional BGP implementations used 16-bit, or two-byte, ASNs. ([Microsoft Learn: ExpressRoute routing requirements](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-routing))
3. Large-scale modern networks use 32-bit, or four-byte, ASNs. ([Microsoft Learn: ExpressRoute routing requirements](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-routing))

### B. Azure’s requirement

1. Azure’s software-defined network uses four-byte ASNs. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
2. AVS ExpressRoute connectivity requires native four-byte ASN support. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
3. Support must exist throughout the routing path. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))

### C. Problems with older network devices

1. Older routers may understand only two-byte ASNs.
2. They may replace an unsupported four-byte ASN with **AS_TRANS 23456**.
3. This translation can preserve basic BGP communication.
4. It can also obscure the real routing path.

### D. Architectural risks of ASN translation

1. Route-path selection may become unreliable.
2. Loop-prevention logic may be weakened.
3. Multiple ExpressRoute circuits and transit paths become difficult to distinguish.
4. AVS may reject or halt the deployment if the network cannot support four-byte ASNs properly.

### E. Operational implication

1. Legacy routing hardware may require replacement or upgrade. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
2. AVS readiness assessments must include router ASN capabilities. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
3. Cloud adoption may expose hidden dependencies on outdated on-premises equipment.

---

## VI. Internet Egress: AVS Generation 1

### A. Managed SNAT model

1. Generation 1 offered a Microsoft-managed source NAT service. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
2. Administrators enabled it through Azure. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
3. Private workload addresses were translated to Microsoft-managed public IP addresses. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
4. The model supported: ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))

   * Internet software updates. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
   * External API access. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
   * Basic outbound connectivity. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))

### B. Benefits

1. Simple to enable. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
2. Fast deployment. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
3. No customer-managed firewall required for basic outbound access. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
4. Minimal initial network design. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))

### C. Connection-limit constraint

1. The transcript describes a hard ceiling of approximately **128,000 concurrent connections**. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
2. The number may appear large but can be consumed quickly.
3. Modern applications open connections to:

   * SaaS platforms.
   * Telemetry endpoints.
   * Certificate-revocation services.
   * APIs.
   * Update services.
4. Hundreds of VMs can collectively create a very large number of simultaneous NAT translations.

### D. NAT state-table behavior

1. Closed connections may remain in the translation table during:

   * TCP TIME_WAIT.
   * Idle timeout periods.
   * HTTP keep-alive intervals.
2. These lingering entries continue consuming ports.
3. The table can fill even when applications appear to have closed their sessions.

### E. Port-exhaustion failure mode

1. New outbound connections are silently dropped.
2. Applications experience:

   * Delayed responses.
   * Random timeouts.
   * Intermittent failures.
3. Engineers cannot directly inspect the managed NAT translation table. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
4. Troubleshooting becomes difficult because the service operates as a black box. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))

### F. ICMP limitation

1. Managed SNAT drops ICMP traffic. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
2. Administrators cannot rely on: ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))

   * Ping. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
   * Traditional traceroute. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
3. They must use TCP-oriented tools, such as: ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))

   * TCPing. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
   * Nmap. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
   * Application-level tests. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
4. The lack of visibility complicates incident response. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))

---

## VII. Internet Egress: AVS Generation 2

### A. Bring-your-own-egress model

1. Generation 2 removes the managed SNAT model. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
2. AVS integrates with a native Azure virtual network. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
3. Customers deploy their own egress platform, such as: ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))

   * Azure Firewall. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
   * A Palo Alto Networks NVA. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
   * A Fortinet NVA. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
   * Another third-party security appliance. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))

### B. Advantages

1. Customer-controlled public IP addresses. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
2. Visibility into: ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))

   * Firewall logs. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
   * NAT translations. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
   * Connection state. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
   * Security events. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
3. Centralized policy enforcement. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
4. Better troubleshooting than the Generation 1 black-box service. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))

### C. Required default route

1. A user-defined route directs **0.0.0.0/0** to the firewall’s private IP address. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
2. The route table must be associated with the AVS Generation 2 subnets `avs-nsx-gw` and `avs-nsx-gw-1`. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
3. These subnets are the AVS-specific NSX gateway uplink subnets in the virtual network associated with the private cloud. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))

### D. Why the UDR is applied at the transit layer

1. These subnets represent the injection point between: ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))

   * Azure’s physical or software-defined routers. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
   * The NSX-T Tier-0 routing layer. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
2. Applying the UDR there forces internet-bound traffic into the inspection path. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
3. It avoids relying solely on dynamically learned default routes. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))

### E. Prevention of asymmetric routing

1. A default route learned through BGP could create inconsistent outbound and return paths.
2. Example:

   * Outbound traffic crosses Azure Firewall.
   * Return traffic arrives through ExpressRoute.
3. A stateful firewall drops return traffic when it did not observe the original session.
4. The targeted UDR design helps maintain symmetric routing.

---

## VIII. Multi-Private-Cloud and Inter-Region Connectivity

### A. Generation 1 AVS Interconnect

1. AVS Interconnect linked multiple private clouds. ([Microsoft Learn: Connect AVS private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/connect-multiple-private-clouds-same-region))
2. The service was explicitly non-transitive. ([Microsoft Learn: Connect AVS private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/connect-multiple-private-clouds-same-region))
3. If Cloud A connected to Cloud B and Cloud B connected to Cloud C: ([Microsoft Learn: Connect AVS private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/connect-multiple-private-clouds-same-region))

   * Cloud A could not automatically communicate with Cloud C through Cloud B. ([Microsoft Learn: Connect AVS private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/connect-multiple-private-clouds-same-region))

### B. Perceived disadvantage

1. Traditional network architects often prefer hub-and-spoke transit routing. ([Microsoft Learn: Connect AVS private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/connect-multiple-private-clouds-same-region))
2. Non-transitivity may require: ([Microsoft Learn: Connect AVS private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/connect-multiple-private-clouds-same-region))

   * Direct connections.
   * Additional configuration.
   * Full-mesh designs.

### C. Reason for non-transitivity

1. Interconnect traffic is carried through dedicated ExpressRoute infrastructure.
2. Allowing one private cloud to become a transit hub would force its edge devices to process unrelated traffic.
3. A large data transfer between two other clouds could:

   * Consume Cloud B’s bandwidth.
   * Create a noisy-neighbor condition.
   * Degrade Cloud B’s workloads.
4. Non-transitivity protects:

   * Performance isolation.
   * Failure-domain boundaries.
   * Latency predictability.

### D. Generation 2 connectivity model

1. Generation 2 moves toward native Azure networking. ([Microsoft Learn: Connect multiple Gen 2 private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/native-connect-multiple-private-clouds))
2. Inter-region options include: ([Microsoft Learn: Connect multiple Gen 2 private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/native-connect-multiple-private-clouds))

   * Azure VNet peering. ([Microsoft Learn: Connect multiple Gen 2 private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/native-connect-multiple-private-clouds))
   * ExpressRoute Global Reach. ([Microsoft Learn: Connect AVS private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/connect-multiple-private-clouds-same-region))
3. VNet peering uses Microsoft’s software-defined backbone. ([Microsoft Learn: Connect multiple Gen 2 private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/native-connect-multiple-private-clouds))
4. Global Reach connects ExpressRoute circuits over Microsoft’s global network. ([Microsoft Learn: Connect AVS private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/connect-multiple-private-clouds-same-region))
5. These options reduce reliance on AVS-specific interconnect constructs. ([Microsoft Learn: Connect multiple Gen 2 private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/native-connect-multiple-private-clouds))

---

## IX. Azure Virtual WAN Connectivity

### A. Branch and remote-site connectivity

1. Organizations may not have ExpressRoute at every branch. ([Microsoft Learn: Azure Virtual WAN overview](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about))
2. Azure Virtual WAN can connect remote locations using site-to-site VPNs. ([Microsoft Learn: Virtual WAN site-to-site connectivity](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal))
3. The Virtual WAN hub requires its own address space. ([Microsoft Learn: Virtual WAN site-to-site connectivity](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal))

### B. Gateway scale units

1. VPN gateway throughput is provisioned through scale units. ([Microsoft Learn: Virtual WAN gateway scale and performance](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq))
2. Microsoft documents one site-to-site VPN gateway scale unit as **500 Mbps aggregate capacity**, with two gateway instances deployed for redundancy: ([Microsoft Learn: Virtual WAN gateway scale and performance](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq))

   * 500 Mbps. ([Microsoft Learn: Virtual WAN gateway scale and performance](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq))
   * Two instances are deployed for redundancy; their capacity should not be added together when sizing the supported aggregate throughput. ([Microsoft Learn: Virtual WAN gateway scale and performance](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq))
3. Capacity planning must account for aggregate branch traffic. ([Microsoft Learn: Virtual WAN gateway scale and performance](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq))

### C. Why bandwidth totals alone are insufficient

1. VPN gateways perform IPsec encryption and decryption. ([Microsoft Learn: Virtual WAN site-to-site connectivity](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal))
2. Cryptographic processing consumes CPU resources.
3. Required operations include:

   * IKEv2. ([Microsoft Learn: Virtual WAN site-to-site connectivity](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal))
   * ESP processing. ([Microsoft Learn: Virtual WAN site-to-site connectivity](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal))
   * AES-256 encryption. ([Microsoft Learn: Virtual WAN site-to-site connectivity](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-site-to-site-portal))
4. A large number of tunnels and packets can exhaust gateway compute even when nominal bandwidth appears sufficient.

### D. Under-provisioning symptoms

1. Gateway CPU reaches 100%.
2. Packets are queued in memory.
3. Queuing introduces jitter.
4. Jitter damages:

   * Voice over IP.
   * Real-time applications.
   * Synchronous database replication.
5. Buffer exhaustion results in packet drops.
6. TCP reacts by reducing window sizes.
7. Overall branch performance collapses.

### E. Capacity-planning lesson

1. Add the aggregate throughput of all branches. ([Microsoft Learn: Virtual WAN gateway scale and performance](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq))
2. Consider packet rate and encryption overhead. ([Microsoft Learn: Virtual WAN gateway scale and performance](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq))
3. Provision enough gateway units for peak conditions. ([Microsoft Learn: Virtual WAN gateway scale and performance](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq))
4. Cost savings from under-provisioning can produce widespread performance failures.

---

## X. Routing Preference: Hot Potato Versus Cold Potato

### A. The routing choice

1. Azure provides a choice between: ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))

   * ISP network routing. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
   * Microsoft network routing. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
2. The transcript describes these as: ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))

   * Hot-potato routing. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
   * Cold-potato routing. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))

### B. Hot-potato routing

1. Microsoft hands traffic to the public internet as soon as possible. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
2. Example: ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))

   * Traffic begins in an AVS environment in Virginia. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
   * Microsoft sends it to a nearby public peering point. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
   * Public transit providers carry it to Tokyo. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
3. BGP attributes influence the early handoff. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
4. Benefits: ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))

   * Lower Azure egress cost. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
5. Risks: ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))

   * Route changes. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
   * Unpredictable latency. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
   * Variable jitter. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
   * Dependence on multiple public ISPs. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))

### C. Cold-potato routing

1. Microsoft retains the traffic on its own network for as long as possible. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
2. Traffic crosses Microsoft’s private global backbone. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
3. It is handed to a local ISP near the destination. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
4. Benefits: ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))

   * Stable latency. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
   * Lower jitter. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
   * Reduced public-internet exposure. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
5. Trade-off: ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))

   * Higher egress cost. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))

### D. Architectural decision

1. Hot-potato routing prioritizes cost. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
2. Cold-potato routing prioritizes predictability and performance. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
3. Latency-sensitive applications may justify Microsoft network routing. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
4. The selection should be based on workload requirements rather than default preference. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))

---

## XI. NSX-T Internal Routing Architecture

### A. NSX-T segments

1. AVS workload networks are implemented as NSX-T segments. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))
2. NSX-T provides logical routing using Tier-0 and Tier-1 gateways. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))

### B. Tier-1 gateway

1. Handles east-west traffic. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))
2. Moves traffic between internal workload segments. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))
3. Described using an airport terminal-tram analogy.
4. Operates in active-standby high availability. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))
5. Traffic may be processed through distributed logical routing close to the workloads.
6. Internal communication can remain within the AVS environment. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))

### C. Tier-0 gateway

1. Handles north-south traffic. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))
2. Connects workloads to: ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))

   * Azure. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))
   * On-premises networks. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))
   * The internet. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))
3. Operates in active-active mode. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))
4. Processes: ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))

   * BGP routes.
   * NAT.
   * Firewall policies.
   * External traffic.

### D. Equal-Cost Multipath

1. Tier-0 uses ECMP to distribute traffic. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))
2. ECMP does not simply alternate packets between gateways.
3. A deterministic hash typically includes:

   * Source IP.
   * Destination IP.
   * Source port.
   * Destination port.
4. All packets in a specific flow remain on the same path.
5. Different flows are distributed across multiple Tier-0 nodes.
6. This prevents:

   * Out-of-order delivery.
   * TCP performance degradation.
7. It increases aggregate north-south throughput.

---

## XII. DHCP Options and HCX Layer-2 Stretch

### A. DHCP delivery methods

1. DHCP can be provided through: ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))

   * Azure portal configuration. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))
   * NSX Manager. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))
   * A relay to an on-premises DHCP server. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))

### B. Purpose of Layer-2 stretching

1. HCX can extend an on-premises subnet into Azure. ([Microsoft Learn: Configure an HCX network extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension))
2. Migrated virtual machines retain: ([Microsoft Learn: Configure an HCX network extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension))

   * Their IP addresses. ([Microsoft Learn: Configure an HCX network extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension))
   * Their original subnet. ([Microsoft Learn: Configure an HCX network extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension))
   * Their original default gateway. ([Microsoft Learn: Configure an HCX network extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension))
3. This supports migration without immediate readdressing. ([Microsoft Learn: Configure an HCX network extension](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-hcx-network-extension))

### C. The DHCP broadcast trap

1. A newly created VM on the Azure side sends a DHCP Discover broadcast. ([Microsoft Learn: DHCP on L2-stretched HCX networks](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks))
2. NSX-T blocks DHCP broadcasts from crossing the HCX Layer-2 extension by default. ([Microsoft Learn: DHCP on L2-stretched HCX networks](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks))
3. The VM never receives a DHCP offer. ([Microsoft Learn: DHCP on L2-stretched HCX networks](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks))
4. The result appears to be a DHCP or network failure. ([Microsoft Learn: DHCP on L2-stretched HCX networks](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks))

### D. Reason for broadcast suppression

1. WAN links are not equivalent to local Ethernet switches.
2. Broadcast traffic must be replicated across the overlay.
3. Unrestricted broadcasts can create:

   * High encapsulation overhead.
   * WAN saturation.
   * VPN gateway CPU exhaustion.
   * Broadcast storms.
4. NSX-T suppresses the traffic to protect the WAN underlay.

### E. Required workaround

1. While the network remains stretched, configure the NSX segment-security profile so that the DHCP filtering options are disabled. ([Microsoft Learn: DHCP on L2-stretched HCX networks](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks))
2. This allows DHCP requests from Azure VMware Solution virtual machines to traverse the HCX Layer-2 extension to the on-premises DHCP server. ([Microsoft Learn: DHCP on L2-stretched HCX networks](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks))
3. Do not configure NSX DHCP relay while the network remains stretched; Microsoft documents that doing so can cause clients to receive incorrect or no responses. ([Microsoft Learn: DHCP on L2-stretched HCX networks](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks))
4. After gateway failover or removal of the network extension, configure an NSX DHCP relay or NSX DHCP server as required. ([Microsoft Learn: DHCP on L2-stretched HCX networks](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks))

---

## XIII. Hybrid DNS and Azure DNS Private Resolver

### A. Azure platform DNS address

1. The transcript identifies **168.63.129.16** as a special Azure platform IP. ([Microsoft Learn: Azure IP address 168.63.129.16](https://learn.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16))
2. It is described as an Anycast virtual address.
3. It is not a normal internet-routed DNS server. ([Microsoft Learn: Azure IP address 168.63.129.16](https://learn.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16))
4. Traffic to the address is intercepted by the local Azure platform. ([Microsoft Learn: Azure IP address 168.63.129.16](https://learn.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16))
5. The query is forwarded into Azure’s internal DNS fabric. ([Microsoft Learn: Azure IP address 168.63.129.16](https://learn.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16))

### B. Benefits

1. Low-latency name resolution. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))
2. High availability. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))
3. No need to expose internal DNS infrastructure publicly. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))
4. Tight integration with Azure’s physical and virtual infrastructure. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))

### C. Hybrid-resolution challenge

1. On-premises users need to resolve private AVS names. ([Microsoft Learn: AVS private and public DNS lookup zones](https://learn.microsoft.com/en-us/azure/azure-vmware/native-dns-forward-lookup-zone))
2. Private AVS records are not available through public DNS. ([Microsoft Learn: AVS private and public DNS lookup zones](https://learn.microsoft.com/en-us/azure/azure-vmware/native-dns-forward-lookup-zone))
3. Traditional on-premises DNS servers cannot directly access Azure platform DNS. ([Microsoft Learn: AVS private and public DNS lookup zones](https://learn.microsoft.com/en-us/azure/azure-vmware/native-dns-forward-lookup-zone))

### D. Azure DNS Private Resolver design

1. Deploy the resolver in an Azure VNet. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))
2. Create: ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))

   * An inbound endpoint subnet. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))
   * An outbound endpoint subnet. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))
3. The transcript describes using small /28 subnets. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))
4. The inbound endpoint receives a private IP address. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))

### E. Conditional forwarding

1. Configure an on-premises DNS conditional forwarder. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))
2. Queries for the AVS private namespace are sent to the resolver’s inbound IP. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))
3. The query path is: ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))

   * On-premises client. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))
   * On-premises DNS server. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))
   * VPN or ExpressRoute. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))
   * Azure DNS Private Resolver inbound endpoint. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))
   * Azure platform DNS. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))
4. The response returns through the same path. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))
5. This provides private hybrid name resolution without deploying standalone DNS servers in Azure. ([Microsoft Learn: Azure DNS Private Resolver architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver))

---

## XIV. Route-Prefix and Hardware Capacity Limits

### A. Key limits identified

1. Azure VNet route-prefix limit: ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

   * Approximately 1,000 prefixes. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
2. Tier-0 gateway virtual NIC limit: ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

   * Approximately 1,024 prefixes. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
3. These limits are presented as critical Generation 2 constraints. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

### B. Hardware forwarding architecture

1. Azure uses SmartNICs for accelerated networking.
2. SmartNICs contain programmable hardware such as FPGAs.
3. They process:

   * Routes.
   * Access-control policies.
   * Encapsulation.
   * Network security functions.
4. Hardware acceleration avoids using the host CPU for every packet.

### C. TCAM limitations

1. Routes are stored in ternary content-addressable memory.
2. TCAM is fast but physically limited and expensive.
3. The routing fabric must standardize how address blocks consume hardware entries.

### D. Prefix fragmentation into /28 blocks

1. The transcript states that Azure fractures advertised address space into /28 units. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
2. A /28 contains 16 IP addresses. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
3. An aggregate route may therefore consume multiple hardware entries. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
4. Example: ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

   * One /24 contains 256 addresses. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * It becomes sixteen /28 blocks. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * It consumes sixteen prefix slots. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
5. A /22 contains: ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

   * 1,024 addresses. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * Sixty-four /28 blocks. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
6. The initial AVS management network therefore consumes route capacity before workload networks are added. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

### E. Scaling effects

1. The transcript describes different internal route capacities based on AVS host count. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
2. A three-node deployment supports fewer /28 route chunks than a larger cluster. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
3. Adding a fourth host increases internal capacity. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
4. The external Azure VNet prefix limit remains a separate hard constraint. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
5. Adding AVS hosts does not remove the VNet-level ceiling. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

---

## XV. HCX Mobility Optimized Networking and the Monday-Morning Outage

### A. Traffic tromboning after migration

1. A VM moved through a stretched Layer-2 network may retain its on-premises default gateway. ([Microsoft Learn: HCX Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance))
2. Traffic may travel: ([Microsoft Learn: HCX Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance))

   * From Azure back to on-premises. ([Microsoft Learn: HCX Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance))
   * Through the original gateway. ([Microsoft Learn: HCX Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance))
   * Back toward Azure or another destination. ([Microsoft Learn: HCX Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance))
3. This inefficient path is called tromboning or hairpinning. ([Microsoft Learn: HCX Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance))

### B. Purpose of Mobility Optimized Networking

1. HCX MON improves the migrated VM’s data path. ([Microsoft Learn: HCX Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance))
2. The VM keeps its original IP address. ([Microsoft Learn: HCX Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance))
3. HCX injects a **/32 host route** for the migrated VM. ([Microsoft Learn: HCX Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance))
4. The /32 tells Azure that the individual VM is now local to AVS. ([Microsoft Learn: HCX Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance))
5. Traffic no longer needs to return through the on-premises gateway. ([Microsoft Learn: HCX Mobility Optimized Networking guidance](https://learn.microsoft.com/en-us/azure/azure-vmware/vmware-hcx-mon-guidance))

### C. Prefix-consumption problem

1. Every migrated VM receives its own /32 route. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
2. Each /32 counts as one prefix. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
3. Migrating 800 VMs can inject 800 individual routes. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
4. Only about 200 entries remain under a 1,000-prefix limit. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
5. The remaining capacity must also accommodate: ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

   * Management routes. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * VPN routes. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * DNS routes. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * Workload subnets. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * Other hybrid connectivity routes. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

### D. Failure at prefix 1,001

1. The Azure forwarding table can no longer accept additional routes. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
2. Newly migrated VMs may:

   * Power on.
   * Appear operational in vCenter.
   * Lack a functional underlay route.
3. Applications cannot communicate.
4. Monitoring may not clearly identify the route-table exhaustion.
5. Engineers may initially investigate:

   * Firewall rules.
   * NSGs.
   * Application services.
   * Guest operating systems.
6. The actual problem is exhausted hardware route capacity.

---

## XVI. Route Summarization and Gateway Cutover

### A. Reclaiming route capacity

1. Individual MON /32 routes should not remain indefinitely. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
2. The long-term solution is to move the subnet gateway into Azure. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
3. The Layer-2 extension is removed or unstretched. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
4. The workload subnet becomes fully local to AVS. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

### B. Summarization

1. NSX-T can replace many individual /32 routes with one aggregate prefix. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
2. Example: ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

   * Hundreds of VM host routes belong to one /24. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * The /32 routes are withdrawn. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * A summarized /24 is advertised. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
3. This dramatically reduces route-table consumption. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

### C. BGP convergence

1. Route withdrawal is not instantaneous. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
2. Updates must propagate through: ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

   * NSX Tier-0 gateways. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * Azure routing components. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * ExpressRoute. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * Other BGP peers. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
3. During convergence, some devices may have inconsistent forwarding information. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

### D. Potential outage

1. The transcript states that convergence may cause up to approximately 30 seconds of downtime. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
2. A 30-second interruption can affect:

   * SQL connections.
   * Application connection pools.
   * Stateful firewall sessions.
   * Replication.
   * Cluster heartbeats.
3. Applications may require manual restart or recovery after the network stabilizes.

### E. Required migration discipline

1. Migrate workloads in controlled batches. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
2. Monitor route-prefix consumption during the migration. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
3. Schedule gateway cutovers during maintenance windows. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
4. Accept the convergence interruption as a planned event.
5. Verify that: ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

   * The summarized route is active. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * The /32 routes have been withdrawn. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * Prefix consumption has returned to baseline. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
6. Begin the next migration batch only after validation. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

---

## XVII. Broader Architectural Lessons

### A. AVS is not a simple VMware hosting platform

1. It combines: ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))

   * VMware management tools. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))
   * NSX-T networking. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))
   * Azure ExpressRoute. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))
   * Azure VNets. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))
   * Azure’s physical networking fabric. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))
2. Traditional data-center practices cannot be transferred without modification. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))

### B. Hidden limits matter

1. IP-block exclusions can cause black holes. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
2. Managed SNAT tables can exhaust. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
3. VPN gateways can be constrained by encryption CPU. ([Microsoft Learn: Virtual WAN gateway scale and performance](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq))
4. Hardware route tables can fill. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
5. Broadcast suppression can break DHCP. ([Microsoft Learn: DHCP on L2-stretched HCX networks](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks))
6. BGP convergence can interrupt applications. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

### C. Visibility and control

1. Generation 1 prioritized simplicity but concealed internal state. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
2. Generation 2 provides more control but requires more deliberate design. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
3. Customers gain:

   * Firewall visibility. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
   * Routing control. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
   * Native Azure integration. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
4. They also inherit responsibility for:

   * UDR design. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
   * Symmetric routing.
   * Capacity management. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
   * Route summarization. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

### D. Networking and project management are inseparable

1. Migration batch size must account for route-prefix capacity. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
2. Cutover timing must account for BGP convergence. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
3. Application teams must understand expected interruptions.
4. Network architects must participate in migration planning from the beginning.

---

## XVIII. Closing Summary and Future Question

### A. Topics recapped in the transcript

1. Mandatory /22 AVS management addressing. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
2. Reserved and prohibited address ranges. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
3. HCX ports and WAN transport. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
4. Four-byte BGP ASNs. ([Microsoft Learn: AVS network planning checklist](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-network-checklist))
5. Generation 1 managed SNAT limitations. ([Microsoft Learn: AVS Managed SNAT](https://learn.microsoft.com/en-us/azure/azure-vmware/enable-managed-snat-for-workloads))
6. Generation 2 customer-managed egress. ([Microsoft Learn: Gen 2 internet connectivity options](https://learn.microsoft.com/en-us/azure/azure-vmware/native-internet-connectivity-design-considerations))
7. Non-transitive AVS Interconnect behavior. ([Microsoft Learn: Connect AVS private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/connect-multiple-private-clouds-same-region))
8. VNet peering and ExpressRoute Global Reach. ([Microsoft Learn: Connect multiple Gen 2 private clouds](https://learn.microsoft.com/en-us/azure/azure-vmware/native-connect-multiple-private-clouds))
9. Virtual WAN scale units. ([Microsoft Learn: Virtual WAN gateway scale and performance](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq))
10. Hot-potato versus cold-potato routing. ([Microsoft Learn: Azure routing preference](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/routing-preference-overview))
11. NSX-T Tier-0 and Tier-1 gateways. ([Microsoft Learn: Configure NSX network components](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-nsx-network-components-azure-portal))
12. HCX Layer-2 DHCP suppression. ([Microsoft Learn: DHCP on L2-stretched HCX networks](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-l2-stretched-vmware-hcx-networks))
13. Azure DNS Private Resolver. ([Microsoft Learn: AVS private and public DNS lookup zones](https://learn.microsoft.com/en-us/azure/azure-vmware/native-dns-forward-lookup-zone))
14. TCAM and prefix-fragmentation limits. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
15. HCX MON /32 route exhaustion. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))
16. Route summarization and cutover convergence. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

### B. Central conclusion

1. Cloud networking is not merely the virtualization of physical cables. ([Microsoft Learn: AVS networking basics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/azure-vmware-solution-network-basics))
2. It depends on an interaction between:

   * Software engineering.
   * Distributed control planes.
   * Hardware memory.
   * Routing mathematics.
   * Operational procedures.
3. Successful AVS architecture requires strict design discipline and continuous capacity monitoring. ([Microsoft Learn: Gen 2 route architecture and limits](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-routing-architecture))

### C. Future-looking question

1. The transcript closes by considering whether AI-driven network control planes could:

   * Dynamically summarize routes.
   * Resize network boundaries.
   * Optimize prefix usage.
   * React to real-time traffic conditions.
2. Such automation could eventually hide hardware and prefix limitations from administrators.
3. This raises a broader question about whether future network architects will still manually:

   * Count IP addresses.
   * Plan route-table capacity.
   * Balance prefix limits.
   * Manage route summarization.
