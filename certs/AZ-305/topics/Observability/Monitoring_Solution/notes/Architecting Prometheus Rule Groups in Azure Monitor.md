# Architecting Prometheus Rule Groups in Azure Monitor

Great job on selecting the correct answer! Your choice shows a solid understanding of how cloud-native alerting is integrated into the Azure Monitor ecosystem.

Here is a detailed breakdown of what Prometheus rule groups are, how they function, and why they are the correct architectural choice for this scenario:

**1. The Role of Prometheus Rule Groups**
When using the Azure Monitor managed service for Prometheus, your Kubernetes metrics are stored in a specialized Azure Monitor workspace and queried using PromQL (Prometheus Query Language) [1, 2]. Standard Azure Monitor metric alerts or log search alerts cannot natively evaluate PromQL. Instead, you must use **Prometheus rule groups**, which are specifically designed to execute PromQL queries against this data [3]. 

A rule group can contain two distinct types of rules:
*   **Alerting rules:** These rules evaluate PromQL expressions at regular intervals. If the condition is met, the rule triggers an alert [3]. 
*   **Recording rules:** These rules are used to precompute computationally expensive or frequently used PromQL queries and save the results as a new, pre-aggregated metric time series [4, 5]. This is highly useful for optimizing performance when loading heavy operational dashboards in Grafana.

**2. Azure-Managed Integration**
While you could theoretically manage rules within a third-party tool (like Grafana-managed rules), using Azure-managed Prometheus rule groups offers significant architectural benefits. Because they are native Azure resources, they provide:
*   **Scalability:** The rules are evaluated directly within the Azure Monitor platform, which automatically scales to meet your processing needs without requiring you to manage underlying compute infrastructure [5].
*   **Consistent Resource Management:** You can deploy, update, and manage these rule groups using standard Azure tools like ARM templates, Bicep, Azure CLI, or Azure SDKs, just like any other Azure resource [6]. 

**3. Built-in Scale Limits**
When designing your observability strategy, it is important to know the platform's scaling boundaries. By default, a single Azure Monitor workspace supports up to **500 Prometheus rule groups** [7]. Within each of those groups, you can define up to **20 rules** [7]. The evaluation interval for these rules defaults to 1 minute, but can be configured anywhere from 1 minute up to 24 hours [7].

**Architectural Takeaway:**
When designing a solution for the AZ-305 exam, remember the separation of duties in Azure Monitor. While the **Prometheus rule group** natively handles the PromQL *detection* logic (evaluating the metric and deciding if it crossed a threshold), it does not handle the notification itself. To actually send an email, SMS, or trigger a webhook when a Prometheus alert fires, you must attach a standard Azure Monitor **action group** to the rule [3, 8].