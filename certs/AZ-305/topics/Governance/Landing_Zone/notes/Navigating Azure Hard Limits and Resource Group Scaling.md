# Navigating Azure Hard Limits and Resource Group Scaling

In Azure architecture, distinguishing between a **soft quota** (which can be increased via a support request) and a **hard platform limit** (which is baked into the platform's control plane) is a vital skill tested on the AZ-305 exam. 

Here is a detailed breakdown of why your answer was incorrect and why distributing resources across resource groups is the correct design decision:

### 1. Why "Request a Quota Increase" is Incorrect (Hard vs. Soft limits)
Azure categorizes service limits into two categories:
*   **Soft limits (Adjustable):** These can be increased by submitting a support ticket [1, 2]. Examples include subscription-level limits, such as the regional virtual machine (VM) core quota [3, 4] or the number of standard storage accounts per subscription, which can be raised from 250 to 500 upon request [5, 6].
*   **Hard limits (Non-adjustable):** These are architectural limits coded directly into the Azure Resource Manager (ARM) engine [1, 2]. The limit of **800 instances of a specific resource type per resource group** is a hard ceiling [7, 8]. It is completely non-adjustable, meaning Microsoft Support does not have the capability to increase this limit for any subscription or resource group [1, 2].

### 2. Why "Distribute across multiple resource groups" is the Correct Solution
To design a solution that scales past this limit, you must scale horizontally using Azure's built-in resource hierarchy:
*   **Leverage Subscription Limits:** While an individual resource group is limited to 800 resources of a single type [8], a single subscription can contain up to **980 resource groups** [9].
*   **Multiply Your Capacity:** By distributing your log storage instances across multiple resource groups within the same subscription, you bypass the 800-limit per group [8]. Each new resource group has its own independent limit of 800 storage accounts [8].
*   **Maintains Lifecycle Management:** The fundamental rule of resource group design is that **all resources in a resource group should share the same lifecycle** (meaning they are deployed, updated, and deleted together) [10]. If you split your log storage accounts across multiple resource groups—perhaps grouping them by month, business unit, or application tier—you can still apply the exact same lifecycle rules to each group [10, 11]. This fulfills the requirement of "maintaining the current lifecycle management" of the logs.

### Summary for the AZ-305 Exam:
*   **Resource Group Limits:** Resource group boundaries (like 800 resources per type [8] or 980 resource groups per subscription [9]) are **hard ceilings** that cannot be modified via support tickets [1, 2].
*   **Horizontal Partitioning:** The only supported way to scale past resource group limits is to **partition your resources horizontally** across multiple resource groups [12] or, for extremely large workloads, across multiple subscriptions [13, 14].

***

📐 Since resource group organization and subscription design are closely linked to landing zone architectures, would you like to review when a workload warrants its own dedicated subscription versus when it can be isolated within separate resource groups in a shared subscription?