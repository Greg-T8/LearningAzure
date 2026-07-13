# AZ-305 Exam Task Study Guide — Deep Product Facts Generator (v3)

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

Model used:
<Model name and reasoning mode, for example: GPT 5.6 Sol High>
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

For **each product, service, or major technical topic listed or clearly used in the study guide**, produce deep technical facts and requirements covering the taxonomy defined in the Depth requirements section below.

Facts must not be surface-level definitions or decision-level restatements. Each fact must assert a specific property, limit, behavior, default, incompatibility, or requirement — something that could appear as a discriminator in an AZ-305 scenario question.

A fact that only states which service to choose for a given requirement belongs in the **Highest-yield exam discriminators** table, not in the facts list.

---

## Required research behavior

Use the study guide as the **product discovery source**, but do **not** rely only on the study guide for facts.

For every product or service:

1. Search the current **official Microsoft documentation**.
2. Prefer Microsoft Learn, Azure product documentation, Azure Architecture Center, Cloud Adoption Framework, Well-Architected Framework, and official product comparison pages.
3. Use non-Microsoft sources only if they help clarify terminology or point to an official Microsoft source.
4. Do not use Reddit, blogs, forums, or vendor marketing pages as authoritative sources for facts.
5. Cite the official Microsoft source used for each individual fact, not only once at the product-section level.
6. For every numeric claim — a limit, default, maximum, SLA percentage, retention window, port, version, or quota — cite the specific service limits page, pricing or tier page, or official quotas documentation, not just the product overview.
7. If a fact involves a recently retired feature, changed limit, or feature currently in preview, note the specific change and the month and year it took effect or was announced.
8. If Microsoft documentation has changed or the guide appears outdated, use the current Microsoft documentation and note the discrepancy.

## Inline reference requirements

Every independently stated technical fact must end with one or more inline Markdown links to the official Microsoft documentation that directly supports that fact.

Use friendly, descriptive link text that identifies the referenced page:

```markdown
1. Event Hubs streaming requires an authorization rule with `Manage`, `Send`, and `Listen`; updating the setting also requires `ListKey` on that rule. Diagnostic settings cannot target a compacted event hub because Azure Monitor does not provide the required partition key. [Stream Azure Monitor logs to Event Hubs](https://learn.microsoft.com/azure/azure-monitor/platform/stream-monitoring-data-event-hubs).
```

Apply this rule to:

- Every numbered item under **Deep technical facts / requirements**
- Every statement under **Incompatibilities and mutual exclusions**
- Every bullet under **Edge cases and gotchas**
- Every **AZ-305 exam discriminator** and **Common trap**
- Every factual statement in the **Why** column of **Highest-yield exam discriminators**
- Every current-documentation, retirement, deprecation, preview, or regional-availability note included elsewhere in the fact sheet

Citation rules:

1. Place the reference at the end of the fact it supports; do not rely on a section-level source to support uncited facts.
2. Link directly to the most specific official Microsoft page or page section available. Use an overview page only when it directly supports the claim.
3. Use descriptive link text such as `[Azure Monitor diagnostic settings limits](https://learn.microsoft.com/...)`; do not use raw URLs, footnote-only citations, or generic labels such as `[Source]`, `[Reference]`, or `[Learn more]`.
4. When one fact contains multiple claims that are not supported by the same page, include multiple inline links at the end of that fact.
5. Do not cite a page merely because it concerns the same product. Confirm that the page directly supports the precise behavior, limit, requirement, incompatibility, or date stated.
6. Use only official Microsoft-owned documentation for authoritative citations, primarily `learn.microsoft.com`, `azure.microsoft.com`, and official Microsoft lifecycle or licensing pages.
7. A **Primary Microsoft source** or **Limits and quotas source** at the start of a product section is useful orientation, but it does not replace the required inline reference on each fact.
8. If no official Microsoft source directly supports a claim, omit the claim rather than present it without an inline reference.

---

## Product identification rules

Extract products and topics from the study guide using the following priority:

1. Products listed in a **Product and topic discovery pass** table.
2. Products listed in **Core product documentation**.
3. Products used in architecture patterns.
4. Products that appear repeatedly in exam tips, comparison tables, or scenario guidance.
5. Supporting services that materially affect the task, such as networking, monitoring, identity, governance, security, cost, backup, or migration tooling.

Include adjacent products only when they affect the exam task's architecture decision.

For each item, classify it as one of:

- **Core**
- **Supporting**
- **Adjacent**
- **Framework / methodology**
- **Architecture guidance**

---

## Quality bar for facts

Each fact must be:

- **Technically specific** — asserts a property, limit, behavior, or constraint, not a preference or intent
- **Current** — reflects documentation as of the research date; note retired or preview features explicitly
- **Microsoft-documented** — sourced from official Microsoft documentation
- **Inline-cited** — ends with a friendly Markdown link to the official Microsoft page that directly supports it
- **Relevant to the provided AZ-305 task**
- **Actionable** — would change an architecture decision or eliminate a wrong answer

**Quantitative specificity rule:** Any fact that involves a number must state the number. Describing it without stating it is not acceptable.

- Fails: "App Service supports multiple deployment slots."
- Passes: "Standard App Service plans support up to 5 deployment slots; Premium v3 supports up to 20."

**Decision-fact ban:** A fact that only restates which service to use for a requirement belongs in the discriminator table, not the facts list. Facts must state *why* — a limit, a behavior, a constraint, or a requirement — not just *what*.

**Preview and regional flag rule:** Mark any feature or SKU currently in preview as `[Preview]`. Mark any feature with limited regional availability as `[Limited regions — verify before specifying]`. Do not recommend preview features as correct exam answers without flagging them.

**Incompatibility rule:** Every Core product section must include at least one fact that states a requirement combination that is invalid or that forces a different service or configuration choice.

---

### Avoid facts like

- "Azure App Service hosts web apps."
- "Azure Monitor collects logs."
- "Azure VMs are virtual machines."
- "Azure Migrate helps migrate workloads."
- "AKS is appropriate when Kubernetes is required." *(decision-only — belongs in the discriminator table)*

### Prefer facts like

- "Standard App Service plans support up to 5 deployment slots; Premium v3 supports up to 20. Slots are unavailable on Basic and below, so a blue-green or staged-cutover requirement eliminates those tiers."
- "App Service VNet integration controls outbound traffic from the app into a VNet; private endpoint controls inbound access to the app. They solve opposite traffic directions and are not interchangeable. Neither is enabled by default."
- "ASE v1 and v2 are retired; new isolated deployments require ASE v3. For most private networking requirements, Premium v3 with VNet integration and a private endpoint is far cheaper than an ASE and is the correct default unless single-tenant hardware isolation or strict compliance mandates ASE v3."
- "AKS Free tier has no financially backed SLA and supports clusters of roughly 10 nodes, making it unsuitable for production. Standard tier adds a 99.95% API server uptime SLA when paired with availability zones (99.9% without) and supports clusters up to 5,000 nodes. Container Apps Consumption plan scales to zero and bills per second of active use; AKS nodes bill continuously even when idle, so Container Apps is cost-correct for bursty or intermittent workloads even when the team is familiar with Kubernetes."
- "ExpressRoute does not encrypt data in transit by default. MACsec can encrypt at the physical layer for supported providers. Adding IPsec over ExpressRoute private peering provides tunnel encryption but requires a VPN gateway running alongside the circuit, adding cost and latency. Azure VMware Solution requires ExpressRoute and cannot use VPN Gateway as its primary connectivity path."
- "The Azure Migrate agentless dependency analysis option for VMware uses VMware APIs through vCenter, requires no guest agents, and refreshes connection data approximately every 6 hours with a bounded export window of about 30 days. Agent-based dependency analysis requires the Log Analytics agent and the Dependency agent on each server; the Log Analytics agent (MMA) was retired on 31 August 2024 and is not valid in new designs."
- "Ultra Disk and Premium SSD v2 both support sub-millisecond latency and high IOPS, but neither supports ZRS, availability sets, or use as an OS disk. A design that requires both maximum disk performance and zone redundancy cannot use Ultra Disk or Premium SSD v2; Premium SSD with ZRS is the only disk type combining high performance and zone redundancy."

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
- Research date: <month and year facts were verified>
- Product selection method: Products and major topics were extracted from the provided guide, then validated against current official Microsoft documentation.

## Product coverage summary

| Product / topic | Classification | Why it matters for this task |
|---|---|---|
| <Product> | Core / Supporting / Adjacent / Framework | <1-sentence relevance> |

---

## <Product or topic name>

**Classification:** Core / Supporting / Adjacent / Framework / Architecture guidance
**Why it matters:** <1–2 sentences explaining why this product affects the AZ-305 task.>
**Primary Microsoft source:** <product documentation or overview page>
**Limits and quotas source:** <service limits page, pricing tier page, or quotas page — required for every Core product>

### Deep technical facts / requirements

Cover at least 8 taxonomy categories from the Depth requirements section. State specific numbers for every limit, default, maximum, SLA, and retention value. Flag preview features as [Preview] and limited-region features as [Limited regions — verify before specifying].

1. <Deep technical fact.> [<Friendly official Microsoft page title>](<direct Microsoft documentation URL>).
2. <Deep technical fact.> [<Friendly official Microsoft page title>](<direct Microsoft documentation URL>).
...

### Incompatibilities and mutual exclusions

State at least one requirement combination that is invalid or that forces a different service or configuration. Format: "If [requirement A] and [requirement B] are both present, [service or configuration] cannot be used because [reason]. [<Friendly official Microsoft page title>](<direct Microsoft documentation URL>)."

### Edge cases and gotchas

3–5 items focusing on: "only works if" conditions, surprising defaults, soft versus hard limits, regional availability gaps, recently retired or renamed features, and preview-to-GA behavior changes.

- <Edge case or gotcha.> [<Friendly official Microsoft page title>](<direct Microsoft documentation URL>).
- <Edge case or gotcha.> [<Friendly official Microsoft page title>](<direct Microsoft documentation URL>).
...

### AZ-305 exam discriminator

<Explain how this product changes the correct answer in a scenario question, referencing specific limits or behaviors.> [<Friendly official Microsoft page title>](<direct Microsoft documentation URL>).

### Common trap

<The single most likely wrong assumption about this product in an exam scenario.> [<Friendly official Microsoft page title>](<direct Microsoft documentation URL>).
```

Repeat the product section for every product, service, or topic.

---

## Depth requirements

Each **Core** product section must cover at least **8 of the following 12 taxonomy categories**. If fewer than 8 can be documented with specific facts for this exam task, move the product to the Adjacent / limited relevance section and explain why.

1. **Limits and quotas** — state specific numbers (nodes, slots, connections, throughput, retention days, instance counts, gateway units)
2. **Prerequisites and dependencies** — what must exist or be deployed first; what other services are required
3. **Incompatibilities and mutual exclusions** — what cannot be combined with what; what requirement combinations are invalid
4. **Defaults versus configurable maximums** — state both the out-of-box default and the configurable ceiling
5. **SKU, tier, or plan gating** — which features are locked behind which tier or plan; which tiers are retired or deprecated
6. **Version or runtime requirements** — specific supported versions, deprecation timelines, or retirement dates
7. **Networking requirements or constraints** — required ports, connectivity models, VNet integration details, private endpoint behavior, default exposure
8. **Identity, RBAC, and access** — required roles, managed identity support, workload identity, credential handling
9. **Resiliency and SLA** — specific SLA percentages, availability zone support, failover and replication behavior
10. **Cost discriminators and licensing** — Azure Hybrid Benefit eligibility, reservation support, per-unit or per-second billing, free versus paid tiers
11. **Preview versus GA status and regional availability** — flag preview features; note SKUs or features not available in all regions
12. **Edge cases** — "only works if" conditions, exceptions to the general rule, surprising or non-obvious behavior

**Supporting** and **Adjacent** products require at least 4 taxonomy categories covered.

**Decision-only facts belong in the discriminator table.** Do not use taxonomy coverage as justification for restating "choose service X when requirement Y is present" in the facts list.

---

## Exam relevance filter

Before finalizing each fact, ask:

- Could this change the answer between two Azure services?
- Could this be used to eliminate a wrong answer?
- Could this appear as a hard requirement in a scenario?
- Does this explain a limitation, prerequisite, incompatibility, or tradeoff?
- Does this help distinguish IaaS, PaaS, containers, VMware, or hybrid options?
- Is this a specific number or constraint that would invalidate a seemingly correct answer?

Keep only facts that pass at least one of these checks.

---

## Final section

End the substantive fact-sheet content with:

```markdown
## Highest-yield exam discriminators

| Scenario clue | Best answer | Why |
|---|---|---|
| <clue> | <service/product> | <reason — reference a specific limit or behavior>. [<Friendly official Microsoft page title>](<direct Microsoft documentation URL>). |
```

Include 10–20 scenario clues. Prioritize clues where the correct answer depends on a specific limit, incompatibility, default behavior, or tier restriction, not just a general service preference. Where a numeric threshold is the discriminator, state it in the Why column.

Before returning the fact sheet, perform a citation audit: verify that every factual numbered item, incompatibility, gotcha bullet, discriminator, trap, table reason, and documentation-change note ends with a direct, friendly inline link to an official Microsoft source. Revise or remove any unsupported or uncited fact. Do not output the audit itself.

After all substantive content, add the following as the final non-blank content in the document. Use the model name and reasoning mode supplied in the input; do not guess or substitute a different model name.

```markdown
---

_Model used to research and author this fact sheet: <Model name and reasoning mode>._
```

For example:

```markdown
---

_Model used to research and author this fact sheet: GPT 5.6 Sol High._
```

---

## Length and scope guidance

Deeper taxonomy coverage per product produces longer output. If the total output becomes unwieldy, reduce the number of products covered per run rather than reducing depth. It is better to produce one complete, deep product section than five shallow ones. Prioritize Core products and reduce or defer Supporting and Adjacent products to a follow-up run if needed.
