# The Mechanics of Cross-Tenant Identity Synchronization

It is completely understandable why you might guess a different timeframe, as Microsoft Entra utilizes several different synchronization engines, each with its own unique scheduling interval. For example, traditional Microsoft Entra Connect Sync defaults to a 30-minute interval [1], while the newer Microsoft Entra Cloud Sync provisions users approximately every 10 to 20 minutes [2]. 

However, cross-tenant synchronization operates on a different backend architecture. Here is a detailed breakdown of why your answer was incorrect and how cross-tenant synchronization works for your AZ-305 exam preparation:

**1. The 40-Minute Provisioning Interval**
Cross-tenant synchronization is built directly on top of the Microsoft Entra application provisioning engine [3]. Because it utilizes this specific backend, an incremental cross-tenant synchronization job starts at a fixed **40-minute** interval [3, 4]. 

**2. Initial vs. Incremental Cycles**
While the job *starts* every 40 minutes, the actual duration of the sync varies depending on the number of in-scope users [3]. The very first time the job runs (the initial cycle), it takes much longer because it must query and evaluate the full scope of the source directory [4]. Once that initial baseline watermark is established, the subsequent 40-minute incremental cycles run much faster because they only query for changes, such as newly added users or updated attributes [4].

**3. The Push Architecture and Scope**
Architecturally, cross-tenant synchronization is a source-initiated push [3]. The source tenant holds the configuration, scoping filters, and attribute mappings [3]. Every 40 minutes, it pushes its *internal member users* into the target tenant, creating them as external members (or external guests) [3]. It is highly important to know that this service does not synchronize source-tenant guests, contacts, or devices [3]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing a multitenant organization (MTO) architecture, remember that cross-tenant synchronization runs every **40 minutes** and supports a maximum of **100 active tenants** [3, 5]. 

Furthermore, you must recognize its strict architectural boundary: it is exclusively for identity lifecycle management among related workforce tenants [3, 6]. If an exam scenario requires you to permanently move a user's authentication authority or their Microsoft 365 data (like SharePoint or OneDrive) to a new tenant, you cannot recommend cross-tenant synchronization because it does not migrate data, and the users will continue to authenticate against their source tenant [3, 6].