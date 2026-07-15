# Azure Diagnostic Logging: Control Plane vs. Data Plane

Your choice of **"Activity Log"** was incorrect because it confuses Azure *control-plane* operations with *data-plane* operations. 

Here is a breakdown of why your answer was wrong and why "Runtime audit logs" is the correct architectural choice for this scenario:

**Why "Activity Log" is incorrect:**
In Azure, the **Activity Log** is strictly used to record **subscription control-plane operations** [1]. This means it tracks management events from the outside of the resource, such as who created the Event Hub, who modified its configuration, or who deleted it [2]. It does *not* look inside the resource to capture the actual data traffic, payloads, or messaging operations flowing through it [1, 3].

**Why "Runtime audit logs" is the correct answer:**
To monitor **data-plane interactions**—which are the actual activities of client applications connecting to the Event Hub to publish or consume events—you must configure resource logs via diagnostic settings. Specifically, Azure Event Hubs provides a log category called **Runtime audit logs** [4]. 

By enabling "Runtime audit logs" in the diagnostic settings of the Event Hubs namespace, you instruct the platform to capture aggregated diagnostic information explicitly for data-plane access operations, satisfying the architect's requirement [4]. 

**Architectural Takeaway:**
When designing a logging solution for the AZ-305 exam, always differentiate between the control plane (management actions, automatically logged by the Activity Log) and the data plane (service-specific usage and data access, which requires you to manually configure resource logs) [1]. 

*Note: As an additional architectural constraint, Event Hubs Runtime audit logs are only available in the Premium and Dedicated pricing tiers [5, 6].*