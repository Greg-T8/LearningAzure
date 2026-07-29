# Microsoft Entra External ID MAU Billing Architecture

Great job on selecting the correct answer! Your calculation perfectly demonstrates how Microsoft Entra External ID handles billing for customer-facing applications. 

Here is a detailed breakdown of how the Monthly Active Users (MAU) billing model works and what you should remember for the AZ-305 exam:

**1. What is a Monthly Active User (MAU)?**
Microsoft Entra External ID billing is based on MAUs, which counts the number of unique users who perform an authentication activity within a given calendar month [1, 2]. In a dedicated external tenant (used for Customer Identity and Access Management, or CIAM), every active user counts toward this MAU total, regardless of their specific `UserType` [3]. 

**2. The 50,000 Free Tier (The Math)**
To help organizations scale cost-effectively, Microsoft provides the **first 50,000 MAUs for core External ID features completely free of charge** [2-4]. 
Because your scenario states that there are 60,000 active users, the math is straightforward:
*   60,000 Total Active Users
*   Minus 50,000 Free Users
*   **= 10,000 Billable Users**

**3. Premium Add-ons Do Not Have a Free Tier**
While core identity features benefit from the 50,000 free MAU tier, it is important to know that **premium add-ons do not have a free tier** [5]. If your architecture includes advanced scenarios, you will pay for those from the very first transaction or user. For example:
*   **SMS Phone Authentication:** Billed per transaction/message [6].
*   **Go-Local:** An MAU-based add-on to ensure data residency strictly in Australia or Japan [3, 7].
*   **Machine-to-Machine (M2M) Authentication:** Billed per transaction for background services authenticating without user interaction [6].

**Architectural Takeaway for the AZ-305 Exam:**
When designing a CIAM solution, remember that an external tenant is an isolated environment tailored for your consumers and business customers [8]. Because it is isolated, **an external tenant cannot natively own its own Azure subscriptions** [3]. In order to actually pay for those 10,000 billable users (and any premium add-ons), an architect must link the external tenant's billing to an Azure subscription owned by the organization's primary workforce tenant [3].