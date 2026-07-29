# Microsoft Entra Application Proxy Timeout Configuration Limits

Great job on selecting the correct answer! You successfully identified a strict configuration boundary for publishing applications through Microsoft Entra Application Proxy.

Here is a detailed breakdown of how back-end request timeouts work and why you might need to adjust them for your architectural designs:

**1. The Default vs. Maximum Timeout**
When you publish an application via Microsoft Entra Application Proxy, the system enforces a timeout limit on how long it will wait for the back-end application to respond to a request. 
*   **Default Timeout:** Out of the box, the back-end application timeout is set to **85 seconds** [1, 2]. 
*   **Maximum Timeout (Long):** If you change this setting to "Long," the timeout is increased to an absolute ceiling of **180 seconds** [1, 2]. There is currently no way to extend the timeout beyond this 180-second limit [3].

**2. When to Use the "Long" Setting**
As an architect, you generally want to leave this setting at the default. You should only configure the timeout to "Long" if your application is known to be slow to authenticate and connect [2]. Common scenarios where extending the timeout is necessary include:
*   **Complex Database Queries:** If a client sends a request to a front-end web application, and that web app must then query a slow back-end database server, the client-side conversation might time out before the database is able to return the payload [4].
*   **Heavy Reporting:** Applications like Power BI Report Server or SQL Server Reporting Services (SSRS) might take several minutes to load massive datasets. If users receive an error page while trying to load a report, increasing the timeout to 180 seconds gives the back end more time to process and render the data [5].

**Architectural Takeaway for the AZ-305 Exam:**
When designing a remote access solution using Application Proxy, remember that **85 seconds** is the standard waiting period and **180 seconds** is the absolute maximum [1]. If a business scenario dictates that a transaction will regularly take longer than 3 minutes to process synchronously, Application Proxy's HTTP timeout limits will cut the connection, and you would need to redesign the application to process the request asynchronously.