# AZ-305 Scenario Question Generator

Restrict coverage to only the task(s) listed below.

Exam: AZ-305  
Skill: <skill>  
Task(s): <task>

Using only the provided source material, create scenario-based practice questions for the listed task(s). Do not cover other AZ-305 tasks, skills, domains, or objectives, even if present in the source.

Use Microsoft role-based and MeasureUp-style reasoning without copying proprietary wording.

## Source analysis

Before writing, extract task-relevant details where available:

- Licensing, SKU, tier, edition, or plan differences
- Prerequisites, dependencies, roles, and permissions
- Supported/unsupported scenarios, limits, quotas, and boundaries
- Region, zone, redundancy, replication, or failover constraints
- Cost, performance, scalability, resiliency, and operations tradeoffs
- Security, governance, compliance, identity, monitoring, and networking implications
- Migration, replacement, or modernization guidance
- CLI, PowerShell, KQL, ARM/Bicep, Terraform, or Graph details

Do not invent facts. If the source lacks licensing, SKU, prerequisite, limit, or supportability details, do not ask questions that depend on them. Note the gap.

## Question requirements

Questions must test design judgment, not recall.

Each question must:

- Present a realistic customer/admin/architect scenario
- Include business and technical requirements
- Include one constraint: cost, licensing, region, availability, compliance, RTO/RPO, overhead, architecture, identity, networking, or supportability
- Require eliminating plausible wrong answers
- Use AZ-305 wording: recommend, design, choose, meet the requirement, minimize cost, minimize effort, maximize availability, or satisfy compliance
- Have one best answer
- Stay aligned to the listed task(s)
- Include CLI, query, automation, or configuration items when relevant

For each question, include:

- One correct answer
- Three plausible distractors
- Why the correct answer is best
- Why each distractor is wrong
- Tested-detail label
- Source reference supporting the answer

## Question mix

- 40% architecture/design recommendation
- 20% SKU, tier, licensing, or capability boundary
- 15% prerequisite, dependency, or supported scenario
- 15% troubleshooting, validation, migration, or operations
- 10% command-line, query, automation, or configuration interpretation

Avoid simple recall questions. Prefer scenarios where several answers seem reasonable but only one meets all requirements.

Do not create questions where the answer mainly depends on a date, deadline, retirement date, release date, or roadmap milestone. Convert date-based material into architecture, migration, risk, or replacement-feature questions when possible. If only the date matters, exclude it.

## Final validation

Verify each question:

- Maps to the listed task(s)
- Is source-supported
- Uses plausible but inferior distractors
- Requires no outside knowledge
- Does not primarily belong to another AZ-305 task
