# Entra Domain Services Enterprise SKU Replica Set Architecture

It is completely understandable why you might guess "Premium," as Premium tiers across Azure services often unlock advanced geographic and high-availability features. However, for Microsoft Entra Domain Services, this capability unlocks one tier lower.

Here is a detailed breakdown of why "Enterprise" is the correct answer and how replica sets are tiered for your AZ-305 exam preparation:

**1. The Enterprise SKU Baseline**
In Microsoft Entra Domain Services, **Enterprise** is both the default SKU and the strict minimum SKU required to deploy additional replica sets [1, 2]. While the Premium SKU certainly supports replica sets, it is not the *minimum* requirement. If an organization is currently using the baseline Standard SKU, they must upgrade to at least the Enterprise SKU before the platform will allow them to expand their managed domain into new Azure regions [3]. 

**2. The Purpose of Replica Sets**
When you create a managed domain, it deploys an initial replica set (two domain controllers) in your selected Azure region [4, 5]. To improve authentication availability, bring authentication closer to your users, or provide geographical disaster recovery for legacy applications, you can create additional replica sets in other peered virtual networks across different Azure regions [6, 7]. 

**3. Limits to Remember for the Exam**
If you see other design questions regarding Domain Services replica sets, keep these architectural limits in mind:
*   **Maximum sets:** A managed domain supports an absolute maximum of **5 replica sets** (your initial set plus up to 4 additional sets) [1, 8].
*   **Billing:** You are billed per hour for *each* deployed replica set based on your managed domain's configured SKU [1, 3].
*   **Networking:** The virtual networks that host your replica sets must be fully meshed using virtual network peering, as peered virtual networks are not transitive [1, 9].
*   **SKU downgrades:** If you have deployed multiple replica sets using the Enterprise or Premium SKU, you cannot downgrade back to the Standard SKU, because Standard does not support multiple replica sets [3].