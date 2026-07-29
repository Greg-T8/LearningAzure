# Architecture and Limits of Microsoft Private Network Connectors

It is very easy to confuse these numbers because 500 is a critical hard limit elsewhere in the Microsoft Entra secure access ecosystem. However, for the private network connectors themselves, the capacity limit is much lower. 

Here is a detailed breakdown of why your answer was incorrect, how the connector architecture manages load, and the specific limits you must memorize for the AZ-305 exam:

**1. The 200 Concurrent Connection Limit**
When a user accesses a published application, the private network connector processes the request and then opens an outbound connection to the application proxy service instance to return the data [1]. By default, each individual connector is strictly limited to a maximum of **200 concurrent outbound connections** [2], [3], [1]. 

**2. Designing for Scale and High Availability**
Because a single connector is capped at 200 connections, an architect must design for scale by adding more connectors. 
*   **The Recommendation:** Microsoft requires at least **two connectors** in a production connector group to ensure basic high availability, but explicitly recommends **three connectors** [2], [3]. 
*   **Why three?** Having three connectors provides an extra buffer of connection capacity so that if one server goes offline for patching or fails, the remaining connectors can seamlessly absorb the traffic [2], [3], [4]. 
*   **Load Distribution:** You do not need to configure a traditional load balancer in front of the connectors. The application proxy cloud service distributes requests across its available instances, which naturally and randomly distributes the load almost evenly across the active connectors in the group [2], [5], [6].

**3. Why 500 is a Common Trap**
You likely guessed 500 because it is another strict architectural boundary related to these exact same connectors. Microsoft Entra Private Access uses the identical private network connector as Application Proxy [7]. If you are designing a Private Access enterprise application, that application supports a strict maximum of **500 application segments** [8]. The exam will frequently mix limits from Private Access and Application Proxy to test your precision.

**Architectural Takeaway for the AZ-305 Exam:**
When sizing and designing remote access using private network connectors, memorize these specific numbers:
*   **Concurrent Connections:** A single connector supports a maximum of **200 concurrent outbound connections** [2], [3].
*   **Connector Group Size:** Always deploy a minimum of **2** connectors for high availability, but aim for **3** for optimal maintenance capacity [2], [3].
*   **Private Access Segments:** A single Private Access enterprise application can hold a maximum of **500 application segments** [8].