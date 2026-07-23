## Hands-On Labs Ideas

### Lab 1: AVS Private Cloud Deployment Map

**Goal:** Understand what a private cloud provisions before you deploy anything.

Things to try:

- Map the AVS resource model: private cloud, clusters, hosts, vSAN, vCenter, and NSX-T Manager.
- Record the required address blocks: management/vMotion CIDR, NSX-T segment ranges, and ExpressRoute peering.
- Review host quota, region availability, and Generation 1 vs Generation 2 SKU differences.
- Estimate cost drivers: host count, reserved instances, and egress.

### Lab 2: Deploy a Private Cloud

**Goal:** Stand up a minimal AVS private cloud and reach vCenter.

Things to try:

- Request AVS host quota for the target region.
- Deploy a private cloud with the smallest supported cluster.
- Retrieve vCenter and NSX-T Manager credentials.
- Connect to the private cloud and confirm access to vCenter and NSX-T.

Deploy only when quota, address planning, and cost profile are acceptable.

### Lab 3: Connectivity and Access

**Goal:** Establish routed access from Azure to the private cloud.

Things to try:

- Configure ExpressRoute and, where relevant, Global Reach.
- Design hub-and-spoke or Virtual WAN connectivity for the private cloud.
- Deploy a jump box in a connected VNet and validate reachability to vCenter.
- Review effective routes and BGP advertisements; watch for route-prefix limits.

### Lab 4: NSX-T Networking

**Goal:** Build workload networking inside the private cloud.

Things to try:

- Create Tier-1 gateways and NSX-T segments for workload VMs.
- Configure distributed firewall rules and gateway firewall policies.
- Test east-west and north-south traffic paths.
- Document route planning to avoid silent packet loss at scale.

### Lab 5: Workload Migration with HCX

**Goal:** Migrate a test VM into AVS with HCX.

Things to try:

- Install and activate HCX on both source and AVS sides.
- Create a service mesh and extend a network segment.
- Run a bulk or vMotion migration for a test VM.
- Validate connectivity and cut over.

### Lab 6: Monitoring and Operations

**Goal:** Add observability to the private cloud.

Things to try:

- Integrate Azure Monitor and Log Analytics with AVS.
- Configure alerts for host, cluster, and capacity conditions.
- Review vSAN and cluster health signals.
- Plan scale-out and remediation runbooks.
