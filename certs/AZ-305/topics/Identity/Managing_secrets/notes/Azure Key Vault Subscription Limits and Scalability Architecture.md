# Azure Key Vault Subscription Limits and Scalability Architecture

It is very easy to arrive at 40,000 by simply multiplying the single-vault limit (4,000) by the number of vaults you have (10). However, this question is designed to test your knowledge of a specific, hard ceiling that Azure places on Key Vault scalability at the subscription level.

Here is a detailed breakdown of why your calculation was incorrect, the specific Azure limits at play, and what you must remember for the AZ-305 exam:

**1. The Single Vault Limit**
For an RSA 2,048-bit software-protected key, Azure Key Vault allows a maximum of **4,000 GET transactions (which fall under the "All other transactions" category) per 10 seconds** for a single vault [1, 2]. 

**2. The Subscription-Wide Ceiling (Why your answer was incorrect)**
Your calculation assumed that adding more vaults scales your allowed throughput linearly (10 vaults × 4,000 transactions = 40,000). 
However, Azure enforces a strict subscription-wide limit per region to prevent resource exhaustion. The total transaction limit across *all* vaults in a single subscription and region is capped at exactly **five times the individual key vault limit** [3, 4]. 

**3. The Correct Math**
Because the maximum multiplier Azure allows is 5, the absolute maximum number of RSA 2,048-bit software-key GET transactions you can perform in your subscription in the East US region is:
**5 × 4,000 = 20,000 transactions per 10 seconds** [3, 4]. 

Even though you have 10 vaults deployed in that region, the platform will throttle your requests (returning HTTP 429 Too Many Requests errors) once the aggregate traffic across those vaults hits the 20,000 threshold within a 10-second window.

**Architectural Takeaways for the AZ-305 Exam:**
When designing for high-throughput cryptography, keep these boundaries in mind:
*   **Limits Do Not Scale Infinitely:** You cannot infinitely bypass Key Vault throttling simply by provisioning more vaults. Once you deploy 5 vaults hitting their maximum limits, your subscription is maxed out for that region [4]. 
*   **Mitigating the Limit:** If a workload genuinely requires more than 20,000 transactions per 10 seconds, the architectural best practice is not to add more vaults. Instead, you must implement client-side **in-memory caching** so your application reuses the key material locally, drastically reducing the number of requests sent directly to the Key Vault service [5]. 
*   **Multiple Subscriptions:** If caching is not an option and you absolutely must bypass this regional cap, you must distribute your key vaults and workload across **multiple Azure subscriptions** to obtain a fresh set of quotas for each subscription [4].