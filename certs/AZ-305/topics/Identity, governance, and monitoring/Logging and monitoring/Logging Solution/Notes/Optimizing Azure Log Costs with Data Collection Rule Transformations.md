# Optimizing Azure Log Costs with Data Collection Rule Transformations

Great job on selecting the correct answer! Your choice highlights a core capability of the modern Azure monitoring architecture specifically designed for cost optimization.

Here is a breakdown of why applying a transformation to a Data Collection Rule (DCR) is the perfect solution for this scenario:

**1. The Role of Data Collection Rules (DCRs)**
The Azure Monitor Agent (AMA) running on the virtual machines does not have its own local configuration. Instead, it relies on centralized Azure resources called **Data Collection Rules (DCRs)** to know what to do. A DCR defines three things: what data sources to collect (like Windows Event Logs), where to send the data, and how to **transform** the data along the way [1, 2].

**2. Ingestion-Time Transformations via KQL**
When you apply a transformation to a DCR, you are inserting a Kusto Query Language (KQL) statement into the data pipeline [1, 3, 4]. This allows you to filter, reshape, or modify the log data *before* Azure Monitor actually stores it in the Log Analytics workspace [3]. In your scenario, the KQL transformation would instruct the pipeline to drop the rows containing the specific, noisy Windows Event IDs [1]. 

**3. Direct Impact on Budgets**
The primary factor driving Azure Monitor Log Analytics costs is the raw volume of data ingested into the workspace [5]. Because the DCR transformation filters out the unneeded event IDs during transit, that data never actually lands in the workspace [1, 3]. By dropping these irrelevant logs before ingestion, you avoid paying the ingestion costs for them entirely, keeping your tables under budget [1, 3, 5].

**4. A Major Upgrade from Legacy Agents**
As an architectural note, this scenario emphasizes why Microsoft requires modern agents. The retired legacy Log Analytics agent applied a blanket configuration and could not perform granular, source-side filtering [2, 6]. Migrating to the Azure Monitor Agent and using DCR transformations is now the recommended best practice specifically because it gives architects the power to filter data and control costs before the data is ingested [6].