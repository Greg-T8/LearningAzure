You are creating an exhaustive study guide for one Microsoft certification exam task.

Exam: AZ-305: Designing Microsoft Azure Infrastructure Solutions

Study Guide: [AZ-305 Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305)

Domain:
Design identity, governance, and monitoring solutions

Skill:
Design solutions for logging and monitoring

Task:
Recommend a logging solution

Primary Microsoft Learn module(s):
[Microsoft Learn Module - Design a solution to log and monitor Azure resources](https://learn.microsoft.com/en-us/training/modules/design-solution-to-log-monitor-azure-resources/)

Primary Microsoft documentation:
[Azure Monitor Documenation](https://learn.microsoft.com/en-us/azure/azure-monitor/)

Optional related sources:
<insert optional Azure Architecture Center, Cloud Adoption Framework, Well-Architected Framework, or Exam Readiness Zone URLs>

- [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/)
- [Cloud Adoption Framewrok](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/)
- [Well-Architected Framewrok](https://learn.microsoft.com/en-us/azure/well-architected/what-is-well-architected-framework)
- [Exam Readiness Zone](https://learn.microsoft.com/en-us/shows/exam-readiness-zone/)

Research boundaries:
Use Microsoft Learn and official Microsoft documentation as the authoritative source base.

Start with the Microsoft Learn module content I provided, then fan out into supporting Microsoft product documentation.

Use broader Microsoft sources only when they directly clarify, deepen, or operationalize the specific exam task.

Do not turn this into a general exam guide.

Keep the study guide anchored to the specific task:
<task>

Related information from neighboring tasks is acceptable only when it helps explain dependencies, design tradeoffs, exam traps, or task boundaries.

When content crosses into another task, explicitly label it as “Adjacent task context” and keep it brief.

Do not use third-party sources unless Microsoft documentation is missing a necessary explanation.

If a third-party source is used, clearly label it as supplemental and explain why it was needed.

Use current Microsoft documentation only.

If Microsoft documentation mentions version-specific behavior, preview status, retirement notices, limitations, SKU dependencies, regional constraints, or licensing dependencies, call those out.

Citation and hyperlink requirements:
Use only normal Markdown hyperlinks in the final report.

Do not include ChatGPT-native citation marker strings in the final output, including any strings that look like internal citation artifacts.

Before finalizing the report, perform a cleanup pass and remove or convert all internal citation markers into standard Markdown links.

Every substantive sentence that makes a factual claim, recommendation, limitation, comparison, design rule, exam trap, or scenario recommendation must include a directly relevant Markdown hyperlink.

Do not group citations only at the end of paragraphs.

Prefer linking the most relevant technical term, feature name, service name, limitation, design phrase, or exam-relevant concept directly to the Microsoft Learn source.

Good examples:

- Use [Log Analytics workspaces](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview) as the primary destination when the requirement is centralized log query, KQL analysis, workbook visualization, or log-based alerting.
- For new Azure resource log designs, prefer [resource-specific tables](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs) instead of the legacy AzureDiagnostics table.
- Start with a single workspace unless requirements such as data residency, ownership, retention, or chargeback justify separation. ([See workspace architecture guidance](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/workspace-design))

Bad examples:

- Use Log Analytics for centralized logging. [1]
- Use Log Analytics for centralized logging. Sources: Azure Monitor overview, workspace design.
- Use Log Analytics for centralized logging. <internal citation marker>

When possible, link to the most specific Microsoft Learn section anchor rather than the top-level article.

If the same source supports multiple nearby sentences, still place the link where it is most relevant, either on the phrase being supported or in a short parenthetical at the end of the sentence.

Do not create a separate bibliography as a substitute for inline links.

Output format:
Create a long-form study guide in Markdown.

The guide should take approximately 45 minutes to read.

Write for someone with Azure administration experience who wants architect-level decision depth.

Use clear headings, practical explanations, tables, diagrams, exam tips, and scenario-based reasoning.

Avoid filler.

Prefer practical design reasoning, service comparisons, architecture patterns, and exam-relevant tradeoffs over generic product descriptions.

Required structure:

# <exam_code> Study Guide: <task>

> **Exam task:** <skill> — <task>
>
> **Estimated reading time:** 45 minutes
>
> **Scope boundary:** Explain what this guide covers and what adjacent tasks are intentionally excluded.

## How to use this guide

Explain how the reader should work through the guide.

Include:

- What they should know by the end.
- How the topic maps to the exam task.
- How to avoid confusing this task with adjacent tasks.

## Primary source set

List the primary Microsoft sources used for the guide.

Group the sources as:

### Exam and module sources

- Microsoft exam study guide
- Microsoft Learn module(s)

### Core product documentation

- Primary product docs directly tied to the task

### Supporting architecture and framework sources

- Azure Architecture Center
- Cloud Adoption Framework
- Well-Architected Framework
- Exam Readiness Zone
- Other official Microsoft sources

Only include sources that are actually relevant to this task.

Use normal Markdown links.

## 1. Exam task scope

Explain what this task is asking an Azure Solutions Architect to design, decide, compare, or recommend.

Include:

- The domain
- The skill
- The task
- Likely design decisions tested
- What is in scope
- What is out of scope or belongs mostly to adjacent tasks
- The mental boundary between this task and related tasks

## 2. Starting point from the Microsoft Learn module

Summarize the relevant Microsoft Learn module content first.

Include:

- Core concepts introduced by the module
- Terms and services the module expects the learner to understand
- Design recommendations from the module
- Any diagrams, patterns, or decision points described by the module
- Gaps where the module is not deep enough for exam-level preparation

## 3. Conceptual foundation

Explain the topic from first principles.

Include:

- Why this topic matters architecturally
- The problem this Azure capability or design pattern solves
- How the major Azure services fit together
- Key terminology
- Control plane vs data plane considerations where relevant
- Identity, networking, monitoring, governance, security, cost, resiliency, and operational implications where relevant

Include an “Exam tip” callout after major conceptual sections.

Use this format:

> **Exam tip:** <specific exam-relevant insight, distinction, or trap. Include inline Microsoft Learn links where appropriate.>

## 4. Design decision framework

Create a decision framework for the task.

Include:

- When to choose one Azure service, SKU, pattern, or configuration over another
- Decision trees or step-by-step design logic
- Selection criteria
- Constraints and dependencies
- Tradeoffs between cost, complexity, availability, performance, security, and operations
- Common “it depends” scenarios and how to reason through them

Include at least one simple decision tree.

Use either Markdown lists or Mermaid, whichever is clearer.

## 5. Service and feature comparison tables

Include comparison tables where useful.

Tables may include:

- Service vs service
- SKU vs SKU
- Collection method vs collection method
- Storage option vs storage option
- Regionally redundant vs zone-redundant vs locally redundant options
- Native Azure feature vs custom option
- Basic vs Standard vs Premium tiers where relevant

Each table must include Microsoft Learn links directly in the row or column descriptions where the facts come from.

## 6. Architecture patterns

Describe exam-relevant architecture patterns.

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

Include Mermaid diagrams when they help explain the architecture.

Use Mermaid diagrams for:

- Service relationships
- Logging flows
- Monitoring flows
- Identity flows
- Failover flows
- Governance hierarchy
- Backup or replication flow
- Hub-spoke or landing zone patterns

Mermaid diagram requirements:

- Keep diagrams simple.
- Use meaningful node labels.
- Avoid overly large diagrams.
- Include a short explanation after each diagram.
- Keep diagrams exam-focused, not implementation-heavy.

## 7. Implementation awareness for architects

AZ-305 is a design exam, not a hands-on administration exam, but architects still need implementation awareness.

Include:

- Configuration details an architect should understand
- Portal, Azure CLI, PowerShell, ARM/Bicep, or Azure Policy concepts only where they support design understanding
- Limits, dependencies, prerequisites, and sequencing considerations
- What must be decided before implementation
- What can be deferred to implementation teams

Do not over-focus on step-by-step deployment unless it is important to the design decision.

## 8. Security, governance, and compliance considerations

Explain how the task intersects with relevant areas such as:

- Microsoft Entra ID
- RBAC
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

Only include items that are relevant to the specific task.

Include an “Exam tip” callout for any common security, governance, or compliance confusion.

## 9. Resiliency, availability, and disaster recovery considerations

Explain any relevant:

- Availability zones
- Region pairs
- Backup
- Replication
- Failover
- Recovery time objective
- Recovery point objective
- SLA considerations
- Zone-redundant or geo-redundant options
- Single points of failure

If this task is not primarily about resiliency, keep this section focused on the resiliency implications of the topic.

## 10. Cost and licensing considerations

Explain cost drivers and licensing dependencies.

Include:

- SKUs and tiers that affect design
- Features that introduce additional cost
- Reservations, savings plans, or commitment options if relevant
- Data transfer, storage, logging, backup, or replication costs if relevant
- Hidden cost traps
- Cost optimization tradeoffs

Include an “Exam tip” callout for cost traps that are likely to appear in scenario questions.

## 11. Monitoring and operational considerations

Explain how the solution should be monitored and operated.

Include only items relevant to this task, such as:

- Azure Monitor
- Log Analytics
- Metrics
- Diagnostic settings
- Alerts
- Workbooks
- Defender for Cloud recommendations
- Update or patching considerations where relevant
- Operational ownership boundaries

Clearly distinguish monitoring operations from the adjacent exam task “Recommend a monitoring solution.”

## 12. Common exam traps

List common exam traps for this task.

For each trap, include:

- The tempting wrong answer
- Why it seems reasonable
- Why it is wrong or incomplete
- The better design choice
- The Microsoft Learn source that supports the distinction

Use a table where practical.

## 13. Scenario-based design examples

Create several realistic architect-level scenarios.

For each scenario, include:

- Customer requirement
- Constraints
- Recommended design
- Why this design is appropriate
- Alternatives considered
- Why alternatives were rejected
- Microsoft Learn links supporting the recommendation

Do not write these as multiple-choice quiz questions.

These are study scenarios, not quiz output.

Include at least 5 scenarios.

At least one scenario should cover:

- A straightforward default recommendation
- A cost-constrained design
- A security or compliance-driven design
- A multi-region or resiliency-driven design
- A scenario that is easy to confuse with an adjacent exam task

## 14. Test yourself

After major sections, include a short “Test yourself” block.

Use this format:

> **Test yourself**
>
> - <Scenario-style question>
> - <Scenario-style question>
>
> **Answer guidance:** <Brief explanation with Microsoft Learn links.>

The questions should test design judgment, not memorization.

## 15. Adjacent task context

Briefly list related exam tasks or topics that overlap with this one.

For each related topic:

- Explain why it overlaps
- Explain what portion belongs to this task
- Explain what portion belongs elsewhere
- Keep this section concise to avoid topic bleed

## 16. Final exam-focused summary

End with:

- Key takeaways
- Must-know decisions
- Must-know Azure services
- Must-know limitations
- Must-know tradeoffs
- A short “before the exam, make sure you can…” checklist

## 17. Quick-reference tables

Include quick-reference tables that help with exam review.

Useful table types:

- Source-to-solution map
- Requirement-to-service map
- Service comparison map
- SKU or tier comparison map
- Scenario-to-recommendation map
- Trap-to-correct-answer map

Every factual table entry must include Microsoft Learn links where relevant.

Final output validation:
Before producing the final Markdown file, verify the following:

- The final output contains only normal Markdown links.
- No internal citation markers remain.
- Important phrases are directly hyperlinked inline.
- Citations are not grouped only at the end of paragraphs.
- Primary sources are listed near the top.
- Exam tips are included throughout the guide.
- Scenario-based design examples are included.
- Mermaid diagrams are included where they improve architectural understanding.
- Adjacent exam tasks are clearly separated from the main task.
- Links point to Microsoft Learn pages or specific Microsoft Learn section anchors.
- The final output is clean Markdown that can be pasted into another tool without hidden citation artifacts.

Now create the Markdown study guide.
