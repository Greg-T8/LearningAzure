# JetStream DR for Azure VMware Solution: Hybrid Technical Guide

## 1. Purpose and Architecture Context

JetStream disaster recovery changes the traditional “Noah’s Ark” disaster recovery model by avoiding a fully mirrored, always-on secondary data center. Instead of paying continuously for duplicate compute and storage, JetStream stores continuously replicated recovery data in Azure Blob Storage and allows recovery compute in Azure VMware Solution (AVS) to be provisioned or used when recovery is required. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)

* **Traditional model:** Enterprises often build an identical standby data center with duplicate hardware, cooling, power, compute, and storage.
* **Cost issue:** The standby site depreciates and consumes budget while remaining idle most of the time.
* **JetStream model:** JetStream decouples protected data from recovery compute by continuously writing replicated changes to Azure Blob Storage. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)
* **Primary benefit:** Organizations can design for a very low recovery point objective (RPO) without maintaining a fully powered secondary AVS cluster. [Business continuity and disaster recovery for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/business-continuity-disaster-recovery)

> **Documentation correction:** “Near-zero RPO” is a design target rather than a guaranteed Microsoft service-level objective. Actual RPO depends on JetStream configuration, source write rate, connectivity, storage performance, and replication health.

## 2. Azure VMware Solution Foundation

Azure VMware Solution is not nested virtualization. It runs the VMware software-defined data center stack on dedicated bare-metal hosts in Microsoft Azure datacenters. [What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)

* **Platform model:** Microsoft provides and manages the physical AVS bare-metal hosts. [Shared responsibility matrix for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/shared-responsibility)
* **Managed stack:** Microsoft operates the AVS service infrastructure, including the deployed VMware management stack and host lifecycle; the exact division of responsibilities is defined in the AVS shared-responsibility matrix. [Shared responsibility matrix for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/shared-responsibility)
* **Customer responsibility:** The customer manages guest operating systems, applications, data, and workload-level configuration for virtual machines running on AVS. [Shared responsibility matrix for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/shared-responsibility)
* **Operational benefit:** Customers retain familiar VMware technologies and vCenter-based workflows while integrating with Azure services. [What is Azure VMware Solution?](https://learn.microsoft.com/en-us/azure/azure-vmware/introduction)

> **Documentation correction:** Microsoft manages the AVS service and infrastructure, but responsibility is not accurately summarized as “the customer manages only the virtual machines.” Identity, networking, guest security, data protection, applications, and several operational controls remain shared or customer responsibilities. [Shared responsibility matrix for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/shared-responsibility)

## 3. JetStream Core Architecture

JetStream is built around continuous data protection (CDP). Instead of relying only on periodic snapshots, it captures VM write I/O through VMware’s vSphere APIs for I/O filtering, commonly referred to as VAIO. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery) [I/O Filter Manager](https://developer.broadcom.com/xapis/vsphere-web-services-api/latest/vim.IoFilterManager.html)

* **Snapshot-based DR behavior:** A snapshot captures a point-in-time state and, when used as a recovery mechanism, the possible data-loss interval is related to the time between usable recovery points.
* **Snapshot limitation:** If recovery points are created hourly and a disaster occurs at minute 59 after the last successful point, up to 59 minutes of changes can be outside that recovery point.
* **CDP behavior:** JetStream captures and replicates write changes continuously rather than waiting for a scheduled snapshot interval. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)
* **Transcript-derived analogy:** Snapshot DR is like a camera that takes one photo per hour; JetStream CDP is like a continuous video feed.
* **Performance design:** JetStream uses vSphere I/O filters installed at the ESXi layer rather than requiring an agent in every protected guest. [I/O Filter Manager](https://developer.broadcom.com/xapis/vsphere-web-services-api/latest/vim.IoFilterManager.html)
* **Why it matters:** Hypervisor-level I/O filtering avoids deploying and maintaining a replication agent inside each protected guest.

> **Architectural interpretation:** Avoiding guest agents can reduce guest-level deployment, compatibility, and maintenance work. The stronger claims that this categorically eliminates reboots, antivirus conflicts, or guest CPU overhead were not directly confirmed in the reviewed Microsoft or Broadcom documentation.

## 4. JetStream Components

JetStream uses separate management and replication components. Microsoft’s AVS deployment guidance identifies the JetStream management server appliance, DR virtual appliances, host components, and protected domains used to configure and operate protection. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)

| Component | Role | Key behavior |
| --- | --- | --- |
| Management Server Appliance (MSA) | Control plane | Manages JetStream configuration and recovery operations and provides the vCenter-integrated management experience. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery) |
| DR Virtual Appliance (DRVA) | Data plane | Receives protected write data and transfers the replication stream toward the configured Azure Blob Storage destination. The transcript also states that the DRVA can optionally compress and encrypt payloads. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery) |
| ESXi host filter packages / VIBs | I/O capture layer | Use the vSphere I/O filtering framework to capture protected write I/O at the hypervisor layer. [I/O Filter Manager](https://developer.broadcom.com/xapis/vsphere-web-services-api/latest/vim.IoFilterManager.html) |
| Protected domain | Logical grouping | Groups protected VMs for policy and recovery management and associates the protected data with JetStream storage configuration. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery) |

* **MSA behavior:** The MSA orchestrates JetStream management functions; replicated payload data is handled by the DRVAs rather than being routed through the MSA. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)
* **DRVA behavior:** The DRVA moves replicated data toward the configured Azure Blob Storage account. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)
* **Host filter behavior:** The host filters participate in I/O capture and maintain protection as VMs operate within the supported vSphere environment. [I/O Filter Manager](https://developer.broadcom.com/xapis/vsphere-web-services-api/latest/vim.IoFilterManager.html)
* **Protected domain behavior:** Protected domains provide the logical unit for grouping VMs and applying JetStream protection and recovery configuration. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)

> **Not directly supported by the reviewed documentation:** The reviewed official sources did not explicitly confirm that every protected domain maps one-to-one to a single Azure Blob container instance; that the host filters specifically track every listed event—vMotion, Storage vMotion, and snapshots—in the manner stated in the transcript; or that DRVA compression and encryption behave exactly as described. Validate these details against the release-specific JetStream administration guide.

### Fault-domain implication

* **If the MSA fails:** The transcript states that replication can continue because the DRVAs and host filters operate independently.
* **Operational benefit:** Maintenance or reboot of the MSA is therefore expected not to stop an already-running replication stream.
* **Scaling model:** Add more DRVAs when VM count or I/O churn increases; DRVA sizing should be based on protected workload scale and change rate. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)
* **Capacity planning requirement:** AVS sizing must include the compute and memory consumed by the MSA and DRVAs in addition to the AVS management appliances and protected workloads. [Azure VMware Solution private clouds and clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/concepts-private-clouds-clusters)

> **Not directly supported by the reviewed documentation:** The MSA-failure continuity behavior above was not explicitly confirmed in the reviewed official Microsoft or Broadcom documentation. Validate it against the JetStream release-specific administration guide and support statement before using it as a fault-tolerance guarantee.

## 5. Azure Landing Zone Prerequisites

Before deploying JetStream, prepare the Azure landing zone, AVS private cloud, storage, DNS, and appliance network. Microsoft’s deployment article lists prerequisites and the AVS Run Command workflow for the JetStream installation. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)

> **Transcript-derived operational observation:** The transcript attributes many deployment failures to storage, DNS, networking, or workload-compatibility mistakes. The reviewed documentation confirms these as important prerequisites but does not quantify them as the most common causes of failure.

### Storage account requirements

* **Requirement:** Create an Azure Storage account to hold JetStream replication data. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)
* **Account configuration:** Follow the storage-account type, performance, redundancy, and networking settings stated in the current JetStream deployment article rather than choosing a tier solely from a generalized performance assumption. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)
* **Access tier:** Use the hot access tier when required by the JetStream deployment procedure; Azure documents the hot tier as optimized for data that is accessed or modified frequently. [Access tiers for blob data](https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview)
* **Limitation:** Do not enable hierarchical namespace when the JetStream deployment prerequisites require a conventional Blob Storage namespace. [Azure Data Lake Storage hierarchical namespace](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-namespace)
* **Why it matters:** Enabling hierarchical namespace changes Blob Storage namespace semantics and supported feature behavior. [Azure Data Lake Storage hierarchical namespace](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-namespace)
* **Transcript-derived rationale:** JetStream expects a flat object-storage structure for its CDP log format, and enabling hierarchical namespace can break its use of Blob Storage as a raw, high-speed object store.
* **Failure condition:** A storage account that does not meet the product’s documented prerequisites can prevent successful JetStream configuration or operation. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)

> **Documentation correction:** The transcript’s statement “use standard or premium based on required write speed and recovery speed” is too broad. Use only the storage account configurations explicitly supported by the current JetStream-for-AVS deployment documentation; Azure Blob performance tiers are not interchangeable by default. [Premium block blob storage accounts](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-block-blob-premium)

### DNS requirements

Azure DNS or an integrated enterprise DNS design must resolve the AVS, JetStream, and storage endpoints required by the deployment. AVS supports configured DNS forwarding and name-resolution integration with Azure and on-premises environments. [Configure DNS forwarding for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution)

* AVS vCenter Server must resolve correctly for management and appliance integration. [Configure DNS forwarding for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution)
* Individual AVS ESXi host names must resolve where the JetStream workflow or supporting services require host-level name resolution. [Configure DNS forwarding for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/configure-dns-azure-vmware-solution)
* Azure Storage account endpoints must resolve correctly from the JetStream appliance network. [Azure Storage endpoints](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview#storage-account-endpoints)
* The JetStream MSA name must resolve where it is referenced by vCenter, DRVAs, operators, or automation.
* The external JetStream Marketplace service named in the transcript must resolve correctly when it is required by the selected deployment or licensing workflow, and the endpoint must be permitted by egress controls. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)
* **Failure condition:** If DRVAs cannot resolve or reach the configured Blob Storage endpoint, they cannot send replication traffic to that endpoint.

> **Operational recommendation:** Validate forward and reverse lookup behavior, required private endpoints or service endpoints, routing, TLS inspection exceptions, and outbound firewall policy from the actual JetStream appliance subnet before enabling protection. Azure Private DNS Resolver can provide managed inbound and outbound DNS forwarding when the landing zone uses Azure-native hybrid name resolution. [What is Azure DNS Private Resolver?](https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview)

### Network segment requirements

* **Requirement:** Configure an NSX-T network segment in the AVS private cloud for the JetStream appliances and any transient recovery appliances required by the workflow. [Create an NSX-T Data Center network segment in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)
* **Purpose:** The segment provides Layer 2 attachment and routed reachability for JetStream appliance traffic according to the AVS network design. [Create an NSX-T Data Center network segment in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)
* **DHCP option:** The JetStream AVS Run Command package includes a DHCP-based installation path where supported by the selected network configuration. [Run commands in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/run-command)
* **Static IP option:** The package also provides a static-address installation path for environments that require fixed appliance addressing. [Run commands in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/run-command)
* **Security implication:** Static IP addresses can simplify deterministic firewalling, auditing, logging correlation, operational inventory, and threat-hunting visibility.

> **Architectural interpretation:** Static addressing is often preferred in tightly governed enterprise landing zones, but that preference is an operational design choice rather than a universal Microsoft requirement.

### Supported topologies

Microsoft documents JetStream as a disaster-recovery option for VMware environments that use AVS as a recovery platform. [Business continuity and disaster recovery for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/business-continuity-disaster-recovery)

| Topology | Description | Blob Storage role |
| --- | --- | --- |
| On-premises VMware to AVS | A supported on-premises vSphere environment protects workloads for recovery into AVS. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery) | Stores the replicated JetStream recovery data used to materialize workloads at the recovery site. |
| AVS region to AVS region | One supported AVS private cloud protects workloads for recovery into another AVS private cloud in a different Azure region. [Business continuity and disaster recovery for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/business-continuity-disaster-recovery) | Stores the replicated CDP data between the protected and recovery environments. |

> **Documentation correction:** Azure Blob Storage is part of the replication and recovery-data path, but calling it merely an “intermediary holding area” understates its role as the persistent recovery-data repository in the JetStream design.

### Workload limitation

* **Limitation:** The transcript states that JetStream does not support workloads using shared disks.
* **Example:** Legacy Windows Server Failover Cluster workloads using shared VMDKs are therefore outside the stated support boundary.
* **Reason given in transcript:** SCSI bus sharing prevents the JetStream VAIO filters from safely intercepting and locking shared I/O traffic without risking corruption.
* **Operational recommendation:** Use an application-aware availability or disaster-recovery pattern for these workloads. For SQL Server, SQL Server Always On Availability Groups provide database-level replication without requiring a shared storage disk for the availability databases. [Overview of Always On availability groups](https://learn.microsoft.com/en-us/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server)

> **Not directly supported by the reviewed documentation:** The reviewed official sources did not directly confirm the transcript’s shared-disk prohibition or its stated SCSI-bus-sharing rationale. Confirm the exact limitation against the current JetStream compatibility matrix before final workload selection.

## 6. AVS Installation Method

JetStream installation on AVS differs from installation on customer-managed vSphere because AVS customers do not receive ESXi root access. AVS exposes a constrained administrative model and Microsoft-managed Run Command packages for supported host-level operations. [Access and identity concepts for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/concepts-identity) [Run commands in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/run-command)

* **On-premises VMware model:** In a customer-managed vSphere environment, an administrator with the required ESXi privileges can use supported host-administration methods, including direct VIB installation where the product procedure permits it.
* **AVS model:** The customer commonly operates through the `cloudadmin` role and cannot directly make unrestricted host-level changes. [Access and identity concepts for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/concepts-identity)
* **Reason:** Microsoft controls the AVS host and service lifecycle to preserve the managed-service support boundary. [Shared responsibility matrix for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/shared-responsibility)
* **Mechanism:** The supported AVS installation workflow uses Azure Portal Run Command. [Run commands in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/run-command)
* **Run Command package:** The JetStream package is exposed through the AVS Run Command catalog; use the package and cmdlet names displayed in the current portal and Microsoft documentation. [Run commands in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/run-command)

> **Documentation correction:** The transcript names the package as `JSDR.configuration` and gives the command names `invoke preflight jet drinstall`, `install jetdr with DHCP`, `install jetdr with static IP`, and `enable JetDR for cluster`. Package and cmdlet capitalization, spacing, and spelling are release-sensitive. Treat the current Azure Portal Run Command catalog and the current JetStream deployment article as authoritative rather than copying transcript spellings into automation. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)

### Installation workflow

1. **Run the pre-flight check.**

   * Use the JetStream pre-flight Run Command shown in the current package. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)
   * The pre-flight workflow validates the supplied AVS and JetStream deployment inputs before host changes are made.
   * It validates the target cluster and the inputs required to deploy the JetStream appliances.
   * It checks naming and environment prerequisites described by the package.

   > **Not directly supported by the reviewed documentation:** The exact transcript assertions that the pre-flight command checks “at least three hosts” and verifies every planned appliance VM name for uniqueness were not independently confirmed in the reviewed source set. Use the command output and current package documentation as the authoritative validation list.

2. **Run the installation command.**

   * Use the DHCP installation path when the supported segment and operating model provide DHCP.
   * Use the static IP installation path when fixed addressing is required.
   * The static installation workflow requires values such as the protected cluster, appliance datastore, NSX-T segment, IP addressing, DNS, hostname, and appliance credentials. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)
   * Typical static inputs include:

     * Protected cluster name.
     * Datastore name for the MSA appliance.
     * NSX-T network segment name.
     * MSA IP address.
     * Netmask or prefix information requested by the package.
     * Default gateway.
     * Primary DNS server IP.
     * Appliance hostname.
     * Root credential password.

3. **Enable JetDR for the cluster.**

   * Run the package cmdlet that enables JetStream for the selected cluster. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)
   * This step activates the cluster-side JetStream integration required for protection.
   * The workflow installs or enables the supported host components through the Microsoft-managed mechanism.
   * It makes the JetStream storage policies and integration available in vCenter where documented by the package.

4. **Move to vCenter for day-two configuration.**

   * Open the JetStream vCenter integration.
   * Add the supported Azure Blob Storage configuration and credentials.
   * Deploy and size DRVAs.
   * Create protected domains and assign eligible VMs. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)

> **Operational recommendation:** Record the exact package version, cmdlet names, parameters, and command output used during deployment. Run Command packages can evolve independently of static design documents.

## 7. Recovery Behavior and RTO Engineering

JetStream is designed to keep replicated recovery data current through CDP. Recovery time objective (RTO), however, depends on how quickly protected data can be made available to the recovery vSphere environment and how quickly the required VMs and application dependencies can start. [Business continuity and disaster recovery for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/business-continuity-disaster-recovery)

* **RPO behavior:** Continuous replication can reduce the recovery-point interval relative to periodic snapshot-only designs, subject to replication health and backlog.
* **RTO dependency:** Azure Blob Storage is object storage and is not itself a vSphere datastore from which AVS virtual machines boot. [Introduction to Azure Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction)
* **Rehydration requirement:** JetStream must materialize protected VM data onto storage that the target vSphere environment can use for recovery. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)
* **RTO bottlenecks:** Recovery speed can be constrained by Blob read throughput, network throughput and latency, target-datastore performance, JetStream appliance sizing, dependency sequencing, and simultaneous VM startup.

> **Architectural interpretation:** These are engineering variables, not a Microsoft-published RTO formula. Validate them through a recovery test that uses representative data volume, churn, network conditions, and application dependencies.

### Storage target options

AVS provides a native vSAN datastore and supports selected Azure external-storage integrations. [Storage concepts for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/concepts-storage)

| Recovery target | Advantage | Limitation |
| --- | --- | --- |
| Internal vSAN | Native datastore included with an AVS private cloud cluster. [Storage concepts for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/concepts-storage) | Usable capacity and performance scale with the AVS host and cluster design. |
| Azure NetApp Files (ANF) | Supported NFS datastore integration can add storage independently of AVS host-local vSAN capacity. [Attach Azure NetApp Files datastores to Azure VMware Solution hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts) | Requires a supported regional, networking, delegation, capacity-pool, and volume configuration. |
| Azure Elastic SAN | Where supported for AVS, external datastore capacity can be provisioned separately from AVS compute. [Use Azure Elastic SAN with Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-elastic-san-datastore) | Availability, support status, region, protocol, and design requirements must be validated for the target deployment. |

* **Why external storage matters:** Increasing native vSAN capacity generally requires scaling the AVS cluster or selecting a host/storage design with more capacity; supported external datastores can decouple part of the storage growth from AVS compute growth. [Scale clusters in an Azure VMware Solution private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/scale-private-cloud-cluster)
* **Cost implication:** External storage can avoid adding AVS hosts solely to satisfy some storage-capacity requirements, although external storage and networking introduce their own cost and performance considerations.
* **Operational recommendation:** For a large recovery event, test whether ANF, Elastic SAN, or the native vSAN datastore meets the required recovery throughput, capacity, protocol, and support constraints before selecting the landing datastore.

> **Documentation correction:** The transcript states that recovery can rehydrate to “VMFS, vSAN, or external storage.” In AVS, use only datastores exposed through supported AVS configurations. Azure Blob Storage is not directly mounted as a VMFS or vSAN datastore. [Storage concepts for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/concepts-storage)

> **Documentation correction:** The transcript states that ANF is attached “via ExpressRoute FastPath directly to ESXi hosts as an NFS datastore.” Microsoft documents the supported AVS-to-ANF datastore attachment workflow and its network prerequisites; use that documented integration rather than treating a customer-configured FastPath route as the universal attachment mechanism. [Attach Azure NetApp Files datastores to Azure VMware Solution hosts](https://learn.microsoft.com/en-us/azure/azure-vmware/attach-azure-netapp-files-to-azure-vmware-solution-hosts)

## 8. Ransomware Recovery

Ransomware recovery can benefit from CDP because granular recovery points may allow recovery to a point immediately before malicious encryption or destructive changes began. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)

* **Transcript-derived scenario:** If encryption began at 2:12:30 a.m., the operator selects 2:12:29 a.m. as the desired recovery point.
* **Value:** A sufficiently granular and healthy CDP history can reduce the amount of legitimate activity lost compared with reverting to a substantially older recovery point.
* **Risk:** A recovered VM should not be reconnected automatically to the production network until the recovery point and workload are validated.
* **NSX-T isolation:** AVS NSX-T segments and gateway controls can be used to create an isolated recovery network. [Create an NSX-T Data Center network segment in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)
* **Quarantine model:** Recovered VMs can be attached to an isolated segment that permits only the communications required for validation and forensics.
* **Operational use:** Security, forensics, and incident-response teams can inspect, clean, and validate systems before controlled reconnection.

> **Operational recommendation:** Treat network isolation, identity isolation, credential reset, malware scanning, and application validation as explicit recovery-runbook stages. Segment isolation alone does not establish that a recovered workload is safe.

> **Documentation correction:** Replicated data in Blob Storage is not automatically “immutable” merely because JetStream writes it there. Azure Blob immutability requires a supported time-based retention policy or legal hold, and the effect of those controls on JetStream write and cleanup operations must be validated before enabling them. [Immutable storage for blob data](https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview)

## 9. Key Calculations and Numerical Examples

### Snapshot data-loss example

> **Transcript-derived calculation:**

| Item | Value |
| --- | --- |
| Inputs | Recovery-point interval = 60 minutes; disaster occurs 59 minutes after the last successful recovery point. |
| Formula | Theoretical data outside the last recovery point = elapsed time since that recovery point. |
| Result | 59 minutes. |
| Practical interpretation | An hourly recovery-point design can leave nearly one hour of changes outside the most recent completed point. |
| Factors affecting real result | Recovery-point completion time, replication lag, application consistency, transaction rate, retention, and the availability of later crash-consistent or application-consistent points. |

The arithmetic is `59 minutes − 0 minutes = 59 minutes`. This is a scenario calculation, not a Microsoft-published JetStream guarantee.

### Host-count lifecycle example

> **Transcript-derived calculation:**

| Item | Value |
| --- | --- |
| Inputs | Transcript baseline = three-host AVS cluster; transcript upgrade assumption = one host must be available for maintenance-mode evacuation. |
| Formula | Theoretical host count during the stated maintenance scenario = baseline hosts + one additional host. |
| Result | Four hosts under the stated assumptions. |
| Practical interpretation | A minimum-size cluster might require temporary scale-out if the JetStream lifecycle procedure cannot proceed while preserving required capacity and availability. |
| Factors affecting real result | AVS generation and host SKU, current Microsoft minimums, vSAN free capacity, storage policy, failure-to-tolerate settings, workload utilization, maintenance behavior, and the current JetStream upgrade procedure. |

AVS cluster scaling is performed through the supported AVS scale workflow. [Scale clusters in an Azure VMware Solution private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/scale-private-cloud-cluster)

> **Not directly supported by the reviewed documentation:** The reviewed official sources did not establish a universal JetStream rule that every upgrade requires exactly four hosts. Treat four as the transcript’s scenario result, not a generally applicable platform specification.

## 10. Limitations, Gotchas, and Support Boundaries

### Host count and lifecycle management

* **Baseline:** AVS cluster minimums and supported scale units depend on the current service architecture, generation, region, and host offering; use the current AVS cluster documentation rather than assuming that three hosts applies to every deployment. [Azure VMware Solution private clouds and clusters](https://learn.microsoft.com/en-us/azure/azure-vmware/concepts-private-clouds-clusters)
* **Upgrade gotcha:** The transcript states that JetStream upgrades require a minimum of four hosts because ESXi hosts must enter maintenance mode.
* **Operational implication:** Under that scenario, a customer operating at the minimum host count may need temporary scale-out before the upgrade. [Scale clusters in an Azure VMware Solution private cloud](https://learn.microsoft.com/en-us/azure/azure-vmware/scale-private-cloud-cluster)
* **Recommendation:** Forecast temporary-host cost, quota, lead time, capacity headroom, and the scale-in plan during design rather than on upgrade day.

> **Not directly supported by the reviewed documentation:** A universal “four hosts required for JetStream lifecycle upgrades” rule was not confirmed. Validate the requirement against the installed JetStream release, AVS generation, cluster health, and the current Microsoft Run Command package.

### Stretched cluster limitation

* **Limitation:** The transcript states that JetStream is unsupported in AVS stretched clusters.
* **Reason given:** Stretched vSAN relies on synchronous cross-availability-zone storage behavior, while JetStream provides I/O-filter-based point-in-time disaster recovery.
* **Architecture decision:** The transcript therefore treats stretched-cluster high availability and JetStream CDP-based disaster recovery as mutually exclusive for the same protected cluster.

AVS stretched clusters are a distinct architecture that spans availability zones and uses a vSAN stretched-cluster design. [Deploy stretched clusters in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-stretched-clusters)

> **Not directly supported by the reviewed documentation:** The reviewed Microsoft stretched-cluster documentation did not by itself establish the transcript’s JetStream support prohibition or the stated technical rationale. Confirm JetStream, Zerto, VMware Live Site Recovery/Site Recovery Manager, and other replication products independently against their current AVS stretched-cluster support matrices; do not infer one product’s limitation from another product’s architecture.

### Support boundaries

Third-party disaster-recovery software running on AVS has a shared support path: Microsoft supports the Azure and AVS service boundary, while the software vendor supports its product behavior and product-specific configuration. [Shared responsibility matrix for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/shared-responsibility)

| Issue type | Primary support path |
| --- | --- |
| Azure Run Command or Azure portal execution failure | Microsoft support for the AVS service workflow; involve JetStream when package-specific diagnostics indicate a product issue. [Run commands in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/run-command) |
| JetStream configuration issue | JetStream support. |
| Replication failure to Blob Storage | JetStream support first; Microsoft support may be required when evidence points to Azure Storage, DNS, networking, or AVS service behavior. |
| Protected-domain synchronization failure | JetStream support. |
| JetStream software performance or operational issue | JetStream support, with Microsoft engaged when the investigation identifies an AVS or Azure dependency. |

* **Microsoft boundary:** Microsoft does not own third-party JetStream software defects or product-specific configuration, but Microsoft remains responsible for supported Azure and AVS service components within the documented shared-responsibility boundary. [Shared responsibility matrix for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/shared-responsibility)
* **JetStream AVS support channel:** The transcript gives `supportavs@jetstreamsoft.com`.
* **Operational recommendation:** Include both vendor escalation paths, entitlement details, deployment version, diagnostic-collection steps, and severity criteria in handover documentation.

> **Not directly supported by the reviewed documentation:** The specific email address above was present in the transcript but was not independently validated in the reviewed official sources. Confirm it through the current JetStream support portal or contract documentation before operational use.

## Architecture Summary

JetStream for AVS uses AVS as the VMware platform, vSphere I/O filters for continuous write capture, DRVAs for replication data movement, and Azure Blob Storage as the recovery-data destination. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)

1. Production VM write I/O occurs on the protected vSphere or AVS environment.
2. JetStream host I/O filters capture protected write changes at the hypervisor layer. [I/O Filter Manager](https://developer.broadcom.com/xapis/vsphere-web-services-api/latest/vim.IoFilterManager.html)
3. DRVAs receive and transfer the replicated changes to the configured Azure Blob Storage account. [Deploy JetStream DR software for Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/deploy-jetstream-disaster-recovery)
4. The MSA manages configuration, health, protected domains, and recovery workflows.
5. During recovery, JetStream materializes protected data from Blob Storage onto a supported datastore available to the target vSphere environment.
6. Workloads start in the recovery AVS environment and can be attached to an isolated NSX-T segment for validation. [Create an NSX-T Data Center network segment in Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/tutorial-nsx-t-network-segment)

## Final Result

JetStream replaces part of the duplicate standby-infrastructure model with continuous replication, Azure Blob Storage, and recovery compute in AVS. The architecture is strongest when the landing zone is prepared correctly and the design validates supported storage-account settings, DNS, NSX-T networking, appliance capacity, workload compatibility, recovery-datastore throughput, lifecycle headroom, and vendor support boundaries.

## Documentation and Interpretation Notes

* **Material documentation corrections:** “Near-zero RPO” is a design target rather than a Microsoft SLA; AVS responsibility is shared rather than limited to customer-managed VMs; Blob Storage is not directly bootable as a vSphere datastore; Blob data is not automatically immutable; and supported JetStream storage-account settings must come from the current deployment documentation rather than a generic standard-versus-premium rule.
* **Claims remaining unsupported after targeted review:** Exact MSA-failure replication continuity, one-container-per-protected-domain behavior, detailed event tracking by host filters, the shared-disk prohibition and stated SCSI rationale, a universal four-host upgrade minimum, the JetStream stretched-cluster prohibition, and the transcript-provided support email require release-specific JetStream validation.
* **Combined or easily confused patterns:** Native AVS vSAN, ANF datastores, Azure Elastic SAN datastores, and Azure Blob Storage serve different roles; Blob is the JetStream recovery-data repository, whereas recovery workloads must ultimately use a supported vSphere datastore.
* **Important interpretations and recommendations:** Size MSA and DRVA overhead, test recovery throughput rather than inferring RTO, validate DNS and egress from the appliance segment, isolate ransomware recovery networks, and record the exact Run Command package version and parameters used in deployment.
