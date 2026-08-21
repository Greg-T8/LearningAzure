Yes. Microsoft’s recommendation to separate production and non-production **subscriptions** is the cleanest architecture, but AMBA does not require that model. AMBA specifically supports mixed-environment subscriptions through **resource-level tagging**.

For customers that have production and development VMs in the same subscription, I would generally use this pattern:

1. **Keep AMBA assigned to the subscription/management group.**
2. Identify the non-production resources with a tag.
3. Configure AMBA to exclude those resources from alerting.
4. Continue monitoring production resources normally.

AMBA has a built-in `MonitorDisable` mechanism. By default, applying this to a development VM prevents AMBA from targeting it:

```text
MonitorDisable = true
```

AMBA also recognizes default exclusion values including `Test`, `Dev`, and `Sandbox`. Microsoft explicitly states that individual VMs, VMSS instances, and Arc-enabled servers can be excluded this way even though some VM alert rules operate at **subscription scope**. ([Azure][1])

### Better approach: reuse the customer's Environment tag

For most customers, I would **not introduce `MonitorDisable` as another manually managed tag** if they already have good environment tagging.

AMBA allows you to change the tag name and exclusion values. For example:

```json
"ALZMonitorDisableTagName": {
  "value": "Environment"
},
"ALZMonitorDisableTagValues": {
  "value": [
    "Dev",
    "Development",
    "Test",
    "QA",
    "Sandbox"
  ]
}
```

The result becomes:

| VM          | Environment | AMBA      |
| ----------- | ----------- | --------- |
| SQL-PROD-01 | Production  | Monitored |
| APP-PROD-01 | Production  | Monitored |
| APP-DEV-01  | Dev         | Excluded  |
| SQL-TEST-01 | Test        | Excluded  |
| APP-SBX-01  | Sandbox     | Excluded  |

AMBA's documentation specifically says the disable mechanism can be changed to use an existing tag such as `Environment` and values such as Production, Test, or Sandbox. ([Azure][1])

This is the model I would recommend for the customers you describe.

### Resource groups can make this much easier

If the customer has something like:

```text
Subscription: Production-Applications
|
+-- rg-app1-prod
|    +-- vm-app1-prod01
|    +-- vm-app1-prod02
|
+-- rg-app1-dev
     +-- vm-app1-dev01
     +-- vm-app1-dev02
```

you could put:

```text
Environment = Production
```

on `rg-app1-prod` and:

```text
Environment = Dev
```

on `rg-app1-dev`.

Then use the built-in Azure Policy:

**Inherit a tag from the resource group if missing**

to put the `Environment` tag onto the individual resources. Existing resources can also be remediated. ([Microsoft Learn][2])

That distinction is important because **Azure resource tags don't automatically inherit from their resource group**. AMBA needs the exclusion tag on the evaluated resource. Using Azure Policy makes the RG-based model manageable.

So you get:

```text
rg-app1-dev
Environment = Dev
       |
       | Azure Policy
       v
vm-app1-dev01
Environment = Dev
       |
       | AMBA evaluates Environment
       v
Excluded from AMBA
```

### I would avoid disabling AMBA at the subscription

For a mixed subscription, don't do:

```text
Subscription
MonitorDisable = true
```

That is too broad. For subscription-scoped VM log alerts, Microsoft specifically notes that putting the disable tag at subscription scope disables the targeted VM policies for **all VMs in that subscription**. ([azure.github.io][1])

Instead, put the environment/exclusion information at the **VM/resource level**.

There is also an important exception: AMBA's `MonitorDisable` resource mechanism does **not apply in the same manner to Service Health and Resource Health policies**. Those should be considered separately because they operate at broader scopes. ([Azure][1])

### One other option: don't completely exclude development

For some customers, I would not exclude development at all. You have three reasonable operating models:

| Model                  | Production      | Development           | When I'd use it                               |
| ---------------------- | --------------- | --------------------- | --------------------------------------------- |
| Full AMBA              | Full alerts     | Full alerts           | Small environments where noise isn't an issue |
| **Production-focused** | **Full alerts** | **Excluded via tag**  | **Most common recommendation**                |
| Tiered monitoring      | Full AMBA       | Selected/tuned alerts | Important dev/test workloads                  |

AMBA supports changing alert thresholds and alert states through assignment parameters, and it also supports resource-specific threshold overrides for some alerts. ([Azure][3])

For example, a development SQL VM might still warrant availability monitoring but not aggressive CPU, memory, disk latency, and IOPS notifications.

### What I'd recommend as a customer standard

I would establish:

```text
Environment
-----------
Production
Development
Test
QA
Sandbox
```

Then configure AMBA approximately as:

```text
Monitor:
  Environment = Production

Exclude:
  Environment = Development
  Environment = Dev
  Environment = Test
  Environment = QA
  Environment = Sandbox
```

And govern the tag with Azure Policy:

```text
Resource Group
Environment = Dev
       ↓
"Inherit Environment tag from RG if missing"
       ↓
Resources
Environment = Dev
       ↓
AMBA exclusion
```

This allows the customer to retain their existing **mixed production/development subscription design** without creating dozens of unnecessary development alerts.

The sentence in the AMBA documentation is therefore better interpreted as **architecture guidance rather than a hard prerequisite**. Microsoft itself provides the resource-level `MonitorDisable` capability specifically for environments where finer-grained exclusions are required. ([Azure][4])

For a brownfield customer with mixed subscriptions, I would generally choose **Environment-tag-based AMBA exclusion rather than reorganizing subscriptions solely for AMBA**.

[1]: https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/HowTo/Disabling-Policies/index.html?utm_source=chatgpt.com "Disable Policies :: Azure Monitor Baseline Alerts"
[2]: https://learn.microsoft.com/en-us/azure/governance/policy/tutorials/govern-tags?utm_source=chatgpt.com "Tutorial: Manage tag governance with Azure Policy - Azure Policy | Microsoft Learn"
[3]: https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/HowTo/deploy/Customize-Policy-Assignment/?utm_source=chatgpt.com "Customize Policy Assignment :: Azure Monitor Baseline Alerts"
[4]: https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/HowTo/deploy/Introduction-to-deploying-the-ALZ-Pattern/?utm_source=chatgpt.com "Introduction to deploying the AMBA-ALZ Pattern :: Azure Monitor Baseline Alerts"
