# Architectural Resilience in Microsoft Entra Cloud Sync

Great job on selecting the correct answer! This question tests your understanding of how high availability is designed in modern, cloud-native synchronization architectures compared to legacy models. 

Here is a detailed breakdown of how Microsoft Entra Cloud Sync handles high availability, why three agents are recommended, and the specific architectural behaviors you need to know for the AZ-305 exam:

**1. The "Rule of 3" for High Availability**
Microsoft officially recommends deploying **3 active Cloud Sync agents** to achieve high availability [1, 2]. By installing and running multiple active agents across different servers, you ensure that Microsoft Entra Cloud Sync can continuously function even if an underlying server experiences an outage or an agent fails [2]. When deploying these agents, it is critical to place them on different physical hosts or separate failure domains so that a localized hardware issue does not take down your entire synchronization capability [3].

**2. Failover vs. Load Balancing (The Exam "Gotcha")**
You must understand exactly *how* these multiple agents work together. While multiple agents provide excellent failover, **they do not load-balance a synchronization job** [1, 4, 5]. When a sync job is scheduled, only one single agent processes that specific job at a time [1, 3-5]. Therefore, adding extra agents to your environment improves your overall availability and resilience, but it does *not* increase your synchronization throughput [3]. 

**3. No "Staging Mode" Required**
If you are familiar with the legacy Microsoft Entra Connect Sync architecture, you might remember that high availability required setting up a separate "staging server" to act as a warm, passive standby [6]. Cloud Sync fundamentally changes this. Because Cloud Sync stores its configuration and runs its orchestration entirely in the cloud, **it has no staging-server mode** [1, 4, 5]. Instead, it relies natively on its fleet of active, lightweight provisioning agents to handle redundancy [4, 7, 8]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing a new hybrid identity solution, Cloud Sync is the strategically recommended direction because it greatly simplifies high availability [5]. You do not need to design complex passive staging servers or worry about manually failing over databases [4, 7]. You simply deploy **3 active agents** [1], and the cloud service automatically handles failover by routing the next synchronization job to a healthy agent if one goes offline [1, 3].