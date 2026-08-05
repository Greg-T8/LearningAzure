# Deny resource deployment in quarantine subscriptions

**Definition name**: Deny-Resource-Deployment-Quarantine
**Display name**: Deny resource deployment in quarantine subscriptions
**Description**: Prevents resource groups and Azure resources from being created or updated in subscriptions placed in the quarantine management group.
**Category**: General

Assign at Quarantine management group level to prevent resource deployment in subscriptions placed in the quarantine management group.

```
{
  "mode": "All",
  "parameters": {
    "effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "Determines whether the policy audits, denies, or is disabled."
      },
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
      "field": "type",
      "notEquals": "Microsoft.Resources/subscriptions"
    },
    "then": {
      "effect": "[parameters('effect')]"
    }
  }
}
```
