# Azure VM Custom Log Collection with AMA and DCR

Great job on selecting the correct answer! Your choice perfectly outlines the modern architectural standard for collecting custom, file-based logs from virtual machines in Azure. 

Here is a breakdown of why this combination of tools is the right approach for this scenario:

**1. Reaching inside the VM with Azure Monitor Agent (AMA)**
When an application writes logs to local files on a Linux filesystem, the Azure platform cannot see them automatically. To collect data from *inside* the guest operating system (Guest-OS), you must use the Azure Monitor Agent (AMA) [1]. Legacy agents have been retired, making AMA the only supported agent for collecting guest-OS logs, such as Windows Event Logs, Syslog, and text or JSON file-based logs [1]. 

**2. Providing instructions via Data Collection Rules (DCR)**
The AMA does not hold its configuration locally on the machine. Instead, it is configured entirely through a centralized Azure resource called a Data Collection Rule (DCR) [1]. A DCR acts as the instruction manual for the agent, defining three main things:
*   **Data sources:** What logs to collect (in this case, local JSON files).
*   **Transformations:** How to optionally reshape or filter the data before it lands.
*   **Destinations:** Where to send the data [2].

**3. Targeting "JSON Logs"**
Within the DCR, you must specify the exact data source. Azure Monitor natively supports a "JSON log" data source type for both Linux and Windows VMs [3]. By selecting this, you instruct the agent to look for specific JSON log files on the local disk, parse them, and prepare them for ingestion [3].

**4. Querying with KQL**
To meet the customer's requirement of querying the data using Kusto Query Language (KQL), the data must be sent to the correct destination. The DCR routes the collected custom JSON logs directly into a custom table within a **Log Analytics workspace** [3, 4]. The Log Analytics workspace serves as the core data platform where all interactive KQL queries are executed [5].

In summary, your answer connects the **agent** needed to read the disk (AMA), the **rules** needed to configure the collection (DCR/JSON data source), and the **destination** required to enable KQL querying (Log Analytics).