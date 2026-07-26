Source: 

# Jetstream DR for Azure VMware Solution: Hybrid Technical Guide

## 1. Purpose and Architecture Context

Jetstream disaster recovery changes the traditional “Noah’s Ark” disaster recovery model by avoiding a fully mirrored, always-on secondary data center. Instead of paying continuously for duplicate compute and storage, Jetstream streams changes into Azure Blob storage and uses compute only when recovery is required.

* **Traditional model:** Enterprises often build an identical standby data center with duplicate hardware, cooling, power, compute, and storage.
* **Cost issue:** The standby site depreciates and consumes budget while remaining idle most of the time.
* **Jetstream model:** Jetstream decouples protected data from recovery compute by continuously writing replicated changes to Azure Blob storage.
* **Primary benefit:** Organizations can target near-zero recovery point objective (RPO) without maintaining a fully powered secondary AVS cluster.

## 2. Azure VMware Solution Foundation

Azure VMware Solution (AVS) is not nested virtualization. It runs VMware software on dedicated bare-metal hosts inside Microsoft Azure data centers.

* **Platform model:** Microsoft provides and manages the physical AVS bare-metal hosts.
* **Managed stack:** Microsoft manages vCenter Server, ESXi, vSAN, NSX, patching, and hardware failures.
* **Customer responsibility:** The customer manages only the virtual machine workloads running on top of the AVS platform.
* **Operational benefit:** Customers retain familiar VMware tools, vCenter workflows, and existing operational runbooks while gaining Azure scale and automation.

## 3. Jetstream Core Architecture

Jetstream is built around continuous data protection (CDP). Instead of taking periodic snapshots, it captures disk writes continuously through the VMware vSphere API for I/O filtering framework, commonly referred to as VAIO.

* **Snapshot-based DR behavior:** A snapshot captures a point-in-time disk state at scheduled intervals.
* **Snapshot limitation:** If snapshots run hourly and a disaster occurs at minute 59, up to 59 minutes of data can be lost.
* **CDP behavior:** Jetstream captures writes in real time, block by block, as they occur.
* **Transcript-derived analogy:** Snapshot DR is like a camera that takes one photo per hour; Jetstream CDP is like a continuous video feed.
* **Performance design:** Jetstream uses VMware’s VAIO framework at the ESXi hypervisor layer rather than in-guest VM agents.
* **Why it matters:** Hypervisor-level I/O filtering avoids guest OS agents, reboots, antivirus conflicts, and guest CPU overhead.

## 4. Jetstream Components

Jetstream uses separate control-plane and data-plane components. This separation is central to its resilience and scalability.

| Component                         | Role              | Key Behavior                                                                                                            |
| --------------------------------- | ----------------- | ----------------------------------------------------------------------------------------------------------------------- |
| Management Server Appliance (MSA) | Control plane     | Manages configuration, monitoring, protection domains, recovery workflows, and vCenter plugin integration.              |
| DR Virtual Appliance (DRVA)       | Data plane        | Receives replicated I/O, maintains logs, optionally compresses/encrypts payloads, and sends data to Azure Blob storage. |
| ESXi host filter packages / VIBs  | I/O capture layer | Install on ESXi hosts and use VAIO to capture write I/O and track vSphere events.                                       |
| Protected domain                  | Logical grouping  | Groups VMs with common SLA, runbook, and Blob container placement.                                                      |

* **MSA behavior:** The MSA orchestrates Jetstream but does not carry replication payload data.
* **DRVA behavior:** The DRVA moves the replicated data to the Azure Blob storage account.
* **Host filter behavior:** Filters track vMotion, Storage vMotion, snapshots, and other vSphere events so replication continuity is maintained.
* **Protected domain behavior:** All VMs in a protected domain store their replicated data in the same Azure Blob container instance.

### Fault-domain implication

* **If the MSA fails:** Replication can continue because the DRVAs and host filters operate independently.
* **Operational benefit:** Maintenance or reboot of the MSA should not directly stop the continuous replication stream.
* **Scaling model:** Add more DRVAs when VM count or I/O churn increases.
* **Capacity planning requirement:** AVS sizing must include MSA and DRVA CPU and memory overhead in addition to normal AVS management overhead.

## 5. Azure Landing Zone Prerequisites

Before deploying Jetstream, the Azure landing zone must be prepared carefully. Most deployment failures described in the transcript come from storage, DNS, networking, or workload compatibility mistakes.

### Storage account requirements

* **Requirement:** Create an Azure Storage account as the destination for Jetstream replication data.
* **Performance tier:** Use standard or premium based on required write speed and recovery speed.
* **Access tier:** Use the hot access tier because Jetstream continuously writes data.
* **Limitation:** Do not enable hierarchical namespace.
* **Why it matters:** Jetstream expects a flat object storage structure for its CDP log format.
* **Failure condition:** Enabling hierarchical namespace can break Jetstream’s interaction with Blob storage as a raw high-speed object store.

### DNS requirements

Azure DNS must resolve all required Jetstream, AVS, and storage endpoints.

* AVS vCenter Server must resolve correctly.
* Individual AVS ESXi hosts must resolve correctly.
* Azure Storage account endpoints must resolve correctly.
* Jetstream MSA must resolve correctly.
* External Jetstream Marketplace service must resolve correctly.
* **Failure condition:** If DRVAs cannot resolve the Blob storage URL, replication traffic cannot leave the AVS cluster.

### Network segment requirements

* **Requirement:** Configure an NSX-T network segment in the AVS private cloud.
* **Purpose:** The segment hosts Jetstream appliances and routes their traffic.
* **DHCP option:** DHCP can support transient appliances that appear during recovery or failover.
* **Static IP option:** Static IPs are supported and preferred in strict enterprise landing zones.
* **Security implication:** Static IPs provide deterministic firewalling, auditing, and threat-hunting visibility.

### Supported topologies

| Topology                  | Description                                                                                | Blob storage role                                    |
| ------------------------- | ------------------------------------------------------------------------------------------ | ---------------------------------------------------- |
| On-premises VMware to AVS | Legacy VMware data center replicates into AVS as the recovery site.                        | Blob acts as the intermediary holding area.          |
| AVS region to AVS region  | One AVS private cloud replicates to another AVS private cloud in a different Azure region. | Blob stores the replicated CDP stream between sites. |

### Workload limitation

* **Limitation:** Jetstream does not support workloads using shared disks.
* **Example:** Legacy Windows Server Failover Cluster workloads using shared VMDKs are not supported.
* **Reason given in transcript:** SCSI bus sharing prevents Jetstream VAIO filters from safely intercepting and locking shared I/O traffic without risking corruption.
* **Operational recommendation:** Use application-level alternatives such as SQL Always On Availability Groups for those workloads.

## 6. AVS Installation Method

Jetstream installation on AVS is different from on-premises VMware because customers do not receive ESXi root access. Microsoft restricts direct hypervisor manipulation to preserve the AVS service-level agreement.

* **On-premises VMware model:** An administrator can SSH into ESXi as root and install VIBs directly.
* **AVS model:** The customer uses the cloudadmin role and cannot directly install kernel-level host filters.
* **Reason:** Microsoft manages the hardware and hypervisor and must prevent unsupported host-level changes.
* **Mechanism:** Jetstream installation uses Azure Portal Run command.
* **Run command package:** The transcript names the AVS package as `JSDR.configuration`.

> **Requires documentation validation:** The transcript provides command names such as `invoke preflight jet drinstall`, `install jetdr with DHCP`, `install jetdr with static IP`, and `enable JetDR for cluster`. Exact cmdlet names and parameter spelling should be validated before deployment.

### Installation workflow

1. **Run the pre-flight check.**

   * The pre-flight command validates the AVS environment before changes are made.
   * It checks that the AVS cluster has at least three hosts.
   * It verifies provided cluster names.
   * It checks that planned Jetstream appliance VM names are unique in vCenter.

2. **Run the installation command.**

   * Use the DHCP installation path for simpler dynamic addressing.
   * Use the static IP installation path for governed enterprise environments.
   * Required static IP inputs include:

     * Protected cluster name.
     * Datastore name for the MSA appliance.
     * NSX-T network segment name.
     * MSA IP address.
     * Netmask.
     * Default gateway.
     * Primary DNS server IP.
     * Appliance hostname.
     * Root credential password.

3. **Enable JetDR for the cluster.**

   * This activates the cluster for protection.
   * It links host filters back to the management plane.
   * It creates the required Jetstream storage policies in vCenter.

4. **Move to vCenter for day-two configuration.**

   * Open the Jetstream vCenter plugin.
   * Add Blob storage credentials.
   * Deploy DRVAs.
   * Create protected domains.

## 7. Recovery Behavior and RTO Engineering

Jetstream targets near-zero RPO by continuously synchronizing data into Blob storage. Recovery time objective (RTO), however, depends on how quickly that data can be rehydrated and booted.

* **RPO behavior:** CDP means data loss may be seconds rather than hours.
* **RTO dependency:** Blob storage is object storage and cannot directly run AVS VMs.
* **Rehydration requirement:** Jetstream must pull data from Blob and rehydrate it into VMFS, vSAN, or external storage usable by ESXi.
* **RTO bottlenecks:** Recovery speed depends on Blob read speed, Azure network throughput, target datastore write speed, and simultaneous VM boot capacity.

### Storage target options

| Recovery target          | Advantage                                      | Limitation                                  |
| ------------------------ | ---------------------------------------------- | ------------------------------------------- |
| Internal vSAN            | Native AVS datastore.                          | Capacity is tied to AVS host count.         |
| Azure NetApp Files (ANF) | Storage scales independently from AVS compute. | Requires correct external datastore design. |
| Azure Elastic SAN        | Storage can be decoupled from compute.         | Requires validation and design planning.    |

* **Why external storage matters:** vSAN capacity increases only when AVS hosts are added.
* **Cost implication:** External storage can avoid buying extra AVS compute nodes solely to obtain more storage.
* **Operational recommendation:** For large recovery events, consider rehydrating to ANF or Elastic SAN rather than filling internal vSAN.

> **Requires documentation validation:** The transcript states that ANF can be attached via ExpressRoute FastPath directly to ESXi hosts as an NFS datastore. Validate the exact supported configuration before implementation.

## 8. Ransomware Recovery

Ransomware recovery benefits from CDP because Jetstream keeps a granular log of changes over time.

* **Recovery behavior:** If encryption began at 2:12:30 a.m., Jetstream can recover to 2:12:29 a.m.
* **Value:** This avoids rolling back to a much older snapshot.
* **Risk:** A recovered VM should not be immediately reconnected to the production network.
* **NSX-T isolation:** Recovery runbooks can place workloads into an isolated NSX-T segment.
* **Quarantine model:** VMs can boot and communicate inside the isolated bubble without north-south internet or corporate network access.
* **Operational use:** Security, forensics, and incident response teams can inspect, clean, and validate systems before reconnecting them.

> **Requires documentation validation:** The transcript describes replicated data in Blob as “immutable.” Confirm whether immutability depends on specific Azure Storage immutability settings.

## 9. Key Calculations and Numerical Examples

### Snapshot data-loss example

> **Transcript-derived calculation:**

| Item                          | Value                                                                                     |
| ----------------------------- | ----------------------------------------------------------------------------------------- |
| Inputs                        | Snapshot interval = 60 minutes; disaster occurs at minute 59.                             |
| Formula                       | Maximum data loss = disaster time since last snapshot.                                    |
| Result                        | 59 minutes of data loss.                                                                  |
| Practical interpretation      | Hourly snapshots can lose nearly one hour of transactions.                                |
| Factors affecting real result | Snapshot frequency, application transaction rate, replication lag, and consistency model. |

### Host-count lifecycle example

> **Transcript-derived calculation:**

| Item                          | Value                                                                                   |
| ----------------------------- | --------------------------------------------------------------------------------------- |
| Inputs                        | AVS minimum cluster size = 3 hosts; Jetstream upgrade requires host maintenance mode.   |
| Formula                       | Required upgrade host count = minimum AVS cluster + 1 additional host.                  |
| Result                        | 4 hosts required for Jetstream lifecycle upgrades.                                      |
| Practical interpretation      | A 3-host cluster may work on day one but require temporary scale-out for upgrades.      |
| Factors affecting real result | AVS maintenance behavior, vSAN capacity, data redundancy, and current host utilization. |

## 10. Limitations, Gotchas, and Support Boundaries

### Host count and lifecycle management

* **Baseline:** AVS requires at least three hosts.
* **Upgrade gotcha:** Jetstream upgrades require a minimum of four hosts because ESXi hosts must enter maintenance mode.
* **Operational implication:** A customer using only three hosts may need to temporarily add and pay for a fourth host during Jetstream upgrades.
* **Recommendation:** Forecast this cost and operational step during design, not on upgrade day.

### Stretched cluster limitation

* **Limitation:** The transcript states that Jetstream is unsupported in AVS stretched clusters.
* **Reason given:** Stretched vSAN relies on synchronous cross-zone storage behavior, while Jetstream uses I/O filtering for point-in-time DR.
* **Architecture decision:** A customer must choose between stretched-cluster high availability and Jetstream CDP-based DR for the same cluster.

> **Requires documentation validation:** The transcript groups Jetstream, Zerto, and VMware Site Recovery Manager together as unsupported DR add-ons using kernel-level I/O filtering or continuous replication in AVS stretched clusters. Validate each product’s current support matrix independently.

### Support boundaries

| Issue type                                          | Support path      |
| --------------------------------------------------- | ----------------- |
| Azure Run command or Azure portal execution failure | Microsoft support |
| Jetstream configuration issue                       | Jetstream support |
| Replication failure to Blob                         | Jetstream support |
| Protected domain sync failure                       | Jetstream support |
| Jetstream software performance or operational issue | Jetstream support |

* **Microsoft boundary:** Microsoft does not directly support Jetstream replication behavior, configuration errors, or third-party software bugs.
* **Jetstream AVS support channel:** The transcript gives `supportavs@jetstreamsoft.com`.
* **Operational recommendation:** Include the escalation path in handover documentation so the client does not lose time opening the wrong support ticket.

## Architecture Summary

Jetstream for AVS uses AVS as the VMware platform, VAIO filters for continuous write capture, DRVAs for data movement, and Azure Blob storage as the low-cost replication target.

1. Production VM writes data on AVS ESXi hosts.
2. Jetstream VAIO host filters capture write I/O at the hypervisor layer.
3. DRVAs receive, process, and send replicated data to Azure Blob storage.
4. The MSA manages configuration, health, protected domains, and recovery workflows.
5. During failover, Jetstream pulls data from Blob and rehydrates it into a recovery datastore.
6. Workloads boot in the recovery AVS environment, optionally inside an isolated NSX-T ransomware recovery segment.

## Final Result

Jetstream replaces duplicate standby infrastructure with continuous data streaming, low-cost Blob storage, and on-demand recovery compute. The architecture is powerful when the landing zone is prepared correctly, but success depends on flat Blob storage, reliable DNS, correct NSX-T segmentation, careful AVS capacity planning, awareness of shared-disk and stretched-cluster limits, and clear support escalation paths.
