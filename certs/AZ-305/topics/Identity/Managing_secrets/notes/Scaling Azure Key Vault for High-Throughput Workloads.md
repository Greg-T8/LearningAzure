# Scaling Azure Key Vault for High-Throughput Workloads

It is very easy to fall for the "two separate key vaults" trap because adding more infrastructure is often the default way to scale in cloud environments. However, this question tests your knowledge of Azure Key Vault's specific service limits and the Microsoft-recommended architectural best practices for handling high-throughput cryptographic workloads.

Here is a detailed breakdown of why your answer was incorrect, why the fan-out and caching pattern is correct, and what you must remember for the AZ-305 exam:

**1. The Service Limit Context**
According to Azure Key Vault service limits, a single vault supports a maximum of **4,000 GET transactions per 10 seconds** for RSA 2,048-bit software-protected keys [1, 2]. While the 2,500 operations in the scenario are technically under this limit, the high throughput places the application dangerously close to the threshold where burst traffic would easily trigger HTTP 429 (Too Many Requests) throttling errors [3, 4].

**2. Why "Distributing across two vaults" is incorrect**
While it is possible to split traffic across multiple vaults, spinning up duplicate vaults in the same region purely to bypass throughput limits is an architectural anti-pattern for a few reasons:
*   **The Domain Boundary Rule:** Microsoft recommends separating key vaults based on strict security and availability domains (such as per application, per environment, or per region) [5]. You should not indiscriminately deploy multiple vaults in the same region simply to increase your request quota.
*   **The Subscription Ceiling:** Even if you distributed the load across multiple vaults in the same region, you would eventually hit a hard wall. Azure enforces a strict **subscription-wide limit** for Key Vault transactions per region, which is capped at exactly **five times the individual key vault limit** [2, 5]. Brute-force scaling of vaults cannot scale infinitely.

**3. Why "Fan-out with in-memory caching" is the correct architectural choice**
When an application performs thousands of repeated GET operations for the exact same cryptographic key, you should optimize the architecture to eliminate unnecessary network calls to the Key Vault.
*   **The Fan-Out Pattern:** If your application consists of multiple compute nodes that all need the same key, Microsoft explicitly recommends using a "fan-out" pattern. In this design, one single entity reads the key from Azure Key Vault and distributes (fans out) the value to all the other nodes [6]. 
*   **In-Memory Caching and Local Execution:** Once retrieved, the nodes must cache the key strictly in memory [6]. Your application should perform its public-key operations (like encryption or verification) locally using the cached key material rather than asking the Key Vault to do it [7]. You only force the application to re-read from Azure Key Vault if the cached copy stops working, such as when a key is rotated at the source [8].

This caching approach drastically reduces the Requests Per Second (RPS) sent to the Key Vault, definitively prevents HTTP 429 throttling errors, and vastly improves the application's overall performance and resiliency [5, 7, 8].

**Architectural Takeaways for the AZ-305 Exam:**
When designing high-throughput Key Vault architectures, memorize these rules:
*   **Throttling (HTTP 429):** Exceeding Key Vault service limits results in HTTP 429 (Too Many Requests) errors [4]. Your clients must be designed to handle these by using exponential back-off retries [5].
*   **Subscription Limits:** You cannot infinitely bypass throttling by adding more vaults to a region. The total transactions across all vaults in a single subscription and region cannot exceed 5 times the single-vault limit [2, 5].
*   **Caching is King:** Always recommend **in-memory caching**, local cryptographic execution, and fan-out patterns for high-throughput secret or key retrieval workloads [6-8].