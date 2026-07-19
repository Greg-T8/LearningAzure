# Azure Monitor Cross-Resource Query Limits and Architecture

Your choice of 50 is a reasonable guess, but it falls short of the actual scale Azure Monitor supports for distributed querying. 

Here is a breakdown of why your answer was incorrect and why 100 is the correct limit for this scenario:

**The Cross-Resource Query Limit**
In Azure Monitor, an architect or operator often needs to correlate telemetry across multiple environments simultaneously. When writing a cross-resource log query, Azure explicitly allows the query to reference a maximum of **100 Log Analytics workspaces and Application Insights resources** in a single execution [1]. This hard limit ensures that distributed KQL queries across multiple data stores remain performant without overwhelming the shared backend query engine. 

**Additional Log Analytics Query Limits to Know for the Exam**
To fully understand the architectural boundaries of Log Analytics queries for the AZ-305 exam, you should also be aware of the following related execution limits:
*   **Result Size Boundaries:** The Azure portal will return a maximum of **500,000 records** or approximately **100 MiB** of raw data per query [1].
*   **Execution Timeouts:** The query API enforces a strict maximum execution time of **10 minutes** [1]. 
*   **Concurrency:** A single user is limited to running **5 concurrent Analytics-table queries** and only **2 concurrent Basic/Auxiliary search queries** [1]. 
*   **Queuing:** If too many queries are submitted, they enter a queue. A queued query will be automatically terminated with an HTTP 429 error after waiting for **3 minutes**, and no more than **200** queries can wait in the queue at one time [1].