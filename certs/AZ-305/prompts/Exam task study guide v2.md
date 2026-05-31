# AZ-305 Exam Task Study Guide Generator

You are creating a comprehensive study guide for one Microsoft AZ-305 exam task.

The user will provide:

1. The official AZ-305 study guide or a link to it.
2. An AZ-305 Study Guide Map that maps exam tasks to relevant Microsoft documentation, products, and discovery notes.
3. A target exam task, such as: `Recommend a monitoring solution`.

Your job is to generate a long-form, architect-level study guide for the target task.

---

## 1. Inputs

### Required input

- **Exam:** AZ-305: Designing Microsoft Azure Infrastructure Solutions
- **Official study guide:** Use the official Microsoft AZ-305 study guide provided by the user.
- **Study Guide Map:** Use the provided study guide map as the source-discovery aid.
- **Target task:** `<target_task>`

### Optional input

The user may optionally provide:

- A preferred reading time.
- Additional Microsoft Learn modules.
- Existing notes.
- A preferred output length.
- A specific audience level.
- Known weak areas.
- Specific adjacent tasks to watch for.

If optional inputs are not provided, use these defaults:

- **Reading time:** approximately 45 minutes
- **Audience:** Azure administrator or engineer preparing for architect-level AZ-305 design questions
- **Depth:** practical design reasoning, not basic product overview
- **Output format:** clean Markdown

---

## 2. Task resolution process

Before writing the study guide, perform a task-resolution pass.

Using the official AZ-305 study guide and the provided Study Guide Map:

1. Locate the exact target task.
2. Identify its:
   - Domain
   - Skill
   - Exact task wording
3. Extract the supporting Microsoft documentation listed for that task.
4. Extract the “Potentially relevant products considered” for that task.
5. Extract any “Forum-discovery note” or coverage notes that apply to the task, domain, or skill.
6. Identify adjacent tasks from:
   - The same skill
   - The same domain
   - Closely related tasks from other domains
7. Use adjacent tasks only to define boundaries, dependencies, design tradeoffs, and exam traps.

Do not require the user to manually provide the domain, skill, task hierarchy, modules, product list, or adjacent task list if these can be derived from the official study guide and Study Guide Map.

If the target task wording is not an exact match, use the closest matching task from the Study Guide Map and clearly state the matched task near the top of the guide.

If multiple tasks are plausible matches, list the candidates and proceed with the most likely match unless the ambiguity would materially change the study guide.

---

## 3. Source selection rules

Use Microsoft sources as the authoritative source base.

Prioritize sources in this order:

1. Official AZ-305 study guide
2. Microsoft Learn modules
3. Microsoft product documentation
4. Azure Architecture Center
5. Cloud Adoption Framework
6. Azure Well-Architected Framework
7. Azure reliability documentation
8. Microsoft Exam Readiness Zone
9. Other official Microsoft documentation

Use the Study Guide Map as the primary discovery aid for relevant products and documentation.

Do not limit the guide only to product names explicitly stated in the official exam task. The official study guide often uses broad task wording, so use the Study Guide Map to infer relevant Azure services, Microsoft Entra features, architecture patterns, and design topics.

Do not use third-party sources unless Microsoft documentation does not explain a necessary concept. If a third-party source is used, label it as supplemental and explain why it was needed.

Forum and Reddit information may be used only as discovery signals. Do not treat forum comments as authoritative. If forum-discovery notes are included, use them to explain what candidates often discuss or confuse, then ground the actual recommendation in Microsoft documentation.

Use current Microsoft documentation. Call out version-specific behavior, preview status, retirements, SKU dependencies, regional constraints, licensing dependencies, and known limitations when Microsoft documentation mentions them.

---

## 4. Scope control

Keep the guide anchored to this task:

`<target_task>`

Do not turn the output into a general AZ-305 guide.

Related information from neighboring tasks is acceptable only when it helps explain:

- Dependencies
- Design tradeoffs
- Exam traps
- Service-selection boundaries
- Scenario interpretation
- Architectural reasoning

When content crosses into another task, label it as:

> **Adjacent task context:** <brief explanation>

Keep adjacent-task context concise.

---

## 5. Citation and hyperlink requirements

Use only normal Markdown hyperlinks in the final report.

Do not include ChatGPT-native citation marker strings, footnote-style citation artifacts, bracketed source IDs, or internal research markers.

Every substantive sentence that makes a factual claim, recommendation, limitation, comparison, design rule, exam trap, or scenario recommendation must include a directly relevant Markdown hyperlink.

Prefer linking the most relevant phrase directly, such as:

- Service name
- Feature name
- SKU name
- Limitation
- Design recommendation
- Exam-relevant distinction
- Architecture pattern

Good examples:

- Use [Log Analytics workspaces](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview) when the requirement is centralized log query, KQL analysis, workbook visualization, or log-based alerting.
- For new Azure resource log designs, prefer [resource-specific tables](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs) over legacy `AzureDiagnostics` where supported.
- Start with a single workspace unless data residency, ownership, retention, or chargeback requirements justify separation. ([See workspace architecture guidance](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design))

Bad examples:

- Use Log Analytics for centralized logging. [1]
- Use Log Analytics for centralized logging. Sources: Azure Monitor overview.
- Use Log Analytics for centralized logging. <internal citation marker>

When possible, link to the most specific Microsoft Learn section anchor rather than the top-level article.

Do not create a bibliography as a substitute for inline links.

A “Primary source set” section is required near the top, but inline links are still required throughout the guide.

---

## 6. Output requirements

Create a long-form Markdown study guide.

The guide should take approximately 45 minutes to read unless the user requests a different length.

Write for someone with Azure administration experience who wants architect-level decision depth.

Prioritize:

- Design reasoning
- Service selection
- Architecture patterns
- Scenario analysis
- Tradeoffs
- Exam traps
- Decision frameworks
- Practical constraints
- Security, governance, resiliency, cost, and operations implications

Avoid:

- Generic product descriptions
- Unanchored lists of services
- Implementation-only walkthroughs
- Topic drift into unrelated AZ-305 tasks
- Unsupported claims
- Citation artifacts

---

# Required output structure

# AZ-305 Study Guide: <target_task>

> **Exam task:** <skill> — <exact_task>
>
> **Domain:** <domain>
>
> **Estimated reading time:** 45 minutes
>
> **Matched task source:** Explain whether this was an exact match or inferred from the closest Study Guide Map entry.
>
> **Scope boundary:** Explain what this guide covers and which adjacent tasks are intentionally excluded.

---

## How to use this guide

Explain how the reader should work through the guide.

Include:

- What they should know by the end.
- How this topic maps to the exam task.
- How this task differs from adjacent AZ-305 tasks.
- How to use the source links for follow-up study.
- How to read scenario questions for requirement clues.

---

## Primary source set

List only sources that are relevant to this task.

Group them as follows:

### Exam and module sources

- Official AZ-305 study guide
- Relevant Microsoft Learn modules

### Core product documentation

- Primary Microsoft product docs from the Study Guide Map
- Additional product docs needed to explain service-selection tradeoffs

### Supporting architecture and framework sources

- Azure Architecture Center
- Cloud Adoption Framework
- Well-Architected Framework
- Azure reliability documentation
- Exam Readiness Zone
- Other official Microsoft sources

### Discovery notes from the Study Guide Map

Summarize:

- Potentially relevant products considered
- Forum-discovery note, if present
- Coverage notes, if relevant

Clearly state that forum-discovery notes are nonauthoritative and are used only to identify common candidate discussion patterns.

---

## 1. Exam task scope

Explain what this task is asking an Azure Solutions Architect to design, decide, compare, or recommend.

Include:

- Domain
- Skill
- Exact task
- What the task likely expects the candidate to know
- Likely design decisions tested
- What is in scope
- What is out of scope
- Adjacent tasks that can be confused with this one
- The mental boundary between this task and related tasks

---

## 2. Product and topic discovery pass

Use the Study Guide Map to identify the product and topic set for this task.

Create a table:

| Product, service, or topic | Why it may be relevant | Primary Microsoft source | In-scope or adjacent? |
|---|---|---|---|

Include:

- Core products directly tied to the task
- Supporting services
- Architecture patterns
- Governance/security/resiliency/cost topics
- Related but adjacent products that should not dominate the guide

Do not include a product simply because it is broadly Azure-related. Explain why it matters for this task.

---

## 3. Starting point from Microsoft Learn

Summarize the most relevant Microsoft Learn module or documentation starting point.

Include:

- Core concepts introduced by Microsoft Learn
- Terms and services Microsoft expects the learner to understand
- Design recommendations from the source material
- Any diagrams, patterns, or decision points described by Microsoft
- Gaps where the module or primary documentation is not deep enough for AZ-305 scenario readiness

End this section with:

> **Exam tip:** <specific exam-relevant insight, distinction, or trap with inline Microsoft Learn links.>

---

## 4. Conceptual foundation

Explain the topic from first principles.

Include only areas relevant to the task:

- Why the topic matters architecturally
- The business or technical problem it solves
- How the major Azure services fit together
- Key terminology
- Control plane vs data plane considerations
- Identity implications
- Networking implications
- Monitoring and operations implications
- Governance implications
- Security implications
- Cost implications
- Resiliency implications

Include an exam tip after each major conceptual subsection.

Use this format:

> **Exam tip:** <specific exam-relevant insight, distinction, or trap with inline Microsoft Learn links.>

---

## 5. Design decision framework

Create a practical decision framework for the task.

Include:

- When to choose one Azure service, SKU, pattern, or configuration over another
- Decision trees or step-by-step design logic
- Selection criteria
- Hard constraints
- Soft preferences
- Dependencies
- Tradeoffs between cost, complexity, availability, performance, security, compliance, and operations
- Common “it depends” scenarios and how to reason through them

Include at least one simple decision tree using Mermaid or Markdown.

The decision tree should help answer scenario-style questions, not just define products.

---

## 6. Service and feature comparison tables

Include comparison tables where useful.

Possible tables:

- Service vs service
- SKU vs SKU
- Native feature vs custom design
- Regionally redundant vs zone-redundant vs locally redundant options
- Collection method vs collection method
- Storage option vs storage option
- Monitoring or operational model vs operational model
- Basic vs Standard vs Premium tiers, where relevant

Each factual table entry must include Microsoft Learn links directly in the relevant row or column.

---

## 7. Architecture patterns

Describe exam-relevant architecture patterns for this task.

For each pattern, include:

- Pattern name
- When the pattern applies
- Why it solves the problem
- Required Azure services
- Design strengths
- Design weaknesses
- Failure modes
- Cost considerations
- Operational considerations
- Security considerations
- Monitoring considerations
- Microsoft Learn links supporting the design

Use Mermaid diagrams when they clarify the architecture.

Use Mermaid diagrams for relevant flows, such as:

- Service relationships
- Logging flows
- Monitoring flows
- Identity flows
- Failover flows
- Governance hierarchy
- Backup or replication flow
- Hub-spoke or landing zone patterns

Mermaid diagram rules:

- Keep diagrams simple.
- Use meaningful node labels.
- Avoid overly large diagrams.
- Include a short explanation after each diagram.
- Keep diagrams exam-focused, not implementation-heavy.

---

## 8. Implementation awareness for architects

AZ-305 is a design exam, not a hands-on administration exam, but architects need implementation awareness.

Include:

- Configuration details an architect should understand
- Portal, Azure CLI, PowerShell, ARM/Bicep, or Azure Policy concepts only where they support design understanding
- Limits
- Dependencies
- Prerequisites
- Sequencing considerations
- What must be decided before implementation
- What can be deferred to implementation teams

Do not over-focus on step-by-step deployment unless the sequence affects the design recommendation.

---

## 9. Security, governance, and compliance considerations

Explain how the task intersects with relevant areas, such as:

- Microsoft Entra ID
- Azure RBAC
- Managed identities
- Azure Policy
- Management groups
- Resource locks
- Defender for Cloud
- Private endpoints
- Network security
- Encryption
- Key management
- Logging and auditability
- Regulatory or data residency requirements

Only include items relevant to the specific task.

End with:

> **Exam tip:** <common security, governance, or compliance confusion with inline Microsoft Learn links.>

---

## 10. Resiliency, availability, and disaster recovery considerations

Explain relevant resiliency implications, including:

- Availability zones
- Region pairs
- Backup
- Replication
- Failover
- RTO
- RPO
- SLA considerations
- Zone-redundant options
- Geo-redundant options
- Single points of failure

If this task is not primarily about resiliency, keep the section focused on resiliency implications rather than turning it into the separate AZ-305 business continuity domain.

---

## 11. Cost and licensing considerations

Explain cost drivers and licensing dependencies.

Include:

- SKUs and tiers that affect design
- Features that introduce additional cost
- Reservations, savings plans, or commitment options, if relevant
- Data transfer costs
- Storage costs
- Logging costs
- Backup or replication costs
- Hidden cost traps
- Cost optimization tradeoffs

End with:

> **Exam tip:** <cost trap likely to appear in scenario questions with inline Microsoft Learn links.>

---

## 12. Monitoring and operational considerations

Explain how the solution should be monitored and operated.

Include only items relevant to this task, such as:

- Azure Monitor
- Log Analytics
- Metrics
- Diagnostic settings
- Alerts
- Workbooks
- Defender for Cloud recommendations
- Service Health
- Network Watcher
- Update or patching considerations
- Operational ownership boundaries

If the target task is not “Recommend a monitoring solution,” clearly distinguish basic operational monitoring from the adjacent exam task “Recommend a monitoring solution.”

If the target task is “Recommend a monitoring solution,” make this section the core operational design section and include workload, platform, identity, network, and service-health monitoring distinctions.

---

## 13. Common exam traps

List common exam traps for this task.

Use a table where practical.

Each trap must include:

| Trap | Tempting wrong answer | Why it seems reasonable | Why it is wrong or incomplete | Better design choice | Microsoft source |
|---|---|---|---|---|---|

Include traps for:

- Service-selection confusion
- SKU or tier confusion
- Feature overlap
- Scope boundary confusion with adjacent tasks
- Security or governance misunderstanding
- Cost misunderstanding
- Resiliency or availability misunderstanding
- Operational ownership confusion
- Edge cases where the default recommendation changes because of a specific requirement, limitation, region, SKU, identity model, compliance requirement, or integration dependency

The “edge cases” row is required.

---

## 14. Scenario-based design examples

Create realistic architect-level study scenarios.

Do not write these as multiple-choice quiz questions.

Include at least 5 scenarios.

At least one scenario must cover:

- A straightforward default recommendation
- A cost-constrained design
- A security or compliance-driven design
- A multi-region or resiliency-driven design
- An edge case where the normal recommendation changes
- A scenario that is easy to confuse with an adjacent AZ-305 task

For each scenario, include:

- Customer requirement
- Constraints
- Recommended design
- Why this design is appropriate
- Alternatives considered
- Why alternatives were rejected
- Microsoft Learn links supporting the recommendation
- Exam interpretation notes

---

## 15. Test yourself

After major sections, include a short “Test yourself” block.

Use this format:

> **Test yourself**
>
> - <Scenario-style question>
> - <Scenario-style question>
>
> **Answer guidance:** <Brief explanation with Microsoft Learn links.>

Questions should test design judgment, not memorization.

---

## 16. Adjacent task context

Briefly list related AZ-305 tasks or topics that overlap with this one.

For each related topic, include:

| Adjacent task or topic | Why it overlaps | What belongs in this task | What belongs elsewhere |
|---|---|---|---|

Keep this section concise to avoid topic bleed.

---

## 17. Final exam-focused summary

End with:

- Key takeaways
- Must-know decisions
- Must-know Azure services
- Must-know limitations
- Must-know tradeoffs
- Common requirement clues
- A short “before the exam, make sure you can…” checklist

---

## 18. Quick-reference tables

Include quick-reference tables that help with exam review.

Useful table types:

- Requirement-to-service map
- Product-to-use-case map
- Service comparison map
- SKU or tier comparison map
- Scenario-to-recommendation map
- Trap-to-correct-answer map
- Edge-case-to-design-change map

Every factual table entry must include Microsoft Learn links where relevant.

---

## 19. Final validation

Before producing the final Markdown output, verify:

- The guide is anchored to the target task.
- The domain, skill, and task were derived from the official study guide or Study Guide Map.
- Product coverage came from the Study Guide Map and relevant Microsoft documentation.
- Potentially relevant products were considered, but irrelevant ones were excluded.
- Forum-discovery notes were treated only as nonauthoritative discovery signals.
- The final output contains only normal Markdown links.
- No internal citation markers remain.
- Important phrases are directly hyperlinked inline.
- Citations are not grouped only at the end of paragraphs.
- Primary sources are listed near the top.
- Exam tips are included throughout the guide.
- Scenario-based design examples are included.
- Mermaid diagrams are included where they improve architectural understanding.
- Common exam traps include an edge-cases line item.
- Adjacent exam tasks are clearly separated from the main task.
- Links point to Microsoft Learn or other official Microsoft sources unless explicitly labeled supplemental.
- The final output is clean Markdown that can be pasted into another tool without hidden citation artifacts.

Now create the Markdown study guide for this target task:

`<target_task>`
