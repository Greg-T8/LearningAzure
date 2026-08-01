# Azure Key Vault RSA HSM Throttling Weights and Limits

Azure Key Vault manages its service limits using a weighted throttling system, where not all cryptographic operations are treated equally. This question tests your knowledge of how Azure Key Vault handles the heavy compute requirements of larger hardware-protected keys.

Here is a detailed breakdown of why your answer was incorrect and the specific throttling math you need to remember for the AZ-305 exam:

**1. The Throttling Limits**
In Azure Key Vault, transaction limits are evaluated over a 10-second interval per vault per region [1]. For standard cryptographic operations (which includes GET, Sign, or Decrypt actions, categorized as "All other transactions"), the service enforces the following strict limits for HSM-protected RSA keys:
*   For an **RSA 2,048-bit HSM-protected key**, you are allowed a maximum of **2,000 transactions per 10 seconds** [2, 3].
*   For an **RSA 4,096-bit HSM-protected key**, that limit drops dramatically to a maximum of just **250 transactions per 10 seconds** [2, 4].

**2. The Weight Calculation (Why the correct answer is right)**
Because Key Vault enforcement is based on a weighted sum, you can calculate exactly how much more "expensive" the larger key is by comparing their limits. When you divide the 2,048-bit limit by the 4,096-bit limit (2,000 / 250), the result is 8 [4]. Therefore, performing operations on a 4,096-bit HSM key is exactly **eight times more expensive** in terms of quota consumption than performing the same operations on a 2,048-bit key [4]. 

**3. Why your answer was incorrect**
It is very intuitive to assume that simply doubling the bit length (from 2,048 to 4,096) would only double the compute cost, making it "2 times as expensive." However, the mathematical complexity of RSA cryptography scales exponentially rather than linearly. Azure strictly enforces this 8x penalty to account for the heavy hardware processing required by the HSMs to manage the larger key sizes [4].

**Architectural Takeaways for the AZ-305 Exam:**
When designing a high-throughput Key Vault architecture, keep these throttling behaviors in mind:
*   **Shared Quotas:** The throttling thresholds are weighted, and enforcement is based on their sum [4]. You can mix and match transactions, provided their total weight does not exceed the limit. For example, in a 10-second interval, your application could successfully perform 248 RSA 4,096-bit GET transactions along with 16 RSA 2,048-bit GET transactions before hitting the ceiling [5].
*   **Throttling Response:** Once the sum of your weighted operations exceeds the allowed threshold, Key Vault will immediately throttle further requests and return an **HTTP status code 429 (Too Many Requests)** [4].
*   **Software vs. Hardware:** Software-protected keys are "cheaper" to process than HSM keys [3, 4]. For example, a 2,048-bit software key allows 4,000 GET transactions per 10 seconds, which means using the HSM-protected equivalent is twice as expensive as using the software version [3, 4].