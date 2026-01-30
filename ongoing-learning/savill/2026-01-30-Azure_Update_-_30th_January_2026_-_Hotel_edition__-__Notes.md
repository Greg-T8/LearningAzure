# Azure Update - 30th January 2026 - Hotel edition :-) - Exam Notes

**Video:** [https://www.youtube.com/watch?v=97b7TE_-kSM](https://www.youtube.com/watch?v=97b7TE_-kSM)  
**Duration:** 9:14  

*Generated on 2026-01-30 08:32*

---

## Table of Contents

- [Introduction and Setup](#introduction-and-setup)
- [New Videos and Passkey Profile Rollout](#new-videos-and-passkey-profile-rollout)
- [Compute Updates](#compute-updates)
- [Networking Updates](#networking-updates)
- [Storage Updates](#storage-updates)
- [Database Updates](#database-updates)
- [Azure Databricks AgentBricks GA](#azure-databricks-agentbricks-ga)
- [Microsoft Research Rho Alpha Model](#microsoft-research-rho-alpha-model)
- [Tenant Configuration Management APIs Preview](#tenant-configuration-management-apis-preview)
- [Closing Remarks](#closing-remarks)

## Introduction and Setup

**Timestamp**: 00:00:00 – 00:00:18

**Key Concepts**

- Overview of updated learning resources for Azure
- Introduction to the new passkey profile rollout across tenants

**Definitions**

- **Passkeys**: A new form of strong authentication that is phishing resistant and simpler to use.

**Key Facts**

- The passkey profile rollout is happening automatically to all tenants (both commercial and government) over the next couple of months.
- Passkeys provide stronger security by preventing phishing attacks and impersonation.

**Examples**

- None mentioned

**Key Takeaways 🎯**

- Check out the updated Azure learning resources and guidance.
- Understand the significance of passkeys as the new preferred authentication method.
- Be aware of the upcoming automatic passkey rollout to all tenants.

---

## New Videos and Passkey Profile Rollout

**Timestamp**: 00:00:18 – 00:01:04

**Key Concepts**

- Updated video content on learning Azure, including refreshed resources and guidance.
- Rollout of the new passkey profile to all tenants (commercial and government) over the next couple of months.
- Passkeys as a new preferred strong authentication method.
- Benefits of passkeys: phishing resistance and ease of use.

**Definitions**

- **Passkeys**: A strong authentication method that is phishing resistant, simpler to use, and cannot be tricked into authenticating a bad actor or a fraudulent site.

**Key Facts**

- The passkey profile rollout is automatic and applies to all tenants, both commercial and government.
- Rollout timeline: occurring over the next couple of months.
- Passkeys prevent authentication to lookalike or fraudulent sites.

**Examples**

- None mentioned specifically in this section.

**Key Takeaways 🎯**

- Check out the updated video on learning Azure for new resources and guidance.
- Be aware of the automatic passkey profile rollout and understand its security benefits.
- Passkeys improve security by preventing phishing attacks and simplifying authentication processes.

---

## Compute Updates

**Timestamp**: 00:01:04 – 00:03:38

**Key Concepts**

- Optimization of Java applications for cloud environments using a specialized command launcher.
- Introduction of new Azure VM SKUs with improved processor performance.
- Differentiation between general purpose, memory optimized, and compute optimized VM SKUs.
- Enhancements in networking and storage throughput on larger VM sizes.
- Availability of AMD-based VM SKUs with significant CPU improvements.
- Upcoming deprecation of Python 3.10 support for Azure Functions.

**Definitions**

- **Azure Command Launcher for Java (Jazz command)**: A preview tool that replaces the regular Java command in the JVM to automatically set optimized parameters for cloud environments, improving performance and efficiency across Azure Compute Services.
- **D & E v2 SKUs**: Azure VM SKUs using Intel Xeon 6 processors, offering up to 15% better processor performance compared to previous generations.  
  - D: General purpose VM SKU  
  - E: Memory optimized VM SKU
- **Azure Boost**: A feature providing enhanced networking (up to 400 Gbps) and storage throughput (up to 20 GB/s) on the largest VM sizes.
- **V7 SKUs (D, E, A, F series)**: Azure VM SKUs powered by 5th Gen AMD EPYC processors with Zen 5 cores, offering up to 35% CPU improvement over V6 SKUs.
- **Python 3.10 Support for Azure Functions**: Support ending in early October; users must upgrade to Python 3.13 or above.

**Key Facts**

- The Azure command launcher for Java (Jazz command) is currently in preview.
- D & E v2 SKUs use Intel Xeon 6 processors with up to 372 vCPUs.
- Memory optimized E SKUs can have up to 2.8 tebibytes of memory.
- Azure Boost provides up to 400 Gbps networking, 800,000 IOPS, and 20 GB/s storage throughput on the largest VM sizes.
- V7 SKUs run on 5th Gen AMD EPYC processors with Zen 5 cores, offering up to 35% CPU improvement over V6.
- Python 3.10 support for Azure Functions ends beginning of October; upgrade to Python 3.13+ required.

**Examples**

- Using the Jazz command instead of the regular Java command to automatically optimize JVM parameters for cloud deployments on Azure services such as VMs, AKS, and App Service.
- D & E v2 SKUs providing better performance for general purpose and memory optimized workloads.
- V7 SKUs offering AMD-based compute options with improved CPU performance.

**Key Takeaways 🎯**

- Use the Azure command launcher for Java (Jazz command) to optimize Java applications for cloud environments without manual tuning.
- Consider upgrading to D & E v2 SKUs for better Intel Xeon 6 processor performance and enhanced networking/storage capabilities.
- Explore V7 SKUs for AMD-based compute options with significant CPU improvements.
- Plan to upgrade Azure Functions from Python 3.10 to 3.13 or above before support ends in October.
- Understand the distinctions between general purpose (D), memory optimized (E), and compute optimized (F) VM SKUs to select the best fit for your workload.

---

## Networking Updates

**Timestamp**: 00:03:38 – 00:05:06

**Key Concepts**

- ExpressRoute scalable gateway (ERGW scale) has reached General Availability (GA).
- The gateway connects virtual networks to ExpressRoute circuits.
- ERGW scale supports dynamic scaling of bandwidth via scale units.
- Scale units can be adjusted automatically based on load.
- Pricing is based on the number of scale units used per hour.
- Redundancy is provided with multiple instances.
- Migration from existing AZ version ER gateways to ERGW scale is possible with no downtime.

**Definitions**

- **ExpressRoute scalable gateway (ERGW scale)**: A new SKU for ExpressRoute gateways that allows variable scaling of bandwidth by adjusting the number of scale units dynamically.
- **Scale unit**: A unit of bandwidth capacity in the ERGW scale gateway, providing 1 Gbps each.

**Key Facts**

- Each scale unit provides 1 Gbps of bandwidth.
- Up to 40 scale units can be allocated, allowing up to 40 Gbps bandwidth.
- Users can set minimum and maximum scale units to control scaling range.
- Billing is hourly and based on the number of scale units active.
- Migration from existing AZ version ER gateways to ERGW scale takes a couple of hours but maintains uptime (no downtime).

**Examples**

- None specifically mentioned beyond general usage of scale units and migration process.

**Key Takeaways 🎯**

- The ERGW scale gateway offers flexible, scalable bandwidth for ExpressRoute connections.
- Cost efficiency is improved by paying only for the scale units needed at any time.
- The gateway supports redundancy with multiple instances.
- Migration to the new scalable gateway is seamless with no service interruption.
- This update enhances network performance management in Azure virtual networks.

---

## Storage Updates

**Timestamp**: 00:05:06 – 00:05:39

**Key Concepts**

- Integration of Azure NetApp Files (ANF) with OpenShift virtualization
- Use of ANF volumes as persistent storage for virtual machines within OpenShift clusters
- Support for different Azure NetApp Files service levels in this context

**Definitions**

- **OpenShift Virtualization**: A feature within Azure Red Hat OpenShift that enables running virtual machines alongside containers on the same OpenShift cluster.
- **Azure NetApp Files (ANF)**: A high-performance file storage service in Azure that now supports use as persistent volumes for VMs in OpenShift virtualization.

**Key Facts**

- Azure NetApp Files support for OpenShift virtualization is currently in preview.
- ANF volumes can be used as persistent volumes for virtual machines running on OpenShift clusters.
- All different service levels of Azure NetApp Files are supported for these persistent volumes.

**Examples**

- Using ANF volumes as persistent storage for VMs running next to containers on an OpenShift cluster.

**Key Takeaways 🎯**

- OpenShift virtualization now supports Azure NetApp Files, enabling high-performance persistent storage for VMs.
- This integration allows leveraging the flexibility and performance tiers of ANF within OpenShift environments.
- The feature is in preview, so users should consider this when planning deployments.

---

## Database Updates

**Timestamp**: 00:05:39 – 00:06:02

**Key Concepts**

- Automatic minor version updates for PostgreSQL databases
- Maintenance and versioning handled as part of planned monthly updates

**Definitions**

- **Minor Version Updates**: Incremental updates to a software version that typically include bug fixes, security patches, and minor improvements without major feature changes.

**Key Facts**

- PostgreSQL minor versions supported include: 18.1, 17.7, 16.11, 15.15, 14.20, and 13.23
- These minor version updates occur automatically during planned monthly maintenance
- No manual intervention is required to receive these updates

**Examples**

- None mentioned

**Key Takeaways 🎯**

- PostgreSQL minor version updates are automatically applied as part of routine maintenance
- Users do not need to take any action to benefit from these updates
- Staying current with minor versions helps maintain security and stability without downtime or manual updates

---

## Azure Databricks AgentBricks GA

**Timestamp**: 00:06:02 – 00:07:02

**Key Concepts**

- Introduction of AgentBricks knowledge assistance in Azure Databricks, now generally available (GA).
- AgentBricks enable creation, deployment, and management of AI agents within the Azure Databricks platform.
- Integration of data and AI capabilities through multiple specialized agent bricks.
- Use of an integrated MCP (Microsoft Cloud Partner) catalog to access additional tools and knowledge.
- Automated model selection based on specified use case and data to optimize agent system performance.
- Supported use cases include information extraction, custom large language models (LLMs), knowledge assistance, multi-agent supervisors, custom agent coding, and AI-driven business intelligence (BI) genie.

**Definitions**

- **AgentBricks**: Modular AI agents within Azure Databricks designed to unify data and AI capabilities by enabling tailored AI agent creation, deployment, and management.
- **MCP Catalog**: An integrated catalog providing additional tooling and knowledge resources for AgentBricks.

**Key Facts**

- AgentBricks GA release enables streamlined AI agent workflows inside Azure Databricks.
- The system automatically tries different AI models to find the best fit based on user-specified use case and data.
- Key use cases supported:
  - Information extraction
  - Custom LLMs
  - Knowledge assistance
  - Multi-agent supervisors
  - Custom agent coding
  - AI BI genie

**Examples**

- None specifically detailed in this segment; however, use cases such as information extraction and custom LLMs were mentioned as supported scenarios.

**Key Takeaways 🎯**

- Azure Databricks AgentBricks GA represents a significant step in integrating AI agent capabilities directly into the Databricks environment.
- The platform simplifies AI agent deployment by automating model selection based on use case and data.
- The MCP catalog enhances extensibility by providing additional tools and knowledge resources.
- Multiple practical AI agent use cases are supported, enabling diverse applications from data extraction to AI-driven business intelligence.

---

## Microsoft Research Rho Alpha Model

**Timestamp**: 00:07:02 – 00:08:03

**Key Concepts**

- Rho Alpha model is a Microsoft Research project.
- It is based on the Microsoft Research Pi Vision Language family of models.
- The model converts natural language commands into control signals for physical robotics.
- It enables robots to perform actions and respond to tactile feedback.
- Developed in partnership with the University of Washington and NVIDIA.
- Represents advancement in AI interaction with the physical world.

**Definitions**

- **Rho Alpha model**: A model that translates natural language instructions into robotic control signals, allowing robots to perform physical actions and react to tactile sensing.
- **Control signals**: Commands sent to a robot to direct its movements or actions.
- **Tactile sensing**: The robot’s ability to perceive and respond to touch or physical feedback.

**Key Facts**

- Built on the Microsoft Research Pi Vision Language family of models.
- Partnership includes University of Washington and NVIDIA.
- Enables bi-directional interaction: issuing commands and sensing feedback.
- Demonstrated in a real-world example of playing air hockey against AI.

**Examples**

- The speaker played air hockey against the AI powered by this technology at the Silicon Valley experience center.
- Video shown highlights the moment the speaker won, illustrating the AI’s physical interaction capabilities.

**Key Takeaways 🎯**

- Rho Alpha is a significant step toward integrating AI with physical robotics through natural language.
- The model’s ability to understand tactile feedback allows for more adaptive and responsive robotic behavior.
- Collaboration between Microsoft Research, academia, and industry partners is crucial for advancing such technologies.
- Practical demonstrations like AI playing air hockey showcase the potential for real-world applications.

---

## Tenant Configuration Management APIs Preview

**Timestamp**: 00:08:03 – 00:09:04

**Key Concepts**

- Tenant Configuration Management APIs allow managing the configuration of an entire Microsoft 365 tenant.
- These APIs enable taking snapshots of the tenant configuration.
- They provide monitoring capabilities to detect configuration drift over time.
- The APIs are currently available in preview and require using the `/beta` version of Microsoft Graph.
- Separate APIs exist for snapshotting configurations and for monitoring changes.
- Detected configuration drifts can be tracked and will be automatically deleted after 30 days once fixed.

**Definitions**

- **Tenant Configuration Management APIs**: APIs that provide the ability to capture and monitor the configuration state of a Microsoft 365 tenant, including services like Entra ID, Exchange Online, Defender, Purview, Intune, and Teams.
- **Configuration Drift**: Changes or deviations in the tenant configuration from a previously captured snapshot that may require correction.

**Key Facts**

- The APIs cover the entire M365 tenant configuration, including Entra ID, Exchange Online, Defender, Purview, Intune, and Teams.
- The APIs are in preview and require use of the `/beta` endpoint in Microsoft Graph.
- Configuration drift records are retained for 30 days after being fixed before deletion.

**Examples**

- None mentioned explicitly beyond the general use case of taking snapshots and monitoring configuration drift.

**Key Takeaways 🎯**

- Tenant Configuration Management APIs provide a centralized way to snapshot and monitor M365 tenant configurations.
- Using these APIs helps identify and correct configuration drift to maintain compliance and security.
- Since the APIs are in preview, developers must use the `/beta` version of Microsoft Graph.
- Monitoring and snapshotting are handled by separate API endpoints.
- Configuration drift data is temporary and cleaned up 30 days after resolution.

---

## Closing Remarks

**Timestamp**: 00:09:04 – unknown

**Key Concepts**

- Wrapping up the session with final thoughts
- Acknowledgement of the different environment used for the demo/presentation
- Expressing intent to share updates despite constraints

**Definitions**

- None explicitly provided in this segment

**Key Facts**

- The presenter apologized for using a different environment than usual
- The session concluded with a sign-off: "until next time, take care"

**Examples**

- None mentioned

**Key Takeaways 🎯**

- The presenter aimed to ensure updates were shared even under less-than-ideal conditions
- Closing remarks serve as a polite and professional end to the session
- Encouragement to stay tuned for future updates or sessions
