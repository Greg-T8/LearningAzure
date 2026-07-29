# Securing Outbound Connectivity for Azure Managed Grafana

Your choice of applying an Azure Monitor Private Link Scope (AMPLS) was a very logical guess, as AMPLS is the standard architectural method for securing inbound traffic to Azure Monitor resources. However, this question tests how a fully managed service connects *outbound* to a private data source. 

Here is a breakdown of why your answer was incorrect and why a Managed Private Endpoint is the correct configuration:

**1. Why "AMPLS on the Grafana VNet" is incorrect:**
Azure Managed Grafana is a fully managed service, which means the underlying virtual machines that run your Grafana servers are hosted in a Microsoft-managed virtual network, not a VNet within your own subscription [1]. Because you do not own or control this underlying Grafana VNet, you cannot manually deploy or link an AMPLS to it. 

**2. Why "Managed Private Endpoint" is the correct answer:**
To solve the problem of securely connecting Grafana's Microsoft-managed network to your Azure data sources (like an Azure Monitor workspace), Azure Managed Grafana provides **Managed Private Endpoints** [1]. 

When you configure a Managed Private Endpoint in your Grafana workspace, Azure creates and manages a private IP address within its own Managed Virtual Network on your behalf [1, 2]. This establishes a direct private link to the target Azure Monitor workspace, ensuring that traffic between Grafana and the workspace travels entirely over the secure Microsoft backbone network rather than traversing the public internet [2]. 

**3. The Complete Architecture Picture:**
It is important to understand that securing this connection actually requires configuration on *both* sides of the transaction:
*   The **Azure Monitor workspace** must have its public query access disabled and its own private access configured (which may utilize an AMPLS for your own client VNets) [3].
*   The **Azure Managed Grafana workspace** *additionally* requires the deployment of a managed private endpoint so its queries are kept off the public internet [3, 4]. 

**Architectural Takeaway:**
When taking the AZ-305 exam, remember that whenever a fully managed service (like Azure Managed Grafana) needs to securely reach into another Azure resource (like an Azure Monitor workspace, Azure Data Explorer, or Cosmos DB) without using the internet, the correct architectural choice is to configure a **Managed Private Endpoint** within the managed service itself [1, 5, 6].