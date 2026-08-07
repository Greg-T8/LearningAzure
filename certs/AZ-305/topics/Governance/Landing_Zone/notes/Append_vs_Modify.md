Both **Modify** and **Append** can alter an Azure resource request before it reaches the resource provider, but they serve different purposes.

| Capability                       | `Modify`                         | `Append`                             |
| -------------------------------- | -------------------------------- | ------------------------------------ |
| Add a property                   | Yes                              | Yes                                  |
| Change/replace an existing value | **Yes**                          | **No — conflict can deny request**   |
| Remove something                 | Tags only                        | No                                   |
| Modify tags                      | **Recommended**                  | Possible, but not recommended        |
| Modify existing resources later  | **Yes, via remediation task**    | No                                   |
| Requires managed identity        | For remediation                  | No                                   |
| Typical use                      | Tags and configurable properties | Adding required fields/array entries |

### Modify

`Modify` is the more capable effect. It can **add, replace, or—in the case of tags—remove values** from the resource request. It can also remediate resources that already exist. ([Microsoft Learn][1])

For example, suppose your policy requires:

```text
Environment = Production
```

and someone submits:

```text
Environment = Prod
```

A `Modify` policy can change the request to:

```text
Environment = Production
```

This makes `Modify` particularly appropriate for the tagging policies you've been considering. Microsoft specifically recommends **Modify rather than Append for tags**. ([Microsoft Learn][1])

The other major advantage is remediation. If you assign the policy today and already have 5,000 resources missing the tag, you can create a **remediation task** to update those existing resources. The policy assignment needs a managed identity with the necessary permissions for that remediation. ([Microsoft Learn][1])

### Append

`Append` is more narrowly focused on **adding something to the incoming request**.

For example, you could ensure a particular IP rule is present in a Storage Account's network ACL:

```text
Existing:
10.1.0.0/16

Policy appends:
10.2.0.0/16

Result:
10.1.0.0/16
10.2.0.0/16
```

This is particularly useful for **array-type properties**, where you want Azure Policy to ensure an additional element is present. ([Microsoft Learn][2])

There is an important behavioral difference: if `Append` attempts to add a scalar property but the deployment already specifies that property with a **different value**, Azure Policy doesn't overwrite it. The conflict causes the request to effectively be **denied**. ([Microsoft Learn][2])

For example:

```text
Policy:
Append TLS version = 1.2

Deployment:
TLS version = 1.0
```

Azure Policy cannot simply overwrite `1.0` with `1.2` using `Append`; the conflicting request can be rejected.

With `Modify`, assuming that property has a **modifiable Azure Policy alias**, Azure Policy could instead transform:

```text
1.0 → 1.2
```

### The biggest operational difference

Think of them this way:

**Append:**

> "Make sure this additional information is part of the request."

**Modify:**

> "Make sure this property has the value I require, and fix it if necessary."

And there's another major distinction for governance:

```text
                 New/updated resources     Existing resources
                 ─────────────────────     ──────────────────
Append                  Yes                 Detect only
Modify                  Yes                 Remediate
```

When Azure Policy evaluates an existing resource against an `Append` policy, it **doesn't modify the existing resource**; it can only report it as noncompliant. ([Microsoft Learn][2])

### For your Azure governance/tagging design

I would generally use **Modify** for things such as:

* inheriting `businessunit` from the subscription/resource group
* inheriting `costcenter`
* adding `environment`
* correcting tag values
* enforcing standardized tag values
* adding missing tags

For example:

```text
Subscription
    businessunit = Finance
          │
          ▼
Resource Group
    businessunit = Finance
          │
          ▼
Resource
    businessunit = Finance
```

A `Modify` policy can implement that inheritance and subsequently remediate existing resources that are missing the tag.

I would reserve **Append** primarily for cases where you're adding **non-tag resource properties, especially members of arrays**, and you don't need to repair existing resources.

**Rule of thumb: `Modify` = enforce/correct state; `Append` = augment the incoming request.** Microsoft explicitly recommends `Modify` over `Append` for tags because of its additional operations and remediation capability. ([Microsoft Learn][1])

[1]: https://learn.microsoft.com/th-th/azure/governance/policy/concepts/effect-modify?utm_source=chatgpt.com "Azure Policy definitions modify effect - Azure Policy | Microsoft Learn"
[2]: https://learn.microsoft.com/hr-hr/azure/governance/policy/concepts/effect-append?utm_source=chatgpt.com "Azure Policy definitions append effect - Azure Policy | Microsoft Learn"
