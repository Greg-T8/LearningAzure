# Optimizing Log Tiers for Cost-Effective Ad-Hoc Troubleshooting

Your choice of the **Auxiliary** plan was a very logical guess because it is indeed the absolute cheapest ingestion tier available for verbose data [1]. However, the extreme cost savings of the Auxiliary plan come at the expense of interactive querying capabilities, making it the wrong fit for ad-hoc troubleshooting.

Here is a breakdown of why your answer was incorrect and why the Basic plan is the right architectural choice for this scenario:

**Why "Auxiliary" is incorrect:**
While the Auxiliary plan minimizes ingestion costs the most, data stored in an Auxiliary table cannot be interactively queried or restored [1]. To analyze data in an Auxiliary table, you must run an asynchronous "search job," which pulls the matching records into a completely new Analytics table for analysis [1]. This adds friction and delay, violating the requirement for quick, "ad-hoc troubleshooting." Additionally, the Auxiliary plan is highly restrictive: it can only be set on DCR-based custom tables created via API, and the plan can never be changed after creation [1, 2].

**Why "Basic" is the correct answer:**
The **Basic** table plan is specifically intended for high-volume, low-value verbose logs, just like the diagnostic logs in your scenario [1, 2]. 
*   **Maintains interactive querying:** Unlike Auxiliary tables, the Basic plan allows you to run ad-hoc, interactive queries, directly fulfilling the troubleshooting requirement.
*   **Cost optimization:** The Basic plan offers significantly cheaper ingestion rates than the default Analytics tier, but introduces a per-query charge based on the amount of data scanned [1]. Since your scenario states these logs are only queried during "rare system failures," paying a small fee per query is far more cost-effective than paying high daily ingestion rates.
*   **Built-in 30-day retention:** The scenario specifies a strict 30-day retention requirement. The Basic plan natively features a fixed 30-day interactive query period, perfectly satisfying this design constraint without any additional configuration [1]. 

In short, the **Basic** plan strikes the perfect balance: it drastically reduces the heavy ingestion costs for high-volume logs while preserving the 30-day interactive querying window needed for rapid troubleshooting [1].