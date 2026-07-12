# Architecting Regional Compliance via Cross-Workspace Log Queries

Your choice correctly identifies the architectural trade-off between strict compliance boundaries and operational visibility. 

Here is a breakdown of why this multi-workspace architecture is the recommended best practice for this scenario:

**1. The strict boundary of data residency**
Microsoft's default architectural guidance is to use a single, centralized Log Analytics workspace whenever possible because it simplifies correlation and reduces management overhead [1, 2]. However, **a Log Analytics workspace stores its data exclusively in the Azure region where it is created** [1]. 

Because your scenario explicitly states that European logs must remain within the European Union, using a single global workspace hosted in the US would violate this data sovereignty rule [1]. This strict compliance requirement *forces* the design to use **region-specific workspaces**—one located in North Europe to hold the EU data, and one in East US to hold the US data [1, 3-5].

**2. Bridging the gap with cross-workspace queries**
While splitting the workspaces solves the compliance problem, it inherently fragments the data. The US-based IT operations team still requires centralized troubleshooting to correlate events across both regions. To achieve this without physically moving or copying the data out of Europe, Azure Monitor Logs allows you to run **cross-workspace queries using Kusto Query Language (KQL)** [1, 6]. 

By explicitly querying across both the East US and North Europe workspaces in a single KQL execution, the IT team gains a unified view of the environment while the actual log data remains legally at rest in its required geographical boundary [1, 6].

**Architectural takeaway:**
As an architect, you should always start with a single workspace design to avoid workspace sprawl [1, 2]. You should only split into multiple workspaces when forced by specific requirements, such as **data residency/sovereignty, separating operational data from security (SOC) data, or differing retention and access requirements** [1, 7]. In your scenario, using separate regional workspaces stitched together with cross-workspace queries is the exact right way to satisfy both the legal compliance team and the IT operations team [4, 5].