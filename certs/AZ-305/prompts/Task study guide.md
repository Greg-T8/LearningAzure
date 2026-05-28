You are creating an exhaustive AZ-305 study guide for one exam task.

Exam: AZ-305: Designing Microsoft Azure Infrastructure Solutions

Study Guide:

Domain:
<domain>

Skill:
<skill>

Task:
<task>

Primary Microsoft Learn module(s):
<insert Microsoft Learn module URLs>

Primary Microsoft documentation:
<insert Microsoft documentation URLs>

Optional related sources:
<insert optional Azure Architecture Center, Cloud Adoption Framework, Well-Architected Framework, or Exam Readiness Zone URLs>

Research boundaries:
Use Microsoft Learn and official Microsoft documentation as the authoritative source base. Start with the Microsoft Learn module content I provided, then fan out into supporting Microsoft documentation. Use broader Microsoft sources only when they directly clarify, deepen, or operationalize the specific exam task.

Do not turn this into a general AZ-305 guide. Keep the study guide anchored to the specific task. Related information from neighboring tasks is acceptable only when it helps explain dependencies, design tradeoffs, or exam-relevant decision points. When content crosses into another task, explicitly label it as “Adjacent task context” and keep it brief.

Source requirements:

- Prioritize official Microsoft sources:
  1. Microsoft Learn module content
  2. Microsoft product documentation
  3. Azure Architecture Center
  4. Microsoft Cloud Adoption Framework
  5. Microsoft Well-Architected Framework
  6. Microsoft Exam Readiness Zone
- Avoid third-party sources unless Microsoft documentation is missing a necessary explanation. If a third-party source is used, clearly label it as supplemental and explain why it was needed.
- Use current documentation only. If Microsoft documentation has version-specific behavior, preview status, retirement notices, limitations, SKU dependencies, or regional constraints, call those out.

Citation requirements:
Every substantive paragraph must include inline links to the source material used for that paragraph. Do not group citations only at the end.

Use links naturally inside the paragraph. For example:
“Azure Policy can be used to enforce allowed locations, required tags, and SKU restrictions across management groups and subscriptions, which makes it a core design control for governance at scale.”

In that example, hyperlink the relevant phrase, such as “Azure Policy,” “management groups,” or “governance at scale,” directly to the exact Microsoft documentation page or section.

When possible, link to the most specific section anchor in the Microsoft documentation rather than only the top-level article.

Output format:
Create a long-form study guide in Markdown.

Use this structure:

# AZ-305 Study Guide: <task>

## 1. Exam task scope

Explain what this task is asking an Azure Solutions Architect to design, decide, compare, or recommend.

Include:

- The domain
- The skill
- The task
- The likely design decisions tested
- What is in scope
- What is out of scope or belongs mostly to adjacent tasks

## 2. Starting point from the Microsoft Learn module

Summarize the relevant Microsoft Learn module content first.

Include:

- Core concepts introduced by the module
- Terms and services the module expects the learner to understand
- Design recommendations from the module
- Any diagrams, patterns, or decision points described in the module
- Gaps where the module is not deep enough for AZ-305-level preparation

## 3. Conceptual foundation

Explain the topic from first principles.

Include:

- Why this topic matters architecturally
- The problem this Azure capability or design pattern solves
- How the major Azure services fit together
- Key terminology
- Control plane vs data plane considerations where relevant
- Identity, networking, monitoring, governance, security, cost, resiliency, and operational implications where relevant

## 4. Design decision framework

Create a decision framework for the task.

Include:

- When to choose one Azure service, SKU, pattern, or configuration over another
- Decision trees or step-by-step design logic
- Selection criteria
- Constraints and dependencies
- Tradeoffs between cost, complexity, availability, performance, security, and operations
- Common “it depends” scenarios and how to reason through them

## 5. Service and feature comparison tables

Include comparison tables where useful.

Tables may include:

- Service vs service
- SKU vs SKU
- Regionally redundant vs zone-redundant vs locally redundant options
- PaaS vs IaaS approaches
- Native Azure feature vs third-party or custom option
- Basic vs standard vs premium tiers where relevant

Each table must include source links in the row or column descriptions where the facts come from.

## 6. Architecture patterns

Describe exam-relevant architecture patterns.

For each pattern, include:

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

If diagrams would help, include Mermaid diagrams in Markdown.

Use simple diagrams that help explain:

- Service relationships
- Traffic flow
- Identity flow
- Failover flow
- Governance hierarchy
- Monitoring/logging flow
- Backup/replication flow

## 7. Implementation awareness for architects

AZ-305 is a design exam, not a hands-on administration exam, but architects still need implementation awareness.

Include:

- Configuration details an architect should understand
- Portal, Azure CLI, PowerShell, ARM/Bicep, or policy concepts only where they support design understanding
- Limits, dependencies, prerequisites, and sequencing considerations
- What must be decided before implementation
- What can be deferred to implementation teams

Do not over-focus on step-by-step deployment unless it is important to the design decision.

## 8. Security, governance, and compliance considerations

Explain how the task intersects with:

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

Only include the items that are relevant to the specific task.

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

## 11. Monitoring and operational considerations

Explain how the solution should be monitored and operated.

Include:

- Azure Monitor
- Log Analytics
- Metrics
- Diagnostic settings
- Alerts
- Workbooks
- Defender for Cloud recommendations
- Update/patching considerations where relevant
- Operational ownership boundaries

## 12. Common exam traps

List common AZ-305 traps for this task.

For each trap, include:

- The tempting wrong answer
- Why it seems reasonable
- Why it is wrong or incomplete
- The better design choice
- The Microsoft source that supports the distinction

## 13. Scenario-based design examples

Create several realistic architect-level scenarios.

For each scenario, include:

- Customer requirement
- Constraints
- Recommended design
- Why this design is appropriate
- Alternatives considered
- Why alternatives were rejected
- Microsoft documentation links supporting the recommendation

Do not write these as multiple-choice quiz questions. These are study scenarios, not the NotebookLM quiz output.

## 14. Adjacent task context

Briefly list related AZ-305 tasks or topics that overlap with this one.

For each related topic:

- Explain why it overlaps
- Explain what portion belongs to this task
- Explain what portion belongs elsewhere
- Keep this section concise to avoid topic bleed

## 15. Final exam-focused summary

End with:

- Key takeaways
- Must-know decisions
- Must-know Azure services
- Must-know limitations
- Must-know tradeoffs
- A short “before the exam, make sure you can…” checklist

Quality bar:
Make this guide exhaustive enough that I could use it as my primary study guide for this one AZ-305 task before moving into NotebookLM quizzes and audio review.

Writing style:
Use clear technical explanations. Assume I have Azure administration experience but want architect-level decision depth. Avoid filler. Prefer practical design reasoning, service comparisons, and exam-relevant tradeoffs over generic product descriptions.
