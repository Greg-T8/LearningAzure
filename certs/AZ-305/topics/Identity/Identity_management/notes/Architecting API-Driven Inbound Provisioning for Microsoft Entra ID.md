# Architecting API-Driven Inbound Provisioning for Microsoft Entra ID

Great job on selecting the correct answer! This question tests your knowledge of identity lifecycle automation, specifically how to integrate custom systems of record and the strict scale boundaries of the provisioning API.

Here is a detailed breakdown of how API-driven inbound provisioning works, why it handles this volume of requests, and what you should remember for your architectural designs:

**1. Integrating Custom Systems of Record**
While major platforms like Workday and SAP SuccessFactors have prebuilt, native HR-driven provisioning connectors, many organizations use custom-built databases, flat files, or CSVs as their authoritative system of record [1, 2]. **API-driven inbound provisioning** is designed specifically to bridge this gap. It allows IT teams to use automation tools (like Azure Logic Apps or PowerShell scripts) to read data from these arbitrary sources and send it to Microsoft Entra ID [2]. 

**2. The 300,000 Record Scale Boundary**
Your scenario required processing up to 250,000 records in a 24-hour period. API-driven inbound provisioning uses the `/bulkUpload` API endpoint, which enforces the following strict throttling quotas:
*   **Call limits:** The API allows 40 calls per 5 seconds, and a maximum of **6,000 calls per 24 hours** [1, 3]. 
*   **Record limits:** Each API call can contain a payload of up to **50 records** [1, 4].

By optimizing your payloads to include the maximum 50 records per call, the service supports a documented maximum of **300,000 records per 24 hours** before hitting the call quota [1, 4]. Because 250,000 updates fall safely under this 300,000-record ceiling, API-driven provisioning is a fully supported design.

**3. Asynchronous vs. Standard SCIM Processing**
Even though the inbound API requires payloads formatted in the standard SCIM schema (`application/scim+json`), it is highly important to know that **it is not a standard, general-purpose SCIM server endpoint** [1, 5]. 

In a standard SCIM implementation, the calling client must figure out the operation semantics (i.e., it must tell the server whether to "Create," "Update," or "Delete" an identity) [6]. With API-driven inbound provisioning, your custom HR database doesn't need to do any of this complex comparison logic [7, 8]. The database simply sends the raw identity data in a bulk request, and the Microsoft Entra provisioning service processes the payload asynchronously [1, 9]. The Entra service takes over the responsibility of comparing the profiles, applying scoping rules, running attribute transformations, and determining the correct creation or update operations [9-11].

**Architectural Takeaway for the AZ-305 Exam:**
When designing identity management solutions, always evaluate the **direction of authority** and the source system [12].
*   If a native HR system (Workday/SuccessFactors) is the authoritative source for creating identities, choose **HR-driven provisioning** [12].
*   If a custom HR database or arbitrary system of record must authoritatively create identities, choose **API-driven inbound provisioning** [5, 12]. 
*   If Microsoft Entra ID is the authority and needs to create and deprovision accounts in downstream SaaS applications, choose **outbound application provisioning** [12].