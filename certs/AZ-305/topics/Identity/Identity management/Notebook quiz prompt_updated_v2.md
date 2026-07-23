# AZ-305 Scenario Question Generator

Restrict coverage to only the task(s) listed below.

Exam: AZ-305  
Skill: Design authentication and authorization solutions
Task(s): Recommend an identity management solution

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
- Migration, replacement, or modernization guidance based on architecture, capability, risk, or operational requirements—not product lifecycle dates
- CLI, PowerShell, KQL, ARM/Bicep, Terraform, or Graph details

Do not invent facts. If the source lacks licensing, SKU, prerequisite, limit, or supportability details, do not ask questions that depend on them. Note the gap.

Treat current technical supportability separately from product lifecycle. Questions may test whether a design, configuration, feature, platform, or scenario is currently supported, but must not test when a product, service, feature, operating system, SKU, or version reaches end of support or retirement.

## Question requirements

Questions must test design judgment, not recall. Emphasize the learner's ability to distinguish between supported, unsupported, partially supported, and conditionally supported designs.

Each question must:

- Present a realistic customer/admin/architect scenario
- Include business and technical requirements
- Include at least one meaningful constraint: cost, licensing, region, availability, compliance, RTO/RPO, overhead, architecture, identity, networking, or supportability
- Test a documented boundary, limitation, prerequisite, scope condition, tradeoff, or exception whenever the source supports one
- Use controlled ambiguity to test the bounds of the subject matter. Use terms such as *can*, *supports*, *directly*, *automatically*, *without additional components*, *across*, *only*, *minimum*, or *maximum* when they expose a meaningful distinction
- Make ambiguous wording technically resolvable from the scenario and source. Do not omit information that is required to identify the best answer, and do not rely on wordplay or trick phrasing
- Avoid explicitly naming the decisive limitation in the question when the learner should infer it from the requirements
- Require the learner to compare all four choices and eliminate answers that are nearly correct
- Use AZ-305 wording: recommend, design, choose, meet the requirement, minimize cost, minimize effort, maximize availability, or satisfy compliance
- Have one unambiguously best answer after all stated and implied requirements are considered
- Stay aligned to the listed task(s)
- Include CLI, query, automation, or configuration items when relevant

### Distractor requirements

Each question must include three distractors that are closely aligned with the correct answer and believably inaccurate.

The three distractors must:

- Be technically credible options that a knowledgeable but incomplete learner might select
- Belong to the same solution category, architectural decision, configuration approach, or capability family as the correct answer
- Satisfy most of the scenario requirements while failing on one subtle but decisive condition
- Be incorrect because of a specific documented issue, such as a prerequisite, scope boundary, unsupported scenario, SKU limitation, regional constraint, configuration dependency, cost tradeoff, operational burden, or failure to meet a stated requirement
- Reflect realistic misconceptions, such as choosing the correct feature at the wrong scope, selecting a nearby SKU that lacks one required capability, extending a supported design beyond its documented boundary, using the correct components in the wrong sequence, or choosing a valid design that does not meet the optimization goal
- Use terminology, length, specificity, and grammatical structure similar to the correct answer
- Avoid obviously absurd, unrelated, invented, or categorically impossible options
- Avoid making multiple distractors wrong for the same obvious reason
- Avoid signaling the correct answer by making it longer, more detailed, more qualified, or more professionally worded than the distractors
- Remain plausible until every requirement, qualifier, and boundary in the scenario is evaluated

For each question, include:

- One correct answer
- Three closely aligned, plausible distractors
- Why the correct answer is best, including the decisive requirement or boundary it satisfies
- Why each distractor is wrong, identifying the exact requirement, limitation, prerequisite, or tradeoff it fails
- Tested-detail label
- Source reference supporting the answer and the reason each distractor is incorrect

### Excluded lifecycle questions

Do not create questions whose stem, answer choices, or decisive reasoning refers to a product or service going out of support.

Exclude questions about:

- End-of-support, end-of-life, retirement, deprecation, or lifecycle dates
- The month, year, deadline, or remaining support window for a product, service, feature, operating system, SKU, API, or version
- Which version retires first, remains supported longest, or must be upgraded before a stated date
- Support expiration notices, retirement announcements, roadmap milestones, or migration deadlines
- Memorizing whether a service is deprecated or when support ends
- Selecting an answer primarily because it is newer, older, still supported, or nearing retirement

Do not use lifecycle dates in the question stem, answer choices, or explanations when those dates help reveal the answer.

A migration, replacement, or modernization question is allowed only when:

- The decision is driven by architecture, capability, security, reliability, cost, compliance, or operational requirements
- The correct answer does not depend on knowing a retirement or end-of-support date
- The scenario remains valid if all lifecycle dates and deadline language are removed

Current supportability questions are allowed when they test whether a specific architecture, configuration, integration, feature, or deployment pattern is supported under documented technical conditions. Do not convert these into lifecycle questions.

If the source material contains only a lifecycle announcement or end-of-support date for a topic, exclude that topic rather than generating a question from it.

## Question mix

- 40% architecture/design recommendation
- 20% SKU, tier, licensing, or capability boundary
- 15% prerequisite, dependency, or supported scenario
- 15% troubleshooting, validation, migration, or operations
- 10% command-line, query, automation, or configuration interpretation

Avoid simple recall questions. Prefer scenarios where several answers seem reasonable but only one meets all requirements.

Do not create questions where the answer depends on a date, deadline, retirement date, end-of-support date, deprecation notice, release date, or roadmap milestone. Do not merely disguise lifecycle recall as a migration scenario. Convert date-based material only when the resulting question is fully about architecture, capability, risk, cost, security, compliance, or operations and no lifecycle fact is needed to answer it. If removing the date or lifecycle notice changes the correct answer, exclude the question.

## Final validation

Verify each question:

- Maps to the listed task(s)
- Is source-supported
- Uses plausible but inferior distractors
- Requires no outside knowledge
- Does not test end-of-support, retirement, deprecation, lifecycle dates, or upgrade deadlines
- Remains answerable after removing any incidental lifecycle date or retirement notice
- Does not primarily belong to another AZ-305 task
