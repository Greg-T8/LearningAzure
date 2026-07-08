1. Collect activity logs from all subscriptions in management group, i.e. resource created event

   - [Azure Monitor - Create diagnostic settings at scale by using built-in Azure policies](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy-built-in?tabs=portal)
   - [Azure Monitor - Azure Policy built-ins](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/policy-reference)

2. Use a workspace transformation to route 'Error' and 'Critical' logs to an Analytics table and other logs to a 'Basic' table.

    - [Transformations in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations)
    - [Analytics tiers with transformations](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/cost-effective-alerting#analytics-tier-with-transformations)

3. Use a transformation in a DCR rule for a Windows or Linux VM for guest log data

   - [Create transformation query](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-transformations-create?tabs=portal#create-the-transformation-query)

4. Set up and use Azure Monitor Private Link Scope (AMPLS) using Open Access and Private Only modes with Data Collection Endpoint (DCE):

   - [Use Azure Private Link to connect networks to Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-security)
   - [Azure Monitor Private Link networking - Design](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-design#plan-by-network-topology)
   - See [When is a DCE required?](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-endpoint-overview?utm_source=chatgpt.com&tabs=portal#when-is-a-dce-required)

5. Create a metrics export using data collection rules

   - [Metrics export using data collection rules](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/metrics-export-create?tabs=portal)

6. Set up Azure Policy to install and manage the Azure Monitor Agent

    - [Use Azure Policy to install and manage the Azure Monitor Agent](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-policy)
    - [Run remediation task for existing machines](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-enable-policy?tabs=basics#vm-insights-initiatives)

7. Set up Azure Monitoring Baseline Alerts (AMBA) system for alerting at scale

8. Experiment with Application Insights. Explore how it creates a managed Log Analytics workspace.

9. Configure a health model. Health models are based on Azure service groups.

    - [Health models overview](https://learn.microsoft.com/en-us/azure/azure-monitor/health-models/overview)

10. Stand up Azure Monitor Dashboard with Grafana

11. Set up Prometheus metrics w/ Windows

12. Configure OpenTelemtry metrics-based monitoring in Azure workspace

    - [Enable enhanced monitoring of VMs](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/tutorial-enable-monitoring)
