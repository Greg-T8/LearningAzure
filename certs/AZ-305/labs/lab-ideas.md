1. Collect activity logs from all subscriptions in management group, i.e. resource created event
2. Use a DCR transformation in an Azure Monitor Workspace, i.e. with a Windows or Linux VM for guest log data
3. Use Azure Policy to configure logging to a Log Analytics workspace, using remediation task to apply policy to existing resources

- <https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diaostic-settings-policy-built-in?tabs=portal>
- <https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings-policy>

4. Set up and use Azure Monitor Private Link Scope (AMPLS) using Open Access and Private Only modes
   - <https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-security>
   - <https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-design#plan-by-network-topology>
5. Scenario with Azure Monitor Private Link Scope (AMPLS) and data collection endpoints, e.g.  (Windows Firewall logs). See [When is a DCE required?](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-endpoint-overview?utm_source=chatgpt.com&tabs=portal#when-is-a-dce-required)
6. Create a metrics export using data collection rules (<https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/metrics-export-create?tabs=portal>)
7. Set up Azure Monitoring Baseline Alerts (AMBA) system for alerting at scale
8. Experiment with Azure Monitor Insights
9. Stand up Azure Monitor Dashboard with Grafana
10. Set up Prometheus metrics w/ Windows
11.
