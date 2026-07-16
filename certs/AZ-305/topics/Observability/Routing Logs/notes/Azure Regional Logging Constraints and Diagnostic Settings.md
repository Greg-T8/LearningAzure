# Azure Regional Logging Constraints and Diagnostic Settings

Great job on selecting the correct answer! Your choice perfectly identifies a strict architectural boundary within Azure Monitor regarding how platform data is routed.

Here is a breakdown of why your answer was correct and why the existing West US storage account could not be used:

**1. The Strict "Same-Region" Constraint**
The most critical factor in this scenario is geographic location. When you use a diagnostic setting to route logs from a regional Azure resource (like a VM in the East US) to an Azure Storage account or an Event Hub, **the destination must reside in the exact same Azure region as the source resource** [1]. Because the existing 'auditlogs' storage account is located in the West US region, the Azure platform physically will not allow you to select it as a direct diagnostic setting destination for an East US virtual machine [2, 3]. 

**2. The "Standard" Tier Requirement**
Your selected answer specifies creating a *Standard* Storage account. This is another hard constraint built into the Azure platform: diagnostic settings can only route logs to **Standard** performance tier storage accounts [1]. Premium storage accounts are not supported as diagnostic-setting destinations [1]. 

**3. Minimizing Administrative Overhead**
The scenario requires minimizing administrative overhead and using "direct platform features." **Diagnostic settings** are the native, built-in routing mechanism for Azure resource logs [4]. While an architect *could* technically engineer a complex, custom pipeline to export logs to an Event Hub, process them with an Azure Function, and then write them across regions to the West US storage account, doing so would introduce massive management overhead and violate the scenario's constraints.

**Architectural Takeaway:**
When designing a logging solution for long-term archival using diagnostic settings, you must always provision a **Standard Storage account in the same region** as the resources you are monitoring [1, 2]. If your organization has strict requirements to centralize audit logs into a single, cross-regional storage bucket, you must first route the logs to a compliant same-region destination, and then use a secondary mechanism (like Object Replication) to copy the blobs to the final destination [2].