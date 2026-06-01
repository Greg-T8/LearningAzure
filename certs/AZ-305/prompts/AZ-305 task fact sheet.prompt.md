# AZ-305 Exam Task Study Guide — Deep Product Facts Generator

## Role

You are helping me prepare for the **AZ-305: Designing Microsoft Azure Infrastructure Solutions** exam.

I will provide an **Exam Task Study Guide** for one AZ-305 task. The guide contains Microsoft documentation links, product references, architecture patterns, migration strategies, comparison tables, exam tips, and scenario guidance.

Your job is to produce **deep technical facts and requirements for each product, service, or major topic covered in the guide**.

The output should help me study facts that are **representative of what Microsoft could test on the AZ-305 exam**.

---

## Input

I will provide:

```text
Exam task study guide:
<Paste the study guide here>
```

The study guide may include:

- Core products
- Supporting products
- Adjacent products
- Architecture patterns
- Cloud Adoption Framework topics
- Azure Architecture Center guidance
- Microsoft Learn module references
- Exam tips
- Scenario traps

---

## Primary objective

For **each product, service, or major technical topic listed or clearly used in the study guide**, produce **5–10 deep technical facts or requirements**.

These should not be surface-level definitions.

Each fact should represent something that could reasonably appear in an AZ-305 scenario question, such as:

- A platform requirement
- A product limitation
- A service boundary
- An edge case
- A supported or unsupported migration path
- A sizing or scaling consideration
- A networking requirement
- A resiliency or availability requirement
- A governance or security requirement
- A cost or licensing discriminator
- A dependency or prerequisite
- A feature/tier/SKU distinction
- A “choose this instead of that” decision point
- A common exam trap

---

## Required research behavior

Use the study guide as the **product discovery source**, but do **not** rely only on the study guide for facts.

For every product or service:

1. Search the current **official Microsoft documentation**.
2. Prefer Microsoft Learn, Azure product documentation, Azure Architecture Center, Cloud Adoption Framework, Well-Architected Framework, and official product comparison pages.
3. Use non-Microsoft sources only if they help clarify terminology or point to an official Microsoft source.
4. Do not use Reddit, blogs, forums, or vendor marketing pages as authoritative sources for facts.
5. Cite the official Microsoft source used for each product section.
6. If Microsoft documentation has changed or the guide appears outdated, use the current Microsoft documentation and note the discrepancy.

---

## Product identification rules

Extract products and topics from the study guide using the following priority:

1. Products listed in a **Product and topic discovery pass** table.
2. Products listed in **Core product documentation**.
3. Products used in architecture patterns.
4. Products that appear repeatedly in exam tips, comparison tables, or scenario guidance.
5. Supporting services that materially affect the task, such as networking, monitoring, identity, governance, security, cost, backup, or migration tooling.

Include adjacent products only when they affect the exam task’s architecture decision.

For each item, classify it as one of:

- **Core**
- **Supporting**
- **Adjacent**
- **Framework / methodology**
- **Architecture guidance**

---

## Quality bar for facts

Each fact must be:

- **Technically specific**
- **Current**
- **Microsoft-documented**
- **Relevant to the provided AZ-305 task**
- **Representative of an exam discriminator**
- **Actionable for architecture decision-making**

Avoid facts like:

- “Azure App Service hosts web apps.”
- “Azure Monitor collects logs.”
- “Azure VMs are virtual machines.”
- “Azure Migrate helps migrate workloads.”

Prefer facts like:

- “Apps in the same App Service plan share the same compute resources and scale together, so resource-intensive apps or apps needing independent scaling may require separate plans.”
- “Azure Migrate dependency visualization can use agentless or agent-based analysis; agentless avoids Log Analytics dependency agents but provides different data granularity.”
- “AKS is appropriate when Kubernetes APIs or cluster-level extensibility are required; Container Apps is often preferable when the requirement is serverless containers without direct Kubernetes management.”
- “ExpressRoute uses private connectivity and BGP dynamic routing, but it does not encrypt traffic by default like a VPN tunnel.”

---

## Output format

Produce the output in Markdown.

Use this structure:

```markdown
# Deep Technical Facts and Requirements for <Exam Task>

## Scope

- Exam: AZ-305: Designing Microsoft Azure Infrastructure Solutions
- Task: <task name inferred from the study guide>
- Source guide: <briefly identify the provided study guide>
- Product selection method: Products and major topics were extracted from the provided guide, then validated against official Microsoft documentation.

## Product coverage summary

| Product / topic | Classification | Why it matters for this task |
|---|---|---|
| <Product> | Core / Supporting / Adjacent / Framework | <1-sentence relevance> |

---

## <Product or topic name>

**Classification:** Core / Supporting / Adjacent / Framework / Architecture guidance  
**Why it matters:** <1–2 sentences explaining why this product affects the AZ-305 task.>  
**Primary Microsoft source:** <official Microsoft documentation link>

### Deep technical facts / requirements

1. <Deep technical fact or requirement.>
2. <Deep technical fact or requirement.>
3. <Deep technical fact or requirement.>
4. <Deep technical fact or requirement.>
5. <Deep technical fact or requirement.>

### AZ-305 exam discriminator

<Explain how this product changes the answer in a scenario question.>

### Common trap

<Explain a common wrong assumption or exam trap involving this product.>
```

Repeat the product section for every product, service, or topic.

---

## Depth requirements

Each product must have **7-15 facts**.

Do not pad the list with generic statements.

If a product does not have 7 meaningful facts for this exam task, include it in an **Adjacent / limited relevance** section and explain why it is not central.

---

## Exam relevance filter

Before finalizing each fact, ask:

- Could this change the answer between two Azure services?
- Could this be used to eliminate a wrong answer?
- Could this appear as a requirement in a scenario?
- Does this explain a limitation, prerequisite, or tradeoff?
- Does this help distinguish IaaS, PaaS, containers, VMware, or hybrid migration?

Keep only facts that pass at least one of these checks.

---

## Final section

End with:

```markdown
## Highest-yield exam discriminators

| Scenario clue | Best answer | Why |
|---|---|---|
| <clue> | <service/product> | <reason> |
```

Include 10–20 scenario clues that summarize the most testable distinctions across the products.
