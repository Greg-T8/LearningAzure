# Azure Network Watcher Regional Enablement and Agent Deployment Logic

Your choice highlights a very common point of confusion between Azure's platform-level services and guest-level virtual machine agents.

Here is a breakdown of why your answer was incorrect and how Network Watcher actually behaves:

**1. The Correct Answer: Automatic Regional Enablement**
Azure Network Watcher is a regional service [1]. By default, the moment you create or update a virtual network (VNet) within your subscription, Azure **automatically enables a Network Watcher instance in that VNet's region** [2, 3]. This automatic, platform-level enablement operates in the background, ensures the service is ready for diagnostic use, and incurs no charges or impact on your resources [2, 3]. 

**2. Why your answer was incorrect**
Your answer confused the regional Network Watcher *service* with the Network Watcher *Agent VM extension*. The regional service itself does not require the VM extension to be installed in order to be enabled [1, 4]. 

Instead, the Network Watcher VM extension is a supplementary agent that you install on specific Virtual Machines only when you need to use advanced diagnostic tools that explicitly generate or intercept VM-level traffic [5, 6]. For example, features like **Packet capture, Connection monitor, and Connection troubleshoot** specifically require the Network Watcher VM extension to be present on the source VM to function [7]. 

**Architectural Takeaway:**
When designing a monitoring estate, you must separate the platform enablement from the resource enablement. While Azure automatically turns on the regional Network Watcher service when a VNet is created [1], **it does not automatically install the VM extensions on your compute resources** [4]. If your architecture requires continuous connectivity tracking or packet capturing, you must explicitly design a mechanism (such as Azure Policy) to deploy the Network Watcher extension to your VMs.