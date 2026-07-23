# Architecting HR-Driven Identity Lifecycle Automation

Great job on selecting the correct answer! This question tests your knowledge of identity lifecycle automation and how to establish a system of record as the single source of truth for your identities.

Here is a detailed breakdown of HR-driven provisioning, how it routes different types of users, and what you should remember for the AZ-305 exam:

**1. The HR System as the Source of Authority**
HR-driven provisioning is the process of creating and managing digital identities based directly on data from a human resources system [1]. In this architecture, an HR platform like Workday or SAP SuccessFactors becomes the authoritative source for workforce identity data [2]. Whenever a change happens in the HR system, it serves as the starting point to trigger automated provisioning processes downstream [1, 2]. 

**2. Routing Cloud-Only vs. Hybrid Users**
As your question highlights, this feature handles the two primary types of workforce accounts differently depending on your infrastructure:
*   **Cloud-only users:** If a user does not need access to legacy on-premises resources, the provisioning service creates their user account directly from the cloud HR app into Microsoft Entra ID [3]. 
*   **Hybrid users:** If a user requires access to on-premises resources, the provisioning service first creates their user account in on-premises Active Directory [3]. From there, a synchronization engine (like Microsoft Entra Connect Sync or Cloud Sync) takes over to synchronize that Active Directory account up to Microsoft Entra ID [1, 4, 5].

**3. Automating the Joiner-Mover-Leaver (JML) Lifecycle**
By tying identity directly to HR records, the organization can fully automate the Joiner-Mover-Leaver process [6]:
*   **Joiners (New Hires):** When a new employee is added to Workday, their accounts are automatically created in the necessary directories, granting them immediate access to tools on day one [7, 8].
*   **Movers (Updates):** If an employee gets promoted, changes departments, or gets a new manager in the HR app, their profile and attributes are automatically updated in Active Directory and Microsoft Entra ID [7]. 
*   **Leavers (Terminations):** When an employee is terminated in the HR system, their accounts are automatically disabled across the directories, mitigating security risks [7].

**Architectural Takeaway for the AZ-305 Exam:**
When designing identity management solutions, you must pay close attention to the **direction of authority** [9]. 
*   If a scenario states that an HR system or custom system of record must authoritatively *create* workforce identities, **HR-driven provisioning** (or **API-driven inbound provisioning** for custom systems) is the correct choice [9, 10]. 
*   Conversely, if the scenario states that Microsoft Entra ID must create and manage accounts in downstream third-party SaaS applications, you should choose **outbound application provisioning** [9, 10].