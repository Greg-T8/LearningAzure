# Architectural Requirements for Azure VNet Flow Log Storage

Great job on getting the correct answer! Your choice demonstrates a solid understanding of how Azure Network Watcher handles the underlying data for network flow logs.

Here is a breakdown of why the storage account must support block blobs, along with other critical architectural requirements for Virtual Network (VNet) flow logs:

**1. The Storage-First Architecture**
Unlike some Azure platform logs that can be routed directly to a Log Analytics workspace, VNet flow logs operate on a strict "storage-first" path [1, 2]. The raw flow data must be written to an Azure Storage account before it can be optionally processed by Traffic Analytics or exported to other tools like a SIEM [1, 2]. 

**2. Why Block Blobs?**
The Azure platform writes VNet flow log data to the storage account specifically using **block blobs** [3]. 
* **The Ingestion Process:** Flow logs are ingested into a block blob at one-minute intervals by continuously appending new blocks of data [4, 5]. 
* **Hourly Generation:** Each log is organized as a separate block blob that is generated every hour and updated with the latest network traffic data every few minutes [3]. 
* **Operational Constraint:** Because Azure relies on this specific appending mechanism, Microsoft strongly warns against editing, overwriting, or deleting the blob's block structure while ingestion is in progress, as doing so can cause all subsequent flow log write operations for that hour to fail [4, 5].

**3. Other Strict Storage Requirements**
When designing a logging solution for VNet flow logs, the requirement for block blobs is just one of several strict constraints you must meet for the destination storage account:
* **Standard Tier Only:** The storage account must use the **Standard** performance tier; Premium storage accounts are not supported for flow logs [4, 6].
* **Same Region:** The destination storage account must be located in the exact same Azure region as the virtual network you are monitoring [6, 7].
* **Same Tenant:** The storage account must be in the same Azure subscription as the virtual network, or in a different subscription that is associated with the exact same Microsoft Entra tenant [6, 7].