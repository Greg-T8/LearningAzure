# Azure Managed Grafana Tiering and Architectural Standards

Your choice of "Premium" is a very logical guess, as many Azure services use a Basic/Standard/Premium tiering model. However, this question tests your knowledge of Azure Managed Grafana's specific pricing and service tiers, where a "Premium" SKU simply does not exist [1, 2]. 

Here is a breakdown of why your answer was incorrect and why **Standard** is the correct architectural choice:

**Why "Premium" is incorrect:**
Azure Managed Grafana does not offer a "Premium" tier [1]. The service historically offered an "Essential" tier and a "Standard" tier [1]. Currently, the Essential tier is deprecated, carries no Service Level Agreement (SLA), and cannot be selected for new workspaces, making Standard the default and only tier available for new deployments [1, 3, 4]. 

You might have been thinking of the advanced capabilities provided by Grafana Enterprise. However, **Grafana Enterprise is an add-on option configured within the Standard plan, not a separate Azure SKU** [2, 5]. 

**Why "Standard" is the correct answer:**
The **Standard** tier is the fully managed, SLA-backed tier that seamlessly fulfills all the scenario's requirements:
*   **Consolidated Dashboarding:** The Standard tier includes all core data source plugins by default [6]. This natively includes the **Azure Monitor** plugin (to view your underlying virtual machine scale set metrics) and the **Prometheus** plugin (to view your AKS cluster metrics) [6]. 
*   **Third-party Data:** The Standard tier supports a wide variety of external and third-party data sources [6]. If the third-party source requires a specialized enterprise plugin (like Datadog, ServiceNow, or Splunk), you simply enable the Grafana Enterprise option on top of your Standard SKU [6, 7].
*   **Identity and Authentication:** Azure Managed Grafana natively authenticates users using **Microsoft Entra ID**, fulfilling the scenario's strict identity requirement and allowing you to control access via standard Azure role-based access control (RBAC) [3, 8].

**Architectural Takeaway:**
When evaluating visualization tools for the AZ-305 exam, **Azure Managed Grafana Standard** is the correct recommendation anytime a scenario requires cloud-native operational dashboards, PromQL queries, multi-source data correlation, and secure Microsoft Entra ID integration [6, 9].