# Azure Event Hubs Tiering for Multi-Consumer Architectures

Great job on selecting the correct answer! Your choice perfectly identifies a strict architectural limit within Azure Event Hubs regarding how downstream applications read streaming data.

Here is a breakdown of why upgrading to the Standard tier is the exact right architectural fit for this scenario:

**1. The Role of Consumer Groups**
In Azure Event Hubs, a **consumer group** provides an independent view of the event stream [1, 2]. This allows a consuming application (like a SIEM) to track its own reading progress and maintain its own checkpoints without interfering with other applications [2, 3]. If you have multiple, independent downstream applications that need to process the exact same event stream, **each application must have its own dedicated consumer group** so they can read at their own pace and maintain independent checkpoints [4, 5].

**2. The Basic Tier Limitation**
The core constraint in your scenario is that the Event Hubs **Basic tier only supports exactly one consumer group per event hub** [4, 6]. Because the customer's existing third-party SIEM is already using that single consumer group, there are no consumer groups left for the new security application to use [4, 7]. 

**3. Unlocking Capacity with the Standard Tier**
To support a second independent consumer, you must upgrade the namespace to the **Standard tier** (or higher) [7]. Upgrading to the Standard tier increases the limit to **20 consumer groups per event hub** [4, 6]. This provides the necessary capacity to assign the new security application its own consumer group, ensuring both systems can read the streaming logs simultaneously and independently [4, 5].

**Architectural Takeaway:**
When designing a logging solution that streams data via Event Hubs to external tools, you must always factor in the number of consumers. While the Basic tier might seem cost-effective, its single consumer group prevents independent checkpoints for multiple downstream applications, making the **Standard tier the minimum practical choice** when routing logs to several consumers [5, 7].