# Configuring Mutual Trust for Microsoft Entra B2B Automation

Great job on selecting the correct answer! You have successfully identified a key security safeguard in Microsoft Entra's B2B collaboration architecture. 

Here is a detailed breakdown of how automatic invitation redemption works, why mutual trust is required, and how you should think about it for your architectural designs:

**1. The Mutual Trust Requirement**
When you invite an external partner to your Microsoft Entra tenant (B2B collaboration), the default behavior requires that guest user to manually accept an email invitation or consent prompt before they can access resources. If you want to bypass this prompt and configure the **automatic redemption of B2B invitations**, you use cross-tenant access settings [1]. However, because this seamlessly provisions access without the user's explicit manual consent, Microsoft enforces a strict mutual opt-in model. This means both organizations must explicitly enable the corresponding trust; enabling it on only one side is insufficient [1].

**2. Inbound vs. Outbound Policies**
To make the feature function correctly, the configuration must be mirrored on both sides of the relationship:
*   The administrator of the **target tenant** (the resource directory) must create an inbound cross-tenant synchronization policy that allows automatic redemption [2].
*   The administrator of the **source tenant** (the partner's home directory) must also enable an outbound policy for automatic redemption [2]. 

**3. What Happens if Misconfigured**
If you enable the setting in your tenant but your partner forgets to enable it in theirs, the Microsoft Entra synchronization engine will block the seamless onboarding. During operations like cross-tenant synchronization, this configuration mismatch will result in an `AzureDirectory B2BManagementPolicy CheckFailure` error [2]. To resolve this, you must ensure the partner organization updates their side of the cross-tenant access settings [2]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing identity solutions that bridge multiple organizations, remember that Microsoft Entra operates on a Zero Trust foundation. An administrator cannot unilaterally force an automatic redemption or synchronization experience onto another organization's users. Anytime a scenario asks about automating B2B collaboration flows without user interruption, ensure your design includes **coordinated administrative configuration in both the source and target tenants**.