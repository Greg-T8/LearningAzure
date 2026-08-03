# Distinguishing Managed HSM via the Security Domain

You’re getting very close! The "tell" in this question—and a common trap in the AZ-305 exam—is the specific mention of the **"Security Domain."**

While both Azure Cloud HSM (Dedicated HSM) and Managed HSM offer single-tenancy and FIPS 140-3 Level 3 compliance, the **Security Domain** is a specific technical component unique to **Azure Key Vault Managed HSM**. 

As we discussed in a previous scenario, the Security Domain is the encrypted blob that acts as your root of trust. You initialize it by providing a quorum of RSA keys, ensuring that *you* have absolute administrative control over the HSM's identity and recovery. If a question mentions "Security Domain," it is almost always pointing you toward Managed HSM.

In contrast, **Azure Cloud HSM** (Dedicated HSM) provides administrative control over the physical appliance and its hardware, but it doesn't use the "Security Domain" architecture to manage the root of trust and recovery in this specific way.

Would you like me to create a quick comparison table of the different HSM tiers in Azure to help you distinguish them for the exam?