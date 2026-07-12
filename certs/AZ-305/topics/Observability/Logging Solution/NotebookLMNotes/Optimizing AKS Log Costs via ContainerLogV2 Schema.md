# Optimizing AKS Log Costs via ContainerLogV2 Schema

Your choice to "Migrate to the Azure Monitor Agent for AKS" was a very logical guess because the legacy Log Analytics agent is retired and the Azure Monitor Agent (AMA) is the modern standard for data collection across Azure [1, 2]. However, simply upgrading the agent does not change how the underlying log tables are formatted or billed in the Log Analytics workspace.

Here is a breakdown of why your answer was incorrect and why the correct architectural choice is the ContainerLogV2 schema:

**Why "Migrate to the Azure Monitor Agent" is incorrect:**
While migrating to the AMA is a required best practice for modern Azure monitoring, it is not the specific mechanism that controls table pricing tiers. The 'Basic' log plan is designed to drastically reduce ingestion costs for high-volume, verbose logs, but it cannot be applied to just any table in a workspace; it is only supported on specific, eligible tables [3]. 

**Why "Enable the ContainerLogV2 schema" is the correct answer:**
*   **Unlocking Basic Plan Compatibility:** To use the Basic log plan for AKS container logs (which capture `stdout` and `stderr` streams), you must explicitly convert your Container insights schema to **ContainerLogV2** [4]. 
*   **Cost Optimization:** The ContainerLogV2 schema is specifically designed to be compatible with the Basic table plan [4, 5]. 
*   **Targeted Routing:** By enabling ContainerLogV2, you can safely flip the high-volume container logs table to the cheaper Basic plan to control costs, while leaving your critical Kubernetes control plane logs in the default 'Analytics' plan where they can be fully queried and used for real-time alerting [3, 4].