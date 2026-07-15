# Principles of Automated Network Watcher Deployment

Your choice to require a dedicated VM was incorrect because it confuses the overall Network Watcher service architecture with the requirements for specific endpoint extensions. 

Here is a detailed breakdown of why your answer was wrong and why the correct answer highlights the standard Azure behavior:

**Why "Network Watcher requires a dedicated virtual machine" is incorrect:**
Azure Network Watcher is a fully managed backend service provided by the Azure platform `[1]`. You never need to deploy or manage a dedicated, standalone virtual machine to act as a central monitoring server or appliance in each region. 

It is true that certain advanced diagnostic features (such as Packet Capture, Connection Monitor, or Connection Troubleshoot) require a lightweight **Network Watcher Agent extension** to be installed on the *specific* virtual machines you are actively monitoring `[2, 3]`. However, this is just a guest-level extension added to your existing workloads, not dedicated infrastructure required to run the service itself. 

**Why "Network Watcher is automatically enabled..." is the correct answer:**
Microsoft specifically designed Network Watcher to minimize management overhead for architects. By default, the moment you **create or update a virtual network in a subscription, Azure automatically enables a Network Watcher instance in that virtual network's region** `[4-6]`. 

When this automatic enablement occurs:
*   Azure creates a unique regional instance of the service (for example, `NetworkWatcher_eastus`) `[7]`.
*   This instance is placed into an automatically generated resource group, which is typically named `NetworkWatcherRG` `[8]`.
*   There is no impact on your existing resources and no associated charge just for having the service automatically enabled `[5, 6]`. 

Because of this automated behavior, the lead architect in your scenario does not have to manually provision Network Watcher infrastructure every time they expand their distributed application to a new region. Azure natively ensures the diagnostic tools are available as soon as the virtual network is deployed.