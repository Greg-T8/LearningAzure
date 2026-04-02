# Practice Questions — Design identity, governance, and monitoring solutions

Accounts for questions missed or unsure about in the practice exams.

* [Design solutions for logging and monitoring](#design-solutions-for-logging-and-monitoring)
  * [Monitoring Solution for a Gaming App](#monitoring-solution-for-a-gaming-app)
* [Design authentication and authorization solutions](#design-authentication-and-authorization-solutions)
* [Design governance](#design-governance)

---

## Design solutions for logging and monitoring

### Monitoring Solution for a Gaming App

**Domain:** Design identity, governance, and monitoring solutions
**Skill:** Design solutions for logging and monitoring
**Task:** Recommend a monitoring solution
**Answered:** Incorrectly
**ID:** 0ed6591

You are designing a monitoring solution for a gaming website hosted in an Azure Web App.

You have the following monitoring requirements:

* Track how often users return to the website in a specified time period.
* Measure how specific events influence user activities.
* View user activity by region.

You need to provide a solution that minimizes administrative effort.

Which monitoring solution should you use?

A. Application Insights  
B. Azure Monitor Alerts  
C. Azure AI Services  
D. Time Series Insights environments  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-04-01-08-00-30.png' width=600>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why Application Insights is correct**

Application Insights is designed for web application telemetry and usage analysis. It supports retention analysis, custom events, and filtering user activity by properties such as region, which matches the requirements for tracking return visits, event influence, and regional activity with minimal administrative effort.

**Why the other options are less appropriate**

Azure Monitor Alerts is for notifying you about threshold breaches and operational conditions, not for analyzing user behavior.

Azure AI Services provides AI capabilities, not monitoring or usage analytics.

Time Series Insights is intended for time-series and IoT-style telemetry analysis, not web app user behavior tracking.

**References**

* [Usage analysis with Application Insights](https://learn.microsoft.com/azure/azure-monitor/app/usage)
* [Azure Monitor overview](https://learn.microsoft.com/azure/azure-monitor/fundamentals/overview)
* [What are Azure Monitor alerts?](https://learn.microsoft.com/azure/azure-monitor/alerts/alerts-overview)
* [Azure Time Series Insights Gen2 data access overview](https://learn.microsoft.com/rest/api/time-series-insights/reference-data-access-overview)
* [Get started with Azure AI Services - Training](https://learn.microsoft.com/training/paths/get-started-azure-ai/)

* [0ed6591 - Azure Observability Blueprint](https://notebooklm.google.com/notebook/c0407f1f-03f4-45c2-8155-ae155499f7d1?artifactId=f28b9767-e325-43e2-8611-c0bc0b6f2951)
* [0ed6591 - Monitoring Quiz](https://notebooklm.google.com/notebook/c0407f1f-03f4-45c2-8155-ae155499f7d1?artifactId=f6960d51-1a14-42fb-96a1-59975710a94f)
* [0ed6591 - Choosing Your Lens: A Student's Guide to Azure Monitoring & Analytics Services](https://docs.google.com/document/d/14CoYV7K63fO4WhOE4MS9PxxS2pLgSjvaB7Ds4dohBog/edit?usp=sharing)
* [0ed6591 - Azure Monitor and Foundry Observability Services Overview](https://docs.google.com/spreadsheets/d/1DPGV4OPnFFNzqLTNHs-VAI64j9Roz8CJQ88gocw0m0w/edit?usp=sharing)
* [0ed6591 - Architectural Framework for Full-Stack Observability with Application Insights and OpenTelemetry](https://docs.google.com/document/d/1aeDHEtY4RaXPU7lHH_QNNIenWJyI0CHvCyt8bhOc1QM/edit?usp=sharing)

</details>

---

## Design authentication and authorization solutions

## Design governance
