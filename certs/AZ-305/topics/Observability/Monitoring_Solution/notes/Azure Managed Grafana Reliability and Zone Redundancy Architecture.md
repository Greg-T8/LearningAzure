# Azure Managed Grafana Reliability and Zone Redundancy Architecture

Your choice of **"Multi-region failover"** is a very logical guess, as many fully managed Azure services offer built-in geographic replication. However, this question highlights a specific architectural limitation and feature set of Azure Managed Grafana. 

Here is a breakdown of why your answer was incorrect and why **Zone redundancy** is the correct feature to choose:

**Why "Multi-region failover" is incorrect:**
Azure Managed Grafana is strictly a **single-region service** [1]. Microsoft does not provide built-in cross-region disaster recovery or automated multi-region failover for this service [1, 2]. If an entire Azure region goes down, your Grafana workspace in that region will be unavailable [1]. To survive a true regional outage, an architect cannot rely on a built-in toggle; they must manually engineer a custom solution by deploying multiple independent Grafana workspaces in different regions and using CI/CD pipelines to replicate dashboard configurations between them [1, 3]. Therefore, "multi-region failover" is not a feature of the service.

**Why "Zone redundancy" is the correct answer:**
While the service cannot natively failover between regions, the **Standard SKU** does natively support **zone redundancy** to provide high availability and reliability [4, 5]. 

When you enable zone redundancy during the creation of a Standard workspace, the underlying virtual machines that run your Grafana servers are automatically distributed across multiple physically separate availability zones (datacenters) within that single Azure region [6, 7]. 

*   **Automatic Failover:** If one datacenter (zone) experiences an outage, the Azure network load balancer automatically routes traffic to the healthy Grafana servers in the surviving zones [6, 8].
*   **Zero User Intervention:** The platform detects the failure and handles this zone-level failover and recovery automatically without you needing to do anything [9, 10]. 

**The Exam Trap:**
The wording of your quiz question ("survive regional outages") might have been slightly misleading, as zone redundancy technically protects against *datacenter* (zonal) outages rather than full *regional* outages [1, 7]. However, the core testable concept for the AZ-305 exam is recognizing that **Zone redundancy is the premier built-in reliability feature exclusive to the Standard tier** [4, 5], whereas native multi-region failover does not exist for Azure Managed Grafana at all.