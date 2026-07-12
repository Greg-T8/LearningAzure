# Azure Monitor Log Architecture: The Basic Table Plan

Great job on selecting the correct answer! Your choice perfectly identifies the purpose of the different log table plans in Azure Monitor and how they are used to control costs. 

Here is a breakdown of why the **Basic** table plan is the exact right architectural fit for this scenario:

**1. Designed for High-Volume, Verbose Logs**
The Basic table plan is specifically intended for high-volume, low-value logs—exactly like the 1.5 TB of daily firewall logs mentioned in the scenario [1]. These logs take up a massive amount of space but are rarely used for daily operations or proactive alerting [1, 2]. 

**2. Drastic Cost Optimization**
Log Analytics ingestion costs can be high for 1.5 TB of daily data. The Basic plan offers significantly cheaper ingestion rates than the default Analytics plan [1]. The trade-off is that the Basic plan introduces a per-query charge based on the amount of data scanned [1]. Because the company only queries these logs rarely (during forensic investigations), paying a small fee per query is far more cost-effective than paying premium ingestion rates for 1.5 TB of data every single day [1, 3].

**3. Built-in 30-Day Interactive Querying**
A key requirement in the scenario is the ability to perform ad-hoc Kusto Query Language (KQL) queries on the raw data for up to 30 days. The Basic plan natively provides a fixed 30-day interactive query period, satisfying this requirement perfectly [1].

**Why the other table plans would fail this scenario:**
*   **The Analytics Plan:** This is the default plan and supports full KQL, alerts, and dashboards [1]. However, the ingestion costs would be much higher [1]. Using it for verbose logs that are rarely queried is a massive over-expenditure [2].
*   **The Auxiliary Plan:** While Auxiliary is the absolute cheapest ingestion tier available, it achieves those savings by stripping away interactive capabilities [1]. Data in an Auxiliary table cannot be interactively queried with KQL or restored; it can only be accessed by running asynchronous "search jobs" [1]. Recommending the Auxiliary plan would violate the customer's requirement to perform ad-hoc KQL queries. 

In short, the **Basic** plan strikes the perfect balance for forensic logs: it drastically reduces the heavy ingestion costs while preserving the 30-day interactive KQL window needed for investigations [1, 3].