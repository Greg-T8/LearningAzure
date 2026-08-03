# Azure App Configuration: Scaling and Tier Selection Guide

It is very easy to select the Standard tier in this scenario, as it is designed for production workloads and offers an SLA. However, this question tests your specific knowledge of Azure service limits and how throttling can impact high-volume applications.

Here is a detailed breakdown of why your answer was incorrect, how App Configuration throttles traffic, and the specific scale limits you must remember for the AZ-305 exam:

**1. The Standard Tier Hourly Limit (Why your answer was incorrect)**
While the Standard tier allows for overages on your daily bill, it enforces a strict **request quota of 30,000 requests per hour** [1, 2]. 

If your application generates 500,000 requests per day, that averages out to about 20,833 requests per hour. While this average is technically beneath the hourly limit, any moderate spike in traffic, deployment scale-out, or uneven distribution of requests will easily exceed 30,000 requests in a single hour. Once this hourly quota is exhausted, App Configuration returns an HTTP status code 429 (Too many requests) until the end of the hour [1, 2]. This effectively blocks your application's access to its configuration data.

**2. The Premium Tier Advantage (Why the correct answer is right)**
To fulfill the scenario's strict requirement to *ensure* that request quotas do not block access, you must recommend the **Premium tier**. The Premium tier has **no quota limit on requests**, which guarantees that access to the configuration store is never blocked due to quota exhaustion [1, 2]. This makes it the correct architectural choice for high-volume or enterprise-level production needs [3].

**Architectural Takeaways for the AZ-305 Exam:**
When sizing Azure App Configuration solutions, keep these distinct boundaries in mind:
*   **Request Quotas (Hourly):** The Standard tier is strictly capped at **30,000 requests per hour** [1, 2]. The Premium tier has **no request quota limit** [1, 2].
*   **Throughput Allowances (Per Second):** Throughput limits apply to all tiers. The Standard tier supports a run rate of up to **300 requests per second (RPS)** for reads and 60 RPS for writes [2, 4]. The Premium tier increases this to **450 RPS** for reads and 100 RPS for writes [4, 5]. Exceeding these throughput rates in either tier will result in momentary HTTP 429 throttling [1, 4, 6].
*   **Billing vs. Throttling:** Do not confuse hourly throttling quotas with daily billing allocations. The Standard tier includes the first 200,000 requests per day in its base charge and bills for overages after that [7]. The Premium tier includes the first 800,000 requests per day (for both the origin and replica) before charging overages [7].