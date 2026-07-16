# Incompatibility Between Azure Monitor and Compacted Event Hubs

Great job on nailing that question! This scenario highlights a specific architectural incompatibility between Azure Monitor's routing engine and advanced Event Hubs features.

Here is a breakdown of why this configuration fails and how these two services interact:

**1. How Log Compaction Works**
By default, Event Hubs uses a time-based retention policy where events are simply purged after a certain amount of time expires [1]. **Log compaction** changes this behavior to an event-key-based retention model [1]. Instead of keeping a full historical log, a compacted event hub retains only the latest event for each unique key, which is useful for maintaining a current state without storing the entire history [1, 2]. To accomplish this, the Event Hubs compaction engine relies on the **partition key** attached to the incoming event to act as the compaction key [3]. 

**2. Azure Monitor's Missing Keys**
When you create a diagnostic setting for an Azure resource (like a Load Balancer), Azure Monitor acts as the event producer streaming those resource logs to your Event Hubs destination. However, **Azure Monitor does not supply or attach a partition key to the log records it exports** [4, 5]. 

**3. The Architectural Conflict**
Because Azure Monitor's output completely lacks the partition key, the Event Hubs log compaction engine has no way to identify, match, or group the incoming log events [4, 5]. As a result, attempting to route Azure Monitor diagnostic settings (or Log Analytics workspace data exports) to a compacted event hub is an invalid configuration, and the route cannot be used [5]. 

If an architect needs to route platform logs to an Event Hub, they must ensure the destination event hub uses standard time-based retention rather than log compaction.