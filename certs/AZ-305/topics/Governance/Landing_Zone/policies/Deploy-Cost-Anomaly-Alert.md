# Deploy subscription cost anomaly alert

**Definition name**: Deploy-Cost-Anomaly-Alert
**Display name**: Deploy subscription cost anomaly alert
**Description**: Deploys an Azure Cost Management anomaly alert to each subscription under the assigned scope. The alert evaluates daily spending anomalies and sends email notifications to the configured recipients.
**Category**: Cost Management

```json
{
  "mode": "All",
  "parameters": {},
  "policyRule": {
    "if": {
      "field": "type",
      "equals": "Microsoft.Resources/subscriptions"
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "type": "Microsoft.CostManagement/scheduledActions",
        "name": "CostAnomalyAlert",
        "existenceScope": "Subscription",
        "deploymentScope": "Subscription",
        "evaluationDelay": "AfterProvisioning",
        "roleDefinitionIds": [
          "/providers/Microsoft.Authorization/roleDefinitions/434105ed-43f6-45c7-a02f-909b2ba83430"
        ],
        "deployment": {
          "location": "eastus",
          "properties": {
            "mode": "incremental",
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {},
              "variables": {},
              "resources": [
                {
                  "type": "Microsoft.CostManagement/scheduledActions",
                  "apiVersion": "2025-03-01",
                  "name": "CostAnomalyAlert",
                  "kind": "InsightAlert",
                  "properties": {
                    "displayName": "Subscription cost anomaly alert",
                    "scope": "[format('subscriptions/{0}', subscription().subscriptionId)]",
                    "status": "Enabled",
                    "viewId": "[concat(subscription().id, '/providers/Microsoft.CostManagement/views/ms:DailyAnomalyByResourceGroup')]",
                    "notificationEmail": "responsible_contact@example.com",
                    "notification": {
                      "to": [
                        "notification_recipients@example.com"
                      ],
                      "language": "en",
                      "regionalFormat": "en-us",
                      "subject": "Azure subscription cost anomaly detected",
                      "message": "Investigate the unexpected spending change."
                    },
                    "schedule": {
                      "frequency": "Daily",
                      "startDate": "2026-08-05T00:00:00Z",
                      "endDate": "2036-08-05T00:00:00Z"
                    }
                  }
                }
              ]
            }
          }
        }
      }
    }
  }
}
```
