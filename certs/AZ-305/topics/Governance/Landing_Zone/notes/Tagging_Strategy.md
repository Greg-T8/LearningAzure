Your proposed model aligns closely with Microsoft’s current CAF tagging guidance. Microsoft now explicitly groups foundational tags into **functional, classification, accounting, purpose, and ownership** categories—the same model you are building. ([learn.microsoft.com][1])

I would make one important architectural adjustment: **do not interpret “CAF aligned” as “put every tag on every resource.”** Instead, define an authoritative scope for each tag and inherit downward only when the value remains true.

### Recommended hierarchy

Think of the three levels this way:

| Level              | What it should describe                                                          |
| ------------------ | -------------------------------------------------------------------------------- |
| **Subscription**   | Organizational, financial, and broad governance ownership                        |
| **Resource group** | Workload/application, environment, business purpose, operational ownership       |
| **Resource**       | Technical characteristics or classifications that can differ within the workload |

The inheritance model I recommend is therefore:

**Subscription → Resource Group → Resource**, but only for tags whose semantics support inheritance.

For actual Azure tags, Azure Policy provides built-ins for subscription-to-resource and resource-group-to-resource inheritance, including `if missing` variants. Microsoft specifically documents that the `if missing` policy preserves a different value already assigned to the child resource. ([Microsoft Learn][2])

One limitation is important: the built-in subscription inheritance policy doesn't provide a clean subscription → resource-group → resource chain. If you specifically want subscription tags copied onto RGs, you'll generally need a small custom `Modify` policy for subscription → RG, followed by the built-in RG → resource policy. ([Microsoft Learn][3])

## My recommended tag schema

Here is how I would refine your list.

| Tag                    | Category               | Subscription |    Resource Group   |   Resource  | Inheritance recommendation           |
| ---------------------- | ---------------------- | :----------: | :-----------------: | :---------: | ------------------------------------ |
| **businessunit**       | Ownership              |    **Yes**   |         Yes         |     Yes     | Subscription → RG → Resource         |
| **costcenter**         | Accounting             |   **Yes***   |       **Yes**       |     Yes     | Subscription or RG → Resource        |
| **application**        | Functional             |  Conditional |       **Yes**       |     Yes     | RG → Resource                        |
| **environment**        | Functional             |  Conditional |       **Yes**       |     Yes     | RG → Resource                        |
| **businessprocess**    | Purpose                |  Conditional |       **Yes**       |     Yes     | RG → Resource                        |
| **criticality**        | Classification/Purpose |      No      |       **Yes**       |     Yes     | RG → Resource if homogeneous         |
| **opsteam**            | Ownership              |  Conditional |       **Yes**       |     Yes     | RG → Resource                        |
| **dataclassification** | Classification         |      No      | **Yes/Conditional** |   **Yes**   | Inherit only when homogeneous        |
| **region**             | Functional             |      No      |     Conditional     |   **Yes**   | Derive from actual resource location |
| **tier**               | Functional             |      No      |     Conditional     |   **Yes**   | Usually resource-specific            |
| department             | Accounting             |  Conditional |     Conditional     | Conditional | Consider eliminating                 |
| billingcode            | Accounting             |  Conditional |       **Yes**       |     Yes     | RG → Resource                        |
| revenueimpact          | Purpose                |      No      |   **Yes/Optional**  |   Optional  | Usually workload-level               |
| regulatorycompliance   | Classification         |      No      |       **Yes**       | Conditional | RG → Resource when applicable        |
| sla                    | Classification         |      No      |   **Yes/Optional**  | Conditional | Usually workload/service-level       |

* `costcenter` belongs on the subscription only when the entire subscription actually belongs to one cost center. Otherwise, make the RG authoritative.

### Base required tags

I would start considerably smaller than the complete CAF taxonomy. My **base required set** would be:

| Required tag         | Why                                              |
| -------------------- | ------------------------------------------------ |
| `businessunit`       | Executive/business accountability                |
| `costcenter`         | Chargeback/showback                              |
| `application`        | Identifies the workload consuming the resource   |
| `environment`        | Prod/dev/test/etc. operational context           |
| `criticality`        | DR, monitoring, operational prioritization       |
| `opsteam`            | Identifies the team responsible for operating it |
| `dataclassification` | Security/governance context                      |
| `region`             | Geographic/reporting context                     |

This gives you **eight core dimensions** without making tagging burdensome.

CAF currently specifically recommends functional tags such as application, tier, environment, and region; classification tags such as criticality/confidentiality/SLA; accounting tags such as department and cost center; purpose tags such as business process/business impact/revenue impact; and ownership tags such as business unit and operations team. ([learn.microsoft.com][1])

## I would consolidate a few of your proposed tags

There are a couple areas where I think your current design risks overlap.

**`businessimpact` vs `criticality`**

I would probably standardize on:

`criticality = mission-critical | high | medium | low`

rather than maintaining both:

`businessimpact = critical`

and:

`criticality = mission-critical`

Unless the organization has a genuine need to distinguish *technical service criticality* from *business impact*, these eventually become duplicate fields maintained inconsistently.

**`businessunit` vs `department`**

These can legitimately be different, but make Finance explain the distinction before requiring both.

For example:

* `businessunit = Operations`
* `department = Information Technology`
* `costcenter = 42310`

If Finance can't give you a reporting use case where BusinessUnit and Department answer different questions, I would eliminate `department`.

**`billingcode` vs `costcenter`**

Same principle. If `billingcode` represents a project/job/grant/work-order code separate from the permanent cost center, keep it. Otherwise it is redundant.

**`revenueimpact`**

I would make this optional rather than part of your minimum standard. It works well for applications such as payment processing or customer-facing services, but doesn't map cleanly to infrastructure such as DNS, connectivity, monitoring, identity, or security resources.

## A practical inheritance example

Suppose you have:

**Subscription**

```text
businessunit = Operations
costcenter   = 42000
```

Then:

**Resource group**

```text
businessunit    = Operations      <- inherited
costcenter      = 42125           <- override
application     = FareCollection
environment     = Production
businessprocess = PaymentProcessing
criticality     = MissionCritical
opsteam         = TransitApps
dataclassification = Confidential
```

Resources inside the RG inherit those values where appropriate.

But a SQL database could add:

```text
tier               = Database
dataclassification = Restricted
region             = westus2
```

The resource is therefore allowed to become **more specific than its parent**.

That is why I'd generally use:

> **Inherit tag ... if missing**

rather than:

> **Inherit tag ...**

The first establishes defaults while preserving legitimate child-level overrides. Microsoft's built-in `Modify` policies support exactly this behavior and can remediate existing resources. ([Microsoft Learn][2])

## Special consideration: `region`

Microsoft's current CAF guidance explicitly recommends a region tag, even though Azure already exposes the resource `location` property. ([learn.microsoft.com][1])

I would therefore keep `region`, but **not inherit it from the subscription**.

A subscription can contain:

```text
westus2
eastus
global
```

and even a resource group's own Azure `location` doesn't mean all resources inside that RG are in that region.

Ideally:

```text
region = westus2
```

is populated by IaC or Azure Policy based on the resource's actual location.

If your organizational standard is **one workload + one region per resource group**, then RG → resource inheritance becomes reasonable.

## Recommended Azure Policy approach

I would ultimately build a **Tag Governance initiative** containing roughly three classes of controls:

| Policy class           | Example                                                                        |
| ---------------------- | ------------------------------------------------------------------------------ |
| **Require**            | Require `application`, `environment`, `criticality` on RGs                     |
| **Inherit**            | Inherit `application`, `environment`, `costcenter`, etc. from RG if missing    |
| **Normalize/validate** | Restrict `environment` to `production`, `development`, `test`, `sandbox`, etc. |

Microsoft provides built-ins for requiring tags on resource groups/resources and for adding/inheriting tags with `Modify`; remediation can correct existing resources as well. ([Microsoft Learn][2])

I'd be cautious about immediately putting `Deny` policies on eight tags. CAF's broader governance guidance recommends a monitor-first approach before applying more restrictive controls. ([Microsoft Learn][4])

A sensible maturity sequence would be:

**Audit → Modify/inherit → Require/Deny**

once you know the schema works.

## Don't confuse Azure Policy inheritance with Cost Management inheritance

There are actually two different mechanisms worth using.

**Azure Policy tag inheritance** actually writes tags to resources.

**Cost Management tag inheritance** does **not** modify the Azure resource. It copies subscription/RG/billing tags into **cost usage records** so that chargeback data is complete. Microsoft explicitly recommends this because some Azure resource types either don't support tags or don't emit their tags into cost data. ([Microsoft Learn][5])

For a chargeback model, I would enable **both**:

**Azure Policy**
→ operational/governance consistency

**Cost Management Tag Inheritance**
→ financial reporting completeness

Cost Management can automatically apply subscription and resource-group tags to child usage data; on MCA billing profiles it can additionally inherit billing profile and invoice-section tags. ([Microsoft Learn][5])

### Resulting model

The structure I'd recommend adopting is:

```text
SUBSCRIPTION
│
├─ businessunit
├─ costcenter              (if uniform)
└─ opsteam                 (platform subscriptions)
        │
        ▼
RESOURCE GROUP
│
├─ businessunit            <- inherited/default
├─ costcenter              <- inherited or override
├─ application
├─ environment
├─ businessprocess
├─ criticality
├─ opsteam
├─ dataclassification
├─ billingcode             (when needed)
└─ regulatorycompliance    (when applicable)
        │
        ▼
RESOURCE
│
├─ inherited workload tags
│
├─ region
├─ tier
└─ resource-specific
   classification overrides
```

That gives you a CAF-aligned taxonomy without forcing every Azure object to carry 15–20 manually maintained tags. It also makes the **resource group the primary workload metadata boundary**, which tends to fit Azure landing-zone designs much better than trying to make the subscription or individual resource the source of truth for everything. ([learn.microsoft.com][1])

If this is for the BART landing-zone design, I would make one additional distinction between **Platform subscriptions** (`Connectivity`, `Identity`, `Management`, `Security`) and **Landing Zone subscriptions**, because tags such as `businessunit`, `application`, `businessprocess`, and `costcenter` should behave somewhat differently in those two subscription types.

[1]: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging "Define your tagging strategy - Cloud Adoption Framework | Microsoft Learn"
[2]: https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-policies?utm_source=chatgpt.com "Policy definitions for tagging resources - Azure Resource Manager | Microsoft Learn"
[3]: https://learn.microsoft.com/en-sg/answers/questions/5748570/azure-tagging-policy?utm_source=chatgpt.com "Azure Tagging Policy - Microsoft Q&A"
[4]: https://learn.microsoft.com/sk-sk/azure/cloud-adoption-framework/govern/enforce-cloud-governance-policies?utm_source=chatgpt.com "Enforce cloud governance policies - Cloud Adoption Framework | Microsoft Learn"
[5]: https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/enable-tag-inheritance "Group and allocate costs using tag inheritance - Microsoft Cost Management | Microsoft Learn"
