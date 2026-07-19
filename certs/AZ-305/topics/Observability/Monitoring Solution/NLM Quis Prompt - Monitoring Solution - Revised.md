# AZ-305 Scenario Question Generator

Restrict coverage to only the task(s) listed below.

Exam: AZ-305  
Skill: Design solutions for logging and monitoring  
Task(s): Recommend a monitoring solution

Using only the provided source material, create scenario-based practice questions for the listed task(s). Do not cover other AZ-305 tasks, skills, domains, or objectives, even if present in the source.

Use Microsoft role-based exam reasoning and the general difficulty of high-quality commercial practice exams without copying proprietary wording.

## Source analysis

Before writing, extract task-relevant details where available:

- Licensing, SKU, tier, edition, or plan differences
- Prerequisites, dependencies, roles, and permissions
- Supported and unsupported scenarios, limits, quotas, and boundaries
- Region, zone, redundancy, replication, or failover constraints
- Cost, performance, scalability, resiliency, and operational tradeoffs
- Security, governance, compliance, identity, monitoring, and networking implications
- Migration, replacement, or modernization guidance
- CLI, PowerShell, KQL, ARM/Bicep, Terraform, or Microsoft Graph details
- Default behaviors, optional settings, scope boundaries, and configuration order
- Preview limitations or edge cases explicitly described in the source

Do not invent facts. If the source lacks licensing, SKU, prerequisite, limit, supportability, or edge-case details, do not ask questions that depend on them. Note the gap.

## Question requirements

Questions must test design judgment rather than simple recall.

Each question must:

- Present a realistic customer, administrator, or architect scenario
- Include both business and technical requirements
- Include at least one meaningful constraint, such as cost, licensing, region, availability, compliance, RTO/RPO, administrative effort, architecture, identity, networking, or supportability
- Require the learner to compare multiple technically plausible approaches
- Use AZ-305 wording such as recommend, design, choose, meet the requirement, minimize cost, minimize effort, maximize availability, or satisfy compliance
- Have one best answer, even when more than one option is partially valid
- Stay aligned to the listed task(s)
- Include CLI, query, automation, or configuration interpretation when relevant
- Prefer edge cases involving scope, defaults, dependencies, supported combinations, feature boundaries, or operational tradeoffs when the source supports them

## Answer-option construction

The answer choices must be deliberately similar in plausibility. Do not create one obviously correct choice and three unrelated or exaggerated choices.

For every question:

- Write four options from the same technical category and at the same level of abstraction
- Keep the options similar in sentence structure, specificity, tone, and approximate length
- Make every distractor technically credible and capable of satisfying part of the scenario
- Make each distractor fail because of one subtle but decisive requirement
- Use near-neighbor services, configurations, scopes, tiers, data sources, or implementation patterns
- Prefer tradeoffs such as lower cost but insufficient capability, correct capability at the wrong scope, supported architecture with excess overhead, or a valid feature missing a prerequisite
- Avoid distractors that introduce unrelated technologies or outcomes
- Avoid wording that gives away the answer through greater detail, stronger qualifiers, or noticeably different terminology
- Do not make the correct answer consistently the longest, most specific, or only conditional option
- Do not use absolute claims such as “always,” “never,” “eliminates,” “all,” “100%,” or “automatically” unless the source explicitly supports the claim and comparable wording appears across the other options
- Do not use implausible promises such as guaranteed availability, universal remediation, or removal of required platform components
- Do not repeat exact wording from the scenario only in the correct answer
- Do not use “all of the above” or “none of the above”

A strong distractor should sound reasonable to a candidate who understands the feature generally but misses one boundary, prerequisite, scope rule, or design tradeoff.

## Difficulty and ambiguity controls

Increase difficulty through precision, not through missing information.

- Include all facts needed to determine the best answer
- Allow two or more options to appear reasonable at first glance
- Ensure only one option satisfies every stated requirement
- Base the distinction on source-supported details, not obscure trivia or unstated assumptions
- Use qualifiers such as minimize administrative effort, use the fewest resources, avoid agents, retain existing architecture, or support cross-subscription scope to create a best-answer decision
- Test default behavior versus optional configuration when supported
- Test capability versus supportability when supported
- Test service scope, data scope, or management scope when supported
- Test prerequisites and configuration order when supported
- Test preview boundaries only when they are explicitly described in the source
- Do not make a question vague merely by omitting a decisive requirement

## Explanation requirements

For each question, include:

- One correct answer
- Three plausible distractors
- Why the correct answer best satisfies all requirements
- Why each distractor is plausible
- The single decisive reason each distractor is inferior
- A tested-detail label
- A source reference supporting the answer

The explanation must identify the exact requirement that separates the best answer from the distractors. Do not dismiss distractors as simply unrelated or incorrect when they are valid in other scenarios.

## Question mix

- 40% architecture or design recommendation
- 20% SKU, tier, licensing, or capability boundary
- 15% prerequisite, dependency, or supported scenario
- 15% troubleshooting, validation, migration, or operations
- 10% command-line, query, automation, or configuration interpretation

Avoid simple recall questions. Prefer scenarios where several answers are valid in isolation but only one meets all requirements.

Do not create questions where the answer mainly depends on a date, deadline, retirement date, release date, or roadmap milestone. Convert date-based material into architecture, migration, risk, or replacement-feature questions when possible. If only the date matters, exclude it.

## Final validation

Verify each question:

- Maps to the listed task(s)
- Is fully supported by the source
- Has four options in the same technical category
- Uses plausible but inferior distractors
- Gives each distractor one source-supported reason for being inferior
- Contains no obviously absurd, unrelated, or exaggerated option
- Does not reveal the answer through wording, length, specificity, or grammar
- Has one best answer without depending on unstated assumptions
- Requires no outside knowledge
- Does not primarily belong to another AZ-305 task

Before finalizing, perform a “cover-the-answer” test: after hiding the explanations and answer key, all four choices should initially appear credible to a qualified candidate.
