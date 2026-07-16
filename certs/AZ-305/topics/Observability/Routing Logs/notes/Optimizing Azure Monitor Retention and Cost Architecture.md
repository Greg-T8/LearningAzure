# Optimizing Azure Monitor Retention and Cost Architecture

Great job on selecting the correct answer! While 4 days is indeed the absolute technical minimum for interactive retention, this question highlights a major "gotcha" regarding Azure Monitor pricing and table plans.

Here is a breakdown of why this 4-day limit exists, the cost trap it presents, and what the actual architectural recommendation should be for this customer:

**1. The 4-Day API Minimum**
For standard "Analytics" tables in a Log Analytics workspace, the default interactive retention is 30 days [1]. While the Azure portal generally restricts how low you can set this, you can use the Azure API or Azure CLI to forcefully reduce the interactive retention period down to an absolute minimum of 4 days [2]. 

**2. The Cost Trap (Why reducing it doesn't save money)**
The trick to this scenario is understanding how Azure Monitor bills for retention. The first 31 days of interactive retention are already included in the standard data ingestion price [1, 2]. Because you are already paying for those first 31 days just by bringing the data into the workspace, reducing the retention down to 4 days **will not save the customer any money** [1, 2]. 

**3. The Correct Architectural Solution**
Since the customer's goal is to minimize costs for data that is only used for "occasional investigations but not for real-time alerting," forcefully lowering the Analytics table retention to 4 days is the wrong approach. Instead, an architect should recommend changing the table's plan:
*   **Basic Logs:** The customer should switch the eligible tables to the **Basic** table plan. Basic tables are specifically designed for verbose, occasionally queried logs that are not used for alerting [1]. They offer a significantly cheaper ingestion rate in exchange for a per-query charge, and they come with a fixed 30-day interactive query window [1, 2]. 
*   **Long-Term Retention (Archive):** If the customer needs to keep the data for investigations longer than 30 days, they can configure long-term retention, which drops the data into a low-cost archive state for up to 12 years [1, 2]. This data can then be accessed via asynchronous search jobs when an investigation occurs [1].