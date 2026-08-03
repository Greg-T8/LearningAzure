# Oracle AI Database@Azure and Exadata — Technical Notes

## 1. Project context

BART’s disaster-recovery engagement includes provisioning Oracle Exadata infrastructure in Azure, connecting it to Azure VMware Solution and associated Azure services, validating storage and interconnect performance, and supporting infrastructure updates. The statement of work also clarifies that Oracle-specific database runbook content, testing procedures, and database failover testing must be supplied by Oracle Consulting.

These notes consolidate the Oracle AI Database@Azure regional-availability and public-pricing information captured in this conversation.

> **Pricing caution:** The figures below are point-in-time public list-price estimates reproduced from the earlier pricing analysis. They exclude taxes, negotiated private-offer discounts, Azure networking, backup, monitoring, and other surrounding services. Validate the final configuration through Oracle, Microsoft, and the Azure Marketplace private offer before procurement.

---

## 2. Service architecture

Oracle AI Database@Azure places Oracle-managed database infrastructure in Microsoft Azure data centers and connects it directly to an Azure virtual network. It is not Exadata software installed on ordinary Azure virtual machines, nor is it a conventional cross-cloud design connected through the public internet.

The operating model has three primary responsibility layers:

| Party           | Primary responsibilities                                                                                                                                                  |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Oracle          | Exadata physical infrastructure, storage servers, database servers, firmware, platform maintenance, and Oracle-managed operations                                         |
| Microsoft/Azure | Azure service integration, Azure Marketplace billing, Azure control-plane integration, and underlying Azure facility services                                             |
| Customer        | Azure networking, routing, governance, security configuration, database administration, VM cluster administration, monitoring configuration, and application connectivity |

The customer still requires an associated OCI tenancy because Oracle uses OCI for fleet management and infrastructure operations. Azure remains the primary customer-facing environment for networking and connected Azure resources.

### Architectural interpretation

Oracle AI Database@Azure should be treated as a jointly operated engineered platform:

* The infrastructure is physically colocated in Azure.
* Oracle continues to operate the Exadata service through Oracle control-plane systems.
* Azure networking and governance participate directly in the architecture.
* Incident response may involve Oracle, Microsoft, and the customer.
* “Native in Azure” does not mean that Microsoft operates every layer.

---

# 3. U.S. regional availability

The regional matrix captured earlier in this conversation identified eight U.S. Azure regions supporting Exadata services.

| Azure region     | Associated OCI region | Exadata Dedicated | Exadata Exascale | Zone coverage |
| ---------------- | --------------------- | ----------------: | ---------------: | ------------- |
| Central US       | US Midwest—Chicago    |               Yes |              Yes | Dual zone     |
| East US          | US East—Ashburn       |               Yes |              Yes | Dual zone     |
| East US 2        | US East—Ashburn       |               Yes |              Yes | Dual zone     |
| North Central US | US Midwest—Chicago    |               Yes |              Yes | Single zone   |
| South Central US | US South—Dallas       |               Yes |              Yes | Dual zone     |
| West US          | US West—San Jose      |               Yes |              Yes | Single zone   |
| West US 2        | US West—Quincy        |               Yes |              Yes | Dual zone     |
| West US 3        | US West—Phoenix       |               Yes |              Yes | Dual zone     |

### Services represented

The regional matrix indicated support for:

* Oracle Exadata Database Service on Dedicated Infrastructure
* Oracle Autonomous AI Database on Dedicated Exadata Infrastructure
* Oracle Exadata Database Service on Exascale Infrastructure

### Zone terminology

**Dual-zone region** means the Oracle service is available in at least two Azure physical availability zones in that region.

**Single-zone region** means the service currently has one physical service location in the region. Regional disaster recovery may therefore depend on another supported Azure region rather than a second zone in the same region.

### Stronger in-region placement options

From a zone-coverage perspective, the U.S. regions with the strongest placement flexibility are:

* Central US
* East US
* East US 2
* South Central US
* West US 2
* West US 3

North Central US and West US support Exadata services but were listed as single-zone locations.

### Capacity caveat

Regional publication does not guarantee that the required Exadata hardware is immediately available. Exadata capacity is physical engineered-system capacity, not an effectively unlimited general-purpose VM pool. Capacity should be confirmed and reserved before the DR design is finalized. The Oracle architecture guide identifies regional availability and capacity as foundational dependencies that must be resolved before networking and recovery procedures are completed.

---

# 4. Region-selection considerations for disaster recovery

Azure paired-region conventions should not be used as the sole basis for Oracle placement. A normal Azure paired region does not automatically guarantee that the required Oracle service, Exadata generation, hardware shape, or physical capacity is available in both locations.

The region decision should evaluate:

| Requirement             | Planning question                                                                                 |
| ----------------------- | ------------------------------------------------------------------------------------------------- |
| Service availability    | Does the region support Dedicated, Exascale, Autonomous Dedicated, or the exact required service? |
| Zone availability       | Is the service single-zone or dual-zone in the selected region?                                   |
| Hardware capacity       | Can Oracle reserve the required database and storage capacity?                                    |
| OCI region subscription | Is the associated OCI tenancy subscribed to the paired OCI region?                                |
| Data residency          | Do both primary and DR locations satisfy BART’s data-location requirements?                       |
| Data Guard support      | Is the desired Data Guard protection mode supported between the locations?                        |
| Latency                 | Can the path meet redo transport and apply-lag objectives?                                        |
| RPO/RTO                 | Does the topology meet the required database recovery objectives?                                 |
| Transfer charges        | Do the documented transfer terms apply to the selected replication path?                          |
| Operational support     | Are Oracle and Microsoft support boundaries documented and tested?                                |

## Recommended placement workflow

1. Identify the location of the production Oracle databases.
2. Identify all Azure regions supporting the required Exadata service.
3. Determine whether each candidate region is dual-zone, single-zone, or intended primarily as a DR location.
4. Verify the associated OCI regions.
5. Confirm Oracle Data Guard support and protection-mode requirements.
6. Measure or estimate network latency between primary and standby locations.
7. Validate data-residency and regulatory constraints.
8. Confirm transfer-charge treatment for the selected route.
9. Reserve Exadata capacity.
10. Finalize the networking, runbook, and failover design.

---

# 5. Oracle Data Guard role

Oracle Data Guard is the principal database-replication technology contemplated for Oracle database DR.

It maintains a standby database by:

1. Generating redo records on the primary database.
2. Transmitting redo to the standby.
3. Applying the redo to maintain a synchronized copy.
4. Tracking transport lag and apply lag.
5. Supporting switchover or failover based on the selected configuration.

Important design variables include:

* Maximum Performance, Maximum Availability, or Maximum Protection mode
* Synchronous versus asynchronous redo transport
* Network round-trip latency
* Redo-generation rate
* Standby apply performance
* Data Guard broker and operational automation
* Fast-Start Failover requirements
* Application and DNS redirection after failover

The Oracle guide cautions against treating all replication traffic as universally free. It distinguishes same-region OCI-managed paths from cross-region guidance in which only a defined amount of transfer may be free. The planned route and current commercial terms must be validated.

---

# 6. Commercial and billing model

Oracle AI Database@Azure is acquired through Azure Marketplace, typically through an Oracle private offer.

The commercial model includes:

* Charges presented on the normal Microsoft Azure invoice
* Eligible consumption applied against the Microsoft Azure Consumption Commitment, or MACC
* An associated OCI tenancy for Oracle fleet management
* Support for license-included and Bring Your Own License configurations
* Potential negotiated pricing based on term, commitment, and deployment scale

The Oracle architecture guide confirms the Marketplace, Azure-invoice, and MACC model while noting that offer eligibility, licensing terms, and contractual scope require account-team confirmation.

---

# 7. Dedicated Exadata Infrastructure pricing

Dedicated Infrastructure has two principal billing layers:

1. Dedicated database and storage servers
2. Enabled Oracle Database OCPUs

## 7.1 X11M infrastructure rates captured in the chat

| Component            |       Public unit price | 730-hour monthly estimate |
| -------------------- | ----------------------: | ------------------------: |
| X11M database server | $6.3014 per server-hour |      $4,600.02 per server |
| X11M storage server  | $5.4795 per server-hour |      $4,000.04 per server |

The baseline configuration used in the earlier analysis contained:

* Two database servers
* Three storage servers

## 7.2 Minimum infrastructure floor

| Component                   | Quantity |         Monthly estimate |
| --------------------------- | -------: | -----------------------: |
| Database servers            |        2 |                $9,200.04 |
| Storage servers             |        3 |               $12,000.11 |
| **Infrastructure subtotal** |          | **$21,200.15 per month** |

This is the infrastructure floor before enabling billable database OCPUs.

The Oracle guide similarly identifies the base engineered-system pattern as two database servers and three storage servers, while noting that current Oracle documentation covers both X9M and X11M generations.

---

## 7.3 Dedicated database OCPU rates

| Licensing model  | OCPU-hour | Monthly estimate per continuously enabled OCPU |
| ---------------- | --------: | ---------------------------------------------: |
| License included |   $1.3441 |                                        $981.19 |
| BYOL             |   $0.3226 |                                        $235.50 |

On x86-based Oracle cloud infrastructure:

* One OCPU represents one physical CPU core.
* One OCPU corresponds to two vCPUs.
* Public pages may therefore show a vCPU comparison rate that is half the actual OCPU billing rate.

## 7.4 Dedicated cost formula

### License included

```text
Monthly cost =
(Database server count × $6.3014 × active hours)
+ (Storage server count × $5.4795 × active hours)
+ (Enabled OCPUs × $1.3441 × active hours)
```

### BYOL

```text
Monthly cost =
(Database server count × $6.3014 × active hours)
+ (Storage server count × $5.4795 × active hours)
+ (Enabled OCPUs × $0.3226 × active hours)
```

## 7.5 Example: base X11M infrastructure with 16 OCPUs

| Cost component              | License included |            BYOL |
| --------------------------- | ---------------: | --------------: |
| Base infrastructure         |       $21,200.15 |      $21,200.15 |
| 16 database OCPUs           |       $15,699.09 |       $3,767.97 |
| **Estimated monthly total** |   **$36,899.24** |  **$24,968.12** |
| **Estimated annual total**  |  **$442,790.88** | **$299,617.44** |

### BYOL effect

BYOL reduces the metered database-compute portion by approximately 76%. It does **not** reduce:

* Database-server charges
* Storage-server charges
* Azure networking
* Monitoring
* Backup
* Data Guard standby infrastructure
* Ancillary Azure services

---

# 8. Exadata Exascale Infrastructure pricing

Exascale separates database compute, RDMA infrastructure, and storage into individual consumption meters.

## 8.1 Exascale rates captured in the chat

| Component                      |        Unit price |         Approximate monthly unit cost |
| ------------------------------ | ----------------: | ------------------------------------: |
| Database ECPU—license included | $0.3360/ECPU-hour | $245.28 per continuously enabled ECPU |
| Database ECPU—BYOL             | $0.0807/ECPU-hour |  $58.91 per continuously enabled ECPU |
| RDMA compute infrastructure    | $0.0375/ECPU-hour |           $27.38 per provisioned ECPU |
| Smart Database Storage         |  $0.1953/GB-month |          $195.30 per decimal TB-month |
| VM filesystem storage          |  $0.0999/GB-month |           $99.90 per decimal TB-month |
| Additional flash cache         |   $0.0009/GB-hour |            $672.77 per 1,024 GB/month |

## 8.2 Billing distinction

The database ECPU and RDMA infrastructure are separate meters:

* **Database ECPU charge:** Oracle Database compute and licensing.
* **RDMA infrastructure charge:** Provisioned Exascale compute infrastructure.
* **Smart Database Storage:** Shared Exascale database storage.
* **VM filesystem storage:** Filesystem capacity assigned to the VM cluster.
* **Flash cache:** Additional optional performance capacity.

## 8.3 Minimum example used in the prior analysis

Assumptions:

* Two database VMs
* Eight ECPUs per VM
* Sixteen total ECPUs
* 560 GB VM filesystem storage
* 300 GB Smart Database Storage
* No additional flash cache
* 730 hours per month

| Component                     | License included |           BYOL |
| ----------------------------- | ---------------: | -------------: |
| 16 database ECPUs             |        $3,924.48 |        $942.58 |
| 16 RDMA infrastructure ECPUs  |          $438.00 |        $438.00 |
| 560 GB VM filesystem storage  |           $55.94 |         $55.94 |
| 300 GB Smart Database Storage |           $58.59 |         $58.59 |
| **Estimated monthly total**   |    **$4,477.01** |  **$1,495.11** |
| **Estimated annual total**    |   **$53,724.12** | **$17,941.32** |

## 8.4 Exascale formula

### License included

```text
Monthly cost =
(Enabled database ECPUs × $0.3360 × active hours)
+ (Provisioned RDMA ECPUs × $0.0375 × active hours)
+ (Smart Database Storage GB × $0.1953)
+ (VM Filesystem Storage GB × $0.0999)
+ (Additional Flash Cache GB × $0.0009 × active hours)
```

### BYOL

Replace the database ECPU rate of `$0.3360` with `$0.0807`.

## 8.5 Commitment behavior

The earlier pricing analysis identified:

* An eight-ECPU minimum per VM
* A two-VM minimum in the illustrated configuration
* A 48-hour initial minimum commitment
* Per-second billing after applicable minimum periods, subject to Oracle’s billing rules

These terms should be reconfirmed for the exact offer and deployment date.

---

# 9. Dedicated versus Exascale

| Design dimension       | Dedicated X11M                                              | Exascale                                                                  |
| ---------------------- | ----------------------------------------------------------- | ------------------------------------------------------------------------- |
| Infrastructure tenancy | Dedicated database and storage servers                      | Elastic Exascale infrastructure                                           |
| Baseline cost          | Approximately $21,200/month before OCPUs                    | Consumption-based                                                         |
| Database billing unit  | OCPU                                                        | ECPU                                                                      |
| Storage model          | Capacity supplied through dedicated storage servers         | Smart Database Storage billed per GB                                      |
| Scaling granularity    | Server and OCPU based                                       | ECPU and storage consumption based                                        |
| Entry cost             | High                                                        | Significantly lower                                                       |
| Best fit               | Large, sustained, predictable enterprise database workloads | Smaller deployments, elastic workloads, DR, testing, and granular scaling |
| Licensing              | License included or BYOL                                    | License included or BYOL                                                  |
| DR economics           | High infrastructure floor even at low utilization           | Better suited to standby or intermittently activated environments         |

> The 16-OCPU Dedicated example and the 16-ECPU Exascale example are not performance-equivalent. OCPUs and ECPUs should not be compared as though they provide identical compute capacity.

---

# 10. Approximate cost comparison

| Example configuration                          | License included |          BYOL |
| ---------------------------------------------- | ---------------: | ------------: |
| Dedicated minimum infrastructure plus 16 OCPUs |    $36,899/month | $24,968/month |
| Exascale example with 16 ECPUs                 |     $4,477/month |  $1,495/month |
| Approximate monthly difference                 |          $32,422 |       $23,473 |

The difference is primarily caused by the Dedicated model’s fixed database-server and storage-server infrastructure floor.

For a DR workload that:

* Runs at reduced capacity,
* Is activated primarily for testing or failover,
* Does not require a full dedicated engineered system at all times,

Exascale may provide a materially lower entry cost.

Dedicated Infrastructure may remain appropriate where:

* The workload requires consistent dedicated capacity,
* Production and DR systems must have closely matched configurations,
* Sustained high compute or storage throughput is required,
* Licensing or operational standards favor Dedicated Exadata,
* The Oracle design requires features or configurations unavailable on Exascale.

---

# 11. Costs outside the Oracle pricing table

The Oracle infrastructure estimate should not be treated as the complete BART DR cost.

## Azure networking

Account separately for:

* Azure Virtual WAN hub charges
* ExpressRoute gateway scale units
* VPN gateway scale units
* ExpressRoute circuits, where applicable
* Azure Firewall or NVA processing
* VNet peering
* Inter-region Azure transfer
* Private endpoints and private DNS
* Route-processing or secured-hub charges

## Database protection

Account for:

* Data Guard standby database compute
* Standby storage
* Backup storage
* Autonomous Recovery Service or OCI Object Storage
* Azure-based backup repositories, where used
* Backup retention and restore testing
* Additional Data Guard broker or observer infrastructure

## Operations and security

Account for:

* Azure Monitor metrics
* Diagnostic log ingestion
* Log Analytics retention
* Microsoft Sentinel ingestion and analytics
* Key management
* Vulnerability-management tooling
* Oracle and Microsoft support arrangements
* DR testing and operational labor

## Application recovery

Account for:

* Application-tier compute in AVS or native Azure
* DNS and application endpoint redirection
* Load balancers or Application Gateway
* Firewall-rule changes
* Recovery automation
* Validation and business testing

---

# 12. BART architectural implications

## Region selection

East US is already represented as the principal DR region in the broader BART architecture. Based on the region information captured in this chat, East US supports both Dedicated and Exascale and provides dual-zone Oracle service coverage.

The architecture team should nevertheless confirm:

* Exact Exadata service and generation
* Physical-zone availability
* Capacity reservation
* OCI Ashburn-region subscription
* BART data-residency requirements
* Database licensing position
* Data Guard source and target regions

## Service-model decision

The key commercial decision is not simply “Exadata in Azure.” It is:

```text
Dedicated Exadata Infrastructure
versus
Exadata Exascale Infrastructure
```

The selection changes:

* Monthly infrastructure floor
* Compute billing unit
* Storage billing method
* Scaling granularity
* DR standby economics
* Capacity-reservation requirements
* Licensing treatment
* Expected recovery performance

## Network integration

The Exadata delegated subnet must be incorporated into the BART routing architecture and made reachable from:

* AVS workload networks
* Azure management services
* BART administrative networks
* Required on-premises systems
* Monitoring and security services

Routing must be symmetric. Azure NSGs and Oracle-side security controls should be governed as one logical policy set. The Oracle technical guide recommends coordinated infrastructure as code because inconsistent Azure and OCI security policies can create difficult-to-diagnose connectivity failures.

## Operational boundary

The BART team should document:

* Which incidents begin with Oracle Support
* Which issues are owned by Microsoft
* Which configuration layers are owned by BART
* How cross-vendor Severity 1 incidents are coordinated
* Who controls Data Guard operations
* Who owns the database failover decision
* Who updates application connection strings, DNS, or service endpoints
* How database recovery is coordinated with AVS and JetStream recovery

---

# 13. Recommended decision record

Before completing the detailed architecture, record the following decisions:

| Decision                     | Required value                                    |
| ---------------------------- | ------------------------------------------------- |
| Target Azure region          | East US or alternate supported region             |
| Oracle service model         | Dedicated or Exascale                             |
| Exadata generation/shape     | Confirmed Oracle-supported configuration          |
| Licensing model              | License included, BYOL, or ULA treatment          |
| OCI tenancy                  | Existing or new                                   |
| Associated OCI region        | Confirmed and subscribed                          |
| Production database location | Region and platform                               |
| DR database location         | Region and service                                |
| Data Guard mode              | Performance, Availability, or Protection          |
| Initial DR compute size      | OCPUs or ECPUs                                    |
| DR storage requirement       | Usable database, filesystem, and backup capacity  |
| Recovery objectives          | RPO and RTO                                       |
| Replication route            | Azure path, OCI path, or approved design          |
| Capacity reservation         | Confirmed with Oracle                             |
| Support model                | Oracle-first escalation and Microsoft handoff     |
| Runbook ownership            | Oracle Consulting, BART, and Quisitive boundaries |
| Testing frequency            | Initial acceptance plus recurring exercises       |

---

# 14. Source references

* [Oracle AI Database@Azure pricing](https://www.oracle.com/cloud/azure/oracle-database-at-azure/pricing/)
* [Oracle regional availability](https://docs.oracle.com/en-us/iaas/Content/database-at-azure/oaa_regions.htm)
* [Microsoft region availability](https://learn.microsoft.com/en-us/azure/oracle/oracle-db/oracle-database-regions)
* Oracle Exadata implementation and architecture guide used for project context:
* BART Azure Disaster Recovery Deployment Services agreement and scope:
