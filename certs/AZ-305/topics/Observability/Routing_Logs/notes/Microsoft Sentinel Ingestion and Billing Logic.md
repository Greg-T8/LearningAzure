# Microsoft Sentinel Ingestion and Billing Logic

Your choice was incorrect because it misidentifies what actually triggers Microsoft Sentinel's workspace-wide pricing model. 

Here is a detailed breakdown of why your answer was wrong, and why the correct answer accurately reflects how Azure Monitor and Microsoft Sentinel interact:

**Why your answer was incorrect:**
While it is true that all data in a Log Analytics workspace becomes subject to Microsoft Sentinel pricing, this happens **if and when Microsoft Sentinel is enabled on the workspace**, not when you integrate a specific log source [1]. 

Because the scenario states that you are routing logs to correlate with "other security data in Microsoft Sentinel," the workspace already has Sentinel enabled. Therefore, the workspace's billing model is already established. Routing Microsoft Entra logs to this workspace simply adds those specific identity logs to the bill; it does not trigger a new behavior that suddenly causes Sentinel to begin charging for all other, non-security data in the workspace [1].

**Why the correct answer is right:**
Microsoft Sentinel does not use a separate, proprietary ingestion pipeline for Microsoft Entra data; it sits on top of Azure Monitor. 

In Microsoft Sentinel, certain data connectors—including the Microsoft Entra ID connector—are natively based on underlying Azure Monitor diagnostic settings [2]. When you integrate Microsoft Entra logs with Azure Monitor by configuring a diagnostic setting to send the logs to your Sentinel-enabled workspace, you are establishing the exact data pipeline that Sentinel relies on. Because Sentinel recognizes this underlying diagnostic setting configuration, the **Microsoft Entra data connector in Microsoft Sentinel detects the data flow and is automatically enabled** (marked as "Connected"), without requiring you to configure a separate, redundant connection inside the Sentinel portal.