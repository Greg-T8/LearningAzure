# Automated Network Forensics via Azure Functions and Watcher

Your choice highlights an advanced, event-driven security architecture used to automatically respond to network anomalies when human administrators aren't actively watching [1]. 

Here is a breakdown of why this combination is the recommended best practice for this scenario:

**1. Deep Inspection with Network Watcher Packet Capture**
While tools like flow logs only provide high-level 5-tuple metadata about traffic, **packet capture provides the actual packet-level payload data** needed to investigate complex network intrusions, debug communications, and detect network misuse [2-4]. Because packet captures are highly configurable, you can set a precise **Time limit per session** (such as 600 seconds for a 10-minute capture) so that it gathers exactly what you need and then automatically stops [5, 6].

**2. Event-Driven Automation via Azure Functions**
Because cloud resources run continuously, it is difficult to manually trigger a packet capture the exact moment an intrusion occurs, such as at 2:00 AM [1]. By using an **Azure Function**, you create an automated programmatic bridge between your security alerts and the Network Watcher service [1, 4].

**How the End-to-End Workflow Operates:**
*   **Detection:** A specific security incident or threshold (such as an unusual spike in network traffic) triggers an alert rule on your virtual machine [7-9].
*   **Action:** The alert rule uses an Action Group configured to call your custom Azure Function [10, 11].
*   **Execution:** The Azure Function processes the alert payload and programmatically calls the Network Watcher API to start the packet capture session on the specific, compromised VM [8, 12].
*   **Storage and Analysis:** The capture runs for the requested 10-minute window, collects the traffic, and securely uploads the resulting `.cap` file to an Azure storage blob or the local VM disk [4, 8, 13].

By combining these tools, you ensure that the moment a threat is detected, the detailed payload evidence is securely recorded for your security analysts to examine using tools like Wireshark, without requiring any manual intervention [8, 14].