Yes. **Azure Policy can enforce resource naming conventions**, but there is no single built-in policy that covers every resource type. Typically, you create a **custom policy** that evaluates the resource’s `name` field and uses the `deny` effect.

Example: require resource groups to start with `rg-`:

```json
{
  "properties": {
    "displayName": "Enforce resource group naming convention",
    "description": "Resource group names must start with rg-.",
    "mode": "All",
    "parameters": {
      "effect": {
        "type": "String",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "defaultValue": "Deny"
      }
    },
    "policyRule": {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Resources/subscriptions/resourceGroups"
          },
          {
            "field": "name",
            "notLike": "rg-*"
          }
        ]
      },
      "then": {
        "effect": "[parameters('effect')]"
      }
    }
  }
}
```

Azure Policy supports several string operators for evaluating names:

* `like` and `notLike` for wildcard patterns such as `rg-*`
* `match` and `notMatch` for position-based patterns
* `matchInsensitively` and `notMatchInsensitively`
* `contains`, `startsWith`, and `endsWith`

For example:

```json
{
  "field": "name",
  "notMatchInsensitively": "rg-???-????-###"
}
```

In a `match` pattern:

* `?` matches a letter.
* `#` matches a digit.
* `.` matches any single character.
* Other characters are matched literally.

Azure Policy does **not support full regular expressions**, so complex naming standards usually require several conditions using `allOf`, `anyOf`, `split()`, `substring()`, or `length()`. ([Microsoft Learn][1])

A few practical considerations:

1. **Different resource types have different naming restrictions.** Storage accounts, Key Vaults, virtual machines, private endpoints, and resource groups cannot necessarily follow exactly the same pattern. Microsoft maintains a resource-specific naming rules reference. ([Microsoft Learn][2])
2. A naming policy generally affects **new resources and rename/update operations**. It cannot rename existing resources.
3. Start with `Audit`, review compliance, and then switch to `Deny`.
4. Separate policies by resource type or resource category are usually easier to maintain than one large universal policy.
5. Some Azure-created child resources may need exclusions to avoid blocking deployments.

For an ALZ environment, I would generally use an initiative containing separate naming policies for resource groups, VNets, subnets, Key Vaults, storage accounts, Log Analytics workspaces, and other major resource types rather than applying one generic rule to everything.

[1]: https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-policy-rule?utm_source=chatgpt.com "Details of the policy definition structure policy rules - Azure Policy | Microsoft Learn"
[2]: https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules?source=recommendations&utm_source=chatgpt.com "Naming rules and restrictions for Azure resources - Azure Resource Manager | Microsoft Learn"
