In studying for the AZ-104, I have used an GitHub Copilot to read an exam question and create an IaaC-based lab from the question so that I can get hands-on experience. How would this process change when studying for the AZ-305 exam?

For AZ-305, the process shifts from **“build what the question asks”** to **“derive and justify the right architecture from the requirements.”** AZ-104 is centered on implementing, managing, and monitoring Azure resources, while AZ-305 is centered on designing identity/governance/monitoring, data storage, business continuity, and infrastructure solutions as an overall architecture. Microsoft also describes the AZ-305 candidate as someone who manages how decisions in networking, identity, security, DR, governance, and data affect the whole solution. ([Microsoft Learn][1])

So your current AZ-104 flow:

**exam question → IaC lab → deploy → verify behavior**

should become this for AZ-305:

**exam question → requirements extraction → architecture options → decision/tradeoff write-up → targeted prototype IaC → validation against changed constraints**

That is the biggest change.

What changes in practice

1. **Start by pulling out requirements before touching IaC.**
   For AZ-305, business requirements and constraints are the driver. Microsoft’s architecture guidance is explicit that design decisions should be justified by business requirements such as scale, budget, compliance, growth, RTO, and RPO. ([Microsoft Learn][2])

2. **Generate multiple viable designs, not one implementation.**
   In AZ-104, one correct configuration path is often enough. In AZ-305, you usually need to compare options and explain why one is better for the stated constraints. The study guide language reflects this: many tasks are framed as “recommend a solution,” not “configure” or “deploy.” ([Microsoft Learn][3])

3. **Use IaC as a prototype, not as the final output.**
   For AZ-104, the lab itself is often the point. For AZ-305, IaC is still useful, but mainly to test the riskiest or most decision-sensitive part of the design: network topology, private connectivity, zone redundancy pattern, hub-and-spoke wiring, DR failover path, policy structure, logging pipeline, and similar items. The exam scope is design-heavy, not full build-out-heavy. ([Microsoft Learn][4])

4. **Add an explicit tradeoff step.**
   Your output should force comparison across cost, reliability, security, operational complexity, performance, and business continuity. That is much closer to the architect role Microsoft describes than a pure “does it deploy?” exercise. ([Microsoft Learn][5])

5. **Practice constraint changes.**
   After you settle on a design, mutate the scenario: lower budget, stricter compliance, global presence, private-only connectivity, lower RPO, different identity boundary, and so on. AZ-305 is largely about whether your recommendation changes correctly when the constraints change. That follows directly from Microsoft’s emphasis on aligning design to business outcomes and constraints. ([Microsoft Learn][2])

A better AZ-305 study workflow

For each practice question, have Copilot produce these 6 outputs instead of only a lab:

1. **Requirement sheet**
   Business goal, functional requirements, nonfunctional requirements, assumptions, constraints, unknowns.

2. **Decision matrix**
   2–3 candidate architectures with pros, cons, cost posture, reliability posture, security posture, and operational complexity.

3. **Recommended architecture**
   One chosen design with a short justification tied directly to requirements.

4. **Architecture diagram + service mapping**
   Which Azure services are used and why they fit.

5. **Targeted IaC prototype**
   Only the parts that are most valuable to validate hands-on.

6. **Change-impact review**
   “What if budget is cut by 30%?”
   “What if private access becomes mandatory?”
   “What if RPO changes from 24 hours to 15 minutes?”

How your Copilot prompt should change

For AZ-104, your prompt can be implementation-oriented.
For AZ-305, it should be architect-oriented.

Use something like this:

```text
Read this AZ-305 exam question and do the following:

1. Extract:
- business requirements
- technical requirements
- nonfunctional requirements
- constraints
- assumptions
- missing information

2. Produce 2-3 viable Azure architecture options.

3. Compare the options across:
- cost
- security
- reliability
- performance
- operational complexity
- scalability
- governance
- business continuity / DR

4. Recommend one option and explain why it is the best fit for the stated requirements.

5. Identify which parts are most worth validating hands-on.

6. Generate a small IaC-based prototype lab in Terraform or Bicep that validates only the key architectural decision points, not the full production environment.

7. Create 3 scenario variations that would force a different architectural choice.
```

What the lab should look like now

Your AZ-104 labs are probably close to:

* deploy resources
* configure them
* verify them
* maybe break/fix them

Your AZ-305 labs should look more like:

* read scenario
* extract requirements
* compare 2–3 designs
* choose one
* prototype only the critical slice
* document why the choice wins
* rerun the decision under altered constraints

A concrete example

AZ-104-style question:

* Deploy storage, secure access, configure networking, enable monitoring.

AZ-305-style version of the same topic:

* Decide between Blob vs Files vs NetApp Files.
* Decide between public access with restrictions vs private endpoints.
* Decide between LRS/ZRS/GRS based on durability and recovery needs.
* Decide how logging, governance, identity, and DR should fit together.
* Then build a small IaC prototype only for the chosen access pattern and resiliency pattern. ([Microsoft Learn][3])

The mental model

For AZ-104, ask:

* “Can I build and manage this correctly?”

For AZ-305, ask:

* “Should I choose this at all?”
* “What requirement is this choice satisfying?”
* “What tradeoff am I accepting?”
* “What would make me choose differently?”

That is the real transition from administrator study habits to solutions architect study habits. It also matches the current AZ-305 exam scope, which remains active and focuses on design across those four major domains. ([Microsoft Learn][4])

I can turn one of your existing AZ-104-style Copilot prompts into an AZ-305 version.

[1]: https://learn.microsoft.com/en-us/credentials/certifications/azure-administrator/?utm_source=chatgpt.com "Microsoft Certified: Azure Administrator Associate"
[2]: https://learn.microsoft.com/en-us/azure/architecture/guide/design-principles/build-for-business?utm_source=chatgpt.com "Build for business needs - Azure Architecture Center"
[3]: https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305?utm_source=chatgpt.com "Study guide for Exam AZ-305: Designing Microsoft Azure ..."
[4]: https://learn.microsoft.com/en-us/credentials/certifications/exams/az-305/?utm_source=chatgpt.com "Exam AZ-305: Designing Microsoft Azure Infrastructure ..."
[5]: https://learn.microsoft.com/en-us/credentials/certifications/azure-solutions-architect/?utm_source=chatgpt.com "Azure Solutions Architect Expert - Certifications"

Here's an example question. How would I be able to use this approach for this question?

Use this question as a **design-analysis exercise first**, and only a **small validation lab second**.

For AZ-305, this question sits in the **design identity, governance, and monitoring solutions** portion of the exam, where the task is to **recommend** the right mechanism, not just configure something. ([Microsoft Learn][1])

For this specific question, the workflow would look like this:

**1. Extract the real requirement**

From the scenario, the requirement is not “implement Conditional Access.”
It is:

* reduce the delay between changed user conditions and enforcement
* support policy violation/security issue response
* enable a “conversation” between the token issuer and the relying party app

That last phrase is the giveaway. Microsoft’s CAE documentation explicitly says that timely response to policy violations or security issues requires a **“conversation” between the token issuer (Microsoft Entra) and the relying party (enlightened app)**, and that the mechanism for that conversation is **Continuous Access Evaluation (CAE)**. ([Microsoft Learn][2])

**2. Map each answer choice to its role**

This is where the AZ-305 method differs from AZ-104.
You do not ask, “What can I configure?” You ask, “Which option solves the exact design problem?”

* **OpenID Connect (OIDC)**: identity layer for authentication/sign-in, not a near-real-time policy reevaluation mechanism.
* **OAuth 2.0 Authorization Code Flow**: token acquisition flow, not a continuous enforcement mechanism.
* **Two-factor authentication (2FA/MFA)**: an access control requirement, but it does not provide the token-issuer/relying-party feedback loop described here.
* **Continuous Access Evaluation (CAE)**: specifically designed for near-real-time response when conditions change, and specifically described as the conversation mechanism between issuer and relying party. ([Microsoft Learn][2])

So the answer is **CAE**, but the important AZ-305 skill is being able to justify it from the scenario wording.

**3. State the architect-style justification**

A strong AZ-305 answer would sound like this:

> Recommend **Continuous Access Evaluation (CAE)** because the concern is delayed enforcement after condition changes, and the scenario explicitly calls for a mechanism that enables communication between Microsoft Entra ID and the relying party application. CAE is the mechanism Microsoft documents for that purpose, enabling near-real-time reevaluation of access when critical events or Conditional Access-related conditions change. ([Microsoft Learn][2])

**4. Add the nuance that makes this more “AZ-305”**

The question mentions delay, so the design nuance matters: CAE improves timeliness, but it is not “magic instant everything.” Microsoft says the goal is near real time for critical events, though **latency up to 15 minutes may occur because of event propagation**, while **IP location policy enforcement is instant**. That kind of nuance is exactly the sort of thing that separates an architect answer from a memorized keyword answer. ([Microsoft Learn][2])

**5. Turn it into a small hands-on lab**

This is where your Copilot/IaC workflow still helps, but the lab is smaller and more targeted than an AZ-104 lab.

For this question, the lab would not be “deploy a big environment.”
It would be:

* create a test tenant/app scenario that uses Microsoft Entra Conditional Access
* target a CAE-capable relying party scenario
* test a sign-in
* change a relevant condition
* observe whether access is reevaluated promptly

A practical lab objective could be:

> Validate how Conditional Access enforcement behaves when user/account state or location-related conditions change, and document where CAE improves responsiveness versus normal token lifetime behavior. ([Microsoft Learn][2])

**6. What you would ask Copilot to produce**

For this exact question, I would have Copilot generate four outputs:

1. **Requirement extraction**

   * delayed enforcement is the problem
   * “conversation” between issuer and relying party is the key phrase
   * mechanism must address policy/security changes after token issuance

2. **Option elimination table**

   * OIDC = sign-in protocol
   * OAuth code flow = token acquisition flow
   * 2FA = authentication requirement
   * CAE = near-real-time reevaluation mechanism

3. **Recommended answer with justification**

   * recommend CAE
   * explain why the word “conversation” is decisive

4. **Mini validation lab**

   * create test policy
   * sign in to a CAE-aware scenario
   * trigger a condition change
   * capture expected behavior and timing observations

A good Copilot prompt for this question would be:

```text
Read this AZ-305 question and do the following:

1. Extract the design requirement, constraint, and trigger phrases.
2. Identify which phrase in the prompt is most decisive.
3. Compare each answer choice by its architectural role:
   - authentication protocol
   - authorization flow
   - access control requirement
   - continuous enforcement mechanism
4. Recommend the best answer and justify it in 4-6 sentences.
5. Create a small lab plan to validate the selected mechanism in Microsoft Entra.
6. List what behavior I should expect to observe if the recommendation is correct.
```

For this question, the most important trigger phrase is:

> “enables a conversation between the token issuer and the relying party”

That should immediately push you to **CAE**, because Microsoft uses almost that exact framing in the official documentation. ([Microsoft Learn][2])

So the AZ-305 version of your method for this item becomes:

**question → extract decisive wording → map options to architectural roles → justify recommendation → design a tiny validation lab**

That is the pattern you want to practice repeatedly for AZ-305.

I can also turn this into a reusable **AZ-305 Copilot prompt template** for identity, networking, storage, and DR questions.
