# Cross-Tenant Data Governance: Lighthouse versus Entra B2B Access

It is completely understandable why you chose "Storage Blob Data Contributor via a Lighthouse delegation." You correctly identified that `Storage Blob Data Contributor` is the least-privilege role needed to manage blob data, and Azure Lighthouse is the standard tool for cross-tenant management. However, this question exposes a strict, deliberate architectural limitation of Azure Lighthouse.

Here is a detailed breakdown of why your answer was incorrect and how cross-tenant authorization works for your AZ-305 exam preparation:

**1. The DataActions Limitation in Azure Lighthouse**
Azure Lighthouse allows a service provider to project customer resources into their own tenant and manage them using Azure built-in roles [1, 2]. However, Azure Lighthouse is strictly designed for **management-plane (control-plane)** operations. It explicitly **does not support the Owner role, custom roles, or any roles containing DataActions** [1, 3]. 

Because `Storage Blob Data Contributor` relies on `DataActions` to read, write, and delete the actual contents of the blobs, you are technically blocked from selecting this role in an Azure Lighthouse delegation [1, 4]. 

**2. Separating Management from Data Access**
If a service provider needs to perform cross-tenant Azure management but *also* needs to read or write customer data, you must separate the management delegation from the data-access design [4]. 

Because Lighthouse rejects explicit data-plane roles, you cannot use it to fulfill the data access requirement [4]. Instead, you must use a standard, customer-approved data-access model [5]. The correct workaround is to have the customer create a **guest account (Microsoft Entra B2B)** for the provider in the customer's own tenant, and assign the `Storage Blob Data Contributor` role directly to that guest account [5, 6]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing cross-tenant access for a service provider, pay very close attention to whether they are managing the *resource* (control plane) or accessing the *data* (data plane):
*   If they need to configure VMs, deploy storage accounts, or manage policies across many customers without creating guest accounts, **Azure Lighthouse** is the correct choice [5].
*   If the scenario explicitly requires them to read customer data (like Blob data, SQL rows, or Key Vault secrets), **Lighthouse cannot do this**. You must recommend an alternative like **Microsoft Entra B2B guest accounts** for that specific data-plane access [4, 5].